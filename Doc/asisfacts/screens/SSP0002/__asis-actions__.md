# AS-IS 액션 대조표 — SSP0002

> 원천: `Doc/asisfacts/screens/SSP0002/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1712행 · 메서드 111 · 종류 DATA_OP 393 · GRID_SET 329 · FLAG 245 · RETURN 136 · GRID_INIT 111 · MESSAGE 94 · UI_PROP 90 · ENDPOINT 58 · VALUE_SET 51 · COMBO_DATA 34 · POPUP 27 · UI_MISC 22 · GRID_COMBO 22 · GRID_LOCK 21 · CALL_EXT 19 · VALUE_CLEAR 17 · STATE 12 · VALIDATE 9 · GRID_BIND 8 · LIST_REBIND 8 · GRID_STYLE 5 · GRID_CLEAR 1 · ⚠ 의미 확인 필요 19


## SSP0002_ShipmentChangeRequest_Backup.BtnAdd_Click

진입점: btnAdd.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f02bd699 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2106 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d949d15 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2109 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00196") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0571e194 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2109 | if (MessageHelper.GMessageBox("MSG00196") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f5fa14bd | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2111 |  | FLAG | bErpIFCheck | true | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.BtnApprovalUser_Click

진입점: btnApprovalUser.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e5fe4d5 | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1917 |  | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ef954594 | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1919 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-7eb3c14f | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1920 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-0ad6b41b | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1921 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-79118647 | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1922 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-f3273367 | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1923 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-8a7f12bf | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1925 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-ed3c5d10 | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1927 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f51c4567 | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1933 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sApprovalID | item.UserID | 화면 필드/플래그 변경 |  |  |  |
| AC-227517dc | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1936 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtApproval.Text | item.UserName | 컨트롤 값 설정 |  |  |  |
| AC-fa1c80f4 | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1938 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtApproval.Text | item.UserName_E | 컨트롤 값 설정 |  |  |  |
| AC-9b16cdee | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1940 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | VALUE_SET | txtAppDeptName.Text | item.Dept_Name | 컨트롤 값 설정 |  |  |  |
| AC-38d25f1e | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1941 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sApprovalDeptID | item.Dept_ID | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.BtnCancel_Click

진입점: btnCancel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2427286 | btnCancel.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2275 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6d663108 | btnCancel.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2278 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00195") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-585de22e | btnCancel.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2278 | if (MessageHelper.GMessageBox("MSG00195") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ea2cd67 | btnCancel.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2280 |  | FLAG | sShipStatus | Shipment_Status.S_Status_C | 화면 필드/플래그 변경 |  |  |  |
| AC-bb61b0bb | btnCancel.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2281 |  | FLAG | bDeleClickYn | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8253ee87 | btnCancel.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2282 |  | FLAG | bErpIFCheck | true | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.BtnChangeRe_Click

진입점: btnChangeRe.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff7fac98 | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2017 | if (string.IsNullOrWhiteSpace(txtRequestNo.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-015504a5 | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2024 | if (sStatus == Shipment_Status.S_Status_R) | MESSAGE | MessageHelper.GMessageBox | ("MSG00174") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2e06c60f | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2025 | if (sStatus == Shipment_Status.S_Status_R) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8efe60b8 | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2029 | if (!checkRequired()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c21862d3 | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2039 | for (iRow < siSub.ActiveSheet.RowCount) ▸ if (dBaseDate > dShipDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00201", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c30b5a90 | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2040 | for (iRow < siSub.ActiveSheet.RowCount) ▸ if (dBaseDate > dShipDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92908350 | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2044 |  | FLAG | sChangeStatus | Change_Req_Status.C_Status_Q | 화면 필드/플래그 변경 |  |  |  |
| AC-5bbddd15 | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2045 |  | FLAG | sShipStatus | Shipment_Status.S_Status_R | 화면 필드/플래그 변경 |  |  |  |
| AC-c9352d54 | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2046 |  | FLAG | bErpIFCheck | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.BtnDel_Click

진입점: btnDel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7835a7a0 | btnDel.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2262 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e6104848 | btnDel.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2265 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-072a05dd | btnDel.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2265 | if (MessageHelper.GMessageBox("MSG00016") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-371457d3 | btnDel.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2267 |  | FLAG | sShipStatus | Shipment_Status.S_Status_C | 화면 필드/플래그 변경 |  |  |  |
| AC-0fd0a57a | btnDel.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2268 |  | FLAG | bDeleClickYn | true | 화면 필드/플래그 변경 |  |  |  |
| AC-45237a7b | btnDel.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2269 |  | FLAG | bErpIFCheck | true | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4bad817 | this.btnItemId.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2297 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-4e798aca | this.btnItemId.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2299 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1c41ba39 | this.btnItemId.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2300 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fa43d693 | this.btnItemId.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2301 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0a149d94 | this.btnItemId.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2307 | if (popItem.ItemID != "") | VALUE_SET | txtRequest.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.BtnSave_Click

진입점: btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-401d0a5b | btnSave.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1994 | if (string.IsNullOrWhiteSpace(txtRequestNo.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bafe4a3d | btnSave.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1997 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4a066857 | btnSave.Click | SSP0002_ShipmentChangeRequest_Backup.cs:1997 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1694e09a | btnSave.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2004 | if (sStatus == Shipment_Status.S_Status_R) | MESSAGE | MessageHelper.GMessageBox | ("MSG00174") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d33de555 | btnSave.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2005 | if (sStatus == Shipment_Status.S_Status_R) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fade67b9 | btnSave.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2008 |  | FLAG | sChangeStatus | Change_Req_Status.C_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-fcce0304 | btnSave.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2009 |  | FLAG | sShipStatus | Shipment_Status.S_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-747bd4e8 | btnSave.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2011 |  | FLAG | bErpIFCheck | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.checkRequired

진입점: btnChangeRe.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9de95736 | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2062 | if (string.IsNullOrWhiteSpace(txtApproval.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8fa68934 | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2063 | if (string.IsNullOrWhiteSpace(txtApproval.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-bdeaec1b | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2073 | if (string.IsNullOrWhiteSpace(txtTitle.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e31be9e | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2074 | if (string.IsNullOrWhiteSpace(txtTitle.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d4d0273d | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2084 | if (cboChangeReason.SelectedIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c2d3725d | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2085 | if (cboChangeReason.SelectedIndex == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d9851102 | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2095 | if (string.IsNullOrWhiteSpace(txtReasonDetail.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-570f14ad | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2096 | if (string.IsNullOrWhiteSpace(txtReasonDetail.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-27142827 | btnChangeRe.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2101 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.ClearRequestInfo

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub)] / btnSave.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnChangeRe.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnAdd.Click [if (ds.Tables[0].Rows.Count > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ if (sShipSta…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3d486c3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 6 | SSP0002_ShipmentChangeRequest_Backup.cs:568 |  | VALUE_CLEAR | txtRequestNo.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-d6e50a16 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 6 | SSP0002_ShipmentChangeRequest_Backup.cs:569 |  | VALUE_CLEAR | txtTitle.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9c6451bc | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 6 | SSP0002_ShipmentChangeRequest_Backup.cs:570 |  | VALUE_CLEAR | txtApproval.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-552c73ef | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 6 | SSP0002_ShipmentChangeRequest_Backup.cs:571 |  | VALUE_CLEAR | txtAppDeptName.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-87240b0f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 6 | SSP0002_ShipmentChangeRequest_Backup.cs:572 |  | VALUE_SET | cboChangeReason.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-7cb08fe8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 6 | SSP0002_ShipmentChangeRequest_Backup.cs:573 |  | VALUE_CLEAR | txtReasonDetail.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-37cbbd57 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 6 | SSP0002_ShipmentChangeRequest_Backup.cs:574 |  | FLAG | sApprovalDeptID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-c5c5eb2a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 6 | SSP0002_ShipmentChangeRequest_Backup.cs:575 |  | FLAG | sApprovalID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-5868243f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 6 | SSP0002_ShipmentChangeRequest_Backup.cs:576 |  | FLAG | sMainConfirmID | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cdc48b1 | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:282 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-415bf63a | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:283 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6f1fafef | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:286 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1b9c3717 | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:287 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-fce4290b | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:289 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc605702 | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:292 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a0a1491 | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:296 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.DeleteDataDrafting

진입점: btnDel.Click / btnCancel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0288c394 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1378 | if (sFlag == "D" && iBaseChk == 0 && siSub.ActiveSheet.RowCount > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00198") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8241bb3d | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1379 | if (sFlag == "D" && iBaseChk == 0 && siSub.ActiveSheet.RowCount > 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b60ea578 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1383 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-1706b755 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1388 | if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e3f08936 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1392 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-f29ea889 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1393 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-1a3a4cbd | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1394 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-a6dae301 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1395 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-5c50d4c5 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1396 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-6b9899ba | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1398 | if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4410b214 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1398 | if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-9fbb7b54 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1406 | if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveConfirmID | p_confirm_id | 화면 필드/플래그 변경 |  |  |  |
| AC-6d884a60 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1407 | if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveFlag | "D_E" | 화면 필드/플래그 변경 |  |  |  |
| AC-034dface | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1415 | if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b335c607 | Dispose | SSP0002_ShipmentChangeRequest_Backup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfa8b87b | EditButton | SSP0002_ShipmentChangeRequest_Backup.cs:480 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e30822ad | EditButton | SSP0002_ShipmentChangeRequest_Backup.cs:481 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.FindAddData

진입점: btnAdd.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33f3949d | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2123 | if (dBaseDate > dShipDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ee0517cc | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2124 | if (dBaseDate > dShipDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b123ecdf | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2198 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo) && sDivision == sChkDivision && sFromSite == sChkFromSite &&… | FLAG | iSelRow | iRow | 화면 필드/플래그 변경 |  |  |  |
| AC-472f5ece | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2205 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo) && sDivision == sChkDivision && sFromSite == sChkFromSite &&… | MESSAGE | MessageHelper.GMessageBox | ("MSG00189") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-557265bc | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2206 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo) && sDivision == sChkDivision && sFromSite == sChkFromSite &&… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8ed29a3f | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2216 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3c13838b | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2220 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST_ADD") ⇒ SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST_ADD | 엔드포인트 요청 생성 |  |  |  |
| AC-7e995af1 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2221 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-407dfa88 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2222 | lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-b85cfe0b | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2223 | lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-351ffb43 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2224 | lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-08edf558 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2226 | lambda | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-3f9a5f15 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2227 | lambda | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-e4d9fbd6 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2228 | lambda | DATA_OP | request.Parameters["p_transport_mode"] | p_trasport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-672bffe2 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2229 | lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-67751005 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2230 | lambda | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-880efd06 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2232 | lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8af204d5 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2233 | lambda | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-72de3077 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2234 | lambda | DATA_OP | request.Parameters["p_to_date"] | p_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-7e54e411 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2235 | lambda | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-6b2a6f8d | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2236 | lambda | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-488f91f7 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2237 | lambda | DATA_OP | request.Parameters["p_sameDate_add"] | p_sameDate_add | 행/컬럼 값 대입 |  |  |  |
| AC-8dbd180d | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2239 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9b51b580 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2241 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c4d767bd | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2252 | if (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][DefColumns.NEW_YN].ToString() == "N") ▸ if (ds.Tables[0].Rows[0][DefColumns.SHIP… | MESSAGE | MessageHelper.GMessageBox | ("MSG00178") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e89aaff8 | btnAdd.Click | SSP0002_ShipmentChangeRequest_Backup.cs:2253 | if (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][DefColumns.NEW_YN].ToString() == "N") ▸ if (ds.Tables[0].Rows[0][DefColumns.SHIP… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f0b543f | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:495 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c4b57cdb | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:500 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-893ea6cb | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:500 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f450d4e | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:504 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5cffdc04 | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:519 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-706a3df4 | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:520 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ce594688 | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:524 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST") ⇒ SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-4808bd69 | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:525 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-05b6dbb3 | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:526 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-112dd0ae | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:527 | try ▸ lambda | DATA_OP | request.Parameters["p_erp_so_no"] | p_erp_so_no | 행/컬럼 값 대입 |  |  |  |
| AC-76fe69b5 | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:528 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f1afbe6c | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:529 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f40b493f | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:530 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-eaec3058 | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:531 | try ▸ lambda | DATA_OP | request.Parameters["p_status"] | p_status | 행/컬럼 값 대입 |  |  |  |
| AC-563b2719 | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:532 | try ▸ lambda | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-0a8774bb | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:534 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d7667281 | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:536 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f3b86a8b | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:543 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-166d4753 | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:544 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6fb16953 | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:547 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0b25edf2 | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:552 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0855d009 | FindButton | SSP0002_ShipmentChangeRequest_Backup.cs:562 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.FindData_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_D)] / btnSave.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / btnChangeRe.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / btnAdd.Click [if (ds.Tables[0].Rows.Count > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / btnDel.Click [if (iCount > 0) ▸ if (t.S…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fb48bef | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:650 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-e30696ad | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:651 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0b9a3528 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:652 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-bfdfcd4e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:653 |  | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-e733d901 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:654 |  | DATA_OP | request.Parameters["p_erp_so_no"] | p_erp_so_no | 행/컬럼 값 대입 |  |  |  |
| AC-623fa7f2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:655 |  | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a5d6f82f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:656 |  | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-a2635069 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:657 |  | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-a272fc37 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:658 |  | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-e09c6201 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:659 |  | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-76d64683 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:660 |  | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-844ad39d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:662 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-1b34eec0 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:663 |  | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-82aed024 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:664 |  | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f546c358 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:665 |  | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-ef46fc2c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:666 |  | DATA_OP | request.Parameters["p_request_user_id"] | p_request_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-0765bfa4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:667 |  | DATA_OP | request.Parameters["p_request_status"] | sRequest_Status | 행/컬럼 값 대입 |  |  |  |
| AC-af25f0ce | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:668 |  | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-248aeb08 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:670 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d152fcef | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:684 | if (ds.Tables[0].Rows.Count > 0) ▸ if (sRequest_Status == Shipment_Status.S_Status_C) ▸ if (sShipStatus != Shipment_Status.S_Status_C) | MESSAGE | MessageHelper.GMessageBox | ("MSG00178") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b77e789 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:685 | if (ds.Tables[0].Rows.Count > 0) ▸ if (sRequest_Status == Shipment_Status.S_Status_C) ▸ if (sShipStatus != Shipment_Status.S_Status_C) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c8d71df | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:693 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-38a1bf1b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:694 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7145a21b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:697 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ce874958 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:701 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8605aa4d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:708 | if (!bReadOnly) ▸ if (sRequest_Status == "C") | FLAG | sChangeStatus | Change_Req_Status.C_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-51620beb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:709 | if (!bReadOnly) ▸ if (sRequest_Status == "C") | FLAG | sShipStatus | Shipment_Status.S_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-7b8e18bb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:721 | if (!bReadOnly) ▸ else of (sRequest_Status == "C") ▸ if (sRequest_Status == "D") ▸ if (!string.IsNullOrWhiteSpace(sSaveConfirmID)) ▸ if (!Ge… | FLAG | bIFFalg | false | 화면 필드/플래그 변경 |  |  |  |
| AC-eee51cc6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:723 | if (!bReadOnly) ▸ else of (sRequest_Status == "C") ▸ if (sRequest_Status == "D") ▸ if (!string.IsNullOrWhiteSpace(sSaveConfirmID)) ▸ if (!Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e7a15e5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:731 | if (!bReadOnly) ▸ else of (sRequest_Status == "C") ▸ if (sRequest_Status == "D") ▸ if (!string.IsNullOrWhiteSpace(sSaveConfirmID)) ▸ else of… | FLAG | bIFFalg | true | 화면 필드/플래그 변경 |  |  |  |
| AC-802ccd4e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:739 | if (!bReadOnly) ▸ else of (sRequest_Status == "C") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count > 0) ▸ if (sShipStatus != Shi… | FLAG | sChangeStatus | Change_Req_Status.C_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-af6d809e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:740 | if (!bReadOnly) ▸ else of (sRequest_Status == "C") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count > 0) ▸ if (sShipStatus != Shi… | FLAG | sShipStatus | Shipment_Status.S_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-aa9eafd3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:761 | else of (!bReadOnly) ▸ for (iRow < siMain.ActiveSheet.RowCount) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-9d74ebeb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:770 | else of (!bReadOnly) ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count > 0) ▸ if (sShipStatus != Shipment_Status.S_Status_R) | FLAG | sChangeStatus | Change_Req_Status.C_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-b705e149 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:771 | else of (!bReadOnly) ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count > 0) ▸ if (sShipStatus != Shipment_Status.S_Status_R) | FLAG | sShipStatus | Shipment_Status.S_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-60dcf1b4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:785 |  | FLAG | bDeleClickYn | false | 화면 필드/플래그 변경 |  |  |  |
| AC-253b41d3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:786 |  | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.FindData_Sub_Draft

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly) ▸ else of (sRequest_Status == "C") ▸ if (sRequest_Status == "D") ▸ if (!string.IsNullOrWhiteSpace(sSaveConfirmID)) ▸ if (!GetErpIFCheck())] / btnSave.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ else of (sRequest_Status == "C") ▸ if (sRequest_Status == "D") ▸ if (!string.IsNullOrWhiteSpace(sSa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ab8ea1e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:833 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-0680e789 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:834 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c47f6164 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:835 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-973a0767 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:836 |  | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-4b81fcd5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:837 |  | DATA_OP | request.Parameters["p_erp_so_no"] | p_erp_so_no | 행/컬럼 값 대입 |  |  |  |
| AC-ca23a2bf | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:838 |  | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-62662983 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:839 |  | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-068ed066 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:840 |  | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-377db994 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:841 |  | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-49dfb0e2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:842 |  | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-3f32ebd3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:843 |  | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-c4c17bee | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:844 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa30a517 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:845 |  | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-fed14e48 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:846 |  | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3198c5a1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:847 |  | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-8fc2318d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:848 |  | DATA_OP | request.Parameters["p_request_user_id"] | p_request_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-5339ccc1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:849 |  | DATA_OP | request.Parameters["p_request_status"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-9f112b2d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:850 |  | DATA_OP | request.Parameters["p_language"] | UserInfoContext.Current[UserInfoProperites.Language] | 행/컬럼 값 대입 |  |  |  |
| AC-1f7fe66c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:852 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-23891ed8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:860 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1ca09223 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:861 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-10747b8a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:864 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ad198d71 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:868 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5f4807aa | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:874 | if (ds.Tables[1].Rows.Count > 0) ▸ if (sShipStatus != Shipment_Status.S_Status_R) | FLAG | sChangeStatus | Change_Req_Status.C_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-b511fb79 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:875 | if (ds.Tables[1].Rows.Count > 0) ▸ if (sShipStatus != Shipment_Status.S_Status_R) | FLAG | sShipStatus | Shipment_Status.S_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-4af6af23 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:897 |  | FLAG | sSaveConfirmID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-78a7eb82 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:898 |  | FLAG | sSaveFlag | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-835ed5d6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:904 |  | FLAG | bDeleClickYn | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e83200e4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:905 |  | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-729bd092 | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:197 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1e895bb | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:1898 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-fb6bdf39 | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:1899 |  | DATA_OP | request.Parameters["p_from_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0b5e01da | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:1900 |  | DATA_OP | request.Parameters["p_offset_day"] | "14" | 행/컬럼 값 대입 |  |  |  |
| AC-ce34ee2b | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:1901 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-b948c02d | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:1902 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-44d6807a | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:1905 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.GetErpIFCheck

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly) ▸ else of (sRequest_Status == "C") ▸ if (sRequest_Status == "D") ▸ if (!string.IsNullOrWhiteSpace(sSaveConfirmID))] / btnSave.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ else of (sRequest_Status == "C") ▸ if (sRequest_Status == "D") ▸ if (!string.IsNullOrWhiteSpace(sSaveConfirmID))] / btnChan…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3dd0b24 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:913 | try ▸ if (!bErpIFCheck) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-284e3b97 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:918 | try ▸ if (string.IsNullOrWhiteSpace(_sRequestNo)) | FLAG | _sRequestNo | txtRequestNo.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-a54163f7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:921 | try | CALL_EXT | service.FN_ERP_UIWebService | (_sRequestNo, "","") | ⚠ 의미 확인 필요 |  |  |  |
| AC-39e61311 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:935 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F") | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-8e3bb3e5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:936 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F") | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-3167a805 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:937 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-5cf4aad7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:938 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F") | DATA_OP | request.Parameters["p_del_flag"] | sSaveFlag | 행/컬럼 값 대입 |  |  |  |
| AC-c00208c0 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:939 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F") | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-774db0f9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:940 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F") | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-c57ba31e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:942 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-387c76a9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:954 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c98b92cb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:961 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6da8d974 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:972 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f9a45ca | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:231 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-24c322bd | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:234 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl1) | 권한 검사/설정 |  |  |  |
| AC-c610ac96 | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:236 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5d1a13af | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:237 |  | CALL_EXT | clsCtrl.setListBoxEx | (dtChangeReasonCode, cboChangeReason, true, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ffa9e5d8 | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:239 |  | LIST_REBIND | clsCtrl.setListBox | (dtChangeStatusCode, cboStatus, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-66d3d98d | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:243 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-65ea9757 | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:244 |  | VALUE_SET | dtDate.InitValue | GetDayRange().Split(':')[0] | 컨트롤 값 설정 |  |  |  |
| AC-51b85921 | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:247 | if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-e76d92af | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:249 |  | FLAG | dBaseDate | Convert.ToDateTime(dtDate.Value).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-8068fb73 | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:251 |  | FLAG | sRequestID | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-1d526091 | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:255 | if (UserInfoContext.Current[UserInfoProperites.Language] == "KO") | VALUE_SET | txtRequestor.Text | UserInfoContext.Current[UserInfoProperites.UserName].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-96ec2fdd | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:259 | else of (UserInfoContext.Current[UserInfoProperites.Language] == "KO") | VALUE_SET | txtRequestor.Text | UserInfoContext.Current[UserInfoProperites.UserName_E].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-224ef1bb | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:262 |  | FLAG | sRequestName | txtRequestor.Text + "(" + UserInfoContext.Current.UserId + ")" | 화면 필드/플래그 변경 |  |  |  |
| AC-30ba9af6 | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:265 |  | VALUE_SET | txtRequestDeptName.Text | UserInfoContext.Current[UserInfoProperites.Dept_Name] | 컨트롤 값 설정 |  |  |  |
| AC-87db1162 | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:266 |  | FLAG | sRequestDeptID | UserInfoContext.Current[UserInfoProperites.Dept_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-fe803963 | this.Load | SSP0002_ShipmentChangeRequest_Backup.cs:268 |  | FLAG | sLanguage | UserInfoContext.Current[UserInfoProperites.Language] | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_D)] / btnSave.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnChangeRe.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnAdd.Click [if (ds.Tables[0].Rows.Count > 0) ▸ if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20f895a2 | this.Load 외 7 | SSP0002_ShipmentChangeRequest_Backup.cs:303 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-6c7b52b4 | this.Load 외 7 | SSP0002_ShipmentChangeRequest_Backup.cs:305 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-7d66b947 | this.Load 외 7 | SSP0002_ShipmentChangeRequest_Backup.cs:306 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6a33927b | this.Load 외 7 | SSP0002_ShipmentChangeRequest_Backup.cs:307 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-44bc999f | this.Load 외 7 | SSP0002_ShipmentChangeRequest_Backup.cs:347 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-02602689 | this.Load 외 7 | SSP0002_ShipmentChangeRequest_Backup.cs:350 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-929ff8eb | this.Load 외 7 | SSP0002_ShipmentChangeRequest_Backup.cs:351 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY),0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-eb807943 | this.Load 외 7 | SSP0002_ShipmentChangeRequest_Backup.cs:359 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | spreadInfo.ActiveSheet.ColumnHeader.Cells[0, spreadInfo.GetColumnIndex(DefColumns.CHK)].Ce… | chk | 그리드 속성/값 설정 |  |  |  |
| AC-eb86e328 | this.Load 외 7 | SSP0002_ShipmentChangeRequest_Backup.cs:360 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | spreadInfo.ActiveSheet.ColumnHeader.Cells[0, spreadInfo.GetColumnIndex(DefColumns.CHK)].Va… | false | 그리드 속성/값 설정 |  |  |  |
| AC-3bf6a130 | this.Load 외 7 | SSP0002_ShipmentChangeRequest_Backup.cs:361 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | spreadInfo.ActiveSheet.ColumnHeader.Cells[0, spreadInfo.GetColumnIndex(DefColumns.CHK)].Bo… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-7eec71d6 | this.Load 외 7 | SSP0002_ShipmentChangeRequest_Backup.cs:365 | if (spreadInfo.SheetName == SpdSheet.shtSub) | UI_PROP | col.MergePolicy | FarPoint.Win.Spread.Model.MergePolicy.None | 속성 MergePolicy 설정 |  |  |  |
| AC-3025888b | this.Load 외 7 | SSP0002_ShipmentChangeRequest_Backup.cs:366 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-74d3eaa1 | this.Load 외 7 | SSP0002_ShipmentChangeRequest_Backup.cs:367 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-823a9c57 | InsertButton | SSP0002_ShipmentChangeRequest_Backup.cs:1457 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-041d9c98 | InsertButton | SSP0002_ShipmentChangeRequest_Backup.cs:1460 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a9c19e96 | InsertButton | SSP0002_ShipmentChangeRequest_Backup.cs:1485 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.SaveAddDataDrafting

진입점: btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e3bba88 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1277 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-9066ed2f | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1282 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8ac55470 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1286 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-15e35f72 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1287 | lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-7ca3901e | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1288 | lambda | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-ff7f0b17 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1289 | lambda | DATA_OP | request.Parameters["p_request_id"] | p_request_id | 행/컬럼 값 대입 |  |  |  |
| AC-aaf19082 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1290 | lambda | DATA_OP | request.Parameters["p_request_dept_id"] | p_request_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-b7efabfe | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1291 | lambda | DATA_OP | request.Parameters["p_approval_id"] | p_approval_id | 행/컬럼 값 대입 |  |  |  |
| AC-400a2a70 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1292 | lambda | DATA_OP | request.Parameters["p_approval_dept_id"] | p_approval_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-c03f7a45 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1293 | lambda | DATA_OP | request.Parameters["p_change_reason"] | p_change_reason | 행/컬럼 값 대입 |  |  |  |
| AC-6eaea6f8 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1294 | lambda | DATA_OP | request.Parameters["p_reason_detail"] | p_reason_detail | 행/컬럼 값 대입 |  |  |  |
| AC-2079ce63 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1295 | lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-e564f866 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1296 | lambda | DATA_OP | request.Parameters["p_main_confirm_id"] | p_main_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-ad14db3d | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1297 | lambda | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-bdaddb26 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1298 | lambda | DATA_OP | request.Parameters["p_new_confirm_id"] | p_new_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-341c49e3 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1300 | lambda | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-9d73f6af | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1301 | lambda | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-48d1766b | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1302 | lambda | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-0d06d93c | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1303 | lambda | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-b6391dca | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1304 | lambda | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-623305d3 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1305 | lambda | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-a5bfe37c | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1306 | lambda | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-49864838 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1307 | lambda | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-2c34f5aa | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1308 | lambda | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-a947c30e | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1309 | lambda | DATA_OP | request.Parameters["p_new_lt_day"] | p_new_lt_day | 행/컬럼 값 대입 |  |  |  |
| AC-9fa7cfb0 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1311 | lambda | DATA_OP | request.Parameters["p_change_status"] | sChangeStatus | 행/컬럼 값 대입 |  |  |  |
| AC-950dbc08 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1312 | lambda | DATA_OP | request.Parameters["p_ship_status"] | sShipStatus | 행/컬럼 값 대입 |  |  |  |
| AC-28f66879 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1313 | lambda | DATA_OP | request.Parameters["p_change_req_no"] | p_change_req_no | 행/컬럼 값 대입 |  |  |  |
| AC-96b1cf20 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1314 | lambda | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-8f7f38fe | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1315 | lambda | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-9c5d0a57 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1316 | lambda | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-ad1e4634 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1317 | lambda | DATA_OP | request.Parameters["p_new_ship_date"] | p_new_ship_date | 행/컬럼 값 대입 |  |  |  |
| AC-f038cbb6 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1318 | lambda | DATA_OP | request.Parameters["p_new_qty"] | p_new_qty | 행/컬럼 값 대입 |  |  |  |
| AC-33dd7dbc | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1319 | lambda | DATA_OP | request.Parameters["p_new_yn"] | p_new_yn | 행/컬럼 값 대입 |  |  |  |
| AC-917ca17a | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1320 | lambda | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-4844cf6a | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1321 | lambda | DATA_OP | request.Parameters["p_if_send_flag"] | p_if_send_flag | 행/컬럼 값 대입 |  |  |  |
| AC-3280c2bc | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1323 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-43b363c2 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1323 | lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-be06493a | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1331 | if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveConfirmID | p_confirm_id | 화면 필드/플래그 변경 |  |  |  |
| AC-efd3bd1c | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1332 | if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveFlag | "E" | 화면 필드/플래그 변경 |  |  |  |
| AC-f90f0fda | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest_Backup.cs:1340 | if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.SaveDataDrafting

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly) ▸ if (sRequest_Status == "C")] / btnSave.Click / btnChangeRe.Click / btnAdd.Click [if (ds.Tables[0].Rows.Count > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ if (sRequest_Status == "C")] / btnDel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e292a662 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1071 | if (sShipStatus == Shipment_Status.S_Status_R) | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-0cffb8ef | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1071 | if (sShipStatus == Shipment_Status.S_Status_R) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1facb349 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1136 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sQty == "") | CALL_EXT | Convert.ToInt64 | (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a31475c6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1150 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-8f525263 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1155 | if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-668d99f7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1159 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c11c0f28 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1160 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-bb6cc074 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1161 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-24f9c8eb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1162 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_request_id"] | p_request_id | 행/컬럼 값 대입 |  |  |  |
| AC-703cc691 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1163 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_request_dept_id"] | p_request_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-83f64432 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1164 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_approval_id"] | p_approval_id | 행/컬럼 값 대입 |  |  |  |
| AC-0c96d988 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1165 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_approval_dept_id"] | p_approval_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-477398e6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1166 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_change_reason"] | p_change_reason | 행/컬럼 값 대입 |  |  |  |
| AC-1d413b98 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1167 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_reason_detail"] | p_reason_detail | 행/컬럼 값 대입 |  |  |  |
| AC-a589fec9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1168 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-d71ec918 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1169 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_main_confirm_id"] | p_main_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-0a3341a0 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1170 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-d147b5e8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1171 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_confirm_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a9bd4d95 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1173 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-cb8a232a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1174 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-571d8e4b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1175 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-99998a8f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1176 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-9d1f6883 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1177 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-9f0bbefa | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1178 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-ecbb458a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1179 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-4da41e66 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1180 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-747e0061 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1181 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-ac5534a1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1182 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_lt_day"] | p_new_lt_day | 행/컬럼 값 대입 |  |  |  |
| AC-ba369cfd | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1184 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_change_status"] | sChangeStatus | 행/컬럼 값 대입 |  |  |  |
| AC-93c65276 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1185 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_ship_status"] | sShipStatus | 행/컬럼 값 대입 |  |  |  |
| AC-91c002bb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1186 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_change_req_no"] | p_change_req_no | 행/컬럼 값 대입 |  |  |  |
| AC-88b0471c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1187 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-1f34fd4f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1188 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-6bbab7b4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1189 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-6c2c7e86 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1190 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_ship_date"] | p_new_ship_date | 행/컬럼 값 대입 |  |  |  |
| AC-3b452485 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1191 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_qty"] | p_new_qty | 행/컬럼 값 대입 |  |  |  |
| AC-21f80568 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1192 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_yn"] | p_new_yn | 행/컬럼 값 대입 |  |  |  |
| AC-2538bb9c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1193 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-edb48c49 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1194 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_if_send_flag"] | p_if_send_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e2484525 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1196 | if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-66096e20 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1196 | if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-e9a6cba9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1204 | if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | VALUE_SET | txtRequestNo.Text | t.DataSet.Tables[0].Rows[0][1].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-7344a95a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1209 | if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R) | MESSAGE | MessageHelper.GMessageBox | ("MSG00173") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f8bcb05 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1215 | if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveConfirmID | p_confirm_id | 화면 필드/플래그 변경 |  |  |  |
| AC-3669fda8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1216 | if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveFlag | "E" | 화면 필드/플래그 변경 |  |  |  |
| AC-91975871 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1224 | if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.SetButtonVisual

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (!string.IsNullOrWhiteSpace(sRequestUser) && sRequestUser != UserInfo.UserId)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dce76c10 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0002_ShipmentChangeRequest_Backup.cs:583 | if (bFlag) | UI_PROP | lcChgReq.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4e32ac24 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0002_ShipmentChangeRequest_Backup.cs:584 | if (bFlag) | UI_PROP | lcSave.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-46b103e6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0002_ShipmentChangeRequest_Backup.cs:585 | if (bFlag) | UI_PROP | lcDel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e3bbb17c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0002_ShipmentChangeRequest_Backup.cs:586 | if (bFlag) | UI_PROP | lcCancel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-fa04990f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0002_ShipmentChangeRequest_Backup.cs:587 | if (bFlag) | UI_PROP | lcAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-685219e8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0002_ShipmentChangeRequest_Backup.cs:588 | if (bFlag) | UI_PROP | lcDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-de716146 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0002_ShipmentChangeRequest_Backup.cs:592 | else of (bFlag) | UI_PROP | lcChgReq.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-53f66b51 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0002_ShipmentChangeRequest_Backup.cs:593 | else of (bFlag) | UI_PROP | lcSave.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-55bb79e2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0002_ShipmentChangeRequest_Backup.cs:594 | else of (bFlag) | UI_PROP | lcDel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7042c42d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0002_ShipmentChangeRequest_Backup.cs:595 | else of (bFlag) | UI_PROP | lcCancel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f92ac593 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0002_ShipmentChangeRequest_Backup.cs:596 | else of (bFlag) | UI_PROP | lcAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a745bbea | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0002_ShipmentChangeRequest_Backup.cs:597 | else of (bFlag) | UI_PROP | lcDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.SetChangedControl

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14400b00 | this.Load 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:276 |  | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-62e8035f | this.Load 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:276 |  | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e6542541 | this.Load 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:277 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, this.clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afd1db0a | (진입점 미연결) | SSP0002_ShipmentChangeRequest_Backup.cs:1507 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e5574ff4 | (진입점 미연결) | SSP0002_ShipmentChangeRequest_Backup.cs:1510 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ce0d660 | (진입점 미연결) | SSP0002_ShipmentChangeRequest_Backup.cs:1514 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-f8bf2ec7 | (진입점 미연결) | SSP0002_ShipmentChangeRequest_Backup.cs:1515 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.SetChangeRequestInfo

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly) ▸ else of (sRequest_Status == "C") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count > 0)] / btnSave.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ else of (sRequest_Status == "C") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count > 0)] / btnChangeRe.Click [if (iCount > 0) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b10453b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:985 |  | FLAG | sApprovalDeptID | dt.Rows[0]["APPROVAL_DEPT"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-26632257 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:990 |  | VALUE_SET | txtRequestNo.Text | sRequestNo | 컨트롤 값 설정 |  |  |  |
| AC-5668af1e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:991 |  | VALUE_SET | txtRequestor.Text | sRequestorName | 컨트롤 값 설정 |  |  |  |
| AC-3cc00778 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:992 |  | VALUE_SET | txtRequestDeptName.Text | sRequestDeptName | 컨트롤 값 설정 |  |  |  |
| AC-f8dcc5ff | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:993 |  | FLAG | _sRequestNo | sRequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-f46e7cd2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:997 | if (!bReadOnly) | FLAG | sRequestID | sRequestorID | 화면 필드/플래그 변경 |  |  |  |
| AC-df50d306 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:998 | if (!bReadOnly) | FLAG | sRequestName | sRequestorName + "(" + sRequestID + ")" | 화면 필드/플래그 변경 |  |  |  |
| AC-50e46255 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1000 | if (!bReadOnly) | STATE | txtTitle.ReadOnly | false | 컨트롤 상태 ReadOnly |  |  |  |
| AC-7eea537b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1001 | if (!bReadOnly) | UI_PROP | lcAppDept.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7fba8bb0 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1002 | if (!bReadOnly) | STATE | cboChangeReason.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8305a2d3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1003 | if (!bReadOnly) | STATE | txtReasonDetail.ReadOnly | false | 컨트롤 상태 ReadOnly |  |  |  |
| AC-9b75f8ad | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1008 | else of (!bReadOnly) | STATE | txtTitle.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-6e7b89fa | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1009 | else of (!bReadOnly) | UI_PROP | lcAppDept.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6d07d004 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1010 | else of (!bReadOnly) | STATE | cboChangeReason.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6b3ac894 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1011 | else of (!bReadOnly) | STATE | txtReasonDetail.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-7ccb289d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1014 |  | VALUE_SET | txtTitle.Text | sTitle | 컨트롤 값 설정 |  |  |  |
| AC-57d1d0d4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1016 |  | VALUE_SET | txtApproval.Text | sApprovalUserName | 컨트롤 값 설정 |  |  |  |
| AC-5e3b01a1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1017 |  | FLAG | sApprovalID | sApproval | 화면 필드/플래그 변경 |  |  |  |
| AC-5ada0ebd | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1019 |  | VALUE_SET | txtAppDeptName.Text | sApprovalDeptName | 컨트롤 값 설정 |  |  |  |
| AC-963041ef | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1020 |  | VALUE_SET | cboChangeReason.SelectedValue | sChaneReason | 컨트롤 값 설정 |  |  |  |
| AC-effa6a50 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1021 |  | VALUE_SET | txtReasonDetail.Text | sReasonDetail | 컨트롤 값 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.SetChangeRequestSOGrid

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly)] / btnSave.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly)] / btnChangeRe.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly)] / btnAdd.Click [if (ds.Tables[0].Rows.Count > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToStrin…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e57aba20 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1026 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4f0afbc3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1027 |  | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-03abcebd | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1029 |  | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(CAppSetting.StringAction), siSub.GetColumnIndex(DefColumns.NEW_ETA),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0fced2f8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1033 | for (i < siSub.ActiveSheet.RowCount) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(CAppSetting.StringAction)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f3c06cf6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1037 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.SetText | (i, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-826a1875 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1038 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-42c90b1d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1039 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-cfbe19de | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1040 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Lock… | true | 그리드 속성/값 설정 |  |  |  |
| AC-cc6db9ce | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1041 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Back… | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-a2a0e272 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1046 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.SetText | (i, siMain.GetColumnIndex(CAppSetting.StringAction), CAppSetting.FlagM) | 그리드 값 설정 |  |  |  |
| AC-0bbe73ac | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1050 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ if (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-1c6147ab | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1051 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ if (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].BackColor | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-a9292690 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1052 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ if (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.CHK)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-49bdd164 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1056 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ else of (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.CHK)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-89f7facc | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1057 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ else of (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-86da29ef | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1058 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ else of (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-7a37c4fc | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1060 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-623a8fd8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1061 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)].BackColor | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-54d0a46c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1062 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Lock… | false | 그리드 속성/값 설정 |  |  |  |
| AC-77455a42 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1063 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Back… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.SetDeleteMainStatus

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly) ▸ else of (sRequest_Status == "C") ▸ if (sRequest_Status == "D") ▸ if (!string.IsNullOrWhiteSpace(sSaveConfirmID)) ▸ else of (!GetErpIFCheck()) ▸ if (bDeleClickYn)] / btnSave.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ else of (sRequest_Status == "C") ▸ if (sRequest_Status == "D") ▸ if (!stri…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69046797 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1435 | for (i < strConfirmID.Length) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sConfirmID == sChkConfirmID) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS), Shipment_Status.S_Status_C) | 그리드 값 설정 |  |  |  |
| AC-22a16463 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1436 | for (i < strConfirmID.Length) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sConfirmID == sChkConfirmID) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER), "") | 그리드 값 설정 |  |  |  |
| AC-5144db28 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1437 | for (i < strConfirmID.Length) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sConfirmID == sChkConfirmID) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-6ec87b73 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1438 | for (i < strConfirmID.Length) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sConfirmID == sChkConfirmID) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_TIME), "") | 그리드 값 설정 |  |  |  |
| AC-13fc774e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1439 | for (i < strConfirmID.Length) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sConfirmID == sChkConfirmID) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO), "") | 그리드 값 설정 |  |  |  |
| AC-ed3dc4c9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1440 | for (i < strConfirmID.Length) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sConfirmID == sChkConfirmID) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.SetMainStatus

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly) ▸ if (bIFFalg)] / btnSave.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ if (bIFFalg)] / btnChangeRe.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ if (bIFFalg)] / btnAdd.Click [if (ds.Tables[0].Rows.Count > 0) ▸ if (t.Success)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95419f73 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1826 | if (bDeleClickYn) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1bf078bb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1834 | for (iRow < siMain.ActiveSheet.RowCount) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-ad979458 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1837 |  | FLAG | sMainConfirmID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-edcc9b97 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1850 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS), sShipStatus) | 그리드 값 설정 |  |  |  |
| AC-7cf6ae23 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1851 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER), sRequestID) | 그리드 값 설정 |  |  |  |
| AC-a4200394 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1852 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER_NAME), sRequestName) | 그리드 값 설정 |  |  |  |
| AC-a422bd58 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1853 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_TIME), DateTime.Now) | 그리드 값 설정 |  |  |  |
| AC-a46a5e3d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1854 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO), txtRequestNo.Text) | 그리드 값 설정 |  |  |  |
| AC-040ef628 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1855 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-a451e78c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1862 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS), sShipStatus) | 그리드 값 설정 |  |  |  |
| AC-4e815260 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1863 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER), sRequestID) | 그리드 값 설정 |  |  |  |
| AC-ae81d984 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1864 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER_NAME), sRequestName) | 그리드 값 설정 |  |  |  |
| AC-aae35f6b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1865 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_TIME), DateTime.Now) | 그리드 값 설정 |  |  |  |
| AC-99bdab72 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1866 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO), txtRequestNo.Text) | 그리드 값 설정 |  |  |  |
| AC-6f7adac7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1867 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-3a8c023e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1875 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS), sShipStatus) | 그리드 값 설정 |  |  |  |
| AC-1a495be3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1876 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER), sRequestID) | 그리드 값 설정 |  |  |  |
| AC-24841ea1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1877 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER_NAME), sRequestName) | 그리드 값 설정 |  |  |  |
| AC-23f1b601 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1878 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_TIME), DateTime.Now) | 그리드 값 설정 |  |  |  |
| AC-eba08802 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1879 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO), txtRequestNo.Text) | 그리드 값 설정 |  |  |  |
| AC-cd6bc943 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1880 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.SetStatus

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly) ▸ if (sRequest_Status == "C")] / btnSave.Click / btnChangeRe.Click / btnAdd.Click [if (ds.Tables[0].Rows.Count > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ if (sRequest_Status == "C")] / btnDel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f5b5a7d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 5 | SSP0002_ShipmentChangeRequest_Backup.cs:1796 |  | FLAG | sMainConfirmID | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.shtSub_Change

진입점: dsdm.Changed / dsdmSub.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afdaf9ad | dsdm.Changed 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1962 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)) ▸ if (dBaseDate > dShipDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6fa06ca1 | dsdm.Changed 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1964 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)) ▸ if (dBaseDate > dShipDate) | GRID_SET | siSub.SetValue | (e.Row, e.Column, dSoSelDate.ToString("yyyy-MM-dd")) | 그리드 값 설정 |  |  |  |
| AC-e31a2055 | dsdm.Changed 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1968 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)) ▸ if (dBaseDate > dShipDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-17111d23 | dsdm.Changed 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1981 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)) ▸ for (i < siSub.ActiveSheet.RowCount) | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-e4e7b68a | dsdm.Changed 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1982 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)) ▸ for (i < siSub.ActiveSheet.RowCount) | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-49192208 | dsdm.Changed 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1983 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)) ▸ for (i < siSub.ActiveSheet.RowCount) | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-a71c5d06 | dsdm.Changed 외 1 | SSP0002_ShipmentChangeRequest_Backup.cs:1984 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)) ▸ for (i < siSub.ActiveSheet.RowCount) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].ForeColor | ControlColor.MarkedForeColor | 그리드 속성/값 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-368d0728 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1528 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e552a340 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1535 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (sErpStatus == "C") | MESSAGE | MessageHelper.GMessageBox | ("MSG00189") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-30b042ff | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1536 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (sErpStatus == "C") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11319168 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1559 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (sStatus == Shipment_Status.S_Status_C && dBaseDate > dShipDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-992b575d | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1560 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (sStatus == Shipment_Status.S_Status_C && dBaseDate > dShipDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-116ccc47 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1563 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | iSelRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-67f9ffb9 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1564 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | iSelCol | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-b127113d | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1566 | if (siMain.IsLock(siMain.SheetName) == true) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3046b5dd | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1570 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdSub) | 그리드 데이터/선택 비움 |  |  |  |
| AC-220538ac | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1574 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (string.IsNullOrWhiteSpace(sStatus)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00176") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-66b99102 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1575 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (string.IsNullOrWhiteSpace(sStatus)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee70cc23 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1582 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status… | MESSAGE | MessageHelper.GMessageBox | ("MSG00174") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-901a3975 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1583 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd543635 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1593 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-b3628279 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1593 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3c18312d | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1628 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.Sheet().Rows.Count > 0) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00186") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3ba2ab94 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1629 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.Sheet().Rows.Count > 0) ▸ if … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4bb95dc | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1638 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus != Shipment_Status.S_Status… | MESSAGE | MessageHelper.GMessageBox | ("MSG00188") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d5245e09 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1640 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus != Shipment_Status.S_Status… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-86e87105 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1645 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | FLAG | sChangeStatus | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-f33ba800 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1646 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | FLAG | sShipStatus | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-3e017baf | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1647 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | FLAG | sSearchType | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-11be71d1 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1648 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | FLAG | _sRequestNo | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-06d9c14e | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1649 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | FLAG | bIFFalg | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c314f4c7 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1653 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status… | FLAG | bErpIFCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e170e7c4 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1656 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (sStatus == Shipment_Status.S_S… | FLAG | bErpIFCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-888f7273 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1662 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (!string.IsNullOrWhiteSpace(sRequest… | FLAG | bReadOnly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4988a826 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1669 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpace(sRe… | FLAG | bReadOnly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1767e87b | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1678 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpace(sRe… | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-886d108f | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1679 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpace(sRe… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2cdd6ae0 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1684 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpace(sRe… | FLAG | bReadOnly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-81348fd5 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1688 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpace(sRe… | UI_PROP | lcAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b31f6f07 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1689 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpace(sRe… | UI_PROP | lcDel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0f375813 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1690 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpace(sRe… | UI_PROP | lcDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c1162c35 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1691 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpace(sRe… | FLAG | sSearchType | SearchType.Type_N | 화면 필드/플래그 변경 |  |  |  |
| AC-173f8b8f | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1695 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpace(sRe… | UI_PROP | lcAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-09e5d6d5 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1696 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpace(sRe… | UI_PROP | lcDel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-90966e26 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1697 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpace(sRe… | UI_PROP | lcDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2607a1d3 | this.spdMain.CellDoubleClick | SSP0002_ShipmentChangeRequest_Backup.cs:1698 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpace(sRe… | FLAG | sSearchType | SearchType.Type_E | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-571f8840 | spdMain.TopChange | SSP0002_ShipmentChangeRequest_Backup.cs:1911 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.SpdSub_CellClick

진입점: this.spdSub.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa871114 | this.spdSub.CellClick | SSP0002_ShipmentChangeRequest_Backup.cs:1717 | if (siSub.Sheet().Rows.Count > 0) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), dtTransMode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-32c962ae | this.spdSub.CellClick | SSP0002_ShipmentChangeRequest_Backup.cs:1721 | if (siSub.Sheet().Rows.Count > 0) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (e.Column == siSub.GetCol… | FLAG | dSoSelDate | Convert.ToDateTime(siSub.GetValue(e.Row, e.Column)) | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest_Backup.SpdSub_ComboSelChange

진입점: this.spdSub.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09ea99a5 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1732 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) | DATA_OP | dtTransMode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f0145fce | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1756 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_ROUTE_ID), sRouteID) | 그리드 값 설정 |  |  |  |
| AC-84bcd1a4 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1757 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_BOD_ID), sBodID) | 그리드 값 설정 |  |  |  |
| AC-daa5df59 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1758 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_INCOTERMS), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-4440abda | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1759 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_D_COUNTRY), sDCountry) | 그리드 값 설정 |  |  |  |
| AC-63baf752 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1760 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_D_PORT_CODE), sDPortCode) | 그리드 값 설정 |  |  |  |
| AC-d6ac9ca6 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1761 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_A_COUNTRY), sACountry) | 그리드 값 설정 |  |  |  |
| AC-caa079f1 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1762 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_A_PORT_CODE), sAPortCode) | 그리드 값 설정 |  |  |  |
| AC-e0f918c5 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1763 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_TO_COUNTRY), sToCountry) | 그리드 값 설정 |  |  |  |
| AC-374be485 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1764 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_TO_CITY), sToCity) | 그리드 값 설정 |  |  |  |
| AC-a5b8f8e6 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1765 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-56a48ad3 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1766 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), dLT) | 그리드 값 설정 |  |  |  |
| AC-5da857e2 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1771 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_ROUTE_ID), sRouteID) | 그리드 값 설정 |  |  |  |
| AC-563506c3 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1772 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_BOD_ID), sBodID) | 그리드 값 설정 |  |  |  |
| AC-ef9d5bc9 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1773 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_INCOTERMS), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-3055f17b | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1774 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_D_COUNTRY), sDCountry) | 그리드 값 설정 |  |  |  |
| AC-d96309de | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1775 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_D_PORT_CODE), sDPortCode) | 그리드 값 설정 |  |  |  |
| AC-3904806f | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1776 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_A_COUNTRY), sACountry) | 그리드 값 설정 |  |  |  |
| AC-deadf32b | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1777 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_A_PORT_CODE), sAPortCode) | 그리드 값 설정 |  |  |  |
| AC-c9265900 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1778 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_TO_COUNTRY), sToCountry) | 그리드 값 설정 |  |  |  |
| AC-3968f1ca | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1779 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_TO_CITY), sToCity) | 그리드 값 설정 |  |  |  |
| AC-4f639587 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1780 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-d3ad5900 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1781 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), dLT) | 그리드 값 설정 |  |  |  |
| AC-9b972197 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest_Backup.cs:1782 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), sNewTransMode) | 그리드 값 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest.Backup_Value

진입점: this.spdMain.CellDoubleClick / btnNew.Click [if (popup.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07e7b0cd | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:3130 |  | FLAG | sBefor_RequestID | sRequestID | 화면 필드/플래그 변경 |  |  |  |
| AC-9fc5f37b | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:3131 |  | FLAG | sBefor_RequestDeptID | sRequestDeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-158bd0a3 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:3132 |  | FLAG | sBefor_ApprovalID | sApprovalID | 화면 필드/플래그 변경 |  |  |  |
| AC-5cf5ea7f | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:3133 |  | FLAG | sBefor_ApprovalDeptID | sApprovalDeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-0ffc0025 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:3134 |  | FLAG | sBefor_MainConfirmID | sMainConfirmID | 화면 필드/플래그 변경 |  |  |  |
| AC-ba16ed9f | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:3135 |  | FLAG | sBefor_ChangeStatus | sChangeStatus | 화면 필드/플래그 변경 |  |  |  |
| AC-2efa32c1 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:3136 |  | FLAG | sBefor_ShipStatus | sShipStatus | 화면 필드/플래그 변경 |  |  |  |
| AC-50732615 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:3137 |  | FLAG | sBefor_RequestName | sRequestName | 화면 필드/플래그 변경 |  |  |  |
| AC-4acaa57d | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:3138 |  | FLAG | sBefor_SaveConfirmID | sSaveConfirmID | 화면 필드/플래그 변경 |  |  |  |
| AC-b41a7947 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:3139 |  | FLAG | _Befor_sRequestNo | _sRequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-56d6ac8c | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:3140 |  | FLAG | _Befor_sConfrimID | _sConfrimID | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest.BtnAdd_Click

진입점: btnAdd.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7286d0b | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2820 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f02573f8 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2823 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00196") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2e769911 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2823 | if (MessageHelper.GMessageBox("MSG00196") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53d5443a | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2826 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_C \|\| cboChangeType.SelectedValue.ToString() == ChangeTyp…) | FLAG | bErpIFCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-22fc2024 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2828 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_C \|\| cboChangeType.SelectedValue.ToString() == ChangeTyp…) | FLAG | bErpIFCheck | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest.BtnApprovalUser_Click

진입점: btnApprovalUser.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e34e7b00 | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest.cs:2555 |  | POPUP | new SSP0002_UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e3dc97fa | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest.cs:2557 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-1810cf80 | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest.cs:2558 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-8eab35f4 | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest.cs:2559 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2a7536c9 | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest.cs:2560 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-778ca357 | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest.cs:2561 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-d91894fd | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest.cs:2563 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-c5285e50 | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest.cs:2565 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ab20b3cc | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest.cs:2571 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sApprovalID | item.UserID | 화면 필드/플래그 변경 |  |  |  |
| AC-e6f5d10b | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest.cs:2574 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtApproval.Text | item.UserName | 컨트롤 값 설정 |  |  |  |
| AC-9cd5b81d | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest.cs:2576 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtApproval.Text | item.UserName_E | 컨트롤 값 설정 |  |  |  |
| AC-09cb169b | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest.cs:2578 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | VALUE_SET | txtAppDeptName.Text | item.Dept_Name | 컨트롤 값 설정 |  |  |  |
| AC-fa96bfba | btnApprovalUser.Click | SSP0002_ShipmentChangeRequest.cs:2579 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sApprovalDeptID | item.Dept_ID | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest.BtnCancel_Click

진입점: btnCancel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ff18db3 | btnCancel.Click | SSP0002_ShipmentChangeRequest.cs:3055 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d31b38b | btnCancel.Click | SSP0002_ShipmentChangeRequest.cs:3058 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00195") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d29c47ea | btnCancel.Click | SSP0002_ShipmentChangeRequest.cs:3058 | if (MessageHelper.GMessageBox("MSG00195") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5ee00e2 | btnCancel.Click | SSP0002_ShipmentChangeRequest.cs:3061 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_C \|\| cboChangeType.SelectedValue.ToString() == ChangeTyp…) | FLAG | sShipStatus | Shipment_Status.S_Status_C | 화면 필드/플래그 변경 |  |  |  |
| AC-7934b126 | btnCancel.Click | SSP0002_ShipmentChangeRequest.cs:3063 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_C \|\| cboChangeType.SelectedValue.ToString() == ChangeTyp…) | FLAG | sShipStatus | Shipment_Status.S_Status_P | 화면 필드/플래그 변경 |  |  |  |
| AC-7665a4de | btnCancel.Click | SSP0002_ShipmentChangeRequest.cs:3065 |  | FLAG | bDeleClickYn | true | 화면 필드/플래그 변경 |  |  |  |
| AC-fd3995a7 | btnCancel.Click | SSP0002_ShipmentChangeRequest.cs:3068 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_C \|\| cboChangeType.SelectedValue.ToString() == ChangeTyp…) | FLAG | bErpIFCheck | true | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest.BtnChangeRe_Click

진입점: btnChangeRe.Click / btnChangeRe2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ebd192f | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2662 |  | FLAG | RollBack_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7807c06e | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2663 | if (string.IsNullOrWhiteSpace(txtRequestNo.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f91979ac | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2671 | if (sStatus == Shipment_Status.S_Status_R) | MESSAGE | MessageHelper.GMessageBox | ("MSG00174") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e3e7ec6e | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2672 | if (sStatus == Shipment_Status.S_Status_R) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-38afc60c | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2676 | if (!checkRequired()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d4f5052 | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2679 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-c669feaa | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2681 | if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50118d28 | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2691 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ for (iRow < siSub.ActiveSheet.RowCount) ▸ if (siSub.GetValue(iRow, … | CALL_EXT | Convert.ToInt64 | (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0f2b35d | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2697 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ if (iShipmentQty == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00202", new object[] { 0 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ba981bb2 | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2698 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ if (iShipmentQty == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e5ccf31 | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2706 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ for (iRow < siSub.ActiveSheet.RowCount) | CALL_EXT | Convert.ToInt64 | (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-31dc118d | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2709 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ for (iRow < siSub.ActiveSheet.RowCount) ▸ if (siSub.GetValue(i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00202", new object[] { 0 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a7ed896a | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2710 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ for (iRow < siSub.ActiveSheet.RowCount) ▸ if (siSub.GetValue(i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-819e46a7 | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2727 | for (iRow < siSub.ActiveSheet.RowCount) ▸ if (dBaseDate > dShipDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00201", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-584ca44e | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2728 | for (iRow < siSub.ActiveSheet.RowCount) ▸ if (dBaseDate > dShipDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a74202f | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2736 | for (iRow < siSub.ActiveSheet.RowCount) ▸ if (dShipDate > dShipDateAfter) | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-809208d7 | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2737 | for (iRow < siSub.ActiveSheet.RowCount) ▸ if (dShipDate > dShipDateAfter) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c2079bf2 | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2758 |  | FLAG | sChangeStatus | Change_Req_Status.C_Status_Q | 화면 필드/플래그 변경 |  |  |  |
| AC-4560d3fd | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2759 |  | FLAG | sShipStatus | Shipment_Status.S_Status_R | 화면 필드/플래그 변경 |  |  |  |
| AC-3761c751 | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2760 |  | FLAG | bErpIFCheck | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest.BtnDel_Click

진입점: btnDel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9368dc6 | btnDel.Click | SSP0002_ShipmentChangeRequest.cs:3033 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a5f2be4 | btnDel.Click | SSP0002_ShipmentChangeRequest.cs:3036 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f575c63f | btnDel.Click | SSP0002_ShipmentChangeRequest.cs:3036 | if (MessageHelper.GMessageBox("MSG00016") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-942bde29 | btnDel.Click | SSP0002_ShipmentChangeRequest.cs:3039 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_C \|\| cboChangeType.SelectedValue.ToString() == ChangeTyp…) | FLAG | sShipStatus | Shipment_Status.S_Status_C | 화면 필드/플래그 변경 |  |  |  |
| AC-0d687729 | btnDel.Click | SSP0002_ShipmentChangeRequest.cs:3041 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_C \|\| cboChangeType.SelectedValue.ToString() == ChangeTyp…) | FLAG | sShipStatus | Shipment_Status.S_Status_P | 화면 필드/플래그 변경 |  |  |  |
| AC-b0aa7cc6 | btnDel.Click | SSP0002_ShipmentChangeRequest.cs:3043 |  | FLAG | bDeleClickYn | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cabeb1e7 | btnDel.Click | SSP0002_ShipmentChangeRequest.cs:3046 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_C \|\| cboChangeType.SelectedValue.ToString() == ChangeTyp…) | FLAG | bErpIFCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ed58c090 | btnDel.Click | SSP0002_ShipmentChangeRequest.cs:3048 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_C \|\| cboChangeType.SelectedValue.ToString() == ChangeTyp…) | FLAG | bErpIFCheck | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da3a1f3d | this.btnItemId.Click | SSP0002_ShipmentChangeRequest.cs:3083 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-145f8c33 | this.btnItemId.Click | SSP0002_ShipmentChangeRequest.cs:3085 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e7b1e4e1 | this.btnItemId.Click | SSP0002_ShipmentChangeRequest.cs:3086 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2ce16b76 | this.btnItemId.Click | SSP0002_ShipmentChangeRequest.cs:3087 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-495bf05d | this.btnItemId.Click | SSP0002_ShipmentChangeRequest.cs:3093 | if (popItem.ItemID != "") | VALUE_SET | txtRequest.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest.BtnNew_Click

진입점: btnNew.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47bff9a0 | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2840 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b5e5a05b | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2841 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c3db9545 | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2845 | if (chkERPIFBlockYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7f258a7 | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2847 |  | POPUP | new SSP0002_ShipmentConfirmInsertPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7acb333b | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2849 |  | UI_PROP | popup._UserID | UserInfo.UserId | 속성 _UserID 설정 |  |  |  |
| AC-ff1792c0 | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2850 |  | UI_PROP | popup._TimeZone | UserInfoContext.Current[UserInfoProperites.TimeZone] | 속성 _TimeZone 설정 |  |  |  |
| AC-f550c83c | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2851 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6137f09d | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2852 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-08fa85c0 | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2856 | if (popup.DialogResult == DialogResult.OK) | VALUE_CLEAR | clbDivision.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-7d5fe632 | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2857 | if (popup.DialogResult == DialogResult.OK) | VALUE_CLEAR | clbFromSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-0eaa8dfa | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2858 | if (popup.DialogResult == DialogResult.OK) | VALUE_CLEAR | clbToSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-401a6206 | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2859 | if (popup.DialogResult == DialogResult.OK) | VALUE_CLEAR | cboStatus.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-febe732f | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2860 | if (popup.DialogResult == DialogResult.OK) | VALUE_CLEAR | txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-7ecc6a71 | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2861 | if (popup.DialogResult == DialogResult.OK) | VALUE_CLEAR | txtRequest.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-64748fc5 | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2862 | if (popup.DialogResult == DialogResult.OK) | VALUE_CLEAR | txtSoNo.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-162e3295 | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2864 | if (popup.DialogResult == DialogResult.OK) | VALUE_SET | cboChangeType.ControlValues | "N" | 컨트롤 값 설정 |  |  |  |
| AC-b93359c9 | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2866 | if (popup.DialogResult == DialogResult.OK) | FLAG | _sConfrimID | popup._ConfrimID | 화면 필드/플래그 변경 |  |  |  |
| AC-aa7d4863 | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2874 | if (popup.DialogResult == DialogResult.OK) ▸ if (SearchDate > SaveDate) | VALUE_SET | drpPeriod.InitValue | GetDayRange(SaveDate.ToString("yyyyMMdd")) | 컨트롤 값 설정 |  |  |  |
| AC-b8a96f82 | btnNew.Click | SSP0002_ShipmentChangeRequest.cs:2876 | if (popup.DialogResult == DialogResult.OK) ▸ else of (SearchDate > SaveDate) ▸ if (SearchEndDate < SaveDate) | VALUE_SET | drpPeriod.InitValue | GetDayRange(SaveDate.ToString("yyyyMMdd")) | 컨트롤 값 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest.BtnSave_Click

진입점: btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f7f5587 | btnSave.Click | SSP0002_ShipmentChangeRequest.cs:2632 | if (string.IsNullOrWhiteSpace(txtRequestNo.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d551afba | btnSave.Click | SSP0002_ShipmentChangeRequest.cs:2635 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cfc95435 | btnSave.Click | SSP0002_ShipmentChangeRequest.cs:2635 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-80c28d90 | btnSave.Click | SSP0002_ShipmentChangeRequest.cs:2642 | if (sStatus == Shipment_Status.S_Status_R) | MESSAGE | MessageHelper.GMessageBox | ("MSG00174") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-af58e16a | btnSave.Click | SSP0002_ShipmentChangeRequest.cs:2643 | if (sStatus == Shipment_Status.S_Status_R) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fff96432 | btnSave.Click | SSP0002_ShipmentChangeRequest.cs:2653 |  | FLAG | sChangeStatus | Change_Req_Status.C_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-c930e3fd | btnSave.Click | SSP0002_ShipmentChangeRequest.cs:2654 |  | FLAG | sShipStatus | Shipment_Status.S_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-c686c62f | btnSave.Click | SSP0002_ShipmentChangeRequest.cs:2656 |  | FLAG | bErpIFCheck | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest.CboChangeType_SelectedIndexChanged

진입점: cboChangeType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6553462c | cboChangeType.SelectedIndexChanged | SSP0002_ShipmentChangeRequest.cs:2500 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | VALUE_SET | drpPeriod.InitValue | GetDayRange(sDate) | 컨트롤 값 설정 |  |  |  |
| AC-17df36dd | cboChangeType.SelectedIndexChanged | SSP0002_ShipmentChangeRequest.cs:2502 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | VALUE_SET | dtDate.InitValue | Convert.ToDateTime(DateTime.Now.Date).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-89251044 | cboChangeType.SelectedIndexChanged | SSP0002_ShipmentChangeRequest.cs:2505 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-37859050 | cboChangeType.SelectedIndexChanged | SSP0002_ShipmentChangeRequest.cs:2507 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | FLAG | dBaseDate | Convert.ToDateTime(dtDate.Value).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-d11a90dc | cboChangeType.SelectedIndexChanged | SSP0002_ShipmentChangeRequest.cs:2513 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | VALUE_SET | drpPeriod.InitValue | GetDayRange(sDate) | 컨트롤 값 설정 |  |  |  |
| AC-69fe7277 | cboChangeType.SelectedIndexChanged | SSP0002_ShipmentChangeRequest.cs:2515 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | VALUE_SET | dtDate.InitValue | Convert.ToDateTime(DateTime.Now.Date).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-5049abac | cboChangeType.SelectedIndexChanged | SSP0002_ShipmentChangeRequest.cs:2517 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-5aa10a02 | cboChangeType.SelectedIndexChanged | SSP0002_ShipmentChangeRequest.cs:2519 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | FLAG | dBaseDate | Convert.ToDateTime(dtDate.Value).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest.Change_ReValue

진입점: this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (string.IsNullOrWhiteSpace(sStatus))] / btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (string.IsNullOrWhiteSpace(sStatus))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8796ea7f | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:3146 |  | FLAG | RollBack_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1c4abb35 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:3147 |  | FLAG | iSelRow | iOld_SelRow | 화면 필드/플래그 변경 |  |  |  |
| AC-6b4fe5ba | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:3148 |  | FLAG | iSelCol | iOld_SelCol | 화면 필드/플래그 변경 |  |  |  |
| AC-8f36967d | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:3149 |  | FLAG | sRequestID | sBefor_RequestID | 화면 필드/플래그 변경 |  |  |  |
| AC-3eed2c19 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:3150 |  | FLAG | sRequestDeptID | sBefor_RequestDeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-ddf479e2 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:3151 |  | FLAG | sApprovalID | sBefor_ApprovalID | 화면 필드/플래그 변경 |  |  |  |
| AC-6cba2b26 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:3152 |  | FLAG | sApprovalDeptID | sBefor_ApprovalDeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-632bd0fc | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:3153 |  | FLAG | sMainConfirmID | sBefor_MainConfirmID | 화면 필드/플래그 변경 |  |  |  |
| AC-e5c6abc0 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:3154 |  | FLAG | sChangeStatus | sBefor_ChangeStatus | 화면 필드/플래그 변경 |  |  |  |
| AC-609099e2 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:3155 |  | FLAG | sShipStatus | sBefor_ShipStatus | 화면 필드/플래그 변경 |  |  |  |
| AC-82cf7cd8 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:3156 |  | FLAG | sRequestName | sBefor_RequestName | 화면 필드/플래그 변경 |  |  |  |
| AC-64b90d9c | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:3157 |  | FLAG | sSaveConfirmID | sBefor_SaveConfirmID | 화면 필드/플래그 변경 |  |  |  |
| AC-e5726633 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:3158 |  | FLAG | _sRequestNo | _Befor_sRequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-3a60a941 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:3159 |  | FLAG | _sConfrimID | _Befor_sConfrimID | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest.checkRequired

진입점: btnChangeRe.Click / btnChangeRe2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-882a407f | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2776 | if (string.IsNullOrWhiteSpace(txtApproval.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-77100c23 | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2777 | if (string.IsNullOrWhiteSpace(txtApproval.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6512904a | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2787 | if (string.IsNullOrWhiteSpace(txtTitle.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-454bcb77 | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2788 | if (string.IsNullOrWhiteSpace(txtTitle.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-54b9cc09 | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2798 | if (cboChangeReason.SelectedIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c1900d88 | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2799 | if (cboChangeReason.SelectedIndex == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-db096365 | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2809 | if (string.IsNullOrWhiteSpace(txtReasonDetail.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c634c7f4 | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2810 | if (string.IsNullOrWhiteSpace(txtReasonDetail.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5cf40794 | btnChangeRe.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:2815 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentChangeRequest.chkERPIFBlockYn

진입점: this.spdMain.CellDoubleClick [try] / btnNew.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77517e0f | this.spdMain.CellDoubleClick [try] 외 1 | SSP0002_ShipmentChangeRequest.cs:2015 |  | FLAG | dtERPBlockYnIF | Data_SCP.Common(Data_SCP.Type.SSPBlockCheckIF, false, "SSP0002") | 화면 필드/플래그 변경 |  |  |  |
| AC-5ce99ca2 | this.spdMain.CellDoubleClick [try] 외 1 | SSP0002_ShipmentChangeRequest.cs:2015 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSPBlockCheckIF, false, "SSP0002") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6a3d33df | this.spdMain.CellDoubleClick [try] 외 1 | SSP0002_ShipmentChangeRequest.cs:2018 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("BLOCK_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-e5b8dce6 | this.spdMain.CellDoubleClick [try] 외 1 | SSP0002_ShipmentChangeRequest.cs:2027 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("PERIOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-fbcbab8d | this.spdMain.CellDoubleClick [try] 외 1 | SSP0002_ShipmentChangeRequest.cs:2028 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00267", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9f942af1 | this.spdMain.CellDoubleClick [try] 외 1 | SSP0002_ShipmentChangeRequest.cs:2032 |  | RETURN | return resultYn; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentChangeRequest.ClearRequestInfo

진입점: this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub)] / btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnChangeRe.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnChangeRe2.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnAdd.Click [if (ds.Tables[0].Rows.Count > 0) ▸ if (ds.T…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e3da1ae | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 9 | SSP0002_ShipmentChangeRequest.cs:824 |  | VALUE_CLEAR | txtRequestNo.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-28364db8 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 9 | SSP0002_ShipmentChangeRequest.cs:825 |  | VALUE_CLEAR | txtTitle.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-7eb72027 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 9 | SSP0002_ShipmentChangeRequest.cs:826 |  | VALUE_CLEAR | txtApproval.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9a78b8a6 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 9 | SSP0002_ShipmentChangeRequest.cs:827 |  | VALUE_CLEAR | txtAppDeptName.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9255d461 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 9 | SSP0002_ShipmentChangeRequest.cs:828 |  | VALUE_SET | cboChangeReason.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-31a5584c | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 9 | SSP0002_ShipmentChangeRequest.cs:829 |  | VALUE_CLEAR | txtReasonDetail.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-59355ae6 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 9 | SSP0002_ShipmentChangeRequest.cs:830 |  | FLAG | sApprovalDeptID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-8460af09 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 9 | SSP0002_ShipmentChangeRequest.cs:831 |  | FLAG | sApprovalID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-283539e1 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 9 | SSP0002_ShipmentChangeRequest.cs:832 |  | FLAG | sMainConfirmID | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e07be82 | this.Load | SSP0002_ShipmentChangeRequest.cs:384 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3ca97677 | this.Load | SSP0002_ShipmentChangeRequest.cs:385 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9e78f54c | this.Load | SSP0002_ShipmentChangeRequest.cs:388 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-35b12e47 | this.Load | SSP0002_ShipmentChangeRequest.cs:389 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-973e23a8 | this.Load | SSP0002_ShipmentChangeRequest.cs:391 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f6fdbba0 | this.Load | SSP0002_ShipmentChangeRequest.cs:394 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-21aac4b7 | this.Load | SSP0002_ShipmentChangeRequest.cs:398 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0002_ShipmentChangeRequest.DeleteDataDrafting

진입점: btnDel.Click / btnCancel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-784cbf6c | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1847 | if (sFlag == "D" && iBaseChk == 0 && siSub.ActiveSheet.RowCount > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00198") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f6f31c9f | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1849 | if (sFlag == "D" && iBaseChk == 0 && siSub.ActiveSheet.RowCount > 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67728c81 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1853 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-ad0c750d | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1858 | if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-77a79a70 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1862 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-803d2f60 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1863 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-caae29ec | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1864 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-c14d82fd | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1865 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-2f2ba6e2 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1866 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-33cdc533 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1867 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_if_send_flag"] | p_if_send_flag | 행/컬럼 값 대입 |  |  |  |
| AC-5a2b2451 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1868 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-b68e7332 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1870 | if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4e460192 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1870 | if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-ede679ab | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1878 | if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveConfirmID | p_confirm_id | 화면 필드/플래그 변경 |  |  |  |
| AC-f8591d76 | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1879 | if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveFlag | "D_E" | 화면 필드/플래그 변경 |  |  |  |
| AC-8ef3038f | btnDel.Click 외 1 | SSP0002_ShipmentChangeRequest.cs:1897 | if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0002_ShipmentChangeRequest.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c9207d7 | Dispose | SSP0002_ShipmentChangeRequest.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0002_ShipmentChangeRequest.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfd3b9c7 | EditButton | SSP0002_ShipmentChangeRequest.cs:654 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-af516086 | EditButton | SSP0002_ShipmentChangeRequest.cs:655 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentChangeRequest.FindAddData

진입점: btnAdd.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee691ea9 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2891 | if (dBaseDate > dShipDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-81f75cfb | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2892 | if (dBaseDate > dShipDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d302f0ec | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2967 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo) && sDivision == sChkDivision && sFromSite == sChkFromSite &&… | FLAG | iSelRow | iRow | 화면 필드/플래그 변경 |  |  |  |
| AC-a6cd0d62 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2974 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo) && sDivision == sChkDivision && sFromSite == sChkFromSite &&… | MESSAGE | MessageHelper.GMessageBox | ("MSG00189") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-825d4bad | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2976 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo) && sDivision == sChkDivision && sFromSite == sChkFromSite &&… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-77445011 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2986 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0076f3bb | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2990 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST_ADD") ⇒ SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST_ADD | 엔드포인트 요청 생성 |  |  |  |
| AC-e7334dd7 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2991 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d00953ef | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2992 | lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-77b59bb8 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2993 | lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-6b81b8ec | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2994 | lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-dbe053fb | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2996 | lambda | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-72f07744 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2997 | lambda | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-7a52e4ba | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2998 | lambda | DATA_OP | request.Parameters["p_transport_mode"] | p_trasport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-d898926f | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:2999 | lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-b2d92cbb | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:3000 | lambda | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-93b34ef4 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:3002 | lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-63565cf5 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:3003 | lambda | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-ccc85576 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:3004 | lambda | DATA_OP | request.Parameters["p_to_date"] | p_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-2487606a | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:3005 | lambda | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-911d3f58 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:3006 | lambda | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-8d839e47 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:3007 | lambda | DATA_OP | request.Parameters["p_sameDate_add"] | p_sameDate_add | 행/컬럼 값 대입 |  |  |  |
| AC-9f731144 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:3008 | lambda | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-f594e8d1 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:3010 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a1c13b92 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:3012 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c2120147 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:3023 | if (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][DefColumns.NEW_YN].ToString() == "N") ▸ if (ds.Tables[0].Rows[0][DefColumns.SHIP… | MESSAGE | MessageHelper.GMessageBox | ("MSG00178") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8210d544 | btnAdd.Click | SSP0002_ShipmentChangeRequest.cs:3024 | if (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][DefColumns.NEW_YN].ToString() == "N") ▸ if (ds.Tables[0].Rows[0][DefColumns.SHIP… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentChangeRequest.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f75d3fc5 | FindButton | SSP0002_ShipmentChangeRequest.cs:669 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f35aa2d8 | FindButton | SSP0002_ShipmentChangeRequest.cs:674 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-95c42ffa | FindButton | SSP0002_ShipmentChangeRequest.cs:674 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b9e8eb4d | FindButton | SSP0002_ShipmentChangeRequest.cs:678 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4004b4e5 | FindButton | SSP0002_ShipmentChangeRequest.cs:695 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-414e38c3 | FindButton | SSP0002_ShipmentChangeRequest.cs:696 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9ee724f0 | FindButton | SSP0002_ShipmentChangeRequest.cs:700 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST") ⇒ SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-cdc5ae7a | FindButton | SSP0002_ShipmentChangeRequest.cs:701 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-040534da | FindButton | SSP0002_ShipmentChangeRequest.cs:702 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-cda713c6 | FindButton | SSP0002_ShipmentChangeRequest.cs:703 | try ▸ lambda | DATA_OP | request.Parameters["p_erp_so_no"] | p_erp_so_no | 행/컬럼 값 대입 |  |  |  |
| AC-3eb85a8a | FindButton | SSP0002_ShipmentChangeRequest.cs:704 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-bfe3d0e9 | FindButton | SSP0002_ShipmentChangeRequest.cs:705 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9cf8b558 | FindButton | SSP0002_ShipmentChangeRequest.cs:706 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-59bc9dc1 | FindButton | SSP0002_ShipmentChangeRequest.cs:707 | try ▸ lambda | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-cd251404 | FindButton | SSP0002_ShipmentChangeRequest.cs:708 | try ▸ lambda | DATA_OP | request.Parameters["p_status"] | p_status | 행/컬럼 값 대입 |  |  |  |
| AC-22fe2292 | FindButton | SSP0002_ShipmentChangeRequest.cs:709 | try ▸ lambda | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-2d46a589 | FindButton | SSP0002_ShipmentChangeRequest.cs:710 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-63c791c7 | FindButton | SSP0002_ShipmentChangeRequest.cs:711 | try ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-ddac8502 | FindButton | SSP0002_ShipmentChangeRequest.cs:713 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-310f1e98 | FindButton | SSP0002_ShipmentChangeRequest.cs:715 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-038c5007 | FindButton | SSP0002_ShipmentChangeRequest.cs:722 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5549417f | FindButton | SSP0002_ShipmentChangeRequest.cs:723 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d43bec1 | FindButton | SSP0002_ShipmentChangeRequest.cs:726 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-104247b6 | FindButton | SSP0002_ShipmentChangeRequest.cs:731 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b377b61a | FindButton | SSP0002_ShipmentChangeRequest.cs:742 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0002_ShipmentChangeRequest.FindData_Main_Nonasync

진입점: btnNew.Click [if (popup.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-296e7226 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:748 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-af60540a | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:753 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-bc3c71a6 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:753 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ab3c858 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:757 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-60a8d1a2 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:777 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST") ⇒ SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-24435a25 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:778 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2cd4f44d | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:779 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-0cc71d1b | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:780 | try | DATA_OP | request.Parameters["p_erp_so_no"] | p_erp_so_no | 행/컬럼 값 대입 |  |  |  |
| AC-778dee01 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:781 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d11ba407 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:782 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0d68c2b7 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:783 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6257e319 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:784 | try | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-6fca43db | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:785 | try | DATA_OP | request.Parameters["p_status"] | p_status | 행/컬럼 값 대입 |  |  |  |
| AC-b1ed38f4 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:786 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-59b59b4a | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:787 | try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-8ec0d2e0 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:788 | try | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-eb9b9f3a | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:790 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f63e0eb9 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:798 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6f026e72 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:799 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9980f097 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:802 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-968d5932 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:807 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb249836 | btnNew.Click [if (popup.DialogResult == DialogResult.OK)] | SSP0002_ShipmentChangeRequest.cs:818 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0002_ShipmentChangeRequest.FindData_Sub

진입점: this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_P \|\| sStatus == Shipment_Status.S_Status_D)] / btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")] / btnChangeRe.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")] / btnChangeRe2.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")] / btnAdd.Click [if (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0]…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cf80d91 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:868 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-76768e22 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:876 | if (electrodeYn =="Y") | CALL_EXT | siSub.ActiveSheet.SetColumnLabel | (0, siSub.GetColumnIndex(DefColumns.REMARKS2), "Shipment No") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a04112f2 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:920 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-2a4ae6d6 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:921 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-034c6e3f | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:922 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-24ea07da | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:923 |  | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-0d986113 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:924 |  | DATA_OP | request.Parameters["p_erp_so_no"] | p_erp_so_no | 행/컬럼 값 대입 |  |  |  |
| AC-78aaffdf | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:925 |  | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-fd97f9b5 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:926 |  | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-47c6cde7 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:927 |  | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-87d4c203 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:928 |  | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-8a0ca49a | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:929 |  | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-ecbde676 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:930 |  | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-fa6d7ea1 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:932 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-c719f160 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:933 |  | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e0a5db55 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:934 |  | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-11c4d7dd | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:935 |  | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-ed6b92c4 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:936 |  | DATA_OP | request.Parameters["p_request_user_id"] | p_request_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-d728b992 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:937 |  | DATA_OP | request.Parameters["p_request_status"] | sRequest_Status | 행/컬럼 값 대입 |  |  |  |
| AC-ebfb3925 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:938 |  | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-3a7a699b | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:939 |  | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-623b6011 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:941 |  | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-69fd2c98 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:946 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-59bb23ff | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:960 | if (ds.Tables[0].Rows.Count > 0) ▸ if (sRequest_Status == Shipment_Status.S_Status_C \|\| sRequest_Status == Shipment_Status.S_Status_P) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00178") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d7ab9096 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:961 | if (ds.Tables[0].Rows.Count > 0) ▸ if (sRequest_Status == Shipment_Status.S_Status_C \|\| sRequest_Status == Shipment_Status.S_Status_P) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b900d7c | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:969 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d142f765 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:970 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ca79b140 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:973 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4d27bfe8 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:977 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2351bfe3 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:984 | if (!bReadOnly) ▸ if (sRequest_Status == "C" \|\| sRequest_Status == "P") | FLAG | sChangeStatus | Change_Req_Status.C_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-7a6970fb | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:985 | if (!bReadOnly) ▸ if (sRequest_Status == "C" \|\| sRequest_Status == "P") | FLAG | sShipStatus | Shipment_Status.S_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-baea4934 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:997 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (!string.IsNullOrWhiteSpac… | FLAG | bIFFalg | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0bd28ea7 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:999 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (!string.IsNullOrWhiteSpac… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-844e30ac | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1007 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (!string.IsNullOrWhiteSpac… | FLAG | bIFFalg | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cc1a5fac | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1015 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | FLAG | sChangeStatus | Change_Req_Status.C_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-7f46a27c | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1016 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | FLAG | sShipStatus | Shipment_Status.S_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-9aff53fe | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1023 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | FLAG | sApprovalID | ds.Tables[2].Rows[0]["USER_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-890ddc7b | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1024 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | FLAG | sApprovalDeptID | ds.Tables[2].Rows[0]["DEPT_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3eaf7870 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1027 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | VALUE_SET | txtApproval.Text | ds.Tables[2].Rows[0]["USER_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b3d478c0 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1028 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | VALUE_SET | txtAppDeptName.Text | ds.Tables[2].Rows[0]["DEPT_NAME_KO"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-6a8e9a91 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1032 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | VALUE_SET | txtApproval.Text | ds.Tables[2].Rows[0]["USER_NAME_EN"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b442be67 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1033 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | VALUE_SET | txtAppDeptName.Text | ds.Tables[2].Rows[0]["DEPT_NAME_EN"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-a0a34c78 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1043 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | CALL_EXT | lcSave.Move | (dragController) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d609517 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1045 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | UI_PROP | lcAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-98792bc0 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1046 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | UI_PROP | lcDel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-408d8c2f | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1047 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | UI_PROP | lcDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c4066e97 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1049 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | UI_PROP | lcChgReq2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a02630b9 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1050 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | FLAG | sSearchType | SearchType.Type_E | 화면 필드/플래그 변경 |  |  |  |
| AC-608fd0c3 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1055 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | CALL_EXT | lcSave.Move | (dragController) | ⚠ 의미 확인 필요 |  |  |  |
| AC-479f453a | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1056 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | UI_PROP | lcAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6369d63a | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1057 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | UI_PROP | lcDel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-584d289e | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1058 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | UI_PROP | lcDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-25a0a99d | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1059 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | UI_PROP | lcChgReq2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-173b187a | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1060 | if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count >… | FLAG | sSearchType | SearchType.Type_N | 화면 필드/플래그 변경 |  |  |  |
| AC-00fb7e45 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1080 | else of (!bReadOnly) ▸ for (iRow < siMain.ActiveSheet.RowCount) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-714b8bc9 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1089 | else of (!bReadOnly) ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count > 0) ▸ if (sShipStatus != Shipment_Status.S_Status_R) | FLAG | sChangeStatus | Change_Req_Status.C_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-4ebf334d | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1090 | else of (!bReadOnly) ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count > 0) ▸ if (sShipStatus != Shipment_Status.S_Status_R) | FLAG | sShipStatus | Shipment_Status.S_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-43052831 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1104 |  | FLAG | bDeleClickYn | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ad83dc82 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1106 |  | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest.FindData_Sub_Draft

진입점: this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_P \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (!string.IsNullOrWhiteSpace(sSaveConfirmID)) ▸ if (!GetErpIFCheck())] / btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94e4b340 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1156 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-4978fcfe | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1157 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7bb61f74 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1158 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-cca76944 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1159 |  | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-a2271665 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1160 |  | DATA_OP | request.Parameters["p_erp_so_no"] | p_erp_so_no | 행/컬럼 값 대입 |  |  |  |
| AC-71aca405 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1161 |  | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-153ebb48 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1162 |  | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-3b44d222 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1163 |  | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-eda165bc | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1164 |  | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-61829932 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1165 |  | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-60975e15 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1166 |  | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-4d8cd858 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1167 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-383c3997 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1168 |  | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9326d46e | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1169 |  | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-efebffbe | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1170 |  | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-a9057757 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1171 |  | DATA_OP | request.Parameters["p_request_user_id"] | p_request_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2b643572 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1172 |  | DATA_OP | request.Parameters["p_request_status"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-7237fad8 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1173 |  | DATA_OP | request.Parameters["p_language"] | UserInfoContext.Current[UserInfoProperites.Language] | 행/컬럼 값 대입 |  |  |  |
| AC-b9ba124e | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1174 |  | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-83a4f527 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1175 |  | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-7672cbf8 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1177 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-16e37cb9 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1185 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5fe4b104 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1186 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-69827822 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1189 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fb40c052 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1193 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5bc70d41 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1199 | if (ds.Tables[1].Rows.Count > 0) ▸ if (sShipStatus != Shipment_Status.S_Status_R) | FLAG | sChangeStatus | Change_Req_Status.C_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-085c469d | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1200 | if (ds.Tables[1].Rows.Count > 0) ▸ if (sShipStatus != Shipment_Status.S_Status_R) | FLAG | sShipStatus | Shipment_Status.S_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-5482347b | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1222 |  | FLAG | sSaveConfirmID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-2ecc834a | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1223 |  | FLAG | sSaveFlag | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-05b25719 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1229 |  | FLAG | bDeleClickYn | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b309e289 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1230 |  | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-473ce4b1 | this.Load | SSP0002_ShipmentChangeRequest.cs:250 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0002_ShipmentChangeRequest.GetDayRange

진입점: this.Load / cboChangeType.SelectedIndexChanged [if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P)] / btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ if (SearchDate > SaveDate)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d3dd88e | this.Load 외 2 | SSP0002_ShipmentChangeRequest.cs:2533 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-70330712 | this.Load 외 2 | SSP0002_ShipmentChangeRequest.cs:2534 |  | DATA_OP | request.Parameters["p_from_date"] | sFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-8f5bbd6c | this.Load 외 2 | SSP0002_ShipmentChangeRequest.cs:2535 |  | DATA_OP | request.Parameters["p_offset_day"] | "14" | 행/컬럼 값 대입 |  |  |  |
| AC-91723fb6 | this.Load 외 2 | SSP0002_ShipmentChangeRequest.cs:2536 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-1835e83e | this.Load 외 2 | SSP0002_ShipmentChangeRequest.cs:2537 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bc693aad | this.Load 외 2 | SSP0002_ShipmentChangeRequest.cs:2540 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentChangeRequest.GetErpIFCheck

진입점: this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_P \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (!string.IsNullOrWhiteSpace(sSaveConfirmID))] / btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRe…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5c93d63 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1239 | try ▸ if (!bErpIFCheck) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-da12d31a | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1244 | try ▸ if (string.IsNullOrWhiteSpace(_sRequestNo)) | FLAG | _sRequestNo | txtRequestNo.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-b79068d6 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1254 | try | CALL_EXT | service.FN_ERP_UIWebService | (_sRequestNo, sChangeType, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc3f5500 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1270 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-6f689c01 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1271 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-8eef313d | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1272 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-a92b4e80 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1273 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_del_flag"] | sSaveFlag | 행/컬럼 값 대입 |  |  |  |
| AC-736bdf57 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1274 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-c80562cb | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1275 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-6fc61a78 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1276 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_if_send_flag"] | p_if_send_flag | 행/컬럼 값 대입 |  |  |  |
| AC-03b27a87 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1277 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-1ccd16b9 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1279 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3ba62969 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1291 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-206496df | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1298 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40ac5412 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1303 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (service.RtFlag == "C_E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fae80329 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1314 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentChangeRequest.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-688212d6 | this.Load | SSP0002_ShipmentChangeRequest.cs:304 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-24e098c4 | this.Load | SSP0002_ShipmentChangeRequest.cs:305 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtSub) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f44a0c6 | this.Load | SSP0002_ShipmentChangeRequest.cs:307 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e5685524 | this.Load | SSP0002_ShipmentChangeRequest.cs:310 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl1) | 권한 검사/설정 |  |  |  |
| AC-62e74aee | this.Load | SSP0002_ShipmentChangeRequest.cs:312 |  | FLAG | dtMyDivision | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-f8d728dc | this.Load | SSP0002_ShipmentChangeRequest.cs:312 |  | DATA_OP | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e16b07c3 | this.Load | SSP0002_ShipmentChangeRequest.cs:312 |  | DATA_OP | dtMyDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d3982fb9 | this.Load | SSP0002_ShipmentChangeRequest.cs:314 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bd1bf17c | this.Load | SSP0002_ShipmentChangeRequest.cs:315 |  | CALL_EXT | clsCtrl.setListBoxEx | (dtChangeReasonCode, cboChangeReason, true, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-094adba3 | this.Load | SSP0002_ShipmentChangeRequest.cs:317 |  | LIST_REBIND | clsCtrl.setListBox | (dtChangeStatusCode, cboStatus, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2c363f18 | this.Load | SSP0002_ShipmentChangeRequest.cs:319 |  | LIST_REBIND | clsCtrl.setListBox | (dtChangeReqType, cboChangeType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-da04017c | this.Load | SSP0002_ShipmentChangeRequest.cs:321 |  | VALUE_SET | cboChangeType.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |
| AC-2d366b90 | this.Load | SSP0002_ShipmentChangeRequest.cs:324 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange("") | 컨트롤 값 설정 |  |  |  |
| AC-3e75b459 | this.Load | SSP0002_ShipmentChangeRequest.cs:327 |  | VALUE_SET | dtDate.InitValue | Convert.ToDateTime(DateTime.Now.Date).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-cbf86fd7 | this.Load | SSP0002_ShipmentChangeRequest.cs:332 | if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-a9e23ac6 | this.Load | SSP0002_ShipmentChangeRequest.cs:334 |  | FLAG | dBaseDate | Convert.ToDateTime(dtDate.Value).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-9c252477 | this.Load | SSP0002_ShipmentChangeRequest.cs:336 |  | FLAG | sRequestID | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-6d425595 | this.Load | SSP0002_ShipmentChangeRequest.cs:340 | if (UserInfoContext.Current[UserInfoProperites.Language] == "KO") | VALUE_SET | txtRequestor.Text | UserInfoContext.Current[UserInfoProperites.UserName].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b4692072 | this.Load | SSP0002_ShipmentChangeRequest.cs:344 | else of (UserInfoContext.Current[UserInfoProperites.Language] == "KO") | VALUE_SET | txtRequestor.Text | UserInfoContext.Current[UserInfoProperites.UserName_E].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-a35233c4 | this.Load | SSP0002_ShipmentChangeRequest.cs:347 |  | FLAG | sRequestName | txtRequestor.Text + "(" + UserInfoContext.Current.UserId + ")" | 화면 필드/플래그 변경 |  |  |  |
| AC-2f64e72e | this.Load | SSP0002_ShipmentChangeRequest.cs:350 |  | VALUE_SET | txtRequestDeptName.Text | UserInfoContext.Current[UserInfoProperites.Dept_Name] | 컨트롤 값 설정 |  |  |  |
| AC-daecc2e6 | this.Load | SSP0002_ShipmentChangeRequest.cs:351 |  | FLAG | sRequestDeptID | UserInfoContext.Current[UserInfoProperites.Dept_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-ef238dec | this.Load | SSP0002_ShipmentChangeRequest.cs:353 |  | FLAG | sLanguage | UserInfoContext.Current[UserInfoProperites.Language] | 화면 필드/플래그 변경 |  |  |  |
| AC-72ba2014 | this.Load | SSP0002_ShipmentChangeRequest.cs:356 |  | CALL_EXT | lcSave.Move | (dragController) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0002_ShipmentChangeRequest.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_P \|\| sStatus == Shipment_Status.S_Status_D)] / btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnChangeRe.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnChangeRe2.Click [if (iCount > 0) ▸ if (ds.Tables…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-238d0854 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:405 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-de7766b6 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:407 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-2bff9b9a | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:408 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c236746b | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:409 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0b550ee9 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:415 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | spdMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ERP_SO_NO)].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-645b49f0 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:416 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | spdMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CONFIRM_ID)].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-38c7eb01 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:421 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | UI_PROP | col.Label | MessageHelper.GetTerm(sFieldName) | 속성 Label 설정 |  |  |  |
| AC-96703cae | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:426 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | spdMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ERP_SO_NO)].Width | 100 | 그리드 속성/값 설정 |  |  |  |
| AC-56a3612f | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:427 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | spdMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CONFIRM_ID)].Width | 120 | 그리드 속성/값 설정 |  |  |  |
| AC-6cea03b2 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:432 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | UI_PROP | col.Label | MessageHelper.GetTerm(sFieldName) | 속성 Label 설정 |  |  |  |
| AC-d03f472b | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:473 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-66803c0e | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:476 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-2f42fa68 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:477 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY), 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c65a2c77 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:485 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | spreadInfo.ActiveSheet.ColumnHeader.Cells[0, spreadInfo.GetColumnIndex(DefColumns.CHK)].Ce… | chk | 그리드 속성/값 설정 |  |  |  |
| AC-963d239c | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:486 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | spreadInfo.ActiveSheet.ColumnHeader.Cells[0, spreadInfo.GetColumnIndex(DefColumns.CHK)].Va… | false | 그리드 속성/값 설정 |  |  |  |
| AC-556489e4 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:487 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | spreadInfo.ActiveSheet.ColumnHeader.Cells[0, spreadInfo.GetColumnIndex(DefColumns.CHK)].Bo… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-66bc2868 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:491 | if (spreadInfo.SheetName == SpdSheet.shtSub) | UI_PROP | col.MergePolicy | FarPoint.Win.Spread.Model.MergePolicy.None | 속성 MergePolicy 설정 |  |  |  |
| AC-21e01302 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:492 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-479fe934 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:493 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3da5f6fa | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:496 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | spdSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.REMARKS)].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-7fca5acf | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:501 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ERP_SO_NO)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-00b04549 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:503 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.LT_DAY), 1, 6, 20, "Plan", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-73de3690 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:504 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 1, 6, 20, "Confirm", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5f36b73f | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:506 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-459463e3 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:507 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33269bad | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:508 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca7e3ae3 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:509 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9116f1c4 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:510 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_DATE), 2, 1, 30, "Shipment Date", FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-16799313 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:511 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ace39bfa | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:513 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2761f585 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:514 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-88768f1c | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:515 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2f870759 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:516 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48c73d10 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:517 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), 2, 1, 30, "Shipment Date*", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-67d08d0d | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:518 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty*", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-07dc02ce | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:523 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ERP_SO_NO)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e754a234 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:525 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.LT_DAY), 1, 6, 20, "Confirmed", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-59cf166d | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:526 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 1, 6, 20, "Change", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a248c6d9 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:528 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13ca6d05 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:529 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0badf369 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:530 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-35b61fdd | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:531 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-00df2561 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:532 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_DATE), 2, 1, 30, "Shipment Date", FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-41940a4b | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:533 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7c9532ab | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:535 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9f1ff60 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:536 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-42365f03 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:537 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9068dfc | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:538 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f1e7bf95 | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:539 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), 2, 1, 30, "Shipment Date*", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2cb28dce | this.Load 외 10 | SSP0002_ShipmentChangeRequest.cs:540 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty*", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0002_ShipmentChangeRequest.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-749642a6 | InsertButton | SSP0002_ShipmentChangeRequest.cs:1948 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bc3b1cba | InsertButton | SSP0002_ShipmentChangeRequest.cs:1951 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1b3781fa | InsertButton | SSP0002_ShipmentChangeRequest.cs:1976 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0002_ShipmentChangeRequest.QtyChk

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-841128bf | (진입점 미연결) | SSP0002_ShipmentChangeRequest.cs:3112 | for (i < siSub.ActiveSheet.RowCount) ▸ if (bQty.ToString() != "") | CALL_EXT | Convert.ToInt64 | (bQty) | ⚠ 의미 확인 필요 |  |  |  |
| AC-edd2217b | (진입점 미연결) | SSP0002_ShipmentChangeRequest.cs:3115 | for (i < siSub.ActiveSheet.RowCount) ▸ if (aQty.ToString() != "") | CALL_EXT | Convert.ToInt64 | (aQty) | ⚠ 의미 확인 필요 |  |  |  |
| AC-942a3428 | (진입점 미연결) | SSP0002_ShipmentChangeRequest.cs:3121 | if (sumBfQty < sumAfQty) | MESSAGE | MessageHelper.GMessageBox | ("MSG00256", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-309b239d | (진입점 미연결) | SSP0002_ShipmentChangeRequest.cs:3125 |  | RETURN | return isQtyChk; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentChangeRequest.SaveAddDataDrafting

진입점: btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-977224c4 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1688 | else of (DateTime.TryParse(dt.Rows[0][DefColumns.NEW_SHIPMENT_DATE].ToString(), out temp) == true) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2113670e | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1689 | else of (DateTime.TryParse(dt.Rows[0][DefColumns.NEW_SHIPMENT_DATE].ToString(), out temp) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd0ee602 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1725 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-078642b3 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1733 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1137ee4e | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1734 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-3352de55 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1735 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-14840468 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1736 |  | DATA_OP | request.Parameters["p_request_id"] | p_request_id | 행/컬럼 값 대입 |  |  |  |
| AC-6ec4186d | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1737 |  | DATA_OP | request.Parameters["p_request_dept_id"] | p_request_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-9adf0fbd | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1738 |  | DATA_OP | request.Parameters["p_approval_id"] | p_approval_id | 행/컬럼 값 대입 |  |  |  |
| AC-efe1063f | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1739 |  | DATA_OP | request.Parameters["p_approval_dept_id"] | p_approval_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-e92e7517 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1740 |  | DATA_OP | request.Parameters["p_change_reason"] | p_change_reason | 행/컬럼 값 대입 |  |  |  |
| AC-14f14651 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1741 |  | DATA_OP | request.Parameters["p_reason_detail"] | p_reason_detail | 행/컬럼 값 대입 |  |  |  |
| AC-476efc0a | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1742 |  | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-71359b49 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1743 |  | DATA_OP | request.Parameters["p_main_confirm_id"] | p_main_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-66a5ae71 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1744 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-59076f1d | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1745 |  | DATA_OP | request.Parameters["p_new_confirm_id"] | p_new_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-3b22048e | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1747 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-4ae5ed15 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1748 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-8b85eebe | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1749 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-e79d3282 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1750 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-cf851afc | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1751 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-a4032acc | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1752 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-766e2c47 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1753 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-1671c8c1 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1754 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-9ccef79a | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1755 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-8a4fe518 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1756 |  | DATA_OP | request.Parameters["p_new_lt_day"] | p_new_lt_day | 행/컬럼 값 대입 |  |  |  |
| AC-b4b46ca6 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1758 |  | DATA_OP | request.Parameters["p_change_status"] | sChangeStatus | 행/컬럼 값 대입 |  |  |  |
| AC-c473f787 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1759 |  | DATA_OP | request.Parameters["p_ship_status"] | sShipStatus | 행/컬럼 값 대입 |  |  |  |
| AC-42685744 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1760 |  | DATA_OP | request.Parameters["p_change_req_no"] | p_change_req_no | 행/컬럼 값 대입 |  |  |  |
| AC-28640612 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1761 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-cbdbd096 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1762 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-fe5f081c | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1763 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-424c075f | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1764 |  | DATA_OP | request.Parameters["p_new_ship_date"] | p_new_ship_date | 행/컬럼 값 대입 |  |  |  |
| AC-be91c681 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1765 |  | DATA_OP | request.Parameters["p_new_qty"] | p_new_qty | 행/컬럼 값 대입 |  |  |  |
| AC-2e4682ca | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1766 |  | DATA_OP | request.Parameters["p_new_yn"] | p_new_yn | 행/컬럼 값 대입 |  |  |  |
| AC-9add5d3f | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1767 |  | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-7e2b70a4 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1768 |  | DATA_OP | request.Parameters["p_if_send_flag"] | p_if_send_flag | 행/컬럼 값 대입 |  |  |  |
| AC-9f43399d | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1769 |  | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-6655a80d | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1770 |  | DATA_OP | request.Parameters["p_plan_confirm_id"] | p_plan_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-f3bb6fea | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1772 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-cc022409 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1773 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-68693d3e | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1774 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9d1e4cbd | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1775 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2bdb41ef | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1776 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-49d0d2f3 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1777 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-ca501a3f | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1778 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-937664be | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1779 |  | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-759747b0 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1781 |  | DATA_OP | request.Parameters["p_auth"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4232a963 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1783 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9cf434ab | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1788 | if (ds.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveConfirmID | p_confirm_id | 화면 필드/플래그 변경 |  |  |  |
| AC-bc505381 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1789 | if (ds.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveFlag | "E" | 화면 필드/플래그 변경 |  |  |  |
| AC-4afca014 | btnAdd.Click [if (ds.Tables[0].Rows.Count > 0)] | SSP0002_ShipmentChangeRequest.cs:1802 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0002_ShipmentChangeRequest.SaveDataDrafting

진입점: this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_P \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly) ▸ if (sRequest_Status == "C" \|\| sRequest_Status == "P")] / btnSave.Click / btnChangeRe.Click / btnChangeRe2.Click / btnAdd.Click [if (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ if (sRequest_Status == "C" \|\| sRequest_Status == "P")] / btnDel.Click [if (iCoun…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-542dd79a | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1419 | if (sShipStatus == Shipment_Status.S_Status_R) | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-7e7d8c58 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1419 | if (sShipStatus == Shipment_Status.S_Status_R) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc9daa8c | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1487 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (DateTime.TryParse(siSub.GetText(i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)).ToStr… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8be7d7b1 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1488 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (DateTime.TryParse(siSub.GetText(i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)).ToStr… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-591da786 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1516 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sQty == "") | CALL_EXT | Convert.ToInt64 | (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e020d1a | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1553 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-7243ea26 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1561 | if (iCount > 0) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6509f62d | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1563 | if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ef5eaad4 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1564 | if (iCount > 0) | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-4e0756f8 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1565 | if (iCount > 0) | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-d5b4a97b | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1566 | if (iCount > 0) | DATA_OP | request.Parameters["p_request_id"] | p_request_id | 행/컬럼 값 대입 |  |  |  |
| AC-02118ae2 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1567 | if (iCount > 0) | DATA_OP | request.Parameters["p_request_dept_id"] | p_request_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-92a83a64 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1568 | if (iCount > 0) | DATA_OP | request.Parameters["p_approval_id"] | p_approval_id | 행/컬럼 값 대입 |  |  |  |
| AC-78f36161 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1569 | if (iCount > 0) | DATA_OP | request.Parameters["p_approval_dept_id"] | p_approval_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-e4e0dc3f | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1570 | if (iCount > 0) | DATA_OP | request.Parameters["p_change_reason"] | p_change_reason | 행/컬럼 값 대입 |  |  |  |
| AC-7adce925 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1571 | if (iCount > 0) | DATA_OP | request.Parameters["p_reason_detail"] | p_reason_detail | 행/컬럼 값 대입 |  |  |  |
| AC-51c1631e | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1572 | if (iCount > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-85a3242f | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1573 | if (iCount > 0) | DATA_OP | request.Parameters["p_main_confirm_id"] | p_main_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-17706f73 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1574 | if (iCount > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-4daf0c28 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1575 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_confirm_id"] | p_new_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-091c9b81 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1577 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-57c86a24 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1578 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-24221915 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1579 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-5a7fe85f | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1580 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-fc33b7c4 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1581 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-b42c7f8c | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1582 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-c3651d4d | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1583 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-5a8328c9 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1584 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-c4a0ab8b | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1585 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-3b94897a | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1586 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_lt_day"] | p_new_lt_day | 행/컬럼 값 대입 |  |  |  |
| AC-08b3bd00 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1588 | if (iCount > 0) | DATA_OP | request.Parameters["p_change_status"] | sChangeStatus | 행/컬럼 값 대입 |  |  |  |
| AC-b237d5dc | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1589 | if (iCount > 0) | DATA_OP | request.Parameters["p_ship_status"] | sShipStatus | 행/컬럼 값 대입 |  |  |  |
| AC-251e2037 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1590 | if (iCount > 0) | DATA_OP | request.Parameters["p_change_req_no"] | p_change_req_no | 행/컬럼 값 대입 |  |  |  |
| AC-e7232f94 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1591 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-6ae01a70 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1592 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-2a7a98bc | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1593 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-3e842b00 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1594 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_ship_date"] | p_new_ship_date | 행/컬럼 값 대입 |  |  |  |
| AC-878da0b3 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1595 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_qty"] | p_new_qty | 행/컬럼 값 대입 |  |  |  |
| AC-114ac434 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1596 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_yn"] | p_new_yn | 행/컬럼 값 대입 |  |  |  |
| AC-5c285123 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1597 | if (iCount > 0) | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-8481f9c4 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1598 | if (iCount > 0) | DATA_OP | request.Parameters["p_if_send_flag"] | p_if_send_flag | 행/컬럼 값 대입 |  |  |  |
| AC-a9831d02 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1599 | if (iCount > 0) | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-3f6c7f17 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1600 | if (iCount > 0) | DATA_OP | request.Parameters["p_plan_confirm_id"] | p_plan_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-59063fc7 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1602 | if (iCount > 0) | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-208996d6 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1603 | if (iCount > 0) | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-c203d537 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1604 | if (iCount > 0) | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6fc3261a | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1605 | if (iCount > 0) | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-51d27055 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1606 | if (iCount > 0) | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-b5ce9c2b | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1607 | if (iCount > 0) | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-1fe4ef67 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1608 | if (iCount > 0) | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-ef3e243f | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1609 | if (iCount > 0) | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-a27c6d72 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1611 | if (iCount > 0) | DATA_OP | request.Parameters["p_auth"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e3b2529a | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1613 | if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3c60e46c | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1618 | if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | VALUE_SET | txtRequestNo.Text | ds.Tables[0].Rows[0][1].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-7fa01710 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1623 | if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R) | MESSAGE | MessageHelper.GMessageBox | ("MSG00173") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-442e8559 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1629 | if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveConfirmID | p_confirm_id | 화면 필드/플래그 변경 |  |  |  |
| AC-18d17a90 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1630 | if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveFlag | "E" | 화면 필드/플래그 변경 |  |  |  |
| AC-3ececcb8 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1635 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | DATA_OP | ds.Tables[1].Rows[0][0].ToString().Contains | ("Unauthorized") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b8481d5 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1637 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[1].Rows[0][0].ToString().Contains("Unauthorized") == t… | MESSAGE | MessageHelper.GMessageBox | ("MSG00316") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-95af1dfe | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1642 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[1].Rows[0][0].ToString().Contains("Unauthorized")… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0002_ShipmentChangeRequest.SetButtonVisual

진입점: this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (!string.IsNullOrWhiteSpace(sRequestUser) && sRequestUser != UserInfo.UserId)] / btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (!string.IsNullOrWhiteSpace(sRequestUser) && sRequestUser != UserInfo.UserId)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2113fd1 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:839 | if (bFlag) | UI_PROP | lcChgReq.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c95af7c5 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:840 | if (bFlag) | UI_PROP | lcChgReq2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-841665b2 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:841 | if (bFlag) | UI_PROP | lcSave.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6110876c | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:842 | if (bFlag) | UI_PROP | lcDel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0891de40 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:843 | if (bFlag) | UI_PROP | lcCancel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-2096becd | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:844 | if (bFlag) | UI_PROP | lcAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-feaa2186 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:845 | if (bFlag) | UI_PROP | lcDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-28afd8ea | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:849 | else of (bFlag) | UI_PROP | lcChgReq.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-69852051 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:850 | else of (bFlag) | UI_PROP | lcChgReq2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e83e9daf | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:851 | else of (bFlag) | UI_PROP | lcSave.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-48941d99 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:852 | else of (bFlag) | UI_PROP | lcDel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e0993783 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:853 | else of (bFlag) | UI_PROP | lcCancel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-bcc1ccb3 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:854 | else of (bFlag) | UI_PROP | lcAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c1e4c265 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 1 | SSP0002_ShipmentChangeRequest.cs:855 | else of (bFlag) | UI_PROP | lcDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest.SetChangedControl

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a6b3d42 | this.Load 외 1 | SSP0002_ShipmentChangeRequest.cs:364 |  | DATA_OP | pDivisionID.Contains | ("EE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f548a3ec | this.Load 외 1 | SSP0002_ShipmentChangeRequest.cs:366 | if (!pDivisionID.Contains("EE")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-443b8a90 | this.Load 외 1 | SSP0002_ShipmentChangeRequest.cs:366 | if (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5ea6a269 | this.Load 외 1 | SSP0002_ShipmentChangeRequest.cs:367 | if (!pDivisionID.Contains("EE")) | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.SSPToSiteByDivision, false, clbDivision.ControlValues, UserI… | 화면 필드/플래그 변경 |  |  |  |
| AC-fb604973 | this.Load 외 1 | SSP0002_ShipmentChangeRequest.cs:367 | if (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSPToSiteByDivision, false, clbDivision.ControlValues, UserInfoContext.Curr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fad8d8d8 | this.Load 외 1 | SSP0002_ShipmentChangeRequest.cs:371 | else of (!pDivisionID.Contains("EE")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-dafb8540 | this.Load 외 1 | SSP0002_ShipmentChangeRequest.cs:371 | else of (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ca25945e | this.Load 외 1 | SSP0002_ShipmentChangeRequest.cs:372 | else of (!pDivisionID.Contains("EE")) | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ShipmentPlanToSite, false, pDivisionID, UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-2ab5b9e2 | this.Load 외 1 | SSP0002_ShipmentChangeRequest.cs:372 | else of (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanToSite, false, pDivisionID, UserInfoContext.Current["NowGroupID… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b643f272 | this.Load 외 1 | SSP0002_ShipmentChangeRequest.cs:376 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, this.clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-96700620 | this.Load 외 1 | SSP0002_ShipmentChangeRequest.cs:379 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0002_ShipmentChangeRequest.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c0ef679 | (진입점 미연결) | SSP0002_ShipmentChangeRequest.cs:1998 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ab301585 | (진입점 미연결) | SSP0002_ShipmentChangeRequest.cs:2001 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fa0f9e9c | (진입점 미연결) | SSP0002_ShipmentChangeRequest.cs:2005 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-683e3096 | (진입점 미연결) | SSP0002_ShipmentChangeRequest.cs:2006 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest.SetChangeRequestInfo

진입점: this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_P \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (ds.Tables[1].Rows.Count > 0)] / btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52fb923c | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1327 |  | FLAG | sApprovalDeptID | dt.Rows[0]["APPROVAL_DEPT"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8c3826fb | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1332 |  | VALUE_SET | txtRequestNo.Text | sRequestNo | 컨트롤 값 설정 |  |  |  |
| AC-9851b4f6 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1333 |  | VALUE_SET | txtRequestor.Text | sRequestorName | 컨트롤 값 설정 |  |  |  |
| AC-390b04a3 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1334 |  | VALUE_SET | txtRequestDeptName.Text | sRequestDeptName | 컨트롤 값 설정 |  |  |  |
| AC-c531f8b1 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1335 |  | FLAG | _sRequestNo | sRequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-13046919 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1339 | if (!bReadOnly) | FLAG | sRequestID | sRequestorID | 화면 필드/플래그 변경 |  |  |  |
| AC-fc8d10e2 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1340 | if (!bReadOnly) | FLAG | sRequestName | sRequestorName + "(" + sRequestID + ")" | 화면 필드/플래그 변경 |  |  |  |
| AC-17a6ec10 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1342 | if (!bReadOnly) | STATE | txtTitle.ReadOnly | false | 컨트롤 상태 ReadOnly |  |  |  |
| AC-7e021c25 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1343 | if (!bReadOnly) | UI_PROP | lcAppDept.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-756b81be | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1344 | if (!bReadOnly) | STATE | cboChangeReason.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cb39ded4 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1345 | if (!bReadOnly) | STATE | txtReasonDetail.ReadOnly | false | 컨트롤 상태 ReadOnly |  |  |  |
| AC-4cff08c0 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1350 | else of (!bReadOnly) | STATE | txtTitle.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-861eb330 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1351 | else of (!bReadOnly) | UI_PROP | lcAppDept.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-989053c4 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1352 | else of (!bReadOnly) | STATE | cboChangeReason.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4f42ed02 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1353 | else of (!bReadOnly) | STATE | txtReasonDetail.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-bc6ecede | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1356 |  | VALUE_SET | txtTitle.Text | sTitle | 컨트롤 값 설정 |  |  |  |
| AC-80b38f72 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1358 |  | VALUE_SET | txtApproval.Text | sApprovalUserName | 컨트롤 값 설정 |  |  |  |
| AC-db07b306 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1359 |  | FLAG | sApprovalID | sApproval | 화면 필드/플래그 변경 |  |  |  |
| AC-fcaa1949 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1361 |  | VALUE_SET | txtAppDeptName.Text | sApprovalDeptName | 컨트롤 값 설정 |  |  |  |
| AC-d5c70101 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1362 |  | VALUE_SET | cboChangeReason.SelectedValue | sChaneReason | 컨트롤 값 설정 |  |  |  |
| AC-b0f79489 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1363 |  | VALUE_SET | txtReasonDetail.Text | sReasonDetail | 컨트롤 값 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest.SetChangeRequestSOGrid

진입점: this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_P \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly)] / btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly)] / btnChangeRe.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly)] / btnChangeRe2.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly)] / b…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd84262d | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1368 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bfda06e0 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1369 |  | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e6917ebc | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1371 |  | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(CAppSetting.StringAction), siSub.GetColumnIndex(DefColumns.NEW_ETA),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cfdee40d | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1375 | for (i < siSub.ActiveSheet.RowCount) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(CAppSetting.StringAction)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0a93df1c | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1379 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.SetText | (i, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-d50cedb3 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1380 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-564b222d | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1381 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-e03b276c | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1382 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Lock… | true | 그리드 속성/값 설정 |  |  |  |
| AC-d8e96401 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1383 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Back… | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-2e3b138c | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1388 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.SetText | (i, siMain.GetColumnIndex(CAppSetting.StringAction), CAppSetting.FlagM) | 그리드 값 설정 |  |  |  |
| AC-e8da6f76 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1392 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ if (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-955a3f06 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1393 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ if (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].BackColor | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-716d57a2 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1394 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ if (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.CHK)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-da9c6f35 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1398 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ else of (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.CHK)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-ad5bb1f9 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1399 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ else of (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-97130683 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1400 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ else of (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-61afd20f | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1402 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-e1aa3793 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1403 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)].BackColor | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-24b2e132 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1404 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Lock… | false | 그리드 속성/값 설정 |  |  |  |
| AC-e86c1998 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1405 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Back… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-d8f9d3b5 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1408 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.REMARKS2)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-2011f66d | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1409 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.REMARKS2)].BackColor | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-2d08db3e | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1410 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.REMARKS3)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-e95e8a6e | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1411 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.REMARKS3)].BackColor | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest.SetDeleteMainStatus

진입점: this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_P \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly) ▸ else of (sRequest_Status == "C" \|\| sRequest_Status == "P") ▸ if (sRequest_Status == "D") ▸ if (!string.IsNullOrWhiteSpace(sSaveConfirmID)) ▸ else of (!GetErpIFCheck()) ▸ if (bDeleClickYn)] / btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ else of (sRequest_Sta…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f84e0ac | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1923 | for (i < strConfirmID.Length) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sConfirmID == sChkConfirmID) ▸ if (cboChangeType.SelectedValu… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS), Shipment_Status.S_Status_C) | 그리드 값 설정 |  |  |  |
| AC-28a48978 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1925 | for (i < strConfirmID.Length) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sConfirmID == sChkConfirmID) ▸ else of (cboChangeType.Selecte… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS), Shipment_Status.S_Status_P) | 그리드 값 설정 |  |  |  |
| AC-dd0ae81f | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1927 | for (i < strConfirmID.Length) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sConfirmID == sChkConfirmID) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER), "") | 그리드 값 설정 |  |  |  |
| AC-5ceef523 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1928 | for (i < strConfirmID.Length) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sConfirmID == sChkConfirmID) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-d7910931 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1929 | for (i < strConfirmID.Length) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sConfirmID == sChkConfirmID) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_TIME), "") | 그리드 값 설정 |  |  |  |
| AC-15b43b45 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1930 | for (i < strConfirmID.Length) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sConfirmID == sChkConfirmID) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO), "") | 그리드 값 설정 |  |  |  |
| AC-3318fed0 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:1931 | for (i < strConfirmID.Length) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sConfirmID == sChkConfirmID) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest.SetMainStatus

진입점: this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_P \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly) ▸ if (bIFFalg)] / btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ if (bIFFalg)] / btnChangeRe.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ if (bIFFalg)] / btnChangeRe2.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0]…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68218643 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2417 | if (bDeleClickYn) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb67a588 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2425 | for (iRow < siMain.ActiveSheet.RowCount) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-028899db | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2428 |  | FLAG | sMainConfirmID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-3be2c1ef | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2441 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS), sShipStatus) | 그리드 값 설정 |  |  |  |
| AC-f7685510 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2442 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER), sRequestID) | 그리드 값 설정 |  |  |  |
| AC-55a465d2 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2443 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER_NAME), sRequestName) | 그리드 값 설정 |  |  |  |
| AC-747355b2 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2444 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_TIME), DateTime.Now) | 그리드 값 설정 |  |  |  |
| AC-926d009a | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2445 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO), txtRequestNo.Text) | 그리드 값 설정 |  |  |  |
| AC-db417f64 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2446 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-f282763d | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2457 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | DATA_OP | (siSub.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eec60837 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2460 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLAN_CONFIRM_ID), dr[DefColumns.CONFIRM_ID].ToStri… | 그리드 값 설정 |  |  |  |
| AC-4f6e2b17 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2465 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS), sShipStatus) | 그리드 값 설정 |  |  |  |
| AC-126a0a9d | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2466 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER), sRequestID) | 그리드 값 설정 |  |  |  |
| AC-9408fcdb | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2467 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER_NAME), sRequestName) | 그리드 값 설정 |  |  |  |
| AC-bca95b35 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2468 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_TIME), DateTime.Now) | 그리드 값 설정 |  |  |  |
| AC-643108c6 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2469 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO), txtRequestNo.Text) | 그리드 값 설정 |  |  |  |
| AC-4e615dcd | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2470 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-f4e3aa3a | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2478 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS), sShipStatus) | 그리드 값 설정 |  |  |  |
| AC-d40d8be0 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2479 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER), sRequestID) | 그리드 값 설정 |  |  |  |
| AC-8c4ef79e | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2480 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER_NAME), sRequestName) | 그리드 값 설정 |  |  |  |
| AC-16481a76 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2481 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_TIME), DateTime.Now) | 그리드 값 설정 |  |  |  |
| AC-dd5d15d2 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2482 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO), txtRequestNo.Text) | 그리드 값 설정 |  |  |  |
| AC-bcb89588 | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2483 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest.SetStatus

진입점: this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_Status_C \|\| sStatus == Shipment_Status.S_Status_P \|\| sStatus == Shipment_Status.S_Status_D) ▸ if (!bReadOnly) ▸ if (sRequest_Status == "C" \|\| sRequest_Status == "P")] / btnSave.Click / btnChangeRe.Click / btnChangeRe2.Click / btnAdd.Click [if (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!bReadOnly) ▸ if (sRequest_Status == "C" \|\| sRequest_Status == "P")] / btnDel.Click [if (iCoun…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-446aa44a | this.spdMain.CellDoubleClick [try ▸ if (siMain.IsLock(siMain… 외 7 | SSP0002_ShipmentChangeRequest.cs:2387 |  | FLAG | sMainConfirmID | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest.shtSub_Change

진입점: dsdm.Changed / dsdmSub.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fc41691 | dsdm.Changed 외 1 | SSP0002_ShipmentChangeRequest.cs:2600 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)) ▸ if (dBaseDate > dShipDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-369f923a | dsdm.Changed 외 1 | SSP0002_ShipmentChangeRequest.cs:2602 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)) ▸ if (dBaseDate > dShipDate) | GRID_SET | siSub.SetValue | (e.Row, e.Column, dSoSelDate.ToString("yyyy-MM-dd")) | 그리드 값 설정 |  |  |  |
| AC-1c8b822d | dsdm.Changed 외 1 | SSP0002_ShipmentChangeRequest.cs:2606 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)) ▸ if (dBaseDate > dShipDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9eb9640b | dsdm.Changed 외 1 | SSP0002_ShipmentChangeRequest.cs:2619 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)) ▸ for (i < siSub.ActiveSheet.RowCount) | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-2e7fa506 | dsdm.Changed 외 1 | SSP0002_ShipmentChangeRequest.cs:2620 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)) ▸ for (i < siSub.ActiveSheet.RowCount) | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-44d619d5 | dsdm.Changed 외 1 | SSP0002_ShipmentChangeRequest.cs:2621 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)) ▸ for (i < siSub.ActiveSheet.RowCount) | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-1a337f09 | dsdm.Changed 외 1 | SSP0002_ShipmentChangeRequest.cs:2622 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)) ▸ for (i < siSub.ActiveSheet.RowCount) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].ForeColor | ControlColor.MarkedForeColor | 그리드 속성/값 설정 |  |  |  |

## SSP0002_ShipmentChangeRequest.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick / btnNew.Click [if (popup.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8efbeb2a | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2043 |  | FLAG | RollBack_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f70ce517 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2048 | try ▸ if (chkERPIFBlockYn()) | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-5ed35892 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2049 | try ▸ if (chkERPIFBlockYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bdc1819e | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2055 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f5dba6dc | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2084 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (sErpStatus == "C") | MESSAGE | MessageHelper.GMessageBox | ("MSG00189") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dbcbc721 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2085 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (sErpStatus == "C") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96ef4138 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2108 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (sStatus == Shipment_Status.S_Status_C && dBaseDate > dShipDate && cboChangeReason.S… | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eb15df08 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2109 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (sStatus == Shipment_Status.S_Status_C && dBaseDate > dShipDate && cboChangeReason.S… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-69045fc4 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2112 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) | FLAG | iSelRow | e_Row | 화면 필드/플래그 변경 |  |  |  |
| AC-943d0697 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2113 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) | FLAG | iSelCol | e_Col | 화면 필드/플래그 변경 |  |  |  |
| AC-16fb731b | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2115 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5708ca23 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2123 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (string.IsNullOrWhiteSpace(sSt… | MESSAGE | MessageHelper.GMessageBox | ("MSG00176") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-95dfa07b | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2125 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (string.IsNullOrWhiteSpace(sSt… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53c127d6 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2132 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_… | MESSAGE | MessageHelper.GMessageBox | ("MSG00174") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-52c41449 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2134 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5dd73ecc | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2147 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-5c0f139d | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2147 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eb4d9ed7 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2182 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.Sheet().Rows.Count > 0)… | MESSAGE | MessageHelper.GMessageBox | ("MSG00186") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d849e227 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2184 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.Sheet().Rows.Count > 0)… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cb5a253b | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2195 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus != Shipment_Status.S_… | MESSAGE | MessageHelper.GMessageBox | ("MSG00188") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-132f0a1e | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2198 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus != Shipment_Status.S_… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec9f1260 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2204 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus != Shipment_Status.S_… | MESSAGE | MessageHelper.GMessageBox | ("MSG00221") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0fa18809 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2207 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus != Shipment_Status.S_… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5aa0e1f | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2213 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | FLAG | sChangeStatus | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-299d59cb | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2214 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | FLAG | sShipStatus | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-4588719e | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2215 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | FLAG | sSearchType | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-4ee6ecbe | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2216 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | FLAG | _sRequestNo | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-e803cbed | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2217 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | FLAG | bIFFalg | true | 화면 필드/플래그 변경 |  |  |  |
| AC-99e833d0 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2221 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sStatus == Shipment_Status.S_… | FLAG | bErpIFCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0bc72f72 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2225 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (sStatus == Shipment_Stat… | FLAG | bErpIFCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cb6dae1f | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2229 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.T… | FLAG | bErpIFCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e5994e07 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2234 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (!string.IsNullOrWhiteSpace(sR… | FLAG | bReadOnly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c68134bc | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2241 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | FLAG | bReadOnly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f0a1dee0 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2250 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ce23f11 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2251 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-902652b3 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2256 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | FLAG | bReadOnly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5dc0a06e | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2263 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | CALL_EXT | lcSave.Move | (dragController) | ⚠ 의미 확인 필요 |  |  |  |
| AC-12bf59ae | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2265 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | UI_PROP | lcAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d2a5d4e7 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2266 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | UI_PROP | lcDel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-186bf271 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2267 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | UI_PROP | lcDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b8b18883 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2269 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | UI_PROP | lcChgReq2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-88996230 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2270 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | FLAG | sSearchType | SearchType.Type_E | 화면 필드/플래그 변경 |  |  |  |
| AC-4372e7a4 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2275 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | CALL_EXT | lcSave.Move | (dragController) | ⚠ 의미 확인 필요 |  |  |  |
| AC-589b73f0 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2276 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | UI_PROP | lcAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c659f3ab | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2277 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | UI_PROP | lcDel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4e39c8aa | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2278 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | UI_PROP | lcDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0b7aa7d1 | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2279 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | UI_PROP | lcChgReq2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-20067ead | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2280 | try ▸ if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (!string.IsNullOrWhiteSpa… | FLAG | sSearchType | SearchType.Type_N | 화면 필드/플래그 변경 |  |  |  |
| AC-98a7e6dc | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2292 | try | FLAG | iOld_SelRow | iSelRow | 화면 필드/플래그 변경 |  |  |  |
| AC-9a0ca4aa | this.spdMain.CellDoubleClick 외 1 | SSP0002_ShipmentChangeRequest.cs:2293 | try | FLAG | iOld_SelCol | iSelCol | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest.SpdMain_CursorChanged

진입점: spdMain.CursorChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80039fd3 | spdMain.CursorChanged | SSP0002_ShipmentChangeRequest.cs:288 | if (RollBack_Flag == true) ▸ if (iOld_SelRow != -1 \|\| iOld_SelCol != -1) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iOld_SelRow, iOld_SelCol) | 그리드 표시 설정 |  |  |  |
| AC-164033ec | spdMain.CursorChanged | SSP0002_ShipmentChangeRequest.cs:289 | if (RollBack_Flag == true) ▸ if (iOld_SelRow != -1 \|\| iOld_SelCol != -1) | CALL_EXT | spdMain.ShowCell | (0, 0, this.iOld_SelRow, this.iOld_SelCol, FarPoint.Win.Spread.VerticalPosition.Center, Fa… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f18fba4 | spdMain.CursorChanged | SSP0002_ShipmentChangeRequest.cs:291 | if (RollBack_Flag == true) ▸ if (iOld_SelRow != -1 \|\| iOld_SelCol != -1) | FLAG | RollBack_Flag | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10091ac9 | spdMain.TopChange | SSP0002_ShipmentChangeRequest.cs:2546 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0002_ShipmentChangeRequest.SpdSub_CellClick

진입점: this.spdSub.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67b5ba41 | this.spdSub.CellClick | SSP0002_ShipmentChangeRequest.cs:2307 | if (siSub.Sheet().Rows.Count > 0) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), dtTransMode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-772cede2 | this.spdSub.CellClick | SSP0002_ShipmentChangeRequest.cs:2311 | if (siSub.Sheet().Rows.Count > 0) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (e.Column == siSub.GetCol… | FLAG | dSoSelDate | Convert.ToDateTime(siSub.GetValue(e.Row, e.Column)) | 화면 필드/플래그 변경 |  |  |  |

## SSP0002_ShipmentChangeRequest.SpdSub_ComboSelChange

진입점: this.spdSub.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4777f4b9 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2322 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) | DATA_OP | dtTransMode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a4c12a8e | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2346 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_ROUTE_ID), sRouteID) | 그리드 값 설정 |  |  |  |
| AC-34f780c9 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2347 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_BOD_ID), sBodID) | 그리드 값 설정 |  |  |  |
| AC-e31aa6e4 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2348 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_INCOTERMS), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-c798e711 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2349 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_D_COUNTRY), sDCountry) | 그리드 값 설정 |  |  |  |
| AC-cf1bcef4 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2350 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_D_PORT_CODE), sDPortCode) | 그리드 값 설정 |  |  |  |
| AC-7b636cbc | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2351 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_A_COUNTRY), sACountry) | 그리드 값 설정 |  |  |  |
| AC-0db9ea83 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2352 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_A_PORT_CODE), sAPortCode) | 그리드 값 설정 |  |  |  |
| AC-37fcb7ba | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2353 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_TO_COUNTRY), sToCountry) | 그리드 값 설정 |  |  |  |
| AC-38c96a3e | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2354 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_TO_CITY), sToCity) | 그리드 값 설정 |  |  |  |
| AC-2f2bfb4d | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2355 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-cdce55eb | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2356 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), dLT) | 그리드 값 설정 |  |  |  |
| AC-e459d165 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2362 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_ROUTE_ID), sRouteID) | 그리드 값 설정 |  |  |  |
| AC-fd07f646 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2363 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_BOD_ID), sBodID) | 그리드 값 설정 |  |  |  |
| AC-60fc6c7e | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2364 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_INCOTERMS), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-879710c2 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2365 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_D_COUNTRY), sDCountry) | 그리드 값 설정 |  |  |  |
| AC-7ff6d514 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2366 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_D_PORT_CODE), sDPortCode) | 그리드 값 설정 |  |  |  |
| AC-8f76db44 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2367 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_A_COUNTRY), sACountry) | 그리드 값 설정 |  |  |  |
| AC-fb375daf | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2368 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_A_PORT_CODE), sAPortCode) | 그리드 값 설정 |  |  |  |
| AC-9c768ee6 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2369 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_TO_COUNTRY), sToCountry) | 그리드 값 설정 |  |  |  |
| AC-78ae5d58 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2370 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_TO_CITY), sToCity) | 그리드 값 설정 |  |  |  |
| AC-4af8f987 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2371 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-afa85d23 | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2372 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), dLT) | 그리드 값 설정 |  |  |  |
| AC-d1c53b1e | this.spdSub.ComboSelChange | SSP0002_ShipmentChangeRequest.cs:2373 | if (e.Column == siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siSub.Active… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), sNewTransMode) | 그리드 값 설정 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.BodValidChk

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save) ▸ try] / SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e24e536 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:503 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_BOD_VALID_CHECK") ⇒ SSP.SSP0002_GET_BOD_VALID_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-f4189f22 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:504 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-87d94097 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:505 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-415c1109 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:506 | try | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-3a24c6c7 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:507 | try | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-0c7cf9c7 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:508 | try | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-e1f14191 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:509 | try | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-70323b11 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:511 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-49593b0b | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:519 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | bSaveCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d3d267b4 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:524 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00293", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-78048c9d | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:525 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a1d08dd9 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:531 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | bSaveCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f40e9d8f | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:535 | try ▸ else of (ds.Tables[1].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00293", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3bf066af | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:536 | try ▸ else of (ds.Tables[1].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ef1e4395 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:543 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4875a033 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:545 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2c0ad49 | this.btnButtonList.UsrButtonList_Click_Detected | SSP0002_ShipmentConfirmInsertPopup.cs:601 | if (buttonItem.UserType == ButtonListType.Save) ▸ if (!bSaveCheck) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc260709 | this.btnButtonList.UsrButtonList_Click_Detected | SSP0002_ShipmentConfirmInsertPopup.cs:608 | else of (buttonItem.UserType == ButtonListType.Save) ▸ if (buttonItem.UserType == ButtonListType.Cancel) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b052c68 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:190 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-871e3ea7 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:191 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f94dad4b | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:192 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a935f39 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:166 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-4128c20d | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:168 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-f5f73bd2 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:169 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-fa9f582a | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:170 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78db4fe7 | Dispose | SSP0002_ShipmentConfirmInsertPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37120a5f | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:142 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-762c21cc | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:150 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3480eea | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:1449 |  | ENDPOINT | new FoxDataRequest | ("SCP.GET_DATE_RANGE_1MONTH") ⇒ SCP.GET_DATE_RANGE_1MONTH | 엔드포인트 요청 생성 |  |  |  |
| AC-1c39bb6b | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:1451 |  | DATA_OP | request.Parameters["p_from_date"] | sFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-e713e9ff | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:1452 |  | DATA_OP | request.Parameters["p_offset_day"] | "1" | 행/컬럼 값 대입 |  |  |  |
| AC-ac614119 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:1453 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-84b7b7c4 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:1454 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-01b83d86 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:1457 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6d956a1 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:175 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7dbc6d91 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:181 | if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-1feeee44 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:183 |  | FLAG | dBaseDate | Convert.ToDateTime(dtTime).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-31e2aef1 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:185 |  | FLAG | dtDivision | dtDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-61611434 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:185 |  | DATA_OP | dtDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2be3d633 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:185 |  | DATA_OP | dtDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5a21f21 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:201 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-9f12158c | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:203 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c8c1ac1b | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:204 |  | GRID_INIT | siMain.AddComboColumn | ("Div*", DefColumns.DIVISION_ID, FPMerge.None, 100, true, dtDivision, FPHAlign.Left, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f51e97c | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:205 |  | GRID_INIT | siMain.AddComboColumn | ("From Site*", DefColumns.FROM_SITE, FPMerge.None, 130, true, dtFromSite, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a19b1f0c | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:206 |  | GRID_INIT | siMain.AddComboColumn | ("To Site*", DefColumns.TO_SITE, FPMerge.None, 130, true, dtToSite, FPHAlign.Left, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d5d441a2 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:207 |  | GRID_INIT | siMain.AddComboColumn | ("End Customer*", DefColumns.PROJECT_CODE40, FPMerge.None, 80, true, dtEndCustomer, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c310c255 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:208 |  | GRID_INIT | siMain.AddTextColumn | ("Project", DefColumns.PROJECT_CODE, FPMerge.None, 80, true, FPHAlign.Left, FPVAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e0a0c207 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:209 |  | GRID_INIT | siMain.AddComboColumn | ("FCST Type* ", DefColumns.FCST_TYPE, FPMerge.None, 80, true, dtFcstType, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb337c3d | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:210 |  | GRID_INIT | siMain.AddComboColumn | ("Model*", DefColumns.ITEM_ID, FPMerge.None, 150, true, dtItem, FPHAlign.Left, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2f4bead7 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:211 |  | GRID_INIT | siMain.AddComboColumn | ("Operation Group*", DefColumns.OPERATION_GROUP, FPMerge.None, 70, true, dtOperationGroup,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bbabd471 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:212 |  | GRID_INIT | siMain.AddTextColumn | ("Nick Name", DefColumns.NICK_NAME, FPMerge.None, 100, true, FPHAlign.Left, FPVAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b2ba232d | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:213 |  | GRID_INIT | siMain.AddDateColumn | ("Shipment Date*", DefColumns.SHIPMENT_DATE, FPMerge.None, 80, true, FPHAlign.Left, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7fba12c2 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:214 |  | GRID_INIT | siMain.AddNumColumn | ("Qty* ", DefColumns.SHIPMENT_QTY, FPMerge.None, 60, true, FPHAlign.Right, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8cc6bbef | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:215 |  | GRID_INIT | siMain.AddComboColumn | ("Incoterms*", DefColumns.INCOTERMS, FPMerge.None, 70, true, dtIncoterms, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aaeea505 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:216 |  | GRID_INIT | siMain.AddComboColumn | ("Trans Mode* ", DefColumns.TRANSPORT_MODE, FPMerge.None, 70, true, dtTransMode, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-22c4c2f0 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:217 |  | GRID_INIT | siMain.AddNumColumn | ("L/T(Day)", DefColumns.LT, FPMerge.None, 60, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-83f7990e | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:218 |  | GRID_INIT | siMain.AddDateColumn | ("ETD", DefColumns.ETD, FPMerge.None, 80, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ef963724 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:219 |  | GRID_INIT | siMain.AddDateColumn | ("ETA", DefColumns.ETA, FPMerge.None, 80, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-573a1edf | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:221 |  | GRID_INIT | siMain.AddTextColumn | ("ROUTE_ID", DefColumns.ROUTE_ID, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4319c4f5 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:222 |  | GRID_INIT | siMain.AddTextColumn | ("BOD_ID", DefColumns.BOD_ID, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c2578746 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:223 |  | GRID_INIT | siMain.AddTextColumn | ("D_COUNTRY", DefColumns.D_COUNTRY, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ebdad548 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:224 |  | GRID_INIT | siMain.AddTextColumn | ("D_PORT_CODE", DefColumns.D_PORT_CODE, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-25c6ab4b | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:225 |  | GRID_INIT | siMain.AddTextColumn | ("A_COUNTRY", DefColumns.A_COUNTRY, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e92b268c | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:226 |  | GRID_INIT | siMain.AddTextColumn | ("A_PORT_CODE", DefColumns.A_PORT_CODE, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6e0a01c3 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:227 |  | GRID_INIT | siMain.AddTextColumn | ("TO_COUNTRY", DefColumns.TO_COUNTRY, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6240d301 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:228 |  | GRID_INIT | siMain.AddTextColumn | ("TO_CITY", DefColumns.TO_CITY, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e47a26ea | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:230 |  | GRID_INIT | siMain.AddTextColumn | ("ELECTRODE_YN", DefColumns.ELECTRODE_YN, FPMerge.None, 100, false, FPHAlign.Left, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-330739b2 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:231 |  | GRID_INIT | siMain.AddTextColumn | ("ORIGIN_FROM_DIVISION_ID", DefColumns.ORIGIN_FROM_DIVISION_ID, FPMerge.None, 100, false, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ab3a0883 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:232 |  | GRID_INIT | siMain.AddTextColumn | ("ORIGIN_TO_DIVISION_ID", DefColumns.ORIGIN_TO_DIVISION_ID, FPMerge.None, 100, false, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-31407ef2 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:234 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NICK_NAME),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4db381c3 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:235 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LT), siMain.GetColumnIndex(DefColumns.TO_CITY), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-346dfc13 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:237 |  | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(DefColumns.SHIPMENT_QTY), 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-10003ec0 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:240 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.InsertRow

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af366204 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:271 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d7feb7fe | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:272 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-5585d4aa | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:274 |  | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bdecd670 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:277 |  | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-19c15864 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:278 |  | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LT), siMain.GetColumnIndex(DefColumns.ETA), tru… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.PlantSiteChk

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save) ▸ try ▸ if (p_division_id.ToString() == "81" \|\| p_division_id.ToString() == "82")] / spdMain.ComboSelChange [else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (dtOriginDivFromTo.Rows.Count > 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)).ToString() == "E")] / SaveButton [try ▸ if (p_division_id.ToString() == "81…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-340dc7ef | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:561 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_PLANT_SITE_CHECK") ⇒ SSP.SSP0002_GET_PLANT_SITE_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-c1357488 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:562 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-0798b1bb | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:563 | try | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-0842742c | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:565 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-303937c2 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:582 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-85c93d7d | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:585 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save)] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bad2290 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:301 | try ▸ if (p_division_id!="" && p_division_id!="40") | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), "-") | 그리드 값 설정 |  |  |  |
| AC-72746c6d | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:304 | try | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-87eedd6d | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:306 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-dc3d068b | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:307 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b940e23 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:310 | try ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | bSaveCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-366f04f7 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:327 | try ▸ if (p_division_id.ToString() == "81" \|\| p_division_id.ToString() == "82") ▸ if (!PlantSiteChk()) ▸ if (p_project_code == "" \|\| p_p… | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ec062d7e | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:329 | try ▸ if (p_division_id.ToString() == "81" \|\| p_division_id.ToString() == "82") ▸ if (!PlantSiteChk()) ▸ if (p_project_code == "" \|\| p_p… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6bde0b4b | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:330 | try ▸ if (p_division_id.ToString() == "81" \|\| p_division_id.ToString() == "82") ▸ if (!PlantSiteChk()) ▸ if (p_project_code == "" \|\| p_p… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-43d5497a | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:344 | try ▸ else of (DateTime.TryParse(siMain.GetText(0, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)).ToString(), out temp) == true) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-33f5a6d6 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:345 | try ▸ else of (DateTime.TryParse(siMain.GetText(0, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)).ToString(), out temp) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4a167dd | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:350 | try ▸ if (!BodValidChk()) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-864b94f5 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:351 | try ▸ if (!BodValidChk()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-699c6a1d | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:384 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-06045be8 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:386 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_SAVE_SHIPMENT_CONFIRM_NEW") ⇒ SSP.SSP0002_SAVE_SHIPMENT_CONFIRM_NEW | 엔드포인트 요청 생성 |  |  |  |
| AC-581c34ed | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:390 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7435d5d7 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:394 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa86905b | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:395 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-896420c2 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:396 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-09696a9b | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:398 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda ▸ if (p_division_id == "40") | DATA_OP | request.Parameters["p_project_code"] | p_project_code40 | 행/컬럼 값 대입 |  |  |  |
| AC-1cbe249f | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:400 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda ▸ else of (p_division_id == "40") | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-0b6eef68 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:401 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-131d3a80 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:402 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-e19c624e | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:403 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-227cbffe | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:404 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-a1213361 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:405 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-fff662db | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:406 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-1afcde8a | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:407 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-7c56d335 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:408 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-9ade817b | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:409 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_lt"] | p_lt | 행/컬럼 값 대입 |  |  |  |
| AC-8ec8c281 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:410 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_etd"] | p_etd | 행/컬럼 값 대입 |  |  |  |
| AC-e0fae0ec | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:411 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_eta"] | p_eta | 행/컬럼 값 대입 |  |  |  |
| AC-f52d5b42 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:412 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_route_id"] | p_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-9363901e | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:413 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-7c221349 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:414 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_d_country"] | p_d_country | 행/컬럼 값 대입 |  |  |  |
| AC-824f7343 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:415 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_d_port_code"] | p_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-eb07f83a | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:416 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_a_conuntry"] | p_a_conuntry | 행/컬럼 값 대입 |  |  |  |
| AC-26f6ac68 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:417 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_a_port_code"] | p_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-ae2943a5 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:418 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_to_country"] | p_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-fd2d7df3 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:420 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_to_city"] | p_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-8030ef76 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:421 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-1be76521 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:422 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4a714649 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:423 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_origin_to_division_id"] | p_origin_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa286f5a | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:424 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-525f013f | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:425 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_time_zone"] | _TimeZone | 행/컬럼 값 대입 |  |  |  |
| AC-9f1776ec | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:427 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f9d35387 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:429 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-63043647 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:429 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-8d26eae3 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:438 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S"… | FLAG | _ConfrimID | t.DataSet.Tables[0].Rows[0][1].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-dbbda288 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:439 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S"… | FLAG | _ShipmentDate | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9abd8a21 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:442 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S"… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3c454aad | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:444 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S"… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ad642130 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:450 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00261", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-426643c2 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:455 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00328", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c5926400 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:467 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-87d015cd | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:474 | try ▸ else of (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-633b98b1 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:475 | try ▸ else of (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-69780ca1 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:480 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8ccacfcd | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:481 | catch ((Exception ex)) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-568fb144 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0002_ShipmentConfirmInsertPopup.cs:482 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.setEndCustomer

진입점: spdMain.CellClick [else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (popItem.ItemID != "")] / spdMain.ComboSelChange [else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE))] / spdMain.ClipboardPasted [if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a38dd6d8 | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:619 | if (sDivision!="" && sToSite != "" && sItemId != "") | FLAG | dtEndCustomer | Data_SCP.Common(Data_SCP.Type.EndCustomerByItemForSSP, false, sDivision, sToSite, sItemId) | 화면 필드/플래그 변경 |  |  |  |
| AC-09a12ae7 | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:619 | if (sDivision!="" && sToSite != "" && sItemId != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.EndCustomerByItemForSSP, false, sDivision, sToSite, sItemId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-29475c2a | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:620 | if (sDivision!="" && sToSite != "" && sItemId != "") | GRID_COMBO | siMain.SetCellTypeCombo | (iROW, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-fa0b8b65 | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:623 | if (sDivision!="" && sToSite != "" && sItemId != "") ▸ if (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) | GRID_SET | siMain.SetValue | (iROW, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), dtEndCustomer.Rows[0]["CODE"].ToS… | 그리드 값 설정 |  |  |  |
| AC-9e72fbcc | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:624 | if (sDivision!="" && sToSite != "" && sItemId != "") ▸ if (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) | GRID_SET | siMain.SetText | (iROW, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), dtEndCustomer.Rows[0]["CODE"].ToS… | 그리드 값 설정 |  |  |  |
| AC-cb7315db | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:628 | if (sDivision!="" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEndC… | FLAG | dtEndCustomer | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-fdb76edd | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:629 | if (sDivision!="" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEndC… | DATA_OP | dtEndCustomer.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7b8fd855 | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:630 | if (sDivision!="" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEndC… | DATA_OP | dtEndCustomer.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-2979a138 | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:631 | if (sDivision!="" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEndC… | DATA_OP | dtEndCustomer.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-02db13dc | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:632 | if (sDivision!="" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEndC… | DATA_OP | drRow["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-d6e05cc3 | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:633 | if (sDivision!="" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEndC… | DATA_OP | drRow["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-4e153f6a | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:634 | if (sDivision!="" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEndC… | DATA_OP | dtEndCustomer.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d1d5861 | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:635 | if (sDivision!="" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEndC… | GRID_COMBO | siMain.SetCellTypeCombo | (iROW, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a66439d1 | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:636 | if (sDivision!="" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEndC… | GRID_SET | siMain.SetValue | (iROW, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), "-") | 그리드 값 설정 |  |  |  |
| AC-0f4e3d1f | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:637 | if (sDivision!="" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEndC… | GRID_SET | siMain.SetText | (iROW, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), "-") | 그리드 값 설정 |  |  |  |
| AC-cf8ba5d8 | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:642 | else of (sDivision!="" && sToSite != "" && sItemId != "") | GRID_SET | siMain.SetValue | (iROW, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), "") | 그리드 값 설정 |  |  |  |
| AC-869d08a7 | spdMain.CellClick [else of (e.Column == siMain.GetColumnInde… 외 2 | SSP0002_ShipmentConfirmInsertPopup.cs:643 | else of (sDivision!="" && sToSite != "" && sItemId != "") | GRID_SET | siMain.SetText | (iROW, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), "") | 그리드 값 설정 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.SetImageCell

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b584653 | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:286 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > -1) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-6a07ca7d | this.Load | SSP0002_ShipmentConfirmInsertPopup.cs:289 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > -1) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-108f62ec | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:660 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ if (string.IsNullOrEmpty(sToSite)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e8d61098 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:661 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ if (string.IsNullOrEmpty(sToSite)) | FLAG | dtEndCustomer | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-dfd25335 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:662 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ if (string.IsNullOrEmpty(sToSite)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), "") | 그리드 값 설정 |  |  |  |
| AC-b378e335 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:663 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ if (string.IsNullOrEmpty(sToSite)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), "") | 그리드 값 설정 |  |  |  |
| AC-ef4956d0 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:664 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ if (string.IsNullOrEmpty(sToSite)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f391cd0a | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:665 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ if (string.IsNullOrEmpty(sToSite)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07128fae | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:670 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (string.IsNullOrEmpty(sToSite)) ▸ if (string.IsNullOrEmpty(sItem… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Model") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-68cfbffc | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:671 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (string.IsNullOrEmpty(sToSite)) ▸ if (string.IsNullOrEmpty(sItem… | FLAG | dtEndCustomer | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-0851fb8d | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:672 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (string.IsNullOrEmpty(sToSite)) ▸ if (string.IsNullOrEmpty(sItem… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), "") | 그리드 값 설정 |  |  |  |
| AC-b33a9b3b | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:673 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (string.IsNullOrEmpty(sToSite)) ▸ if (string.IsNullOrEmpty(sItem… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), "") | 그리드 값 설정 |  |  |  |
| AC-c49c37f7 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:674 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (string.IsNullOrEmpty(sToSite)) ▸ if (string.IsNullOrEmpty(sItem… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7c4e995d | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:675 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (string.IsNullOrEmpty(sToSite)) ▸ if (string.IsNullOrEmpty(sItem… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2af879b5 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:687 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ i… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "-") | 그리드 값 설정 |  |  |  |
| AC-b92a94ef | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:697 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ e… | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2deeebf0 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:698 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ e… | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-51c58821 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:699 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ e… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-237fda57 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:700 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ e… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-799ecdff | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:706 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ e… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), sProjectCode) | 그리드 값 설정 |  |  |  |
| AC-d94e777c | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:728 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site*") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-08482a0b | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:730 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5c1df71 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:736 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site*") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-87e418ae | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:738 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1214e1c2 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:743 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d9d0abfd | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:748 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | POPUP | popItem.Form_Load | (false, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1ae195f3 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:749 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1adcfdae | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:750 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bd6c1413 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:756 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-1d398a9f | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:757 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), popItem.NickName) | 그리드 값 설정 |  |  |  |
| AC-edda1b73 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:768 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | FLAG | dtIncoterms | Data_SCP.Common(Data_SCP.Type.Incoterms, false, sDivision, sFromSite, sToSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-2212ba62 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:768 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Incoterms, false, sDivision, sFromSite, sToSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-83b0f89c | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:770 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), dtIncoterms) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d1980bc9 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:771 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS)].VerticalAlign… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-5c06a2dd | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:772 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS)].HorizontalAli… | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-2f9d762f | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:782 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-d44781e4 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:782 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0cf6f5b4 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:784 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), dtTransMode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a38f1865 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:785 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Vertical… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-52ccda00 | spdMain.CellClick | SSP0002_ShipmentConfirmInsertPopup.cs:786 | else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Horizont… | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.SpdMain_ClipboardPasted

진입점: spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1eee197a | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1093 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.PlantSiteByDivisionEEOperation, false, sDivisionID, UserInfo… | 화면 필드/플래그 변경 |  |  |  |
| AC-c9be052d | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1093 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteByDivisionEEOperation, false, sDivisionID, UserInfoContext.Current… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5f738703 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1094 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-5c5713d6 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1094 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0414ab2b | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1095 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ELECTRODE_YN), "N") | 그리드 값 설정 |  |  |  |
| AC-3e12b6ff | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1099 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-9e317d20 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1100 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-19e60cf3 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1104 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3b38d43a | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1105 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-486f4e6b | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1112 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.PlantSiteByDivisionEEOperation, false, sDivisionID, UserInfo… | 화면 필드/플래그 변경 |  |  |  |
| AC-80ce0abd | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1112 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteByDivisionEEOperation, false, sDivisionID, UserInfoContext.Current… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c1a7f085 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1113 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-bef02c3f | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1113 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2a9e59ba | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1116 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-26e26f7a | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1117 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-da5508c8 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1120 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.FROM_SITE), dtFromSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-aafc825e | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1121 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.TO_SITE), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6b646bff | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1123 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.FROM_SITE), "") | 그리드 값 설정 |  |  |  |
| AC-3632202b | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1124 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TO_SITE), "") | 그리드 값 설정 |  |  |  |
| AC-5a061f2c | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1125 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-a18f37e6 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1126 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), "") | 그리드 값 설정 |  |  |  |
| AC-85442c96 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1127 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.FCST_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-2c473c91 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1128 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-ced9df54 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1129 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-f9e73b2c | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1130 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-a5366838 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1131 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-f1c0d3b3 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1132 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-1f8bb3bf | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1133 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.LT), "") | 그리드 값 설정 |  |  |  |
| AC-213bcf89 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1134 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ETD), "") | 그리드 값 설정 |  |  |  |
| AC-7a5c996d | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1135 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ETA), "") | 그리드 값 설정 |  |  |  |
| AC-8df317ac | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1139 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a91164b5 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1140 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "-") | 그리드 값 설정 |  |  |  |
| AC-f1366817 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1144 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2e625140 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1153 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtOriginDivFromTo | Data_SCP.Common(Data_SCP.Type.OrigionDivFromTo, false, sFromSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-0b0e482b | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1153 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OrigionDivFromTo, false, sFromSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9bce48a7 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1158 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtIncoterms | Data_SCP.Common(Data_SCP.Type.Incoterms, false, sDivision, sFromSite, sToSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-1f1addd8 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1158 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Incoterms, false, sDivision, sFromSite, sToSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-708f59fd | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1160 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.INCOTERMS), dtIncoterms) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2527f9c4 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1161 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.INCOTERMS)].VerticalAlignm… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-bee6523e | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1162 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.INCOTERMS)].HorizontalAlig… | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-3d39e6f0 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1172 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtOriginDivFromTo | Data_SCP.Common(Data_SCP.Type.OrigionDivFromTo, false, sFromSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a8a5fba | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1172 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OrigionDivFromTo, false, sFromSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-17f74207 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1177 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-5ffc2564 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1177 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33ef91e0 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1179 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), dtTransMode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-bbe871db | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1180 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].VerticalA… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-52330d05 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1181 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Horizonta… | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-3d3cd617 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1188 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtOriginDivFromTo | Data_SCP.Common(Data_SCP.Type.OrigionDivFromTo, false, sFromSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-49c3ed54 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1188 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OrigionDivFromTo, false, sFromSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8ed7125a | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1192 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ORIGIN_FROM_DIVISION_ID), dtOriginDivFromTo.Rows[0… | 그리드 값 설정 |  |  |  |
| AC-7b9b36ec | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1201 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ORIGIN_FROM_DIVISION_ID), dtOriginDivFromTo.Rows[0… | 그리드 값 설정 |  |  |  |
| AC-25896274 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1205 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ORIGIN_FROM_DIVISION_ID), sDivisionID) | 그리드 값 설정 |  |  |  |
| AC-3e672a50 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1210 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ORIGIN_FROM_DIVISION_ID), sDivisionID) | 그리드 값 설정 |  |  |  |
| AC-5661ab5a | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1215 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), dtOriginDivFromTo.Rows[0]["OPERA… | 그리드 값 설정 |  |  |  |
| AC-89eb9cfe | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1220 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "-") | 그리드 값 설정 |  |  |  |
| AC-c3ddf978 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1221 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.FCST_TYPE), "-") | 그리드 값 설정 |  |  |  |
| AC-408e652c | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1222 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ELECTRODE_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-2356fd06 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1224 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtToSite | Data.Common(Data.Type.PlantByElectordeShipToSite_EE, false, sDivisionID, sFromSite) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite_EE] | 화면 필드/플래그 변경 |  |  |  |
| AC-eaed548b | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1224 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | COMBO_DATA | Data.Common | (Data.Type.PlantByElectordeShipToSite_EE, false, sDivisionID, sFromSite) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite_EE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7d0ab967 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1225 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.TO_SITE), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2c6b64f4 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1227 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-90982b45 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1228 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7950f680 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1229 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FCST_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-23ef7948 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1233 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-d806d777 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1233 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-07851765 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1234 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.TO_SITE), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-79db0872 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1237 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "-") | 그리드 값 설정 |  |  |  |
| AC-56dfda86 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1238 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.FCST_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-e461eb4d | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1239 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ELECTRODE_YN), "N") | 그리드 값 설정 |  |  |  |
| AC-77530a6b | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1243 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e35b65ab | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1244 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-674b0797 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1245 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FCST_TYPE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c6f78617 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1249 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-adbeebc0 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1250 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-04f889ed | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1251 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FCST_TYPE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-31a80d24 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1262 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtOriginDivFromTo | Data_SCP.Common(Data_SCP.Type.OrigionDivFromTo, false, sToSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c952bdc | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1262 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OrigionDivFromTo, false, sToSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e9b1a93d | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1267 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ORIGIN_TO_DIVISION_ID), dtOriginDivFromTo.Rows[0][… | 그리드 값 설정 |  |  |  |
| AC-543a08fb | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1276 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ORIGIN_TO_DIVISION_ID), dtOriginDivFromTo.Rows[0][… | 그리드 값 설정 |  |  |  |
| AC-5bd31894 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1280 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ORIGIN_TO_DIVISION_ID), sDivisionID) | 그리드 값 설정 |  |  |  |
| AC-18d5caf7 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1285 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ORIGIN_TO_DIVISION_ID), sDivisionID) | 그리드 값 설정 |  |  |  |
| AC-5ca721bd | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1294 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | DATA_OP | dtTransMode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a3cd3bb5 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1319 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ROUTE_ID), sRouteID) | 그리드 값 설정 |  |  |  |
| AC-f81d885e | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1320 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.BOD_ID), sBodID) | 그리드 값 설정 |  |  |  |
| AC-73d34d9d | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1321 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.INCOTERMS), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-9a28a2ad | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1322 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.D_COUNTRY), sDCountry) | 그리드 값 설정 |  |  |  |
| AC-b192030e | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1323 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.D_PORT_CODE), sDPortCode) | 그리드 값 설정 |  |  |  |
| AC-36c9eb90 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1324 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.A_COUNTRY), sACountry) | 그리드 값 설정 |  |  |  |
| AC-23a8b05b | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1325 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.A_PORT_CODE), sAPortCode) | 그리드 값 설정 |  |  |  |
| AC-936ca5a4 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1326 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TO_COUNTRY), sToCountry) | 그리드 값 설정 |  |  |  |
| AC-1763a1da | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1327 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TO_CITY), sToCity) | 그리드 값 설정 |  |  |  |
| AC-9c7e6bc1 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1328 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-98a4c500 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1329 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-0c6d9bb9 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1330 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.LT), dLT) | 그리드 값 설정 |  |  |  |
| AC-b77233ba | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1331 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), sNewTransMode) | 그리드 값 설정 |  |  |  |
| AC-da219244 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1335 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6171aeea | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1345 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5867f993 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1346 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), "") | 그리드 값 설정 |  |  |  |
| AC-7848e9db | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1347 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91a43776 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1350 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72fc425a | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1356 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-0fa13c26 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1357 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-d31fbf8c | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1358 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-261bd53d | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1369 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4bd29640 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1370 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtEndCustomer | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-c706323a | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1371 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), "") | 그리드 값 설정 |  |  |  |
| AC-a402c0a4 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1372 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetText | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), "") | 그리드 값 설정 |  |  |  |
| AC-b49d6744 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1373 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-282d1f46 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1374 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c22f8162 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1379 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Model") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1406f47a | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1380 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtEndCustomer | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-8d0ebd27 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1381 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), "") | 그리드 값 설정 |  |  |  |
| AC-bd345176 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1382 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetText | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), "") | 그리드 값 설정 |  |  |  |
| AC-394e02c1 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1383 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-afb59d41 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1384 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-14006eef | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1404 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site*") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2e2c8393 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1406 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a25265c | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1412 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site*") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-488c716f | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1414 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-68536c13 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1417 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-00c3b69d | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1422 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | POPUP | popItem.Form_Load | (false, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-26b5f885 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1423 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1d305308 | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1424 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c934b86d | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1430 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-5424681f | spdMain.ClipboardPasted | SSP0002_ShipmentConfirmInsertPopup.cs:1431 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), popItem.NickName) | 그리드 값 설정 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.SpdMain_ComboSelChange

진입점: spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fae0c560 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:799 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.PlantSiteByDivisionEEOperation, false, sDivisionID, UserInfo… | 화면 필드/플래그 변경 |  |  |  |
| AC-3af39b51 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:799 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteByDivisionEEOperation, false, sDivisionID, UserInfoContext.Current… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9f2e024f | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:800 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-beb6d8ab | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:800 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-de32406b | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:802 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ELECTRODE_YN), "N") | 그리드 값 설정 |  |  |  |
| AC-c45e2f86 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:806 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") ▸ if (sDivisionID == "40") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-67e87963 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:807 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") ▸ if (sDivisionID == "40") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f3506d9b | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:811 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") ▸ else of (sDivisionID == "40") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-869be06d | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:812 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") ▸ else of (sDivisionID == "40") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f9ef5792 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:820 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID != "EE") | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.PlantSiteByDivisionEEOperation, false, sDivisionID, UserInfo… | 화면 필드/플래그 변경 |  |  |  |
| AC-2b896998 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:820 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID != "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteByDivisionEEOperation, false, sDivisionID, UserInfoContext.Current… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-34ae2eb4 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:821 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID != "EE") | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e2d3b67 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:821 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID != "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c65339eb | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:823 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID != "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9fefac1b | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:824 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID != "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-acd76ee6 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:827 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE), dtFromSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5e125296 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:828 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4413431e | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:830 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE), "") | 그리드 값 설정 |  |  |  |
| AC-268d9363 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:831 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE), "") | 그리드 값 설정 |  |  |  |
| AC-84b9c9bc | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:832 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-69840278 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:833 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE40), "") | 그리드 값 설정 |  |  |  |
| AC-f7a778e2 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:834 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FCST_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-7236b22d | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:835 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-4ee7a566 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:836 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-e80f1c51 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:837 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-aa08b410 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:838 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-c7f3148f | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:839 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-3914b920 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:840 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LT), "") | 그리드 값 설정 |  |  |  |
| AC-28f6975a | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:841 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ETD), "") | 그리드 값 설정 |  |  |  |
| AC-efd18769 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:842 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ETA), "") | 그리드 값 설정 |  |  |  |
| AC-376332eb | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:846 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), e.Row, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-75704668 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:847 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "-") | 그리드 값 설정 |  |  |  |
| AC-8b8176ff | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:851 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), e.Row, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1bfe71be | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:860 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-75dc07a9 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:861 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-8184f550 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:863 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) | FLAG | dtOriginDivFromTo | Data_SCP.Common(Data_SCP.Type.OrigionDivFromTo, false, sFromSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-a177c237 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:863 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OrigionDivFromTo, false, sFromSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f17f5367 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:871 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (dtO… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ORIGIN_FROM_DIVISION_ID), dtOriginDivFromTo.Rows[… | 그리드 값 설정 |  |  |  |
| AC-74ec575c | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:875 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (dtO… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ORIGIN_FROM_DIVISION_ID), sDivisionID) | 그리드 값 설정 |  |  |  |
| AC-9534b632 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:880 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ else of… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ORIGIN_FROM_DIVISION_ID), sDivisionID) | 그리드 값 설정 |  |  |  |
| AC-b3f6e797 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:885 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (dtO… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), dtOriginDivFromTo.Rows[0]["OPER… | 그리드 값 설정 |  |  |  |
| AC-d94e7eef | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:893 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (dtO… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "-") | 그리드 값 설정 |  |  |  |
| AC-e3c3a7de | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:894 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (dtO… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FCST_TYPE), "-") | 그리드 값 설정 |  |  |  |
| AC-afe11575 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:895 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (dtO… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ELECTRODE_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-151a75be | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:897 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (dtO… | FLAG | dtToSite | Data.Common(Data.Type.PlantByElectordeShipToSite_EE, false, sDivisionID, sFromSite) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite_EE] | 화면 필드/플래그 변경 |  |  |  |
| AC-12843dd5 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:897 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (dtO… | COMBO_DATA | Data.Common | (Data.Type.PlantByElectordeShipToSite_EE, false, sDivisionID, sFromSite) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite_EE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0df8583b | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:899 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (dtO… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7ebb1d77 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:902 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (dtO… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e758a6a0 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:903 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (dtO… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4b05925f | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:904 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (dtO… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FCST_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ed3b083c | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:909 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ else of… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "-") | 그리드 값 설정 |  |  |  |
| AC-e1a78786 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:910 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ else of… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FCST_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-c68df970 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:911 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ else of… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ELECTRODE_YN), "N") | 그리드 값 설정 |  |  |  |
| AC-9a91a498 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:913 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ else of… | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-5edb8f90 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:913 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ else of… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b00b8fc4 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:914 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ else of… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9fbe3c83 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:918 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ else of… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-39efdda0 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:919 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ else of… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cfbf9c1b | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:920 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ else of… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FCST_TYPE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b93554e8 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:924 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ else of… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e778fec0 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:925 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ else of… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-fc5daf61 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:926 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ else of… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FCST_TYPE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ddb8603b | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:939 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-7879e374 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:940 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-446bbd92 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:942 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if… | FLAG | dtOriginDivFromTo | Data_SCP.Common(Data_SCP.Type.OrigionDivFromTo, false, sToSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-3f71e1cc | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:942 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OrigionDivFromTo, false, sToSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-10a0547f | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:949 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ORIGIN_TO_DIVISION_ID), dtOriginDivFromTo.Rows[0]… | 그리드 값 설정 |  |  |  |
| AC-60b157ed | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:954 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FCST_TYPE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1d285813 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:958 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-24da2e3e | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:959 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a9746882 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:963 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE40)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-eaabeaa9 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:964 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d2bf5e11 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:971 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ORIGIN_TO_DIVISION_ID), sDivisionID) | 그리드 값 설정 |  |  |  |
| AC-66c7377d | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:976 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ORIGIN_TO_DIVISION_ID), sDivisionID) | 그리드 값 설정 |  |  |  |
| AC-dd48c8f3 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:989 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6bfa0a85 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:991 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | DATA_OP | dtTransMode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c3a8ad2d | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1007 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Shipmente Date") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5243b917 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1009 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-eb528c0c | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1010 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f6647714 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1027 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ROUTE_ID), sRouteID) | 그리드 값 설정 |  |  |  |
| AC-9b5360ba | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1028 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), sBodID) | 그리드 값 설정 |  |  |  |
| AC-e8f22ab3 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1029 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-855ab670 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1030 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.D_COUNTRY), sDCountry) | 그리드 값 설정 |  |  |  |
| AC-9bb70aec | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1031 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.D_PORT_CODE), sDPortCode) | 그리드 값 설정 |  |  |  |
| AC-70940020 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1032 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.A_COUNTRY), sACountry) | 그리드 값 설정 |  |  |  |
| AC-f17ee35b | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1033 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.A_PORT_CODE), sAPortCode) | 그리드 값 설정 |  |  |  |
| AC-a97fe140 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1034 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_COUNTRY), sToCountry) | 그리드 값 설정 |  |  |  |
| AC-2ce2273b | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1035 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_CITY), sToCity) | 그리드 값 설정 |  |  |  |
| AC-e8e85055 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1036 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-8d50c335 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1037 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-8e0fdda0 | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1038 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LT), dLT) | 그리드 값 설정 |  |  |  |
| AC-cafcb1ba | spdMain.ComboSelChange | SSP0002_ShipmentConfirmInsertPopup.cs:1039 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE)) ▸ el… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), sNewTransMode) | 그리드 값 설정 |  |  |  |

## SSP0002_ShipmentConfirmInsertPopup.SpdMain_EditChange

진입점: spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c770f923 | spdMain.EditChange | SSP0002_ShipmentConfirmInsertPopup.cs:1048 | if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6e4fafa | spdMain.EditChange | SSP0002_ShipmentConfirmInsertPopup.cs:1058 | if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)) ▸ if (dBaseDate > dDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4460f1ae | spdMain.EditChange | SSP0002_ShipmentConfirmInsertPopup.cs:1059 | if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)) ▸ if (dBaseDate > dDate) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), "") | 그리드 값 설정 |  |  |  |
| AC-a57d9c31 | spdMain.EditChange | SSP0002_ShipmentConfirmInsertPopup.cs:1060 | if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)) ▸ if (dBaseDate > dDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5619c5d9 | spdMain.EditChange | SSP0002_ShipmentConfirmInsertPopup.cs:1063 | if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.LT)) == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-250d2852 | spdMain.EditChange | SSP0002_ShipmentConfirmInsertPopup.cs:1069 | if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-60ebecd1 | spdMain.EditChange | SSP0002_ShipmentConfirmInsertPopup.cs:1070 | if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-606908fd | spdMain.EditChange | SSP0002_ShipmentConfirmInsertPopup.cs:1071 | if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |

## SSP0002_UserInfoPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11961231 | this.Load | SSP0002_UserInfoPopup.cs:126 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f485ce3f | this.Load | SSP0002_UserInfoPopup.cs:127 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-855d214c | this.Load | SSP0002_UserInfoPopup.cs:128 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0002_UserInfoPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e8bc267 | this.Load | SSP0002_UserInfoPopup.cs:111 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-a6882f02 | this.Load | SSP0002_UserInfoPopup.cs:118 | if (SSOUserYN \|\| SingleSelectYn) | DATA_OP | list.Add | (ButtonListType.OK) | 데이터 객체 조작/조회 |  |  |  |
| AC-8fd9b9fa | this.Load | SSP0002_UserInfoPopup.cs:121 |  | CALL_EXT | btnButtonList.Set_ButtonVisibleFalse | (list) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0002_UserInfoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-312588ad | Dispose | SSP0002_UserInfoPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0002_UserInfoPopup.FindData

진입점: this.Load [if (!string.IsNullOrEmpty(strSearch))] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-549a1dcd | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SSP0002_UserInfoPopup.cs:172 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-217f5268 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SSP0002_UserInfoPopup.cs:176 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_USER_INFO_LIST") ⇒ SSP.SSP0002_GET_USER_INFO_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-4c486184 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SSP0002_UserInfoPopup.cs:177 | lambda | DATA_OP | request.Parameters["Search"] | this.txtSearch.Text | 행/컬럼 값 대입 |  |  |  |
| AC-54ef2986 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SSP0002_UserInfoPopup.cs:178 | lambda | DATA_OP | request.Parameters["Language"] | Language | 행/컬럼 값 대입 |  |  |  |
| AC-2e3032ff | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SSP0002_UserInfoPopup.cs:179 | lambda | DATA_OP | request.Parameters["SSOUserYN"] | SSOUserYN == true ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-7a70dbff | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SSP0002_UserInfoPopup.cs:180 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1ad425d6 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SSP0002_UserInfoPopup.cs:182 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a766a9ad | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SSP0002_UserInfoPopup.cs:186 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1f317401 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SSP0002_UserInfoPopup.cs:187 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dc1adc1f | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SSP0002_UserInfoPopup.cs:190 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0002_UserInfoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b8c940a | this.Load | SSP0002_UserInfoPopup.cs:90 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6f7cd07b | this.Load | SSP0002_UserInfoPopup.cs:96 | if (!string.IsNullOrEmpty(strSearch)) | VALUE_SET | this.txtSearch.Text | strSearch | 컨트롤 값 설정 |  |  |  |

## SSP0002_UserInfoPopup.InitSpread

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-471358f8 | this.Load 외 2 | SSP0002_UserInfoPopup.cs:135 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b5bc118c | this.Load 외 2 | SSP0002_UserInfoPopup.cs:138 | if (!SSOUserYN && !SingleSelectYn) | CALL_EXT | siMain.AddSelectionCheckBox | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a72ad3b9 | this.Load 외 2 | SSP0002_UserInfoPopup.cs:140 |  | GRID_INIT | siMain.AddTextColumn | ("UserID", DefColumns.UserID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29830871 | this.Load 외 2 | SSP0002_UserInfoPopup.cs:141 |  | GRID_INIT | siMain.AddTextColumn | ("UserName", DefColumns.UserName, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f5a70540 | this.Load 외 2 | SSP0002_UserInfoPopup.cs:142 |  | GRID_INIT | siMain.AddTextColumn | ("EnglishName", DefColumns.UserName_E, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f5a9424 | this.Load 외 2 | SSP0002_UserInfoPopup.cs:144 | if (!SSOUserYN && !SingleSelectYn) | GRID_INIT | siMain.AddTextColumn | ("Email", DefColumns.Email, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a3a0e552 | this.Load 외 2 | SSP0002_UserInfoPopup.cs:145 |  | GRID_INIT | siMain.AddTextColumn | ("Dept_ID", DefColumns.Dept_ID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6e1ea63b | this.Load 외 2 | SSP0002_UserInfoPopup.cs:146 |  | GRID_INIT | siMain.AddTextColumn | ("Dept_Name", DefColumns.Dept_Name, FPMerge.None, 240, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6eba0b78 | this.Load 외 2 | SSP0002_UserInfoPopup.cs:148 | if (!SSOUserYN && !SingleSelectYn) | GRID_INIT | siMain.AddComboColumn | ("UseYN", DefColumns.UseYN, FPMerge.None, 60, true, Data.Common(Data.Type.YesOrNo), FPHAli… ⇒ biz:CommonData.YesOrNo | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ab291035 | this.Load 외 2 | SSP0002_UserInfoPopup.cs:148 | if (!SSOUserYN && !SingleSelectYn) | COMBO_DATA | Data.Common | (Data.Type.YesOrNo) ⇒ biz:CommonData.YesOrNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3746b0dc | this.Load 외 2 | SSP0002_UserInfoPopup.cs:150 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.UserID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0002_UserInfoPopup.OkButtonClick

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da989938 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SSP0002_UserInfoPopup.cs:243 | for (i <= siMain.GetMaxRowIndex()) ▸ if (chk.Equals("True")) | DATA_OP | lstUserInfo.Add | (new SelectedUserInfo() { UserID = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.User… | 데이터 객체 조작/조회 |  |  |  |
| AC-b875d3ef | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SSP0002_UserInfoPopup.cs:260 |  | FLAG | SelectedUserInfoList | lstUserInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-e6042dba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SSP0002_UserInfoPopup.cs:263 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0002_UserInfoPopup.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95f0648b | this.spdMain.CellClick | SSP0002_UserInfoPopup.cs:220 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-a4c53382 | this.spdMain.CellClick | SSP0002_UserInfoPopup.cs:221 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-b7a71451 | this.spdMain.CellClick | SSP0002_UserInfoPopup.cs:225 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-a040c52a | this.spdMain.CellClick | SSP0002_UserInfoPopup.cs:226 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |

## SSP0002_UserInfoPopup.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4237c1c7 | spdMain.CellDoubleClick | SSP0002_UserInfoPopup.cs:270 |  | DATA_OP | lstUserInfo.Add | (new SelectedUserInfo() { UserID = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.… | 데이터 객체 조작/조회 |  |  |  |
| AC-a25c4fa1 | spdMain.CellDoubleClick | SSP0002_UserInfoPopup.cs:284 |  | FLAG | SelectedUserInfoList | lstUserInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-8aec18a2 | spdMain.CellDoubleClick | SSP0002_UserInfoPopup.cs:287 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

