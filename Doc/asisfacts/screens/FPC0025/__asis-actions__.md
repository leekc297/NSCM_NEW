# AS-IS 액션 대조표 — FPC0025

> 원천: `Doc/asisfacts/screens/FPC0025/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 117행 · 메서드 17 · 종류 FLAG 37 · DATA_OP 33 · GRID_INIT 9 · UI_MISC 7 · UI_PROP 6 · COMBO_DATA 6 · LIST_REBIND 6 · RETURN 4 · ENDPOINT 3 · POPUP 2 · VALUE_SET 2 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 0


## FPC0025_WorkCenterOperationPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b33cf385 | .ctor | FPC0025_WorkCenterOperationPopup.cs:151 |  | FLAG | this.sSite | pSite | 화면 필드/플래그 변경 |  |  |  |
| AC-b9c3785c | .ctor | FPC0025_WorkCenterOperationPopup.cs:152 |  | FLAG | this.sNoFactory | pNoFactory | 화면 필드/플래그 변경 |  |  |  |
| AC-407a956f | .ctor | FPC0025_WorkCenterOperationPopup.cs:153 |  | FLAG | this.bFactoryVisibility | bFactoryDisplay | 화면 필드/플래그 변경 |  |  |  |
| AC-57a0f5f4 | .ctor | FPC0025_WorkCenterOperationPopup.cs:155 |  | UI_PROP | SpdSheet.shtMain | pSheetName | 속성 shtMain 설정 |  |  |  |
| AC-100f5b5b | .ctor | FPC0025_WorkCenterOperationPopup.cs:158 | if (pSheetName.Equals("WorkCenterOperationFactory")) | FLAG | sSysFlag | "WORKCENTER_OPERATION_FACTORY" | 화면 필드/플래그 변경 |  |  |  |
| AC-4432bc09 | .ctor | FPC0025_WorkCenterOperationPopup.cs:160 | else of (pSheetName.Equals("WorkCenterOperationFactory")) | FLAG | sSysFlag | "WORKCENTER_OPERATION_FACTORY_NONE" | 화면 필드/플래그 변경 |  |  |  |

## FPC0025_WorkCenterOperationPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebfa1ab0 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0025_WorkCenterOperationPopup.cs:451 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-505168d2 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0025_WorkCenterOperationPopup.cs:454 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0025_WorkCenterOperationPopup.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e9270d1 | cboSite.SelectedIndexChanged | FPC0025_WorkCenterOperationPopup.cs:429 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-88d3dc03 | cboSite.SelectedIndexChanged | FPC0025_WorkCenterOperationPopup.cs:434 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-49d2c86b | cboSite.SelectedIndexChanged | FPC0025_WorkCenterOperationPopup.cs:438 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-e3a1f218 | cboSite.SelectedIndexChanged | FPC0025_WorkCenterOperationPopup.cs:438 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ef248274 | cboSite.SelectedIndexChanged | FPC0025_WorkCenterOperationPopup.cs:439 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, cboFactory, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FPC0025_WorkCenterOperationPopup.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-265e1792 | clbDivision.SelectedIndexChanged | FPC0025_WorkCenterOperationPopup.cs:403 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-58c77306 | clbDivision.SelectedIndexChanged | FPC0025_WorkCenterOperationPopup.cs:406 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-64a29e23 | clbDivision.SelectedIndexChanged | FPC0025_WorkCenterOperationPopup.cs:406 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e68cb125 | clbDivision.SelectedIndexChanged | FPC0025_WorkCenterOperationPopup.cs:407 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9cbd4d75 | clbDivision.SelectedIndexChanged | FPC0025_WorkCenterOperationPopup.cs:411 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-28184b47 | clbDivision.SelectedIndexChanged | FPC0025_WorkCenterOperationPopup.cs:414 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-89cade32 | clbDivision.SelectedIndexChanged | FPC0025_WorkCenterOperationPopup.cs:414 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a6b42d3a | clbDivision.SelectedIndexChanged | FPC0025_WorkCenterOperationPopup.cs:415 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, cboFactory, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FPC0025_WorkCenterOperationPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad22bbed | this.Load | FPC0025_WorkCenterOperationPopup.cs:267 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1882a602 | this.Load | FPC0025_WorkCenterOperationPopup.cs:268 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-193fcfa2 | this.Load | FPC0025_WorkCenterOperationPopup.cs:269 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0025_WorkCenterOperationPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0403c17a | this.Load | FPC0025_WorkCenterOperationPopup.cs:239 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0025_WorkCenterOperationPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5cb323a | Dispose | FPC0025_WorkCenterOperationPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0025_WorkCenterOperationPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03c4c60b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:317 |  | FLAG | this.sDivision | CString.GetCheckedListValue(dtMyDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-a0f781e2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:318 |  | FLAG | this.sSite | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-91ce23b2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:319 |  | FLAG | this.sFactory | CString.GetCheckedListValue(dtFactory, cboFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-c6bd552d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:320 |  | FLAG | this.sOperation | txtOperation.Text.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-42361c64 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:325 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-29d6eb02 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:326 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b7a8c51c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:329 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f20af1b6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:331 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Common.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c25eadb1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:335 | lambda | ENDPOINT | new FoxDataRequest | ("FP_Common.PR_UI_COMMON_POPUP") ⇒ FP_Common.PR_UI_COMMON_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-a4e2a846 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:337 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-97ccd99e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:339 | lambda | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-61b2733b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:340 | lambda | DATA_OP | request.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-0525a7db | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:341 | lambda | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-818ffc56 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:342 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-010534c1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:343 | lambda | DATA_OP | request.Parameters["p_non_auth"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a5069669 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:344 | lambda | DATA_OP | request.Parameters["p_save_auth"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-aabb2277 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:345 | lambda | DATA_OP | request.Parameters["p_param1"] | sCompany | 행/컬럼 값 대입 |  |  |  |
| AC-1421c943 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:346 | lambda | DATA_OP | request.Parameters["p_param2"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a2c6aac9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:347 | lambda | DATA_OP | request.Parameters["p_param3"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-5b97a5ae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:348 | lambda | DATA_OP | request.Parameters["p_param4"] | sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-9f7f874b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:349 | lambda | DATA_OP | request.Parameters["p_param5"] | sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-315b8f42 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:350 | lambda | DATA_OP | request.Parameters["p_param6"] | sNoFactory | 행/컬럼 값 대입 |  |  |  |
| AC-604b341a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:351 | lambda | DATA_OP | request.Parameters["p_param7"] | sOperation | 행/컬럼 값 대입 |  |  |  |
| AC-51dbdf86 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:352 | lambda | DATA_OP | request.Parameters["p_param8"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-f0a55856 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:353 | lambda | DATA_OP | request.Parameters["p_param9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-feb009ca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:354 | lambda | DATA_OP | request.Parameters["p_param10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3daadefb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:355 | lambda | DATA_OP | request.Parameters["p_param11"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6433e8af | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:356 | lambda | DATA_OP | request.Parameters["p_param12"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5790ea46 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:357 | lambda | DATA_OP | request.Parameters["p_param13"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ffadc872 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:358 | lambda | DATA_OP | request.Parameters["p_param14"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5261bcbe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:359 | lambda | DATA_OP | request.Parameters["p_param15"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-74718f37 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:360 | lambda | DATA_OP | request.Parameters["p_param16"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-48992f5b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:361 | lambda | DATA_OP | request.Parameters["p_param17"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fdf92914 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:362 | lambda | DATA_OP | request.Parameters["p_param18"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f70c1088 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:363 | lambda | DATA_OP | request.Parameters["p_param19"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-edffd1c3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:364 | lambda | DATA_OP | request.Parameters["p_param20"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4f64f261 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:365 | lambda | DATA_OP | request.Parameters["TimeZone"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-853862cf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:367 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-22e0d1e1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:369 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-42691eae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:374 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3a623399 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:377 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-abda0ad7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:382 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-2337586f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:384 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0025_WorkCenterOperationPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff360622 | this.Load | FPC0025_WorkCenterOperationPopup.cs:169 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-60bc6eae | this.Load | FPC0025_WorkCenterOperationPopup.cs:171 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0025_WorkCenterOperationPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2acd807c | this.Load | FPC0025_WorkCenterOperationPopup.cs:200 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-f35894c4 | this.Load | FPC0025_WorkCenterOperationPopup.cs:202 | if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-5b2564b9 | this.Load | FPC0025_WorkCenterOperationPopup.cs:205 |  | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-265a73ef | this.Load | FPC0025_WorkCenterOperationPopup.cs:205 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4ecc403f | this.Load | FPC0025_WorkCenterOperationPopup.cs:206 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-2deab3d8 | this.Load | FPC0025_WorkCenterOperationPopup.cs:209 | if (!string.IsNullOrEmpty(sDivision)) | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-1e99cd71 | this.Load | FPC0025_WorkCenterOperationPopup.cs:213 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-2a08eeaa | this.Load | FPC0025_WorkCenterOperationPopup.cs:216 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-19603854 | this.Load | FPC0025_WorkCenterOperationPopup.cs:216 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9edaa5e2 | this.Load | FPC0025_WorkCenterOperationPopup.cs:217 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-080b9116 | this.Load | FPC0025_WorkCenterOperationPopup.cs:220 | if (!string.IsNullOrEmpty(sSite)) | VALUE_SET | cboSite.ControlValues | sSite | 컨트롤 값 설정 |  |  |  |
| AC-a3730b72 | this.Load | FPC0025_WorkCenterOperationPopup.cs:224 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb547f52 | this.Load | FPC0025_WorkCenterOperationPopup.cs:228 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-dbb50ff2 | this.Load | FPC0025_WorkCenterOperationPopup.cs:228 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-99ade3db | this.Load | FPC0025_WorkCenterOperationPopup.cs:229 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, cboFactory, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8a7f3564 | this.Load | FPC0025_WorkCenterOperationPopup.cs:233 | if (this.bFactoryVisibility==false) | UI_PROP | lblFactory.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FPC0025_WorkCenterOperationPopup.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34eae22c | this.Load | FPC0025_WorkCenterOperationPopup.cs:244 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FPC0025_WorkCenterOperationPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3a618c5 | this.Load | FPC0025_WorkCenterOperationPopup.cs:279 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-55617539 | this.Load | FPC0025_WorkCenterOperationPopup.cs:280 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0025_WorkCenterOperationPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b540b54 | (진입점 미연결) | FPC0025_WorkCenterOperationPopup.cs:302 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0025_WorkCenterOperationPopup.SetOperationInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-100a0a0f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:496 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec159593 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:497 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-928d213e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:499 |  | FLAG | _CompanyId | this.dtFindData.Rows[iClick_Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-45cade62 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:500 |  | FLAG | _DivisionId | this.dtFindData.Rows[iClick_Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5ff8efe0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:501 |  | FLAG | _SiteId | this.dtFindData.Rows[iClick_Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-93ed5fce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:502 |  | FLAG | _PlantId | this.dtFindData.Rows[iClick_Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f71ed336 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:503 |  | FLAG | _FactoryId | this.dtFindData.Rows[iClick_Row][DefColumns.FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-aa58ca12 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:504 |  | FLAG | _OperationId | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3153a6d0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:505 |  | FLAG | _OperationName | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-576bf272 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:506 |  | FLAG | _OperationGroupId | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_GROUP_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b10be984 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0025_WorkCenterOperationPopup.cs:509 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0025_WorkCenterOperationPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f42cd3d3 | this.Load | FPC0025_WorkCenterOperationPopup.cs:287 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-867b4969 | this.Load | FPC0025_WorkCenterOperationPopup.cs:288 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-40365cb5 | this.Load | FPC0025_WorkCenterOperationPopup.cs:292 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-2fe735ad | this.Load | FPC0025_WorkCenterOperationPopup.cs:293 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.OPERATION_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0025_WorkCenterOperationPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-164c7282 | this.spdMain.CellClick | FPC0025_WorkCenterOperationPopup.cs:465 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0025_WorkCenterOperationPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40c8c46a | this.spdMain.CellDoubleClick | FPC0025_WorkCenterOperationPopup.cs:470 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-efed05d8 | this.spdMain.CellDoubleClick | FPC0025_WorkCenterOperationPopup.cs:472 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f3c3e61 | this.spdMain.CellDoubleClick | FPC0025_WorkCenterOperationPopup.cs:474 |  | FLAG | _CompanyId | this.dtFindData.Rows[e.Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3d88d10d | this.spdMain.CellDoubleClick | FPC0025_WorkCenterOperationPopup.cs:475 |  | FLAG | _DivisionId | this.dtFindData.Rows[e.Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-293690c1 | this.spdMain.CellDoubleClick | FPC0025_WorkCenterOperationPopup.cs:476 |  | FLAG | _SiteId | this.dtFindData.Rows[e.Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-67d59493 | this.spdMain.CellDoubleClick | FPC0025_WorkCenterOperationPopup.cs:477 |  | FLAG | _PlantId | this.dtFindData.Rows[e.Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-abf70df1 | this.spdMain.CellDoubleClick | FPC0025_WorkCenterOperationPopup.cs:478 |  | FLAG | _FactoryId | this.dtFindData.Rows[e.Row][DefColumns.FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-335dba62 | this.spdMain.CellDoubleClick | FPC0025_WorkCenterOperationPopup.cs:479 |  | FLAG | _OperationId | this.dtFindData.Rows[e.Row][DefColumns.OPERATION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f1d0d329 | this.spdMain.CellDoubleClick | FPC0025_WorkCenterOperationPopup.cs:480 |  | FLAG | _OperationGroupId | this.dtFindData.Rows[e.Row][DefColumns.OPERATION_GROUP_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-374f5b22 | this.spdMain.CellDoubleClick | FPC0025_WorkCenterOperationPopup.cs:485 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

