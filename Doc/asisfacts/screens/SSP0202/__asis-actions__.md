# AS-IS 액션 대조표 — SSP0202

> 원천: `Doc/asisfacts/screens/SSP0202/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 287행 · 메서드 28 · 종류 DATA_OP 66 · GRID_INIT 42 · RETURN 33 · FLAG 27 · ENDPOINT 21 · VALUE_CLEAR 17 · UI_PROP 16 · VALUE_SET 13 · MESSAGE 12 · COMBO_DATA 10 · POPUP 7 · LIST_REBIND 6 · UI_MISC 5 · FOCUS 2 · VALIDATE 2 · GRID_BIND 2 · GRID_LOCK 2 · GRID_SET 2 · CALL_EXT 1 · STATE 1 · ⚠ 의미 확인 필요 1


## SSP0202_ShipmentChangeRequestConfirm.BtnApproval_Click

진입점: btnApproval.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b5ac5c3 | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1374 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fdd5ab93 | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1382 | if (chkSaveYN() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00362") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-20918eba | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1383 | if (chkSaveYN() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e3fd3c7c | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1387 | if (!EngProcessingChk(pDivisionID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20dd6cd5 | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1390 | if (chkERPIFBlockYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c346ba8b | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1393 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00190") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ac6211c8 | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1395 | if (MessageHelper.GMessageBox("MSG00190") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-81d0e9a1 | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1410 |  | FLAG | _sStatus | "A" | 화면 필드/플래그 변경 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.btnItemId_Click

진입점: btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0586ced3 | btnItemId.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1424 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-69d41ed0 | btnItemId.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1426 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-febc4c9e | btnItemId.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1427 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4b809a06 | btnItemId.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1428 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-05879a79 | btnItemId.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1434 | if (popItem.ItemID != "") | VALUE_SET | txtItemID.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.BtnReject_Click

진입점: btnReject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c79483c8 | btnReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1342 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b882045 | btnReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1345 | if (chkERPIFBlockYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ada1b31 | btnReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1348 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00191") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-03924cb4 | btnReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1350 | if (MessageHelper.GMessageBox("MSG00191") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-abeb21e6 | btnReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1358 | if (string.IsNullOrEmpty(sRejectReason)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00181") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1c2ef4ef | btnReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1359 | if (string.IsNullOrEmpty(sRejectReason)) | FOCUS | txtRejectReason.Focus | () | 포커스 이동 |  |  |  |
| AC-95f7f2a9 | btnReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1360 | if (string.IsNullOrEmpty(sRejectReason)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6d3ed7d | btnReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1363 |  | FLAG | _sStatus | "" | 화면 필드/플래그 변경 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.BtnRequestUser_Click

진입점: btnRequestUser.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f1837c4 | btnRequestUser.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1316 |  | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-50488e9d | btnRequestUser.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1318 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-7c15c1c9 | btnRequestUser.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1319 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-4a670497 | btnRequestUser.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1320 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5d8c955f | btnRequestUser.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1321 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-2fd86268 | btnRequestUser.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1322 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-a8f01f16 | btnRequestUser.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1323 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-cd4d83b6 | btnRequestUser.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1325 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5b548f80 | btnRequestUser.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1335 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) | VALUE_SET | txtRequest.Text | strRequest.Substring(0, strRequest.Length - 1) | 컨트롤 값 설정 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.BtnSelfReject_Click

진입점: btnSelfReject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d2e1323 | btnSelfReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1282 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f15faed | btnSelfReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1285 | if (chkERPIFBlockYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-676d4ee8 | btnSelfReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1288 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00192") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7364f830 | btnSelfReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1290 | if (MessageHelper.GMessageBox("MSG00192") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-216a716b | btnSelfReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1298 | if (string.IsNullOrEmpty(sRejectReason)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00181") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4daf2f85 | btnSelfReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1299 | if (string.IsNullOrEmpty(sRejectReason)) | FOCUS | txtRejectReason.Focus | () | 포커스 이동 |  |  |  |
| AC-b8879b73 | btnSelfReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1300 | if (string.IsNullOrEmpty(sRejectReason)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-704bd91c | btnSelfReject.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1304 |  | FLAG | _sStatus | "" | 화면 필드/플래그 변경 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.chkERPIFBlockYn

진입점: btnApproval.Click / btnReject.Click / btnSelfReject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1d8aa71 | btnApproval.Click 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:1061 |  | FLAG | dtERPBlockYnIF | Data_SCP.Common(Data_SCP.Type.SSPBlockCheckIF, false, "SSP0202") | 화면 필드/플래그 변경 |  |  |  |
| AC-dff9a41c | btnApproval.Click 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:1061 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSPBlockCheckIF, false, "SSP0202") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6986acac | btnApproval.Click 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:1064 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("BLOCK_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-29fc2062 | btnApproval.Click 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:1073 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("PERIOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b9e854e | btnApproval.Click 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:1074 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00267", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8621566c | btnApproval.Click 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:1078 |  | RETURN | return resultYn; |  | 처리 중단/반환 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.chkSaveYN

진입점: btnApproval.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d236dc2e | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1130 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK") ⇒ SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-01c2b1d2 | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1134 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-a32168e2 | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1136 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ef13ebef | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1143 | if (ds.Tables[0].Rows.Count > 0) ▸ if (Convert.ToInt32(ds.Tables[0].Rows[0]["CNT"]) > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4454f66f | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1149 | if (ds.Tables[0].Rows.Count > 0) ▸ else of (Convert.ToInt32(ds.Tables[0].Rows[0]["CNT"]) > 0) ▸ if (Convert.ToInt32(ds.Tables[1].Rows[0]["CN… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e2a3a83d | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1153 | if (ds.Tables[0].Rows.Count > 0) ▸ else of (Convert.ToInt32(ds.Tables[0].Rows[0]["CNT"]) > 0) ▸ else of (Convert.ToInt32(ds.Tables[1].Rows[0… | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-dd5df5b6 | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1163 | else of (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[1].Rows.Count > 0) ▸ if (Convert.ToInt32(ds.Tables[1].Rows[0]["CNT"]) > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5d784f31 | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1167 | else of (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[1].Rows.Count > 0) ▸ else of (Convert.ToInt32(ds.Tables[1].Rows[0]["CNT"]) > 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-d335c95b | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1172 | else of (ds.Tables[0].Rows.Count > 0) ▸ else of (ds.Tables[1].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.ClearRequestInfo

진입점: btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / btnReject.Click [if (bFlag) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / btnSelfReject.Click [if (bFlag) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1971803 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:659 |  | VALUE_CLEAR | txtRequestNo.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1e36dc28 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:660 |  | VALUE_CLEAR | txtTitle.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c8da4e27 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:661 |  | VALUE_CLEAR | txtRequestNo.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0bd54f21 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:662 |  | VALUE_CLEAR | txtRequestDeptName.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-146d671b | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:663 |  | VALUE_CLEAR | txtApproval.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-db346065 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:664 |  | VALUE_CLEAR | txtAppDeptName.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-94642a64 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:665 |  | VALUE_CLEAR | txtReasonDetail.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-cbb7fde4 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:666 |  | VALUE_CLEAR | txtChangeReason.Text | "" | 컨트롤 값 비움 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e44e7c8b | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:342 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c9feb77b | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:343 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2f494a5a | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:346 |  | GRID_INIT | this.AddSheet | (txtApprovalDeptName, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-567971a2 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:347 |  | FLAG | siSub | GetSheetInfo(txtApprovalDeptName.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-045e8544 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:349 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-05386ec9 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:352 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-99b9537a | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:356 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.Delegate_Load

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0c17f1f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:1233 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0202_GET_DELEGATEE_LOAD") ⇒ SSP.SSP0202_GET_DELEGATEE_LOAD | 엔드포인트 요청 생성 |  |  |  |
| AC-f124b13e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:1234 |  | DATA_OP | request.Parameters["p_division_id"] | strDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-f4cec0ce | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:1235 |  | DATA_OP | request.Parameters["p_apploval"] | strApproval | 행/컬럼 값 대입 |  |  |  |
| AC-4561338a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:1237 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dd453359 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:1239 | if (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count == 0) | FLAG | _sDelegatee | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-118d7a90 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:1240 | if (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count == 0) | FLAG | _sDelegatee_Dept | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-73581598 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:1244 | else of (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count == 0) | FLAG | _sDelegatee | client.ExecuteDataSet(request).DataSet.Tables[0].Rows[0][0].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1673b8ba | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:1244 | else of (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count == 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b76dfb26 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:1245 | else of (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count == 0) | FLAG | _sDelegatee_Dept | client.ExecuteDataSet(request).DataSet.Tables[0].Rows[0][1].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d81130b9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:1245 | else of (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count == 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8647db2b | Dispose | SSP0202_ShipmentChangeRequestConfirm.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-712efa4e | EditButton | SSP0202_ShipmentChangeRequestConfirm.cs:544 |  | FLAG | _sStatus | siMain.GetValue(siMain.ActiveSheet.ActiveRow.Index, siMain.GetColumnIndex(DefColumns.SHIPM… | 화면 필드/플래그 변경 |  |  |  |
| AC-5455dff6 | EditButton | SSP0202_ShipmentChangeRequestConfirm.cs:546 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-565fdb5e | EditButton | SSP0202_ShipmentChangeRequestConfirm.cs:549 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b82ac59c | EditButton | SSP0202_ShipmentChangeRequestConfirm.cs:550 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f0cf6a10 | EditButton | SSP0202_ShipmentChangeRequestConfirm.cs:565 | else of (fps.ActiveSheet.SheetName == SpdSheet.shtSub && _sStatus == "Q") | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d78835b6 | EditButton | SSP0202_ShipmentChangeRequestConfirm.cs:566 | else of (fps.ActiveSheet.SheetName == SpdSheet.shtSub && _sStatus == "Q") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.EngProcessingChk

진입점: btnApproval.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d5c4df3 | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1090 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK") ⇒ SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-8567a3a3 | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1091 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-b0ab243e | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1093 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c3e767ea | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1103 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00291", new object[] { remainMinute }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-331b79d4 | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1113 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1f456492 | btnApproval.Click | SSP0202_ShipmentChangeRequestConfirm.cs:1115 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.FindData_Main

진입점: btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / btnReject.Click [if (bFlag) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / btnSelfReject.Click [if (bFlag) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-befe77ce | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:581 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-086c80fe | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:586 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-b2e6b723 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:586 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aad6a7ec | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:590 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-43e3dd5a | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:607 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-048e3fab | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:611 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM") ⇒ SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-19f40885 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:612 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-99234cba | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:613 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-f74870b9 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:614 | try ▸ lambda | DATA_OP | request.Parameters["p_request_id"] | p_request_id | 행/컬럼 값 대입 |  |  |  |
| AC-0f01609c | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:615 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e844fc32 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:616 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-35bb6559 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:617 | try ▸ lambda | DATA_OP | request.Parameters["p_status"] | p_status | 행/컬럼 값 대입 |  |  |  |
| AC-fe7cc87e | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:618 | try ▸ lambda | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-d0f96100 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:619 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-2e3dd907 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:620 | try ▸ lambda | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-f97f626c | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:622 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c9ce6984 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:624 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d5719779 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:631 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-262eb2e0 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:632 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-65d155c2 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:635 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-281592ad | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:640 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c726972 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:653 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.FindData_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e51b854c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:683 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5f02c4db | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:687 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING") ⇒ SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-4dd595c8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:688 | lambda | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-61efe54d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:689 | lambda | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-06ce23c6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:691 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bfca4bfb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:693 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-fa3e2401 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:700 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-efa62141 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:701 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-87444247 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:704 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ddbfe310 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:709 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96a77621 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:191 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af6b04a0 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:1263 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-7020dd32 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:1264 |  | DATA_OP | request.Parameters["p_from_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4145feb8 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:1265 |  | DATA_OP | request.Parameters["p_offset_day"] | "-14" | 행/컬럼 값 대입 |  |  |  |
| AC-7b8ae589 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:1266 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-a24690f0 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:1267 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c9d2785b | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:1270 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.GetErpIFCheck

진입점: btnApproval.Click / btnReject.Click [if (_sChangeType == ChangeType.ChangeType_C \|\| _sChangeType == ChangeType.ChangeType_N)] / btnSelfReject.Click [if (_sChangeType == ChangeType.ChangeType_C \|\| _sChangeType == ChangeType.ChangeType_N)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba8cc8c8 | btnApproval.Click 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:986 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK") ⇒ SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-8ac4c7a7 | btnApproval.Click 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:987 | try | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-36aeec66 | btnApproval.Click 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:988 | try | DATA_OP | request.Parameters["p_change_status"] | p_change_status | 행/컬럼 값 대입 |  |  |  |
| AC-a6e1f9ff | btnApproval.Click 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:989 | try | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-4ff81b35 | btnApproval.Click 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:990 | try | DATA_OP | request.Parameters["p_change_type"] | sChangeType | 행/컬럼 값 대입 |  |  |  |
| AC-9ce3db6b | btnApproval.Click 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:992 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-21275d05 | btnApproval.Click 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:1035 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8989f18 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:286 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-62e5418b | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:289 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-f831dc8e | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:290 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtSub) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7e643b8 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:293 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl1) | 권한 검사/설정 |  |  |  |
| AC-9f07658c | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:295 |  | FLAG | dtMyDivision | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-ed5e3e4b | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:295 |  | DATA_OP | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-67362b89 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:295 |  | DATA_OP | dtMyDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1c3d807c | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:297 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-98d32993 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:299 |  | LIST_REBIND | clsCtrl.setListBox | (dtChangeStatusCode, cboStatus, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a3456de0 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:301 |  | LIST_REBIND | clsCtrl.setListBox | (dtChangeReqType, cboChangeType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6fe6d870 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:305 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-79fc7df0 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:308 | if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-91dfd991 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:310 |  | FLAG | dBaseDate | Convert.ToDateTime(drpPeriod.Value2).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-5c08af1b | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:312 |  | VALUE_SET | cboStatus.SelectedIndex | 2 | 컨트롤 값 설정 |  |  |  |
| AC-21da891e | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:314 |  | FLAG | sLanguage | UserInfoContext.Current[UserInfoProperites.Language] | 화면 필드/플래그 변경 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)] / btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / btnReject.Click [if (bFlag) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / btnSelfReject.Click [if (bFlag) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd526bd8 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:363 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-d1c6f03f | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:365 | if (spreadInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("LookupCommon3", dtChangeReasonCode) | 목록 컨트롤 재구성 |  |  |  |
| AC-fabc4703 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:366 | if (spreadInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("Dept", dtDept) | 목록 컨트롤 재구성 |  |  |  |
| AC-4aa87c7c | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:368 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-e5811d9a | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:369 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0b173ff9 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:397 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-3454cb84 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:399 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-c67ffb8d | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:400 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f8f935b1 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:405 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ERP_SO_NO)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6d4d2165 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:407 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.LT_DAY), 1, 6, 20, "Plan", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f8b054ad | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:408 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 1, 7, 20, "Confirm", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c782b175 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:410 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ffccb009 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:411 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b02a3320 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:412 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3010318 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:413 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-62e9dc46 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:414 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_DATE), 2, 1, 30, "Shipment Date", FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bd800d01 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:415 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-09187940 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:417 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a29737d | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:418 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-067a0315 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:419 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-124f44d8 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:420 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-96f683ac | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:421 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), 2, 1, 30, "Shipment Date*", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5bf00a32 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:422 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty*", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bad53637 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:427 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ERP_SO_NO)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-4b5670a4 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:429 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.LT_DAY), 1, 7, 20, "Confirmed", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6df639a6 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:430 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 1, 7, 20, "Change", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d567daaa | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:432 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5b4f9ba5 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:433 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8380729b | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:434 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9cd881ee | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:435 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2fd94f50 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:436 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_DATE), 2, 1, 30, "Shipment Date", FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5b47356f | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:437 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e62d8970 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:439 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-537a999a | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:440 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fee4cebc | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:441 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c2f7d434 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:442 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d720c83b | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:443 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), 2, 1, 30, "Shipment Date*", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b622ac07 | this.Load 외 5 | SSP0202_ShipmentChangeRequestConfirm.cs:444 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty*", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.SaveData

진입점: btnApproval.Click [if (GetErpIFCheck("A"))] / btnReject.Click [if (bFlag)] / btnSelfReject.Click [if (bFlag)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edc4bba6 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:835 | if (sStatus == "A") ▸ for (i < siSub.ActiveSheet.RowCount) ▸ else of (sShipQty == "") | CALL_EXT | Convert.ToInt64 | (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-daf2060c | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:875 |  | ENDPOINT | new FoxDataRequest | (requestNm) ⇒ SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40 \| SSP.SSP0202_SAVE_SHIPMENT_REQUES… | 엔드포인트 요청 생성 |  |  |  |
| AC-88936e57 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:882 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5ae54fcf | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:886 | lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7c7ff72f | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:888 | lambda | DATA_OP | request.Parameters["p_change_request_no"] | p_change_req_no | 행/컬럼 값 대입 |  |  |  |
| AC-761437f0 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:889 | lambda | DATA_OP | request.Parameters["p_change_status"] | p_change_status | 행/컬럼 값 대입 |  |  |  |
| AC-aea0d5bf | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:890 | lambda | DATA_OP | request.Parameters["p_reject_reason"] | p_reject_reason | 행/컬럼 값 대입 |  |  |  |
| AC-69a764cc | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:892 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4c48bfad | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:893 | lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ef1d6e31 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:894 | lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-0816d206 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:895 | lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-81fba0fa | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:897 | lambda | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-0539c6d6 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:898 | lambda | DATA_OP | request.Parameters["p_new_confirm_id"] | p_new_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-45304b43 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:899 | lambda | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-0848d20b | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:900 | lambda | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-b75169f0 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:901 | lambda | DATA_OP | request.Parameters["p_new_qty"] | p_new_qty | 행/컬럼 값 대입 |  |  |  |
| AC-c4076142 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:902 | lambda | DATA_OP | request.Parameters["p_new_ship_date"] | p_new_ship_date | 행/컬럼 값 대입 |  |  |  |
| AC-b305ea54 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:903 | lambda | DATA_OP | request.Parameters["p_new_yn"] | p_new_yn | 행/컬럼 값 대입 |  |  |  |
| AC-0caffbca | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:905 | lambda | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-16f6c27d | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:906 | lambda | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-1a23baef | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:907 | lambda | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-c595e0bd | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:908 | lambda | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-83c69bfd | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:909 | lambda | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-a0c4a6ce | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:910 | lambda | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-a354a46f | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:911 | lambda | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-104f773e | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:912 | lambda | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-c012933d | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:913 | lambda | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-083c322c | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:914 | lambda | DATA_OP | request.Parameters["p_new_lt_day"] | p_new_lt_day | 행/컬럼 값 대입 |  |  |  |
| AC-68d5a1c3 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:915 | lambda | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-878052cc | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:917 | lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-7885e3a8 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:918 | lambda | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-030d78a8 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:919 | lambda | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-b504debc | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:921 | lambda | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-78d6d034 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:922 | lambda | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-58e36ccf | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:923 | lambda | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-029643ac | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:927 | lambda ▸ if (_bDelegate_Flag == true) | DATA_OP | request.Parameters["p_delegatee"] | _sDelegatee | 행/컬럼 값 대입 |  |  |  |
| AC-12b41bfb | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:928 | lambda ▸ if (_bDelegate_Flag == true) | DATA_OP | request.Parameters["p_delegatee_dept"] | p_delegate_dept | 행/컬럼 값 대입 |  |  |  |
| AC-0d54a093 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:932 | lambda ▸ else of (_bDelegate_Flag == true) | DATA_OP | request.Parameters["p_delegatee"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3334a519 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:933 | lambda ▸ else of (_bDelegate_Flag == true) | DATA_OP | request.Parameters["p_delegatee_dept"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-084e42e3 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:936 | lambda | DATA_OP | request.Parameters["p_shipto_code"] | p_shipto_code | 행/컬럼 값 대입 |  |  |  |
| AC-900d3efe | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:938 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5ecca294 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:938 | lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-7c6c9ce0 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:958 | if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f23aa492 | btnApproval.Click [if (GetErpIFCheck("A"))] 외 2 | SSP0202_ShipmentChangeRequestConfirm.cs:962 | else of (t.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { p_change_req_no }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-597179ed | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:209 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-16a4d247 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:210 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5fddc569 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:216 | switch (triggerControl) case "MyDivision": | FLAG | dtMyDivision | DataService.GetSSPInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-542b3c07 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:216 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d871ca41 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:221 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | FLAG | dtChangeReasonCode | DataService.GetSSPInnerTable("CHANGE_REASON_CODE_ALL", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2529dc9b | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:221 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REASON_CODE_ALL", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-46107c85 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:226 | switch (triggerControl) case "CHANGE_REQ_STATUS": | FLAG | dtChangeStatusCode | DataService.GetSSPInnerTable("CHANGE_REQ_STATUS", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f4ef39fb | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:226 | switch (triggerControl) case "CHANGE_REQ_STATUS": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REQ_STATUS", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-5a52b731 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:231 | switch (triggerControl) case "Dept": | FLAG | dtDept | DataService.GetSSPInnerTable("Dept", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-8197d667 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:231 | switch (triggerControl) case "Dept": | COMBO_DATA | DataService.GetSSPInnerTable | ("Dept", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b088da43 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:236 | switch (triggerControl) case "SALES_TYPE_CODE": | FLAG | dtFcstType | DataService.GetSSPInnerTable("SALES_TYPE_CODE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-918c3c7f | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:236 | switch (triggerControl) case "SALES_TYPE_CODE": | COMBO_DATA | DataService.GetSSPInnerTable | ("SALES_TYPE_CODE", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-86bdaaf9 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:241 | switch (triggerControl) case "CHANGE_REQ_APP_DAY": | FLAG | dtBaseDay | DataService.GetSSPInnerTable("CHANGE_REQ_APP_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-3dc92418 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:241 | switch (triggerControl) case "CHANGE_REQ_APP_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REQ_APP_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f953e284 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:246 | switch (triggerControl) case "CHANGE_REQ_TYPE": | FLAG | dtChangeReqType | DataService.GetSSPInnerTable("CHANGE_REQ_TYPE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-94811ae4 | this.Load | SSP0202_ShipmentChangeRequestConfirm.cs:246 | switch (triggerControl) case "CHANGE_REQ_TYPE": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REQ_TYPE", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.SetChangedControl

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e0e4d21 | this.Load 외 1 | SSP0202_ShipmentChangeRequestConfirm.cs:327 |  | FLAG | dtPlantSiteByDivision | Data.UserPlantSiteByDivisionOspPack(UserInfoContext.Current["NowGroupID"], UserInfoContext… | 화면 필드/플래그 변경 |  |  |  |
| AC-eb38deaf | this.Load 외 1 | SSP0202_ShipmentChangeRequestConfirm.cs:327 |  | COMBO_DATA | Data.UserPlantSiteByDivisionOspPack | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "40") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4afc111a | this.Load 외 1 | SSP0202_ShipmentChangeRequestConfirm.cs:334 |  | VALUE_SET | clbDivision.ControlValues | "40" | 컨트롤 값 설정 |  |  |  |
| AC-a91801af | this.Load 외 1 | SSP0202_ShipmentChangeRequestConfirm.cs:335 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ac53abb9 | this.Load 외 1 | SSP0202_ShipmentChangeRequestConfirm.cs:337 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, this.clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49fc7ced | (진입점 미연결) | SSP0202_ShipmentChangeRequestConfirm.cs:1044 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b5a38ca6 | (진입점 미연결) | SSP0202_ShipmentChangeRequestConfirm.cs:1047 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad23bb35 | (진입점 미연결) | SSP0202_ShipmentChangeRequestConfirm.cs:1051 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-ac1e7bb9 | (진입점 미연결) | SSP0202_ShipmentChangeRequestConfirm.cs:1052 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.SetChangeRequestInfo

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (ds.Tables[1].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43b77cd4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:733 |  | VALUE_SET | txtRequestNo.Text | sRequestNo | 컨트롤 값 설정 |  |  |  |
| AC-e66633f2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:734 |  | VALUE_SET | txtTitle.Text | sTitle | 컨트롤 값 설정 |  |  |  |
| AC-7ccce8ba | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:735 |  | VALUE_SET | txtRequestor.Text | sRequestName | 컨트롤 값 설정 |  |  |  |
| AC-5124d92d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:736 |  | VALUE_SET | txtRequestDeptName.Text | sRequestDeptName | 컨트롤 값 설정 |  |  |  |
| AC-532372c4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:737 |  | VALUE_SET | txtApproval.Text | sApproval | 컨트롤 값 설정 |  |  |  |
| AC-dd5a5ab3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:738 |  | VALUE_SET | txtAppDeptName.Text | sApprovalDeptName | 컨트롤 값 설정 |  |  |  |
| AC-00295582 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:739 |  | VALUE_SET | txtChangeReason.Text | sChaneReason | 컨트롤 값 설정 |  |  |  |
| AC-d524dc86 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0202_ShipmentChangeRequestConfirm.cs:740 |  | VALUE_SET | txtReasonDetail.Text | sReasonDetail | 컨트롤 값 설정 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.SetConfirmInfoClear

진입점: btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / btnReject.Click [if (bFlag) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / btnSelfReject.Click [if (bFlag) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af38e8f5 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:745 |  | VALUE_CLEAR | txtRequestNo.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-b3fc0bd0 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:746 |  | VALUE_CLEAR | txtTitle.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-446f2d18 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:747 |  | VALUE_CLEAR | txtRequestor.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e10fdaa2 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:748 |  | VALUE_CLEAR | txtRequestDeptName.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e40f2891 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:749 |  | VALUE_CLEAR | txtApproval.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-aeef33a8 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:750 |  | VALUE_CLEAR | txtAppDeptName.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-df408dfc | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:751 |  | VALUE_CLEAR | txtChangeReason.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-f878c677 | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:752 |  | VALUE_CLEAR | txtReasonDetail.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-35fa84aa | btnApproval.Click [if (GetErpIFCheck("A")) ▸ if (t.Success) … 외 3 | SSP0202_ShipmentChangeRequestConfirm.cs:753 |  | VALUE_CLEAR | txtRejectReason.Text | "" | 컨트롤 값 비움 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b518eb1d | this.spdMain.CellDoubleClick | SSP0202_ShipmentChangeRequestConfirm.cs:1185 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9fb6de2a | this.spdMain.CellDoubleClick | SSP0202_ShipmentChangeRequestConfirm.cs:1195 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (sStatus == "Q" && (sApproval == UserInfoContext.Current.UserId \|\| _sDelegatee == UserIn… | UI_PROP | lcBtnApproval.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-2f318216 | this.spdMain.CellDoubleClick | SSP0202_ShipmentChangeRequestConfirm.cs:1196 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (sStatus == "Q" && (sApproval == UserInfoContext.Current.UserId \|\| _sDelegatee == UserIn… | UI_PROP | lcBtnReject.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d12acc10 | this.spdMain.CellDoubleClick | SSP0202_ShipmentChangeRequestConfirm.cs:1200 | if (siMain.IsLock(siMain.SheetName) == true) ▸ else of (sStatus == "Q" && (sApproval == UserInfoContext.Current.UserId \|\| _sDelegatee == U… | UI_PROP | lcBtnApproval.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c7431212 | this.spdMain.CellDoubleClick | SSP0202_ShipmentChangeRequestConfirm.cs:1201 | if (siMain.IsLock(siMain.SheetName) == true) ▸ else of (sStatus == "Q" && (sApproval == UserInfoContext.Current.UserId \|\| _sDelegatee == U… | UI_PROP | lcBtnReject.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d5cb9328 | this.spdMain.CellDoubleClick | SSP0202_ShipmentChangeRequestConfirm.cs:1206 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (sStatus == "Q" && sRequestor == UserInfoContext.Current.UserId) | UI_PROP | lcSelfReject.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b3ae0e5a | this.spdMain.CellDoubleClick | SSP0202_ShipmentChangeRequestConfirm.cs:1210 | if (siMain.IsLock(siMain.SheetName) == true) ▸ else of (sStatus == "Q" && sRequestor == UserInfoContext.Current.UserId) | UI_PROP | lcSelfReject.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c8822956 | this.spdMain.CellDoubleClick | SSP0202_ShipmentChangeRequestConfirm.cs:1215 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_sDelegatee == UserInfoContext.Current.UserId) | FLAG | _bDelegate_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-148c5f31 | this.spdMain.CellDoubleClick | SSP0202_ShipmentChangeRequestConfirm.cs:1219 | if (siMain.IsLock(siMain.SheetName) == true) ▸ else of (_sDelegatee == UserInfoContext.Current.UserId) | FLAG | _bDelegate_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8bf832f0 | this.spdMain.CellDoubleClick | SSP0202_ShipmentChangeRequestConfirm.cs:1222 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | _sChangeType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CHANGE_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |

## SSP0202_ShipmentChangeRequestConfirm.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b40f9422 | spdMain.TopChange | SSP0202_ShipmentChangeRequestConfirm.cs:1276 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

