# DM0020 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Plan.UIL\DM0020_SalesFuturePrice.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 2590 |
| only | 06.UIL\GSCM.DM.Plan.UIL\DM0020_SalesFuturePrice.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1098 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0020_OwnerbyDivisionPopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 480 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0020_OwnerbyDivisionPopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 551 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0020_SalesFuturePricePopUp.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 679 |
| only | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0020_SalesFuturePricePopUp.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 465 |
| only | 06.UIL\GSCM.DM.Shipment.UIL\POPUP\DM0020_SalesFuturePricePopUp.cs | 06.UIL\GSCM.DM.Shipment.UIL\GSCM.DM.Shipment.UIL.csproj | 504 |
| only | 06.UIL\GSCM.DM.Shipment.UIL\POPUP\DM0020_SalesFuturePricePopUp.Designer.cs | 06.UIL\GSCM.DM.Shipment.UIL\GSCM.DM.Shipment.UIL.csproj | 436 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData > InitSpread | 172 | DM.DM0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | SP DM0020_GET_EXCHANGE_POPUP_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 283 | DM.DMF0020_GET_OWNER_DATA | MATCH | SP DMF0020_GET_OWNER_DATA |
| button:FindButton | FindButton > FindData | 323 | DM_H.DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP | MATCH | SP DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP |
| button:FindButton | FindButton > FindData | 348 | DM_H.DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA | MATCH | SP DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA |
| button:FindButton | FindButton > FindData > InitSpread > InitSpread_X | 459 | DM_H.DM0020_GET_SPREAD_TITLE_DATE | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > FindData | 680 | DM.DM0020_GET_SCM_MST_FUTURE_PRICE | MATCH | SP DM0020_GET_SCM_MST_FUTURE_PRICE |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 2301 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread | 172 | DM.DM0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | SP DM0020_GET_EXCHANGE_POPUP_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData | 323 | DM_H.DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP | MATCH | SP DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP |
| button:SaveButton | SaveButton > SaveData > FindData | 348 | DM_H.DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA | MATCH | SP DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > InitSpread_X | 459 | DM_H.DM0020_GET_SPREAD_TITLE_DATE | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData | 538 | DM.DM0020_SAVE_DM_MST_EXCHANGE_RATE_ALL | MATCH | SP DM0020_SAVE_DM_MST_EXCHANGE_RATE_ALL |
| button:SaveButton | SaveButton > SaveData > FindData | 680 | DM.DM0020_GET_SCM_MST_FUTURE_PRICE | MATCH | SP DM0020_GET_SCM_MST_FUTURE_PRICE |
| button:SaveButton | SaveButton > SaveData | 1108 | DM_H.DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL | MATCH | SP DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 2301 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnBatch.Click | btnBatch_Click | 2126 | DM_H.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW | NOT_IN_FOXQUERY |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData > InitSpread | 172 | DM.DM0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | SP DM0020_GET_EXCHANGE_POPUP_SPREAD_TITLE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 283 | DM.DMF0020_GET_OWNER_DATA | MATCH | SP DMF0020_GET_OWNER_DATA |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData | 323 | DM_H.DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP | MATCH | SP DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData | 348 | DM_H.DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA | MATCH | SP DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 538 | DM.DM0020_SAVE_DM_MST_EXCHANGE_RATE_ALL | MATCH | SP DM0020_SAVE_DM_MST_EXCHANGE_RATE_ALL |
| event:this.btnExchangeRate.Click | btnExchangeRate_Click > FindData > InitSpread > InitSpread_X | 459 | DM_H.DM0020_GET_SPREAD_TITLE_DATE | NOT_IN_FOXQUERY |  |
| event:this.btnExchangeRate.Click | btnExchangeRate_Click > FindData | 680 | DM.DM0020_GET_SCM_MST_FUTURE_PRICE | MATCH | SP DM0020_GET_SCM_MST_FUTURE_PRICE |
| event:this.btnExchangeRate.Click | btnExchangeRate_Click > FindData > InitSpread > GetSpdTitle | 2301 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > GetDivisionbyScmSite | 431 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.clbDivisions.SelectedIndexChanged | clbDivisions_SelectedIndexChanged > GetBizTypebyDivision | 2398 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls | 118 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 121 | biz:CommonData.CommonDataList [code=Division] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 122 | biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 169 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > InitSpread | 172 | DM.DM0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | SP DM0020_GET_EXCHANGE_POPUP_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls | 179 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 180 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 184 | biz:CommonData.CommonDataList [code=UpperDeptId] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 215 | biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetDayRange | 233 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > FindData | 283 | DM.DMF0020_GET_OWNER_DATA | MATCH | SP DMF0020_GET_OWNER_DATA |
| event:this.Load | Form_Load > FindData | 323 | DM_H.DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP | MATCH | SP DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP |
| event:this.Load | Form_Load > FindData | 348 | DM_H.DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA | MATCH | SP DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 355 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > InitSpread_X | 459 | DM_H.DM0020_GET_SPREAD_TITLE_DATE | NOT_IN_FOXQUERY |  |
| event:this.Load | Form_Load > InitControls > GetLookupValues | 2080 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2301 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetBizTypebyDivision | 2398 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.txtOwner.KeyDown | txtItemID_KeyDown > FindButton > FindData | 283 | DM.DMF0020_GET_OWNER_DATA | MATCH | SP DMF0020_GET_OWNER_DATA |
| unreached:(진입점 미연결) | GetDivision | 417 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivision | 448 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetEndCustomerbyDivision | 462 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetDivision | 2006 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetScmSitebyDivision | 2020 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetScmSiteInfobyDivision | 2036 | SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_INFO_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivision | 2051 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetEndCustomerbyDivision | 2065 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomer | 2094 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetTeambyDivisionAsync | 2320 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivision | 2338 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivisionAsync | 2353 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomerAsync | 2375 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetScmSitebyDivisionAsync | 2412 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=Division] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=UpperDeptId] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO |
| DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DM0000_GET_COMMON_SPREAD_TITLE | EXEC:DM0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS |  |
| DM_H.DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP | MATCH | 1 | SP DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP | EXEC:DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP, SELECT:DM_MST_EXCHANGE_RATE, REF:UF_FX_STRING_SPLITFORIN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SPLIT |  |
| DM_H.DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA | MATCH | 1 | SP DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA | EXEC:DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA, SELECT:DM_MST_EXCHANGE_RATE, REF:UF_FX_STRING_SPLITFORIN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SPLIT |  |
| DM_H.DM0020_GET_SPREAD_TITLE_DATE | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| DM_H.DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL | MATCH | 1 | SP DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL | EXEC:DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_ITEM_SN, DELETE:SCM_MST_FUTURE_PRICE, MERGE:SCM_MST_FUTURE_PRICE, INSERT:SCM_MST_FUTURE_PRICE_H, INSERT:#RESULTS, EXEC:PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE, INSERT:SCM_SYS_LOG_BATCH, SELECT:#RESULTS, DELETE:DM_PLN_SALES_PLAN, REF:FN_NEXT_DAY, SELECT:SCM_MST_SITE_ITEM, SELECT:DM_PLN_SALES_PLAN, INSERT:#SALES_PLAN_TEMP, SELECT:DM_PLN_MKT_FCST, SELECT:SCM_MST_FUTURE_PRICE, SELECT:SCM_SYS_CALENDAR_M, SELECT:DM_PLN_CFM_MKT_DEMAND_PLAN, SELECT:#SALES_PLAN_TEMP, INSERT:DM_PLN_SALES_PLAN, DELETE:DM_PLN_SALES_ETC_PLAN, INSERT:DM_PLN_SALES_ETC_PLAN, SELECT:DM_PLN_SALES_ETC_PLAN |  |
| DM_H.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW | NOT_IN_FOXQUERY | 1 |  |  | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:DM_MST_VERSION, REF:FN_NEXT_DAY, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, CREATE:#T2_PRICE, CREATE:#T2_MKT_FCST, CREATE:#SALES_PLAN_TEMP_LOC, CREATE:#T_RTF_EXCEPTION_ITEM, INSERT:#T_RTF_EXCEPTION_ITEM, SELECT:DM_PLN_SALES_PLAN, SELECT:DM_PLN_CFM_MKT_DEMAND_PLAN, SELECT:#T_RTF_EXCEPTION_ITEM, DELETE:DM_PLN_SALES_PLAN, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_SITE_ITEM, INSERT:#T_PRICE, SELECT:SCM_MST_FUTURE_PRICE, INSERT:#T2_PRICE, SELECT:DM_PLN_CFM_SELLING_PRICE |
| DM.DM0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | MATCH | 1 | SP DM0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | EXEC:DM0020_GET_EXCHANGE_POPUP_SPREAD_TITLE, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DM0020_GET_SCM_MST_FUTURE_PRICE | MATCH | 1 | SP DM0020_GET_SCM_MST_FUTURE_PRICE | EXEC:DM0020_GET_SCM_MST_FUTURE_PRICE, INSERT:#TMPDATA, REF:FN_GET_DEPT_LIST, SELECT:SCM_MST_FUTURE_PRICE, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SHEET_MEASURE, REF:UF_FX_STRING_SPLITFORIN, REF:UF_FX_STRING_SPLIT, INSERT:#TMPOUTPUT, SELECT:#TMPDATA, SELECT:#TMPOUTPUT, EXEC:SP_EXECUTESQL, SELECT:TB_FX_USER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SPLIT |  |
| DM.DM0020_SAVE_DM_MST_EXCHANGE_RATE_ALL | MATCH | 1 | SP DM0020_SAVE_DM_MST_EXCHANGE_RATE_ALL | EXEC:DM0020_SAVE_DM_MST_EXCHANGE_RATE_ALL, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCM_MST_DIVISION, DELETE:DM_MST_EXCHANGE_RATE, MERGE:DM_MST_EXCHANGE_RATE, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DMF0000_GET_COMMON_SPREAD_TITLE | EXEC:DMF0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0020_GET_OWNER_DATA | MATCH | 1 | SP DMF0020_GET_OWNER_DATA | EXEC:DMF0020_GET_OWNER_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPAUTHEXTENTION, REF:UF_FX_STRING_SPLITFORIN, REF:STRING_SPLIT, SELECT:SPLIT |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | EXEC:SCM0001_GET_BIZ_TYPE_BY_DIVISION, SELECT:SCM_MST_PROJECT, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | 4 | SP SCM0001_GET_CUSTOMER_BY_DIVISION | EXEC:SCM0001_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 2 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | 2 | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | EXEC:SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 3 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_SITE_INFO_BY_DIVISION | EXEC:SCM0001_GET_SITE_INFO_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, REF:STRING_SPLIT |  |
| SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | 3 | SP SCM0001_GET_TEAM_BY_DIVISION | EXEC:SCM0001_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbDivisions_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbEndCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| EditButton | dtWeek.Rows[i] | BASIS_START_DATE |
| EditButton | UserInfoContext.Current | NowGroupID |
| FindData | dt.Rows[i] | CURRENCY, UNIT_CURRENCY, YYYYMMDD, EXCHANGE_PRICE, DIVISION_ID |
| FindData | nvc | p_division_id, p_dept_id, p_end_customer, p_scm_site_id, p_project_code, p_item_id, p_plant_site_id, p_customer_project_code, p_customer_model, p_from_yyyymmdd, p_to_yyyymmdd, p_biztype, p_created_by, p_userinfo |
| FindData | UserInfoContext.Current | NowGroupID |
| FindData | ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1] | MEASURE |
| FindData | dtWeek.Rows[i] | BASIS_START_DATE |
| GetCurrencyBySCM_MST_SITE_ITEM | ds.Tables[0].Rows[0] | CURRENCY |
| GetExchangeRate | row[0] | EXCHANGE_PRICE |
| GetExchangeRate | row1[0] | EXCHANGE_PRICE |
| GetExchangeRate | row4[0] | EXCHANGE_PRICE |
| GetExchangeRate | row5[0] | EXCHANGE_PRICE |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitSpread | dt.Rows[i] | CALENDAR_YYYY, CALENDAR_MONTH, BASIS_START_DATE |
| InitSpread_X | dt.Rows[i] | CALENDAR_YYYY, WEEK_NAME, BASIS_START_DATE, CALENDAR_MONTH, BASIS_YYYYMM, DATE_SHORT1_NAME |
| InitSpread_X | nvc | p_start_yyyymmdd, p_end_yyyymmdd, p_created_by |
| InsertRow | UserInfoContext.Current | NowGroupID |
| InsertRow | dtMeasureCount.Rows[i] | LOOKUP_CODE |
| InsertRow | dtWeek.Rows[j] | BASIS_START_DATE |
| SaveButton | UserInfoContext.Current | NowGroupID |
| SaveData | dr | ACTION, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS |
| SaveData | nvc | p_active_flag, p_DIVISION_ID, p_PROJECT_CODE, p_SCM_SITE_ID, p_PLANT_SITE_ID, p_ITEM_ID, p_YYYYMMDD, p_CURRENCY, p_MEASURE, p_DOM_EXP, p_FCST_TYPE, p_INCOTERMS, p_PRICE, p_CREATED_BY, p_CREATION_DATE, p_LAST_UPDATED_BY, p_division_id, p_UNIT_CURRENCY, p_EXCHANGE_PRICE |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SaveData | SaveButton:303, btnButtonList_UsrButtonList_Click_Detected:482, SaveButton:601, SaveButton:294, btnButtonList_UsrButtonList_Click_Detected:651 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetCheckedListValue | InitControls:182, InitControls:189, InitControls:195, FindData:636, usrButton1_Click:1304, btnModelType_Click:1321, clbDivisions_SelectedIndexChanged:1370, clbDivisions_SelectedIndexChanged:1375 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:402, InitSpread:228 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:403, InitSpread:229 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| LoadData | btnExchangeRate_Click:1287 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:267 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:345 |
| this | Load | Form_Load | .ctor:73 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:132 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:133 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:134 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:135 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:136 |
| this.btnBatch | Click | btnBatch_Click | InitializeComponent:248 |
| this.btnExchangeRate | Click | btnExchangeRate_Click | InitializeComponent:285 |
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:321 |
| this.btnItemId | Click | btnModelType_Click | InitializeComponent:391 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:545 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:585 |
| this.clbDivisions | SelectedIndexChanged | clbDivisions_SelectedIndexChanged | InitializeComponent:625 |
| this.btnSetPrice | Click | btnSetPrice_Click | InitializeComponent:740 |
| this.backgroundWorker1 | DoWork | backgroundWorker1_DoWork | InitializeComponent:995 |
| this.backgroundWorker1 | ProgressChanged | backgroundWorker1_ProgressChanged | InitializeComponent:996 |
| this.backgroundWorker1 | RunWorkerCompleted | backgroundWorker1_RunWorkerCompleted | InitializeComponent:997 |
| this | Resize | DM0020_SalesFuturePrice_Resize | InitializeComponent:1015 |
| this | Load | Form_Load | .ctor:145 |
| this.umltProject | KeyDown | umltProject_KeyDown | DefineProperty:281 |
| this.umltModel | KeyDown | umltModel_KeyDown | DefineProperty:282 |
| dsdm | Changed | Dsdm_Changed | InitEvent:379 |
| this.txtOwner | KeyDown | txtItemID_KeyDown | InitializeComponent:126 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:166 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:260 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:452 |
| this | Load | Form_Load | .ctor:124 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:238 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:369 |
| this | Load | Form_Load | .ctor:84 |

