# AS-IS 액션 대조표 — FP00518

> 원천: `Doc/asisfacts/screens/FP00518/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 548행 · 메서드 65 · 종류 DATA_OP 162 · FLAG 91 · RETURN 41 · GRID_SET 35 · UI_PROP 28 · GRID_INIT 27 · COMBO_DATA 23 · UI_MISC 20 · LIST_REBIND 19 · POPUP 18 · MESSAGE 15 · GRID_LOCK 14 · ENDPOINT 13 · STATE 10 · GRID_STYLE 7 · VALUE_SET 6 · THROW 5 · GRID_BIND 4 · CALL_BASE 3 · VALIDATE 3 · CALL_EXT 2 · STATE_RESET 1 · EXCEL 1 · ⚠ 의미 확인 필요 5


## FP00518_ItemPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e9bfe0b | .ctor | FP00518_ItemPopup.cs:134 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-39afd378 | .ctor | FP00518_ItemPopup.cs:135 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6445389a | .ctor | FP00518_ItemPopup.cs:136 |  | FLAG | this.sDivision | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-0c955010 | .ctor | FP00518_ItemPopup.cs:144 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-bfc6bf51 | .ctor | FP00518_ItemPopup.cs:145 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-dced2c3a | .ctor | FP00518_ItemPopup.cs:147 |  | FLAG | this.sDivision | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-46491d66 | .ctor | FP00518_ItemPopup.cs:155 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-c92ec339 | .ctor | FP00518_ItemPopup.cs:156 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-48ba6b0e | .ctor | FP00518_ItemPopup.cs:158 |  | FLAG | this.sDivision | pDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-dce6e0ec | .ctor | FP00518_ItemPopup.cs:167 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-12147c9f | .ctor | FP00518_ItemPopup.cs:168 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-025b6c54 | .ctor | FP00518_ItemPopup.cs:170 |  | FLAG | this.sDivision | pDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-522fc538 | .ctor | FP00518_ItemPopup.cs:171 |  | FLAG | this.sSite | pSite | 화면 필드/플래그 변경 |  |  |  |
| AC-fd1a7887 | .ctor | FP00518_ItemPopup.cs:172 |  | FLAG | this.sPlant | pPlant | 화면 필드/플래그 변경 |  |  |  |

## FP00518_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e86e4de3 | this.btnButtonList.UsrButtonList_Click_Detected | FP00518_ItemPopup.cs:506 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-b65d39e4 | this.btnButtonList.UsrButtonList_Click_Detected | FP00518_ItemPopup.cs:509 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00518_ItemPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33c5a3e1 | this.btnSql.Click | FP00518_ItemPopup.cs:317 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c2c721de | this.btnSql.Click | FP00518_ItemPopup.cs:318 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-eb5c1cff | this.btnSql.Click | FP00518_ItemPopup.cs:320 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00518_SELECT_ITEMPOPUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-48226f21 | this.btnSql.Click | FP00518_ItemPopup.cs:321 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00518_ItemPopup.cboSite_SelectedIndexChanged

진입점: this.cboSite.SelectedIndexChanged / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-100f447c | this.cboSite.SelectedIndexChanged 외 1 | FP00518_ItemPopup.cs:484 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-170a9b86 | this.cboSite.SelectedIndexChanged 외 1 | FP00518_ItemPopup.cs:489 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-64bc41c4 | this.cboSite.SelectedIndexChanged 외 1 | FP00518_ItemPopup.cs:493 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-4f887391 | this.cboSite.SelectedIndexChanged 외 1 | FP00518_ItemPopup.cs:493 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c506e42a | this.cboSite.SelectedIndexChanged 외 1 | FP00518_ItemPopup.cs:494 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, cboPlant, true,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00518_ItemPopup.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-199e5cc1 | this.clbDivision.SelectedIndexChanged 외 1 | FP00518_ItemPopup.cs:456 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb2b371f | this.clbDivision.SelectedIndexChanged 외 1 | FP00518_ItemPopup.cs:459 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-13983d1f | this.clbDivision.SelectedIndexChanged 외 1 | FP00518_ItemPopup.cs:459 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aa2cbdd8 | this.clbDivision.SelectedIndexChanged 외 1 | FP00518_ItemPopup.cs:460 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-22bebcfa | this.clbDivision.SelectedIndexChanged 외 1 | FP00518_ItemPopup.cs:464 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-ded40407 | this.clbDivision.SelectedIndexChanged 외 1 | FP00518_ItemPopup.cs:467 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-d7b080bd | this.clbDivision.SelectedIndexChanged 외 1 | FP00518_ItemPopup.cs:467 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ff46e89d | this.clbDivision.SelectedIndexChanged 외 1 | FP00518_ItemPopup.cs:468 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, cboPlant, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00518_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c5ebc5e | this.Load | FP00518_ItemPopup.cs:268 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4abf26a2 | this.Load | FP00518_ItemPopup.cs:269 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-924e3966 | this.Load | FP00518_ItemPopup.cs:270 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00518_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98b21f61 | this.Load | FP00518_ItemPopup.cs:256 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00518_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7aa0af44 | Dispose | FP00518_ItemPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00518_ItemPopup.Find_Data_Item

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ lambda] / this.Load [try ▸ lambda] / popSql.OnSql [if (programID == "PR_UI_FP00518_SELECT_ITEMPOPUP")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ee91388 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:374 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pDivisionID = CString.GetCheckedListValue(dtMyDivision, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-73073d34 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:384 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00518_SHIPPING_PLAN") ⇒ FP_Master.PR_UI_FP00518_SHIPPING_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-f6806cf5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:386 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ff675eb6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:388 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-32caf2c1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:389 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_ITEM_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-60d5ccec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:390 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bc4bd137 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:391 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-03c9ddcc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:393 | try | DATA_OP | request.Parameters["p_instance_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7c721423 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:394 | try | DATA_OP | request.Parameters["p_instance_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-13c77048 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:395 | try | DATA_OP | request.Parameters["p_version_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7ac6ba5a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:396 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-88174aa4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:397 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-8a7efe71 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:398 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-27d7a406 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:399 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-5a0245db | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:400 | try | DATA_OP | request.Parameters["p_item_id"] | pItemID | 행/컬럼 값 대입 |  |  |  |
| AC-45c41fc9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:401 | try | DATA_OP | request.Parameters["p_item_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ac89f998 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:402 | try | DATA_OP | request.Parameters["p_production_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-31b511e7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:403 | try | DATA_OP | request.Parameters["p_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f532c7a5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:404 | try | DATA_OP | request.Parameters["p_transport_mode"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c810929a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:405 | try | DATA_OP | request.Parameters["p_to_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d46e040d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:406 | try | DATA_OP | request.Parameters["p_to_plant_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a2960c11 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:407 | try | DATA_OP | request.Parameters["p_ship_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c49cbbbe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:408 | try | DATA_OP | request.Parameters["p_eta"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-532cadf0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:409 | try | DATA_OP | request.Parameters["p_ship_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bdcb8ba8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:410 | try | DATA_OP | request.Parameters["p_pkg_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-19da14ee | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:411 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8a175ea1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:412 | try | DATA_OP | request.Parameters["p_cell_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bb6923ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:413 | try | DATA_OP | request.Parameters["p_start_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5aae541f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:414 | try | DATA_OP | request.Parameters["p_end_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c2da0307 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:415 | try | DATA_OP | request.Parameters["p_wpp_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cf78929c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:416 | try | DATA_OP | request.Parameters["p_wpp_week"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-87b719ac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:417 | try | DATA_OP | request.Parameters["p_wpp_seq"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0d282581 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:419 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-927f12a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:422 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-35671bb9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_ItemPopup.cs:427 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00518_ItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-587ee9f8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_ItemPopup.cs:335 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6845ee25 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_ItemPopup.cs:336 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f61d6440 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_ItemPopup.cs:339 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Item("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-838df877 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_ItemPopup.cs:345 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cfc1003b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_ItemPopup.cs:348 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-624e745a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_ItemPopup.cs:350 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-50690c29 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_ItemPopup.cs:356 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-edb2d85f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_ItemPopup.cs:361 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00518_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1c7850a | this.Load | FP00518_ItemPopup.cs:180 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e93a4f66 | this.Load | FP00518_ItemPopup.cs:182 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00518_ItemPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec1ee54e | this.Load | FP00518_ItemPopup.cs:208 |  | DATA_OP | this.sDivision.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-2929f5ee | this.Load | FP00518_ItemPopup.cs:212 |  | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-7dc1a40a | this.Load | FP00518_ItemPopup.cs:212 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-240b1a71 | this.Load | FP00518_ItemPopup.cs:214 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2ce03b50 | this.Load | FP00518_ItemPopup.cs:216 | if (!string.IsNullOrEmpty(sDivision)) | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-865ea9bb | this.Load | FP00518_ItemPopup.cs:220 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-89453ec9 | this.Load | FP00518_ItemPopup.cs:224 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-f9ef5543 | this.Load | FP00518_ItemPopup.cs:224 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2fb11eae | this.Load | FP00518_ItemPopup.cs:225 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-993b0c2f | this.Load | FP00518_ItemPopup.cs:227 | if (!string.IsNullOrEmpty(sSite)) | VALUE_SET | cboSite.SelectedValue | sSite | 컨트롤 값 설정 |  |  |  |
| AC-d20c4298 | this.Load | FP00518_ItemPopup.cs:230 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d307497 | this.Load | FP00518_ItemPopup.cs:233 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-163d55e7 | this.Load | FP00518_ItemPopup.cs:233 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5c347b02 | this.Load | FP00518_ItemPopup.cs:234 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, cboPlant, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-61820bbf | this.Load | FP00518_ItemPopup.cs:236 | if (!string.IsNullOrEmpty(sPlant)) | VALUE_SET | cboPlant.SelectedValue | sPlant | 컨트롤 값 설정 |  |  |  |
| AC-fb371b70 | this.Load | FP00518_ItemPopup.cs:241 | if (bCtlEnable == true) | STATE | clbDivision.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cbc30c47 | this.Load | FP00518_ItemPopup.cs:242 | if (bCtlEnable == true) | STATE | cboSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c0514c2d | this.Load | FP00518_ItemPopup.cs:243 | if (bCtlEnable == true) | STATE | cboPlant.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-67a14e93 | this.Load | FP00518_ItemPopup.cs:247 | else of (bCtlEnable == true) | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ba4ebcea | this.Load | FP00518_ItemPopup.cs:248 | else of (bCtlEnable == true) | STATE | cboSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e8a17eab | this.Load | FP00518_ItemPopup.cs:249 | else of (bCtlEnable == true) | STATE | cboPlant.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP00518_ItemPopup.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66eb50d6 | this.Load | FP00518_ItemPopup.cs:261 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00518_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-443b71f0 | this.Load | FP00518_ItemPopup.cs:280 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-db5525c8 | this.Load | FP00518_ItemPopup.cs:281 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00518_ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-143777a7 | (진입점 미연결) | FP00518_ItemPopup.cs:302 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00518_ItemPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f852df9 | popSql.OnSql | FP00518_ItemPopup.cs:565 | if (programID == "PR_UI_FP00518_SELECT_ITEMPOPUP") | RETURN | return Find_Data_Item("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-d00a6721 | popSql.OnSql | FP00518_ItemPopup.cs:567 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00518_ItemPopup.SetLineInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a497b562 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00518_ItemPopup.cs:547 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-47891554 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00518_ItemPopup.cs:548 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-801fa16b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00518_ItemPopup.cs:549 |  | FLAG | _CompanyId | this.dtFindData.Rows[iClick_Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-09a3d7b7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00518_ItemPopup.cs:550 |  | FLAG | _DivisionId | this.dtFindData.Rows[iClick_Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7570b88f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00518_ItemPopup.cs:551 |  | FLAG | _SiteId | this.dtFindData.Rows[iClick_Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f8a77434 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00518_ItemPopup.cs:552 |  | FLAG | _PlantId | this.dtFindData.Rows[iClick_Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9864aa91 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00518_ItemPopup.cs:553 |  | FLAG | _ItemId | this.dtFindData.Rows[iClick_Row][DefColumns.ITEM_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-69a6a89b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00518_ItemPopup.cs:554 |  | FLAG | _ItemName | this.dtFindData.Rows[iClick_Row][DefColumns.NICK_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-45684d48 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00518_ItemPopup.cs:557 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00518_ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f670228 | this.Load | FP00518_ItemPopup.cs:287 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8556c144 | this.Load | FP00518_ItemPopup.cs:288 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-9186e348 | this.Load | FP00518_ItemPopup.cs:292 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-63b14632 | this.Load | FP00518_ItemPopup.cs:293 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.SITE_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00518_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eeb7ce88 | this.spdMain.CellClick | FP00518_ItemPopup.cs:520 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00518_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e8c93a0 | this.spdMain.CellDoubleClick | FP00518_ItemPopup.cs:525 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-ce4bbcd2 | this.spdMain.CellDoubleClick | FP00518_ItemPopup.cs:527 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aabc2bd7 | this.spdMain.CellDoubleClick | FP00518_ItemPopup.cs:529 |  | FLAG | _CompanyId | this.dtFindData.Rows[e.Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-86b5e31b | this.spdMain.CellDoubleClick | FP00518_ItemPopup.cs:530 |  | FLAG | _DivisionId | this.dtFindData.Rows[e.Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8d0455d3 | this.spdMain.CellDoubleClick | FP00518_ItemPopup.cs:531 |  | FLAG | _SiteId | this.dtFindData.Rows[e.Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6a977762 | this.spdMain.CellDoubleClick | FP00518_ItemPopup.cs:532 |  | FLAG | _PlantId | this.dtFindData.Rows[e.Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-51090de9 | this.spdMain.CellDoubleClick | FP00518_ItemPopup.cs:533 |  | FLAG | _ItemId | this.dtFindData.Rows[e.Row][DefColumns.ITEM_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6546961c | this.spdMain.CellDoubleClick | FP00518_ItemPopup.cs:534 |  | FLAG | _ItemName | this.dtFindData.Rows[e.Row][DefColumns.NICK_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7a1b5379 | this.spdMain.CellDoubleClick | FP00518_ItemPopup.cs:537 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00518_Shipping_Plan.btnCreateWPP_Click

진입점: this.btnCreateWPP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1781a99 | this.btnCreateWPP.Click | FP00518_Shipping_Plan.cs:516 | if (bWPPMode == true \|\| chkWPP.Checked == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f9fcaa6f | this.btnCreateWPP.Click | FP00518_Shipping_Plan.cs:517 | if (bWPPMode == true \|\| chkWPP.Checked == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0907d3bf | this.btnCreateWPP.Click | FP00518_Shipping_Plan.cs:520 |  | MESSAGE | MessageBox.Show | ("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", Messa… | 메시지 표시 |  |  |  |
| AC-fa5c5e44 | this.btnCreateWPP.Click | FP00518_Shipping_Plan.cs:524 | if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) | FLAG | dtNewVersion | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00518_find_WPP_newVersion", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-c795ec62 | this.btnCreateWPP.Click | FP00518_Shipping_Plan.cs:524 | if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00518_find_WPP_newVersion", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f4419109 | this.btnCreateWPP.Click | FP00518_Shipping_Plan.cs:541 | if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) ▸ if (dtNewVe… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-11b81d86 | this.btnCreateWPP.Click | FP00518_Shipping_Plan.cs:550 | if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) ▸ if (dtNewVe… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-963fcda1 | this.btnCreateWPP.Click | FP00518_Shipping_Plan.cs:556 | if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) ▸ else of (dt… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-005659c9 | this.btnCreateWPP.Click | FP00518_Shipping_Plan.cs:557 | if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) ▸ else of (dt… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48fc62e2 | this.btnCreateWPP.Click | FP00518_Shipping_Plan.cs:562 | else of (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00518_Shipping_Plan.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63dd81f5 | this.btnImport.Click | FP00518_Shipping_Plan.cs:601 | try | FLAG | dtNewVersion | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00518_find_newVersion", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-20d78c10 | this.btnImport.Click | FP00518_Shipping_Plan.cs:601 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00518_find_newVersion", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-15407f9e | this.btnImport.Click | FP00518_Shipping_Plan.cs:615 | try ▸ if (bWPPMode == true \|\| chkWPP.Checked == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-afd60076 | this.btnImport.Click | FP00518_Shipping_Plan.cs:616 | try ▸ if (bWPPMode == true \|\| chkWPP.Checked == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd5ee985 | this.btnImport.Click | FP00518_Shipping_Plan.cs:639 | try ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-b2a18a04 | this.btnImport.Click | FP00518_Shipping_Plan.cs:643 | try | POPUP | new FPC0100_ExcelImportPopup | ("FPC0100", "ShippingPlanImportPopup", "FP_Master.PR_UI_FP00518_SHIPPING_PLAN_EXCEL", sPar… | 팝업/폼 생성 |  |  |  |
| AC-437be975 | this.btnImport.Click | FP00518_Shipping_Plan.cs:644 | try | UI_PROP | popTestImport.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c3b3ec29 | this.btnImport.Click | FP00518_Shipping_Plan.cs:645 | try | POPUP | popTestImport.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00518_Shipping_Plan.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d829847 | this.btnSql.Click | FP00518_Shipping_Plan.cs:570 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0abe137a | this.btnSql.Click | FP00518_Shipping_Plan.cs:571 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f7ab0ebf | this.btnSql.Click | FP00518_Shipping_Plan.cs:573 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00518_SHIPPING_PLAN_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-31cb2a97 | this.btnSql.Click | FP00518_Shipping_Plan.cs:574 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00518_SHIPPING_PLAN_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a29aa305 | this.btnSql.Click | FP00518_Shipping_Plan.cs:575 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00518_Shipping_Plan.CboPlanGroup_SelectedIndexChanged

진입점: cboPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-136be6fb | cboPlanGroup.SelectedIndexChanged | FP00518_Shipping_Plan.cs:1211 |  | FLAG | dtCurrVersion | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00518_find_currVersion", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-d7c762c8 | cboPlanGroup.SelectedIndexChanged | FP00518_Shipping_Plan.cs:1211 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00518_find_currVersion", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2fa501de | cboPlanGroup.SelectedIndexChanged | FP00518_Shipping_Plan.cs:1215 | if (dtCurrVersion.Rows.Count > 0) | FLAG | _sInstanceDate | dtCurrVersion.Rows[0]["INSTANCE_DATE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-894c75d3 | cboPlanGroup.SelectedIndexChanged | FP00518_Shipping_Plan.cs:1216 | if (dtCurrVersion.Rows.Count > 0) | FLAG | _sVersion | dtCurrVersion.Rows[0]["VERSION_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |

## FP00518_Shipping_Plan.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40001656 | cboSite.SelectedIndexChanged | FP00518_Shipping_Plan.cs:1240 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-70299c8a | cboSite.SelectedIndexChanged | FP00518_Shipping_Plan.cs:1245 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e7e25ba | cboSite.SelectedIndexChanged | FP00518_Shipping_Plan.cs:1248 |  | FLAG | dtPlantByDivision | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-a18309e8 | cboSite.SelectedIndexChanged | FP00518_Shipping_Plan.cs:1248 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pInstan… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3b1a7bd5 | cboSite.SelectedIndexChanged | FP00518_Shipping_Plan.cs:1249 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00518_Shipping_Plan.CboWppWeek_SelectedIndexChanged

진입점: cboWppWeek.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3ab7f3a | cboWppWeek.SelectedIndexChanged | FP00518_Shipping_Plan.cs:1263 |  | FLAG | dtWppSeq | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00518_find_WPPSeq", sInstanceID, sWppW… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-b5b9c649 | cboWppWeek.SelectedIndexChanged | FP00518_Shipping_Plan.cs:1263 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00518_find_WPPSeq", sInstanceID, sWppWeek) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b23d1a5 | cboWppWeek.SelectedIndexChanged | FP00518_Shipping_Plan.cs:1264 |  | LIST_REBIND | clsCtrl.setListBox | (dtWppSeq, cboWppSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00518_Shipping_Plan.chkWPP_CheckedChanged

진입점: this.chkWPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99356831 | this.chkWPP.CheckedChanged | FP00518_Shipping_Plan.cs:1278 | if (chkWPP.Checked == true) | FLAG | dtWppWeek | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00518_find_WPPWeek") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-24bffdd7 | this.chkWPP.CheckedChanged | FP00518_Shipping_Plan.cs:1278 | if (chkWPP.Checked == true) | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00518_find_WPPWeek") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-96710e46 | this.chkWPP.CheckedChanged | FP00518_Shipping_Plan.cs:1279 | if (chkWPP.Checked == true) | LIST_REBIND | clsCtrl.setListBox | (dtWppWeek, cboWppWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-872c4734 | this.chkWPP.CheckedChanged | FP00518_Shipping_Plan.cs:1284 | if (chkWPP.Checked == true) | FLAG | dtWppSeq | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00518_find_WPPSeq", sInstanceID, sWppW… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-fc9172fd | this.chkWPP.CheckedChanged | FP00518_Shipping_Plan.cs:1284 | if (chkWPP.Checked == true) | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00518_find_WPPSeq", sInstanceID, sWppWeek) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6343eb21 | this.chkWPP.CheckedChanged | FP00518_Shipping_Plan.cs:1285 | if (chkWPP.Checked == true) | LIST_REBIND | clsCtrl.setListBox | (dtWppSeq, cboWppSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e72c9903 | this.chkWPP.CheckedChanged | FP00518_Shipping_Plan.cs:1289 | if (chkWPP.Checked == true) ▸ if (dtWppSeq.Rows.Count >0) | VALUE_SET | drpPeriod.InitValue | dtWppSeq.Rows[0]["MIN_DATE"].ToString() + ":" + dtWppSeq.Rows[0]["MAX_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-fac68415 | this.chkWPP.CheckedChanged | FP00518_Shipping_Plan.cs:1291 | if (chkWPP.Checked == true) | UI_PROP | lblWppWeek.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a856c599 | this.chkWPP.CheckedChanged | FP00518_Shipping_Plan.cs:1292 | if (chkWPP.Checked == true) | UI_PROP | lblWppSeq.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0bd36f48 | this.chkWPP.CheckedChanged | FP00518_Shipping_Plan.cs:1294 | if (chkWPP.Checked == true) | UI_PROP | lblExcelImport.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2e3a9e5f | this.chkWPP.CheckedChanged | FP00518_Shipping_Plan.cs:1298 | else of (chkWPP.Checked == true) | UI_PROP | lblWppWeek.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f75b5931 | this.chkWPP.CheckedChanged | FP00518_Shipping_Plan.cs:1299 | else of (chkWPP.Checked == true) | UI_PROP | lblWppSeq.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-236827a5 | this.chkWPP.CheckedChanged | FP00518_Shipping_Plan.cs:1301 | else of (chkWPP.Checked == true) | UI_PROP | lblExcelImport.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## FP00518_Shipping_Plan.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dfd62f2 | (진입점 미연결) | FP00518_Shipping_Plan.cs:313 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-924af08a | (진입점 미연결) | FP00518_Shipping_Plan.cs:314 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00518_Shipping_Plan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-934f09a4 | this.Load | FP00518_Shipping_Plan.cs:323 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c067cf99 | this.Load | FP00518_Shipping_Plan.cs:324 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6c882659 | this.Load | FP00518_Shipping_Plan.cs:326 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00518_Shipping_Plan.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77c35b59 | this.Load | FP00518_Shipping_Plan.cs:232 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-202869a1 | this.Load | FP00518_Shipping_Plan.cs:234 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-684bd981 | this.Load | FP00518_Shipping_Plan.cs:235 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-db3cbfe3 | this.Load | FP00518_Shipping_Plan.cs:236 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP00518_Shipping_Plan.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d56ebed6 | DeleteButton | FP00518_Shipping_Plan.cs:478 | if (spdMain != null) ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22f98ab6 | DeleteButton | FP00518_Shipping_Plan.cs:482 | if (spdMain != null) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP00518_Shipping_Plan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02e4cf9b | Dispose | FP00518_Shipping_Plan.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00518_Shipping_Plan.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01485c10 | EditButton | FP00518_Shipping_Plan.cs:399 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b346128 | EditButton | FP00518_Shipping_Plan.cs:405 | if (spdMain != null) ▸ if (bWPPMode == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg2 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dab732d3 | EditButton | FP00518_Shipping_Plan.cs:406 | if (spdMain != null) ▸ if (bWPPMode == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d98dc6e7 | EditButton | FP00518_Shipping_Plan.cs:409 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-891b2ce4 | EditButton | FP00518_Shipping_Plan.cs:411 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.INSTANCE_ID), siMain.GetColumnIndex(DefColumns.MARKET), … | 그리드 편집 잠금/해제 |  |  |  |
| AC-915dba05 | EditButton | FP00518_Shipping_Plan.cs:413 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TO_SITE_ID), siMain.GetColumnIndex(DefColumns.ETA), true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-872d0026 | EditButton | FP00518_Shipping_Plan.cs:414 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PKG_TYPE), siMain.GetColumnIndex(DefColumns.PKG_TYPE), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-046568c0 | EditButton | FP00518_Shipping_Plan.cs:415 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.UPDATE_ID), siMain.GetColumnIndex(DefColumns.EDIT_YN), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-760ff763 | EditButton | FP00518_Shipping_Plan.cs:424 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-c1c9eaad | EditButton | FP00518_Shipping_Plan.cs:428 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) ▸ if (i % 2 == 1) | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-3d3a15eb | EditButton | FP00518_Shipping_Plan.cs:432 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) ▸ else of (i % 2 == … | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-88813f24 | EditButton | FP00518_Shipping_Plan.cs:439 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ if (i % 2 == … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), i, siMain.GetColumnIndex(DefColumns.… | 그리드 표시 설정 |  |  |  |
| AC-0afd1be0 | EditButton | FP00518_Shipping_Plan.cs:440 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ if (i % 2 == … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.SHIP_QTY), i, siMain.GetColumnIndex(DefColumns.SHIP_Q… | 그리드 표시 설정 |  |  |  |
| AC-e844faa9 | EditButton | FP00518_Shipping_Plan.cs:441 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ if (i % 2 == … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.DESCRIPTION), i, siMain.GetColumnIndex(DefColumns.DES… | 그리드 표시 설정 |  |  |  |
| AC-b176e783 | EditButton | FP00518_Shipping_Plan.cs:445 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ else of (i % … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), i, siMain.GetColumnIndex(DefColumns.… | 그리드 표시 설정 |  |  |  |
| AC-454e3509 | EditButton | FP00518_Shipping_Plan.cs:446 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ else of (i % … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.SHIP_QTY), i, siMain.GetColumnIndex(DefColumns.SHIP_Q… | 그리드 표시 설정 |  |  |  |
| AC-24140a1c | EditButton | FP00518_Shipping_Plan.cs:447 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ else of (i % … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.DESCRIPTION), i, siMain.GetColumnIndex(DefColumns.DES… | 그리드 표시 설정 |  |  |  |
| AC-e06183c9 | EditButton | FP00518_Shipping_Plan.cs:453 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## FP00518_Shipping_Plan.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf536749 | ExcelButton | FP00518_Shipping_Plan.cs:690 |  | EXCEL | ExportExcel2 | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00518_Shipping_Plan.Find_Data

진입점: this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) ▸ if (dtNewVersion.Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48d2bdd2 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:696 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-52fd0a46 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:701 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2b72ac54 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:702 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ccaadc89 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:705 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e9565ccc | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:708 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f1b91c77 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:711 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-de2ad919 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:711 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd7940a4 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:717 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-71b91abf | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:720 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8c24349a | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:726 | try ▸ if (chkWPP.Checked == true) | FLAG | bWPPMode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-11d43079 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:728 | try ▸ else of (chkWPP.Checked == true) | FLAG | bWPPMode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2a9bf635 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:731 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_ShippingPlan("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-63a8a140 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:742 | try ▸ if (ds != null) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3e790be9 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:744 | try ▸ if (ds != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-240595dc | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:747 | try ▸ if (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4180e759 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:751 | try ▸ if (ds != null) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dba3d1d0 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:759 | try ▸ if (ds != null) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-1d551e14 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:763 | try ▸ else of (ds != null) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0d3e07c9 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:764 | try ▸ else of (ds != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-9d8382bd | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:771 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3bb371b7 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:772 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f0638bb6 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:773 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-c2cf0a5e | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:774 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-62c9c48d | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FP00518_Shipping_Plan.cs:774 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP00518_Shipping_Plan.Find_Data_ShippingPlan

진입점: this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) ▸ if (dtNewVersion.Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / popSql.OnSql [if (programID == "PR_UI_FP00518_SHIPPING_PLAN_SELECT")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52ff42a9 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:793 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pPlanGroup = CString.GetCheckedListValue(dtInstance, cboP… | ⚠ 의미 확인 필요 |  |  |  |
| AC-75c802fd | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:826 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00518_SHIPPING_PLAN") ⇒ FP_Master.PR_UI_FP00518_SHIPPING_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-11049820 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:827 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-ae63f3e0 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:828 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-5b19f1ef | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:829 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3d9cda4a | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:830 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6c062fbb | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:832 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup.Equals("ALL") ? DBNull.Value : pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-881d8566 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:833 | try | DATA_OP | request.Parameters["p_instance_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7c07dc8c | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:834 | try | DATA_OP | request.Parameters["p_version_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-28f4a5e9 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:835 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cf40f257 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:836 | try | DATA_OP | request.Parameters["p_division_id"] | pDivision.Equals("ALL") ? DBNull.Value : pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b4e02ffb | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:837 | try | DATA_OP | request.Parameters["p_site_id"] | pSite.Equals("ALL") ? DBNull.Value : pSite | 행/컬럼 값 대입 |  |  |  |
| AC-0bec9101 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:838 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlant.Equals("ALL") ? DBNull.Value : pPlant | 행/컬럼 값 대입 |  |  |  |
| AC-bc6a3c83 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:839 | try | DATA_OP | request.Parameters["p_item_id"] | pItem | 행/컬럼 값 대입 |  |  |  |
| AC-3e9cd7b1 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:840 | try | DATA_OP | request.Parameters["p_item_name"] | pItemName | 행/컬럼 값 대입 |  |  |  |
| AC-c7f6e572 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:841 | try | DATA_OP | request.Parameters["p_production_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-413e6fa0 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:842 | try | DATA_OP | request.Parameters["p_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f9b8352d | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:843 | try | DATA_OP | request.Parameters["p_transport_mode"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5fd3db01 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:844 | try | DATA_OP | request.Parameters["p_to_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0fa26ea3 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:845 | try | DATA_OP | request.Parameters["p_to_plant_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-73166244 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:846 | try | DATA_OP | request.Parameters["p_ship_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e908cdcf | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:847 | try | DATA_OP | request.Parameters["p_eta"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f256dd29 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:848 | try | DATA_OP | request.Parameters["p_ship_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8476a66e | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:849 | try | DATA_OP | request.Parameters["p_pkg_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6ba26ed5 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:850 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8c4cffd2 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:851 | try | DATA_OP | request.Parameters["p_cell_type"] | pCellType | 행/컬럼 값 대입 |  |  |  |
| AC-0ba4cc76 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:852 | try | DATA_OP | request.Parameters["p_start_date"] | pStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-c891691c | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:853 | try | DATA_OP | request.Parameters["p_end_date"] | pEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-ed180285 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:854 | try | DATA_OP | request.Parameters["p_wpp_type"] | pWppType | 행/컬럼 값 대입 |  |  |  |
| AC-f48a608b | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:855 | try | DATA_OP | request.Parameters["p_wpp_week"] | pWppWeek | 행/컬럼 값 대입 |  |  |  |
| AC-ea756b26 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:856 | try | DATA_OP | request.Parameters["p_wpp_seq"] | pWppSeq | 행/컬럼 값 대입 |  |  |  |
| AC-9f104b4e | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:858 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-36c1d42c | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:860 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-49c8512c | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FP00518_Shipping_Plan.cs:865 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00518_Shipping_Plan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd1862db | this.Load | FP00518_Shipping_Plan.cs:118 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00518_Shipping_Plan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1330b1ec | this.Load | FP00518_Shipping_Plan.cs:142 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b61dfae8 | this.Load | FP00518_Shipping_Plan.cs:148 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d4ec9da0 | this.Load | FP00518_Shipping_Plan.cs:149 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5c4d78c5 | this.Load | FP00518_Shipping_Plan.cs:154 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-79621b44 | this.Load | FP00518_Shipping_Plan.cs:156 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-4a28f28a | this.Load | FP00518_Shipping_Plan.cs:160 | try | FLAG | dtInstance | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00518_findInstanceList_common", "LINE_… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-ed8088e1 | this.Load | FP00518_Shipping_Plan.cs:160 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00518_findInstanceList_common", "LINE_AMEND_E_PRE") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-721faf0e | this.Load | FP00518_Shipping_Plan.cs:161 | try | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboPlanGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-47d11f2f | this.Load | FP00518_Shipping_Plan.cs:166 | try | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-73fdb0a2 | this.Load | FP00518_Shipping_Plan.cs:166 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, sIns… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0e1425a7 | this.Load | FP00518_Shipping_Plan.cs:169 | try ▸ if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-f09095cb | this.Load | FP00518_Shipping_Plan.cs:172 | try | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-149a941a | this.Load | FP00518_Shipping_Plan.cs:174 | try | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-c4567451 | this.Load | FP00518_Shipping_Plan.cs:177 | try | FLAG | dtCellType | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00518_find_cellType") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-6e95d7e4 | this.Load | FP00518_Shipping_Plan.cs:177 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00518_find_cellType") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3ba4b386 | this.Load | FP00518_Shipping_Plan.cs:178 | try | LIST_REBIND | clsCtrl.setListBox | (dtCellType, cboCellType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-628db8b7 | this.Load | FP00518_Shipping_Plan.cs:181 | try | FLAG | dtWppWeek | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00518_find_WPPWeek") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-cc53a166 | this.Load | FP00518_Shipping_Plan.cs:181 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00518_find_WPPWeek") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-95524407 | this.Load | FP00518_Shipping_Plan.cs:182 | try | LIST_REBIND | clsCtrl.setListBox | (dtWppWeek, cboWppWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c13d61eb | this.Load | FP00518_Shipping_Plan.cs:187 | try | FLAG | dtWppSeq | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00518_find_WPPSeq", sInstanceID, sWppW… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-0169f39f | this.Load | FP00518_Shipping_Plan.cs:187 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00518_find_WPPSeq", sInstanceID, sWppWeek) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0698054b | this.Load | FP00518_Shipping_Plan.cs:188 | try | LIST_REBIND | clsCtrl.setListBox | (dtWppSeq, cboWppSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fa9ca18b | this.Load | FP00518_Shipping_Plan.cs:194 | try | VALUE_SET | drpPeriod.InitValue | sStartday.ToString() + ":" + sEndday.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-37fb06fc | this.Load | FP00518_Shipping_Plan.cs:197 | try | FLAG | dtCurrVersion | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00518_find_currVersion", sInstanceID) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-3ebb7849 | this.Load | FP00518_Shipping_Plan.cs:197 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00518_find_currVersion", sInstanceID) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9aaac602 | this.Load | FP00518_Shipping_Plan.cs:198 | try | FLAG | dtPancakeType | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00518_find_pancakeType") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-20f36cfb | this.Load | FP00518_Shipping_Plan.cs:198 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00518_find_pancakeType") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-926ba228 | this.Load | FP00518_Shipping_Plan.cs:204 | try | UI_PROP | lblWppWeek.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0f957dbb | this.Load | FP00518_Shipping_Plan.cs:205 | try | UI_PROP | lblWppSeq.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-369d14d4 | this.Load | FP00518_Shipping_Plan.cs:211 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-2d21178e | this.Load | FP00518_Shipping_Plan.cs:212 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fa3780f9 | this.Load | FP00518_Shipping_Plan.cs:213 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f281b9ab | this.Load | FP00518_Shipping_Plan.cs:217 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnImport.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-50e768d0 | this.Load | FP00518_Shipping_Plan.cs:218 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnImport.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-90aa8de3 | this.Load | FP00518_Shipping_Plan.cs:219 | try ▸ if (!_sSaveAuth.Equals("Y")) | UI_PROP | lblExcelImport.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8c6257c4 | this.Load | FP00518_Shipping_Plan.cs:225 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00518_Shipping_Plan.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d55f3bb | this.Load | FP00518_Shipping_Plan.cs:291 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d988b6d6 | this.Load | FP00518_Shipping_Plan.cs:292 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00518_Shipping_Plan.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcecbbde | this.Load | FP00518_Shipping_Plan.cs:338 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec78601c | this.Load | FP00518_Shipping_Plan.cs:339 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-07b88629 | this.Load | FP00518_Shipping_Plan.cs:343 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00518_Shipping_Plan.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41a3e178 | InsertButton | FP00518_Shipping_Plan.cs:667 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-706d1349 | InsertButton | FP00518_Shipping_Plan.cs:672 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-1300e8b5 | InsertButton | FP00518_Shipping_Plan.cs:673 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-8ba1fd70 | InsertButton | FP00518_Shipping_Plan.cs:676 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.INSTANCE_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a36bac2 | InsertButton | FP00518_Shipping_Plan.cs:677 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.MA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2a1cd36b | InsertButton | FP00518_Shipping_Plan.cs:678 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TO_SITE_ID), siMain.GetColumnIndex(DefColumns.T… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e2ab46f9 | InsertButton | FP00518_Shipping_Plan.cs:679 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ETA), siMain.GetColumnIndex(DefColumns.ETA), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a38cf447 | InsertButton | FP00518_Shipping_Plan.cs:680 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.PKG_TYPE), siMain.GetColumnIndex(DefColumns.PKG… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f47e4d1a | InsertButton | FP00518_Shipping_Plan.cs:681 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.UPDATE_ID), siMain.GetColumnIndex(DefColumns.ED… | 그리드 편집 잠금/해제 |  |  |  |

## FP00518_Shipping_Plan.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-465f2ef4 | popSql.OnSql | FP00518_Shipping_Plan.cs:1466 | if (programID == "PR_UI_FP00518_SHIPPING_PLAN_SELECT") | RETURN | return Find_Data_ShippingPlan("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-81c24dd6 | popSql.OnSql | FP00518_Shipping_Plan.cs:1470 | else of (programID == "PR_UI_FP00518_SHIPPING_PLAN_SELECT") ▸ if (programID == "PR_UI_FP00518_SHIPPING_PLAN_SAVE") | RETURN | return Save_Data_ShippingPlan("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-6323080f | popSql.OnSql | FP00518_Shipping_Plan.cs:1472 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00518_Shipping_Plan.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64a549ec | SaveButton | FP00518_Shipping_Plan.cs:877 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b79f079e | SaveButton | FP00518_Shipping_Plan.cs:879 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-265b04eb | SaveButton | FP00518_Shipping_Plan.cs:883 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-516d3574 | SaveButton | FP00518_Shipping_Plan.cs:884 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-54fc75f2 | SaveButton | FP00518_Shipping_Plan.cs:887 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-956cc256 | SaveButton | FP00518_Shipping_Plan.cs:894 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-46f6d831 | SaveButton | FP00518_Shipping_Plan.cs:896 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-be725e2b | SaveButton | FP00518_Shipping_Plan.cs:897 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50344a61 | SaveButton | FP00518_Shipping_Plan.cs:914 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == "D") ▸ if (!sValidYN.Equals("Y")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg2 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-91d00507 | SaveButton | FP00518_Shipping_Plan.cs:915 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == "D") ▸ if (!sValidYN.Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0af46db9 | SaveButton | FP00518_Shipping_Plan.cs:924 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b53f3d0b | SaveButton | FP00518_Shipping_Plan.cs:929 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b3bcd11f | SaveButton | FP00518_Shipping_Plan.cs:938 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-00c438f2 | SaveButton | FP00518_Shipping_Plan.cs:942 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fe877676 | SaveButton | FP00518_Shipping_Plan.cs:946 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1670540e | SaveButton | FP00518_Shipping_Plan.cs:947 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-839272a3 | SaveButton | FP00518_Shipping_Plan.cs:952 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00518_Shipping_Plan.Save_Data_CreateWPP

진입점: this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) ▸ if (dtNewVersion.Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2aa6b171 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1156 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00518_SHIPPING_PLAN") ⇒ FP_Master.PR_UI_FP00518_SHIPPING_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-7df30aff | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1157 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-89b69d8a | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1159 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-40c5b621 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1160 | try | DATA_OP | req.Parameters["p_sys_flag"] | "INSERT_CREATE_WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-089316ba | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1161 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-44504e83 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1162 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7802555e | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1163 | try | DATA_OP | req.Parameters["p_instance_id"] | pInstance | 행/컬럼 값 대입 |  |  |  |
| AC-02814f59 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1164 | try | DATA_OP | req.Parameters["p_instance_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ef6bd2a3 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1165 | try | DATA_OP | req.Parameters["p_version_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-294c014a | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1166 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8eb54d1c | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1167 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f4aa2bfd | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1168 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-793f0307 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1169 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-25bc30ff | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1170 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aace545d | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1171 | try | DATA_OP | req.Parameters["p_item_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-edfe7dc1 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1172 | try | DATA_OP | req.Parameters["p_production_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8dab9a88 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1173 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-439243ed | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1174 | try | DATA_OP | req.Parameters["p_transport_mode"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-04b1e65d | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1175 | try | DATA_OP | req.Parameters["p_to_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ad56440d | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1176 | try | DATA_OP | req.Parameters["p_to_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2c2b5f9b | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1177 | try | DATA_OP | req.Parameters["p_ship_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aeb7036f | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1178 | try | DATA_OP | req.Parameters["p_eta"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3ca00795 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1179 | try | DATA_OP | req.Parameters["p_ship_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5d3e5f54 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1180 | try | DATA_OP | req.Parameters["p_pkg_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2ac19dd3 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1181 | try | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1f1b44ed | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1182 | try | DATA_OP | req.Parameters["p_cell_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8d04d5d3 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1183 | try | DATA_OP | req.Parameters["p_start_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7dce83b0 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1184 | try | DATA_OP | req.Parameters["p_end_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3b87f73f | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1185 | try | DATA_OP | req.Parameters["p_wpp_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-68886d36 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1186 | try | DATA_OP | req.Parameters["p_wpp_week"] | pWppWeek | 행/컬럼 값 대입 |  |  |  |
| AC-3f948219 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1187 | try | DATA_OP | req.Parameters["p_wpp_seq"] | pWppSeq | 행/컬럼 값 대입 |  |  |  |
| AC-43924651 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1189 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-01bef4e5 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1190 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-cb2e6232 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FP00518_Shipping_Plan.cs:1195 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00518_Shipping_Plan.Save_Data_ShippingPlan

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_PLAN_SELECT") ▸ if (programID == "PR_UI_FP00518_SHIPPING_PLAN_SAVE")] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-055d6b4b | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1067 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00518_SHIPPING_PLAN") ⇒ FP_Master.PR_UI_FP00518_SHIPPING_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-928c292e | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1068 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0438418c | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1070 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-d476ccf9 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1071 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1589da2e | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1072 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-308e073e | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1073 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2b6bab99 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1074 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-ef20ee84 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1075 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_date"] | p_instance_date | 행/컬럼 값 대입 |  |  |  |
| AC-70ed283d | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1076 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version_id"] | p_version_id | 행/컬럼 값 대입 |  |  |  |
| AC-93b17809 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1077 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-26d3cb97 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1078 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b2bdbf48 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1079 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-6d30d99a | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1080 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-bf62d6b1 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1081 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-597d45aa | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1082 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_name"] | p_item_name | 행/컬럼 값 대입 |  |  |  |
| AC-c8d23d2d | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1083 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-1216688f | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1084 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-ebd5d44a | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1085 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-4cdec853 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1086 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_to_site_id"] | p_to_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a0aa9df6 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1087 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_to_plant_id"] | p_to_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-5da01b6c | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1088 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_ship_date"] | p_ship_date | 행/컬럼 값 대입 |  |  |  |
| AC-07e25cbe | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1089 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_eta"] | p_eta | 행/컬럼 값 대입 |  |  |  |
| AC-182622c0 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1090 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_ship_qty"] | p_ship_qty | 행/컬럼 값 대입 |  |  |  |
| AC-a6939a59 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1091 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_pkg_type"] | p_pkg_type | 행/컬럼 값 대입 |  |  |  |
| AC-e55be52c | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1092 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-f0143edd | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1093 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_type"] | p_cell_type | 행/컬럼 값 대입 |  |  |  |
| AC-96d02b26 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1094 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_start_date"] | p_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-c3d32d35 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1095 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_end_date"] | p_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-b1670f76 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1096 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_wpp_type"] | p_wpp_type | 행/컬럼 값 대입 |  |  |  |
| AC-cb23bb4e | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1097 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_wpp_week"] | p_wpp_week | 행/컬럼 값 대입 |  |  |  |
| AC-808ec568 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1098 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_wpp_seq"] | p_wpp_seq | 행/컬럼 값 대입 |  |  |  |
| AC-0fbb1842 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1100 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e9fa09a9 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1101 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-180f63fe | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1107 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-91001a54 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1108 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e11e6405 | popSql.OnSql [else of (programID == "PR_UI_FP00518_SHIPPING_… 외 1 | FP00518_Shipping_Plan.cs:1114 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00518_Shipping_Plan.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f85665f0 | SaveButton | FP00518_Shipping_Plan.cs:495 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00518_Shipping_Plan.SetChangedControl

진입점: this.Load [try] / cboPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07ef5278 | this.Load [try] 외 1 | FP00518_Shipping_Plan.cs:262 | try | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-e158730c | this.Load [try] 외 1 | FP00518_Shipping_Plan.cs:262 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pIns… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1a717be3 | this.Load [try] 외 1 | FP00518_Shipping_Plan.cs:263 | try | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-3a604ebd | this.Load [try] 외 1 | FP00518_Shipping_Plan.cs:267 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab197061 | this.Load [try] 외 1 | FP00518_Shipping_Plan.cs:269 | try | FLAG | dtSiteByDivision | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", pInsta… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-d3f3c38f | this.Load [try] 외 1 | FP00518_Shipping_Plan.cs:269 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", pInstanceID, "", "", ""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f08848f7 | this.Load [try] 외 1 | FP00518_Shipping_Plan.cs:270 | try | LIST_REBIND | clsCtrl.setListBox | (dtSiteByDivision, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7d40957e | this.Load [try] 외 1 | FP00518_Shipping_Plan.cs:274 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-6b39df70 | this.Load [try] 외 1 | FP00518_Shipping_Plan.cs:276 | try | FLAG | dtPlantByDivision | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-d32545d0 | this.Load [try] 외 1 | FP00518_Shipping_Plan.cs:276 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pInstan… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f3ef49e9 | this.Load [try] 외 1 | FP00518_Shipping_Plan.cs:277 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8b760e51 | this.Load [try] 외 1 | FP00518_Shipping_Plan.cs:283 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00518_Shipping_Plan.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ff32283 | this.Load [try] | FP00518_Shipping_Plan.cs:352 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2f779f30 | this.Load [try] | FP00518_Shipping_Plan.cs:353 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-18e2a5ab | this.Load [try] | FP00518_Shipping_Plan.cs:358 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-b58e85df | this.Load [try] | FP00518_Shipping_Plan.cs:359 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.PLANT_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-48e27db3 | this.Load [try] | FP00518_Shipping_Plan.cs:362 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INSTANCE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-600b0301 | this.Load [try] | FP00518_Shipping_Plan.cs:363 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INSTANCE_DATE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f0b4dc22 | this.Load [try] | FP00518_Shipping_Plan.cs:364 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.VERSION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6505224c | this.Load [try] | FP00518_Shipping_Plan.cs:365 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cc8c3ab8 | this.Load [try] | FP00518_Shipping_Plan.cs:366 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-af01068a | this.Load [try] | FP00518_Shipping_Plan.cs:367 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MARKET)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-72a734ce | this.Load [try] | FP00518_Shipping_Plan.cs:368 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.WPP_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d1a9ec41 | this.Load [try] | FP00518_Shipping_Plan.cs:369 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MESSAGE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5eac5f7b | this.Load [try] | FP00518_Shipping_Plan.cs:370 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.EDIT_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP00518_Shipping_Plan.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c490ed75 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1330 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f35ad31d | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1332 | try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-953096e5 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1355 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | POPUP | new FP00518_ItemPopup | (bFilterEnable, bMultiSelect, pDivision, pSite, pPlant) | 팝업/폼 생성 |  |  |  |
| AC-24f61c76 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1356 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9bb584a4 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1357 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9c2dcf03 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1374 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID), pCompany) | 그리드 값 설정 |  |  |  |
| AC-f0a81ce2 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1375 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.INSTANCE_ID), pInstance) | 그리드 값 설정 |  |  |  |
| AC-85fc3b15 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1376 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.INSTANCE_DATE), pInstanceDate) | 그리드 값 설정 |  |  |  |
| AC-ca9fb2ec | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1377 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.VERSION_ID), pVersion) | 그리드 값 설정 |  |  |  |
| AC-8bcfd335 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1378 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), pDivision) | 그리드 값 설정 |  |  |  |
| AC-d5cf3916 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1379 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID), pSite) | 그리드 값 설정 |  |  |  |
| AC-e102888e | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1380 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), pPlant) | 그리드 값 설정 |  |  |  |
| AC-e3b6be11 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1381 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), pItem) | 그리드 값 설정 |  |  |  |
| AC-1fa9caf6 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1382 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), pItemName) | 그리드 값 설정 |  |  |  |
| AC-49998260 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1395 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg2 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4c424085 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1396 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f576f2e6 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1399 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | POPUP | new FP00518_TransportModePopup | (pPlant) | 팝업/폼 생성 |  |  |  |
| AC-0068032a | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1400 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | UI_PROP | popTransMode.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b783aff3 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1401 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | POPUP | popTransMode.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d2100b1d | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1409 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), pTransportMode) | 그리드 값 설정 |  |  |  |
| AC-ceec8b94 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1410 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_ID), pShiptoSite) | 그리드 값 설정 |  |  |  |
| AC-13f8ed25 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1411 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TO_PLANT_ID), pShiptoPlant) | 그리드 값 설정 |  |  |  |
| AC-5cf44238 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1418 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SHIP_DATE), pShipDate) | 그리드 값 설정 |  |  |  |
| AC-61c84a92 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1419 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ETA), pETA) | 그리드 값 설정 |  |  |  |
| AC-5ff6b7ed | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1449 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-1783d982 | this.spdMain.CellClick | FP00518_Shipping_Plan.cs:1452 |  | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00518_TransportModePopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b614f33d | .ctor | FP00518_TransportModePopup.cs:118 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1db41e16 | .ctor | FP00518_TransportModePopup.cs:119 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-08f4121c | .ctor | FP00518_TransportModePopup.cs:120 |  | FLAG | this._sDivision | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-d2cf27d8 | .ctor | FP00518_TransportModePopup.cs:129 |  | FLAG | this._sPlant | pPlant | 화면 필드/플래그 변경 |  |  |  |

## FP00518_TransportModePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f19bdecd | this.btnButtonList.UsrButtonList_Click_Detected | FP00518_TransportModePopup.cs:346 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-11d39607 | this.btnButtonList.UsrButtonList_Click_Detected | FP00518_TransportModePopup.cs:349 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00518_TransportModePopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a176851d | this.btnSql.Click | FP00518_TransportModePopup.cs:216 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e761c053 | this.btnSql.Click | FP00518_TransportModePopup.cs:217 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d0893f1e | this.btnSql.Click | FP00518_TransportModePopup.cs:219 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00518_SELECT_TRANSPORTMODEPOPUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-3e6ad015 | this.btnSql.Click | FP00518_TransportModePopup.cs:220 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00518_TransportModePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b1a3624 | this.Load | FP00518_TransportModePopup.cs:164 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a4b73f01 | this.Load | FP00518_TransportModePopup.cs:165 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-06df2b32 | this.Load | FP00518_TransportModePopup.cs:166 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00518_TransportModePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cec08871 | this.Load | FP00518_TransportModePopup.cs:159 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00518_TransportModePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee141463 | Dispose | FP00518_TransportModePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00518_TransportModePopup.Find_Data_TransMode

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ lambda] / this.Load [try ▸ lambda] / popSql.OnSql [if (programID == "PR_UI_FP00518_SELECT_TRANSPORTMODEPOPUP")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea8fc11d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:270 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pPlantID = _sPlant; })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b42fc7da | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:277 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00518_SHIPPING_PLAN") ⇒ FP_Master.PR_UI_FP00518_SHIPPING_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-29126da1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:279 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bb6d221b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:281 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-b17ffb5b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:282 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_TRANSPORTMODE_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-c2dba7ff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:283 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4d6105b2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:284 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5f6413c0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:286 | try | DATA_OP | request.Parameters["p_instance_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2ecdc6d4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:287 | try | DATA_OP | request.Parameters["p_instance_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e9bbc87b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:288 | try | DATA_OP | request.Parameters["p_version_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-26e78b0d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:289 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3ef99ce1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:290 | try | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2d8c980e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:291 | try | DATA_OP | request.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fc528cb5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:292 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-617b8c52 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:293 | try | DATA_OP | request.Parameters["p_item_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a43bcc38 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:294 | try | DATA_OP | request.Parameters["p_item_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8cc1535a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:295 | try | DATA_OP | request.Parameters["p_production_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-31d9cd71 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:296 | try | DATA_OP | request.Parameters["p_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-aa920044 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:297 | try | DATA_OP | request.Parameters["p_transport_mode"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a624fd05 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:298 | try | DATA_OP | request.Parameters["p_to_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c8825060 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:299 | try | DATA_OP | request.Parameters["p_to_plant_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-95763c0e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:300 | try | DATA_OP | request.Parameters["p_ship_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-275a1206 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:301 | try | DATA_OP | request.Parameters["p_eta"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1a6833f9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:302 | try | DATA_OP | request.Parameters["p_ship_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-06be2aec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:303 | try | DATA_OP | request.Parameters["p_pkg_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-54c49e32 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:304 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cd672115 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:305 | try | DATA_OP | request.Parameters["p_cell_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f69e6e0a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:306 | try | DATA_OP | request.Parameters["p_start_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b7763d39 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:307 | try | DATA_OP | request.Parameters["p_end_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c5dc2191 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:308 | try | DATA_OP | request.Parameters["p_wpp_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d87477cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:309 | try | DATA_OP | request.Parameters["p_wpp_week"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-179ba4d9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:310 | try | DATA_OP | request.Parameters["p_wpp_seq"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e1546d9a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:312 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-75ffab48 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:315 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-ce5c6fd1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP00518_TransportModePopup.cs:320 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00518_TransportModePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e615d23 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_TransportModePopup.cs:234 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4c3e3989 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_TransportModePopup.cs:235 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-98defa84 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_TransportModePopup.cs:238 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_TransMode("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-297343e3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_TransportModePopup.cs:244 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c6a0907b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_TransportModePopup.cs:247 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-02f43f3f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_TransportModePopup.cs:249 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-cc14362d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_TransportModePopup.cs:255 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d9411826 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00518_TransportModePopup.cs:260 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00518_TransportModePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ff1081e | this.Load | FP00518_TransportModePopup.cs:137 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3de049c1 | this.Load | FP00518_TransportModePopup.cs:139 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00518_TransportModePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4ce248f | this.Load | FP00518_TransportModePopup.cs:176 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e173a003 | this.Load | FP00518_TransportModePopup.cs:177 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00518_TransportModePopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae6baf89 | (진입점 미연결) | FP00518_TransportModePopup.cs:201 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00518_TransportModePopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac625f89 | popSql.OnSql | FP00518_TransportModePopup.cs:400 | if (programID == "PR_UI_FP00518_SELECT_TRANSPORTMODEPOPUP") | RETURN | return Find_Data_TransMode("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-85b883f0 | popSql.OnSql | FP00518_TransportModePopup.cs:402 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00518_TransportModePopup.SetLineInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec55eb47 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00518_TransportModePopup.cs:384 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa713a9a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00518_TransportModePopup.cs:385 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0cc327d0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00518_TransportModePopup.cs:386 |  | FLAG | _ShipToSiteId | this.dtFindData.Rows[iClick_Row][DefColumns.TO_SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ac7c3681 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00518_TransportModePopup.cs:387 |  | FLAG | _ShipToPlantId | this.dtFindData.Rows[iClick_Row][DefColumns.TO_PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f0e98909 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00518_TransportModePopup.cs:388 |  | FLAG | _TransportMode | this.dtFindData.Rows[iClick_Row][DefColumns.TRANSPORT_MODE].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-86204899 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00518_TransportModePopup.cs:392 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00518_TransportModePopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d8e1568 | this.Load | FP00518_TransportModePopup.cs:183 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-51509d87 | this.Load | FP00518_TransportModePopup.cs:184 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-58105044 | this.Load | FP00518_TransportModePopup.cs:188 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-da7b8fef | this.Load | FP00518_TransportModePopup.cs:191 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FROM_PLANT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-28289c6e | this.Load | FP00518_TransportModePopup.cs:192 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TO_PLANT_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6fc16515 | this.Load | FP00518_TransportModePopup.cs:193 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.LT_TOTAL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-010032f5 | this.Load | FP00518_TransportModePopup.cs:194 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP00518_TransportModePopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4120bad | this.spdMain.CellClick | FP00518_TransportModePopup.cs:360 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00518_TransportModePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-249ab08e | this.spdMain.CellDoubleClick | FP00518_TransportModePopup.cs:365 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-8323f0ff | this.spdMain.CellDoubleClick | FP00518_TransportModePopup.cs:367 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c1720f1 | this.spdMain.CellDoubleClick | FP00518_TransportModePopup.cs:369 |  | FLAG | _ShipToSiteId | this.dtFindData.Rows[e.Row][DefColumns.TO_SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4e0648b5 | this.spdMain.CellDoubleClick | FP00518_TransportModePopup.cs:370 |  | FLAG | _ShipToPlantId | this.dtFindData.Rows[e.Row][DefColumns.TO_PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4c48f65a | this.spdMain.CellDoubleClick | FP00518_TransportModePopup.cs:371 |  | FLAG | _TransportMode | this.dtFindData.Rows[e.Row][DefColumns.TRANSPORT_MODE].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c7a32ac1 | this.spdMain.CellDoubleClick | FP00518_TransportModePopup.cs:374 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

