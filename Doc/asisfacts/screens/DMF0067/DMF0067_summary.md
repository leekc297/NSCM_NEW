# DMF0067 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0067_BizPlanRaw\DMF0067_BizPlanRaw.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0067_BizPlanRaw\DMF0067_BizPlanRaw.csproj | 3594 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0067_BizPlanRaw\DMF0067_BizPlanRaw.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0067_BizPlanRaw\DMF0067_BizPlanRaw.csproj | 1614 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0067_BizPlanRaw\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0067_BizPlanRaw\DMF0067_BizPlanRaw.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0067_BizPlanRaw\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0067_BizPlanRaw\DMF0067_BizPlanRaw.csproj | 72 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0067_BizPlanRaw\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0067_BizPlanRaw\DMF0067_BizPlanRaw.csproj | 31 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0067_BizPlanRaw.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 3594 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0067_BizPlanRaw.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1614 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged | 1506 | biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged | 1509 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged | 1567 | biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > GetComboData | 2954 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > GetDayRange | 2991 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 3007 | DM.DMF0042_3_GET_SPREAD_TITLE | MATCH | SP DMF0042_3_GET_SPREAD_TITLE |
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > GetLookupData | 3024 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:clbDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > GetBizTypebyDivision | 3037 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| button:FindButton | FindButton > FindData | 768 | DM.DMF0042_3_Get_BizPlan | MATCH | SP DMF0042_3_Get_BizPlan |
| button:FindButton | FindButton > FindData > InitSpread > SetComboColumn > GetComboData | 2954 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 3007 | DM.DMF0042_3_GET_SPREAD_TITLE | MATCH | SP DMF0042_3_GET_SPREAD_TITLE |
| button:InsertButton | InsertButton > InsertRow > GetLookupData | 3024 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| button:InsertButton | InsertButton > InsertRow > GetCellProdSite | 3487 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:SaveButton | SaveButton > SaveData > FindData | 768 | DM.DMF0042_3_Get_BizPlan | MATCH | SP DMF0042_3_Get_BizPlan |
| button:SaveButton | SaveButton > SaveData | 1147 | DM.DMF0042_SAVE_DM_PLN_BP_FCST | MATCH | SP DMF0042_SAVE_DM_PLN_BP_FCST |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > SetComboColumn > GetComboData | 2954 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 3007 | DM.DMF0042_3_GET_SPREAD_TITLE | MATCH | SP DMF0042_3_GET_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > SetComboColumn > GetComboData | 2954 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 3007 | DM.DMF0042_3_GET_SPREAD_TITLE | MATCH | SP DMF0042_3_GET_SPREAD_TITLE |
| event:this.btnExchangeRate.Click | btnExchangeRate_Click > FindData | 768 | DM.DMF0042_3_Get_BizPlan | MATCH | SP DMF0042_3_Get_BizPlan |
| event:this.btnExchangeRate.Click | btnExchangeRate_Click > FindData > InitSpread > SetComboColumn > GetComboData | 2954 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| event:this.btnExchangeRate.Click | btnExchangeRate_Click > FindData > InitSpread > GetSpdTitle | 3007 | DM.DMF0042_3_GET_SPREAD_TITLE | MATCH | SP DMF0042_3_GET_SPREAD_TITLE |
| event:this.btnExchangeRate.Click | btnExchangeRate_Click > GetFuturePriceInfo | 3132 | DM.DMF0042_GET_EXCHANGE_PRICE | MATCH | SP DMF0042_GET_EXCHANGE_PRICE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > SetComboColumn > GetComboData | 2954 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 3007 | DM.DMF0042_3_GET_SPREAD_TITLE | MATCH | SP DMF0042_3_GET_SPREAD_TITLE |
| event:this.btnSetPrice.Click | btnSetPrice_Click > FindData | 768 | DM.DMF0042_3_Get_BizPlan | MATCH | SP DMF0042_3_Get_BizPlan |
| event:this.btnSetPrice.Click | btnSetPrice_Click > FindData > InitSpread > SetComboColumn > GetComboData | 2954 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| event:this.btnSetPrice.Click | btnSetPrice_Click > FindData > InitSpread > GetSpdTitle | 3007 | DM.DMF0042_3_GET_SPREAD_TITLE | MATCH | SP DMF0042_3_GET_SPREAD_TITLE |
| event:this.btnSetPrice.Click | btnSetPrice_Click | 3241 | DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV | MATCH | SP DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV |
| event:this.clbCustomer.SelectedIndexChanged | clbCustomer_SelectedIndexChanged | 1611 | biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH |  |
| event:this.clbTeam.SelectedIndexChanged | clbTeam_SelectedIndexChanged | 1592 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.clbTeam.SelectedIndexChanged | clbTeam_SelectedIndexChanged | 1595 | biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 261 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 279 | biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 282 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 342 | biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetComboColumn > GetComboData | 2954 | DM.DMF0009_GET_CODE | MATCH | SP DMF0009_GET_CODE |
| event:this.Load | Form_Load > InitControls > GetDayRange | 2991 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 3007 | DM.DMF0042_3_GET_SPREAD_TITLE | MATCH | SP DMF0042_3_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetLookupData | 3024 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls > GetBizTypebyDivision | 3037 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1653 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE_ITEM, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GETCOMMONDATALIST_DM:REF:STRING_SPLIT, UP_FX_GETCOMMONDATALIST_DM:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM.DMF0009_GET_CODE | MATCH | 1 | SP DMF0009_GET_CODE | EXEC:DMF0009_GET_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SHEET_MEASURE |  |
| DM.DMF0042_3_Get_BizPlan | MATCH | 1 | SP DMF0042_3_Get_BizPlan | EXEC:DMF0042_3_GET_BIZPLAN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:TB_FX_USER, CREATE:#RAW_DATA, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:DM_MST_ITEM_SINGLE_V, REF:STRING_SPLIT, INSERT:#TEMP_SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_USER_INFO, INSERT:#TEMP_SCM_MST_SITE_ITEM, REF:FN_GET_DM_MKT_OWNER_NAME, SELECT:#TEMP_SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SITE_ITEM, INSERT:#SELECT_MEASURE, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#RAW_DATA, SELECT:DM_PLN_BIZPLAN, SELECT:#SELECT_MEASURE, SELECT:SCM_MST_SITE, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:#TEMP_SCM_MST_SITE_ITEM, SELECT:SCM_MST_CITY, SELECT:SCM_MST_COUNTRY, SELECT:SCM_SYS_CALENDAR_M, REF:UF_FX_STRING_SPLITFORIN, SELECT:SCM_MST_PROJECT, INSERT:#DLT_ITEM_ID, SELECT:#RAW_DATA, DELETE:A, SELECT:#DLT_ITEM_ID, INSERT:#RAW_DATA_SUM, SELECT:#RAW_DATA_SUM, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, EXEC:SP_EXECUTESQL, SELECT:SPLIT |  |
| DM.DMF0042_3_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0042_3_GET_SPREAD_TITLE | EXEC:DMF0042_3_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DMF0042_GET_EXCHANGE_PRICE | MATCH | 1 | SP DMF0042_GET_EXCHANGE_PRICE | EXEC:DMF0042_GET_EXCHANGE_PRICE, SELECT:DM_MST_EXCHANGE_RATE |  |
| DM.DMF0042_SAVE_DM_PLN_BP_FCST | MATCH | 1 | SP DMF0042_SAVE_DM_PLN_BP_FCST | EXEC:DMF0042_SAVE_DM_PLN_BP_FCST, CREATE:#TEMP_BP_FCST, CREATE:#TMP_DM_PLN_BP_FCST_X, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#TEMP_BP_FCST, SELECT:#TEMP_BP_FCST, SELECT:NERP_CONV_MASTER, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SITE_ITEM, INSERT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, SELECT:SCM_MST_ITEM_SN, INSERT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_B_V, DELETE:DM_PLN_BP_FCST, DELETE:#TEMP_BP_FCST, SELECT:DM_PLN_BP_FCST, UPDATE:A, DELETE:A, INSERT:DM_PLN_BP_FCST, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V, EXEC:DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV, SELECT:DM_BP_EXCHANGE_RATE, INSERT:#TMP_DM_PLN_BP_FCST_X, INSERT:DM_PLN_BP_FCST_H, SELECT:#TMP_DM_PLN_BP_FCST_X, INSERT:SCM_SYS_LOG_BATCH, CREATE:#FUTURE_PRICE_TEMP0, CREATE:#FUTURE_PRICE_TEMP2, CREATE:#FUTURE_PRICE_TEMP_QTY, INSERT:#FUTURE_PRICE_TEMP0, INSERT:#FUTURE_PRICE_TEMP1, SELECT:#FUTURE_PRICE_TEMP0, INSERT:#FUTURE_PRICE_TEMP2, SELECT:#FUTURE_PRICE_TEMP1, INSERT:#FUTURE_PRICE_TEMP_QTY, SELECT:#FUTURE_PRICE_TEMP2, INSERT:#FUTURE_PRICE_TEMP3, SELECT:SYSCURSORS, SELECT:#FUTURE_PRICE_TEMP_QTY, SELECT:#FUTURE_PRICE_TEMP3 |  |
| DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV | MATCH | 1 | SP DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV | EXEC:DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV, EXEC:PR_SCM_SYS_LOG_BATCH, CREATE:#FUTURE_PRICE_TEMP0, CREATE:#FUTURE_PRICE_TEMP2, CREATE:#FUTURE_PRICE_TEMP_QTY, INSERT:#FUTURE_PRICE_TEMP0, SELECT:#TEMP_BP_FCST, SELECT:DM_PLN_BP_FCST, INSERT:#FUTURE_PRICE_TEMP1, SELECT:#FUTURE_PRICE_TEMP0, INSERT:#FUTURE_PRICE_TEMP2, SELECT:#FUTURE_PRICE_TEMP1, INSERT:#FUTURE_PRICE_TEMP_QTY, SELECT:#FUTURE_PRICE_TEMP2, INSERT:#FUTURE_PRICE_TEMP3, SELECT:SYSCURSORS, SELECT:#FUTURE_PRICE_TEMP_QTY, SELECT:DM_BP_EXCHANGE_RATE, DELETE:DM_PLN_BP_FCST, SELECT:#FUTURE_PRICE_TEMP3, INSERT:DM_PLN_BP_FCST, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| DM.UP_FX_GetCommonDataList_DM | MATCH | 1 | SP UP_FX_GETCOMMONDATALIST_DM | EXEC:UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_PLANT_SN |  |
| SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | EXEC:SCM0001_GET_BIZ_TYPE_BY_DIVISION, SELECT:SCM_MST_PROJECT, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnReplace_Click | UserInfoContext.Current | NowGroupID |
| btnReplace_Click | row | YYYYMM |
| btnReplace_Click | dt.Rows[0] | YYYYMM |
| btnReplace_Click | dt.Rows[z] | YYYYMM |
| cboDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| FindData | UserInfoContext.Current | NowGroupID |
| FindData | ds.Tables[1].Rows[0] | VALID_YN, START_YYYYQQ, END_YYYYQQ, START_YYYYMM, END_YYYYMM, START_YYYY, END_YYYY |
| InitControls | UserInfoContext.Current | NowGroupID |
| InsertRow | UserInfoContext.Current | NowGroupID |
| InsertRow | dtMeasure.Rows[i] | CODE, NAME |
| SetComboCol | dr | CODE, NAME |
| SetComboColumn | dr | CELL_COMBO_DATA_TYPE |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| OnShown | OnShown:246 | BaseForm.OnShown | NowGroupID, USER_ID |
| GetCheckedListValue | OnShown:248, InitControls:263, InitControls:271, InitControls:321, EditButton:567, FindData:721, FindData:722, cboDivision_SelectedIndexChanged:1491 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:398 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumnDtDiv | InitSpread:400 | SpreadInfo.CreateSheetHeaderColumnDtDiv | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:706 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| LoadData | btnExchangeRate_Click:3111 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:157 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:158 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:159 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:160 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:161 |
| this.btnReplace | Click | btnReplace_Click | InitializeComponent:284 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:320 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:358 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:395 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:432 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:468 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:537 |
| this.cboBucketType | Click | cboBucketType_Click | InitializeComponent:538 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:732 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:772 |
| this.btnOwner | Click | btnOwner_Click | InitializeComponent:954 |
| this.btnSetPrice | Click | btnSetPrice_Click | InitializeComponent:991 |
| this.btnExchangeRate | Click | btnExchangeRate_Click | InitializeComponent:1028 |
| this.btnCutOff | Click | btnCutOff_Click | InitializeComponent:1065 |
| this.layoutControlItem3 | Click | btnProject_Click | InitializeComponent:1245 |
| this | Load | Form_Load | .ctor:229 |
| dsdm | Changed | spdMain_Changed | DefineProperty:381 |
| clbDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | DefineProperty:383 |
| cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | DefineProperty:384 |

