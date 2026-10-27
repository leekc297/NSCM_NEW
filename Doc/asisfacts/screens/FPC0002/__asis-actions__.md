# AS-IS 액션 대조표 — FPC0002

> 원천: `Doc/asisfacts/screens/FPC0002/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 135행 · 메서드 18 · 종류 DATA_OP 41 · FLAG 36 · GRID_INIT 9 · UI_MISC 7 · COMBO_DATA 7 · ENDPOINT 7 · LIST_REBIND 6 · RETURN 6 · STATE 6 · UI_PROP 3 · VALUE_SET 3 · POPUP 2 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 0


## FPC0002_OperationPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65c48026 | .ctor | FPC0002_OperationPopup.cs:130 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5bf25aaa | .ctor | FPC0002_OperationPopup.cs:131 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-269e128f | .ctor | FPC0002_OperationPopup.cs:133 |  | FLAG | this.sDivision | "All" | 화면 필드/플래그 변경 |  |  |  |
| AC-b2bbb67e | .ctor | FPC0002_OperationPopup.cs:141 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-5344265e | .ctor | FPC0002_OperationPopup.cs:142 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-7399ba4b | .ctor | FPC0002_OperationPopup.cs:144 |  | FLAG | this.sDivision | "All" | 화면 필드/플래그 변경 |  |  |  |
| AC-7efb4fbb | .ctor | FPC0002_OperationPopup.cs:154 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-3fd99b6e | .ctor | FPC0002_OperationPopup.cs:155 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-e271d956 | .ctor | FPC0002_OperationPopup.cs:157 |  | FLAG | this.sDivision | pDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-0a263a83 | .ctor | FPC0002_OperationPopup.cs:166 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-fd592342 | .ctor | FPC0002_OperationPopup.cs:167 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-27393754 | .ctor | FPC0002_OperationPopup.cs:169 |  | FLAG | this.sDivision | pDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-a64de099 | .ctor | FPC0002_OperationPopup.cs:170 |  | FLAG | this.sSite | pSite | 화면 필드/플래그 변경 |  |  |  |

## FPC0002_OperationPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f3815da | this.btnButtonList.UsrButtonList_Click_Detected | FPC0002_OperationPopup.cs:512 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-f49bc85d | this.btnButtonList.UsrButtonList_Click_Detected | FPC0002_OperationPopup.cs:515 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0002_OperationPopup.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9e5ec41 | cboSite.SelectedIndexChanged | FPC0002_OperationPopup.cs:485 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-b6df39a0 | cboSite.SelectedIndexChanged | FPC0002_OperationPopup.cs:490 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-8deb9a99 | cboSite.SelectedIndexChanged | FPC0002_OperationPopup.cs:494 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-94db4376 | cboSite.SelectedIndexChanged | FPC0002_OperationPopup.cs:494 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aa8c31cb | cboSite.SelectedIndexChanged | FPC0002_OperationPopup.cs:495 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FPC0002_OperationPopup.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ae544f6 | clbDivision.SelectedIndexChanged | FPC0002_OperationPopup.cs:459 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-5670dcd1 | clbDivision.SelectedIndexChanged | FPC0002_OperationPopup.cs:462 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-7e1b8534 | clbDivision.SelectedIndexChanged | FPC0002_OperationPopup.cs:462 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aa049021 | clbDivision.SelectedIndexChanged | FPC0002_OperationPopup.cs:463 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ddf9f29a | clbDivision.SelectedIndexChanged | FPC0002_OperationPopup.cs:467 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-cddea182 | clbDivision.SelectedIndexChanged | FPC0002_OperationPopup.cs:470 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-c1a2723c | clbDivision.SelectedIndexChanged | FPC0002_OperationPopup.cs:470 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bd3666c4 | clbDivision.SelectedIndexChanged | FPC0002_OperationPopup.cs:471 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FPC0002_OperationPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7da54cf | this.Load | FPC0002_OperationPopup.cs:291 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-31a68b0b | this.Load | FPC0002_OperationPopup.cs:292 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5c6228d8 | this.Load | FPC0002_OperationPopup.cs:293 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0002_OperationPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0402cf5d | this.Load | FPC0002_OperationPopup.cs:263 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0002_OperationPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88dfc9a1 | Dispose | FPC0002_OperationPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0002_OperationPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b10c88c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:373 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4bbd32d2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:374 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-da0b9608 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:377 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f6564810 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:379 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Common.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-39312797 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:383 | lambda | ENDPOINT | new FoxDataRequest | ("FP_Common.PR_UI_COMMON_POPUP") ⇒ FP_Common.PR_UI_COMMON_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-3fb64047 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:385 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-84ab8f77 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:387 | lambda | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-6dc435f3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:388 | lambda | DATA_OP | request.Parameters["p_sys_flag"] | "OPERATION_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-15884d8c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:389 | lambda | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a583ee99 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:390 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e12a205a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:391 | lambda | DATA_OP | request.Parameters["p_non_auth"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-30fee832 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:392 | lambda | DATA_OP | request.Parameters["p_save_auth"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cfe180c7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:393 | lambda | DATA_OP | request.Parameters["p_param1"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-43339b5e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:394 | lambda | DATA_OP | request.Parameters["p_param2"] | pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-27c5a8b1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:395 | lambda | DATA_OP | request.Parameters["p_param3"] | pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-9fa921a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:396 | lambda | DATA_OP | request.Parameters["p_param4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-be1756bb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:397 | lambda | DATA_OP | request.Parameters["p_param5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-26a59822 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:398 | lambda | DATA_OP | request.Parameters["p_param6"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0fb81b6a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:399 | lambda | DATA_OP | request.Parameters["p_param7"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1b121400 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:400 | lambda | DATA_OP | request.Parameters["p_param8"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4a3dff43 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:401 | lambda | DATA_OP | request.Parameters["p_param9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-868dbed6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:402 | lambda | DATA_OP | request.Parameters["p_param10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cf22c4fd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:403 | lambda | DATA_OP | request.Parameters["p_param11"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-433d360d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:404 | lambda | DATA_OP | request.Parameters["p_param12"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f70cbb41 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:405 | lambda | DATA_OP | request.Parameters["p_param13"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0985ac80 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:406 | lambda | DATA_OP | request.Parameters["p_param14"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-59f450cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:407 | lambda | DATA_OP | request.Parameters["p_param15"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7fa5ca0f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:408 | lambda | DATA_OP | request.Parameters["p_param16"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-92b31523 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:409 | lambda | DATA_OP | request.Parameters["p_param17"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ddef878d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:410 | lambda | DATA_OP | request.Parameters["p_param18"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7566057c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:411 | lambda | DATA_OP | request.Parameters["p_param19"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bc026d1a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:412 | lambda | DATA_OP | request.Parameters["p_param20"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-91a6bb10 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:413 | lambda | DATA_OP | request.Parameters["TimeZone"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-83985ba3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:415 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d3c47271 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:417 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-971a66c8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:422 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-49a8db87 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:425 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-446186a8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:430 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-17ab79e1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0002_OperationPopup.cs:432 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0002_OperationPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8ea632d | this.Load | FPC0002_OperationPopup.cs:179 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e2c4b975 | this.Load | FPC0002_OperationPopup.cs:181 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0002_OperationPopup.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac75e9e2 | (진입점 미연결) | FPC0002_OperationPopup.cs:631 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-1901b9d4 | (진입점 미연결) | FPC0002_OperationPopup.cs:633 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-361471e9 | (진입점 미연결) | FPC0002_OperationPopup.cs:636 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FPC0002_OperationPopup.GetSpdTitle

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb17364d | (진입점 미연결) | FPC0002_OperationPopup.cs:612 |  | ENDPOINT | new FoxDataRequest | ("FP_Common.FPC0002_OperationPopup") ⇒ FP_Common.FPC0002_OperationPopup | 엔드포인트 요청 생성 |  |  |  |
| AC-5b6dfe1a | (진입점 미연결) | FPC0002_OperationPopup.cs:613 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1b4cb9ab | (진입점 미연결) | FPC0002_OperationPopup.cs:614 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a5d042c7 | (진입점 미연결) | FPC0002_OperationPopup.cs:615 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4db82a66 | (진입점 미연결) | FPC0002_OperationPopup.cs:616 |  | DATA_OP | request.Parameters["p_program_id"] | "SCM0002_40" | 행/컬럼 값 대입 |  |  |  |
| AC-bf7b27eb | (진입점 미연결) | FPC0002_OperationPopup.cs:617 |  | DATA_OP | request.Parameters["p_sheet_name"] | "ItemPopup" | 행/컬럼 값 대입 |  |  |  |
| AC-85fad24b | (진입점 미연결) | FPC0002_OperationPopup.cs:618 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-ef1f32ae | (진입점 미연결) | FPC0002_OperationPopup.cs:620 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-c8453346 | (진입점 미연결) | FPC0002_OperationPopup.cs:620 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-55ee3f7f | (진입점 미연결) | FPC0002_OperationPopup.cs:623 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## FPC0002_OperationPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27e27c6e | this.Load | FPC0002_OperationPopup.cs:209 |  | DATA_OP | this.sDivision.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-22ff8270 | this.Load | FPC0002_OperationPopup.cs:212 |  | DATA_OP | this.sSite.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-57d2a832 | this.Load | FPC0002_OperationPopup.cs:218 | if (sDivision == "All") | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-3999c22d | this.Load | FPC0002_OperationPopup.cs:218 | if (sDivision == "All") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c7624a01 | this.Load | FPC0002_OperationPopup.cs:222 | else of (sDivision == "All") | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-f5985ac5 | this.Load | FPC0002_OperationPopup.cs:222 | else of (sDivision == "All") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-99929ec7 | this.Load | FPC0002_OperationPopup.cs:225 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1eac6f51 | this.Load | FPC0002_OperationPopup.cs:226 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-3f93403a | this.Load | FPC0002_OperationPopup.cs:230 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-809156ec | this.Load | FPC0002_OperationPopup.cs:233 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-0e040307 | this.Load | FPC0002_OperationPopup.cs:233 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-38f1ef66 | this.Load | FPC0002_OperationPopup.cs:234 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e8538eb8 | this.Load | FPC0002_OperationPopup.cs:235 |  | VALUE_SET | cboSite.ControlValues | sSite | 컨트롤 값 설정 |  |  |  |
| AC-75ae784b | this.Load | FPC0002_OperationPopup.cs:239 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-ebae06e8 | this.Load | FPC0002_OperationPopup.cs:242 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-e18594e5 | this.Load | FPC0002_OperationPopup.cs:242 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-09022474 | this.Load | FPC0002_OperationPopup.cs:243 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7dce7b59 | this.Load | FPC0002_OperationPopup.cs:244 |  | VALUE_SET | cboOperation.ControlValues | sOperation | 컨트롤 값 설정 |  |  |  |
| AC-f27fbe24 | this.Load | FPC0002_OperationPopup.cs:248 | if (bCtlEnable == true) | STATE | clbDivision.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-73100c8a | this.Load | FPC0002_OperationPopup.cs:249 | if (bCtlEnable == true) | STATE | cboSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4998044c | this.Load | FPC0002_OperationPopup.cs:250 | if (bCtlEnable == true) | STATE | cboOperation.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-808dbf75 | this.Load | FPC0002_OperationPopup.cs:254 | else of (bCtlEnable == true) | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fef5fbc0 | this.Load | FPC0002_OperationPopup.cs:255 | else of (bCtlEnable == true) | STATE | cboSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-63eb329b | this.Load | FPC0002_OperationPopup.cs:256 | else of (bCtlEnable == true) | STATE | cboOperation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FPC0002_OperationPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c8cea67 | this.Load | FPC0002_OperationPopup.cs:303 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-20c401f3 | this.Load | FPC0002_OperationPopup.cs:304 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0002_OperationPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68c16055 | (진입점 미연결) | FPC0002_OperationPopup.cs:326 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0002_OperationPopup.SetLineInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c10afe5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0002_OperationPopup.cs:555 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d46af08a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0002_OperationPopup.cs:556 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-70e09f35 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0002_OperationPopup.cs:558 |  | FLAG | _CompanyId | this.dtFindData.Rows[iClick_Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3c6e4cf5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0002_OperationPopup.cs:559 |  | FLAG | _DivisionId | this.dtFindData.Rows[iClick_Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-96862f8d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0002_OperationPopup.cs:560 |  | FLAG | _SiteId | this.dtFindData.Rows[iClick_Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-180b49d8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0002_OperationPopup.cs:561 |  | FLAG | _OperationId | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4b9ce67a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0002_OperationPopup.cs:562 |  | FLAG | _OperationGroupId | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_GROUP_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b8abfc51 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0002_OperationPopup.cs:565 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0002_OperationPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5aa6280a | this.Load | FPC0002_OperationPopup.cs:311 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b43c0891 | this.Load | FPC0002_OperationPopup.cs:312 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-07da4cf4 | this.Load | FPC0002_OperationPopup.cs:316 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-ada1f7b5 | this.Load | FPC0002_OperationPopup.cs:317 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.OPERATION_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0002_OperationPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85b21b9e | this.spdMain.CellClick | FPC0002_OperationPopup.cs:526 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0002_OperationPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-043ba548 | this.spdMain.CellDoubleClick | FPC0002_OperationPopup.cs:531 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-c3c3e61f | this.spdMain.CellDoubleClick | FPC0002_OperationPopup.cs:533 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-37f897ae | this.spdMain.CellDoubleClick | FPC0002_OperationPopup.cs:535 |  | FLAG | _CompanyId | this.dtFindData.Rows[e.Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6976775a | this.spdMain.CellDoubleClick | FPC0002_OperationPopup.cs:536 |  | FLAG | _DivisionId | this.dtFindData.Rows[e.Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-42ec9926 | this.spdMain.CellDoubleClick | FPC0002_OperationPopup.cs:537 |  | FLAG | _SiteId | this.dtFindData.Rows[e.Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d6635fdf | this.spdMain.CellDoubleClick | FPC0002_OperationPopup.cs:538 |  | FLAG | _OperationId | this.dtFindData.Rows[e.Row][DefColumns.OPERATION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7cf4b2fe | this.spdMain.CellDoubleClick | FPC0002_OperationPopup.cs:539 |  | FLAG | _OperationGroupId | this.dtFindData.Rows[e.Row][DefColumns.OPERATION_GROUP_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c3c2a0ff | this.spdMain.CellDoubleClick | FPC0002_OperationPopup.cs:544 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

