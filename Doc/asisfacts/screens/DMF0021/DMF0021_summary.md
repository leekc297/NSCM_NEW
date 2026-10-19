# DMF0021 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0021_SalesPlan\DMF0021_SalesPlan.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0021_SalesPlan\DMF0021_SalesPlan.csproj | 5644 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0021_SalesPlan\DMF0021_SalesPlan.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0021_SalesPlan\DMF0021_SalesPlan.csproj | 1452 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0021_SalesPlan\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0021_SalesPlan\DMF0021_SalesPlan.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0021_SalesPlan\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0021_SalesPlan\DMF0021_SalesPlan.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0021_SalesPlan\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0021_SalesPlan\DMF0021_SalesPlan.csproj | 27 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\DMF0021_SalesPlan - 복사본.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 3311 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\DMF0021_SalesPlan - 복사본.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1508 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0021_SalesPlan.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 3632 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0021_SalesPlan.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1446 |
| legacy | 06.UIL\GSCM.DM.Shipment.UIL\DMF0021_SalesPlan.cs | 06.UIL\GSCM.DM.Shipment.UIL\GSCM.DM.Shipment.UIL.csproj | 3913 |
| legacy | 06.UIL\GSCM.DM.Shipment.UIL\DMF0021_SalesPlan.Designer.cs | 06.UIL\GSCM.DM.Shipment.UIL\GSCM.DM.Shipment.UIL.csproj | 1408 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 563 | DM.DMF0021_GET_SPREAD_TITLE | MATCH | SP DMF0021_GET_SPREAD_TITLE |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 654 | DM.DMF0021_GET_SPREAD_TITLE | MATCH | SP DMF0021_GET_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 912 | DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx | MATCH | SP DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx |
| button:FindButton | FindButton > FindData | 1552 | DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx | MATCH | SP DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx |
| button:InsertButton | InsertButton > InsertRow | 1679 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 2946 | biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 563 | DM.DMF0021_GET_SPREAD_TITLE | MATCH | SP DMF0021_GET_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 654 | DM.DMF0021_GET_SPREAD_TITLE | MATCH | SP DMF0021_GET_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData | 912 | DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx | MATCH | SP DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx |
| button:SaveButton | SaveButton > SaveData > FindData | 1552 | DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx | MATCH | SP DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx |
| button:SaveButton | SaveButton > SaveData | 1617 | DM_H.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL | MATCH | SP DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL |
| button:SaveButton | SaveButton > SaveData | 2715 | DM.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL | MATCH | SP DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 563 | DM.DMF0021_GET_SPREAD_TITLE | MATCH | SP DMF0021_GET_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 654 | DM.DMF0021_GET_SPREAD_TITLE | MATCH | SP DMF0021_GET_SPREAD_TITLE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 563 | DM.DMF0021_GET_SPREAD_TITLE | MATCH | SP DMF0021_GET_SPREAD_TITLE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 654 | DM.DMF0021_GET_SPREAD_TITLE | MATCH | SP DMF0021_GET_SPREAD_TITLE |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 563 | DM.DMF0021_GET_SPREAD_TITLE | MATCH | SP DMF0021_GET_SPREAD_TITLE |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 654 | DM.DMF0021_GET_SPREAD_TITLE | MATCH | SP DMF0021_GET_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 563 | DM.DMF0021_GET_SPREAD_TITLE | MATCH | SP DMF0021_GET_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 654 | DM.DMF0021_GET_SPREAD_TITLE | MATCH | SP DMF0021_GET_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > GetBizTypebyDivision | 1923 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 3015 | biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 3018 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > GetBizTypebyDivision | 3483 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.clbTeam.SelectedIndexChanged | clbTeam_SelectedIndexChanged | 3163 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.clbTeam.SelectedIndexChanged | clbTeam_SelectedIndexChanged | 3168 | biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 239 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 252 | biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 255 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 306 | biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 309 | biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 525 | biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 528 | biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 563 | DM.DMF0021_GET_SPREAD_TITLE | MATCH | SP DMF0021_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 654 | DM.DMF0021_GET_SPREAD_TITLE | MATCH | SP DMF0021_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1854 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1870 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetItemType | 1882 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls > GetBizTypebyDivision | 1923 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > GetSALESPLAN_MEASUREInfo | 1950 | DM.DMF0021_GET_SALES_PLAN_MEASUREINFO | MATCH | SP DMF0021_GET_SALES_PLAN_MEASUREINFO |
| event:this.Load | Form_Load > InitControls > GetSALESPLAN_MEASUREInfo2 | 1963 | DM.DMF0021_GET_SALES_PLAN_MEASUREINFO2 | MATCH | SP DMF0021_GET_SALES_PLAN_MEASUREINFO2 |
| event:this.Load | Form_Load > InitControls > GetDayRange | 3410 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 3430 | DM.DMF0003_GET_BUCKET_TYPE_CODE | MATCH | SP DMF0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetItemType | 3442 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls > GetBizTypebyDivision | 3483 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > GetSALESPLAN_MEASUREInfo | 3510 | DM.DMF0021_GET_SALES_PLAN_MEASUREINFO | MATCH | SP DMF0021_GET_SALES_PLAN_MEASUREINFO |
| event:this.Load | Form_Load > InitControls > GetSALESPLAN_MEASUREInfo2 | 3523 | DM.DMF0021_GET_SALES_PLAN_MEASUREINFO2 | MATCH | SP DMF0021_GET_SALES_PLAN_MEASUREINFO2 |
| event:this.Load | Form_Load > InitControls > GetCustomsHandbook | 5546 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.Load | Form_Load > InitControls > GetFcstType | 5585 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted | 5633 | biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 2770 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 2841 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 4563 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 4809 | biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetIncotermsType | 5566 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| unreached:(진입점 미연결) | InitSpread_X | 437 | DM_H.DM0021_GET_SPREAD_TITLE_DATE | MATCH | SP DM0021_GET_SPREAD_TITLE_DATE |
| unreached:(진입점 미연결) | SaveData_All | 1261 | DM_H.DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | MATCH | SP DM0021_SAVE_DM_PLN_SALES_PLAN_ALL |
| unreached:(진입점 미연결) | GetDivision | 1824 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetScmSitebyDivision | 1838 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivision | 1896 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivision | 1909 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetEndCustomerbyDivision | 1936 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomer | 2706 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetBizTypebyDivisionAsync | 3078 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivisionAsync | 3092 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivisionAsync | 3105 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomerAsync | 3120 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetScmSitebyDivisionAsync | 3136 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetDivision | 3380 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetScmSitebyDivision | 3394 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivision | 3456 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivision | 3469 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetEndCustomerbyDivision | 3496 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomer | 4499 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetBizTypebyDivisionAsync | 5269 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivisionAsync | 5283 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivisionAsync | 5296 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomerAsync | 5311 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetScmSitebyDivisionAsync | 5327 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetLookupValues | 5604 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_ITEM_SN, UP_FX_GetCommonDataList:SELECT:SCM_ITEM_M_SN, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ITEM_M_SN, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE_ITEM_PRIORITY, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_ITEM_SN, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_LINE_HIERARCHY_V_SN, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 7 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE_ITEM, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GETCOMMONDATALIST_DM:REF:STRING_SPLIT, UP_FX_GETCOMMONDATALIST_DM:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM_H.DM0021_GET_SPREAD_TITLE_DATE | MATCH | 1 | SP DM0021_GET_SPREAD_TITLE_DATE | EXEC:DM0021_GET_SPREAD_TITLE_DATE, SELECT:SCM_SYS_CALENDAR_M |  |
| DM_H.DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | MATCH | 1 | SP DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | EXEC:DM0021_SAVE_DM_PLN_SALES_PLAN_ALL, CREATE:TEMP_SALES_PLAN$, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:TEMP_SALES_PLAN$, SELECT:TEMP_SALES_PLAN$, SELECT:SCM_MST_PROJECT, DELETE:DM_PLN_SALES_PLAN, SELECT:DM_MST_EXCHANGE_RATE, INSERT:DM_PLN_SALES_PLAN, INSERT:DM_PLN_SALES_PLAN_H, INSERT:SCM_SYS_LOG_BATCH |  |
| DM_H.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL | MATCH | 1 | SP DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL | EXEC:DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL, CREATE:#TEMP_SALES_PLAN, CREATE:#TEMP_SALES_PLAN_SALESAMT_LOC, CREATE:#TEMP_SALES_PLAN_RTF_SYS_RP, CREATE:#TMP_DATA_DUP, CREATE:#TEMP_PRICE_RTF_SYS_RP, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TEMP_SALES_PLAN, UPDATE:A, SELECT:#TEMP_SALES_PLAN, SELECT:DM_PLN_SALES_PLAN, REF:FN_NEXT_DAY, INSERT:#TEMP_SALES_PLAN_SALESAMT_LOC, INSERT:#TEMP_SALES_PLAN_RTF_SYS_RP, INSERT:#TMP_FCST_TYPE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:#TEMP_SALES_PLAN_RTF_SYS_RP, SELECT:DM_MST_VERSION, INSERT:#TEMP_DAYINFO, SELECT:#TEMP_DAYINFO, SELECT:NERP_CONV_MASTER, SELECT:SCM_MST_PROJECT, INSERT:#TMP_DATA_DUP, SELECT:#TEMP_SALES_PLAN_SALESAMT_LOC, SELECT:DM_PLN_SALES_ETC_PLAN, SELECT:#TMP_DATA_DUP, SELECT:SCM_MST_SITE_ITEM, SELECT:#TMP_FCST_TYPE, SELECT:DM_PLN_CFM_SELLING_PRICE, INSERT:#TEMP_PRICE_RTF_SYS_RP, SELECT:SCM_MST_FUTURE_PRICE, SELECT:#TEMP_PRICE_RTF_SYS_RP, DELETE:A, SELECT:DM_MST_EXCHANGE_RATE, INSERT:DM_PLN_SALES_ETC_PLAN, INSERT:DM_PLN_SALES_ETC_PLAN_H, INSERT:DM_PLN_SALES_PLAN, INSERT:DM_PLN_SALES_PLAN_H, INSERT:#TEMP_SALES_PLAN_INSERT, DELETE:DM_PLN_CFM_MKT_DEMAND_PLAN, SELECT:#TEMP_SALES_PLAN_INSERT, INSERT:DM_PLN_CFM_MKT_DEMAND_PLAN, DELETE:DM_PLN_MKT_FCST, INSERT:DM_PLN_MKT_FCST, DELETE:DM_PLN_CFM_MKT_DEMAND_PLAN_C, INSERT:DM_PLN_CFM_MKT_DEMAND_PLAN_C, DELETE:DM_PLN_MKT_FCST_C, INSERT:DM_PLN_MKT_FCST_C, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DMF0003_GET_BUCKET_TYPE_CODE | EXEC:DMF0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx | MATCH | 2 | SP DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx | EXEC:DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:TB_FX_USER, SELECT:SCM_MST_TITLESET_USER, INSERT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#TEMP_SCM_MST_SHEET_MEASURE, INSERT:#SELECT_MEASURE, SELECT:#TEMP_SCM_MST_SHEET_MEASURE, SELECT:#SELECT_MEASURE, CREATE:#RAW_DATA, CREATE:#TEMP_SHIPMENT_SITE, INSERT:#RAW_DATA, SELECT:DM_PLN_SALES_PLAN, SELECT:SCM_MST_SITE, SELECT:DM_PLN_SALES_ETC_PLAN, SELECT:DM_PLN_SALES_PLAN_RESULT, SELECT:#RAW_DATA, REF:FN_NEXT_DAY, UPDATE:A, SELECT:SCM_MST_SITE_ITEM, DELETE:#RAW_DATA, SELECT:SCM_MST_COMPANY_SN, INSERT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, SELECT:SCM_MST_ITEM_SN, INSERT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#TEMP_SCM_MST_SITE_ITEM, REF:FN_GET_DM_MKT_OWNER_NAME, SELECT:SCM_MST_SSO_USER_INFO, REF:STRING_SPLIT, DELETE:A, SELECT:SCM_MST_PROJECT, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:#TEMP_SCM_MST_SITE_ITEM, SELECT:DM_PLN_CFM_SELLING_PRICE, SELECT:SCM_MST_FUTURE_PRICE, INSERT:#TEMP_SCM_MST_SITE, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CITY, SELECT:SCM_MST_COUNTRY, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:SCP_PLAN_VERSION_V, INSERT:#TEMP_SHIPMENT_SITE_ROW, SELECT:SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCP_ANL_PROBLEM_REPORT_PEGGING, INSERT:#TEMP_SHIPMENT_SITE, SELECT:#TEMP_SHIPMENT_SITE_ROW, CREATE:#T_COLUMN_SETUP, INSERT:#T_COLUMN_SETUP, INSERT:#T, REF:UF_FX_STRING_SPLIT, SELECT:#T_COLUMN_SETUP, SELECT:#T |  |
| DM.DMF0021_GET_SALES_PLAN_MEASUREINFO | MATCH | 2 | SP DMF0021_GET_SALES_PLAN_MEASUREINFO | EXEC:DMF0021_GET_SALES_PLAN_MEASUREINFO, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0021_GET_SALES_PLAN_MEASUREINFO2 | MATCH | 2 | SP DMF0021_GET_SALES_PLAN_MEASUREINFO2 | EXEC:DMF0021_GET_SALES_PLAN_MEASUREINFO2, SELECT:SCM_MST_SHEET_MEASURE |  |
| DM.DMF0021_GET_SPREAD_TITLE | MATCH | 2 | SP DMF0021_GET_SPREAD_TITLE | EXEC:DMF0021_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL | MATCH | 1 | SP DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL | EXEC:DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL, CREATE:#TEMP_SALES_PLAN, CREATE:#TEMP_SALES_PLAN_SALESAMT_LOC, CREATE:#TEMP_SALES_PLAN_RTF_SYS_RP, CREATE:#TMP_DATA_DUP, CREATE:#TEMP_PRICE_RTF_SYS_RP, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TEMP_SALES_PLAN, UPDATE:A, SELECT:#TEMP_SALES_PLAN, SELECT:DM_PLN_SALES_PLAN, REF:FN_NEXT_DAY, INSERT:#TEMP_SALES_PLAN_SALESAMT_LOC, INSERT:#TEMP_SALES_PLAN_RTF_SYS_RP, INSERT:#TMP_FCST_TYPE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:#TEMP_SALES_PLAN_RTF_SYS_RP, SELECT:DM_MST_VERSION, INSERT:#TEMP_DAYINFO, SELECT:#TEMP_DAYINFO, SELECT:NERP_CONV_MASTER, SELECT:SCM_MST_PROJECT, INSERT:#TMP_DATA_DUP, SELECT:#TEMP_SALES_PLAN_SALESAMT_LOC, SELECT:DM_PLN_SALES_ETC_PLAN, SELECT:#TMP_DATA_DUP, SELECT:SCM_MST_SITE_ITEM, SELECT:#TMP_FCST_TYPE, SELECT:DM_PLN_CFM_SELLING_PRICE, INSERT:#TEMP_PRICE_RTF_SYS_RP, SELECT:SCM_MST_FUTURE_PRICE, SELECT:#TEMP_PRICE_RTF_SYS_RP, DELETE:A, SELECT:DM_MST_EXCHANGE_RATE, INSERT:DM_PLN_SALES_ETC_PLAN, INSERT:DM_PLN_SALES_ETC_PLAN_H, INSERT:DM_PLN_SALES_PLAN, INSERT:DM_PLN_SALES_PLAN_H, INSERT:#TEMP_SALES_PLAN_INSERT, DELETE:DM_PLN_CFM_MKT_DEMAND_PLAN, SELECT:#TEMP_SALES_PLAN_INSERT, INSERT:DM_PLN_CFM_MKT_DEMAND_PLAN, DELETE:DM_PLN_MKT_FCST, INSERT:DM_PLN_MKT_FCST, DELETE:DM_PLN_CFM_MKT_DEMAND_PLAN_C, INSERT:DM_PLN_CFM_MKT_DEMAND_PLAN_C, DELETE:DM_PLN_MKT_FCST_C, INSERT:DM_PLN_MKT_FCST_C, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.PR_GET_DAY_RANGE | MATCH | 2 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| DM.UP_FX_GetCommonDataList_DM | MATCH | 4 | SP UP_FX_GETCOMMONDATALIST_DM | EXEC:UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_PLANT_SN |  |
| SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | 4 | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | EXEC:SCM0001_GET_BIZ_TYPE_BY_DIVISION, SELECT:SCM_MST_PROJECT, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | 6 | SP SCM0001_GET_CUSTOMER_BY_DIVISION | EXEC:SCM0001_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 2 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 2 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | 4 | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | EXEC:SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 4 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | 4 | SP SCM0001_GET_TEAM_BY_DIVISION | EXEC:SCM0001_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| Draw | ds.Tables[0].Columns | SORT_ORDER_NO |
| Draw | ds.Tables[0].Rows[i] | NOTATION |
| Draw | ds.Tables[1].Rows[0] | THIS_YYYYMM, THIS_YYYYMMWW, PRE_YYYYMM, PRE_YYYYMMWW, BASIS_DATE, BASIS_YYYYMM, ISO_WEEK |
| EditButton | UserInfoContext.Current | NowGroupID |
| EditButton | dt.Rows[0] | EDIT_AUTH_SalesAmt_LOC, EDIT_AUTH_RTF_SYS_RP |
| FindData | UserInfoContext.Current | NowGroupID, Dept_ID |
| FindData | ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1] | MEASURE |
| GetFcstType | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitSpread_X | nvc | p_start_yyyymmdd, p_end_yyyymmdd, p_created_by |
| InitSpread_X | dt.Rows[i] | BASIS_YYYYMM, COL_WEEK_NAME, CALENDAR_DAY, BASIS_YYYYMMDD, DAYOFWEEK, WEEK_NAME |
| InitSpread_X | dt.Rows[i - 1] | WEEK_NAME |
| InsertRow | dt.Rows[0] | EDIT_AUTH_SalesAmt_LOC |
| InsertRow | UserInfoContext.Current | NowGroupID |
| SaveData | nvc | p_active_flag, p_DIVISION_ID, p_PROJECT_CODE, p_SCM_SITE_ID, p_PLANT_SITE_ID, p_ITEM_ID, p_DOM_EXP, p_FCST_TYPE, p_INCOTERMS, p_MEASURE, p_YYYYMMDD, p_QTY, p_CURRENCY, p_CREATED_BY, p_LAST_UPDATED_BY |
| SaveData_All | nvc | p_active_flag, p_DIVISION_ID, p_PROJECT_CODE, p_SCM_SITE_ID, p_PLANT_SITE_ID, p_ITEM_ID, p_DOM_EXP, p_FCST_TYPE, p_INCOTERMS, p_MEASURE, p_YYYYMMDD, p_QTY, p_CREATED_BY, p_CREATION_DATE, p_LAST_UPDATED_BY |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |
| spdMain_ComboSelChange | drs[0] | NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:381, SetChangeControl:386, SetChangeControl:392, SetChangeControl:397, SetChangeControl:404, SetChangeControl:410, SetChangeControl:415 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| GetCheckedListValue | InitControls:432, InitControls:441, InitControls:498, EditButton:710, EditButton:711, EditButton:712, EditButton:715, EditButton:721 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:607, InitSpread:406 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:609, InitSpread:408 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:1127, SaveButton:824 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| FP_Log2 | clbDivision_SelectedIndexChanged:5137, clbDivision_SelectedIndexChanged:5234 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| LoadData | btnCutOff_Click:2976 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | EditModeStarting | spdMain_EditModeStarting | InitializeComponent:152 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:153 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:154 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:155 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:156 |
| this.spdMain | EnterCell | spdMain_EnterCell | InitializeComponent:157 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:158 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:159 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:160 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:161 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:162 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:163 |
| this.chkColor | CheckedChanged | chkColor_CheckedChanged | InitializeComponent:281 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:353 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:389 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:426 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:463 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:499 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:568 |
| this.cboBucketType | Click | cboBucketType_Click | InitializeComponent:569 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:763 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:803 |
| this.btnOwner | Click | btnOwner_Click | InitializeComponent:985 |
| this.layoutControlItem3 | Click | btnProject_Click | InitializeComponent:1129 |
| this | Load | DMF0021_SalesPlan_Load | InitializeComponent:1351 |
| this | Load | Form_Load | .ctor:305 |
| this.txtProject | KeyDown | txtProject_KeyDown | DefineProperty:558 |
| this.txtItemId | KeyDown | txtItemId_KeyDown | DefineProperty:559 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | DefineProperty:560 |
| dsdm | Changed | Dsdm_Changed | CreateSpread:589 |
| this.spdMain | EditModeStarting | spdMain_EditModeStarting | InitializeComponent:153 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:154 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:155 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:156 |
| this.spdMain | EnterCell | spdMain_EnterCell | InitializeComponent:157 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:158 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:159 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:160 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:161 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:162 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:163 |
| this.btnCutOff | Click | btnCutOff_Click | InitializeComponent:319 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:355 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:393 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:430 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:467 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:503 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:572 |
| this.cboBucketType | Click | cboBucketType_Click | InitializeComponent:573 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:766 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:806 |
| this.btnOwner | Click | btnOwner_Click | InitializeComponent:988 |
| this.layoutControlItem3 | Click | btnProject_Click | InitializeComponent:1171 |
| this.layoutControlItem7 | Click | btnCutOff_Click | InitializeComponent:1241 |
| this | Load | Form_Load | .ctor:215 |
| this.txtProject | KeyDown | txtProject_KeyDown | DefineProperty:351 |
| this.txtItemId | KeyDown | txtItemId_KeyDown | DefineProperty:352 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | DefineProperty:353 |
| dsdm | Changed | Dsdm_Changed | CreateSpread:382 |

