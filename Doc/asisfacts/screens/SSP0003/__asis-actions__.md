# AS-IS 액션 대조표 — SSP0003

> 원천: `Doc/asisfacts/screens/SSP0003/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 397행 · 메서드 30 · 종류 DATA_OP 113 · GRID_INIT 40 · RETURN 39 · ENDPOINT 38 · FLAG 34 · MESSAGE 23 · UI_PROP 19 · VALUE_CLEAR 17 · VALUE_SET 12 · GRID_LOCK 10 · COMBO_DATA 9 · GRID_SET 9 · POPUP 7 · CALL_EXT 7 · LIST_REBIND 6 · UI_MISC 5 · FOCUS 3 · STATE_RESET 2 · VALIDATE 2 · GRID_BIND 2 · ⚠ 의미 확인 필요 7


## SSP0003_ShipmentChangeRequestConfirm.BtnApproval_Click

진입점: btnApproval.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-501e5755 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:2005 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7e02c6dd | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:2010 | if (!EngProcessingChk(pDivisionID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ca81960 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:2013 | if (chkERPIFBlockYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4058b6d | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:2031 | for (iRow < siSub.ActiveSheet.RowCount) ▸ if (GetShipmentStatusChk(sDivisionID, sConfirmID) == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a77fb88 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:2035 |  | FLAG | _sStatus | "A" | 화면 필드/플래그 변경 |  |  |  |
| AC-6629fe54 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:2038 | if (!ChkDraftingData(_sStatus)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a49a358 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:2041 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00190") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-408afd67 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:2043 | if (MessageHelper.GMessageBox("MSG00190") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e361edf8 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:2066 |  | STATE_RESET | errConfrimList2.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-6fb1e9e4 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:2067 |  | FLAG | bPartialApproved | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.btnItemId_Click

진입점: btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-111ef8b9 | btnItemId.Click | SSP0003_ShipmentChangeRequestConfirm.cs:2079 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0b9ea23e | btnItemId.Click | SSP0003_ShipmentChangeRequestConfirm.cs:2081 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-0b18a8da | btnItemId.Click | SSP0003_ShipmentChangeRequestConfirm.cs:2082 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-50c2683f | btnItemId.Click | SSP0003_ShipmentChangeRequestConfirm.cs:2083 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0ed4be4b | btnItemId.Click | SSP0003_ShipmentChangeRequestConfirm.cs:2089 | if (popItem.ItemID != "") | VALUE_SET | txtItemID.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.BtnReject_Click

진입점: btnReject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1aefd7c | btnReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1959 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48b8eaf6 | btnReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1962 | if (chkERPIFBlockYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3567696f | btnReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1969 | if (string.IsNullOrEmpty(sRejectReason)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00181") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-184ee85d | btnReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1970 | if (string.IsNullOrEmpty(sRejectReason)) | FOCUS | txtRejectReason.Focus | () | 포커스 이동 |  |  |  |
| AC-fcb73486 | btnReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1971 | if (string.IsNullOrEmpty(sRejectReason)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1bf9148 | btnReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1975 | if (!ChkDraftingData("R")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0bf8b83 | btnReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1978 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00191") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2ae9a7e0 | btnReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1980 | if (MessageHelper.GMessageBox("MSG00191") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a12b24b6 | btnReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1984 |  | FLAG | _sStatus | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ae1143f3 | btnReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1995 |  | FLAG | bPartialApproved | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.BtnRequestUser_Click

진입점: btnRequestUser.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f83a8d8e | btnRequestUser.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1928 |  | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7bf54c46 | btnRequestUser.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1930 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-f1599fc9 | btnRequestUser.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1931 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-af5d9b03 | btnRequestUser.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1932 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c255603e | btnRequestUser.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1933 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-9d2f80d6 | btnRequestUser.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1934 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-50358ec9 | btnRequestUser.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1935 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-8189561b | btnRequestUser.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1937 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a29e7fe5 | btnRequestUser.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1947 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) | VALUE_SET | txtRequest.Text | strRequest.Substring(0, strRequest.Length - 1) | 컨트롤 값 설정 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.BtnSelfReject_Click

진입점: btnSelfReject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81c61b22 | btnSelfReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1888 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f16b2336 | btnSelfReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1891 | if (chkERPIFBlockYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c2bf3df | btnSelfReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1898 | if (string.IsNullOrEmpty(sRejectReason)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00181") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9dddf754 | btnSelfReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1899 | if (string.IsNullOrEmpty(sRejectReason)) | FOCUS | txtRejectReason.Focus | () | 포커스 이동 |  |  |  |
| AC-ba9c6977 | btnSelfReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1900 | if (string.IsNullOrEmpty(sRejectReason)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e967b33 | btnSelfReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1904 | if (!ChkDraftingData("S")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae72a1a7 | btnSelfReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1907 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00192") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-afee04f1 | btnSelfReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1909 | if (MessageHelper.GMessageBox("MSG00192") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-774aa91a | btnSelfReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1913 |  | FLAG | _sStatus | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-27a29403 | btnSelfReject.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1923 |  | FLAG | bPartialApproved | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.ChkDraftingData

진입점: btnApproval.Click / btnReject.Click / btnSelfReject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-939f912f | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1740 | if (sStatus == "A") ▸ if (iChkCnt == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00420") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-76c50ad7 | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1741 | if (sStatus == "A") ▸ if (iChkCnt == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ac906f77 | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1747 | if (sStatus == "A") ▸ if (iUnChkCnt > 0 && string.IsNullOrEmpty(txtRejectReason.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00181") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-20768be2 | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1748 | if (sStatus == "A") ▸ if (iUnChkCnt > 0 && string.IsNullOrEmpty(txtRejectReason.Text)) | FOCUS | txtRejectReason.Focus | () | 포커스 이동 |  |  |  |
| AC-cb31e5c4 | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1749 | if (sStatus == "A") ▸ if (iUnChkCnt > 0 && string.IsNullOrEmpty(txtRejectReason.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-62a90e98 | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1757 | else of (sStatus == "A") ▸ if (sStatus == "R") ▸ if (iUnChkCnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00421") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2ab09884 | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1758 | else of (sStatus == "A") ▸ if (sStatus == "R") ▸ if (iUnChkCnt > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4cedff40 | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1766 | else of (sStatus == "A") ▸ else of (sStatus == "R") ▸ if (sStatus == "S") ▸ if (iUnChkCnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00422") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7b1e12a | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1767 | else of (sStatus == "A") ▸ else of (sStatus == "R") ▸ if (sStatus == "S") ▸ if (iUnChkCnt > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9c34c2f2 | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1772 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.chkERPIFBlockYn

진입점: btnApproval.Click / btnReject.Click / btnSelfReject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0268bd5 | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1590 |  | FLAG | dtERPBlockYnIF | Data_SCP.Common(Data_SCP.Type.SSPBlockCheckIF, false, "SSP0003") | 화면 필드/플래그 변경 |  |  |  |
| AC-f31851a0 | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1590 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSPBlockCheckIF, false, "SSP0003") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bec30713 | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1593 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("BLOCK_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b07ee6d | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1602 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("PERIOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d252c6b | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1603 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00267", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aa4f0770 | btnApproval.Click 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1607 |  | RETURN | return resultYn; |  | 처리 중단/반환 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.ClearRequestInfo

진입점: btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸ if (GetShipmentStatusChk(sDivisionID, sConfirmID) == false) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / btnReject.Click [if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / btnSelfReject.Click [if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-748c557e | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:744 |  | VALUE_CLEAR | txtRequestNo.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-3bc83b1c | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:745 |  | VALUE_CLEAR | txtTitle.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-67b99464 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:746 |  | VALUE_CLEAR | txtRequestNo.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-70e48d05 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:747 |  | VALUE_CLEAR | txtRequestDeptName.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-3b4b3877 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:748 |  | VALUE_CLEAR | txtApproval.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-cfdd4af2 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:749 |  | VALUE_CLEAR | txtAppDeptName.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-86d01d6a | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:750 |  | VALUE_CLEAR | txtReasonDetail.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a6e8b10f | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:751 |  | VALUE_CLEAR | txtChangeReason.Text | "" | 컨트롤 값 비움 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5a340e3 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:405 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-39f027bb | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:406 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-48482368 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:409 |  | GRID_INIT | this.AddSheet | (txtApprovalDeptName, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cf115a13 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:410 |  | FLAG | siSub | GetSheetInfo(txtApprovalDeptName.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-5d0699f5 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:412 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d596caa | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:415 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98112b22 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:419 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.Delegate_Load

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c5839d4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:1834 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0003_GET_DELEGATEE_LOAD") ⇒ SSP.SSP0003_GET_DELEGATEE_LOAD | 엔드포인트 요청 생성 |  |  |  |
| AC-633184eb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:1835 |  | DATA_OP | request.Parameters["p_division_id"] | strDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-9a9d9b39 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:1836 |  | DATA_OP | request.Parameters["p_apploval"] | strApproval | 행/컬럼 값 대입 |  |  |  |
| AC-4c4fbe19 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:1838 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fa4db4ef | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:1840 | if (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count == 0) | FLAG | _sDelegatee | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-b93a40d7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:1841 | if (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count == 0) | FLAG | _sDelegatee_Dept | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a3f83856 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:1845 | else of (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count == 0) | FLAG | _sDelegatee | client.ExecuteDataSet(request).DataSet.Tables[0].Rows[0][0].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5b142949 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:1845 | else of (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count == 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f3c4971d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:1846 | else of (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count == 0) | FLAG | _sDelegatee_Dept | client.ExecuteDataSet(request).DataSet.Tables[0].Rows[0][1].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-18f3dfbb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:1846 | else of (client.ExecuteDataSet(request).DataSet.Tables[0].Rows.Count == 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-150e4cf8 | Dispose | SSP0003_ShipmentChangeRequestConfirm.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-381f4407 | EditButton | SSP0003_ShipmentChangeRequestConfirm.cs:627 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6f8b59a1 | EditButton | SSP0003_ShipmentChangeRequestConfirm.cs:628 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5751e882 | EditButton | SSP0003_ShipmentChangeRequestConfirm.cs:631 |  | FLAG | _sStatus | siMain.GetValue(siMain.ActiveSheet.ActiveRow.Index, siMain.GetColumnIndex(DefColumns.SHIPM… | 화면 필드/플래그 변경 |  |  |  |
| AC-9258447c | EditButton | SSP0003_ShipmentChangeRequestConfirm.cs:633 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1c1b58f4 | EditButton | SSP0003_ShipmentChangeRequestConfirm.cs:639 | if (fps.ActiveSheet.SheetName == SpdSheet.shtSub && _sStatus == "Q") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-bfd94d2a | EditButton | SSP0003_ShipmentChangeRequestConfirm.cs:641 | if (fps.ActiveSheet.SheetName == SpdSheet.shtSub && _sStatus == "Q") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.ERP_SO_NO), siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d7a90613 | EditButton | SSP0003_ShipmentChangeRequestConfirm.cs:642 | if (fps.ActiveSheet.SheetName == SpdSheet.shtSub && _sStatus == "Q") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.CONFIRM_ID), siSub.GetColumnIndex(DefColumns.CONFIRM_ID),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-505b2e24 | EditButton | SSP0003_ShipmentChangeRequestConfirm.cs:647 | else of (fps.ActiveSheet.SheetName == SpdSheet.shtSub && _sStatus == "Q") | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-569f15c2 | EditButton | SSP0003_ShipmentChangeRequestConfirm.cs:648 | else of (fps.ActiveSheet.SheetName == SpdSheet.shtSub && _sStatus == "Q") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.EngProcessingChk

진입점: btnApproval.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ada55f89 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1619 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK") ⇒ SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-b7cb18b5 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1620 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-6e992cc7 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1622 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-af95d17e | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1632 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00291", new object[] { remainMinute }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1eafb559 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1642 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4e6e94c8 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1644 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.FindData_Main

진입점: btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸ if (GetShipmentStatusChk(sDivisionID, sConfirmID) == false) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / btnReject.Click [if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / btnSelfReject.Click [if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e71492d | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:663 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f3db6064 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:668 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-6b32aefe | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:668 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd0bb4b4 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:672 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d87fb37d | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:692 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c6f0d9d0 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:696 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM") ⇒ SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-2f567a09 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:697 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1e2e62f0 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:698 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-42069138 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:699 | try ▸ lambda | DATA_OP | request.Parameters["p_request_id"] | p_request_id | 행/컬럼 값 대입 |  |  |  |
| AC-3d3bba4d | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:700 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-92a7ad74 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:701 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5e15455f | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:702 | try ▸ lambda | DATA_OP | request.Parameters["p_status"] | p_status | 행/컬럼 값 대입 |  |  |  |
| AC-75aa6379 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:703 | try ▸ lambda | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-d0e6f2a9 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:704 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-2e5ba5c4 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:705 | try ▸ lambda | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-6df0f31a | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:707 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cc6c80d1 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:709 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-283f0e8e | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:716 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8896dfff | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:717 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4b6569ac | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:720 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-887a2ec3 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:738 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.FindData_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64b59628 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:768 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c67444b4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:772 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING") ⇒ SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-c5247311 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:773 | lambda | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-f73c814b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:774 | lambda | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-9385abcd | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:777 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-292f4a8d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:779 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-85743584 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:787 |  | GRID_BIND | siSub.Query | (ds,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-83a497b7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:789 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8548c415 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:796 | if (p_status.Equals("E") \|\| p_status.Equals("O") \|\| p_status.Equals("R") \|\| p_status.Equals("S")) | GRID_LOCK | this.siSub.LockColumn | (this.siSub.GetColumnIndex(DefColumns.CHK), this.siSub.GetColumnIndex(DefColumns.CHK), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-768f4c11 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:800 | if (p_status.Equals("E") \|\| p_status.Equals("O") \|\| p_status.Equals("R") \|\| p_status.Equals("S")) ▸ for (iRow <= siSub.GetMaxRowIndex(… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.CHK), false) | 그리드 값 설정 |  |  |  |
| AC-a7e8519b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:805 | else of (p_status.Equals("E") \|\| p_status.Equals("O") \|\| p_status.Equals("R") \|\| p_status.Equals("S")) ▸ if (p_status.Equals("D") \|\|… | GRID_LOCK | this.siSub.LockColumn | (this.siSub.GetColumnIndex(DefColumns.CHK), this.siSub.GetColumnIndex(DefColumns.CHK), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-80fdb46b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:809 | else of (p_status.Equals("E") \|\| p_status.Equals("O") \|\| p_status.Equals("R") \|\| p_status.Equals("S")) ▸ if (p_status.Equals("D") \|\|… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.CHK), true) | 그리드 값 설정 |  |  |  |
| AC-61f68ecc | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:814 | else of (p_status.Equals("E") \|\| p_status.Equals("O") \|\| p_status.Equals("R") \|\| p_status.Equals("S")) ▸ else of (p_status.Equals("D")… | GRID_LOCK | this.siSub.LockColumn | (this.siSub.GetColumnIndex(DefColumns.CHK), this.siSub.GetColumnIndex(DefColumns.CHK), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a48e324d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:820 | else of (p_status.Equals("E") \|\| p_status.Equals("O") \|\| p_status.Equals("R") \|\| p_status.Equals("S")) ▸ else of (p_status.Equals("D")… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.CHK), statusDetail.Equals("R") \|\| statusDetail.Eq… | 그리드 값 설정 |  |  |  |
| AC-e401163d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:825 | else of (p_status.Equals("E") \|\| p_status.Equals("O") \|\| p_status.Equals("R") \|\| p_status.Equals("S")) ▸ else of (p_status.Equals("D")… | GRID_LOCK | this.siSub.LockColumn | (this.siSub.GetColumnIndex(DefColumns.CHK), this.siSub.GetColumnIndex(DefColumns.CHK), fal… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4ce6e606 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:826 | else of (p_status.Equals("E") \|\| p_status.Equals("O") \|\| p_status.Equals("R") \|\| p_status.Equals("S")) ▸ else of (p_status.Equals("D")… | GRID_LOCK | this.siSub.SetLockFlag | (this.siSub.ActiveSheet.SheetName, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4991c837 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:827 | else of (p_status.Equals("E") \|\| p_status.Equals("O") \|\| p_status.Equals("R") \|\| p_status.Equals("S")) ▸ else of (p_status.Equals("D")… | GRID_INIT | this.siSub.VisibleColumns | (0, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1bed9381 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:831 | else of (p_status.Equals("E") \|\| p_status.Equals("O") \|\| p_status.Equals("R") \|\| p_status.Equals("S")) ▸ else of (p_status.Equals("D")… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.CHK), true) | 그리드 값 설정 |  |  |  |
| AC-ff5d7591 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:835 |  | GRID_LOCK | this.siSub.LockColumn | (this.siSub.GetColumnIndex(DefColumns.CHK) + 1, this.siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb5e4925 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:209 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94a377f9 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:1864 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-7aa6c6b6 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:1865 |  | DATA_OP | request.Parameters["p_from_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d2e6f0ca | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:1866 |  | DATA_OP | request.Parameters["p_offset_day"] | "-14" | 행/컬럼 값 대입 |  |  |  |
| AC-cf3e1b63 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:1867 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-3a78bc6b | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:1868 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-63b4978a | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:1871 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.GetErpIFCheck

진입점: btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸ if (GetShipmentStatusChk(sDivisionID, sConfirmID) == false) ▸ if (_sChangeType == ChangeType.ChangeType_C)] / btnReject.Click [if (_sChangeType == ChangeType.ChangeType_C)] / btnSelfReject.Click [if (_sChangeType == ChangeType.ChangeType_C)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f8f7b7c | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1337 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK") ⇒ SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-bf8da66b | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1338 | try | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-e1adb261 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1339 | try | DATA_OP | request.Parameters["p_change_status"] | p_change_status | 행/컬럼 값 대입 |  |  |  |
| AC-cb996766 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1340 | try | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-0b1f6dd9 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1341 | try | DATA_OP | request.Parameters["p_change_type"] | sChangeType | 행/컬럼 값 대입 |  |  |  |
| AC-a07c0c54 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1342 | try | DATA_OP | request.Parameters["p_partial_approval"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-32ef7350 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1343 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-280c95b3 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1353 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | CALL_EXT | service.FN_ERP_UIWebService | (p_change_request_no, sChangeType, _sStatus) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c5aa3a3 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1360 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d49e00ea | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1367 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4bbf5fc8 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1372 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d5f3e375 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1384 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.GetErpIFCheckNew

진입점: btnApproval.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57972c6e | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1409 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK") ⇒ SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-1b8f493a | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1410 | try | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-89c6f030 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1411 | try | DATA_OP | request.Parameters["p_change_status"] | p_change_status | 행/컬럼 값 대입 |  |  |  |
| AC-69137bd7 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1412 | try | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-092595d2 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1413 | try | DATA_OP | request.Parameters["p_change_type"] | sChangeType | 행/컬럼 값 대입 |  |  |  |
| AC-d844749e | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1418 | try | DATA_OP | request.Parameters["p_partial_approval"] | sPartialApproved | 행/컬럼 값 대입 |  |  |  |
| AC-e58b2391 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1420 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5efc1b40 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1430 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | CALL_EXT | service.FN_ERP_UIWebService | (p_change_request_no, sChangeType, _sStatus) | ⚠ 의미 확인 필요 |  |  |  |
| AC-655b2635 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1439 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (service.ReE… | UI_PROP | service.ReErrorMsg | service.ReErrorMsg.Substring(0, service.ReErrorMsg.Length - 1) | 속성 ReErrorMsg 설정 |  |  |  |
| AC-de1ae332 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1446 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ for (iCount < a… | DATA_OP | errConfirmList.Add | (arrReMsg[iCount] + ":" + p_change_request_no) | 데이터 객체 조작/조회 |  |  |  |
| AC-b72a8c6b | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1450 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ for (iCount < a… | DATA_OP | errConfrimList2.Add | (arrConfirm[0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2474df0 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1458 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM") ⇒ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-7e8a838d | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1460 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-b265ae57 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1461 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-11022810 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1462 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-5220faa1 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1463 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8bd7084a | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1464 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-03e8f7f2 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1465 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_if_send_flag"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-6419c3ef | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1466 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-719769ea | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1468 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f105ad73 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1492 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (servic… | ENDPOINT | new FoxDataRequest | ("SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK") ⇒ SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-b6a1c95f | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1493 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (servic… | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-5e16125f | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1494 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (servic… | DATA_OP | request.Parameters["p_change_status"] | "R" | 행/컬럼 값 대입 |  |  |  |
| AC-028daba7 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1495 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (servic… | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-ef1fb4bb | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1496 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (servic… | DATA_OP | request.Parameters["p_change_type"] | sChangeType | 행/컬럼 값 대입 |  |  |  |
| AC-47e72f14 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1497 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (servic… | DATA_OP | request.Parameters["p_partial_approval"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-55bf9b47 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1499 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (servic… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-adbb8541 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1506 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (servic… | CALL_EXT | service.FN_ERP_UIWebService | (p_change_request_no, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6675232 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1509 | try ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (servic… | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-69952e2a | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1541 | try ▸ if (errConfirmList.Count > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM") ⇒ SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-8a57a48c | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1543 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_change_request_no"] | p_change_req | 행/컬럼 값 대입 |  |  |  |
| AC-7921308c | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1544 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-49192cc0 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1545 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_e_type"] | "E" | 행/컬럼 값 대입 |  |  |  |
| AC-0476e0b3 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1546 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_e_message"] | p_e_message | 행/컬럼 값 대입 |  |  |  |
| AC-32bce4b3 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1547 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-359c3828 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1549 | try ▸ if (errConfirmList.Count > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f56f980d | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1555 | try ▸ if (errConfirmList.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3846e5d7 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1561 | finally | STATE_RESET | errConfirmList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-5322c465 | btnApproval.Click | SSP0003_ShipmentChangeRequestConfirm.cs:1564 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.GetShipmentStatusChk

진입점: btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8625f656 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount)] | SSP0003_ShipmentChangeRequestConfirm.cs:1656 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_GET_SHIPMENT_STATUS") ⇒ SSP.SSP0200_GET_SHIPMENT_STATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-68eac84f | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount)] | SSP0003_ShipmentChangeRequestConfirm.cs:1657 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-5bab557b | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount)] | SSP0003_ShipmentChangeRequestConfirm.cs:1658 | try | DATA_OP | request.Parameters["p_confirm_id"] | sConfirmID | 행/컬럼 값 대입 |  |  |  |
| AC-de995d5d | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount)] | SSP0003_ShipmentChangeRequestConfirm.cs:1660 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b94e2044 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount)] | SSP0003_ShipmentChangeRequestConfirm.cs:1704 | try ▸ if (ds.Tables[2].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00413", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e409c503 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount)] | SSP0003_ShipmentChangeRequestConfirm.cs:1708 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-65050fd7 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount)] | SSP0003_ShipmentChangeRequestConfirm.cs:1710 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6b22365 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:304 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8005e09a | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:307 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6e5769b | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:308 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtSub) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9e1ecb3 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:311 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl1) | 권한 검사/설정 |  |  |  |
| AC-0af50bab | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:317 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_GET_SHIPMENT_DIVISION") ⇒ SSP.SSP0200_GET_SHIPMENT_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-ad4c6d2f | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:321 |  | DATA_OP | request.Parameters["Param1"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3677903a | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:322 |  | DATA_OP | request.Parameters["Param2"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0348ccf8 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:323 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-af3afbdc | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:327 |  | FLAG | dtMyDivision | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-4c840f43 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:330 |  | FLAG | dtMyDivision | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-593b9912 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:330 |  | DATA_OP | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bfd80881 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:330 |  | DATA_OP | dtMyDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fecf5e70 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:332 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-35dcfe7e | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:334 |  | LIST_REBIND | clsCtrl.setListBox | (dtChangeStatusCode, cboStatus, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-20a3fd2c | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:336 |  | LIST_REBIND | clsCtrl.setListBox | (dtChangeReqType, cboChangeType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-be22a9bd | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:340 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-39cecf1a | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:343 | if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-02c1b9cf | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:345 |  | FLAG | dBaseDate | Convert.ToDateTime(drpPeriod.Value2).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-075a3d25 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:347 |  | VALUE_SET | cboStatus.SelectedIndex | 2 | 컨트롤 값 설정 |  |  |  |
| AC-854dcd4a | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:349 |  | FLAG | sLanguage | UserInfoContext.Current[UserInfoProperites.Language] | 화면 필드/플래그 변경 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)] / btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸ if (GetShipmentStatusChk(sDivisionID, sConfirmID) == false) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / btnReject.Click [if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / btnSelfReject.Click [if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27ec5b08 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:426 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8e414aca | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:428 | if (spreadInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("LookupCommon3", dtChangeReasonCode) | 목록 컨트롤 재구성 |  |  |  |
| AC-5956e36e | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:429 | if (spreadInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("Dept", dtDept) | 목록 컨트롤 재구성 |  |  |  |
| AC-96f5ab23 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:431 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-1ee41b9d | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:432 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5953ad9e | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:437 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-24c09067 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:439 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-c451e98e | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:447 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | spreadInfo.ActiveSheet.ColumnHeader.Cells[0, spreadInfo.GetColumnIndex(DefColumns.CHK)].Ce… | chk | 그리드 속성/값 설정 |  |  |  |
| AC-9b3b203b | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:448 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | spreadInfo.ActiveSheet.ColumnHeader.Cells[0, spreadInfo.GetColumnIndex(DefColumns.CHK)].Va… | true | 그리드 속성/값 설정 |  |  |  |
| AC-7e877670 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:449 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | spreadInfo.ActiveSheet.ColumnHeader.Cells[0, spreadInfo.GetColumnIndex(DefColumns.CHK)].Bo… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-0dc0e285 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:453 | if (spreadInfo.SheetName == SpdSheet.shtSub) | UI_PROP | col.MergePolicy | FarPoint.Win.Spread.Model.MergePolicy.None | 속성 MergePolicy 설정 |  |  |  |
| AC-e19b2059 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:470 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2d8e913f | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:475 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ERP_SO_NO)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4dfa72cc | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:477 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.LT_DAY), 1, 6, 20, "Plan", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6af1aa7b | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:478 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 1, 6, 20, "Confirm", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bbfd3035 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:480 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-338fdce6 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:481 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e45f098f | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:482 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d7c450b | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:483 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-495483b5 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:484 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_DATE), 2, 1, 30, "Shipment Date", FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5faf1efe | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:485 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd2903c4 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:487 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f4aea09a | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:488 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fbb04bf4 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:489 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-44c01ce0 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:490 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-42629bca | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:491 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), 2, 1, 30, "Shipment Date*", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0fafb06c | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:492 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty*", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7c6ae894 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:496 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | CALL_EXT | spreadInfo.SetDecimal | (index0, index0, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-031e8cfe | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:497 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (_sChangeType == ChangeType.ChangeType_P) | CALL_EXT | spreadInfo.SetDecimal | (index, index, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba98bfdd | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:503 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ERP_SO_NO)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f6552cab | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:505 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.LT_DAY), 1, 6, 20, "Confirmed", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f95a989f | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:506 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (0, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 1, 6, 20, "Change", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a3e82c97 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:508 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d91a283 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:509 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-351c8601 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:510 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a33b4590 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:511 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae5ab0ef | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:512 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_DATE), 2, 1, 30, "Shipment Date", FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a22e35d6 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:513 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-64b64b25 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:515 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-105d1c17 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:516 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-99e31c9e | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:517 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3ad10b77 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:518 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-401e48ca | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:519 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), 2, 1, 30, "Shipment Date*", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7e87ced8 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:520 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | GRID_INIT | siSub.ColumnHeaderSpan | (1, siSub.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty*", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-02fd4552 | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:524 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | CALL_EXT | spreadInfo.SetDecimal | (index, index, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6ddadca | this.Load 외 5 | SSP0003_ShipmentChangeRequestConfirm.cs:525 | if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (_sChangeType == ChangeType.ChangeType_P) | CALL_EXT | spreadInfo.SetDecimal | (index0, index0, 3, true) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.SaveData

진입점: btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸ if (GetShipmentStatusChk(sDivisionID, sConfirmID) == false) ▸ if (bFlag)] / btnReject.Click [if (bFlag)] / btnSelfReject.Click [if (bFlag)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75917f5a | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1207 |  | ENDPOINT | new FoxDataRequest | (requestNm) ⇒ SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 \| SSP.SSP0003_SAVE_SHIPMENT_REQUES… | 엔드포인트 요청 생성 |  |  |  |
| AC-a75ae6a1 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1214 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-157e23e8 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1218 | lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-dbac8d51 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1231 | lambda | DATA_OP | request.Parameters["p_change_request_no"] | p_change_req_no | 행/컬럼 값 대입 |  |  |  |
| AC-10bed7e8 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1232 | lambda | DATA_OP | request.Parameters["p_change_status"] | p_change_status | 행/컬럼 값 대입 |  |  |  |
| AC-a9b516fc | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1233 | lambda | DATA_OP | request.Parameters["p_reject_reason"] | p_reject_reason | 행/컬럼 값 대입 |  |  |  |
| AC-14c4b202 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1235 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d7ee5bd8 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1236 | lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-95a5f109 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1237 | lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-32f1010a | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1238 | lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6e59f8ca | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1240 | lambda | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-937c47bd | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1241 | lambda | DATA_OP | request.Parameters["p_new_confirm_id"] | p_new_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-ff13c51f | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1242 | lambda | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-e82fd48b | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1243 | lambda | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-775ab90b | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1244 | lambda | DATA_OP | request.Parameters["p_new_qty"] | p_new_qty | 행/컬럼 값 대입 |  |  |  |
| AC-0cf75180 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1245 | lambda | DATA_OP | request.Parameters["p_new_ship_date"] | p_new_ship_date | 행/컬럼 값 대입 |  |  |  |
| AC-6c677b85 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1246 | lambda | DATA_OP | request.Parameters["p_new_yn"] | p_new_yn | 행/컬럼 값 대입 |  |  |  |
| AC-d4916708 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1248 | lambda | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-dcb8a9d2 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1249 | lambda | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-45794501 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1250 | lambda | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-bca88593 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1251 | lambda | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-c85b567f | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1252 | lambda | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-390f4f11 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1253 | lambda | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-dfe3cbc7 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1254 | lambda | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-7a8a94f3 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1255 | lambda | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-e039aa0c | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1256 | lambda | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-72af2ee6 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1257 | lambda | DATA_OP | request.Parameters["p_new_lt_day"] | p_new_lt_day | 행/컬럼 값 대입 |  |  |  |
| AC-eca27db4 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1258 | lambda | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-40d8dd77 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1260 | lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-6faab3b1 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1261 | lambda | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-faf1ea94 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1262 | lambda | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-b94a6659 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1264 | lambda | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-16c9769d | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1265 | lambda | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-c4c944bd | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1266 | lambda | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-2c2360fb | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1270 | lambda ▸ if (_bDelegate_Flag == true) | DATA_OP | request.Parameters["p_delegatee"] | _sDelegatee | 행/컬럼 값 대입 |  |  |  |
| AC-053af6a7 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1271 | lambda ▸ if (_bDelegate_Flag == true) | DATA_OP | request.Parameters["p_delegatee_dept"] | p_delegate_dept | 행/컬럼 값 대입 |  |  |  |
| AC-239a34e6 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1275 | lambda ▸ else of (_bDelegate_Flag == true) | DATA_OP | request.Parameters["p_delegatee"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-41b40746 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1276 | lambda ▸ else of (_bDelegate_Flag == true) | DATA_OP | request.Parameters["p_delegatee_dept"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-43c69852 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1280 | lambda | DATA_OP | request.Parameters["p_erp_attr1"] | p_erp_attr1 | 행/컬럼 값 대입 |  |  |  |
| AC-ab49e4e9 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1281 | lambda | DATA_OP | request.Parameters["p_erp_attr2"] | p_erp_attr2 | 행/컬럼 값 대입 |  |  |  |
| AC-3f8a37b6 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1282 | lambda | DATA_OP | request.Parameters["p_erp_attr3"] | p_erp_attr3 | 행/컬럼 값 대입 |  |  |  |
| AC-f8e43549 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1284 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c0e6ea2c | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1284 | lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-3718dcef | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1304 | if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d0fe22ca | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1309 | else of (t.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { p_change_req_no }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.SaveDraftingData

진입점: btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸ if (GetShipmentStatusChk(sDivisionID, sConfirmID) == false)] / btnReject.Click / btnSelfReject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d97aab8d | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:970 |  | ENDPOINT | new FoxDataRequest | (requestNm) ⇒ SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-c84e8092 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:974 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-57bf7a12 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:978 | lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5130db0f | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:989 | lambda ▸ if (sStatus.Equals("A")) ▸ else of (iChkCnt > 0 && iUnChkCnt == 0) ▸ else of (iChkCnt == 0 && iUnChkCnt > 0) ▸ if (iChkCnt > 0 && i… | FLAG | bPartialApproved | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d1e71bd6 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:998 | lambda | DATA_OP | request.Parameters["p_change_request_no"] | p_change_req_no | 행/컬럼 값 대입 |  |  |  |
| AC-f63fa1ef | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:999 | lambda | DATA_OP | request.Parameters["p_change_status"] | p_change_status | 행/컬럼 값 대입 |  |  |  |
| AC-908d5452 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1001 | lambda | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-8cae2eb3 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1002 | lambda | DATA_OP | request.Parameters["p_new_confirm_id"] | p_new_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-44a8abfa | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1004 | lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-92814a5a | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1005 | lambda | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-e7ed59c1 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1008 | lambda | DATA_OP | request.Parameters["p_status_detail"] | p_status_detail | 행/컬럼 값 대입 |  |  |  |
| AC-fa3f66dd | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1009 | lambda | DATA_OP | request.Parameters["p_reject_reason"] | p_reject_reason | 행/컬럼 값 대입 |  |  |  |
| AC-20bd9422 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1012 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ac7ec622 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1012 | lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-1486cb92 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1032 | if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0c409b14 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 2 | SSP0003_ShipmentChangeRequestConfirm.cs:1037 | else of (t.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { p_change_req_no }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90cd7345 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:227 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-617675bc | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:228 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ea699cf8 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:234 | switch (triggerControl) case "MyDivision": | FLAG | dtMyDivision | DataService.GetSSPInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-924e5e9b | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:234 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b3598bdc | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:239 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | FLAG | dtChangeReasonCode | DataService.GetSSPInnerTable("CHANGE_REASON_CODE_ALL", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9307c04c | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:239 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REASON_CODE_ALL", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1dc560fa | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:244 | switch (triggerControl) case "CHANGE_REQ_STATUS": | FLAG | dtChangeStatusCode | DataService.GetSSPInnerTable("CHANGE_REQ_STATUS", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-50054fb8 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:244 | switch (triggerControl) case "CHANGE_REQ_STATUS": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REQ_STATUS", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-06138d47 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:249 | switch (triggerControl) case "Dept": | FLAG | dtDept | DataService.GetSSPInnerTable("Dept", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a02e21fe | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:249 | switch (triggerControl) case "Dept": | COMBO_DATA | DataService.GetSSPInnerTable | ("Dept", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-02345ea9 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:254 | switch (triggerControl) case "SALES_TYPE_CODE": | FLAG | dtFcstType | DataService.GetSSPInnerTable("SALES_TYPE_CODE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-161a5af6 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:254 | switch (triggerControl) case "SALES_TYPE_CODE": | COMBO_DATA | DataService.GetSSPInnerTable | ("SALES_TYPE_CODE", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-be34b3f5 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:259 | switch (triggerControl) case "CHANGE_REQ_APP_DAY": | FLAG | dtBaseDay | DataService.GetSSPInnerTable("CHANGE_REQ_APP_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-793bfbe2 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:259 | switch (triggerControl) case "CHANGE_REQ_APP_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REQ_APP_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-91c8fac8 | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:264 | switch (triggerControl) case "CHANGE_REQ_TYPE": | FLAG | dtChangeReqType | DataService.GetSSPInnerTable("CHANGE_REQ_TYPE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5abe28ed | this.Load | SSP0003_ShipmentChangeRequestConfirm.cs:264 | switch (triggerControl) case "CHANGE_REQ_TYPE": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REQ_TYPE", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.SetChangedControl

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4fd8525 | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:366 |  | DATA_OP | pDivisionID.Contains | ("EE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f9fca880 | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:369 | if (!pDivisionID.Contains("EE")) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION") ⇒ SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-1e0fbb70 | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:373 | if (!pDivisionID.Contains("EE")) | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-d89f1a14 | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:374 | if (!pDivisionID.Contains("EE")) | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-219dc419 | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:375 | if (!pDivisionID.Contains("EE")) | DATA_OP | request.Parameters["p_valid_yn"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-07e28b06 | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:376 | if (!pDivisionID.Contains("EE")) | DATA_OP | request.Parameters["p_now_group_id"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-49d5f02e | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:377 | if (!pDivisionID.Contains("EE")) | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4328655a | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:378 | if (!pDivisionID.Contains("EE")) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-95ea37a7 | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:381 | if (!pDivisionID.Contains("EE")) | FLAG | dtPlantSiteByDivision | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-388d7ff2 | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:386 | else of (!pDivisionID.Contains("EE")) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE") ⇒ SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 엔드포인트 요청 생성 |  |  |  |
| AC-b1cd4992 | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:390 | else of (!pDivisionID.Contains("EE")) | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-2e245cff | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:391 | else of (!pDivisionID.Contains("EE")) | DATA_OP | request.Parameters["p_now_group_id"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8db20199 | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:392 | else of (!pDivisionID.Contains("EE")) | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1e787e63 | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:393 | else of (!pDivisionID.Contains("EE")) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2d6e6c4c | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:396 | else of (!pDivisionID.Contains("EE")) | FLAG | dtPlantSiteByDivision | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-4a76e223 | this.Load 외 1 | SSP0003_ShipmentChangeRequestConfirm.cs:400 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, this.clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa4b3f11 | (진입점 미연결) | SSP0003_ShipmentChangeRequestConfirm.cs:1573 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6fe18023 | (진입점 미연결) | SSP0003_ShipmentChangeRequestConfirm.cs:1576 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2aa00385 | (진입점 미연결) | SSP0003_ShipmentChangeRequestConfirm.cs:1580 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-25425d7e | (진입점 미연결) | SSP0003_ShipmentChangeRequestConfirm.cs:1581 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.SetChangeRequestInfo

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (ds.Tables[1].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c88e8da | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:862 |  | VALUE_SET | txtRequestNo.Text | sRequestNo | 컨트롤 값 설정 |  |  |  |
| AC-d0f83eab | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:863 |  | VALUE_SET | txtTitle.Text | sTitle | 컨트롤 값 설정 |  |  |  |
| AC-d7868061 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:864 |  | VALUE_SET | txtRequestor.Text | sRequestName | 컨트롤 값 설정 |  |  |  |
| AC-25419458 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:865 |  | VALUE_SET | txtRequestDeptName.Text | sRequestDeptName | 컨트롤 값 설정 |  |  |  |
| AC-cc9911d2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:866 |  | VALUE_SET | txtApproval.Text | sApproval | 컨트롤 값 설정 |  |  |  |
| AC-ba01043a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:867 |  | VALUE_SET | txtAppDeptName.Text | sApprovalDeptName | 컨트롤 값 설정 |  |  |  |
| AC-37a72132 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:868 |  | VALUE_SET | txtChangeReason.Text | sChaneReason | 컨트롤 값 설정 |  |  |  |
| AC-e3224470 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SSP0003_ShipmentChangeRequestConfirm.cs:869 |  | VALUE_SET | txtReasonDetail.Text | sReasonDetail | 컨트롤 값 설정 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.SetConfirmInfoClear

진입점: btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸ if (GetShipmentStatusChk(sDivisionID, sConfirmID) == false) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / btnReject.Click [if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / btnSelfReject.Click [if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa1eb457 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:874 |  | VALUE_CLEAR | txtRequestNo.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-f4257ea3 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:875 |  | VALUE_CLEAR | txtTitle.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-b1a613ed | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:876 |  | VALUE_CLEAR | txtRequestor.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-cdefed52 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:877 |  | VALUE_CLEAR | txtRequestDeptName.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-d1d506ee | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:878 |  | VALUE_CLEAR | txtApproval.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c4498c77 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:879 |  | VALUE_CLEAR | txtAppDeptName.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-10a67a56 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:880 |  | VALUE_CLEAR | txtChangeReason.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1e3e6cb9 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:881 |  | VALUE_CLEAR | txtReasonDetail.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e3ac53e6 | btnApproval.Click [for (iRow < siSub.ActiveSheet.RowCount) ▸… 외 3 | SSP0003_ShipmentChangeRequestConfirm.cs:882 |  | VALUE_CLEAR | txtRejectReason.Text | "" | 컨트롤 값 비움 |  |  |  |

## SSP0003_ShipmentChangeRequestConfirm.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62d9d856 | this.spdMain.CellDoubleClick | SSP0003_ShipmentChangeRequestConfirm.cs:1784 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | selRow | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8aedb2bf | this.spdMain.CellDoubleClick | SSP0003_ShipmentChangeRequestConfirm.cs:1786 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df1820e5 | this.spdMain.CellDoubleClick | SSP0003_ShipmentChangeRequestConfirm.cs:1796 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (sStatus == "Q" && (sApproval == UserInfoContext.Current.UserId \|\| _sDelegatee == UserIn… | UI_PROP | lcBtnApproval.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-22662ac2 | this.spdMain.CellDoubleClick | SSP0003_ShipmentChangeRequestConfirm.cs:1797 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (sStatus == "Q" && (sApproval == UserInfoContext.Current.UserId \|\| _sDelegatee == UserIn… | UI_PROP | lcBtnReject.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-68578a37 | this.spdMain.CellDoubleClick | SSP0003_ShipmentChangeRequestConfirm.cs:1801 | if (siMain.IsLock(siMain.SheetName) == true) ▸ else of (sStatus == "Q" && (sApproval == UserInfoContext.Current.UserId \|\| _sDelegatee == U… | UI_PROP | lcBtnApproval.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9fbf1064 | this.spdMain.CellDoubleClick | SSP0003_ShipmentChangeRequestConfirm.cs:1802 | if (siMain.IsLock(siMain.SheetName) == true) ▸ else of (sStatus == "Q" && (sApproval == UserInfoContext.Current.UserId \|\| _sDelegatee == U… | UI_PROP | lcBtnReject.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2c4e79a3 | this.spdMain.CellDoubleClick | SSP0003_ShipmentChangeRequestConfirm.cs:1807 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (sStatus == "Q" && sRequestor == UserInfoContext.Current.UserId) | UI_PROP | lcSelfReject.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-21bbdcfd | this.spdMain.CellDoubleClick | SSP0003_ShipmentChangeRequestConfirm.cs:1811 | if (siMain.IsLock(siMain.SheetName) == true) ▸ else of (sStatus == "Q" && sRequestor == UserInfoContext.Current.UserId) | UI_PROP | lcSelfReject.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ee56a0e9 | this.spdMain.CellDoubleClick | SSP0003_ShipmentChangeRequestConfirm.cs:1816 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_sDelegatee == UserInfoContext.Current.UserId) | FLAG | _bDelegate_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f81c8aaa | this.spdMain.CellDoubleClick | SSP0003_ShipmentChangeRequestConfirm.cs:1820 | if (siMain.IsLock(siMain.SheetName) == true) ▸ else of (_sDelegatee == UserInfoContext.Current.UserId) | FLAG | _bDelegate_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1c0afcc8 | this.spdMain.CellDoubleClick | SSP0003_ShipmentChangeRequestConfirm.cs:1823 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | _sChangeType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CHANGE_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |

