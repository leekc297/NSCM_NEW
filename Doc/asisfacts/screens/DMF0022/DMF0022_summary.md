# DMF0022 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0022_SalesPlanWaterfall\DMF0022_SalesPlanWaterfall.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0022_SalesPlanWaterfall\DMF0022_SalesPlanWaterfall.csproj | 2770 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0022_SalesPlanWaterfall\DMF0022_SalesPlanWaterfall.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0022_SalesPlanWaterfall\DMF0022_SalesPlanWaterfall.csproj | 1802 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0022_SalesPlanWaterfall\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0022_SalesPlanWaterfall\DMF0022_SalesPlanWaterfall.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0022_SalesPlanWaterfall\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0022_SalesPlanWaterfall\DMF0022_SalesPlanWaterfall.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0022_SalesPlanWaterfall\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0022_SalesPlanWaterfall\DMF0022_SalesPlanWaterfall.csproj | 27 |
| shared | 06.UIL\GSCM.DM.Shipment.UIL\DMF0022_SalesPlanWaterfall2.cs | 06.UIL\GSCM.DM.Shipment.UIL\GSCM.DM.Shipment.UIL.csproj | 2427 |
| shared | 06.UIL\GSCM.DM.Shipment.UIL\DMF0022_SalesPlanWaterfall2.Designer.cs | 06.UIL\GSCM.DM.Shipment.UIL\GSCM.DM.Shipment.UIL.csproj | 1829 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0022_SalesPlanWaterfall.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 2667 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0022_SalesPlanWaterfall.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1802 |
| legacy | 06.UIL\GSCM.DM.Shipment.UIL\DMF0022_SalesPlanWaterfall.cs | 06.UIL\GSCM.DM.Shipment.UIL\GSCM.DM.Shipment.UIL.csproj | 2210 |
| legacy | 06.UIL\GSCM.DM.Shipment.UIL\DMF0022_SalesPlanWaterfall.Designer.cs | 06.UIL\GSCM.DM.Shipment.UIL\GSCM.DM.Shipment.UIL.csproj | 1712 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged | 1201 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged | 1207 | biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 1803 | DM.DMF0022_GET_SPREAD_TITLE | MATCH | SP DMF0022_GET_SPREAD_TITLE |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > GetBizTypebyDivisionAsync | 1933 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| button:FindButton | FindButton > FindData | 772 | DM.DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL2 | MATCH | SP DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL2 |
| button:FindButton | FindButton > FindData | 1122 | DM.DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL | MATCH | SP DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 1803 | DM.DMF0022_GET_SPREAD_TITLE | MATCH | SP DMF0022_GET_SPREAD_TITLE |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 2125 | DM.DMF0022_GET_SPREAD_TITLE | MATCH | SP DMF0022_GET_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 1803 | DM.DMF0022_GET_SPREAD_TITLE | MATCH | SP DMF0022_GET_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 2125 | DM.DMF0022_GET_SPREAD_TITLE | MATCH | SP DMF0022_GET_SPREAD_TITLE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 1803 | DM.DMF0022_GET_SPREAD_TITLE | MATCH | SP DMF0022_GET_SPREAD_TITLE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 2125 | DM.DMF0022_GET_SPREAD_TITLE | MATCH | SP DMF0022_GET_SPREAD_TITLE |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 2125 | DM.DMF0022_GET_SPREAD_TITLE | MATCH | SP DMF0022_GET_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 2125 | DM.DMF0022_GET_SPREAD_TITLE | MATCH | SP DMF0022_GET_SPREAD_TITLE |
| event:this.clbTeam.SelectedIndexChanged | clbTeam_SelectedIndexChanged | 2309 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 260 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 283 | biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 286 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 342 | biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 344 | biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 346 | biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 414 | biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 416 | biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 418 | biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1803 | DM.DMF0022_GET_SPREAD_TITLE | MATCH | SP DMF0022_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1821 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetItemType | 1834 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls > GetBizTypebyDivision | 1919 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > GetQtyData | 1953 | DM.DMF0003_GET_QTY_TYPE_CODE | MATCH | SP DMF0003_GET_QTY_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetDayRange | 2107 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2125 | DM.DMF0022_GET_SPREAD_TITLE | MATCH | SP DMF0022_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 2144 | DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE | MATCH | SP DMF0003_GET_REPORT_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetItemType | 2157 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls > GetQtyData | 2257 | DM.DMF0003_GET_QTY_TYPE_CODE | MATCH | SP DMF0003_GET_QTY_TYPE_CODE |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetScmSitebyDivision | 1687 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetPlantSitebyEndCustomer | 1727 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetScmSitebyDivision | 2043 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetPlantSitebyEndCustomer | 2075 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | InitSpread_X | 531 | DM_H.DM0022_GET_SPREAD_TITLE_DATE | MATCH | SP DM0022_GET_SPREAD_TITLE_DATE |
| unreached:(진입점 미연결) | GetScmSitebyDivisionAsync | 1703 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomerAsync | 1743 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetTeambyDivision | 1849 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivisionAsync | 1863 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivision | 1882 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivisionAsync | 1897 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetScmSitebyDivisionAsync | 2059 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomerAsync | 2091 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetTeambyDivision | 2172 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivisionAsync | 2186 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivision | 2199 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivisionAsync | 2214 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetBizTypebyDivision | 2229 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| unreached:(진입점 미연결) | GetBizTypebyDivisionAsync | 2243 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| unreached:(진입점 미연결) | GetLookupValues | 2756 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM_H.DM0022_GET_SPREAD_TITLE_DATE | MATCH | 1 | SP DM0022_GET_SPREAD_TITLE_DATE | EXEC:DM0022_GET_SPREAD_TITLE_DATE, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0003_GET_QTY_TYPE_CODE | MATCH | 2 | SP DMF0003_GET_QTY_TYPE_CODE | EXEC:DMF0003_GET_QTY_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE | MATCH | 1 | SP DMF0003_GET_REPORT_BUCKET_TYPE_CODE | EXEC:DMF0003_GET_REPORT_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL | MATCH | 1 | SP DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL | EXEC:DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL, SELECT:SCM_SYS_CALENDAR_M, CREATE:#V_VERSION_NO, INSERT:#V_VERSION_NO, REF:STRING_SPLIT, SELECT:SCM_MST_TITLESET_USER, INSERT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#TEMP_SCM_MST_SHEET_MEASURE, INSERT:#SELECT_MEASURE, SELECT:#TEMP_SCM_MST_SHEET_MEASURE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#TEMP_PROGRAM_ADD_MEASURE, SELECT:#SELECT_MEASURE, SELECT:#TEMP_PROGRAM_ADD_MEASURE, CREATE:#RAW_DATA, INSERT:#RAW_DATA, SELECT:DM_PLN_SALES_PLAN, SELECT:SCM_MST_SITE, SELECT:DM_PLN_SALES_ETC_PLAN, SELECT:DM_PLN_SALES_PLAN_RESULT, SELECT:DM_PLN_SALES_PLAN_C, SELECT:#V_VERSION_NO, SELECT:DM_PLN_SALES_ETC_PLAN_C, SELECT:DM_PLN_SALES_PLAN_RESULT_C, REF:FN_NEXT_DAY, SELECT:#RAW_DATA, UPDATE:A, SELECT:SCM_MST_SITE_ITEM, DELETE:#RAW_DATA, SELECT:SCM_MST_COMPANY_SN, INSERT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, SELECT:SCM_MST_ITEM_SN, INSERT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#TEMP_SCM_MST_SITE_ITEM, REF:FN_GET_DM_MKT_OWNER_NAME, SELECT:SCM_MST_SSO_USER_INFO, DELETE:A, SELECT:#TEMP_SCM_MST_SITE_ITEM, SELECT:SCM_MST_PROJECT, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:DM_PLN_CFM_SELLING_PRICE, SELECT:SCM_MST_FUTURE_PRICE, CREATE:#T_PRICE, INSERT:#T_PRICE, SELECT:DM_PLN_CFM_SELLING_PRICE_C, SELECT:SCM_MST_FUTURE_PRICE_C, SELECT:#T_PRICE, INSERT:#TEMP_SCM_MST_SITE, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CITY, SELECT:SCM_MST_COUNTRY, SELECT:SCM_MST_CUSTOMER, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V_T, SELECT:SCM_MST_SHEET_COLUMNS |  |
| DM.DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL2 | MATCH | 1 | SP DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL2 | EXEC:DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL2 | ⚠ DB에 SP 없음 |
| DM.DMF0022_GET_SPREAD_TITLE | MATCH | 2 | SP DMF0022_GET_SPREAD_TITLE | EXEC:DMF0022_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| DM.UP_FX_GetCommonDataList_DM | MATCH | 1 | SP UP_FX_GETCOMMONDATALIST_DM | EXEC:UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_PLANT_SN |  |
| SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | 4 | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | EXEC:SCM0001_GET_BIZ_TYPE_BY_DIVISION, SELECT:SCM_MST_PROJECT, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | 4 | SP SCM0001_GET_CUSTOMER_BY_DIVISION | EXEC:SCM0001_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 2 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | 4 | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | EXEC:SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 4 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | 4 | SP SCM0001_GET_TEAM_BY_DIVISION | EXEC:SCM0001_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| ClbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| Draw | ds.Tables[0].Columns | SORT_ORDER_NO |
| Draw | ds.Tables[0].Rows[i] | NOTATION |
| Draw | ds.Tables[1].Rows[0] | ISO_WEEK, BASIS_DATE |
| FindData | UserInfoContext.Current | Dept_ID, NowGroupID |
| FindData | ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1] | MEASURE |
| GetDayRange | UserInfoContext.Current | TimeZone |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitSpread_X | nvc | p_start_yyyymmdd, p_end_yyyymmdd, p_created_by |
| InitSpread_X | dt.Rows[i] | BASIS_YYYYMM, COL_WEEK_NAME, CALENDAR_DAY, BASIS_YYYYMMDD, DAYOFWEEK, WEEK_NAME |
| InitSpread_X | dt.Rows[i - 1] | WEEK_NAME |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:250, SetChangeControl:257, SetChangeControl:265, SetChangeControl:272, SetChangeControl:281, SetChangeControl:289, SetChangeControl:296 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| GetCheckedListValue | InitControls:325, InitControls:404, InitControls:405, InitControls:406, FindData:1084, Draw:1237, Draw:1238, ClbDivision_SelectedIndexChanged:1521 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:499, InitSpread:442 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:500, InitSpread:443 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| FP_Log2 | ClbDivision_SelectedIndexChanged:1502, ClbDivision_SelectedIndexChanged:1601 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.chkMem | CheckedChanged | chkMem_CheckedChanged | InitializeComponent:240 |
| this.btnVersion | Click | btnVersion_Click | InitializeComponent:277 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:314 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:392 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:430 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:467 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:539 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:577 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:775 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:816 |
| this.cboLOC | SelectedIndexChanged | cboLOC_SelectedIndexChanged | InitializeComponent:854 |
| this.cboKRW | SelectedIndexChanged | cboKRW_SelectedIndexChanged | InitializeComponent:892 |
| this.cboUSD | SelectedIndexChanged | cboUSD_SelectedIndexChanged | InitializeComponent:930 |
| this.txtVersion | KeyDown | txtVersion_KeyDown | InitializeComponent:966 |
| this.usrButton1 | Click | btnOwner_Click | InitializeComponent:1113 |
| this.cboQTY | SelectedIndexChanged | cboQTY_SelectedIndexChanged | InitializeComponent:1151 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1633 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1634 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:1635 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:1636 |
| this | FormClosed | DM0022_SalesPlanWaterfall_FormClosed | InitializeComponent:1688 |
| this | Load | Form_Load | .ctor:213 |
| this.txtProject | KeyDown | txtProject_KeyDown | DefineProperty:451 |
| this.txtItemId | KeyDown | txtItemId_KeyDown | DefineProperty:452 |
| clbSalesSite | SelectedIndexChanged | ClbSalesSite_SelectedIndexChanged | InitEvent:668 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:669 |
| this.clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:670 |
| cboKRW | SelectedIndexChanged | cboKRW_SelectedIndexChanged | FindData:1197 |
| cboUSD | SelectedIndexChanged | cboUSD_SelectedIndexChanged | FindData:1198 |
| cboLOC | SelectedIndexChanged | cboLOC_SelectedIndexChanged | FindData:1199 |
| cboKRW | SelectedIndexChanged | cboKRW_SelectedIndexChanged | FindData:1201 |
| cboUSD | SelectedIndexChanged | cboUSD_SelectedIndexChanged | FindData:1202 |
| cboLOC | SelectedIndexChanged | cboLOC_SelectedIndexChanged | FindData:1203 |
| this.btnVersion | Click | btnVersion_Click | InitializeComponent:276 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:314 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:390 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:427 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:463 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:533 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:570 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:763 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:803 |
| this.cboLOC | SelectedIndexChanged | cboLOC_SelectedIndexChanged | InitializeComponent:840 |
| this.cboKRW | SelectedIndexChanged | cboKRW_SelectedIndexChanged | InitializeComponent:877 |
| this.cboUSD | SelectedIndexChanged | cboUSD_SelectedIndexChanged | InitializeComponent:914 |
| this.txtVersion | KeyDown | txtVersion_KeyDown | InitializeComponent:949 |
| this.usrButton1 | Click | btnOwner_Click | InitializeComponent:1092 |
| this.cboQTY | SelectedIndexChanged | cboQTY_SelectedIndexChanged | InitializeComponent:1129 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1658 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1659 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:1660 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:1661 |
| this | FormClosed | DM0022_SalesPlanWaterfall_FormClosed | InitializeComponent:1712 |
| this | Load | Form_Load | .ctor:178 |
| this.txtProject | KeyDown | txtProject_KeyDown | DefineProperty:379 |
| this.txtItemId | KeyDown | txtItemId_KeyDown | DefineProperty:380 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:643 |
| clbSalesSite | SelectedIndexChanged | ClbSalesSite_SelectedIndexChanged | InitEvent:644 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:645 |
| cboKRW | SelectedIndexChanged | cboKRW_SelectedIndexChanged | FindData:1113 |
| cboUSD | SelectedIndexChanged | cboUSD_SelectedIndexChanged | FindData:1114 |
| cboLOC | SelectedIndexChanged | cboLOC_SelectedIndexChanged | FindData:1115 |
| cboKRW | SelectedIndexChanged | cboKRW_SelectedIndexChanged | FindData:1121 |
| cboUSD | SelectedIndexChanged | cboUSD_SelectedIndexChanged | FindData:1122 |
| cboLOC | SelectedIndexChanged | cboLOC_SelectedIndexChanged | FindData:1123 |

