# AS-IS 액션 대조표 — SSP0201

> 원천: `Doc/asisfacts/screens/SSP0201/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1035행 · 메서드 54 · 종류 DATA_OP 298 · GRID_SET 165 · FLAG 110 · RETURN 87 · MESSAGE 72 · GRID_INIT 43 · UI_PROP 41 · ENDPOINT 33 · GRID_LOCK 30 · VALUE_SET 29 · COMBO_DATA 24 · POPUP 19 · GRID_COMBO 18 · GRID_STYLE 16 · CALL_EXT 13 · UI_MISC 9 · STATE 7 · VALIDATE 6 · VALUE_CLEAR 5 · LIST_REBIND 5 · GRID_BIND 3 · STATE_RESET 1 · CALL_BASE 1 · ⚠ 의미 확인 필요 14


## SSP0201_ShipmentChangeRequest.Backup_Value

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a311a5b0 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3070 |  | FLAG | sBefor_RequestID | sRequestID | 화면 필드/플래그 변경 |  |  |  |
| AC-39b32d32 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3071 |  | FLAG | sBefor_RequestDeptID | sRequestDeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-bf0636f9 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3072 |  | FLAG | sBefor_ApprovalID | sApprovalID | 화면 필드/플래그 변경 |  |  |  |
| AC-f0fb4103 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3073 |  | FLAG | sBefor_ApprovalDeptID | sApprovalDeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-004ff754 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3074 |  | FLAG | sBefor_MainConfirmID | sMainConfirmID | 화면 필드/플래그 변경 |  |  |  |
| AC-126cfcc7 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3075 |  | FLAG | sBefor_ChangeStatus | sChangeStatus | 화면 필드/플래그 변경 |  |  |  |
| AC-b6280859 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3076 |  | FLAG | sBefor_ShipStatus | sShipStatus | 화면 필드/플래그 변경 |  |  |  |
| AC-df9d8353 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3077 |  | FLAG | sBefor_RequestName | sRequestName | 화면 필드/플래그 변경 |  |  |  |
| AC-5a9ee5b4 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3078 |  | FLAG | sBefor_SaveConfirmID | sSaveConfirmID | 화면 필드/플래그 변경 |  |  |  |
| AC-dc70a1bf | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3079 |  | FLAG | _Befor_sRequestNo | _sRequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-e4f011f7 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3080 |  | FLAG | _Befor_sConfrimID | _sConfrimID | 화면 필드/플래그 변경 |  |  |  |

## SSP0201_ShipmentChangeRequest.BtnApprovalUser_Click

진입점: btnApprovalUser.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b806ef4 | btnApprovalUser.Click | SSP0201_ShipmentChangeRequest.cs:2743 |  | POPUP | new SSP0002_UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e3ce8a3c | btnApprovalUser.Click | SSP0201_ShipmentChangeRequest.cs:2745 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-4b90b3b3 | btnApprovalUser.Click | SSP0201_ShipmentChangeRequest.cs:2746 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-db62e721 | btnApprovalUser.Click | SSP0201_ShipmentChangeRequest.cs:2747 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-444963ca | btnApprovalUser.Click | SSP0201_ShipmentChangeRequest.cs:2748 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-fe49da7f | btnApprovalUser.Click | SSP0201_ShipmentChangeRequest.cs:2749 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-e3f7c51f | btnApprovalUser.Click | SSP0201_ShipmentChangeRequest.cs:2751 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-2c678266 | btnApprovalUser.Click | SSP0201_ShipmentChangeRequest.cs:2753 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-067a5b89 | btnApprovalUser.Click | SSP0201_ShipmentChangeRequest.cs:2759 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sApprovalID | item.UserID | 화면 필드/플래그 변경 |  |  |  |
| AC-d3068814 | btnApprovalUser.Click | SSP0201_ShipmentChangeRequest.cs:2762 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtApproval.Text | item.UserName | 컨트롤 값 설정 |  |  |  |
| AC-ac5641fb | btnApprovalUser.Click | SSP0201_ShipmentChangeRequest.cs:2764 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtApproval.Text | item.UserName_E | 컨트롤 값 설정 |  |  |  |
| AC-ceda5e98 | btnApprovalUser.Click | SSP0201_ShipmentChangeRequest.cs:2766 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | VALUE_SET | txtAppDeptName.Text | item.Dept_Name | 컨트롤 값 설정 |  |  |  |
| AC-84cd16a5 | btnApprovalUser.Click | SSP0201_ShipmentChangeRequest.cs:2767 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sApprovalDeptID | item.Dept_ID | 화면 필드/플래그 변경 |  |  |  |

## SSP0201_ShipmentChangeRequest.BtnCancel_Click

진입점: btnCancel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8257bf05 | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:3025 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6377544a | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:3028 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00195") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-685d7de8 | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:3028 | if (MessageHelper.GMessageBox("MSG00195") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6bde3f0a | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:3031 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_C \|\| cboChangeType.SelectedValue.ToString() == ChangeTyp…) | FLAG | sShipStatus | Shipment_Status.S_Status_C | 화면 필드/플래그 변경 |  |  |  |
| AC-99a122a5 | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:3033 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_C \|\| cboChangeType.SelectedValue.ToString() == ChangeTyp…) | FLAG | sShipStatus | Shipment_Status.S_Status_P | 화면 필드/플래그 변경 |  |  |  |
| AC-ba0ce179 | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:3035 |  | FLAG | bDeleClickYn | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cf567a18 | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:3038 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_C \|\| cboChangeType.SelectedValue.ToString() == ChangeTyp…) | FLAG | bErpIFCheck | true | 화면 필드/플래그 변경 |  |  |  |

## SSP0201_ShipmentChangeRequest.BtnChangeRe_Click

진입점: btnChangeRe.Click / btnChangeRe2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-607282c9 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2805 |  | FLAG | RollBack_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f6176360 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2819 | if (!checkRequired()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-63e4a0cb | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2822 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-8cf51085 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2824 | if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-68011222 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2834 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ for (iRow < siSub.ActiveSheet.RowCount) ▸ if (siSub.GetValue(iRow, … | CALL_EXT | Convert.ToInt64 | (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2e130c6 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2840 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ if (iShipmentQty == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00202", new object[] { 0 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-675e0eb9 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2841 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ if (iShipmentQty == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf197271 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2849 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ for (iRow < siSub.ActiveSheet.RowCount) | CALL_EXT | Convert.ToInt64 | (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-84043a87 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2852 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ for (iRow < siSub.ActiveSheet.RowCount) ▸ if (siSub.GetValue(i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00202", new object[] { 0 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7cd55cf | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2853 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ for (iRow < siSub.ActiveSheet.RowCount) ▸ if (siSub.GetValue(i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-138e24e9 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2870 | for (iRow < siSub.ActiveSheet.RowCount) ▸ if (dBaseDate > dShipDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00201", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-35ff5bbc | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2871 | for (iRow < siSub.ActiveSheet.RowCount) ▸ if (dBaseDate > dShipDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33e747f3 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2879 | for (iRow < siSub.ActiveSheet.RowCount) ▸ if (dShipDate > dShipDateAfter) | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a7535eea | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2880 | for (iRow < siSub.ActiveSheet.RowCount) ▸ if (dShipDate > dShipDateAfter) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9befefca | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2901 |  | FLAG | sChangeStatus | Change_Req_Status.C_Status_Q | 화면 필드/플래그 변경 |  |  |  |
| AC-3eb21a4b | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2902 |  | FLAG | sShipStatus | Shipment_Status.S_Status_R | 화면 필드/플래그 변경 |  |  |  |
| AC-fc05e4b5 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2903 |  | FLAG | bErpIFCheck | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0201_ShipmentChangeRequest.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b25f9c81 | this.btnItemId.Click | SSP0201_ShipmentChangeRequest.cs:3053 |  | POPUP | new SSP0026_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2e23b427 | this.btnItemId.Click | SSP0201_ShipmentChangeRequest.cs:3055 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-90d0bd32 | this.btnItemId.Click | SSP0201_ShipmentChangeRequest.cs:3056 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b398ebc0 | this.btnItemId.Click | SSP0201_ShipmentChangeRequest.cs:3057 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-427bb41a | this.btnItemId.Click | SSP0201_ShipmentChangeRequest.cs:3063 | if (popItem.ItemID != "") | VALUE_SET | txtRequest.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0201_ShipmentChangeRequest.BtnNew_Click

진입점: btnNew.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58f6a27e | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:2965 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5908c0cc | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:2967 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-8b9dde50 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:2968 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-96503f8c | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:2969 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3c21b3ba | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:2971 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivision_ID.SelectedValue.ToSt… | 그리드 값 설정 |  |  |  |
| AC-f33551c1 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:2977 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.Sel… | FLAG | dtFromSite | Data.UserPlantSiteByDivisionOspPack(UserInfoContext.Current["NowGroupID"], UserInfoContext… | 화면 필드/플래그 변경 |  |  |  |
| AC-87f5b660 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:2977 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.Sel… | COMBO_DATA | Data.UserPlantSiteByDivisionOspPack | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision_ID.Sel… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7c73b69b | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:2978 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.Sel… | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteByDivisionEEForSSP, false, clbDivision_ID.SelectedValu… | 화면 필드/플래그 변경 |  |  |  |
| AC-2a75396b | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:2978 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.Sel… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteByDivisionEEForSSP, false, clbDivision_ID.SelectedValue.ToString()) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5fef81a9 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:2983 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.Sel… | GRID_SET | siMain.SetValue | (insCell, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "-") | 그리드 값 설정 |  |  |  |
| AC-3336eec1 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:2987 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.Sel… | GRID_SET | siMain.SetValue | (insCell, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "-") | 그리드 값 설정 |  |  |  |
| AC-c5b4eaa0 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:2996 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | dtShipToCode | Data.Common(Data.Type.ShipToCodeByDivision, false, clbDivision_ID.SelectedValue.ToString()… ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-4c327450 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:2996 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.ShipToCodeByDivision, false, clbDivision_ID.SelectedValue.ToString(), "", "", "… ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5efce184 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:2998 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CODE), dtShipToCod… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f61d9295 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:3000 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION), dtFromSit… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-937ce176 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:3001 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTION), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0171b676 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:3005 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-6649c6b8 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:3006 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-e5f6db20 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:3007 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1485151b | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:3009 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cd6d50b2 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:3010 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ERP_SO_NO), siMain.GetColumnIndex(DefColumns.SH… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ebeb4e6c | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:3011 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e3f51b0e | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:3012 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-647a66b9 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:3013 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.REQUESTOR) - 1, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f8dcec48 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:3014 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TO_SITE_SOLDTO_CODE), siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-443734b4 | btnNew.Click | SSP0201_ShipmentChangeRequest.cs:3016 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CODE) + 1, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0201_ShipmentChangeRequest.BtnSave_Click

진입점: btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a06234d0 | btnSave.Click | SSP0201_ShipmentChangeRequest.cs:2775 | if (string.IsNullOrWhiteSpace(txtRequestNo.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2903da30 | btnSave.Click | SSP0201_ShipmentChangeRequest.cs:2778 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-594990a2 | btnSave.Click | SSP0201_ShipmentChangeRequest.cs:2778 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e72c1f2f | btnSave.Click | SSP0201_ShipmentChangeRequest.cs:2785 | if (sStatus == Shipment_Status.S_Status_R) | MESSAGE | MessageHelper.GMessageBox | ("MSG00174") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4dc86883 | btnSave.Click | SSP0201_ShipmentChangeRequest.cs:2786 | if (sStatus == Shipment_Status.S_Status_R) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0a7d135 | btnSave.Click | SSP0201_ShipmentChangeRequest.cs:2796 |  | FLAG | sChangeStatus | Change_Req_Status.C_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-596815da | btnSave.Click | SSP0201_ShipmentChangeRequest.cs:2797 |  | FLAG | sShipStatus | Shipment_Status.S_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-4f774fd2 | btnSave.Click | SSP0201_ShipmentChangeRequest.cs:2799 |  | FLAG | bErpIFCheck | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0201_ShipmentChangeRequest.CboChangeType_SelectedIndexChanged

진입점: cboChangeType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28e336d3 | cboChangeType.SelectedIndexChanged | SSP0201_ShipmentChangeRequest.cs:2688 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | VALUE_SET | drpPeriod.InitValue | GetDayRange(sDate) | 컨트롤 값 설정 |  |  |  |
| AC-42e46846 | cboChangeType.SelectedIndexChanged | SSP0201_ShipmentChangeRequest.cs:2690 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | VALUE_SET | dtDate.InitValue | Convert.ToDateTime(DateTime.Now.Date).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-23010475 | cboChangeType.SelectedIndexChanged | SSP0201_ShipmentChangeRequest.cs:2693 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-74e34da6 | cboChangeType.SelectedIndexChanged | SSP0201_ShipmentChangeRequest.cs:2695 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | FLAG | dBaseDate | Convert.ToDateTime(dtDate.Value).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-970a6315 | cboChangeType.SelectedIndexChanged | SSP0201_ShipmentChangeRequest.cs:2701 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | VALUE_SET | drpPeriod.InitValue | GetDayRange(sDate) | 컨트롤 값 설정 |  |  |  |
| AC-b6c736db | cboChangeType.SelectedIndexChanged | SSP0201_ShipmentChangeRequest.cs:2703 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | VALUE_SET | dtDate.InitValue | Convert.ToDateTime(DateTime.Now.Date).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-5bb30b6a | cboChangeType.SelectedIndexChanged | SSP0201_ShipmentChangeRequest.cs:2705 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-fd553d11 | cboChangeType.SelectedIndexChanged | SSP0201_ShipmentChangeRequest.cs:2707 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | FLAG | dBaseDate | Convert.ToDateTime(dtDate.Value).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |

## SSP0201_ShipmentChangeRequest.Change_ReValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3dad53e | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3086 |  | FLAG | RollBack_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b82d7a95 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3087 |  | FLAG | iSelRow | iOld_SelRow | 화면 필드/플래그 변경 |  |  |  |
| AC-6d41414f | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3088 |  | FLAG | iSelCol | iOld_SelCol | 화면 필드/플래그 변경 |  |  |  |
| AC-0e3e9185 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3089 |  | FLAG | sRequestID | sBefor_RequestID | 화면 필드/플래그 변경 |  |  |  |
| AC-274809ea | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3090 |  | FLAG | sRequestDeptID | sBefor_RequestDeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-c9b395eb | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3091 |  | FLAG | sApprovalID | sBefor_ApprovalID | 화면 필드/플래그 변경 |  |  |  |
| AC-0d43ed32 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3092 |  | FLAG | sApprovalDeptID | sBefor_ApprovalDeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-25b0c243 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3093 |  | FLAG | sMainConfirmID | sBefor_MainConfirmID | 화면 필드/플래그 변경 |  |  |  |
| AC-fcdcc6ed | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3094 |  | FLAG | sChangeStatus | sBefor_ChangeStatus | 화면 필드/플래그 변경 |  |  |  |
| AC-f435f737 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3095 |  | FLAG | sShipStatus | sBefor_ShipStatus | 화면 필드/플래그 변경 |  |  |  |
| AC-0a4adea9 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3096 |  | FLAG | sRequestName | sBefor_RequestName | 화면 필드/플래그 변경 |  |  |  |
| AC-8cffb08f | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3097 |  | FLAG | sSaveConfirmID | sBefor_SaveConfirmID | 화면 필드/플래그 변경 |  |  |  |
| AC-fb3a0c99 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3098 |  | FLAG | _sRequestNo | _Befor_sRequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-11b7987c | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3099 |  | FLAG | _sConfrimID | _Befor_sConfrimID | 화면 필드/플래그 변경 |  |  |  |

## SSP0201_ShipmentChangeRequest.checkRequired

진입점: btnChangeRe.Click / btnChangeRe2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61f55133 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2919 | if (string.IsNullOrWhiteSpace(txtApproval.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2b25cafc | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2920 | if (string.IsNullOrWhiteSpace(txtApproval.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-10ab50d3 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2930 | if (string.IsNullOrWhiteSpace(txtTitle.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c7df663 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2931 | if (string.IsNullOrWhiteSpace(txtTitle.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f5c09dd2 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2941 | if (cboChangeReason.SelectedIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dfb61df2 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2942 | if (cboChangeReason.SelectedIndex == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8a139282 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2952 | if (string.IsNullOrWhiteSpace(txtReasonDetail.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb162bb2 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2953 | if (string.IsNullOrWhiteSpace(txtReasonDetail.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-bc39f133 | btnChangeRe.Click 외 1 | SSP0201_ShipmentChangeRequest.cs:2958 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0201_ShipmentChangeRequest.chkERPIFBlockYn

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57e07a83 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:2539 |  | FLAG | dtERPBlockYnIF | Data_SCP.Common(Data_SCP.Type.SSPBlockCheckIF, false, "SSP0201") | 화면 필드/플래그 변경 |  |  |  |
| AC-d4b8c0d4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:2539 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSPBlockCheckIF, false, "SSP0201") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ab6d094f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:2542 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("BLOCK_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-231064a1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:2551 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("PERIOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d293a20 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:2552 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00267", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-72a97711 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:2556 |  | RETURN | return resultYn; |  | 처리 중단/반환 |  |  |  |

## SSP0201_ShipmentChangeRequest.ClearRequestInfo

진입점: btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnChangeRe.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnChangeRe2.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnCancel.Click / cboChangeType.SelectedIndexChanged / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-effda3f9 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1465 |  | VALUE_CLEAR | txtRequestNo.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-42677ce8 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1466 |  | VALUE_CLEAR | txtTitle.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-58471b86 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1467 |  | VALUE_CLEAR | txtApproval.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-35f8dba3 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1468 |  | VALUE_CLEAR | txtAppDeptName.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-45f875ad | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1469 |  | VALUE_SET | cboChangeReason.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-817a4a0c | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1470 |  | VALUE_CLEAR | txtReasonDetail.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-be9b819c | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1471 |  | FLAG | sApprovalDeptID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-410486f4 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1472 |  | FLAG | sApprovalID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-815ad0d2 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1473 |  | FLAG | sMainConfirmID | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## SSP0201_ShipmentChangeRequest.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d260f44a | this.Load | SSP0201_ShipmentChangeRequest.cs:523 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-24db211b | this.Load | SSP0201_ShipmentChangeRequest.cs:524 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f3eb07e4 | this.Load | SSP0201_ShipmentChangeRequest.cs:527 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ac963ed3 | this.Load | SSP0201_ShipmentChangeRequest.cs:528 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-d66eb183 | this.Load | SSP0201_ShipmentChangeRequest.cs:537 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0201_ShipmentChangeRequest.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eeaeb268 | this.Load | SSP0201_ShipmentChangeRequest.cs:406 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-f0efc037 | this.Load | SSP0201_ShipmentChangeRequest.cs:408 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-2824436f | this.Load | SSP0201_ShipmentChangeRequest.cs:409 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-96da7a36 | this.Load | SSP0201_ShipmentChangeRequest.cs:410 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-3c5c2c6c | this.Load | SSP0201_ShipmentChangeRequest.cs:411 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## SSP0201_ShipmentChangeRequest.DeleteDataDrafting

진입점: btnCancel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da787045 | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:2373 | if (sFlag == "D" && iBaseChk == 0 && siSub.ActiveSheet.RowCount > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00198") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-31367d20 | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:2375 | if (sFlag == "D" && iBaseChk == 0 && siSub.ActiveSheet.RowCount > 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53b376bb | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:2379 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-5c6ebf28 | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:2384 | if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-69bd4c9a | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:2388 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-3ad2a998 | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:2389 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-5f320abd | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:2390 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-eb68e303 | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:2391 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-0f1e4a46 | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:2392 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-c08dbd10 | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:2393 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_if_send_flag"] | p_if_send_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b1acf5cc | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:2394 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-09f23716 | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:2396 | if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f2e4cd27 | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:2396 | if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-2943b553 | btnCancel.Click | SSP0201_ShipmentChangeRequest.cs:2423 | if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0201_ShipmentChangeRequest.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0817ef1 | Dispose | SSP0201_ShipmentChangeRequest.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0201_ShipmentChangeRequest.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6cbc85b | EditButton | SSP0201_ShipmentChangeRequest.cs:701 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e49df43a | EditButton | SSP0201_ShipmentChangeRequest.cs:702 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-be2e93ad | EditButton | SSP0201_ShipmentChangeRequest.cs:712 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.TO_SITE_D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7cfe3a57 | EditButton | SSP0201_ShipmentChangeRequest.cs:713 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TO_SITE_SOLDTO_CODE), siMain.GetColumnIndex(DefColumns.T… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f7be7e14 | EditButton | SSP0201_ShipmentChangeRequest.cs:714 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TO_SITE_SOLDTO_CODE) +2 , siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b3c466a9 | EditButton | SSP0201_ShipmentChangeRequest.cs:736 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.… | GRID_LOCK | siMain.LockRange | (i, 1, i, siMain.GetMaxColumnIndex(), true, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9ef292ec | EditButton | SSP0201_ShipmentChangeRequest.cs:744 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.ITEM_ID), i, siMain.GetColumnIndex(DefColumns.ITEM_ID… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6fc044ac | EditButton | SSP0201_ShipmentChangeRequest.cs:745 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.FCST_TYPE), i, siMain.GetColumnIndex(DefColumns.FCST_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-72c167e6 | EditButton | SSP0201_ShipmentChangeRequest.cs:746 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION), i, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9e9c8654 | EditButton | SSP0201_ShipmentChangeRequest.cs:747 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CODE), i, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0201_ShipmentChangeRequest.FindData_BOD

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21943022 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5833 |  | FLAG | dtTransMode | null | 화면 필드/플래그 변경 |  |  |  |
| AC-06856352 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5836 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SSP.Plan.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6fad3038 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5840 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_BOD_ITEM") ⇒ SSP.SSP0026_GET_BOD_ITEM | 엔드포인트 요청 생성 |  |  |  |
| AC-a1fe4e51 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5841 | lambda | DATA_OP | request.Parameters["p_division_id"] | sdivision | 행/컬럼 값 대입 |  |  |  |
| AC-bea835be | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5842 | lambda | DATA_OP | request.Parameters["p_from_site_id"] | sFromSite | 행/컬럼 값 대입 |  |  |  |
| AC-bb6da6ae | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5843 | lambda | DATA_OP | request.Parameters["p_to_site_id"] | sToSite | 행/컬럼 값 대입 |  |  |  |
| AC-4f81346b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5844 | lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-e9d6b275 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5845 | lambda | DATA_OP | request.Parameters["p_bod_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b09b73f5 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5846 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3fe9027d | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5848 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5dd8e59e | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5852 |  | FLAG | dtFindData_BOD | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-01182d9e | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5860 | if (dtFindData_BOD.Rows.Count > 0) | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sdivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-95c784e3 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5860 | if (dtFindData_BOD.Rows.Count > 0) | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sdivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-00b99da4 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5864 | if (dtFindData_BOD.Rows.Count > 0) | GRID_COMBO | siMain.SetCellTypeCombo | (row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), dtTransMode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1b86d84c | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5872 | else of (dtFindData_BOD.Rows.Count > 0) | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-72cd09f4 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0201_ShipmentChangeRequest.cs:5873 | else of (dtFindData_BOD.Rows.Count > 0) | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |

## SSP0201_ShipmentChangeRequest.FindData_Main

진입점: btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")] / btnChangeRe.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")] / btnChangeRe2.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")] / btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ else of (!GetERPInterface()) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1368c5de | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1290 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6ed4ea0b | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1295 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-88f4afb9 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1295 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3e441eb | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1299 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0bd12599 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1320 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f1a40162 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1321 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e380cf4e | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1325 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST") ⇒ SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-b2433f1b | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1326 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8e325dae | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1327 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-07d75f9f | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1328 | try ▸ lambda | DATA_OP | request.Parameters["p_erp_so_no"] | p_erp_so_no | 행/컬럼 값 대입 |  |  |  |
| AC-63623b36 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1329 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-fe0ad362 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1330 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b55f2164 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1331 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7b90ae64 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1332 | try ▸ lambda | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-e0859d04 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1333 | try ▸ lambda | DATA_OP | request.Parameters["p_status"] | p_status | 행/컬럼 값 대입 |  |  |  |
| AC-2054ec75 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1334 | try ▸ lambda | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-bf171166 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1335 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-fc1177e5 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1336 | try ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-046d206c | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1339 | try ▸ lambda | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-43f6de99 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1341 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a613e452 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1343 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9adf457c | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1350 | try | GRID_BIND | siMain.Query | (ds,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-376ba4cf | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1351 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-979c06a4 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1356 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-69171ced | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1358 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-1db99fab | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1358 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-07872993 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1361 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3d3fa6a9 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1377 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0201_ShipmentChangeRequest.FindData_Main_Nonasync

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ else of (!GetERPInterface()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06bfb6de | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1383 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-73822769 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1388 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-bb9cb26d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1388 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7fedf7e6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1392 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1bc44589 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1413 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f5e93f79 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1417 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N") ⇒ SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N | 엔드포인트 요청 생성 |  |  |  |
| AC-6dd11825 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1418 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8aeb12d8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1419 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-86aa4c45 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1420 | try | DATA_OP | request.Parameters["p_erp_so_no"] | p_erp_so_no | 행/컬럼 값 대입 |  |  |  |
| AC-d33f7b6f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1421 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3d8a293a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1422 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1ba8409e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1423 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-88a4febe | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1424 | try | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-accf880f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1425 | try | DATA_OP | request.Parameters["p_status"] | p_status | 행/컬럼 값 대입 |  |  |  |
| AC-186e3dbf | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1426 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-d8d34177 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1427 | try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-36eb6eab | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1428 | try | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-6ada6219 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1430 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2e017357 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1439 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-20076b77 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1440 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7637381e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1443 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1441326d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1448 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a4f2cb5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:1459 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0201_ShipmentChangeRequest.FindData_Sub_Draft

진입점: btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")] / btnChangeRe.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")] / btnChangeRe2.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")] / btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ else of (!GetERPInterface()) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f5f1013 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1796 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-951c0027 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1797 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d0acca50 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1798 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-d59cc859 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1799 |  | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-f07ef353 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1800 |  | DATA_OP | request.Parameters["p_erp_so_no"] | p_erp_so_no | 행/컬럼 값 대입 |  |  |  |
| AC-a2d1a523 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1801 |  | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-54cd46d7 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1802 |  | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-d77a6d6d | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1803 |  | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-1719126b | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1804 |  | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-f27c5c92 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1805 |  | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-535f2b29 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1806 |  | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-694ac32c | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1807 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-90608bad | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1808 |  | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-dc575a57 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1809 |  | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-70d588c5 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1810 |  | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-11cf5327 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1811 |  | DATA_OP | request.Parameters["p_request_user_id"] | p_request_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c821ec3c | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1812 |  | DATA_OP | request.Parameters["p_request_status"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-79530a6c | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1813 |  | DATA_OP | request.Parameters["p_language"] | UserInfoContext.Current[UserInfoProperites.Language] | 행/컬럼 값 대입 |  |  |  |
| AC-80d3217d | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1814 |  | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-6eb0c14a | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1815 |  | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-62612114 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1817 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7aeea02d | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1825 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f578b11c | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1826 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ecceb64f | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1829 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-327192c0 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1833 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3b800c0e | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1841 | if (ds.Tables[1].Rows.Count > 0) ▸ if (txtApproval.Text == "" && null != ds.Tables[1] && ds.Tables[1].Rows.Count > 0) | FLAG | sApprovalID | ds.Tables[1].Rows[0]["USER_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a7dbd4c1 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1842 | if (ds.Tables[1].Rows.Count > 0) ▸ if (txtApproval.Text == "" && null != ds.Tables[1] && ds.Tables[1].Rows.Count > 0) | FLAG | sApprovalDeptID | ds.Tables[1].Rows[0]["DEPT_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-81ff09ed | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1845 | if (ds.Tables[1].Rows.Count > 0) ▸ if (txtApproval.Text == "" && null != ds.Tables[1] && ds.Tables[1].Rows.Count > 0) ▸ if (UserInfoContext.… | VALUE_SET | txtApproval.Text | ds.Tables[1].Rows[0]["USER_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-2e266d16 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1846 | if (ds.Tables[1].Rows.Count > 0) ▸ if (txtApproval.Text == "" && null != ds.Tables[1] && ds.Tables[1].Rows.Count > 0) ▸ if (UserInfoContext.… | VALUE_SET | txtAppDeptName.Text | ds.Tables[1].Rows[0]["DEPT_NAME_KO"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-668a1853 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1850 | if (ds.Tables[1].Rows.Count > 0) ▸ if (txtApproval.Text == "" && null != ds.Tables[1] && ds.Tables[1].Rows.Count > 0) ▸ else of (UserInfoCon… | VALUE_SET | txtApproval.Text | ds.Tables[1].Rows[0]["USER_NAME_EN"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-5ff4083a | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 5 | SSP0201_ShipmentChangeRequest.cs:1851 | if (ds.Tables[1].Rows.Count > 0) ▸ if (txtApproval.Text == "" && null != ds.Tables[1] && ds.Tables[1].Rows.Count > 0) ▸ else of (UserInfoCon… | VALUE_SET | txtAppDeptName.Text | ds.Tables[1].Rows[0]["DEPT_NAME_EN"].ToString() | 컨트롤 값 설정 |  |  |  |

## SSP0201_ShipmentChangeRequest.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dca87792 | this.Load | SSP0201_ShipmentChangeRequest.cs:294 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0201_ShipmentChangeRequest.GetDayRange

진입점: this.Load / cboChangeType.SelectedIndexChanged [if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f4e5908 | this.Load 외 1 | SSP0201_ShipmentChangeRequest.cs:2721 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-ade2043d | this.Load 외 1 | SSP0201_ShipmentChangeRequest.cs:2722 |  | DATA_OP | request.Parameters["p_from_date"] | sFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-1f3492c4 | this.Load 외 1 | SSP0201_ShipmentChangeRequest.cs:2723 |  | DATA_OP | request.Parameters["p_offset_day"] | "30" | 행/컬럼 값 대입 |  |  |  |
| AC-12479c10 | this.Load 외 1 | SSP0201_ShipmentChangeRequest.cs:2724 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-61e104b2 | this.Load 외 1 | SSP0201_ShipmentChangeRequest.cs:2725 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-05f15d0f | this.Load 외 1 | SSP0201_ShipmentChangeRequest.cs:2728 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0201_ShipmentChangeRequest.GetErpIFCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d82c370 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:4267 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1587949 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:4276 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-6c19b687 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:4278 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_confirm_id"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-c1523ad7 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:4279 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-a41a7200 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:4280 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_del_flag"] | "E" | 행/컬럼 값 대입 |  |  |  |
| AC-6074892b | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:4281 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a079e310 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:4282 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-c720b0c8 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:4283 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_if_send_flag"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-82bb8388 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:4284 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-c87311a5 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:4286 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b841a735 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:4297 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-05b4bc09 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:4304 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1d153b02 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:4309 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (service.RtFlag == "C_E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3955cb81 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:4320 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0201_ShipmentChangeRequest.GetERPInterface

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b9e6f4e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3421 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-47968bff | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3431 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | DATA_OP | (siMain.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c607a6a2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3437 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00247", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-114191d3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3438 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a2068524 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3446 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7f9a9b6b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3447 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-965f09a5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3475 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (this.Non… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-dd485fa7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3487 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ else of (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (thi… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ad6d89b2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3497 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c49c8437 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3499 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0201_ShipmentChangeRequest.GetErpSoNoCnt

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24a5dfc8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3636 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0201_GET_ERP_SO_NO_CNT") ⇒ SSP.SSP0201_GET_ERP_SO_NO_CNT | 엔드포인트 요청 생성 |  |  |  |
| AC-f92cb1e8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3637 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-969b1b6a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3638 | try | DATA_OP | request.Parameters["p_erp_so_no"] | sErpSoNo | 행/컬럼 값 대입 |  |  |  |
| AC-f073f6a7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3640 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2eb1e989 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3648 | catch ((Exception ex)) | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |
| AC-99ec140f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3650 |  | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0201_ShipmentChangeRequest.GetNewERPInterface

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ else of (!GetERPInterface()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19e2f232 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3523 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (DateTime.TryParse(siMain.GetText(i, siMain.GetColu… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ab25e65b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3524 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (DateTime.TryParse(siMain.GetText(i, siMain.GetColu… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-dc7237fd | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3558 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-169b0311 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3560 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0201_ShipmentChangeRequest.GetShipmentStatusChk

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ee4e1b5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3571 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0201_GET_SHIPMENT_STATUS") ⇒ SSP.SSP0201_GET_SHIPMENT_STATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-b099285a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3572 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-d9ef7cc9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3573 | try | DATA_OP | request.Parameters["p_confirm_id"] | sConfirmID | 행/컬럼 값 대입 |  |  |  |
| AC-4a855669 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3575 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7c262136 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3590 | try ▸ if (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00248", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ffe15a8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3604 | try ▸ if (ds.Tables[1].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00249", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-57b7be4b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3619 | try ▸ if (ds.Tables[2].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00189", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8d562555 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3623 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1287102e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3625 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0201_ShipmentChangeRequest.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ce26d2d | this.Load | SSP0201_ShipmentChangeRequest.cs:432 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f0223c7 | this.Load | SSP0201_ShipmentChangeRequest.cs:433 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtSub) | 데이터 객체 조작/조회 |  |  |  |
| AC-46179ee1 | this.Load | SSP0201_ShipmentChangeRequest.cs:435 |  | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-09522345 | this.Load | SSP0201_ShipmentChangeRequest.cs:437 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-562f1580 | this.Load | SSP0201_ShipmentChangeRequest.cs:440 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl1) | 권한 검사/설정 |  |  |  |
| AC-96546e39 | this.Load | SSP0201_ShipmentChangeRequest.cs:443 |  | DATA_OP | dtChangeStatusCode.Rows.RemoveAt | (0) | 데이터 객체 조작/조회 |  |  |  |
| AC-8407963c | this.Load | SSP0201_ShipmentChangeRequest.cs:445 |  | FLAG | dtMyDivision | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-8d611565 | this.Load | SSP0201_ShipmentChangeRequest.cs:445 |  | DATA_OP | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-77fe941d | this.Load | SSP0201_ShipmentChangeRequest.cs:445 |  | DATA_OP | dtMyDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fe8b0506 | this.Load | SSP0201_ShipmentChangeRequest.cs:449 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d6849929 | this.Load | SSP0201_ShipmentChangeRequest.cs:451 |  | CALL_EXT | clsCtrl.setListBoxEx | (dtChangeReasonCode, cboChangeReason, true, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-859e4856 | this.Load | SSP0201_ShipmentChangeRequest.cs:453 |  | LIST_REBIND | clsCtrl.setListBox | (dtChangeStatusCode, cboStatus, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-320a2729 | this.Load | SSP0201_ShipmentChangeRequest.cs:455 |  | LIST_REBIND | clsCtrl.setListBox | (dtChangeReqType, cboChangeType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5f8dbd1c | this.Load | SSP0201_ShipmentChangeRequest.cs:457 |  | VALUE_SET | cboChangeType.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |
| AC-bbc66bf3 | this.Load | SSP0201_ShipmentChangeRequest.cs:460 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange("") | 컨트롤 값 설정 |  |  |  |
| AC-5c4713bc | this.Load | SSP0201_ShipmentChangeRequest.cs:462 |  | VALUE_SET | dtDate.InitValue | Convert.ToDateTime(DateTime.Now.Date).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-d7666f12 | this.Load | SSP0201_ShipmentChangeRequest.cs:465 | if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-1e7743f3 | this.Load | SSP0201_ShipmentChangeRequest.cs:467 |  | FLAG | dBaseDate | Convert.ToDateTime(dtDate.Value).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-d25ee224 | this.Load | SSP0201_ShipmentChangeRequest.cs:469 |  | FLAG | sRequestID | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-67e7222b | this.Load | SSP0201_ShipmentChangeRequest.cs:473 | if (UserInfoContext.Current[UserInfoProperites.Language] == "KO") | VALUE_SET | txtRequestor.Text | UserInfoContext.Current[UserInfoProperites.UserName].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-bef4fd4f | this.Load | SSP0201_ShipmentChangeRequest.cs:477 | else of (UserInfoContext.Current[UserInfoProperites.Language] == "KO") | VALUE_SET | txtRequestor.Text | UserInfoContext.Current[UserInfoProperites.UserName_E].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-05f1e330 | this.Load | SSP0201_ShipmentChangeRequest.cs:480 |  | FLAG | sRequestName | txtRequestor.Text + "(" + UserInfoContext.Current.UserId + ")" | 화면 필드/플래그 변경 |  |  |  |
| AC-993d031f | this.Load | SSP0201_ShipmentChangeRequest.cs:482 |  | VALUE_SET | txtRequestDeptName.Text | UserInfoContext.Current[UserInfoProperites.Dept_Name] | 컨트롤 값 설정 |  |  |  |
| AC-90ba4e37 | this.Load | SSP0201_ShipmentChangeRequest.cs:483 |  | FLAG | sRequestDeptID | UserInfoContext.Current[UserInfoProperites.Dept_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-bad138ab | this.Load | SSP0201_ShipmentChangeRequest.cs:485 |  | FLAG | sLanguage | UserInfoContext.Current[UserInfoProperites.Language] | 화면 필드/플래그 변경 |  |  |  |
| AC-4d2e41f5 | this.Load | SSP0201_ShipmentChangeRequest.cs:490 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMaxShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[0]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-34547f7d | this.Load | SSP0201_ShipmentChangeRequest.cs:491 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMinShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[1]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-d25a3cef | this.Load | SSP0201_ShipmentChangeRequest.cs:492 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMaxDay | dtShipmentInputPeriod.Rows[0]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-36b4fcce | this.Load | SSP0201_ShipmentChangeRequest.cs:493 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMinDay | dtShipmentInputPeriod.Rows[1]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-689b128e | this.Load | SSP0201_ShipmentChangeRequest.cs:497 |  | CALL_EXT | lcSave.Move | (dragController) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0201_ShipmentChangeRequest.InitSpread

진입점: this.Load / clbDivision_ID.SelectedIndexChanged / btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnChangeRe.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnChangeRe2.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / cboChangeType.SelectedIndexCha…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7cf8400 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:544 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-82eace68 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:546 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-7e06ea94 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:547 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-135cdf3e | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:548 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a07531b5 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:554 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | spdMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ERP_SO_NO)].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-692a844a | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:555 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | spdMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CONFIRM_ID)].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-3f59a97e | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:560 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | UI_PROP | col.Label | MessageHelper.GetTerm(sFieldName) | 속성 Label 설정 |  |  |  |
| AC-a33bcb1e | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:567 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | spdMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CONFIRM_ID)].Width | 120 | 그리드 속성/값 설정 |  |  |  |
| AC-02f04a72 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:572 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | UI_PROP | col.Label | MessageHelper.GetTerm(sFieldName) | 속성 Label 설정 |  |  |  |
| AC-e78df68f | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:578 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.ToStri… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.END_CUSTOMER)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-8446fe7a | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:579 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.ToStri… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-bc2a972b | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:580 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.ToStri… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f4e66542 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:585 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.T… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.END_CUSTOMER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-86b02ccb | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:586 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.T… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-dd814b9f | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:587 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.T… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_NAME)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7f6ffa6c | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:596 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-c25e3f29 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:599 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-d2224047 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:600 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY), 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fb5c10e6 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:608 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | spreadInfo.ActiveSheet.ColumnHeader.Cells[0, spreadInfo.GetColumnIndex(DefColumns.CHK)].Ce… | chk | 그리드 속성/값 설정 |  |  |  |
| AC-656eb264 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:609 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | spreadInfo.ActiveSheet.ColumnHeader.Cells[0, spreadInfo.GetColumnIndex(DefColumns.CHK)].Va… | false | 그리드 속성/값 설정 |  |  |  |
| AC-5220190c | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:610 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | spreadInfo.ActiveSheet.ColumnHeader.Cells[0, spreadInfo.GetColumnIndex(DefColumns.CHK)].Bo… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-28312c6e | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:614 | if (spreadInfo.SheetName == SpdSheet.shtSub) | UI_PROP | col.MergePolicy | FarPoint.Win.Spread.Model.MergePolicy.None | 속성 MergePolicy 설정 |  |  |  |
| AC-7331e635 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:615 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cd316349 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:616 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5422693f | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:619 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | spdSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.REMARKS)].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-bdc73676 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:624 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ERP_SO_NO)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f80b5501 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:626 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.LT_DAY), 1, 7, 20, "Plan", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1d95f924 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:627 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 1, 7, 20, "Confirm", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f09e730f | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:629 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b7774eb7 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:630 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-acf45583 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:631 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8e5ae780 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:632 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-56f670ef | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:633 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_DATE), 2, 1, 30, "Shipment Date", FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-689bc141 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:634 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-174c91ce | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:636 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-96b8b91d | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:637 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2ecf39ac | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:638 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7c781c8a | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:639 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0f30c619 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:640 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), 2, 1, 30, "Shipment Date*", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a7ec4d0 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:641 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty*", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e2e769cf | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:646 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ERP_SO_NO)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-3214c192 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:648 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.LT_DAY), 1, 7, 20, "Confirmed", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e7a8c0c2 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:649 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 1, 7, 20, "Change", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-26ae3f2f | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:651 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-76fd5e34 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:652 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec77f0e9 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:653 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b78ffa9 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:654 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b750ec84 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:655 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_DATE), 2, 1, 30, "Shipment Date", FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc1b4582 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:656 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-99485982 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:658 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b128c2f | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:659 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a33d9364 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:660 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e17a58f | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:661 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4febef52 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:662 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), 2, 1, 30, "Shipment Date*", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3bedad7 | this.Load 외 8 | SSP0201_ShipmentChangeRequest.cs:663 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty*", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0201_ShipmentChangeRequest.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f26213b | InsertButton | SSP0201_ShipmentChangeRequest.cs:2437 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0fb4b1a2 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2455 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | FLAG | dtShipToCode | Data.Common(Data.Type.ShipToCodeByDivision, false, DIVISION_ID, TO_SITE_DESCRIPTION, "", "… ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-e715d680 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2455 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | COMBO_DATA | Data.Common | (Data.Type.ShipToCodeByDivision, false, DIVISION_ID, TO_SITE_DESCRIPTION, "", "", "") ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bb659d2c | InsertButton | SSP0201_ShipmentChangeRequest.cs:2457 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CODE), dtShipToCod… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-02f27a1a | InsertButton | SSP0201_ShipmentChangeRequest.cs:2477 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | FLAG | dtFromSite | Data.UserPlantSiteByDivisionOspPack(UserInfoContext.Current["NowGroupID"], UserInfoContext… | 화면 필드/플래그 변경 |  |  |  |
| AC-fd534caa | InsertButton | SSP0201_ShipmentChangeRequest.cs:2477 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | COMBO_DATA | Data.UserPlantSiteByDivisionOspPack | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, DIVISION_ID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fb2b139d | InsertButton | SSP0201_ShipmentChangeRequest.cs:2478 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteByDivisionEEForSSP, false, DIVISION_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-050ff30e | InsertButton | SSP0201_ShipmentChangeRequest.cs:2478 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteByDivisionEEForSSP, false, DIVISION_ID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a3d8c89 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2488 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION), dtFromSit… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3d7ae5f4 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2489 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTION), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-10d51f2a | InsertButton | SSP0201_ShipmentChangeRequest.cs:2493 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-c18b18d8 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2494 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.ITEM_ID, ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2c0f81f | InsertButton | SSP0201_ShipmentChangeRequest.cs:2495 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.FROM_SITE_DESCRIPTION, FROM_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-cddbb859 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2496 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.TO_SITE_DESCRIPTION, TO_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-b88cb32a | InsertButton | SSP0201_ShipmentChangeRequest.cs:2497 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.TO_SITE_SHIPTO_CODE, TO_SITE_SHIPTO_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-246e6f66 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2501 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.END_CUSTOMER, PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb5ceff9 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2502 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.PROJECT_CODE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-c29981f9 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2507 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.PROJECT_CODE, PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fc8ba7b | InsertButton | SSP0201_ShipmentChangeRequest.cs:2508 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.END_CUSTOMER, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-fbf00fee | InsertButton | SSP0201_ShipmentChangeRequest.cs:2510 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_CONFIRM_QTY, SHIPMENT_CONFIRM_QTY) | 데이터 객체 조작/조회 |  |  |  |
| AC-75ad79df | InsertButton | SSP0201_ShipmentChangeRequest.cs:2511 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_DATE, SHIPMENT_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a7dafb3 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2512 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.INCOTERMS, INCOTERMS) | 데이터 객체 조작/조회 |  |  |  |
| AC-23c26776 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2513 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.TRANSPORT_MODE, TRANSPORT_MODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-97367b5b | InsertButton | SSP0201_ShipmentChangeRequest.cs:2514 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.FCST_TYPE, FCST_TYPE) | 데이터 객체 조작/조회 |  |  |  |
| AC-feae3a75 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2517 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-c4b23180 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2519 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-4ccf2257 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2520 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-65351929 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2521 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0f2b1c55 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2523 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8c6579ea | InsertButton | SSP0201_ShipmentChangeRequest.cs:2524 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ERP_SO_NO), siMain.GetColumnIndex(DefColumns.SH… | 그리드 편집 잠금/해제 |  |  |  |
| AC-23df1bff | InsertButton | SSP0201_ShipmentChangeRequest.cs:2525 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.FC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1294a211 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2526 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TO_SITE_SOLDTO_CODE), siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-69fb0336 | InsertButton | SSP0201_ShipmentChangeRequest.cs:2527 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TO_SITE_SOLDTO_CODE) +2 , siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0201_ShipmentChangeRequest.NewNonSoNo

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ else of (!GetERPInterface()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04454de7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3768 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-edce92ce | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3772 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-7ec51504 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3773 |  | DATA_OP | request.Parameters["p_change_type"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-39e6c780 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3774 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9c0b8350 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3775 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-d6d0ed6b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3776 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-a1e8f239 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3777 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-258cf17d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3778 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-5e79c9a6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3779 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-10bfa65f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3780 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-9fb90a54 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3781 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-81810efe | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3782 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-102e3163 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3783 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-fa57a9de | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3784 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-a5563963 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3785 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-db788abb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3786 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-3faba3ab | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3787 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-17e9fd9f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3788 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-dd88d9b5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3789 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-5e9543a1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3790 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-fbaf6b1e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3791 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-b553af5e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3792 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-a68b0a6c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3793 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-944a0d79 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3794 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-d931ad89 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3795 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-db288bd0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3796 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-98623659 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3797 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-3dd0cdb0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3798 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6ea1cf9e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3799 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-266f240e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3801 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-28571784 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3802 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-16359a48 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3803 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-700f2561 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3805 |  | DATA_OP | request.Parameters["p_change_req_no"] | _ChangeReqno | 행/컬럼 값 대입 |  |  |  |
| AC-f3b43b77 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3807 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-4936aa63 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3808 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-fe8281c1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3809 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-5c4790c8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3810 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-3a28c73d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3812 |  | DATA_OP | request.Parameters["p_shipto_code"] | p_shipto_code | 행/컬럼 값 대입 |  |  |  |
| AC-334b36b3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3814 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-78c4c57a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3835 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c9df340d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3839 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0201_ShipmentChangeRequest.NonSoNo

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9dac4cae | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3939 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-5b016202 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3943 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2fec850b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3944 |  | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-7712e851 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3945 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-630c3a9d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3946 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-54d6739b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3947 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-5552cd1c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3948 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-41f9f812 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3949 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-fc6c441c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3950 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-f738a9ad | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3951 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-5002e130 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3952 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-351a0726 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3953 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-1759805d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3954 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-c79b8945 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3955 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-35c43fa5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3956 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-dc9da097 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3957 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-ebd2fce4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3958 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-81bd36b5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3959 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-81a0e444 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3960 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-89ce2e2c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3961 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-34cc82bb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3962 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-1445a5e7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3963 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-32c36f2b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3964 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-31d2e66b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3965 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e8338e8c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3966 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-eec501a8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3967 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-cf0aa3a6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3968 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-8db3e09d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3969 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0024681d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3970 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d872a6e9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3972 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-4cecff89 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3973 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-d0df7b65 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3974 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-c9f1fcc2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3976 |  | DATA_OP | request.Parameters["p_change_req_no"] | _ChangeReqno | 행/컬럼 값 대입 |  |  |  |
| AC-6c4e84f6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3978 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-ad2e7888 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3979 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-245f5406 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3980 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-eef67116 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3981 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-5d365f25 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3983 |  | DATA_OP | request.Parameters["p_shipto_code"] | p_shipto_code | 행/컬럼 값 대입 |  |  |  |
| AC-159f0efe | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3985 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-73e14a9c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4007 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00293", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ad379a35 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4022 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d5c0fab | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4027 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0201_ShipmentChangeRequest.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6c63af7 | SaveButton | SSP0201_ShipmentChangeRequest.cs:768 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | _ChangeReqno | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f83c4659 | SaveButton | SSP0201_ShipmentChangeRequest.cs:777 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (chkERPIFBlockYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-93b7006b | SaveButton | SSP0201_ShipmentChangeRequest.cs:780 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0201_GET_CHANGE_REQ_NO") ⇒ SSP.SSP0201_GET_CHANGE_REQ_NO | 엔드포인트 요청 생성 |  |  |  |
| AC-5a41ad1b | SaveButton | SSP0201_ShipmentChangeRequest.cs:784 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | requestTemp.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8752ee83 | SaveButton | SSP0201_ShipmentChangeRequest.cs:786 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | client.ExecuteDataSet | (requestTemp) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-71bff633 | SaveButton | SSP0201_ShipmentChangeRequest.cs:790 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dsTemp.Tables[0].Rows[0][0… | FLAG | _ChangeReqno | dsTemp.Tables[0].Rows[0][1].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1cdceac2 | SaveButton | SSP0201_ShipmentChangeRequest.cs:797 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-d3757938 | SaveButton | SSP0201_ShipmentChangeRequest.cs:800 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-624f6a91 | SaveButton | SSP0201_ShipmentChangeRequest.cs:804 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a2c678a1 | SaveButton | SSP0201_ShipmentChangeRequest.cs:812 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a518449f | SaveButton | SSP0201_ShipmentChangeRequest.cs:818 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-195a2c14 | SaveButton | SSP0201_ShipmentChangeRequest.cs:820 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2a9983e2 | SaveButton | SSP0201_ShipmentChangeRequest.cs:823 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-dbb6b9bc | SaveButton | SSP0201_ShipmentChangeRequest.cs:830 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageBox.Show | ("변경 실패") | 메시지 표시 |  |  |  |
| AC-f799c089 | SaveButton | SSP0201_ShipmentChangeRequest.cs:843 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-be226b0f | SaveButton | SSP0201_ShipmentChangeRequest.cs:844 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-97e1941f | SaveButton | SSP0201_ShipmentChangeRequest.cs:934 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4355db4d | SaveButton | SSP0201_ShipmentChangeRequest.cs:936 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | ENDPOINT | new FoxDataRequest | ("SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW") ⇒ SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW | 엔드포인트 요청 생성 |  |  |  |
| AC-8555dc93 | SaveButton | SSP0201_ShipmentChangeRequest.cs:942 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-59d60472 | SaveButton | SSP0201_ShipmentChangeRequest.cs:943 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-878a825a | SaveButton | SSP0201_ShipmentChangeRequest.cs:944 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-687ed37c | SaveButton | SSP0201_ShipmentChangeRequest.cs:945 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-2e8ceb31 | SaveButton | SSP0201_ShipmentChangeRequest.cs:946 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_project_code40"] | p_project_code40 | 행/컬럼 값 대입 |  |  |  |
| AC-e6462386 | SaveButton | SSP0201_ShipmentChangeRequest.cs:947 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-89bdb4c1 | SaveButton | SSP0201_ShipmentChangeRequest.cs:948 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-0a907710 | SaveButton | SSP0201_ShipmentChangeRequest.cs:949 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5f9aca13 | SaveButton | SSP0201_ShipmentChangeRequest.cs:950 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-a5523c8c | SaveButton | SSP0201_ShipmentChangeRequest.cs:951 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-59cb37e8 | SaveButton | SSP0201_ShipmentChangeRequest.cs:952 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-0db103c1 | SaveButton | SSP0201_ShipmentChangeRequest.cs:953 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-1942bed1 | SaveButton | SSP0201_ShipmentChangeRequest.cs:954 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_lt"] | p_lt | 행/컬럼 값 대입 |  |  |  |
| AC-0c3f8b38 | SaveButton | SSP0201_ShipmentChangeRequest.cs:955 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_etd"] | p_etd | 행/컬럼 값 대입 |  |  |  |
| AC-46b9903f | SaveButton | SSP0201_ShipmentChangeRequest.cs:956 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_eta"] | p_eta | 행/컬럼 값 대입 |  |  |  |
| AC-4c17aab0 | SaveButton | SSP0201_ShipmentChangeRequest.cs:957 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_route_id"] | p_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-73e76367 | SaveButton | SSP0201_ShipmentChangeRequest.cs:958 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-5e22479a | SaveButton | SSP0201_ShipmentChangeRequest.cs:959 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_d_country"] | p_d_country | 행/컬럼 값 대입 |  |  |  |
| AC-59a6e6f9 | SaveButton | SSP0201_ShipmentChangeRequest.cs:960 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_d_port_code"] | p_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-8e7799b1 | SaveButton | SSP0201_ShipmentChangeRequest.cs:961 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_a_conuntry"] | p_a_conuntry | 행/컬럼 값 대입 |  |  |  |
| AC-6b32d25f | SaveButton | SSP0201_ShipmentChangeRequest.cs:962 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_a_port_code"] | p_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-f39b84ae | SaveButton | SSP0201_ShipmentChangeRequest.cs:963 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_to_country"] | p_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-089f73e9 | SaveButton | SSP0201_ShipmentChangeRequest.cs:964 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_to_city"] | p_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-2b04193c | SaveButton | SSP0201_ShipmentChangeRequest.cs:965 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-13f66a72 | SaveButton | SSP0201_ShipmentChangeRequest.cs:966 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-b2499e64 | SaveButton | SSP0201_ShipmentChangeRequest.cs:967 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-97e8114f | SaveButton | SSP0201_ShipmentChangeRequest.cs:970 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-fb2191c1 | SaveButton | SSP0201_ShipmentChangeRequest.cs:971 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_time_zone"] | p_time_zone | 행/컬럼 값 대입 |  |  |  |
| AC-9b589e1f | SaveButton | SSP0201_ShipmentChangeRequest.cs:972 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_shipto_code"] | p_shipto_code | 행/컬럼 값 대입 |  |  |  |
| AC-568413bf | SaveButton | SSP0201_ShipmentChangeRequest.cs:974 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-37727ad6 | SaveButton | SSP0201_ShipmentChangeRequest.cs:976 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f54de74e | SaveButton | SSP0201_ShipmentChangeRequest.cs:986 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageBox.Show | ("신규 생성 요청 실패") | 메시지 표시 |  |  |  |
| AC-6ceea13a | SaveButton | SSP0201_ShipmentChangeRequest.cs:996 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00468", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-80623ceb | SaveButton | SSP0201_ShipmentChangeRequest.cs:1001 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00261", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fbaca7d6 | SaveButton | SSP0201_ShipmentChangeRequest.cs:1006 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00328", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-455ec5a7 | SaveButton | SSP0201_ShipmentChangeRequest.cs:1011 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d93d6742 | SaveButton | SSP0201_ShipmentChangeRequest.cs:1013 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7950247c | SaveButton | SSP0201_ShipmentChangeRequest.cs:1029 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cb648c63 | SaveButton | SSP0201_ShipmentChangeRequest.cs:1036 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-294f26b7 | SaveButton | SSP0201_ShipmentChangeRequest.cs:1042 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4311ee52 | SaveButton | SSP0201_ShipmentChangeRequest.cs:1052 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d509fbc4 | SaveButton | SSP0201_ShipmentChangeRequest.cs:1058 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0201_ShipmentChangeRequest.SaveDataDrafting

진입점: btnSave.Click / btnChangeRe.Click / btnChangeRe2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cdac835 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2086 | if (sShipStatus == Shipment_Status.S_Status_R) | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-60e316eb | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2086 | if (sShipStatus == Shipment_Status.S_Status_R) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92e395fd | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2157 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (DateTime.TryParse(siSub.GetText(i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)).ToStr… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fec619ff | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2158 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (DateTime.TryParse(siSub.GetText(i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)).ToStr… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3c1ddfb | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2189 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sQty == "") | CALL_EXT | Convert.ToInt64 | (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6b31669 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2222 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE") ⇒ SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE | 엔드포인트 요청 생성 |  |  |  |
| AC-b4f92099 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2230 | if (iCount > 0) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c835b2b4 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2232 | if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d6c0eb81 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2233 | if (iCount > 0) | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-a543b219 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2234 | if (iCount > 0) | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-65232e78 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2235 | if (iCount > 0) | DATA_OP | request.Parameters["p_request_id"] | p_request_id | 행/컬럼 값 대입 |  |  |  |
| AC-d5d60962 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2236 | if (iCount > 0) | DATA_OP | request.Parameters["p_request_dept_id"] | p_request_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-ea81a62a | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2237 | if (iCount > 0) | DATA_OP | request.Parameters["p_approval_id"] | p_approval_id | 행/컬럼 값 대입 |  |  |  |
| AC-68ad634f | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2238 | if (iCount > 0) | DATA_OP | request.Parameters["p_approval_dept_id"] | p_approval_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-dd09dcb1 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2239 | if (iCount > 0) | DATA_OP | request.Parameters["p_change_reason"] | p_change_reason | 행/컬럼 값 대입 |  |  |  |
| AC-579a65ae | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2240 | if (iCount > 0) | DATA_OP | request.Parameters["p_reason_detail"] | p_reason_detail | 행/컬럼 값 대입 |  |  |  |
| AC-108fd254 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2241 | if (iCount > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-4f4abb6a | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2242 | if (iCount > 0) | DATA_OP | request.Parameters["p_main_confirm_id"] | p_main_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-9d0bf336 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2243 | if (iCount > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-43fe7b51 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2244 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_confirm_id"] | p_new_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-a17cf581 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2246 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-defecaee | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2247 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-37aabf39 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2248 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-446ea7f2 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2249 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-46450418 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2250 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-2b29152a | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2251 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-d37361da | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2252 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-65d30316 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2253 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-2e184ea9 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2254 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-e61f3ff0 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2255 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_lt_day"] | p_new_lt_day | 행/컬럼 값 대입 |  |  |  |
| AC-3ec033ab | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2257 | if (iCount > 0) | DATA_OP | request.Parameters["p_change_status"] | sChangeStatus | 행/컬럼 값 대입 |  |  |  |
| AC-7f66ca58 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2258 | if (iCount > 0) | DATA_OP | request.Parameters["p_ship_status"] | sShipStatus | 행/컬럼 값 대입 |  |  |  |
| AC-2b13d9f6 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2259 | if (iCount > 0) | DATA_OP | request.Parameters["p_change_req_no"] | p_change_req_no | 행/컬럼 값 대입 |  |  |  |
| AC-1f11e4fa | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2260 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-952219ed | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2261 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-5827d301 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2262 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-d68c56ad | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2263 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_ship_date"] | p_new_ship_date | 행/컬럼 값 대입 |  |  |  |
| AC-f17289ff | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2264 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_qty"] | p_new_qty | 행/컬럼 값 대입 |  |  |  |
| AC-7732b856 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2265 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_yn"] | p_new_yn | 행/컬럼 값 대입 |  |  |  |
| AC-d03f766b | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2266 | if (iCount > 0) | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-253c29af | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2267 | if (iCount > 0) | DATA_OP | request.Parameters["p_if_send_flag"] | p_if_send_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f35efe06 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2268 | if (iCount > 0) | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-65c02c27 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2269 | if (iCount > 0) | DATA_OP | request.Parameters["p_plan_confirm_id"] | p_plan_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-780e46f1 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2271 | if (iCount > 0) | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-843fa672 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2272 | if (iCount > 0) | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-7ea66535 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2273 | if (iCount > 0) | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-479cdc90 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2274 | if (iCount > 0) | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d97d5fcd | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2275 | if (iCount > 0) | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-fa173fbd | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2276 | if (iCount > 0) | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-cc547385 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2277 | if (iCount > 0) | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-cbad543c | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2278 | if (iCount > 0) | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-5eaa9561 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2280 | if (iCount > 0) | DATA_OP | request.Parameters["p_auth"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-67b4b746 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2282 | if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-496e9a43 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2287 | if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | VALUE_SET | txtRequestNo.Text | ds.Tables[0].Rows[0][1].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-200ffeee | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2292 | if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R) | MESSAGE | MessageHelper.GMessageBox | ("MSG00173") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-08bd4b33 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2298 | if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveConfirmID | p_confirm_id | 화면 필드/플래그 변경 |  |  |  |
| AC-0a835009 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2299 | if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveFlag | "E" | 화면 필드/플래그 변경 |  |  |  |
| AC-df7c1e5d | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2306 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | DATA_OP | ds.Tables[1].Rows[0][0].ToString().Contains | ("Unauthorized") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee0ec333 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2309 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[1].Rows[0][0].ToString().Contains("Unauthorized") == t… | MESSAGE | MessageHelper.GMessageBox | ("MSG00316") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2f8a3b19 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2311 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[1].Rows[0][0].ToString().Contains("Unauthorized")… | DATA_OP | ds.Tables[1].Rows[0][0].ToString().Contains | ("UnModelPic") | 데이터 객체 조작/조회 |  |  |  |
| AC-c03f6faa | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2314 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[1].Rows[0][0].ToString().Contains("Unauthorized")… | MESSAGE | MessageHelper.GMessageBox | ("MSG00353") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-720b5379 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2316 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[1].Rows[0][0].ToString().Contains("Unauthorized")… | DATA_OP | ds.Tables[1].Rows[0][0].ToString().Contains | ("UnModelItem") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6425abe | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2319 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[1].Rows[0][0].ToString().Contains("Unauthorized")… | MESSAGE | MessageHelper.GMessageBox | ("MSG00353") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bc9a4969 | btnSave.Click 외 2 | SSP0201_ShipmentChangeRequest.cs:2324 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[1].Rows[0][0].ToString().Contains("Unauthorized")… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0201_ShipmentChangeRequest.SetButtonVisual

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db2150e2 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1480 | if (bFlag) | UI_PROP | lcChgReq.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ce78c4e4 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1481 | if (bFlag) | UI_PROP | lcChgReq2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b262d62b | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1482 | if (bFlag) | UI_PROP | lcSave.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d9c0d92c | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1483 | if (bFlag) | UI_PROP | lcDel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-88770dbf | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1484 | if (bFlag) | UI_PROP | lcCancel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f9292823 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1485 | if (bFlag) | UI_PROP | lcAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-8ee84533 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1486 | if (bFlag) | UI_PROP | lcDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ade6c941 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1490 | else of (bFlag) | UI_PROP | lcChgReq.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-106130af | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1491 | else of (bFlag) | UI_PROP | lcChgReq2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6505ed51 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1492 | else of (bFlag) | UI_PROP | lcSave.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-be939841 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1493 | else of (bFlag) | UI_PROP | lcDel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-46b655a7 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1494 | else of (bFlag) | UI_PROP | lcCancel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ea7dcc11 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1495 | else of (bFlag) | UI_PROP | lcAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3f6eed6a | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1496 | else of (bFlag) | UI_PROP | lcDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0201_ShipmentChangeRequest.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71c45900 | this.Load | SSP0201_ShipmentChangeRequest.cs:312 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-199fc735 | this.Load | SSP0201_ShipmentChangeRequest.cs:313 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c26bc66e | this.Load | SSP0201_ShipmentChangeRequest.cs:319 | switch (triggerControl) case "MyDivision": | FLAG | dtMyDivision | DataService.GetSSPInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2c681481 | this.Load | SSP0201_ShipmentChangeRequest.cs:319 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-86dc09c3 | this.Load | SSP0201_ShipmentChangeRequest.cs:324 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | FLAG | dtChangeReasonCode | DataService.GetSSPInnerTable("CHANGE_REASON_CODE_ALL", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e58d056c | this.Load | SSP0201_ShipmentChangeRequest.cs:324 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REASON_CODE_ALL", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d9f25b80 | this.Load | SSP0201_ShipmentChangeRequest.cs:329 | switch (triggerControl) case "SHIPMENT_STATUS": | FLAG | dtChangeStatusCode | DataService.GetSSPInnerTable("SHIPMENT_STATUS", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-55da7b1b | this.Load | SSP0201_ShipmentChangeRequest.cs:329 | switch (triggerControl) case "SHIPMENT_STATUS": | COMBO_DATA | DataService.GetSSPInnerTable | ("SHIPMENT_STATUS", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-88196eaa | this.Load | SSP0201_ShipmentChangeRequest.cs:334 | switch (triggerControl) case "SALES_TYPE_CODE": | FLAG | dtFcstType | DataService.GetSSPInnerTable("SALES_TYPE_CODE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-79a0ddbc | this.Load | SSP0201_ShipmentChangeRequest.cs:334 | switch (triggerControl) case "SALES_TYPE_CODE": | COMBO_DATA | DataService.GetSSPInnerTable | ("SALES_TYPE_CODE", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3665e383 | this.Load | SSP0201_ShipmentChangeRequest.cs:339 | switch (triggerControl) case "CHANGE_REQ_TYPE": | FLAG | dtChangeReqType | DataService.GetSSPInnerTable("CHANGE_REQ_TYPE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d68b0150 | this.Load | SSP0201_ShipmentChangeRequest.cs:339 | switch (triggerControl) case "CHANGE_REQ_TYPE": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REQ_TYPE", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-181d55ac | this.Load | SSP0201_ShipmentChangeRequest.cs:344 | switch (triggerControl) case "CHANGE_REQ_DAY": | FLAG | dtBaseDay | DataService.GetSSPInnerTable("CHANGE_REQ_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-369ded1c | this.Load | SSP0201_ShipmentChangeRequest.cs:344 | switch (triggerControl) case "CHANGE_REQ_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REQ_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e1fa5306 | this.Load | SSP0201_ShipmentChangeRequest.cs:349 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | FLAG | dtShipmentInputPeriod | DataService.GetSSPInnerTable("SHIPMENT_PERIOD_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-263f853a | this.Load | SSP0201_ShipmentChangeRequest.cs:349 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("SHIPMENT_PERIOD_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## SSP0201_ShipmentChangeRequest.SetChangedControl

진입점: this.Load / clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4cf22f9 | this.Load 외 1 | SSP0201_ShipmentChangeRequest.cs:506 |  | FLAG | dtPlantSiteByDivision | Data.UserPlantSiteByDivisionOspPack(UserInfoContext.Current["NowGroupID"], UserInfoContext… | 화면 필드/플래그 변경 |  |  |  |
| AC-9ea924b4 | this.Load 외 1 | SSP0201_ShipmentChangeRequest.cs:506 |  | COMBO_DATA | Data.UserPlantSiteByDivisionOspPack | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-16144478 | this.Load 외 1 | SSP0201_ShipmentChangeRequest.cs:507 |  | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ShipmentPlanToSite, false, pDivisionID, UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-2fa4c2db | this.Load 외 1 | SSP0201_ShipmentChangeRequest.cs:507 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanToSite, false, pDivisionID, UserInfoContext.Current["NowGroupID… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bb93917b | this.Load 외 1 | SSP0201_ShipmentChangeRequest.cs:509 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, this.clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-da20dcb2 | this.Load 외 1 | SSP0201_ShipmentChangeRequest.cs:511 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ed1ba09c | this.Load 외 1 | SSP0201_ShipmentChangeRequest.cs:515 |  | VALUE_SET | clbDivision_ID.ControlValues | "40" | 컨트롤 값 설정 |  |  |  |
| AC-5eaddc6d | this.Load 외 1 | SSP0201_ShipmentChangeRequest.cs:516 |  | STATE | clbDivision_ID.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0201_ShipmentChangeRequest.SetChangeRequestInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b61ccfc0 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1994 |  | FLAG | sApprovalDeptID | dt.Rows[0]["APPROVAL_DEPT"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b4e5bf21 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:1999 |  | VALUE_SET | txtRequestNo.Text | sRequestNo | 컨트롤 값 설정 |  |  |  |
| AC-3250a813 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2000 |  | VALUE_SET | txtRequestor.Text | sRequestorName | 컨트롤 값 설정 |  |  |  |
| AC-6632a00b | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2001 |  | VALUE_SET | txtRequestDeptName.Text | sRequestDeptName | 컨트롤 값 설정 |  |  |  |
| AC-3cb810dd | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2002 |  | FLAG | _sRequestNo | sRequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-436b3392 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2006 | if (!bReadOnly) | FLAG | sRequestID | sRequestorID | 화면 필드/플래그 변경 |  |  |  |
| AC-ba4a5d10 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2007 | if (!bReadOnly) | FLAG | sRequestName | sRequestorName + "(" + sRequestID + ")" | 화면 필드/플래그 변경 |  |  |  |
| AC-9d7cd86d | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2009 | if (!bReadOnly) | STATE | txtTitle.ReadOnly | false | 컨트롤 상태 ReadOnly |  |  |  |
| AC-b52a5431 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2010 | if (!bReadOnly) | UI_PROP | lcAppDept.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4bdeaf75 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2011 | if (!bReadOnly) | STATE | cboChangeReason.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c0ec1e61 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2012 | if (!bReadOnly) | STATE | txtReasonDetail.ReadOnly | false | 컨트롤 상태 ReadOnly |  |  |  |
| AC-a51dca1f | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2017 | else of (!bReadOnly) | STATE | txtTitle.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-a31381e6 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2018 | else of (!bReadOnly) | UI_PROP | lcAppDept.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-cca7cea8 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2019 | else of (!bReadOnly) | STATE | cboChangeReason.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-dc8d857a | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2020 | else of (!bReadOnly) | STATE | txtReasonDetail.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-3acdabe8 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2023 |  | VALUE_SET | txtTitle.Text | sTitle | 컨트롤 값 설정 |  |  |  |
| AC-2b470735 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2025 |  | VALUE_SET | txtApproval.Text | sApprovalUserName | 컨트롤 값 설정 |  |  |  |
| AC-b997708e | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2026 |  | FLAG | sApprovalID | sApproval | 화면 필드/플래그 변경 |  |  |  |
| AC-f999deab | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2028 |  | VALUE_SET | txtAppDeptName.Text | sApprovalDeptName | 컨트롤 값 설정 |  |  |  |
| AC-e4c63c7a | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2029 |  | VALUE_SET | cboChangeReason.SelectedValue | sChaneReason | 컨트롤 값 설정 |  |  |  |
| AC-b21afafd | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2030 |  | VALUE_SET | txtReasonDetail.Text | sReasonDetail | 컨트롤 값 설정 |  |  |  |

## SSP0201_ShipmentChangeRequest.SetChangeRequestSOGrid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56856fe5 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2035 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ac777508 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2036 |  | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-adc2e623 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2038 |  | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(CAppSetting.StringAction), siSub.GetColumnIndex(DefColumns.NEW_ETA),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-be0604e0 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2042 | for (i < siSub.ActiveSheet.RowCount) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(CAppSetting.StringAction)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-73798695 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2046 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.SetText | (i, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-66ba66d2 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2047 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-4e26200f | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2048 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-86951fb8 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2049 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Lock… | true | 그리드 속성/값 설정 |  |  |  |
| AC-1254d050 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2050 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Back… | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-e7ae8514 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2055 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.SetText | (i, siMain.GetColumnIndex(CAppSetting.StringAction), CAppSetting.FlagM) | 그리드 값 설정 |  |  |  |
| AC-ccdfb5b4 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2059 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ if (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-88012a54 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2060 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ if (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].BackColor | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-da20db40 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2061 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ if (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.CHK)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-fbf4516c | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2065 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ else of (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.CHK)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-9aca4cc4 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2066 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ else of (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-9a20dfeb | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2067 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ else of (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-1778a823 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2069 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-fd21f832 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2070 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)].BackColor | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-6ff2696d | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2071 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Lock… | false | 그리드 속성/값 설정 |  |  |  |
| AC-324b2ede | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2072 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Back… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-9da04952 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2075 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.REMARKS2)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-162c5179 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2076 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.REMARKS2)].BackColor | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-91591229 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2077 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.REMARKS3)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-f6ae5908 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2078 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.REMARKS3)].BackColor | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |

## SSP0201_ShipmentChangeRequest.setEndCustomer

진입점: btnNew.Click [if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.SelectedValue.ToString() != "EE") ▸ if (clbDivision_ID.SelectedValue.ToString() == "40")] / this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (popItem.ItemID != "") ▸ if (sdivision == "40")] / this.spdMain.ClipboardPasted [if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5704e5de | btnNew.Click [if (siMain != null && siMain.IsLock(siMain.She… 외 4 | SSP0201_ShipmentChangeRequest.cs:5783 | if (sDivision != "" && sToSite != "" && sItemId != "") | FLAG | dtEndCustomer | Data_SCP.Common(Data_SCP.Type.EndCustomerByItemForSSP, false, sDivision, sToSite, sItemId,… | 화면 필드/플래그 변경 |  |  |  |
| AC-e81fc2ac | btnNew.Click [if (siMain != null && siMain.IsLock(siMain.She… 외 4 | SSP0201_ShipmentChangeRequest.cs:5783 | if (sDivision != "" && sToSite != "" && sItemId != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.EndCustomerByItemForSSP, false, sDivision, sToSite, sItemId, sFromSite, "P"… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a33fa133 | btnNew.Click [if (siMain != null && siMain.IsLock(siMain.She… 외 4 | SSP0201_ShipmentChangeRequest.cs:5785 | if (sDivision != "" && sToSite != "" && sItemId != "") | GRID_COMBO | siMain.SetCellTypeCombo | (iROW, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e816db2c | btnNew.Click [if (siMain != null && siMain.IsLock(siMain.She… 외 4 | SSP0201_ShipmentChangeRequest.cs:5788 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ if (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) | GRID_SET | siMain.SetValue | (iROW, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer.Rows[0]["CODE"].ToStr… | 그리드 값 설정 |  |  |  |
| AC-325465a9 | btnNew.Click [if (siMain != null && siMain.IsLock(siMain.She… 외 4 | SSP0201_ShipmentChangeRequest.cs:5789 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ if (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) | GRID_SET | siMain.SetText | (iROW, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer.Rows[0]["CODE"].ToStr… | 그리드 값 설정 |  |  |  |
| AC-2bf93f06 | btnNew.Click [if (siMain != null && siMain.IsLock(siMain.She… 외 4 | SSP0201_ShipmentChangeRequest.cs:5794 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | FLAG | dtEndCustomer | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-0c568ac5 | btnNew.Click [if (siMain != null && siMain.IsLock(siMain.She… 외 4 | SSP0201_ShipmentChangeRequest.cs:5795 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | dtEndCustomer.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-469a3984 | btnNew.Click [if (siMain != null && siMain.IsLock(siMain.She… 외 4 | SSP0201_ShipmentChangeRequest.cs:5796 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | dtEndCustomer.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-62814c42 | btnNew.Click [if (siMain != null && siMain.IsLock(siMain.She… 외 4 | SSP0201_ShipmentChangeRequest.cs:5797 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | dtEndCustomer.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-520eb902 | btnNew.Click [if (siMain != null && siMain.IsLock(siMain.She… 외 4 | SSP0201_ShipmentChangeRequest.cs:5798 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | drRow["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-3aec3a5e | btnNew.Click [if (siMain != null && siMain.IsLock(siMain.She… 외 4 | SSP0201_ShipmentChangeRequest.cs:5799 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | drRow["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-491e551b | btnNew.Click [if (siMain != null && siMain.IsLock(siMain.She… 외 4 | SSP0201_ShipmentChangeRequest.cs:5800 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | dtEndCustomer.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca2e97ad | btnNew.Click [if (siMain != null && siMain.IsLock(siMain.She… 외 4 | SSP0201_ShipmentChangeRequest.cs:5801 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | GRID_COMBO | siMain.SetCellTypeCombo | (iROW, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SSP0201_ShipmentChangeRequest.SetMainStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1c31c52 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2603 | if (bDeleClickYn) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a52115dc | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2611 | for (iRow < siMain.ActiveSheet.RowCount) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-2fa973c1 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2614 |  | FLAG | sMainConfirmID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-0a30ca3c | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2627 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS), sShipStatus) | 그리드 값 설정 |  |  |  |
| AC-efe43065 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2628 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER), sRequestID) | 그리드 값 설정 |  |  |  |
| AC-bd8d0bd2 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2629 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER_NAME), sRequestName) | 그리드 값 설정 |  |  |  |
| AC-db260dd5 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2630 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_TIME), DateTime.Now) | 그리드 값 설정 |  |  |  |
| AC-674205fa | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2631 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO), txtRequestNo.Text) | 그리드 값 설정 |  |  |  |
| AC-c90c8d5a | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2632 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-71118859 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2643 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | DATA_OP | (siSub.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2f25a46d | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2646 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLAN_CONFIRM_ID), dr[DefColumns.CONFIRM_ID].ToStri… | 그리드 값 설정 |  |  |  |
| AC-fea4bcb6 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2651 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS), sShipStatus) | 그리드 값 설정 |  |  |  |
| AC-cd536d48 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2652 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER), sRequestID) | 그리드 값 설정 |  |  |  |
| AC-b8da59bb | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2653 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER_NAME), sRequestName) | 그리드 값 설정 |  |  |  |
| AC-17904fee | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2654 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_TIME), DateTime.Now) | 그리드 값 설정 |  |  |  |
| AC-eb6d71b8 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2655 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO), txtRequestNo.Text) | 그리드 값 설정 |  |  |  |
| AC-a423e6bc | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2656 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-e5248f4b | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2664 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS), sShipStatus) | 그리드 값 설정 |  |  |  |
| AC-2fa16da5 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2665 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER), sRequestID) | 그리드 값 설정 |  |  |  |
| AC-200bdbbd | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2666 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER_NAME), sRequestName) | 그리드 값 설정 |  |  |  |
| AC-e015988d | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2667 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_TIME), DateTime.Now) | 그리드 값 설정 |  |  |  |
| AC-6d429173 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2668 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO), txtRequestNo.Text) | 그리드 값 설정 |  |  |  |
| AC-666c57fa | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2669 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |

## SSP0201_ShipmentChangeRequest.SetStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4760fd87 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:2573 |  | FLAG | sMainConfirmID | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## SSP0201_ShipmentChangeRequest.shtMain_Change

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48bcd5be | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5619 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange != true \|\| e.Row == -1 && e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9f4c6c6 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5620 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e12c7aff | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5629 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00189") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-afb7712a | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5630 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc10bc03 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5655 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-867f958f | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5665 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-bf200b42 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5667 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-c7c7c7f3 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5668 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].ForeColor | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-c378fc5c | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5669 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].BackColor | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-a218453b | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5673 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-b5776874 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5684 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-72ccf2d2 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5694 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-5f66274c | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5696 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-00226a24 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5697 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].ForeColor | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-ac7c5c79 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5698 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].BackColor | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-32ba54e1 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5713 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-efd73fc7 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5714 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7f0426d0 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5718 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-ae0a9b60 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5725 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-5a75e2b4 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5735 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-25ec2122 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5736 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-5adb0bd6 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5737 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-9ac0554c | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5749 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-6f2bdf99 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5759 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-8ceed865 | dsdm.Changed | SSP0201_ShipmentChangeRequest.cs:5760 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0201_ShipmentChangeRequest.SoNo

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ else of (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05c51256 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4042 | for (i < intRowIdx) ▸ if (erpSoNo == siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ERP_SO_NO)).ToString()) ▸ if (intRowIdx > i) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-85de9b61 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4163 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-b2e16115 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4167 | try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e200f7ed | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4168 | try | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-7dd553a0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4169 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2bce2a46 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4170 | try | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-fe5fbf0d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4171 | try | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-e1983344 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4172 | try | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-b940e073 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4173 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-7d52287e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4174 | try | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-1b3fbb20 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4175 | try | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-01a1d222 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4176 | try | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-1b70e58d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4177 | try | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-e8320100 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4178 | try | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-c335be73 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4179 | try | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-3d6fd6d3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4180 | try | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-09b84d0c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4181 | try | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-84f22f50 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4182 | try | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-dd5f0231 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4183 | try | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-19ac2131 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4184 | try | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-ed716455 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4185 | try | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-9a8987d0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4186 | try | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-d8c82782 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4187 | try | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-62cf62f0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4188 | try | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-6954c519 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4189 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-56c4b554 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4190 | try | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-9715444d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4191 | try | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-886e1f94 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4192 | try | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-66f8733e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4193 | try | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e10ce70d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4194 | try | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-583a7df3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4196 | try | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-b5d382bb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4197 | try | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-b31d1075 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4198 | try | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-37c14315 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4200 | try | DATA_OP | request.Parameters["p_change_req_no"] | _ChangeReqno | 행/컬럼 값 대입 |  |  |  |
| AC-3ed41ac4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4202 | try | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-cc919501 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4203 | try | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-f6c063d3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4204 | try | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-7a8a2a95 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4205 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-424c05b5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4207 | try | DATA_OP | request.Parameters["p_shipto_code"] | p_shipto_code | 행/컬럼 값 대입 |  |  |  |
| AC-d9f37517 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4209 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e80eb8bd | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4229 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00293", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-00589aff | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4244 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-28d09723 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4248 | try | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |
| AC-08837e50 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:4255 | catch ((Exception ex)) | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0201_ShipmentChangeRequest.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e6016f8 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4464 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (spdMain.AutoClipboard == true) | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.ClipboardPasteAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-063bee4a | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4465 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (spdMain.AutoClipboard == true) | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.ClipboardCopyAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f6e008a3 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4466 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (spdMain.AutoClipboard == true) | UI_PROP | spdMain.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |
| AC-d8627ead | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4479 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Div") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c6f2e0c6 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4480 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7fd809f4 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4492 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Div") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-64a1fa65 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4493 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e918d867 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4677 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-036905b3 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4677 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8f3256f9 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4679 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), dtTransMode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ac614757 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4680 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Vertical… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-d7782c2b | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4681 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Horizont… | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-01df70ff | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4691 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | FLAG | dtShipToCode | Data.Common(Data.Type.ShipToCodeByDivision, false, sDivision, sToSite, "", "", "") ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-9da16812 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4691 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | COMBO_DATA | Data.Common | (Data.Type.ShipToCodeByDivision, false, sDivision, sToSite, "", "", "") ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4fc16863 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4693 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CODE), dtShipToCode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-415011cb | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4695 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CODE)].Ver… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-c4fc5c27 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4696 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CODE)].Hor… | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-16cb2396 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4705 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.Activ… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-a8d34e35 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4709 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.Activ… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-baabac61 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4722 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ActiveColumnIndex == siMain.GetColumnIndex(DefColum… | UI_PROP | spdMain.AutoClipboard | true | 속성 AutoClipboard 설정 |  |  |  |
| AC-daa93ba4 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4723 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ActiveColumnIndex == siMain.GetColumnIndex(DefColum… | FLAG | im | spdMain.GetInputMap(FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | 화면 필드/플래그 변경 |  |  |  |
| AC-cdafce7a | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4723 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ActiveColumnIndex == siMain.GetColumnIndex(DefColum… | CALL_EXT | spdMain.GetInputMap | (FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d87c2d48 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4724 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ActiveColumnIndex == siMain.GetColumnIndex(DefColum… | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a2c0b2b | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4725 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ActiveColumnIndex == siMain.GetColumnIndex(DefColum… | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-27791620 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4740 | else of (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-cc6a99dd | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4744 | else of (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-8a8ba734 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4751 | else of (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-1299048a | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4755 | else of (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-a4705085 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4766 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) ▸ if (string.IsNullOrWhiteSpace(sRequestNo)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45544987 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4768 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | new SCM0002_ShipmentPlanRequestPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fc8b616d | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4769 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-20f4667f | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4770 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop._sRequestNo | sRequestNo | 속성 _sRequestNo 설정 |  |  |  |
| AC-9e778f63 | this.spdMain.CellClick | SSP0201_ShipmentChangeRequest.cs:4771 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0201_ShipmentChangeRequest.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6253116b | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4342 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (string.IsNullOrEmpty(sdivision)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Div") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ac8d40c4 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4344 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (string.IsNullOrEmpty(sdivision)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d0b6c450 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4350 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (string.IsNullOrEmpty(sfromSite)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4c32f2ea | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4352 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (string.IsNullOrEmpty(sfromSite)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fdecd3e0 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4358 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (string.IsNullOrEmpty(sScmSite)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-60d249d3 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4360 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (string.IsNullOrEmpty(sScmSite)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-21e3cdc8 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4365 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") | POPUP | new SSP0026_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7a505457 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4370 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") | POPUP | popItem.Form_Load | (false, sdivision, sfromSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-45b7f243 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4371 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-87ba6a41 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4372 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-82a90812 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4378 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (popItem.ItemID != "") | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-b9b02851 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4379 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (popItem.ItemID != "") | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), popItem.NickName) | 그리드 값 설정 |  |  |  |
| AC-729be6a7 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4402 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Div") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ef5ff06 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4404 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-36700f4d | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4410 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a425676 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4412 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5248d5ee | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4418 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7addc199 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4420 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c04271e0 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4426 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Model") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-284c1b82 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4428 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07b389b3 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4437 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1481c76f | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4438 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-a5ff2f34 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4439 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4dcead4a | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4440 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ecc67427 | this.spdMain.CellDoubleClick | SSP0201_ShipmentChangeRequest.cs:4446 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), sProjectCode) | 그리드 값 설정 |  |  |  |

## SSP0201_ShipmentChangeRequest.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7f97b3d | this.spdMain.ClipboardPasted | SSP0201_ShipmentChangeRequest.cs:5143 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtShipToCode | Data.Common(Data.Type.ShipToCodeByDivision, false, sDivision, sToSite, "", "", "") ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-83d24af3 | this.spdMain.ClipboardPasted | SSP0201_ShipmentChangeRequest.cs:5143 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | COMBO_DATA | Data.Common | (Data.Type.ShipToCodeByDivision, false, sDivision, sToSite, "", "", "") ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8aab706e | this.spdMain.ClipboardPasted | SSP0201_ShipmentChangeRequest.cs:5145 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CODE), dtShipToCod… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SSP0201_ShipmentChangeRequest.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e6b6f9e | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4785 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (!string.IsNullOrEmpty(sItemId)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-0f965c48 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4786 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (!string.IsNullOrEmpty(sItemId)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-6ba8833e | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4787 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (!string.IsNullOrEmpty(sItemId)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-77a1258c | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4803 | else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_DES… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fb5a8bb4 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4805 | else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_DES… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7e983307 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4811 | else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_DES… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-431aa0a4 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4812 | else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_DES… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-cf8b5b4d | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4813 | else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_DES… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-ba9fb335 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4815 | else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_DES… | FLAG | dtShipToCode | Data.Common(Data.Type.ShipToCodeByDivision, false, clbDivision_ID.SelectedValue.ToString()… ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-a144a11b | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4815 | else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_DES… | COMBO_DATA | Data.Common | (Data.Type.ShipToCodeByDivision, false, clbDivision_ID.SelectedValue.ToString(), sToSite, … ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-449f014f | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4817 | else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_DES… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CODE), dtShipToCod… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e6920d15 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4840 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") | FLAG | dtFromSite | Data.UserPlantSiteByDivisionOspPack(UserInfoContext.Current["NowGroupID"], UserInfoContext… | 화면 필드/플래그 변경 |  |  |  |
| AC-aa01a6eb | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4840 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") | COMBO_DATA | Data.UserPlantSiteByDivisionOspPack | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-91ab5f3a | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4841 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-061f4719 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4841 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ec3df3d0 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4852 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION), dtFromSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cb0fbdea | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4853 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTION), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5f7bbf61 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4855 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-1273de42 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4856 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-f4735fe6 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4857 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-169d7cd3 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4858 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-d90cdd8a | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4859 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-63f11d1b | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4860 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-01cd34e5 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4861 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FCST_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-0a09f90b | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4862 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-4341f84b | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4863 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-fcb2b7ec | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4864 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-1278c92e | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4870 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.END_CUSTOMER)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-506f7c87 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4871 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0bf21a7a | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4872 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-744c99f7 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4873 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), e.Row, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d6edaf89 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4874 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), e.Row, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-981ba99f | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4875 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "-") | 그리드 값 설정 |  |  |  |
| AC-6722adbb | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4879 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.END_CUSTOMER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b7f7af03 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4880 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f30f3108 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4881 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_NAME)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-abf1e396 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4882 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), e.Row, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4696b4ac | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4883 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), e.Row, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-65c633a9 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4904 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Div*") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b26745e9 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4906 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToS… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-f0d2a404 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4907 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f90810aa | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4914 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIP… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-46dbb269 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4915 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIP… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-f3432fd5 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4917 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIP… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72ed2e7c | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4924 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bd8d061b | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4925 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTI… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-9bae97e9 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4926 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6be9e61 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4934 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToStrin… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Model*") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bfe9e02f | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4935 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToStrin… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-516b3214 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4936 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToStrin… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff1d5340 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4939 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-869ab1a7 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4940 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-78920989 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4955 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (dtTransMode == null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00293", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ba8acf7e | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4956 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (dtTransMode == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c8521df | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4959 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(siMain.GetValue(e.Row, siMain.GetColumnInd… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0cd6a67c | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4972 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DAT… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Shipmente Date") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a0edaca0 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4974 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DAT… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-661ec8e8 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4975 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DAT… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-e2362cf9 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4976 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DAT… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10a9dcec | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4982 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS)).… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Incoterms") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd40002e | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4984 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS)).… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-6429ae4e | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4985 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS)).… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-33777735 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4986 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS)).… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a6789ee | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:4992 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | DATA_OP | dtTransMode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b85e4cb1 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:5032 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-54aa3d56 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:5042 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), sNewTransMode) | 그리드 값 설정 |  |  |  |
| AC-6b44a916 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:5057 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-63c038da | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:5075 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-832ce025 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:5076 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-95faad12 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:5081 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-a89a6ade | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:5095 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-c8aae008 | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:5096 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-6461580c | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:5097 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-1eb84c9b | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:5102 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-96655feb | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:5103 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-68b9de9d | this.spdMain.ComboSelChange | SSP0201_ShipmentChangeRequest.cs:5104 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0201_ShipmentChangeRequest.SpdMain_CursorChanged

진입점: spdMain.CursorChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aabe23eb | spdMain.CursorChanged | SSP0201_ShipmentChangeRequest.cs:396 | if (RollBack_Flag == true) ▸ if (iOld_SelRow != -1 \|\| iOld_SelCol != -1) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iOld_SelRow, iOld_SelCol) | 그리드 표시 설정 |  |  |  |
| AC-78b82cd8 | spdMain.CursorChanged | SSP0201_ShipmentChangeRequest.cs:397 | if (RollBack_Flag == true) ▸ if (iOld_SelRow != -1 \|\| iOld_SelCol != -1) | CALL_EXT | spdMain.ShowCell | (0, 0, this.iOld_SelRow, this.iOld_SelCol, FarPoint.Win.Spread.VerticalPosition.Center, Fa… | ⚠ 의미 확인 필요 |  |  |  |
| AC-fed80688 | spdMain.CursorChanged | SSP0201_ShipmentChangeRequest.cs:399 | if (RollBack_Flag == true) ▸ if (iOld_SelRow != -1 \|\| iOld_SelCol != -1) | FLAG | RollBack_Flag | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0201_ShipmentChangeRequest.SpdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-249c8845 | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5517 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-012329be | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5528 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d54689d | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5529 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), "") | 그리드 값 설정 |  |  |  |
| AC-ee2ba192 | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5530 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-003b4237 | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5533 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5a90f4f7 | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5544 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-233ec37d | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5545 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-495e0fda | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5546 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-3d18f196 | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5547 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-0f686a1a | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5548 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-0abcbbb5 | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5558 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-c567dfa4 | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5561 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-467cb0b2 | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5562 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-b6e47f8d | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5563 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-c7c77cf6 | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5564 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-e0362446 | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5580 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.ERP_SO_NO)) | 그리드 표시 설정 |  |  |  |
| AC-451b859d | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5581 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | CALL_EXT | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL)].Re… | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3dd72366 | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5583 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00287", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6e928ea2 | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5585 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66a8fd61 | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5593 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-53296383 | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5603 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-1ce9d5e5 | this.spdMain.EditChange | SSP0201_ShipmentChangeRequest.cs:5605 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0201_ShipmentChangeRequest.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-547a86c7 | spdMain.TopChange | SSP0201_ShipmentChangeRequest.cs:2734 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0201_ShipmentChangeRequest.SSP_Main_Validation

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f378179c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3147 |  | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7437a218 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3173 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a288bcbb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3174 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1dc5b724 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3181 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00359", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e5f8fe2f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3182 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-dc852157 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3188 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e451d029 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3188 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ lamb… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-aba8937d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3206 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d460b075 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3219 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), "T07") | 그리드 값 설정 |  |  |  |
| AC-192322ed | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3238 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-958ad7f9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3238 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-041a1b13 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3279 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].ResetBackColo… | () | 그리드 표시 설정 |  |  |  |
| AC-bc721f19 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3280 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].ResetForeColo… | () | 그리드 표시 설정 |  |  |  |
| AC-d5afa270 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3281 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-9cf8d30d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3283 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].ResetF… | () | 그리드 표시 설정 |  |  |  |
| AC-f8f26385 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3284 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetForeColo… | () | 그리드 표시 설정 |  |  |  |
| AC-edac414f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3285 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetForeCol… | () | 그리드 표시 설정 |  |  |  |
| AC-bb2283eb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3286 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-fa02f03c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3287 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-bd501b67 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3295 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-dff3018c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3299 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ddeae2ba | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3315 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-15c29cee | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3315 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf60d820 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3347 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].ResetBackColo… | () | 그리드 표시 설정 |  |  |  |
| AC-42e398af | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3348 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].ResetForeColo… | () | 그리드 표시 설정 |  |  |  |
| AC-160ae848 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3349 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-7bf9907b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3351 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].ResetF… | () | 그리드 표시 설정 |  |  |  |
| AC-3ea10d25 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3352 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetForeColo… | () | 그리드 표시 설정 |  |  |  |
| AC-57c468b8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3353 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetForeCol… | () | 그리드 표시 설정 |  |  |  |
| AC-d622de2c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3354 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-90d64add | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3355 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-f4865e99 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3357 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | MESSAGE | MessageHelper.GMessageBox | ("MSG00286", new object[] { (i + 1).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f39f6237 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3359 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e574472d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3383 | for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f1f1edf9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3384 | for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-78435644 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3391 | for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00359", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-19c20af8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3392 | for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-16f4a101 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3396 | for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d4f814f9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0201_ShipmentChangeRequest.cs:3400 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SSP0201_ShipmentChangeRequest.SSP_Main_Validation_SoldTo_ShipTo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-199bfbac | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3119 | if (string.IsNullOrWhiteSpace(soldto) \|\| string.IsNullOrWhiteSpace(shipto)) | MESSAGE | MessageBox.Show | (msg) | 메시지 표시 |  |  |  |
| AC-8013c976 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3120 | if (string.IsNullOrWhiteSpace(soldto) \|\| string.IsNullOrWhiteSpace(shipto)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-230cd7a4 | (진입점 미연결) | SSP0201_ShipmentChangeRequest.cs:3127 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

