# AS-IS 액션 대조표 — SSP0029

> 원천: `Doc/asisfacts/screens/SSP0029/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1915행 · 메서드 106 · 종류 DATA_OP 639 · FLAG 170 · UI_PROP 169 · GRID_INIT 152 · GRID_SET 149 · RETURN 111 · ENDPOINT 90 · POPUP 63 · MESSAGE 59 · UI_MISC 49 · VALUE_SET 42 · GRID_LOCK 40 · STATE 38 · CALL_EXT 37 · GRID_STYLE 29 · GRID_BIND 21 · COMBO_DATA 15 · VALIDATE 14 · LIST_REBIND 12 · STATE_RESET 10 · CALL_BASE 3 · VALUE_CLEAR 2 · GRID_COMBO 1 · ⚠ 의미 확인 필요 40


## SSP0029_ShipmentPlanPack.BtnChecked_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-781e8a4c | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:8116 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1666a4e5 | this.btnItemId.Click | SSP0029_ShipmentPlanPack.cs:1834 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8ec43078 | this.btnItemId.Click | SSP0029_ShipmentPlanPack.cs:1836 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-4a54d55e | this.btnItemId.Click | SSP0029_ShipmentPlanPack.cs:1837 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2d61589b | this.btnItemId.Click | SSP0029_ShipmentPlanPack.cs:1838 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fd136b35 | this.btnItemId.Click | SSP0029_ShipmentPlanPack.cs:1844 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.BtnItemID2_Click

진입점: this.btnItemID2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a8632db | this.btnItemID2.Click | SSP0029_ShipmentPlanPack.cs:7986 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-11d93249 | this.btnItemID2.Click | SSP0029_ShipmentPlanPack.cs:7988 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-0406b3c4 | this.btnItemID2.Click | SSP0029_ShipmentPlanPack.cs:7989 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5f6c7f18 | this.btnItemID2.Click | SSP0029_ShipmentPlanPack.cs:7990 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f6bd8576 | this.btnItemID2.Click | SSP0029_ShipmentPlanPack.cs:7996 | if (popItem.ItemID != "") | VALUE_SET | txtModel2.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80d19373 | this.btnMeasure.Click | SSP0029_ShipmentPlanPack.cs:1867 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-42ba0b6d | this.btnMeasure.Click | SSP0029_ShipmentPlanPack.cs:1872 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8df49eea | this.btnMeasure.Click | SSP0029_ShipmentPlanPack.cs:1873 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d03bc74 | this.btnMeasure.Click | SSP0029_ShipmentPlanPack.cs:1878 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-968298bf | this.btnMeasure.Click | SSP0029_ShipmentPlanPack.cs:1879 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e89ca85a | this.btnMeasure.Click | SSP0029_ShipmentPlanPack.cs:1882 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0029", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-25d29cf0 | this.btnMeasure.Click | SSP0029_ShipmentPlanPack.cs:1883 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9a19d15a | this.btnMeasure.Click | SSP0029_ShipmentPlanPack.cs:1884 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ad88e330 | this.btnMeasure.Click | SSP0029_ShipmentPlanPack.cs:1888 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-1cba5602 | this.btnMeasure.Click | SSP0029_ShipmentPlanPack.cs:1898 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.BtnRequestor_Click

진입점: this.btnRequestor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92558144 | this.btnRequestor.Click | SSP0029_ShipmentPlanPack.cs:1415 |  | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2b3e5fd1 | this.btnRequestor.Click | SSP0029_ShipmentPlanPack.cs:1417 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-697ea52f | this.btnRequestor.Click | SSP0029_ShipmentPlanPack.cs:1418 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-e213bd13 | this.btnRequestor.Click | SSP0029_ShipmentPlanPack.cs:1419 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d1dbd85c | this.btnRequestor.Click | SSP0029_ShipmentPlanPack.cs:1420 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-84d7148a | this.btnRequestor.Click | SSP0029_ShipmentPlanPack.cs:1421 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-3f680359 | this.btnRequestor.Click | SSP0029_ShipmentPlanPack.cs:1423 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-3f8e6ea1 | this.btnRequestor.Click | SSP0029_ShipmentPlanPack.cs:1425 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a039d74a | this.btnRequestor.Click | SSP0029_ShipmentPlanPack.cs:1431 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sRequestor | item.UserID | 화면 필드/플래그 변경 |  |  |  |
| AC-a366e259 | this.btnRequestor.Click | SSP0029_ShipmentPlanPack.cs:1435 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName | 컨트롤 값 설정 |  |  |  |
| AC-f17c7af9 | this.btnRequestor.Click | SSP0029_ShipmentPlanPack.cs:1439 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName_E | 컨트롤 값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.BtnSearch_Click

진입점: this.btnSearch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b545a0e | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8002 |  | FLAG | bDetail_Search | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2a7b7f31 | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8003 |  | FLAG | sDivision | CString.GetCheckedListValue(dtMyDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e20e2f8 | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8004 |  | FLAG | sItemID | txtModel2.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-c540075f | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8005 |  | FLAG | sFromSiteID | CString.GetCheckedListValue(dtPlantSiteByDivision, clbPlantSite.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd1c81ce | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8006 |  | FLAG | sPlanStartYyyymmdd | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-a33b081a | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8007 |  | FLAG | sPlanType | "SP" | 화면 필드/플래그 변경 |  |  |  |
| AC-14ae597e | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8008 |  | FLAG | sSeq | "1" | 화면 필드/플래그 변경 |  |  |  |
| AC-aa4a2e35 | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8009 |  | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-55ce4895 | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8014 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) | FLAG | sSrh | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-e8b94c22 | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8017 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f496facd | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8018 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-82729351 | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8034 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtRequestDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28b57fcb | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8035 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtRequestDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4b1f4b1a | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8044 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if … | FLAG | sSrh | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-1b42e60a | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8046 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f6fd270 | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8047 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHstock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-050cd893 | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8057 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | FLAG | sSrh | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-df96635a | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8058 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-88f7ce6b | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8059 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtBolckStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9e7dc9f7 | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8065 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMesStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc23e154 | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8066 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMesStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a3663b46 | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8072 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtScsStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-afaf5acd | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8073 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtScsStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-07c0e29d | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8079 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockLocationDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ffeeb7a9 | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8080 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtStockLocationDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2313afdd | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8089 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | FLAG | sSrh | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-cc3f871d | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8090 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHinPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c0595552 | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8091 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHinPlanDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b386fbea | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8097 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | FLAG | sSrh | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-ec203289 | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8098 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6140bcad | this.btnSearch.Click | SSP0029_ShipmentPlanPack.cs:8099 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentResult) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0029_ShipmentPlanPack.CalculateSum

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments != null) ▸ if (SSP0029Popup.DialogResult == DialogResult.OK) ▸ try] / FindButton [if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6226ea9f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:4831 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-6311c746 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:4835 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-54fc25b1 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:4879 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-182c9411 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:4883 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-95f867ca | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:4897 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-e508dc02 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:4901 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-3ee9bd22 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:4910 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6563e858 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:5004 | for (nCol < columCount) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-8865969f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:5008 | for (nCol < columCount) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2c7a709 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:5090 | for (nRow < rowCount) ▸ for (nCol < columCount) ▸ if (nCol == columCount - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-6eb395ff | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:5105 | for (nRow < rowCount) ▸ for (nCol < columCount) ▸ if (nCol == columCount - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-78cc7160 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:5113 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0029_ShipmentPlanPack.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2f8c9ad | cboPlanDate.SelectedIndexChanged | SSP0029_ShipmentPlanPack.cs:7469 | if (siMain.ActiveSheetIndex == 0) | VALUE_SET | drpPeriod.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-cbcdbbf7 | cboPlanDate.SelectedIndexChanged | SSP0029_ShipmentPlanPack.cs:7470 | if (siMain.ActiveSheetIndex == 0) | VALUE_SET | drpPeriod2.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-1091805b | cboPlanDate.SelectedIndexChanged | SSP0029_ShipmentPlanPack.cs:7474 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) | VALUE_SET | drpPeriod.InitValue | GetDayRange("P") | 컨트롤 값 설정 |  |  |  |
| AC-e733627f | cboPlanDate.SelectedIndexChanged | SSP0029_ShipmentPlanPack.cs:7475 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) | VALUE_SET | drpPeriod2.InitValue | GetDayRange("P") | 컨트롤 값 설정 |  |  |  |
| AC-b676abad | cboPlanDate.SelectedIndexChanged | SSP0029_ShipmentPlanPack.cs:7479 | else of (siMain.ActiveSheetIndex == 0) ▸ else of (siMain.ActiveSheetIndex == 1) | VALUE_SET | drpPeriod.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-42a4e700 | cboPlanDate.SelectedIndexChanged | SSP0029_ShipmentPlanPack.cs:7480 | else of (siMain.ActiveSheetIndex == 0) ▸ else of (siMain.ActiveSheetIndex == 1) | VALUE_SET | drpPeriod2.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.checkValidN

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f07ad5a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:8925 | for (i <= siDetail.GetMaxRowIndex()) ▸ if (intORG_FROM_YYYYMMDD > intORG_TO_YYYYMMDD) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0160f34 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:8935 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c347d178 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:8938 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.chkERPIFBlockYn

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94f529e8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6970 |  | FLAG | dtERPBlockYnIF | Data_SCP.Common(Data_SCP.Type.SSPBlockCheckIF, false, "SSP0029") | 화면 필드/플래그 변경 |  |  |  |
| AC-850004bb | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6970 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSPBlockCheckIF, false, "SSP0029") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-16269b32 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6973 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("BLOCK_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-a67d833b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6982 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("PERIOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-5a08b90d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6983 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00267", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fefe577b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6987 |  | RETURN | return resultYn; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.chkSaveYN

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-184a6877 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:9389 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK") ⇒ SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-0eedab11 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:9393 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-cd4c2754 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:9395 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0b7326b0 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:9402 | if (ds.Tables[0].Rows.Count > 0) ▸ if (Convert.ToInt32(ds.Tables[0].Rows[0]["CNT"]) > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f51f5bb0 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:9408 | if (ds.Tables[0].Rows.Count > 0) ▸ else of (Convert.ToInt32(ds.Tables[0].Rows[0]["CNT"]) > 0) ▸ if (Convert.ToInt32(ds.Tables[1].Rows[0]["CN… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a85286ef | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:9412 | if (ds.Tables[0].Rows.Count > 0) ▸ else of (Convert.ToInt32(ds.Tables[0].Rows[0]["CNT"]) > 0) ▸ else of (Convert.ToInt32(ds.Tables[1].Rows[0… | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-005d40af | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:9422 | else of (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[1].Rows.Count > 0) ▸ if (Convert.ToInt32(ds.Tables[1].Rows[0]["CNT"]) > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-fc8740fb | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:9426 | else of (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[1].Rows.Count > 0) ▸ else of (Convert.ToInt32(ds.Tables[1].Rows[0]["CNT"]) > 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-a96ec5b7 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:9431 | else of (ds.Tables[0].Rows.Count > 0) ▸ else of (ds.Tables[1].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bb45ff2 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:439 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-839de724 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:440 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0029_ShipmentPlanPack.Convert_Requestor

진입점: this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (bDetail_Search == true) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25b529a6 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3574 | if (string.IsNullOrWhiteSpace(this.txtRequestor.Text.Trim())) | RETURN | return strCVT_Requestor; |  | 처리 중단/반환 |  |  |  |
| AC-ec515283 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3594 |  | RETURN | return strCVT_Requestor; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fd7568f | this.Load | SSP0029_ShipmentPlanPack.cs:554 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0fc46d47 | this.Load | SSP0029_ShipmentPlanPack.cs:555 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-995c9662 | this.Load | SSP0029_ShipmentPlanPack.cs:559 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPacker, SpdSheet.shtPacker, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dddd7613 | this.Load | SSP0029_ShipmentPlanPack.cs:560 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 1) | 화면 필드/플래그 변경 |  |  |  |
| AC-a39e5528 | this.Load | SSP0029_ShipmentPlanPack.cs:564 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtDetail, SpdSheet.shtDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2c44ea0d | this.Load | SSP0029_ShipmentPlanPack.cs:565 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtRequestDetail, SpdSheet.shtRequestDetail, 1, 1, 60) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-174f3d6d | this.Load | SSP0029_ShipmentPlanPack.cs:567 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtWHstock, SpdSheet.shtWHstock, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-23266034 | this.Load | SSP0029_ShipmentPlanPack.cs:568 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtWHstockDetail, SpdSheet.shtWHstockDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-084c990c | this.Load | SSP0029_ShipmentPlanPack.cs:569 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtBolckStock, SpdSheet.shtBolckStock, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2f6ea8ff | this.Load | SSP0029_ShipmentPlanPack.cs:570 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtBolckStockDetail, SpdSheet.shtBolckStockDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5805ad9f | this.Load | SSP0029_ShipmentPlanPack.cs:571 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtMesStock, SpdSheet.shtMesStock, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f2a8e847 | this.Load | SSP0029_ShipmentPlanPack.cs:572 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtScsStock, SpdSheet.shtScsStock, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-be5b8253 | this.Load | SSP0029_ShipmentPlanPack.cs:573 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtStockLocationDetail, SpdSheet.shtStockLocationDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f03e1d97 | this.Load | SSP0029_ShipmentPlanPack.cs:579 | if (drPgmAuthId != null) | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtWHinPlanDetail, SpdSheet.shtWHinPlanDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1efcb38d | this.Load | SSP0029_ShipmentPlanPack.cs:582 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtShipmentResult, SpdSheet.shtShipmentResult, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c0359972 | this.Load | SSP0029_ShipmentPlanPack.cs:584 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-ff877977 | this.Load | SSP0029_ShipmentPlanPack.cs:585 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-556c167a | this.Load | SSP0029_ShipmentPlanPack.cs:591 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtRequestDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-07130abb | this.Load | SSP0029_ShipmentPlanPack.cs:592 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtRequestDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-07d2984a | this.Load | SSP0029_ShipmentPlanPack.cs:597 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtWHstock) | 화면 필드/플래그 변경 |  |  |  |
| AC-850261e6 | this.Load | SSP0029_ShipmentPlanPack.cs:598 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d155dfa0 | this.Load | SSP0029_ShipmentPlanPack.cs:601 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtWHstockDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-09022e48 | this.Load | SSP0029_ShipmentPlanPack.cs:602 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a55931c4 | this.Load | SSP0029_ShipmentPlanPack.cs:605 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtBolckStock) | 화면 필드/플래그 변경 |  |  |  |
| AC-348e0b1b | this.Load | SSP0029_ShipmentPlanPack.cs:606 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-053f6215 | this.Load | SSP0029_ShipmentPlanPack.cs:609 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtBolckStockDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-44cb1d6b | this.Load | SSP0029_ShipmentPlanPack.cs:610 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-16d1c2e2 | this.Load | SSP0029_ShipmentPlanPack.cs:613 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtMesStock) | 화면 필드/플래그 변경 |  |  |  |
| AC-ac3e1d78 | this.Load | SSP0029_ShipmentPlanPack.cs:614 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMesStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f4f1af43 | this.Load | SSP0029_ShipmentPlanPack.cs:618 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtScsStock) | 화면 필드/플래그 변경 |  |  |  |
| AC-dfb9b7e3 | this.Load | SSP0029_ShipmentPlanPack.cs:619 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtScsStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66d8ab2f | this.Load | SSP0029_ShipmentPlanPack.cs:622 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtStockLocationDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-b563736f | this.Load | SSP0029_ShipmentPlanPack.cs:623 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockLocationDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4cdc6c94 | this.Load | SSP0029_ShipmentPlanPack.cs:630 | if (drPgmAuthId != null) | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtWHinPlanDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-abda6bc0 | this.Load | SSP0029_ShipmentPlanPack.cs:631 | if (drPgmAuthId != null) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHinPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1d3af0f6 | this.Load | SSP0029_ShipmentPlanPack.cs:635 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtShipmentResult) | 화면 필드/플래그 변경 |  |  |  |
| AC-a71e63bb | this.Load | SSP0029_ShipmentPlanPack.cs:636 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dbe5d849 | this.Load | SSP0029_ShipmentPlanPack.cs:639 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f0c4391d | this.Load | SSP0029_ShipmentPlanPack.cs:640 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-142dbf1e | this.Load | SSP0029_ShipmentPlanPack.cs:645 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0029_ShipmentPlanPack.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-651c4dd0 | this.Load | SSP0029_ShipmentPlanPack.cs:425 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-e3f4bc4c | this.Load | SSP0029_ShipmentPlanPack.cs:427 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-19fedfca | this.Load | SSP0029_ShipmentPlanPack.cs:428 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-08c1178b | this.Load | SSP0029_ShipmentPlanPack.cs:429 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-2b834ba7 | this.Load | SSP0029_ShipmentPlanPack.cs:432 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42b7c502 | DeleteButton | SSP0029_ShipmentPlanPack.cs:1623 | if (fps != null) ▸ if (fps.Name == "spdDetail" && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckStock) ▸ if (siDetail.ActiveSheet.Activ… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-09ecb279 | DeleteButton | SSP0029_ShipmentPlanPack.cs:1628 | if (fps != null) ▸ if (fps.Name == "spdDetail" && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckStock) ▸ if (action == CAppSetting.Flag… | DATA_OP | siDetail.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0029_ShipmentPlanPack.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72b9b76b | Dispose | SSP0029_ShipmentPlanPack.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-726c9434 | EditButton | SSP0029_ShipmentPlanPack.cs:1642 | if (siMain.ActiveSheetIndex == 0) | FLAG | dtNewPlanDate | Data.Common(Data.Type.PlanDateShip, false, pDivisionID, "A") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-0dae6a92 | EditButton | SSP0029_ShipmentPlanPack.cs:1642 | if (siMain.ActiveSheetIndex == 0) | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID, "A") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fb35d6a2 | EditButton | SSP0029_ShipmentPlanPack.cs:1646 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) | FLAG | dtNewPlanDate | Data.Common(Data.Type.PlanDateShip, false, pDivisionID, "P") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-ee0fd8e9 | EditButton | SSP0029_ShipmentPlanPack.cs:1646 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID, "P") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-99f62712 | EditButton | SSP0029_ShipmentPlanPack.cs:1651 |  | DATA_OP | dtNewPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5e19563 | EditButton | SSP0029_ShipmentPlanPack.cs:1656 | if (oldPlanDate != newPlanDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00170", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-52d58893 | EditButton | SSP0029_ShipmentPlanPack.cs:1658 | if (oldPlanDate != newPlanDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad6442bd | EditButton | SSP0029_ShipmentPlanPack.cs:1667 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-96176b03 | EditButton | SSP0029_ShipmentPlanPack.cs:1668 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4311392b | EditButton | SSP0029_ShipmentPlanPack.cs:1703 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1d6bf590 | EditButton | SSP0029_ShipmentPlanPack.cs:1704 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72b5674d | EditButton | SSP0029_ShipmentPlanPack.cs:1727 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") | FLAG | siDetail | GetSheetInfo(spdDetail.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ccbf3a0c | EditButton | SSP0029_ShipmentPlanPack.cs:1728 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-5d64ed5d | EditButton | SSP0029_ShipmentPlanPack.cs:1749 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.A… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColumns.FCST_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cd546c46 | EditButton | SSP0029_ShipmentPlanPack.cs:1750 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.A… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.INCOTERMS), siDetail.ActiveSheet.ColumnCount - 1, true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f3ec2ea4 | EditButton | SSP0029_ShipmentPlanPack.cs:1754 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siM… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColumns.FCST_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2d3c31a1 | EditButton | SSP0029_ShipmentPlanPack.cs:1755 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siM… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.INCOTERMS), siDetail.GetColumnIndex(DefColumns.TO_SITE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1bc3c67d | EditButton | SSP0029_ShipmentPlanPack.cs:1756 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siM… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.REQUESTOR), siDetail.ActiveSheet.ColumnCount - 1, true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bbd35e5f | EditButton | SSP0029_ShipmentPlanPack.cs:1768 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (i < siD… | GRID_LOCK | siDetail.LockRange | (i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), i, siDetail.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8fe29f2d | EditButton | SSP0029_ShipmentPlanPack.cs:1772 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (i < siD… | GRID_LOCK | siDetail.LockRange | (i, 0, i, siDetail.GetMaxColumnIndex(), true, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0d5daf05 | EditButton | SSP0029_ShipmentPlanPack.cs:1792 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siD… | GRID_LOCK | siDetail.LockRange | (iRow, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siDetail.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-62d726a4 | EditButton | SSP0029_ShipmentPlanPack.cs:1796 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siD… | GRID_LOCK | siDetail.LockRange | (iRow, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siDetail.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8d014bb7 | EditButton | SSP0029_ShipmentPlanPack.cs:1797 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siD… | GRID_LOCK | siDetail.LockRange | (iRow, siDetail.GetColumnIndex(DefColumns.AVAILABLE_YN), iRow, siDetail.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f0e68080 | EditButton | SSP0029_ShipmentPlanPack.cs:1798 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siD… | GRID_LOCK | siDetail.LockRange | (iRow, siDetail.GetColumnIndex(DefColumns.JUDG_VLD_DATE), iRow, siDetail.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.EngProcessingChk

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa73226f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:7427 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK") ⇒ SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-95a4feb0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:7428 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-43974a21 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:7430 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8ec29071 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:7440 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00291", new object[] { remainMinute }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-897870fa | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:7450 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-acf3b6ac | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:7452 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea4a2955 | FindButton | SSP0029_ShipmentPlanPack.cs:1606 |  | FLAG | bDetail_Search | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_block_stock

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2169a4cb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3831 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e97b9854 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3837 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-94a9665f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3860 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c3719e04 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3865 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_BLOCK_STOCK") ⇒ SSP.SSP0029_GET_BLOCK_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-75ac29bc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3866 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8b82fa89 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3868 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c8b2a0e6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3869 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f1cf7bc0 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3870 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-ceb3e08a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3871 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e1be4cfc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3872 | try | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-8f8982cf | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3873 | try | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-b6882161 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3874 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-85ba1713 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3875 | try | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-95ab4094 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3876 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-0446c87d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3877 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-6c28c941 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3878 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-388d3ac7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3879 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-5da664a8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3880 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-53295729 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3881 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-074b976b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3883 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c0f41b56 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3892 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-bfffb0ca | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3893 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ab348aaf | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3896 | try | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e17837e0 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3897 | try | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtBolckStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e8dc7014 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3906 | try ▸ if (ds.Tables[1].Rows.Count > 0) | DATA_OP | ds.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-74275d72 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3908 | try ▸ if (ds.Tables[1].Rows.Count > 0) | DATA_OP | dsDetail.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-22982b0a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3910 | try ▸ if (ds.Tables[1].Rows.Count > 0) | GRID_BIND | siDetail.Query | (dsDetail) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4f7d233a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3911 | try ▸ if (ds.Tables[1].Rows.Count > 0) | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bb90d25a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3914 | try | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ed43e07d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3915 | try | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtBolckStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d8b1d40f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3919 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2e072991 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3929 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-159a49cd | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0029_ShipmentPlanPack.cs:3934 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_BolckStockDetail_btnSearch

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstockDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckStockDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34232822 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:3941 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a94eceee | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:3947 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fc3924b8 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:3983 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b9fe0275 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:3988 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_BLOCK_STOCK") ⇒ SSP.SSP0029_GET_BLOCK_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-a6d036bb | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:3989 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fc330830 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:3991 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8cdb8dd9 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:3992 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1a98b741 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:3993 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-a10354e2 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:3994 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-19bba9b4 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:3995 | try | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-3cf91ca6 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:3996 | try | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-de1a3391 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:3997 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-1ed06438 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:3998 | try | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-8ea81c48 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:3999 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c05d39ca | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4000 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-48337dd3 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4001 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-e215a82a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4002 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-ac509c42 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4003 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-c3ec8e13 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4004 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-baec16d2 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4006 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9c85c374 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4015 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-24e5a049 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4016 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-42e61c9a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4018 | try | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b06d9cec | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4019 | try | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtBolckStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-349840e9 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4028 | try ▸ if (ds.Tables[1].Rows.Count > 0) | DATA_OP | ds.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9c43d128 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4030 | try ▸ if (ds.Tables[1].Rows.Count > 0) | DATA_OP | dsDetail.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-f71dd845 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4032 | try ▸ if (ds.Tables[1].Rows.Count > 0) | GRID_BIND | siDetail.Query | (dsDetail) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f3083489 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4033 | try ▸ if (ds.Tables[1].Rows.Count > 0) | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-48e5ea2b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4037 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b4e0085c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4047 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-3d34cd59 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4053 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_Detail

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM")] / SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (bDetail_Search == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ea53ec4 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2892 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-444f6453 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2902 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b116a1a3 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2925 | try | DATA_OP | dtNewPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-28c813db | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2954 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8fe0070e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2959 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL") ⇒ SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-41c9d58f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2960 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-91872834 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2962 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-00ae1f71 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2963 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-6a146e53 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2964 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-e284284b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2965 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-2ab964b0 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2966 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-854085b8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2967 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7bf6a343 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2968 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-c944e976 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2969 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e08083b3 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2970 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-e8f224eb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2971 | try | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-ddb06854 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2972 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-736fa72d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2973 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-c269b23c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2974 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-deb27cbd | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2975 | try | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-364e2470 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2976 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-69f83713 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2977 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-17273444 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2978 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-6f783fac | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2980 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fb85bf21 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2989 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-68013fde | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2990 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-89e3a241 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2995 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1ae1cf24 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2997 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-a09bc988 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:2997 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fa1ff442 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3000 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-94354713 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3012 | try | GRID_SET | sv.Columns[62].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a0d9c62a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3013 | try | GRID_SET | sv.Columns[63].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e9002aca | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3014 | try | GRID_SET | sv.Columns[64].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-68961002 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3015 | try | GRID_SET | sv.Columns[65].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-666f66e4 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3017 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-276e3711 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3022 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9c30ffcf | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3030 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0e28d8a8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3040 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-dd4d7c96 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3063 | try | DATA_OP | dtNewPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-1eed655b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3092 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c579cbfb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3097 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL") ⇒ SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-70e21041 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3098 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-14b1064a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3100 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-99250f40 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3101 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f7b7a495 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3102 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-586c3d56 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3103 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-c527027c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3104 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-846205e2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3105 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a0e34af2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3106 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-afc89281 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3107 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-8afcff48 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3108 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-1f50cdfb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3109 | try | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-79e71c1e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3110 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-d4e615e3 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3111 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-ef7b5a5a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3112 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-aa026f5d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3113 | try | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-8471e8db | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3114 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-2ccff7cc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3115 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-017179b2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3116 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-f341c0e9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3118 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-72ea193e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3127 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-549e4b98 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3128 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6fc7e5ac | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3133 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-c670189c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3135 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-1370d717 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3135 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7eec6d85 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3138 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a947f35a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3150 | try | GRID_SET | sv.Columns[62].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-081d8b02 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3151 | try | GRID_SET | sv.Columns[63].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c4e83d16 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3152 | try | GRID_SET | sv.Columns[64].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-948e84bc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3153 | try | GRID_SET | sv.Columns[65].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-39562f6e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3155 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-c1f89338 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3160 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_Detail_btnSearch

진입점: this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (bDetail_Search == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76901e53 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3429 |  | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod2) | 프레임워크 검증 |  |  |  |
| AC-4a7a3864 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3429 | if (!DateUtil.Check_PeriodDate(drpPeriod2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b58fc18 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3431 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ff737c53 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3437 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ed886a25 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3459 | try | DATA_OP | dtNewPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6c8943f | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3494 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-6bdde506 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3499 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL") ⇒ SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-b97bde9b | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3500 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fc1f9f79 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3502 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-aae10b68 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3503 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d510b6a9 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3504 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-71ddbf6c | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3505 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-ec19a8dc | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3506 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e4b49d12 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3507 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-91b023a0 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3508 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-4686f548 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3509 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c599039b | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3510 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-4515055f | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3511 | try | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-ccf6aba5 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3512 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-35165dd9 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3513 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-069f985a | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3514 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-cbb3158b | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3515 | try | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-744d7064 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3516 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-a1d3f25c | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3517 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-9ce2b33c | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3518 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-c866965d | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3520 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e8bad4b3 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3529 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-479c4cfa | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3530 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e33817b1 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3535 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-a170cdcf | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3537 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-8af4d1a6 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3537 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1268c6ce | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3540 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-36c95928 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3552 | try | GRID_SET | sv.Columns[62].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a1025c0b | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3553 | try | GRID_SET | sv.Columns[63].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b35331b5 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3554 | try | GRID_SET | sv.Columns[64].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9eaf8457 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3555 | try | GRID_SET | sv.Columns[65].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b0ad165e | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3557 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-50eec909 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3562 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_Detail_Packer_btnSearch

진입점: this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1)] / SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bdb7e4f | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3166 |  | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod2) | 프레임워크 검증 |  |  |  |
| AC-bfa6b345 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3166 | if (!DateUtil.Check_PeriodDate(drpPeriod2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac24652c | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3167 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-26e5b449 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3177 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-82cd3d3b | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3195 | try | DATA_OP | dtNewPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-51c4e4d0 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3229 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-9485dfd3 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3233 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL_PACKER") ⇒ SSP.SSP0029_GET_SHIPMENT_CONFIRM_DETAIL_PACKER | 엔드포인트 요청 생성 |  |  |  |
| AC-13c6147b | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3234 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f389238f | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3236 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-48436379 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3237 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e18b7949 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3238 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-7336b1ef | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3239 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-c95f4005 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3240 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-48470ebd | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3241 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cd6da80e | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3242 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-2eb07230 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3243 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-75a500df | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3244 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-c877227d | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3245 | try | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-6bd1230c | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3246 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-b65577d0 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3247 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-e0eb612f | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3248 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-5287283d | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3249 | try | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-3590d1cd | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3250 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-855f443d | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3251 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e808929d | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3252 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-ef61bcf4 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3254 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fd48d921 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3263 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1ffa4be2 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3264 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0b9be8f2 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3269 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-5d70e6d2 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3271 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c22298ed | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3271 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-95da6bc3 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3274 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bbb783c7 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3285 | try | GRID_SET | sv.Columns[15].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-18dc9bcf | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3286 | try | GRID_SET | sv.Columns[60].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8a8e166e | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3287 | try | GRID_SET | sv.Columns[61].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cbf6e648 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0029_ShipmentPlanPack.cs:3298 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_Main

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments != null) ▸ if (SSP0029Popup.DialogResult == DialogResult.OK)] / FindButton [if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a47bf41 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2305 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ba48ea51 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2310 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-06fb316a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2310 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-043df037 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2313 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-41f36717 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2314 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-4e85dc8a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2314 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dda6793b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2361 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-456ef20e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2362 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7328dc5e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2366 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_SHIPMENT_PSI") ⇒ SSP.SSP0029_GET_SHIPMENT_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-6407c623 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2368 | try ▸ lambda | UI_PROP | req.CommandTimeout | 2 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-143280d8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2370 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f4f041b5 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2371 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-95f2a222 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2372 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0c5579f4 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2373 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e9c7d496 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2374 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-6cbeb9c5 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2375 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-36fbd9fc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2376 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-508e7eef | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2377 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-f9fcc5a6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2378 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-e3ee4fc8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2379 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-900f174d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2380 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-2a97b0ad | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2381 | try ▸ lambda | DATA_OP | req.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-3b4f3335 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2382 | try ▸ lambda | DATA_OP | req.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-89d5bee1 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2383 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-4d3cf731 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2384 | try ▸ lambda | DATA_OP | req.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-389419ac | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2385 | try ▸ lambda | DATA_OP | req.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-fcdbfa71 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2386 | try ▸ lambda | DATA_OP | req.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-c97143ac | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2387 | try ▸ lambda | DATA_OP | req.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-f06463d6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2389 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b3296ee9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2390 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-405857b7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2398 | try | FLAG | dtPlanNonZero | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-59106cbd | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2399 | try | FLAG | dtBalanceMinus | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-ed721229 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2401 | try | FLAG | dtPlanNonZero | dsBinding.Tables[0].Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-73c17dd6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2401 | try | DATA_OP | dsBinding.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e828b6c1 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2402 | try | FLAG | dtBalanceMinus | dsBinding.Tables[0].Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-52ef26ad | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2402 | try | DATA_OP | dsBinding.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-528ac6d1 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2404 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-45b2c8bb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2407 | try | FLAG | dtNote | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-953ca0d2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2408 | try | FLAG | dtNote | dsBinding.Tables[1].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-bd36872d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2408 | try | DATA_OP | dsBinding.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0b0456a8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2409 | try | FLAG | intNoteCnt | dtNote.Rows.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-7548a270 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2413 | try | FLAG | dtPROD_Note | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-6d81ffa4 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2414 | try | FLAG | dtPROD_Note | dsBinding.Tables[2].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-59c6a920 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2414 | try | DATA_OP | dsBinding.Tables[2].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-32626a4d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2415 | try | FLAG | intProdNoteCNT | dtPROD_Note.Rows.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-948acf90 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2419 | try | GRID_SET | spdMain.ActiveSheet.AllowNoteEdit | false | 그리드 속성/값 설정 |  |  |  |
| AC-63096046 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2420 | try | UI_PROP | spdMain.CellNoteIndicatorRenderer | new FarPoint.Win.Spread.TriangleNoteIndicatorRenderer() | 속성 CellNoteIndicatorRenderer 설정 |  |  |  |
| AC-699aa457 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2423 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6b0a88a7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2424 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5ed8d2b8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2482 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | DATA_OP | dsBinding.Tables[0].DefaultView.ToTable | (true, "MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6677cf5f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2496 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < rowCount) ▸ if (!string.IsNullOrWhiteSpace(strLTupdateYN) && drPgmAuthId != null… | GRID_SET | spdMain.ActiveSheet.Cells[idx, siMain.GetColumnIndex(DefColumns.LT_DAY)].Note | strLTupdateYN | 그리드 속성/값 설정 |  |  |  |
| AC-6110a9d4 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2500 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < rowCount) ▸ if (!string.IsNullOrWhiteSpace(strLTupdateYN) && drPgmAuthId != null… | GRID_SET | spdMain.ActiveSheet.Cells[idx, siMain.GetColumnIndex(DefColumns.LT_DAY)].NoteIndicatorSize | new Size(0, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-415e28ef | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2503 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < rowCount) ▸ if (!string.IsNullOrWhiteSpace(strLTupdateYN) && drPgmAuthId != null… | GRID_SET | spdMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.LT_DAY)].NoteIndicatorSiz… | new Size(5, 5) | 그리드 속성/값 설정 |  |  |  |
| AC-6f105641 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2558 | try ▸ for (iRow < rowCount) ▸ if (sMeasure == "PROD_DATE" \|\| sMeasure == "LOT" \|\| sMeasure == "WH_IN" \|\| sMeasure == "PROD_PLAN") ▸ fo… | GRID_INIT | siMain.SetCellTypeDateToText | (iRow, nCol) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b34b20df | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2562 | try ▸ for (iRow < rowCount) ▸ if (sMeasure == "PROD_DATE" \|\| sMeasure == "LOT" \|\| sMeasure == "WH_IN" \|\| sMeasure == "PROD_PLAN") ▸ fo… | GRID_INIT | siMain.SetCellTypeText | (iRow, nCol) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-36b376e6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2563 | try ▸ for (iRow < rowCount) ▸ if (sMeasure == "PROD_DATE" \|\| sMeasure == "LOT" \|\| sMeasure == "WH_IN" \|\| sMeasure == "PROD_PLAN") ▸ fo… | GRID_SET | siMain.ActiveSheet.Cells[iRow, nCol].HorizontalAlignment | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-8099a211 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2566 | try ▸ for (iRow < rowCount) ▸ if (sMeasure == "PROD_DATE" \|\| sMeasure == "LOT" \|\| sMeasure == "WH_IN" \|\| sMeasure == "PROD_PLAN") ▸ fo… | GRID_SET | siMain.SetValue | (iRow, nCol, "") | 그리드 값 설정 |  |  |  |
| AC-c7ecd812 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2592 | try | UI_PROP | spdMain.AutoClipboard | true | 속성 AutoClipboard 설정 |  |  |  |
| AC-cc4186b0 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2615 | try | FLAG | intRNoteIdx | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-25597d32 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2616 | try | FLAG | intCNoteIdx | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-9f0674fb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2623 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_Main_Packer

진입점: FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (cboPlanDate.SelectedIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9d01e8f | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2186 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-525c00df | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2191 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-7a67b046 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2191 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b276abb | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2194 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8b1711f0 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2195 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-bb84793e | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2195 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7812e094 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2237 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-97ca4a77 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2238 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b45c9c31 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2242 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_SHIPMENT_PSI_PACKER") ⇒ SSP.SSP0029_GET_SHIPMENT_PSI_PACKER | 엔드포인트 요청 생성 |  |  |  |
| AC-71fea96a | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2244 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a3c2e9a9 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2246 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c9f7db5d | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2247 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-3e75dcfa | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2248 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ce432f74 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2249 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b39e43c5 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2250 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-8b2d487f | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2251 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8a399612 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2252 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3951f502 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2253 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a94ef6a4 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2254 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-f1c37a23 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2255 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-587a07e7 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2256 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-fe6f7aa0 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2257 | try ▸ lambda | DATA_OP | req.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-57445737 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2258 | try ▸ lambda | DATA_OP | req.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-a3247092 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2259 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-e14e60b4 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2260 | try ▸ lambda | DATA_OP | req.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-ed5febb3 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2261 | try ▸ lambda | DATA_OP | req.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-43f34b56 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2262 | try ▸ lambda | DATA_OP | req.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-4f97162e | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2263 | try ▸ lambda | DATA_OP | req.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-31b066a9 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2265 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a024e708 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2266 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4ecdcefc | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2273 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6ab757b8 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2275 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-623948bd | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2276 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a225f10f | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2286 | try | UI_PROP | spdMain.AutoClipboard | true | 속성 AutoClipboard 설정 |  |  |  |
| AC-f35cebd9 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2293 | try | FLAG | intRNoteIdx | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-688b1b92 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2294 | try | FLAG | intCNoteIdx | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-91ba83d3 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2300 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_Main_Packer_Past

진입점: FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ else of (cboPlanDate.SelectedIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fe705be | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2067 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0cb90df5 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2072 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-c48f01d5 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2072 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf629db9 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2075 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e8dc56bc | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2076 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-7fe5e5f4 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2076 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7f99a69a | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2118 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-3c2c5d3b | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2119 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e2e546c8 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2123 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_SHIPMENT_PSI_PACKER_PAST") ⇒ SSP.SSP0029_GET_SHIPMENT_PSI_PACKER_PAST | 엔드포인트 요청 생성 |  |  |  |
| AC-ed3c0f82 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2125 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b1d94514 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2127 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-cf30ee74 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2128 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-cd613c0c | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2129 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-781aa30a | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2130 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5f17185e | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2131 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-8f8a56c0 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2132 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-652d4886 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2133 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-bdec8178 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2134 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-5dac594a | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2135 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa45a0b1 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2136 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-97f92fbd | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2137 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-5d6b5403 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2138 | try ▸ lambda | DATA_OP | req.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-e745b5c4 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2139 | try ▸ lambda | DATA_OP | req.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-30751485 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2140 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-a820ab4b | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2141 | try ▸ lambda | DATA_OP | req.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-2ae0c41a | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2142 | try ▸ lambda | DATA_OP | req.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-4b5b1450 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2143 | try ▸ lambda | DATA_OP | req.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-e8d3a194 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2144 | try ▸ lambda | DATA_OP | req.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-1cdb0ce1 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2146 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e64d834a | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2147 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b6c7d9f3 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2154 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-28f0ea63 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2156 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-258bb04b | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2157 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7480bfbe | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2167 | try | UI_PROP | spdMain.AutoClipboard | true | 속성 AutoClipboard 설정 |  |  |  |
| AC-a7c4b2a1 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2174 | try | FLAG | intRNoteIdx | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-b1ec3281 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2175 | try | FLAG | intCNoteIdx | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-c9290e12 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0029_ShipmentPlanPack.cs:2181 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_mes_stock

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK")] / SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (bDetail_Search == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93813075 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3710 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-60091250 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3716 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4fdfcebd | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3746 | try | VALUE_SET | txtModel2.Text | siMain.GetValue(nRowIdx, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8b92b583 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3756 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b5388872 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3761 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_MES_STOCK") ⇒ SSP.SSP0029_GET_MES_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-26cb11a6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3762 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0d15ecf4 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3764 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-68281809 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3765 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2fa14e01 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3766 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-d5ef10bf | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3767 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-cf095973 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3768 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-f6436003 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3769 | try | DATA_OP | request.Parameters["p_lot_id"] | p_lot_id | 행/컬럼 값 대입 |  |  |  |
| AC-e6ede670 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3770 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-e8e9351f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3771 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-c15083a9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3772 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-1ed32c0f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3773 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-49073f9e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3774 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-359ca6cb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3775 | try | DATA_OP | request.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-e8082d0d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3777 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ab710276 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3785 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-80ec5a85 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3786 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-229850bf | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3791 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ec44e61b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3793 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-5ba02781 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3793 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0d74b7e4 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3798 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1bfad659 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3805 | try ▸ for (iRow < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.GetValue(iRow, siDetail.GetColumnIndex(DefColumns.USER_MOD_RELEASE_DATE)).To… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.USER_MOD_RELEASE_DATE)… | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-e72472c9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3820 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-5407ffb6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3825 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_MesStock_btnSearch

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckStockDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtMesStock)] / SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.Sheet…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33a8fe98 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4276 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-fce3dac7 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4282 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c5a37f87 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4317 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-04a11498 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4322 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_MES_STOCK") ⇒ SSP.SSP0029_GET_MES_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-56b7a8bd | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4323 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3894b375 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4325 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1029297f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4326 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-65de0e29 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4327 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-02a4ea2f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4328 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-173e95ca | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4329 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-29c54239 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4330 | try | DATA_OP | request.Parameters["p_lot_id"] | p_lot_id | 행/컬럼 값 대입 |  |  |  |
| AC-de82c31c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4331 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-b72ee049 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4332 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-04ec99e6 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4333 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-6dd70b55 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4334 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-4100e5b9 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4335 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-1dec4001 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4336 | try | DATA_OP | request.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-da5432ef | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4338 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7d395441 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4347 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4f585e99 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4348 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fc91ed46 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4353 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-b9c10995 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4355 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-2791f975 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4355 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2b20ed85 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4358 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2906cfbf | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4365 | try ▸ for (iRow < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.GetValue(iRow, siDetail.GetColumnIndex(DefColumns.USER_MOD_RELEASE_DATE)).To… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.USER_MOD_RELEASE_DATE)… | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-1b36c45f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4378 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-01dde4cf | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0029_ShipmentPlanPack.cs:4384 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_Request_Detail

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48b595e2 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4389 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-27fe6e73 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4397 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-646aa91b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4397 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eee8bc2f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4401 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e507177a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4403 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod2) | 프레임워크 검증 |  |  |  |
| AC-71562a9b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4403 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55b2841e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4429 | try ▸ if (spdMain.ActiveSheetIndex == 1) | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-bb70b6f8 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4430 | try ▸ if (spdMain.ActiveSheetIndex == 1) | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cfc6c6ca | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4434 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_REQUEST_DETAIL_PACK") ⇒ SSP.SSP0026_GET_REQUEST_DETAIL_PACK | 엔드포인트 요청 생성 |  |  |  |
| AC-483f2a89 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4436 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8b64a5b5 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4438 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | siDetail.SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-84d04396 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4439 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-32c65150 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4440 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_team_id"] | (sTeam == "ALL") ? "" : sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-aff87568 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4441 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_customer"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a9075507 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4442 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1ff71c07 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4444 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | sPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-dc81b215 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4445 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d9dcfdf9 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4446 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-6bfd9978 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4447 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a16b3a74 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4448 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f1b509a8 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4449 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7d3b75ed | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4450 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_requestor_id"] | p_requestor_id | 행/컬럼 값 대입 |  |  |  |
| AC-f1ef545e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4451 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-67257e84 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4452 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-0ade456c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4454 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b5922b63 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4455 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-eb0b449c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4465 | try ▸ if (spdMain.ActiveSheetIndex == 1) | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8e6dd37b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4467 | try ▸ if (spdMain.ActiveSheetIndex == 1) | GRID_BIND | siDetail.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1b2cf48b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4471 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-415404ad | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4486 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_ScsStock_btnSearch

진입점: this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FIGURE) && sMeasure == "WH_STOCK")] / this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af01e30e | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4185 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5235f9bf | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4191 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-290cfc2d | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4226 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e4bcd2b5 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4231 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_SCS_STOCK") ⇒ SSP.SSP0029_GET_SCS_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-b137aa77 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4232 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5fcf4cb1 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4234 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a6ce160d | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4235 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f0ecf3bf | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4236 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-6ef02b95 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4237 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c2354ba9 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4238 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-958c5ef1 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4239 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-0e835904 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4240 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-e84ba91b | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4241 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-edbe3754 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4242 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-ee6c6187 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4243 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-925546e6 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4245 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1be5af80 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4254 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-04283e10 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4255 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-794e425f | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4259 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-70f68a6d | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4271 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_ShipmentResult_btnSearch

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckStockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtMesStock) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtScsStock) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtStockLocationDetail) ▸ else of (siDetail.Activ…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c99a8c80 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4682 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a5489364 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4693 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-886caac2 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4711 | try | DATA_OP | dtNewPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b7a31aa | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4733 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e3d1bf28 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4738 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_SHIPMENT_RESULT") ⇒ SSP.SSP0029_GET_SHIPMENT_RESULT | 엔드포인트 요청 생성 |  |  |  |
| AC-70eb3090 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4739 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-14f4af8e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4741 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc08ecda | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4742 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-ffb75cda | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4743 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-eba0d78c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4744 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5ca7c11f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4745 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ed23144e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4746 | try | DATA_OP | request.Parameters["p_type"] | p_type | 행/컬럼 값 대입 |  |  |  |
| AC-e88c5d3e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4747 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-bc949ceb | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4748 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-2de2a1d6 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4749 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-fb94251d | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4750 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-e900f678 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4751 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-d39ad735 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4752 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-556bdbb8 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4753 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-2799564f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4754 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-078a4a65 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4755 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-87b6edcd | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4757 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-848b757f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4766 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-71ebd51f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4767 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4804e447 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4772 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e463d648 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4774 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-619d431d | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4774 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7d5d7c21 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4777 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-465ed776 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4785 | try | GRID_SET | sv.Columns["SHIP_TO"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1df2284d | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4786 | try | GRID_SET | sv.Columns["SHIPTO_DESCRIPTION"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c66d88de | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4788 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-bdbdca6c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4793 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_ShipmentSCSResult_btnSearch

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckStockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtMesStock) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtScsStock) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtStockLocationDetail) ▸ else of (siDetail.Activ…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fe25107 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4567 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0ad3a055 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4573 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2c91be68 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4591 | try | DATA_OP | dtNewPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-d24a5f52 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4621 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d43e5edf | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4626 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_SHIPMENT_RESULT_PACKER") ⇒ SSP.SSP0029_GET_SHIPMENT_RESULT_PACKER | 엔드포인트 요청 생성 |  |  |  |
| AC-ae46a879 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4627 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-48199699 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4629 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c025938b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4630 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-2e0797ca | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4631 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3eb38574 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4632 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ba28c7d9 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4633 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2c046f1a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4634 | try | DATA_OP | request.Parameters["p_type"] | p_type | 행/컬럼 값 대입 |  |  |  |
| AC-7d57adda | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4635 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c3ae6254 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4636 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-de4fea63 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4637 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-00175ae4 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4638 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-c824c1ab | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4639 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-ea1a3b7c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4640 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-673b96bd | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4641 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-6fe4b8bf | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4642 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-894a6b5a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4643 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ff0c04db | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4645 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fd179c4e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4654 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5388b6ac | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4655 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f99bd36f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4660 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-7508611f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4662 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-41445dfa | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4662 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e9db12d5 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4665 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bb5f5edd | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4672 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-63268c94 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4677 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_shtStockLocationDetail_btnSearch

진입점: this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FIGURE) && sMeasure == "WH_STOCK") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FIGURE) && sMeasure == "BALANCE")] / this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.She…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03087c11 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4061 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9dbb2bcd | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4066 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-75be6d46 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4126 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-292d3cab | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4131 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_STOCK_LOCATION_DETAIL") ⇒ SSP.SSP0029_GET_STOCK_LOCATION_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-4c142e0b | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4132 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c8defac0 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4133 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5f409ea5 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4134 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-4b892cee | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4135 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-83d58fe9 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4136 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-8a106f5c | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4137 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5abf8e6e | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4138 | try | DATA_OP | request.Parameters["p_dbl_flag"] | p_dbl_flag | 행/컬럼 값 대입 |  |  |  |
| AC-43b96178 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4139 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-0ba5843a | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4140 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-8910b0b0 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4141 | try | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-ea962d45 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4142 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-21ce3206 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4143 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-66cf82a6 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4144 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-d5f44631 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4145 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-4f645f1f | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4146 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-23505ce6 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4147 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-e93a54b6 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4148 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-e796c6a7 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4150 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7f781716 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4159 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f654959e | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4160 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-659215b4 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4163 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6379a884 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0029_ShipmentPlanPack.cs:4180 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_WHinPlanDetail_btnSearch

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckStockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtMesStock) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtScsStock) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtStockLocationDetail) ▸ if (siDetail.ActiveShee…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b78d5ff | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4491 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a2b08b5c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4497 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e1bc4029 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4512 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-2a49245a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4517 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_SHIPMENT_PSI_COMMENTS") ⇒ SSP.SSP0029_GET_SHIPMENT_PSI_COMMENTS | 엔드포인트 요청 생성 |  |  |  |
| AC-737c386f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4518 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ea4d97fe | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4520 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-221cd9bc | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4521 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8d448709 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4522 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-435d99da | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4523 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-29db057e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4524 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-23e6eac4 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4525 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-bc17db13 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4527 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9e883563 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4536 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-992702ae | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4537 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fed2f49b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4542 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-0dee9d47 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4544 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-1468115b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4544 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-45e649e0 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4547 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5f10ced2 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0029_ShipmentPlanPack.cs:4562 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.FindData_WHstock

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_HOLD")] / this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstockDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9f3f3f5 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3599 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ff1d5acf | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3605 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c8b0db82 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3639 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-04c6539a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3640 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2443b7c7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3644 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_WH_STOCK") ⇒ SSP.SSP0029_GET_WH_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-4b3455e5 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3645 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5a6db564 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3646 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e83b1012 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3647 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-efcd8e8f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3648 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-180b0acb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3649 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-3d37afc1 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3650 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_seq"] | p_plan_seq | 행/컬럼 값 대입 |  |  |  |
| AC-35c79ec7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3651 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-bb2ebe40 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3652 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-35643d37 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3653 | try ▸ lambda | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-38517e2e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3654 | try ▸ lambda | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-a414f9ba | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3655 | try ▸ lambda | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-60ea5cd9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3656 | try ▸ lambda | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-f130bff4 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3657 | try ▸ lambda | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-5c9f94f7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3658 | try ▸ lambda | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-bf4cd9d9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3660 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0c61ba21 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3662 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-941a99dc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3669 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f23d41dc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3670 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5595cfd9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3672 | try | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6afb0490 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3673 | try | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHstockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-598e7df8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3682 | try ▸ if (ds.Tables[1].Rows.Count > 0) | DATA_OP | ds.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-68f6afb4 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3684 | try ▸ if (ds.Tables[1].Rows.Count > 0) | DATA_OP | dsDetail.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-d372197b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3686 | try ▸ if (ds.Tables[1].Rows.Count > 0) | GRID_BIND | siDetail.Query | (dsDetail) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b90ebe0f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3687 | try ▸ if (ds.Tables[1].Rows.Count > 0) | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2c62d482 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3690 | try | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6e95ef00 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3691 | try | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHstock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7de0348c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3694 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4b5bc637 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0029_ShipmentPlanPack.cs:3704 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3698aef | this.Load | SSP0029_ShipmentPlanPack.cs:410 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-86096cb1 | this.Load | SSP0029_ShipmentPlanPack.cs:416 |  | GRID_SET | spdMain.Sheets[1].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94f20f72 | this.Load | SSP0029_ShipmentPlanPack.cs:1995 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-b59c3b89 | this.Load | SSP0029_ShipmentPlanPack.cs:1996 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e93be614 | this.Load | SSP0029_ShipmentPlanPack.cs:1999 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.GetDayRange

진입점: this.Load / this.spdMain.ActiveSheetChanged / clbDivision.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged [if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9cb5fc7 | this.Load 외 3 | SSP0029_ShipmentPlanPack.cs:8857 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-187ff335 | this.Load 외 3 | SSP0029_ShipmentPlanPack.cs:8858 |  | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-2c27eff2 | this.Load 외 3 | SSP0029_ShipmentPlanPack.cs:8861 |  | DATA_OP | request.Parameters["p_offset_day"] | "31" | 행/컬럼 값 대입 |  |  |  |
| AC-867380d5 | this.Load 외 3 | SSP0029_ShipmentPlanPack.cs:8862 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-51f5b689 | this.Load 외 3 | SSP0029_ShipmentPlanPack.cs:8863 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8edca367 | this.Load 외 3 | SSP0029_ShipmentPlanPack.cs:8866 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4592acee | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:8760 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-b0364f73 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:8761 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7226bea1 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:8764 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.GetErpIFCheck

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!string.IsNullOrWhiteSpace(sRequestNo)) ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d37293b4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6915 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b8e4987 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6924 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0029_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-c1759eff | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6925 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-fe7766bb | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6926 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c648d8a1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6928 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f90602c6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6939 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6474b24c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6946 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-110de690 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6951 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (service.RtFlag == "C_E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-66118089 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6962 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.GetErpIFCheckNew

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9eda7384 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9290 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "P", "A") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7c602d2 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9299 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0029_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-0a264841 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9300 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-04fa93f2 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9301 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-75ee33bc | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9303 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a60a84fb | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9314 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d31cad7 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9321 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc139ea7 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9326 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (service.RtFlag == "C_E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c4b37b2 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9337 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.GetERPInterface

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce4c0da7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6306 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b11344af | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6316 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | DATA_OP | (siDetail.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7f026760 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6322 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | MESSAGE | MessageHelper.GMessageBox | ("MSG00247", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a225f180 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6323 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a149cd70 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6331 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-31ce7b78 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6332 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c618f0fa | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6359 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (this.N… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-dc88f881 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6371 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ else of (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (t… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3cd704ab | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6381 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d42dc63e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6383 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.GetErpSoNoCnt

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60ecef69 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0029_ShipmentPlanPack.cs:6824 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_ERP_SO_NO_CNT") ⇒ SSP.SSP0029_GET_ERP_SO_NO_CNT | 엔드포인트 요청 생성 |  |  |  |
| AC-4b11f881 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0029_ShipmentPlanPack.cs:6825 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-69ba7426 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0029_ShipmentPlanPack.cs:6826 | try | DATA_OP | request.Parameters["p_erp_so_no"] | sErpSoNo | 행/컬럼 값 대입 |  |  |  |
| AC-d21f3e3f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0029_ShipmentPlanPack.cs:6828 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3e220be8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0029_ShipmentPlanPack.cs:6836 | catch ((Exception ex)) | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |
| AC-ca68456e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0029_ShipmentPlanPack.cs:6838 |  | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.GetNewERPInterface

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f79a7ff5 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9006 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!GetShipmentStatusChk(p_division_id, p_status_ch… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-dc695e64 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9016 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo)) | DATA_OP | (siDetail.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-64f9e1d4 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9028 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (iErpS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00247", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cb7ed48c | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9029 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (iErpS… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e074d670 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9038 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (DateTime.TryParse(siDetail.GetText(i, siDetail.G… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-df2275e5 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9039 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (DateTime.TryParse(siDetail.GetText(i, siDetail.G… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-778bf647 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9065 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (this.NewNonSoNo(i, action) == false) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4844ff30 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9074 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a6320b8a | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9076 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.GetShipmentStatusChk

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-734abbad | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0029_ShipmentPlanPack.cs:6849 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_GET_SHIPMENT_STATUS") ⇒ SSP.SSP0029_GET_SHIPMENT_STATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-14d7bab2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0029_ShipmentPlanPack.cs:6850 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-7f430e1c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0029_ShipmentPlanPack.cs:6851 | try | DATA_OP | request.Parameters["p_confirm_id"] | sConfirmID | 행/컬럼 값 대입 |  |  |  |
| AC-272d2125 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0029_ShipmentPlanPack.cs:6853 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3671ad4b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0029_ShipmentPlanPack.cs:6868 | try ▸ if (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00248", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-92e5d3a9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0029_ShipmentPlanPack.cs:6882 | try ▸ if (ds.Tables[1].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00249", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54970c0c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0029_ShipmentPlanPack.cs:6898 | try ▸ if (ds.Tables[2].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00189", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-df7f97fb | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0029_ShipmentPlanPack.cs:6903 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6996bb8e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0029_ShipmentPlanPack.cs:6905 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.GetShipToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9842cfdf | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:8800 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.GetShipType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c371c15b | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:8794 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.GetSoldToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78c0eca2 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:8806 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.GetSpdTitle

진입점: this.Load / this.spdMain.CellDoubleClick [for (i < spdDetail.Sheets.Count)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / this.spdMain.ActiveSheetChanged / FindButton [if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString()…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5079df7 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:8815 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-dbbc5c8c | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:8820 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-e991fb4f | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:8821 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-54987e6d | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:8823 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-f072f003 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:8823 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0029_ShipmentPlanPack.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6e439ea | this.Load | SSP0029_ShipmentPlanPack.cs:446 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1cc89af6 | this.Load | SSP0029_ShipmentPlanPack.cs:449 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtWHstock) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f41fb06 | this.Load | SSP0029_ShipmentPlanPack.cs:450 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtWHstockDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ecc54d3 | this.Load | SSP0029_ShipmentPlanPack.cs:453 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3d92633 | this.Load | SSP0029_ShipmentPlanPack.cs:456 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-580a9b85 | this.Load | SSP0029_ShipmentPlanPack.cs:460 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ce86603b | this.Load | SSP0029_ShipmentPlanPack.cs:463 |  | VALUE_SET | clbDivision.ControlValues | "40" | 컨트롤 값 설정 |  |  |  |
| AC-3835c871 | this.Load | SSP0029_ShipmentPlanPack.cs:464 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-300a0ac6 | this.Load | SSP0029_ShipmentPlanPack.cs:466 |  | FLAG | dtNewPlanDate | Data.Common(Data.Type.PlanDateShip, false, "40", "A") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-2444f0d8 | this.Load | SSP0029_ShipmentPlanPack.cs:466 |  | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, "40", "A") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fe4483b6 | this.Load | SSP0029_ShipmentPlanPack.cs:470 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-a8f52be9 | this.Load | SSP0029_ShipmentPlanPack.cs:471 |  | VALUE_SET | drpPeriod2.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-d4e048ce | this.Load | SSP0029_ShipmentPlanPack.cs:472 |  | VALUE_SET | drpPeriod3.InitValue | ShipmentResult_GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-7afdd84e | this.Load | SSP0029_ShipmentPlanPack.cs:474 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-73ac9476 | this.Load | SSP0029_ShipmentPlanPack.cs:475 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8d007f1f | this.Load | SSP0029_ShipmentPlanPack.cs:477 |  | FLAG | sLanguage | UserInfoContext.Current[UserInfoProperites.Language] | 화면 필드/플래그 변경 |  |  |  |
| AC-5021bf26 | this.Load | SSP0029_ShipmentPlanPack.cs:480 |  | FLAG | sRequestor | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-02c1d615 | this.Load | SSP0029_ShipmentPlanPack.cs:482 |  | FLAG | sGroupID | UserInfoContext.Current["NowGroupID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8ae4845d | this.Load | SSP0029_ShipmentPlanPack.cs:483 |  | FLAG | drPgmAuthId | dtPgmAuthId.Select().Where(c => c["CODE"].ToString() == "SSP0029" && c["NAME"].ToString() … | 화면 필드/플래그 변경 |  |  |  |
| AC-577429c4 | this.Load | SSP0029_ShipmentPlanPack.cs:483 |  | DATA_OP | dtPgmAuthId.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2f85a1ca | this.Load | SSP0029_ShipmentPlanPack.cs:486 | if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-16a99351 | this.Load | SSP0029_ShipmentPlanPack.cs:488 |  | FLAG | dBaseDate | Convert.ToDateTime(Convert.ToDateTime(DateTime.Now).ToString()).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-4c7e6cf2 | this.Load | SSP0029_ShipmentPlanPack.cs:491 |  | VALUE_SET | chkMyModel.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-8d4d6044 | this.Load | SSP0029_ShipmentPlanPack.cs:497 | if (dtMyModelChk.Rows.Count > 0 && drPgmAuthId != null) | DATA_OP | dtMyModelChk.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6c5cdafa | this.Load | SSP0029_ShipmentPlanPack.cs:500 | if (dtMyModelChk.Rows.Count > 0 && drPgmAuthId != null) ▸ if (dr != null) | VALUE_SET | chkMyModel.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-c3b81656 | this.Load | SSP0029_ShipmentPlanPack.cs:511 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMaxShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[0]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-16946c15 | this.Load | SSP0029_ShipmentPlanPack.cs:512 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMinShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[1]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-472b6c66 | this.Load | SSP0029_ShipmentPlanPack.cs:513 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMaxDay | dtShipmentInputPeriod.Rows[0]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c043971e | this.Load | SSP0029_ShipmentPlanPack.cs:514 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMinDay | dtShipmentInputPeriod.Rows[1]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1a62534c | this.Load | SSP0029_ShipmentPlanPack.cs:526 | if (drPgmAuthId != null) | DATA_OP | contextMenu.MenuItems.Add | ("&Memo", new EventHandler(TsmNotepad_Click)) | 데이터 객체 조작/조회 |  |  |  |
| AC-eec56ab4 | this.Load | SSP0029_ShipmentPlanPack.cs:530 | else of (drPgmAuthId != null) | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-03401f33 | this.Load | SSP0029_ShipmentPlanPack.cs:531 | else of (drPgmAuthId != null) | UI_PROP | layoutControlItem12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8985e3f0 | this.Load | SSP0029_ShipmentPlanPack.cs:532 | else of (drPgmAuthId != null) | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5e586f0c | this.Load | SSP0029_ShipmentPlanPack.cs:533 | else of (drPgmAuthId != null) | UI_PROP | layoutControlItem16.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ff0d139b | this.Load | SSP0029_ShipmentPlanPack.cs:536 |  | DATA_OP | dtResultType.Rows.RemoveAt | (3) | 데이터 객체 조작/조회 |  |  |  |
| AC-40abec64 | this.Load | SSP0029_ShipmentPlanPack.cs:540 |  | LIST_REBIND | clsCtrl.setListBox | (dtResultType, clbResultType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5803e017 | this.Load | SSP0029_ShipmentPlanPack.cs:541 |  | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7eeb8017 | this.Load | SSP0029_ShipmentPlanPack.cs:542 |  | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b1f3d04d | this.Load | SSP0029_ShipmentPlanPack.cs:543 |  | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8c6e9436 | this.Load | SSP0029_ShipmentPlanPack.cs:546 |  | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2b41767d | this.Load | SSP0029_ShipmentPlanPack.cs:547 |  | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [for (i < spdDetail.Sheets.Count)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / this.spdMain.ActiveSheetChanged / FindButton [if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString()…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1798e6b | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:656 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-8072ef87 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:658 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-9c7faa0a | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:662 | if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | clsCtrl.HeaderSpan | (siMain, 0, siMain.GetColumnIndex(DefColumns.TYPE), 3, 2, "BOH") | ⚠ 의미 확인 필요 |  |  |  |
| AC-432e6e4e | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:670 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc76f2c2 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:672 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a9e8a9b3 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:675 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.TYPE].MergePolicy | MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-dd7f1648 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:677 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.PSI_NAME].MergePolicy | MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-f0dbb18a | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:683 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPacker) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtPacker) | 그리드 재구성/초기화 |  |  |  |
| AC-cfddd3f0 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:685 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPacker) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-97502a83 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:689 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPacker) | CALL_EXT | clsCtrl.HeaderSpan | (siMain, 0, siMain.GetColumnIndex(DefColumns.TYPE), 3, 2, "BOH") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc907516 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:697 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPacker) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f78fca6 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:699 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPacker) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-11ea934f | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:702 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPacker) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.TYPE].MergePolicy | MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-bed58db7 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:704 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPacker) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.PSI_NAME].MergePolicy | MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-fbab81b2 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:708 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtD… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b2fcf3a6 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:710 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtD… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-01b70ada | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:712 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtD… | LIST_REBIND | SpreadInfo.SetComBoParam | ("CHANGE_REASON_CODE_ALL", dtChangeReasonCode) | 목록 컨트롤 재구성 |  |  |  |
| AC-c3e9e3ce | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:714 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtD… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-671dcec8 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:725 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | siDetail.SetSheetHeaderColumn | (siDetail, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-78df9a3f | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:736 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-2ec220d5 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:740 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-036c8850 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:750 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-27c37ae7 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:752 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-7025d0c8 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:754 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | LIST_REBIND | SpreadInfo.SetComBoParam | ("LookupCommon3", dtStockStatus) | 목록 컨트롤 재구성 |  |  |  |
| AC-af654bb7 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:756 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c61c8d13 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:763 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-17e25bbd | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:765 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-faa14f43 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:767 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | LIST_REBIND | SpreadInfo.SetComBoParam | ("LookupCommon3", dtStockStatus) | 목록 컨트롤 재구성 |  |  |  |
| AC-b0ee8250 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:769 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0aec84a6 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:776 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8d19391c | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:778 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-0f6dae3f | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:780 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColumns.HOLD_QTY), -9999999, 0, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dd7c3405 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:782 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8c74feec | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:789 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-bb7e84df | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:791 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-1102b9bd | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:793 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColumns.HOLD_QTY), -9999999, 0, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-db311ba0 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:795 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-00fb2966 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:802 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f590791f | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:804 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-303d40dc | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:806 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColumns.LOT_QTY), -9999999, 0, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2b9f96a0 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:808 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2c06e600 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:815 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-d03aae6d | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:817 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-95558672 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:827 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-5c102e04 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:831 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-76972e7f | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:832 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-88080345 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:838 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-ba0ad96e | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:840 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-c6dc7592 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:850 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-e57e361c | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:854 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-3420eef9 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:855 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-35ebd067 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:864 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-0af93a20 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:866 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-69fb270e | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:868 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cbc37b71 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:875 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-84bfd84b | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:877 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-1afb33d5 | this.Load 외 7 | SSP0029_ShipmentPlanPack.cs:882 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0029_ShipmentPlanPack.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [for (i < spdDetail.Sheets.Count) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.ActiveSheetChanged [if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [if (siMain.ActiveSheetIndex ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bb31acf | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0029_ShipmentPlanPack.cs:1009 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a45a73e0 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0029_ShipmentPlanPack.cs:1013 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7c2a2011 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0029_ShipmentPlanPack.cs:1017 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-2dfd7493 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0029_ShipmentPlanPack.cs:1024 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-59103736 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0029_ShipmentPlanPack.cs:1025 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b82c26b4 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0029_ShipmentPlanPack.cs:1030 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17674ac9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0029_ShipmentPlanPack.cs:1031 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-32ef1bab | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0029_ShipmentPlanPack.cs:1039 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7c79c98b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0029_ShipmentPlanPack.cs:1040 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b2b8136a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0029_ShipmentPlanPack.cs:1050 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f56e4303 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0029_ShipmentPlanPack.cs:1051 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fdcd1479 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0029_ShipmentPlanPack.cs:1052 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2500da2e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0029_ShipmentPlanPack.cs:1053 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0029_ShipmentPlanPack.InitSpreadFooterSum

진입점: this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.spdMain.CellDoubleClick [for (i < spdDetail.Sheets.Count) ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == Sp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dae2825b | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0029_ShipmentPlanPack.cs:926 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2b572a0a | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0029_ShipmentPlanPack.cs:927 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-e8a126af | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0029_ShipmentPlanPack.cs:967 | for (iCol <= siDetail.GetMaxColumnIndex()) | CALL_EXT | siDetail.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d62c2879 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0029_ShipmentPlanPack.cs:968 | for (iCol <= siDetail.GetMaxColumnIndex()) | CALL_EXT | siDetail.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-42669ab8 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0029_ShipmentPlanPack.cs:969 | for (iCol <= siDetail.GetMaxColumnIndex()) | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-035145a5 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0029_ShipmentPlanPack.cs:970 | for (iCol <= siDetail.GetMaxColumnIndex()) | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.InitSpreadFooterSum_Detail

진입점: this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet.shtDetail) ▸ if (spdInfo.SheetName == SpdSheet.shtRequestDetail)] / this.spdMain.CellDoubleClick [for (i < spdDetail.Sheets.Count) ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet.shtDetail) ▸ if (spdInfo.SheetName == SpdSheet.shtRequestDetail)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ else of (sp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d27f6c8 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0029_ShipmentPlanPack.cs:8971 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-8b02c4ab | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0029_ShipmentPlanPack.cs:8972 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfb2770f | InsertButton | SSP0029_ShipmentPlanPack.cs:7218 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | DATA_OP | siDetail.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bc6e6ad1 | InsertButton | SSP0029_ShipmentPlanPack.cs:7223 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | UI_MISC | siDetail.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-41257acc | InsertButton | SSP0029_ShipmentPlanPack.cs:7228 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetValue… | 그리드 값 설정 |  |  |  |
| AC-4c2cf1e3 | InsertButton | SSP0029_ShipmentPlanPack.cs:7229 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.FROM_SITE), siMain.GetValue(s… | 그리드 값 설정 |  |  |  |
| AC-5cb4b8ef | InsertButton | SSP0029_ShipmentPlanPack.cs:7230 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.FROM_SITE_NM), siMain.GetValu… | 그리드 값 설정 |  |  |  |
| AC-7655d1e8 | InsertButton | SSP0029_ShipmentPlanPack.cs:7231 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.ITEM_ID), siMain.GetValue(siM… | 그리드 값 설정 |  |  |  |
| AC-2401d274 | InsertButton | SSP0029_ShipmentPlanPack.cs:7232 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetValue(s… | 그리드 값 설정 |  |  |  |
| AC-2effccef | InsertButton | SSP0029_ShipmentPlanPack.cs:7234 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_LOCK | siDetail.LockRange | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.Active… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ec66a4c | InsertButton | SSP0029_ShipmentPlanPack.cs:7235 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_LOCK | siDetail.LockRange | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siDetail.Ac… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5b839420 | InsertButton | SSP0029_ShipmentPlanPack.cs:7237 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.HOLD_YYYYMMDD), DateTime.Now.… | 그리드 값 설정 |  |  |  |
| AC-76d661ee | InsertButton | SSP0029_ShipmentPlanPack.cs:7237 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f7ab51f | InsertButton | SSP0029_ShipmentPlanPack.cs:7242 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-21d14f8d | InsertButton | SSP0029_ShipmentPlanPack.cs:7319 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48f5adfd | InsertButton | SSP0029_ShipmentPlanPack.cs:7321 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | siDetail.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ca451b38 | InsertButton | SSP0029_ShipmentPlanPack.cs:7324 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-6afba066 | InsertButton | SSP0029_ShipmentPlanPack.cs:7325 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ITEM_ID, ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f46b3b3 | InsertButton | SSP0029_ShipmentPlanPack.cs:7326 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NICK_NAME, NICK_NAME) | 데이터 객체 조작/조회 |  |  |  |
| AC-d61e2ab4 | InsertButton | SSP0029_ShipmentPlanPack.cs:7327 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.TO_SITE_DESCRIPTION, TO_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4cc3781 | InsertButton | SSP0029_ShipmentPlanPack.cs:7328 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.END_CUSTOMER, PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d49d10e | InsertButton | SSP0029_ShipmentPlanPack.cs:7330 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_DATE, SHIPMENT_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6054412 | InsertButton | SSP0029_ShipmentPlanPack.cs:7331 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_CONFIRM_QTY, 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-456983be | InsertButton | SSP0029_ShipmentPlanPack.cs:7332 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REMARKS2, REMARKS2) | 데이터 객체 조작/조회 |  |  |  |
| AC-4492f0ef | InsertButton | SSP0029_ShipmentPlanPack.cs:7333 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REMARKS, REMARKS) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4c2f4f1 | InsertButton | SSP0029_ShipmentPlanPack.cs:7334 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.TRANSPORT_MODE, TRANSPORT_MODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b4704e4 | InsertButton | SSP0029_ShipmentPlanPack.cs:7335 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.FROM_SITE_DESCRIPTION, FROM_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b4eb7d4 | InsertButton | SSP0029_ShipmentPlanPack.cs:7336 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REQUESTOR, REQUESTOR) | 데이터 객체 조작/조회 |  |  |  |
| AC-97e9a941 | InsertButton | SSP0029_ShipmentPlanPack.cs:7337 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REMARKS3, REMARKS3) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b475ade | InsertButton | SSP0029_ShipmentPlanPack.cs:7338 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_REASON_CODE, CHANGE_REASON_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c1c1331 | InsertButton | SSP0029_ShipmentPlanPack.cs:7339 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_REASON_DETAIL, CHANGE_REASON_DETAIL) | 데이터 객체 조작/조회 |  |  |  |
| AC-70265ebf | InsertButton | SSP0029_ShipmentPlanPack.cs:7340 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.INCOTERMS, INCOTERMS) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed323868 | InsertButton | SSP0029_ShipmentPlanPack.cs:7341 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.LT_DAY, LT_DAY) | 데이터 객체 조작/조회 |  |  |  |
| AC-bce97209 | InsertButton | SSP0029_ShipmentPlanPack.cs:7342 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ETD, ETD) | 데이터 객체 조작/조회 |  |  |  |
| AC-06d8eada | InsertButton | SSP0029_ShipmentPlanPack.cs:7343 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ETA, ETA) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e6751b9 | InsertButton | SSP0029_ShipmentPlanPack.cs:7345 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.FCST_TYPE, FCST_TYPE) | 데이터 객체 조작/조회 |  |  |  |
| AC-37c8a861 | InsertButton | SSP0029_ShipmentPlanPack.cs:7346 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.UPDATED_BY, UPDATED_BY) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c6e0b21 | InsertButton | SSP0029_ShipmentPlanPack.cs:7347 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.UPDATED_DATE, UPDATED_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-a455a29b | InsertButton | SSP0029_ShipmentPlanPack.cs:7348 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_REQ_NO, CHANGE_REQ_NO) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a3aab7b | InsertButton | SSP0029_ShipmentPlanPack.cs:7349 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CONFIRM_ID, CONFIRM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd7815cb | InsertButton | SSP0029_ShipmentPlanPack.cs:7350 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.FROM_SITE, FROM_SITE) | 데이터 객체 조작/조회 |  |  |  |
| AC-21e18fad | InsertButton | SSP0029_ShipmentPlanPack.cs:7351 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | ("TO_SITE_SOLDTO_CODE", SOLDTO_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-23e64648 | InsertButton | SSP0029_ShipmentPlanPack.cs:7352 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | ("TO_SITE_SHIPTO_CODE", SHIPTO_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-84a1d617 | InsertButton | SSP0029_ShipmentPlanPack.cs:7353 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.TO_SITE, TO_SITE) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7a61561 | InsertButton | SSP0029_ShipmentPlanPack.cs:7354 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ERP_STATUS, ERP_STATUS) | 데이터 객체 조작/조회 |  |  |  |
| AC-f31a18b2 | InsertButton | SSP0029_ShipmentPlanPack.cs:7355 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.BOD_ID, BOD_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d549b08 | InsertButton | SSP0029_ShipmentPlanPack.cs:7356 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_TYPE, CHANGE_TYPE) | 데이터 객체 조작/조회 |  |  |  |
| AC-507b58f4 | InsertButton | SSP0029_ShipmentPlanPack.cs:7357 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_ROUTE_ID, NEW_ROUTE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-35ae0705 | InsertButton | SSP0029_ShipmentPlanPack.cs:7358 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_BOD_ID, NEW_BOD_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-928a31c8 | InsertButton | SSP0029_ShipmentPlanPack.cs:7359 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_INCOTERMS, NEW_INCOTERMS) | 데이터 객체 조작/조회 |  |  |  |
| AC-1970f0e1 | InsertButton | SSP0029_ShipmentPlanPack.cs:7360 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_D_COUNTRY, NEW_D_COUNTRY) | 데이터 객체 조작/조회 |  |  |  |
| AC-45cb4859 | InsertButton | SSP0029_ShipmentPlanPack.cs:7361 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_D_PORT_CODE, NEW_D_PORT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb551f0f | InsertButton | SSP0029_ShipmentPlanPack.cs:7362 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_A_COUNTRY, NEW_A_COUNTRY) | 데이터 객체 조작/조회 |  |  |  |
| AC-d853f50d | InsertButton | SSP0029_ShipmentPlanPack.cs:7363 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_A_PORT_CODE, NEW_A_PORT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9481087 | InsertButton | SSP0029_ShipmentPlanPack.cs:7364 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_CUSTOMER_LT, NEW_CUSTOMER_LT) | 데이터 객체 조작/조회 |  |  |  |
| AC-97cd074a | InsertButton | SSP0029_ShipmentPlanPack.cs:7365 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_TO_COUNTRY, NEW_TO_COUNTRY) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fba98f2 | InsertButton | SSP0029_ShipmentPlanPack.cs:7366 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_TO_CITY, NEW_TO_CITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0e3a78f | InsertButton | SSP0029_ShipmentPlanPack.cs:7367 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_ETA, NEW_ETA) | 데이터 객체 조작/조회 |  |  |  |
| AC-f42ac20a | InsertButton | SSP0029_ShipmentPlanPack.cs:7368 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_ETD, NEW_ETD) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2e51bf3 | InsertButton | SSP0029_ShipmentPlanPack.cs:7369 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_LT_DAY, NEW_LT_DAY) | 데이터 객체 조작/조회 |  |  |  |
| AC-531bf94c | InsertButton | SSP0029_ShipmentPlanPack.cs:7370 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_TRANSPORT_MODE, NEW_TRANSPORT_MODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-579cfa64 | InsertButton | SSP0029_ShipmentPlanPack.cs:7371 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_SHIPMENT_DATE, NEW_SHIPMENT_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea4de274 | InsertButton | SSP0029_ShipmentPlanPack.cs:7372 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.EDIT_REMARKS, EDIT_REMARKS) | 데이터 객체 조작/조회 |  |  |  |
| AC-3cc5cd45 | InsertButton | SSP0029_ShipmentPlanPack.cs:7374 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | GRID_SET | siDetail.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-0990838f | InsertButton | SSP0029_ShipmentPlanPack.cs:7376 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-afb0f553 | InsertButton | SSP0029_ShipmentPlanPack.cs:7380 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.INCOTERMS), siDetail.ActiveSheet.ColumnCount … | 그리드 편집 잠금/해제 |  |  |  |
| AC-4c447ec8 | InsertButton | SSP0029_ShipmentPlanPack.cs:7385 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.INCOTERMS), siDetail.GetColumnIndex("TO_SITE_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-13337078 | InsertButton | SSP0029_ShipmentPlanPack.cs:7386 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.REQUESTOR), siDetail.ActiveSheet.ColumnCount … | 그리드 편집 잠금/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.NewNonSoNo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f5d7895 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9179 | if (siMain.ActiveSheetIndex == 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-6aac2a7f | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9183 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER") ⇒ SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | 엔드포인트 요청 생성 |  |  |  |
| AC-212c6905 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9189 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-55c0b391 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9190 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-13b72035 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9191 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-06a378d1 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9192 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-53bc0286 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9193 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-bed75d10 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9194 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-446487ed | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9195 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-fd78b4f0 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9196 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-088a9341 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9197 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-01d736dc | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9198 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-dbf8e6a8 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9199 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-74cd2ee4 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9200 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-0830bb6d | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9201 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-bca7e864 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9202 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-ebbf70af | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9203 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-c9c04628 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9204 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-d6a28088 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9205 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-bc997e12 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9206 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-32e7ae17 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9207 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-12bd6821 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9208 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-0ef02872 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9209 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-b26257da | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9210 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-89fc07bc | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9211 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-a15724eb | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9212 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-1104c1f5 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9213 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-dcd5f03e | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9214 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-636ac3da | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9215 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1954f970 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9217 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-4c15026d | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9218 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-961a95b9 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9219 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-e976a358 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9221 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-bbcf3f4c | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9222 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-517f36c2 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9223 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-ff0396cf | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9224 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-70fe8ba8 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9225 |  | DATA_OP | request.Parameters["p_shipto_code"] | p_shipto_code | 행/컬럼 값 대입 |  |  |  |
| AC-93cf1b03 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9228 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-540b431a | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9253 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9c6291c0 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9255 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ if (MessageHelper.GMessageBox("MSG003… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd9111a1 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9276 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25830104 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:9280 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.NonSoNo

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-360e9734 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6486 | if (siMain.ActiveSheetIndex == 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-3f841cc7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6490 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER") ⇒ SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | 엔드포인트 요청 생성 |  |  |  |
| AC-b8543803 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6496 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-fb70d8af | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6497 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1e275204 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6498 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-e9014ecb | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6499 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-0b5028de | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6500 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-54cfa39d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6501 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-e5982c33 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6502 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-975e4cf5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6503 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-15779c65 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6504 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-272ddc67 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6505 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-ff42e1de | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6506 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-911442fd | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6507 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-5e1cb591 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6508 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-2fcea627 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6509 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-4e1de1a8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6510 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-ca8e1ca2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6511 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-51570e27 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6512 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-dd0f29ff | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6513 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-2f22003a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6514 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-54de073d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6515 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-207e960f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6516 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-efe5def5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6517 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-d201459d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6518 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-c45416d0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6519 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-52164e15 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6520 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-c5f8376d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6521 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-87d910a1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6522 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0b0a497e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6524 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-0cce77ea | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6525 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-f367528e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6526 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-75fb5b87 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6528 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-15efbe61 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6529 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-47060cb5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6530 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-31f6e0ab | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6531 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-e79a2070 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6532 |  | DATA_OP | request.Parameters["p_shipto_code"] | p_shipto_code | 행/컬럼 값 대입 |  |  |  |
| AC-24fb3f30 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6534 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-575b2d4f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6574 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-626dd7f1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6578 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.Re_Design

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments != null) ▸ if (SSP0029Popup.DialogResult == DialogResult.OK) ▸ finally] / FindButton [if (siMain.ActiveSheetIndex == 0) ▸ finally] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ finally] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ff9dc15 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2672 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < rowCount) ▸ if (strItemId != strTmp_ItemID) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.ITEM_ID), i, columnCount - 1]… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-c14d8eac | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2679 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < rowCount) ▸ if (siMain.ActiveSheetIndex == 1) | CALL_EXT | Convert.ToInt16 | (siMain.GetValue(i, siMain.GetColumnIndex("SHIP_FROZEN"))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-61fd4db2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2691 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < rowCount) ▸ if (startIdx < (intEndIdx - 2)) | GRID_STYLE | siMain.SetBGColor2 | (i, startIdx, i, intEndIdx, Color.FromArgb(Convert.ToInt32(242), Convert.ToInt32(242), Con… | 그리드 표시 설정 |  |  |  |
| AC-ad32e90f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2706 | if (siMain.ActiveSheet.RowCount > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0029_ShipmentPlanPack.SaveData_Detail

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab7eb63d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5502 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (!EngProcessingCh… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52932b3d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5504 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-98d672f7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5507 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (!DataUtil.checkR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff3264c4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5514 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (chkERPIFBlockYn(… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ecfd0b5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5518 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1778c1f5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5526 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad4c30f8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5532 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-79ce6b22 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5534 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-17d86bb7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5538 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f49b46b2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5543 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5165577 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5614 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_SAVE_SHIPMENT_REQUEST_CONFIRM_40") ⇒ SSP.SSP0029_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | 엔드포인트 요청 생성 |  |  |  |
| AC-e732e2a3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5618 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-3fa8920d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5619 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-507570e3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5620 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-c853cc43 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5621 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-4f49639a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5622 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-d5ed5fea | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5623 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-f6a79476 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5624 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-48754fba | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5625 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-63501dfd | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5626 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-bc9d9aa9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5627 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-559ecae4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5628 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-74dd0f54 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5629 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-dc0abd5b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5630 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-8cac47d4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5631 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-733b3a1d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5632 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-f5570c9b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5633 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-b4542429 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5634 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-2b28f986 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5635 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-e1c36ad9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5636 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-14c2e15b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5637 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-9d4f7cf1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5638 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-0babf240 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5639 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a0d04208 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5640 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_check_need_yn"] | p_check_need_yn | 행/컬럼 값 대입 |  |  |  |
| AC-c5ea3e68 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5641 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-02034d94 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5643 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9fa9bbe9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5649 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-40ae2238 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5650 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4b52d4d0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5678 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-37b92910 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5680 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-97590627 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5688 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fc23867f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5700 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4623482c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5713 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0b0c5d59 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5736 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-b881ce65 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5736 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (!DataUtil.ch… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-41d036f6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5738 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (!checkValidN… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b0eec101 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5780 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_SAVE_BLOCK_STOCK_DATA") ⇒ SSP.SSP0029_SAVE_BLOCK_STOCK_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-60648fb0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5785 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-92418bb0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5789 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-69e3856b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5790 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-79666f53 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5791 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_hold_id"] | p_hold_id | 행/컬럼 값 대입 |  |  |  |
| AC-fa377c9a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5792 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-e871032b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5793 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3ca5541e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5794 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_hold_yyyymmdd"] | p_hold_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5619aa69 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5795 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_release_yyyymmdd"] | p_release_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-eabd3076 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5796 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_hold_qty"] | p_hold_qty | 행/컬럼 값 대입 |  |  |  |
| AC-fc9baa78 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5797 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-e80a24e4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5798 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e3fbd802 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5800 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5f7727e0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5801 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-4b86c609 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5802 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-be0e1793 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5804 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dc598e72 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5804 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-b5ac5c53 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5813 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ea0df563 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5828 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ef24f57 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5881 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_SAVE_MES_STOCK") ⇒ SSP.SSP0029_SAVE_MES_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-55cd8d1b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5886 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4a7633b1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5890 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1711e6e8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5892 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-56278cce | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5893 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-fe61db95 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5894 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3bff78b4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5895 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-0436a27b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5896 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-c2d87a71 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5897 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-f27b42c5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5898 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-54766477 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5899 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_lot_id"] | p_lot_id | 행/컬럼 값 대입 |  |  |  |
| AC-95e1e93e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5900 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_user_mod_release_date"] | p_user_mod_release_date | 행/컬럼 값 대입 |  |  |  |
| AC-f01feff1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5901 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-d8fdcbca | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5902 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-eb3de62d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5904 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-832b92e2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5904 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-d02a288c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5913 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d0c24b69 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5935 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-820f85a0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5988 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_SAVE_MES_STOCK") ⇒ SSP.SSP0029_SAVE_MES_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-ba1f543a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5993 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-77dde68e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5997 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-83ace075 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:5999 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f5e8e5ee | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6000 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b4a9e032 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6001 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-bf642100 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6002 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-f23675a5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6003 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-5003bc2f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6004 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-c4161538 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6005 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-95054957 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6006 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_lot_id"] | p_lot_id | 행/컬럼 값 대입 |  |  |  |
| AC-6079bfcf | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6007 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_user_mod_release_date"] | p_user_mod_release_date | 행/컬럼 값 대입 |  |  |  |
| AC-14162cb1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6008 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-139320a1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6009 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a238fdd9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6011 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-df602eda | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6011 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-8aacc137 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6020 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-646bcaa6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6042 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0029_ShipmentPlanPack.SaveData_Detail_Packer

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82876a76 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5275 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (chkSaveYN() == f… | MESSAGE | MessageHelper.GMessageBox | ("MSG00363") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cab7c091 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5276 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (chkSaveYN() == f… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d94002a | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5280 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (!EngProcessingCh… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-caf8e540 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5282 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-6bf82cc5 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5285 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (!DataUtil.checkR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7839525 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5292 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (chkERPIFBlockYn(… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e3632375 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5296 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0a05a1b6 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5304 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6881894f | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5310 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-67901ef9 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5312 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f9aa26fb | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5316 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9ed390b2 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5321 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13468f1d | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5396 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER") ⇒ SSP.SSP0029_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER | 엔드포인트 요청 생성 |  |  |  |
| AC-b1a66393 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5400 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-4ed1bfac | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5401 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d504a441 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5402 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-467fa52b | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5403 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-0f0143a2 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5404 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-254fb8b7 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5405 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-9b8b4fca | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5406 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-1d444d9e | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5407 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-1e4011d7 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5408 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-fed1086d | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5409 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-6f803aec | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5410 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-49e1921e | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5411 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-b21d2e03 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5412 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-aa2692ca | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5413 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-3fda02a7 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5414 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-1e3b67f5 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5415 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-777b2119 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5416 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-42452e55 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5417 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-7fb5d472 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5418 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-c6f50169 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5419 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-0cf7cbf2 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5420 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-45f30417 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5421 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-8d1aeca2 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5422 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_check_need_yn"] | p_check_need_yn | 행/컬럼 값 대입 |  |  |  |
| AC-d8e9229e | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5423 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-d406ce20 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5424 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_shipto_code"] | p_shipto_code | 행/컬럼 값 대입 |  |  |  |
| AC-be1d154d | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5426 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e18acc2b | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5432 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5e0e32de | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5433 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5730f14d | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5451 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-798b89dd | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5453 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d82f4e88 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5461 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4f597c27 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5473 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2d1f80f5 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0029_ShipmentPlanPack.cs:5485 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.SaveData_Main

진입점: SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19d8c38a | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5125 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0004ae1a | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5171 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-48db9ca1 | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5172 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ca977a2 | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5173 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c0e75bed | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5206 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_SAVE_SHIPMENT_PSI") ⇒ SSP.SSP0029_SAVE_SHIPMENT_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-6da849c3 | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5208 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ef511f05 | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5209 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-303c558e | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5210 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-a94cf9aa | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5211 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-19fe5be5 | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5212 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-33ad83a2 | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5213 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3f096f22 | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5214 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-367e6c22 | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5215 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-3f694ed9 | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5216 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | p_measure | 행/컬럼 값 대입 |  |  |  |
| AC-e53c9ff4 | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5217 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-6aa804f2 | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5218 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-0793519a | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5219 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-0fb590d9 | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5221 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-719b1739 | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5226 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bdbddcd9 | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5243 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-56633351 | SaveButton [if (fps.Name == "spdMain")] | SSP0029_ShipmentPlanPack.cs:5252 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0029_ShipmentPlanPack.SCM_SYS_LOG_BATCH

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8408aac0 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:7400 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-8849881c | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:7401 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-57939e7f | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:7402 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-e82b0e2d | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:7403 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-9b806808 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:7404 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-25fe7b0f | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:7405 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-08b96096 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:7406 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-acb472e4 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:7408 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0029_ShipmentPlanPack.Set_SumValues

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments != null) ▸ if (SSP0029Popup.DialogResult == DialogResult.OK) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / FindButton [if (siMain.ActiveSheetIndex == 0) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca248039 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2733 | for (nCol < columCount) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-3fe9a20d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2737 | for (nCol < columCount) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0c6b8be | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2800 | for (iRow < rowCount) ▸ if (measure.Equals("INCO_WIP") \|\| measure.Equals("INSP_WIP") \|\| measure.Equals("WH_STOCK") \|\| measure.Equals("… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-fe8fe762 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2808 | for (iRow < rowCount) ▸ if (measure.Equals("INCO_WIP") \|\| measure.Equals("INSP_WIP") \|\| measure.Equals("WH_STOCK") \|\| measure.Equals("… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-5f8243fc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2818 | for (iRow < rowCount) ▸ if (measure.Equals("INCO_WIP") \|\| measure.Equals("INSP_WIP") \|\| measure.Equals("WH_STOCK") \|\| measure.Equals("… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-582e753f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2819 | for (iRow < rowCount) ▸ if (measure.Equals("INCO_WIP") \|\| measure.Equals("INSP_WIP") \|\| measure.Equals("WH_STOCK") \|\| measure.Equals("… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.SetBalanceMinus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc9f68d4 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:4917 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-de6e14c2 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:4920 |  | DATA_OP | dt.Columns.Add | ("DivisionID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3dd02042 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:4921 |  | DATA_OP | dt.Columns.Add | ("FromSite") | 데이터 객체 조작/조회 |  |  |  |
| AC-24b0863e | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:4922 |  | DATA_OP | dt.Columns.Add | ("ItemID") | 데이터 객체 조작/조회 |  |  |  |
| AC-af674fba | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:4950 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6cffc00e | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:4951 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dr["DivisionID"] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-907ebc1d | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:4952 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dr["FromSite"] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-19d9d8ea | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:4953 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dr["ItemID"] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-98093c88 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:4954 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dt.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-883c6610 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:4972 | if (dt.Rows.Count > 0) ▸ foreach (DataRow dr in dt.Rows) | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9171f66c | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:4979 | if (dt.Rows.Count > 0) ▸ foreach (DataRow dr in dt.Rows) ▸ if (list.Count > 0) ▸ foreach (DataRow dr2 in list) | DATA_OP | dtBalanceMinus.ImportRow | (dr2) | 데이터 객체 조작/조회 |  |  |  |

## SSP0029_ShipmentPlanPack.SetChangedControl

진입점: this.Load / this.spdMain.ActiveSheetChanged / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16d4b73f | this.Load 외 2 | SSP0029_ShipmentPlanPack.cs:2050 |  | FLAG | dtPlantSiteByDivision | Data.FromSiteByDivisionNoOspPack(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… | 화면 필드/플래그 변경 |  |  |  |
| AC-b8152ff5 | this.Load 외 2 | SSP0029_ShipmentPlanPack.cs:2050 |  | COMBO_DATA | Data.FromSiteByDivisionNoOspPack | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ecece9b1 | this.Load 외 2 | SSP0029_ShipmentPlanPack.cs:2051 |  | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDateShip, false, pDivisionID, "P") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-d0c48fc5 | this.Load 외 2 | SSP0029_ShipmentPlanPack.cs:2051 |  | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID, "P") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a277fc2e | this.Load 외 2 | SSP0029_ShipmentPlanPack.cs:2052 |  | FLAG | dtNewPlanDate | dtPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-4f777004 | this.Load 외 2 | SSP0029_ShipmentPlanPack.cs:2053 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-2a3d3b63 | this.Load 외 2 | SSP0029_ShipmentPlanPack.cs:2054 |  | VALUE_SET | drpPeriod2.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-3a3ba458 | this.Load 외 2 | SSP0029_ShipmentPlanPack.cs:2057 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-836bf3f1 | this.Load 외 2 | SSP0029_ShipmentPlanPack.cs:2061 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0029_ShipmentPlanPack.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a21c1350 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:8775 | if (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-32fdfa17 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:8779 | else of (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD2_" + value, strcboPlanDate) ⇒ biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a99ac702 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:8782 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1437cff6 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:8786 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-ae839db9 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:8787 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.SetImageCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef7488d4 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:4801 | for (iRow < siDetail.ActiveSheet.RowCount) | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.INCOTERMS)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-699ca64a | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:4802 | for (iRow < siDetail.ActiveSheet.RowCount) | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)].CellTy… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.SetLockSumColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fa42bea | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:2012 | for (iCol < spreadInfo.ActiveSheet.ColumnCount) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| spreadInfo.GetColumnTag(iCol).In… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0029_ShipmentPlanPack.SetNote_Display

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments != null) ▸ if (SSP0029Popup.DialogResult == DialogResult.OK) ▸ try ▸ for (iRow < rowCount) ▸ if (sMeasure == "PROD_DATE" \|\| sMeasure == "LOT" \|\| sMeasure == "WH_IN" \|\| sMeasure == "PROD_PLAN") ▸ for (nCol < columnCount) ▸ else of (sMeasure == "PROD_DATE") ▸ else of (sMeasure == "LOT") ▸ if (intNoteCnt > 0 && sMeasure == "WH_IN") ▸ if (drPgmAuthId != null)] / FindButton [if (siMain.ActiveSheetIndex == 0) ▸ try ▸ for (iRo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc9f99d6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2837 |  | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7abb14bf | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2838 |  | DATA_OP | row.Field | ("SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-02c852b6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2839 |  | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-78c08584 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2840 |  | DATA_OP | row.Field | ("YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-7082c244 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2847 | if (Comments != null) | GRID_SET | spdMain.ActiveSheet.Cells[intRowIdx, intColIdx].Note | strComments | 그리드 속성/값 설정 |  |  |  |
| AC-666a76c0 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2848 | if (Comments != null) | GRID_SET | spdMain.ActiveSheet.Cells[intRowIdx, intColIdx].NoteIndicatorSize | new Size(5, 5) | 그리드 속성/값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.SetProdNote_Display

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments != null) ▸ if (SSP0029Popup.DialogResult == DialogResult.OK) ▸ try ▸ for (iRow < rowCount) ▸ if (sMeasure == "PROD_DATE" \|\| sMeasure == "LOT" \|\| sMeasure == "WH_IN" \|\| sMeasure == "PROD_PLAN") ▸ for (nCol < columnCount) ▸ else of (sMeasure == "PROD_DATE") ▸ else of (sMeasure == "LOT") ▸ else of (intNoteCnt > 0 && sMeasure == "WH_IN") ▸ if (intProdNoteCNT > 0 && sMeasure == "PROD_PLAN") ▸ if (drPgmAuthId != null)] / Find…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-453abcdc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2863 |  | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-569f5670 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2864 |  | DATA_OP | row.Field | ("SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-06616c68 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2865 |  | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0d08729 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2866 |  | DATA_OP | row.Field | ("YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-f3239651 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2873 | if (drProdQty != null) | GRID_SET | spdMain.ActiveSheet.Cells[intRowIdx, intColIdx].Note | strProdQty | 그리드 속성/값 설정 |  |  |  |
| AC-9b9746c9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2874 | if (drProdQty != null) | GRID_SET | spdMain.ActiveSheet.Cells[intRowIdx, intColIdx].NoteIndicatorSize | new Size(5, 5) | 그리드 속성/값 설정 |  |  |  |
| AC-620e65cc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2875 | if (drProdQty != null) | GRID_SET | spdMain.ActiveSheet.Cells[intRowIdx, intColIdx].NoteIndicatorColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-a1ba72b5 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2877 | if (drProdQty != null) | CALL_EXT | spdMain.ActiveSheet.GetStickyNoteStyleInfo | (intRowIdx, intColIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d397d076 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2879 | if (drProdQty != null) | UI_PROP | nsinfo.Width | 170 | 속성 Width 설정 |  |  |  |
| AC-340c5f34 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0029_ShipmentPlanPack.cs:2881 | if (drProdQty != null) | CALL_EXT | spdMain.ActiveSheet.SetStickyNoteStyleInfo | (intRowIdx, intColIdx, nsinfo) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0029_ShipmentPlanPack.SetSoNoColumnVisible

진입점: this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.spdMain.CellDoubleClick [for (i < spdDetail.Sheets.Count) ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == Sp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a61bbd5 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0029_ShipmentPlanPack.cs:9346 | if (ichkbtn == 1) ▸ if (sSheetName == SpdSheet.shtPacker) | GRID_SET | siDetail.ActiveSheet.Columns[DefColumns.ERP_SO_NO].Width | 80 | 그리드 속성/값 설정 |  |  |  |
| AC-18480e0b | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0029_ShipmentPlanPack.cs:9350 | if (ichkbtn == 1) ▸ else of (sSheetName == SpdSheet.shtPacker) | GRID_SET | siDetail.ActiveSheet.Columns[DefColumns.ERP_SO_NO].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-9e5a291f | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0029_ShipmentPlanPack.cs:9357 | else of (ichkbtn == 1) ▸ if (sSheetName == SpdSheet.shtPacker) | GRID_SET | siDetail.ActiveSheet.Columns[DefColumns.ERP_SO_NO].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-b70f7b6d | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0029_ShipmentPlanPack.cs:9361 | else of (ichkbtn == 1) ▸ else of (sSheetName == SpdSheet.shtPacker) | GRID_SET | siDetail.ActiveSheet.Columns[DefColumns.ERP_SO_NO].Width | 80 | 그리드 속성/값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [for (i < spdDetail.Sheets.Count) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged / this.chkSum.CheckedChanged / this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.ActiveSheetChanged [if (spdInfo.Sheet…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53b9cea9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0029_ShipmentPlanPack.cs:1949 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-37387b73 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0029_ShipmentPlanPack.cs:1954 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-09485793 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0029_ShipmentPlanPack.cs:1961 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2e5ad5bc | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0029_ShipmentPlanPack.cs:1965 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e752214e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0029_ShipmentPlanPack.cs:1970 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-9d833c1a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0029_ShipmentPlanPack.cs:1977 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a4a05e66 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0029_ShipmentPlanPack.cs:1981 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.ShipmentResult_GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-643eac80 | this.Load | SSP0029_ShipmentPlanPack.cs:8898 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.shtDetail_Change

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f0da7df | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:6995 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange != true \|\| e.Row == -1 && e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b098115f | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:6996 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a0a7354 | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7007 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00189") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e84c66a3 | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7012 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00362") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7de173dc | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7014 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-712a641d | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7081 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00278") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d24468d2 | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7082 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8fbb3d50 | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7096 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-d013ecae | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7106 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-c51df898 | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7108 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-11646045 | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7109 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ForeCo… | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-723720c9 | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7110 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].BackCo… | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-5a4cbd5e | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7114 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-61b38bae | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7125 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-79948a26 | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7135 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-70e4700d | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7137 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-51d97ba5 | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7138 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ForeCo… | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-3d4f8a35 | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7139 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].BackCo… | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-f371a76b | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7154 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-a0716f77 | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7155 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfd4dec8 | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7159 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-da661a6b | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7166 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-5d7299eb | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7176 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-526eff9b | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7177 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-4a42c325 | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7178 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-130274ce | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7190 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-b1643bb4 | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7200 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-1d6a9b50 | dsdm.Changed | SSP0029_ShipmentPlanPack.cs:7201 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.SoNo

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ else of (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4974e7c2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6594 | for (i < intRowIdx) ▸ if (erpSoNo == siDetail.GetValue(i, siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)).ToString()) ▸ if (intRowIdx > i) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-6d9f43a4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6717 | try ▸ if (siMain.ActiveSheetIndex == 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-79fb585c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6721 | try ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER") ⇒ SSP.SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | 엔드포인트 요청 생성 |  |  |  |
| AC-537ef6a0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6726 | try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c4b42de4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6727 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1ba00ed7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6728 | try | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-9d47d62f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6729 | try | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-8952c368 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6730 | try | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-e01d9110 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6731 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-10c4437b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6732 | try | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-c7c6c01d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6733 | try | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-39890430 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6734 | try | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-0ccafcc0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6735 | try | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-9a92c0d9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6736 | try | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-8795bebc | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6737 | try | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-c83a8e43 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6738 | try | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-970d63f7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6739 | try | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-3af24d29 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6740 | try | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-831662be | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6741 | try | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-1573389f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6742 | try | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-506d07d7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6743 | try | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-01ad2fae | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6744 | try | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-07134fd6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6745 | try | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-33ee64dd | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6746 | try | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-8bf48bb7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6747 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-3cad4728 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6748 | try | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-68d16c1c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6749 | try | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-e6965aa1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6750 | try | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-66573ffe | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6751 | try | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a01f1621 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6752 | try | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a65e8d1c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6754 | try | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-17a5f184 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6755 | try | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-6bc54206 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6756 | try | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-14f302de | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6758 | try | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-0dc9d1e2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6759 | try | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-6ee2bcef | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6760 | try | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-634efc3f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6761 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-24f9e978 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6762 | try | DATA_OP | request.Parameters["p_shipto_code"] | p_shipto_code | 행/컬럼 값 대입 |  |  |  |
| AC-bdb58767 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6764 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-df3d779c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6801 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c0fc2248 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6805 | try | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |
| AC-ad6a4f32 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6812 | catch ((Exception ex)) | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPack.SpdDetail_ActiveSheetChanged

진입점: spdDetail.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6cfc13d | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7510 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ee9e654b | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7511 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-88c0746e | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7512 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d92d2f2e | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7513 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-900bc82c | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7514 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b040de1a | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7515 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a4d93a00 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7516 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b3e85992 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7517 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d88613be | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7518 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7cf42c7a | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7524 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4e954762 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7525 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-68d978e6 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7526 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-537d3050 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7527 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4d498ebd | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7528 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-96298f0d | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7529 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c1fdea52 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7530 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-25361231 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7531 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f85b855d | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7532 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-aa980278 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7539 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ed83a05a | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7540 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-34cfb7c9 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7541 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ceda0092 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7542 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9e44ae60 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7543 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b90d9f1e | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7544 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-139d8edc | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7545 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6af4ee1d | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7546 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-09b0fb43 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7547 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d35d856d | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7551 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d07969f6 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7552 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9d945b45 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7553 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0195d9a1 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7554 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-18137269 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7555 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-220a7720 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7556 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f17c8e62 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7557 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c80195b5 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7558 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5e842021 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7559 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-bdb79030 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7563 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-fcaf2a20 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7564 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1a5065e0 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7565 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9bae1fa4 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7566 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7f61f183 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7567 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-de793651 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7568 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-34d7383c | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7569 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fb53c47f | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7570 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-39cf742f | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7571 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c7d50575 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7576 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-fb5649e8 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7577 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-68fa71ec | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7578 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-8f50f1b1 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7579 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-58da5a88 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7580 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5211233a | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7581 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-77fee26f | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7582 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-148ecd1f | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7583 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-fe9958e6 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7584 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f2710958 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7588 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-31a360a5 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7589 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-90be9859 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7590 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1c535f76 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7591 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-84bd4997 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7592 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-44619090 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7593 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d11c149f | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7594 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-450102ef | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7595 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ba9cfcb5 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7596 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e6f5d757 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7600 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-8636ce5f | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7601 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-58b559a9 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7602 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9e5dd9e2 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7603 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f216a40d | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7604 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-623488d9 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7605 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-77e9586e | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7606 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7ed4d4ba | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7607 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-595ab5aa | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7608 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f783ae15 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7612 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-05de9867 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7613 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-028b0b1c | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7614 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-dc8df664 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7615 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a5a1ce13 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7616 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-027edef9 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7617 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-66dacc70 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7618 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fb9ca392 | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7619 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-84f8296e | spdDetail.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:7620 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.SpdDetail_CellClick

진입점: this.spdDetail.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d193b8a | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8133 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (spdDetail.AutoClipboard == true) | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.ClipboardPasteAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-920c47e2 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8134 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (spdDetail.AutoClipboard == true) | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.ClipboardCopyAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d4d1ac56 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8135 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (spdDetail.AutoClipboard == true) | UI_PROP | spdDetail.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |
| AC-66e10e29 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8149 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) … | FLAG | sDivision | siDetail.GetValue(e.Row, siDetail.GetColumnIndex(DefColumns.ORIGIN_FROM_DIVISION_ID)).ToSt… | 화면 필드/플래그 변경 |  |  |  |
| AC-0b878f1d | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8151 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-f29ac799 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8151 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bbd5bd44 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8160 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Vert… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-0c16cd07 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8161 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Hori… | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-97236fa3 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8172 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CO… | FLAG | dtShipToCode | Data.Common(Data.Type.ShipToCodeByDivision, false, sDivision, sToSite, "", "", "") ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-d3fdc552 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8172 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CO… | COMBO_DATA | Data.Common | (Data.Type.ShipToCodeByDivision, false, sDivision, sToSite, "", "", "") ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-107b4f22 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8174 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CO… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CODE), dtShipToCode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8e940210 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8176 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CO… | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CODE)]… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-3be8a421 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8177 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CO… | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CODE)]… | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-3b578125 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8186 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siDe… | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-3cd8aef6 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8190 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siDe… | GRID_SET | siDetail.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-268059da | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8203 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | UI_PROP | spdDetail.AutoClipboard | true | 속성 AutoClipboard 설정 |  |  |  |
| AC-7725d7e3 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8204 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | FLAG | im | spdDetail.GetInputMap(FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | 화면 필드/플래그 변경 |  |  |  |
| AC-1208e083 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8204 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | CALL_EXT | spdDetail.GetInputMap | (FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e8db94c | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8205 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c836414 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8206 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c2abbc12 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8221 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-2d447481 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8225 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-06c7b2d6 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8232 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-03aae1b9 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8236 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-82115b1c | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8247 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) ▸ if (string.IsNullOrWhiteSpace(sRequestNo)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15d600c0 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8249 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | new SCM0002_ShipmentPlanRequestPopup | () | 팝업/폼 생성 |  |  |  |
| AC-14b47238 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8250 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0ce36495 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8251 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop._sRequestNo | sRequestNo | 속성 _sRequestNo 설정 |  |  |  |
| AC-c7c76b26 | this.spdDetail.CellClick | SSP0029_ShipmentPlanPack.cs:8252 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0029_ShipmentPlanPack.SpdDetail_CellDoubleClick

진입점: this.spdDetail.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e58cc2d9 | this.spdDetail.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:1242 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetail.Ge… | POPUP | new SSP0300_OrderDetailPopup | () | 팝업/폼 생성 |  |  |  |
| AC-46531366 | this.spdDetail.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:1244 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetail.Ge… | POPUP | pop.Form_Load | (_DivisionID, _ErpSoNo, _ConfirmId, _ItemID, "N") | 팝업 초기화(인자 전달) |  |  |  |
| AC-c8bd53a4 | this.spdDetail.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:1245 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetail.Ge… | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1abd0971 | this.spdDetail.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:1246 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetail.Ge… | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0029_ShipmentPlanPack.SpdDetail_ClipboardPasted

진입점: spdDetail.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ec180d3 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8520 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | FLAG | sDivision | siDetail.GetValue(iRow, siDetail.GetColumnIndex(DefColumns.ORIGIN_FROM_DIVISION_ID)).ToStr… | 화면 필드/플래그 변경 |  |  |  |
| AC-066cdddd | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8522 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms2) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-e82786ee | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8522 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms2) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f03b4589 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8524 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | DATA_OP | dtTransMode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ec9c56e9 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8528 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | CALL_EXT | ((FarPoint.Win.Spread.FpSpread)sender).CancelCellEditing | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d4eef73d | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8530 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-ae928d7d | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8531 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].BackCo… | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-a838de40 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8532 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)]… | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-177bf735 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8533 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ForeCo… | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-2d074f6c | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8539 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | MESSAGE | MessageHelper.GMessageBox | ("MSG00047", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da6caba7 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8540 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03978df3 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8577 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-6a854952 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8601 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-5baa1eed | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8619 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-8dc709de | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8620 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_STYLE | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetF… | () | 그리드 표시 설정 |  |  |  |
| AC-6985a216 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8621 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_STYLE | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetB… | () | 그리드 표시 설정 |  |  |  |
| AC-d95f1f65 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8624 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ForeCo… | ControlColor.DefaultForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-a761e614 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8640 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-2f06b1a3 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8641 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-44c87651 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8642 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-d0d3c526 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8643 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-a73c7238 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8644 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-14de1c2d | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8654 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-63665669 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8656 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-7c847428 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8657 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-87f6289b | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8658 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-d96e24d6 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8659 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-cf14a5ad | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8667 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-69a237a6 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8674 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-849389f8 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8682 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | DATA_OP | dtChangeReasonCode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-196b41e5 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8686 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | CALL_EXT | ((FarPoint.Win.Spread.FpSpread)sender).CancelCellEditing | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b263e070 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8690 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | MESSAGE | MessageHelper.GMessageBox | ("MSG00047", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-837b05cb | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8691 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5d6c0e2 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8697 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE)].F… | ControlColor.MarkedForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-10803fcc | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8701 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-edd098a0 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8712 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE)].Fore… | ControlColor.MarkedForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-58ea8ec0 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8714 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-0f8c22c2 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8715 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-e862f75c | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8729 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-66604372 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8740 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-1279b713 | spdDetail.ClipboardPasted | SSP0029_ShipmentPlanPack.cs:8742 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.spdDetail_ComboSelChange

진입점: this.spdDetail.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62354bfb | this.spdDetail.ComboSelChange | SSP0029_ShipmentPlanPack.cs:8262 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(siDetail.GetValue(e.Row, siDetail.GetCol… | MESSAGE | MessageHelper.GMessageBox | ("MSG00278") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c1260f1 | this.spdDetail.ComboSelChange | SSP0029_ShipmentPlanPack.cs:8263 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(siDetail.GetValue(e.Row, siDetail.GetCol… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32744d38 | this.spdDetail.ComboSelChange | SSP0029_ShipmentPlanPack.cs:8307 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-2adc3ac8 | this.spdDetail.ComboSelChange | SSP0029_ShipmentPlanPack.cs:8332 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siDetail.Acti… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-cda116d4 | this.spdDetail.ComboSelChange | SSP0029_ShipmentPlanPack.cs:8355 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-a5846370 | this.spdDetail.ComboSelChange | SSP0029_ShipmentPlanPack.cs:8356 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-e8bfb414 | this.spdDetail.ComboSelChange | SSP0029_ShipmentPlanPack.cs:8361 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-dbeb8fcb | this.spdDetail.ComboSelChange | SSP0029_ShipmentPlanPack.cs:8375 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-a3041562 | this.spdDetail.ComboSelChange | SSP0029_ShipmentPlanPack.cs:8376 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-da7e2802 | this.spdDetail.ComboSelChange | SSP0029_ShipmentPlanPack.cs:8377 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-19c30d22 | this.spdDetail.ComboSelChange | SSP0029_ShipmentPlanPack.cs:8382 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-28312b5f | this.spdDetail.ComboSelChange | SSP0029_ShipmentPlanPack.cs:8383 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-36076ff3 | this.spdDetail.ComboSelChange | SSP0029_ShipmentPlanPack.cs:8384 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.SpdDetail_EditChange

진입점: spdDetail.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e660bb0 | spdDetail.EditChange | SSP0029_ShipmentPlanPack.cs:8429 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.Get… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-fbd011d8 | spdDetail.EditChange | SSP0029_ShipmentPlanPack.cs:8430 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.Get… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-c4dc5a68 | spdDetail.EditChange | SSP0029_ShipmentPlanPack.cs:8440 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.Get… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-17f8ea01 | spdDetail.EditChange | SSP0029_ShipmentPlanPack.cs:8445 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.Get… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-3221f2fe | spdDetail.EditChange | SSP0029_ShipmentPlanPack.cs:8446 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.Get… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-df81a75e | spdDetail.EditChange | SSP0029_ShipmentPlanPack.cs:8462 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (e.Column == siDetai… | GRID_STYLE | siDetail.ActiveSheet.SetActiveCell | (e.Row, siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) | 그리드 표시 설정 |  |  |  |
| AC-a647ea49 | spdDetail.EditChange | SSP0029_ShipmentPlanPack.cs:8463 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (e.Column == siDetai… | CALL_EXT | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL)… | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3341890b | spdDetail.EditChange | SSP0029_ShipmentPlanPack.cs:8465 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (e.Column == siDetai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00287", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f8f6c48a | spdDetail.EditChange | SSP0029_ShipmentPlanPack.cs:8467 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (e.Column == siDetai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd50ceaf | spdDetail.EditChange | SSP0029_ShipmentPlanPack.cs:8475 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (e.Column == siDetai… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-478855fe | spdDetail.EditChange | SSP0029_ShipmentPlanPack.cs:8485 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (e.Column == siDetai… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-9c70768a | spdDetail.EditChange | SSP0029_ShipmentPlanPack.cs:8487 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (e.Column == siDetai… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.SpdDetail_SheetTabClick

진입점: this.spdDetail.SheetTabClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a85fb09 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1502 | if (e.SheetTabIndex == 0) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ff1b5c6 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1503 | if (e.SheetTabIndex == 0) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a0339560 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1507 | else of (e.SheetTabIndex == 0) ▸ if (e.SheetTabIndex == 1) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtRequestDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-276f806e | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1508 | else of (e.SheetTabIndex == 0) ▸ if (e.SheetTabIndex == 1) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtRequestDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0802a433 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1512 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ if (e.SheetTabIndex == 2) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5b87d286 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1513 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ if (e.SheetTabIndex == 2) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHstock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6233ee15 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1517 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 3) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ced39211 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1518 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 3) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHstockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-aa310d20 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1522 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ if (e.Sh… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-15dbebc1 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1523 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ if (e.Sh… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtBolckStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-60e3b728 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1527 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMesStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c2f1fbb | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1528 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMesStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-78f4fb4c | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1532 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtScsStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6204dff5 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1533 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtScsStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6b67c151 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1538 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockLocationDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0cdeb90b | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1539 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtStockLocationDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0e8d69c6 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1546 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHinPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8284407b | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1547 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHinPlanDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-15675b07 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1551 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a69e817 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1552 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentResult) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2b9d1d60 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1554 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | CALL_EXT | clbResultType.SetItemChecked | (0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8fab687a | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1555 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | CALL_EXT | clbResultType.SetItemChecked | (1, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c68053a | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1560 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cd0ebac9 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1561 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentResult) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f9199a9b | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1563 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | CALL_EXT | clbResultType.SetItemChecked | (0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2aa7d51 | this.spdDetail.SheetTabClick | SSP0029_ShipmentPlanPack.cs:1564 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | CALL_EXT | clbResultType.SetItemChecked | (1, true) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0029_ShipmentPlanPack.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b0dec1a | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1262 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-447258fe | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1265 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtWHstock) | 화면 필드/플래그 변경 |  |  |  |
| AC-c34f31df | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1268 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtWHstockDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-0666878a | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1271 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtBolckStock) | 화면 필드/플래그 변경 |  |  |  |
| AC-65624578 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1274 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtBolckStockDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-efef228d | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1277 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtMesStock) | 화면 필드/플래그 변경 |  |  |  |
| AC-05f1199b | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1280 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtScsStock) | 화면 필드/플래그 변경 |  |  |  |
| AC-c625c11d | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1283 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtStockLocationDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-5437a98d | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1286 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtWHinPlanDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-9b6aea39 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1289 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtShipmentResult) | 화면 필드/플래그 변경 |  |  |  |
| AC-60c4720b | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1295 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-4ed3c54c | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1299 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | FLAG | dtResultType | Data.Common(Data.Type.LookupCommon, false, "SSP_SHIPMENT_RESULT_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-13cf9897 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1299 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "SSP_SHIPMENT_RESULT_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf5bb27d | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1301 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | DATA_OP | dtResultType.Rows.RemoveAt | (3) | 데이터 객체 조작/조회 |  |  |  |
| AC-5548c75f | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1303 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | LIST_REBIND | clsCtrl.setListBox | (dtResultType, clbResultType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2cdf50a6 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1305 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.ShipmentRequestPlantSite, false, pDivisionID, "P", "E") | 화면 필드/플래그 변경 |  |  |  |
| AC-638ed790 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1305 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentRequestPlantSite, false, pDivisionID, "P", "E") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9b25012f | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1314 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-34cf45bc | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1317 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-c1b4defe | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1320 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-8c4aead1 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1323 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-4f5675df | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1326 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-28e60a4e | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1329 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-21e93c76 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1333 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-dd1c6057 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1336 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-3073ce09 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1339 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-87f34d12 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1341 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | drpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4ba54364 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1347 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPacker) | 화면 필드/플래그 변경 |  |  |  |
| AC-47411825 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1351 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | FLAG | dtResultType | Data.Common(Data.Type.LookupCommon, false, "SSP_SHIPMENT_RESULT_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-6b8931b4 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1351 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "SSP_SHIPMENT_RESULT_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-052eaaca | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1353 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | DATA_OP | dtResultType.Rows.RemoveAt | (1) | 데이터 객체 조작/조회 |  |  |  |
| AC-72211469 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1354 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | DATA_OP | dtResultType.Rows.RemoveAt | (1) | 데이터 객체 조작/조회 |  |  |  |
| AC-addbcfcb | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1356 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | LIST_REBIND | clsCtrl.setListBox | (dtResultType, clbResultType, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-841596fe | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1358 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | FLAG | dtPlantSiteByDivision | Data.UserPlantSiteByDivisionOspPack(UserInfoContext.Current["NowGroupID"], UserInfoContext… | 화면 필드/플래그 변경 |  |  |  |
| AC-cc62abb3 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1358 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | COMBO_DATA | Data.UserPlantSiteByDivisionOspPack | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2e53f2a0 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1367 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-b68ecdaa | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1371 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-a50fab8d | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1375 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-a2daa2e9 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1379 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-a138a9aa | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1383 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-1ec148ae | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1387 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-298aa849 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1391 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-f74c7c16 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1395 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-8a84b101 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1399 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-90f2a125 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1401 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | drpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-deee45dd | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1404 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fdf591e4 | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1405 |  | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c83efd6d | this.spdMain.ActiveSheetChanged | SSP0029_ShipmentPlanPack.cs:1407 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0029_ShipmentPlanPack.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93635eda | spdMain.CellClick | SSP0029_ShipmentPlanPack.cs:1099 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (e.Column > siMain.GetColumnIndex(DefColumns.MEASURE) && siMain.GetValue(e.Row, siMain.GetColumnIn… | GRID_STYLE | spdMain.ActiveSheet.SetActiveCell | (e.Row, e.Column) | 그리드 표시 설정 |  |  |  |
| AC-7ea7c64f | spdMain.CellClick | SSP0029_ShipmentPlanPack.cs:1100 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (e.Column > siMain.GetColumnIndex(DefColumns.MEASURE) && siMain.GetValue(e.Row, siMain.GetColumnIn… | UI_PROP | spdMain.ContextMenu | contextMenu | 속성 ContextMenu 설정 |  |  |  |
| AC-09c8c139 | spdMain.CellClick | SSP0029_ShipmentPlanPack.cs:1104 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (e.Column > siMain.GetColumnIndex(DefColumns.MEASURE) && siMain.GetValue(e.Row, siMain.GetCol… | UI_PROP | spdMain.ContextMenu | null | 속성 ContextMenu 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a2ef3eb | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7630 | for (i < spdDetail.Sheets.Count) | FLAG | siDetail | GetSheetInfo(spdDetail.Name, spdDetail.Sheets[i].SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-e295df1e | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7631 | for (i < spdDetail.Sheets.Count) | GRID_INIT | siDetail.ChangeSheet | (spdDetail.Sheets[i].SheetName) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-de25591c | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7637 | if (e.ColumnHeader) | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-11a134d8 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7642 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-df31ab7a | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7643 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-71d4279a | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7653 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) | FLAG | bDetail_Search | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5b982d27 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7658 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | VALUE_CLEAR | txtModel2.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-68541137 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7659 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | VALUE_CLEAR | drpPeriod2.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-ba78b83e | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7660 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | FLAG | sDivision | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b7b33c2f | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7661 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | FLAG | sItemID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-508290a8 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7662 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | FLAG | sFromSiteID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-73994a3c | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7663 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | FLAG | sPlanStartYyyymmdd | siMain.GetColumnTag(e.Column).Replace("D_", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-05e8ac3c | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7666 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-53577450 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7668 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-50deeecd | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7669 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5385b7cd | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7678 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_HOLD") | FLAG | sDivision | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a2675679 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7679 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_HOLD") | FLAG | sItemID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f9a83ac4 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7680 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_HOLD") | FLAG | sPlanStartYyyymmdd | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-be511881 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7682 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_HOLD") | FLAG | sPlanType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-da44e858 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7683 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_HOLD") | FLAG | sSeq | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2263cded | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7684 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_HOLD") | FLAG | sFromSiteID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-484e2509 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7689 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_HOLD") | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-8d65aed2 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7691 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_HOLD") | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a8ed7998 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7692 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_HOLD") | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHstock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b48589ce | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7722 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | FLAG | sPlanStartYyyymmdd | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-c19571ad | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7723 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | FLAG | sFromSiteID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8ecff74a | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7724 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | FLAG | sItemID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9b026910 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7726 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | FLAG | sPlanType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e56041e5 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7727 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | FLAG | sSeq | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6d83cf04 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7729 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-4ecd3907 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7731 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMesStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-35afccc9 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7732 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMesStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f5ca9820 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7748 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_RELEASE") | FLAG | sPlanStartYyyymmdd | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-1765c567 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7749 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_RELEASE") | FLAG | sFromSiteID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-58b6968c | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7750 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_RELEASE") | FLAG | sItemID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-331890df | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7752 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_RELEASE") | FLAG | sPlanType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-df9d1b22 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7753 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_RELEASE") | FLAG | sSeq | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-da326110 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7755 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_RELEASE") | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-1a418f38 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7757 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_RELEASE") | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-224962bc | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7758 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "MES_FCS_RELEASE") | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtBolckStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-98f4a0c4 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7792 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sPlanStartYyyymmdd | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-4f497a57 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7793 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sFromSiteID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0e555010 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7794 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sItemID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-86a3a2b6 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7796 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sPlanType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e107a699 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7797 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sSeq | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-742aa2ad | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7799 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-2ac974a9 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7801 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMesStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5bb3b6a6 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7802 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMesStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1def80a0 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7827 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ else of (str… | DATA_OP | dtMyDivision.Compute | ("MAX(NAME)", "CODE = '" + strDivision_ID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-4dade85a | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7851 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (strQty =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d7a3914c | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7858 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1679c0b3 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7859 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") | DATA_OP | row.Field | ("SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ab13e80 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7860 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4e7c7a58 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7861 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") | DATA_OP | row.Field | ("YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-2866a85e | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7870 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments… | CALL_EXT | Comments["GAP"].ToString().LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8fdf8242 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7881 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments… | POPUP | new SSP0029_ShipmentPlanPackPopup | (strDivision_ID, strDivision_NM, strPlan_Date, strFromSite_ID, strFromSite_NM, strItem_ID,… | 팝업/폼 생성 |  |  |  |
| AC-4bbadd25 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7882 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments… | UI_PROP | SSP0029Popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-94689102 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7883 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments… | POPUP | SSP0029Popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-58875cb9 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7886 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments… | UI_PROP | spdMain.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |
| AC-d41ac53c | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7904 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ else of (Com… | POPUP | new SSP0029_ShipmentPlanPackPopup | (strDivision_ID, strDivision_NM, strPlan_Date, strFromSite_ID, strFromSite_NM, strItem_ID,… | 팝업/폼 생성 |  |  |  |
| AC-17016a98 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7905 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ else of (Com… | UI_PROP | SSP0029Popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9fd10c3b | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7906 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ else of (Com… | POPUP | SSP0029Popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b53ad576 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7909 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ else of (Com… | UI_PROP | spdMain.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |
| AC-ed423628 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7923 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) | FLAG | bDetail_Search | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cee29d47 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7930 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sPlanStartYyyymmdd | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-b16ec49c | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7931 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sFromSiteID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-bde1caa1 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7932 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sItemID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cd7043fe | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7934 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sPlanType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-424e3fd7 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7935 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sSeq | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c9711dbe | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7937 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-4814c94e | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7940 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | VALUE_SET | txtModel2.Text | sItemID | 컨트롤 값 설정 |  |  |  |
| AC-b886d41d | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7942 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtScsStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f48108cc | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7943 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtScsStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-05e09c72 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7955 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sPlanStartYyyymmdd | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-f2280d82 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7956 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sFromSiteID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f1435954 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7957 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sItemID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-22f103dc | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7959 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sPlanType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8ae78d11 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7960 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sSeq | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-06f6e07b | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7962 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-7f8ae202 | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7964 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | VALUE_SET | txtModel2.Text | sItemID | 컨트롤 값 설정 |  |  |  |
| AC-10f68f3d | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7966 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockLocationDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c4b4324c | this.spdMain.CellDoubleClick | SSP0029_ShipmentPlanPack.cs:7967 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtStockLocationDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0029_ShipmentPlanPack.SpdMain_EditModeOn

진입점: spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b71b52c | spdMain.EditModeOn | SSP0029_ShipmentPlanPack.cs:1111 |  | UI_PROP | spdMain.EditingControl.ContextMenu | contextMenu | 속성 ContextMenu 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.spdMain_TextTipFetch

진입점: this.spdMain.TextTipFetch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a23c12b | this.spdMain.TextTipFetch | SSP0029_ShipmentPlanPack.cs:8950 | if (drPgmAuthId != null) ▸ if (spdMain.ActiveSheet.RowCount > 0) | GRID_SET | spdMain.ActiveSheet.Cells[intRNoteIdx, intCNoteIdx].NoteStyle | NoteStyle.Hidden | 그리드 속성/값 설정 |  |  |  |
| AC-865fbe9c | this.spdMain.TextTipFetch | SSP0029_ShipmentPlanPack.cs:8953 | if (drPgmAuthId != null) ▸ if (spdMain.ActiveSheet.RowCount > 0) ▸ if (spdMain.ActiveSheet.Cells[e.Row, e.Column].Note != "") | GRID_SET | spdMain.ActiveSheet.Cells[e.Row, e.Column].NoteStyle | NoteStyle.StickyNote | 그리드 속성/값 설정 |  |  |  |
| AC-2008f7dc | this.spdMain.TextTipFetch | SSP0029_ShipmentPlanPack.cs:8954 | if (drPgmAuthId != null) ▸ if (spdMain.ActiveSheet.RowCount > 0) ▸ if (spdMain.ActiveSheet.Cells[e.Row, e.Column].Note != "") | FLAG | intRNoteIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-e7dcf0ee | this.spdMain.TextTipFetch | SSP0029_ShipmentPlanPack.cs:8955 | if (drPgmAuthId != null) ▸ if (spdMain.ActiveSheet.RowCount > 0) ▸ if (spdMain.ActiveSheet.Cells[e.Row, e.Column].Note != "") | FLAG | intCNoteIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SSP0029_ShipmentPlanPack.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaa4c431 | this.spdMain.TopChange | SSP0029_ShipmentPlanPack.cs:1578 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0029_ShipmentPlanPack.TsmNotepad_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4af38a19 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:1130 | else of (strDivision_ID == "40") | DATA_OP | dtMyDivision.Compute | ("MAX(NAME)", "CODE = '" + strDivision_ID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-c27b231e | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:1156 |  | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-480a2e8a | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:1157 |  | DATA_OP | row.Field | ("SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-79abdce0 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:1158 |  | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0a107d49 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:1159 |  | DATA_OP | row.Field | ("YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-4e25e3b9 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:1168 | if (Comments != null) | CALL_EXT | Comments["GAP"].ToString().LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f486cb9 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:1179 | if (Comments != null) | POPUP | new SSP0029_ShipmentPlanPackPopup | (strDivision_ID, strDivision_NM, strPlan_Date, strFromSite_ID, strFromSite_NM, strItem_ID,… | 팝업/폼 생성 |  |  |  |
| AC-de93f23d | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:1180 | if (Comments != null) | UI_PROP | SSP0029Popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-15056143 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:1181 | if (Comments != null) | POPUP | SSP0029Popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4c6967ef | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:1184 | if (Comments != null) | UI_PROP | spdMain.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |
| AC-2b5e8b3e | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:1202 | else of (Comments != null) | POPUP | new SSP0029_ShipmentPlanPackPopup | (strDivision_ID, strDivision_NM, strPlan_Date, strFromSite_ID, strFromSite_NM, strItem_ID,… | 팝업/폼 생성 |  |  |  |
| AC-81c9c2ae | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:1203 | else of (Comments != null) | UI_PROP | SSP0029Popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b74ac8f3 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:1204 | else of (Comments != null) | POPUP | SSP0029Popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-595bde21 | (진입점 미연결) | SSP0029_ShipmentPlanPack.cs:1207 | else of (Comments != null) | UI_PROP | spdMain.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |

## SSP0029_ShipmentPlanPack.Validation_Check

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2b0be77 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6062 |  | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6617811c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6080 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39b3b401 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6081 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6ee9e930 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6087 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-547af0cd | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6087 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-c2f14356 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6103 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c4b55773 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6123 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), "T07") | 그리드 값 설정 |  |  |  |
| AC-91a95428 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6143 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9ae0af0f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6143 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef8395f4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6199 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetBack… | () | 그리드 표시 설정 |  |  |  |
| AC-6170f814 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6200 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-c3f68021 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6201 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-86edb412 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6203 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].Re… | () | 그리드 표시 설정 |  |  |  |
| AC-87d58d5c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6204 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-4b43e9f7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6205 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetFor… | () | 그리드 표시 설정 |  |  |  |
| AC-cf7807d3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6206 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-5e4d6e65 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6207 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-a44c05c1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6215 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a8cdd9bf | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6219 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b2e8769b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6235 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d0d1a62f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6235 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-e26195c3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6267 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetBack… | () | 그리드 표시 설정 |  |  |  |
| AC-7d6a70ce | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6268 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-c3c14b27 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6269 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-7bd803e9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6271 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].Re… | () | 그리드 표시 설정 |  |  |  |
| AC-a5731965 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6272 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-ab58ef76 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6273 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetFor… | () | 그리드 표시 설정 |  |  |  |
| AC-c4be0e23 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6274 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-d5e34fc1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6275 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-769b75d8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6277 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00286", new object[] { (i + 1).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c353f84 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6279 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3e6f34b0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0029_ShipmentPlanPack.cs:6285 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPackPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d3f036d | .ctor | SSP0029_ShipmentPlanPackPopup.cs:187 |  | FLAG | this.Division_ID | spDivision_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-9f210250 | .ctor | SSP0029_ShipmentPlanPackPopup.cs:188 |  | FLAG | this.Division_NM | spDivision_NM | 화면 필드/플래그 변경 |  |  |  |
| AC-35a42071 | .ctor | SSP0029_ShipmentPlanPackPopup.cs:189 |  | FLAG | this.Plan_Date | spPlan_Date.Replace("-", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-ba646e94 | .ctor | SSP0029_ShipmentPlanPackPopup.cs:190 |  | FLAG | this.FromSite_ID | spFromSite_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-61add294 | .ctor | SSP0029_ShipmentPlanPackPopup.cs:191 |  | FLAG | this.FromSite_NM | spFromSite_NM | 화면 필드/플래그 변경 |  |  |  |
| AC-c8e387fe | .ctor | SSP0029_ShipmentPlanPackPopup.cs:192 |  | FLAG | this.Item_ID | spItem_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-8877160d | .ctor | SSP0029_ShipmentPlanPackPopup.cs:193 |  | FLAG | this.Date | spDate | 화면 필드/플래그 변경 |  |  |  |
| AC-4a5d4bbe | .ctor | SSP0029_ShipmentPlanPackPopup.cs:194 |  | FLAG | this.Measure_ID | spMeasure_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-263f8208 | .ctor | SSP0029_ShipmentPlanPackPopup.cs:195 |  | FLAG | this.Measure_NM | spMeasure_NM | 화면 필드/플래그 변경 |  |  |  |
| AC-9c200b44 | .ctor | SSP0029_ShipmentPlanPackPopup.cs:196 |  | FLAG | this.UserAddQty | spUserAddQty | 화면 필드/플래그 변경 |  |  |  |
| AC-a493f397 | .ctor | SSP0029_ShipmentPlanPackPopup.cs:197 |  | FLAG | this.BeforeQty | spBeforeQty | 화면 필드/플래그 변경 |  |  |  |
| AC-eaa58cf5 | .ctor | SSP0029_ShipmentPlanPackPopup.cs:198 |  | FLAG | this.Gap | spGap | 화면 필드/플래그 변경 |  |  |  |
| AC-ceb60048 | .ctor | SSP0029_ShipmentPlanPackPopup.cs:199 |  | FLAG | this.Qty | spQty | 화면 필드/플래그 변경 |  |  |  |
| AC-1d841a3e | .ctor | SSP0029_ShipmentPlanPackPopup.cs:200 |  | FLAG | this.ProdQty | spProdQty | 화면 필드/플래그 변경 |  |  |  |
| AC-0d932fce | .ctor | SSP0029_ShipmentPlanPackPopup.cs:201 |  | FLAG | this.PlanType | spPlanType | 화면 필드/플래그 변경 |  |  |  |
| AC-5a03aaaa | .ctor | SSP0029_ShipmentPlanPackPopup.cs:202 |  | FLAG | this.Seq | spSeq | 화면 필드/플래그 변경 |  |  |  |
| AC-a1e79526 | .ctor | SSP0029_ShipmentPlanPackPopup.cs:203 |  | FLAG | this.User_ID | spUser_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-b45bba42 | .ctor | SSP0029_ShipmentPlanPackPopup.cs:204 |  | FLAG | this.Comments | spComments | 화면 필드/플래그 변경 |  |  |  |

## SSP0029_ShipmentPlanPackPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eead8ebd | this.btnButtonList.UsrButtonList_Click_Detected | SSP0029_ShipmentPlanPackPopup.cs:440 | else of (buttonItem.UserType == ButtonListType.Save) ▸ if (buttonItem.UserType == ButtonListType.Cancel) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPackPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aecc41c0 | Dispose | SSP0029_ShipmentPlanPackPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0029_ShipmentPlanPackPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c2c324c | this.Load | SSP0029_ShipmentPlanPackPopup.cs:212 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0029_ShipmentPlanPackPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef9d44fd | this.Load | SSP0029_ShipmentPlanPackPopup.cs:225 |  | VALUE_SET | this.txtDivision_ID.Text | Division_NM | 컨트롤 값 설정 |  |  |  |
| AC-5ba005aa | this.Load | SSP0029_ShipmentPlanPackPopup.cs:226 |  | VALUE_SET | this.txtPlan_Date.Text | Plan_Date.Substring(0, 4) + "-" + Plan_Date.Substring(4, 2) + "-" + Plan_Date.Substring(6,… | 컨트롤 값 설정 |  |  |  |
| AC-663cceb9 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:227 |  | VALUE_SET | this.txtFrom_Site.Text | FromSite_NM | 컨트롤 값 설정 |  |  |  |
| AC-578b92c9 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:228 |  | VALUE_SET | this.txtItem_ID.Text | Item_ID | 컨트롤 값 설정 |  |  |  |
| AC-83b2cdb7 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:229 |  | VALUE_SET | this.txtDate.Text | Date.Substring(0, 4) + "-" + Date.Substring(4, 2) + "-" + Date.Substring(6, 2) | 컨트롤 값 설정 |  |  |  |
| AC-857170d2 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:230 |  | VALUE_SET | this.txtMeasure.Text | Measure_NM | 컨트롤 값 설정 |  |  |  |
| AC-8d4fdf23 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:231 |  | VALUE_SET | this.txtChange_Qty.Text | Qty | 컨트롤 값 설정 |  |  |  |
| AC-96695fb6 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:232 |  | VALUE_SET | this.txtCurrent_Qty.Text | Qty | 컨트롤 값 설정 |  |  |  |
| AC-313f0317 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:233 |  | VALUE_SET | this.txtBefore_Qty.Text | UserAddQty | 컨트롤 값 설정 |  |  |  |
| AC-938a07f7 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:234 |  | VALUE_SET | this.txtGap_Qty.Text | Gap | 컨트롤 값 설정 |  |  |  |
| AC-6cdcf7a1 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:235 |  | VALUE_SET | this.txtWHin_Qty.Text | Qty | 컨트롤 값 설정 |  |  |  |
| AC-09e6a44c | this.Load | SSP0029_ShipmentPlanPackPopup.cs:236 |  | VALUE_SET | this.txtProd_Qty.Text | ProdQty | 컨트롤 값 설정 |  |  |  |
| AC-a236deb7 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:237 |  | VALUE_SET | this.rtxComments.Text | Comments | 컨트롤 값 설정 |  |  |  |
| AC-34cce8bd | this.Load | SSP0029_ShipmentPlanPackPopup.cs:240 |  | STATE | this.txtDivision_ID.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-90255e97 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:241 |  | STATE | this.txtPlan_Date.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-074be9cf | this.Load | SSP0029_ShipmentPlanPackPopup.cs:242 |  | STATE | this.txtFrom_Site.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6560dbbf | this.Load | SSP0029_ShipmentPlanPackPopup.cs:243 |  | STATE | this.txtItem_ID.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cad9765e | this.Load | SSP0029_ShipmentPlanPackPopup.cs:244 |  | STATE | this.txtDate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ef4e539e | this.Load | SSP0029_ShipmentPlanPackPopup.cs:245 |  | STATE | this.txtMeasure.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-991208b4 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:246 |  | STATE | this.txtCurrent_Qty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4018fee3 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:247 |  | STATE | this.txtProd_Qty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-75ee4503 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:248 |  | STATE | this.txtWHin_Qty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8bf8ed66 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:249 |  | STATE | this.txtBefore_Qty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-780aed33 | this.Load | SSP0029_ShipmentPlanPackPopup.cs:250 |  | STATE | this.txtGap_Qty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0029_ShipmentPlanPackPopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save)] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98c989fb | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:282 | try | FLAG | SaveFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4bdb25b1 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:285 | try ▸ if (Validation_Check() == false) | FLAG | SaveFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-38f77ab2 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:286 | try ▸ if (Validation_Check() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8a074032 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:331 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9375b6da | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:333 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0029_SAVE_SHIPMENT_PSI_COMMENTS") ⇒ SSP.SSP0029_SAVE_SHIPMENT_PSI_COMMENTS | 엔드포인트 요청 생성 |  |  |  |
| AC-35bf3192 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:337 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c0732269 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:341 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_change_flag"] | p_change_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b7c1f609 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:342 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-15c6c34a | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:343 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-3e4f5449 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:344 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0188b3bd | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:345 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-00b5a9d7 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:346 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-49f8ea37 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:347 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-62930bb4 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:348 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-8c40bc32 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:349 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_measure"] | p_measure | 행/컬럼 값 대입 |  |  |  |
| AC-0ecb5057 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:350 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-95851ac8 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:351 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_prodQty"] | p_prodQty | 행/컬럼 값 대입 |  |  |  |
| AC-2b4f89b1 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:352 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_comments"] | p_comments | 행/컬럼 값 대입 |  |  |  |
| AC-9bff2143 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:353 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-48150c90 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:355 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-73a9be4e | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:357 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-470babd3 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:357 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-b09b619d | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:368 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S"… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d66b60ae | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:370 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S"… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ce214e8e | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:376 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b1768985 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:383 | try ▸ else of (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6b940ee | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:389 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39e82806 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:390 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0029_ShipmentPlanPackPopup.txtBefore_Qty_TextChanged

진입점: this.txtBefore_Qty.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-488c68ca | this.txtBefore_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:137 | if (txtBefore_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | VALUE_SET | txtBefore_Qty.Text | string.Format("{0:#,##0}", Convert.ToInt64(strTmpText)) | 컨트롤 값 설정 |  |  |  |
| AC-a8ba351d | this.txtBefore_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:137 | if (txtBefore_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | CALL_EXT | Convert.ToInt64 | (strTmpText) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0029_ShipmentPlanPackPopup.txtChange_Qty_KeyPress

진입점: this.txtChange_Qty.KeyPress

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11d9f5b8 | this.txtChange_Qty.KeyPress | SSP0029_ShipmentPlanPackPopup.cs:66 |  | CALL_EXT | char.IsDigit | (e.KeyChar) | ⚠ 의미 확인 필요 |  |  |  |
| AC-523a99cf | this.txtChange_Qty.KeyPress | SSP0029_ShipmentPlanPackPopup.cs:66 |  | CALL_EXT | Convert.ToChar | (Keys.Back) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7673178c | this.txtChange_Qty.KeyPress | SSP0029_ShipmentPlanPackPopup.cs:68 | if (!(char.IsDigit(e.KeyChar) \|\| e.KeyChar == Convert.ToChar(Keys.Back))) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |

## SSP0029_ShipmentPlanPackPopup.txtChange_Qty_TextChanged

진입점: this.txtChange_Qty.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-891cd89f | this.txtChange_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:147 |  | CALL_EXT | txtChange_Qty.Text.Replace(",", "").ToCharArray | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac7cfbba | this.txtChange_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:155 | foreach (char aChar in entereddata.AsEnumerable()) ▸ else of (intLengthCnt == 0 && aChar == '-') | CALL_EXT | Char.IsDigit | (aChar) | ⚠ 의미 확인 필요 |  |  |  |
| AC-254306cd | this.txtChange_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:163 | foreach (char aChar in entereddata.AsEnumerable()) ▸ else of (intLengthCnt == 0 && aChar == '-') ▸ else of (Char.IsDigit(aChar)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { actualdata }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-21579e05 | this.txtChange_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:164 | foreach (char aChar in entereddata.AsEnumerable()) ▸ else of (intLengthCnt == 0 && aChar == '-') ▸ else of (Char.IsDigit(aChar)) | VALUE_SET | txtChange_Qty.Text | strDivision + string.Format("{0:#,##0}", Convert.ToInt64(actualdata.Substring(0, actualdat… | 컨트롤 값 설정 |  |  |  |
| AC-804460dd | this.txtChange_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:164 | foreach (char aChar in entereddata.AsEnumerable()) ▸ else of (intLengthCnt == 0 && aChar == '-') ▸ else of (Char.IsDigit(aChar)) | CALL_EXT | Convert.ToInt64 | (actualdata.Substring(0, actualdata.Length)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-778fbda7 | this.txtChange_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:165 | foreach (char aChar in entereddata.AsEnumerable()) ▸ else of (intLengthCnt == 0 && aChar == '-') ▸ else of (Char.IsDigit(aChar)) | UI_PROP | txtChange_Qty.SelectionStart | txtChange_Qty.TextLength | 속성 SelectionStart 설정 |  |  |  |
| AC-d9604f66 | this.txtChange_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:166 | foreach (char aChar in entereddata.AsEnumerable()) ▸ else of (intLengthCnt == 0 && aChar == '-') ▸ else of (Char.IsDigit(aChar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eaf80729 | this.txtChange_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:172 | if (actualdata != "") | VALUE_SET | txtChange_Qty.Text | strDivision + string.Format("{0:#,##0}", Convert.ToInt64(actualdata)) | 컨트롤 값 설정 |  |  |  |
| AC-6c64e42d | this.txtChange_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:172 | if (actualdata != "") | CALL_EXT | Convert.ToInt64 | (actualdata) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd2e4219 | this.txtChange_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:173 | if (actualdata != "") | UI_PROP | txtChange_Qty.SelectionStart | txtChange_Qty.TextLength | 속성 SelectionStart 설정 |  |  |  |

## SSP0029_ShipmentPlanPackPopup.txtCurrent_Qty_TextChanged

진입점: this.txtCurrent_Qty.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-762dafcc | this.txtCurrent_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:109 | if (txtCurrent_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | VALUE_SET | txtCurrent_Qty.Text | string.Format("{0:#,##0}", Convert.ToInt64(strTmpText)) | 컨트롤 값 설정 |  |  |  |
| AC-132c83f5 | this.txtCurrent_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:109 | if (txtCurrent_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | CALL_EXT | Convert.ToInt64 | (strTmpText) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0029_ShipmentPlanPackPopup.txtGap_Qty_TextChanged

진입점: this.txtGap_Qty.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b7c25d9 | this.txtGap_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:123 | if (txtGap_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | VALUE_SET | txtGap_Qty.Text | string.Format("{0:#,##0}", Convert.ToInt64(strTmpText)) | 컨트롤 값 설정 |  |  |  |
| AC-b5d56113 | this.txtGap_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:123 | if (txtGap_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | CALL_EXT | Convert.ToInt64 | (strTmpText) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0029_ShipmentPlanPackPopup.txtProd_Qty_TextChanged

진입점: this.txtProd_Qty.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d0ac656 | this.txtProd_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:96 | if (txtProd_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | VALUE_SET | txtProd_Qty.Text | string.Format("{0:#,##0}", Convert.ToInt64(strTmpText)) | 컨트롤 값 설정 |  |  |  |
| AC-d78f009e | this.txtProd_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:96 | if (txtProd_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | CALL_EXT | Convert.ToInt64 | (strTmpText) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0029_ShipmentPlanPackPopup.txtWHin_Qty_TextChanged

진입점: this.txtWHin_Qty.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c3af943 | this.txtWHin_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:83 | if (txtWHin_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | VALUE_SET | txtWHin_Qty.Text | string.Format("{0:#,##0}", Convert.ToInt64(strTmpText)) | 컨트롤 값 설정 |  |  |  |
| AC-3412cc72 | this.txtWHin_Qty.TextChanged | SSP0029_ShipmentPlanPackPopup.cs:83 | if (txtWHin_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | CALL_EXT | Convert.ToInt64 | (strTmpText) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0029_ShipmentPlanPackPopup.Validation_Check

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save) ▸ try] / SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e936e7cf | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:412 | if (strChangeQty == strCurrenQty) ▸ if (rtxComments.Text.Trim() == Comments.Trim()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00017", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-890b28b5 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:413 | if (strChangeQty == strCurrenQty) ▸ if (rtxComments.Text.Trim() == Comments.Trim()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e1b8918d | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0029_ShipmentPlanPackPopup.cs:417 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

