# DMF0048 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0048_SalesMonitoring\DMF0048_SalesMonitoring.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0048_SalesMonitoring\DMF0048_SalesMonitoring.csproj | 2181 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0048_SalesMonitoring\DMF0048_SalesMonitoring.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0048_SalesMonitoring\DMF0048_SalesMonitoring.csproj | 1460 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0048_SalesMonitoring\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0048_SalesMonitoring\DMF0048_SalesMonitoring.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0048_SalesMonitoring\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0048_SalesMonitoring\DMF0048_SalesMonitoring.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0048_SalesMonitoring\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0048_SalesMonitoring\DMF0048_SalesMonitoring.csproj | 27 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\DMF0048_SalesPlanMonitoring.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1310 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\DMF0048_SalesPlanMonitoring.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1462 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0048_SalesMonitoring.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 2131 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0048_SalesMonitoring.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1460 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 412 | DM.DMF0048_GET_SPREAD_TITLE | MATCH | SP DMF0048_GET_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 533 | DM.DMF0048_GET_DM_PLN_SALES_MONITORING | MATCH | SP DMF0048_GET_DM_PLN_SALES_MONITORING |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 540 | DM.DMF0048_GET_SPREAD_TITLE | MATCH | SP DMF0048_GET_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 693 | DM.DMF0048_GET_DM_PLN_SALES_MONITORING | MATCH | SP DMF0048_GET_DM_PLN_SALES_MONITORING |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 412 | DM.DMF0048_GET_SPREAD_TITLE | MATCH | SP DMF0048_GET_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 540 | DM.DMF0048_GET_SPREAD_TITLE | MATCH | SP DMF0048_GET_SPREAD_TITLE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 412 | DM.DMF0048_GET_SPREAD_TITLE | MATCH | SP DMF0048_GET_SPREAD_TITLE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 540 | DM.DMF0048_GET_SPREAD_TITLE | MATCH | SP DMF0048_GET_SPREAD_TITLE |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 540 | DM.DMF0048_GET_SPREAD_TITLE | MATCH | SP DMF0048_GET_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 412 | DM.DMF0048_GET_SPREAD_TITLE | MATCH | SP DMF0048_GET_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 540 | DM.DMF0048_GET_SPREAD_TITLE | MATCH | SP DMF0048_GET_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > GetBizTypebyDivision | 781 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 1187 | biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 1190 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.clbTeam.SelectedIndexChanged | clbTeam_SelectedIndexChanged | 1262 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.clbTeam.SelectedIndexChanged | clbTeam_SelectedIndexChanged | 1267 | biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 223 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 235 | biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 238 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 283 | biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 286 | biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 412 | biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 412 | DM.DMF0048_GET_SPREAD_TITLE | MATCH | SP DMF0048_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls | 415 | biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 540 | DM.DMF0048_GET_SPREAD_TITLE | MATCH | SP DMF0048_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetDayRange | 740 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 756 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetItemType | 768 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls > GetBizTypebyDivision | 781 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > GetSALESPLAN_MEASUREInfo | 794 | DM.DMF0021_GET_SALES_PLAN_MEASUREINFO | MATCH | SP DMF0021_GET_SALES_PLAN_MEASUREINFO |
| event:this.Load | Form_Load > InitControls > GetSALESPLAN_MEASUREInfo2 | 807 | DM.DMF0021_GET_SALES_PLAN_MEASUREINFO2 | MATCH | SP DMF0021_GET_SALES_PLAN_MEASUREINFO2 |
| event:this.Load | Form_Load > InitControls > GetDayRange | 992 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1008 | DM.DMF0003_GET_BUCKET_TYPE_CODE | MATCH | SP DMF0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetItemType | 1020 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| unreached:(진입점 미연결) | GetDivision | 962 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetScmSitebyDivision | 976 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivision | 1034 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivision | 1047 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetBizTypebyDivision | 1061 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| unreached:(진입점 미연결) | GetEndCustomerbyDivision | 1074 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomer | 1787 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetBizTypebyDivisionAsync | 1947 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivisionAsync | 1961 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivisionAsync | 1974 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomerAsync | 1989 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetScmSitebyDivisionAsync | 2005 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE_ITEM, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GETCOMMONDATALIST_DM:REF:STRING_SPLIT, UP_FX_GETCOMMONDATALIST_DM:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DMF0003_GET_BUCKET_TYPE_CODE | EXEC:DMF0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0021_GET_SALES_PLAN_MEASUREINFO | MATCH | 1 | SP DMF0021_GET_SALES_PLAN_MEASUREINFO | EXEC:DMF0021_GET_SALES_PLAN_MEASUREINFO, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0021_GET_SALES_PLAN_MEASUREINFO2 | MATCH | 1 | SP DMF0021_GET_SALES_PLAN_MEASUREINFO2 | EXEC:DMF0021_GET_SALES_PLAN_MEASUREINFO2, SELECT:SCM_MST_SHEET_MEASURE |  |
| DM.DMF0048_GET_DM_PLN_SALES_MONITORING | MATCH | 2 | SP DMF0048_GET_DM_PLN_SALES_MONITORING | EXEC:DMF0048_GET_DM_PLN_SALES_MONITORING, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:TB_FX_USER, SELECT:SCM_MST_TITLESET_USER, INSERT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#SELECT_MEASURE, SELECT:#SELECT_MEASURE, CREATE:#RAW_DATA, CREATE:#TEMP_SHIPMENT_SITE, INSERT:#RAW_DATA, SELECT:DM_PLN_SALES_PLAN, SELECT:SCM_MST_SITE, SELECT:DM_PLN_SALES_ETC_PLAN, SELECT:DM_PLN_SALES_PLAN_RESULT, SELECT:#RAW_DATA, REF:FN_NEXT_DAY, UPDATE:A, SELECT:SCM_MST_SITE_ITEM, DELETE:#RAW_DATA, SELECT:SCM_MST_COMPANY_SN, INSERT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, SELECT:SCM_MST_ITEM_SN, INSERT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_B_V, UPDATE:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V, INSERT:#TEMP_SCM_MST_SITE_ITEM, REF:FN_GET_DM_MKT_OWNER_NAME, SELECT:SCM_MST_SSO_USER_INFO, REF:STRING_SPLIT, DELETE:A, SELECT:SCM_MST_PROJECT, SELECT:#TEMP_SCM_MST_SITE_ITEM, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_FUTURE_PRICE, SELECT:DM_PLN_CFM_SELLING_PRICE, INSERT:#TEMP_SCM_MST_SITE, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CITY, SELECT:SCM_MST_COUNTRY, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:SCP_PLAN_VERSION_V, INSERT:#TEMP_SHIPMENT_SITE_ROW, SELECT:SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCP_ANL_PROBLEM_REPORT_PEGGING, INSERT:#TEMP_SHIPMENT_SITE, SELECT:#TEMP_SHIPMENT_SITE_ROW, CREATE:#T_COLUMN_SETUP, INSERT:#T_COLUMN_SETUP, INSERT:#T, REF:UF_FX_STRING_SPLIT, SELECT:#T_COLUMN_SETUP, SELECT:#T |  |
| DM.DMF0048_GET_SPREAD_TITLE | MATCH | 2 | SP DMF0048_GET_SPREAD_TITLE | EXEC:DMF0048_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.PR_GET_DAY_RANGE | MATCH | 2 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | 3 | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | EXEC:SCM0001_GET_BIZ_TYPE_BY_DIVISION, SELECT:SCM_MST_PROJECT, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | 3 | SP SCM0001_GET_CUSTOMER_BY_DIVISION | EXEC:SCM0001_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 2 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | 2 | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | EXEC:SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_TEAM_BY_DIVISION | EXEC:SCM0001_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| FindData | UserInfoContext.Current | NowGroupID, Dept_ID |
| FindData | ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1] | MEASURE |
| FindData | ds.Tables[1].Rows[0] | ISO_WEEK, BASIS_DATE, BASIS_YYYYMM, THIS_YYYYMMWW, PRE_YYYYMMWW |
| InitControls | UserInfoContext.Current | NowGroupID |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:263, SetChangeControl:270, SetChangeControl:278, SetChangeControl:285, SetChangeControl:294, SetChangeControl:302, SetChangeControl:309 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| GetCheckedListValue | InitControls:326, InitControls:334, InitControls:387, FindData:656, btnProject_Click:1087, btnItemId_Click:1104, clbDivision_SelectedIndexChanged:1843, clbDivision_SelectedIndexChanged:1851 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:494, InitSpread:367 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:496, InitSpread:369 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| FP_Log2 | clbDivision_SelectedIndexChanged:1831, clbDivision_SelectedIndexChanged:1923 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:151 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:309 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:348 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:386 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:424 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:461 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:532 |
| this.cboBucketType | Click | cboBucketType_Click | InitializeComponent:533 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:731 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:772 |
| this.btnOwner | Click | btnOwner_Click | InitializeComponent:959 |
| this.layoutControlItem3 | Click | btnProject_Click | InitializeComponent:1104 |
| this.chkColor | CheckedChanged | chkColor_CheckedChanged | InitializeComponent:1341 |
| this | Load | Form_Load | .ctor:223 |
| this.txtProject | KeyDown | txtProject_KeyDown | DefineProperty:439 |
| this.txtItemId | KeyDown | txtItemId_KeyDown | DefineProperty:440 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | DefineProperty:441 |
| dsdm | Changed | Dsdm_Changed | CreateSpread:470 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:308 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:347 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:385 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:423 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:460 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:531 |
| this.cboBucketType | Click | cboBucketType_Click | InitializeComponent:532 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:730 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:771 |
| this.btnOwner | Click | btnOwner_Click | InitializeComponent:958 |
| this.layoutControlItem3 | Click | btnProject_Click | InitializeComponent:1140 |
| this | Load | Form_Load | .ctor:202 |
| this.txtProject | KeyDown | txtProject_KeyDown | DefineProperty:312 |
| this.txtItemId | KeyDown | txtItemId_KeyDown | DefineProperty:313 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | DefineProperty:314 |
| dsdm | Changed | Dsdm_Changed | CreateSpread:343 |

