# AS-IS 액션 대조표 — FPC0031

> 원천: `Doc/asisfacts/screens/FPC0031/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 77행 · 메서드 11 · 종류 DATA_OP 27 · FLAG 20 · UI_MISC 7 · CALL_EXT 6 · GRID_INIT 4 · RETURN 4 · UI_PROP 3 · ENDPOINT 3 · POPUP 2 · GRID_BIND 1 · ⚠ 의미 확인 필요 6


## FPC0031_ItemBPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cae04b2 | .ctor | FPC0031_ItemBPopup.cs:120 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c2fdd113 | .ctor | FPC0031_ItemBPopup.cs:121 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-605203be | .ctor | FPC0031_ItemBPopup.cs:122 |  | FLAG | this.sDivisionId | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-788de73c | .ctor | FPC0031_ItemBPopup.cs:130 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-ec44903f | .ctor | FPC0031_ItemBPopup.cs:131 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-57f5f02d | .ctor | FPC0031_ItemBPopup.cs:133 |  | CALL_EXT | searchParam.TryGetValue | ("COMPANY_ID", out this.sCompanyId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9737966a | .ctor | FPC0031_ItemBPopup.cs:134 |  | CALL_EXT | searchParam.TryGetValue | ("DIVISION_ID", out this.sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a1e3925a | .ctor | FPC0031_ItemBPopup.cs:135 |  | CALL_EXT | searchParam.TryGetValue | ("SITE_ID", out sSiteId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a7f395a | .ctor | FPC0031_ItemBPopup.cs:136 |  | CALL_EXT | searchParam.TryGetValue | ("LEVEL_2_CODE", out sLevel2Code) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe37f919 | .ctor | FPC0031_ItemBPopup.cs:137 |  | CALL_EXT | searchParam.TryGetValue | ("LEVEL_2_CODE_FLAG", out sLevel2CodeFlag) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d5462aea | .ctor | FPC0031_ItemBPopup.cs:138 |  | CALL_EXT | searchParam.TryGetValue | ("IS_FORMATION_FLOW_ID_EXISTS", out sIsFormationFlowIdExists) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0031_ItemBPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04ab15ae | this.btnButtonList.UsrButtonList_Click_Detected | FPC0031_ItemBPopup.cs:336 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-1c907a30 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0031_ItemBPopup.cs:339 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0031_ItemBPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2840914b | this.Load | FPC0031_ItemBPopup.cs:180 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-95706ada | this.Load | FPC0031_ItemBPopup.cs:181 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-01180644 | this.Load | FPC0031_ItemBPopup.cs:182 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0031_ItemBPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-175fa1d5 | this.Load | FPC0031_ItemBPopup.cs:175 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0031_ItemBPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-474a676f | Dispose | FPC0031_ItemBPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0031_ItemBPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6727470f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:246 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5c4780ee | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:247 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a6303218 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:250 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e9655594 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:252 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Common.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f204a4a5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:256 | lambda | ENDPOINT | new FoxDataRequest | ("FP_Common.PR_UI_COMMON_POPUP") ⇒ FP_Common.PR_UI_COMMON_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-e3e96b37 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:258 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-26f16956 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:260 | lambda | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-7a725842 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:261 | lambda | DATA_OP | request.Parameters["p_sys_flag"] | "ITEM_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-602ffdaa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:262 | lambda | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0b7cbe70 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:263 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2d01f5d1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:264 | lambda | DATA_OP | request.Parameters["p_non_auth"] | _sNonAuth | 행/컬럼 값 대입 |  |  |  |
| AC-cb2feb27 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:265 | lambda | DATA_OP | request.Parameters["p_save_auth"] | _sSaveAuth | 행/컬럼 값 대입 |  |  |  |
| AC-42908b0e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:267 | lambda | DATA_OP | request.Parameters["p_param1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-72b1b37c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:268 | lambda | DATA_OP | request.Parameters["p_param2"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-b6c51b3e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:269 | lambda | DATA_OP | request.Parameters["p_param3"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-3c5e47cb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:270 | lambda | DATA_OP | request.Parameters["p_param4"] | pItemID.Equals("ALL") ? DBNull.Value : pItemID | 행/컬럼 값 대입 |  |  |  |
| AC-e910a7a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:271 | lambda | DATA_OP | request.Parameters["p_param5"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-88b2a988 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:272 | lambda | DATA_OP | request.Parameters["p_param6"] | (string.IsNullOrEmpty(sLevel2CodeFlag)) ? DBNull.Value : sLevel2CodeFlag as object | 행/컬럼 값 대입 |  |  |  |
| AC-aba8034e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:273 | lambda | DATA_OP | request.Parameters["p_param7"] | (string.IsNullOrEmpty(sLevel2Code)) ? DBNull.Value : sLevel2Code as object | 행/컬럼 값 대입 |  |  |  |
| AC-4397c834 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:274 | lambda | DATA_OP | request.Parameters["p_param8"] | (string.IsNullOrEmpty(sIsFormationFlowIdExists)) ? DBNull.Value : sIsFormationFlowIdExists… | 행/컬럼 값 대입 |  |  |  |
| AC-eb68b646 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:275 | lambda | DATA_OP | request.Parameters["p_param9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-68c223b4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:276 | lambda | DATA_OP | request.Parameters["p_param10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fd026b28 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:278 | lambda | DATA_OP | request.Parameters["p_param11"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f930fa33 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:279 | lambda | DATA_OP | request.Parameters["p_param12"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-191c39bb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:280 | lambda | DATA_OP | request.Parameters["p_param13"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-43740b12 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:281 | lambda | DATA_OP | request.Parameters["p_param14"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6c1fd74b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:282 | lambda | DATA_OP | request.Parameters["p_param15"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fa98fc67 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:283 | lambda | DATA_OP | request.Parameters["p_param16"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-dae79835 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:284 | lambda | DATA_OP | request.Parameters["p_param17"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f9f1ce39 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:285 | lambda | DATA_OP | request.Parameters["p_param18"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f0f820cb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:286 | lambda | DATA_OP | request.Parameters["p_param19"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d93ab46a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:287 | lambda | DATA_OP | request.Parameters["p_param20"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d21dca44 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:288 | lambda | DATA_OP | request.Parameters["TimeZone"] | TimeZone | 행/컬럼 값 대입 |  |  |  |
| AC-77220078 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:290 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-023f059c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:292 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d03e75af | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:297 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f9c6223d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:301 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-93c7df41 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0031_ItemBPopup.cs:307 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0031_ItemBPopup.fn_setRowInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4f7a5f6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0031_ItemBPopup.cs:376 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb323eb8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0031_ItemBPopup.cs:377 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9414f7c6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0031_ItemBPopup.cs:379 |  | FLAG | _CompanyId | this.dtFindData.Rows[iClick_Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ebe03b87 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0031_ItemBPopup.cs:380 |  | FLAG | _DivisionId | this.dtFindData.Rows[iClick_Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4b474bba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0031_ItemBPopup.cs:381 |  | FLAG | _SiteId | this.dtFindData.Rows[iClick_Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-02a50fcc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0031_ItemBPopup.cs:382 |  | FLAG | _ItemId | this.dtFindData.Rows[iClick_Row][DefColumns.ITEM_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6fb799ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0031_ItemBPopup.cs:383 |  | FLAG | _NickName | this.dtFindData.Rows[iClick_Row][DefColumns.NICK_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0f1d7062 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0031_ItemBPopup.cs:386 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0031_ItemBPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-468d793d | this.Load | FPC0031_ItemBPopup.cs:149 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-84be47b2 | this.Load | FPC0031_ItemBPopup.cs:151 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0031_ItemBPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f66e0f7 | this.Load | FPC0031_ItemBPopup.cs:189 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f2fe9282 | this.Load | FPC0031_ItemBPopup.cs:191 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0031_ItemBPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c9301f8 | this.spdMain.CellClick | FPC0031_ItemBPopup.cs:350 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0031_ItemBPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91f6770d | this.spdMain.CellDoubleClick | FPC0031_ItemBPopup.cs:355 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-cae85519 | this.spdMain.CellDoubleClick | FPC0031_ItemBPopup.cs:357 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-731e0d5d | this.spdMain.CellDoubleClick | FPC0031_ItemBPopup.cs:359 |  | FLAG | _CompanyId | this.dtFindData.Rows[e.Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4067a0b4 | this.spdMain.CellDoubleClick | FPC0031_ItemBPopup.cs:360 |  | FLAG | _DivisionId | this.dtFindData.Rows[e.Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8d9fee4c | this.spdMain.CellDoubleClick | FPC0031_ItemBPopup.cs:361 |  | FLAG | _SiteId | this.dtFindData.Rows[e.Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b4c741e9 | this.spdMain.CellDoubleClick | FPC0031_ItemBPopup.cs:362 |  | FLAG | _ItemId | this.dtFindData.Rows[e.Row][DefColumns.ITEM_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7ce14ad6 | this.spdMain.CellDoubleClick | FPC0031_ItemBPopup.cs:363 |  | FLAG | _NickName | this.dtFindData.Rows[e.Row][DefColumns.NICK_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ab6a3935 | this.spdMain.CellDoubleClick | FPC0031_ItemBPopup.cs:366 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