## 6. 컨트롤 (58개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 24 | lblTeam, lblCustomer, lblBizType, lblSalesSite, lblProject, layoutControlItem3, layoutControlItem1, layoutControlItem4, lblPlantSite, layoutControlItem5, layoutControlItem2, lblDivision, lblModel, lblOwner, layoutControlItem6 … |
| UsrButton | 9 | btnReplace, btnItemId, btnMeasure, btnColumn, btnProject, btnOwner, btnSetPrice, btnExchangeRate, btnCutOff |
| UsrCheckedList | 6 | clbSalesSite, clbBizType, clbCustomer, clbTeam, clbPlantSite, clbItemType |
| UsrMultiLineEditor | 3 | txtProject, txtItemId, txtOwner |
| UsrCombo | 3 | cboBucketType, clbDivision, cboClosed |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl3 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup3 |
| UsrCheckBox | 2 | chkSum, cboQty |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel2 |
| UsrDateRangePicker | 1 | drpPeriod |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Biz Plan
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumnDtDiv@InitSpread:400
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetComboColumn, SetSpreadHeaderSpan, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadHeaderSpan |  | 444 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadColumn |  | 501 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Q_") == 0) |
| SetSpreadColumn |  | 504 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Q_") == 0) |
| SetSpreadColumn |  | 509 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "MONTHLY") ⟫ if(cboBucketType.ControlValues == "QUARTERLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 511 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "MONTHLY") ⟫ if(cboBucketType.ControlValues == "QUARTERLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Q_") == 0) |
| SetSpreadColumn |  | 514 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "MONTHLY") ⟫ if(cboBucketType.ControlValues == "QUARTERLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_") == 0) |
| SetSpreadColumn |  | 519 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(cboBucketType.ControlValues == "QUARTERLY") ⟫ if(cboBucketType.ControlValues == "YEARLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Q_") == 0) |
| SetSpreadColumn |  | 521 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(cboBucketType.ControlValues == "QUARTERLY") ⟫ if(cboBucketType.ControlValues == "YEARLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Q_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Y_") == 0) |
| spdMain_CellDoubleClick |  | 1675 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("Q_") == 0) |
| spdMain_CellDoubleClick |  | 1681 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("Q_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 1697 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("Q_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 177 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 178 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 179 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 180 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
