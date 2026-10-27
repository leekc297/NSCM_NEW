# AS-IS 액션 대조표 — SSP0016

> 원천: `Doc/asisfacts/screens/SSP0016/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 526행 · 메서드 46 · 종류 DATA_OP 99 · GRID_SET 69 · FLAG 50 · GRID_INIT 50 · GRID_COMBO 40 · UI_PROP 36 · RETURN 32 · ENDPOINT 23 · MESSAGE 21 · GRID_LOCK 18 · COMBO_DATA 17 · POPUP 14 · CALL_EXT 13 · VALUE_SET 12 · UI_MISC 10 · LIST_REBIND 8 · VALIDATE 4 · STATE 4 · GRID_BIND 3 · GRID_CLEAR 2 · STATE_RESET 1 · ⚠ 의미 확인 필요 13


## SSP0016_ShipmentRequest.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c12d381e | this.btnItemId.Click | SSP0016_ShipmentRequest.cs:825 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e577c0a8 | this.btnItemId.Click | SSP0016_ShipmentRequest.cs:827 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-3931c3db | this.btnItemId.Click | SSP0016_ShipmentRequest.cs:828 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-befcd3e9 | this.btnItemId.Click | SSP0016_ShipmentRequest.cs:829 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e1dd8ed3 | this.btnItemId.Click | SSP0016_ShipmentRequest.cs:835 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0016_ShipmentRequest.btnItemID2_Click

진입점: this.btnItemID2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8517101 | this.btnItemID2.Click | SSP0016_ShipmentRequest.cs:863 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c9a4def5 | this.btnItemID2.Click | SSP0016_ShipmentRequest.cs:865 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9559359a | this.btnItemID2.Click | SSP0016_ShipmentRequest.cs:866 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bfd4b4e8 | this.btnItemID2.Click | SSP0016_ShipmentRequest.cs:867 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-78504985 | this.btnItemID2.Click | SSP0016_ShipmentRequest.cs:873 | if (popItem.ItemID != "") | VALUE_SET | txtItemId2.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0016_ShipmentRequest.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96e003c3 | this.btnMeasure.Click | SSP0016_ShipmentRequest.cs:922 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf1ae312 | this.btnMeasure.Click | SSP0016_ShipmentRequest.cs:927 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c94246b7 | this.btnMeasure.Click | SSP0016_ShipmentRequest.cs:928 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a682fc7 | this.btnMeasure.Click | SSP0016_ShipmentRequest.cs:933 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da09c1b6 | this.btnMeasure.Click | SSP0016_ShipmentRequest.cs:934 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ab3bb6f | this.btnMeasure.Click | SSP0016_ShipmentRequest.cs:937 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0016", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-3d369351 | this.btnMeasure.Click | SSP0016_ShipmentRequest.cs:938 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c9ea24bf | this.btnMeasure.Click | SSP0016_ShipmentRequest.cs:939 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ab33be2e | this.btnMeasure.Click | SSP0016_ShipmentRequest.cs:943 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-e1342247 | this.btnMeasure.Click | SSP0016_ShipmentRequest.cs:953 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SSP0016_ShipmentRequest.btnRequestor_Click

진입점: this.btnRequestor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1122033 | this.btnRequestor.Click | SSP0016_ShipmentRequest.cs:879 |  | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a72fdcb3 | this.btnRequestor.Click | SSP0016_ShipmentRequest.cs:881 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-42fd9063 | this.btnRequestor.Click | SSP0016_ShipmentRequest.cs:882 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-818a9928 | this.btnRequestor.Click | SSP0016_ShipmentRequest.cs:883 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c2997bd9 | this.btnRequestor.Click | SSP0016_ShipmentRequest.cs:884 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-a67e057c | this.btnRequestor.Click | SSP0016_ShipmentRequest.cs:885 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-4e4b0003 | this.btnRequestor.Click | SSP0016_ShipmentRequest.cs:887 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-0febc1b0 | this.btnRequestor.Click | SSP0016_ShipmentRequest.cs:889 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-50378b71 | this.btnRequestor.Click | SSP0016_ShipmentRequest.cs:895 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sRequestorID | item.UserID | 화면 필드/플래그 변경 |  |  |  |
| AC-fadedba2 | this.btnRequestor.Click | SSP0016_ShipmentRequest.cs:899 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName | 컨트롤 값 설정 |  |  |  |
| AC-fde72841 | this.btnRequestor.Click | SSP0016_ShipmentRequest.cs:903 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName_E | 컨트롤 값 설정 |  |  |  |

## SSP0016_ShipmentRequest.btnSearch_Click

진입점: this.btnSearch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5023d723 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1582 | if (this.chkDelete.Checked == true) | FLAG | bDelete_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d2dda947 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1586 | else of (this.chkDelete.Checked == true) | FLAG | bDelete_Flag | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0016_ShipmentRequest.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ca7a4eb | cboPlanDate.SelectedIndexChanged | SSP0016_ShipmentRequest.cs:2245 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-4052d6d7 | cboPlanDate.SelectedIndexChanged | SSP0016_ShipmentRequest.cs:2248 |  | DATA_OP | dtPlanDate.Select | ("CODE = '" + pReqDate + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-88bf203d | cboPlanDate.SelectedIndexChanged | SSP0016_ShipmentRequest.cs:2251 | if (drDate != null) | VALUE_SET | drpAvailable.InitValue | drDate[DefColumns.REQ_START_DATE].ToString() + ":" + drDate[DefColumns.REQ_END_DATE].ToStr… | 컨트롤 값 설정 |  |  |  |
| AC-816d4a5c | cboPlanDate.SelectedIndexChanged | SSP0016_ShipmentRequest.cs:2252 | if (drDate != null) | FLAG | reqInStartDate | drDate[DefColumns.REQ_IN_START_DATE].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e65f591b | cboPlanDate.SelectedIndexChanged | SSP0016_ShipmentRequest.cs:2253 | if (drDate != null) | FLAG | reqInEndDate | drDate[DefColumns.REQ_IN_END_DATE].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-03cb2679 | cboPlanDate.SelectedIndexChanged | SSP0016_ShipmentRequest.cs:2256 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-6245fe10 | cboPlanDate.SelectedIndexChanged | SSP0016_ShipmentRequest.cs:2257 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdDetail) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0016_ShipmentRequest.chkBalanceSum

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eccd7b01 | (진입점 미연결) | SSP0016_ShipmentRequest.cs:2133 | if (dtBalance == null \|\| dtBalance.Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b56878f0 | (진입점 미연결) | SSP0016_ShipmentRequest.cs:2147 | for (iCol <= siDetail.GetMaxColumnIndex()) ▸ if (siDetail.GetColumnValue(iCol).IndexOf("D_") == 0) ▸ if (sum >= balance && sum != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00270", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-34d5b526 | (진입점 미연결) | SSP0016_ShipmentRequest.cs:2154 |  | RETURN | return chkTF; |  | 처리 중단/반환 |  |  |  |

## SSP0016_ShipmentRequest.chkIncludINF_Click

진입점: this.chkInculdINF.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-092d7935 | this.chkInculdINF.Click | SSP0016_ShipmentRequest.cs:847 | for (i <= siDetail.GetMaxRowIndex()) ▸ if (siDetail.GetValue(i, siDetail.GetColumnIndex(DefColumns.MEASURE)).ToString() == "RTF_System[R+P]"… | CALL_EXT | siDetail.VisibleRow | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9af9389c | this.chkInculdINF.Click | SSP0016_ShipmentRequest.cs:851 | for (i <= siDetail.GetMaxRowIndex()) ▸ if (siDetail.GetValue(i, siDetail.GetColumnIndex(DefColumns.MEASURE)).ToString() == "RTF_System[R+P]"… | CALL_EXT | siDetail.VisibleRow | (i, false) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0016_ShipmentRequest.chkQtyNewLine

진입점: SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27bfef21 | SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != n… | SSP0016_ShipmentRequest.cs:2185 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (!lineQty) | MESSAGE | MessageHelper.GMessageBox | ("MSG00271", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-72b3b42d | SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != n… | SSP0016_ShipmentRequest.cs:2195 | for (i < siDetail.ActiveSheet.RowCount) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSP16LocTransMode, false, pDivisionId, pFromSite, strToSite, strIncoterms) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f1bd85c5 | SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != n… | SSP0016_ShipmentRequest.cs:2196 | for (i < siDetail.ActiveSheet.RowCount) | DATA_OP | dtlocTrans.Select().Where(c => c["CODE"].ToString() == strTransmode).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9463f2ff | SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != n… | SSP0016_ShipmentRequest.cs:2196 | for (i < siDetail.ActiveSheet.RowCount) | DATA_OP | dtlocTrans.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1e950c74 | SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != n… | SSP0016_ShipmentRequest.cs:2197 | for (i < siDetail.ActiveSheet.RowCount) | GRID_COMBO | siDetail.SetCellTypeCombo | (i, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocTrans) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-82441347 | SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != n… | SSP0016_ShipmentRequest.cs:2201 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (dtTmpBod.Rows.Count == 1) | GRID_SET | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE)].Value | dtTmpBod.Rows[0][0].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-7b94575a | SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != n… | SSP0016_ShipmentRequest.cs:2206 | for (i < siDetail.ActiveSheet.RowCount) ▸ else of (dtTmpBod.Rows.Count == 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00293", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f0fbf4cd | SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != n… | SSP0016_ShipmentRequest.cs:2212 |  | RETURN | return chkQty; |  | 처리 중단/반환 |  |  |  |

## SSP0016_ShipmentRequest.ClearDetailLocalData

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / FindButton [if (!isReload)] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!isReload)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca391f6d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:2114 |  | FLAG | dtBalance | null | 화면 필드/플래그 변경 |  |  |  |
| AC-550b2274 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:2115 |  | FLAG | dtlocBodTotal | null | 화면 필드/플래그 변경 |  |  |  |
| AC-103e67ce | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:2116 |  | FLAG | pDivisionId | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d8f73b6f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:2117 |  | FLAG | pFromSite | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e17ae622 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:2118 |  | FLAG | pItemId | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-25cf66bf | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:2119 |  | FLAG | pPlanStartYYYYMMDD | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-118b3094 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:2120 |  | FLAG | pPlanType | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ff40b0ae | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:2121 |  | FLAG | pSeq | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d4bf9559 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:2122 |  | FLAG | pNickName | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-eb8b858a | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:2123 |  | FLAG | pBizType | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e3093450 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:2124 |  | FLAG | pReqMstId | "" | 화면 필드/플래그 변경 |  |  |  |

## SSP0016_ShipmentRequest.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa7d86ca | (진입점 미연결) | SSP0016_ShipmentRequest.cs:229 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-67096ee8 | (진입점 미연결) | SSP0016_ShipmentRequest.cs:230 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0016_ShipmentRequest.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89964df0 | this.Load | SSP0016_ShipmentRequest.cs:268 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-82738211 | this.Load | SSP0016_ShipmentRequest.cs:269 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtDetail, SpdSheet.shtDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-246a0a49 | this.Load | SSP0016_ShipmentRequest.cs:270 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtDetail_All, SpdSheet.shtDetail_All, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-46977858 | this.Load | SSP0016_ShipmentRequest.cs:272 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-6d93f8b0 | this.Load | SSP0016_ShipmentRequest.cs:275 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-a0f52cc0 | this.Load | SSP0016_ShipmentRequest.cs:279 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-fbd63273 | this.Load | SSP0016_ShipmentRequest.cs:280 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail_All) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa77112d | this.Load | SSP0016_ShipmentRequest.cs:283 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-008f213b | this.Load | SSP0016_ShipmentRequest.cs:284 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0016_ShipmentRequest.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd306bc9 | this.Load | SSP0016_ShipmentRequest.cs:219 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-8ccec612 | this.Load | SSP0016_ShipmentRequest.cs:220 |  | VALUE_SET | cboBucketType_Detail.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SSP0016_ShipmentRequest.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92799e45 | DeleteButton | SSP0016_ShipmentRequest.cs:685 | if (fps != null) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-86f17e90 | DeleteButton | SSP0016_ShipmentRequest.cs:690 | if (fps != null) ▸ if (fps.Name == "spdDetail") | DATA_OP | siDetail.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0016_ShipmentRequest.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d43548f5 | Dispose | SSP0016_ShipmentRequest.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0016_ShipmentRequest.Dsdm_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6584a371 | dsdm.Changed | SSP0016_ShipmentRequest.cs:504 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange != true \|\| e.Row == -1 && e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e5cca53 | dsdm.Changed | SSP0016_ShipmentRequest.cs:505 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dd697ed5 | dsdm.Changed | SSP0016_ShipmentRequest.cs:515 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cc158fda | dsdm.Changed | SSP0016_ShipmentRequest.cs:516 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2e302ae1 | dsdm.Changed | SSP0016_ShipmentRequest.cs:517 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-97adb8c5 | dsdm.Changed | SSP0016_ShipmentRequest.cs:518 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-7f8f2c6d | dsdm.Changed | SSP0016_ShipmentRequest.cs:519 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-ea0f0038 | dsdm.Changed | SSP0016_ShipmentRequest.cs:520 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-bc02b017 | dsdm.Changed | SSP0016_ShipmentRequest.cs:524 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSP16LocProjectCode, false, pDivisionId, pItemId, _ToSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f792e304 | dsdm.Changed | SSP0016_ShipmentRequest.cs:525 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), dtlocPrjCode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-079bad86 | dsdm.Changed | SSP0016_ShipmentRequest.cs:527 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSP16LocIncoterms, false, pDivisionId, pFromSite, _ToSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cdc0dfd2 | dsdm.Changed | SSP0016_ShipmentRequest.cs:528 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), dtlocIncotms) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-31101f4f | dsdm.Changed | SSP0016_ShipmentRequest.cs:530 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3c8d9fb5 | dsdm.Changed | SSP0016_ShipmentRequest.cs:531 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-9abb623a | dsdm.Changed | SSP0016_ShipmentRequest.cs:535 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)].Value | dtlocPrjCode.Rows[0][0].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-c4db1446 | dsdm.Changed | SSP0016_ShipmentRequest.cs:540 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS)].Value | dtlocIncotms.Rows[0][0].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-e5879624 | dsdm.Changed | SSP0016_ShipmentRequest.cs:544 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSP16LocTransMode, false, pDivisionId, pFromSite, _ToSite, _Incoterms) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0606fb4f | dsdm.Changed | SSP0016_ShipmentRequest.cs:545 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocTrans) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f478e4b5 | dsdm.Changed | SSP0016_ShipmentRequest.cs:549 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE)].Valu… | dtlocTrans.Rows[0][0].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-f0819e4f | dsdm.Changed | SSP0016_ShipmentRequest.cs:561 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-630e7e0c | dsdm.Changed | SSP0016_ShipmentRequest.cs:562 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6ff412f4 | dsdm.Changed | SSP0016_ShipmentRequest.cs:563 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ca9280c9 | dsdm.Changed | SSP0016_ShipmentRequest.cs:564 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-1df606d5 | dsdm.Changed | SSP0016_ShipmentRequest.cs:565 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-5628da71 | dsdm.Changed | SSP0016_ShipmentRequest.cs:566 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-49db554a | dsdm.Changed | SSP0016_ShipmentRequest.cs:573 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b2294b61 | dsdm.Changed | SSP0016_ShipmentRequest.cs:574 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-2050bcc0 | dsdm.Changed | SSP0016_ShipmentRequest.cs:580 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSP16LocTransMode, false, pDivisionId, pFromSite, _ToSite, _Incoterms) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-11b553af | dsdm.Changed | SSP0016_ShipmentRequest.cs:581 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocTrans) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-08d125cd | dsdm.Changed | SSP0016_ShipmentRequest.cs:585 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE)].Valu… | dtlocTrans.Rows[0][0].ToString() | 그리드 속성/값 설정 |  |  |  |

## SSP0016_ShipmentRequest.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4f68b81 | EditButton | SSP0016_ShipmentRequest.cs:703 |  | DATA_OP | dtPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-7909e053 | EditButton | SSP0016_ShipmentRequest.cs:709 | if (oldPlanDate != newPlanDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00170", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8295c1e0 | EditButton | SSP0016_ShipmentRequest.cs:711 | if (oldPlanDate != newPlanDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ecece6f | EditButton | SSP0016_ShipmentRequest.cs:718 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-073fd2ee | EditButton | SSP0016_ShipmentRequest.cs:719 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-de469d54 | EditButton | SSP0016_ShipmentRequest.cs:726 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (bDelete_Flag == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2166ecdc | EditButton | SSP0016_ShipmentRequest.cs:727 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (bDelete_Flag == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bb969e9d | EditButton | SSP0016_ShipmentRequest.cs:732 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (fps.ActiveSheetIndex == 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-83de7a33 | EditButton | SSP0016_ShipmentRequest.cs:733 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (fps.ActiveSheetIndex == 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91cdeaef | EditButton | SSP0016_ShipmentRequest.cs:740 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.IsLock(SpdSheet.shtDetail) == true) ▸ if (dtBalance == null… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Model") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5852030a | EditButton | SSP0016_ShipmentRequest.cs:741 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.IsLock(SpdSheet.shtDetail) == true) ▸ if (dtBalance == null… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf621c99 | EditButton | SSP0016_ShipmentRequest.cs:750 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.IsLock(SpdSheet.shtDetail) == true) ▸ if (time1 == "" \|\| … | MESSAGE | MessageHelper.GMessageBox | ("MSG00268", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-51ac04c9 | EditButton | SSP0016_ShipmentRequest.cs:751 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.IsLock(SpdSheet.shtDetail) == true) ▸ if (time1 == "" \|\| … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20e3e52d | EditButton | SSP0016_ShipmentRequest.cs:757 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.IsLock(SpdSheet.shtDetail) == true) ▸ if (Int64.Parse(nowTi… | MESSAGE | MessageHelper.GMessageBox | ("MSG00269", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c2441fa1 | EditButton | SSP0016_ShipmentRequest.cs:758 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.IsLock(SpdSheet.shtDetail) == true) ▸ if (Int64.Parse(nowTi… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d12440be | EditButton | SSP0016_ShipmentRequest.cs:763 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") | FLAG | siDetail | GetSheetInfo(spdDetail.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6fae0f19 | EditButton | SSP0016_ShipmentRequest.cs:764 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-05b34a92 | EditButton | SSP0016_ShipmentRequest.cs:766 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColumns.FROM_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9786521e | EditButton | SSP0016_ShipmentRequest.cs:767 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.REQUEST_USER), siDetail.GetColumnIndex(DefColumns.REQU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-311321bc | EditButton | SSP0016_ShipmentRequest.cs:768 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siDetail.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2cd68302 | EditButton | SSP0016_ShipmentRequest.cs:774 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ for (i <= siDetail.GetMaxRowIndex()) ▸ if (siDetail.GetValue(i, siDetail… | GRID_LOCK | siDetail.LockRange2 | (i, 0, i, siDetail.GetMaxColumnIndex(), true, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-4a8e593f | EditButton | SSP0016_ShipmentRequest.cs:797 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (intHolCnt > 0) ▸ for (i < intHolCnt) ▸ for (j < siDetail.ActiveSheet… | GRID_LOCK | siDetail.LockColumn | (j, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5dbb86d1 | EditButton | SSP0016_ShipmentRequest.cs:800 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (intHolCnt > 0) ▸ for (i < intHolCnt) ▸ for (j < siDetail.ActiveSheet… | DATA_OP | strWeek.Contains | ("W_") | 데이터 객체 조작/조회 |  |  |  |
| AC-49471254 | EditButton | SSP0016_ShipmentRequest.cs:802 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (intHolCnt > 0) ▸ for (i < intHolCnt) ▸ for (j < siDetail.ActiveSheet… | GRID_LOCK | siDetail.LockColumn | (j, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-95df45c9 | EditButton | SSP0016_ShipmentRequest.cs:806 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (intHolCnt > 0) ▸ for (i < intHolCnt) ▸ for (j < siDetail.ActiveSheet… | DATA_OP | strWeek.Contains | ("M_") | 데이터 객체 조작/조회 |  |  |  |
| AC-3fb16f93 | EditButton | SSP0016_ShipmentRequest.cs:808 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (intHolCnt > 0) ▸ for (i < intHolCnt) ▸ for (j < siDetail.ActiveSheet… | GRID_LOCK | siDetail.LockColumn | (j, true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0016_ShipmentRequest.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c91455a1 | FindButton | SSP0016_ShipmentRequest.cs:663 | if (this.chkDelete.Checked == true) | FLAG | bDelete_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f3e13e3d | FindButton | SSP0016_ShipmentRequest.cs:667 | else of (this.chkDelete.Checked == true) | FLAG | bDelete_Flag | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0016_ShipmentRequest.FindData_Detail

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / FindButton [try ▸ if (this.nSelRowOfMain >= 0 && isReload)] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (this.nSelRowOfMain >= 0 && isReload)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ed11692 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1357 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-069aaf75 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1363 | if (string.IsNullOrEmpty(reqInStartDate) \|\| reqInStartDate == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96a7a188 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1390 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9fc605f0 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1393 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL") ⇒ SSP.SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-ce90e2a1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1395 | lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8f835f7c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1396 | lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-c163f6b2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1397 | lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d4a8837b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1398 | lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-64b6a9a1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1399 | lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-e92025cc | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1400 | lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-f117fe1b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1401 | lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8928579e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1402 | lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6ed43320 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1403 | lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c625b2f4 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1404 | lambda | DATA_OP | req.Parameters["p_measure"] | p_measure | 행/컬럼 값 대입 |  |  |  |
| AC-78183187 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1405 | lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-57446c4c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1406 | lambda | DATA_OP | req.Parameters["delete_flag"] | delete_flag | 행/컬럼 값 대입 |  |  |  |
| AC-74804403 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1408 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9788a566 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1409 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7f93ccf6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1416 |  | GRID_BIND | siDetail.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0e7f61ad | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1419 | if (siDetail.GetMaxRowIndex() > 0) | GRID_LOCK | siDetail.LockColumn | (0, siDetail.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-336f2ee2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1423 | if (dsBinding.Tables.Count > 0) | FLAG | dtBalance | dsBinding.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-2ffcc738 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1426 |  | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-88d270d5 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1438 | for (i <= siDetail.GetMaxRowIndex()) ▸ if (siDetail.GetValue(i, siDetail.GetColumnIndex(DefColumns.MEASURE)).ToString() == "RTF_System[R+P]"… | GRID_INIT | siDetail.SetCellTypeText | (i, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d3f50e4c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1439 | for (i <= siDetail.GetMaxRowIndex()) ▸ if (siDetail.GetValue(i, siDetail.GetColumnIndex(DefColumns.MEASURE)).ToString() == "RTF_System[R+P]"… | GRID_SET | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE)].Horizont… | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-26b1d81b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1440 | for (i <= siDetail.GetMaxRowIndex()) ▸ if (siDetail.GetValue(i, siDetail.GetColumnIndex(DefColumns.MEASURE)).ToString() == "RTF_System[R+P]"… | GRID_SET | siDetail.ActiveSheet.SetText | (i, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), siDetail.GetValue(i, siDetail.GetC… | 그리드 값 설정 |  |  |  |
| AC-b794376b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1445 | for (i <= siDetail.GetMaxRowIndex()) ▸ if (siDetail.GetValue(i, siDetail.GetColumnIndex(DefColumns.MEASURE)).ToString() == "RTF_System[R+P]"… | CALL_EXT | siDetail.VisibleRow | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b269cf1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1449 | for (i <= siDetail.GetMaxRowIndex()) ▸ if (siDetail.GetValue(i, siDetail.GetColumnIndex(DefColumns.MEASURE)).ToString() == "RTF_System[R+P]"… | CALL_EXT | siDetail.VisibleRow | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a5f3be24 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 2 | SSP0016_ShipmentRequest.cs:1454 |  | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0016_ShipmentRequest.FindData_Detail_All

진입점: this.btnSearch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b9bf84b | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1476 | if (string.IsNullOrEmpty(reqInStartDate) \|\| reqInStartDate == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3344401b | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1502 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-214859b6 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1505 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL_ALL") ⇒ SSP.SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL_ALL | 엔드포인트 요청 생성 |  |  |  |
| AC-59fc1c0d | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1506 | lambda | UI_PROP | req.CommandTimeout | 0 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d8752490 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1507 | lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-553317cc | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1508 | lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ca95a688 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1509 | lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f27fd2e9 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1510 | lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-01428d7c | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1511 | lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ed203cf4 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1512 | lambda | DATA_OP | req.Parameters["p_user_id"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-a9e65b38 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1513 | lambda | DATA_OP | req.Parameters["p_measure"] | p_measure | 행/컬럼 값 대입 |  |  |  |
| AC-6ad27a59 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1514 | lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-4b31c6c9 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1515 | lambda | DATA_OP | req.Parameters["delete_flag"] | delete_flag | 행/컬럼 값 대입 |  |  |  |
| AC-12670513 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1517 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b945088c | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1518 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-930b55b4 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1525 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail_All) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0f67f138 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1526 |  | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtDetail_All) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6c9b0544 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1529 |  | GRID_BIND | siDetail.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c226d515 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1533 | if (siDetail.GetMaxRowIndex() > 0) | GRID_LOCK | siDetail.LockColumn | (0, siDetail.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f48b2d8b | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1537 | if (dsBinding.Tables.Count > 0) | FLAG | dtBalance | dsBinding.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-5028d6c6 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1540 |  | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7547ca39 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1556 | for (i <= siDetail.GetMaxRowIndex()) ▸ if (siDetail.GetValue(i, siDetail.GetColumnIndex(DefColumns.MEASURE)).ToString() == "RTF_System[R+P]"… | CALL_EXT | siDetail.VisibleRow | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc31fcd8 | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1560 | for (i <= siDetail.GetMaxRowIndex()) ▸ if (siDetail.GetValue(i, siDetail.GetColumnIndex(DefColumns.MEASURE)).ToString() == "RTF_System[R+P]"… | CALL_EXT | siDetail.VisibleRow | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-290f185a | this.btnSearch.Click | SSP0016_ShipmentRequest.cs:1565 |  | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0016_ShipmentRequest.FindData_Main

진입점: FindButton / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96528d77 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1170 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-60cd2caf | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1180 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-58092ab3 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1180 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b165bb26 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1183 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-66dc6c15 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1184 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-b7eaab9b | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1184 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-695fb365 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1197 | try | DATA_OP | dtPlanDate.Select | ("CODE = '" + p_plan_start_yyyymmdd + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-635a7ca8 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1219 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b5dda62d | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1220 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e5bbb86f | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1224 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL") ⇒ SSP.SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL | 엔드포인트 요청 생성 |  |  |  |
| AC-f2a97e48 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1226 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bfc33f98 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1228 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-56f96ba7 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1229 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-2ec5e8f9 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1230 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-4efbf0da | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1231 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9a0862c3 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1232 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-85543f7b | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1233 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-6337fceb | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1234 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3b3cce4f | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1235 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-39bab395 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1236 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-dc9ef6c2 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1237 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-5af9a744 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1238 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-454c077b | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1239 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-256f8e4b | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1240 | try ▸ lambda | DATA_OP | req.Parameters["delete_flag"] | delete_flag | 행/컬럼 값 대입 |  |  |  |
| AC-4222dab8 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1241 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-80d791aa | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1242 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5cf8a876 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1249 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-60b5be30 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1251 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-405a2c73 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1252 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ea96fbfc | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1266 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cecfb654 | FindButton 외 1 | SSP0016_ShipmentRequest.cs:1280 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0016_ShipmentRequest.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-861b041f | this.Load | SSP0016_ShipmentRequest.cs:204 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0016_ShipmentRequest.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f1ed8d9 | this.Load | SSP0016_ShipmentRequest.cs:1120 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-9f81e808 | this.Load | SSP0016_ShipmentRequest.cs:1121 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f7af1ae0 | this.Load | SSP0016_ShipmentRequest.cs:1123 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0016_ShipmentRequest.GetDayRange

진입점: this.Load / clbDivision.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63001a13 | this.Load 외 2 | SSP0016_ShipmentRequest.cs:2662 | if (null != dtPlanDate && dtPlanDate.Rows.Count > 0) | DATA_OP | dtPlanDate.Select | ("CODE = '" + pReqDate + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1e35e24f | this.Load 외 2 | SSP0016_ShipmentRequest.cs:2665 | if (null != dtPlanDate && dtPlanDate.Rows.Count > 0) ▸ if (drDate != null) | FLAG | reqInStartDate | drDate[DefColumns.REQ_IN_START_DATE].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2c0f4bbb | this.Load 외 2 | SSP0016_ShipmentRequest.cs:2666 | if (null != dtPlanDate && dtPlanDate.Rows.Count > 0) ▸ if (drDate != null) | FLAG | reqInEndDate | drDate[DefColumns.REQ_IN_END_DATE].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fa7f4163 | this.Load 외 2 | SSP0016_ShipmentRequest.cs:2675 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0016_ShipmentRequest.GetSpdHoliday

진입점: InsertButton [if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false)] / EditButton [if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-798017c4 | InsertButton [if (siDetail != null && siDetail.IsLock(siMain… 외 1 | SSP0016_ShipmentRequest.cs:2646 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0016_GET_SHEET_HOLIDAY_CALENDAR") ⇒ SSP.SSP0016_GET_SHEET_HOLIDAY_CALENDAR | 엔드포인트 요청 생성 |  |  |  |
| AC-13e347fa | InsertButton [if (siDetail != null && siDetail.IsLock(siMain… 외 1 | SSP0016_ShipmentRequest.cs:2647 |  | DATA_OP | request.Parameters["p_sivision_id"] | strDivision | 행/컬럼 값 대입 |  |  |  |
| AC-ca440f4d | InsertButton [if (siDetail != null && siDetail.IsLock(siMain… 외 1 | SSP0016_ShipmentRequest.cs:2648 |  | DATA_OP | request.Parameters["p_from_site"] | strFromsite | 행/컬럼 값 대입 |  |  |  |
| AC-bfdfdff4 | InsertButton [if (siDetail != null && siDetail.IsLock(siMain… 외 1 | SSP0016_ShipmentRequest.cs:2649 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | strStartDate.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-3bcc8643 | InsertButton [if (siDetail != null && siDetail.IsLock(siMain… 외 1 | SSP0016_ShipmentRequest.cs:2650 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | strEndDate.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-4d68d4f7 | InsertButton [if (siDetail != null && siDetail.IsLock(siMain… 외 1 | SSP0016_ShipmentRequest.cs:2651 |  | FLAG | dsDetailSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-3904f35e | InsertButton [if (siDetail != null && siDetail.IsLock(siMain… 외 1 | SSP0016_ShipmentRequest.cs:2651 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0016_ShipmentRequest.GetSpdTitle

진입점: this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnSearch.Click / FindButton [try] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c50b1e2 | this.Load 외 5 | SSP0016_ShipmentRequest.cs:2565 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-6a85b79b | this.Load 외 5 | SSP0016_ShipmentRequest.cs:2566 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-a1f93abe | this.Load 외 5 | SSP0016_ShipmentRequest.cs:2567 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-a0d8657b | this.Load 외 5 | SSP0016_ShipmentRequest.cs:2568 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-3c0d67ba | this.Load 외 5 | SSP0016_ShipmentRequest.cs:2568 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0016_ShipmentRequest.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47bdb9bc | this.Load | SSP0016_ShipmentRequest.cs:237 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-faf6703c | this.Load | SSP0016_ShipmentRequest.cs:240 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-87b80d5b | this.Load | SSP0016_ShipmentRequest.cs:241 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtDetail_All) | 데이터 객체 조작/조회 |  |  |  |
| AC-bca25b24 | this.Load | SSP0016_ShipmentRequest.cs:244 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-685aa6d2 | this.Load | SSP0016_ShipmentRequest.cs:247 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-ee5b45e0 | this.Load | SSP0016_ShipmentRequest.cs:249 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-2566566b | this.Load | SSP0016_ShipmentRequest.cs:251 |  | VALUE_SET | clbDivision.ControlValues | "40" | 컨트롤 값 설정 |  |  |  |
| AC-8bb06275 | this.Load | SSP0016_ShipmentRequest.cs:252 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-78455147 | this.Load | SSP0016_ShipmentRequest.cs:254 |  | STATE | drpAvailable.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-44edc2c6 | this.Load | SSP0016_ShipmentRequest.cs:258 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-36e14aee | this.Load | SSP0016_ShipmentRequest.cs:259 |  | FLAG | dtBucketType_Detail | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-9dd3de24 | this.Load | SSP0016_ShipmentRequest.cs:260 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b25ba0a6 | this.Load | SSP0016_ShipmentRequest.cs:261 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType_Detail, cboBucketType_Detail, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0291178f | this.Load | SSP0016_ShipmentRequest.cs:263 |  | VALUE_SET | this.txtRequestor.Text | UserInfoContext.Current.UserId | 컨트롤 값 설정 |  |  |  |

## SSP0016_ShipmentRequest.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnSearch.Click / FindButton [try] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1baf0968 | this.Load 외 5 | SSP0016_ShipmentRequest.cs:294 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-d3e14fb8 | this.Load 외 5 | SSP0016_ShipmentRequest.cs:296 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-8c5fcea9 | this.Load 외 5 | SSP0016_ShipmentRequest.cs:302 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8b6556fd | this.Load 외 5 | SSP0016_ShipmentRequest.cs:303 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6532b2a3 | this.Load 외 5 | SSP0016_ShipmentRequest.cs:307 | if (spdInfo.SheetName == SpdSheet.shtDetail) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtDetail) | 그리드 재구성/초기화 |  |  |  |
| AC-6fc1fcce | this.Load 외 5 | SSP0016_ShipmentRequest.cs:309 | if (spdInfo.SheetName == SpdSheet.shtDetail) | UI_PROP | this.layoutControlGroup3.Expanded | true | 속성 Expanded 설정 |  |  |  |
| AC-20df5cc4 | this.Load 외 5 | SSP0016_ShipmentRequest.cs:311 | if (spdInfo.SheetName == SpdSheet.shtDetail) | UI_PROP | lblItemId2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d55f5ed3 | this.Load 외 5 | SSP0016_ShipmentRequest.cs:312 | if (spdInfo.SheetName == SpdSheet.shtDetail) | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-27510292 | this.Load 외 5 | SSP0016_ShipmentRequest.cs:313 | if (spdInfo.SheetName == SpdSheet.shtDetail) | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-dac38384 | this.Load 외 5 | SSP0016_ShipmentRequest.cs:314 | if (spdInfo.SheetName == SpdSheet.shtDetail) | UI_PROP | lblRequestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-21962b6d | this.Load 외 5 | SSP0016_ShipmentRequest.cs:315 | if (spdInfo.SheetName == SpdSheet.shtDetail) | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-172a05ae | this.Load 외 5 | SSP0016_ShipmentRequest.cs:317 | if (spdInfo.SheetName == SpdSheet.shtDetail) | UI_PROP | lblBucket_Detail.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5a4f1a54 | this.Load 외 5 | SSP0016_ShipmentRequest.cs:321 | if (spdInfo.SheetName == SpdSheet.shtDetail) ▸ if (comboSet) | LIST_REBIND | SpreadInfo.SetComBoParam | ("dtlocToSite", dtlocToSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-092e0a28 | this.Load 외 5 | SSP0016_ShipmentRequest.cs:322 | if (spdInfo.SheetName == SpdSheet.shtDetail) ▸ if (comboSet) | LIST_REBIND | SpreadInfo.SetComBoParam | ("dtlocBodTotal", dtlocBodTotal) | 목록 컨트롤 재구성 |  |  |  |
| AC-f7f8b7de | this.Load 외 5 | SSP0016_ShipmentRequest.cs:326 | if (spdInfo.SheetName == SpdSheet.shtDetail) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-5a67c233 | this.Load 외 5 | SSP0016_ShipmentRequest.cs:329 | if (spdInfo.SheetName == SpdSheet.shtDetail) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e5661e7c | this.Load 외 5 | SSP0016_ShipmentRequest.cs:333 | if (spdInfo.SheetName == SpdSheet.shtDetail) | GRID_INIT | spdInfo.AddTextColumn | ("Last Updated By", DefColumns.LAST_UPDATED_BY, FPMerge.None, 130, true, FPHAlign.Right, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a658431d | this.Load 외 5 | SSP0016_ShipmentRequest.cs:334 | if (spdInfo.SheetName == SpdSheet.shtDetail) | GRID_INIT | spdInfo.AddDateTimeColumn | ("Update Date", DefColumns.LAST_UPDATE_DATE, FPMerge.None, 130, true, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-716ed383 | this.Load 외 5 | SSP0016_ShipmentRequest.cs:342 | if (spdInfo.SheetName == SpdSheet.shtDetail_All) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtDetail_All) | 그리드 재구성/초기화 |  |  |  |
| AC-d47f3581 | this.Load 외 5 | SSP0016_ShipmentRequest.cs:346 | if (spdInfo.SheetName == SpdSheet.shtDetail_All) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-b217384a | this.Load 외 5 | SSP0016_ShipmentRequest.cs:349 | if (spdInfo.SheetName == SpdSheet.shtDetail_All) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-176e8c8e | this.Load 외 5 | SSP0016_ShipmentRequest.cs:353 | if (spdInfo.SheetName == SpdSheet.shtDetail_All) | GRID_INIT | spdInfo.AddTextColumn | ("Last Updated By", DefColumns.LAST_UPDATED_BY, FPMerge.None, 130, true, FPHAlign.Right, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e3d82c9c | this.Load 외 5 | SSP0016_ShipmentRequest.cs:354 | if (spdInfo.SheetName == SpdSheet.shtDetail_All) | GRID_INIT | spdInfo.AddDateTimeColumn | ("Update Date", DefColumns.LAST_UPDATE_DATE, FPMerge.None, 130, true, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0016_ShipmentRequest.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnSearch.Click [if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸ try …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-defc5a6c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0016_ShipmentRequest.cs:417 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-92d27c5e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0016_ShipmentRequest.cs:421 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5cd2625f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0016_ShipmentRequest.cs:425 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-2831ebd8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0016_ShipmentRequest.cs:432 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c3cef966 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0016_ShipmentRequest.cs:433 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-47a8116b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0016_ShipmentRequest.cs:438 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-054b67e9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0016_ShipmentRequest.cs:439 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7a58ed5a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0016_ShipmentRequest.cs:447 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8160902e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0016_ShipmentRequest.cs:448 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5939a309 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0016_ShipmentRequest.cs:458 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98039c95 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0016_ShipmentRequest.cs:459 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b568f00 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0016_ShipmentRequest.cs:460 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9345b0c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0016_ShipmentRequest.cs:461 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0016_ShipmentRequest.InitSpreadFooterSum

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.btnSearch.Click [if (spdInfo.SheetName == SpdSheet.shtDetail)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModify…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a86cb64a | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:366 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1e61a289 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:367 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-c98f42fb | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:374 | for (iCol <= siDetail.GetMaxColumnIndex()-2) ▸ if (siDetail.GetColumnValue(iCol).IndexOf("D_") == 0 \|\| siDetail.GetColumnValue(iCol).Index… | CALL_EXT | siDetail.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-260faccd | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:375 | for (iCol <= siDetail.GetMaxColumnIndex()-2) ▸ if (siDetail.GetColumnValue(iCol).IndexOf("D_") == 0 \|\| siDetail.GetColumnValue(iCol).Index… | CALL_EXT | siDetail.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-663d92b5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:376 | for (iCol <= siDetail.GetMaxColumnIndex()-2) ▸ if (siDetail.GetColumnValue(iCol).IndexOf("D_") == 0 \|\| siDetail.GetColumnValue(iCol).Index… | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-21cc90dc | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:377 | for (iCol <= siDetail.GetMaxColumnIndex()-2) ▸ if (siDetail.GetColumnValue(iCol).IndexOf("D_") == 0 \|\| siDetail.GetColumnValue(iCol).Index… | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## SSP0016_ShipmentRequest.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52435ef4 | InsertButton | SSP0016_ShipmentRequest.cs:2052 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) | DATA_OP | siDetail.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-889330e8 | InsertButton | SSP0016_ShipmentRequest.cs:2056 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) | GRID_COMBO | siDetail.SetCellTypeCombo | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.TO_SITE), dtlocToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-11f55db1 | InsertButton | SSP0016_ShipmentRequest.cs:2058 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, pDivisionId) | 데이터 객체 조작/조회 |  |  |  |
| AC-58b2e88c | InsertButton | SSP0016_ShipmentRequest.cs:2059 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.ITEM_ID, pItemId) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c8a2a8c | InsertButton | SSP0016_ShipmentRequest.cs:2060 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.NICK_NAME, pNickName) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4d9c1bd | InsertButton | SSP0016_ShipmentRequest.cs:2061 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.FROM_SITE, pFromSite) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a46b1bb | InsertButton | SSP0016_ShipmentRequest.cs:2062 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.REQUEST_USER, base.UserInfo.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9fa68f6 | InsertButton | SSP0016_ShipmentRequest.cs:2064 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) | GRID_SET | siDetail.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-46c2a61c | InsertButton | SSP0016_ShipmentRequest.cs:2068 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0fe91d0b | InsertButton | SSP0016_ShipmentRequest.cs:2069 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.REQUEST_USER), siDetail.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-08ce53b9 | InsertButton | SSP0016_ShipmentRequest.cs:2070 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siDetail.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-91d13379 | InsertButton | SSP0016_ShipmentRequest.cs:2071 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siDetail.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1063db1f | InsertButton | SSP0016_ShipmentRequest.cs:2092 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) ▸ if (intHolCnt > 0) ▸ for (i < intHolCnt) ▸ for (j < siDetail.ActiveShe… | GRID_LOCK | siDetail.LockRange | (insCell, j, j, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9edd12f1 | InsertButton | SSP0016_ShipmentRequest.cs:2095 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) ▸ if (intHolCnt > 0) ▸ for (i < intHolCnt) ▸ for (j < siDetail.ActiveShe… | DATA_OP | strWeek.Contains | ("W_") | 데이터 객체 조작/조회 |  |  |  |
| AC-112fac06 | InsertButton | SSP0016_ShipmentRequest.cs:2097 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) ▸ if (intHolCnt > 0) ▸ for (i < intHolCnt) ▸ for (j < siDetail.ActiveShe… | GRID_LOCK | siDetail.LockRange | (insCell, j, j, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d24eb31e | InsertButton | SSP0016_ShipmentRequest.cs:2101 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) ▸ if (intHolCnt > 0) ▸ for (i < intHolCnt) ▸ for (j < siDetail.ActiveShe… | DATA_OP | strWeek.Contains | ("M_") | 데이터 객체 조작/조회 |  |  |  |
| AC-dc6e9322 | InsertButton | SSP0016_ShipmentRequest.cs:2103 | if (siDetail != null && siDetail.IsLock(siMain.SheetName) == false) ▸ if (intHolCnt > 0) ▸ for (i < intHolCnt) ▸ for (j < siDetail.ActiveShe… | GRID_LOCK | siDetail.LockRange | (insCell, j, j, true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0016_ShipmentRequest.SaveData_Detail

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfd51cc7 | SaveButton | SSP0016_ShipmentRequest.cs:1617 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (siDetail.ActiveSheet.Rows.Count <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-294d8f07 | SaveButton | SSP0016_ShipmentRequest.cs:1621 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-a26a4066 | SaveButton | SSP0016_ShipmentRequest.cs:1624 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (!DataUtil.checkRequiredOfSpread(s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df7e2472 | SaveButton | SSP0016_ShipmentRequest.cs:1633 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (!chkQtyNewLine()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8cf9d1bb | SaveButton | SSP0016_ShipmentRequest.cs:1663 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-09557e83 | SaveButton | SSP0016_ShipmentRequest.cs:1812 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-cc98cca1 | SaveButton | SSP0016_ShipmentRequest.cs:1815 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3d89a681 | SaveButton | SSP0016_ShipmentRequest.cs:1820 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | ENDPOINT | new FoxDataRequest | ("SSP.SSP0016_SAVE_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL") ⇒ SSP.SSP0016_SAVE_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-69a8999c | SaveButton | SSP0016_ShipmentRequest.cs:1822 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-448bf432 | SaveButton | SSP0016_ShipmentRequest.cs:1824 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-991cc477 | SaveButton | SSP0016_ShipmentRequest.cs:1825 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-68c67530 | SaveButton | SSP0016_ShipmentRequest.cs:1826 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-facfe794 | SaveButton | SSP0016_ShipmentRequest.cs:1827 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-0301c809 | SaveButton | SSP0016_ShipmentRequest.cs:1828 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-8891d7ed | SaveButton | SSP0016_ShipmentRequest.cs:1829 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5457bfbc | SaveButton | SSP0016_ShipmentRequest.cs:1830 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-55f5fab2 | SaveButton | SSP0016_ShipmentRequest.cs:1831 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-9a8e61e8 | SaveButton | SSP0016_ShipmentRequest.cs:1832 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_measure"] | p_measure | 행/컬럼 값 대입 |  |  |  |
| AC-c3ee95a0 | SaveButton | SSP0016_ShipmentRequest.cs:1833 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b393ebc1 | SaveButton | SSP0016_ShipmentRequest.cs:1834 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-8ba5a4fb | SaveButton | SSP0016_ShipmentRequest.cs:1835 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-8a692c15 | SaveButton | SSP0016_ShipmentRequest.cs:1836 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_route_id"] | p_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-97582b92 | SaveButton | SSP0016_ShipmentRequest.cs:1837 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-3c7ca996 | SaveButton | SSP0016_ShipmentRequest.cs:1838 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-3289676c | SaveButton | SSP0016_ShipmentRequest.cs:1839 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-f909c781 | SaveButton | SSP0016_ShipmentRequest.cs:1840 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-49358956 | SaveButton | SSP0016_ShipmentRequest.cs:1841 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-276158aa | SaveButton | SSP0016_ShipmentRequest.cs:1842 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-b42a0388 | SaveButton | SSP0016_ShipmentRequest.cs:1843 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_req_mst_id"] | p_req_mst_id | 행/컬럼 값 대입 |  |  |  |
| AC-34c299c9 | SaveButton | SSP0016_ShipmentRequest.cs:1844 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_lt"] | p_lt | 행/컬럼 값 대입 |  |  |  |
| AC-53d1d897 | SaveButton | SSP0016_ShipmentRequest.cs:1845 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_grp_id"] | p_grp_id | 행/컬럼 값 대입 |  |  |  |
| AC-6eab6a3d | SaveButton | SSP0016_ShipmentRequest.cs:1846 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_text"] | p_text | 행/컬럼 값 대입 |  |  |  |
| AC-9fc5c900 | SaveButton | SSP0016_ShipmentRequest.cs:1847 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_remark_grp_id"] | p_remark_grp_id | 행/컬럼 값 대입 |  |  |  |
| AC-968a9fbd | SaveButton | SSP0016_ShipmentRequest.cs:1848 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_remark_text"] | p_remark_text | 행/컬럼 값 대입 |  |  |  |
| AC-d78e29a4 | SaveButton | SSP0016_ShipmentRequest.cs:1849 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_now_date"] | p_now_date | 행/컬럼 값 대입 |  |  |  |
| AC-5757a128 | SaveButton | SSP0016_ShipmentRequest.cs:1850 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-15480e2e | SaveButton | SSP0016_ShipmentRequest.cs:1851 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-a171fb23 | SaveButton | SSP0016_ShipmentRequest.cs:1854 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a38ad68a | SaveButton | SSP0016_ShipmentRequest.cs:1859 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b5521bde | SaveButton | SSP0016_ShipmentRequest.cs:1861 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00020", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-94fdd52f | SaveButton | SSP0016_ShipmentRequest.cs:1867 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-90b78d05 | SaveButton | SSP0016_ShipmentRequest.cs:1871 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00274", new object[] { strBalanceDate }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-104b5b00 | SaveButton | SSP0016_ShipmentRequest.cs:1875 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-38fb2439 | SaveButton | SSP0016_ShipmentRequest.cs:1883 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a613a945 | SaveButton | SSP0016_ShipmentRequest.cs:1890 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-590e398d | SaveButton | SSP0016_ShipmentRequest.cs:1892 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7f8729ec | SaveButton | SSP0016_ShipmentRequest.cs:1897 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ else of (iCount > 0 \|\| remarkModify… | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e2fa7ee6 | SaveButton | SSP0016_ShipmentRequest.cs:1898 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ else of (iCount > 0 \|\| remarkModify… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0016_ShipmentRequest.Set_SumValues

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModifyYn) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d648ce7 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0016_ShipmentRequest.cs:1298 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ac16cf8 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0016_ShipmentRequest.cs:1302 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-97231902 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0016_ShipmentRequest.cs:1326 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_STOCK") \|\| measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-9a4a2b31 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0016_ShipmentRequest.cs:1334 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_STOCK") \|\| measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-8b028242 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0016_ShipmentRequest.cs:1344 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_STOCK") \|\| measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-a7950f5a | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0016_ShipmentRequest.cs:1345 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_STOCK") \|\| measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |

## SSP0016_ShipmentRequest.SetCalendar

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a8ee1e1 | (진입점 미연결) | SSP0016_ShipmentRequest.cs:2229 | if (reqInStartDate != "" && reqInEndDate != "") | FLAG | dtCalendar | Data.Common(Data.Type.CalendarDay, false, reqInStartDate, reqInEndDate) ⇒ biz:CommonData.CommonDataList [code=CalendarDay] | 화면 필드/플래그 변경 |  |  |  |
| AC-40a78605 | (진입점 미연결) | SSP0016_ShipmentRequest.cs:2229 | if (reqInStartDate != "" && reqInEndDate != "") | COMBO_DATA | Data.Common | (Data.Type.CalendarDay, false, reqInStartDate, reqInEndDate) ⇒ biz:CommonData.CommonDataList [code=CalendarDay] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b7485c5 | (진입점 미연결) | SSP0016_ShipmentRequest.cs:2233 | if (reqInStartDate != "" && reqInEndDate != "") ▸ foreach (var a in dtCalendar.AsEnumerable()) | DATA_OP | a.Field | (DefColumns.CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-75b0b235 | (진입점 미연결) | SSP0016_ShipmentRequest.cs:2234 | if (reqInStartDate != "" && reqInEndDate != "") ▸ foreach (var a in dtCalendar.AsEnumerable()) | DATA_OP | a.Field | (DefColumns.NAME) | 데이터 객체 조작/조회 |  |  |  |
| AC-78ea882f | (진입점 미연결) | SSP0016_ShipmentRequest.cs:2236 | if (reqInStartDate != "" && reqInEndDate != "") ▸ foreach (var a in dtCalendar.AsEnumerable()) | GRID_INIT | spreadinfo.AddNumColumn | (sYYYYMM_NAME, sYYYYMM, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ac88fda | (진입점 미연결) | SSP0016_ShipmentRequest.cs:2237 | if (reqInStartDate != "" && reqInEndDate != "") ▸ foreach (var a in dtCalendar.AsEnumerable()) | GRID_INIT | spreadinfo.SetReNumerCellType | (spreadinfo, spreadinfo.GetColumnIndex(sYYYYMM), 0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0016_ShipmentRequest.SetChangedControl

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04cc5b98 | this.Load 외 1 | SSP0016_ShipmentRequest.cs:1145 |  | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.ShipmentRequestPlantSite, false, pDivisionID, "P","E") | 화면 필드/플래그 변경 |  |  |  |
| AC-8666fa74 | this.Load 외 1 | SSP0016_ShipmentRequest.cs:1145 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentRequestPlantSite, false, pDivisionID, "P","E") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-64271e3a | this.Load 외 1 | SSP0016_ShipmentRequest.cs:1146 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-710ec2be | this.Load 외 1 | SSP0016_ShipmentRequest.cs:1149 |  | FLAG | dtPlanDate | Data_SCP.Common(Data_SCP.Type.PlanDateShipReq40, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-0db7d857 | this.Load 외 1 | SSP0016_ShipmentRequest.cs:1149 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlanDateShipReq40, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-275db0d3 | this.Load 외 1 | SSP0016_ShipmentRequest.cs:1150 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7cf864a0 | this.Load 외 1 | SSP0016_ShipmentRequest.cs:1155 | if (null != dtPlanDate && dtPlanDate.Rows.Count > 0) | DATA_OP | dtPlanDate.Select | ("CODE = '" + pReqDate + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-4351dfea | this.Load 외 1 | SSP0016_ShipmentRequest.cs:1158 | if (null != dtPlanDate && dtPlanDate.Rows.Count > 0) ▸ if (drDate != null) | VALUE_SET | drpAvailable.InitValue | drDate[DefColumns.REQ_START_DATE].ToString() + ":" + drDate[DefColumns.REQ_END_DATE].ToStr… | 컨트롤 값 설정 |  |  |  |
| AC-987acca6 | this.Load 외 1 | SSP0016_ShipmentRequest.cs:1159 | if (null != dtPlanDate && dtPlanDate.Rows.Count > 0) ▸ if (drDate != null) | FLAG | reqInStartDate | drDate[DefColumns.REQ_IN_START_DATE].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d6cc05e3 | this.Load 외 1 | SSP0016_ShipmentRequest.cs:1160 | if (null != dtPlanDate && dtPlanDate.Rows.Count > 0) ▸ if (drDate != null) | FLAG | reqInEndDate | drDate[DefColumns.REQ_IN_END_DATE].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a44bf01a | this.Load 외 1 | SSP0016_ShipmentRequest.cs:1165 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SSP0016_ShipmentRequest.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged / this.chkSum.CheckedChanged / this.btnSearch.Click [if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (siMain.GetMaxRowIndex() > 0)] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtD…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3186aaa2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0016_ShipmentRequest.cs:991 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c6f3ec08 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0016_ShipmentRequest.cs:996 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-3d587108 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0016_ShipmentRequest.cs:1003 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-093cf83e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0016_ShipmentRequest.cs:1007 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-8142fa07 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0016_ShipmentRequest.cs:1012 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-0b5993d7 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0016_ShipmentRequest.cs:1019 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-19f82aa8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0016_ShipmentRequest.cs:1023 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0016_ShipmentRequest.SetSpreadColumnDetail

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.cboBucketType_Detail.SelectedIndexChanged / this.spdDetail.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail")] / this.btnSearch.Click [if (spdInfo.SheetName == SpdSheet.shtDetail)] / FindButton [try ▸ if (spdInfo.S…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54986cc4 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 7 | SSP0016_ShipmentRequest.cs:1042 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail_All) ▸ for (iCol <= siDetail.GetMaxColumnIndex()) ▸ if (cboBucketType_Detail.Contro… | GRID_SET | siDetail.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-16e10c41 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 7 | SSP0016_ShipmentRequest.cs:1046 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail_All) ▸ for (iCol <= siDetail.GetMaxColumnIndex()) ▸ if (cboBucketType_Detail.Contro… | GRID_SET | siDetail.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-555f2c36 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 7 | SSP0016_ShipmentRequest.cs:1054 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail_All) ▸ for (iCol <= siDetail.GetMaxColumnIndex()) ▸ else of (cboBucketType_Detail.C… | GRID_SET | siDetail.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-04c2c967 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 7 | SSP0016_ShipmentRequest.cs:1058 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail_All) ▸ for (iCol <= siDetail.GetMaxColumnIndex()) ▸ else of (cboBucketType_Detail.C… | GRID_SET | siDetail.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-fcb4ef9b | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 7 | SSP0016_ShipmentRequest.cs:1065 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail_All) ▸ for (iCol <= siDetail.GetMaxColumnIndex()) ▸ else of (cboBucketType_Detail.C… | GRID_SET | siDetail.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8044de21 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 7 | SSP0016_ShipmentRequest.cs:1069 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail_All) ▸ for (iCol <= siDetail.GetMaxColumnIndex()) ▸ else of (cboBucketType_Detail.C… | GRID_SET | siDetail.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1932a924 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 7 | SSP0016_ShipmentRequest.cs:1082 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail_All) ▸ for (iCol <= siDetail.GetMaxColumnIndex()) ▸ if (cboBucketType_Detail.C… | GRID_SET | siDetail.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f2a64b77 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 7 | SSP0016_ShipmentRequest.cs:1086 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail_All) ▸ for (iCol <= siDetail.GetMaxColumnIndex()) ▸ if (cboBucketType_Detail.C… | GRID_SET | siDetail.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-52f424bc | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 7 | SSP0016_ShipmentRequest.cs:1094 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail_All) ▸ for (iCol <= siDetail.GetMaxColumnIndex()) ▸ else of (cboBucketType_Det… | GRID_SET | siDetail.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-921a10f5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 7 | SSP0016_ShipmentRequest.cs:1098 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail_All) ▸ for (iCol <= siDetail.GetMaxColumnIndex()) ▸ else of (cboBucketType_Det… | GRID_SET | siDetail.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3ca96851 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 7 | SSP0016_ShipmentRequest.cs:1105 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail_All) ▸ for (iCol <= siDetail.GetMaxColumnIndex()) ▸ else of (cboBucketType_Det… | GRID_SET | siDetail.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-17d67879 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 7 | SSP0016_ShipmentRequest.cs:1109 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail_All) ▸ for (iCol <= siDetail.GetMaxColumnIndex()) ▸ else of (cboBucketType_Det… | GRID_SET | siDetail.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SSP0016_ShipmentRequest.SetWeekEnd

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.btnSearch.Click [if (spdInfo.SheetName == SpdSheet.shtDetail)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0 \|\| remarkModify…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a76edbf0 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:2576 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-65969f93 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:2577 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | strStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-7151e421 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:2578 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | strEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-0c9f2786 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:2579 |  | FLAG | dsSpdTitle_WeekEnd | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-33380d93 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:2579 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5134f094 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:2591 | foreach (DataRow dr in dsSpdTitle_WeekEnd.Tables[0].Rows) | DATA_OP | strWeeKEnd.Contains | ("M_") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a9dfbac | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:2596 | foreach (DataRow dr in dsSpdTitle_WeekEnd.Tables[0].Rows) ▸ else of (strWeeKEnd.Contains("M_") == true) | DATA_OP | strWeeKEnd.Contains | ("W_") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ada2ff0 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:2611 | foreach (DataRow dr in dsSpdTitle_WeekEnd.Tables[0].Rows) ▸ else of (strWeeKEnd.Contains("M_") == true) ▸ else of (strWeeKEnd.Contains("W_")… | DATA_OP | strWeeKEnd.Contains | ("D_") | 데이터 객체 조작/조회 |  |  |  |
| AC-d273bab7 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:2617 | foreach (DataRow dr in dsSpdTitle_WeekEnd.Tables[0].Rows) | GRID_INIT | siDetail.AddNumColumn | (colName, strWeeKEnd, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6dbfef2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:2620 | foreach (DataRow dr in dsSpdTitle_WeekEnd.Tables[0].Rows) | DATA_OP | strWeeKEnd.Contains | ("D_") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6cab062 | this.Load [if (spdInfo.SheetName == SpdSheet.shtDetail)] 외 5 | SSP0016_ShipmentRequest.cs:2631 | foreach (DataRow dr in dsSpdTitle_WeekEnd.Tables[0].Rows) ▸ if (strWeeKEnd.Contains("D_") == true) ▸ for (i < siDetail.ActiveSheet.ColumnCou… | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[0, i].ForeColor | strDayOfWeek == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |

## SSP0016_ShipmentRequest.SpdDetail_ActiveSheetChanged

진입점: this.spdDetail.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40ecfdf0 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:598 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") | UI_PROP | this.layoutControlGroup3.Expanded | true | 속성 Expanded 설정 |  |  |  |
| AC-8c89f665 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:599 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") | STATE | this.usrLayoutControl3.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-ec4c3103 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:601 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") | UI_PROP | lblItemId2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1977ff78 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:602 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8919d9d1 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:603 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-11de8009 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:604 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") | UI_PROP | lblRequestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-207f5ee2 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:605 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-000837f0 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:607 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") | UI_PROP | lblBucket_Detail.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3da783f1 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:609 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fc210884 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:610 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f5fe24cf | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:617 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sen… | UI_PROP | this.layoutControlGroup3.Expanded | true | 속성 Expanded 설정 |  |  |  |
| AC-b33eb346 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:618 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sen… | STATE | this.usrLayoutControl3.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-9d4ca7c0 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:620 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sen… | UI_PROP | lblItemId2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-224a5ad5 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:621 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sen… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-3023b449 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:622 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sen… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-894350b5 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:623 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sen… | UI_PROP | lblRequestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-10b99097 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:624 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sen… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-2e5b556f | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:626 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sen… | UI_PROP | lblBucket_Detail.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1256f2d6 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:628 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sen… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail_All) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c525f9f4 | this.spdDetail.ActiveSheetChanged | SSP0016_ShipmentRequest.cs:629 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Request Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sen… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtDetail_All) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0016_ShipmentRequest.SpdDetail_CellClick

진입점: this.spdDetail.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90008e07 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2311 | if (siDetail.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e7b11fa | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2313 | if (siDetail.IsLock(SpdSheet.shtDetail) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8044fe8e | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2323 | if (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (_ToSite == "") | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-248f7f61 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2324 | if (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (_ToSite == "") | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-23c0b97d | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2325 | if (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (_ToSite == "") | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-48cc75a4 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2326 | if (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (_ToSite == "") | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-8d0868ce | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2327 | if (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (_ToSite == "") | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-1e84bc26 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2328 | if (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (_ToSite == "") | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-426feb00 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2330 | if (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (_ToSite == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "To Site" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cd54d63f | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2334 | if (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (_ToSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSP16LocProjectCode, false, pDivisionId, pItemId, _ToSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c50388ac | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2335 | if (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (_ToSite == "") | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), dtlocPrjCode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6ec81072 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2345 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-26d343db | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2346 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-08a7b665 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2347 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-dc064dfe | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2348 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-da65af1c | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2349 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-fca0b73d | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2350 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-21950ebf | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2352 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "To Site" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ff83de51 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2356 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ el… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSP16LocIncoterms, false, pDivisionId, pFromSite, _ToSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23d61a7a | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2357 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ el… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), dtlocIncotms) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-dd32f04c | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2367 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS))… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0b5e549c | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2368 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS))… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ebc795b1 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2369 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS))… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1c99f812 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2370 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS))… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-667f7134 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2371 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS))… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-327dc884 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2372 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS))… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-d7ff3ca5 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2374 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS))… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "To Site" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b352e90f | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2379 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS))… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e830d04d | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2380 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS))… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ebd1e6a6 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2381 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS))… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-3ddd41ca | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2382 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS))… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-d3ed1ce4 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2384 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS))… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Incoterms" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bc6a01e3 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2388 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS))… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSP16LocTransMode, false, pDivisionId, pFromSite, _ToSite, _Incoterms) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1d446d12 | this.spdDetail.CellClick | SSP0016_ShipmentRequest.cs:2389 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS))… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocTrans) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SSP0016_ShipmentRequest.SpdDetail_ClipboardPasted

진입점: this.spdDetail.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-280baba7 | this.spdDetail.ClipboardPasted | SSP0016_ShipmentRequest.cs:2504 | if (spdDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnIndex(DefColumns.REMARKS3)) | ENDPOINT | System.Windows.Forms.Clipboard.GetDataObject().GetDataPresent | (System.Windows.Forms.DataFormats.Text) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-80abe71d | this.spdDetail.ClipboardPasted | SSP0016_ShipmentRequest.cs:2504 | if (spdDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnIndex(DefColumns.REMARKS3)) | ENDPOINT | System.Windows.Forms.Clipboard.GetDataObject | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d3c9906d | this.spdDetail.ClipboardPasted | SSP0016_ShipmentRequest.cs:2511 | if (spdDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnIndex(DefColumns.REMARKS3)) ▸ if (System.Windows.Forms.Clipboard.GetDataObj… | ENDPOINT | System.Windows.Forms.Clipboard.GetDataObject().GetData | (System.Windows.Forms.DataFormats.Text) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-85a5f649 | this.spdDetail.ClipboardPasted | SSP0016_ShipmentRequest.cs:2511 | if (spdDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnIndex(DefColumns.REMARKS3)) ▸ if (System.Windows.Forms.Clipboard.GetDataObj… | ENDPOINT | System.Windows.Forms.Clipboard.GetDataObject | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8091563c | this.spdDetail.ClipboardPasted | SSP0016_ShipmentRequest.cs:2513 | if (spdDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnIndex(DefColumns.REMARKS3)) ▸ if (System.Windows.Forms.Clipboard.GetDataObj… | CALL_EXT | Convert.ToChar | (13) | ⚠ 의미 확인 필요 |  |  |  |
| AC-65413262 | this.spdDetail.ClipboardPasted | SSP0016_ShipmentRequest.cs:2516 | if (spdDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnIndex(DefColumns.REMARKS3)) ▸ if (System.Windows.Forms.Clipboard.GetDataObj… | CALL_EXT | siDetail.RowHeaderForeColor | (spdDetail.ActiveSheet.ActiveRowIndex, 0, spdDetail.ActiveSheet.ActiveRowIndex + rowcount,… | ⚠ 의미 확인 필요 |  |  |  |

## SSP0016_ShipmentRequest.SpdDetail_ComboSelChange

진입점: this.spdDetail.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5548886f | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2406 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (_ToSite == "") | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f2bd58a1 | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2407 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (_ToSite == "") | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8d0fcd5f | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2408 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (_ToSite == "") | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0fd29a84 | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2409 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (_ToSite == "") | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-809b039f | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2410 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (_ToSite == "") | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-e9e83d6d | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2411 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (_ToSite == "") | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-a367cb82 | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2415 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ else of (_ToSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSP16LocProjectCode, false, pDivisionId, pItemId, _ToSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-03f0da5e | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2416 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ else of (_ToSite == "") | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), dtlocPrjCode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-fbdf416a | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2418 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ else of (_ToSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSP16LocIncoterms, false, pDivisionId, pFromSite, _ToSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2900c9da | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2419 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ else of (_ToSite == "") | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), dtlocIncotms) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ab068ebd | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2421 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ else of (_ToSite == "") | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a4f5eba4 | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2422 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ else of (_ToSite == "") | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-c2ece1ec | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2426 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ else of (_ToSite == "") ▸ if (dtlocPrjCode.Rows.Count == 1) | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE)].Value | dtlocPrjCode.Rows[0][0].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-b0b0918c | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2431 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ else of (_ToSite == "") ▸ if (dtlocIncotms.Rows.Count == 1) | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS)].Value | dtlocIncotms.Rows[0][0].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-bff60833 | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2435 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ else of (_ToSite == "") ▸ if (dtlocIncotms.Rows.Count == 1) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSP16LocTransMode, false, pDivisionId, pFromSite, _ToSite, _Incoterms) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b95b90a2 | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2436 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ else of (_ToSite == "") ▸ if (dtlocIncotms.Rows.Count == 1) | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocTrans) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5529d2af | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2440 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ else of (_ToSite == "") ▸ if (dtlocIncotms.Rows.Count == 1) ▸ if (dtlocTrans.… | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE)].Valu… | dtlocTrans.Rows[0][0].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-8032bbd5 | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2452 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (_To… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f8fe9907 | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2453 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (_To… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5ab87ec1 | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2454 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (_To… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-250cce0e | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2455 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (_To… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-4f812b6b | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2456 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (_To… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-e7e470a8 | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2457 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (_To… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-f4f156be | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2464 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ else of… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f4ead3e0 | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2465 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ else of… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-1167167b | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2471 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ else of… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSP16LocTransMode, false, pDivisionId, pFromSite, _ToSite, _Incoterms) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3bae94e4 | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2472 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ else of… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE), dtlocTrans) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-73c08717 | this.spdDetail.ComboSelChange | SSP0016_ShipmentRequest.cs:2476 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ else of… | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.BOD_TOTAL_CODE)].Valu… | dtlocTrans.Rows[0][0].ToString() | 그리드 속성/값 설정 |  |  |  |

## SSP0016_ShipmentRequest.SpdDetail_EditChange

진입점: this.spdDetail.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ccb9315 | this.spdDetail.EditChange | SSP0016_ShipmentRequest.cs:2488 | if (e.Column == siDetail.GetColumnIndex(DefColumns.REMARKS3)) | CALL_EXT | siDetail.RowHeaderForeColor | (e.Row, 0, e.Row, 0, Color.Red) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5aed4082 | this.spdDetail.EditChange | SSP0016_ShipmentRequest.cs:2495 | if (e.Column > siDetail.GetColumnIndex(DefColumns.REMARKS3)) ▸ if (string.IsNullOrEmpty(siDetail.GetValue(e.Row, e.Column).ToString())) | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, e.Column].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## SSP0016_ShipmentRequest.SpdDetail_TopChange

진입점: this.spdDetail.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d22444e | this.spdDetail.TopChange | SSP0016_ShipmentRequest.cs:650 |  | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0016_ShipmentRequest.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2acc2e30 | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2275 | if (e.ColumnHeader) | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee219a44 | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2280 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-b5de56d7 | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2281 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-3ac19eae | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2283 | if (!e.ColumnHeader && e.Row >= 0) ▸ if (e.Column != siMain.GetColumnIndex(DefColumns.ITEM_ID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87d81ffe | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2287 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | pDivisionId | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8f769572 | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2288 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | pFromSite | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c3cdbeee | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2289 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | pItemId | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0ed59ed0 | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2290 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | pPlanStartYYYYMMDD | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_START_YYYYMMDD)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-88af025b | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2291 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | pPlanType | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-054ec49d | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2292 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | pSeq | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0845452b | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2293 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | pNickName | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-51e4b18a | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2294 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | pBizType | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BIZ_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c931b247 | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2295 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | pReqMstId | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.REQ_MST_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f9af86b2 | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2297 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | dtlocToSite | Data_SCP.Common(Data_SCP.Type.SSP16LocToSite, false, pDivisionId, pItemId) | 화면 필드/플래그 변경 |  |  |  |
| AC-7511c7e6 | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2297 | if (!e.ColumnHeader && e.Row >= 0) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSP16LocToSite, false, pDivisionId, pItemId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9f2633e1 | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2298 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | dtlocBodTotal | Data_SCP.Common(Data_SCP.Type.SSP16LocBodTotal, false, pDivisionId, pFromSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-31b0c84d | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2298 | if (!e.ColumnHeader && e.Row >= 0) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSP16LocBodTotal, false, pDivisionId, pFromSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dca50769 | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2304 | if (!e.ColumnHeader && e.Row >= 0) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-36d3c410 | this.spdMain.CellDoubleClick | SSP0016_ShipmentRequest.cs:2305 | if (!e.ColumnHeader && e.Row >= 0) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0016_ShipmentRequest.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e4d3f2f | this.spdMain.TopChange | SSP0016_ShipmentRequest.cs:643 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

