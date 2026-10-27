# AS-IS 액션 대조표 — SSP0200

> 원천: `Doc/asisfacts/screens/SSP0200/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1170행 · 메서드 66 · 종류 DATA_OP 364 · GRID_SET 172 · FLAG 112 · RETURN 98 · MESSAGE 82 · UI_PROP 50 · ENDPOINT 49 · GRID_INIT 38 · GRID_LOCK 34 · VALUE_SET 28 · POPUP 24 · CALL_EXT 23 · UI_MISC 18 · GRID_COMBO 16 · COMBO_DATA 16 · GRID_STYLE 16 · VALIDATE 6 · LIST_REBIND 6 · STATE 6 · VALUE_CLEAR 5 · GRID_BIND 3 · STATE_RESET 3 · CALL_BASE 1 · ⚠ 의미 확인 필요 24


## Item.ClassToItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d194e33 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:6876 | if (ds.Good()) ▸ if (dt.Good()) ▸ foreach (DataRow r in dt.Rows) ▸ foreach (DataColumn column in dt.Columns) ▸ try | UI_PROP | a.division_id | r["division_id"].SafeString() | 속성 division_id 설정 |  |  |  |
| AC-70a48957 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:6877 | if (ds.Good()) ▸ if (dt.Good()) ▸ foreach (DataRow r in dt.Rows) ▸ foreach (DataColumn column in dt.Columns) ▸ try | UI_PROP | a.bod_id | r["bod_id"].SafeString() | 속성 bod_id 설정 |  |  |  |
| AC-8a311040 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:6878 | if (ds.Good()) ▸ if (dt.Good()) ▸ foreach (DataRow r in dt.Rows) ▸ foreach (DataColumn column in dt.Columns) ▸ try | UI_PROP | a.incoterms | r["incoterms"].SafeString() | 속성 incoterms 설정 |  |  |  |
| AC-5a7dd5bd | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:6879 | if (ds.Good()) ▸ if (dt.Good()) ▸ foreach (DataRow r in dt.Rows) ▸ foreach (DataColumn column in dt.Columns) ▸ try | UI_PROP | a.priority | r["priority"].SafeString() | 속성 priority 설정 |  |  |  |
| AC-9533cc9d | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:6880 | if (ds.Good()) ▸ if (dt.Good()) ▸ foreach (DataRow r in dt.Rows) ▸ foreach (DataColumn column in dt.Columns) ▸ try | UI_PROP | a.transport_mode | r["transport_mode"].SafeString() | 속성 transport_mode 설정 |  |  |  |
| AC-8ba95582 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:6881 | if (ds.Good()) ▸ if (dt.Good()) ▸ foreach (DataRow r in dt.Rows) ▸ foreach (DataColumn column in dt.Columns) ▸ try | UI_PROP | a.operation_group | r["operation_group"].SafeString() | 속성 operation_group 설정 |  |  |  |
| AC-d7f98413 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:6894 | if (ds.Good()) ▸ if (dt.Good()) ▸ foreach (DataRow r in dt.Rows) | DATA_OP | returnList.Add | (a) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a214cd2 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:6896 | if (ds.Good()) ▸ if (dt.Good()) | RETURN | return returnList; |  | 처리 중단/반환 |  |  |  |
| AC-be17fd59 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:6899 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.Backup_Value

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2321ee3d | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3483 |  | FLAG | sBefor_RequestID | sRequestID | 화면 필드/플래그 변경 |  |  |  |
| AC-b9fcb9fe | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3484 |  | FLAG | sBefor_RequestDeptID | sRequestDeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-74084123 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3485 |  | FLAG | sBefor_ApprovalID | sApprovalID | 화면 필드/플래그 변경 |  |  |  |
| AC-e9afc8d5 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3486 |  | FLAG | sBefor_ApprovalDeptID | sApprovalDeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-4076bbf3 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3487 |  | FLAG | sBefor_MainConfirmID | sMainConfirmID | 화면 필드/플래그 변경 |  |  |  |
| AC-a811cc1b | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3488 |  | FLAG | sBefor_ChangeStatus | sChangeStatus | 화면 필드/플래그 변경 |  |  |  |
| AC-63969104 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3489 |  | FLAG | sBefor_ShipStatus | sShipStatus | 화면 필드/플래그 변경 |  |  |  |
| AC-491e0ae9 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3490 |  | FLAG | sBefor_RequestName | sRequestName | 화면 필드/플래그 변경 |  |  |  |
| AC-017a3e36 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3491 |  | FLAG | sBefor_SaveConfirmID | sSaveConfirmID | 화면 필드/플래그 변경 |  |  |  |
| AC-eb67b0dd | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3492 |  | FLAG | _Befor_sRequestNo | _sRequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-49c9ae3a | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3493 |  | FLAG | _Befor_sConfrimID | _sConfrimID | 화면 필드/플래그 변경 |  |  |  |

## SSP0200_ShipmentChangeRequest.BtnApprovalUser_Click

진입점: btnApprovalUser.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba63ce72 | btnApprovalUser.Click | SSP0200_ShipmentChangeRequest.cs:3151 |  | POPUP | new SSP0002_UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c68f610b | btnApprovalUser.Click | SSP0200_ShipmentChangeRequest.cs:3153 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-bc115c3b | btnApprovalUser.Click | SSP0200_ShipmentChangeRequest.cs:3154 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-cff7d537 | btnApprovalUser.Click | SSP0200_ShipmentChangeRequest.cs:3155 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5d466396 | btnApprovalUser.Click | SSP0200_ShipmentChangeRequest.cs:3156 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-f2f81490 | btnApprovalUser.Click | SSP0200_ShipmentChangeRequest.cs:3157 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-80a76307 | btnApprovalUser.Click | SSP0200_ShipmentChangeRequest.cs:3159 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-1a661a14 | btnApprovalUser.Click | SSP0200_ShipmentChangeRequest.cs:3161 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-79525a45 | btnApprovalUser.Click | SSP0200_ShipmentChangeRequest.cs:3167 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sApprovalID | item.UserID | 화면 필드/플래그 변경 |  |  |  |
| AC-27ef8e63 | btnApprovalUser.Click | SSP0200_ShipmentChangeRequest.cs:3170 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtApproval.Text | item.UserName | 컨트롤 값 설정 |  |  |  |
| AC-a4eccc13 | btnApprovalUser.Click | SSP0200_ShipmentChangeRequest.cs:3172 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtApproval.Text | item.UserName_E | 컨트롤 값 설정 |  |  |  |
| AC-8fe48bd0 | btnApprovalUser.Click | SSP0200_ShipmentChangeRequest.cs:3174 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | VALUE_SET | txtAppDeptName.Text | item.Dept_Name | 컨트롤 값 설정 |  |  |  |
| AC-d89b6378 | btnApprovalUser.Click | SSP0200_ShipmentChangeRequest.cs:3175 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sApprovalDeptID | item.Dept_ID | 화면 필드/플래그 변경 |  |  |  |

## SSP0200_ShipmentChangeRequest.BtnCancel_Click

진입점: btnCancel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-632784dd | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:3438 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e08dcd12 | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:3441 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00195") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93e09018 | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:3441 | if (MessageHelper.GMessageBox("MSG00195") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d28da2f | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:3444 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_C \|\| cboChangeType.SelectedValue.ToString() == ChangeTyp…) | FLAG | sShipStatus | Shipment_Status.S_Status_C | 화면 필드/플래그 변경 |  |  |  |
| AC-a0682a29 | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:3446 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_C \|\| cboChangeType.SelectedValue.ToString() == ChangeTyp…) | FLAG | sShipStatus | Shipment_Status.S_Status_P | 화면 필드/플래그 변경 |  |  |  |
| AC-9571b21a | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:3448 |  | FLAG | bDeleClickYn | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e1fdb603 | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:3451 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_C \|\| cboChangeType.SelectedValue.ToString() == ChangeTyp…) | FLAG | bErpIFCheck | true | 화면 필드/플래그 변경 |  |  |  |

## SSP0200_ShipmentChangeRequest.BtnChangeRe_Click

진입점: btnChangeRe2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6e23c86 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3213 |  | FLAG | RollBack_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d62f2b8a | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3227 | if (!checkRequired()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f0cd7f8 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3230 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-42c8a870 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3232 | if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2a092dc | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3250 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ if (iShipmentQty == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00202", new object[] { 0 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8f857f13 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3251 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ if (iShipmentQty == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7d910a4 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3264 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ for (iRow < siSub.ActiveSheet.RowCount) ▸ if (siSub.GetValue(i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00202", new object[] { 0 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-903c0b86 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3265 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ for (iRow < siSub.ActiveSheet.RowCount) ▸ if (siSub.GetValue(i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48ee6557 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3282 | for (iRow < siSub.ActiveSheet.RowCount) ▸ if (dBaseDate > dShipDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00201", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0f110d24 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3283 | for (iRow < siSub.ActiveSheet.RowCount) ▸ if (dBaseDate > dShipDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9fdc9464 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3291 | for (iRow < siSub.ActiveSheet.RowCount) ▸ if (dShipDate > dShipDateAfter) | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e2eadd8 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3292 | for (iRow < siSub.ActiveSheet.RowCount) ▸ if (dShipDate > dShipDateAfter) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bb3422ec | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3313 |  | FLAG | sChangeStatus | Change_Req_Status.C_Status_Q | 화면 필드/플래그 변경 |  |  |  |
| AC-e9e07d5a | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3314 |  | FLAG | sShipStatus | Shipment_Status.S_Status_R | 화면 필드/플래그 변경 |  |  |  |
| AC-6a759fb9 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3315 |  | FLAG | bErpIFCheck | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0200_ShipmentChangeRequest.btnInsertMultiple_Click

진입점: this.btnInsertMultiple.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-655ffb59 | this.btnInsertMultiple.Click | SSP0200_ShipmentChangeRequest.cs:2924 |  | POPUP | new SSP0200_ShipmentChangeRequestInsertPopup | () | 팝업/폼 생성 |  |  |  |
| AC-aed54555 | this.btnInsertMultiple.Click | SSP0200_ShipmentChangeRequest.cs:2926 |  | UI_PROP | popup.Width | 400 | 속성 Width 설정 |  |  |  |
| AC-564d0ba4 | this.btnInsertMultiple.Click | SSP0200_ShipmentChangeRequest.cs:2927 |  | UI_PROP | popup.Height | 300 | 속성 Height 설정 |  |  |  |
| AC-e9117eff | this.btnInsertMultiple.Click | SSP0200_ShipmentChangeRequest.cs:2928 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d4c3e2f5 | this.btnInsertMultiple.Click | SSP0200_ShipmentChangeRequest.cs:2934 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0200_ShipmentChangeRequest.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d393c35 | this.btnItemId.Click | SSP0200_ShipmentChangeRequest.cs:3466 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-eb708a61 | this.btnItemId.Click | SSP0200_ShipmentChangeRequest.cs:3468 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8f06d5e4 | this.btnItemId.Click | SSP0200_ShipmentChangeRequest.cs:3469 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-062d0ec6 | this.btnItemId.Click | SSP0200_ShipmentChangeRequest.cs:3470 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a2c23a51 | this.btnItemId.Click | SSP0200_ShipmentChangeRequest.cs:3476 | if (popItem.ItemID != "") | VALUE_SET | txtRequest.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0200_ShipmentChangeRequest.BtnNew_Click

진입점: btnNew.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f78093d1 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3377 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-245e655d | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3379 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-58491bc2 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3380 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-d87e9621 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3381 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-00a324fe | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3383 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivision_ID.SelectedValue.ToSt… | 그리드 값 설정 |  |  |  |
| AC-8d0885d9 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3394 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.Sel… | FLAG | dtFromSite | GetPlantSiteByDivisionEEOperation(clbDivision_ID.SelectedValue.ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-0a791813 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3396 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.Sel… | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteByDivisionEEForSSP, false, clbDivision_ID.SelectedValu… | 화면 필드/플래그 변경 |  |  |  |
| AC-9a6616b7 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3396 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.Sel… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteByDivisionEEForSSP, false, clbDivision_ID.SelectedValue.ToString()) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8fbd3839 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3401 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.Sel… | GRID_SET | siMain.SetValue | (insCell, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "-") | 그리드 값 설정 |  |  |  |
| AC-3fb0f970 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3405 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.Sel… | GRID_SET | siMain.SetValue | (insCell, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "-") | 그리드 값 설정 |  |  |  |
| AC-058e5230 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3415 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION), dtFromSit… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6e78471a | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3416 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTION), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cfa1bb10 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3420 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-7ce2c9d4 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3421 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-f521c8c2 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3422 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b63117c5 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3424 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e41c934a | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3425 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ERP_SO_NO), siMain.GetColumnIndex(DefColumns.SH… | 그리드 편집 잠금/해제 |  |  |  |
| AC-187fd3a7 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3426 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8cda5cc6 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3427 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7ffa9aee | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3428 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.REQUESTOR) - 1, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-61969562 | btnNew.Click | SSP0200_ShipmentChangeRequest.cs:3429 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TO_SITE_SOLDTO_CODE), siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0200_ShipmentChangeRequest.BtnSave_Click

진입점: btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32754977 | btnSave.Click | SSP0200_ShipmentChangeRequest.cs:3183 | if (string.IsNullOrWhiteSpace(txtRequestNo.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b913b616 | btnSave.Click | SSP0200_ShipmentChangeRequest.cs:3186 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e8bf9580 | btnSave.Click | SSP0200_ShipmentChangeRequest.cs:3186 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55d066f8 | btnSave.Click | SSP0200_ShipmentChangeRequest.cs:3193 | if (sStatus == Shipment_Status.S_Status_R) | MESSAGE | MessageHelper.GMessageBox | ("MSG00174") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6859f2c9 | btnSave.Click | SSP0200_ShipmentChangeRequest.cs:3194 | if (sStatus == Shipment_Status.S_Status_R) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6e8d758 | btnSave.Click | SSP0200_ShipmentChangeRequest.cs:3204 |  | FLAG | sChangeStatus | Change_Req_Status.C_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-2fa1312f | btnSave.Click | SSP0200_ShipmentChangeRequest.cs:3205 |  | FLAG | sShipStatus | Shipment_Status.S_Status_D | 화면 필드/플래그 변경 |  |  |  |
| AC-c358b0e5 | btnSave.Click | SSP0200_ShipmentChangeRequest.cs:3207 |  | FLAG | bErpIFCheck | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0200_ShipmentChangeRequest.CboChangeType_SelectedIndexChanged

진입점: cboChangeType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5adc3b12 | cboChangeType.SelectedIndexChanged | SSP0200_ShipmentChangeRequest.cs:3096 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | VALUE_SET | drpPeriod.InitValue | GetDayRange(sDate) | 컨트롤 값 설정 |  |  |  |
| AC-7a349e6a | cboChangeType.SelectedIndexChanged | SSP0200_ShipmentChangeRequest.cs:3098 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | VALUE_SET | dtDate.InitValue | Convert.ToDateTime(DateTime.Now.Date).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-d258084a | cboChangeType.SelectedIndexChanged | SSP0200_ShipmentChangeRequest.cs:3101 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-2e314ed6 | cboChangeType.SelectedIndexChanged | SSP0200_ShipmentChangeRequest.cs:3103 | if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | FLAG | dBaseDate | Convert.ToDateTime(dtDate.Value).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b6d2ff3 | cboChangeType.SelectedIndexChanged | SSP0200_ShipmentChangeRequest.cs:3109 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | VALUE_SET | drpPeriod.InitValue | GetDayRange(sDate) | 컨트롤 값 설정 |  |  |  |
| AC-9ef4f22b | cboChangeType.SelectedIndexChanged | SSP0200_ShipmentChangeRequest.cs:3111 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | VALUE_SET | dtDate.InitValue | Convert.ToDateTime(DateTime.Now.Date).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-5a346b8a | cboChangeType.SelectedIndexChanged | SSP0200_ShipmentChangeRequest.cs:3113 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) ▸ if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-53058f72 | cboChangeType.SelectedIndexChanged | SSP0200_ShipmentChangeRequest.cs:3115 | else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | FLAG | dBaseDate | Convert.ToDateTime(dtDate.Value).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |

## SSP0200_ShipmentChangeRequest.Change_ReValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea644123 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3499 |  | FLAG | RollBack_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3ed5dabc | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3500 |  | FLAG | iSelRow | iOld_SelRow | 화면 필드/플래그 변경 |  |  |  |
| AC-36c863cc | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3501 |  | FLAG | iSelCol | iOld_SelCol | 화면 필드/플래그 변경 |  |  |  |
| AC-8de3ac4c | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3502 |  | FLAG | sRequestID | sBefor_RequestID | 화면 필드/플래그 변경 |  |  |  |
| AC-55cd99ae | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3503 |  | FLAG | sRequestDeptID | sBefor_RequestDeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-3c2d41a7 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3504 |  | FLAG | sApprovalID | sBefor_ApprovalID | 화면 필드/플래그 변경 |  |  |  |
| AC-2fb16f46 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3505 |  | FLAG | sApprovalDeptID | sBefor_ApprovalDeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-4df225b0 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3506 |  | FLAG | sMainConfirmID | sBefor_MainConfirmID | 화면 필드/플래그 변경 |  |  |  |
| AC-cd9d62b0 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3507 |  | FLAG | sChangeStatus | sBefor_ChangeStatus | 화면 필드/플래그 변경 |  |  |  |
| AC-92ee6275 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3508 |  | FLAG | sShipStatus | sBefor_ShipStatus | 화면 필드/플래그 변경 |  |  |  |
| AC-c73a9eb8 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3509 |  | FLAG | sRequestName | sBefor_RequestName | 화면 필드/플래그 변경 |  |  |  |
| AC-cbf3369b | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3510 |  | FLAG | sSaveConfirmID | sBefor_SaveConfirmID | 화면 필드/플래그 변경 |  |  |  |
| AC-b1a7ce3b | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3511 |  | FLAG | _sRequestNo | _Befor_sRequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-d4daf92f | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3512 |  | FLAG | _sConfrimID | _Befor_sConfrimID | 화면 필드/플래그 변경 |  |  |  |

## SSP0200_ShipmentChangeRequest.checkRequired

진입점: btnChangeRe2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66a36260 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3331 | if (string.IsNullOrWhiteSpace(txtApproval.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-81db80e4 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3332 | if (string.IsNullOrWhiteSpace(txtApproval.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4e2324ea | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3342 | if (string.IsNullOrWhiteSpace(txtTitle.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b7a7de13 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3343 | if (string.IsNullOrWhiteSpace(txtTitle.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a6429a37 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3353 | if (cboChangeReason.SelectedIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bc887414 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3354 | if (cboChangeReason.SelectedIndex == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f07b05a1 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3364 | if (string.IsNullOrWhiteSpace(txtReasonDetail.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc9fc698 | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3365 | if (string.IsNullOrWhiteSpace(txtReasonDetail.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e4fb2c7b | btnChangeRe2.Click | SSP0200_ShipmentChangeRequest.cs:3370 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.chkERPIFBlockYn

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98ccb31b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:2947 |  | FLAG | dtERPBlockYnIF | Data_SCP.Common(Data_SCP.Type.SSPBlockCheckIF, false, "SSP0200") | 화면 필드/플래그 변경 |  |  |  |
| AC-34b2adb2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:2947 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSPBlockCheckIF, false, "SSP0200") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23eee2ad | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:2950 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("BLOCK_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-968dc464 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:2959 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("PERIOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d807f06 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:2960 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00267", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-67d1ce5d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:2964 |  | RETURN | return resultYn; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.ClearRequestInfo

진입점: btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnChangeRe2.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnCancel.Click / cboChangeType.SelectedIndexChanged / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ else of (!GetERPInterface()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c47006be | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1698 |  | VALUE_CLEAR | txtRequestNo.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c769cc7b | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1699 |  | VALUE_CLEAR | txtTitle.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-8a49a075 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1700 |  | VALUE_CLEAR | txtApproval.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-13138269 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1701 |  | VALUE_CLEAR | txtAppDeptName.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-be5f365f | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1702 |  | VALUE_SET | cboChangeReason.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-e0fe9b41 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1703 |  | VALUE_CLEAR | txtReasonDetail.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1445db9a | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1704 |  | FLAG | sApprovalDeptID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-5b0ca65f | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1705 |  | FLAG | sApprovalID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-d86db07e | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1706 |  | FLAG | sMainConfirmID | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## SSP0200_ShipmentChangeRequest.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-043bacd8 | this.Load | SSP0200_ShipmentChangeRequest.cs:573 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-acf6e258 | this.Load | SSP0200_ShipmentChangeRequest.cs:574 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2e2bcd1b | this.Load | SSP0200_ShipmentChangeRequest.cs:577 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fce23ba3 | this.Load | SSP0200_ShipmentChangeRequest.cs:578 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-3db485e6 | this.Load | SSP0200_ShipmentChangeRequest.cs:587 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0200_ShipmentChangeRequest.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50abdff2 | this.Load | SSP0200_ShipmentChangeRequest.cs:429 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-295f45ea | this.Load | SSP0200_ShipmentChangeRequest.cs:431 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d11eff8f | this.Load | SSP0200_ShipmentChangeRequest.cs:432 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-065c138c | this.Load | SSP0200_ShipmentChangeRequest.cs:433 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-8cac9e10 | this.Load | SSP0200_ShipmentChangeRequest.cs:434 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## SSP0200_ShipmentChangeRequest.DeleteDataDrafting

진입점: btnCancel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc601e7b | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:2614 | if (sFlag == "D" && iBaseChk == 0 && siSub.ActiveSheet.RowCount > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00198") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f8df731 | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:2616 | if (sFlag == "D" && iBaseChk == 0 && siSub.ActiveSheet.RowCount > 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-19c9e5e9 | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:2620 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-2c61954b | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:2625 | if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aaef72bd | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:2629 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-bb119bc1 | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:2630 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-20bdd04b | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:2631 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-e2e18fbb | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:2632 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-3fc71d17 | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:2633 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-2b6cc338 | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:2634 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_if_send_flag"] | p_if_send_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b07545b0 | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:2635 | if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-d11659ab | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:2637 | if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8d8ce8d9 | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:2637 | if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-b9334ab2 | btnCancel.Click | SSP0200_ShipmentChangeRequest.cs:2668 | if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToSt… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0200_ShipmentChangeRequest.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-923b4769 | Dispose | SSP0200_ShipmentChangeRequest.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0200_ShipmentChangeRequest.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d958cb74 | EditButton | SSP0200_ShipmentChangeRequest.cs:785 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-97e52453 | EditButton | SSP0200_ShipmentChangeRequest.cs:786 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c65b52dd | EditButton | SSP0200_ShipmentChangeRequest.cs:796 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.TO_SITE_D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-01c74ff7 | EditButton | SSP0200_ShipmentChangeRequest.cs:797 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TO_SITE_SOLDTO_CODE), siMain.GetColumnIndex(DefColumns.R… | 그리드 편집 잠금/해제 |  |  |  |
| AC-02cdbfd6 | EditButton | SSP0200_ShipmentChangeRequest.cs:819 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.… | GRID_LOCK | siMain.LockRange | (i, 1, i, siMain.GetMaxColumnIndex(), true, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-56aa7954 | EditButton | SSP0200_ShipmentChangeRequest.cs:827 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.ITEM_ID), i, siMain.GetColumnIndex(DefColumns.ITEM_ID… | 그리드 편집 잠금/해제 |  |  |  |
| AC-512e1974 | EditButton | SSP0200_ShipmentChangeRequest.cs:828 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION), i, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8d5db41d | EditButton | SSP0200_ShipmentChangeRequest.cs:829 | if (fps.Name == "spdMain") ▸ if (siSub.ActiveSheet.RowCount == 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (i < siMain.… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), i, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0200_ShipmentChangeRequest.FindData_BOD

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3031b3e | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6704 |  | FLAG | dtTransMode | null | 화면 필드/플래그 변경 |  |  |  |
| AC-aee1be91 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6707 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SSP.Plan.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a2d256bb | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6711 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_BOD_ITEM") ⇒ SSP.SSP0026_GET_BOD_ITEM | 엔드포인트 요청 생성 |  |  |  |
| AC-7e9566d0 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6712 | lambda | DATA_OP | request.Parameters["p_division_id"] | sdivision | 행/컬럼 값 대입 |  |  |  |
| AC-51ca2728 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6713 | lambda | DATA_OP | request.Parameters["p_from_site_id"] | sFromSite | 행/컬럼 값 대입 |  |  |  |
| AC-68001855 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6714 | lambda | DATA_OP | request.Parameters["p_to_site_id"] | sToSite | 행/컬럼 값 대입 |  |  |  |
| AC-5f405773 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6715 | lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-e2f59a47 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6716 | lambda | DATA_OP | request.Parameters["p_bod_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-23292367 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6717 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-89f7a254 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6719 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-84cc619c | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6723 |  | FLAG | dtFindData_BOD | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-a2b2cc8e | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6731 | if (dtFindData_BOD.Rows.Count > 0) | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sdivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-032b3e5a | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6731 | if (dtFindData_BOD.Rows.Count > 0) | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sdivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d6ed0e75 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6735 | if (dtFindData_BOD.Rows.Count > 0) | GRID_COMBO | siMain.SetCellTypeCombo | (row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), dtTransMode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a55032a7 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6743 | else of (dtFindData_BOD.Rows.Count > 0) | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-a16bcd1c | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | SSP0200_ShipmentChangeRequest.cs:6744 | else of (dtFindData_BOD.Rows.Count > 0) | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |

## SSP0200_ShipmentChangeRequest.FindData_Main

진입점: btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")] / btnChangeRe2.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")] / btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ else of (!GetERPInterface()) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cb7bda3 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1454 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4a410964 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1459 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-b7b22de4 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1459 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eda140ad | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1514 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6d99d9ca | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1520 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-2eb0e5cd | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1522 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fb01461a | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1529 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST") ⇒ SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-1b7dbeaa | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1530 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8d43a2f1 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1531 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-3ad1f851 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1532 | try ▸ lambda | DATA_OP | request.Parameters["p_erp_so_no"] | p_erp_so_no | 행/컬럼 값 대입 |  |  |  |
| AC-098f94c0 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1533 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-27a40609 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1534 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6df8338e | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1535 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e9eddab9 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1536 | try ▸ lambda | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-798e21ef | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1537 | try ▸ lambda | DATA_OP | request.Parameters["p_status"] | p_status | 행/컬럼 값 대입 |  |  |  |
| AC-84ce01b4 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1538 | try ▸ lambda | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-a6e7c66f | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1539 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-c111b85c | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1540 | try ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-102083b8 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1543 | try ▸ lambda | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-276e96f3 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1545 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-26e0befd | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1547 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-254ea02c | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1555 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d30783e8 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1569 | try ▸ foreach (DataRow r in ds.Tables[0].Rows) ▸ if (operation == "E") | CALL_EXT | siMain.SetDecimal | (index, ship_qty, index, ship_qty, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-49a60c3e | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1570 | try ▸ foreach (DataRow r in ds.Tables[0].Rows) ▸ if (operation == "E") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c5ec4b33 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1589 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-7961dd1f | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1591 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-9f1bf4e4 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1591 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d0387e09 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1594 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3001f745 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:1610 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0200_ShipmentChangeRequest.FindData_Main_Nonasync

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ else of (!GetERPInterface()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f07d7068 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1616 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d5f4dbef | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1621 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-2bf0b8f7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1621 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c0568f9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1636 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-18fc945c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1646 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-61d36d0e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1650 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N") ⇒ SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N | 엔드포인트 요청 생성 |  |  |  |
| AC-b9790105 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1651 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-70fc86ca | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1652 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-7aebc221 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1653 | try | DATA_OP | request.Parameters["p_erp_so_no"] | p_erp_so_no | 행/컬럼 값 대입 |  |  |  |
| AC-ab2db26e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1654 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-789dc76b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1655 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5b08f015 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1656 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6fab7225 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1657 | try | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-04745c78 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1658 | try | DATA_OP | request.Parameters["p_status"] | p_status | 행/컬럼 값 대입 |  |  |  |
| AC-076f0a8f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1659 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-d647951d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1660 | try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-038776a8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1661 | try | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-72a4015c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1663 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-367ed62b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1672 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4ac0aedc | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1673 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a139f32 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1676 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-164a16ae | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:1692 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0200_ShipmentChangeRequest.FindData_Sub_Draft

진입점: btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")] / btnChangeRe2.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")] / btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ else of (!GetERPInterface()) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42810bfa | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2029 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-6d738f29 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2030 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2394e918 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2031 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-f85502ff | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2032 |  | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-2bfc3194 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2033 |  | DATA_OP | request.Parameters["p_erp_so_no"] | p_erp_so_no | 행/컬럼 값 대입 |  |  |  |
| AC-c125d410 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2034 |  | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-4286f295 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2035 |  | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-6a73f804 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2036 |  | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-ab565c0d | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2037 |  | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-31a20ca0 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2038 |  | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-a1022807 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2039 |  | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-5854d817 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2040 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-c3095cf9 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2041 |  | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-857ec197 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2042 |  | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cf75976e | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2043 |  | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-a6038a69 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2044 |  | DATA_OP | request.Parameters["p_request_user_id"] | p_request_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-708b5d7e | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2045 |  | DATA_OP | request.Parameters["p_request_status"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-13dab7f8 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2046 |  | DATA_OP | request.Parameters["p_language"] | UserInfoContext.Current[UserInfoProperites.Language] | 행/컬럼 값 대입 |  |  |  |
| AC-97cf921a | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2047 |  | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-6420a19b | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2048 |  | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-6d034e44 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2050 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e3cf0a00 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2058 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f0241d3b | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2059 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-88077b52 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2062 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e54b3d48 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2074 | if (ds.Tables[1].Rows.Count > 0) ▸ if (txtApproval.Text == "" && null != ds.Tables[1] && ds.Tables[1].Rows.Count > 0) | FLAG | sApprovalID | ds.Tables[1].Rows[0]["USER_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a915f268 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2075 | if (ds.Tables[1].Rows.Count > 0) ▸ if (txtApproval.Text == "" && null != ds.Tables[1] && ds.Tables[1].Rows.Count > 0) | FLAG | sApprovalDeptID | ds.Tables[1].Rows[0]["DEPT_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fa2aab7f | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2078 | if (ds.Tables[1].Rows.Count > 0) ▸ if (txtApproval.Text == "" && null != ds.Tables[1] && ds.Tables[1].Rows.Count > 0) ▸ if (UserInfoContext.… | VALUE_SET | txtApproval.Text | ds.Tables[1].Rows[0]["USER_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8b5b6fd5 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2079 | if (ds.Tables[1].Rows.Count > 0) ▸ if (txtApproval.Text == "" && null != ds.Tables[1] && ds.Tables[1].Rows.Count > 0) ▸ if (UserInfoContext.… | VALUE_SET | txtAppDeptName.Text | ds.Tables[1].Rows[0]["DEPT_NAME_KO"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-6aa80b48 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2083 | if (ds.Tables[1].Rows.Count > 0) ▸ if (txtApproval.Text == "" && null != ds.Tables[1] && ds.Tables[1].Rows.Count > 0) ▸ else of (UserInfoCon… | VALUE_SET | txtApproval.Text | ds.Tables[1].Rows[0]["USER_NAME_EN"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ffd4c993 | btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0]… 외 4 | SSP0200_ShipmentChangeRequest.cs:2084 | if (ds.Tables[1].Rows.Count > 0) ▸ if (txtApproval.Text == "" && null != ds.Tables[1] && ds.Tables[1].Rows.Count > 0) ▸ else of (UserInfoCon… | VALUE_SET | txtAppDeptName.Text | ds.Tables[1].Rows[0]["DEPT_NAME_EN"].ToString() | 컨트롤 값 설정 |  |  |  |

## SSP0200_ShipmentChangeRequest.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a907bf07 | this.Load | SSP0200_ShipmentChangeRequest.cs:316 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0200_ShipmentChangeRequest.GetDayRange

진입점: this.Load / cboChangeType.SelectedIndexChanged [if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cccab953 | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:3129 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-e837bbb3 | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:3130 |  | DATA_OP | request.Parameters["p_from_date"] | sFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-5875795d | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:3131 |  | DATA_OP | request.Parameters["p_offset_day"] | "30" | 행/컬럼 값 대입 |  |  |  |
| AC-015152e5 | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:3132 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-675e050a | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:3133 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c2f042ac | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:3136 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d51b9dc | this.Load | SSP0200_ShipmentChangeRequest.cs:6781 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_GET_SHIPMENT_DIVISION") ⇒ SSP.SSP0200_GET_SHIPMENT_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-ca742486 | this.Load | SSP0200_ShipmentChangeRequest.cs:6782 |  | DATA_OP | request.Parameters["Param1"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-598bdb02 | this.Load | SSP0200_ShipmentChangeRequest.cs:6783 |  | DATA_OP | request.Parameters["Param2"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3bea771a | this.Load | SSP0200_ShipmentChangeRequest.cs:6784 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e81e08f4 | this.Load | SSP0200_ShipmentChangeRequest.cs:6786 |  | FLAG | dtMyDivision | response.Tables[0].Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-1dadc440 | this.Load | SSP0200_ShipmentChangeRequest.cs:6786 |  | DATA_OP | response.Tables[0].Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4bad5865 | this.Load | SSP0200_ShipmentChangeRequest.cs:6786 |  | DATA_OP | response.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8f222439 | this.Load | SSP0200_ShipmentChangeRequest.cs:6787 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0200_ShipmentChangeRequest.GetErpIFCheck

진입점: btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!string.IsNullOrWhiteSpace(p_change_request_no))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b84f3ade | btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.Da… | SSP0200_ShipmentChangeRequest.cs:4919 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-709c73c5 | btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.Da… | SSP0200_ShipmentChangeRequest.cs:4928 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-730d7331 | btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.Da… | SSP0200_ShipmentChangeRequest.cs:4930 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_confirm_id"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-00595478 | btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.Da… | SSP0200_ShipmentChangeRequest.cs:4931 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-011b9041 | btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.Da… | SSP0200_ShipmentChangeRequest.cs:4932 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_del_flag"] | "E" | 행/컬럼 값 대입 |  |  |  |
| AC-4cd6e2e4 | btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.Da… | SSP0200_ShipmentChangeRequest.cs:4933 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-803a53e6 | btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.Da… | SSP0200_ShipmentChangeRequest.cs:4934 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-343a5b76 | btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.Da… | SSP0200_ShipmentChangeRequest.cs:4935 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_if_send_flag"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-b1ce279d | btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.Da… | SSP0200_ShipmentChangeRequest.cs:4936 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-e4dfed98 | btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.Da… | SSP0200_ShipmentChangeRequest.cs:4938 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a6a91607 | btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.Da… | SSP0200_ShipmentChangeRequest.cs:4949 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c6fa7be | btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.Da… | SSP0200_ShipmentChangeRequest.cs:4956 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-91c9be98 | btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.Da… | SSP0200_ShipmentChangeRequest.cs:4961 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (service.RtFlag == "C_E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-442384c7 | btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.Da… | SSP0200_ShipmentChangeRequest.cs:4972 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.GetErpIFCheckNew

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!string.IsNullOrWhiteSpace(sRequestNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb749b54 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4984 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c479f4b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4993 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (service.ReErrorMsg.EndsWith("^")) | UI_PROP | service.ReErrorMsg | service.ReErrorMsg.Substring(0, service.ReErrorMsg.Length - 1) | 속성 ReErrorMsg 설정 |  |  |  |
| AC-1f7eaf63 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5000 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ for (iCount < arrReMsg.Length) | DATA_OP | errConfirmList.Add | (arrReMsg[iCount] + ":" + RequestNo) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f24ca52 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5009 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM") ⇒ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-419af9a2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5011 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-8b6163ac | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5012 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-cacfbd5f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5013 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-64118087 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5014 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2aa2c53c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5015 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-697fb996 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5016 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_if_send_flag"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-b7e638af | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5017 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-c8649f8b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5019 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bffe19d6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5036 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | bActiveList.Add | (bFlag) | 데이터 객체 조작/조회 |  |  |  |
| AC-1379560a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5041 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | FLAG | F_CE_requestNo | RequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-03a7ae16 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5048 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | bActiveList.Add | (bFlag) | 데이터 객체 조작/조회 |  |  |  |
| AC-422a425f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5054 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.GetErpIFSeqMerge

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ else of (string.IsNullOrWhiteSpace(erpSoNo)) ▸ try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!string.IsNullOrWhiteSpace(sRequestNo)) ▸ if (iCount > 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09714cda | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5067 | try | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE") ⇒ SSP.PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE | 엔드포인트 요청 생성 |  |  |  |
| AC-a8ea816c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5069 | try | DATA_OP | request.Parameters["p_change_request_no"] | RequestNo | 행/컬럼 값 대입 |  |  |  |
| AC-2b6ed881 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5070 | try | DATA_OP | request.Parameters["p_status"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-5c5c75ca | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5071 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e1a20ab5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:5080 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.GetERPInterface

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41caea21 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3837 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b576a4e3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3847 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | DATA_OP | (siMain.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-56ea9f8b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3853 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00247", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5ad4d056 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3854 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-cafa4aa0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3862 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d156b49c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3863 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0962a39f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3950 | try ▸ if (errConfirmList.Count > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM") ⇒ SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-f8757677 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3952 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-d7a98bad | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3953 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-975166ea | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3954 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_e_type"] | "E" | 행/컬럼 값 대입 |  |  |  |
| AC-f4dd295a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3955 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_e_message"] | p_e_message | 행/컬럼 값 대입 |  |  |  |
| AC-2bdb5f11 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3956 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0de1c1dd | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3958 | try ▸ if (errConfirmList.Count > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-299580ad | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3964 | try ▸ if (errConfirmList.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-33680e80 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3989 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-b9601142 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3991 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id_F_CE | 행/컬럼 값 대입 |  |  |  |
| AC-027083cb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3992 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_change_request_no"] | reqNo | 행/컬럼 값 대입 |  |  |  |
| AC-4ddc9eeb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3993 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-adb774cb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3994 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-dc54eb8e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3995 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-79666bf4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3996 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_if_send_flag"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-5387b197 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3997 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-b3e6062d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3999 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d2337b98 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4005 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | CALL_EXT | service.FN_ERP_UIWebService | (F_CE_requestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-54ae58c1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4010 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0efef3f5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4016 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-65418a7a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4019 | finally | STATE_RESET | bActiveList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-634974c9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4020 | finally | STATE_RESET | errConfirmList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ac9a60e8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4021 | finally | FLAG | F_CE_requestNo | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-cea296d2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4024 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.GetErpSoNoCnt

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f0a11cf | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4161 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_GET_ERP_SO_NO_CNT") ⇒ SSP.SSP0200_GET_ERP_SO_NO_CNT | 엔드포인트 요청 생성 |  |  |  |
| AC-bf95138f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4162 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-6c0e2128 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4163 | try | DATA_OP | request.Parameters["p_erp_so_no"] | sErpSoNo | 행/컬럼 값 대입 |  |  |  |
| AC-3ba8f522 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4165 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-76bc7653 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4173 | catch ((Exception ex)) | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |
| AC-9702b5e8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4175 |  | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.GetItemFromBOD

진입점: this.btnInsertMultiple.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < inputCount)] / dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.REMARKS) \|\| e.Column == siMain.GetColumnIndex(DefColumns.REMARKS2)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIR…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94d508e2 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 1 | SSP0200_ShipmentChangeRequest.cs:6756 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_GET_ITEM_FROM_BOD") ⇒ SSP.SSP0200_GET_ITEM_FROM_BOD | 엔드포인트 요청 생성 |  |  |  |
| AC-7dc40c0f | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 1 | SSP0200_ShipmentChangeRequest.cs:6758 |  | DATA_OP | request.Parameters["p_division_id"] | sdivision | 행/컬럼 값 대입 |  |  |  |
| AC-8842ad13 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 1 | SSP0200_ShipmentChangeRequest.cs:6759 |  | DATA_OP | request.Parameters["p_from_site_id"] | sFromSite | 행/컬럼 값 대입 |  |  |  |
| AC-a68003a7 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 1 | SSP0200_ShipmentChangeRequest.cs:6760 |  | DATA_OP | request.Parameters["p_to_site_id"] | sToSite | 행/컬럼 값 대입 |  |  |  |
| AC-98cda812 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 1 | SSP0200_ShipmentChangeRequest.cs:6761 |  | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-24cb6a64 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 1 | SSP0200_ShipmentChangeRequest.cs:6762 |  | DATA_OP | request.Parameters["p_bod_id"] | sBod | 행/컬럼 값 대입 |  |  |  |
| AC-a719aefe | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 1 | SSP0200_ShipmentChangeRequest.cs:6764 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b51df3af | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 1 | SSP0200_ShipmentChangeRequest.cs:6769 | if (ds.Good()) | CALL_EXT | Item.ClassToItem | (ds) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ad8a24c | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 1 | SSP0200_ShipmentChangeRequest.cs:6770 | if (ds.Good()) | RETURN | return rets; |  | 처리 중단/반환 |  |  |  |
| AC-298be22e | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 1 | SSP0200_ShipmentChangeRequest.cs:6773 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.GetNewERPInterface

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ else of (!GetERPInterface()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09bbf9b6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4048 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (DateTime.TryParse(siMain.GetText(i, siMain.GetColu… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e68ba1df | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4049 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (DateTime.TryParse(siMain.GetText(i, siMain.GetColu… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-99e0bba5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4083 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-da794265 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4085 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.GetPlantSiteByDivisionEEOperation

진입점: this.btnInsertMultiple.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < inputCount) ▸ if (DIVISION_ID != "EE")] / btnNew.Click [if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.SelectedValue.ToString() != "EE")] / this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE")] / InsertB…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a209867e | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 3 | SSP0200_ShipmentChangeRequest.cs:6812 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION") ⇒ SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION | 엔드포인트 요청 생성 |  |  |  |
| AC-665b5c18 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 3 | SSP0200_ShipmentChangeRequest.cs:6813 |  | DATA_OP | request.Parameters["Param1"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-cb5be49d | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 3 | SSP0200_ShipmentChangeRequest.cs:6814 |  | DATA_OP | request.Parameters["Param2"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b8ca4c06 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 3 | SSP0200_ShipmentChangeRequest.cs:6815 |  | DATA_OP | request.Parameters["Param3"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-faec8052 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 3 | SSP0200_ShipmentChangeRequest.cs:6816 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-76b07e61 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 3 | SSP0200_ShipmentChangeRequest.cs:6818 |  | RETURN | return response.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.GetShipmentPlanPlantSite

진입점: this.Load / clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fb410e5 | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:6798 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE") ⇒ SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 엔드포인트 요청 생성 |  |  |  |
| AC-be25c3ce | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:6799 |  | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-e6aebc3b | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:6800 |  | DATA_OP | request.Parameters["p_now_group_id"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-34aadf58 | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:6801 |  | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cfe7d455 | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:6802 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-326528e2 | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:6804 |  | RETURN | return response.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.GetShipmentStatusChk

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0cdfc2c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4096 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_GET_SHIPMENT_STATUS") ⇒ SSP.SSP0200_GET_SHIPMENT_STATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-4c38b6be | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4097 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-b12cde76 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4098 | try | DATA_OP | request.Parameters["p_confirm_id"] | sConfirmID | 행/컬럼 값 대입 |  |  |  |
| AC-24ddec5b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4100 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6e786aba | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4115 | try ▸ if (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00248", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e6644cf7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4129 | try ▸ if (ds.Tables[1].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00249", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-324d0ef2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4144 | try ▸ if (ds.Tables[2].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00189", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-06d4b784 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4148 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-94f353bf | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4150 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b553c1b | this.Load | SSP0200_ShipmentChangeRequest.cs:455 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-4af4fb33 | this.Load | SSP0200_ShipmentChangeRequest.cs:456 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtSub) | 데이터 객체 조작/조회 |  |  |  |
| AC-57582394 | this.Load | SSP0200_ShipmentChangeRequest.cs:458 |  | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-577b1d03 | this.Load | SSP0200_ShipmentChangeRequest.cs:471 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8f32966d | this.Load | SSP0200_ShipmentChangeRequest.cs:475 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl1) | 권한 검사/설정 |  |  |  |
| AC-6bd4a0f4 | this.Load | SSP0200_ShipmentChangeRequest.cs:476 | if (dtMyDivision.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e9ac744c | this.Load | SSP0200_ShipmentChangeRequest.cs:479 |  | DATA_OP | dtChangeStatusCode.Rows.RemoveAt | (0) | 데이터 객체 조작/조회 |  |  |  |
| AC-57a6c039 | this.Load | SSP0200_ShipmentChangeRequest.cs:481 |  | FLAG | dtMyDivision | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-ca3e282d | this.Load | SSP0200_ShipmentChangeRequest.cs:481 |  | DATA_OP | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aa50a1bd | this.Load | SSP0200_ShipmentChangeRequest.cs:481 |  | DATA_OP | dtMyDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-97479659 | this.Load | SSP0200_ShipmentChangeRequest.cs:485 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d23e162e | this.Load | SSP0200_ShipmentChangeRequest.cs:487 |  | CALL_EXT | clsCtrl.setListBoxEx | (dtChangeReasonCode, cboChangeReason, true, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4785ef9 | this.Load | SSP0200_ShipmentChangeRequest.cs:489 |  | LIST_REBIND | clsCtrl.setListBox | (dtChangeStatusCode, cboStatus, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4c23a37c | this.Load | SSP0200_ShipmentChangeRequest.cs:491 |  | LIST_REBIND | clsCtrl.setListBox | (dtChangeReqType, cboChangeType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9847e846 | this.Load | SSP0200_ShipmentChangeRequest.cs:493 |  | VALUE_SET | cboChangeType.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |
| AC-2de900a4 | this.Load | SSP0200_ShipmentChangeRequest.cs:500 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange("") | 컨트롤 값 설정 |  |  |  |
| AC-f8edb3ed | this.Load | SSP0200_ShipmentChangeRequest.cs:502 |  | VALUE_SET | dtDate.InitValue | Convert.ToDateTime(DateTime.Now.Date).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-cb900abc | this.Load | SSP0200_ShipmentChangeRequest.cs:505 | if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-a03a9559 | this.Load | SSP0200_ShipmentChangeRequest.cs:507 |  | FLAG | dBaseDate | Convert.ToDateTime(dtDate.Value).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-c9ca917c | this.Load | SSP0200_ShipmentChangeRequest.cs:509 |  | FLAG | sRequestID | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-c9b24017 | this.Load | SSP0200_ShipmentChangeRequest.cs:513 | if (UserInfoContext.Current[UserInfoProperites.Language] == "KO") | VALUE_SET | txtRequestor.Text | UserInfoContext.Current[UserInfoProperites.UserName].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f4358b8e | this.Load | SSP0200_ShipmentChangeRequest.cs:517 | else of (UserInfoContext.Current[UserInfoProperites.Language] == "KO") | VALUE_SET | txtRequestor.Text | UserInfoContext.Current[UserInfoProperites.UserName_E].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-6b575823 | this.Load | SSP0200_ShipmentChangeRequest.cs:520 |  | FLAG | sRequestName | txtRequestor.Text + "(" + UserInfoContext.Current.UserId + ")" | 화면 필드/플래그 변경 |  |  |  |
| AC-45de8c75 | this.Load | SSP0200_ShipmentChangeRequest.cs:522 |  | VALUE_SET | txtRequestDeptName.Text | UserInfoContext.Current[UserInfoProperites.Dept_Name] | 컨트롤 값 설정 |  |  |  |
| AC-1b8aeeea | this.Load | SSP0200_ShipmentChangeRequest.cs:523 |  | FLAG | sRequestDeptID | UserInfoContext.Current[UserInfoProperites.Dept_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-be651482 | this.Load | SSP0200_ShipmentChangeRequest.cs:525 |  | FLAG | sLanguage | UserInfoContext.Current[UserInfoProperites.Language] | 화면 필드/플래그 변경 |  |  |  |
| AC-192d65d4 | this.Load | SSP0200_ShipmentChangeRequest.cs:530 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMaxShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[0]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-56649b7a | this.Load | SSP0200_ShipmentChangeRequest.cs:531 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMinShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[1]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-f9c8a9d4 | this.Load | SSP0200_ShipmentChangeRequest.cs:532 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMaxDay | dtShipmentInputPeriod.Rows[0]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a38ddd37 | this.Load | SSP0200_ShipmentChangeRequest.cs:533 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMinDay | dtShipmentInputPeriod.Rows[1]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-76467f2d | this.Load | SSP0200_ShipmentChangeRequest.cs:539 |  | CALL_EXT | lcSave.Move | (dragController) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0200_ShipmentChangeRequest.InitSpread

진입점: this.Load / clbDivision_ID.SelectedIndexChanged / btnSave.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnChangeRe2.Click [if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R)] / btnCancel.Click [if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / cboChangeType.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bb21d17 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:596 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-0a2c37fe | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:598 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-3e9223a8 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:600 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | UI_MISC | spreadInfo.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1b338904 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:601 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-534a1e4b | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:607 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | spdMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ERP_SO_NO)].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-5d68ddbb | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:608 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | spdMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CONFIRM_ID)].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-6e8af61d | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:613 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | UI_PROP | col.Label | MessageHelper.GetTerm(sFieldName) | 속성 Label 설정 |  |  |  |
| AC-da3d758a | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:618 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | spdMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ERP_SO_NO)].Width | 100 | 그리드 속성/값 설정 |  |  |  |
| AC-97597932 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:619 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | spdMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CONFIRM_ID)].Width | 120 | 그리드 속성/값 설정 |  |  |  |
| AC-7e092a7b | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:625 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | UI_PROP | col.Label | MessageHelper.GetTerm(sFieldName) | 속성 Label 설정 |  |  |  |
| AC-85f9fab1 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:630 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.END_CUSTOMER)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f7dcd3fd | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:631 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-53869954 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:632 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2b70f6a6 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:635 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ERP_ATTR1)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c57b1c35 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:636 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ERP_ATTR2)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-38d7de09 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:637 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ERP_ATTR3)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ae9ab6ab | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:641 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedV… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.END_CUSTOMER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b69f227b | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:642 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedV… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-26549fc6 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:643 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedV… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_NAME)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1f95fac8 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:646 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedV… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ERP_ATTR1)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-348491ec | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:647 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedV… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ERP_ATTR2)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7f187d6d | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:648 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedV… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ERP_ATTR3)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-54113abe | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:650 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | UI_MISC | spreadInfo.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-09db86e6 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:656 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-40fa68a8 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:659 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-2f69ea4b | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:660 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY), 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7e5b6d3f | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:672 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ try | GRID_SET | spreadInfo.ActiveSheet.ColumnHeader.Cells[0, spreadInfo.GetColumnIndex(DefColumns.CHK)].Ce… | chk | 그리드 속성/값 설정 |  |  |  |
| AC-5430781d | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:673 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ try | GRID_SET | spreadInfo.ActiveSheet.ColumnHeader.Cells[0, spreadInfo.GetColumnIndex(DefColumns.CHK)].Va… | false | 그리드 속성/값 설정 |  |  |  |
| AC-32fb5c0c | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:674 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ try | GRID_SET | spreadInfo.ActiveSheet.ColumnHeader.Cells[0, spreadInfo.GetColumnIndex(DefColumns.CHK)].Bo… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-10427b18 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:678 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ try | UI_PROP | col.MergePolicy | FarPoint.Win.Spread.Model.MergePolicy.None | 속성 MergePolicy 설정 |  |  |  |
| AC-a9b6f19a | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:685 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d27ed61a | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:690 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (new_ship_qty > 0) | CALL_EXT | spreadInfo.SetDecimal | (new_ship_qty, new_ship_qty, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-342851bf | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:693 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (ship_qty >0) | CALL_EXT | spreadInfo.SetDecimal | (ship_qty, ship_qty, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6922324c | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:696 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | spdSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.REMARKS)].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-e4d633cd | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:701 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ERP_SO_NO)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-adda14e8 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:703 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.LT_DAY), 1, 6, 20, "Plan", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8934cc8d | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:704 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 1, 6, 20, "Confirm", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17b742b9 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:706 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e9e2da4 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:707 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ad3a2d3 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:708 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d952ca8 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:709 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b4e06ca1 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:710 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_DATE), 2, 1, 30, "Shipment Date", FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33916943 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:711 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bed705a9 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:713 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c890aa8b | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:714 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a5a90229 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:715 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f4caaf8d | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:716 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8c1d4b01 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:717 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), 2, 1, 30, "Shipment Date*", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f11513b3 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:718 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty*", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4cef281c | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:723 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ERP_SO_NO)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e518e900 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:725 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.LT_DAY), 1, 6, 20, "Confirmed", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2f0fa666 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:726 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 1, 6, 20, "Change", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ac64b411 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:728 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48f55235 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:729 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-523817d4 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:730 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d3baa09 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:731 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-04913de1 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:732 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_DATE), 2, 1, 30, "Shipment Date", FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b42fc772 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:733 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9d799e2c | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:735 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c0fd05b4 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:736 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0e88a4dd | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:737 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cd033ccc | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:738 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-456a994c | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:739 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), 2, 1, 30, "Shipment Date*", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2ddc5ac6 | this.Load 외 7 | SSP0200_ShipmentChangeRequest.cs:740 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (cboChangeType.SelectedValue.ToString() == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty*", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0200_ShipmentChangeRequest.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd1d4190 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2682 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-072d30df | InsertButton | SSP0200_ShipmentChangeRequest.cs:2716 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | FLAG | dtFromSite | GetPlantSiteByDivisionEEOperation(DIVISION_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-4840287b | InsertButton | SSP0200_ShipmentChangeRequest.cs:2718 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteByDivisionEEForSSP, false, DIVISION_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-5d29efd6 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2718 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteByDivisionEEForSSP, false, DIVISION_ID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e2bd92dc | InsertButton | SSP0200_ShipmentChangeRequest.cs:2728 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION), dtFromSit… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d383bd92 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2729 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTION), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-495e6ada | InsertButton | SSP0200_ShipmentChangeRequest.cs:2733 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-0097ce05 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2734 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.ITEM_ID, ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8d1aca2 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2735 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.FROM_SITE_DESCRIPTION, FROM_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-84f8a5fd | InsertButton | SSP0200_ShipmentChangeRequest.cs:2736 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.TO_SITE_DESCRIPTION, TO_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-130765f8 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2740 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.END_CUSTOMER, PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-db82869a | InsertButton | SSP0200_ShipmentChangeRequest.cs:2741 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.PROJECT_CODE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-ebb5eb87 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2746 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.PROJECT_CODE, PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-8506dd73 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2747 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.END_CUSTOMER, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-7b6afd59 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2749 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_CONFIRM_QTY, SHIPMENT_CONFIRM_QTY) | 데이터 객체 조작/조회 |  |  |  |
| AC-18fe3fbf | InsertButton | SSP0200_ShipmentChangeRequest.cs:2750 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_DATE, SHIPMENT_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9110d4a | InsertButton | SSP0200_ShipmentChangeRequest.cs:2751 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.INCOTERMS, INCOTERMS) | 데이터 객체 조작/조회 |  |  |  |
| AC-06b53ded | InsertButton | SSP0200_ShipmentChangeRequest.cs:2752 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.TRANSPORT_MODE, TRANSPORT_MODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-6873b4ab | InsertButton | SSP0200_ShipmentChangeRequest.cs:2753 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.FCST_TYPE, FCST_TYPE) | 데이터 객체 조작/조회 |  |  |  |
| AC-737faf10 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2758 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.NICK_NAME, NICK_NAME) | 데이터 객체 조작/조회 |  |  |  |
| AC-48771726 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2759 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.MTK_OWNER, MTK_OWNER) | 데이터 객체 조작/조회 |  |  |  |
| AC-4afb3806 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2761 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-ca84b218 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2763 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-d8db6f10 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2764 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-76e5bc33 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2765 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-20ad2e9c | InsertButton | SSP0200_ShipmentChangeRequest.cs:2767 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0faec016 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2768 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ERP_SO_NO), siMain.GetColumnIndex(DefColumns.SH… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4fa9ea10 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2769 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-14a1d15a | InsertButton | SSP0200_ShipmentChangeRequest.cs:2770 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a925b2a | InsertButton | SSP0200_ShipmentChangeRequest.cs:2771 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.REQUESTOR) - 1, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-103b66c9 | InsertButton | SSP0200_ShipmentChangeRequest.cs:2772 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TO_SITE_SOLDTO_CODE), siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0200_ShipmentChangeRequest.InsertRowMultiple

진입점: this.btnInsertMultiple.Click [if (popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1600ff99 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2792 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a6586839 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2842 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | FLAG | dtFromSite | GetPlantSiteByDivisionEEOperation(DIVISION_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-1fdbb451 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2844 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteByDivisionEEForSSP, false, DIVISION_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-170081fb | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2844 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteByDivisionEEForSSP, false, DIVISION_ID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dc1b2a1f | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2854 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION), dtFromSit… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-36377bee | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2855 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTION), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-69e1ff59 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2859 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-50f132b9 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2860 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.ITEM_ID, ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-7283880b | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2861 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.FROM_SITE_DESCRIPTION, FROM_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-8256e43d | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2862 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.TO_SITE_DESCRIPTION, TO_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-99e18382 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2866 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.END_CUSTOMER, PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-51bbe0d8 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2867 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.PROJECT_CODE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-b091d0b2 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2872 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.PROJECT_CODE, PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4d21c09 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2873 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.END_CUSTOMER, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-e55ac0fa | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2875 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_CONFIRM_QTY, SHIPMENT_CONFIRM_QTY) | 데이터 객체 조작/조회 |  |  |  |
| AC-aefc16f1 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2876 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_DATE, SHIPMENT_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-98d276ae | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2877 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.INCOTERMS, INCOTERMS) | 데이터 객체 조작/조회 |  |  |  |
| AC-29094878 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2878 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.TRANSPORT_MODE, TRANSPORT_MODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6ab0516 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2879 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.FCST_TYPE, FCST_TYPE) | 데이터 객체 조작/조회 |  |  |  |
| AC-867832a8 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2884 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.NICK_NAME, NICK_NAME) | 데이터 객체 조작/조회 |  |  |  |
| AC-2398ef87 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2885 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | DATA_OP | defaultData.Add | (DefColumns.MTK_OWNER, MTK_OWNER) | 데이터 객체 조작/조회 |  |  |  |
| AC-d34b9f86 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2887 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-b1012c03 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2890 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-77d41630 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2891 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-28d25a41 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2893 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-db776828 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2894 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ERP_SO_NO), siMain.GetColumnIndex(DefColumns.SH… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ab0fee55 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2895 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ec341cd0 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2896 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ff761a84 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2897 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.REQUESTOR) - 1, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-989be90f | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2898 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TO_SITE_SOLDTO_CODE), siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4c39cf8e | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2900 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d22b21f5 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2904 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | CALL_EXT | siMain.SetDecimal | (siMain.ActiveRowIndex, qty_idx, siMain.ActiveRowIndex, qty_idx, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-36b0688b | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2908 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | CALL_EXT | siMain.SetDecimal | (siMain.ActiveRowIndex, qty_idx, siMain.ActiveRowIndex, qty_idx, 0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b272028 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… | SSP0200_ShipmentChangeRequest.cs:2910 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0200_ShipmentChangeRequest.NewNonSoNo

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ else of (!GetERPInterface()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a26b872d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4297 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-93d4b99f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4301 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-927b3437 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4302 |  | DATA_OP | request.Parameters["p_change_type"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-b613bb17 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4303 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-fa932d57 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4304 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-730e7e86 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4305 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-e4175278 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4306 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-9c17e29a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4307 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-4aa042c9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4308 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-8008fe2d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4309 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-5da78656 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4310 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-48c4f48f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4311 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-3ef6c5aa | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4312 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-238abd65 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4313 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-320508d4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4314 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-4337c5b6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4315 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-19d44738 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4316 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-39afde22 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4317 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-f078c777 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4318 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-7c3ad7e9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4319 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-2653b0fa | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4320 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-3d8eb00a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4321 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-a983b14b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4322 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-3194d7e0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4323 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-8229645f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4324 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-f9d1664c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4325 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-2a1dfe8c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4326 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-afc3ebd1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4327 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0aca46b3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4328 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e2dfb31e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4330 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-abd38028 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4331 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-f13ee06a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4332 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-b3a45304 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4334 |  | DATA_OP | request.Parameters["p_change_req_no"] | _ChangeReqno | 행/컬럼 값 대입 |  |  |  |
| AC-3a284390 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4336 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-e11fc8cd | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4337 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-17035b88 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4338 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-7069765d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4339 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-0558500b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4342 |  | DATA_OP | request.Parameters["p_erp_attr1"] | p_erp_attr1 | 행/컬럼 값 대입 |  |  |  |
| AC-e122ec4c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4343 |  | DATA_OP | request.Parameters["p_erp_attr2"] | p_erp_attr2 | 행/컬럼 값 대입 |  |  |  |
| AC-3ab9a1e4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4344 |  | DATA_OP | request.Parameters["p_erp_attr3"] | p_erp_attr3 | 행/컬럼 값 대입 |  |  |  |
| AC-c3b752ad | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4347 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-308a1b80 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4379 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-06d08a7b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4383 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.NonSoNo

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68b016e8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4491 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-5f1d9c8d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4495 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b425c11c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4496 |  | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-08bdf8b0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4497 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-644707e9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4498 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-c2640152 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4499 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-a82180e0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4500 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-3220f7ef | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4501 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-5f73e0e8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4502 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-9c54ce41 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4503 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-86aa1a6a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4504 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-8941b9b8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4505 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-d8c7b762 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4506 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-20863ebf | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4507 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-1eb76198 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4508 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-dcf729d7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4509 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-124534a5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4510 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-54ab3e87 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4511 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-922b1f40 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4512 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-9c90793c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4513 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-99331299 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4514 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-9b5ae2c6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4515 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-918213b9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4516 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-009634d1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4517 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-8bfad84c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4518 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-6041057f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4519 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-483e6191 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4520 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-e3450f2e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4521 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-448e0f0e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4522 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0b93ad24 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4524 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-836ec37e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4525 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-1817f19a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4526 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-39e5cfa6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4528 |  | DATA_OP | request.Parameters["p_change_req_no"] | _ChangeReqno | 행/컬럼 값 대입 |  |  |  |
| AC-d9a343c3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4530 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-c2c19c3f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4531 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-9f05caf8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4532 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-75a9741a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4533 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-52e6430f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4536 |  | DATA_OP | request.Parameters["p_erp_attr1"] | p_erp_attr1 | 행/컬럼 값 대입 |  |  |  |
| AC-6213cbc1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4537 |  | DATA_OP | request.Parameters["p_erp_attr2"] | p_erp_attr2 | 행/컬럼 값 대입 |  |  |  |
| AC-6506630d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4538 |  | DATA_OP | request.Parameters["p_erp_attr3"] | p_erp_attr3 | 행/컬럼 값 대입 |  |  |  |
| AC-cd8f212c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4541 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1f00c555 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4578 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ try ▸ if (ds.Tables[0].Rows[0]["reaso… | MESSAGE | MessageBox.Show | (error_message) | 메시지 표시 |  |  |  |
| AC-5380d80b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4591 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ try ▸ else of (ds.Tables[0].Rows[0]["… | MESSAGE | MessageBox.Show | (error_message) | 메시지 표시 |  |  |  |
| AC-51923326 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4601 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ if (check_error_type == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00293", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14553b34 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4619 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ee960144 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4624 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-170d2ef0 | SaveButton | SSP0200_ShipmentChangeRequest.cs:850 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | _ChangeReqno | null | 화면 필드/플래그 변경 |  |  |  |
| AC-863029d4 | SaveButton | SSP0200_ShipmentChangeRequest.cs:859 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (chkERPIFBlockYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79bd4b44 | SaveButton | SSP0200_ShipmentChangeRequest.cs:862 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_GET_CHANGE_REQ_NO") ⇒ SSP.SSP0200_GET_CHANGE_REQ_NO | 엔드포인트 요청 생성 |  |  |  |
| AC-d663092b | SaveButton | SSP0200_ShipmentChangeRequest.cs:866 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | requestTemp.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1c14c638 | SaveButton | SSP0200_ShipmentChangeRequest.cs:868 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | client.ExecuteDataSet | (requestTemp) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c052bcb0 | SaveButton | SSP0200_ShipmentChangeRequest.cs:872 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dsTemp.Tables[0].Rows[0][0… | FLAG | _ChangeReqno | dsTemp.Tables[0].Rows[0][1].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8eda3e84 | SaveButton | SSP0200_ShipmentChangeRequest.cs:879 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-a6a061dd | SaveButton | SSP0200_ShipmentChangeRequest.cs:882 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef970861 | SaveButton | SSP0200_ShipmentChangeRequest.cs:886 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-42020502 | SaveButton | SSP0200_ShipmentChangeRequest.cs:894 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b9f35180 | SaveButton | SSP0200_ShipmentChangeRequest.cs:915 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b12722d3 | SaveButton | SSP0200_ShipmentChangeRequest.cs:917 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0dfd1bd9 | SaveButton | SSP0200_ShipmentChangeRequest.cs:920 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3662af96 | SaveButton | SSP0200_ShipmentChangeRequest.cs:927 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageBox.Show | ("변경 실패") | 메시지 표시 |  |  |  |
| AC-274e8885 | SaveButton | SSP0200_ShipmentChangeRequest.cs:940 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9e670d64 | SaveButton | SSP0200_ShipmentChangeRequest.cs:941 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-65f1c950 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1054 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ae43b4b0 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1056 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW") ⇒ SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW | 엔드포인트 요청 생성 |  |  |  |
| AC-d783037d | SaveButton | SSP0200_ShipmentChangeRequest.cs:1062 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6ed367b5 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1063 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2f91ebf5 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1064 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-62365fbc | SaveButton | SSP0200_ShipmentChangeRequest.cs:1065 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-e5673cb8 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1066 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_project_code40"] | p_project_code40 | 행/컬럼 값 대입 |  |  |  |
| AC-0a88c5e2 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1067 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-bfee9e8a | SaveButton | SSP0200_ShipmentChangeRequest.cs:1068 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-d6b4caa8 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1069 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-1d380d70 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1070 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-dc91fa39 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1071 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-341de13d | SaveButton | SSP0200_ShipmentChangeRequest.cs:1072 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-6d541eb0 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1073 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-5b7ab2e8 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1074 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_lt"] | p_lt | 행/컬럼 값 대입 |  |  |  |
| AC-86b5167b | SaveButton | SSP0200_ShipmentChangeRequest.cs:1075 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_etd"] | p_etd | 행/컬럼 값 대입 |  |  |  |
| AC-4b846d03 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1076 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_eta"] | p_eta | 행/컬럼 값 대입 |  |  |  |
| AC-6daf51b0 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1077 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_route_id"] | p_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-dc25fd1e | SaveButton | SSP0200_ShipmentChangeRequest.cs:1078 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-232e055e | SaveButton | SSP0200_ShipmentChangeRequest.cs:1079 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_d_country"] | p_d_country | 행/컬럼 값 대입 |  |  |  |
| AC-74701d82 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1080 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_d_port_code"] | p_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-cc4193fe | SaveButton | SSP0200_ShipmentChangeRequest.cs:1081 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_a_conuntry"] | p_a_conuntry | 행/컬럼 값 대입 |  |  |  |
| AC-afc48e52 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1082 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_a_port_code"] | p_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-2b4fc427 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1083 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_to_country"] | p_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-3b4682f5 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1084 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_to_city"] | p_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-e0359a88 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1085 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-c110f405 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1086 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-506507ef | SaveButton | SSP0200_ShipmentChangeRequest.cs:1087 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-dc18efa5 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1090 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c5ae5825 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1091 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_time_zone"] | p_time_zone | 행/컬럼 값 대입 |  |  |  |
| AC-b765a4d1 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1094 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_erp_attr1"] | p_erp_attr1 | 행/컬럼 값 대입 |  |  |  |
| AC-5bb52212 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1095 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_erp_attr2"] | p_erp_attr2 | 행/컬럼 값 대입 |  |  |  |
| AC-c15a8708 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1096 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | DATA_OP | request.Parameters["p_erp_attr3"] | p_erp_attr3 | 행/컬럼 값 대입 |  |  |  |
| AC-4a8365fa | SaveButton | SSP0200_ShipmentChangeRequest.cs:1099 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-571c9e88 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1101 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-25c5aad6 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1111 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageBox.Show | ("신규 생성 요청 실패") | 메시지 표시 |  |  |  |
| AC-7e698371 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1121 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00261", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aa759e09 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1126 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00328", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ba7b9e3e | SaveButton | SSP0200_ShipmentChangeRequest.cs:1132 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4653b12f | SaveButton | SSP0200_ShipmentChangeRequest.cs:1149 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageBox.Show | (error_message) | 메시지 표시 |  |  |  |
| AC-30dd2ef4 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1162 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageBox.Show | (error_message) | 메시지 표시 |  |  |  |
| AC-fe804880 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1173 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1409afbf | SaveButton | SSP0200_ShipmentChangeRequest.cs:1175 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-591a71ea | SaveButton | SSP0200_ShipmentChangeRequest.cs:1193 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47bc0fab | SaveButton | SSP0200_ShipmentChangeRequest.cs:1200 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4b5263cc | SaveButton | SSP0200_ShipmentChangeRequest.cs:1206 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-66221224 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1216 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3bae7739 | SaveButton | SSP0200_ShipmentChangeRequest.cs:1222 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequir… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0200_ShipmentChangeRequest.SaveDataDrafting

진입점: btnSave.Click / btnChangeRe2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d954b97 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2319 | if (sShipStatus == Shipment_Status.S_Status_R) | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-38907602 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2319 | if (sShipStatus == Shipment_Status.S_Status_R) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a37cd5b5 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2390 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (DateTime.TryParse(siSub.GetText(i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)).ToStr… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc21686e | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2391 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (DateTime.TryParse(siSub.GetText(i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)).ToStr… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bbcfaee2 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2463 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE") ⇒ SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE | 엔드포인트 요청 생성 |  |  |  |
| AC-c9a4c9f9 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2471 | if (iCount > 0) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-953bcad9 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2473 | if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-55e368f1 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2474 | if (iCount > 0) | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-24503220 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2475 | if (iCount > 0) | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-962e30da | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2476 | if (iCount > 0) | DATA_OP | request.Parameters["p_request_id"] | p_request_id | 행/컬럼 값 대입 |  |  |  |
| AC-ab4cf117 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2477 | if (iCount > 0) | DATA_OP | request.Parameters["p_request_dept_id"] | p_request_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc62ac06 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2478 | if (iCount > 0) | DATA_OP | request.Parameters["p_approval_id"] | p_approval_id | 행/컬럼 값 대입 |  |  |  |
| AC-e111ae88 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2479 | if (iCount > 0) | DATA_OP | request.Parameters["p_approval_dept_id"] | p_approval_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-bf99d0fe | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2480 | if (iCount > 0) | DATA_OP | request.Parameters["p_change_reason"] | p_change_reason | 행/컬럼 값 대입 |  |  |  |
| AC-cd5f70f2 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2481 | if (iCount > 0) | DATA_OP | request.Parameters["p_reason_detail"] | p_reason_detail | 행/컬럼 값 대입 |  |  |  |
| AC-940dabae | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2482 | if (iCount > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-7c702daa | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2483 | if (iCount > 0) | DATA_OP | request.Parameters["p_main_confirm_id"] | p_main_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-6cf9b036 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2484 | if (iCount > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-0f572520 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2485 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_confirm_id"] | p_new_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-fc5dcb99 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2487 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-a23d5f8b | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2488 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-2bc87857 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2489 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-06c30c98 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2490 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-36a10477 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2491 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-6cc6adba | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2492 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-8e262edd | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2493 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-be3bc4bb | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2494 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-8bb6de5f | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2495 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-f1d01b9e | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2496 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_lt_day"] | p_new_lt_day | 행/컬럼 값 대입 |  |  |  |
| AC-1cdfe551 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2498 | if (iCount > 0) | DATA_OP | request.Parameters["p_change_status"] | sChangeStatus | 행/컬럼 값 대입 |  |  |  |
| AC-fbeccff5 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2499 | if (iCount > 0) | DATA_OP | request.Parameters["p_ship_status"] | sShipStatus | 행/컬럼 값 대입 |  |  |  |
| AC-b1af2ef1 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2500 | if (iCount > 0) | DATA_OP | request.Parameters["p_change_req_no"] | p_change_req_no | 행/컬럼 값 대입 |  |  |  |
| AC-8e498cb5 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2501 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-526c317a | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2502 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-1adaa8b6 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2503 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-6825f4d8 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2504 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_ship_date"] | p_new_ship_date | 행/컬럼 값 대입 |  |  |  |
| AC-b8610466 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2505 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_qty"] | p_new_qty | 행/컬럼 값 대입 |  |  |  |
| AC-d10d62b4 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2506 | if (iCount > 0) | DATA_OP | request.Parameters["p_new_yn"] | p_new_yn | 행/컬럼 값 대입 |  |  |  |
| AC-094285f8 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2507 | if (iCount > 0) | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-6261a5bc | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2508 | if (iCount > 0) | DATA_OP | request.Parameters["p_if_send_flag"] | p_if_send_flag | 행/컬럼 값 대입 |  |  |  |
| AC-06d22d3a | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2509 | if (iCount > 0) | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-a948d97e | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2510 | if (iCount > 0) | DATA_OP | request.Parameters["p_plan_confirm_id"] | p_plan_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-48a87826 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2512 | if (iCount > 0) | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-a2b8623b | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2513 | if (iCount > 0) | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-355ef8ca | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2514 | if (iCount > 0) | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-69c75b5a | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2515 | if (iCount > 0) | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4a56a115 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2516 | if (iCount > 0) | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-6f491de4 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2517 | if (iCount > 0) | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-184ae065 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2518 | if (iCount > 0) | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-152ac5e4 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2519 | if (iCount > 0) | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-846486ce | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2521 | if (iCount > 0) | DATA_OP | request.Parameters["p_auth"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-01d2f9ac | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2523 | if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f64d0500 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2528 | if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | VALUE_SET | txtRequestNo.Text | ds.Tables[0].Rows[0][1].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-19de68fc | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2533 | if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sShipStatus == Shipment_Status.S_Status_R) | MESSAGE | MessageHelper.GMessageBox | ("MSG00173") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-72f41cd5 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2539 | if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveConfirmID | p_confirm_id | 화면 필드/플래그 변경 |  |  |  |
| AC-3fd18009 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2540 | if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | FLAG | sSaveFlag | "E" | 화면 필드/플래그 변경 |  |  |  |
| AC-517a09b4 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2547 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | DATA_OP | ds.Tables[1].Rows[0][0].ToString().Contains | ("Unauthorized") | 데이터 객체 조작/조회 |  |  |  |
| AC-465cce54 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2550 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[1].Rows[0][0].ToString().Contains("Unauthorized") == t… | MESSAGE | MessageHelper.GMessageBox | ("MSG00316") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b669b66f | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2552 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[1].Rows[0][0].ToString().Contains("Unauthorized")… | DATA_OP | ds.Tables[1].Rows[0][0].ToString().Contains | ("UnModelPic") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb844abe | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2555 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[1].Rows[0][0].ToString().Contains("Unauthorized")… | MESSAGE | MessageHelper.GMessageBox | ("MSG00353") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3cfd0348 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2557 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[1].Rows[0][0].ToString().Contains("Unauthorized")… | DATA_OP | ds.Tables[1].Rows[0][0].ToString().Contains | ("UnModelItem") | 데이터 객체 조작/조회 |  |  |  |
| AC-d3a02c9f | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2560 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[1].Rows[0][0].ToString().Contains("Unauthorized")… | MESSAGE | MessageHelper.GMessageBox | ("MSG00353") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd24c295 | btnSave.Click 외 1 | SSP0200_ShipmentChangeRequest.cs:2565 | if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[1].Rows[0][0].ToString().Contains("Unauthorized")… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0200_ShipmentChangeRequest.SetButtonVisual

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49983de9 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:1714 | if (bFlag) | UI_PROP | lcChgReq2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-51ca2bb1 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:1715 | if (bFlag) | UI_PROP | lcSave.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1e9948c9 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:1716 | if (bFlag) | UI_PROP | lcDel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0eb70109 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:1717 | if (bFlag) | UI_PROP | lcCancel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-95a48666 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:1718 | if (bFlag) | UI_PROP | lcAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9c2915b6 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:1719 | if (bFlag) | UI_PROP | lcDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-40c597d8 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:1724 | else of (bFlag) | UI_PROP | lcChgReq2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-de9771e9 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:1725 | else of (bFlag) | UI_PROP | lcSave.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-49afaa44 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:1726 | else of (bFlag) | UI_PROP | lcDel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-cec7425b | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:1727 | else of (bFlag) | UI_PROP | lcCancel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b408543d | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:1728 | else of (bFlag) | UI_PROP | lcAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-108cb6be | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:1729 | else of (bFlag) | UI_PROP | lcDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0200_ShipmentChangeRequest.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de578aee | this.Load | SSP0200_ShipmentChangeRequest.cs:334 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-702e08b3 | this.Load | SSP0200_ShipmentChangeRequest.cs:335 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1a436dca | this.Load | SSP0200_ShipmentChangeRequest.cs:341 | switch (triggerControl) case "MyDivision": | FLAG | dtMyDivision | DataService.GetSSPInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d64f1f9a | this.Load | SSP0200_ShipmentChangeRequest.cs:341 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-eef0bed5 | this.Load | SSP0200_ShipmentChangeRequest.cs:346 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | FLAG | dtChangeReasonCode | DataService.GetSSPInnerTable("CHANGE_REASON_CODE_ALL", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b428700 | this.Load | SSP0200_ShipmentChangeRequest.cs:346 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REASON_CODE_ALL", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-bfe4359a | this.Load | SSP0200_ShipmentChangeRequest.cs:351 | switch (triggerControl) case "SHIPMENT_STATUS": | FLAG | dtChangeStatusCode | DataService.GetSSPInnerTable("SHIPMENT_STATUS", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6c298d5e | this.Load | SSP0200_ShipmentChangeRequest.cs:351 | switch (triggerControl) case "SHIPMENT_STATUS": | COMBO_DATA | DataService.GetSSPInnerTable | ("SHIPMENT_STATUS", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-993f3923 | this.Load | SSP0200_ShipmentChangeRequest.cs:357 | switch (triggerControl) case "SALES_TYPE_CODE": | FLAG | dtFcstType | DataService.GetSSPInnerTable("SALES_TYPE_CODE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c14b17d6 | this.Load | SSP0200_ShipmentChangeRequest.cs:357 | switch (triggerControl) case "SALES_TYPE_CODE": | COMBO_DATA | DataService.GetSSPInnerTable | ("SALES_TYPE_CODE", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-45f71326 | this.Load | SSP0200_ShipmentChangeRequest.cs:362 | switch (triggerControl) case "CHANGE_REQ_TYPE": | FLAG | dtChangeReqType | DataService.GetSSPInnerTable("CHANGE_REQ_TYPE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-7d4d4724 | this.Load | SSP0200_ShipmentChangeRequest.cs:362 | switch (triggerControl) case "CHANGE_REQ_TYPE": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REQ_TYPE", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1bb91e98 | this.Load | SSP0200_ShipmentChangeRequest.cs:367 | switch (triggerControl) case "CHANGE_REQ_DAY": | FLAG | dtBaseDay | DataService.GetSSPInnerTable("CHANGE_REQ_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-93c7cef7 | this.Load | SSP0200_ShipmentChangeRequest.cs:367 | switch (triggerControl) case "CHANGE_REQ_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REQ_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a8eab155 | this.Load | SSP0200_ShipmentChangeRequest.cs:372 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | FLAG | dtShipmentInputPeriod | DataService.GetSSPInnerTable("SHIPMENT_PERIOD_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-fb1aea01 | this.Load | SSP0200_ShipmentChangeRequest.cs:372 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("SHIPMENT_PERIOD_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## SSP0200_ShipmentChangeRequest.SetChangedControl

진입점: this.Load / clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95f6b774 | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:554 | try | FLAG | JVFlag | dtMyDivision.Select().Where(c => c["CODE"].ToString() == pDivisionID).First()["ATTRIBUTE1"… | 화면 필드/플래그 변경 |  |  |  |
| AC-65962bea | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:554 | try | DATA_OP | dtMyDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-42b0a6b0 | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:559 |  | FLAG | dtPlantSiteByDivision | GetShipmentPlanPlantSite(pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a7157a9 | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:562 |  | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ShipmentPlanToSite, false, pDivisionID, UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-11c3ed96 | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:562 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanToSite, false, pDivisionID, UserInfoContext.Current["NowGroupID… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d13164eb | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:564 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, this.clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-250ff84d | this.Load 외 1 | SSP0200_ShipmentChangeRequest.cs:566 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0200_ShipmentChangeRequest.SetChangeRequestInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17bc4340 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2227 |  | FLAG | sApprovalDeptID | dt.Rows[0]["APPROVAL_DEPT"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-eca910e8 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2232 |  | VALUE_SET | txtRequestNo.Text | sRequestNo | 컨트롤 값 설정 |  |  |  |
| AC-f1be9013 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2233 |  | VALUE_SET | txtRequestor.Text | sRequestorName | 컨트롤 값 설정 |  |  |  |
| AC-15ad4ab9 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2234 |  | VALUE_SET | txtRequestDeptName.Text | sRequestDeptName | 컨트롤 값 설정 |  |  |  |
| AC-9521a991 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2235 |  | FLAG | _sRequestNo | sRequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-71eba717 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2239 | if (!bReadOnly) | FLAG | sRequestID | sRequestorID | 화면 필드/플래그 변경 |  |  |  |
| AC-3563a7e6 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2240 | if (!bReadOnly) | FLAG | sRequestName | sRequestorName + "(" + sRequestID + ")" | 화면 필드/플래그 변경 |  |  |  |
| AC-2beed14c | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2242 | if (!bReadOnly) | STATE | txtTitle.ReadOnly | false | 컨트롤 상태 ReadOnly |  |  |  |
| AC-834fb3c9 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2243 | if (!bReadOnly) | UI_PROP | lcAppDept.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9c3e31e1 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2244 | if (!bReadOnly) | STATE | cboChangeReason.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-452eb051 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2245 | if (!bReadOnly) | STATE | txtReasonDetail.ReadOnly | false | 컨트롤 상태 ReadOnly |  |  |  |
| AC-286adf31 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2250 | else of (!bReadOnly) | STATE | txtTitle.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-b0dbfa12 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2251 | else of (!bReadOnly) | UI_PROP | lcAppDept.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-cd089dea | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2252 | else of (!bReadOnly) | STATE | cboChangeReason.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-759d1a90 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2253 | else of (!bReadOnly) | STATE | txtReasonDetail.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-ed2b4c83 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2256 |  | VALUE_SET | txtTitle.Text | sTitle | 컨트롤 값 설정 |  |  |  |
| AC-40c0e9cd | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2258 |  | VALUE_SET | txtApproval.Text | sApprovalUserName | 컨트롤 값 설정 |  |  |  |
| AC-407c0a99 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2259 |  | FLAG | sApprovalID | sApproval | 화면 필드/플래그 변경 |  |  |  |
| AC-bd153ce1 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2261 |  | VALUE_SET | txtAppDeptName.Text | sApprovalDeptName | 컨트롤 값 설정 |  |  |  |
| AC-aac8c571 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2262 |  | VALUE_SET | cboChangeReason.SelectedValue | sChaneReason | 컨트롤 값 설정 |  |  |  |
| AC-154952eb | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2263 |  | VALUE_SET | txtReasonDetail.Text | sReasonDetail | 컨트롤 값 설정 |  |  |  |

## SSP0200_ShipmentChangeRequest.SetChangeRequestSOGrid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-179959d3 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2268 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5d30a5af | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2269 |  | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-b13a2801 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2271 |  | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(CAppSetting.StringAction), siSub.GetColumnIndex(DefColumns.NEW_ETA),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e380408c | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2275 | for (i < siSub.ActiveSheet.RowCount) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(CAppSetting.StringAction)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-21362f2b | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2279 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.SetText | (i, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-80abc5f8 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2280 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-5f9bab90 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2281 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-bd06dec7 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2282 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Lock… | true | 그리드 속성/값 설정 |  |  |  |
| AC-74e4fd62 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2283 | for (i < siSub.ActiveSheet.RowCount) ▸ if (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Back… | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-e81ad4cb | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2288 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.SetText | (i, siMain.GetColumnIndex(CAppSetting.StringAction), CAppSetting.FlagM) | 그리드 값 설정 |  |  |  |
| AC-054b90d5 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2292 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ if (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-586bb55f | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2293 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ if (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].BackColor | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-28b56a2a | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2294 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ if (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.CHK)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f08591c4 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2298 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ else of (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.CHK)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-746d6fd5 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2299 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ else of (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-f016ff96 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2300 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) ▸ else of (sSearchType == SearchType.Type_E) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE)].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-98f3d1cb | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2302 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-28f78400 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2303 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE)].BackColor | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-5a63f269 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2304 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Lock… | false | 그리드 속성/값 설정 |  |  |  |
| AC-390fc7e3 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2305 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY)].Back… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-1bbf14e8 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2308 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.REMARKS2)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-a791f3e5 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2309 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.REMARKS2)].BackColor | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-f98754d1 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2310 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.REMARKS3)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-93e27092 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2311 | for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipStatus == Shipment_Status.S_Status_R) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.REMARKS3)].BackColor | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |

## SSP0200_ShipmentChangeRequest.setEndCustomer

진입점: this.btnInsertMultiple.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < inputCount) ▸ if (clbDivision_ID.ControlValues == "40")] / btnNew.Click [if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (clbDivision_ID.SelectedValue.ToString() != "EE") ▸ if (clbDivision_ID.SelectedValue.ToString() == "40")] / this.spdMain.CellDoubleClick [if (e.Column == siMain.GetC…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04a2d7cd | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 5 | SSP0200_ShipmentChangeRequest.cs:6655 | if (sDivision != "" && sToSite != "" && sItemId != "") | FLAG | dtEndCustomer | Data_SCP.Common(Data_SCP.Type.EndCustomerByItemForSSP, false, sDivision, sToSite, sItemId) | 화면 필드/플래그 변경 |  |  |  |
| AC-33136a10 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 5 | SSP0200_ShipmentChangeRequest.cs:6655 | if (sDivision != "" && sToSite != "" && sItemId != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.EndCustomerByItemForSSP, false, sDivision, sToSite, sItemId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9fb21659 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 5 | SSP0200_ShipmentChangeRequest.cs:6656 | if (sDivision != "" && sToSite != "" && sItemId != "") | GRID_COMBO | siMain.SetCellTypeCombo | (iROW, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cf025abd | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 5 | SSP0200_ShipmentChangeRequest.cs:6659 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ if (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) | GRID_SET | siMain.SetValue | (iROW, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer.Rows[0]["CODE"].ToStr… | 그리드 값 설정 |  |  |  |
| AC-fe79a77a | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 5 | SSP0200_ShipmentChangeRequest.cs:6660 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ if (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) | GRID_SET | siMain.SetText | (iROW, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer.Rows[0]["CODE"].ToStr… | 그리드 값 설정 |  |  |  |
| AC-29420745 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 5 | SSP0200_ShipmentChangeRequest.cs:6665 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | FLAG | dtEndCustomer | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-184892be | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 5 | SSP0200_ShipmentChangeRequest.cs:6666 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | dtEndCustomer.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a41f96a5 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 5 | SSP0200_ShipmentChangeRequest.cs:6667 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | dtEndCustomer.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-06f5bbf3 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 5 | SSP0200_ShipmentChangeRequest.cs:6668 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | dtEndCustomer.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1b7e668d | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 5 | SSP0200_ShipmentChangeRequest.cs:6669 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | drRow["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-b2140e41 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 5 | SSP0200_ShipmentChangeRequest.cs:6670 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | drRow["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-c0b63493 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 5 | SSP0200_ShipmentChangeRequest.cs:6671 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | dtEndCustomer.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-c023dbc5 | this.btnInsertMultiple.Click [if (popup.ShowDialog() == Dial… 외 5 | SSP0200_ShipmentChangeRequest.cs:6672 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | GRID_COMBO | siMain.SetCellTypeCombo | (iROW, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SSP0200_ShipmentChangeRequest.SetMainStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b785de61 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3011 | if (bDeleClickYn) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c41b085e | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3019 | for (iRow < siMain.ActiveSheet.RowCount) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-c8855fb9 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3022 |  | FLAG | sMainConfirmID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-08915f9a | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3035 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS), sShipStatus) | 그리드 값 설정 |  |  |  |
| AC-905b8f87 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3036 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER), sRequestID) | 그리드 값 설정 |  |  |  |
| AC-13b78116 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3037 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER_NAME), sRequestName) | 그리드 값 설정 |  |  |  |
| AC-0bc7afe4 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3038 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_TIME), DateTime.Now) | 그리드 값 설정 |  |  |  |
| AC-4384151c | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3039 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO), txtRequestNo.Text) | 그리드 값 설정 |  |  |  |
| AC-08c10459 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3040 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if (txtR… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-46cdb8a8 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3051 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | DATA_OP | (siSub.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-020c3f98 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3054 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLAN_CONFIRM_ID), dr[DefColumns.CONFIRM_ID].ToStri… | 그리드 값 설정 |  |  |  |
| AC-1cc1eeac | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3059 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS), sShipStatus) | 그리드 값 설정 |  |  |  |
| AC-2fc7a695 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3060 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER), sRequestID) | 그리드 값 설정 |  |  |  |
| AC-35a90086 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3061 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER_NAME), sRequestName) | 그리드 값 설정 |  |  |  |
| AC-bca9cb12 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3062 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_TIME), DateTime.Now) | 그리드 값 설정 |  |  |  |
| AC-d6f14d05 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3063 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO), txtRequestNo.Text) | 그리드 값 설정 |  |  |  |
| AC-7c9aef0d | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3064 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) ▸ else of (!string.IsNullOrWhiteSpace(sChkRequestNo)) ▸ if … | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |
| AC-4dc5f979 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3072 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS), sShipStatus) | 그리드 값 설정 |  |  |  |
| AC-75da9506 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3073 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER), sRequestID) | 그리드 값 설정 |  |  |  |
| AC-abe9c7e0 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3074 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_USER_NAME), sRequestName) | 그리드 값 설정 |  |  |  |
| AC-0b1b5b88 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3075 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_TIME), DateTime.Now) | 그리드 값 설정 |  |  |  |
| AC-e4e9c3c4 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3076 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO), txtRequestNo.Text) | 그리드 값 설정 |  |  |  |
| AC-d2acff27 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3077 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ if (sSoNo == sChkSoNo) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_STATUS)].BackColo… | ControlColor.EditColor | 그리드 속성/값 설정 |  |  |  |

## SSP0200_ShipmentChangeRequest.SetStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-939515b6 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:2981 |  | FLAG | sMainConfirmID | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## SSP0200_ShipmentChangeRequest.shtMain_Change

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35b41cdb | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6412 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange != true \|\| e.Row == -1 && e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ca01433 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6413 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2bb814ad | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6422 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00189") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9b82e55d | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6423 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b06cc6b6 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6447 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-2d574016 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6457 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-09a8a2bd | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6459 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-9b46ef0d | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6460 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].ForeColor | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-21a9fce9 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6461 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].BackColor | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-20b8d125 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6465 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-1d521194 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6476 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-853021ae | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6486 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-aaec2743 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6488 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-44fea046 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6489 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].ForeColor | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-4e42cb43 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6490 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].BackColor | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-e5c6a5c7 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6505 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-c2a791db | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6506 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db828b5e | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6510 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-3da21443 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6517 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-3d8f8b9d | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6527 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-8d3f5ee7 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6528 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-f8199b71 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6529 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-7341c00d | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6554 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | CALL_EXT | siMain.SetDecimal | (e.Row, e.Column, e.Row, e.Column, 0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1d38178 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6574 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | CALL_EXT | siMain.SetDecimal | (e.Row, qty_idx, e.Row, qty_idx, 0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ddc6c724 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6578 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | CALL_EXT | siMain.SetDecimal | (e.Row, qty_idx, e.Row, qty_idx, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c81ea88e | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6595 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-e2e37a62 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6605 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-38a636c9 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6606 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-8da98dc6 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6636 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | CALL_EXT | siMain.SetDecimal | (e.Row, qty_idx, e.Row, qty_idx, 0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d341e968 | dsdm.Changed | SSP0200_ShipmentChangeRequest.cs:6640 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | CALL_EXT | siMain.SetDecimal | (e.Row, qty_idx, e.Row, qty_idx, 3, true) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0200_ShipmentChangeRequest.SoNo

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ else of (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5278578 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4632 | else of (iCallChk == 1) ▸ if (iCallChk > 1) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-b18837f2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4642 | for (i < intRowIdx) ▸ if (erpSoNo == siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ERP_SO_NO)).ToString()) ▸ if (intRowIdx > i) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-1047d934 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4771 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-4584881a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4775 | try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-4fa0d2b5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4776 | try | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-3a49405f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4777 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-54d4d3a5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4778 | try | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-9636b69c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4779 | try | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-69b9571c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4780 | try | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-b6b3b053 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4781 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-fc8bf479 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4782 | try | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-4360b197 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4783 | try | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-77ce00cc | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4784 | try | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-05dccaff | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4785 | try | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-c4f9db57 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4786 | try | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-bee828b5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4787 | try | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-92d44e20 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4788 | try | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-5711daa0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4789 | try | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-9fa7fb11 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4790 | try | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-bb48e016 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4791 | try | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-4377e8e0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4792 | try | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-4ba8815a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4793 | try | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-cca7df10 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4794 | try | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-b1576005 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4795 | try | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-f0f68f9c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4796 | try | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-9e508277 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4797 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-23aa657c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4798 | try | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-430d2fc9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4799 | try | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-3c3458c9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4800 | try | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-e1b57ac9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4801 | try | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8481a559 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4802 | try | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-433bbd38 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4804 | try | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-16ffacfd | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4805 | try | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-d5d07b86 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4806 | try | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-4d438187 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4808 | try | DATA_OP | request.Parameters["p_change_req_no"] | _ChangeReqno | 행/컬럼 값 대입 |  |  |  |
| AC-d9de2b58 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4810 | try | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-b5e77a9d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4811 | try | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-608ba187 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4812 | try | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-35fd2573 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4813 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-114663f3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4816 | try | DATA_OP | request.Parameters["p_erp_attr1"] | p_erp_attr1 | 행/컬럼 값 대입 |  |  |  |
| AC-35b1a721 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4817 | try | DATA_OP | request.Parameters["p_erp_attr2"] | p_erp_attr2 | 행/컬럼 값 대입 |  |  |  |
| AC-028e3fe6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4818 | try | DATA_OP | request.Parameters["p_erp_attr3"] | p_erp_attr3 | 행/컬럼 값 대입 |  |  |  |
| AC-92c2724c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4821 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2a59fcf5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4858 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ try ▸ if (ds.Tables[0].Rows[0][… | MESSAGE | MessageBox.Show | (error_message) | 메시지 표시 |  |  |  |
| AC-861957f1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4872 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ try ▸ else of (ds.Tables[0].Row… | MESSAGE | MessageBox.Show | (error_message) | 메시지 표시 |  |  |  |
| AC-a61ccfa4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4881 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ if (check_error_type == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00293", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8b8d2960 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4896 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ffea660 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4900 | try | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |
| AC-885e69ee | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:4907 | catch ((Exception ex)) | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab6f6e59 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5247 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (spdMain.AutoClipboard == true) ▸ try | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.ClipboardPasteAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ad5f7c1 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5252 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (spdMain.AutoClipboard == true) ▸ try | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.ClipboardCopyAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2bc27305 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5255 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (spdMain.AutoClipboard == true) | UI_PROP | spdMain.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |
| AC-f4372689 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5268 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Div") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-69026017 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5269 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb0c1048 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5281 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Div") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d64b672 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5282 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-223a042a | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5466 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-1cc6f70d | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5466 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f6dfbe87 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5468 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), dtTransMode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4b8cddf6 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5469 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Vertical… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-91767eb6 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5470 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Horizont… | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-86af8412 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5480 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTIO… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d423692a | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5505 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.Activ… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-3e1597ee | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5509 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.Activ… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-c6f24e91 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5522 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ActiveColumnIndex == siMain.GetColumnIndex(DefColum… | UI_PROP | spdMain.AutoClipboard | true | 속성 AutoClipboard 설정 |  |  |  |
| AC-a5aad339 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5523 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ActiveColumnIndex == siMain.GetColumnIndex(DefColum… | FLAG | im | spdMain.GetInputMap(FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | 화면 필드/플래그 변경 |  |  |  |
| AC-011bce83 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5523 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ActiveColumnIndex == siMain.GetColumnIndex(DefColum… | CALL_EXT | spdMain.GetInputMap | (FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff88d7fa | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5524 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ActiveColumnIndex == siMain.GetColumnIndex(DefColum… | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-416e69db | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5525 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ActiveColumnIndex == siMain.GetColumnIndex(DefColum… | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1819b20d | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5540 | else of (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-43424a2c | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5544 | else of (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-7cb23f1c | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5551 | else of (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-9c2a76f9 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5555 | else of (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-497e894d | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5566 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) ▸ if (string.IsNullOrWhiteSpace(sRequestNo)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d99c1fd1 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5568 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | new SCM0002_ShipmentPlanRequestPopup | () | 팝업/폼 생성 |  |  |  |
| AC-936d4536 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5569 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-56121bbb | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5570 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop._sRequestNo | sRequestNo | 속성 _sRequestNo 설정 |  |  |  |
| AC-e6b71187 | this.spdMain.CellClick | SSP0200_ShipmentChangeRequest.cs:5571 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0200_ShipmentChangeRequest.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-908a31c9 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5102 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (string.IsNullOrEmpty(sdivision)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Div") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-892f3e05 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5104 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (string.IsNullOrEmpty(sdivision)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-078b38c8 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5110 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (string.IsNullOrEmpty(sfromSite)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-07e36b5b | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5112 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (string.IsNullOrEmpty(sfromSite)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a61aadec | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5118 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (string.IsNullOrEmpty(sScmSite)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-efaede7a | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5120 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (string.IsNullOrEmpty(sScmSite)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8cf04de0 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5125 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-832841d4 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5130 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") | POPUP | popItem.Form_Load | (false, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-fe896520 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5131 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8e6a446b | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5132 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-42f03109 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5138 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (popItem.ItemID != "") | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-ce074d6b | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5139 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (popItem.ItemID != "") | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), popItem.NickName) | 그리드 값 설정 |  |  |  |
| AC-f3c38b34 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5162 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Div") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cf46505b | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5164 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa0c86a4 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5170 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-269dfe49 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5172 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ce2047c | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5178 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-38d4768b | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5180 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8d14f222 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5186 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Model") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ddfbcf2a | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5188 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98c80a9b | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5197 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-894ac3f8 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5198 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-134ad98d | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5199 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-39fa18af | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5200 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e50053a7 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5206 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (acti… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), sProjectCode) | 그리드 값 설정 |  |  |  |
| AC-504a8b49 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5222 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if … | POPUP | new SSP0300_OrderDetailPopup | () | 팝업/폼 생성 |  |  |  |
| AC-77c9ca46 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5224 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if … | POPUP | pop.Form_Load | (_DivisionID, _ErpSoNo, _ConfirmId, _ItemID, "N") | 팝업 초기화(인자 전달) |  |  |  |
| AC-85a3fe36 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5225 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if … | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d7bf89b6 | this.spdMain.CellDoubleClick | SSP0200_ShipmentChangeRequest.cs:5226 | else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if … | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0200_ShipmentChangeRequest.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9528c72 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5585 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (!string.IsNullOrEmpty(sItemId)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-395bc1da | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5586 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (!string.IsNullOrEmpty(sItemId)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-0c996164 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5587 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (!string.IsNullOrEmpty(sItemId)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-9e852e88 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5602 | else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_DES… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-92d9c97f | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5604 | else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_DES… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-276e13d6 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5610 | else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_DES… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-a3c96bbc | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5611 | else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_DES… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-0654c4bf | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5612 | else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_SITE_DES… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-20f02674 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5637 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") | FLAG | dtFromSite | GetPlantSiteByDivisionEEOperation(sDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-a1842c37 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5639 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-0a6cb621 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5639 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID != "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteByDivisionEEForSSP, false, sDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-048ae000 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5650 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION), dtFromSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f111a933 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5651 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTION), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-31bfcf0e | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5653 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-d5d7c679 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5654 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-0cc5a91c | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5655 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-d39c9e88 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5656 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-c69e90fd | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5657 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-c9745da5 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5658 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-010f67d8 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5659 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FCST_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-57adb7d6 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5660 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-867735c0 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5661 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-eaff397b | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5662 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-47b66e7b | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5668 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.END_CUSTOMER)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6b31ac62 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5669 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1879801b | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5670 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c3f1b6bf | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5671 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), e.Row, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e0604cae | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5672 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), e.Row, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-40f4aa24 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5673 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "-") | 그리드 값 설정 |  |  |  |
| AC-8a132601 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5677 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.END_CUSTOMER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3e6c8599 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5678 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ae7b35d7 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5679 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROJECT_NAME)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b877eb34 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5680 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), e.Row, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a552a3e0 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5681 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivisionID == "40" \|\| sDivisionID == "EE") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), e.Row, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5286726d | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5702 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Div*") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d740db86 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5704 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToS… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-3bbba644 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5705 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71a96c02 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5712 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIP… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5e3734da | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5713 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIP… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-cafe7a74 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5715 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIP… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c70527d4 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5722 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a2301b5c | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5723 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTI… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-3ba82b37 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5724 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f27591f2 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5732 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToStrin… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Model*") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-882b09df | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5733 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToStrin… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-685fb7e4 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5734 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToStrin… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af5f6f74 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5737 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-28a89753 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5738 | if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-53922bd4 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5753 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (dtTransMode == null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00293", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-556a8fd4 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5754 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (dtTransMode == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c206089 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5757 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(siMain.GetValue(e.Row, siMain.GetColumnInd… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8e39127f | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5770 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DAT… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Shipmente Date") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cdc2eddd | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5772 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DAT… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-426e6e27 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5773 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DAT… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-da3a3962 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5774 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DAT… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d98478c9 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5780 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS)).… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Incoterms") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-773ccf88 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5782 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS)).… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-a974d1c2 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5783 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS)).… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-6be59005 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5784 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS)).… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-425cc9ec | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5790 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | DATA_OP | dtTransMode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4bb199c5 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5830 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-ac77c719 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5840 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), sNewTransMode) | 그리드 값 설정 |  |  |  |
| AC-e2a00176 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5855 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-c048bb07 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5873 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-cb323e93 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5874 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-89aa5d7d | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5879 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-f6799105 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5893 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-b90862e3 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5894 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-a2dbc7fe | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5895 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-b43e25c9 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5900 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-42fd2234 | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5901 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-65e8138e | this.spdMain.ComboSelChange | SSP0200_ShipmentChangeRequest.cs:5902 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0200_ShipmentChangeRequest.SpdMain_CursorChanged

진입점: spdMain.CursorChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61974aa3 | spdMain.CursorChanged | SSP0200_ShipmentChangeRequest.cs:419 | if (RollBack_Flag == true) ▸ if (iOld_SelRow != -1 \|\| iOld_SelCol != -1) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iOld_SelRow, iOld_SelCol) | 그리드 표시 설정 |  |  |  |
| AC-8fcbbd12 | spdMain.CursorChanged | SSP0200_ShipmentChangeRequest.cs:420 | if (RollBack_Flag == true) ▸ if (iOld_SelRow != -1 \|\| iOld_SelCol != -1) | CALL_EXT | spdMain.ShowCell | (0, 0, this.iOld_SelRow, this.iOld_SelCol, FarPoint.Win.Spread.VerticalPosition.Center, Fa… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b5b986b | spdMain.CursorChanged | SSP0200_ShipmentChangeRequest.cs:422 | if (RollBack_Flag == true) ▸ if (iOld_SelRow != -1 \|\| iOld_SelCol != -1) | FLAG | RollBack_Flag | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0200_ShipmentChangeRequest.SpdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f869239 | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6310 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d1dec701 | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6321 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47503eb6 | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6322 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), "") | 그리드 값 설정 |  |  |  |
| AC-93fc9044 | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6323 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ebac43d | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6326 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a2d75ff | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6337 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-4a48478b | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6338 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-994c989a | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6339 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-2c90095c | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6340 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-261a3c66 | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6341 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-586e711b | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6351 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-7c8d7bba | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6354 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-ab5de595 | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6355 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-b902a466 | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6356 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-d6fe1622 | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6357 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-a2c17f0c | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6373 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.ERP_SO_NO)) | 그리드 표시 설정 |  |  |  |
| AC-3d2f92e3 | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6374 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | CALL_EXT | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL)].Re… | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2770d22b | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6376 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00287", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-15488ae3 | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6378 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b2dc565c | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6386 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-00e62114 | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6396 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-e8f280fc | this.spdMain.EditChange | SSP0200_ShipmentChangeRequest.cs:6398 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0200_ShipmentChangeRequest.SSP_Main_Validation

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9411657b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3562 |  | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0f1bd7c5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3586 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-174c876e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3587 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-89fea881 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3594 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00359", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da5f8609 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3595 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-308a5075 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3609 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4a1de5e9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3609 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ lamb… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-c4a04d40 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3628 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e94e38d6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3640 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), "T07") | 그리드 값 설정 |  |  |  |
| AC-60d3c603 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3659 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-02a78751 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3659 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ba86b59 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3698 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].ResetBackColo… | () | 그리드 표시 설정 |  |  |  |
| AC-172748a6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3699 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].ResetForeColo… | () | 그리드 표시 설정 |  |  |  |
| AC-1a23a198 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3700 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-63da75b9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3702 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].ResetF… | () | 그리드 표시 설정 |  |  |  |
| AC-8bc9a51c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3703 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetForeColo… | () | 그리드 표시 설정 |  |  |  |
| AC-df71b83e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3704 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetForeCol… | () | 그리드 표시 설정 |  |  |  |
| AC-935c50de | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3705 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-fbb29347 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3706 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-6760873d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3714 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-21822cb6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3718 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4d01c7e6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3734 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a61f69c4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3734 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-7273ceca | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3764 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].ResetBackColo… | () | 그리드 표시 설정 |  |  |  |
| AC-e2d26835 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3765 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].ResetForeColo… | () | 그리드 표시 설정 |  |  |  |
| AC-bac3adaa | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3766 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-1e0afbef | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3768 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].ResetF… | () | 그리드 표시 설정 |  |  |  |
| AC-9f5acff3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3769 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetForeColo… | () | 그리드 표시 설정 |  |  |  |
| AC-131a4380 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3770 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetForeCol… | () | 그리드 표시 설정 |  |  |  |
| AC-230461cc | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3771 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-c7ddd130 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3772 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-3d1d42a3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3774 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | MESSAGE | MessageHelper.GMessageBox | ("MSG00286", new object[] { (i + 1).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aee0461b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3776 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-08dda810 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3797 | for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3837465e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3798 | for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a7ef0ec1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3804 | for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00359", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-75e56089 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3805 | for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a2eb1feb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3809 | for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c00b6580 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0200_ShipmentChangeRequest.cs:3813 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequest.SSP_Main_Validation_SoldTo_ShipTo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4bcd367 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3535 | if (string.IsNullOrWhiteSpace(soldto) \|\| string.IsNullOrWhiteSpace(shipto)) | MESSAGE | MessageBox.Show | (msg) | 메시지 표시 |  |  |  |
| AC-3cca2cb9 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3536 | if (string.IsNullOrWhiteSpace(soldto) \|\| string.IsNullOrWhiteSpace(shipto)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-72df1f18 | (진입점 미연결) | SSP0200_ShipmentChangeRequest.cs:3543 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequestInsertPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c8a07e1 | this.btnButtonList.UsrButtonList_Click_Detected | SSP0200_ShipmentChangeRequestInsertPopup.cs:124 | if (buttonItem.UserType == ButtonListType.OK) ▸ if (result == true && (iCount > 0 && iCount < 51)) | FLAG | UserInputCount | int.Parse(txtCurrentInsert_Qty.Text.ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-7757e5cd | this.btnButtonList.UsrButtonList_Click_Detected | SSP0200_ShipmentChangeRequestInsertPopup.cs:128 | if (buttonItem.UserType == ButtonListType.OK) ▸ else of (result == true && (iCount > 0 && iCount < 51)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { txtCurrentInsert_Qty.Text.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-27cf6743 | this.btnButtonList.UsrButtonList_Click_Detected | SSP0200_ShipmentChangeRequestInsertPopup.cs:129 | if (buttonItem.UserType == ButtonListType.OK) ▸ else of (result == true && (iCount > 0 && iCount < 51)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25cc898e | this.btnButtonList.UsrButtonList_Click_Detected | SSP0200_ShipmentChangeRequestInsertPopup.cs:137 | if (buttonItem.UserType == ButtonListType.OK) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-afe3091f | this.btnButtonList.UsrButtonList_Click_Detected | SSP0200_ShipmentChangeRequestInsertPopup.cs:143 | else of (buttonItem.UserType == ButtonListType.OK) ▸ if (buttonItem.UserType == ButtonListType.Cancel) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0200_ShipmentChangeRequestInsertPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e68abad9 | Dispose | SSP0200_ShipmentChangeRequestInsertPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0200_ShipmentChangeRequestInsertPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52b71b75 | this.Load | SSP0200_ShipmentChangeRequestInsertPopup.cs:54 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0200_ShipmentChangeRequestInsertPopup.SaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8627744e | (진입점 미연결) | SSP0200_ShipmentChangeRequestInsertPopup.cs:99 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-74f3bb79 | (진입점 미연결) | SSP0200_ShipmentChangeRequestInsertPopup.cs:100 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0200_ShipmentChangeRequestInsertPopup.Validation_Check

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57b9d940 | (진입점 미연결) | SSP0200_ShipmentChangeRequestInsertPopup.cs:106 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

