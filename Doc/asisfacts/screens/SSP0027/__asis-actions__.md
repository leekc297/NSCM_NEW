# AS-IS 액션 대조표 — SSP0027

> 원천: `Doc/asisfacts/screens/SSP0027/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1098행 · 메서드 65 · 종류 DATA_OP 375 · GRID_SET 99 · UI_PROP 97 · GRID_INIT 79 · RETURN 75 · FLAG 65 · ENDPOINT 57 · MESSAGE 53 · POPUP 37 · GRID_LOCK 24 · UI_MISC 23 · CALL_EXT 21 · COMBO_DATA 19 · GRID_STYLE 19 · LIST_REBIND 14 · VALUE_SET 9 · VALUE_CLEAR 8 · GRID_BIND 7 · VALIDATE 5 · STATE_RESET 4 · CALL_BASE 4 · STATE 3 · GRID_COMBO 1 · ⚠ 의미 확인 필요 25


## SSP0027_ShipmentPlanEss.BtnConfirm_Click

진입점: this.btnConfirm.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-868ab3ac | this.btnConfirm.Click | SSP0027_ShipmentPlanEss.cs:1902 | if (UserInfoContext.Current["NowGroupID"] == "DM Planner") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3610589 | this.btnItemId.Click | SSP0027_ShipmentPlanEss.cs:2304 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-dcfbae18 | this.btnItemId.Click | SSP0027_ShipmentPlanEss.cs:2306 |  | POPUP | popItem.Form_Load | (true, sDivision_ID, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-bf933a7f | this.btnItemId.Click | SSP0027_ShipmentPlanEss.cs:2307 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1fd597a6 | this.btnItemId.Click | SSP0027_ShipmentPlanEss.cs:2308 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-330fc413 | this.btnItemId.Click | SSP0027_ShipmentPlanEss.cs:2314 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.BtnMaterialId2_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfed3bf5 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:823 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-517ae285 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:825 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6e5abc43 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:826 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fdd15b3c | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:827 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-33e0d86a | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:833 | if (popItem.ItemID != "") | VALUE_SET | txtModel2.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.BtnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70ce7588 | this.btnMeasure.Click | SSP0027_ShipmentPlanEss.cs:860 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5695076a | this.btnMeasure.Click | SSP0027_ShipmentPlanEss.cs:864 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ed86556 | this.btnMeasure.Click | SSP0027_ShipmentPlanEss.cs:865 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9abe1b38 | this.btnMeasure.Click | SSP0027_ShipmentPlanEss.cs:870 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-74894f9a | this.btnMeasure.Click | SSP0027_ShipmentPlanEss.cs:871 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f7d7852 | this.btnMeasure.Click | SSP0027_ShipmentPlanEss.cs:874 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0027", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-79280abf | this.btnMeasure.Click | SSP0027_ShipmentPlanEss.cs:875 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f5b32010 | this.btnMeasure.Click | SSP0027_ShipmentPlanEss.cs:876 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dd2b267b | this.btnMeasure.Click | SSP0027_ShipmentPlanEss.cs:880 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-4125135e | this.btnMeasure.Click | SSP0027_ShipmentPlanEss.cs:890 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.BtnRequestor_Click

진입점: this.btnRequestor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffcfe2a2 | this.btnRequestor.Click | SSP0027_ShipmentPlanEss.cs:1866 |  | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-cc75137b | this.btnRequestor.Click | SSP0027_ShipmentPlanEss.cs:1868 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-bade7fe2 | this.btnRequestor.Click | SSP0027_ShipmentPlanEss.cs:1869 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-b7c2bbc8 | this.btnRequestor.Click | SSP0027_ShipmentPlanEss.cs:1870 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6e33f730 | this.btnRequestor.Click | SSP0027_ShipmentPlanEss.cs:1871 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-059682f8 | this.btnRequestor.Click | SSP0027_ShipmentPlanEss.cs:1872 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-f2ffb9a9 | this.btnRequestor.Click | SSP0027_ShipmentPlanEss.cs:1874 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-f0e55697 | this.btnRequestor.Click | SSP0027_ShipmentPlanEss.cs:1876 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-536fe3b4 | this.btnRequestor.Click | SSP0027_ShipmentPlanEss.cs:1882 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sRequestor | item.UserID | 화면 필드/플래그 변경 |  |  |  |
| AC-da567c31 | this.btnRequestor.Click | SSP0027_ShipmentPlanEss.cs:1886 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName | 컨트롤 값 설정 |  |  |  |
| AC-2e7feb8b | this.btnRequestor.Click | SSP0027_ShipmentPlanEss.cs:1890 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName_E | 컨트롤 값 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.BtnSearch_Click

진입점: this.btnSearch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6475d2f | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5650 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-41caae8c | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5651 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtPlanDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-50f5b6ec | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5655 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) | FLAG | bDetail_DbClick | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e92fcab7 | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5660 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPRPODetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a0f56f5c | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5661 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtPRPODetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1c514d08 | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5665 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) | FLAG | bDetail_DbClick | false | 화면 필드/플래그 변경 |  |  |  |
| AC-350edd82 | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5670 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtNetDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f566b018 | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5671 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtNetDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-df598f08 | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5677 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if… | FLAG | bDetail_DbClick | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d4dbe71a | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5681 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ el… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-27c0eecf | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5682 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ el… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentResult) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4521af63 | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5686 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ el… | FLAG | bDetail_DbClick | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1d5607f6 | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5690 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ el… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentMonthly) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-284909d1 | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5691 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ el… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentMonthly) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-057e73ed | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5695 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ el… | FLAG | bDetail_DbClick | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e435e853 | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5699 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ el… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentDaliy) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c8d875c | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5700 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ el… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentDaliy) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-96954300 | this.btnSearch.Click | SSP0027_ShipmentPlanEss.cs:5704 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ el… | FLAG | bDetail_DbClick | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0027_ShipmentPlanEss.BtnSimulation_Click

진입점: this.btnSimulation.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a557b3a | this.btnSimulation.Click | SSP0027_ShipmentPlanEss.cs:1912 | if (UserInfoContext.Current["NowGroupID"] == "DM Planner") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.cboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66366d5b | cboPlanDate.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5610 | if (cboPlanDate.ControlValues != null) | DATA_OP | dtPlanDate.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-baa8bf38 | cboPlanDate.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5610 | if (cboPlanDate.ControlValues != null) ▸ lambda | DATA_OP | row.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-94cafc53 | cboPlanDate.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5619 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod.Value1 | Convert.ToDateTime(dr["FROM_DATE"].ToString()) | 속성 Value1 설정 |  |  |  |
| AC-074ae882 | cboPlanDate.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5620 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod.Value2 | Convert.ToDateTime(dr["TO_DATE"].ToString()) | 속성 Value2 설정 |  |  |  |
| AC-802193af | cboPlanDate.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5621 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod2.Value1 | Convert.ToDateTime(sPlanDate) | 속성 Value1 설정 |  |  |  |
| AC-8fd7c6be | cboPlanDate.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5622 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod2.Value2 | Convert.ToDateTime(dr["TO_DATE"].ToString()) | 속성 Value2 설정 |  |  |  |
| AC-0e873b02 | cboPlanDate.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5628 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOr… | VALUE_CLEAR | txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-b8066d05 | cboPlanDate.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5629 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOr… | VALUE_CLEAR | txtModel2.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e50169f3 | cboPlanDate.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5630 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOr… | VALUE_CLEAR | txtRequestor.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1584940f | cboPlanDate.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5636 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (cboPlanDate.SelectedIndex == 0) | FLAG | bRealFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-fbac3a8a | cboPlanDate.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5640 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ else of (cboPlanDate.SelectedIndex == 0) | FLAG | bRealFlag | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0027_ShipmentPlanEss.chkERPIFBlockYn

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5deb2b8f | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2760 |  | FLAG | dtERPBlockYnIF | Data_SCP.Common(Data_SCP.Type.SSPBlockCheckIF, false, "SSP0027") | 화면 필드/플래그 변경 |  |  |  |
| AC-f9002f32 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2760 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSPBlockCheckIF, false, "SSP0027") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-35525a9e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2763 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("BLOCK_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3e16b23 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2772 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("PERIOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-eeed2540 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2773 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00267", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-acf112ec | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2777 |  | RETURN | return resultYn; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.clbCompanyID_SelectedIndexChanged

진입점: clbCompany_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b6b4dc0 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5542 |  | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.Com_FromSite, false, strSelDivision_ID, GetNERPCode("SSP0027… | 화면 필드/플래그 변경 |  |  |  |
| AC-54ffdb4e | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5542 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Com_FromSite, false, strSelDivision_ID, GetNERPCode("SSP0027_ShipmentPlanEs… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2b766b87 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5546 |  | FLAG | dtFromSite | dtFromSite.Select().Where(c => c["CODE"].ToString() == GetNERPCode("SSP0027_ShipmentPlanEs… | 화면 필드/플래그 변경 |  |  |  |
| AC-9af2cb97 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5546 |  | DATA_OP | dtFromSite.Select().Where(c => c["CODE"].ToString() == GetNERPCode("SSP0027_ShipmentPlanEs… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c7892f8b | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5546 |  | DATA_OP | dtFromSite.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eff90ce8 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5548 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6a724f46 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5550 |  | CALL_EXT | clbPlantSite.SetAllCheckItem | (true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f41db080 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5555 |  | FLAG | dtPlanDate | Data_SCP.Common(Data_SCP.Type.Plan_Infor_ESS, false, strSelDivision_ID, strSelCompany_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-2e852ea8 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5555 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Plan_Infor_ESS, false, strSelDivision_ID, strSelCompany_ID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-25a9a53d | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5556 |  | FLAG | dtPlanDate21 | Data_SCP.Common(Data_SCP.Type.Plan_Infor, false, strSelCompany_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-3ffa6cd5 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5556 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Plan_Infor, false, strSelCompany_ID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a700be3 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5558 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f1e23078 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5559 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate21, cboPlanDate21, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c0c9eb70 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5560 |  | VALUE_CLEAR | cboPlanDate.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-462bb30a | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5566 |  | VALUE_CLEAR | txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a217fad0 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5567 |  | VALUE_CLEAR | txtModel2.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-fabadabd | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5568 |  | VALUE_CLEAR | txtRequestor.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-643ec264 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5569 |  | UI_PROP | drpPeriod.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-cc82285c | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5570 |  | UI_PROP | drpPeriod.Text2 | "" | 속성 Text2 설정 |  |  |  |
| AC-92a4c8b7 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5571 |  | UI_PROP | drpPeriod2.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-11d1cd04 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5572 |  | UI_PROP | drpPeriod2.Text2 | "" | 속성 Text2 설정 |  |  |  |
| AC-95df3285 | clbCompany_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5576 | if (cboPlanDate.Items.Count > 0) | VALUE_SET | cboPlanDate.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.clbDivision_ID_SelectedIndexChanged

진입점: clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3db9338 | clbDivision_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5518 |  | DATA_OP | dtCompany.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5a5c39cd | clbDivision_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5520 | if (dtCompany.Select().Where(c => c["DIVISION_ID"].ToString() == strSelDivision_ID).Count() > 0) | DATA_OP | dtCompany.Select().Where(c => c["DIVISION_ID"].ToString() == strSelDivision_ID).CopyToData… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7ac5e885 | clbDivision_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5520 | if (dtCompany.Select().Where(c => c["DIVISION_ID"].ToString() == strSelDivision_ID).Count() > 0) | DATA_OP | dtCompany.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aae4640d | clbDivision_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5522 |  | LIST_REBIND | clsCtrl.setListBox | (dtDiv_Company_ID, clbCompany_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3407a253 | clbDivision_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5526 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | CALL_EXT | clbCompany_ID.FindString | (sUserCompany_NM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-44a299fb | clbDivision_ID.SelectedIndexChanged | SSP0027_ShipmentPlanEss.cs:5527 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | VALUE_SET | clbCompany_ID.SelectedIndex | intComIdx | 컨트롤 값 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c33a3028 | this.Load | SSP0027_ShipmentPlanEss.cs:575 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a6875455 | this.Load | SSP0027_ShipmentPlanEss.cs:576 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-32e2b496 | this.Load | SSP0027_ShipmentPlanEss.cs:579 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtPlanDetail, SpdSheet.shtPlanDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-46efc2c8 | this.Load | SSP0027_ShipmentPlanEss.cs:580 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtPRPODetail, SpdSheet.shtPRPODetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9477573b | this.Load | SSP0027_ShipmentPlanEss.cs:581 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtNetDetail, SpdSheet.shtNetDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-46685913 | this.Load | SSP0027_ShipmentPlanEss.cs:582 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtShipmentResult, SpdSheet.shtShipmentResult, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-eb0f35ab | this.Load | SSP0027_ShipmentPlanEss.cs:583 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtShipmentMonthly, SpdSheet.shtShipmentMonthly, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cd949f4c | this.Load | SSP0027_ShipmentPlanEss.cs:584 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtShipmentDaliy, SpdSheet.shtShipmentDaliy, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1c022952 | this.Load | SSP0027_ShipmentPlanEss.cs:589 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtPlanDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b98b9b9 | this.Load | SSP0027_ShipmentPlanEss.cs:590 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b9c9fbe | this.Load | SSP0027_ShipmentPlanEss.cs:593 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtPRPODetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-de46893c | this.Load | SSP0027_ShipmentPlanEss.cs:594 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPRPODetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7a115f54 | this.Load | SSP0027_ShipmentPlanEss.cs:597 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtNetDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-749d80de | this.Load | SSP0027_ShipmentPlanEss.cs:598 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtNetDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9dd6daa | this.Load | SSP0027_ShipmentPlanEss.cs:601 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtShipmentResult) | 화면 필드/플래그 변경 |  |  |  |
| AC-78def86c | this.Load | SSP0027_ShipmentPlanEss.cs:602 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c45ba143 | this.Load | SSP0027_ShipmentPlanEss.cs:605 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtShipmentMonthly) | 화면 필드/플래그 변경 |  |  |  |
| AC-4aec3853 | this.Load | SSP0027_ShipmentPlanEss.cs:606 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentMonthly) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b1796546 | this.Load | SSP0027_ShipmentPlanEss.cs:609 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtShipmentDaliy) | 화면 필드/플래그 변경 |  |  |  |
| AC-8a20ccb7 | this.Load | SSP0027_ShipmentPlanEss.cs:610 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentDaliy) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-df54985b | this.Load | SSP0027_ShipmentPlanEss.cs:613 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4c88f288 | this.Load | SSP0027_ShipmentPlanEss.cs:617 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0027_ShipmentPlanEss.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f217cde | this.Load | SSP0027_ShipmentPlanEss.cs:462 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-013c8871 | this.Load | SSP0027_ShipmentPlanEss.cs:464 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ce78f60 | DeleteButton | SSP0027_ShipmentPlanEss.cs:2087 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5653551c | DeleteButton | SSP0027_ShipmentPlanEss.cs:2129 | if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ else of ("True" == siDetail.GetValue(activeRo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-386bb598 | DeleteButton | SSP0027_ShipmentPlanEss.cs:2135 | if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ else of ("True" == siDetail.GetValue(activeRo… | DATA_OP | siDetail.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0027_ShipmentPlanEss.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9228bba0 | Dispose | SSP0027_ShipmentPlanEss.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0027_ShipmentPlanEss.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea1483c6 | EditButton | SSP0027_ShipmentPlanEss.cs:2153 | if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e3bc0fa6 | EditButton | SSP0027_ShipmentPlanEss.cs:2154 | if (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3c0b0c05 | EditButton | SSP0027_ShipmentPlanEss.cs:2162 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtNetDetail \|\| siDetail.A… | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2bc6ff28 | EditButton | SSP0027_ShipmentPlanEss.cs:2163 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtNetDetail \|\| siDetail.A… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa0c8184 | EditButton | SSP0027_ShipmentPlanEss.cs:2169 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bRealFlag == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00312", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e4bcf0e | EditButton | SSP0027_ShipmentPlanEss.cs:2170 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bRealFlag == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ebb02d05 | EditButton | SSP0027_ShipmentPlanEss.cs:2177 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) | FLAG | siDetail | GetSheetInfo(spdDetail.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f6376d48 | EditButton | SSP0027_ShipmentPlanEss.cs:2178 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) | GRID_LOCK | siDetail.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e056ed2a | EditButton | SSP0027_ShipmentPlanEss.cs:2188 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (i < si… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColumns.REQUE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-00bdee9d | EditButton | SSP0027_ShipmentPlanEss.cs:2189 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (i < si… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.REMARKS3), siDetail.GetColumnIndex(DefColumns.CONFIRM_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a50182f2 | EditButton | SSP0027_ShipmentPlanEss.cs:2191 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (i < si… | GRID_LOCK | siDetail.LockRange | (i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), i, siDetail.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2a872a27 | EditButton | SSP0027_ShipmentPlanEss.cs:2196 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (i < si… | GRID_LOCK | siDetail.LockRange | (i, 0, i, siDetail.GetMaxColumnIndex(), true, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-727757dd | EditButton | SSP0027_ShipmentPlanEss.cs:2204 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4c9401a0 | EditButton | SSP0027_ShipmentPlanEss.cs:2208 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | FLAG | siDetail | GetSheetInfo(spdDetail.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6617de8b | EditButton | SSP0027_ShipmentPlanEss.cs:2209 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | GRID_LOCK | siDetail.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-bfc8e769 | EditButton | SSP0027_ShipmentPlanEss.cs:2221 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (i, 1, i, siDetail.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-72c6d86c | EditButton | SSP0027_ShipmentPlanEss.cs:2228 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (i, siDetail.GetColumnIndex(DefColumns.PR_CHECK), i, siDetail.GetColumnIndex(DefColumns.PR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0651c167 | EditButton | SSP0027_ShipmentPlanEss.cs:2229 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (i, siDetail.GetColumnIndex(DefColumns.INV_ALLO_QTY), i, siDetail.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7038846e | EditButton | SSP0027_ShipmentPlanEss.cs:2230 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (i, siDetail.GetColumnIndex("EDIT_CHECK"), i, siDetail.GetColumnIndex("EDIT_CHECK"), false… | 그리드 편집 잠금/해제 |  |  |  |
| AC-934950dc | EditButton | SSP0027_ShipmentPlanEss.cs:2236 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (i, siDetail.GetColumnIndex(DefColumns.PR_CHECK), i, siDetail.GetColumnIndex(DefColumns.PR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8b67f9d2 | EditButton | SSP0027_ShipmentPlanEss.cs:2237 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (i, siDetail.GetColumnIndex(DefColumns.INV_ALLO_QTY), i, siDetail.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f2e7a4c0 | EditButton | SSP0027_ShipmentPlanEss.cs:2238 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (i, siDetail.GetColumnIndex("EDIT_CHECK"), i, siDetail.GetColumnIndex("EDIT_CHECK"), false… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a691fcff | EditButton | SSP0027_ShipmentPlanEss.cs:2243 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (i, 1, i, siDetail.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9abc466f | EditButton | SSP0027_ShipmentPlanEss.cs:2259 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | FLAG | bEdit_Mode_Detail | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2d3c8b08 | EditButton | SSP0027_ShipmentPlanEss.cs:2269 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (i, 1, i, siDetail.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-96928418 | EditButton | SSP0027_ShipmentPlanEss.cs:2285 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (si… | FLAG | bEdit_Mode_Detail | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0027_ShipmentPlanEss.ERP_PR_REQUEST_SEND

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cf1722d | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3362 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_GET_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0027_GET_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-b60eeacd | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3366 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f87e2370 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3367 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2396842f | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3368 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-fbabbdfb | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3369 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-7ba5e366 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3370 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-ee0d2ea3 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3371 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-77751848 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3372 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-42954ad8 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3374 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-98659f3e | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3394 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6fd4a8a2 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3398 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.FindData_Detail

진입점: this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail)] / SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (bDetail_DbClick == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0ad590b | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4795 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f1dff2af | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4800 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fd94791a | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4849 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-186096e5 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4853 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_GET_SHIPMENT_PLAN_DETAIL") ⇒ SSP.SSP0027_GET_SHIPMENT_PLAN_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-d6254e30 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4854 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-080a6007 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4855 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-36af9423 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4856 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-1945efdd | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4857 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-46878dd4 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4858 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a33db52e | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4859 | try | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-f3da3fd4 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4860 | try | DATA_OP | request.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-17d4ce9d | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4861 | try | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-629aacdf | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4862 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-dc4e437d | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4863 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-688894ec | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4864 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6901d1a7 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4865 | try | DATA_OP | request.Parameters["p_dbl_flag"] | p_dbl_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6043038d | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4866 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-22c96087 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4867 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-18b41349 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4868 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc4cd144 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4869 | try | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-571de33c | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4870 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-f788f1e1 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4871 | try | DATA_OP | request.Parameters["p_pr_no"] | p_pr_no | 행/컬럼 값 대입 |  |  |  |
| AC-a9bd888a | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4873 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-fd0eefbd | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4875 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1ba7a1f0 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4884 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-10d23b10 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4885 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-93f70a9a | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4890 | try ▸ if (DefaultDetailDS != null) | STATE_RESET | DefaultDetailDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-3ef55230 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4892 | try | FLAG | DefaultDetailDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-383f59a2 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4892 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0e923cd9 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4895 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-345f7447 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4909 | finally | FLAG | bEdit_Mode_Detail | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e5aa07f7 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0027_ShipmentPlanEss.cs:4912 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0027_ShipmentPlanEss.FindData_Main

진입점: FindButton / SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet.RowCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b675f5b | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4495 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-44fe88d7 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4500 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-4400c0d3 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4500 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a134a1b | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4508 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-47ecb0c4 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4509 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-2a276179 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4509 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4ebafc5 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4544 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-af91dcc2 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4545 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-62204d14 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4549 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_GET_SHIPMENT_PLAN") ⇒ SSP.SSP0027_GET_SHIPMENT_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-8e82b65f | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4551 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-28eb4cb4 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4553 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-443c9c20 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4554 | try ▸ lambda | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-a17c8bd1 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4555 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-40303999 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4556 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-82e4aa34 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4557 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1a5ad694 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4558 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-bc2eda52 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4559 | try ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-1ae2b829 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4560 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c3c54bc3 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4561 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-76407e76 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4562 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-639499f7 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4563 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-ba2f8a28 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4564 | try ▸ lambda | DATA_OP | req.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-834467f3 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4566 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3b6b21fa | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4567 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8c79f0e5 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4575 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-266e2006 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4576 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d248321f | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4587 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0fe0df16 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4596 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2127d305 | FindButton 외 1 | SSP0027_ShipmentPlanEss.cs:4605 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0027_ShipmentPlanEss.FindData_NET_History

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtNetDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-695bdd6f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5192 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d15887ac | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5197 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9fce94a7 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5244 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-99ad2fff | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5248 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_GET_NETTING_HISTORY") ⇒ SSP.SSP0027_GET_NETTING_HISTORY | 엔드포인트 요청 생성 |  |  |  |
| AC-c11f421b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5249 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a57dd114 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5250 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c7645114 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5251 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-113119fa | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5252 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-5a3f7e15 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5253 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-9d56e516 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5254 | try | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-2dca041c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5255 | try | DATA_OP | request.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-52e05071 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5256 | try | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-7e451675 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5257 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-80f72125 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5258 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ddf0cf6c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5259 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e1fa3374 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5260 | try | DATA_OP | request.Parameters["p_dbl_flag"] | p_dbl_flag | 행/컬럼 값 대입 |  |  |  |
| AC-0af69ca4 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5261 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-4ad15874 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5262 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-d328c00a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5263 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-533d6139 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5264 | try | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-ed2acf5e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5265 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-8222cf4a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5266 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-9cd8b1cf | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5268 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7d0e7146 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5277 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e1625c84 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5278 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e6378e38 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5280 | try | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6e3b4b9d | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5283 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-44a9c2ff | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5295 | finally | FLAG | bEdit_Mode_Detail | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f1013d1a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5297 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0027_ShipmentPlanEss.FindData_PO_PR_Detail

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail)] / SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetail.SheetName == SpdSheet.shtPRPODetail) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (p_pr_check.Contains("True")) ▸ if (!bQtyEqual) ▸ if (!GetErpPRIFCheck(ds.Tables[0].Rows[0][2].ToString())) ▸ if (siDetail.ActiveSheet.RowCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71fcb966 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5302 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-35d65815 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5307 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-28847c99 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5354 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e5ff1c3f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5358 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_GET_SHIPMENT_PR_PO_DETAIL") ⇒ SSP.SSP0027_GET_SHIPMENT_PR_PO_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-59baf2e7 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5359 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-56570f31 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5360 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-eeaca5af | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5361 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-522cbd11 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5362 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-b712eb6f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5363 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-836769f0 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5364 | try | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-a187ce53 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5365 | try | DATA_OP | request.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-950161a4 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5366 | try | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-2a59cd31 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5367 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-bb81a00e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5368 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-53651f14 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5369 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cb1762f2 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5370 | try | DATA_OP | request.Parameters["p_dbl_flag"] | p_dbl_flag | 행/컬럼 값 대입 |  |  |  |
| AC-8f3c3d6b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5371 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-4e0a2620 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5372 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-75df12e8 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5373 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-90d999a1 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5374 | try | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-904c51b3 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5375 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a858839b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5376 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-7cbdce60 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5378 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c2858699 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5387 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7cc2bbcd | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5388 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-baa3628e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5391 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-85c58f64 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5400 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f35609a8 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5404 | finally | FLAG | bEdit_Mode_Detail | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5fecd250 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0027_ShipmentPlanEss.cs:5406 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0027_ShipmentPlanEss.FindData_Shipment_Daily

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtNetDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtShipmentResult) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtShipmentMonthly) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtShipmentDaliy)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f368951 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5013 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e1ed89b1 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5018 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a7bbd887 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5047 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-3173686a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5052 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_GET_SHIPMENT_BOH_DAILY") ⇒ SSP.SSP0027_GET_SHIPMENT_BOH_DAILY | 엔드포인트 요청 생성 |  |  |  |
| AC-1ab2da95 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5053 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-13db4898 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5054 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-dbdea0c5 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5055 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6d258da7 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5056 | try | DATA_OP | request.Parameters["p_storage_id"] | p_storage_id | 행/컬럼 값 대입 |  |  |  |
| AC-773530da | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5057 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6ec55d37 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5058 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-23fc60df | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5059 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9f5ab432 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5060 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-841eca4d | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5061 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-0b5bdead | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5064 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ce7d8ca0 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5073 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-94e55201 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5074 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1f592d74 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5077 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aeb07e18 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5091 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0027_ShipmentPlanEss.FindData_Shipment_Monthly

진입점: this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColumnIndex("M_BOH_QTY"))] / this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtNetDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtShipmentResult) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtShipmentMonthly)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-981d3818 | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4918 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c14a494a | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4923 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c074f890 | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4953 | try ▸ if (bolDoubleClick) | VALUE_SET | cboPlanDate21.SelectedValue | p_plan_start_yyyymmdd | 컨트롤 값 설정 |  |  |  |
| AC-e60bed82 | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4963 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-644c131a | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4968 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_GET_SHIPMENT_BOH_MONTHLY") ⇒ SSP.SSP0027_GET_SHIPMENT_BOH_MONTHLY | 엔드포인트 요청 생성 |  |  |  |
| AC-9412ef10 | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4969 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-42d3f51c | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4970 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0143ca31 | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4971 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5c9b428c | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4972 | try | DATA_OP | request.Parameters["p_storage_id"] | p_storage_id | 행/컬럼 값 대입 |  |  |  |
| AC-a5dc1b57 | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4973 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-69a5c8d6 | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4974 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-066b1104 | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4975 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-33556532 | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4976 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-4e18f679 | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4977 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-6779a20e | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4980 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a541cd61 | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4989 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3d2217bb | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4990 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-64b2b877 | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:4993 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-39a2196e | this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColu… 외 1 | SSP0027_ShipmentPlanEss.cs:5008 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0027_ShipmentPlanEss.FindData_Shipment_Result

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtNetDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtShipmentResult)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aaaa3b9a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5096 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-abaf7e69 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5101 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1eb2a04c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5137 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ea26be5e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5142 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_GET_SHIPMENT_RESULT") ⇒ SSP.SSP0027_GET_SHIPMENT_RESULT | 엔드포인트 요청 생성 |  |  |  |
| AC-db844116 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5143 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f2616d53 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5144 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ae2d64d5 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5145 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-e88b2e89 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5146 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-560e0bbc | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5147 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6d137a98 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5148 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4df9d61e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5149 | try | DATA_OP | request.Parameters["p_type"] | p_type | 행/컬럼 값 대입 |  |  |  |
| AC-949a1bf4 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5150 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-421c74fd | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5151 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-4be162d7 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5152 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-8d2ab2db | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5153 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-570ec07c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5154 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-81272769 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5155 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-048ef404 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5156 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-69f68908 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5157 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1f5bbbf7 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5158 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a9ed7d9a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5160 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0c9bfefc | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5169 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-59ce69f5 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5170 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b38a8f54 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5173 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-55feaa08 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0027_ShipmentPlanEss.cs:5187 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0027_ShipmentPlanEss.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b79818b | this.Load | SSP0027_ShipmentPlanEss.cs:357 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d04d23f0 | this.Load | SSP0027_ShipmentPlanEss.cs:366 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | VALUE_CLEAR | clbCompany_ID.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-36dff358 | this.Load | SSP0027_ShipmentPlanEss.cs:367 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | CALL_EXT | clbCompany_ID.FindString | (sUserCompany_NM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-77e74345 | this.Load | SSP0027_ShipmentPlanEss.cs:368 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | VALUE_SET | clbCompany_ID.SelectedIndex | intComIdx | 컨트롤 값 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a048549 | this.Load | SSP0027_ShipmentPlanEss.cs:4487 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-2c7f717e | this.Load | SSP0027_ShipmentPlanEss.cs:4488 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4eb45cbf | this.Load | SSP0027_ShipmentPlanEss.cs:4490 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.GetErpIFCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc80a689 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4196 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7e23b26 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4205 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0027_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-dd0baf8b | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4206 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-144f6285 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4207 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0d882244 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4209 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-726af291 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4220 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a44cd362 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4227 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5a3bfe9a | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4232 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (service.RtFlag == "C_E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1cece173 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4243 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.GetErpIFCheckNew

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!string.IsNullOrWhiteSpace(sRequestNo))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-491e5fed | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4255 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-08860b4d | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4264 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (service.ReErrorMsg.EndsWith("^")) | UI_PROP | service.ReErrorMsg | service.ReErrorMsg.Substring(0, service.ReErrorMsg.Length - 1) | 속성 ReErrorMsg 설정 |  |  |  |
| AC-8efbe651 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4271 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ for (iCount < arrReMsg.Length) | DATA_OP | errConfirmList.Add | (arrReMsg[iCount] + ":" + RequestNo) | 데이터 객체 조작/조회 |  |  |  |
| AC-f378e23a | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4275 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ for (iCount < arrReMsg.Length) | DATA_OP | errConfrimList2.Add | (arrConfirm[0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1007d0b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4283 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM") ⇒ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-665cab7e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4285 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-308b06aa | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4286 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-eeaa9dc8 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4287 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-49f02dc4 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4288 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b3f90349 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4289 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-75459112 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4290 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_if_send_flag"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-cb8c8e3b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4291 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-2edcc42c | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4293 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d0abadfc | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4309 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH") ⇒ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-cf0f3799 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4311 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | DATA_OP | request.Parameters["p_change_type"] | "B" | 행/컬럼 값 대입 |  |  |  |
| AC-f580db78 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4312 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | DATA_OP | request.Parameters["p_change_req_no"] | RequestNo | 행/컬럼 값 대입 |  |  |  |
| AC-94f61a9e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4314 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a3699007 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4319 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd27c275 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4325 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | bActiveList.Add | (bFlag) | 데이터 객체 조작/조회 |  |  |  |
| AC-feef9877 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4330 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | FLAG | F_CE_requestNo | RequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-d6fba5c7 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4339 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH") ⇒ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-be730300 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4341 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_type"] | "B" | 행/컬럼 값 대입 |  |  |  |
| AC-d397c271 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4342 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_req_no"] | RequestNo | 행/컬럼 값 대입 |  |  |  |
| AC-eeef1494 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4344 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-87cfae95 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4349 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8abe3c81 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4352 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | bActiveList.Add | (bFlag) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca7d5ab5 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4358 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.GetErpIFCheckNew_

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffa1bf4f | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4140 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "P", "A") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bafd0dfe | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4149 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0027_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-6077e7ce | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4150 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-ff933e81 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4151 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-159a0b5a | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4153 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-49e4d452 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4164 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e9890929 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4171 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-141475c2 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4176 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (service.RtFlag == "C_E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a6b52de9 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:4187 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.GetERPInterface

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0971f40 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3004 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-47fa2463 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3014 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | DATA_OP | (siDetail.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b2f1118d | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3026 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | MESSAGE | MessageHelper.GMessageBox | ("MSG00247", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-46652c70 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3027 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4cb7e436 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3036 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f480cfb4 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3037 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-de3a00cd | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3127 | try ▸ if (errConfirmList.Count > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM") ⇒ SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-73aa1c06 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3129 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-b27f4e75 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3130 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id2 | 행/컬럼 값 대입 |  |  |  |
| AC-9e859da8 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3131 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_e_type"] | "E" | 행/컬럼 값 대입 |  |  |  |
| AC-9d216691 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3132 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_e_message"] | p_e_message | 행/컬럼 값 대입 |  |  |  |
| AC-6e2fdd78 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3133 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-15ef6c1b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3135 | try ▸ if (errConfirmList.Count > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-82742252 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3141 | try ▸ if (errConfirmList.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0226093e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3168 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM") ⇒ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-15d32383 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3170 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id_F_CE | 행/컬럼 값 대입 |  |  |  |
| AC-91bb5a75 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3171 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_change_request_no"] | F_CE_requestNo | 행/컬럼 값 대입 |  |  |  |
| AC-d9e4dae2 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3172 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-b4a4e328 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3173 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-40ee6663 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3174 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-a96568a7 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3175 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_if_send_flag"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-2d045b1c | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3176 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-1c329683 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3178 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5f046f91 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3184 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | CALL_EXT | service.FN_ERP_UIWebService | (F_CE_requestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-60276bca | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3189 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-23b45f48 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3194 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-7a1ac579 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3197 | finally | STATE_RESET | bActiveList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-d1de2c0d | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3198 | finally | STATE_RESET | errConfirmList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-8aab046f | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3199 | finally | FLAG | F_CE_requestNo | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-d6c1f77e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3201 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.GetErpPRIFCheck

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetail.SheetName == SpdSheet.shtPRPODetail) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (p_pr_check.Contains("True")) ▸ if (!bQtyEqual)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd66aab7 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4368 | try | CALL_EXT | service.FN_ERP_PR_UIWebService | (ifseqno, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0e8ce81e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4375 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f75afa33 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4382 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-15acae0c | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4387 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (service.RtFlag == "C_E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-44fcff81 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4403 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ else of (service.RtFlag == "C_E") ▸ else of (service.RtFlag == "Z"… | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { service.RtFlag +"-" + arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39946dcb | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:4409 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.GetErpSoNoCnt

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d440f55 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:3473 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_GET_ERP_SO_NO_CNT") ⇒ SSP.SSP0027_GET_ERP_SO_NO_CNT | 엔드포인트 요청 생성 |  |  |  |
| AC-9cb553d4 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:3474 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-5662bb4f | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:3475 | try | DATA_OP | request.Parameters["p_erp_so_no"] | sErpSoNo | 행/컬럼 값 대입 |  |  |  |
| AC-b8576bdf | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:3477 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-17535f1c | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:3485 | catch ((Exception ex)) | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |
| AC-4a32e898 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:3487 |  | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.GetNERPCode

진입점: this.Load [lambda] / clbCompany_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e23a1c19 | this.Load [lambda] 외 1 | SSP0027_ShipmentPlanEss.cs:5588 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_NERP_CODE") ⇒ SSP.SSP0002_GET_NERP_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-8b774a03 | this.Load [lambda] 외 1 | SSP0027_ShipmentPlanEss.cs:5589 | try | DATA_OP | request.Parameters["P_PROCEDURE_KEY"] | sFileName | 행/컬럼 값 대입 |  |  |  |
| AC-fbdfc859 | this.Load [lambda] 외 1 | SSP0027_ShipmentPlanEss.cs:5590 | try | DATA_OP | request.Parameters["P_SEQUENCE"] | sGERPCode | 행/컬럼 값 대입 |  |  |  |
| AC-74bf63d1 | this.Load [lambda] 외 1 | SSP0027_ShipmentPlanEss.cs:5592 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ceafe424 | this.Load [lambda] 외 1 | SSP0027_ShipmentPlanEss.cs:5600 | catch ((Exception ex)) | RETURN | return sReturn; |  | 처리 중단/반환 |  |  |  |
| AC-2ae58d72 | this.Load [lambda] 외 1 | SSP0027_ShipmentPlanEss.cs:5602 |  | RETURN | return sReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.GetNewERPInterface

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ef96724 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3226 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!GetShipmentStatusChk(p_division_id, p_status_ch… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9bb6356b | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3236 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo)) | DATA_OP | (siDetail.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5637821c | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3248 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (iErpS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00247", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c9c3c97 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3249 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (iErpS… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5d9c8100 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3258 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (DateTime.TryParse(siDetail.GetText(i, siDetail.G… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d5635b9 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3259 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (DateTime.TryParse(siDetail.GetText(i, siDetail.G… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-76167a1c | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3290 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (this.NewNonSoNo(i, action) == false) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2d8d5043 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3299 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-881ebde8 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3301 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.GetShipmentStatusChk

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d97f0830 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:3408 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_GET_SHIPMENT_STATUS") ⇒ SSP.SSP0027_GET_SHIPMENT_STATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-86872e78 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:3409 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-dca3495a | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:3410 | try | DATA_OP | request.Parameters["p_confirm_id"] | sConfirmID | 행/컬럼 값 대입 |  |  |  |
| AC-e4145960 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:3412 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-32a53175 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:3427 | try ▸ if (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00248", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-680c6e5a | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:3441 | try ▸ if (ds.Tables[1].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00249", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4b1b7832 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:3456 | try ▸ if (ds.Tables[2].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00189", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1811b28b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:3460 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c63c456b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… 외 1 | SSP0027_ShipmentPlanEss.cs:3462 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.GetSpdTitle

진입점: this.Load / this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColumnIndex("M_BOH_QTY")) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ try] / clbCompany_ID.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged [if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOrWhiteSpace(drpPeriod.Text2))] / FindButton [try] / SaveButton [if (siDetail != null && siDetail.I…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffde5d49 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:5716 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-6a1b1ca3 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:5719 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-a33b1c0d | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:5720 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-2712dc67 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:5725 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-d389db3e | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:5725 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0027_ShipmentPlanEss.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8eefc00 | this.Load | SSP0027_ShipmentPlanEss.cs:490 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-513f1ee3 | this.Load | SSP0027_ShipmentPlanEss.cs:493 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae290488 | this.Load | SSP0027_ShipmentPlanEss.cs:496 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-59c89169 | this.Load | SSP0027_ShipmentPlanEss.cs:498 |  | FLAG | sLanguage | UserInfoContext.Current[UserInfoProperites.Language] | 화면 필드/플래그 변경 |  |  |  |
| AC-3235ff82 | this.Load | SSP0027_ShipmentPlanEss.cs:501 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-ad11d039 | this.Load | SSP0027_ShipmentPlanEss.cs:502 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ed474dc1 | this.Load | SSP0027_ShipmentPlanEss.cs:505 |  | DATA_OP | dtPgmAuthId.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1081fb85 | this.Load | SSP0027_ShipmentPlanEss.cs:508 | if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-988f4f19 | this.Load | SSP0027_ShipmentPlanEss.cs:510 |  | FLAG | dBaseDate | Convert.ToDateTime(Convert.ToDateTime(DateTime.Now).ToString()).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-fefe479d | this.Load | SSP0027_ShipmentPlanEss.cs:514 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMaxShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[0]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-941a1f93 | this.Load | SSP0027_ShipmentPlanEss.cs:515 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMinShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[1]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-8d16f65b | this.Load | SSP0027_ShipmentPlanEss.cs:516 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMaxDay | dtShipmentInputPeriod.Rows[0]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b47aa47e | this.Load | SSP0027_ShipmentPlanEss.cs:517 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMinDay | dtShipmentInputPeriod.Rows[1]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ec9292b0 | this.Load | SSP0027_ShipmentPlanEss.cs:519 |  | FLAG | sRequestor | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-0a41cf8c | this.Load | SSP0027_ShipmentPlanEss.cs:521 |  | DATA_OP | dtResultType.Rows.RemoveAt | (3) | 데이터 객체 조작/조회 |  |  |  |
| AC-c547b053 | this.Load | SSP0027_ShipmentPlanEss.cs:523 |  | LIST_REBIND | clsCtrl.setListBox | (dtResultType, clbResultType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-36e32726 | this.Load | SSP0027_ShipmentPlanEss.cs:526 |  | LIST_REBIND | clsCtrl.setListBox | (dtStorageId, clbStorageId, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-636eaa8d | this.Load | SSP0027_ShipmentPlanEss.cs:533 |  | UI_PROP | PlanDate21.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0bdf4451 | this.Load | SSP0027_ShipmentPlanEss.cs:539 |  | STATE | clbPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-203f2efc | this.Load | SSP0027_ShipmentPlanEss.cs:540 |  | STATE | clbDivision_ID.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3e3c2cbf | this.Load | SSP0027_ShipmentPlanEss.cs:541 |  | STATE | clbCompany_ID.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0027_ShipmentPlanEss.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColumnIndex("M_BOH_QTY")) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ try] / clbCompany_ID.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged [if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOrWhiteSpace(drpPeriod.Text2))] / FindButton [try] / SaveButton [if (siDetail != null && siDetail.I…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fec2ce5c | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:627 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-8c2f19fe | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:629 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-fea8d2ea | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:636 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9269297f | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:637 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b0325740 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:642 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-a44db011 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:644 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-1b3937a2 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:646 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | LIST_REBIND | SpreadInfo.SetComBoParam | ("CHANGE_REASON_CODE_ALL", dtChangeReasonCode) | 목록 컨트롤 재구성 |  |  |  |
| AC-1b25d0e6 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:648 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-89700921 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:655 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ if (spdInfo.SheetName == SpdSheet.… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-42c20bf0 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:657 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ if (spdInfo.SheetName == SpdSheet.… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-c05a74c5 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:659 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ if (spdInfo.SheetName == SpdSheet.… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-67f1af68 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:666 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-c9217788 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:668 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-1c1bc8f4 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:669 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1282680 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:670 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-34007d76 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:675 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-2ab88fcd | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:677 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-eb006bc5 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:679 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6c8269bd | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:684 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-9fda96ff | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:686 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-6b983586 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:688 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-14542c71 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:693 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-38ce8b06 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:695 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-d9485496 | this.Load 외 7 | SSP0027_ShipmentPlanEss.cs:697 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0027_ShipmentPlanEss.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColumnIndex("M_BOH_QTY")) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / clbCompany_ID.SelectedIndexChanged [if (spdInfo.SheetName == SpdSheet.shtMain)] / cboPlanDate.SelectedIndexChanged [if (cboPlanD…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e72f058f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0027_ShipmentPlanEss.cs:705 | if (string.IsNullOrWhiteSpace(cboPlanDate.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e1279ec | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0027_ShipmentPlanEss.cs:738 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29e2431a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0027_ShipmentPlanEss.cs:742 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a6a5188 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0027_ShipmentPlanEss.cs:746 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-8c72a1e8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0027_ShipmentPlanEss.cs:753 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10ddb8d6 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0027_ShipmentPlanEss.cs:754 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c046a1a9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0027_ShipmentPlanEss.cs:759 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ba430299 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0027_ShipmentPlanEss.cs:760 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-73fb9174 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0027_ShipmentPlanEss.cs:768 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17122492 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0027_ShipmentPlanEss.cs:769 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f429eb2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0027_ShipmentPlanEss.cs:777 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8440e9c5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0027_ShipmentPlanEss.cs:778 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cfd5a7f9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0027_ShipmentPlanEss.cs:779 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b3948a6 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0027_ShipmentPlanEss.cs:780 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0027_ShipmentPlanEss.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67114b2e | InsertButton | SSP0027_ShipmentPlanEss.cs:1950 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | siDetail.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-83b6144b | InsertButton | SSP0027_ShipmentPlanEss.cs:2025 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e612f52 | InsertButton | SSP0027_ShipmentPlanEss.cs:2026 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.ITEM_ID, ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-20a96696 | InsertButton | SSP0027_ShipmentPlanEss.cs:2027 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NICK_NAME, NICK_NAME) | 데이터 객체 조작/조회 |  |  |  |
| AC-704009b1 | InsertButton | SSP0027_ShipmentPlanEss.cs:2028 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.TO_SITE_DESCRIPTION, TO_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-aad07b11 | InsertButton | SSP0027_ShipmentPlanEss.cs:2029 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | ("PROJECT_CODE", PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-3810b8d3 | InsertButton | SSP0027_ShipmentPlanEss.cs:2031 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_DATE, SHIPMENT_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-18825401 | InsertButton | SSP0027_ShipmentPlanEss.cs:2032 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_CONFIRM_QTY, SHIPMENT_CONFIRM_QTY) | 데이터 객체 조작/조회 |  |  |  |
| AC-0da64772 | InsertButton | SSP0027_ShipmentPlanEss.cs:2033 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.REMARKS2, REMARKS2) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea8555d8 | InsertButton | SSP0027_ShipmentPlanEss.cs:2034 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.REMARKS, REMARKS) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee0bbab1 | InsertButton | SSP0027_ShipmentPlanEss.cs:2035 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.TRANSPORT_MODE, TRANSPORT_MODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-4469aab3 | InsertButton | SSP0027_ShipmentPlanEss.cs:2036 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.FROM_SITE_DESCRIPTION, FROM_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-080caa58 | InsertButton | SSP0027_ShipmentPlanEss.cs:2037 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.REQUESTOR, REQUESTOR) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b7f0596 | InsertButton | SSP0027_ShipmentPlanEss.cs:2038 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.REMARKS3, REMARKS3) | 데이터 객체 조작/조회 |  |  |  |
| AC-4423fdf0 | InsertButton | SSP0027_ShipmentPlanEss.cs:2039 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.CHANGE_REASON_CODE, CHANGE_REASON_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-29c0740e | InsertButton | SSP0027_ShipmentPlanEss.cs:2040 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.CHANGE_REASON_DETAIL, CHANGE_REASON_DETAIL) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ba503e1 | InsertButton | SSP0027_ShipmentPlanEss.cs:2041 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.INCOTERMS, INCOTERMS) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8ea88da | InsertButton | SSP0027_ShipmentPlanEss.cs:2042 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.LT_DAY, LT_DAY) | 데이터 객체 조작/조회 |  |  |  |
| AC-328138e4 | InsertButton | SSP0027_ShipmentPlanEss.cs:2043 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.ETD, ETD) | 데이터 객체 조작/조회 |  |  |  |
| AC-917329f9 | InsertButton | SSP0027_ShipmentPlanEss.cs:2044 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.ETA, ETA) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe65fb83 | InsertButton | SSP0027_ShipmentPlanEss.cs:2046 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.FCST_TYPE, FCST_TYPE) | 데이터 객체 조작/조회 |  |  |  |
| AC-ffd6503f | InsertButton | SSP0027_ShipmentPlanEss.cs:2047 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.UPDATED_BY, UPDATED_BY) | 데이터 객체 조작/조회 |  |  |  |
| AC-be38fa15 | InsertButton | SSP0027_ShipmentPlanEss.cs:2048 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.UPDATED_DATE, UPDATED_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0992f5f | InsertButton | SSP0027_ShipmentPlanEss.cs:2049 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.CHANGE_REQ_NO, CHANGE_REQ_NO) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ad630e4 | InsertButton | SSP0027_ShipmentPlanEss.cs:2050 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.CONFIRM_ID, CONFIRM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-631972ae | InsertButton | SSP0027_ShipmentPlanEss.cs:2051 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.FROM_SITE, FROM_SITE) | 데이터 객체 조작/조회 |  |  |  |
| AC-8411e95e | InsertButton | SSP0027_ShipmentPlanEss.cs:2052 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.SOLDTO_DESCRIPTION, SOLDTO_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ef5e467 | InsertButton | SSP0027_ShipmentPlanEss.cs:2053 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.SHIPTO_DESCRIPTION, SHIPTO_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-9540b94e | InsertButton | SSP0027_ShipmentPlanEss.cs:2054 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.TO_SITE, TO_SITE) | 데이터 객체 조작/조회 |  |  |  |
| AC-571f8b9d | InsertButton | SSP0027_ShipmentPlanEss.cs:2055 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.ERP_STATUS, ERP_STATUS) | 데이터 객체 조작/조회 |  |  |  |
| AC-0848f1d4 | InsertButton | SSP0027_ShipmentPlanEss.cs:2056 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.BOD_ID, BOD_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-caf2851f | InsertButton | SSP0027_ShipmentPlanEss.cs:2057 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.CHANGE_TYPE, CHANGE_TYPE) | 데이터 객체 조작/조회 |  |  |  |
| AC-76777ad3 | InsertButton | SSP0027_ShipmentPlanEss.cs:2058 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NEW_ROUTE_ID, NEW_ROUTE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-515ff34f | InsertButton | SSP0027_ShipmentPlanEss.cs:2059 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NEW_BOD_ID, NEW_BOD_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-87657d85 | InsertButton | SSP0027_ShipmentPlanEss.cs:2060 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NEW_INCOTERMS, NEW_INCOTERMS) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ff71b5c | InsertButton | SSP0027_ShipmentPlanEss.cs:2061 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NEW_D_COUNTRY, NEW_D_COUNTRY) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4709d94 | InsertButton | SSP0027_ShipmentPlanEss.cs:2062 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NEW_D_PORT_CODE, NEW_D_PORT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a87e88c | InsertButton | SSP0027_ShipmentPlanEss.cs:2063 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NEW_A_COUNTRY, NEW_A_COUNTRY) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8012147 | InsertButton | SSP0027_ShipmentPlanEss.cs:2064 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NEW_A_PORT_CODE, NEW_A_PORT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-39d88f5f | InsertButton | SSP0027_ShipmentPlanEss.cs:2065 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NEW_CUSTOMER_LT, NEW_CUSTOMER_LT) | 데이터 객체 조작/조회 |  |  |  |
| AC-6cd11ac7 | InsertButton | SSP0027_ShipmentPlanEss.cs:2066 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NEW_TO_COUNTRY, NEW_TO_COUNTRY) | 데이터 객체 조작/조회 |  |  |  |
| AC-514c8708 | InsertButton | SSP0027_ShipmentPlanEss.cs:2067 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NEW_TO_CITY, NEW_TO_CITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2da30b0 | InsertButton | SSP0027_ShipmentPlanEss.cs:2068 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NEW_ETA, NEW_ETA) | 데이터 객체 조작/조회 |  |  |  |
| AC-038d8095 | InsertButton | SSP0027_ShipmentPlanEss.cs:2069 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NEW_ETD, NEW_ETD) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae04658e | InsertButton | SSP0027_ShipmentPlanEss.cs:2070 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NEW_LT_DAY, NEW_LT_DAY) | 데이터 객체 조작/조회 |  |  |  |
| AC-c41b5607 | InsertButton | SSP0027_ShipmentPlanEss.cs:2071 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NEW_TRANSPORT_MODE, NEW_TRANSPORT_MODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3ea9700 | InsertButton | SSP0027_ShipmentPlanEss.cs:2072 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.NEW_SHIPMENT_DATE, NEW_SHIPMENT_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-b21f8376 | InsertButton | SSP0027_ShipmentPlanEss.cs:2073 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | DATA_OP | defaultData.Add | (DefColumns.EDIT_REMARKS, EDIT_REMARKS) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7bdee6f | InsertButton | SSP0027_ShipmentPlanEss.cs:2075 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | GRID_SET | siDetail.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-6617613e | InsertButton | SSP0027_ShipmentPlanEss.cs:2077 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f6623d23 | InsertButton | SSP0027_ShipmentPlanEss.cs:2078 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.REMARKS3), siDetail.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0027_ShipmentPlanEss.ManualConfirm

진입점: this.btnConfirm.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb7afb39 | this.btnConfirm.Click | SSP0027_ShipmentPlanEss.cs:5731 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e7abeb51 | this.btnConfirm.Click | SSP0027_ShipmentPlanEss.cs:5740 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-235bd9d0 | this.btnConfirm.Click | SSP0027_ShipmentPlanEss.cs:5742 | try | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_ESS_SHIP_CONFIRM") ⇒ SSP.PR_SSP_ANL_ESS_SHIP_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-4e260489 | this.btnConfirm.Click | SSP0027_ShipmentPlanEss.cs:5745 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8fb4a557 | this.btnConfirm.Click | SSP0027_ShipmentPlanEss.cs:5747 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b913ecea | this.btnConfirm.Click | SSP0027_ShipmentPlanEss.cs:5751 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | strSelDivision_ID | 행/컬럼 값 대입 |  |  |  |
| AC-ee0b895e | this.btnConfirm.Click | SSP0027_ShipmentPlanEss.cs:5752 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9bd0b52a | this.btnConfirm.Click | SSP0027_ShipmentPlanEss.cs:5752 | try ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-08552979 | this.btnConfirm.Click | SSP0027_ShipmentPlanEss.cs:5759 | try ▸ if (t.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-963c3518 | this.btnConfirm.Click | SSP0027_ShipmentPlanEss.cs:5766 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ad9eb5a2 | this.btnConfirm.Click | SSP0027_ShipmentPlanEss.cs:5770 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0027_ShipmentPlanEss.NewNonSoNo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1dce750 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3599 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0027_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-d15d8b65 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3603 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f690489a | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3604 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-fa777036 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3605 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-a0a7a257 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3606 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-f1b988f8 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3607 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-5c7bbe1d | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3608 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-077bfdeb | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3609 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-776edcae | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3610 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-92766752 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3611 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-f2a61176 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3612 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-f857684e | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3613 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-a5ba3f24 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3614 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-65dbb6ec | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3615 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-aeb5b533 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3616 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-f3082712 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3617 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-19608b29 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3618 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-621831c2 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3619 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-9c4a0a1d | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3620 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-fb8f6d82 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3621 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-68bdf4ff | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3622 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-b0e213e2 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3623 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-59411c67 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3624 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-0ac7005b | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3625 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-6914529e | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3626 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-ab6af180 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3627 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-3503399b | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3628 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-04151b89 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3629 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6c806ff8 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3631 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-234219be | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3632 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-5e7f83ff | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3633 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-0e3ba16e | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3635 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-8dc814ee | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3636 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-f358d292 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3637 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-5e677867 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3638 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-462a2f93 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3640 |  | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-33ea6d8c | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3641 |  | DATA_OP | request.Parameters["p_package_type"] | p_package_type | 행/컬럼 값 대입 |  |  |  |
| AC-a5a132ea | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3642 |  | DATA_OP | request.Parameters["p_dom_exp"] | p_dom_exp | 행/컬럼 값 대입 |  |  |  |
| AC-dd95d4fe | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3644 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-addccc13 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3664 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2dc75e55 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3666 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ if (MessageHelper.GMessageBox("MSG003… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c2b9e9d | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3687 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-482d43a9 | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:3691 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.NonSoNo

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f796e630 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3800 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0027_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-53c756ca | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3804 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-825b3fb9 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3805 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6f9f473e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3806 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-5e2c6279 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3807 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-536e769b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3808 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-75fd2e73 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3809 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-cc51f14b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3810 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-d80417c7 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3811 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-e059d1e1 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3812 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-1f482100 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3813 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-bf20b3a0 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3814 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-e887edfb | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3815 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-7ad434b3 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3816 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-f7bc4ca0 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3817 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-54f7d8ba | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3818 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-3a0ad50f | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3819 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-bdac78d6 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3820 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-6c57a243 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3821 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-11b9ed6d | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3822 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-8f542cdc | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3823 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-2f58c76a | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3824 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-c490e475 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3825 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-022e9226 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3826 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-75e6cb29 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3827 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-278015d5 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3828 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-15214961 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3829 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0589ab04 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3830 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ed6de99c | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3832 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-f3b23942 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3833 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-66b215ee | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3834 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-45e0b6c9 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3836 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-ac24c3e0 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3837 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-f9d357ad | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3838 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-b32261b0 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3839 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-04c53a4c | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3845 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2fe36428 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3867 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d54d6e46 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3869 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ if (MessageHelper.GMessageBox("MSG003… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-730c9904 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3890 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d8a5ba8 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3894 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.Plan_Current_Check

진입점: this.btnSimulation.Click [finally] / FindButton [try ▸ if (cboPlanDate.SelectedIndex == 0)] / SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try ▸ if (cboPlanDate.SelectedIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5a54191 | this.btnSimulation.Click [finally] 외 2 | SSP0027_ShipmentPlanEss.cs:5421 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Plan_Infor_ESS, false, strDivision_ID, strCompanyID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c36c7da1 | this.btnSimulation.Click [finally] 외 2 | SSP0027_ShipmentPlanEss.cs:5432 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00313", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d8967ec2 | this.btnSimulation.Click [finally] 외 2 | SSP0027_ShipmentPlanEss.cs:5439 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) ▸ if (!DateTime.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20495b88 | this.btnSimulation.Click [finally] 외 2 | SSP0027_ShipmentPlanEss.cs:5445 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) ▸ if (!DateTime.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd8967bc | this.btnSimulation.Click [finally] 외 2 | SSP0027_ShipmentPlanEss.cs:5451 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) ▸ if (!DateTime.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd23933b | this.btnSimulation.Click [finally] 외 2 | SSP0027_ShipmentPlanEss.cs:5453 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod.Value1 | dateFrom | 속성 Value1 설정 |  |  |  |
| AC-a5c33a16 | this.btnSimulation.Click [finally] 외 2 | SSP0027_ShipmentPlanEss.cs:5454 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod.Value2 | dateTo | 속성 Value2 설정 |  |  |  |
| AC-88e105f7 | this.btnSimulation.Click [finally] 외 2 | SSP0027_ShipmentPlanEss.cs:5455 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod2.Value1 | Convert.ToDateTime(sPlanDate) | 속성 Value1 설정 |  |  |  |
| AC-0fa0e59a | this.btnSimulation.Click [finally] 외 2 | SSP0027_ShipmentPlanEss.cs:5456 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod2.Value2 | dateTo | 속성 Value2 설정 |  |  |  |
| AC-c75f9382 | this.btnSimulation.Click [finally] 외 2 | SSP0027_ShipmentPlanEss.cs:5458 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | CALL_EXT | cboPlanDate.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f8d66834 | this.btnSimulation.Click [finally] 외 2 | SSP0027_ShipmentPlanEss.cs:5459 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | LIST_REBIND | clsCtrl.setListBox | (Tmp_dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0027_ShipmentPlanEss.Re_Design

진입점: FindButton [finally] / SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae7d6f72 | FindButton [finally] 외 1 | SSP0027_ShipmentPlanEss.cs:4695 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (!string.IsNullOrWhiteSpace(siMain.GetValue(i, siMain.GetC… | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-de6a5839 | FindButton [finally] 외 1 | SSP0027_ShipmentPlanEss.cs:4707 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure == "PUR_BALANCE") | UI_PROP | range1.BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 속성 BackColor 설정 |  |  |  |
| AC-bb8350cc | FindButton [finally] 외 1 | SSP0027_ShipmentPlanEss.cs:4715 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure == "SHIP_BALANCE") | UI_PROP | range1.BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 속성 BackColor 설정 |  |  |  |
| AC-d68290fe | FindButton [finally] 외 1 | SSP0027_ShipmentPlanEss.cs:4723 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure == "SHIP_CONFIRM") | UI_PROP | range1.BackColor | Color.FromArgb(80, Color.Violet) | 속성 BackColor 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.Re_DesignDetail

진입점: this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ finally] / EditButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail)] / SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (bDetail_DbClick == true) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b60292a | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 2 | SSP0027_ShipmentPlanEss.cs:4748 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.RowCount > 0) ▸ for (i < siDetail.ActiveSheet.RowCo… | GRID_STYLE | siDetail.SetBGColor2 | (i, siDetail.GetColumnIndex(DefColumns.PR_REQ_QTY), i, siDetail.GetColumnIndex(DefColumns.… | 그리드 표시 설정 |  |  |  |
| AC-1b1b89b7 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 2 | SSP0027_ShipmentPlanEss.cs:4754 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.RowCount > 0) ▸ for (i < siDetail.ActiveSheet.RowCo… | GRID_STYLE | siDetail.SetFGColor2 | (i, siDetail.GetColumnIndex(DefColumns.PR_CHECK), i, siDetail.GetColumnIndex("DELETE_FLAG"… | 그리드 표시 설정 |  |  |  |
| AC-a56ebce2 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 2 | SSP0027_ShipmentPlanEss.cs:4784 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtNetDetail) ▸ if (siDetail.ActiveSheet.RowCount > 0) ▸ for (i < siDetail.ActiveSheet.RowCou… | UI_PROP | range1.Border | bevelbrdr | 속성 Border 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.SaveData_Detail

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-493ecfd4 | SaveButton | SSP0027_ShipmentPlanEss.cs:2336 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-e29b5745 | SaveButton | SSP0027_ShipmentPlanEss.cs:2339 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (!DataUtil.ch… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-37c4663b | SaveButton | SSP0027_ShipmentPlanEss.cs:2346 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (chkERPIFBloc… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-658d9437 | SaveButton | SSP0027_ShipmentPlanEss.cs:2350 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-52e54ac7 | SaveButton | SSP0027_ShipmentPlanEss.cs:2358 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd3ff16e | SaveButton | SSP0027_ShipmentPlanEss.cs:2364 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9b659fb8 | SaveButton | SSP0027_ShipmentPlanEss.cs:2366 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c1a695ac | SaveButton | SSP0027_ShipmentPlanEss.cs:2369 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-19423117 | SaveButton | SSP0027_ShipmentPlanEss.cs:2374 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-004b038d | SaveButton | SSP0027_ShipmentPlanEss.cs:2465 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_SAVE_SHIPMENT_REQUEST_CONFIRM") ⇒ SSP.SSP0027_SAVE_SHIPMENT_REQUEST_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-18bb38dc | SaveButton | SSP0027_ShipmentPlanEss.cs:2469 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-eef153d1 | SaveButton | SSP0027_ShipmentPlanEss.cs:2470 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4eb5be0d | SaveButton | SSP0027_ShipmentPlanEss.cs:2471 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-de73b71a | SaveButton | SSP0027_ShipmentPlanEss.cs:2472 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-e1509594 | SaveButton | SSP0027_ShipmentPlanEss.cs:2473 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-606d1bc6 | SaveButton | SSP0027_ShipmentPlanEss.cs:2474 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-f22dd15e | SaveButton | SSP0027_ShipmentPlanEss.cs:2475 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-c4454048 | SaveButton | SSP0027_ShipmentPlanEss.cs:2476 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-7b2d854a | SaveButton | SSP0027_ShipmentPlanEss.cs:2477 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-9c97519d | SaveButton | SSP0027_ShipmentPlanEss.cs:2478 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-b5dde1ab | SaveButton | SSP0027_ShipmentPlanEss.cs:2479 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-206eac56 | SaveButton | SSP0027_ShipmentPlanEss.cs:2480 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-4f07a177 | SaveButton | SSP0027_ShipmentPlanEss.cs:2481 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-d143c75e | SaveButton | SSP0027_ShipmentPlanEss.cs:2482 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-d8661210 | SaveButton | SSP0027_ShipmentPlanEss.cs:2483 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-5965359b | SaveButton | SSP0027_ShipmentPlanEss.cs:2484 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-eaffff25 | SaveButton | SSP0027_ShipmentPlanEss.cs:2485 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-4baa0ce8 | SaveButton | SSP0027_ShipmentPlanEss.cs:2486 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-05f06de5 | SaveButton | SSP0027_ShipmentPlanEss.cs:2487 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-52de4c86 | SaveButton | SSP0027_ShipmentPlanEss.cs:2488 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-83f27cfe | SaveButton | SSP0027_ShipmentPlanEss.cs:2489 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-b3f2ed60 | SaveButton | SSP0027_ShipmentPlanEss.cs:2490 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-788c0c1f | SaveButton | SSP0027_ShipmentPlanEss.cs:2491 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_check_need_yn"] | p_check_need_yn | 행/컬럼 값 대입 |  |  |  |
| AC-420952d8 | SaveButton | SSP0027_ShipmentPlanEss.cs:2492 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-b55f29e3 | SaveButton | SSP0027_ShipmentPlanEss.cs:2494 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ab9c3e50 | SaveButton | SSP0027_ShipmentPlanEss.cs:2501 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-79ba37bd | SaveButton | SSP0027_ShipmentPlanEss.cs:2533 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dbacea69 | SaveButton | SSP0027_ShipmentPlanEss.cs:2535 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1dd58c15 | SaveButton | SSP0027_ShipmentPlanEss.cs:2543 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7b89a758 | SaveButton | SSP0027_ShipmentPlanEss.cs:2545 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb53cd18 | SaveButton | SSP0027_ShipmentPlanEss.cs:2558 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9557ef88 | SaveButton | SSP0027_ShipmentPlanEss.cs:2562 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | STATE_RESET | errConfrimList2.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-9675912d | SaveButton | SSP0027_ShipmentPlanEss.cs:2568 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-6bf5a0cf | SaveButton | SSP0027_ShipmentPlanEss.cs:2571 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87839c2e | SaveButton | SSP0027_ShipmentPlanEss.cs:2574 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f3d21636 | SaveButton | SSP0027_ShipmentPlanEss.cs:2579 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-04715322 | SaveButton | SSP0027_ShipmentPlanEss.cs:2631 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_SAVE_SHIPMENT_REQUEST_ALLO") ⇒ SSP.SSP0027_SAVE_SHIPMENT_REQUEST_ALLO | 엔드포인트 요청 생성 |  |  |  |
| AC-28b5f54b | SaveButton | SSP0027_ShipmentPlanEss.cs:2635 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-3814c7eb | SaveButton | SSP0027_ShipmentPlanEss.cs:2636 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | DATA_OP | request.Parameters["p_pr_check"] | p_pr_check | 행/컬럼 값 대입 |  |  |  |
| AC-5258194f | SaveButton | SSP0027_ShipmentPlanEss.cs:2637 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | DATA_OP | request.Parameters["p_dm_req_no"] | p_dm_req_no | 행/컬럼 값 대입 |  |  |  |
| AC-7f023d3f | SaveButton | SSP0027_ShipmentPlanEss.cs:2638 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-012c840f | SaveButton | SSP0027_ShipmentPlanEss.cs:2639 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-6bb70f24 | SaveButton | SSP0027_ShipmentPlanEss.cs:2640 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | DATA_OP | request.Parameters["p_item_seq"] | p_item_seq | 행/컬럼 값 대입 |  |  |  |
| AC-f36da9bc | SaveButton | SSP0027_ShipmentPlanEss.cs:2641 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-357c58ce | SaveButton | SSP0027_ShipmentPlanEss.cs:2642 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | DATA_OP | request.Parameters["p_dm_request_date"] | p_dm_request_date | 행/컬럼 값 대입 |  |  |  |
| AC-865dc47f | SaveButton | SSP0027_ShipmentPlanEss.cs:2643 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | DATA_OP | request.Parameters["p_plan_qty"] | p_plan_qty | 행/컬럼 값 대입 |  |  |  |
| AC-b00e1aa1 | SaveButton | SSP0027_ShipmentPlanEss.cs:2644 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | DATA_OP | request.Parameters["p_allo_qty"] | p_allo_qty | 행/컬럼 값 대입 |  |  |  |
| AC-392823bb | SaveButton | SSP0027_ShipmentPlanEss.cs:2645 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-f6598030 | SaveButton | SSP0027_ShipmentPlanEss.cs:2646 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-6cb19a19 | SaveButton | SSP0027_ShipmentPlanEss.cs:2649 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6a1109c9 | SaveButton | SSP0027_ShipmentPlanEss.cs:2655 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | DATA_OP | p_pr_check.Contains | ("True") | 데이터 객체 조작/조회 |  |  |  |
| AC-18fc14ae | SaveButton | SSP0027_ShipmentPlanEss.cs:2661 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12f4b2e5 | SaveButton | SSP0027_ShipmentPlanEss.cs:2665 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | DATA_OP | p_plan_qty.Contains | ("^") | 데이터 객체 조작/조회 |  |  |  |
| AC-be2a3df4 | SaveButton | SSP0027_ShipmentPlanEss.cs:2666 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | DATA_OP | p_allo_qty.Contains | ("^") | 데이터 객체 조작/조회 |  |  |  |
| AC-29f1c71e | SaveButton | SSP0027_ShipmentPlanEss.cs:2681 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00340", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-953a3e97 | SaveButton | SSP0027_ShipmentPlanEss.cs:2688 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91fb4f21 | SaveButton | SSP0027_ShipmentPlanEss.cs:2695 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4a7f22d2 | SaveButton | SSP0027_ShipmentPlanEss.cs:2706 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00341", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d0a65c07 | SaveButton | SSP0027_ShipmentPlanEss.cs:2708 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c459262c | SaveButton | SSP0027_ShipmentPlanEss.cs:2715 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00342", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-05f3935c | SaveButton | SSP0027_ShipmentPlanEss.cs:2717 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b082750 | SaveButton | SSP0027_ShipmentPlanEss.cs:2724 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00351", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f6a7cb2c | SaveButton | SSP0027_ShipmentPlanEss.cs:2726 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a94c0b8 | SaveButton | SSP0027_ShipmentPlanEss.cs:2734 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-00a178a2 | SaveButton | SSP0027_ShipmentPlanEss.cs:2736 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-76605ea6 | SaveButton | SSP0027_ShipmentPlanEss.cs:2743 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7a042463 | SaveButton | SSP0027_ShipmentPlanEss.cs:2749 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ else of (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (siDetai… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0027_ShipmentPlanEss.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40df1a43 | this.Load | SSP0027_ShipmentPlanEss.cs:383 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c07ff8aa | this.Load | SSP0027_ShipmentPlanEss.cs:384 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ed612d52 | this.Load | SSP0027_ShipmentPlanEss.cs:390 | switch (triggerControl) case "MyDivision": | FLAG | dtMyDivision | DataService.GetSSPInnerTable("AllDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-aed7ec6d | this.Load | SSP0027_ShipmentPlanEss.cs:390 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetSSPInnerTable | ("AllDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9e36fb79 | this.Load | SSP0027_ShipmentPlanEss.cs:395 | switch (triggerControl) case "Div_Company": | FLAG | dtCompany | DataService.GetSSPInnerTable("Div_Company", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-feca8ab7 | this.Load | SSP0027_ShipmentPlanEss.cs:395 | switch (triggerControl) case "Div_Company": | COMBO_DATA | DataService.GetSSPInnerTable | ("Div_Company", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-8f43e249 | this.Load | SSP0027_ShipmentPlanEss.cs:400 | switch (triggerControl) case "MyCompanyID": | FLAG | dtMyCompany | DataService.GetSSPInnerTable("MyCompanyID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-40a4c9a6 | this.Load | SSP0027_ShipmentPlanEss.cs:400 | switch (triggerControl) case "MyCompanyID": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyCompanyID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f3095ec2 | this.Load | SSP0027_ShipmentPlanEss.cs:405 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | FLAG | dtShipmentInputPeriod | DataService.GetSSPInnerTable("SHIPMENT_PERIOD_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-08465acf | this.Load | SSP0027_ShipmentPlanEss.cs:405 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("SHIPMENT_PERIOD_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c03c493a | this.Load | SSP0027_ShipmentPlanEss.cs:410 | switch (triggerControl) case "CHANGE_REQ_DAY": | FLAG | dtBaseDay | DataService.GetSSPInnerTable("CHANGE_REQ_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a19d19c7 | this.Load | SSP0027_ShipmentPlanEss.cs:410 | switch (triggerControl) case "CHANGE_REQ_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REQ_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-6b572eb3 | this.Load | SSP0027_ShipmentPlanEss.cs:415 | switch (triggerControl) case "PgmAuthId": | FLAG | dtPgmAuthId | DataService.GetSSPInnerTable("PgmAuthId", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-4a8575b9 | this.Load | SSP0027_ShipmentPlanEss.cs:415 | switch (triggerControl) case "PgmAuthId": | COMBO_DATA | DataService.GetSSPInnerTable | ("PgmAuthId", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1bc00970 | this.Load | SSP0027_ShipmentPlanEss.cs:420 | switch (triggerControl) case "DomExpTypeCode": | FLAG | dtDomExpTypeCode | DataService.GetSSPInnerTable("DomExpTypeCode", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ef85e65d | this.Load | SSP0027_ShipmentPlanEss.cs:420 | switch (triggerControl) case "DomExpTypeCode": | COMBO_DATA | DataService.GetSSPInnerTable | ("DomExpTypeCode", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-83b96f9e | this.Load | SSP0027_ShipmentPlanEss.cs:425 | switch (triggerControl) case "ElectrodePackageType": | FLAG | dtElectrodePackageType | DataService.GetSSPInnerTable("ElectrodePackageType", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ac52ec92 | this.Load | SSP0027_ShipmentPlanEss.cs:425 | switch (triggerControl) case "ElectrodePackageType": | COMBO_DATA | DataService.GetSSPInnerTable | ("ElectrodePackageType", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-148ff3b8 | this.Load | SSP0027_ShipmentPlanEss.cs:430 | switch (triggerControl) case "BuildingForShipMasterElec": | FLAG | dtBuilding | DataService.GetSSPInnerTable("BuildingForShipMasterElec", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b175b9e4 | this.Load | SSP0027_ShipmentPlanEss.cs:430 | switch (triggerControl) case "BuildingForShipMasterElec": | COMBO_DATA | DataService.GetSSPInnerTable | ("BuildingForShipMasterElec", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-91096c24 | this.Load | SSP0027_ShipmentPlanEss.cs:435 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | FLAG | dtChangeReasonCode | DataService.GetSSPInnerTable("CHANGE_REASON_CODE_ALL", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c8cfb826 | this.Load | SSP0027_ShipmentPlanEss.cs:435 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REASON_CODE_ALL", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ed05bfa7 | this.Load | SSP0027_ShipmentPlanEss.cs:440 | switch (triggerControl) case "MyModelChk": | FLAG | dtMyModelChk | DataService.GetSSPInnerTable("MyModelChk", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1b477432 | this.Load | SSP0027_ShipmentPlanEss.cs:440 | switch (triggerControl) case "MyModelChk": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyModelChk", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9e602db9 | this.Load | SSP0027_ShipmentPlanEss.cs:445 | switch (triggerControl) case "SSP_SHIPMENT_RESULT_TYPE": | FLAG | dtResultType | DataService.GetSSPInnerTable("SSP_SHIPMENT_RESULT_TYPE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6ec3ef79 | this.Load | SSP0027_ShipmentPlanEss.cs:445 | switch (triggerControl) case "SSP_SHIPMENT_RESULT_TYPE": | COMBO_DATA | DataService.GetSSPInnerTable | ("SSP_SHIPMENT_RESULT_TYPE", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f512f3cb | this.Load | SSP0027_ShipmentPlanEss.cs:450 | switch (triggerControl) case "ESS_STOCK_STORAGE_ID": | FLAG | dtStorageId | DataService.GetSSPInnerTable("ESS_STOCK_STORAGE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6662c9b3 | this.Load | SSP0027_ShipmentPlanEss.cs:450 | switch (triggerControl) case "ESS_STOCK_STORAGE_ID": | COMBO_DATA | DataService.GetSSPInnerTable | ("ESS_STOCK_STORAGE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## SSP0027_ShipmentPlanEss.SetChangedControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3294bd11 | this.Load | SSP0027_ShipmentPlanEss.cs:552 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-b5bf75ed | this.Load | SSP0027_ShipmentPlanEss.cs:553 | if (dtMyDivision.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66bb71c9 | this.Load | SSP0027_ShipmentPlanEss.cs:556 |  | FLAG | dtMyDivision | dtMyDivision.Select().Where(c => c["CODE"].ToString() == "82").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-5bbf470a | this.Load | SSP0027_ShipmentPlanEss.cs:556 |  | DATA_OP | dtMyDivision.Select().Where(c => c["CODE"].ToString() == "82").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-96eab2b0 | this.Load | SSP0027_ShipmentPlanEss.cs:556 |  | DATA_OP | dtMyDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7a493c26 | this.Load | SSP0027_ShipmentPlanEss.cs:557 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1ad705a8 | this.Load | SSP0027_ShipmentPlanEss.cs:563 |  | DATA_OP | dtCompany.Select().Where(c => c["DIVISION_ID"].ToString() == strSelDivision_ID && c["CODE"… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-888206bc | this.Load | SSP0027_ShipmentPlanEss.cs:563 |  | DATA_OP | dtCompany.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-74659792 | this.Load | SSP0027_ShipmentPlanEss.cs:564 |  | LIST_REBIND | clsCtrl.setListBox | (dtDiv_Company_ID, clbCompany_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-87c4b75d | this.Load | SSP0027_ShipmentPlanEss.cs:568 |  | FLAG | sUserCompany_NM | dtMyCompany.Rows[0]["NAME"].ToString() | 화면 필드/플래그 변경 |  |  |  |

## SSP0027_ShipmentPlanEss.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged / this.chkSum.CheckedChanged / this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColumnIndex("M_BOH_QTY")) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / clbCompany_ID.SelectedIndexChanged [if (spdInfo.SheetName…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-587413d9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SSP0027_ShipmentPlanEss.cs:4443 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ef152920 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SSP0027_ShipmentPlanEss.cs:4448 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-e79794f9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SSP0027_ShipmentPlanEss.cs:4455 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a8c80099 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SSP0027_ShipmentPlanEss.cs:4459 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-4218fe3d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SSP0027_ShipmentPlanEss.cs:4464 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-59462d00 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SSP0027_ShipmentPlanEss.cs:4471 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6eda9dfe | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SSP0027_ShipmentPlanEss.cs:4475 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.ShipmentResult_GetDayRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6876d44f | (진입점 미연결) | SSP0027_ShipmentPlanEss.cs:5504 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.shtPlanDetail_Change

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddad23b1 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5851 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange != true \|\| e.Row == -1 && e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50fef835 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5852 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8738d450 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5861 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00189") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7eb2e7ae | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5862 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c9d4f47 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5876 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00278") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3ac4e6df | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5877 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2de2b696 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5891 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-c97a714a | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5901 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-8fe425b5 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5903 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-07f34c68 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5904 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ForeCo… | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-8ed77931 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5905 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].BackCo… | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-6b9b3cc3 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5909 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-3ba04ad2 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5920 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-5eddc97a | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5930 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-4ada351c | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5932 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-3cb35ba0 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5933 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ForeCo… | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-852a5098 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5934 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].BackCo… | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-d3873c5c | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5949 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-38ee2e52 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5950 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-31097c06 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5954 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-ab96ad42 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5961 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-50231092 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5971 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-26886cae | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5972 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-1e4f2c67 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5973 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-0294985f | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5985 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-89e5b138 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5995 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-6030f9c0 | dsdm.Changed | SSP0027_ShipmentPlanEss.cs:5996 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.Simulation

진입점: this.btnSimulation.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-904c69ca | this.btnSimulation.Click | SSP0027_ShipmentPlanEss.cs:5775 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e8c7d2e1 | this.btnSimulation.Click | SSP0027_ShipmentPlanEss.cs:5784 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7f42d252 | this.btnSimulation.Click | SSP0027_ShipmentPlanEss.cs:5806 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d158b158 | this.btnSimulation.Click | SSP0027_ShipmentPlanEss.cs:5807 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-14dea44e | this.btnSimulation.Click | SSP0027_ShipmentPlanEss.cs:5813 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_ESS_PLAN_CUTOFF") ⇒ SSP.PR_SSP_ANL_ESS_PLAN_CUTOFF | 엔드포인트 요청 생성 |  |  |  |
| AC-d8e64779 | this.btnSimulation.Click | SSP0027_ShipmentPlanEss.cs:5815 | try ▸ lambda | UI_PROP | req.CommandTimeout | 2 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-cfec2080 | this.btnSimulation.Click | SSP0027_ShipmentPlanEss.cs:5817 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | strSelDivision_ID | 행/컬럼 값 대입 |  |  |  |
| AC-eebefa1f | this.btnSimulation.Click | SSP0027_ShipmentPlanEss.cs:5818 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-ffd5d91d | this.btnSimulation.Click | SSP0027_ShipmentPlanEss.cs:5821 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a79f6a6e | this.btnSimulation.Click | SSP0027_ShipmentPlanEss.cs:5822 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-78f09e1e | this.btnSimulation.Click | SSP0027_ShipmentPlanEss.cs:5839 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-183206de | this.btnSimulation.Click | SSP0027_ShipmentPlanEss.cs:5841 | finally | FLAG | dtPlanDate | Data_SCP.Common(Data_SCP.Type.Plan_Infor_ESS, false, strSelDivision_ID, strSelCompany_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-0ff7689f | this.btnSimulation.Click | SSP0027_ShipmentPlanEss.cs:5841 | finally | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Plan_Infor_ESS, false, strSelDivision_ID, strSelCompany_ID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SSP0027_ShipmentPlanEss.SoNo

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ else of (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c407800c | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:3912 | for (i < intRowIdx) ▸ if (erpSoNo == siDetail.GetValue(i, siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)).ToString()) ▸ if (intRowIdx > i) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-04ce88b0 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4035 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0027_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0027_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-100faff0 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4039 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-672c7af3 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4040 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0c922abe | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4041 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-4cca8ded | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4042 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-2281d6af | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4043 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-6ec2324a | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4044 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-5ec79d34 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4045 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-c162916b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4046 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-60b21099 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4047 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-f627de77 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4048 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-094d3597 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4049 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-fb1e639f | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4050 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-4ad5f238 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4051 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-45b54bc8 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4052 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-91df653f | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4053 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-05e913a5 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4054 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-4fb8a528 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4055 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-ee10ff98 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4056 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-bffc8034 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4057 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-ed1ee252 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4058 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-d2ac6ebe | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4059 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-8d60573b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4060 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-cda5e33e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4061 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-a07f849b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4062 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-c66f3fa2 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4063 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-ba9b8f7b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4064 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-61fccfd0 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4065 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4300533a | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4067 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-d818f10c | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4068 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-21db5d9e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4069 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-8fbe17e4 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4071 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-68990a3f | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4072 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-f730f890 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4073 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-b265a2d1 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4074 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-bad59d40 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4080 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f057904e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4101 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-15e8ae4f | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4103 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ if (MessageHelper.GMessageBox("MSG003… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba06e566 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4124 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a72337fb | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:4128 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0027_ShipmentPlanEss.SpdDetail_ActiveSheetChanged

진입점: this.spdDetail.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ffe9d33 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:943 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | PlanDate21.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-78f5cb41 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:944 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c8618608 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:945 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-58bbc41b | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:946 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-41e336ee | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:947 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-cdfdd788 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:948 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4679ccc5 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:949 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1968aa21 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:954 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | PlanDate21.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ad6aa219 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:955 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-3900aabb | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:956 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d46c6814 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:957 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-302f227f | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:958 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d5edf06b | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:959 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-950e9928 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:960 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-3faeafae | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:964 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | PlanDate21.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-dc4e8e9a | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:965 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a8e480d2 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:966 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9776db7c | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:967 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6f9fdf53 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:968 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-292fd878 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:969 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9961dc11 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:970 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1d14bab3 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:974 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | PlanDate21.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fabf8d63 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:975 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-99438555 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:976 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4fda1cac | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:977 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-3baafb62 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:978 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-048db8f3 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:979 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-790f073c | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:980 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-85f6e163 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:984 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | PlanDate21.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-abb487b4 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:985 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ad426dc7 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:986 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-950e3417 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:987 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d3c1d916 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:988 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1abcd80e | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:989 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fe0ffd63 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:990 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6e164294 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:991 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c8162335 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:995 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | PlanDate21.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ad3b318f | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:996 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ca85615b | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:997 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-5fd6bef9 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:998 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d44e4d94 | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:999 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ce5251db | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:1000 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-82fb2afd | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:1001 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0bd1d09d | this.spdDetail.ActiveSheetChanged | SSP0027_ShipmentPlanEss.cs:1002 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.SpdDetail_CellClick

진입점: this.spdDetail.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03a2adba | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1657 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.GetColumnTag(e.Column) == "PR_CHECK") ▸ if (!siDetail.ActiveShe… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-31f25b56 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1663 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.GetColumnTag(e.Column) == "PR_CHECK") ▸ if (siDetail.ActiveShee… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f7aa9001 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1668 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.GetColumnTag(e.Column) == "PR_CHECK") ▸ if ("False" == prCheck) | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.PR_CHECK), "True") | 그리드 값 설정 |  |  |  |
| AC-db475245 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1673 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.GetColumnTag(e.Column) == "PR_CHECK") ▸ else of ("False" == prC… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.PR_CHECK), "False") | 그리드 값 설정 |  |  |  |
| AC-054f9efb | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1688 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.GetColumnTag(e.Column) == "PR_CHECK") ▸ for (i <= rowCount) ▸ i… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.PR_CHECK), "True") | 그리드 값 설정 |  |  |  |
| AC-b19fc87c | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1692 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.GetColumnTag(e.Column) == "PR_CHECK") ▸ for (i <= rowCount) ▸ i… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.PR_CHECK), "False") | 그리드 값 설정 |  |  |  |
| AC-b657c61b | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1699 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.GetColumnTag(e.Column) == "PR_CHECK") ▸ for (i <= rowCount) ▸ e… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.PR_CHECK), "True") | 그리드 값 설정 |  |  |  |
| AC-7ed353d9 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1703 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.GetColumnTag(e.Column) == "PR_CHECK") ▸ for (i <= rowCount) ▸ e… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.PR_CHECK), "False") | 그리드 값 설정 |  |  |  |
| AC-af0ec706 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1722 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.ClipboardPasteAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-80b64249 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1723 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.ClipboardCopyAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-86957b98 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1724 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | UI_PROP | spdDetail.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |
| AC-f8af585c | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1751 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | DATA_OP | dtBuildingForCell.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9be08f4e | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1752 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | DATA_OP | dtBuildingForCell.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd41f6a1 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1754 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | DATA_OP | dtBuilding.Select | ("DIVISION_ID = '" + sDivisionId + "' AND COMPANY_ID = '" + sCompanyId + "' AND SCM_SITE_I… | 데이터 객체 조작/조회 |  |  |  |
| AC-ec74c251 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1762 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | DATA_OP | dtBuildingForCell.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b9d309f4 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1763 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | DATA_OP | drRow["CODE"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-67f84335 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1764 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() + " : " + dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cfc0fb19 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1765 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | DATA_OP | dtBuildingForCell.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a74f5ab | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1768 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | DATA_OP | dtBuildingForCell.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-01a115c0 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1769 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | DATA_OP | drAllRow["CODE"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-d21d3942 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1770 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | DATA_OP | drAllRow["NAME"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-083db03a | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1771 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | CALL_EXT | dtBuildingForCell.Rows.InsertAt | (drAllRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-362a7a5f | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1772 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | DATA_OP | dtBuildingForCell.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eb3984d6 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1774 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.FACTORY_ID), dtBuildingForCell) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-75c0ae71 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1783 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-ad494d59 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1787 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | GRID_SET | siDetail.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-97d7c230 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1796 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | UI_PROP | spdDetail.AutoClipboard | true | 속성 AutoClipboard 설정 |  |  |  |
| AC-9ababfe7 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1797 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | FLAG | im | spdDetail.GetInputMap(FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | 화면 필드/플래그 변경 |  |  |  |
| AC-a6cbb441 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1797 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | CALL_EXT | spdDetail.GetInputMap | (FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8462b36e | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1798 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-78f17b64 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1799 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (siD… | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c94fed07 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1811 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of… | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-81d996fd | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1815 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of… | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-8ab27acf | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1822 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of… | GRID_SET | siDetail.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-4c353266 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1826 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of… | GRID_SET | siDetail.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-e7f3ba21 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1837 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.C… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25463538 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1839 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.C… | POPUP | new SCM0002_ShipmentPlanRequestPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6a942e39 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1840 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.C… | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-82304908 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1841 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.C… | UI_PROP | pop._sRequestNo | sRequestNo | 속성 _sRequestNo 설정 |  |  |  |
| AC-b88d8350 | this.spdDetail.CellClick | SSP0027_ShipmentPlanEss.cs:1842 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.C… | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0027_ShipmentPlanEss.SpdDetail_CellDoubleClick

진입점: this.spdDetail.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50a855f9 | this.spdDetail.CellDoubleClick | SSP0027_ShipmentPlanEss.cs:1160 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetai… | POPUP | new SSP0300_OrderDetailPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ebaa8216 | this.spdDetail.CellDoubleClick | SSP0027_ShipmentPlanEss.cs:1162 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetai… | POPUP | pop.Form_Load | (_DivisionID, _ErpSoNo, _ConfirmId, _ItemID, "N") | 팝업 초기화(인자 전달) |  |  |  |
| AC-bd52c6de | this.spdDetail.CellDoubleClick | SSP0027_ShipmentPlanEss.cs:1163 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetai… | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d6b1a69f | this.spdDetail.CellDoubleClick | SSP0027_ShipmentPlanEss.cs:1164 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetai… | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0027_ShipmentPlanEss.SpdDetail_ClipboardPasted

진입점: this.spdDetail.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c0296c9 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1251 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-a4e61268 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1275 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-0c7d3be6 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1293 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-3d408951 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1294 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_STYLE | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetF… | () | 그리드 표시 설정 |  |  |  |
| AC-d9d7cda2 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1295 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_STYLE | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetB… | () | 그리드 표시 설정 |  |  |  |
| AC-6052ce83 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1298 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ForeCo… | ControlColor.DefaultForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-b30ea42e | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1314 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-71bcefcc | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1315 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-9d70df54 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1316 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-e7e18bc6 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1317 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-5201f282 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1318 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-1b7f828d | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1328 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-a00ad4fa | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1330 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-708aa78c | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1331 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-c0822ff3 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1332 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-d6ddfb84 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1333 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-c3022865 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1341 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-299a2700 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1347 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-8c3d0b41 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1355 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | DATA_OP | dtChangeReasonCode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-490cc187 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1359 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | CALL_EXT | ((FarPoint.Win.Spread.FpSpread)sender).CancelCellEditing | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c39f5168 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1363 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00047", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e73ab327 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1364 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53def506 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1370 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE)].F… | ControlColor.MarkedForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-405afeaa | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1372 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-e8583032 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1383 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE)].Fore… | ControlColor.MarkedForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-2f75ce01 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1385 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-196e6ef7 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1386 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-1b11f2df | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1400 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-649c081f | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1411 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-e8ca8a72 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1413 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-05750248 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1426 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-2ac5e373 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1437 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-db18d3a1 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1450 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-e1da7a43 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1461 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-cc1770b5 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1474 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-47d6afe5 | this.spdDetail.ClipboardPasted | SSP0027_ShipmentPlanEss.cs:1485 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.SpdDetail_ComboSelChange

진입점: this.spdDetail.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-405030f9 | this.spdDetail.ComboSelChange | SSP0027_ShipmentPlanEss.cs:1014 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(siDetail.GetValue(e.Row, siDetail.GetCol… | MESSAGE | MessageHelper.GMessageBox | ("MSG00278") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-582f39fc | this.spdDetail.ComboSelChange | SSP0027_ShipmentPlanEss.cs:1015 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(siDetail.GetValue(e.Row, siDetail.GetCol… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6ecf669 | this.spdDetail.ComboSelChange | SSP0027_ShipmentPlanEss.cs:1057 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-fc9c1e96 | this.spdDetail.ComboSelChange | SSP0027_ShipmentPlanEss.cs:1082 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siDetail.Acti… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-531a1fef | this.spdDetail.ComboSelChange | SSP0027_ShipmentPlanEss.cs:1099 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-e32a7a15 | this.spdDetail.ComboSelChange | SSP0027_ShipmentPlanEss.cs:1100 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-398e2072 | this.spdDetail.ComboSelChange | SSP0027_ShipmentPlanEss.cs:1105 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-4e88caa1 | this.spdDetail.ComboSelChange | SSP0027_ShipmentPlanEss.cs:1119 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-a1d0285c | this.spdDetail.ComboSelChange | SSP0027_ShipmentPlanEss.cs:1120 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-27a66169 | this.spdDetail.ComboSelChange | SSP0027_ShipmentPlanEss.cs:1121 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-e8ab4f9b | this.spdDetail.ComboSelChange | SSP0027_ShipmentPlanEss.cs:1126 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-9db93734 | this.spdDetail.ComboSelChange | SSP0027_ShipmentPlanEss.cs:1127 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-140a3e06 | this.spdDetail.ComboSelChange | SSP0027_ShipmentPlanEss.cs:1128 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.SpdDetail_EditChange

진입점: this.spdDetail.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-354bef34 | this.spdDetail.EditChange | SSP0027_ShipmentPlanEss.cs:1534 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-20059e0a | this.spdDetail.EditChange | SSP0027_ShipmentPlanEss.cs:1535 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-833aebdb | this.spdDetail.EditChange | SSP0027_ShipmentPlanEss.cs:1545 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-9c76e4e1 | this.spdDetail.EditChange | SSP0027_ShipmentPlanEss.cs:1550 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-6f4d3b01 | this.spdDetail.EditChange | SSP0027_ShipmentPlanEss.cs:1551 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-ab08fc66 | this.spdDetail.EditChange | SSP0027_ShipmentPlanEss.cs:1567 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | GRID_STYLE | siDetail.ActiveSheet.SetActiveCell | (e.Row, siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) | 그리드 표시 설정 |  |  |  |
| AC-d66e9a76 | this.spdDetail.EditChange | SSP0027_ShipmentPlanEss.cs:1568 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | CALL_EXT | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL)… | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c91dd3d | this.spdDetail.EditChange | SSP0027_ShipmentPlanEss.cs:1570 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | MESSAGE | MessageHelper.GMessageBox | ("MSG00287", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-417f6439 | this.spdDetail.EditChange | SSP0027_ShipmentPlanEss.cs:1572 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0ed772b | this.spdDetail.EditChange | SSP0027_ShipmentPlanEss.cs:1580 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-87f39669 | this.spdDetail.EditChange | SSP0027_ShipmentPlanEss.cs:1590 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-edf458e6 | this.spdDetail.EditChange | SSP0027_ShipmentPlanEss.cs:1592 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-e2c3ec10 | this.spdDetail.EditChange | SSP0027_ShipmentPlanEss.cs:1607 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPRPODetail) | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex("EDIT_CHECK"), "Y") | 그리드 값 설정 |  |  |  |

## SSP0027_ShipmentPlanEss.SpdDetail_SheetTabClick

진입점: this.spdDetail.SheetTabClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c00aa34e | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:898 | if (e.SheetTabIndex == 0) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12eb151c | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:899 | if (e.SheetTabIndex == 0) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtPlanDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d28c5b0d | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:903 | else of (e.SheetTabIndex == 0) ▸ if (e.SheetTabIndex == 1) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPRPODetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7736743a | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:904 | else of (e.SheetTabIndex == 0) ▸ if (e.SheetTabIndex == 1) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtPRPODetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1a5fa1d5 | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:908 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ if (e.SheetTabIndex == 2) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtNetDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9496190e | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:909 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ if (e.SheetTabIndex == 2) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtNetDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dfc1d49a | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:914 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 3) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-23671f1c | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:915 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 3) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentResult) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5ac3c3f1 | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:917 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 3) | CALL_EXT | clbResultType.SetItemChecked | (0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb188180 | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:918 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 3) | CALL_EXT | clbResultType.SetItemChecked | (1, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e54fe21d | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:922 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ if (e.Sh… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentMonthly) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-64f04576 | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:923 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ if (e.Sh… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentMonthly) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cee474d3 | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:925 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ if (e.Sh… | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate21, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6cca4acd | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:931 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentDaliy) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-24cb4353 | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:932 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentDaliy) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-04753d38 | this.spdDetail.SheetTabClick | SSP0027_ShipmentPlanEss.cs:934 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate21, cboPlanDate21, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0027_ShipmentPlanEss.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f8aca94 | this.spdMain.CellDoubleClick | SSP0027_ShipmentPlanEss.cs:1854 | if (e.Column == siMain.GetColumnIndex("M_BOH_QTY")) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentMonthly) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f039219a | this.spdMain.CellDoubleClick | SSP0027_ShipmentPlanEss.cs:1855 | if (e.Column == siMain.GetColumnIndex("M_BOH_QTY")) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentMonthly) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5dc3ca19 | this.spdMain.CellDoubleClick | SSP0027_ShipmentPlanEss.cs:1857 | if (e.Column == siMain.GetColumnIndex("M_BOH_QTY")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate21, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0027_ShipmentPlanEss.SpdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e96bdb11 | this.spdMain.Change | SSP0027_ShipmentPlanEss.cs:839 |  | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-d082d0ee | this.spdMain.Change | SSP0027_ShipmentPlanEss.cs:840 |  | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-8ac322a1 | this.spdMain.Change | SSP0027_ShipmentPlanEss.cs:844 | if (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) | FLAG | iTopRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-9c8b259f | this.spdMain.Change | SSP0027_ShipmentPlanEss.cs:845 | if (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEAS…) | FLAG | iTopCol | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SSP0027_ShipmentPlanEss.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4998f0be | this.spdMain.TopChange | SSP0027_ShipmentPlanEss.cs:1921 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0027_ShipmentPlanEss.Validation_Check

진입점: SaveButton [if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56a9cf87 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2794 |  | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-69da52eb | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2820 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e9aec466 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2821 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9b45c205 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2839 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | DefaultDetailDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e634c119 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2839 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab587904 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2854 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cc892d4b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2869 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), strChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-b0866453 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2870 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-c7744492 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2877 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), strChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-fb63b3d2 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2879 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-91404acc | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2894 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetBack… | () | 그리드 표시 설정 |  |  |  |
| AC-4358fa98 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2895 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-c9009f40 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2896 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-6fcfa15a | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2897 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].Re… | () | 그리드 표시 설정 |  |  |  |
| AC-c912a948 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2898 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-e430b8a0 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2899 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetFor… | () | 그리드 표시 설정 |  |  |  |
| AC-6d2ad9f5 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2900 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-c761a737 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2901 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-bffca719 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2909 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e6f3bf00 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2913 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-fb6b3e67 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2929 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | DefaultDetailDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4a665b0e | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2929 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-301d0732 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2960 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetBack… | () | 그리드 표시 설정 |  |  |  |
| AC-bfece90b | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2961 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-10bde990 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2962 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-1ecc18ef | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2964 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].Re… | () | 그리드 표시 설정 |  |  |  |
| AC-9cfb28de | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2965 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-16697c5c | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2966 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetFor… | () | 그리드 표시 설정 |  |  |  |
| AC-c91dc134 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2967 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-0c5fe4f8 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2968 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-98f49708 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2970 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00286", new object[] { (i + 1).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c7b7635 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2972 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-173255a9 | SaveButton [if (siDetail != null && siDetail.IsLock(siDetail… | SSP0027_ShipmentPlanEss.cs:2978 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

