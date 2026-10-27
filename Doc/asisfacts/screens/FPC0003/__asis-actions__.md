# AS-IS 액션 대조표 — FPC0003

> 원천: `Doc/asisfacts/screens/FPC0003/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 94행 · 메서드 13 · 종류 DATA_OP 27 · FLAG 24 · UI_MISC 7 · CALL_EXT 6 · COMBO_DATA 4 · GRID_INIT 4 · RETURN 4 · STATE 4 · LIST_REBIND 3 · UI_PROP 3 · ENDPOINT 3 · POPUP 2 · VALUE_SET 2 · GRID_BIND 1 · ⚠ 의미 확인 필요 6


## FPC0003_ItemPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f2ebea1 | .ctor | FPC0003_ItemPopup.cs:123 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-dc562151 | .ctor | FPC0003_ItemPopup.cs:124 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-15072575 | .ctor | FPC0003_ItemPopup.cs:125 |  | FLAG | this.sDivisionId | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-02e711b1 | .ctor | FPC0003_ItemPopup.cs:133 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-2a283134 | .ctor | FPC0003_ItemPopup.cs:134 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-25752290 | .ctor | FPC0003_ItemPopup.cs:136 |  | CALL_EXT | searchParam.TryGetValue | ("COMPANY_ID", out this.sCompanyId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-db033522 | .ctor | FPC0003_ItemPopup.cs:137 |  | CALL_EXT | searchParam.TryGetValue | ("DIVISION_ID", out this.sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-44fcef50 | .ctor | FPC0003_ItemPopup.cs:138 |  | CALL_EXT | searchParam.TryGetValue | ("SITE_ID", out sSiteId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a26f8f8 | .ctor | FPC0003_ItemPopup.cs:139 |  | CALL_EXT | searchParam.TryGetValue | ("LEVEL_2_CODE", out sLevel2Code) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b5864be | .ctor | FPC0003_ItemPopup.cs:140 |  | CALL_EXT | searchParam.TryGetValue | ("LEVEL_2_CODE_FLAG", out sLevel2CodeFlag) | ⚠ 의미 확인 필요 |  |  |  |
| AC-56ed9a18 | .ctor | FPC0003_ItemPopup.cs:141 |  | CALL_EXT | searchParam.TryGetValue | ("IS_FORMATION_FLOW_ID_EXISTS", out sIsFormationFlowIdExists) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0003_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30329eb5 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0003_ItemPopup.cs:394 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-b14dc9d3 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0003_ItemPopup.cs:397 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0003_ItemPopup.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11813df6 | this.clbDivision.SelectedIndexChanged | FPC0003_ItemPopup.cs:374 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-a4e2b77e | this.clbDivision.SelectedIndexChanged | FPC0003_ItemPopup.cs:374 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-80d67acb | this.clbDivision.SelectedIndexChanged | FPC0003_ItemPopup.cs:375 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FPC0003_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae844743 | this.Load | FPC0003_ItemPopup.cs:222 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-40a21338 | this.Load | FPC0003_ItemPopup.cs:223 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ee38d588 | this.Load | FPC0003_ItemPopup.cs:224 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0003_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39188a42 | this.Load | FPC0003_ItemPopup.cs:212 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0003_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-046cf435 | Dispose | FPC0003_ItemPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0003_ItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05366db2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:288 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1af81e78 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:289 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-43ff6a53 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:292 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-02b530aa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:294 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Common.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7f82392c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:298 | lambda | ENDPOINT | new FoxDataRequest | ("FP_Common.PR_UI_COMMON_POPUP") ⇒ FP_Common.PR_UI_COMMON_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-3065cdf5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:300 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ea02c638 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:302 | lambda | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-6132d787 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:303 | lambda | DATA_OP | request.Parameters["p_sys_flag"] | "ITEM_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-e8530707 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:304 | lambda | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d11ab445 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:305 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bc89dc4d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:306 | lambda | DATA_OP | request.Parameters["p_non_auth"] | _sNonAuth | 행/컬럼 값 대입 |  |  |  |
| AC-3dca3b62 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:307 | lambda | DATA_OP | request.Parameters["p_save_auth"] | _sSaveAuth | 행/컬럼 값 대입 |  |  |  |
| AC-fff962ea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:309 | lambda | DATA_OP | request.Parameters["p_param1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bba7dcb8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:310 | lambda | DATA_OP | request.Parameters["p_param2"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-8e9fd2dc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:311 | lambda | DATA_OP | request.Parameters["p_param3"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-69ef40ba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:312 | lambda | DATA_OP | request.Parameters["p_param4"] | pItemID.Equals("ALL") ? DBNull.Value : pItemID | 행/컬럼 값 대입 |  |  |  |
| AC-c39d089a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:313 | lambda | DATA_OP | request.Parameters["p_param5"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-e8aa73c7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:314 | lambda | DATA_OP | request.Parameters["p_param6"] | (string.IsNullOrEmpty(sLevel2CodeFlag)) ? DBNull.Value : sLevel2CodeFlag as object | 행/컬럼 값 대입 |  |  |  |
| AC-a48cf7aa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:315 | lambda | DATA_OP | request.Parameters["p_param7"] | (string.IsNullOrEmpty(sLevel2Code)) ? DBNull.Value : sLevel2Code as object | 행/컬럼 값 대입 |  |  |  |
| AC-6611f5a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:316 | lambda | DATA_OP | request.Parameters["p_param8"] | (string.IsNullOrEmpty(sIsFormationFlowIdExists)) ? DBNull.Value : sIsFormationFlowIdExists… | 행/컬럼 값 대입 |  |  |  |
| AC-9c360219 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:317 | lambda | DATA_OP | request.Parameters["p_param9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1c2826ae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:318 | lambda | DATA_OP | request.Parameters["p_param10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-13d6fbc4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:320 | lambda | DATA_OP | request.Parameters["p_param11"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5715a3b2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:321 | lambda | DATA_OP | request.Parameters["p_param12"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0f74df96 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:322 | lambda | DATA_OP | request.Parameters["p_param13"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-88c5f19e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:323 | lambda | DATA_OP | request.Parameters["p_param14"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-79342a04 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:324 | lambda | DATA_OP | request.Parameters["p_param15"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ac2c77b3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:325 | lambda | DATA_OP | request.Parameters["p_param16"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0481b41a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:326 | lambda | DATA_OP | request.Parameters["p_param17"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a46cbe30 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:327 | lambda | DATA_OP | request.Parameters["p_param18"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cd0b57f6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:328 | lambda | DATA_OP | request.Parameters["p_param19"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4f0d1e44 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:329 | lambda | DATA_OP | request.Parameters["p_param20"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-25468ba7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:330 | lambda | DATA_OP | request.Parameters["TimeZone"] | TimeZone | 행/컬럼 값 대입 |  |  |  |
| AC-c0529fc3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:332 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3a7afdbe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:334 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d244b51d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:339 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-017edb5b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:343 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-9f8b8ea1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0003_ItemPopup.cs:349 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0003_ItemPopup.fn_setRowInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2973f67f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0003_ItemPopup.cs:434 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4f5a5b5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0003_ItemPopup.cs:435 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7342ec1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0003_ItemPopup.cs:437 |  | FLAG | _CompanyId | this.dtFindData.Rows[iClick_Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-04eab47d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0003_ItemPopup.cs:438 |  | FLAG | _DivisionId | this.dtFindData.Rows[iClick_Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7cdfa24d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0003_ItemPopup.cs:439 |  | FLAG | _SiteId | this.dtFindData.Rows[iClick_Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fc60f479 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0003_ItemPopup.cs:440 |  | FLAG | _ItemId | this.dtFindData.Rows[iClick_Row][DefColumns.ITEM_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6fe162e1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0003_ItemPopup.cs:441 |  | FLAG | _NickName | this.dtFindData.Rows[iClick_Row][DefColumns.NICK_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c2fbdc35 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0003_ItemPopup.cs:444 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0003_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2318d797 | this.Load | FPC0003_ItemPopup.cs:152 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-29707e2d | this.Load | FPC0003_ItemPopup.cs:154 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0003_ItemPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe411472 | this.Load | FPC0003_ItemPopup.cs:178 | if (sDivisionId == "ALL") | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-e0596128 | this.Load | FPC0003_ItemPopup.cs:178 | if (sDivisionId == "ALL") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e1ccb9ff | this.Load | FPC0003_ItemPopup.cs:182 | else of (sDivisionId == "ALL") | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-983ca4b4 | this.Load | FPC0003_ItemPopup.cs:182 | else of (sDivisionId == "ALL") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth,"",""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2947c2c5 | this.Load | FPC0003_ItemPopup.cs:184 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3419e6ac | this.Load | FPC0003_ItemPopup.cs:185 |  | VALUE_SET | clbDivision.ControlValues | sDivisionId | 컨트롤 값 설정 |  |  |  |
| AC-144779e5 | this.Load | FPC0003_ItemPopup.cs:193 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-b9ce662f | this.Load | FPC0003_ItemPopup.cs:193 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-457b9646 | this.Load | FPC0003_ItemPopup.cs:194 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-20997825 | this.Load | FPC0003_ItemPopup.cs:195 |  | VALUE_SET | cboSite.ControlValues | sSiteId | 컨트롤 값 설정 |  |  |  |
| AC-963b2273 | this.Load | FPC0003_ItemPopup.cs:199 | if (bCtlEnable == true) | STATE | clbDivision.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-229c8768 | this.Load | FPC0003_ItemPopup.cs:200 | if (bCtlEnable == true) | STATE | cboSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-db053abf | this.Load | FPC0003_ItemPopup.cs:204 | else of (bCtlEnable == true) | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5daed086 | this.Load | FPC0003_ItemPopup.cs:205 | else of (bCtlEnable == true) | STATE | cboSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FPC0003_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4b0a203 | this.Load | FPC0003_ItemPopup.cs:231 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-08e66607 | this.Load | FPC0003_ItemPopup.cs:233 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0003_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7ba46ae | this.spdMain.CellClick | FPC0003_ItemPopup.cs:408 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0003_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d672d886 | this.spdMain.CellDoubleClick | FPC0003_ItemPopup.cs:413 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-2413834c | this.spdMain.CellDoubleClick | FPC0003_ItemPopup.cs:415 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1be708c | this.spdMain.CellDoubleClick | FPC0003_ItemPopup.cs:417 |  | FLAG | _CompanyId | this.dtFindData.Rows[e.Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7690198c | this.spdMain.CellDoubleClick | FPC0003_ItemPopup.cs:418 |  | FLAG | _DivisionId | this.dtFindData.Rows[e.Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c4dbfbd4 | this.spdMain.CellDoubleClick | FPC0003_ItemPopup.cs:419 |  | FLAG | _SiteId | this.dtFindData.Rows[e.Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4a70c97a | this.spdMain.CellDoubleClick | FPC0003_ItemPopup.cs:420 |  | FLAG | _ItemId | this.dtFindData.Rows[e.Row][DefColumns.ITEM_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5485c99a | this.spdMain.CellDoubleClick | FPC0003_ItemPopup.cs:421 |  | FLAG | _NickName | this.dtFindData.Rows[e.Row][DefColumns.NICK_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-502f9bf3 | this.spdMain.CellDoubleClick | FPC0003_ItemPopup.cs:424 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

