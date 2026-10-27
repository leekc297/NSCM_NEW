# AS-IS 액션 대조표 — FP00540

> 원천: `Doc/asisfacts/screens/FP00540/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 193행 · 메서드 23 · 종류 DATA_OP 58 · FLAG 39 · RETURN 13 · UI_PROP 11 · COMBO_DATA 11 · LIST_REBIND 11 · ENDPOINT 9 · GRID_SET 8 · POPUP 6 · GRID_INIT 5 · STATE 4 · UI_MISC 4 · CALL_EXT 4 · MESSAGE 3 · THROW 2 · EXCEL 1 · CALL_BASE 1 · VALIDATE 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 5


## FP00540_SSP_Shipping_Plan.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-432cf993 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:614 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d02f0914 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:615 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c0fdc47b | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:619 |  | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d4eb580a | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:622 |  | DATA_OP | p.Filter["instance_id"] | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-8d842063 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:623 |  | DATA_OP | p.Filter["division_id"] | CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-1f7e8165 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:624 |  | DATA_OP | p.Filter["site_id"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-aa0b8ce7 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:625 |  | DATA_OP | p.Filter["plant_id"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-07ebc0ee | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:626 |  | DATA_OP | p.Filter["scp_plan_id"] | CString.GetCheckedListValue(dtScpPlanId, cboScpPlanId.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-63ed643f | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:627 |  | DATA_OP | p.Filter["production_type"] | CString.GetCheckedListValue(dtProductionType, cboProductionType.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-e613eee0 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:628 |  | DATA_OP | p.Filter["item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-6ca90958 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:629 |  | DATA_OP | p.Filter["nick_name"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-9e87d04a | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:630 |  | DATA_OP | p.Filter["user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0d8076f5 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:632 |  | GRID_SET | p.KeyColumns["COMPANY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f533f38f | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:633 |  | GRID_SET | p.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e8eaa495 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:634 |  | GRID_SET | p.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5e2b434e | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:635 |  | GRID_SET | p.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6729d715 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:636 |  | GRID_SET | p.KeyColumns["SHOP_GROUP_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-95d54779 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:637 |  | GRID_SET | p.KeyColumns["SCP_PLAN_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1999633d | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:638 |  | GRID_SET | p.KeyColumns["SCP_TARGET_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-58513df4 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:639 |  | GRID_SET | p.KeyColumns["FP_TARGET_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9263ebfe | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:641 |  | DATA_OP | p.ColumnTitle["COMPANY_ID"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-55ece150 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:642 |  | DATA_OP | p.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-d786eee4 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:643 |  | DATA_OP | p.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-6a240a84 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:644 |  | DATA_OP | p.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-5f60d0f3 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:645 |  | DATA_OP | p.ColumnTitle["SHOP_GROUP_ID"] | "Shop" | 행/컬럼 값 대입 |  |  |  |
| AC-739802a9 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:646 |  | DATA_OP | p.ColumnTitle["SCP_PLAN_ID"] | "SCP Plan ID" | 행/컬럼 값 대입 |  |  |  |
| AC-20c4affb | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:647 |  | DATA_OP | p.ColumnTitle["SCP_TARGET_ID"] | "SCP Demand ID" | 행/컬럼 값 대입 |  |  |  |
| AC-1dfd7991 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:648 |  | DATA_OP | p.ColumnTitle["FP_TARGET_ID"] | "FP Target ID" | 행/컬럼 값 대입 |  |  |  |
| AC-6ac6e002 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:649 |  | DATA_OP | p.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-71941b83 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:650 |  | DATA_OP | p.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-7bdfa388 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:651 |  | DATA_OP | p.ColumnTitle["TO_SITE_ID"] | "To Site" | 행/컬럼 값 대입 |  |  |  |
| AC-0b0e4312 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:652 |  | DATA_OP | p.ColumnTitle["TO_PLANT_ID"] | "To Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-de01910b | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:653 |  | DATA_OP | p.ColumnTitle["CUSTOMER_ID"] | "Customer" | 행/컬럼 값 대입 |  |  |  |
| AC-64fe8abe | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:654 |  | DATA_OP | p.ColumnTitle["SHIP_WEEK"] | "Ship Week" | 행/컬럼 값 대입 |  |  |  |
| AC-e2e4046d | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:655 |  | DATA_OP | p.ColumnTitle["SHIP_DATE"] | "Ship Date" | 행/컬럼 값 대입 |  |  |  |
| AC-450c5cf3 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:656 |  | DATA_OP | p.ColumnTitle["SHIP_QTY"] | "Ship Qty" | 행/컬럼 값 대입 |  |  |  |
| AC-50af587d | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:657 |  | DATA_OP | p.ColumnTitle["PRODUCTION_TYPE"] | "Production Type" | 행/컬럼 값 대입 |  |  |  |
| AC-efdccc6f | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:658 |  | DATA_OP | p.ColumnTitle["TRANSPORT_MODE"] | "Transport Mode" | 행/컬럼 값 대입 |  |  |  |
| AC-06d6525d | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:659 |  | DATA_OP | p.ColumnTitle["BIZ_TYPE"] | "Biz Type" | 행/컬럼 값 대입 |  |  |  |
| AC-d015e466 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:660 |  | DATA_OP | p.ColumnTitle["CONFIRM_TYPE"] | "Confirm Type" | 행/컬럼 값 대입 |  |  |  |
| AC-f02bc8d7 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:662 |  | DATA_OP | p.ColumnWidth["INSTANCE_ID"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-f877ff0c | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:664 |  | UI_PROP | p.DoSearchData | FP00540_SearchDataDelegate | 속성 DoSearchData 설정 |  |  |  |
| AC-1232c500 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:665 |  | UI_PROP | p.DoLineCheck | FP00540_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-20040405 | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:666 |  | UI_PROP | p.DoSaveData | FP00540_SaveDataDelegate | 속성 DoSaveData 설정 |  |  |  |
| AC-862106ef | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:667 |  | UI_PROP | p.DoValidationData | FP00540_ValidateDataDelegate | 속성 DoValidationData 설정 |  |  |  |
| AC-1fef46be | this.btnExcelImport.Click | FP00540_SSP_Shipping_Plan.cs:668 |  | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00540_SSP_Shipping_Plan.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb6c8886 | this.btnSql.Click | FP00540_SSP_Shipping_Plan.cs:270 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f07bc15c | this.btnSql.Click | FP00540_SSP_Shipping_Plan.cs:271 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-81f17f1a | this.btnSql.Click | FP00540_SSP_Shipping_Plan.cs:273 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00540_SSP_SHIPPING_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-c9c8ba05 | this.btnSql.Click | FP00540_SSP_Shipping_Plan.cs:274 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00540_SSP_Shipping_Plan.CboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3e29c6d | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:482 |  | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-c4777a8d | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:483 |  | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-74551dba | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:484 |  | FLAG | dtScpPlanId | Data_FP.Common_FP(Data_FP.Type.SCP_PLAN, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SCP_PLAN] | 화면 필드/플래그 변경 |  |  |  |
| AC-6e999f33 | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:484 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SCP_PLAN, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth , pIn… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SCP_PLAN] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6433a3d8 | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:488 |  | LIST_REBIND | clsCtrl.setListBox | (dtScpPlanId, cboScpPlanId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-42b507cb | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:491 |  | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-b51574b3 | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:492 |  | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-908a3a96 | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:493 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-e5f07ca1 | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:493 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pInstanc… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f86e4b76 | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:494 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9023ecac | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:498 |  | FLAG | sDataID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-6ca32987 | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:499 |  | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-43d18aa5 | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:500 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-5dbc8a66 | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:500 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pInstan… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b666bb02 | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:501 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9aca5405 | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:504 |  | FLAG | dtProductionType | Data_FP.Common_FP(Data_FP.Type.LOOKUP_CODE_TARGET, false, UserInfoContext.Current.UserId, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_TARGET] | 화면 필드/플래그 변경 |  |  |  |
| AC-ee070a07 | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:504 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LOOKUP_CODE_TARGET, false, UserInfoContext.Current.UserId, _sNonAuth, _sSave… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_TARGET] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-112c362c | cboDivision.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:505 |  | LIST_REBIND | clsCtrl.setListBox | (dtProductionType, cboProductionType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00540_SSP_Shipping_Plan.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7676c3b | cboSite.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:516 |  | FLAG | sDataID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-71c7aaf1 | cboSite.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:517 |  | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-70b3208a | cboSite.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:518 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-1b0b38e4 | cboSite.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:518 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7889bc5a | cboSite.SelectedIndexChanged | FP00540_SSP_Shipping_Plan.cs:519 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00540_SSP_Shipping_Plan.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d104fe6 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:570 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00540_SSP_Shipping_Plan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a862f5c3 | this.Load | FP00540_SSP_Shipping_Plan.cs:226 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c969840e | this.Load | FP00540_SSP_Shipping_Plan.cs:227 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f7884b8b | this.Load | FP00540_SSP_Shipping_Plan.cs:228 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00540_SSP_Shipping_Plan.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38e61c23 | this.Load | FP00540_SSP_Shipping_Plan.cs:133 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-16879c85 | this.Load | FP00540_SSP_Shipping_Plan.cs:134 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-969166db | this.Load | FP00540_SSP_Shipping_Plan.cs:135 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-70f1a06e | this.Load | FP00540_SSP_Shipping_Plan.cs:139 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-10269301 | this.Load | FP00540_SSP_Shipping_Plan.cs:140 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-a7f2dab4 | this.Load | FP00540_SSP_Shipping_Plan.cs:141 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00540_SSP_Shipping_Plan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71469dfb | Dispose | FP00540_SSP_Shipping_Plan.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00540_SSP_Shipping_Plan.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f46c738 | EditButton | FP00540_SSP_Shipping_Plan.cs:252 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bdfdb2ec | EditButton | FP00540_SSP_Shipping_Plan.cs:253 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00540_SSP_Shipping_Plan.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e65ef829 | ExcelButton | FP00540_SSP_Shipping_Plan.cs:263 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00540_SSP_Shipping_Plan.Find_Data_Excel_Execute

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2dd3eff3 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:443 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00540_SSP_SHIPPING_PLAN") ⇒ FP_Master.PR_UI_FP00540_SSP_SHIPPING_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-b8eb6e0d | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:444 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fefa4be2 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:445 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-5b74523f | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:446 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-afce7aaf | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:447 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0db952c7 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:448 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-d948137d | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:450 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstanceID.Equals("ALL") ? DBNull.Value : pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-a2fc1a65 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:451 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-80639083 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:452 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-cd950230 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:453 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-72e62f4b | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:454 | try | DATA_OP | request.Parameters["p_scp_plan_id"] | pScpPlanID.Equals("ALL") ? DBNull.Value : pScpPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-16885eea | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:455 | try | DATA_OP | request.Parameters["p_production_type"] | pProductionType.Equals("ALL") ? DBNull.Value : pProductionType | 행/컬럼 값 대입 |  |  |  |
| AC-f67f7526 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:456 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-ebd01483 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:457 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-aaaaa119 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:459 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3a38abc8 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:461 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6ca5c324 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:468 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00540_SSP_Shipping_Plan.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_PLAN")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16db3a84 | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:359 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pInstanceID = CString.GetCheckedListValue(dtInstance, cbo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-258a1942 | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:361 | try ▸ lambda | FLAG | pInstanceID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-ce929cd6 | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:362 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-7254e53e | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:363 | try ▸ lambda | FLAG | pScpPlanID | CString.GetCheckedListValue(dtScpPlanId, cboScpPlanId.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-41b737d6 | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:364 | try ▸ lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-1e1c312e | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:365 | try ▸ lambda | FLAG | pPlantID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-61d06a6c | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:366 | try ▸ lambda | FLAG | pProductionType | CString.GetCheckedListValue(dtProductionType, cboProductionType.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd480771 | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:387 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00540_SSP_SHIPPING_PLAN") ⇒ FP_Master.PR_UI_FP00540_SSP_SHIPPING_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-9fe5fd4e | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:388 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a97ae43c | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:389 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-f74c05c6 | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:390 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-0a42d5ed | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:391 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6b2e02c2 | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:392 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-4e7005b3 | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:394 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstanceID.Equals("ALL") ? DBNull.Value : pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-629a507e | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:395 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-628ddc7e | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:396 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-99b9dade | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:397 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-52014aee | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:398 | try | DATA_OP | request.Parameters["p_scp_plan_id"] | pScpPlanID.Equals("ALL") ? DBNull.Value : pScpPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-2be1ef1a | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:399 | try | DATA_OP | request.Parameters["p_production_type"] | pProductionType.Equals("ALL") ? DBNull.Value : pProductionType | 행/컬럼 값 대입 |  |  |  |
| AC-0dcfba82 | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:400 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-13b1a4bc | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:401 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-449f8765 | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:403 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0a9341de | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:405 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b42ebc11 | popSql.OnSql [if (programID == "PR_UI_FP00540_SSP_SHIPPING_P… 외 1 | FP00540_SSP_Shipping_Plan.cs:412 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00540_SSP_Shipping_Plan.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1536aa67 | FindButton | FP00540_SSP_Shipping_Plan.cs:282 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-27cbf15b | FindButton | FP00540_SSP_Shipping_Plan.cs:288 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d07b62dc | FindButton | FP00540_SSP_Shipping_Plan.cs:289 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e9d3edd7 | FindButton | FP00540_SSP_Shipping_Plan.cs:292 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-06494947 | FindButton | FP00540_SSP_Shipping_Plan.cs:293 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-f20d6177 | FindButton | FP00540_SSP_Shipping_Plan.cs:293 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5fdd25d4 | FindButton | FP00540_SSP_Shipping_Plan.cs:299 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-dafb13f8 | FindButton | FP00540_SSP_Shipping_Plan.cs:308 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-649d6465 | FindButton | FP00540_SSP_Shipping_Plan.cs:309 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b4c6552e | FindButton | FP00540_SSP_Shipping_Plan.cs:317 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-28b8addd | FindButton | FP00540_SSP_Shipping_Plan.cs:319 | try | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6fc4824b | FindButton | FP00540_SSP_Shipping_Plan.cs:320 | try | CALL_EXT | siMain.SetFormat | ("####-W##", 12, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b9daef60 | FindButton | FP00540_SSP_Shipping_Plan.cs:321 | try | CALL_EXT | siMain.SetFormat | ("####-##-##", 13, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-df20e793 | FindButton | FP00540_SSP_Shipping_Plan.cs:322 | try | CALL_EXT | siMain.SetFormat | ("#,##0.###", 14, 2, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d38c8da0 | FindButton | FP00540_SSP_Shipping_Plan.cs:324 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1a9249ca | FindButton | FP00540_SSP_Shipping_Plan.cs:327 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3cac657a | FindButton | FP00540_SSP_Shipping_Plan.cs:330 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0b63c925 | FindButton | FP00540_SSP_Shipping_Plan.cs:340 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f6a195a8 | FindButton | FP00540_SSP_Shipping_Plan.cs:341 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00540_SSP_Shipping_Plan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1a3c33e | this.Load | FP00540_SSP_Shipping_Plan.cs:112 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00540_SSP_Shipping_Plan.FP00540_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c7b3e2a | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:604 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00540_SSP_Shipping_Plan.FP00540_SaveDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7461e1f | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:582 |  | ENDPOINT | DataService.FP_UpdateBatch | ("FP00540_SSP_Shipping_Plan", "merge_FP00540", data, 0) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00540] \| FP\Common\FP00… | 엔드포인트 호출 |  |  |  |
| AC-ee937084 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:586 |  | DATA_OP | rds.Tables.Add | (rdt) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a0aaf54 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:588 |  | RETURN | return rds; |  | 처리 중단/반환 |  |  |  |

## FP00540_SSP_Shipping_Plan.FP00540_SearchDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac3c2362 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:577 |  | RETURN | return set; |  | 처리 중단/반환 |  |  |  |

## FP00540_SSP_Shipping_Plan.FP00540_ValidateDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5edf30b8 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:594 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b89265f | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:595 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP00540_SSP_Shipping_Plan", "delete_Excel_buffer" , column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-4a3563d1 | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:597 |  | ENDPOINT | DataService.FP_UpdateBatch | ("FP00540_SSP_Shipping_Plan", "insert_Excel_buffer", data) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-21e2021f | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:599 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00540_SSP_Shipping_Plan", "find_Excel_buffer_validation", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6d3b4abc | (진입점 미연결) | FP00540_SSP_Shipping_Plan.cs:599 |  | RETURN | return DataService.FP_ExecuteQuery("FP00540_SSP_Shipping_Plan", "find_Excel_buff… |  | 처리 중단/반환 |  |  |  |

## FP00540_SSP_Shipping_Plan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8088c9c3 | this.Load | FP00540_SSP_Shipping_Plan.cs:148 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3e5683a3 | this.Load | FP00540_SSP_Shipping_Plan.cs:150 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-d039f4c6 | this.Load | FP00540_SSP_Shipping_Plan.cs:155 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6bf3eb28 | this.Load | FP00540_SSP_Shipping_Plan.cs:156 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a660e4db | this.Load | FP00540_SSP_Shipping_Plan.cs:158 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.TARGET_INSTANCE, false, UserInfoContext.Current.UserId, _sN… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=TARGET_INSTANCE] | 화면 필드/플래그 변경 |  |  |  |
| AC-4f02faa0 | this.Load | FP00540_SSP_Shipping_Plan.cs:158 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.TARGET_INSTANCE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=TARGET_INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0cf6c6c2 | this.Load | FP00540_SSP_Shipping_Plan.cs:163 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00540_SSP_Shipping_Plan.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb73a40d | this.Load | FP00540_SSP_Shipping_Plan.cs:210 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00540_SSP_Shipping_Plan.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c516a87 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:235 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-0297d194 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:237 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00540_SSP_Shipping_Plan.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b55a991 | popSql.OnSql | FP00540_SSP_Shipping_Plan.cs:532 | if (programID == "PR_UI_FP00540_SSP_SHIPPING_PLAN") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-144e3d4c | popSql.OnSql | FP00540_SSP_Shipping_Plan.cs:535 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00540_SSP_Shipping_Plan.SetChangeControl

진입점: this.Load / cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e486cf5 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:172 |  | FLAG | sDataID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-58fe4b8a | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:173 |  | FLAG | pInstanceID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-57df677b | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:174 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-575350e9 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:174 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pIns… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6c7190de | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:175 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ef5bb192 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:179 |  | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-94337af4 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:180 |  | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-ba8a4f40 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:181 |  | FLAG | dtScpPlanId | Data_FP.Common_FP(Data_FP.Type.SCP_PLAN, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SCP_PLAN] | 화면 필드/플래그 변경 |  |  |  |
| AC-ee6dcef3 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:181 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SCP_PLAN, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth , pIn… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SCP_PLAN] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-20472cd6 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:185 |  | LIST_REBIND | clsCtrl.setListBox | (dtScpPlanId, cboScpPlanId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-90931e9a | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:188 |  | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a6631bd | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:189 |  | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-9f0703c7 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:190 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-c12fd571 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:190 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pInstanc… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b2ef2992 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:191 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c61016c9 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:195 |  | FLAG | sDataID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-007c9b9e | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:196 |  | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-d1ec29c1 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:198 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-f1bace21 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:198 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pInstan… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2ec7c415 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:199 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c72a6257 | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:202 |  | FLAG | dtProductionType | Data_FP.Common_FP(Data_FP.Type.LOOKUP_CODE_TARGET, false, UserInfoContext.Current.UserId, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_TARGET] | 화면 필드/플래그 변경 |  |  |  |
| AC-da89639b | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:202 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LOOKUP_CODE_TARGET, false, UserInfoContext.Current.UserId, _sNonAuth, _sSave… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_TARGET] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bab15f1c | this.Load 외 1 | FP00540_SSP_Shipping_Plan.cs:203 |  | LIST_REBIND | clsCtrl.setListBox | (dtProductionType, cboProductionType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

