# AS-IS 액션 대조표 — FDM0005

> 원천: `Doc/asisfacts/screens/FDM0005/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 526행 · 메서드 63 · 종류 DATA_OP 162 · FLAG 87 · RETURN 40 · GRID_SET 33 · GRID_INIT 27 · UI_PROP 24 · COMBO_DATA 23 · UI_MISC 19 · LIST_REBIND 19 · POPUP 18 · GRID_LOCK 14 · MESSAGE 14 · ENDPOINT 13 · STATE 8 · VALUE_SET 6 · THROW 5 · CALL_BASE 3 · GRID_BIND 3 · VALIDATE 3 · CALL_EXT 2 · STATE_RESET 1 · EXCEL 1 · GRID_STYLE 1 · ⚠ 의미 확인 필요 5


## FDM0005_ItemPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-501c8ac4 | .ctor | FDM0005_ItemPopup.cs:134 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e3a15887 | .ctor | FDM0005_ItemPopup.cs:135 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-be2735c6 | .ctor | FDM0005_ItemPopup.cs:136 |  | FLAG | this.sDivision | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-a64e5298 | .ctor | FDM0005_ItemPopup.cs:144 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-422cfe6d | .ctor | FDM0005_ItemPopup.cs:145 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-2ae864f0 | .ctor | FDM0005_ItemPopup.cs:147 |  | FLAG | this.sDivision | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-a74511db | .ctor | FDM0005_ItemPopup.cs:155 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-c83ec2f5 | .ctor | FDM0005_ItemPopup.cs:156 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-542a785f | .ctor | FDM0005_ItemPopup.cs:158 |  | FLAG | this.sDivision | pDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-cee9b2fb | .ctor | FDM0005_ItemPopup.cs:167 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-4099104f | .ctor | FDM0005_ItemPopup.cs:168 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-a316480b | .ctor | FDM0005_ItemPopup.cs:170 |  | FLAG | this.sDivision | pDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-9946129b | .ctor | FDM0005_ItemPopup.cs:171 |  | FLAG | this.sSite | pSite | 화면 필드/플래그 변경 |  |  |  |
| AC-980bad97 | .ctor | FDM0005_ItemPopup.cs:172 |  | FLAG | this.sPlant | pPlant | 화면 필드/플래그 변경 |  |  |  |

## FDM0005_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d111eea | this.btnButtonList.UsrButtonList_Click_Detected | FDM0005_ItemPopup.cs:505 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ee750484 | this.btnButtonList.UsrButtonList_Click_Detected | FDM0005_ItemPopup.cs:508 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FDM0005_ItemPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee73e073 | this.btnSql.Click | FDM0005_ItemPopup.cs:316 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6c86c3e8 | this.btnSql.Click | FDM0005_ItemPopup.cs:317 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a62962b6 | this.btnSql.Click | FDM0005_ItemPopup.cs:319 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FDM0005_SELECT_ITEMPOPUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6f92b8e | this.btnSql.Click | FDM0005_ItemPopup.cs:320 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FDM0005_ItemPopup.cboSite_SelectedIndexChanged

진입점: this.cboSite.SelectedIndexChanged / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f97350c9 | this.cboSite.SelectedIndexChanged 외 1 | FDM0005_ItemPopup.cs:483 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-0762f924 | this.cboSite.SelectedIndexChanged 외 1 | FDM0005_ItemPopup.cs:488 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-d66b468a | this.cboSite.SelectedIndexChanged 외 1 | FDM0005_ItemPopup.cs:492 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-a4b380c2 | this.cboSite.SelectedIndexChanged 외 1 | FDM0005_ItemPopup.cs:492 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3dd18aaf | this.cboSite.SelectedIndexChanged 외 1 | FDM0005_ItemPopup.cs:493 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, cboPlant, true,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |

## FDM0005_ItemPopup.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec5a05c2 | this.clbDivision.SelectedIndexChanged 외 1 | FDM0005_ItemPopup.cs:455 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ea1250e | this.clbDivision.SelectedIndexChanged 외 1 | FDM0005_ItemPopup.cs:458 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-37f577ce | this.clbDivision.SelectedIndexChanged 외 1 | FDM0005_ItemPopup.cs:458 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-26b38fe1 | this.clbDivision.SelectedIndexChanged 외 1 | FDM0005_ItemPopup.cs:459 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-06aa4521 | this.clbDivision.SelectedIndexChanged 외 1 | FDM0005_ItemPopup.cs:463 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-1fb3287c | this.clbDivision.SelectedIndexChanged 외 1 | FDM0005_ItemPopup.cs:466 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-bfdcf30b | this.clbDivision.SelectedIndexChanged 외 1 | FDM0005_ItemPopup.cs:466 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-584afb00 | this.clbDivision.SelectedIndexChanged 외 1 | FDM0005_ItemPopup.cs:467 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, cboPlant, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FDM0005_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8d5e143 | this.Load | FDM0005_ItemPopup.cs:267 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-973bbddb | this.Load | FDM0005_ItemPopup.cs:268 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ba1377fb | this.Load | FDM0005_ItemPopup.cs:269 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FDM0005_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06d48d79 | this.Load | FDM0005_ItemPopup.cs:257 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FDM0005_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a229b322 | Dispose | FDM0005_ItemPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FDM0005_ItemPopup.Find_Data_Item

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ lambda] / this.Load [try ▸ lambda] / popSql.OnSql [if (programID == "PR_UI_FDM0005_SELECT_ITEMPOPUP")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5a5862c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:373 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pDivisionID = CString.GetCheckedListValue(dtMyDivision, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d97fab21 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:383 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FDM0005_SHIPPING_PLAN") ⇒ FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-e65dd8fd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:385 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-122f7c3b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:387 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-c307ca6e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:388 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_ITEM_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-5f8b701c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:389 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bfa94fbe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:390 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d3dd9f1e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:392 | try | DATA_OP | request.Parameters["p_instance_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-124fad37 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:393 | try | DATA_OP | request.Parameters["p_instance_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e6bc5e7c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:394 | try | DATA_OP | request.Parameters["p_version_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cfdd7cdc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:395 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-82d6e73d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:396 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-a65a199b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:397 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-dded0795 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:398 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-5e7c272b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:399 | try | DATA_OP | request.Parameters["p_item_id"] | pItemID | 행/컬럼 값 대입 |  |  |  |
| AC-86f03fc5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:400 | try | DATA_OP | request.Parameters["p_item_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4bb9612c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:401 | try | DATA_OP | request.Parameters["p_production_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d75346eb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:402 | try | DATA_OP | request.Parameters["p_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2c8e3879 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:403 | try | DATA_OP | request.Parameters["p_transport_mode"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ce1d2794 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:404 | try | DATA_OP | request.Parameters["p_to_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3238b823 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:405 | try | DATA_OP | request.Parameters["p_to_plant_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1a69cc2e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:406 | try | DATA_OP | request.Parameters["p_ship_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2cee96a8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:407 | try | DATA_OP | request.Parameters["p_eta"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-227d6f2c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:408 | try | DATA_OP | request.Parameters["p_ship_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7e0f128b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:409 | try | DATA_OP | request.Parameters["p_pkg_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a240b23b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:410 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-17f158e8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:411 | try | DATA_OP | request.Parameters["p_cell_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c7a94e67 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:412 | try | DATA_OP | request.Parameters["p_start_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6acbcdda | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:413 | try | DATA_OP | request.Parameters["p_end_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3c2f7860 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:414 | try | DATA_OP | request.Parameters["p_wpp_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-03f7c34b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:415 | try | DATA_OP | request.Parameters["p_wpp_week"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b58f57c4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:416 | try | DATA_OP | request.Parameters["p_wpp_seq"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3b5a70d8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:418 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8dc11958 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:421 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-6dc6c688 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_ItemPopup.cs:426 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FDM0005_ItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16fda514 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_ItemPopup.cs:334 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ef4451cb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_ItemPopup.cs:335 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c119b4f8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_ItemPopup.cs:338 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Item("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7fc0b278 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_ItemPopup.cs:344 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0706dac0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_ItemPopup.cs:347 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-454d5505 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_ItemPopup.cs:349 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-e73bc105 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_ItemPopup.cs:355 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-db019b4b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_ItemPopup.cs:360 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FDM0005_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d05b2f1a | this.Load | FDM0005_ItemPopup.cs:180 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1add0d70 | this.Load | FDM0005_ItemPopup.cs:182 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FDM0005_ItemPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd633a5a | this.Load | FDM0005_ItemPopup.cs:209 |  | DATA_OP | this.sDivision.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-6dc32d1a | this.Load | FDM0005_ItemPopup.cs:213 |  | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-aa809dfd | this.Load | FDM0005_ItemPopup.cs:213 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cad3acf9 | this.Load | FDM0005_ItemPopup.cs:215 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f236a0e4 | this.Load | FDM0005_ItemPopup.cs:217 | if (!string.IsNullOrEmpty(sDivision)) | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-9db117fa | this.Load | FDM0005_ItemPopup.cs:221 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-49d2a85d | this.Load | FDM0005_ItemPopup.cs:225 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-1f7472be | this.Load | FDM0005_ItemPopup.cs:225 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7d136d47 | this.Load | FDM0005_ItemPopup.cs:226 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e8677cbb | this.Load | FDM0005_ItemPopup.cs:228 | if (!string.IsNullOrEmpty(sSite)) | VALUE_SET | cboSite.SelectedValue | sSite | 컨트롤 값 설정 |  |  |  |
| AC-1074d797 | this.Load | FDM0005_ItemPopup.cs:231 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-a4fc767f | this.Load | FDM0005_ItemPopup.cs:234 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-fbd66d99 | this.Load | FDM0005_ItemPopup.cs:234 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-18fe3b0a | this.Load | FDM0005_ItemPopup.cs:235 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, cboPlant, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c1ff10e7 | this.Load | FDM0005_ItemPopup.cs:237 | if (!string.IsNullOrEmpty(sPlant)) | VALUE_SET | cboPlant.SelectedValue | sPlant | 컨트롤 값 설정 |  |  |  |
| AC-d15e0357 | this.Load | FDM0005_ItemPopup.cs:242 | if (bCtlEnable == true) | STATE | clbDivision.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cd0fd26a | this.Load | FDM0005_ItemPopup.cs:243 | if (bCtlEnable == true) | STATE | cboSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fbc1de00 | this.Load | FDM0005_ItemPopup.cs:244 | if (bCtlEnable == true) | STATE | cboPlant.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e1a84a23 | this.Load | FDM0005_ItemPopup.cs:248 | else of (bCtlEnable == true) | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c8219dc6 | this.Load | FDM0005_ItemPopup.cs:249 | else of (bCtlEnable == true) | STATE | cboSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-10905f46 | this.Load | FDM0005_ItemPopup.cs:250 | else of (bCtlEnable == true) | STATE | cboPlant.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FDM0005_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea328d41 | this.Load | FDM0005_ItemPopup.cs:279 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1145c8e8 | this.Load | FDM0005_ItemPopup.cs:280 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FDM0005_ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3680b746 | (진입점 미연결) | FDM0005_ItemPopup.cs:301 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FDM0005_ItemPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fcc2227 | popSql.OnSql | FDM0005_ItemPopup.cs:564 | if (programID == "PR_UI_FDM0005_SELECT_ITEMPOPUP") | RETURN | return Find_Data_Item("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-e317ce94 | popSql.OnSql | FDM0005_ItemPopup.cs:566 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FDM0005_ItemPopup.SetLineInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72d960bf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FDM0005_ItemPopup.cs:546 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f9f6a1f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FDM0005_ItemPopup.cs:547 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e3c0cf6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FDM0005_ItemPopup.cs:548 |  | FLAG | _CompanyId | this.dtFindData.Rows[iClick_Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3bfd82d4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FDM0005_ItemPopup.cs:549 |  | FLAG | _DivisionId | this.dtFindData.Rows[iClick_Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-742e0a83 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FDM0005_ItemPopup.cs:550 |  | FLAG | _SiteId | this.dtFindData.Rows[iClick_Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-098fd1e8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FDM0005_ItemPopup.cs:551 |  | FLAG | _PlantId | this.dtFindData.Rows[iClick_Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3129b1b5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FDM0005_ItemPopup.cs:552 |  | FLAG | _ItemId | this.dtFindData.Rows[iClick_Row][DefColumns.ITEM_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-53a98a36 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FDM0005_ItemPopup.cs:553 |  | FLAG | _ItemName | this.dtFindData.Rows[iClick_Row][DefColumns.NICK_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8c2a2b47 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FDM0005_ItemPopup.cs:556 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FDM0005_ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7eba437 | this.Load | FDM0005_ItemPopup.cs:286 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0a8081a2 | this.Load | FDM0005_ItemPopup.cs:287 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-a0d89a56 | this.Load | FDM0005_ItemPopup.cs:291 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-cf94c88a | this.Load | FDM0005_ItemPopup.cs:292 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.SITE_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FDM0005_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f01072c8 | this.spdMain.CellClick | FDM0005_ItemPopup.cs:519 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FDM0005_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1548095 | this.spdMain.CellDoubleClick | FDM0005_ItemPopup.cs:524 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-70d1ece4 | this.spdMain.CellDoubleClick | FDM0005_ItemPopup.cs:526 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fbc9d8b1 | this.spdMain.CellDoubleClick | FDM0005_ItemPopup.cs:528 |  | FLAG | _CompanyId | this.dtFindData.Rows[e.Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6ca7421b | this.spdMain.CellDoubleClick | FDM0005_ItemPopup.cs:529 |  | FLAG | _DivisionId | this.dtFindData.Rows[e.Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6aacf07a | this.spdMain.CellDoubleClick | FDM0005_ItemPopup.cs:530 |  | FLAG | _SiteId | this.dtFindData.Rows[e.Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-49b14691 | this.spdMain.CellDoubleClick | FDM0005_ItemPopup.cs:531 |  | FLAG | _PlantId | this.dtFindData.Rows[e.Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-da167703 | this.spdMain.CellDoubleClick | FDM0005_ItemPopup.cs:532 |  | FLAG | _ItemId | this.dtFindData.Rows[e.Row][DefColumns.ITEM_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7e323dcd | this.spdMain.CellDoubleClick | FDM0005_ItemPopup.cs:533 |  | FLAG | _ItemName | this.dtFindData.Rows[e.Row][DefColumns.NICK_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-99895c9a | this.spdMain.CellDoubleClick | FDM0005_ItemPopup.cs:536 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FDM0005_Shipping_Plan.btnCreateWPP_Click

진입점: this.btnCreateWPP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4396bcbe | this.btnCreateWPP.Click | FDM0005_Shipping_Plan.cs:475 | if (bWPPMode == true \|\| chkWPP.Checked == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e68b4f9 | this.btnCreateWPP.Click | FDM0005_Shipping_Plan.cs:476 | if (bWPPMode == true \|\| chkWPP.Checked == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9aa9fc96 | this.btnCreateWPP.Click | FDM0005_Shipping_Plan.cs:479 |  | MESSAGE | MessageBox.Show | ("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", Messa… | 메시지 표시 |  |  |  |
| AC-2a2d5352 | this.btnCreateWPP.Click | FDM0005_Shipping_Plan.cs:483 | if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) | FLAG | dtNewVersion | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0005_find_WPP_newVersion", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-fe4c76c7 | this.btnCreateWPP.Click | FDM0005_Shipping_Plan.cs:483 | if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0005_find_WPP_newVersion", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ad9488ae | this.btnCreateWPP.Click | FDM0005_Shipping_Plan.cs:500 | if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) ▸ if (dtNewVe… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b6608076 | this.btnCreateWPP.Click | FDM0005_Shipping_Plan.cs:509 | if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) ▸ if (dtNewVe… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ae317f00 | this.btnCreateWPP.Click | FDM0005_Shipping_Plan.cs:515 | if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) ▸ else of (dt… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aa3aa8bb | this.btnCreateWPP.Click | FDM0005_Shipping_Plan.cs:516 | if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) ▸ else of (dt… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6630a35d | this.btnCreateWPP.Click | FDM0005_Shipping_Plan.cs:521 | else of (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FDM0005_Shipping_Plan.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ff87420 | this.btnImport.Click | FDM0005_Shipping_Plan.cs:560 | try | FLAG | dtNewVersion | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0005_find_newVersion", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-b62d103a | this.btnImport.Click | FDM0005_Shipping_Plan.cs:560 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0005_find_newVersion", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dd9de7dc | this.btnImport.Click | FDM0005_Shipping_Plan.cs:574 | try ▸ if (bWPPMode == true \|\| chkWPP.Checked == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a68137c6 | this.btnImport.Click | FDM0005_Shipping_Plan.cs:575 | try ▸ if (bWPPMode == true \|\| chkWPP.Checked == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-120a3f57 | this.btnImport.Click | FDM0005_Shipping_Plan.cs:596 | try | POPUP | new FPC0100_ExcelImportPopup | ("FPC0100", "ShippingPlanImportPopup", "FP_Master.PR_UI_FDM0005_SHIPPING_PLAN_EXCEL", sPar… | 팝업/폼 생성 |  |  |  |
| AC-8d81a3d8 | this.btnImport.Click | FDM0005_Shipping_Plan.cs:597 | try | UI_PROP | popTestImport.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-54ff9db7 | this.btnImport.Click | FDM0005_Shipping_Plan.cs:598 | try | POPUP | popTestImport.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FDM0005_Shipping_Plan.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a5b27ad | this.btnSql.Click | FDM0005_Shipping_Plan.cs:529 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ef95f910 | this.btnSql.Click | FDM0005_Shipping_Plan.cs:530 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0964861d | this.btnSql.Click | FDM0005_Shipping_Plan.cs:532 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FDM0005_SHIPPING_PLAN_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-2d054955 | this.btnSql.Click | FDM0005_Shipping_Plan.cs:533 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FDM0005_SHIPPING_PLAN_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5faf7ea9 | this.btnSql.Click | FDM0005_Shipping_Plan.cs:534 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FDM0005_Shipping_Plan.CboPlanGroup_SelectedIndexChanged

진입점: cboPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-326e3918 | cboPlanGroup.SelectedIndexChanged | FDM0005_Shipping_Plan.cs:1148 |  | FLAG | dtCurrVersion | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0005_find_currVersion", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-f3dbe6a0 | cboPlanGroup.SelectedIndexChanged | FDM0005_Shipping_Plan.cs:1148 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0005_find_currVersion", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a2e44845 | cboPlanGroup.SelectedIndexChanged | FDM0005_Shipping_Plan.cs:1152 | if (dtCurrVersion.Rows.Count > 0) | FLAG | _sInstanceDate | dtCurrVersion.Rows[0]["INSTANCE_DATE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-89dc8e62 | cboPlanGroup.SelectedIndexChanged | FDM0005_Shipping_Plan.cs:1153 | if (dtCurrVersion.Rows.Count > 0) | FLAG | _sVersion | dtCurrVersion.Rows[0]["VERSION_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |

## FDM0005_Shipping_Plan.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5db3159 | cboSite.SelectedIndexChanged | FDM0005_Shipping_Plan.cs:1178 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f4284f7 | cboSite.SelectedIndexChanged | FDM0005_Shipping_Plan.cs:1183 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-d9e3d43e | cboSite.SelectedIndexChanged | FDM0005_Shipping_Plan.cs:1186 |  | FLAG | dtPlantByDivision | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-daff7c17 | cboSite.SelectedIndexChanged | FDM0005_Shipping_Plan.cs:1186 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pInstan… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c22445a0 | cboSite.SelectedIndexChanged | FDM0005_Shipping_Plan.cs:1187 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## FDM0005_Shipping_Plan.CboWppWeek_SelectedIndexChanged

진입점: cboWppWeek.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01f3720f | cboWppWeek.SelectedIndexChanged | FDM0005_Shipping_Plan.cs:1201 |  | FLAG | dtWppSeq | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0005_find_WPPSeq", sInstanceID, sWppW… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-7376441c | cboWppWeek.SelectedIndexChanged | FDM0005_Shipping_Plan.cs:1201 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0005_find_WPPSeq", sInstanceID, sWppWeek) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-de35dd91 | cboWppWeek.SelectedIndexChanged | FDM0005_Shipping_Plan.cs:1202 |  | LIST_REBIND | clsCtrl.setListBox | (dtWppSeq, cboWppSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FDM0005_Shipping_Plan.chkWPP_CheckedChanged

진입점: this.chkWPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6f74ca9 | this.chkWPP.CheckedChanged | FDM0005_Shipping_Plan.cs:1216 | if (chkWPP.Checked == true) | FLAG | dtWppWeek | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0005_find_WPPWeek") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-71c3204c | this.chkWPP.CheckedChanged | FDM0005_Shipping_Plan.cs:1216 | if (chkWPP.Checked == true) | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0005_find_WPPWeek") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d80be94 | this.chkWPP.CheckedChanged | FDM0005_Shipping_Plan.cs:1217 | if (chkWPP.Checked == true) | LIST_REBIND | clsCtrl.setListBox | (dtWppWeek, cboWppWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-16c980ef | this.chkWPP.CheckedChanged | FDM0005_Shipping_Plan.cs:1222 | if (chkWPP.Checked == true) | FLAG | dtWppSeq | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0005_find_WPPSeq", sInstanceID, sWppW… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-ab8fb38f | this.chkWPP.CheckedChanged | FDM0005_Shipping_Plan.cs:1222 | if (chkWPP.Checked == true) | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0005_find_WPPSeq", sInstanceID, sWppWeek) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-75f3affa | this.chkWPP.CheckedChanged | FDM0005_Shipping_Plan.cs:1223 | if (chkWPP.Checked == true) | LIST_REBIND | clsCtrl.setListBox | (dtWppSeq, cboWppSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fa1cc9ca | this.chkWPP.CheckedChanged | FDM0005_Shipping_Plan.cs:1227 | if (chkWPP.Checked == true) ▸ if (dtWppSeq.Rows.Count >0) | VALUE_SET | drpPeriod.InitValue | dtWppSeq.Rows[0]["MIN_DATE"].ToString() + ":" + dtWppSeq.Rows[0]["MAX_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-c2b24a49 | this.chkWPP.CheckedChanged | FDM0005_Shipping_Plan.cs:1229 | if (chkWPP.Checked == true) | UI_PROP | lblWppWeek.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-cff4715b | this.chkWPP.CheckedChanged | FDM0005_Shipping_Plan.cs:1230 | if (chkWPP.Checked == true) | UI_PROP | lblWppSeq.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4b16b3b5 | this.chkWPP.CheckedChanged | FDM0005_Shipping_Plan.cs:1232 | if (chkWPP.Checked == true) | UI_PROP | lblExcelImport.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1649aebb | this.chkWPP.CheckedChanged | FDM0005_Shipping_Plan.cs:1236 | else of (chkWPP.Checked == true) | UI_PROP | lblWppWeek.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-33f9e801 | this.chkWPP.CheckedChanged | FDM0005_Shipping_Plan.cs:1237 | else of (chkWPP.Checked == true) | UI_PROP | lblWppSeq.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6e61f1b2 | this.chkWPP.CheckedChanged | FDM0005_Shipping_Plan.cs:1239 | else of (chkWPP.Checked == true) | UI_PROP | lblExcelImport.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## FDM0005_Shipping_Plan.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddb1d4f9 | (진입점 미연결) | FDM0005_Shipping_Plan.cs:296 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-379bc72c | (진입점 미연결) | FDM0005_Shipping_Plan.cs:297 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## FDM0005_Shipping_Plan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3999cf26 | this.Load | FDM0005_Shipping_Plan.cs:306 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5b6e5933 | this.Load | FDM0005_Shipping_Plan.cs:307 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0d4ffeac | this.Load | FDM0005_Shipping_Plan.cs:309 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FDM0005_Shipping_Plan.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46330cc0 | this.Load | FDM0005_Shipping_Plan.cs:218 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-58de12cc | this.Load | FDM0005_Shipping_Plan.cs:220 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-5898bea6 | this.Load | FDM0005_Shipping_Plan.cs:221 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-0d357f0b | this.Load | FDM0005_Shipping_Plan.cs:222 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FDM0005_Shipping_Plan.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d79fe6c3 | DeleteButton | FDM0005_Shipping_Plan.cs:438 | if (spdMain != null) ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d397ce92 | DeleteButton | FDM0005_Shipping_Plan.cs:442 | if (spdMain != null) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FDM0005_Shipping_Plan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2af2a76b | Dispose | FDM0005_Shipping_Plan.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FDM0005_Shipping_Plan.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2bb5110 | EditButton | FDM0005_Shipping_Plan.cs:382 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0da7677f | EditButton | FDM0005_Shipping_Plan.cs:388 | if (spdMain != null) ▸ if (bWPPMode == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg2 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-536d1cc7 | EditButton | FDM0005_Shipping_Plan.cs:389 | if (spdMain != null) ▸ if (bWPPMode == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ad7ce57 | EditButton | FDM0005_Shipping_Plan.cs:392 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-96d940bc | EditButton | FDM0005_Shipping_Plan.cs:394 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.INSTANCE_ID), siMain.GetColumnIndex(DefColumns.MARKET), … | 그리드 편집 잠금/해제 |  |  |  |
| AC-28340d0c | EditButton | FDM0005_Shipping_Plan.cs:396 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TO_SITE_ID), siMain.GetColumnIndex(DefColumns.ETA), true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7f8fdbf2 | EditButton | FDM0005_Shipping_Plan.cs:397 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PKG_TYPE), siMain.GetColumnIndex(DefColumns.PKG_TYPE), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8ff52b4b | EditButton | FDM0005_Shipping_Plan.cs:398 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.UPDATE_ID), siMain.GetColumnIndex(DefColumns.VALID_YN), … | 그리드 편집 잠금/해제 |  |  |  |
| AC-dad00d30 | EditButton | FDM0005_Shipping_Plan.cs:407 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-833515d8 | EditButton | FDM0005_Shipping_Plan.cs:408 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-5605413c | EditButton | FDM0005_Shipping_Plan.cs:413 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## FDM0005_Shipping_Plan.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b372c34d | ExcelButton | FDM0005_Shipping_Plan.cs:642 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FDM0005_Shipping_Plan.Find_Data

진입점: this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) ▸ if (dtNewVersion.Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b46cfc00 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:648 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-367c81b2 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:652 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6bb05a9b | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:655 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-bfc7b45d | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:655 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d268c40b | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:661 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-bda6b3ec | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:664 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77aa3798 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:670 | try ▸ if (chkWPP.Checked == true) | FLAG | bWPPMode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-49a85930 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:672 | try ▸ else of (chkWPP.Checked == true) | FLAG | bWPPMode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-928a8f72 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:675 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_ShippingPlan("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f8a52341 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:686 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4305867c | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:688 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7712d562 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:691 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4401d9f9 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:695 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7eed5758 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:703 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-52e69ee7 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:710 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-83efdafb | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:711 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-10850616 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:712 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6fba2e46 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 2 | FDM0005_Shipping_Plan.cs:712 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FDM0005_Shipping_Plan.Find_Data_ShippingPlan

진입점: this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) ▸ if (dtNewVersion.Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / popSql.OnSql [if (programID == "PR_UI_FDM0005_SHIPPING_PLAN_SELECT")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdf23b4a | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:731 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pPlanGroup = CString.GetCheckedListValue(dtInstance, cboP… | ⚠ 의미 확인 필요 |  |  |  |
| AC-774514b7 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:764 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FDM0005_SHIPPING_PLAN") ⇒ FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-ded78e4b | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:765 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-5655e655 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:766 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-b6a2abb7 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:767 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-84e746ff | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:768 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b6c7f281 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:770 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup.Equals("ALL") ? DBNull.Value : pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-402b3a00 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:771 | try | DATA_OP | request.Parameters["p_instance_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-24d5f620 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:772 | try | DATA_OP | request.Parameters["p_version_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c150ba65 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:773 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e594146c | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:774 | try | DATA_OP | request.Parameters["p_division_id"] | pDivision.Equals("ALL") ? DBNull.Value : pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e2cb590a | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:775 | try | DATA_OP | request.Parameters["p_site_id"] | pSite.Equals("ALL") ? DBNull.Value : pSite | 행/컬럼 값 대입 |  |  |  |
| AC-418b022a | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:776 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlant.Equals("ALL") ? DBNull.Value : pPlant | 행/컬럼 값 대입 |  |  |  |
| AC-eb9f5245 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:777 | try | DATA_OP | request.Parameters["p_item_id"] | pItem | 행/컬럼 값 대입 |  |  |  |
| AC-ece371a8 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:778 | try | DATA_OP | request.Parameters["p_item_name"] | pItemName | 행/컬럼 값 대입 |  |  |  |
| AC-3af87234 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:779 | try | DATA_OP | request.Parameters["p_production_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-96ee566d | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:780 | try | DATA_OP | request.Parameters["p_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d5817370 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:781 | try | DATA_OP | request.Parameters["p_transport_mode"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2c0f28cc | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:782 | try | DATA_OP | request.Parameters["p_to_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-78695979 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:783 | try | DATA_OP | request.Parameters["p_to_plant_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8b01b4ec | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:784 | try | DATA_OP | request.Parameters["p_ship_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-395d1c33 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:785 | try | DATA_OP | request.Parameters["p_eta"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4370f0e9 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:786 | try | DATA_OP | request.Parameters["p_ship_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d0952474 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:787 | try | DATA_OP | request.Parameters["p_pkg_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-aff09e2c | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:788 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-699beb83 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:789 | try | DATA_OP | request.Parameters["p_cell_type"] | pCellType | 행/컬럼 값 대입 |  |  |  |
| AC-f66c1353 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:790 | try | DATA_OP | request.Parameters["p_start_date"] | pStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-171097c5 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:791 | try | DATA_OP | request.Parameters["p_end_date"] | pEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-0b5d34fa | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:792 | try | DATA_OP | request.Parameters["p_wpp_type"] | pWppType | 행/컬럼 값 대입 |  |  |  |
| AC-4d5aa42a | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:793 | try | DATA_OP | request.Parameters["p_wpp_week"] | pWppWeek | 행/컬럼 값 대입 |  |  |  |
| AC-339d4537 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:794 | try | DATA_OP | request.Parameters["p_wpp_seq"] | pWppSeq | 행/컬럼 값 대입 |  |  |  |
| AC-2e42b3b0 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:796 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d059ea67 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:798 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b98d49ed | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… 외 3 | FDM0005_Shipping_Plan.cs:803 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FDM0005_Shipping_Plan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b58b58ba | this.Load | FDM0005_Shipping_Plan.cs:118 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FDM0005_Shipping_Plan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e468279 | this.Load | FDM0005_Shipping_Plan.cs:142 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c137c4c5 | this.Load | FDM0005_Shipping_Plan.cs:148 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-8c1287dd | this.Load | FDM0005_Shipping_Plan.cs:149 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-81c688a1 | this.Load | FDM0005_Shipping_Plan.cs:152 | try | FLAG | dtInstance | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0005_findInstanceList_common", "LINE_… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-80294e48 | this.Load | FDM0005_Shipping_Plan.cs:152 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0005_findInstanceList_common", "LINE_AMEND_E_PRE") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-524f4ada | this.Load | FDM0005_Shipping_Plan.cs:153 | try | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboPlanGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e7b3afb4 | this.Load | FDM0005_Shipping_Plan.cs:158 | try | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-a53b8a97 | this.Load | FDM0005_Shipping_Plan.cs:158 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, sIns… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-69caa2d0 | this.Load | FDM0005_Shipping_Plan.cs:161 | try ▸ if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-391b5d48 | this.Load | FDM0005_Shipping_Plan.cs:164 | try | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-83151d96 | this.Load | FDM0005_Shipping_Plan.cs:166 | try | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-87591e9f | this.Load | FDM0005_Shipping_Plan.cs:169 | try | FLAG | dtCellType | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0005_find_cellType") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-4d027e6d | this.Load | FDM0005_Shipping_Plan.cs:169 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0005_find_cellType") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9e5a28a0 | this.Load | FDM0005_Shipping_Plan.cs:170 | try | LIST_REBIND | clsCtrl.setListBox | (dtCellType, cboCellType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b9ccf061 | this.Load | FDM0005_Shipping_Plan.cs:173 | try | FLAG | dtWppWeek | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0005_find_WPPWeek") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-3d9cee60 | this.Load | FDM0005_Shipping_Plan.cs:173 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0005_find_WPPWeek") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f113e54c | this.Load | FDM0005_Shipping_Plan.cs:174 | try | LIST_REBIND | clsCtrl.setListBox | (dtWppWeek, cboWppWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3bfb3377 | this.Load | FDM0005_Shipping_Plan.cs:179 | try | FLAG | dtWppSeq | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0005_find_WPPSeq", sInstanceID, sWppW… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-cd2a72b9 | this.Load | FDM0005_Shipping_Plan.cs:179 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0005_find_WPPSeq", sInstanceID, sWppWeek) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-84ec89c1 | this.Load | FDM0005_Shipping_Plan.cs:180 | try | LIST_REBIND | clsCtrl.setListBox | (dtWppSeq, cboWppSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-dc0b8fc5 | this.Load | FDM0005_Shipping_Plan.cs:186 | try | VALUE_SET | drpPeriod.InitValue | sStartday.ToString() + ":" + sEndday.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-0b3668d8 | this.Load | FDM0005_Shipping_Plan.cs:189 | try | FLAG | dtCurrVersion | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0005_find_currVersion", sInstanceID) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-dd1eb0d6 | this.Load | FDM0005_Shipping_Plan.cs:189 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0005_find_currVersion", sInstanceID) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d51700ef | this.Load | FDM0005_Shipping_Plan.cs:190 | try | FLAG | dtPancakeType | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0005_find_pancakeType") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-81cf22b3 | this.Load | FDM0005_Shipping_Plan.cs:190 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0005_find_pancakeType") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6721b458 | this.Load | FDM0005_Shipping_Plan.cs:196 | try | UI_PROP | lblWppWeek.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a360b063 | this.Load | FDM0005_Shipping_Plan.cs:197 | try | UI_PROP | lblWppSeq.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-766ebc37 | this.Load | FDM0005_Shipping_Plan.cs:203 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-7e638a58 | this.Load | FDM0005_Shipping_Plan.cs:204 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b69107dd | this.Load | FDM0005_Shipping_Plan.cs:205 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a4eac152 | this.Load | FDM0005_Shipping_Plan.cs:211 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FDM0005_Shipping_Plan.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d735604 | this.Load | FDM0005_Shipping_Plan.cs:321 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f97d320 | this.Load | FDM0005_Shipping_Plan.cs:322 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-789697e1 | this.Load | FDM0005_Shipping_Plan.cs:326 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FDM0005_Shipping_Plan.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1c4db69 | InsertButton | FDM0005_Shipping_Plan.cs:620 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-85468d57 | InsertButton | FDM0005_Shipping_Plan.cs:625 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-c64d92d8 | InsertButton | FDM0005_Shipping_Plan.cs:626 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-b0ffd8f3 | InsertButton | FDM0005_Shipping_Plan.cs:629 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.INSTANCE_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5432709b | InsertButton | FDM0005_Shipping_Plan.cs:630 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.MA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4c026cdc | InsertButton | FDM0005_Shipping_Plan.cs:631 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TO_SITE_ID), siMain.GetColumnIndex(DefColumns.T… | 그리드 편집 잠금/해제 |  |  |  |
| AC-891efc86 | InsertButton | FDM0005_Shipping_Plan.cs:632 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ETA), siMain.GetColumnIndex(DefColumns.ETA), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0d2e1fdf | InsertButton | FDM0005_Shipping_Plan.cs:633 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.PKG_TYPE), siMain.GetColumnIndex(DefColumns.PKG… | 그리드 편집 잠금/해제 |  |  |  |
| AC-465476b0 | InsertButton | FDM0005_Shipping_Plan.cs:634 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.UPDATE_ID), siMain.GetColumnIndex(DefColumns.VA… | 그리드 편집 잠금/해제 |  |  |  |

## FDM0005_Shipping_Plan.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c379752 | popSql.OnSql | FDM0005_Shipping_Plan.cs:1403 | if (programID == "PR_UI_FDM0005_SHIPPING_PLAN_SELECT") | RETURN | return Find_Data_ShippingPlan("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-57b1cd76 | popSql.OnSql | FDM0005_Shipping_Plan.cs:1407 | else of (programID == "PR_UI_FDM0005_SHIPPING_PLAN_SELECT") ▸ if (programID == "PR_UI_FDM0005_SHIPPING_PLAN_SAVE") | RETURN | return Save_Data_ShippingPlan("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-28c058e7 | popSql.OnSql | FDM0005_Shipping_Plan.cs:1409 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FDM0005_Shipping_Plan.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-980c6301 | SaveButton | FDM0005_Shipping_Plan.cs:814 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5d6ad82a | SaveButton | FDM0005_Shipping_Plan.cs:816 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9693bf12 | SaveButton | FDM0005_Shipping_Plan.cs:820 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-94fc610e | SaveButton | FDM0005_Shipping_Plan.cs:821 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ef30275 | SaveButton | FDM0005_Shipping_Plan.cs:824 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-db79bca9 | SaveButton | FDM0005_Shipping_Plan.cs:831 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-85da9000 | SaveButton | FDM0005_Shipping_Plan.cs:833 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0f352133 | SaveButton | FDM0005_Shipping_Plan.cs:834 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4033a8a0 | SaveButton | FDM0005_Shipping_Plan.cs:851 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == "D") ▸ if (!sValidYN.Equals("Y")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg2 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c6514c13 | SaveButton | FDM0005_Shipping_Plan.cs:852 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == "D") ▸ if (!sValidYN.Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef7cbfec | SaveButton | FDM0005_Shipping_Plan.cs:861 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d476f442 | SaveButton | FDM0005_Shipping_Plan.cs:866 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3086848a | SaveButton | FDM0005_Shipping_Plan.cs:875 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cfb3db57 | SaveButton | FDM0005_Shipping_Plan.cs:879 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c0eb902c | SaveButton | FDM0005_Shipping_Plan.cs:883 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c3e68ede | SaveButton | FDM0005_Shipping_Plan.cs:884 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-591cdf03 | SaveButton | FDM0005_Shipping_Plan.cs:889 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FDM0005_Shipping_Plan.Save_Data_CreateWPP

진입점: this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WPP] with the current version.\r\nDo you want to proceed?", "Comfirm", MessageBoxButtons.OK…) ▸ if (dtNewVersion.Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2dd4bd09 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1093 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FDM0005_SHIPPING_PLAN") ⇒ FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-2323f005 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1094 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-68dcf66c | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1096 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-904e8bab | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1097 | try | DATA_OP | req.Parameters["p_sys_flag"] | "INSERT_CREATE_WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-3230f27a | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1098 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4fa4513d | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1099 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-aec5248a | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1100 | try | DATA_OP | req.Parameters["p_instance_id"] | pInstance | 행/컬럼 값 대입 |  |  |  |
| AC-e5f86ebd | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1101 | try | DATA_OP | req.Parameters["p_instance_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5c23d9f0 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1102 | try | DATA_OP | req.Parameters["p_version_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-87b13815 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1103 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f5b9839d | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1104 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fcb45ce9 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1105 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3b9947f9 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1106 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-48044cd9 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1107 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c21c195a | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1108 | try | DATA_OP | req.Parameters["p_item_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b26106bd | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1109 | try | DATA_OP | req.Parameters["p_production_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-544f5594 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1110 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-84ff7659 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1111 | try | DATA_OP | req.Parameters["p_transport_mode"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-67464ee4 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1112 | try | DATA_OP | req.Parameters["p_to_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-033cd3f6 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1113 | try | DATA_OP | req.Parameters["p_to_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3fdfef5d | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1114 | try | DATA_OP | req.Parameters["p_ship_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-42ff178a | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1115 | try | DATA_OP | req.Parameters["p_eta"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-530294e0 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1116 | try | DATA_OP | req.Parameters["p_ship_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-310d0b9f | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1117 | try | DATA_OP | req.Parameters["p_pkg_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c833844d | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1118 | try | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e2d06ab5 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1119 | try | DATA_OP | req.Parameters["p_cell_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5232e776 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1120 | try | DATA_OP | req.Parameters["p_start_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eca82023 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1121 | try | DATA_OP | req.Parameters["p_end_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-148907fd | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1122 | try | DATA_OP | req.Parameters["p_wpp_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f2a18f93 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1123 | try | DATA_OP | req.Parameters["p_wpp_week"] | pWppWeek | 행/컬럼 값 대입 |  |  |  |
| AC-b578b045 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1124 | try | DATA_OP | req.Parameters["p_wpp_seq"] | pWppSeq | 행/컬럼 값 대입 |  |  |  |
| AC-216001a8 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1126 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-09c0a33e | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1127 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-fd03ea57 | this.btnCreateWPP.Click [if (MessageBox.Show("Run [Create WP… | FDM0005_Shipping_Plan.cs:1132 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FDM0005_Shipping_Plan.Save_Data_ShippingPlan

진입점: popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_PLAN_SELECT") ▸ if (programID == "PR_UI_FDM0005_SHIPPING_PLAN_SAVE")] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-007d7715 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1004 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FDM0005_SHIPPING_PLAN") ⇒ FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-959e178f | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1005 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e4eae54c | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1007 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-9805b273 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1008 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-9c4df277 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1009 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-bb847a3e | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1010 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-d2909b75 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1011 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-598f1885 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1012 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_date"] | p_instance_date | 행/컬럼 값 대입 |  |  |  |
| AC-c5cc2fc4 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1013 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version_id"] | p_version_id | 행/컬럼 값 대입 |  |  |  |
| AC-fee28ad6 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1014 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-ac8a9ee7 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1015 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e9e1bf3f | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1016 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-5dd11803 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1017 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-feee1460 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1018 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-6d55e2e3 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1019 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_name"] | p_item_name | 행/컬럼 값 대입 |  |  |  |
| AC-a2840c12 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1020 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-89650e69 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1021 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-20b30a56 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1022 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-10b80609 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1023 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_to_site_id"] | p_to_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-26728d93 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1024 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_to_plant_id"] | p_to_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-1478fe77 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1025 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_ship_date"] | p_ship_date | 행/컬럼 값 대입 |  |  |  |
| AC-2eeb398a | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1026 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_eta"] | p_eta | 행/컬럼 값 대입 |  |  |  |
| AC-2d4347fe | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1027 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_ship_qty"] | p_ship_qty | 행/컬럼 값 대입 |  |  |  |
| AC-76a21a5b | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1028 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_pkg_type"] | p_pkg_type | 행/컬럼 값 대입 |  |  |  |
| AC-628dd7e6 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1029 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-33300b84 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1030 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_type"] | p_cell_type | 행/컬럼 값 대입 |  |  |  |
| AC-6f4e6b0d | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1031 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_start_date"] | p_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-0f5fb21f | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1032 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_end_date"] | p_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-ddef76bf | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1033 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_wpp_type"] | p_wpp_type | 행/컬럼 값 대입 |  |  |  |
| AC-7c2501b3 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1034 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_wpp_week"] | p_wpp_week | 행/컬럼 값 대입 |  |  |  |
| AC-388d136a | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1035 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_wpp_seq"] | p_wpp_seq | 행/컬럼 값 대입 |  |  |  |
| AC-93306446 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1037 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e9604a50 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1038 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8ab23902 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1044 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-055403b0 | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1045 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-9e1402bc | popSql.OnSql [else of (programID == "PR_UI_FDM0005_SHIPPING_… 외 1 | FDM0005_Shipping_Plan.cs:1051 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FDM0005_Shipping_Plan.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e714d58 | SaveButton | FDM0005_Shipping_Plan.cs:455 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FDM0005_Shipping_Plan.SetChangedControl

진입점: this.Load [try] / cboPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5610cd64 | this.Load [try] 외 1 | FDM0005_Shipping_Plan.cs:248 | try | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-fdab1de8 | this.Load [try] 외 1 | FDM0005_Shipping_Plan.cs:248 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pIns… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cd520204 | this.Load [try] 외 1 | FDM0005_Shipping_Plan.cs:249 | try | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-b49685e3 | this.Load [try] 외 1 | FDM0005_Shipping_Plan.cs:253 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8efc742 | this.Load [try] 외 1 | FDM0005_Shipping_Plan.cs:255 | try | FLAG | dtSiteByDivision | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", pInsta… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-c47afab3 | this.Load [try] 외 1 | FDM0005_Shipping_Plan.cs:255 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", pInstanceID, "", "", ""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9678a435 | this.Load [try] 외 1 | FDM0005_Shipping_Plan.cs:256 | try | LIST_REBIND | clsCtrl.setListBox | (dtSiteByDivision, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-35a5e52c | this.Load [try] 외 1 | FDM0005_Shipping_Plan.cs:260 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c1b87d8 | this.Load [try] 외 1 | FDM0005_Shipping_Plan.cs:262 | try | FLAG | dtPlantByDivision | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-9a866b64 | this.Load [try] 외 1 | FDM0005_Shipping_Plan.cs:262 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pInstan… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4ffc5215 | this.Load [try] 외 1 | FDM0005_Shipping_Plan.cs:263 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-62bd4191 | this.Load [try] 외 1 | FDM0005_Shipping_Plan.cs:269 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FDM0005_Shipping_Plan.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac73e996 | this.Load [try] | FDM0005_Shipping_Plan.cs:335 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8aec36d6 | this.Load [try] | FDM0005_Shipping_Plan.cs:336 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-bcc27f28 | this.Load [try] | FDM0005_Shipping_Plan.cs:341 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-1b37b85f | this.Load [try] | FDM0005_Shipping_Plan.cs:342 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.PLANT_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-409b6672 | this.Load [try] | FDM0005_Shipping_Plan.cs:345 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INSTANCE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4710c31d | this.Load [try] | FDM0005_Shipping_Plan.cs:346 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INSTANCE_DATE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-216b3073 | this.Load [try] | FDM0005_Shipping_Plan.cs:347 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.VERSION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-160dc364 | this.Load [try] | FDM0005_Shipping_Plan.cs:348 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-145fe661 | this.Load [try] | FDM0005_Shipping_Plan.cs:349 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a8605537 | this.Load [try] | FDM0005_Shipping_Plan.cs:350 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MARKET)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-39f8f9f1 | this.Load [try] | FDM0005_Shipping_Plan.cs:351 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.WPP_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e7bc4e40 | this.Load [try] | FDM0005_Shipping_Plan.cs:352 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MESSAGE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ed6aa344 | this.Load [try] | FDM0005_Shipping_Plan.cs:353 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.VALID_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FDM0005_Shipping_Plan.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98410475 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1268 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae7b982f | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1270 | try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc12e886 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1293 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | POPUP | new FDM0005_ItemPopup | (bFilterEnable, bMultiSelect, pDivision, pSite, pPlant) | 팝업/폼 생성 |  |  |  |
| AC-93c71f1f | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1294 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-eb4785e7 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1295 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4823d2df | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1312 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID), pCompany) | 그리드 값 설정 |  |  |  |
| AC-3bbf35fd | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1313 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.INSTANCE_ID), pInstance) | 그리드 값 설정 |  |  |  |
| AC-5cd0b91d | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1314 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.INSTANCE_DATE), pInstanceDate) | 그리드 값 설정 |  |  |  |
| AC-c4f5a772 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1315 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.VERSION_ID), pVersion) | 그리드 값 설정 |  |  |  |
| AC-94ba1401 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1316 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), pDivision) | 그리드 값 설정 |  |  |  |
| AC-feee40f2 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1317 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID), pSite) | 그리드 값 설정 |  |  |  |
| AC-d988ee82 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1318 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), pPlant) | 그리드 값 설정 |  |  |  |
| AC-36063563 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1319 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), pItem) | 그리드 값 설정 |  |  |  |
| AC-867c0216 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1320 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), pItemName) | 그리드 값 설정 |  |  |  |
| AC-78522eb7 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1333 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg2 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d5db6bc3 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1334 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba65e602 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1337 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | POPUP | new FDM0005_TransportModePopup | (pPlant) | 팝업/폼 생성 |  |  |  |
| AC-b3909dbe | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1338 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | UI_PROP | popTransMode.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-92e70924 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1339 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | POPUP | popTransMode.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8a6e545d | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1346 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), pTransportMode) | 그리드 값 설정 |  |  |  |
| AC-0c2ec48f | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1347 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_ID), pShiptoSite) | 그리드 값 설정 |  |  |  |
| AC-c36f7186 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1348 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TO_PLANT_ID), pShiptoPlant) | 그리드 값 설정 |  |  |  |
| AC-d633fcdd | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1355 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SHIP_DATE), pShipDate) | 그리드 값 설정 |  |  |  |
| AC-596e3a24 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1356 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ETA), pETA) | 그리드 값 설정 |  |  |  |
| AC-8b466155 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1386 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-d8f502b4 | this.spdMain.CellClick | FDM0005_Shipping_Plan.cs:1389 |  | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FDM0005_TransportModePopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-268b4ce4 | .ctor | FDM0005_TransportModePopup.cs:118 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d045aa09 | .ctor | FDM0005_TransportModePopup.cs:119 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-30fa6a45 | .ctor | FDM0005_TransportModePopup.cs:120 |  | FLAG | this._sDivision | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-9f9d75f3 | .ctor | FDM0005_TransportModePopup.cs:129 |  | FLAG | this._sPlant | pPlant | 화면 필드/플래그 변경 |  |  |  |

## FDM0005_TransportModePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5831a62c | this.btnButtonList.UsrButtonList_Click_Detected | FDM0005_TransportModePopup.cs:346 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-501d3ce4 | this.btnButtonList.UsrButtonList_Click_Detected | FDM0005_TransportModePopup.cs:349 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FDM0005_TransportModePopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bc7aef8 | this.btnSql.Click | FDM0005_TransportModePopup.cs:216 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f8826ccb | this.btnSql.Click | FDM0005_TransportModePopup.cs:217 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9cd375ac | this.btnSql.Click | FDM0005_TransportModePopup.cs:219 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FDM0005_SELECT_TRANSPORTMODEPOPUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-25ceb79b | this.btnSql.Click | FDM0005_TransportModePopup.cs:220 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FDM0005_TransportModePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-142676fc | this.Load | FDM0005_TransportModePopup.cs:164 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3cee92dd | this.Load | FDM0005_TransportModePopup.cs:165 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-58025587 | this.Load | FDM0005_TransportModePopup.cs:166 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FDM0005_TransportModePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b910845b | this.Load | FDM0005_TransportModePopup.cs:159 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FDM0005_TransportModePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18a455c4 | Dispose | FDM0005_TransportModePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FDM0005_TransportModePopup.Find_Data_TransMode

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ lambda] / this.Load [try ▸ lambda] / popSql.OnSql [if (programID == "PR_UI_FDM0005_SELECT_TRANSPORTMODEPOPUP")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-893f01c2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:270 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pPlantID = _sPlant; })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ece37a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:277 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FDM0005_SHIPPING_PLAN") ⇒ FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-9fe05f9a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:279 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-489e04b0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:281 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-466c36b4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:282 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_TRANSPORTMODE_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-e2bc9a4e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:283 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3d7d8c80 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:284 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f7304cbd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:286 | try | DATA_OP | request.Parameters["p_instance_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e27a026f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:287 | try | DATA_OP | request.Parameters["p_instance_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8964f3eb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:288 | try | DATA_OP | request.Parameters["p_version_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-beaffdc0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:289 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bb48f617 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:290 | try | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-30d95ae3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:291 | try | DATA_OP | request.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-08c7a3db | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:292 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-29f7d1d2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:293 | try | DATA_OP | request.Parameters["p_item_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d7ab3d6c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:294 | try | DATA_OP | request.Parameters["p_item_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2f8e9deb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:295 | try | DATA_OP | request.Parameters["p_production_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-33cb9d39 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:296 | try | DATA_OP | request.Parameters["p_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-be594227 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:297 | try | DATA_OP | request.Parameters["p_transport_mode"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fc21b1a9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:298 | try | DATA_OP | request.Parameters["p_to_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7f5e2673 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:299 | try | DATA_OP | request.Parameters["p_to_plant_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-730e94cf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:300 | try | DATA_OP | request.Parameters["p_ship_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f5ca10f8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:301 | try | DATA_OP | request.Parameters["p_eta"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-294c5279 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:302 | try | DATA_OP | request.Parameters["p_ship_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-005122be | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:303 | try | DATA_OP | request.Parameters["p_pkg_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5388a1e2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:304 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8a5da7e3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:305 | try | DATA_OP | request.Parameters["p_cell_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ebeb0fa4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:306 | try | DATA_OP | request.Parameters["p_start_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e01f65aa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:307 | try | DATA_OP | request.Parameters["p_end_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6501abf5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:308 | try | DATA_OP | request.Parameters["p_wpp_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-975b56a1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:309 | try | DATA_OP | request.Parameters["p_wpp_week"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d2b16295 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:310 | try | DATA_OP | request.Parameters["p_wpp_seq"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c953da08 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:312 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ac192c52 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:315 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-1dfcac0f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FDM0005_TransportModePopup.cs:320 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FDM0005_TransportModePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-690d5a59 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_TransportModePopup.cs:234 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-22eeefb3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_TransportModePopup.cs:235 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-956a3fac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_TransportModePopup.cs:238 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_TransMode("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0612fe82 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_TransportModePopup.cs:244 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4d4a965e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_TransportModePopup.cs:247 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-08a60780 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_TransportModePopup.cs:249 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-4a25b71f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_TransportModePopup.cs:255 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-64bdbba5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FDM0005_TransportModePopup.cs:260 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FDM0005_TransportModePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f32fe3d2 | this.Load | FDM0005_TransportModePopup.cs:137 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3cb0a7d0 | this.Load | FDM0005_TransportModePopup.cs:139 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FDM0005_TransportModePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b515281f | this.Load | FDM0005_TransportModePopup.cs:176 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f5c393aa | this.Load | FDM0005_TransportModePopup.cs:177 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FDM0005_TransportModePopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c28b982a | (진입점 미연결) | FDM0005_TransportModePopup.cs:201 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FDM0005_TransportModePopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5a3646e | popSql.OnSql | FDM0005_TransportModePopup.cs:400 | if (programID == "PR_UI_FDM0005_SELECT_TRANSPORTMODEPOPUP") | RETURN | return Find_Data_TransMode("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-9969faec | popSql.OnSql | FDM0005_TransportModePopup.cs:402 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FDM0005_TransportModePopup.SetLineInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01be9d3a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FDM0005_TransportModePopup.cs:384 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee078ce6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FDM0005_TransportModePopup.cs:385 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a33aeb55 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FDM0005_TransportModePopup.cs:386 |  | FLAG | _ShipToSiteId | this.dtFindData.Rows[iClick_Row][DefColumns.TO_SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f8ddc81c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FDM0005_TransportModePopup.cs:387 |  | FLAG | _ShipToPlantId | this.dtFindData.Rows[iClick_Row][DefColumns.TO_PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b315109d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FDM0005_TransportModePopup.cs:388 |  | FLAG | _TransportMode | this.dtFindData.Rows[iClick_Row][DefColumns.TRANSPORT_MODE].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8cebd96e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FDM0005_TransportModePopup.cs:392 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FDM0005_TransportModePopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1edadcfe | this.Load | FDM0005_TransportModePopup.cs:183 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b5238b8 | this.Load | FDM0005_TransportModePopup.cs:184 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-03030e7a | this.Load | FDM0005_TransportModePopup.cs:188 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-1227b85b | this.Load | FDM0005_TransportModePopup.cs:191 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FROM_PLANT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7fdd261d | this.Load | FDM0005_TransportModePopup.cs:192 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TO_PLANT_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-fdd8bbbd | this.Load | FDM0005_TransportModePopup.cs:193 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.LT_TOTAL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b253cf58 | this.Load | FDM0005_TransportModePopup.cs:194 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FDM0005_TransportModePopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14a39195 | this.spdMain.CellClick | FDM0005_TransportModePopup.cs:360 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FDM0005_TransportModePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9db84a1f | this.spdMain.CellDoubleClick | FDM0005_TransportModePopup.cs:365 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-4f625b8e | this.spdMain.CellDoubleClick | FDM0005_TransportModePopup.cs:367 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d1c7c78 | this.spdMain.CellDoubleClick | FDM0005_TransportModePopup.cs:369 |  | FLAG | _ShipToSiteId | this.dtFindData.Rows[e.Row][DefColumns.TO_SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d74fa77c | this.spdMain.CellDoubleClick | FDM0005_TransportModePopup.cs:370 |  | FLAG | _ShipToPlantId | this.dtFindData.Rows[e.Row][DefColumns.TO_PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b7e8a8c7 | this.spdMain.CellDoubleClick | FDM0005_TransportModePopup.cs:371 |  | FLAG | _TransportMode | this.dtFindData.Rows[e.Row][DefColumns.TRANSPORT_MODE].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-bc284f0f | this.spdMain.CellDoubleClick | FDM0005_TransportModePopup.cs:374 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

