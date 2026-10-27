# AS-IS 액션 대조표 — FPC0023

> 원천: `Doc/asisfacts/screens/FPC0023/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 90행 · 메서드 14 · 종류 DATA_OP 27 · FLAG 22 · UI_MISC 7 · CALL_EXT 5 · GRID_INIT 4 · UI_PROP 4 · RETURN 4 · STATE 4 · COMBO_DATA 3 · LIST_REBIND 3 · ENDPOINT 3 · POPUP 2 · GRID_BIND 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 5


## FPC0023_PlantPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98b3efdc | .ctor | FPC0023_PlantPopup.cs:120 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b1ef747b | .ctor | FPC0023_PlantPopup.cs:121 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8f9c4140 | .ctor | FPC0023_PlantPopup.cs:129 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-6a82f1ad | .ctor | FPC0023_PlantPopup.cs:130 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-c0d78230 | .ctor | FPC0023_PlantPopup.cs:132 |  | CALL_EXT | searchParam.TryGetValue | ("COMPANY_ID", out this.sCompanyId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d83113f | .ctor | FPC0023_PlantPopup.cs:133 |  | CALL_EXT | searchParam.TryGetValue | ("DIVISION_ID", out this.sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7817f0e | .ctor | FPC0023_PlantPopup.cs:134 |  | CALL_EXT | searchParam.TryGetValue | ("SITE_ID", out sSiteId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5fd35fb8 | .ctor | FPC0023_PlantPopup.cs:135 |  | CALL_EXT | searchParam.TryGetValue | ("PLANT_ID", out sPlantId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d2a6efd7 | .ctor | FPC0023_PlantPopup.cs:136 |  | CALL_EXT | searchParam.TryGetValue | ("PLANT_NAME", out sPlantName) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0023_PlantPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3225d8d2 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0023_PlantPopup.cs:368 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ddfcdd65 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0023_PlantPopup.cs:371 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0023_PlantPopup.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d90b75a | cboSite.SelectedIndexChanged | FPC0023_PlantPopup.cs:354 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-68554fc4 | cboSite.SelectedIndexChanged | FPC0023_PlantPopup.cs:354 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fb2ff09d | cboSite.SelectedIndexChanged | FPC0023_PlantPopup.cs:355 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## FPC0023_PlantPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3f078e4 | this.Load | FPC0023_PlantPopup.cs:201 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cd62e1b5 | this.Load | FPC0023_PlantPopup.cs:202 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e615d154 | this.Load | FPC0023_PlantPopup.cs:203 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0023_PlantPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b45ff6c | this.Load | FPC0023_PlantPopup.cs:196 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0023_PlantPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96acc38c | Dispose | FPC0023_PlantPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0023_PlantPopup.FindData

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-565538d7 | this.Load 외 2 | FPC0023_PlantPopup.cs:269 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3dd08af5 | this.Load 외 2 | FPC0023_PlantPopup.cs:270 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a44cc5c6 | this.Load 외 2 | FPC0023_PlantPopup.cs:273 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e1bb6742 | this.Load 외 2 | FPC0023_PlantPopup.cs:275 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Common.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-89002661 | this.Load 외 2 | FPC0023_PlantPopup.cs:279 | lambda | ENDPOINT | new FoxDataRequest | ("FP_Common.PR_UI_COMMON_POPUP") ⇒ FP_Common.PR_UI_COMMON_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-d482873b | this.Load 외 2 | FPC0023_PlantPopup.cs:281 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9db0056b | this.Load 외 2 | FPC0023_PlantPopup.cs:283 | lambda | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-083dee23 | this.Load 외 2 | FPC0023_PlantPopup.cs:284 | lambda | DATA_OP | request.Parameters["p_sys_flag"] | "PLANT_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-79e9e81d | this.Load 외 2 | FPC0023_PlantPopup.cs:285 | lambda | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-24ef6842 | this.Load 외 2 | FPC0023_PlantPopup.cs:286 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b7233745 | this.Load 외 2 | FPC0023_PlantPopup.cs:287 | lambda | DATA_OP | request.Parameters["p_non_auth"] | _sNonAuth | 행/컬럼 값 대입 |  |  |  |
| AC-556b84b7 | this.Load 외 2 | FPC0023_PlantPopup.cs:288 | lambda | DATA_OP | request.Parameters["p_save_auth"] | _sSaveAuth | 행/컬럼 값 대입 |  |  |  |
| AC-692a6b96 | this.Load 외 2 | FPC0023_PlantPopup.cs:290 | lambda | DATA_OP | request.Parameters["p_param1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a6f74891 | this.Load 외 2 | FPC0023_PlantPopup.cs:291 | lambda | DATA_OP | request.Parameters["p_param2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-36cce3e3 | this.Load 외 2 | FPC0023_PlantPopup.cs:292 | lambda | DATA_OP | request.Parameters["p_param3"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-5464c024 | this.Load 외 2 | FPC0023_PlantPopup.cs:293 | lambda | DATA_OP | request.Parameters["p_param4"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-e3116c61 | this.Load 외 2 | FPC0023_PlantPopup.cs:294 | lambda | DATA_OP | request.Parameters["p_param5"] | pPlantName.Equals("ALL") ? DBNull.Value : pPlantName | 행/컬럼 값 대입 |  |  |  |
| AC-98cf1fbc | this.Load 외 2 | FPC0023_PlantPopup.cs:295 | lambda | DATA_OP | request.Parameters["p_param6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d4765e5d | this.Load 외 2 | FPC0023_PlantPopup.cs:296 | lambda | DATA_OP | request.Parameters["p_param7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1872a60c | this.Load 외 2 | FPC0023_PlantPopup.cs:297 | lambda | DATA_OP | request.Parameters["p_param8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bbcfee39 | this.Load 외 2 | FPC0023_PlantPopup.cs:298 | lambda | DATA_OP | request.Parameters["p_param9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-021c92e3 | this.Load 외 2 | FPC0023_PlantPopup.cs:299 | lambda | DATA_OP | request.Parameters["p_param10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5d71a70a | this.Load 외 2 | FPC0023_PlantPopup.cs:301 | lambda | DATA_OP | request.Parameters["p_param11"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-66d9105b | this.Load 외 2 | FPC0023_PlantPopup.cs:302 | lambda | DATA_OP | request.Parameters["p_param12"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fc9f785e | this.Load 외 2 | FPC0023_PlantPopup.cs:303 | lambda | DATA_OP | request.Parameters["p_param13"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a777eb67 | this.Load 외 2 | FPC0023_PlantPopup.cs:304 | lambda | DATA_OP | request.Parameters["p_param14"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1f217bdc | this.Load 외 2 | FPC0023_PlantPopup.cs:305 | lambda | DATA_OP | request.Parameters["p_param15"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8e7ebe3c | this.Load 외 2 | FPC0023_PlantPopup.cs:306 | lambda | DATA_OP | request.Parameters["p_param16"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9d0fece2 | this.Load 외 2 | FPC0023_PlantPopup.cs:307 | lambda | DATA_OP | request.Parameters["p_param17"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d96c5938 | this.Load 외 2 | FPC0023_PlantPopup.cs:308 | lambda | DATA_OP | request.Parameters["p_param18"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-52c1fe64 | this.Load 외 2 | FPC0023_PlantPopup.cs:309 | lambda | DATA_OP | request.Parameters["p_param19"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c6241508 | this.Load 외 2 | FPC0023_PlantPopup.cs:310 | lambda | DATA_OP | request.Parameters["p_param20"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6fa5b1bb | this.Load 외 2 | FPC0023_PlantPopup.cs:311 | lambda | DATA_OP | request.Parameters["TimeZone"] | TimeZone | 행/컬럼 값 대입 |  |  |  |
| AC-2d4be9ab | this.Load 외 2 | FPC0023_PlantPopup.cs:313 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2d7093a5 | this.Load 외 2 | FPC0023_PlantPopup.cs:315 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-36d66c26 | this.Load 외 2 | FPC0023_PlantPopup.cs:320 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6f64f97c | this.Load 외 2 | FPC0023_PlantPopup.cs:324 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-c78de9ea | this.Load 외 2 | FPC0023_PlantPopup.cs:330 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0023_PlantPopup.fn_setRowInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22dcc29a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0023_PlantPopup.cs:408 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f4920384 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0023_PlantPopup.cs:409 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e2e63b04 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0023_PlantPopup.cs:411 |  | FLAG | _CompanyId | this.dtFindData.Rows[iClick_Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-46049310 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0023_PlantPopup.cs:412 |  | FLAG | _DivisionId | this.dtFindData.Rows[iClick_Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-425f083d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0023_PlantPopup.cs:413 |  | FLAG | _SiteId | this.dtFindData.Rows[iClick_Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f7ceba36 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0023_PlantPopup.cs:414 |  | FLAG | _PlantId | this.dtFindData.Rows[iClick_Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f7c4b894 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0023_PlantPopup.cs:415 |  | FLAG | _PlantName | this.dtFindData.Rows[iClick_Row][DefColumns.PLANT_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-bfc06b0a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0023_PlantPopup.cs:418 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0023_PlantPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-643059a2 | this.Load | FPC0023_PlantPopup.cs:147 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a2b29294 | this.Load | FPC0023_PlantPopup.cs:149 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0023_PlantPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0129937d | this.Load | FPC0023_PlantPopup.cs:170 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-7f4b4b18 | this.Load | FPC0023_PlantPopup.cs:170 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d5b6736e | this.Load | FPC0023_PlantPopup.cs:171 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4d1f82af | this.Load | FPC0023_PlantPopup.cs:172 |  | VALUE_SET | cboSite.ControlValues | sSiteId | 컨트롤 값 설정 |  |  |  |
| AC-a33c4004 | this.Load | FPC0023_PlantPopup.cs:177 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-e51669ba | this.Load | FPC0023_PlantPopup.cs:177 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c289d8e1 | this.Load | FPC0023_PlantPopup.cs:178 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b055492a | this.Load | FPC0023_PlantPopup.cs:183 | if (bCtlEnable == true) | STATE | clbPlant.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-49bdaeb7 | this.Load | FPC0023_PlantPopup.cs:184 | if (bCtlEnable == true) | STATE | cboSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-562fec7e | this.Load | FPC0023_PlantPopup.cs:188 | else of (bCtlEnable == true) | STATE | clbPlant.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-91459032 | this.Load | FPC0023_PlantPopup.cs:189 | else of (bCtlEnable == true) | STATE | cboSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FPC0023_PlantPopup.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24ec91aa | this.Load | FPC0023_PlantPopup.cs:218 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FPC0023_PlantPopup.InitSpread

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68fb0536 | this.Load 외 2 | FPC0023_PlantPopup.cs:210 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b64ed932 | this.Load 외 2 | FPC0023_PlantPopup.cs:212 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0023_PlantPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-191ee9e2 | this.spdMain.CellClick | FPC0023_PlantPopup.cs:382 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0023_PlantPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15cc91d9 | this.spdMain.CellDoubleClick | FPC0023_PlantPopup.cs:387 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-898812b0 | this.spdMain.CellDoubleClick | FPC0023_PlantPopup.cs:389 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e84d3e75 | this.spdMain.CellDoubleClick | FPC0023_PlantPopup.cs:391 |  | FLAG | _CompanyId | this.dtFindData.Rows[e.Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-167bc5be | this.spdMain.CellDoubleClick | FPC0023_PlantPopup.cs:392 |  | FLAG | _DivisionId | this.dtFindData.Rows[e.Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-05fe1ef8 | this.spdMain.CellDoubleClick | FPC0023_PlantPopup.cs:393 |  | FLAG | _SiteId | this.dtFindData.Rows[e.Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4a06bdc6 | this.spdMain.CellDoubleClick | FPC0023_PlantPopup.cs:394 |  | FLAG | _PlantId | this.dtFindData.Rows[e.Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e8225cc4 | this.spdMain.CellDoubleClick | FPC0023_PlantPopup.cs:395 |  | FLAG | _PlantName | this.dtFindData.Rows[e.Row][DefColumns.PLANT_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-de350c27 | this.spdMain.CellDoubleClick | FPC0023_PlantPopup.cs:398 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

