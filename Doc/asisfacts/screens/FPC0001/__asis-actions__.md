# AS-IS 액션 대조표 — FPC0001

> 원천: `Doc/asisfacts/screens/FPC0001/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 354행 · 메서드 60 · 종류 DATA_OP 77 · FLAG 71 · RETURN 34 · GRID_INIT 28 · UI_MISC 21 · UI_PROP 21 · ENDPOINT 17 · POPUP 14 · MESSAGE 13 · COMBO_DATA 9 · GRID_SET 9 · STATE 8 · CALL_EXT 7 · LIST_REBIND 6 · VALUE_SET 5 · GRID_BIND 4 · GRID_LOCK 3 · VALIDATE 2 · FOCUS 1 · CALL_BASE 1 · EXCEL 1 · GRID_STYLE 1 · THROW 1 · ⚠ 의미 확인 필요 8


## FPC0001_BuildingPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df8f2bd1 | .ctor | FPC0001_BuildingPopup.cs:128 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d0a7a1ca | .ctor | FPC0001_BuildingPopup.cs:129 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-edfaf45e | .ctor | FPC0001_BuildingPopup.cs:130 |  | FLAG | this.sDivision | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-19951486 | .ctor | FPC0001_BuildingPopup.cs:138 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-4ebf9a3b | .ctor | FPC0001_BuildingPopup.cs:139 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-370a57cc | .ctor | FPC0001_BuildingPopup.cs:141 |  | FLAG | this.sDivision | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-00ecde0c | .ctor | FPC0001_BuildingPopup.cs:149 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-d067e650 | .ctor | FPC0001_BuildingPopup.cs:150 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-6a78d7b5 | .ctor | FPC0001_BuildingPopup.cs:152 |  | FLAG | this.sDivision | pDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-92fc4e57 | .ctor | FPC0001_BuildingPopup.cs:161 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-39cb165f | .ctor | FPC0001_BuildingPopup.cs:162 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-e566f563 | .ctor | FPC0001_BuildingPopup.cs:164 |  | FLAG | this.sDivision | pDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-201c682b | .ctor | FPC0001_BuildingPopup.cs:165 |  | FLAG | this.sSite | pSite | 화면 필드/플래그 변경 |  |  |  |
| AC-c278b44f | .ctor | FPC0001_BuildingPopup.cs:166 |  | FLAG | this.sPlant | pPlant | 화면 필드/플래그 변경 |  |  |  |

## FPC0001_BuildingPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e614dcb | this.btnButtonList.UsrButtonList_Click_Detected | FPC0001_BuildingPopup.cs:489 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-72360043 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0001_BuildingPopup.cs:492 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0001_BuildingPopup.cboSite_SelectedIndexChanged

진입점: this.cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a13854d | this.cboSite.SelectedIndexChanged | FPC0001_BuildingPopup.cs:462 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e98353d | this.cboSite.SelectedIndexChanged | FPC0001_BuildingPopup.cs:467 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-6a9460e6 | this.cboSite.SelectedIndexChanged | FPC0001_BuildingPopup.cs:471 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-80bf4c16 | this.cboSite.SelectedIndexChanged | FPC0001_BuildingPopup.cs:471 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-60352a54 | this.cboSite.SelectedIndexChanged | FPC0001_BuildingPopup.cs:472 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## FPC0001_BuildingPopup.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44e826c4 | this.clbDivision.SelectedIndexChanged | FPC0001_BuildingPopup.cs:434 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-f538cfa3 | this.clbDivision.SelectedIndexChanged | FPC0001_BuildingPopup.cs:437 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-6664dc82 | this.clbDivision.SelectedIndexChanged | FPC0001_BuildingPopup.cs:437 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-72613e6c | this.clbDivision.SelectedIndexChanged | FPC0001_BuildingPopup.cs:438 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-efbb5b81 | this.clbDivision.SelectedIndexChanged | FPC0001_BuildingPopup.cs:442 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-065dd79e | this.clbDivision.SelectedIndexChanged | FPC0001_BuildingPopup.cs:445 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-f2639dec | this.clbDivision.SelectedIndexChanged | FPC0001_BuildingPopup.cs:445 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-47bc3f24 | this.clbDivision.SelectedIndexChanged | FPC0001_BuildingPopup.cs:446 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## FPC0001_BuildingPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48cf7b59 | this.Load | FPC0001_BuildingPopup.cs:264 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-81869601 | this.Load | FPC0001_BuildingPopup.cs:265 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7f8b3ade | this.Load | FPC0001_BuildingPopup.cs:266 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0001_BuildingPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5a62d74 | this.Load | FPC0001_BuildingPopup.cs:259 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0001_BuildingPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c17eb70 | Dispose | FPC0001_BuildingPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0001_BuildingPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6dc8814 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:348 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-20311370 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:349 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5ef53e1e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:352 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-6e978504 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:354 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Common.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4615a6bd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:358 | lambda | ENDPOINT | new FoxDataRequest | ("FP_Common.PR_UI_COMMON_POPUP") ⇒ FP_Common.PR_UI_COMMON_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-ef0a2c8c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:360 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-54d979f9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:362 | lambda | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-0480010c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:363 | lambda | DATA_OP | request.Parameters["p_sys_flag"] | "BUILDING_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-e236ddb6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:364 | lambda | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fbc31379 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:365 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-56d638c7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:366 | lambda | DATA_OP | request.Parameters["p_non_auth"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fd806631 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:367 | lambda | DATA_OP | request.Parameters["p_save_auth"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1cecbd6d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:368 | lambda | DATA_OP | request.Parameters["p_param1"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-47997c7c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:369 | lambda | DATA_OP | request.Parameters["p_param2"] | pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-6a145f1e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:370 | lambda | DATA_OP | request.Parameters["p_param3"] | pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-0bdc57d8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:371 | lambda | DATA_OP | request.Parameters["p_param4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-58527dcf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:372 | lambda | DATA_OP | request.Parameters["p_param5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e614efe2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:373 | lambda | DATA_OP | request.Parameters["p_param6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-82754c9b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:374 | lambda | DATA_OP | request.Parameters["p_param7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-00d4000d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:375 | lambda | DATA_OP | request.Parameters["p_param8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-17cbe808 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:376 | lambda | DATA_OP | request.Parameters["p_param9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5edb8067 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:377 | lambda | DATA_OP | request.Parameters["p_param10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d5d6f958 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:378 | lambda | DATA_OP | request.Parameters["p_param11"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9e413cfc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:379 | lambda | DATA_OP | request.Parameters["p_param12"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d74c2be5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:380 | lambda | DATA_OP | request.Parameters["p_param13"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-12b5d4d5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:381 | lambda | DATA_OP | request.Parameters["p_param14"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-09f885d3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:382 | lambda | DATA_OP | request.Parameters["p_param15"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-eb0031e7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:383 | lambda | DATA_OP | request.Parameters["p_param16"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a055739b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:384 | lambda | DATA_OP | request.Parameters["p_param17"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ceebc5ce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:385 | lambda | DATA_OP | request.Parameters["p_param18"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-95bff30c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:386 | lambda | DATA_OP | request.Parameters["p_param19"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-be6d6817 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:387 | lambda | DATA_OP | request.Parameters["p_param20"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7b4f0c96 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:388 | lambda | DATA_OP | request.Parameters["TimeZone"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6bf7cfba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:389 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-81ee42f4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:391 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e0a1cfe2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:396 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f962656b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:399 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4b143517 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:401 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-4932d9af | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0001_BuildingPopup.cs:405 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0001_BuildingPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b304b27 | this.Load | FPC0001_BuildingPopup.cs:174 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2104c511 | this.Load | FPC0001_BuildingPopup.cs:176 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0001_BuildingPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-189c8ceb | this.Load | FPC0001_BuildingPopup.cs:208 |  | DATA_OP | this.sDivision.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e6eea6b | this.Load | FPC0001_BuildingPopup.cs:214 | if (sDivision == "ALL") | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-308ebc37 | this.Load | FPC0001_BuildingPopup.cs:214 | if (sDivision == "ALL") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3f77546c | this.Load | FPC0001_BuildingPopup.cs:218 | else of (sDivision == "ALL") | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-df23c9a7 | this.Load | FPC0001_BuildingPopup.cs:218 | else of (sDivision == "ALL") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth,"",""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-14c891de | this.Load | FPC0001_BuildingPopup.cs:220 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d7c3722c | this.Load | FPC0001_BuildingPopup.cs:221 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-4b9c7f22 | this.Load | FPC0001_BuildingPopup.cs:225 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-b011678e | this.Load | FPC0001_BuildingPopup.cs:229 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-f57ff01e | this.Load | FPC0001_BuildingPopup.cs:229 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a28ec367 | this.Load | FPC0001_BuildingPopup.cs:230 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-08c2e3ad | this.Load | FPC0001_BuildingPopup.cs:231 |  | VALUE_SET | cboSite.ControlValues | sSite | 컨트롤 값 설정 |  |  |  |
| AC-7a0d093f | this.Load | FPC0001_BuildingPopup.cs:235 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-12d50ad0 | this.Load | FPC0001_BuildingPopup.cs:238 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-45ce1e1b | this.Load | FPC0001_BuildingPopup.cs:238 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4f4afeb1 | this.Load | FPC0001_BuildingPopup.cs:239 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e5c26096 | this.Load | FPC0001_BuildingPopup.cs:240 |  | VALUE_SET | clbPlant.ControlValues | sPlant | 컨트롤 값 설정 |  |  |  |
| AC-22a57d5c | this.Load | FPC0001_BuildingPopup.cs:244 | if (bCtlEnable == true) | STATE | clbDivision.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cbf80e2e | this.Load | FPC0001_BuildingPopup.cs:245 | if (bCtlEnable == true) | STATE | cboSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-627323e6 | this.Load | FPC0001_BuildingPopup.cs:246 | if (bCtlEnable == true) | STATE | clbPlant.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e34915ba | this.Load | FPC0001_BuildingPopup.cs:250 | else of (bCtlEnable == true) | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0e788545 | this.Load | FPC0001_BuildingPopup.cs:251 | else of (bCtlEnable == true) | STATE | cboSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c5143f01 | this.Load | FPC0001_BuildingPopup.cs:252 | else of (bCtlEnable == true) | STATE | clbPlant.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FPC0001_BuildingPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8316d9ac | this.Load | FPC0001_BuildingPopup.cs:276 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0446e139 | this.Load | FPC0001_BuildingPopup.cs:277 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0001_BuildingPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b720c479 | (진입점 미연결) | FPC0001_BuildingPopup.cs:298 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0001_BuildingPopup.SetLineInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29079f8a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0001_BuildingPopup.cs:529 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-76490d65 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0001_BuildingPopup.cs:530 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-99d4e1a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0001_BuildingPopup.cs:531 |  | FLAG | _CompanyId | this.dtFindData.Rows[iClick_Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-54560003 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0001_BuildingPopup.cs:532 |  | FLAG | _DivisionId | this.dtFindData.Rows[iClick_Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e9be34c9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0001_BuildingPopup.cs:533 |  | FLAG | _SiteId | this.dtFindData.Rows[iClick_Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-13f451e1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0001_BuildingPopup.cs:534 |  | FLAG | _PlantId | this.dtFindData.Rows[iClick_Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-667aa850 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0001_BuildingPopup.cs:535 |  | FLAG | _FactoryId | this.dtFindData.Rows[iClick_Row][DefColumns.FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b114ec85 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0001_BuildingPopup.cs:538 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0001_BuildingPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b85d274 | this.Load | FPC0001_BuildingPopup.cs:283 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-85469259 | this.Load | FPC0001_BuildingPopup.cs:284 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-9fec9065 | this.Load | FPC0001_BuildingPopup.cs:288 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-9ea54941 | this.Load | FPC0001_BuildingPopup.cs:289 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.SITE_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0001_BuildingPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b140f835 | this.spdMain.CellClick | FPC0001_BuildingPopup.cs:503 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0001_BuildingPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-991ed6a8 | this.spdMain.CellDoubleClick | FPC0001_BuildingPopup.cs:508 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-1b1c0dd9 | this.spdMain.CellDoubleClick | FPC0001_BuildingPopup.cs:510 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ee5840b | this.spdMain.CellDoubleClick | FPC0001_BuildingPopup.cs:512 |  | FLAG | _CompanyId | this.dtFindData.Rows[e.Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-bb657186 | this.spdMain.CellDoubleClick | FPC0001_BuildingPopup.cs:513 |  | FLAG | _DivisionId | this.dtFindData.Rows[e.Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2f69d244 | this.spdMain.CellDoubleClick | FPC0001_BuildingPopup.cs:514 |  | FLAG | _SiteId | this.dtFindData.Rows[e.Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-168cc2a6 | this.spdMain.CellDoubleClick | FPC0001_BuildingPopup.cs:515 |  | FLAG | _PlantId | this.dtFindData.Rows[e.Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3b558fa7 | this.spdMain.CellDoubleClick | FPC0001_BuildingPopup.cs:516 |  | FLAG | _FactoryId | this.dtFindData.Rows[e.Row][DefColumns.FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3a73cf74 | this.spdMain.CellDoubleClick | FPC0001_BuildingPopup.cs:519 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0001_ExcelImportPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5192e223 | .ctor | FPC0001_ExcelImportPopup.cs:91 |  | FLAG | this.sSheetName | pSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-803c77f6 | .ctor | FPC0001_ExcelImportPopup.cs:92 |  | FLAG | this.sProgramId | pProgramId | 화면 필드/플래그 변경 |  |  |  |
| AC-8f9b2dbf | .ctor | FPC0001_ExcelImportPopup.cs:93 |  | FLAG | this.sServiceCallName | pServiceCallName | 화면 필드/플래그 변경 |  |  |  |
| AC-f77572c2 | .ctor | FPC0001_ExcelImportPopup.cs:94 |  | FLAG | this.sParamsValue | pParamsValue | 화면 필드/플래그 변경 |  |  |  |
| AC-17b57406 | .ctor | FPC0001_ExcelImportPopup.cs:95 |  | FLAG | this.sParamsList | pParamsList | 화면 필드/플래그 변경 |  |  |  |
| AC-10adf240 | .ctor | FPC0001_ExcelImportPopup.cs:97 |  | UI_PROP | SpdSheet.shtComExcel | this.sSheetName | 속성 shtComExcel 설정 |  |  |  |
| AC-a5c84b6d | .ctor | FPC0001_ExcelImportPopup.cs:101 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | MESSAGE | MessageBox.Show | ("The ProgramID/SheetName/ProcedureName[Parameters] is Null!", "FP", MessageBoxButtons.OK,… | 메시지 표시 |  |  |  |
| AC-a61c692c | .ctor | FPC0001_ExcelImportPopup.cs:102 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-8bd6bc6e | .ctor | FPC0001_ExcelImportPopup.cs:106 | if (string.IsNullOrEmpty(this.sParamsValue) \|\| string.IsNullOrEmpty(this.sParamsList)) | MESSAGE | MessageBox.Show | ("the Value/List[Parameters] is Null!", "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-97ff9c46 | .ctor | FPC0001_ExcelImportPopup.cs:107 | if (string.IsNullOrEmpty(this.sParamsValue) \|\| string.IsNullOrEmpty(this.sParamsList)) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-0485057c | .ctor | FPC0001_ExcelImportPopup.cs:114 |  | FLAG | iParmsCount | arrList.Length | 화면 필드/플래그 변경 |  |  |  |
| AC-050b0530 | .ctor | FPC0001_ExcelImportPopup.cs:116 |  | UI_PROP | structParam._sDbParamsList | new string[iParmsCount] | 속성 _sDbParamsList 설정 |  |  |  |
| AC-83834869 | .ctor | FPC0001_ExcelImportPopup.cs:117 |  | UI_PROP | structParam._sParamFilter | new string[iParmsCount] | 속성 _sParamFilter 설정 |  |  |  |
| AC-1f16a16c | .ctor | FPC0001_ExcelImportPopup.cs:123 | for (i < iParmsCount) | DATA_OP | structParam._sDbParamsList[i] | arrList[i] | 행/컬럼 값 대입 |  |  |  |
| AC-603d7c1b | .ctor | FPC0001_ExcelImportPopup.cs:124 | for (i < iParmsCount) | DATA_OP | structParam._sParamFilter[i] | arrValue[i] | 행/컬럼 값 대입 |  |  |  |
| AC-fe9b8b83 | .ctor | FPC0001_ExcelImportPopup.cs:126 | for (i < iParmsCount) | DATA_OP | pParams.Add | (String.Format("p_param{0}", i.ToString()), "") | 데이터 객체 조작/조회 |  |  |  |

## FPC0001_ExcelImportPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c29a35a | this.btnClose.Click | FPC0001_ExcelImportPopup.cs:853 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0001_ExcelImportPopup.btnExport_Click

진입점: this.btnExport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8535763 | this.btnExport.Click | FPC0001_ExcelImportPopup.cs:814 |  | FOCUS | siComExcel.SpreadObject.Focus | () | 포커스 이동 |  |  |  |
| AC-d80c1bcd | this.btnExport.Click | FPC0001_ExcelImportPopup.cs:815 |  | CALL_BASE | OnClickExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## FPC0001_ExcelImportPopup.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46d7c10d | this.btnImport.Click | FPC0001_ExcelImportPopup.cs:824 |  | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-4e705d44 | this.btnImport.Click | FPC0001_ExcelImportPopup.cs:825 |  | UI_PROP | opd.InitialDirectory | Application.StartupPath | 속성 InitialDirectory 설정 |  |  |  |
| AC-6e43fb78 | this.btnImport.Click | FPC0001_ExcelImportPopup.cs:826 |  | UI_PROP | opd.Filter | "Excel files (*.xls)\|*.xls\|All files (*.*)\|*.*" | 속성 Filter 설정 |  |  |  |
| AC-7206156c | this.btnImport.Click | FPC0001_ExcelImportPopup.cs:827 |  | UI_PROP | opd.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-93afcefa | this.btnImport.Click | FPC0001_ExcelImportPopup.cs:829 |  | POPUP | opd.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1537e55d | this.btnImport.Click | FPC0001_ExcelImportPopup.cs:833 | if (opd.ShowDialog() == DialogResult.OK) | COMBO_DATA | DataCommon.GetReadExcelFile | (opd.FileName, iParmsCount) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FPC0001_ExcelImportPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-166658bc | this.btnSql.Click | FPC0001_ExcelImportPopup.cs:859 |  | POPUP | new FPC0001_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8ac4247b | this.btnSql.Click | FPC0001_ExcelImportPopup.cs:860 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8cb1506a | this.btnSql.Click | FPC0001_ExcelImportPopup.cs:862 |  | DATA_OP | popSql.Services.Add | ("SELECT_IMPORT") | 데이터 객체 조작/조회 |  |  |  |
| AC-b388bbf6 | this.btnSql.Click | FPC0001_ExcelImportPopup.cs:863 |  | DATA_OP | popSql.Services.Add | ("SELECT_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c3a9fbd6 | this.btnSql.Click | FPC0001_ExcelImportPopup.cs:864 |  | DATA_OP | popSql.Services.Add | ("INSERT_BUFFER") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c876017 | this.btnSql.Click | FPC0001_ExcelImportPopup.cs:865 |  | DATA_OP | popSql.Services.Add | ("INSERT_EXCEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-47926201 | this.btnSql.Click | FPC0001_ExcelImportPopup.cs:866 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FPC0001_ExcelImportPopup.CheckNullSpreadValidation

진입점: this.btnImport.Click [if (opd.ShowDialog() == DialogResult.OK) ▸ if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ if (bFlag) ▸ try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (dsv.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70380997 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:887 |  | FLAG | dtSheetColumn | siComExcel.GetSpdTitle("FPC0001", UserInfoContext.Current.UserId, this.sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-e9204143 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:887 |  | CALL_EXT | siComExcel.GetSpdTitle | ("FPC0001", UserInfoContext.Current.UserId, this.sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-40a213b6 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:890 | if (dtSheetColumn.Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3833c3bf | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:914 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrE… | GRID_SET | siComExcel.ActiveSheet.Cells[i, siComExcel.GetMaxColumnIndex() - 1].Text | actionText + " Not Null : " + siComExcel.GetText(i, siComExcel.GetMaxColumnIndex() - 1) | 그리드 속성/값 설정 |  |  |  |
| AC-a8882f6d | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:915 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrE… | GRID_SET | siComExcel.ActiveSheet.Cells[i, siComExcel.GetMaxColumnIndex()].Text | "N" | 그리드 속성/값 설정 |  |  |  |
| AC-9ac90df3 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:916 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrE… | GRID_SET | siComExcel.ActiveSheet.Cells[i, 0, i, siComExcel.GetMaxColumnIndex()].BackColor | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-73899bee | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:924 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-7669af8b | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:926 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FPC0001_ExcelImportPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49c0088d | this.Load | FPC0001_ExcelImportPopup.cs:183 |  | GRID_INIT | this.AddSheet | (spdComExcel, SpdSheet.shtComExcel, SpdSheet.shtComExcel, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a136699e | this.Load | FPC0001_ExcelImportPopup.cs:184 |  | FLAG | siComExcel | GetSheetInfo(spdComExcel.Name, spdComExcel.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bdb737d9 | this.Load | FPC0001_ExcelImportPopup.cs:186 |  | GRID_INIT | siComExcel.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0001_ExcelImportPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c1ca985 | this.Load | FPC0001_ExcelImportPopup.cs:176 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0001_ExcelImportPopup.Delete_Data_Buffer

진입점: this.btnImport.Click [if (opd.ShowDialog() == DialogResult.OK) ▸ if (dtExcel != null && dtExcel.Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63df7b6a | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:754 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-e9cb4881 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:758 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8742c0cd | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:760 | try | DATA_OP | req.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-9370b3e9 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:761 | try | DATA_OP | req.Parameters["p_sys_flag"] | "DELETE_BUFFER" | 행/컬럼 값 대입 |  |  |  |
| AC-f1a7e4e7 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:762 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-52d953cb | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:763 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0860b4c2 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:768 | try ▸ for (k < iParmsCount) | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d28eb457 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:771 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-03172e87 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:786 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-341420a8 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:789 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-1e497f28 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:793 | catch ((Exception ex)) | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |

## FPC0001_ExcelImportPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1021a2e | Dispose | FPC0001_ExcelImportPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0001_ExcelImportPopup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97d27e98 | EditButton | FPC0001_ExcelImportPopup.cs:242 | if (spdComExcel.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bfa15ee5 | EditButton | FPC0001_ExcelImportPopup.cs:243 | if (spdComExcel.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FPC0001_ExcelImportPopup.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb6ffcbd | ExcelButton | FPC0001_ExcelImportPopup.cs:274 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FPC0001_ExcelImportPopup.Find_Data

진입점: this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btnFind.Click / this.Load / FindButton / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c340ef15 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0001_ExcelImportPopup.cs:282 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-097486b0 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0001_ExcelImportPopup.cs:286 | try | CALL_EXT | spdComExcel.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4dc49248 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0001_ExcelImportPopup.cs:289 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-fc9884b8 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0001_ExcelImportPopup.cs:289 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a476f7b8 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0001_ExcelImportPopup.cs:295 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-15841a1c | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0001_ExcelImportPopup.cs:298 | try | GRID_INIT | siComExcel.ChangeSheet | (SpdSheet.shtComExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-38bdd3bd | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0001_ExcelImportPopup.cs:307 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Import("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-85c06d94 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0001_ExcelImportPopup.cs:318 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siComExcel.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-dcd0d90a | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0001_ExcelImportPopup.cs:320 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-01a8c9c6 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0001_ExcelImportPopup.cs:323 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6c6dcc8a | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0001_ExcelImportPopup.cs:326 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | dtSheetData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-950f20e8 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0001_ExcelImportPopup.cs:329 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siComExcel.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-00f1e562 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0001_ExcelImportPopup.cs:337 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdComExcel.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-27fe473e | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0001_ExcelImportPopup.cs:343 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0001_ExcelImportPopup.Find_Data_Import

진입점: this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / this.btnFind.Click [try ▸ lambda] / this.Load [try ▸ lambda] / popSql.OnSql [if (programID == "SELECT_IMPORT")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22feaebd | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0001_ExcelImportPopup.cs:354 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-73807a47 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0001_ExcelImportPopup.cs:356 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-41fdf4dd | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0001_ExcelImportPopup.cs:357 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_IMPORT" | 행/컬럼 값 대입 |  |  |  |
| AC-6269ffc2 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0001_ExcelImportPopup.cs:358 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a7b6985d | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0001_ExcelImportPopup.cs:359 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1e785179 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0001_ExcelImportPopup.cs:363 | try ▸ for (i < iParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | structParam._sParamFilter[i].ToString().Equals("ALL") ? "" : structParam._sParamFilter[i].… | 행/컬럼 값 대입 |  |  |  |
| AC-a904c5a0 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0001_ExcelImportPopup.cs:367 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a929115d | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0001_ExcelImportPopup.cs:369 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-79cf57a8 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0001_ExcelImportPopup.cs:375 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FPC0001_ExcelImportPopup.Find_Data_Validation

진입점: this.btnImport.Click [if (opd.ShowDialog() == DialogResult.OK) ▸ if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ if (bFlag) ▸ try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / popSql.OnSql [else of (programID == "SELECT_IMPORT") ▸ if (programID == "SELECT_VALID")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06ee3481 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:463 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-4b5d7739 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:465 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-93f15fc7 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:466 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_VALID" | 행/컬럼 값 대입 |  |  |  |
| AC-270c65a8 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:467 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c90f5c2f | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:468 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8d9f3e4c | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:472 | try ▸ for (i < iParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | structParam._sParamFilter[i].ToString().Equals("ALL") ? "" : structParam._sParamFilter[i].… | 행/컬럼 값 대입 |  |  |  |
| AC-52d438c7 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:476 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-caac40d7 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:479 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-b9399266 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:485 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FPC0001_ExcelImportPopup.Find_Validation

진입점: this.btnImport.Click [if (opd.ShowDialog() == DialogResult.OK) ▸ if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ if (bFlag) ▸ try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5848daa7 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:384 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-71eab650 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:392 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-c71c6e86 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:392 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67834d02 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:398 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d1ae16b7 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:401 | try | GRID_INIT | siComExcel.ChangeSheet | (SpdSheet.shtComExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ce040aa2 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:408 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Validation("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-91f34cb7 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:419 | try ▸ if (dsv.Tables[0].Rows.Count > 0) | GRID_BIND | siComExcel.Query | (dsv) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3cb03cf8 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:421 | try ▸ if (dsv.Tables[0].Rows.Count > 0) | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9a7eb0ee | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:447 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-77d91c51 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:451 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0001_ExcelImportPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd3da99d | this.Load | FPC0001_ExcelImportPopup.cs:137 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-dffda048 | this.Load | FPC0001_ExcelImportPopup.cs:139 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c033d533 | this.Load | FPC0001_ExcelImportPopup.cs:150 |  | VALUE_SET | this.lblSheetName.Text | "[ " + sSheetName + " ] Excel Import" | 컨트롤 값 설정 |  |  |  |

## FPC0001_ExcelImportPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc332ea6 | this.Load | FPC0001_ExcelImportPopup.cs:158 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e6adf8c | this.Load | FPC0001_ExcelImportPopup.cs:161 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtComExcel) | 데이터 객체 조작/조회 |  |  |  |
| AC-550c644e | this.Load | FPC0001_ExcelImportPopup.cs:167 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-e656245f | this.Load | FPC0001_ExcelImportPopup.cs:168 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0a661b8e | this.Load | FPC0001_ExcelImportPopup.cs:169 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FPC0001_ExcelImportPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54876e40 | this.Load | FPC0001_ExcelImportPopup.cs:199 | try | GRID_INIT | siComExcel.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6399f1e6 | this.Load | FPC0001_ExcelImportPopup.cs:200 | try | GRID_INIT | siComExcel.ChangeActiveSheet | (SpdSheet.shtComExcel) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-50e17cab | this.Load | FPC0001_ExcelImportPopup.cs:207 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FPC0001_ExcelImportPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc773a37 | popSql.OnSql | FPC0001_ExcelImportPopup.cs:965 | if (programID == "SELECT_IMPORT") | RETURN | return Find_Data_Import("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-9e6903f3 | popSql.OnSql | FPC0001_ExcelImportPopup.cs:969 | else of (programID == "SELECT_IMPORT") ▸ if (programID == "SELECT_VALID") | RETURN | return Find_Data_Validation("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-620da3fd | popSql.OnSql | FPC0001_ExcelImportPopup.cs:976 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-5fc64041 | popSql.OnSql | FPC0001_ExcelImportPopup.cs:977 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") | UI_PROP | opd.InitialDirectory | Application.StartupPath | 속성 InitialDirectory 설정 |  |  |  |
| AC-0c9730cc | popSql.OnSql | FPC0001_ExcelImportPopup.cs:978 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") | UI_PROP | opd.Filter | "Excel files (*.xls)\|*.xls\|All files (*.*)\|*.*" | 속성 Filter 설정 |  |  |  |
| AC-111b54e9 | popSql.OnSql | FPC0001_ExcelImportPopup.cs:979 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") | UI_PROP | opd.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-6f059a66 | popSql.OnSql | FPC0001_ExcelImportPopup.cs:981 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") | POPUP | opd.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4c41e48f | popSql.OnSql | FPC0001_ExcelImportPopup.cs:985 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") ▸ if (opd.ShowDialog() ==… | COMBO_DATA | DataCommon.GetReadExcelFile | (opd.FileName, iParmsCount) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6558202e | popSql.OnSql | FPC0001_ExcelImportPopup.cs:990 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") ▸ if (opd.ShowDialog() ==… | RETURN | return Save_Data_Buffer(dtExcel,"SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-cc88f48c | popSql.OnSql | FPC0001_ExcelImportPopup.cs:1000 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ else of (programID == "INSERT_BUFFER") ▸ if (programID == "… | RETURN | return Save_Data_Excel("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-9f079b52 | popSql.OnSql | FPC0001_ExcelImportPopup.cs:1003 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FPC0001_ExcelImportPopup.Save_Buffer

진입점: this.btnImport.Click [if (opd.ShowDialog() == DialogResult.OK) ▸ if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ if (bFlag)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b3efbcd | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:640 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91db02a0 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:646 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Save_Data_Buffer(dtData, "SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bb5164f7 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:653 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "Buffer: " + ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d3823493 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:664 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cdc55be2 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:669 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |

## FPC0001_ExcelImportPopup.Save_Data

진입점: this.btnSave.Click / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-279323b9 | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:492 | if (siComExcel == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d4b34a2c | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:494 | if (siComExcel.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc123836 | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:499 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b8df3ae7 | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:500 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0043b64a | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:503 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5af20453 | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:518 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sVal… | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-00b8d48f | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:519 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sVal… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5814e400 | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:521 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sVal… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3521f3fc | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:526 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) | ENDPOINT | proxyPivot.ExecuteAsync | (() => Save_Data_Excel("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cb381270 | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:530 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-26d5a047 | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:534 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c3224876 | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:543 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1e7dd782 | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:546 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-75fa6e35 | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:550 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-915f7f91 | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:551 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-8354be32 | this.btnSave.Click 외 1 | FPC0001_ExcelImportPopup.cs:555 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FPC0001_ExcelImportPopup.Save_Data_Buffer

진입점: this.btnImport.Click [if (opd.ShowDialog() == DialogResult.OK) ▸ if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ if (bFlag) ▸ try ▸ lambda] / popSql.OnSql [else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (dtExcel != null && dtExcel.Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b3416fb | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:681 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-804cdafa | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:694 | try ▸ for (i< sParm.Length) | DATA_OP | sParm[i] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f3314a57 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:714 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-ed2c657e | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:718 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-62172397 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:720 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-e07102c3 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:721 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-df0b9922 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:722 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-859410e8 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:723 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-8af853a1 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:728 | try ▸ if (iCount > 0) ▸ for (k < iParmsCount) | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | sParm[k] | 행/컬럼 값 대입 |  |  |  |
| AC-2de5c2ff | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:730 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e7ca7c25 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:732 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-60ae4361 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:738 | try ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-6f79ba02 | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… 외 1 | FPC0001_ExcelImportPopup.cs:743 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FPC0001_ExcelImportPopup.Save_Data_Excel

진입점: this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ lambda] / popSql.OnSql [else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ else of (programID == "INSERT_BUFFER") ▸ if (programID == "INSERT_EXCEL")] / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d39024c9 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0001_ExcelImportPopup.cs:575 | try ▸ for (i < sParams.Length) | DATA_OP | sParams[i] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-51429397 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0001_ExcelImportPopup.cs:605 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-0f403185 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0001_ExcelImportPopup.cs:609 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a786e67d | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0001_ExcelImportPopup.cs:611 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-38646a49 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0001_ExcelImportPopup.cs:612 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-47181b54 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0001_ExcelImportPopup.cs:613 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-36420ab4 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0001_ExcelImportPopup.cs:614 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e6be8467 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0001_ExcelImportPopup.cs:618 | try ▸ if (iCount > 0) ▸ for (k < iParmsCount) | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | sParams[k] | 행/컬럼 값 대입 |  |  |  |
| AC-4aaa45a2 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0001_ExcelImportPopup.cs:621 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4438c1fd | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0001_ExcelImportPopup.cs:623 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-a5560150 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0001_ExcelImportPopup.cs:628 | try ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-cb741e7d | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0001_ExcelImportPopup.cs:633 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FPC0001_ExcelImportPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20663fec | SaveButton | FPC0001_ExcelImportPopup.cs:268 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FPC0001_ExcelImportPopup.SetSheetColorValidation

진입점: this.btnImport.Click [if (opd.ShowDialog() == DialogResult.OK) ▸ if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ if (bFlag) ▸ try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (dsv.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc6d1edf | this.btnImport.Click [if (opd.ShowDialog() == DialogResult.O… | FPC0001_ExcelImportPopup.cs:941 | if (siComExcel.GetMaxRowIndex() > 0) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValid.Equals("N")) | GRID_SET | siComExcel.ActiveSheet.Cells[i, 0, i, siComExcel.GetMaxColumnIndex()].BackColor | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |

## FPC0001_ExcelImportPopup.SetSheetHeaderWidth

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b0dd690 | this.Load [try] | FPC0001_ExcelImportPopup.cs:954 | for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siComExcel.ActiveSheet.Columns[idx].Width) == 0) | CALL_EXT | siComExcel.ActiveSheet.GetPreferredCellSize | (0, idx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-34e59b1f | this.Load [try] | FPC0001_ExcelImportPopup.cs:955 | for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siComExcel.ActiveSheet.Columns[idx].Width) == 0) | GRID_SET | siComExcel.ActiveSheet.Columns[idx].Width | sz.Width | 그리드 속성/값 설정 |  |  |  |

## FPC0001_ExcelImportPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b22b3bb4 | this.Load [try] | FPC0001_ExcelImportPopup.cs:215 | if (sheetName.Equals(SpdSheet.shtComExcel)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c43be6d8 | this.Load [try] | FPC0001_ExcelImportPopup.cs:216 | if (sheetName.Equals(SpdSheet.shtComExcel)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-43aa9756 | this.Load [try] | FPC0001_ExcelImportPopup.cs:220 |  | GRID_INIT | siComExcel.SetSheetHeaderColumn_FP | (siComExcel, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-3d40d727 | this.Load [try] | FPC0001_ExcelImportPopup.cs:221 |  | GRID_INIT | siComExcel.Freeze | (0, 7) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0001_ExcelImportPopup.spdComExce_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85620022 | (진입점 미연결) | FPC0001_ExcelImportPopup.cs:874 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0001_NamePopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31627922 | .ctor | FPC0001_NamePopup.cs:99 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b44cbd3e | .ctor | FPC0001_NamePopup.cs:100 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c56356bb | .ctor | FPC0001_NamePopup.cs:101 |  | FLAG | this.sDivision | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-e78aba88 | .ctor | FPC0001_NamePopup.cs:102 |  | FLAG | Filter | new SimpleFilter() | 화면 필드/플래그 변경 |  |  |  |
| AC-4dfc1d6a | .ctor | FPC0001_NamePopup.cs:109 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-6091f447 | .ctor | FPC0001_NamePopup.cs:110 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-eb24b6bf | .ctor | FPC0001_NamePopup.cs:112 |  | FLAG | this.sDivision | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-8c1e57e2 | .ctor | FPC0001_NamePopup.cs:120 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-d497226d | .ctor | FPC0001_NamePopup.cs:121 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-f252e0aa | .ctor | FPC0001_NamePopup.cs:123 |  | FLAG | this.sDivision | pDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-ebc2df7d | .ctor | FPC0001_NamePopup.cs:132 |  | FLAG | this.bCtlEnable | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-cf659696 | .ctor | FPC0001_NamePopup.cs:133 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-4db3ae67 | .ctor | FPC0001_NamePopup.cs:135 |  | FLAG | this.sDivision | pDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-fd386e18 | .ctor | FPC0001_NamePopup.cs:136 |  | FLAG | this.sSite | pSite | 화면 필드/플래그 변경 |  |  |  |
| AC-bbd77511 | .ctor | FPC0001_NamePopup.cs:137 |  | FLAG | this.sPlant | pPlant | 화면 필드/플래그 변경 |  |  |  |

## FPC0001_NamePopup.btnClear_Click

진입점: this.btnClear.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e472dd4 | this.btnClear.Click | FPC0001_NamePopup.cs:338 |  | CALL_EXT | Selected.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9eee0436 | this.btnClear.Click | FPC0001_NamePopup.cs:342 | for (p <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (p) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b7c369d1 | this.btnClear.Click | FPC0001_NamePopup.cs:346 | for (p <= siMain.GetMaxRowIndex()) ▸ if (chk_string == "TRUE" && row != null) | GRID_SET | siMain.SetText | (p, siMain.GetColumnIndex("CHK"), "") | 그리드 값 설정 |  |  |  |

## FPC0001_NamePopup.btnSelect_Click

진입점: this.btnSelect.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a574ef76 | this.btnSelect.Click | FPC0001_NamePopup.cs:356 |  | CALL_EXT | Selected.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e2ef035 | this.btnSelect.Click | FPC0001_NamePopup.cs:360 | for (p <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (p) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-960b4e67 | this.btnSelect.Click | FPC0001_NamePopup.cs:366 | for (p <= siMain.GetMaxRowIndex()) ▸ if (chk_string == "TRUE"&& row !=null) ▸ if (row_string !=null) | DATA_OP | Selected.Add | (row_string) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c152403 | this.btnSelect.Click | FPC0001_NamePopup.cs:373 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-499d0449 | this.btnSelect.Click | FPC0001_NamePopup.cs:374 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0001_NamePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4d6176a | this.Load | FPC0001_NamePopup.cs:173 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9b3256a6 | this.Load | FPC0001_NamePopup.cs:174 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8f66fc53 | this.Load | FPC0001_NamePopup.cs:175 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0001_NamePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54f6bea7 | this.Load | FPC0001_NamePopup.cs:168 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0001_NamePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f66aad3 | Dispose | FPC0001_NamePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0001_NamePopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32397501 | FindButton | FPC0001_NamePopup.cs:216 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-98535e45 | FindButton | FPC0001_NamePopup.cs:217 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-76d751d8 | FindButton | FPC0001_NamePopup.cs:219 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0001_NamePopup.FindData

진입점: this.usrButton1.Click / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc8c4c76 | this.usrButton1.Click 외 2 | FPC0001_NamePopup.cs:244 |  | DATA_OP | Filter["NICK_NAME"] | tbNickNameLike.Text | 행/컬럼 값 대입 |  |  |  |
| AC-1a044af1 | this.usrButton1.Click 외 2 | FPC0001_NamePopup.cs:245 |  | DATA_OP | Filter["NICK_NAME_LIKE"] | tbNickNameLike.Text | 행/컬럼 값 대입 |  |  |  |
| AC-75981e85 | this.usrButton1.Click 외 2 | FPC0001_NamePopup.cs:246 |  | CALL_EXT | DataService.CommonNameList | (_name_type, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ca8ced7 | this.usrButton1.Click 외 2 | FPC0001_NamePopup.cs:251 | if (init) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-f7363699 | this.usrButton1.Click 외 2 | FPC0001_NamePopup.cs:255 | if (init) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-927c1098 | this.usrButton1.Click 외 2 | FPC0001_NamePopup.cs:256 | if (init) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-aae8dba4 | this.usrButton1.Click 외 2 | FPC0001_NamePopup.cs:257 | if (init) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-9870690d | this.usrButton1.Click 외 2 | FPC0001_NamePopup.cs:265 | if (Selected != null && Selected.Count > 0) ▸ if (Selected.Count > 100) | MESSAGE | MessageBox.Show | (string.Format("There are too many selected nicknames to check({0}.\r\nDo you want to make… | 메시지 표시 |  |  |  |
| AC-c86157ad | this.usrButton1.Click 외 2 | FPC0001_NamePopup.cs:269 | if (Selected != null && Selected.Count > 0) ▸ if (Selected.Count > 100) | CALL_EXT | Selected.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4aaf4a12 | this.usrButton1.Click 외 2 | FPC0001_NamePopup.cs:277 | if (Selected != null && Selected.Count > 0) ▸ if (try_check == true) ▸ try | DATA_OP | Selected.Contains | (row.Field<string>("NAME")) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfba5e85 | this.usrButton1.Click 외 2 | FPC0001_NamePopup.cs:277 | if (Selected != null && Selected.Count > 0) ▸ if (try_check == true) ▸ try | DATA_OP | row.Field | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-b60db228 | this.usrButton1.Click 외 2 | FPC0001_NamePopup.cs:282 | if (Selected != null && Selected.Count > 0) ▸ if (try_check == true) ▸ try ▸ foreach (DataRow dm in dd) | DATA_OP | dm["CHK"] | true | 행/컬럼 값 대입 |  |  |  |
| AC-fbcc4846 | this.usrButton1.Click 외 2 | FPC0001_NamePopup.cs:289 |  | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |

## FPC0001_NamePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1de4bae5 | this.Load | FPC0001_NamePopup.cs:145 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4116673c | this.Load | FPC0001_NamePopup.cs:147 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0001_NamePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a19f4a64 | this.Load | FPC0001_NamePopup.cs:162 |  | VALUE_SET | tbNickNameLike.Text | Filter["NICK_NAME_LIKE"].ToString() | 컨트롤 값 설정 |  |  |  |

## FPC0001_NamePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2634e84 | this.Load | FPC0001_NamePopup.cs:185 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5d81f22d | this.Load | FPC0001_NamePopup.cs:186 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0001_NamePopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0c935e7 | (진입점 미연결) | FPC0001_NamePopup.cs:207 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0001_NamePopup.panelBottom_SizeChanged

진입점: this.panelBottom.SizeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ae6ae5c | this.panelBottom.SizeChanged | FPC0001_NamePopup.cs:332 |  | UI_PROP | panelBtn.Left | (panelBottom.Size.Width - panelBtn.Size.Width) / 2 | 속성 Left 설정 |  |  |  |

## FPC0001_NamePopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c48d16da | this.Load | FPC0001_NamePopup.cs:198 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6cc9323f | this.Load | FPC0001_NamePopup.cs:199 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FPC0001_SqlPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81b909c5 | Dispose | FPC0001_SqlPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