## 6. 컨트롤 (108개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 43 | lblTeam, lblCustomer, lblBizType, lblSalesSite, lblProject, layoutControlItem3, layoutControlItem1, layoutControlItem4, lblPlantSite, layoutControlItem5, layoutControlItem2, lblBucket, Period, lblItemType, lblDivision … |
| UsrCheckedList | 12 | clbSalesSite, clbBizType, clbCustomer, clbTeam, clbPlantSite, clbItemType, clbSalesSite, clbBizType, clbCustomer, clbTeam, clbPlantSite, clbItemType |
| UsrButton | 11 | btnItemId, btnMeasure, btnColumn, btnProject, btnOwner, btnCutOff, btnItemId, btnMeasure, btnColumn, btnProject, btnOwner |
| UsrCheckBox | 8 | chkColor, InternalYN, chkSum, cboCellQty, InternalYN, chkSum, cboUnitYN, cboCellQty |
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
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 4527 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 53 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 400 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 66 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 47 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 680 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 92 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 1501 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (4건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 653 | DM_H.DM0021_GET_SPREAD_TITLE | commented:MATCH |
| 3381 | DM.Get_Division | commented:NOT_IN_FOXQUERY |
| 562 | DM_H.DM0021_GET_SPREAD_TITLE | commented:MATCH |
| 1825 | DM.Get_Division | commented:NOT_IN_FOXQUERY |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0021 | Sales Plan | 12/30 | 14/15 | 14/15 | 14/15 | 14/15 | 14/15 | 14/15 | 12/15 | · | · | · | · | · | · |
| SCM_MST_SHEET_MEASURE | DMF0021 | Sales Plan | 8/14 | 7/12 | 7/12 | 7/12 | 7/12 | 7/12 | 7/12 | 5/10 | · | · | · | · | · | · |
| SCM_MST_SHEET_MEASURE | DMF0021 | Sales Plan Waterfall | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 | 14/3 |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 136건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Sales Plan
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:609, CreateSheetHeaderColumn@InitSpread:408
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| EditButton |  | 855 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | {?ds.Tables[1].Rows[0]["THIS_YYYYMMWW"]} | if(this.fps != null) ⟫ if(cboBucketType.ControlValues == "WEEKLY"\|\| cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetMaxRowIndex() >= 0) ⟫ else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if(int.Parse(sPeriod[0]) > int.Parse(sResult_YYYYMMDD)) |
| EditButton |  | 860 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?sResult_YYYYMMDD.Substring(0, 6)}{?ds.Tables[1].Rows[0]["ISO_WEEK"]} | if(this.fps != null) ⟫ if(cboBucketType.ControlValues == "WEEKLY"\|\| cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetMaxRowIndex() >= 0) ⟫ else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ else!(int.Parse(sPeriod[0]) > int.Parse(sResult_YYYYMMDD)) |
| ExportExcel |  | 1328 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ else!(RemoveActionCell == true && i == 0 && newSheet.Columns[i].DataField.ToUpper() == "ACTION") ⟫ else!(RemoveInvisibleCell && newSheet.Columns[i].Width <= 0) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| ExportExcel |  | 1418 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| Draw |  | 1923 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | {?ds.Tables[1].Rows[0]["THIS_YYYYMMWW"]} | else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0 \|\| siMain.GetColumnIndex(sResult_YYYYMMWW) > 0) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) |
| Draw |  | 1925 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?sResult_YYYYMMDD.Substring(0, 6)}{?ds.Tables[1].Rows[0]["ISO_WEEK"]} | else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0 \|\| siMain.GetColumnIndex(sResult_YYYYMMWW) > 0) ⟫ else!(siMain.GetColumnIndex(this_YYYYMMWW) > 0) |
| Draw |  | 1931 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | D_{?dateTime.ToString("yyyyMMdd")} | else!(chkColor.Checked == true) ⟫ if(chkColor.Checked == false) ⟫ else!(cboBucketType.ControlValues != "DAILY") ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnIndex("D_" + sResult_YYYYMMDD) > 0) |
| cboBucketType_SelectedIndexChanged |  | 3596 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | D_{?dateTime.ToString("yyyyMMdd")} | if(siMain != null) ⟫ if(chkColor.Checked == false) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnIndex("D_" + sResult_YYYYMMDD) > 0) |
| cboBucketType_SelectedIndexChanged |  | 3612 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | {?ds.Tables[1].Rows[0]["THIS_YYYYMMWW"]} | if(siMain != null) ⟫ if(chkColor.Checked == false) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) |
| cboBucketType_SelectedIndexChanged |  | 3614 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?sResult_YYYYMMDD.Substring(0, 6)}{?ds.Tables[1].Rows[0]["ISO_WEEK"]} | if(siMain != null) ⟫ if(chkColor.Checked == false) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ else!(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if(siMain.GetColumnIndex(sResult_YYYYMMWW) > 0) |
| SetSpreadColumn |  | 3641 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 3643 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 3648 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 3650 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 3653 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 3658 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 3660 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 3669 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sResult_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 3670 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sResult_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 3671 | 표시/라벨 변경 | set:Width | Width = 60 |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sResult_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 3678 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(iso_week == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sResult_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 3679 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(iso_week == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sResult_YYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 3686 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(check == false) ⟫ if(siMain.GetColumnTag(iCol).ToString() == this_YYYYMMWW) |
| SetSpreadColumn |  | 3687 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(chkColor.Checked == false) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(check == false) ⟫ if(siMain.GetColumnTag(iCol).ToString() == this_YYYYMMWW) |
| SetSpreadHeaderSpan |  | 3734 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan |  | 3747 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| spdMain_CellDoubleClick |  | 3800 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| spdMain_CellDoubleClick |  | 3807 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(fBucket == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 3813 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ else!(fBucket == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(!siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 3827 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(fBucket == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| InitializeComponent |  | 179 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 180 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 181 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 182 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread_X |  | 458 | DB루프 | AddNumColumn | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | for(i < dt.Rows.Count) ⟫ if("0"== 0) |
| InitSpread_X |  | 470 | DB루프 | AddNumColumn | SUM | W_{?dt.Rows[i]["COL_WEEK_NAME"]} | for(i < dt.Rows.Count) ⟫ if("0"== 0) |
| InitSpread_X |  | 486 | DB루프 | AddNumColumn | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | M_{?dt.Rows[i]["BASIS_YYYYMM"]} | for(i < dt.Rows.Count) ⟫ if(sFYear != dt.Rows["0"]["BASIS_YYYYMM"].ToString()) |
| InitSpread_X |  | 501 | DB루프 | AddNumColumn | SUM | W_{?dt.Rows[i]["COL_WEEK_NAME"]} | for(i < dt.Rows.Count) ⟫ if(sFWeek != dt.Rows["0"]["COL_WEEK_NAME"].ToString()) |
| InitSpread_X |  | 509 | DB루프 | AddNumColumn | {?dt.Rows[i]["CALENDAR_DAY"]} | {?dt.Rows[i]["BASIS_YYYYMMDD"]} | for(i < dt.Rows.Count) |
| InitSpread_X |  | 511 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} | {?dt.Rows[i]["BASIS_YYYYMMDD"]} | for(i < dt.Rows.Count) ⟫ if(dt.Rows["0"]["DAYOFWEEK"].ToString() == "SAT") |
| InitSpread_X |  | 513 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} | {?dt.Rows[i]["BASIS_YYYYMMDD"]} | for(i < dt.Rows.Count) ⟫ else!(dt.Rows["0"]["DAYOFWEEK"].ToString() == "SAT") ⟫ if(dt.Rows["0"]["DAYOFWEEK"].ToString() == "SUN") |
| SetSpreadColumn |  | 2039 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2041 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2046 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 2048 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2051 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 2056 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2058 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadHeaderSpan |  | 2098 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan |  | 2111 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| spdMain_CellDoubleClick |  | 2164 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| spdMain_CellDoubleClick |  | 2169 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 2181 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| InitializeComponent |  | 179 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 180 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 181 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 182 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Sales Plan | META+코드연결 | 14 (?2) | 16 (?2) | 16 (?2) | 16 (?2) | 16 (?2) | 16 (?2) | 16 (?2) | 14 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) | 2 (?2) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:조회데이터 56 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 56건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