## 6. 컨트롤 (106개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 42 | lblTeam, lblCustomer, lblBizType, lblSalesSite, lblProject, layoutControlItem3, layoutControlItem1, layoutControlItem4, lblPlantSite, layoutControlItem5, layoutControlItem2, lblBucket, Period, lblItemType, lblDivision … |
| UsrCheckedList | 12 | clbSalesSite, clbBizType, clbCustomer, clbTeam, clbPlantSite, clbItemType, clbSalesSite, clbBizType, clbCustomer, clbTeam, clbPlantSite, clbItemType |
| UsrButton | 10 | btnItemId, btnMeasure, btnColumn, btnProject, btnOwner, btnItemId, btnMeasure, btnColumn, btnProject, btnOwner |
| UsrCheckBox | 8 | InternalYN, chkSum, cboCellQty, chkColor, InternalYN, chkSum, cboUnitYN, cboCellQty |
| UsrMultiLineEditor | 6 | txtProject, txtItemId, txtOwner, txtProject, txtItemId, txtOwner |
| EmptySpaceItem | 6 | emptySpaceItem1, emptySpaceItem4, emptySpaceItem2, emptySpaceItem1, emptySpaceItem4, emptySpaceItem2 |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl3, usrLayoutControl1, usrLayoutControl3 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup3, layoutControlGroup1, layoutControlGroup3 |
| UsrCombo | 4 | cboBucketType, clbDivision, cboBucketType, clbDivision |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrConditionPanel | 2 | usrConditionPanel2, usrConditionPanel2 |
| UsrDateRangePicker | 2 | drpPeriod, drpPeriod |
| ImageList | 2 | imageList1, imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 491 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 54 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 38 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 343 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 4 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 7 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 97 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (3건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 539 | DM_H.DM0021_GET_SPREAD_TITLE | commented:MATCH |
| 963 | DM.Get_Division | commented:NOT_IN_FOXQUERY |
| 411 | DM_H.DM0021_GET_SPREAD_TITLE | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0048 | Sales Monitoring | 11/25 | 15/15 | 15/15 | 15/15 | 15/15 | 15/15 | 15/15 | 11/8 | · | · | · | · | · | · |
| SCM_MST_SHEET_MEASURE | DMF0048 | Sales Monitoring | 4/8 | 5/11 | 5/11 | 5/11 | 5/11 | 5/11 | 5/11 | 4/11 | · | · | · | · | · | · |
| SCM_MST_SHEET_MEASURE | DMF0048 | Sales Plan Waterfall | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 128건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Sales Monitoring, Sales Plan
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:496, CreateSheetHeaderColumn@InitSpread:369
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| FindData |  | 777 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?dateTime.ToString("yyyyMM")}0 \|\| W_{?dateTime.ToString("yyyyMM")}{?Convert.ToInt32(ds.Tables[1].Rows[0]["ISO_WEEK"].ToString())} \|\| W_{?sResult_YYYYMMDD.Substring(0, 6)}0 \|\| W_{?sResult_YYYYMMDD.Substring(0, 6)}{?Convert.ToInt32(ds.Tables[1].Rows[0]["ISO_WEEK"].ToString())} | else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0 \|\| siMain.GetColumnIndex(sResult_YYYYMMWW) > 0) ⟫ if(siMain.GetColumnIndex(sResult_YYYYMMWW) > 0) |
| FindData |  | 779 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | {?ds.Tables[1].Rows[0]["THIS_YYYYMMWW"]} | else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0 \|\| siMain.GetColumnIndex(sResult_YYYYMMWW) > 0) ⟫ else!(siMain.GetColumnIndex(sResult_YYYYMMWW) > 0) |
| FindData |  | 785 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | D_{?DateTime.Today.ToString("yyyyMMdd")} | else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ else!(cboBucketType.ControlValues != "DAILY") ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnIndex("D_" + sPre_YYYYMMDD) > 0) |
| cboBucketType_SelectedIndexChanged |  | 1150 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | D_{?DateTime.Today.ToString("yyyyMMdd")} | if(siMain != null) ⟫ if(chkColor.Checked == false) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnIndex("D_" + sPre_YYYYMMDD) > 0) |
| cboBucketType_SelectedIndexChanged |  | 1165 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?dateTime.ToString("yyyyMM")}0 \|\| W_{?dateTime.ToString("yyyyMM")}{?Convert.ToInt32(ds.Tables[1].Rows[0]["ISO_WEEK"].ToString())} \|\| W_{?sResult_YYYYMMDD.Substring(0, 6)}0 \|\| W_{?sResult_YYYYMMDD.Substring(0, 6)}{?Convert.ToInt32(ds.Tables[1].Rows[0]["ISO_WEEK"].ToString())} | if(siMain != null) ⟫ if(chkColor.Checked == false) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(sResult_YYYYMMWW) > 0) |
| cboBucketType_SelectedIndexChanged |  | 1169 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | {?ds.Tables[1].Rows[0]["THIS_YYYYMMWW"]} | if(siMain != null) ⟫ if(chkColor.Checked == false) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ else!(siMain.GetColumnIndex(sResult_YYYYMMWW) > 0) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) |
| SetSpreadColumn |  | 1202 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1204 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1209 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1211 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1214 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1219 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1221 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1234 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sPre_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 1235 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sPre_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 1236 | 표시/라벨 변경 | set:Width | Width = 60 |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sPre_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 1243 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(Convert.ToString(weekNumber) == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sPre_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 1244 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(Convert.ToString(weekNumber) == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sPre_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 1251 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(check == false) ⟫ if(siMain.GetColumnTag(iCol).ToString() == this_YYYYMMWW) |
| SetSpreadColumn |  | 1252 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(check == false) ⟫ if(siMain.GetColumnTag(iCol).ToString() == this_YYYYMMWW) |
| SetSpreadColumn |  | 1263 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sResult_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 1264 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sResult_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 1265 | 표시/라벨 변경 | set:Width | Width = 60 |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sResult_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 1272 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(Convert.ToString(weekNumber) == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sResult_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 1273 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(Convert.ToString(weekNumber) == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sResult_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 1280 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(check == false) ⟫ if(siMain.GetColumnTag(iCol).ToString() == this_YYYYMMWW) |
| SetSpreadColumn |  | 1281 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(check == false) ⟫ if(siMain.GetColumnTag(iCol).ToString() == this_YYYYMMWW) |
| SetSpreadHeaderSpan |  | 1329 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan |  | 1342 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| InitializeComponent |  | 167 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 168 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 169 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 170 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadColumn |  | 883 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 885 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 890 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 892 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 895 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 900 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 902 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadHeaderSpan |  | 942 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan |  | 955 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| InitializeComponent |  | 166 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 167 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 168 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 169 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Sales Monitoring | META+코드연결 | 11 | 15 | 15 | 15 | 15 | 15 | 15 | 11 | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
