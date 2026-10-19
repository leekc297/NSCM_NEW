# DMF0010 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0010_BizPlanPrice\DMF0010_BizPlanPrice.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0010_BizPlanPrice\DMF0010_BizPlanPrice.csproj | 2493 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0010_BizPlanPrice\DMF0010_BizPlanPrice.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0010_BizPlanPrice\DMF0010_BizPlanPrice.csproj | 1213 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0010_BizPlanPrice\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0010_BizPlanPrice\DMF0010_BizPlanPrice.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0010_BizPlanPrice\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0010_BizPlanPrice\DMF0010_BizPlanPrice.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0010_BizPlanPrice\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0010_BizPlanPrice\DMF0010_BizPlanPrice.csproj | 27 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0010_BizPlanPrice.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 2386 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0010_BizPlanPrice.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 1213 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:dsdm.Changed | spdMain_Changed | 1392 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 1396 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 1406 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 1410 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > InitSpread | 511 | DM.DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE | MATCH | SP DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 808 | DM.DMF0010_GET_BIZ_PLAN_PRICE | MATCH | SP DMF0010_GET_BIZ_PLAN_PRICE |
| button:FindButton | FindButton > FindData > InitSpread > SetComboColumn > GetComboData | 2079 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 2147 | DM.DMF0009_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0009_GET_COMMON_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread | 511 | DM.DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE | MATCH | SP DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData | 808 | DM.DMF0010_GET_BIZ_PLAN_PRICE | MATCH | SP DMF0010_GET_BIZ_PLAN_PRICE |
| button:SaveButton | SaveButton > SaveData | 1165 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > SaveData | 1165 | DM.DMF0010_SAVE_BIZ_PLAN_PRICE | MATCH | SP DMF0010_SAVE_BIZ_PLAN_PRICE |
| button:SaveButton | SaveButton > SaveData | 1165 | DM.DMF0010_SAVE_ESS_BIZ_PLAN_PRICE | MATCH | SP DMF0010_SAVE_ESS_BIZ_PLAN_PRICE |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > SetComboColumn > GetComboData | 2079 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 2147 | DM.DMF0009_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0009_GET_COMMON_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread | 511 | DM.DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE | MATCH | SP DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > SetComboColumn > GetComboData | 2079 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 2147 | DM.DMF0009_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0009_GET_COMMON_SPREAD_TITLE |
| event:this.btnModelChange.Click | btnModelChange_Click > FindData > InitSpread | 511 | DM.DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE | MATCH | SP DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE |
| event:this.btnModelChange.Click | btnModelChange_Click > FindData | 808 | DM.DMF0010_GET_BIZ_PLAN_PRICE | MATCH | SP DMF0010_GET_BIZ_PLAN_PRICE |
| event:this.btnModelChange.Click | btnModelChange_Click > FindData > InitSpread > SetComboColumn > GetComboData | 2079 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| event:this.btnModelChange.Click | btnModelChange_Click > FindData > InitSpread > GetSpdTitle | 2147 | DM.DMF0009_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0009_GET_COMMON_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread | 511 | DM.DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE | MATCH | SP DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread > SetComboColumn > GetComboData | 2079 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 2147 | DM.DMF0009_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0009_GET_COMMON_SPREAD_TITLE |
| event:this.clbTeam.SelectedIndexChanged | ClbTeam_SelectedIndexChanged | 1873 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 382 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 396 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 429 | biz:CommonData.CommonDataList [code=ItemType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 438 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 440 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread | 511 | DM.DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE | MATCH | SP DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetComboColumn > GetComboData | 2079 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2147 | DM.DMF0009_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0009_GET_COMMON_SPREAD_TITLE |
| event:this.spdMain.CellClick | spdMain_CellClick | 2257 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | spdMain_CellClick | 2269 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted | 2323 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted | 2334 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1337 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1350 | biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetScmSiteInfobyDivision | 2133 | SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_INFO_BY_DIVISION |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 60 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtEndCustomer40> | 328 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetItemType | 2230 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?string.Empty} | UNRESOLVED | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:TB_FX_USER |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=ItemType] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:EXEC:SCM0001_GET_LOOKUP_VALUES |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SalesCompany] | BIZ_MATCH | 5 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PROJECT_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_ITEM_SN |
| biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH | 5 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PROJECT_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_ITEM_SN |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| DM.DMF0009_GET_CODE | MATCH | 1 | SP DMF0009_GET_CODE | EXEC:DMF0009_GET_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SHEET_MEASURE |  |
| DM.DMF0009_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DMF0009_GET_COMMON_SPREAD_TITLE | EXEC:DMF0009_GET_COMMON_SPREAD_TITLE, EXEC:SCM0002_SET_DEFAULT_TITLESET_POPUP, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, INSERT:SCM_MST_TITLESET_USER, REF:FN_SCM_SYS_NVL, SELECT:SCM_MST_SHEET_MEASURE |  |
| DM.DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE | MATCH | 1 | SP DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE | EXEC:DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE, SELECT:T |  |
| DM.DMF0010_GET_BIZ_PLAN_PRICE | MATCH | 1 | SP DMF0010_GET_BIZ_PLAN_PRICE | EXEC:DMF0010_GET_BIZ_PLAN_PRICE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, CREATE:#MEASURE, INSERT:#MEASURE, EXEC:DMF0009_GET_CODE, INSERT:#SOURCE3, REF:FN_GET_DEPT_LIST, REF:FN_GET_MULTI_OWNER_NAME, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_COUNTRY, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, SELECT:DM_MST_CUSTOMER_MODEL, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, REF:SCM_ARR_SPL_VAL_ENTITY, EXEC:SP_EXECUTESQL, INSERT:#SOURCE2, SELECT:DM_MST_ESS_METAL_PRICE_RULE, CREATE:#T_SINGLE, CREATE:#SCM_MST_SITE_ITEM, INSERT:#T_SINGLE, INSERT:#SCM_MST_SITE_ITEM, SELECT:#T_SINGLE, INSERT:#SOURCE, SELECT:DM_MST_METAL_PRICE_RULE, SELECT:#SCM_MST_SITE_ITEM, SELECT:SCM_MST_SHEET_MEASURE, SELECT:TB_FX_USER |  |
| DM.DMF0010_SAVE_BIZ_PLAN_PRICE | MATCH | 1 | SP DMF0010_SAVE_BIZ_PLAN_PRICE | EXEC:DMF0010_SAVE_BIZ_PLAN_PRICE, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#SAVE_FLAG, REF:STRING_SPLIT, INSERT:#DIVISION_ID, INSERT:#PROJECT_CODE, INSERT:#SCM_SITE_ID, INSERT:#ITEM_ID, INSERT:#CELL_PROD_SITE, UPDATE:#CELL_PROD_SITE, SELECT:#DIVISION_ID, INSERT:#MEASURE, INSERT:#STND_YM, INSERT:#PRICE, INSERT:#SOURCE, SELECT:#SAVE_FLAG, SELECT:#PROJECT_CODE, SELECT:#SCM_SITE_ID, SELECT:#ITEM_ID, SELECT:#CELL_PROD_SITE, SELECT:#MEASURE, SELECT:#STND_YM, SELECT:#PRICE, SELECT:#SOURCE, INSERT:#RULE, SELECT:DM_MST_METAL_PRICE_RULE, CREATE:#DATA, INSERT:#DATA, SELECT:#RULE, REF:DMF0009_GET_YM_IN_BETWEEN_TWO_YM, CREATE:#PERIOD, INSERT:#PERIOD, EXEC:DMF0009_GET_CODE, SELECT:DM_MST_METAL_CURRENCY_PRICE, REF:DMF0009_GET_START_YM, SELECT:#DATA, SELECT:#PERIOD, DELETE:T, SELECT:DM_MST_METAL_PRICE, INSERT:DM_MST_METAL_PRICE, INSERT:SCM_SYS_LOG_BATCH, SELECT:T, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SHEET_MEASURE |  |
| DM.DMF0010_SAVE_ESS_BIZ_PLAN_PRICE | MATCH | 1 | SP DMF0010_SAVE_ESS_BIZ_PLAN_PRICE | EXEC:DMF0010_SAVE_ESS_BIZ_PLAN_PRICE, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#SAVE_FLAG, REF:STRING_SPLIT, INSERT:#DIVISION_ID, INSERT:#PROJECT_CODE, INSERT:#SCM_SITE_ID, INSERT:#ITEM_ID, INSERT:#MEASURE, INSERT:#STND_YM, INSERT:#PRICE, INSERT:#SOURCE, SELECT:#SAVE_FLAG, SELECT:#DIVISION_ID, SELECT:#PROJECT_CODE, SELECT:#SCM_SITE_ID, SELECT:#ITEM_ID, SELECT:#MEASURE, SELECT:#STND_YM, SELECT:#PRICE, SELECT:#SOURCE, INSERT:#RULE, SELECT:DM_MST_ESS_METAL_PRICE_RULE, SELECT:DM_MST_ESS_METAL_SENSITIVITY, CREATE:#DATA, INSERT:#DATA, SELECT:#RULE, REF:DMF0009_GET_YM_IN_BETWEEN_TWO_YM, CREATE:#PERIOD, INSERT:#PERIOD, EXEC:DMF0009_GET_CODE, SELECT:DM_MST_METAL_CURRENCY_PRICE, REF:DMF0009_GET_START_YM, SELECT:#DATA, SELECT:#PERIOD, UPDATE:#DATA, DELETE:T, SELECT:DM_MST_METAL_PRICE, INSERT:DM_MST_METAL_PRICE, INSERT:SCM_SYS_LOG_BATCH, SELECT:T, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SHEET_MEASURE |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_SITE_INFO_BY_DIVISION | EXEC:SCM0001_GET_SITE_INFO_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, REF:STRING_SPLIT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtEndCustomer40> | UserInfoContext.Current | NowGroupID |
| clbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbEndCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| ClbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| DeleteButton | UserInfoContext.Current | NowGroupID |
| EditButton | UserInfoContext.Current | NowGroupID |
| FindButton | UserInfoContext.Current | NowGroupID |
| FindData | UserInfoContext.Current | NowGroupID, Dept_ID |
| FindData | siMain.ActiveSheet.Columns | CELL_PROD_SITE |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitSpread | dtSpan.Rows[i] | SPAN_HEADER, COL_HEADER, COLUMN_NAME |
| SaveButton | UserInfoContext.Current | NowGroupID |
| SaveData | UserInfoContext.Current | NowGroupID |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| SetComboCol | dr | CODE, NAME |
| SetComboColumn | dr | CELL_COMBO_DATA_TYPE |
| SetSpreadHeaderSpan | dr | COLUMN_NAME, LARGE_CLASS_LABEL_NAME, COLUMN_LABEL_NAME |
| spdMain_ClipboardPasted | dtSalesPlant.Rows[0] | CODE |
| spdMain_ClipboardPasted | dtSalesCompany.Rows[0] | CODE |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |
| spdMain_ComboSelChange | dtSalesPlant.Rows[0] | CODE |
| spdMain_ComboSelChange | dtSalesCompany.Rows[0] | CODE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:343, SetChangeControl:350, SetChangeControl:358, SetChangeControl:367 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| GetCheckedListValue | InitControls:386, InitControls:391, InitControls:424, InitSpread:519, FindData:767, clbDivision_SelectedIndexChanged:1779, clbDivision_SelectedIndexChanged:1787, clbDivision_SelectedIndexChanged:1837 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:482 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:483 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:692 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| FP_Log2 | clbDivision_SelectedIndexChanged:1775, clbDivision_SelectedIndexChanged:1856 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| LoadData | btnModelChange_Click:2420, btnExchangeRate_Click:2458 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:115 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:116 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:117 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:118 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:119 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:120 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:121 |
| this.btnCutOff | Click | btnCutOff_Click | InitializeComponent:239 |
| this.btnExchangeRate | Click | btnExchangeRate_Click | InitializeComponent:350 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:388 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:424 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:460 |
| this.txtProject | KeyDown | txtProject_KeyDown | InitializeComponent:529 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:569 |
| this.clbTeam | SelectedIndexChanged | ClbTeam_SelectedIndexChanged | InitializeComponent:609 |
| this.chkEndCust | CheckedChanged | chkDetail_CheckedChanged | InitializeComponent:686 |
| this.btnOwner | Click | btnOwner_Click | InitializeComponent:790 |
| this.btnModelChange | Click | btnModelChange_Click | InitializeComponent:863 |
| this | Load | Form_Load | .ctor:310 |
| dsdm | Changed | spdMain_Changed | DefineProperty:465 |
| dsdm | Changed | shtMainDataModel_Changed | InitEvent:588 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitEvent:593 |