## 6. 컨트롤 (128개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 55 | lblTeam, lblCustomer, lblBizType, lblSalesSite, lblModel, layoutControlItem3, layoutControlItem1, layoutControlItem2, layoutControlItem4, Period, lblProject, lblPlantSite, lblVersion, layoutControlItem6, lblBucket2 … |
| UsrButton | 12 | btnVersion, btnMeasure, btnColumn, btnProject, btnItemId, usrButton1, btnVersion, btnMeasure, btnColumn, btnProject, btnItemId, usrButton1 |
| UsrCheckedList | 12 | clbPlantSite, clbSalesSite, clbBizType, clbCustomer, clbTeam, clbItemType, clbPlantSite, clbSalesSite, clbBizType, clbCustomer, clbTeam, clbItemType |
| UsrCombo | 12 | cboBucketType, cboLOC, cboKRW, cboUSD, clbDivision, cboQTY, cboBucketType, cboLOC, cboKRW, cboUSD, clbDivision, cboQTY |
| UsrCheckBox | 9 | chkMem, chkSum, InternalYN, cboCellQty, chkMem, chkSum, InternalYN, cboCellQty, cboUnitYN |
| UsrMultiLineEditor | 8 | txtProject, txtItemId, txtVersion, txtOwner, txtProject, txtItemId, txtVersion, txtOwner |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 4 | emptySpaceItem2, emptySpaceItem1, emptySpaceItem2, emptySpaceItem1 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrDateRangePickerWtWeek | 1 | drpPeriod |
| UsrDateRangePicker | 1 | drpPeriod |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 2270 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 26 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 66 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 29 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 407 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 86 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 1874 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (4건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 2124 | DM_H.DM0022_GET_SPREAD_TITLE | commented:MATCH |
| 1766 | DM.PR_GET_DAY_RANGE | commented:MATCH |
| 1787 | DM_H.DM0022_GET_SPREAD_TITLE | commented:MATCH |
| 1802 | DM_H.DM0022_GET_SPREAD_TITLE | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0022 | Sales Plan Waterfall | 13/32 | 16/22 | 16/22 | 16/22 | 16/22 | 16/22 | 16/22 | 14/17 | · | · | · | · | · | · |
| SCM_MST_SHEET_MEASURE | DMF0022 | Sales Plan Waterfall | 11/9 | 6/13 | 6/13 | 6/13 | 6/13 | 6/13 | 6/13 | 5/10 | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 128건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Sales Plan Waterfall
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:500, CreateSheetHeaderColumn@InitSpread:443
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| spdMain_CellDoubleClick |  | 1709 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| spdMain_CellDoubleClick |  | 1715 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(fBucket == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 1721 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ else!(fBucket == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(!siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 1735 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(fBucket == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadHeaderSpan |  | 1877 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan |  | 1887 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| SetSpreadHeader |  | 1953 | 표시/라벨 변경 | set:Text | Text = {?sLargeLabelName} |  | foreach(dr in dt.Rows) ⟫ else!("0"< iStartCol) |
| SetSpreadHeader |  | 1954 | 표시/라벨 변경 | set:Text | Text = {?sSmallLabelName} |  | foreach(dr in dt.Rows) ⟫ else!("0"< iStartCol) |
| SetSpreadHeader |  | 1955 | 표시/라벨 변경 | set:Text | Text = SUM |  | foreach(dr in dt.Rows) ⟫ else!("0"< iStartCol) |
| SetSpreadColumn |  | 1977 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1980 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1985 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1987 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1990 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1995 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1997 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 2006 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkMem.Checked == false) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sResult_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 2007 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkMem.Checked == false) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sResult_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 2008 | 표시/라벨 변경 | set:Width | Width = 60 |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkMem.Checked == false) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sResult_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 2015 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkMem.Checked == false) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(iso_week == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sResult_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 2016 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkMem.Checked == false) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(iso_week == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sResult_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 2023 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkMem.Checked == false) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(check == false) ⟫ if(siMain.GetColumnTag(iCol).ToString() == this_YYYYMMWW) |
| SetSpreadColumn |  | 2024 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkMem.Checked == false) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(check == false) ⟫ if(siMain.GetColumnTag(iCol).ToString() == this_YYYYMMWW) |
| InitializeComponent |  | 1652 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1653 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1654 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1655 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread_X |  | 553 | DB루프 | AddNumColumn | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | for(i < dt.Rows.Count) ⟫ if("0"== 0) |
| InitSpread_X |  | 567 | DB루프 | AddNumColumn | SUM | W_{?dt.Rows[i]["COL_WEEK_NAME"]} | for(i < dt.Rows.Count) ⟫ if("0"== 0) |
| InitSpread_X |  | 583 | DB루프 | AddNumColumn | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | for(i < dt.Rows.Count) ⟫ if(sFYear != dt.Rows["0"]["BASIS_YYYYMM"].ToString()) |
| InitSpread_X |  | 600 | DB루프 | AddNumColumn | SUM | W_{?dt.Rows[i]["COL_WEEK_NAME"]} | for(i < dt.Rows.Count) ⟫ if(sFWeek != dt.Rows["0"]["COL_WEEK_NAME"].ToString()) |
| InitSpread_X |  | 608 | DB루프 | AddNumColumn | {?dt.Rows[i]["CALENDAR_DAY"]} | {?dt.Rows[i]["BASIS_YYYYMMDD"]} | for(i < dt.Rows.Count) |
| InitSpread_X |  | 610 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} | {?dt.Rows[i]["BASIS_YYYYMMDD"]} | for(i < dt.Rows.Count) ⟫ if(dt.Rows["0"]["DAYOFWEEK"].ToString() == "SAT") |
| InitSpread_X |  | 612 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} | {?dt.Rows[i]["BASIS_YYYYMMDD"]} | for(i < dt.Rows.Count) ⟫ else!(dt.Rows["0"]["DAYOFWEEK"].ToString() == "SAT") ⟫ if(dt.Rows["0"]["DAYOFWEEK"].ToString() == "SUN") |
| spdMain_CellDoubleClick |  | 1360 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| spdMain_CellDoubleClick |  | 1366 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 1382 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadHeaderSpan |  | 1565 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan |  | 1578 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| SetSpreadColumn |  | 1643 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1648 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1655 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1659 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1664 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1671 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1675 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 1677 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1678 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1679 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1680 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Sales Plan Waterfall | META+코드연결 | 15 (?2) | 18 (?2) | 18 (?2) | 18 (?2) | 18 (?2) | 18 (?2) | 18 (?2) | 16 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:조회데이터 56 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 56건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
