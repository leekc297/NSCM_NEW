# DMF0009 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0009_BizPlanPrice_Input\DMF0009_BizPlanPrice_Input.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0009_BizPlanPrice_Input\DMF0009_BizPlanPrice_Input.csproj | 2221 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0009_BizPlanPrice_Input\DMF0009_BizPlanPrice_Input.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0009_BizPlanPrice_Input\DMF0009_BizPlanPrice_Input.csproj | 1069 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0009_BizPlanPrice_Input\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0009_BizPlanPrice_Input\DMF0009_BizPlanPrice_Input.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0009_BizPlanPrice_Input\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0009_BizPlanPrice_Input\DMF0009_BizPlanPrice_Input.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0009_BizPlanPrice_Input\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0009_BizPlanPrice_Input\DMF0009_BizPlanPrice_Input.csproj | 27 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0009_BizPlanPrice_Input.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 2100 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0009_BizPlanPrice_Input.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 1069 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 837 | DM.DMF0009_GET_BIZ_PLAN_PRICE_INPUT | MATCH | SP DMF0009_GET_BIZ_PLAN_PRICE_INPUT |
| button:FindButton | FindButton > FindData > InitSpread > SetComboColumn > GetComboData | 2073 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 2161 | DM.DMF0009_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0009_GET_COMMON_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData | 837 | DM.DMF0009_GET_BIZ_PLAN_PRICE_INPUT | MATCH | SP DMF0009_GET_BIZ_PLAN_PRICE_INPUT |
| button:SaveButton | SaveButton > SaveData | 1294 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > SaveData | 1294 | DM.DMF0009_SAVE_BIZ_PLAN_PRICE_INPUT | MATCH | SP DMF0009_SAVE_BIZ_PLAN_PRICE_INPUT |
| button:SaveButton | SaveButton > SaveData | 1294 | DM.DMF0009_SAVE_ESS_BIZ_PLAN_PRICE_INPUT | MATCH | SP DMF0009_SAVE_ESS_BIZ_PLAN_PRICE_INPUT |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > SetComboColumn > GetComboData | 2073 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 2161 | DM.DMF0009_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0009_GET_COMMON_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > SetComboColumn > GetComboData | 2073 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 2161 | DM.DMF0009_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0009_GET_COMMON_SPREAD_TITLE |
| event:this.btnModelChange.Click | btnModelChange_Click > FindData | 837 | DM.DMF0009_GET_BIZ_PLAN_PRICE_INPUT | MATCH | SP DMF0009_GET_BIZ_PLAN_PRICE_INPUT |
| event:this.btnModelChange.Click | btnModelChange_Click > FindData > InitSpread > SetComboColumn > GetComboData | 2073 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| event:this.btnModelChange.Click | btnModelChange_Click > FindData > InitSpread > GetSpdTitle | 2161 | DM.DMF0009_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0009_GET_COMMON_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread > SetComboColumn > GetComboData | 2073 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 2161 | DM.DMF0009_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0009_GET_COMMON_SPREAD_TITLE |
| event:this.clbTeam.SelectedIndexChanged | ClbTeam_SelectedIndexChanged | 1678 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 419 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 433 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 466 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetComboColumn > GetComboData | 2073 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2161 | DM.DMF0009_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0009_GET_COMMON_SPREAD_TITLE |
| event:this.spdMain.CellClick | spdMain_CellClick > GetComboData | 2073 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted | 1495 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted | 1506 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > ClearContentsForCell > GetComboData | 2073 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| unreached:(진입점 미연결) | <field:dtEndCustomer40> | 364 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetScmSiteInfobyDivision | 2148 | SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_INFO_BY_DIVISION |
| unreached:(진입점 미연결) | GetItemType | 2180 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?string.Empty} | UNRESOLVED | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PROJECT_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_ITEM_SN |
| biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PROJECT_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_ITEM_SN |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| DM.DMF0009_GET_BIZ_PLAN_PRICE_INPUT | MATCH | 1 | SP DMF0009_GET_BIZ_PLAN_PRICE_INPUT | EXEC:DMF0009_GET_BIZ_PLAN_PRICE_INPUT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#SITE_ITEM, SELECT:SCM_MST_SITE_ITEM, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_SITE, SELECT:SCM_MST_COUNTRY, INSERT:#SOURCE3, REF:FN_GET_DEPT_LIST, REF:FN_GET_MULTI_OWNER_NAME, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, SELECT:#SITE_ITEM, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, SELECT:DM_MST_CUSTOMER_MODEL, SELECT:#SOURCE3, SELECT:DM_MST_METAL_PRICE_RULE, SELECT:DM_MST_ESS_METAL_PRICE_RULE, CREATE:#T_SINGLE, CREATE:#SCM_MST_SITE_ITEM, INSERT:#T_SINGLE, INSERT:#SCM_MST_SITE_ITEM, SELECT:#T_SINGLE, SELECT:#SCM_MST_SITE_ITEM, SELECT:TB_FX_USER |  |
| DM.DMF0009_GET_CODE | MATCH | 1 | SP DMF0009_GET_CODE | EXEC:DMF0009_GET_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SHEET_MEASURE |  |
| DM.DMF0009_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DMF0009_GET_COMMON_SPREAD_TITLE | EXEC:DMF0009_GET_COMMON_SPREAD_TITLE, EXEC:SCM0002_SET_DEFAULT_TITLESET_POPUP, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, INSERT:SCM_MST_TITLESET_USER, REF:FN_SCM_SYS_NVL, SELECT:SCM_MST_SHEET_MEASURE |  |
| DM.DMF0009_SAVE_BIZ_PLAN_PRICE_INPUT | MATCH | 1 | SP DMF0009_SAVE_BIZ_PLAN_PRICE_INPUT | EXEC:DMF0009_SAVE_BIZ_PLAN_PRICE_INPUT, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#SAVE_FLAG, REF:STRING_SPLIT, INSERT:#DIVISION_ID, INSERT:#PROJECT_CODE, INSERT:#SCM_SITE_ID, INSERT:#ITEM_ID, INSERT:#CELL_PROD_SITE, UPDATE:#CELL_PROD_SITE, SELECT:#DIVISION_ID, INSERT:#BASE_PRICE, INSERT:#METAL_LINK_YN, INSERT:#CURRENCY, INSERT:#METAL_LINK_PERIOD, INSERT:#METAL_LINK_START_MONTH, INSERT:#METAL_LINK_MTD, INSERT:#START_YM, INSERT:#END_YM, INSERT:#AL_KG_PER_BIZ_TYPE, INSERT:#CU_KG_PER_BIZ_TYPE, INSERT:#MN_KG_PER_BIZ_TYPE, INSERT:#NI_KG_PER_BIZ_TYPE, INSERT:#CO_KG_PER_BIZ_TYPE, INSERT:#LI2CO3_KG_PER_BIZ_TYPE, INSERT:#LIOH_KG_PER_BIZ_TYPE, INSERT:#AL_USD_PER_KG, INSERT:#CU_USD_PER_KG, INSERT:#MN_USD_PER_KG, INSERT:#NI_USD_PER_KG, INSERT:#CO_USD_PER_KG, INSERT:#LI2CO3_USD_PER_KG, INSERT:#LIOH_USD_PER_KG, INSERT:#CNTRC_EXCHANGE_PRICE, INSERT:#AL_MIX_METAL_LINK_PERIOD, INSERT:#CU_MIX_METAL_LINK_PERIOD, INSERT:#MN_MIX_METAL_LINK_PERIOD, INSERT:#NI_MIX_METAL_LINK_PERIOD, INSERT:#CO_MIX_METAL_LINK_PERIOD, INSERT:#LI2CO3_MIX_METAL_LINK_PERIOD, INSERT:#LIOH_MIX_METAL_LINK_PERIOD, INSERT:#SOURCE, SELECT:#SAVE_FLAG, SELECT:#PROJECT_CODE, SELECT:#SCM_SITE_ID, SELECT:#ITEM_ID, SELECT:#CELL_PROD_SITE, SELECT:#BASE_PRICE, SELECT:#METAL_LINK_YN, SELECT:#CURRENCY, SELECT:#METAL_LINK_PERIOD, SELECT:#METAL_LINK_START_MONTH, SELECT:#METAL_LINK_MTD, SELECT:#START_YM, SELECT:#END_YM, SELECT:#AL_KG_PER_BIZ_TYPE, SELECT:#CU_KG_PER_BIZ_TYPE, SELECT:#MN_KG_PER_BIZ_TYPE, SELECT:#NI_KG_PER_BIZ_TYPE, SELECT:#CO_KG_PER_BIZ_TYPE |  |
| DM.DMF0009_SAVE_ESS_BIZ_PLAN_PRICE_INPUT | MATCH | 1 | SP DMF0009_SAVE_ESS_BIZ_PLAN_PRICE_INPUT | EXEC:DMF0009_SAVE_ESS_BIZ_PLAN_PRICE_INPUT, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#SAVE_FLAG, REF:STRING_SPLIT, INSERT:#DIVISION_ID, INSERT:#PROJECT_CODE, INSERT:#SCM_SITE_ID, INSERT:#ITEM_ID, INSERT:#BASE_PRICE_PER_EA, INSERT:#METAL_LINK_YN, INSERT:#CURRENCY, INSERT:#METAL_LINK_PERIOD, INSERT:#METAL_LINK_START_MONTH, INSERT:#METAL_LINK_MTD, INSERT:#CELL_NICK, INSERT:#CELL_QTY, INSERT:#CAP_PCT, INSERT:#START_YM, INSERT:#END_YM, INSERT:#AL_USD_PER_KG, INSERT:#CU_USD_PER_KG, INSERT:#MN_USD_PER_KG, INSERT:#NI_USD_PER_KG, INSERT:#CO_USD_PER_KG, INSERT:#LI2CO3_USD_PER_KG, INSERT:#LIOH_USD_PER_KG, INSERT:#CNTRC_EXCHANGE_PRICE, INSERT:#SOURCE, SELECT:#SAVE_FLAG, SELECT:#DIVISION_ID, SELECT:#PROJECT_CODE, SELECT:#SCM_SITE_ID, SELECT:#ITEM_ID, SELECT:#BASE_PRICE_PER_EA, SELECT:#METAL_LINK_YN, SELECT:#CURRENCY, SELECT:#METAL_LINK_PERIOD, SELECT:#METAL_LINK_START_MONTH, SELECT:#METAL_LINK_MTD, SELECT:#CELL_NICK, SELECT:#CELL_QTY, SELECT:#CAP_PCT, SELECT:#START_YM, SELECT:#END_YM, SELECT:#AL_USD_PER_KG, SELECT:#CU_USD_PER_KG, SELECT:#MN_USD_PER_KG, SELECT:#NI_USD_PER_KG, SELECT:#CO_USD_PER_KG, SELECT:#LI2CO3_USD_PER_KG, SELECT:#LIOH_USD_PER_KG, SELECT:#CNTRC_EXCHANGE_PRICE, SELECT:#SOURCE, SELECT:DM_MST_ESS_METAL_SENSITIVITY, CREATE:#PERIOD, INSERT:#PERIOD, EXEC:DMF0009_GET_CODE, MERGE:#SOURCE, SELECT:#PERIOD, MERGE:DM_MST_ESS_METAL_PRICE_RULE |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_SITE_INFO_BY_DIVISION | EXEC:SCM0001_GET_SITE_INFO_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, REF:STRING_SPLIT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtEndCustomer40> | UserInfoContext.Current | NowGroupID |
| clbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbEndCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| ClbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| ClearContentsForCell | row | ATTR1 |
| DeleteButton | UserInfoContext.Current | NowGroupID |
| EditButton | UserInfoContext.Current | NowGroupID |
| FindButton | UserInfoContext.Current | NowGroupID |
| FindData | UserInfoContext.Current | NowGroupID, Dept_ID |
| FindData | siMain.ActiveSheet.Columns | CELL_PROD_SITE |
| InitControls | UserInfoContext.Current | NowGroupID |
| InsertButton | UserInfoContext.Current | NowGroupID |
| SaveButton | UserInfoContext.Current | NowGroupID |
| SaveData | UserInfoContext.Current | NowGroupID |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| SetComboCell | dr | CODE, NAME |
| SetComboCol | dr | CODE, NAME |
| SetComboColumn | dr | CELL_COMBO_DATA_TYPE |
| SetSpreadHeaderSpan | dr | COLUMN_NAME, LARGE_CLASS_LABEL_NAME, COLUMN_LABEL_NAME |
| spdMain_CellClick | row | ATTR1 |
| spdMain_ClipboardPasted | dtSalesPlant.Rows[0] | CODE |
| spdMain_ClipboardPasted | dtSalesCompany.Rows[0] | CODE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:379, SetChangeControl:386, SetChangeControl:394, SetChangeControl:403 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| GetCheckedListValue | InitControls:423, InitControls:428, InitControls:461, FindData:813, clbDivision_SelectedIndexChanged:1596, clbDivision_SelectedIndexChanged:1605, clbDivision_SelectedIndexChanged:1649, ClbTeam_SelectedIndexChanged:1672 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:493 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:494 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:660 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| FP_Log2 | clbDivision_SelectedIndexChanged:1592, clbDivision_SelectedIndexChanged:1668 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| LoadData | btnModelChange_Click:1795, btnExchangeRate_Click:1844 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:109 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:110 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:111 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:112 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:113 |
| this.btnExchangeRate | Click | btnExchangeRate_Click | InitializeComponent:239 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:277 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:313 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:349 |
| this.txtProject | KeyDown | txtProject_KeyDown | InitializeComponent:418 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:458 |
| this.clbTeam | SelectedIndexChanged | ClbTeam_SelectedIndexChanged | InitializeComponent:498 |
| this.btnOwner | Click | btnOwner_Click | InitializeComponent:678 |
| this.btnModelChange | Click | btnModelChange_Click | InitializeComponent:751 |
| this | Load | Form_Load | .ctor:347 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitEvent:577 |