## 6. 컨트롤 (43개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 18 | lblSalesSite, lblTeam, lblEndCustomer, lblProject, lblItemId, lblActive, layoutControlItem2, layoutControlItem3, lblDivision, lblOwner, layoutControlItem4, layoutControlItem11, layoutControlItem5, layoutControlItem1, layoutControlItem6 … |
| UsrButton | 7 | btnCutOff, btnExchangeRate, btnColumn, btnItemId, btnProject, btnOwner, btnModelChange |
| UsrMultiLineEditor | 3 | txtItemId, txtProject, txtOwner |
| UsrCheckedList | 3 | clbEndCustomer, clbTeam, clbSalesSite |
| UsrMonthPicker | 2 | usrMonthTo, usrMonthFrom |
| UsrCombo | 2 | cboActive, clbDivision |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| UsrCheckBox | 1 | chkEndCust |
| LayoutControlGroup | 1 | layoutControlGroup1 |
| EmptySpaceItem | 1 | emptySpaceItem1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1165 | SaveData | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 163 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 70 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 169 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_GroupMenuAuth | 2 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 6 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (2건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1027 | DM.DMF0005_GET_SALES_SITE_MODEL_PURCHASE | commented:MATCH |
| 1026 | DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0010 | Production | 9/3 | 10/4 | 10/4 | 10/4 | 10/4 | 10/4 | 10/4 | 10/4 | · | · | · | · | · | · |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Production
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:483
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetComboColumn, SetSpreadHeaderSpan

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 488 | 표시/라벨 변경 | set:RowCount | RowCount = 2 |  |  |
| InitSpread |  | 496 | 표시/라벨 변경 | SetColumnVisible | {?spreadInfo.GetColumnIndex(DefColumns.MEASURE)} \|\| {?spreadInfo.GetColumnIndex(DefColumns.DIVISION_ID)} |  | for(col <= col2) |
| InitSpread |  | 529 | DB루프 | AddNumColumn | {?dtSpan.Rows[i]["COL_HEADER"]} | {?dtSpan.Rows[i]["COLUMN_NAME"]} | for(i < dtSpan.Rows.Count) ⟫ if(sDivision.Equals("40")) |
| InitSpread |  | 531 | DB루프 | AddNumColumn | {?dtSpan.Rows[i]["COL_HEADER"]} | {?dtSpan.Rows[i]["COLUMN_NAME"]} | for(i < dtSpan.Rows.Count) ⟫ else!(sDivision.Equals("40")) |
| SetSpreadHeaderSpan |  | 575 | 표시/라벨 변경 | set:Text | Text = {?dr["COLUMN_LABEL_NAME"].ToString()} | {?dr["COLUMN_NAME"]} | for(index < dt.Rows.Count) |
| FindData |  | 852 | 표시/라벨 변경 | set:Width | Width = {?cell_prod_width} | CELL_PROD_SITE | if(siMain.ActiveSheet.Columns["CELL_PROD_SITE"].Width == 0) |
| InitializeComponent |  | 137 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 138 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 139 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 140 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Production | META+코드연결 | 9 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