## 6. 컨트롤 (96개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 27 | layoutControlItem2, layoutControlItem1, layoutControlItem3, lblDivision, layoutControlItem1, lblCustomer, Period, lblSalesSite, layoutControlItem4, lblModel, lblProject, layoutControlItem6, lblPlantSite, lblBizType, layoutControlItem7 … |
| UsrCheckedList | 11 | clbSalesSite, clbEndCustomer, clbTeam, clbDivisions, clbPlantSite, clbBizType, clbDivision, clbScmSite, clbTeam, clbEndCustomer, clbDivisions |
| EmptySpaceItem | 9 | emptySpaceItem1, emptySpaceItem3, emptySpaceItem3, emptySpaceItem1, emptySpaceItem2, emptySpaceItem2, emptySpaceItem1, emptySpaceItem1, emptySpaceItem3 |
| UsrLayoutControl | 8 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl3, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 8 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup3, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 5 | btnBatch, btnExchangeRate, usrButton1, btnItemId, btnSetPrice |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel2, usrConditionPanel1, usrConditionPanel1 |
| UsrMonthPicker | 4 | usrMonthTo, usrMonthFrom, usrMonthTo, usrMonthFrom |
| FpSpread | 4 | spdMain, spdMain, spdMain, spdMain |
| SheetView | 4 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrButtonList | 3 | btnButtonList, btnButtonList, btnButtonList |
| UsrMultiLineEditor | 2 | umltProject, umltModel |
| UsrDateRangePicker | 1 | drpDateTime |
| Panel | 1 | panel1 |
| Label | 1 | lblProgress |
| ProgressBar | 1 | progressBar1 |
| BackgroundWorker | 1 | backgroundWorker1 |
| ImageList | 1 | imageList1 |
| TextBox | 1 | txtOwner |