## 6. 컨트롤 (39개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 16 | lblSalesSite, lblTeam, lblEndCustomer, lblProject, lblItemId, lblActive, layoutControlItem2, layoutControlItem3, lblDivision, lblOwner, layoutControlItem4, layoutControlItem11, layoutControlItem5, layoutControlItem1, layoutControlItem6 … |
| UsrButton | 6 | btnExchangeRate, btnColumn, btnItemId, btnProject, btnOwner, btnModelChange |
| UsrMultiLineEditor | 3 | txtItemId, txtProject, txtOwner |
| UsrCheckedList | 3 | clbEndCustomer, clbTeam, clbSalesSite |
| UsrCombo | 2 | cboActive, clbDivision |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| CheckBox | 1 | cbSmart |
| UsrCheckBox | 1 | chkEndCust |
| LayoutControlGroup | 1 | layoutControlGroup1 |
| EmptySpaceItem | 1 | emptySpaceItem1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1294 | SaveData | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 160 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 101 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 140 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 6 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0009 | Production | 9/3 | 10/4 | 10/4 | 10/4 | 10/4 | 10/4 | 10/4 | 10/4 | · | · | · | · | · | · |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Production
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:494
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetComboColumn, SetSpreadHeaderSpan

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 497 | 표시/라벨 변경 | set:RowCount | RowCount = 2 |  |  |
| InitSpread |  | 516 | 표시/라벨 변경 | SetColumnVisible | {?-1} \|\| {?spcold.GetColumnIndex(DefColumns.BASE_PRICE)} \|\| {?spcold.GetColumnIndex(DefColumns.BASE_PRICE_PER_EA)} \|\| {?spcold.GetColumnIndex(DefColumns.DIVISION_ID)} \|\| 0 |  | for(col <= col2) |
| SetSpreadHeaderSpan |  | 566 | 표시/라벨 변경 | set:Text | Text = {?dr["COLUMN_LABEL_NAME"].ToString()} | {?dr["COLUMN_NAME"]} | for(index < dt.Rows.Count) |
| FindData |  | 912 | 표시/라벨 변경 | set:Width | Width = {?cell_prod_width} | CELL_PROD_SITE | if(siMain.ActiveSheet.Columns["CELL_PROD_SITE"].Width == 0) |
| InitializeComponent |  | 129 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 130 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 131 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 132 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Production | META+코드연결 | 9 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
