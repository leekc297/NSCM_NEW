# AS-IS 액션 대조표 — SSP0021

> 원천: `Doc/asisfacts/screens/SSP0021/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1129행 · 메서드 70 · 종류 DATA_OP 378 · GRID_SET 121 · UI_PROP 118 · GRID_INIT 88 · RETURN 71 · FLAG 62 · ENDPOINT 59 · MESSAGE 46 · POPUP 35 · CALL_EXT 24 · UI_MISC 23 · GRID_LOCK 23 · GRID_STYLE 18 · COMBO_DATA 13 · LIST_REBIND 11 · VALUE_SET 9 · VALUE_CLEAR 8 · GRID_BIND 8 · VALIDATE 5 · STATE_RESET 4 · CALL_BASE 4 · LIST_CLEAR 1 · ⚠ 의미 확인 필요 28


## SSP0021_ShipmentPlan.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fe188d1 | this.btnItemId.Click | SSP0021_ShipmentPlan.cs:2502 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-30587746 | this.btnItemId.Click | SSP0021_ShipmentPlan.cs:2504 |  | POPUP | popItem.Form_Load | (true, sDivision_ID, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c197d783 | this.btnItemId.Click | SSP0021_ShipmentPlan.cs:2505 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e2db1f9f | this.btnItemId.Click | SSP0021_ShipmentPlan.cs:2506 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6d4d5478 | this.btnItemId.Click | SSP0021_ShipmentPlan.cs:2512 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0021_ShipmentPlan.BtnItemID2_Click

진입점: this.btnItemID2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-027e4c34 | this.btnItemID2.Click | SSP0021_ShipmentPlan.cs:991 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-698a6e06 | this.btnItemID2.Click | SSP0021_ShipmentPlan.cs:993 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-a592dc1f | this.btnItemID2.Click | SSP0021_ShipmentPlan.cs:994 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a77e3164 | this.btnItemID2.Click | SSP0021_ShipmentPlan.cs:995 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-264c2509 | this.btnItemID2.Click | SSP0021_ShipmentPlan.cs:1001 | if (popItem.ItemID != "") | VALUE_SET | txtModel2.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0021_ShipmentPlan.BtnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dba60d60 | this.btnMeasure.Click | SSP0021_ShipmentPlan.cs:1900 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7aabd397 | this.btnMeasure.Click | SSP0021_ShipmentPlan.cs:1905 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2da17726 | this.btnMeasure.Click | SSP0021_ShipmentPlan.cs:1906 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-623709b3 | this.btnMeasure.Click | SSP0021_ShipmentPlan.cs:1911 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de7405e2 | this.btnMeasure.Click | SSP0021_ShipmentPlan.cs:1912 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-813b5843 | this.btnMeasure.Click | SSP0021_ShipmentPlan.cs:1915 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0021", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-ac645fb3 | this.btnMeasure.Click | SSP0021_ShipmentPlan.cs:1916 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0f20acfb | this.btnMeasure.Click | SSP0021_ShipmentPlan.cs:1917 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bdf0752f | this.btnMeasure.Click | SSP0021_ShipmentPlan.cs:1921 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-c5a295fd | this.btnMeasure.Click | SSP0021_ShipmentPlan.cs:1933 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SSP0021_ShipmentPlan.BtnRequestor_Click

진입점: this.btnRequestor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e2cec4a | this.btnRequestor.Click | SSP0021_ShipmentPlan.cs:2102 |  | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-dd984a1f | this.btnRequestor.Click | SSP0021_ShipmentPlan.cs:2104 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-0af42ef0 | this.btnRequestor.Click | SSP0021_ShipmentPlan.cs:2105 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-935806d3 | this.btnRequestor.Click | SSP0021_ShipmentPlan.cs:2106 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7a43a15b | this.btnRequestor.Click | SSP0021_ShipmentPlan.cs:2107 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-d944ec1d | this.btnRequestor.Click | SSP0021_ShipmentPlan.cs:2108 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-3a9338e6 | this.btnRequestor.Click | SSP0021_ShipmentPlan.cs:2110 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-763bc138 | this.btnRequestor.Click | SSP0021_ShipmentPlan.cs:2112 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7677742e | this.btnRequestor.Click | SSP0021_ShipmentPlan.cs:2118 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sRequestor | item.UserID | 화면 필드/플래그 변경 |  |  |  |
| AC-bf5f26eb | this.btnRequestor.Click | SSP0021_ShipmentPlan.cs:2122 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName | 컨트롤 값 설정 |  |  |  |
| AC-9d3d588b | this.btnRequestor.Click | SSP0021_ShipmentPlan.cs:2126 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName_E | 컨트롤 값 설정 |  |  |  |

## SSP0021_ShipmentPlan.BtnSearch_Click

진입점: this.btnSearch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdfe8678 | this.btnSearch.Click | SSP0021_ShipmentPlan.cs:6003 | if (spdDetail.ActiveSheetIndex == 0) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-27371f16 | this.btnSearch.Click | SSP0021_ShipmentPlan.cs:6004 | if (spdDetail.ActiveSheetIndex == 0) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtPlanDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0038de20 | this.btnSearch.Click | SSP0021_ShipmentPlan.cs:6007 | if (spdDetail.ActiveSheetIndex == 0) | FLAG | this.bDetail_Search | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ca986767 | this.btnSearch.Click | SSP0021_ShipmentPlan.cs:6011 | else of (spdDetail.ActiveSheetIndex == 0) ▸ if (spdDetail.ActiveSheetIndex == 1) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4455ce6 | this.btnSearch.Click | SSP0021_ShipmentPlan.cs:6012 | else of (spdDetail.ActiveSheetIndex == 0) ▸ if (spdDetail.ActiveSheetIndex == 1) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-77131da4 | this.btnSearch.Click | SSP0021_ShipmentPlan.cs:6018 | else of (spdDetail.ActiveSheetIndex == 0) ▸ else of (spdDetail.ActiveSheetIndex == 1) ▸ if (spdDetail.ActiveSheetIndex == 2) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtoWMSDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d4cfdb9a | this.btnSearch.Click | SSP0021_ShipmentPlan.cs:6019 | else of (spdDetail.ActiveSheetIndex == 0) ▸ else of (spdDetail.ActiveSheetIndex == 1) ▸ if (spdDetail.ActiveSheetIndex == 2) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtoWMSDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-afe8e13b | this.btnSearch.Click | SSP0021_ShipmentPlan.cs:6033 | if (spdDetail.ActiveSheetIndex == 3) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMESStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c5957a2 | this.btnSearch.Click | SSP0021_ShipmentPlan.cs:6034 | if (spdDetail.ActiveSheetIndex == 3) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMESStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-800212a1 | this.btnSearch.Click | SSP0021_ShipmentPlan.cs:6037 | if (spdDetail.ActiveSheetIndex == 3) | FLAG | this.bDetail_Search | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9126a7e3 | this.btnSearch.Click | SSP0021_ShipmentPlan.cs:6041 | if (spdDetail.ActiveSheetIndex == 4) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMESStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-07da6d15 | this.btnSearch.Click | SSP0021_ShipmentPlan.cs:6042 | if (spdDetail.ActiveSheetIndex == 4) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMESStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ce6c5955 | this.btnSearch.Click | SSP0021_ShipmentPlan.cs:6045 | if (spdDetail.ActiveSheetIndex == 4) | FLAG | this.bDetail_Search | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b7fa6a70 | this.btnSearch.Click | SSP0021_ShipmentPlan.cs:6049 | else of (spdDetail.ActiveSheetIndex == 4) ▸ if (spdDetail.ActiveSheetIndex == 5) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-54e211cf | this.btnSearch.Click | SSP0021_ShipmentPlan.cs:6050 | else of (spdDetail.ActiveSheetIndex == 4) ▸ if (spdDetail.ActiveSheetIndex == 5) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentResult) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0021_ShipmentPlan.CalculateSum

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a9135e4 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:5637 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f605e78 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:5641 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-f2d1be07 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:5685 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-8f6b0979 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:5689 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-b17a48c2 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:5703 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-86f2eaa5 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:5707 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-767689ea | (진입점 미연결) | SSP0021_ShipmentPlan.cs:5716 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-34dde8ee | (진입점 미연결) | SSP0021_ShipmentPlan.cs:5733 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-504d719b | (진입점 미연결) | SSP0021_ShipmentPlan.cs:5737 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-4337e385 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:5816 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-3a312d81 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:5831 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-cc16c032 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:5839 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0021_ShipmentPlan.cboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95c6a40b | cboPlanDate.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5963 | if (cboPlanDate.ControlValues != null) | DATA_OP | dtPlanDate.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d030accc | cboPlanDate.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5963 | if (cboPlanDate.ControlValues != null) ▸ lambda | DATA_OP | row.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-14f37987 | cboPlanDate.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5967 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod.Value1 | Convert.ToDateTime(dr["FROM_DATE"].ToString()) | 속성 Value1 설정 |  |  |  |
| AC-9227ccd7 | cboPlanDate.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5968 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod.Value2 | Convert.ToDateTime(dr["TO_DATE"].ToString()) | 속성 Value2 설정 |  |  |  |
| AC-a639cab3 | cboPlanDate.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5969 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod2.Value1 | Convert.ToDateTime(dr["FROM_DATE"].ToString()) | 속성 Value1 설정 |  |  |  |
| AC-2cda71de | cboPlanDate.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5970 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod2.Value2 | Convert.ToDateTime(dr["TO_DATE"].ToString()) | 속성 Value2 설정 |  |  |  |
| AC-18ce56d6 | cboPlanDate.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5978 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOr… | VALUE_CLEAR | txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-934a739f | cboPlanDate.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5979 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOr… | VALUE_CLEAR | txtModel2.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2e7fa1ab | cboPlanDate.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5980 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOr… | VALUE_CLEAR | txtRequestor.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-99cbbab7 | cboPlanDate.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5989 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (cboPlanDate.SelectedIndex == 0) | FLAG | bRealFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a252b06d | cboPlanDate.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5993 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ else of (cboPlanDate.SelectedIndex == 0) | FLAG | bRealFlag | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0021_ShipmentPlan.checkValidN

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58aee201 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:2905 | for (i <= siDetail.GetMaxRowIndex()) ▸ if (intORG_FROM_YYYYMMDD > intORG_TO_YYYYMMDD) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-03219b52 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:2915 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-151df158 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:2918 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.ChkConfirmChangeTime

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ if (!string.IsNullOrEmpty(p_confirm_id))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b44fa34 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:6561 |  | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME") ⇒ SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME | 엔드포인트 요청 생성 |  |  |  |
| AC-de4c6042 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:6565 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-60b5edee | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:6567 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-35bee5b5 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:6572 | if (ds.Tables[0].Rows[0][0].ToString() == "S") | RETURN | return result = true; |  | 처리 중단/반환 |  |  |  |
| AC-94346a43 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:6576 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | RETURN | return result = false; |  | 처리 중단/반환 |  |  |  |
| AC-ab902a83 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:6578 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.chkERPIFBlockYn

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3bd9734 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:2927 |  | FLAG | dtERPBlockYnIF | Data_SCP.Common(Data_SCP.Type.SSPBlockCheckIF, false, "SSP0021") | 화면 필드/플래그 변경 |  |  |  |
| AC-ba67a193 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:2927 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSPBlockCheckIF, false, "SSP0021") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-689f7a0b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:2930 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("BLOCK_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-c97e9e8a | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:2939 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("PERIOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-00213ad7 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:2940 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00267", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1ab1de3b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:2944 |  | RETURN | return resultYn; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.clbCompanyID_SelectedIndexChanged

진입점: clbCompany_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-013bdf4f | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5916 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_GET_SHIPMENT_FROM_SITE") ⇒ SSP.SSP0021_GET_SHIPMENT_FROM_SITE | 엔드포인트 요청 생성 |  |  |  |
| AC-12c8bbad | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5920 |  | DATA_OP | request.Parameters["Param1"] | strSelDivision_ID | 행/컬럼 값 대입 |  |  |  |
| AC-d7ad3ccc | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5921 |  | DATA_OP | request.Parameters["Param2"] | strSelCompany_ID!=null? strSelCompany_ID:"" | 행/컬럼 값 대입 |  |  |  |
| AC-449227f3 | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5922 |  | DATA_OP | request.Parameters["Param3"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b3a00b39 | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5923 |  | DATA_OP | request.Parameters["Param4"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-49b8bf9c | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5924 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a735d3a3 | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5927 |  | FLAG | dtFromSite | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-4eff0e4d | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5929 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3eafeaf2 | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5934 |  | FLAG | dtPlanDate | Data_SCP.Common(Data_SCP.Type.Plan_Infor, false, strSelCompany_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-07b12b58 | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5934 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Plan_Infor, false, strSelCompany_ID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4726c1ae | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5935 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-059c314c | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5936 |  | VALUE_CLEAR | cboPlanDate.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-4a15bb70 | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5945 |  | VALUE_CLEAR | txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-bcfca907 | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5946 |  | VALUE_CLEAR | txtModel2.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1842c298 | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5947 |  | VALUE_CLEAR | txtRequestor.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e3a4b65c | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5948 |  | UI_PROP | drpPeriod.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-f57d29ba | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5949 |  | UI_PROP | drpPeriod.Text2 | "" | 속성 Text2 설정 |  |  |  |
| AC-b5f919ae | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5950 |  | UI_PROP | drpPeriod2.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-fd07b21d | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5951 |  | UI_PROP | drpPeriod2.Text2 | "" | 속성 Text2 설정 |  |  |  |
| AC-5350108f | clbCompany_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5955 | if (cboPlanDate.Items.Count > 0) | VALUE_SET | cboPlanDate.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SSP0021_ShipmentPlan.clbDivision_ID_SelectedIndexChanged

진입점: clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b8c4ae0 | clbDivision_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5883 |  | DATA_OP | dtCompany.Select().Where(c => c["DIVISION_ID"].ToString() == strSelDivision_ID).CopyToData… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8c4eaa2a | clbDivision_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5883 |  | DATA_OP | dtCompany.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-69214ce3 | clbDivision_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5884 |  | LIST_REBIND | clsCtrl.setListBox | (dtDiv_Company_ID, clbCompany_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-abb9702d | clbDivision_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5890 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | FLAG | sUserCompany_NM | (tUserCompany_NM != sUserCompany_NM) ? tUserCompany_NM : sUserCompany_NM | 화면 필드/플래그 변경 |  |  |  |
| AC-b068de6d | clbDivision_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5892 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | CALL_EXT | clbCompany_ID.FindString | (sUserCompany_NM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-637a28a6 | clbDivision_ID.SelectedIndexChanged | SSP0021_ShipmentPlan.cs:5893 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | VALUE_SET | clbCompany_ID.SelectedIndex | intComIdx | 컨트롤 값 설정 |  |  |  |

## SSP0021_ShipmentPlan.ControlClear

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b148ce0c | (진입점 미연결) | SSP0021_ShipmentPlan.cs:530 |  | CALL_EXT | clbCompany_ID.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4fc2f667 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:531 |  | LIST_CLEAR | clbPlantSite.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-eb399534 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:534 |  | CALL_EXT | cboPlanDate.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-33100e30 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:535 |  | UI_PROP | drpPeriod.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-ff250f23 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:536 |  | UI_PROP | drpPeriod.Text2 | "" | 속성 Text2 설정 |  |  |  |
| AC-5eb79836 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:537 |  | UI_PROP | drpPeriod2.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-3e5eec05 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:538 |  | UI_PROP | drpPeriod2.Text2 | "" | 속성 Text2 설정 |  |  |  |

## SSP0021_ShipmentPlan.Convert_Requestor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d20f6a99 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:5582 | if (string.IsNullOrWhiteSpace(this.txtRequestor.Text.Trim())) | RETURN | return strCVT_Requestor; |  | 처리 중단/반환 |  |  |  |
| AC-42ee7098 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:5602 |  | RETURN | return strCVT_Requestor; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1f6d4f7 | this.Load | SSP0021_ShipmentPlan.cs:544 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-de69ea79 | this.Load | SSP0021_ShipmentPlan.cs:545 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-aaf20922 | this.Load | SSP0021_ShipmentPlan.cs:548 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtPlanDetail, SpdSheet.shtPlanDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3916fe29 | this.Load | SSP0021_ShipmentPlan.cs:549 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtStockDetail, SpdSheet.shtStockDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f1500300 | this.Load | SSP0021_ShipmentPlan.cs:550 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtoWMSDetail, SpdSheet.shtoWMSDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-de12d922 | this.Load | SSP0021_ShipmentPlan.cs:556 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtMESStock, SpdSheet.shtMESStock, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0e556997 | this.Load | SSP0021_ShipmentPlan.cs:557 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtMESStockDetail, SpdSheet.shtMESStockDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f13f50d4 | this.Load | SSP0021_ShipmentPlan.cs:559 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtShipmentResult, SpdSheet.shtShipmentResult, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9e1c42eb | this.Load | SSP0021_ShipmentPlan.cs:561 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtPlanDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-4aef30bb | this.Load | SSP0021_ShipmentPlan.cs:562 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5d3d2d42 | this.Load | SSP0021_ShipmentPlan.cs:565 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtStockDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-6af56dce | this.Load | SSP0021_ShipmentPlan.cs:566 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b89faa1 | this.Load | SSP0021_ShipmentPlan.cs:569 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtoWMSDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-c37b375f | this.Load | SSP0021_ShipmentPlan.cs:570 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtoWMSDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a33a376f | this.Load | SSP0021_ShipmentPlan.cs:582 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtMESStock) | 화면 필드/플래그 변경 |  |  |  |
| AC-285ddd07 | this.Load | SSP0021_ShipmentPlan.cs:583 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMESStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e516f530 | this.Load | SSP0021_ShipmentPlan.cs:586 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtMESStockDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-41dc7b3d | this.Load | SSP0021_ShipmentPlan.cs:587 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMESStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-675e0aa3 | this.Load | SSP0021_ShipmentPlan.cs:590 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtShipmentResult) | 화면 필드/플래그 변경 |  |  |  |
| AC-a67eca41 | this.Load | SSP0021_ShipmentPlan.cs:591 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-79fce89a | this.Load | SSP0021_ShipmentPlan.cs:594 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c0b4efd | this.Load | SSP0021_ShipmentPlan.cs:598 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0021_ShipmentPlan.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a08b1b7 | this.Load | SSP0021_ShipmentPlan.cs:396 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-46fad315 | this.Load | SSP0021_ShipmentPlan.cs:398 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-8ca51a84 | this.Load | SSP0021_ShipmentPlan.cs:399 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-c42d01db | this.Load | SSP0021_ShipmentPlan.cs:400 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-34aad215 | this.Load | SSP0021_ShipmentPlan.cs:402 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SSP0021_ShipmentPlan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-912e72a3 | Dispose | SSP0021_ShipmentPlan.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0021_ShipmentPlan.DrpPeriod2_ValueChanged

진입점: this.drpPeriod2.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82eb4f50 | this.drpPeriod2.ValueChanged | SSP0021_ShipmentPlan.cs:1947 | if (intDiff1 > 0 \|\| intDiff2 > 0) | UI_PROP | drpPeriod2.Value1 | drpPeriod.Value1 | 속성 Value1 설정 |  |  |  |
| AC-cdb4edb3 | this.drpPeriod2.ValueChanged | SSP0021_ShipmentPlan.cs:1948 | if (intDiff1 > 0 \|\| intDiff2 > 0) | UI_PROP | drpPeriod2.Value2 | drpPeriod.Value2 | 속성 Value2 설정 |  |  |  |
| AC-4c07db0b | this.drpPeriod2.ValueChanged | SSP0021_ShipmentPlan.cs:1950 | if (intDiff1 > 0 \|\| intDiff2 > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7de5be9e | EditButton | SSP0021_ShipmentPlan.cs:2369 | if (isOK == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00251", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f1b840f2 | EditButton | SSP0021_ShipmentPlan.cs:2370 | if (isOK == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-97f60e96 | EditButton | SSP0021_ShipmentPlan.cs:2377 | if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ba2f42d2 | EditButton | SSP0021_ShipmentPlan.cs:2378 | if (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-390f9987 | EditButton | SSP0021_ShipmentPlan.cs:2399 | if (fps.Name == "spdMain") ▸ if (bEdit_Auth == true) ▸ if (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain.Shee… | GRID_LOCK | siMain.LockRange | (i, j, i, j, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f6c679a1 | EditButton | SSP0021_ShipmentPlan.cs:2404 | if (fps.Name == "spdMain") ▸ if (bEdit_Auth == true) ▸ if (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain.Shee… | GRID_LOCK | siMain.LockRange | (i, j, i, j, true, ControlColor.DefaultForeColor, Color.FromArgb(242, 242, 242)) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ae3cefc8 | EditButton | SSP0021_ShipmentPlan.cs:2414 | if (fps.Name == "spdMain") ▸ if (bEdit_Auth == true) ▸ if (bEdit_Mode == false) | FLAG | bEdit_Mode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7cc86659 | EditButton | SSP0021_ShipmentPlan.cs:2435 | if (fps.Name == "spdMain") ▸ if (bEdit_Auth == true) ▸ else of (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain… | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-62a8ecb7 | EditButton | SSP0021_ShipmentPlan.cs:2441 | if (fps.Name == "spdMain") ▸ if (bEdit_Auth == true) ▸ else of (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, i, siMain.ActiveSheet.ColumnCount - 1, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-29d5a6c3 | EditButton | SSP0021_ShipmentPlan.cs:2443 | if (fps.Name == "spdMain") ▸ if (bEdit_Auth == true) ▸ else of (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, i, siMain.Activ… | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |
| AC-f80d5469 | EditButton | SSP0021_ShipmentPlan.cs:2448 | if (fps.Name == "spdMain") ▸ if (bEdit_Auth == true) ▸ else of (bEdit_Mode == false) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-19757b59 | EditButton | SSP0021_ShipmentPlan.cs:2457 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bRealFlag == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00312", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a59725c3 | EditButton | SSP0021_ShipmentPlan.cs:2458 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bRealFlag == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c80f02f | EditButton | SSP0021_ShipmentPlan.cs:2461 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") | FLAG | siDetail | GetSheetInfo(spdDetail.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-df8f9716 | EditButton | SSP0021_ShipmentPlan.cs:2462 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e74be571 | EditButton | SSP0021_ShipmentPlan.cs:2473 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (i < si… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColumns.REQUE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f0b743de | EditButton | SSP0021_ShipmentPlan.cs:2474 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (i < si… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.REMARKS3), siDetail.GetColumnIndex(DefColumns.MODEL_US… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c1eccef6 | EditButton | SSP0021_ShipmentPlan.cs:2476 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (i < si… | GRID_LOCK | siDetail.LockRange2 | (i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), i, siDetail.GetColumnIndex(D… | 그리드 편집 잠금 전환 |  |  |  |
| AC-eeef1647 | EditButton | SSP0021_ShipmentPlan.cs:2481 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (i < si… | GRID_LOCK | siDetail.LockRange2 | (i, 0, i, siDetail.GetMaxColumnIndex(), true, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-b517f468 | EditButton | SSP0021_ShipmentPlan.cs:2487 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColumns.HOLD_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-68625050 | EditButton | SSP0021_ShipmentPlan.cs:2488 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siDetail.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0021_ShipmentPlan.FindData_Detail

진입점: this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] / this.spdMain.CellDoubleClick [if (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…)] / SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (bDetail_Search == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82e2fa5d | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4807 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8039f352 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4812 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0b61e074 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4872 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-fa0219c4 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4877 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL") ⇒ SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-f249d035 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4878 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0c0e3996 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4879 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-279cadf0 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4880 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-59599ed4 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4881 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-df9a46d6 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4882 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e7ab4379 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4883 | try | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-8282bc20 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4884 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d2bb7e84 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4885 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-30bb8c5e | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4886 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3185c464 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4887 | try | DATA_OP | request.Parameters["p_dbl_flag"] | p_dbl_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e7fd9406 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4888 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-947d07bc | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4889 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-d0fc1338 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4890 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-7db456bd | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4891 | try | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-7da021dd | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4892 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-2cd37a51 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4895 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-74e951e7 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4904 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ff0eb8ce | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4905 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-004b8e6f | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4910 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-b5f8c898 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4912 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-ff268c3a | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4912 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-296cfe81 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4915 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cd129505 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0021_ShipmentPlan.cs:4932 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0021_ShipmentPlan.FindData_hold_stock

진입점: this.spdMain.CellDoubleClick [else of (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…)] / SaveButton [if (siDetail != null && si…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfad8a80 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5233 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4f5b493e | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5239 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5bcf82dd | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5244 | try ▸ if (bolDoubleClick == true) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtHoldStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-09226354 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5245 | try ▸ if (bolDoubleClick == true) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtHoldStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-36fe5931 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5253 | try ▸ else of (bolDoubleClick == true) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtHoldStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-abe4a74d | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5254 | try ▸ else of (bolDoubleClick == true) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtHoldStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-930508d2 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5278 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-11018aa8 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5283 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_GET_HOLD_STOCK") ⇒ SSP.SSP0021_GET_HOLD_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-da459a73 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5284 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3973bbbf | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5286 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c26ca28d | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5287 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-da86b9d1 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5288 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-57eb0dcc | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5289 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-2fab413a | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5290 | try | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-55f91304 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5291 | try | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-5511d9d3 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5292 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-7d752f96 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5293 | try | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-9d2c5bb6 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5294 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-73674448 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5296 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a57dfd4f | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5305 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-587b1ac1 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5306 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3d02ec3a | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5309 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6351c22f | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5319 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (intRowIdx, intColIdx) | 그리드 표시 설정 |  |  |  |
| AC-998477ab | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0021_ShipmentPlan.cs:5324 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0021_ShipmentPlan.FindData_Main

진입점: FindButton / SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet.RowCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be971d2e | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4540 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-aa7118a8 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4545 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-c685938a | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4545 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5fb2e9dc | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4553 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b6b07941 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4554 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-3e0a6c0f | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4554 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0049e769 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4593 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-65a08869 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4594 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4ff03909 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4598 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_GET_SHIPMENT_PLAN") ⇒ SSP.SSP0021_GET_SHIPMENT_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-8e0248ab | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4600 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bc88f9d3 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4602 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-47c2a692 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4603 | try ▸ lambda | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-a7f7dc32 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4604 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-ba479110 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4605 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ee22fdd4 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4606 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-97138d4d | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4607 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d969dd03 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4608 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-77df9541 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4609 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-45ebfcdf | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4610 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-908a566b | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4611 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-782b7a96 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4612 | try ▸ lambda | DATA_OP | req.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ca6d7573 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4614 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-963a9fe8 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4615 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4b4946e0 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4627 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-625639c9 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4628 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-06f69ace | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4639 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d2fe8cd9 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4650 | try ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sMeasure == "SHIP_PLAN") | UI_PROP | range1.BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 속성 BackColor 설정 |  |  |  |
| AC-f7b3eb84 | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4659 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0df0165d | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4667 | finally | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5aad28ce | FindButton 외 1 | SSP0021_ShipmentPlan.cs:4669 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0021_ShipmentPlan.FindData_MES_stock

진입점: this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] / this.spdMain.CellDoubleClick [else of (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIn…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c36aebee | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5332 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0d8a9940 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5337 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-bd787f1f | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5377 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-6d5d9cb0 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5382 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_GET_MES_STOCK") ⇒ SSP.SSP0021_GET_MES_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-3df54805 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5383 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ff0f2d9c | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5384 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6fb3aeaf | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5385 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-b04c2e12 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5386 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-8938e3b1 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5387 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-eba1a568 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5388 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a64f6597 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5389 | try | DATA_OP | request.Parameters["p_dbl_flag"] | p_dbl_flag | 행/컬럼 값 대입 |  |  |  |
| AC-7c157e0c | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5390 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-56d938f5 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5391 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-641c494b | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5392 | try | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-461d13cd | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5393 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-13198bc6 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5395 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8a9535e5 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5404 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f06d7d34 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5405 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7d2d1cc4 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5408 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d78a2cb6 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0021_ShipmentPlan.cs:5422 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0021_ShipmentPlan.FindData_MES_stock_Detail

진입점: this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] / this.spdMain.CellDoubleClick [else of (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIn…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6da474e9 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5429 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3f0e57c7 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5434 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f79647bf | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5477 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ed9af36e | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5482 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_GET_MES_STOCK_DETAIL") ⇒ SSP.SSP0021_GET_MES_STOCK_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-f087803e | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5483 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d0d8d867 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5484 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-fc7e2caf | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5485 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-538df2fc | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5486 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-fa13b33a | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5487 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-48620a88 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5488 | try | DATA_OP | request.Parameters["p_box_id"] | p_box_id | 행/컬럼 값 대입 |  |  |  |
| AC-463dfa47 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5489 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7e952019 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5490 | try | DATA_OP | request.Parameters["p_dbl_flag"] | p_dbl_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d846a804 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5491 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-e434a573 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5492 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-3a478546 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5493 | try | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-f9d73ba5 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5494 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-14b53b90 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5496 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7c952b70 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5505 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b345c4ba | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5506 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-06da741a | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5509 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-279df1e4 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0021_ShipmentPlan.cs:5523 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0021_ShipmentPlan.FindData_oWMS_Detail

진입점: this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex == 0) ▸ else of (spdDetail.ActiveSheetIndex == 1) ▸ if (spdDetail.ActiveSheetIndex == 2)] / this.spdMain.CellDoubleClick [else of (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc66df4c | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5037 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5d1281f5 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5042 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-40d4fb6f | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5082 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b2dfe794 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5087 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_GET_OWMS_DETAIL") ⇒ SSP.SSP0021_GET_OWMS_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-986f1eb5 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5088 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-da3fdc1d | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5089 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b5dfeb48 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5090 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-3e0d8df1 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5091 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-b62d954a | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5092 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-eb24f0a6 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5093 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d715a7be | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5094 | try | DATA_OP | request.Parameters["p_dbl_flag"] | p_dbl_flag | 행/컬럼 값 대입 |  |  |  |
| AC-cbf2402c | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5095 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-7ccd39a3 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5096 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-7d4ba1dc | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5097 | try | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-1e1d739b | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5098 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-2b26396e | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5100 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c4f2e1eb | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5109 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a36a3add | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5110 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cf2b8696 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5113 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d63469cf | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5127 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0021_ShipmentPlan.FindData_Shipment_Result

진입점: this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex == 4) ▸ if (spdDetail.ActiveSheetIndex == 5)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfe88ac9 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5133 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6a7de74e | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5138 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c74110fc | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5175 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-57918cbc | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5180 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_GET_SHIPMENT_RESULT") ⇒ SSP.SSP0021_GET_SHIPMENT_RESULT | 엔드포인트 요청 생성 |  |  |  |
| AC-0bfe561c | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5181 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-92aa93e2 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5182 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa12260d | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5183 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-a6b70c40 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5184 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0a90c4cb | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5185 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-86ab045f | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5186 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f0b5f5a3 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5187 | try | DATA_OP | request.Parameters["p_type"] | p_type | 행/컬럼 값 대입 |  |  |  |
| AC-643edddc | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5188 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b4220589 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5189 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-d6e4b514 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5190 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-4ca764c2 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5191 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-e042d061 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5192 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-4e807737 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5193 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-8c4cd904 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5194 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-22c69d0b | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5195 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b0673923 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5196 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-691754e5 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5198 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1226a13b | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5207 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-457c6e85 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5208 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4891eafc | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5211 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c310f086 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0021_ShipmentPlan.cs:5226 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0021_ShipmentPlan.FindData_Stock_Detail

진입점: this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex == 0) ▸ if (spdDetail.ActiveSheetIndex == 1)] / this.spdMain.CellDoubleClick [else of (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ffcfbd4 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:4939 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-39e655bd | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:4944 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9f460c48 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:4985 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-637cf001 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:4990 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_GET_STOCK_LOCATION_DETAIL") ⇒ SSP.SSP0021_GET_STOCK_LOCATION_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-44eec2c3 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:4991 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2aab606d | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:4992 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-fe75fffd | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:4993 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-f162e86f | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:4994 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-9db4d583 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:4995 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3529ad9f | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:4996 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-604e89b2 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:4997 | try | DATA_OP | request.Parameters["p_dbl_flag"] | p_dbl_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6454614e | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:4998 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-6c36cb41 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:4999 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-019384bc | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5000 | try | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-eec1e061 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5001 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-5c498dad | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5003 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8f30d48d | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5012 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cedc8dfd | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5013 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dcaef3f5 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5016 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-42f1a6f3 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0021_ShipmentPlan.cs:5030 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0021_ShipmentPlan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f899fd4a | this.Load | SSP0021_ShipmentPlan.cs:301 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-97a4d516 | this.Load | SSP0021_ShipmentPlan.cs:310 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | VALUE_CLEAR | clbCompany_ID.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-282574c1 | this.Load | SSP0021_ShipmentPlan.cs:311 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | CALL_EXT | clbCompany_ID.FindString | (sUserCompany_NM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f8b91034 | this.Load | SSP0021_ShipmentPlan.cs:312 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | VALUE_SET | clbCompany_ID.SelectedIndex | intComIdx | 컨트롤 값 설정 |  |  |  |

## SSP0021_ShipmentPlan.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c49139ab | this.Load | SSP0021_ShipmentPlan.cs:4513 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-00d8fce4 | this.Load | SSP0021_ShipmentPlan.cs:4514 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9cbc9efb | this.Load | SSP0021_ShipmentPlan.cs:4517 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.GetErpIFCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35474544 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:3932 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7e2a3ac | (진입점 미연결) | SSP0021_ShipmentPlan.cs:3941 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-138e61e8 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:3942 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-37b610eb | (진입점 미연결) | SSP0021_ShipmentPlan.cs:3943 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-319ef58f | (진입점 미연결) | SSP0021_ShipmentPlan.cs:3945 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b5200d2d | (진입점 미연결) | SSP0021_ShipmentPlan.cs:3956 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f866bb5 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:3963 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d12cbe48 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:3968 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (service.RtFlag == "C_E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-29b2ada5 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:3979 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.GetErpIFCheckNew

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!string.IsNullOrWhiteSpace(sRequestNo))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b33b6152 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:3991 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4dae4970 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4000 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (service.ReErrorMsg.EndsWith("^")) | UI_PROP | service.ReErrorMsg | service.ReErrorMsg.Substring(0, service.ReErrorMsg.Length - 1) | 속성 ReErrorMsg 설정 |  |  |  |
| AC-3b0e2ecc | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4007 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ for (iCount < arrReMsg.Length) | DATA_OP | errConfirmList.Add | (arrReMsg[iCount] + ":" + RequestNo) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0d9245b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4011 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ for (iCount < arrReMsg.Length) | DATA_OP | errConfrimList2.Add | (arrConfirm[0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a1bdb18 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4019 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM") ⇒ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-945ff75a | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4021 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-6fb1523b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4022 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-262240d3 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4023 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-9fb9ea5e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4024 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2e52736c | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4025 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-24ae7e60 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4026 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_if_send_flag"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-690f7380 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4027 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-3d5c75b8 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4029 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-62386ef3 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4045 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH") ⇒ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-c3c3b9b0 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4047 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | DATA_OP | request.Parameters["p_change_type"] | "B" | 행/컬럼 값 대입 |  |  |  |
| AC-1417734b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4048 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | DATA_OP | request.Parameters["p_change_req_no"] | RequestNo | 행/컬럼 값 대입 |  |  |  |
| AC-bcbfa5f5 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4050 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-71e85769 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4055 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e97c60ac | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4061 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | bActiveList.Add | (bFlag) | 데이터 객체 조작/조회 |  |  |  |
| AC-462a74cf | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4066 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | FLAG | F_CE_requestNo | RequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-7e27d290 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4075 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH") ⇒ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-ac8c2e13 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4077 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_type"] | "B" | 행/컬럼 값 대입 |  |  |  |
| AC-264f2df0 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4078 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_req_no"] | RequestNo | 행/컬럼 값 대입 |  |  |  |
| AC-f3258b02 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4080 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0b49cb76 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4085 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-12ac6db1 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4088 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | bActiveList.Add | (bFlag) | 데이터 객체 조작/조회 |  |  |  |
| AC-35f24081 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:4094 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.GetErpIFCheckNew_

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07482c11 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4395 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "P", "A") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0add8bb | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4404 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-9b694ff9 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4405 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-6606e365 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4406 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-956a2907 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4408 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e0ee2b7b | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4419 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-220b1d84 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4426 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ac5c4262 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4431 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (service.RtFlag == "C_E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-136735d6 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4442 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.GetERPInterface

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29a2c854 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3225 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-338dc1e6 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3237 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | DATA_OP | (siDetail.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-78548dbf | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3243 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | MESSAGE | MessageHelper.GMessageBox | ("MSG00247", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d4360b47 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3244 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-266bb61b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3252 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3132ce1a | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3253 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1ac5608c | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3267 | try ▸ if (!string.IsNullOrEmpty(p_confirm_id)) ▸ if (!isResult) | MESSAGE | MessageHelper.GMessageBox | ("MSG00404", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-db38d3ae | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3269 | try ▸ if (!string.IsNullOrEmpty(p_confirm_id)) ▸ if (!isResult) | RETURN | return bReturn = false; |  | 처리 중단/반환 |  |  |  |
| AC-9503a840 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3352 | try ▸ if (errConfirmList.Count > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM") ⇒ SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-90d0b581 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3354 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-b8625a93 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3355 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id2 | 행/컬럼 값 대입 |  |  |  |
| AC-fd53fe71 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3356 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_e_type"] | "E" | 행/컬럼 값 대입 |  |  |  |
| AC-8b980b68 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3357 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_e_message"] | p_e_message | 행/컬럼 값 대입 |  |  |  |
| AC-37a025c4 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3358 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1d855938 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3360 | try ▸ if (errConfirmList.Count > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7f4dbc7b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3366 | try ▸ if (errConfirmList.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-33d37df0 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3393 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM") ⇒ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-c8609a9f | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3395 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id_F_CE | 행/컬럼 값 대입 |  |  |  |
| AC-f2cd311c | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3396 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_change_request_no"] | F_CE_requestNo | 행/컬럼 값 대입 |  |  |  |
| AC-ef4e57b5 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3397 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-bdd45272 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3398 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7f990fb6 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3399 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-8ecd7bb8 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3400 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_if_send_flag"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-ee5f4171 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3401 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-295ceb20 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3403 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-81a7fb6e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3409 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | CALL_EXT | service.FN_ERP_UIWebService | (F_CE_requestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bfa4b7c7 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3414 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8bb4adc3 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3419 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e720b89b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3422 | finally | STATE_RESET | bActiveList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-8b06e53d | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3423 | finally | STATE_RESET | errConfirmList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ba181503 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3424 | finally | FLAG | F_CE_requestNo | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-13b52a73 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3426 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.GetErpSoNoCnt

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-697979bc | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:3843 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_GET_ERP_SO_NO_CNT") ⇒ SSP.SSP0021_GET_ERP_SO_NO_CNT | 엔드포인트 요청 생성 |  |  |  |
| AC-15052e5c | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:3844 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-68f01552 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:3845 | try | DATA_OP | request.Parameters["p_erp_so_no"] | sErpSoNo | 행/컬럼 값 대입 |  |  |  |
| AC-e3e199b4 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:3847 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-535a829f | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:3855 | catch ((Exception ex)) | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |
| AC-d7b5da62 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0021_ShipmentPlan.cs:3857 |  | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.GetNewERPInterface

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c39231c | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4129 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo)) | DATA_OP | (siDetail.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e6baf222 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4141 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (iErpS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00247", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-41ca75a6 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4142 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (iErpS… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-506e900c | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4151 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (DateTime.TryParse(siDetail.GetText(i, siDetail.G… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6e7b2635 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4152 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (DateTime.TryParse(siDetail.GetText(i, siDetail.G… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2e254583 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4178 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (this.NewNonSoNo(i, action) == false) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6874f4e4 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4187 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-88f665f3 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4189 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.GetShipmentStatusChk

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD) ▸ if (action != CAppSetting.FlagI)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b1aeb87 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3868 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_GET_SHIPMENT_STATUS") ⇒ SSP.SSP0021_GET_SHIPMENT_STATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-567a6585 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3869 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-c30af655 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3870 | try | DATA_OP | request.Parameters["p_confirm_id"] | sConfirmID | 행/컬럼 값 대입 |  |  |  |
| AC-ffdce4af | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3872 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-44485b18 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3887 | try ▸ if (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00248", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f3830b1d | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3901 | try ▸ if (ds.Tables[1].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00249", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f3754ea0 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3916 | try ▸ if (ds.Tables[2].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00189", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-84428589 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3920 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-7a914992 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3922 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.GetSpdTitle

진입점: this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0) ▸ try] / this.spdMain.CellDoubleClick / clbCompany_ID.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged [if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOrWhiteSpace(drpPeriod.Text2))] / FindButton [try] / SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetai…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6bcc0a47 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:6063 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-89807479 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:6068 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-fc891907 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:6069 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-b7e98155 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:6071 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod2.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-9f88fc38 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:6072 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod2.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-ae946e30 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:6074 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-e810c5bc | this.Load 외 7 | SSP0021_ShipmentPlan.cs:6074 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0021_ShipmentPlan.GetSSPUserCheck

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca3f871a | EditButton | SSP0021_ShipmentPlan.cs:5850 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_USER_INFO_LIST") ⇒ SSP.SSP0002_GET_USER_INFO_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-1fd8f6c1 | EditButton | SSP0021_ShipmentPlan.cs:5854 |  | DATA_OP | request.Parameters["Search"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1f8c769f | EditButton | SSP0021_ShipmentPlan.cs:5855 |  | DATA_OP | request.Parameters["Language"] | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9684c815 | EditButton | SSP0021_ShipmentPlan.cs:5856 |  | DATA_OP | request.Parameters["SSOUserYN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-0ec667b4 | EditButton | SSP0021_ShipmentPlan.cs:5857 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-888063cb | EditButton | SSP0021_ShipmentPlan.cs:5861 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f7982bbd | EditButton | SSP0021_ShipmentPlan.cs:5865 |  | RETURN | return isResult; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2684f035 | this.Load | SSP0021_ShipmentPlan.cs:422 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c518df5d | this.Load | SSP0021_ShipmentPlan.cs:425 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-869a3955 | this.Load | SSP0021_ShipmentPlan.cs:428 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8ec97b4 | this.Load | SSP0021_ShipmentPlan.cs:429 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-65a5c07d | this.Load | SSP0021_ShipmentPlan.cs:430 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtStockDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-12da07f1 | this.Load | SSP0021_ShipmentPlan.cs:431 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtoWMSDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-40f3abc7 | this.Load | SSP0021_ShipmentPlan.cs:432 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMESStock) | 데이터 객체 조작/조회 |  |  |  |
| AC-370abaae | this.Load | SSP0021_ShipmentPlan.cs:433 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMESStockDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-1dfdefe9 | this.Load | SSP0021_ShipmentPlan.cs:435 |  | FLAG | sLanguage | UserInfoContext.Current[UserInfoProperites.Language] | 화면 필드/플래그 변경 |  |  |  |
| AC-bf3345a8 | this.Load | SSP0021_ShipmentPlan.cs:438 |  | VALUE_SET | drpPeriod3.InitValue | ShipmentResult_GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-a3eeaac5 | this.Load | SSP0021_ShipmentPlan.cs:440 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d92b9d76 | this.Load | SSP0021_ShipmentPlan.cs:441 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-de6357c4 | this.Load | SSP0021_ShipmentPlan.cs:444 |  | DATA_OP | dtPgmAuthId.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-56e8040e | this.Load | SSP0021_ShipmentPlan.cs:447 | if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-310c43ca | this.Load | SSP0021_ShipmentPlan.cs:449 |  | FLAG | dBaseDate | Convert.ToDateTime(Convert.ToDateTime(DateTime.Now).ToString()).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-d1d7012d | this.Load | SSP0021_ShipmentPlan.cs:454 | if (drPgmAuthId != null) | FLAG | bEdit_Auth | true | 화면 필드/플래그 변경 |  |  |  |
| AC-de19a21e | this.Load | SSP0021_ShipmentPlan.cs:455 | if (drPgmAuthId != null) | UI_PROP | layoutControlItem12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-5824f3f7 | this.Load | SSP0021_ShipmentPlan.cs:459 | else of (drPgmAuthId != null) | FLAG | bEdit_Auth | false | 화면 필드/플래그 변경 |  |  |  |
| AC-809ac3f2 | this.Load | SSP0021_ShipmentPlan.cs:460 | else of (drPgmAuthId != null) | UI_PROP | layoutControlItem12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ffc02152 | this.Load | SSP0021_ShipmentPlan.cs:465 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMaxShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[0]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-73e43776 | this.Load | SSP0021_ShipmentPlan.cs:466 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMinShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[1]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-7cfa4b81 | this.Load | SSP0021_ShipmentPlan.cs:467 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMaxDay | dtShipmentInputPeriod.Rows[0]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4cc82b03 | this.Load | SSP0021_ShipmentPlan.cs:468 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMinDay | dtShipmentInputPeriod.Rows[1]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-70004c25 | this.Load | SSP0021_ShipmentPlan.cs:470 |  | FLAG | sRequestor | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-42391000 | this.Load | SSP0021_ShipmentPlan.cs:475 |  | LIST_REBIND | clsCtrl.setListBox | (dtResultType, clbResultType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0b099b12 | this.Load | SSP0021_ShipmentPlan.cs:476 |  | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3d196a0d | this.Load | SSP0021_ShipmentPlan.cs:477 |  | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-919feb1a | this.Load | SSP0021_ShipmentPlan.cs:478 |  | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0021_ShipmentPlan.InitSpread

진입점: this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0) ▸ try] / this.spdMain.CellDoubleClick / clbCompany_ID.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged [if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOrWhiteSpace(drpPeriod.Text2))] / FindButton [try] / SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetai…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99de4ef1 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:608 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-fbb063de | this.Load 외 7 | SSP0021_ShipmentPlan.cs:609 | if (spdInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantSiteByDivision", dtFromSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-55b19b08 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:610 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-f216632d | this.Load 외 7 | SSP0021_ShipmentPlan.cs:614 | if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | clsCtrl.HeaderSpan | (siMain, 0, siMain.GetColumnIndex(DefColumns.BOH_TYPE), 3, 2, "BOH") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1b12e85 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:622 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a64d4e2d | this.Load 외 7 | SSP0021_ShipmentPlan.cs:624 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.Freeze | (0, spdInfo.GetColumnIndex(DefColumns.MEASURE)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cd32ded7 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:625 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-958f19dc | this.Load 외 7 | SSP0021_ShipmentPlan.cs:627 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.PSI].MergePolicy | MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-48233523 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:632 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-ed7dd7ff | this.Load 외 7 | SSP0021_ShipmentPlan.cs:634 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-94d63151 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:636 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | LIST_REBIND | SpreadInfo.SetComBoParam | ("CHANGE_REASON_CODE_ALL", dtChangeReasonCode) | 목록 컨트롤 재구성 |  |  |  |
| AC-7d536d93 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:638 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-90dae01e | this.Load 외 7 | SSP0021_ShipmentPlan.cs:645 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ if (spdInfo.SheetName == SpdSheet.… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f7b0fdf5 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:647 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ if (spdInfo.SheetName == SpdSheet.… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-e9df1932 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:649 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ if (spdInfo.SheetName == SpdSheet.… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-97718a78 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:656 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-fba2874e | this.Load 외 7 | SSP0021_ShipmentPlan.cs:658 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-fba14d96 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:660 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | LIST_REBIND | SpreadInfo.SetComBoParam | ("LookupCommon3", dtStockStatus) | 목록 컨트롤 재구성 |  |  |  |
| AC-ba95e318 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:662 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f4ae8904 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:696 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-21fe82bf | this.Load 외 7 | SSP0021_ShipmentPlan.cs:698 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-c880cdf2 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:700 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d0388b1b | this.Load 외 7 | SSP0021_ShipmentPlan.cs:706 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b79da6cd | this.Load 외 7 | SSP0021_ShipmentPlan.cs:708 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-76a7ad78 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:710 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4fe2b366 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:716 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-a0caf9cd | this.Load 외 7 | SSP0021_ShipmentPlan.cs:718 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-df10936a | this.Load 외 7 | SSP0021_ShipmentPlan.cs:720 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-71fccc12 | this.Load 외 7 | SSP0021_ShipmentPlan.cs:727 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_SET | siDetail.ActiveSheet.Columns["CHILD_QTY"].Width | 75 | 그리드 속성/값 설정 |  |  |  |

## SSP0021_ShipmentPlan.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (spdInfo.SheetName == SpdSheet.shtMain)] / clbCompany_ID.SelectedIndexChanged [if (spdInfo.SheetName == SpdSheet.shtMain)] / cboPlanDate.SelectedIndexChanged [if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhit…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-423e3f5b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0021_ShipmentPlan.cs:829 | if (string.IsNullOrWhiteSpace(cboPlanDate.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d6d0696 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0021_ShipmentPlan.cs:862 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-784728a0 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0021_ShipmentPlan.cs:866 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a856e06e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0021_ShipmentPlan.cs:870 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-30f0c703 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0021_ShipmentPlan.cs:877 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0fb34a7c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0021_ShipmentPlan.cs:878 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6dffc766 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0021_ShipmentPlan.cs:883 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b35763d0 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0021_ShipmentPlan.cs:884 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f0628fd3 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0021_ShipmentPlan.cs:892 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-847c0ae7 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0021_ShipmentPlan.cs:893 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c10bd70d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0021_ShipmentPlan.cs:903 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a5b5b51 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0021_ShipmentPlan.cs:904 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b32861ca | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0021_ShipmentPlan.cs:905 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2558800d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0021_ShipmentPlan.cs:906 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0021_ShipmentPlan.InitSpreadFooterSum

진입점: this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail)] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0) ▸ try ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail)] / this.spdMain.CellDoubleClick [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlan…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cce2f99 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0021_ShipmentPlan.cs:771 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c89baacd | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0021_ShipmentPlan.cs:772 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-0b364d1d | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0021_ShipmentPlan.cs:818 | for (iCol <= siDetail.GetMaxColumnIndex()) | CALL_EXT | siDetail.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1418da94 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0021_ShipmentPlan.cs:819 | for (iCol <= siDetail.GetMaxColumnIndex()) | CALL_EXT | siDetail.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ade9da6 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0021_ShipmentPlan.cs:820 | for (iCol <= siDetail.GetMaxColumnIndex()) | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-83b0f768 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0021_ShipmentPlan.cs:821 | for (iCol <= siDetail.GetMaxColumnIndex()) | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## SSP0021_ShipmentPlan.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b53eeba6 | InsertButton | SSP0021_ShipmentPlan.cs:2193 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | DATA_OP | siDetail.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-37fb085f | InsertButton | SSP0021_ShipmentPlan.cs:2196 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | UI_MISC | siDetail.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b569bf23 | InsertButton | SSP0021_ShipmentPlan.cs:2198 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetValue… | 그리드 값 설정 |  |  |  |
| AC-e682dd35 | InsertButton | SSP0021_ShipmentPlan.cs:2199 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.FROM_SITE), siMain.GetValue(s… | 그리드 값 설정 |  |  |  |
| AC-dee58026 | InsertButton | SSP0021_ShipmentPlan.cs:2200 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.FROM_SITE_NM), siMain.GetValu… | 그리드 값 설정 |  |  |  |
| AC-08d48fae | InsertButton | SSP0021_ShipmentPlan.cs:2201 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.ITEM_ID), siMain.GetValue(siM… | 그리드 값 설정 |  |  |  |
| AC-19847864 | InsertButton | SSP0021_ShipmentPlan.cs:2202 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetValue(s… | 그리드 값 설정 |  |  |  |
| AC-693dfa7f | InsertButton | SSP0021_ShipmentPlan.cs:2204 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_LOCK | siDetail.LockRange | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.Active… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4ad0ac79 | InsertButton | SSP0021_ShipmentPlan.cs:2205 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_LOCK | siDetail.LockRange | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siDetail.Ac… | 그리드 편집 잠금/해제 |  |  |  |
| AC-344bc93d | InsertButton | SSP0021_ShipmentPlan.cs:2207 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.HOLD_YYYYMMDD), cboPlanDate.T… | 그리드 값 설정 |  |  |  |
| AC-61b5a2e4 | InsertButton | SSP0021_ShipmentPlan.cs:2212 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf39d10e | InsertButton | SSP0021_ShipmentPlan.cs:2287 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52f2675e | InsertButton | SSP0021_ShipmentPlan.cs:2289 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | siDetail.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-76500f97 | InsertButton | SSP0021_ShipmentPlan.cs:2292 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a14acbf6 | InsertButton | SSP0021_ShipmentPlan.cs:2293 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ITEM_ID, ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-42a32ede | InsertButton | SSP0021_ShipmentPlan.cs:2294 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NICK_NAME, NICK_NAME) | 데이터 객체 조작/조회 |  |  |  |
| AC-9478c7bf | InsertButton | SSP0021_ShipmentPlan.cs:2295 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.TO_SITE_DESCRIPTION, TO_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd23ba5e | InsertButton | SSP0021_ShipmentPlan.cs:2296 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | ("PROJECT_CODE", PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1ee720d | InsertButton | SSP0021_ShipmentPlan.cs:2298 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_DATE, SHIPMENT_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-53fc8c96 | InsertButton | SSP0021_ShipmentPlan.cs:2299 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_CONFIRM_QTY, 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd13fd49 | InsertButton | SSP0021_ShipmentPlan.cs:2300 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REMARKS2, REMARKS2) | 데이터 객체 조작/조회 |  |  |  |
| AC-58200826 | InsertButton | SSP0021_ShipmentPlan.cs:2301 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REMARKS, REMARKS) | 데이터 객체 조작/조회 |  |  |  |
| AC-07d4e804 | InsertButton | SSP0021_ShipmentPlan.cs:2302 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.TRANSPORT_MODE, TRANSPORT_MODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-77f8d3c7 | InsertButton | SSP0021_ShipmentPlan.cs:2303 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.FROM_SITE_DESCRIPTION, FROM_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-073762a2 | InsertButton | SSP0021_ShipmentPlan.cs:2304 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REQUESTOR, REQUESTOR) | 데이터 객체 조작/조회 |  |  |  |
| AC-438e92eb | InsertButton | SSP0021_ShipmentPlan.cs:2305 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REMARKS3, REMARKS3) | 데이터 객체 조작/조회 |  |  |  |
| AC-152ce48a | InsertButton | SSP0021_ShipmentPlan.cs:2306 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_REASON_CODE, CHANGE_REASON_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b7883c4 | InsertButton | SSP0021_ShipmentPlan.cs:2307 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_REASON_DETAIL, CHANGE_REASON_DETAIL) | 데이터 객체 조작/조회 |  |  |  |
| AC-520f4cf1 | InsertButton | SSP0021_ShipmentPlan.cs:2308 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.INCOTERMS, INCOTERMS) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc6daf5f | InsertButton | SSP0021_ShipmentPlan.cs:2309 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.LT_DAY, LT_DAY) | 데이터 객체 조작/조회 |  |  |  |
| AC-83ca0d51 | InsertButton | SSP0021_ShipmentPlan.cs:2310 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ETD, ETD) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac40625d | InsertButton | SSP0021_ShipmentPlan.cs:2311 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ETA, ETA) | 데이터 객체 조작/조회 |  |  |  |
| AC-db26aa4d | InsertButton | SSP0021_ShipmentPlan.cs:2313 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | ("FCST_TYPE", FCST_TYPE) | 데이터 객체 조작/조회 |  |  |  |
| AC-f03c9337 | InsertButton | SSP0021_ShipmentPlan.cs:2314 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | ("UPDATED_BY", UPDATED_BY) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf509876 | InsertButton | SSP0021_ShipmentPlan.cs:2315 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | ("UPDATED_DATE", UPDATED_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-9dc732ab | InsertButton | SSP0021_ShipmentPlan.cs:2316 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_REQ_NO, CHANGE_REQ_NO) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee67dea5 | InsertButton | SSP0021_ShipmentPlan.cs:2317 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CONFIRM_ID, CONFIRM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1182aa6 | InsertButton | SSP0021_ShipmentPlan.cs:2318 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.FROM_SITE, FROM_SITE) | 데이터 객체 조작/조회 |  |  |  |
| AC-385e26a9 | InsertButton | SSP0021_ShipmentPlan.cs:2321 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.TO_SITE, TO_SITE) | 데이터 객체 조작/조회 |  |  |  |
| AC-a60457f8 | InsertButton | SSP0021_ShipmentPlan.cs:2322 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ERP_STATUS, ERP_STATUS) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef78fc0b | InsertButton | SSP0021_ShipmentPlan.cs:2323 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | ("BOD_ID", BOD_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7f09c38 | InsertButton | SSP0021_ShipmentPlan.cs:2324 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_TYPE, CHANGE_TYPE) | 데이터 객체 조작/조회 |  |  |  |
| AC-fff18bda | InsertButton | SSP0021_ShipmentPlan.cs:2325 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_ROUTE_ID, NEW_ROUTE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0f60997 | InsertButton | SSP0021_ShipmentPlan.cs:2326 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_BOD_ID, NEW_BOD_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-53d840e5 | InsertButton | SSP0021_ShipmentPlan.cs:2327 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_INCOTERMS, NEW_INCOTERMS) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb269c61 | InsertButton | SSP0021_ShipmentPlan.cs:2328 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_D_COUNTRY, NEW_D_COUNTRY) | 데이터 객체 조작/조회 |  |  |  |
| AC-6366e200 | InsertButton | SSP0021_ShipmentPlan.cs:2329 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_D_PORT_CODE, NEW_D_PORT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-955b1e8d | InsertButton | SSP0021_ShipmentPlan.cs:2330 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_A_COUNTRY, NEW_A_COUNTRY) | 데이터 객체 조작/조회 |  |  |  |
| AC-19b74f01 | InsertButton | SSP0021_ShipmentPlan.cs:2331 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_A_PORT_CODE, NEW_A_PORT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-02bfcb55 | InsertButton | SSP0021_ShipmentPlan.cs:2332 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_CUSTOMER_LT, NEW_CUSTOMER_LT) | 데이터 객체 조작/조회 |  |  |  |
| AC-586de478 | InsertButton | SSP0021_ShipmentPlan.cs:2333 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_TO_COUNTRY, NEW_TO_COUNTRY) | 데이터 객체 조작/조회 |  |  |  |
| AC-804f4bdd | InsertButton | SSP0021_ShipmentPlan.cs:2334 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_TO_CITY, NEW_TO_CITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc2a0c1b | InsertButton | SSP0021_ShipmentPlan.cs:2335 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_ETA, NEW_ETA) | 데이터 객체 조작/조회 |  |  |  |
| AC-413bab11 | InsertButton | SSP0021_ShipmentPlan.cs:2336 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_ETD, NEW_ETD) | 데이터 객체 조작/조회 |  |  |  |
| AC-faa6390a | InsertButton | SSP0021_ShipmentPlan.cs:2337 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_LT_DAY, NEW_LT_DAY) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5bae417 | InsertButton | SSP0021_ShipmentPlan.cs:2338 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_TRANSPORT_MODE, NEW_TRANSPORT_MODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-065fcef2 | InsertButton | SSP0021_ShipmentPlan.cs:2339 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_SHIPMENT_DATE, NEW_SHIPMENT_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9bbe657 | InsertButton | SSP0021_ShipmentPlan.cs:2340 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.EDIT_REMARKS, EDIT_REMARKS) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ed4b8ce | InsertButton | SSP0021_ShipmentPlan.cs:2342 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | GRID_SET | siDetail.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-b2d59e15 | InsertButton | SSP0021_ShipmentPlan.cs:2344 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f402b5b4 | InsertButton | SSP0021_ShipmentPlan.cs:2346 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.REMARKS3), siDetail.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0021_ShipmentPlan.Measure_SearchIdx

진입점: this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" && siMain.ActiveSheet.Cells[i…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25646f05 | this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIn… | SSP0021_ShipmentPlan.cs:6511 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == strDivisionId… | DATA_OP | intidxArr[0] | iRow | 행/컬럼 값 대입 |  |  |  |
| AC-16f771c7 | this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIn… | SSP0021_ShipmentPlan.cs:6515 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == strDivisionId… | DATA_OP | intidxArr[1] | iRow | 행/컬럼 값 대입 |  |  |  |
| AC-1cf47448 | this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIn… | SSP0021_ShipmentPlan.cs:6519 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == strDivisionId… | DATA_OP | intidxArr[2] | iRow | 행/컬럼 값 대입 |  |  |  |
| AC-d5798293 | this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIn… | SSP0021_ShipmentPlan.cs:6525 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == strDivisionId… | DATA_OP | intidxArr[3] | -1 | 행/컬럼 값 대입 |  |  |  |
| AC-4ecc27d8 | this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIn… | SSP0021_ShipmentPlan.cs:6529 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == strDivisionId… | DATA_OP | intidxArr[3] | iRow | 행/컬럼 값 대입 |  |  |  |
| AC-020bc3af | this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIn… | SSP0021_ShipmentPlan.cs:6534 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == strDivisionId… | DATA_OP | intidxArr[4] | iRow | 행/컬럼 값 대입 |  |  |  |
| AC-ffc06fec | this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIn… | SSP0021_ShipmentPlan.cs:6539 |  | RETURN | return intidxArr; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.NewNonSoNo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84eb916d | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4290 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-0777b049 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4294 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-abfe92d9 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4295 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-37f7eb01 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4296 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-c71d9110 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4297 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-f80a7b41 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4298 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-583f9152 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4299 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-e58ebca5 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4300 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-c5297ba1 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4301 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-68e65156 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4302 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-670b5da5 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4303 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-1e8803e7 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4304 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-1ab44677 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4305 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-38a2bbf8 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4306 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-11efc608 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4307 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-da96f62d | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4308 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-e0c49ad3 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4309 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-7bec36df | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4310 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-9fb6c5c8 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4311 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-d7adef71 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4312 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-1260de3c | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4313 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-f8e4ce4e | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4314 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-073c77bd | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4315 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c024fad0 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4316 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-f05363ef | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4317 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-e6e47476 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4318 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-a1f66914 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4319 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b03d89d3 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4320 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b3f69d63 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4322 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-dcbcf607 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4323 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-f88e3737 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4324 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-7784cbb0 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4326 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-c70ecf59 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4327 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-6be42433 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4328 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-17e82ba2 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4329 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-c1357449 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4330 |  | DATA_OP | request.Parameters["p_shipto_code"] | p_shipto_code | 행/컬럼 값 대입 |  |  |  |
| AC-7d0c7844 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4333 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f3ec324f | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4358 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-64441709 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4360 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ if (MessageHelper.GMessageBox("MSG003… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-82e3d581 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4381 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c8c44034 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4385 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.NonSoNo

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8b63e55 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3521 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-bfc9cff1 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3525 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-56ace077 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3526 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9619bbdc | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3527 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-54175d67 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3528 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-5da76e36 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3529 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-719e5e8e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3530 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-a021a62f | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3531 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-c3a3d6e2 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3532 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-f8368862 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3533 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-0b67adbc | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3534 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-bf97cd6a | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3535 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-a80f9372 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3536 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-cfb5f101 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3537 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-2bdf8ffd | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3538 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-3c949483 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3539 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-b5a6a041 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3540 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-d23e5e7e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3541 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-3f8b6a00 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3542 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-ece9f441 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3543 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-996209b4 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3544 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-1bf3c2a3 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3545 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-210e2d4b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3546 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e99960e2 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3547 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-ac833f08 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3548 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-3b6edc0f | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3549 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-ee8358b3 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3550 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7c966a98 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3551 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-72961736 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3553 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-c5c47d39 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3554 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-dae1073e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3555 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-66123437 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3557 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-669b4f58 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3558 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-e2a2ad23 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3559 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-ded8ef40 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3560 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-38fdba2b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3562 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5f180c84 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3584 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-304a5317 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3586 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ if (MessageHelper.GMessageBox("MSG003… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e277ffb | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3608 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-58932996 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3612 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.Plan_Current_Check

진입점: FindButton [try ▸ if (cboPlanDate.SelectedIndex == 0)] / SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try ▸ if (cboPlanDate.SelectedIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce492286 | FindButton [try ▸ if (cboPlanDate.SelectedIndex == 0)] 외 1 | SSP0021_ShipmentPlan.cs:5538 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Plan_Infor, false, strCompanyID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7d708d0c | FindButton [try ▸ if (cboPlanDate.SelectedIndex == 0)] 외 1 | SSP0021_ShipmentPlan.cs:5543 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00313", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ed642aa | FindButton [try ▸ if (cboPlanDate.SelectedIndex == 0)] 외 1 | SSP0021_ShipmentPlan.cs:5550 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) ▸ if (!DateTime.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-614832e0 | FindButton [try ▸ if (cboPlanDate.SelectedIndex == 0)] 외 1 | SSP0021_ShipmentPlan.cs:5556 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) ▸ if (!DateTime.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce9becaf | FindButton [try ▸ if (cboPlanDate.SelectedIndex == 0)] 외 1 | SSP0021_ShipmentPlan.cs:5562 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) ▸ if (!DateTime.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac160251 | FindButton [try ▸ if (cboPlanDate.SelectedIndex == 0)] 외 1 | SSP0021_ShipmentPlan.cs:5564 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod.Value1 | dateFrom | 속성 Value1 설정 |  |  |  |
| AC-c5ee35dc | FindButton [try ▸ if (cboPlanDate.SelectedIndex == 0)] 외 1 | SSP0021_ShipmentPlan.cs:5565 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod.Value2 | dateTo | 속성 Value2 설정 |  |  |  |
| AC-497ca847 | FindButton [try ▸ if (cboPlanDate.SelectedIndex == 0)] 외 1 | SSP0021_ShipmentPlan.cs:5566 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod2.Value1 | dateFrom | 속성 Value1 설정 |  |  |  |
| AC-8b8f5869 | FindButton [try ▸ if (cboPlanDate.SelectedIndex == 0)] 외 1 | SSP0021_ShipmentPlan.cs:5567 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod2.Value2 | dateTo | 속성 Value2 설정 |  |  |  |
| AC-9198ef93 | FindButton [try ▸ if (cboPlanDate.SelectedIndex == 0)] 외 1 | SSP0021_ShipmentPlan.cs:5568 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | CALL_EXT | cboPlanDate.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd973121 | FindButton [try ▸ if (cboPlanDate.SelectedIndex == 0)] 외 1 | SSP0021_ShipmentPlan.cs:5569 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | LIST_REBIND | clsCtrl.setListBox | (Tmp_dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0021_ShipmentPlan.Re_Design

진입점: FindButton [finally] / SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e68f3d34 | FindButton [finally] 외 1 | SSP0021_ShipmentPlan.cs:4766 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (!string.IsNullOrWhiteSpace(siMain.GetValue(i, siMain.GetC… | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-9e35c558 | FindButton [finally] 외 1 | SSP0021_ShipmentPlan.cs:4777 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure == "CONTAINER") ▸ if (siMain.GetValue(i, siMain.… | GRID_SET | siMain.ActiveSheet.Cells[i, startIdx, i, siMain.ActiveSheet.ColumnCount - 1].Value | null | 그리드 속성/값 설정 |  |  |  |
| AC-568c4ece | FindButton [finally] 외 1 | SSP0021_ShipmentPlan.cs:4786 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure == "SHIP_PLAN") | UI_PROP | range1.BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 속성 BackColor 설정 |  |  |  |
| AC-85bd02c6 | FindButton [finally] 외 1 | SSP0021_ShipmentPlan.cs:4796 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (strItemId != strTmp_ItemID) | UI_PROP | range1.Border | bevelbrdr | 속성 Border 설정 |  |  |  |

## SSP0021_ShipmentPlan.SaveData_Detail

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2f72fbf | SaveButton | SSP0021_ShipmentPlan.cs:2532 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-410fac71 | SaveButton | SSP0021_ShipmentPlan.cs:2535 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (!DataUtil.ch… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec9ab230 | SaveButton | SSP0021_ShipmentPlan.cs:2542 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (chkERPIFBloc… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f1a12ae | SaveButton | SSP0021_ShipmentPlan.cs:2546 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0213f239 | SaveButton | SSP0021_ShipmentPlan.cs:2554 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7c6dba3 | SaveButton | SSP0021_ShipmentPlan.cs:2560 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d7ef077 | SaveButton | SSP0021_ShipmentPlan.cs:2562 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-550efe24 | SaveButton | SSP0021_ShipmentPlan.cs:2566 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-63cab3aa | SaveButton | SSP0021_ShipmentPlan.cs:2571 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5bd982f2 | SaveButton | SSP0021_ShipmentPlan.cs:2664 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM") ⇒ SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-611e24b7 | SaveButton | SSP0021_ShipmentPlan.cs:2668 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c4af2b69 | SaveButton | SSP0021_ShipmentPlan.cs:2669 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-48db46e4 | SaveButton | SSP0021_ShipmentPlan.cs:2670 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-160ef4d9 | SaveButton | SSP0021_ShipmentPlan.cs:2671 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-9839ebfc | SaveButton | SSP0021_ShipmentPlan.cs:2672 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-1c984cd9 | SaveButton | SSP0021_ShipmentPlan.cs:2673 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-2ae5e701 | SaveButton | SSP0021_ShipmentPlan.cs:2674 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-8d5bf1fb | SaveButton | SSP0021_ShipmentPlan.cs:2675 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-ddb5e2e8 | SaveButton | SSP0021_ShipmentPlan.cs:2676 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-563cb547 | SaveButton | SSP0021_ShipmentPlan.cs:2677 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-f002b8c0 | SaveButton | SSP0021_ShipmentPlan.cs:2678 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-9f5d65df | SaveButton | SSP0021_ShipmentPlan.cs:2679 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-7c69ac0f | SaveButton | SSP0021_ShipmentPlan.cs:2680 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-4f18cf8d | SaveButton | SSP0021_ShipmentPlan.cs:2681 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-b2d4aa22 | SaveButton | SSP0021_ShipmentPlan.cs:2682 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-91ee3d57 | SaveButton | SSP0021_ShipmentPlan.cs:2683 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-01a4f677 | SaveButton | SSP0021_ShipmentPlan.cs:2684 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-17c34883 | SaveButton | SSP0021_ShipmentPlan.cs:2685 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-d4441e3b | SaveButton | SSP0021_ShipmentPlan.cs:2686 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-154161c4 | SaveButton | SSP0021_ShipmentPlan.cs:2687 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-a3b92a18 | SaveButton | SSP0021_ShipmentPlan.cs:2688 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-fa475a3d | SaveButton | SSP0021_ShipmentPlan.cs:2689 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-3dfb8e3b | SaveButton | SSP0021_ShipmentPlan.cs:2690 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_check_need_yn"] | p_check_need_yn | 행/컬럼 값 대입 |  |  |  |
| AC-73a63a60 | SaveButton | SSP0021_ShipmentPlan.cs:2691 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-203118b5 | SaveButton | SSP0021_ShipmentPlan.cs:2693 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-186dae1d | SaveButton | SSP0021_ShipmentPlan.cs:2699 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-140c3660 | SaveButton | SSP0021_ShipmentPlan.cs:2700 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e3020840 | SaveButton | SSP0021_ShipmentPlan.cs:2726 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b456dcc | SaveButton | SSP0021_ShipmentPlan.cs:2728 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e35739a5 | SaveButton | SSP0021_ShipmentPlan.cs:2739 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7f7fb6e6 | SaveButton | SSP0021_ShipmentPlan.cs:2751 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40721912 | SaveButton | SSP0021_ShipmentPlan.cs:2762 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9718e36f | SaveButton | SSP0021_ShipmentPlan.cs:2766 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | STATE_RESET | errConfrimList2.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-16a6775b | SaveButton | SSP0021_ShipmentPlan.cs:2789 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-384f41a5 | SaveButton | SSP0021_ShipmentPlan.cs:2789 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (!DataUtil.che… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b659233 | SaveButton | SSP0021_ShipmentPlan.cs:2791 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (!checkValidN(… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2a5390ec | SaveButton | SSP0021_ShipmentPlan.cs:2822 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_SAVE_HOLD_STOCK_DATA") ⇒ SSP.SSP0021_SAVE_HOLD_STOCK_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-87f7eda3 | SaveButton | SSP0021_ShipmentPlan.cs:2827 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-382bc2c4 | SaveButton | SSP0021_ShipmentPlan.cs:2831 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c352da1a | SaveButton | SSP0021_ShipmentPlan.cs:2832 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7753bac7 | SaveButton | SSP0021_ShipmentPlan.cs:2833 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_hold_id"] | p_hold_id | 행/컬럼 값 대입 |  |  |  |
| AC-6f34be0a | SaveButton | SSP0021_ShipmentPlan.cs:2834 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-eca350ee | SaveButton | SSP0021_ShipmentPlan.cs:2835 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-01ee41c3 | SaveButton | SSP0021_ShipmentPlan.cs:2836 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_hold_yyyymmdd"] | p_hold_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9fc47c90 | SaveButton | SSP0021_ShipmentPlan.cs:2837 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_release_yyyymmdd"] | p_release_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1a4d85e2 | SaveButton | SSP0021_ShipmentPlan.cs:2838 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_hold_qty"] | p_hold_qty | 행/컬럼 값 대입 |  |  |  |
| AC-8a5f5415 | SaveButton | SSP0021_ShipmentPlan.cs:2839 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-effb2f21 | SaveButton | SSP0021_ShipmentPlan.cs:2840 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-13038c98 | SaveButton | SSP0021_ShipmentPlan.cs:2842 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-63ed597c | SaveButton | SSP0021_ShipmentPlan.cs:2843 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-2703d247 | SaveButton | SSP0021_ShipmentPlan.cs:2844 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-5f928192 | SaveButton | SSP0021_ShipmentPlan.cs:2846 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f5097976 | SaveButton | SSP0021_ShipmentPlan.cs:2846 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-eac1a0f8 | SaveButton | SSP0021_ShipmentPlan.cs:2855 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b28c98fa | SaveButton | SSP0021_ShipmentPlan.cs:2876 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0021_ShipmentPlan.Set_SumValues

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06c43057 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0021_ShipmentPlan.cs:4686 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-554ac927 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0021_ShipmentPlan.cs:4690 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e15148f | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0021_ShipmentPlan.cs:4714 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_STOCK") \|\| measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-014efc7d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0021_ShipmentPlan.cs:4722 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_STOCK") \|\| measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-c08eca1d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0021_ShipmentPlan.cs:4732 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_STOCK") \|\| measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-9483f05c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0021_ShipmentPlan.cs:4733 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_STOCK") \|\| measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |

## SSP0021_ShipmentPlan.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9025d17a | this.Load | SSP0021_ShipmentPlan.cs:338 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3db0fe62 | this.Load | SSP0021_ShipmentPlan.cs:339 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7e6e515c | this.Load | SSP0021_ShipmentPlan.cs:345 | switch (triggerControl) case "MyDivisionOut40": | FLAG | dtMyDivision | DataService.GetSSPInnerTable("MyDivisionOut40", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-120a06ae | this.Load | SSP0021_ShipmentPlan.cs:345 | switch (triggerControl) case "MyDivisionOut40": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyDivisionOut40", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c42c2b7d | this.Load | SSP0021_ShipmentPlan.cs:350 | switch (triggerControl) case "Div_Company": | FLAG | dtCompany | DataService.GetSSPInnerTable("Div_Company", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c7c3cdf9 | this.Load | SSP0021_ShipmentPlan.cs:350 | switch (triggerControl) case "Div_Company": | COMBO_DATA | DataService.GetSSPInnerTable | ("Div_Company", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-57e7b67b | this.Load | SSP0021_ShipmentPlan.cs:355 | switch (triggerControl) case "MyCompanyID": | FLAG | dtMyCompany | DataService.GetSSPInnerTable("MyCompanyID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f1b96a62 | this.Load | SSP0021_ShipmentPlan.cs:355 | switch (triggerControl) case "MyCompanyID": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyCompanyID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-96e7c9ff | this.Load | SSP0021_ShipmentPlan.cs:360 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | FLAG | dtChangeReasonCode | DataService.GetSSPInnerTable("CHANGE_REASON_CODE_ALL", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-94563eee | this.Load | SSP0021_ShipmentPlan.cs:360 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REASON_CODE_ALL", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-83a20e88 | this.Load | SSP0021_ShipmentPlan.cs:365 | switch (triggerControl) case "OWMS_STOCK_STATUS": | FLAG | dtStockStatus | DataService.GetSSPInnerTable("OWMS_STOCK_STATUS", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b12934df | this.Load | SSP0021_ShipmentPlan.cs:365 | switch (triggerControl) case "OWMS_STOCK_STATUS": | COMBO_DATA | DataService.GetSSPInnerTable | ("OWMS_STOCK_STATUS", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-09039a40 | this.Load | SSP0021_ShipmentPlan.cs:370 | switch (triggerControl) case "SSP_SHIPMENT_RESULT_TYPE": | FLAG | dtResultType | DataService.GetSSPInnerTable("SSP_SHIPMENT_RESULT_TYPE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c2d2f2fa | this.Load | SSP0021_ShipmentPlan.cs:370 | switch (triggerControl) case "SSP_SHIPMENT_RESULT_TYPE": | COMBO_DATA | DataService.GetSSPInnerTable | ("SSP_SHIPMENT_RESULT_TYPE", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-78823869 | this.Load | SSP0021_ShipmentPlan.cs:375 | switch (triggerControl) case "CHANGE_REQ_DAY": | FLAG | dtBaseDay | DataService.GetSSPInnerTable("CHANGE_REQ_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-729ebf3b | this.Load | SSP0021_ShipmentPlan.cs:375 | switch (triggerControl) case "CHANGE_REQ_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REQ_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-7cb8d6ac | this.Load | SSP0021_ShipmentPlan.cs:380 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | FLAG | dtShipmentInputPeriod | DataService.GetSSPInnerTable("SHIPMENT_PERIOD_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9c9460ed | this.Load | SSP0021_ShipmentPlan.cs:380 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("SHIPMENT_PERIOD_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-31954918 | this.Load | SSP0021_ShipmentPlan.cs:385 | switch (triggerControl) case "PgmAuthId": | FLAG | dtPgmAuthId | DataService.GetSSPInnerTable("PgmAuthId", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-03336108 | this.Load | SSP0021_ShipmentPlan.cs:385 | switch (triggerControl) case "PgmAuthId": | COMBO_DATA | DataService.GetSSPInnerTable | ("PgmAuthId", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## SSP0021_ShipmentPlan.SetChangedControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a474b319 | this.Load | SSP0021_ShipmentPlan.cs:488 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-5f1abc7f | this.Load | SSP0021_ShipmentPlan.cs:489 | if (dtMyDivision.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32053edc | this.Load | SSP0021_ShipmentPlan.cs:493 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_GET_SHIPMENT_DIVISION") ⇒ SSP.SSP0021_GET_SHIPMENT_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-0b664a50 | this.Load | SSP0021_ShipmentPlan.cs:497 |  | DATA_OP | request.Parameters["Param1"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d1992ef6 | this.Load | SSP0021_ShipmentPlan.cs:498 |  | DATA_OP | request.Parameters["Param2"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bd2057e0 | this.Load | SSP0021_ShipmentPlan.cs:499 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bdff543f | this.Load | SSP0021_ShipmentPlan.cs:502 |  | FLAG | dtMyDivision | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-924c6abd | this.Load | SSP0021_ShipmentPlan.cs:503 |  | FLAG | dtCompany | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-06777673 | this.Load | SSP0021_ShipmentPlan.cs:505 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-556a92ea | this.Load | SSP0021_ShipmentPlan.cs:509 |  | DATA_OP | dtCompany.Select().Where(c => c["DIVISION_ID"].ToString() == strSelDivision_ID).CopyToData… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7f3d603d | this.Load | SSP0021_ShipmentPlan.cs:509 |  | DATA_OP | dtCompany.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d26aba2b | this.Load | SSP0021_ShipmentPlan.cs:511 |  | LIST_REBIND | clsCtrl.setListBox | (dtDiv_Company_ID, clbCompany_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-51cb98e7 | this.Load | SSP0021_ShipmentPlan.cs:515 |  | FLAG | sUserCompany_NM | dtMyCompany.Rows[0]["NAME"].ToString() | 화면 필드/플래그 변경 |  |  |  |

## SSP0021_ShipmentPlan.SetLockSumColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86625232 | (진입점 미연결) | SSP0021_ShipmentPlan.cs:4530 | for (iCol < spreadInfo.ActiveSheet.ColumnCount) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| spreadInfo.GetColumnTag(iCol).In… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0021_ShipmentPlan.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged / this.chkSum.CheckedChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (spdInfo.SheetName == SpdSheet.shtMain)] / clbCompany_ID.SelectedIndexChanged [if (spdInfo.SheetName == SpdSheet.shtMain)] / cboPlanDate.SelectedIndexChanged [if (cboPlanDate.ControlVal…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da0a37c9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0021_ShipmentPlan.cs:4469 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-29da6100 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0021_ShipmentPlan.cs:4474 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-5829bf4d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0021_ShipmentPlan.cs:4481 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-922d533e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0021_ShipmentPlan.cs:4485 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d4cdfa10 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0021_ShipmentPlan.cs:4490 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-c87e0c6b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0021_ShipmentPlan.cs:4497 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-00fd9195 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0021_ShipmentPlan.cs:4501 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0021_ShipmentPlan.ShipmentResult_GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90430488 | this.Load | SSP0021_ShipmentPlan.cs:6552 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.shtDetail_Change

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39d104f9 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1010 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange != true \|\| e.Row == -1 && e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d75e4cfd | dsdm.Changed | SSP0021_ShipmentPlan.cs:1011 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dca88bf7 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1020 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00189") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-97f99c63 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1021 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-657b12b7 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1087 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00278") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9d3e71f4 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1088 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8695049a | dsdm.Changed | SSP0021_ShipmentPlan.cs:1102 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-d7fca000 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1112 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-159f894f | dsdm.Changed | SSP0021_ShipmentPlan.cs:1114 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-5ade1823 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1115 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ForeCo… | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-2769b8b0 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1116 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].BackCo… | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-7c866ac7 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1120 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-0c306ae6 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1131 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-dae35071 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1141 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-36ba66c4 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1143 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-0c5db37a | dsdm.Changed | SSP0021_ShipmentPlan.cs:1144 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ForeCo… | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-56f30e7e | dsdm.Changed | SSP0021_ShipmentPlan.cs:1145 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].BackCo… | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-e7f63bd2 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1160 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-f1d69ed9 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1161 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-606f4f86 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1165 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-3048351d | dsdm.Changed | SSP0021_ShipmentPlan.cs:1172 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-9737c2b7 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1182 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-d3895d04 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1183 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-8fc2cc16 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1184 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-129b6c19 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1196 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-224eb82e | dsdm.Changed | SSP0021_ShipmentPlan.cs:1206 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-9cfd6573 | dsdm.Changed | SSP0021_ShipmentPlan.cs:1207 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0021_ShipmentPlan.Simulation

진입점: this.btnSimulation.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c27c52a | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6096 | if (bContainer_Flag == true) ▸ if (bRealFlag == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00292", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-42e13efe | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6099 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5555b63b | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6100 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4ed3cc49 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6103 | try | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Container_Size, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-91ca417a | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6124 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | DATA_OP | dtContainer.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c7388da1 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6124 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3bfa184f | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6125 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-19c6b866 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6126 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e109ba3b | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6176 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | GRID_SET | siMain.SetValue | (intWHSearchIdx, j, intWH_Qty) | 그리드 값 설정 |  |  |  |
| AC-4dc80629 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6195 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | GRID_SET | siMain.SetValue | (intBalanceIdx, j, intBalance) | 그리드 값 설정 |  |  |  |
| AC-57db3b39 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6214 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | GRID_SET | siMain.SetValue | (intContainerIdx, j, intContainer) | 그리드 값 설정 |  |  |  |
| AC-88a0f4d0 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6294 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "WH_STOCK") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveShe… | GRID_SET | siMain.SetValue | (i, whTemp, intSumWH_Qty) | 그리드 값 설정 |  |  |  |
| AC-722a0e77 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6300 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "WH_STOCK") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveShe… | GRID_SET | siMain.SetValue | (i, whTemp3, intTotWH_Qty) | 그리드 값 설정 |  |  |  |
| AC-6fd27797 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6309 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "WH_STOCK") | GRID_SET | siMain.SetValue | (i, whTemp, intSumWH_Qty) | 그리드 값 설정 |  |  |  |
| AC-d5838279 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6323 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "BALANCE") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveShee… | GRID_SET | siMain.SetValue | (i, balnceTemp, intSumBalance) | 그리드 값 설정 |  |  |  |
| AC-ebf47b0d | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6329 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "BALANCE") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveShee… | GRID_SET | siMain.SetValue | (i, balnceTem3, intTotBalance) | 그리드 값 설정 |  |  |  |
| AC-919aa9e8 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6338 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "BALANCE") | GRID_SET | siMain.SetValue | (i, balnceTemp, intSumBalance) | 그리드 값 설정 |  |  |  |
| AC-8fb6546a | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6353 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "SHIP_REQ") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveShe… | GRID_SET | siMain.SetValue | (i, shipReqTemp, intSumShipReq_Qty) | 그리드 값 설정 |  |  |  |
| AC-75f57769 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6361 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "SHIP_REQ") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveShe… | GRID_SET | siMain.SetValue | (i, shipReqTemp3, intTotShipReq_Qty) | 그리드 값 설정 |  |  |  |
| AC-0916718d | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6370 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "SHIP_REQ") | GRID_SET | siMain.SetValue | (i, shipReqTemp, intSumShipReq_Qty) | 그리드 값 설정 |  |  |  |
| AC-d72d5046 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6383 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "SHIP_PLAN") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveSh… | GRID_SET | siMain.SetValue | (i, shipPlanTemp, intSumShipPlan_Qty) | 그리드 값 설정 |  |  |  |
| AC-a1caef4b | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6390 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "SHIP_PLAN") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveSh… | GRID_SET | siMain.SetValue | (i, shipPlanTemp3, intTotShipPlan_Qty) | 그리드 값 설정 |  |  |  |
| AC-b66a787f | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6399 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "SHIP_PLAN") | GRID_SET | siMain.SetValue | (i, shipPlanTemp, intSumShipPlan_Qty) | 그리드 값 설정 |  |  |  |
| AC-103400a0 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6412 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "INTN_MOVEMENT") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Acti… | GRID_SET | siMain.SetValue | (i, shipMoveTemp, intSumShipMove_Qty) | 그리드 값 설정 |  |  |  |
| AC-f789adef | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6419 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "INTN_MOVEMENT") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Acti… | GRID_SET | siMain.SetValue | (i, shipMoveTemp3, intTotShipMove_Qty) | 그리드 값 설정 |  |  |  |
| AC-0a5d8245 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6428 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "INTN_MOVEMENT") | GRID_SET | siMain.SetValue | (i, shipMoveTemp, intSumShipMove_Qty) | 그리드 값 설정 |  |  |  |
| AC-91c9c24b | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6440 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "CONTAINER") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveSh… | GRID_SET | siMain.SetValue | (i, shipContainerTemp, intSumContainer_Qty) | 그리드 값 설정 |  |  |  |
| AC-14bc0aa0 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6447 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "CONTAINER") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveSh… | GRID_SET | siMain.SetValue | (i, shipContainerTemp3, intTotContainer_Qty) | 그리드 값 설정 |  |  |  |
| AC-997d0fbd | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6456 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "CONTAINER") | GRID_SET | siMain.SetValue | (i, shipContainerTemp, intSumContainer_Qty) | 그리드 값 설정 |  |  |  |
| AC-f3a976ad | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6469 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "PROD_PLAN") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveSh… | GRID_SET | siMain.SetValue | (i, shipProdTemp, intSumProd_Qty) | 그리드 값 설정 |  |  |  |
| AC-737463a7 | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6476 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "PROD_PLAN") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveSh… | GRID_SET | siMain.SetValue | (i, shipProdTemp3, intTotProd_Qty) | 그리드 값 설정 |  |  |  |
| AC-a37536dd | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6485 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "PROD_PLAN") | GRID_SET | siMain.SetValue | (i, shipProdTemp, intSumProd_Qty) | 그리드 값 설정 |  |  |  |
| AC-60a1018d | this.btnSimulation.Click | SSP0021_ShipmentPlan.cs:6495 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0021_ShipmentPlan.SoNo

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ else of (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f225b7ce | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3628 | for (i < intRowIdx) ▸ if (erpSoNo == siDetail.GetValue(i, siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)).ToString()) ▸ if (intRowIdx > i) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-3cbc8eb9 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3742 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-63472c0e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3746 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-54d10f6b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3747 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4201d058 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3748 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-7b299a45 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3749 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-0d82fb4b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3750 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-e02c2668 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3751 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-f0561e33 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3752 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-1203c1b7 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3753 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-e9aca388 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3754 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-8e683925 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3755 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-4d3c596d | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3756 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-a84fac35 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3757 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-d38bc6ec | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3758 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-aa4f922c | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3759 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-09a17d5b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3760 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-2927df7f | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3761 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-5f5d5473 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3762 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-b190101e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3763 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-48f72efd | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3764 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-121d8254 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3765 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-c79243dd | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3766 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-5d33cb53 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3767 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e4359368 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3768 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-bd90a471 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3769 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-f426dbe0 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3770 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-47835ba5 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3771 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-922d70a0 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3772 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c8838a3a | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3774 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-4a791019 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3775 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-363ee7c7 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3776 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-bcaed7e7 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3778 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-1743d1d4 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3779 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-3affc6fa | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3780 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-b51121e9 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3781 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-25978fc6 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3783 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0bc497c9 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3804 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-24c3704c | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3806 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ if (MessageHelper.GMessageBox("MSG003… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b4cbfc8 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3827 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cada44ee | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3831 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0021_ShipmentPlan.SpdDetail_ActiveSheetChanged

진입점: this.spdDetail.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee4deec7 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1958 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-90e45688 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1959 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6175d401 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1960 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-8dcf419e | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1961 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-32758aa4 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1962 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f594edae | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1963 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-637de317 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1964 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-65b7d98c | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1965 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8fc6ff42 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1966 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0ec45f19 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1970 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4d98f563 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1971 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ee9a8886 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1972 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6f17507e | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1973 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a410daed | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1974 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d40e722a | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1975 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a260e816 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1976 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-23b912de | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1977 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-dbf30edd | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1978 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6bb435fb | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1982 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-22589efe | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1983 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-95acb64f | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1984 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d48e485b | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1985 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c19b7cee | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1986 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7e882d43 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1987 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8c1b6f96 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1988 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9048681e | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1989 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d51f0713 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1990 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e790c9d9 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1994 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-91649e6e | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1995 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-242f7b0f | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1996 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-342663be | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1997 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3b928d27 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1998 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a1a4e4ab | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:1999 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-5e3316db | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2000 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-50454f79 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2001 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7169cd98 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2002 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-3feeb73c | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2030 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-dc32999d | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2031 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1510e706 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2032 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-67549a9d | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2033 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-cb6d49dc | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2034 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-02047ca4 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2035 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-db50c218 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2036 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-42ff8314 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2037 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-54122316 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2038 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-82081fc4 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2042 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0a6b90b0 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2043 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f4a5d695 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2044 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-99eb2166 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2045 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fe709f34 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2046 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-55f28be5 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2047 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2f2ad2d7 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2048 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-aad475b0 | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2049 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4ac52d8f | this.spdDetail.ActiveSheetChanged | SSP0021_ShipmentPlan.cs:2050 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## SSP0021_ShipmentPlan.SpdDetail_CellClick

진입점: this.spdDetail.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc28e501 | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1766 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (spdDetail.AutoClipboard == true) | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.ClipboardPasteAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb5f7dad | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1767 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (spdDetail.AutoClipboard == true) | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.ClipboardCopyAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7707edfa | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1768 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (spdDetail.AutoClipboard == true) | UI_PROP | spdDetail.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |
| AC-e21adff0 | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1793 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Vert… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-b302cd81 | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1794 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Hori… | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-9455b559 | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1802 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siDe… | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-69fda1c1 | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1806 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siDe… | GRID_SET | siDetail.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-8ab4df7a | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1819 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | UI_PROP | spdDetail.AutoClipboard | true | 속성 AutoClipboard 설정 |  |  |  |
| AC-680c8664 | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1820 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | FLAG | im | spdDetail.GetInputMap(FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | 화면 필드/플래그 변경 |  |  |  |
| AC-32c917bf | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1820 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | CALL_EXT | spdDetail.GetInputMap | (FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c2f7445c | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1821 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d2b7f49 | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1822 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-25a97abf | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1837 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-5b28a6e5 | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1841 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-be8bea3f | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1848 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-38ceda3d | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1852 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-b51abc4e | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1863 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) ▸ if (string.IsNullOrWhiteSpace(sRequestNo)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60419973 | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1865 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | new SCM0002_ShipmentPlanRequestPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c273e5ab | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1866 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-48dfda53 | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1867 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop._sRequestNo | sRequestNo | 속성 _sRequestNo 설정 |  |  |  |
| AC-8f803078 | this.spdDetail.CellClick | SSP0021_ShipmentPlan.cs:1868 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0021_ShipmentPlan.SpdDetail_CellDoubleClick

진입점: this.spdDetail.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7093a559 | this.spdDetail.CellDoubleClick | SSP0021_ShipmentPlan.cs:1606 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetai… | POPUP | new SSP0300_OrderDetailPopup | () | 팝업/폼 생성 |  |  |  |
| AC-597a9183 | this.spdDetail.CellDoubleClick | SSP0021_ShipmentPlan.cs:1608 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetai… | POPUP | pop.Form_Load | (_DivisionID, _ErpSoNo, _ConfirmId, _ItemID, "N") | 팝업 초기화(인자 전달) |  |  |  |
| AC-a1e18373 | this.spdDetail.CellDoubleClick | SSP0021_ShipmentPlan.cs:1609 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetai… | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cd91e677 | this.spdDetail.CellDoubleClick | SSP0021_ShipmentPlan.cs:1610 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetai… | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0021_ShipmentPlan.SpdDetail_ClipboardPasted

진입점: this.spdDetail.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f5a7539 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1404 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-6104f255 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1428 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-eb414a0e | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1446 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-33cb2924 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1447 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_STYLE | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetF… | () | 그리드 표시 설정 |  |  |  |
| AC-05809601 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1448 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_STYLE | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetB… | () | 그리드 표시 설정 |  |  |  |
| AC-84b2779d | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1451 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ForeCo… | ControlColor.DefaultForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-1c6566e5 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1467 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-1c727b1e | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1470 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-60aeb452 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1471 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-4247aef5 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1481 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-a40ffdcc | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1486 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-0ff8a9f9 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1494 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-df3a9cfa | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1501 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-f6301d23 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1509 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | DATA_OP | dtChangeReasonCode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-65468a75 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1513 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | CALL_EXT | ((FarPoint.Win.Spread.FpSpread)sender).CancelCellEditing | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-61b7dab1 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1517 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00047", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0593b751 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1518 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c055b8a5 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1524 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE)].F… | ControlColor.MarkedForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-48fb9c52 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1528 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-9aea819c | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1539 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE)].Fore… | ControlColor.MarkedForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-d5912912 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1541 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-64225993 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1542 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-fd845315 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1556 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-7476904c | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1567 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-312e0bd4 | this.spdDetail.ClipboardPasted | SSP0021_ShipmentPlan.cs:1569 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0021_ShipmentPlan.SpdDetail_ComboSelChange

진입점: this.spdDetail.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f2d571d | this.spdDetail.ComboSelChange | SSP0021_ShipmentPlan.cs:1624 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(siDetail.GetValue(e.Row, siDetail.GetCol… | MESSAGE | MessageHelper.GMessageBox | ("MSG00278") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2df38e91 | this.spdDetail.ComboSelChange | SSP0021_ShipmentPlan.cs:1625 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(siDetail.GetValue(e.Row, siDetail.GetCol… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f80eb86 | this.spdDetail.ComboSelChange | SSP0021_ShipmentPlan.cs:1669 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-f58e480f | this.spdDetail.ComboSelChange | SSP0021_ShipmentPlan.cs:1694 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siDetail.Acti… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-43a9e6d1 | this.spdDetail.ComboSelChange | SSP0021_ShipmentPlan.cs:1717 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-a1c18f05 | this.spdDetail.ComboSelChange | SSP0021_ShipmentPlan.cs:1718 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-1f6a078b | this.spdDetail.ComboSelChange | SSP0021_ShipmentPlan.cs:1723 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-f4a7ab04 | this.spdDetail.ComboSelChange | SSP0021_ShipmentPlan.cs:1737 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-c3787785 | this.spdDetail.ComboSelChange | SSP0021_ShipmentPlan.cs:1738 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-f09d6368 | this.spdDetail.ComboSelChange | SSP0021_ShipmentPlan.cs:1739 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-5104f4b9 | this.spdDetail.ComboSelChange | SSP0021_ShipmentPlan.cs:1744 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-1137a9cc | this.spdDetail.ComboSelChange | SSP0021_ShipmentPlan.cs:1745 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-657b368d | this.spdDetail.ComboSelChange | SSP0021_ShipmentPlan.cs:1746 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0021_ShipmentPlan.SpdDetail_EditChange

진입점: this.spdDetail.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21118bcb | this.spdDetail.EditChange | SSP0021_ShipmentPlan.cs:1257 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-07229a23 | this.spdDetail.EditChange | SSP0021_ShipmentPlan.cs:1267 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-b6be52ba | this.spdDetail.EditChange | SSP0021_ShipmentPlan.cs:1273 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-0d7fa813 | this.spdDetail.EditChange | SSP0021_ShipmentPlan.cs:1289 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | GRID_STYLE | siDetail.ActiveSheet.SetActiveCell | (e.Row, siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) | 그리드 표시 설정 |  |  |  |
| AC-41a1ba47 | this.spdDetail.EditChange | SSP0021_ShipmentPlan.cs:1290 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | CALL_EXT | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL)… | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8581ffe0 | this.spdDetail.EditChange | SSP0021_ShipmentPlan.cs:1292 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | MESSAGE | MessageHelper.GMessageBox | ("MSG00287", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-baf53f2d | this.spdDetail.EditChange | SSP0021_ShipmentPlan.cs:1294 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f36a0dd7 | this.spdDetail.EditChange | SSP0021_ShipmentPlan.cs:1302 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-e585135a | this.spdDetail.EditChange | SSP0021_ShipmentPlan.cs:1312 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-5b9be261 | this.spdDetail.EditChange | SSP0021_ShipmentPlan.cs:1314 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0021_ShipmentPlan.SpdDetail_SheetTabClick

진입점: this.spdDetail.SheetTabClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f880ad5c | this.spdDetail.SheetTabClick | SSP0021_ShipmentPlan.cs:2138 | if (e.SheetTabIndex == 0) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8347418f | this.spdDetail.SheetTabClick | SSP0021_ShipmentPlan.cs:2139 | if (e.SheetTabIndex == 0) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtPlanDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9af87d41 | this.spdDetail.SheetTabClick | SSP0021_ShipmentPlan.cs:2143 | else of (e.SheetTabIndex == 0) ▸ if (e.SheetTabIndex == 1) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f72ec03a | this.spdDetail.SheetTabClick | SSP0021_ShipmentPlan.cs:2144 | else of (e.SheetTabIndex == 0) ▸ if (e.SheetTabIndex == 1) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7f0a18c7 | this.spdDetail.SheetTabClick | SSP0021_ShipmentPlan.cs:2148 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ if (e.SheetTabIndex == 2) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtoWMSDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d33d45e | this.spdDetail.SheetTabClick | SSP0021_ShipmentPlan.cs:2149 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ if (e.SheetTabIndex == 2) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtoWMSDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-36af1255 | this.spdDetail.SheetTabClick | SSP0021_ShipmentPlan.cs:2153 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 5) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a23d544e | this.spdDetail.SheetTabClick | SSP0021_ShipmentPlan.cs:2154 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 5) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentResult) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4f7b3d46 | this.spdDetail.SheetTabClick | SSP0021_ShipmentPlan.cs:2156 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 5) | CALL_EXT | clbResultType.SetItemChecked | (0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6fd70b4 | this.spdDetail.SheetTabClick | SSP0021_ShipmentPlan.cs:2157 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 5) | CALL_EXT | clbResultType.SetItemChecked | (1, true) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0021_ShipmentPlan.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08e87f60 | this.spdMain.CellDoubleClick | SSP0021_ShipmentPlan.cs:2059 | if (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2847abc5 | this.spdMain.CellDoubleClick | SSP0021_ShipmentPlan.cs:2060 | if (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtPlanDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4cb3b520 | this.spdMain.CellDoubleClick | SSP0021_ShipmentPlan.cs:2063 | if (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) | FLAG | bDetail_Search | false | 화면 필드/플래그 변경 |  |  |  |
| AC-89f5c985 | this.spdMain.CellDoubleClick | SSP0021_ShipmentPlan.cs:2067 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) ▸ if (e.… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e274826 | this.spdMain.CellDoubleClick | SSP0021_ShipmentPlan.cs:2068 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) ▸ if (e.… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b3f5a813 | this.spdMain.CellDoubleClick | SSP0021_ShipmentPlan.cs:2074 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) ▸ else o… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtoWMSDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f1df5a0f | this.spdMain.CellDoubleClick | SSP0021_ShipmentPlan.cs:2075 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) ▸ else o… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtoWMSDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2cc8aa9a | this.spdMain.CellDoubleClick | SSP0021_ShipmentPlan.cs:2081 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) ▸ else o… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtHoldStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12fce5bf | this.spdMain.CellDoubleClick | SSP0021_ShipmentPlan.cs:2082 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) ▸ else o… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtHoldStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-000e9137 | this.spdMain.CellDoubleClick | SSP0021_ShipmentPlan.cs:2088 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) ▸ else o… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMESStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-900ad9a4 | this.spdMain.CellDoubleClick | SSP0021_ShipmentPlan.cs:2089 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) ▸ else o… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMESStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9b9528e1 | this.spdMain.CellDoubleClick | SSP0021_ShipmentPlan.cs:2093 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) ▸ else o… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMESStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-18497cd2 | this.spdMain.CellDoubleClick | SSP0021_ShipmentPlan.cs:2094 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) ▸ else o… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMESStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0021_ShipmentPlan.SpdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c175c901 | this.spdMain.Change | SSP0021_ShipmentPlan.cs:1879 |  | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-643c85ff | this.spdMain.Change | SSP0021_ShipmentPlan.cs:1880 |  | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |

## SSP0021_ShipmentPlan.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01b102a0 | this.spdMain.ClipboardPasted | SSP0021_ShipmentPlan.cs:959 | try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (measure.Equals("SHIP_PLAN")) | FLAG | cellclipboardPast | true | 화면 필드/플래그 변경 |  |  |  |
| AC-47c9394f | this.spdMain.ClipboardPasted | SSP0021_ShipmentPlan.cs:963 | try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (measure.Equals("SHIP_PLAN")) ▸ for (iCol < e.CellRange.Column + e.CellRange.… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MEASURE)].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-03cd8690 | this.spdMain.ClipboardPasted | SSP0021_ShipmentPlan.cs:964 | try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (measure.Equals("SHIP_PLAN")) ▸ for (iCol < e.CellRange.Column + e.CellRange.… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-6b0a5d0d | this.spdMain.ClipboardPasted | SSP0021_ShipmentPlan.cs:966 | try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (measure.Equals("SHIP_PLAN")) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7758a671 | this.spdMain.ClipboardPasted | SSP0021_ShipmentPlan.cs:972 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fdf73011 | this.spdMain.ClipboardPasted | SSP0021_ShipmentPlan.cs:973 | catch ((Exception ex)) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e700eec4 | this.spdMain.ClipboardPasted | SSP0021_ShipmentPlan.cs:977 | finally | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b29b290e | this.spdMain.ClipboardPasted | SSP0021_ShipmentPlan.cs:979 |  | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0021_ShipmentPlan.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bce8e599 | this.spdMain.TopChange | SSP0021_ShipmentPlan.cs:2170 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0021_ShipmentPlan.Validation_Check

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af69b422 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:2957 |  | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d6540ff3 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:2983 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-827365f7 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:2984 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3ad63bd1 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3006 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ae0a180d | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3006 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-d3b24c3a | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3020 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6bcb2bc1 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3032 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00285", new object[] { (i + 1).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3df52575 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3034 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ccb0fbcc | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3053 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b5123812 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3053 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-15a0f2ca | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3107 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetBack… | () | 그리드 표시 설정 |  |  |  |
| AC-028890be | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3108 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-d5c071c0 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3109 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-5f926533 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3111 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].Re… | () | 그리드 표시 설정 |  |  |  |
| AC-b257b913 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3112 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-fa19b88e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3113 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetFor… | () | 그리드 표시 설정 |  |  |  |
| AC-4f808630 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3114 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-a6b54240 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3115 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-16eeaca6 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3123 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-88ec1e4e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3127 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-40fe997a | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3143 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-75c8d808 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3143 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-5a986068 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3173 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetBack… | () | 그리드 표시 설정 |  |  |  |
| AC-1a07bc42 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3174 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-3e0f6194 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3175 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-62a41dc5 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3177 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].Re… | () | 그리드 표시 설정 |  |  |  |
| AC-5d56a8f7 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3178 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-a1845b01 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3179 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetFor… | () | 그리드 표시 설정 |  |  |  |
| AC-40b01125 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3180 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-cd2ebbfb | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3181 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-ce3827bb | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3183 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00286", new object[] { (i + 1).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40a1533f | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3185 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-539a9a37 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3191 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-02041a82 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0021_ShipmentPlan.cs:3199 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

