# AS-IS 액션 대조표 — FPC0024

> 원천: `Doc/asisfacts/screens/FPC0024/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 103행 · 메서드 17 · 종류 DATA_OP 33 · FLAG 30 · GRID_INIT 9 · UI_MISC 7 · UI_PROP 5 · RETURN 4 · COMBO_DATA 3 · LIST_REBIND 3 · ENDPOINT 3 · POPUP 2 · VALUE_SET 2 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 0


## FPC0024_WorkCenterOperationPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b898bbe | .ctor | FPC0024_WorkCenterOperationPopup.cs:150 |  | FLAG | this.sSite | pSite | 화면 필드/플래그 변경 |  |  |  |
| AC-ce4677e5 | .ctor | FPC0024_WorkCenterOperationPopup.cs:151 |  | FLAG | this.sNoFactory | pNoFactory | 화면 필드/플래그 변경 |  |  |  |
| AC-04828e35 | .ctor | FPC0024_WorkCenterOperationPopup.cs:153 |  | UI_PROP | SpdSheet.shtMain | pSheetName | 속성 shtMain 설정 |  |  |  |
| AC-af051017 | .ctor | FPC0024_WorkCenterOperationPopup.cs:156 | if (pSheetName.ToUpper().Equals("WORKCENTER_OPERATION_FACTORY")) | FLAG | sSysFlag | "WORKCENTER_OPERATION_FACTORY" | 화면 필드/플래그 변경 |  |  |  |
| AC-e13dea34 | .ctor | FPC0024_WorkCenterOperationPopup.cs:158 | else of (pSheetName.ToUpper().Equals("WORKCENTER_OPERATION_FACTORY")) | FLAG | sSysFlag | "WORKCENTER_OPERATION_FACTORY_NONE" | 화면 필드/플래그 변경 |  |  |  |

## FPC0024_WorkCenterOperationPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-806707f4 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0024_WorkCenterOperationPopup.cs:424 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-2f1295d6 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0024_WorkCenterOperationPopup.cs:427 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0024_WorkCenterOperationPopup.cboSite_SelectedIndexChanged

진입점: this.cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fcfa978 | this.cboSite.SelectedIndexChanged | FPC0024_WorkCenterOperationPopup.cs:402 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8170a02 | this.cboSite.SelectedIndexChanged | FPC0024_WorkCenterOperationPopup.cs:407 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |

## FPC0024_WorkCenterOperationPopup.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d1718d1 | this.clbDivision.SelectedIndexChanged | FPC0024_WorkCenterOperationPopup.cs:376 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-350b40c5 | this.clbDivision.SelectedIndexChanged | FPC0024_WorkCenterOperationPopup.cs:379 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-9d4c20f9 | this.clbDivision.SelectedIndexChanged | FPC0024_WorkCenterOperationPopup.cs:379 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5ea2240f | this.clbDivision.SelectedIndexChanged | FPC0024_WorkCenterOperationPopup.cs:380 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c85fb81c | this.clbDivision.SelectedIndexChanged | FPC0024_WorkCenterOperationPopup.cs:384 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |

## FPC0024_WorkCenterOperationPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6a57e67 | this.Load | FPC0024_WorkCenterOperationPopup.cs:239 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2e226300 | this.Load | FPC0024_WorkCenterOperationPopup.cs:240 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-54eb7b33 | this.Load | FPC0024_WorkCenterOperationPopup.cs:241 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0024_WorkCenterOperationPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16f27dc6 | this.Load | FPC0024_WorkCenterOperationPopup.cs:234 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0024_WorkCenterOperationPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fc9b40c | Dispose | FPC0024_WorkCenterOperationPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0024_WorkCenterOperationPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d49a7246 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:290 |  | FLAG | this.sDivision | CString.GetCheckedListValue(dtMyDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-fc9f8f99 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:291 |  | FLAG | this.sSite | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-68b44137 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:293 |  | FLAG | this.sOperation | txtOperation.Text.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6de4a3ce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:298 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b8810b30 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:299 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-36bc8adc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:302 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0cc2f34b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:304 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Common.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-89cb6e95 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:308 | lambda | ENDPOINT | new FoxDataRequest | ("FP_Common.PR_UI_COMMON_POPUP") ⇒ FP_Common.PR_UI_COMMON_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-b874f3f5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:310 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5b7786e2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:312 | lambda | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-e890ce4f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:313 | lambda | DATA_OP | request.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2078c5c2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:314 | lambda | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-aecd1d0a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:315 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2c81fcb9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:316 | lambda | DATA_OP | request.Parameters["p_non_auth"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-68306fe7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:317 | lambda | DATA_OP | request.Parameters["p_save_auth"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-551acf3f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:318 | lambda | DATA_OP | request.Parameters["p_param1"] | sCompany | 행/컬럼 값 대입 |  |  |  |
| AC-87e532a0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:319 | lambda | DATA_OP | request.Parameters["p_param2"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-27be3436 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:320 | lambda | DATA_OP | request.Parameters["p_param3"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-ea23c761 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:321 | lambda | DATA_OP | request.Parameters["p_param4"] | sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-6b9712f3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:322 | lambda | DATA_OP | request.Parameters["p_param5"] | sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-a38588c3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:323 | lambda | DATA_OP | request.Parameters["p_param6"] | sNoFactory | 행/컬럼 값 대입 |  |  |  |
| AC-6d4dbeee | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:324 | lambda | DATA_OP | request.Parameters["p_param7"] | sOperation | 행/컬럼 값 대입 |  |  |  |
| AC-cd8b4d4c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:325 | lambda | DATA_OP | request.Parameters["p_param8"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-5b8c58c4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:326 | lambda | DATA_OP | request.Parameters["p_param9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bc472d6a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:327 | lambda | DATA_OP | request.Parameters["p_param10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-83fb85f5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:328 | lambda | DATA_OP | request.Parameters["p_param11"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-67c0f7d8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:329 | lambda | DATA_OP | request.Parameters["p_param12"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8a80caf9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:330 | lambda | DATA_OP | request.Parameters["p_param13"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a3e6a711 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:331 | lambda | DATA_OP | request.Parameters["p_param14"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-059b31eb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:332 | lambda | DATA_OP | request.Parameters["p_param15"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8e46bed1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:333 | lambda | DATA_OP | request.Parameters["p_param16"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-99e4d587 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:334 | lambda | DATA_OP | request.Parameters["p_param17"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e21bd569 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:335 | lambda | DATA_OP | request.Parameters["p_param18"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2924594f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:336 | lambda | DATA_OP | request.Parameters["p_param19"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-dabab942 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:337 | lambda | DATA_OP | request.Parameters["p_param20"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9c49fa37 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:338 | lambda | DATA_OP | request.Parameters["TimeZone"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5654480c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:340 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9ebc36e1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:342 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-53a5fe49 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:347 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1841dddd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:350 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a470b74b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:355 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-a08f4f12 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0024_WorkCenterOperationPopup.cs:357 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0024_WorkCenterOperationPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f029083b | this.Load | FPC0024_WorkCenterOperationPopup.cs:167 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d3e6d911 | this.Load | FPC0024_WorkCenterOperationPopup.cs:169 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0024_WorkCenterOperationPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e114beb6 | this.Load | FPC0024_WorkCenterOperationPopup.cs:203 |  | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-97eae75b | this.Load | FPC0024_WorkCenterOperationPopup.cs:203 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dcc98784 | this.Load | FPC0024_WorkCenterOperationPopup.cs:204 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-dfacf000 | this.Load | FPC0024_WorkCenterOperationPopup.cs:207 | if (!string.IsNullOrEmpty(sDivision)) | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-9e3da80b | this.Load | FPC0024_WorkCenterOperationPopup.cs:211 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc4a0282 | this.Load | FPC0024_WorkCenterOperationPopup.cs:214 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-a97f2cfb | this.Load | FPC0024_WorkCenterOperationPopup.cs:214 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-84c6dc06 | this.Load | FPC0024_WorkCenterOperationPopup.cs:215 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-33d6ae08 | this.Load | FPC0024_WorkCenterOperationPopup.cs:217 | if (!string.IsNullOrEmpty(sSite)) | VALUE_SET | cboSite.ControlValues | sSite | 컨트롤 값 설정 |  |  |  |
| AC-c8d672b0 | this.Load | FPC0024_WorkCenterOperationPopup.cs:221 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |

## FPC0024_WorkCenterOperationPopup.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd839035 | this.Load | FPC0024_WorkCenterOperationPopup.cs:186 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FPC0024_WorkCenterOperationPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bbb50f4 | this.Load | FPC0024_WorkCenterOperationPopup.cs:251 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6635ded2 | this.Load | FPC0024_WorkCenterOperationPopup.cs:252 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0024_WorkCenterOperationPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2518b25 | (진입점 미연결) | FPC0024_WorkCenterOperationPopup.cs:275 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0024_WorkCenterOperationPopup.SetOperationInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccf4cf6d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0024_WorkCenterOperationPopup.cs:473 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1b7eb0c4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0024_WorkCenterOperationPopup.cs:474 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57c8ac17 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0024_WorkCenterOperationPopup.cs:476 |  | FLAG | _CompanyId | this.dtFindData.Rows[iClick_Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-bc1298f2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0024_WorkCenterOperationPopup.cs:477 |  | FLAG | _DivisionId | this.dtFindData.Rows[iClick_Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2a88fb3c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0024_WorkCenterOperationPopup.cs:478 |  | FLAG | _SiteId | this.dtFindData.Rows[iClick_Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9c2792e2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0024_WorkCenterOperationPopup.cs:479 |  | FLAG | _PlantId | this.dtFindData.Rows[iClick_Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-de9b0010 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0024_WorkCenterOperationPopup.cs:480 |  | FLAG | _FactoryId | this.dtFindData.Rows[iClick_Row][DefColumns.FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f84c32d1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0024_WorkCenterOperationPopup.cs:481 |  | FLAG | _OperationId | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2b7e0d51 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0024_WorkCenterOperationPopup.cs:482 |  | FLAG | _OperationName | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1b653ab1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0024_WorkCenterOperationPopup.cs:483 |  | FLAG | _OperationGroupId | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_GROUP_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-476ff9bd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0024_WorkCenterOperationPopup.cs:486 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0024_WorkCenterOperationPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba30e6f7 | this.Load | FPC0024_WorkCenterOperationPopup.cs:259 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3bfa0291 | this.Load | FPC0024_WorkCenterOperationPopup.cs:260 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-c9766763 | this.Load | FPC0024_WorkCenterOperationPopup.cs:264 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-ca183bea | this.Load | FPC0024_WorkCenterOperationPopup.cs:266 | if (siMain.GetColumnIndex(DefColumns.OPERATION_ID)>-1) | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.OPERATION_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0024_WorkCenterOperationPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59a0060c | this.spdMain.CellClick | FPC0024_WorkCenterOperationPopup.cs:438 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0024_WorkCenterOperationPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f995b8d5 | this.spdMain.CellDoubleClick | FPC0024_WorkCenterOperationPopup.cs:443 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-8c223a94 | this.spdMain.CellDoubleClick | FPC0024_WorkCenterOperationPopup.cs:445 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1f161780 | this.spdMain.CellDoubleClick | FPC0024_WorkCenterOperationPopup.cs:447 |  | FLAG | _CompanyId | this.dtFindData.Rows[e.Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ba04ccaa | this.spdMain.CellDoubleClick | FPC0024_WorkCenterOperationPopup.cs:448 |  | FLAG | _DivisionId | this.dtFindData.Rows[e.Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5b52b9a9 | this.spdMain.CellDoubleClick | FPC0024_WorkCenterOperationPopup.cs:449 |  | FLAG | _SiteId | this.dtFindData.Rows[e.Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f50f6c6d | this.spdMain.CellDoubleClick | FPC0024_WorkCenterOperationPopup.cs:450 |  | FLAG | _PlantId | this.dtFindData.Rows[e.Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7845546e | this.spdMain.CellDoubleClick | FPC0024_WorkCenterOperationPopup.cs:453 | if (sSysFlag != "WORKCENTER_OPERATION_FACTORY_NONE") | FLAG | _FactoryId | this.dtFindData.Rows[e.Row][DefColumns.FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-109bb5a0 | this.spdMain.CellDoubleClick | FPC0024_WorkCenterOperationPopup.cs:456 |  | FLAG | _OperationId | this.dtFindData.Rows[e.Row][DefColumns.OPERATION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-339349dc | this.spdMain.CellDoubleClick | FPC0024_WorkCenterOperationPopup.cs:457 |  | FLAG | _OperationGroupId | this.dtFindData.Rows[e.Row][DefColumns.OPERATION_GROUP_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c376be65 | this.spdMain.CellDoubleClick | FPC0024_WorkCenterOperationPopup.cs:462 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