## 7. 확인 필요 (2건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 2126 | btnBatch_Click | DM_H.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW | NOT_IN_FOXQUERY | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:DM_MST_VERSION, REF:FN_NEXT_DAY, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, CREATE:#T2_PRICE, CREATE:#T2_MKT_FCST, CREATE:#SALES_PLAN_TEMP_LOC, CREATE:#T_RTF_EXCEPTION_ITEM, INSERT:#T_RTF_EXCEPTION_ITEM, SELECT:DM_PLN_SALES_PLAN, SELECT:DM_PLN_CFM_MKT_DEMAND_PLAN, SELECT:#T_RTF_EXCEPTION_ITEM, DELETE:DM_PLN_SALES_PLAN, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_SITE_ITEM, INSERT:#T_PRICE, SELECT:SCM_MST_FUTURE_PRICE, INSERT:#T2_PRICE, SELECT:DM_PLN_CFM_SELLING_PRICE · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 459 | InitSpread_X | DM_H.DM0020_GET_SPREAD_TITLE_DATE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 31 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_H | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 20 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (4건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 2007 | DM.Get_Division | commented:NOT_IN_FOXQUERY |
| 2125 | DM_H.DM0021_GET_DM_PLN_SALES_PLAN | commented:MATCH |
| 354 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | commented:MATCH |
| 418 | DM.Get_Division | commented:NOT_IN_FOXQUERY |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DM0020 | Sales Price | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 56건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Sales Price PopUp, Sales Price, Owner Popup
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:403, CreateSheetHeaderColumn@InitSpread:229

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread_X |  | 474 | DB루프 | AddNumColumn | {?dt.Rows[i]["DATE_SHORT1_NAME"]} | {?dt.Rows[i]["BASIS_START_DATE"]} | for(i < dt.Rows.Count) |
| DTJoin |  | 2516 | 표시/라벨 변경 | set:ColumnName | ColumnName = {?col.ColumnName + "_2"} |  | for(colIdx < right.Columns.Count) ⟫ if(dt.Columns[col.ColumnName] != null) ⟫ else!(!blnNoKeyOverlap) |
| InitializeComponent |  | 152 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 153 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 154 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 155 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 468 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 469 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 470 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 471 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 148 | 하드코딩 | AddComboColumn | Division | DIVISION_ID |  |
| InitSpread |  | 149 | 하드코딩 | AddTextColumn | Currency | CURRENCY |  |
| InitSpread |  | 151 | 하드코딩 | AddComboColumn | Unit | UNIT_CURRENCY |  |
| InitSpread |  | 152 | 하드코딩 | AddTextColumn | Currency | CURRENCY_UNITCURRENCY |  |
| InitSpread |  | 189 | DB루프 | AddNumColumn | {?dt.Rows[i]["CALENDAR_MONTH"]} | D{?dt.Rows[i]["BASIS_START_DATE"]} | for(i < dt.Rows.Count) |
| InitializeComponent |  | 385 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 386 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 387 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 388 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread_X |  | 129 | 하드코딩 | AddTextColumn | Currency | CURRENCY |  |
| InitSpread_X |  | 156 | DB루프 | AddNumColumn | {?dt.Rows[i]["WEEK_NAME"]} | {?dt.Rows[i]["BASIS_START_DATE"]} | for(i < dt.Rows.Count) |
| InitSpread |  | 201 | 하드코딩 | AddTextColumn | CURRENCY | CURRENCY |  |
| InitSpread |  | 202 | 하드코딩 | AddTextColumn | UNIT_CURRENCY | UNIT_CURRENCY |  |
| InitSpread |  | 203 | 하드코딩 | AddTextColumn | CURRENCY | CURRENCY_UNITCURRENCY |  |
| InitSpread |  | 229 | DB루프 | AddNumColumn | {?dt.Rows[i]["CALENDAR_MONTH"]} | D{?dt.Rows[i]["BASIS_START_DATE"]} | for(i < dt.Rows.Count) |
| InitializeComponent |  | 361 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 362 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 363 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 364 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Sales Price | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |
| Sales Price PopUp | 코드 하드코딩 전용(메타 없음) | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
