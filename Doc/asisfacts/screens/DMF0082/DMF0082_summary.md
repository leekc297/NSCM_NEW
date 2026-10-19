# DMF0082 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0082_FcstNPrice_Mgmt\DMF0082_FcstNPrice_Mgmt.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0082_FcstNPrice_Mgmt\DMF0082_FcstNPrice_Mgmt.csproj | 9419 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0082_FcstNPrice_Mgmt\DMF0082_FcstNPrice_Mgmt.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0082_FcstNPrice_Mgmt\DMF0082_FcstNPrice_Mgmt.csproj | 1300 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0082_FcstNPrice_Mgmt\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0082_FcstNPrice_Mgmt\DMF0082_FcstNPrice_Mgmt.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0082_FcstNPrice_Mgmt\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0082_FcstNPrice_Mgmt\DMF0082_FcstNPrice_Mgmt.csproj | 72 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0082_FcstNPrice_Mgmt\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0082_FcstNPrice_Mgmt\DMF0082_FcstNPrice_Mgmt.csproj | 31 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0082_SaveSalesFuturePrice_Popup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 2827 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0082_SaveSalesFuturePrice_Popup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 897 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:dsdm.Changed | spdMain_Changed | 5628 | biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 5639 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:dsdm.Changed | spdMain_Changed | 5841 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:dsdm.Changed | spdMain_Changed | 5855 | biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 5864 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:dsdm.Changed | spdMain_Changed > GetLookupValues | 8719 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 438 | DM.DMF0082_GET_SPREAD_TITLE | MATCH | SP DMF0082_GET_SPREAD_TITLE |
| button:FindButton | FindButton > FindData > GetFuturePriceInfo | 486 | DM.DMF0082_POPUP_GET_FUTUREPRICE_INFO | MATCH | SP DMF0082_POPUP_GET_FUTUREPRICE_INFO |
| button:FindButton | FindButton > FindData | 1250 | DM.DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP | MATCH | SP DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP |
| button:FindButton | FindButton > FindData | 1315 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:FindButton | FindButton > FindData | 1723 | DM.DMF0082_GET_MAIN_DATA | MATCH | SP DMF0082_GET_MAIN_DATA |
| button:FindButton | FindButton > FindData | 1773 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > GetLookupValues | 2683 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 2706 | DM.DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE | MATCH | SP DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE |
| button:FindButton | FindButton > FindData > GetLookupValues | 2813 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:FindButton | FindButton > FindData > GetFcstType | 8659 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:FindButton | FindButton > FindData > GetCustomsHandbook | 8699 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:InsertButton | InsertButton > InsertRow | 2528 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:InsertButton | InsertButton > InsertRow | 2579 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 2616 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:InsertButton | InsertButton > InsertRow | 2621 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:InsertButton | InsertButton > InsertRow | 2625 | biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 2629 | biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow > GetLookupValues | 8719 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 438 | DM.DMF0082_GET_SPREAD_TITLE | MATCH | SP DMF0082_GET_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData > GetFuturePriceInfo | 486 | DM.DMF0082_POPUP_GET_FUTUREPRICE_INFO | MATCH | SP DMF0082_POPUP_GET_FUTUREPRICE_INFO |
| button:SaveButton | SaveButton > SaveData > FindData | 1250 | DM.DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP | MATCH | SP DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP |
| button:SaveButton | SaveButton > SaveData > FindData | 1315 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:SaveButton | SaveButton > SaveData > FindData | 1723 | DM.DMF0082_GET_MAIN_DATA | MATCH | SP DMF0082_GET_MAIN_DATA |
| button:SaveButton | SaveButton > SaveData > FindData | 1773 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1986 | DM.DMF0082_SAVE_MAIN_DATA | MATCH | SP DMF0082_SAVE_MAIN_DATA |
| button:SaveButton | SaveButton > SaveData | 2145 | DM.DMF0082_SAVE_MAIN_DATA | MATCH | SP DMF0082_SAVE_MAIN_DATA |
| button:SaveButton | SaveButton > SaveData > FindData > GetLookupValues | 2683 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 2706 | DM.DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE | MATCH | SP DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE |
| button:SaveButton | SaveButton > SaveData > GetSaveDateFromTo | 2731 | DM.DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE | MATCH | SP DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE |
| button:SaveButton | SaveButton > SaveData > FindData > GetLookupValues | 2813 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:SaveButton | SaveButton > SaveData > FindData > GetFcstType | 8659 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:SaveButton | SaveButton > SaveData > FindData > GetCustomsHandbook | 8699 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > SaveData > FindData > GetFuturePriceInfo | 486 | DM.DMF0082_POPUP_GET_FUTUREPRICE_INFO | MATCH | SP DMF0082_POPUP_GET_FUTUREPRICE_INFO |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > SaveData > FindData | 1250 | DM.DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP | MATCH | SP DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > SaveData > FindData | 1315 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > SaveData | 1986 | DM.DMF0082_SAVE_MAIN_DATA | MATCH | SP DMF0082_SAVE_MAIN_DATA |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > SaveData > FindData > GetLookupValues | 2683 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 2706 | DM.DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE | MATCH | SP DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > SaveData > GetSaveDateFromTo | 2731 | DM.DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE | MATCH | SP DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > SaveData > FindData > GetLookupValues | 2813 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 438 | DM.DMF0082_GET_SPREAD_TITLE | MATCH | SP DMF0082_GET_SPREAD_TITLE |
| event:this.btnExchangeRate.Click | btnExchangeRate_Click > FindData > InitSpread > GetSpdTitle | 438 | DM.DMF0082_GET_SPREAD_TITLE | MATCH | SP DMF0082_GET_SPREAD_TITLE |
| event:this.btnExchangeRate.Click | btnExchangeRate_Click > FindData | 1723 | DM.DMF0082_GET_MAIN_DATA | MATCH | SP DMF0082_GET_MAIN_DATA |
| event:this.btnExchangeRate.Click | btnExchangeRate_Click > FindData | 1773 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| event:this.btnExchangeRate.Click | btnExchangeRate_Click > GetFuturePriceInfo | 3166 | DM.DMF0082_POPUP_GET_FUTUREPRICE_INFO | MATCH | SP DMF0082_POPUP_GET_FUTUREPRICE_INFO |
| event:this.btnExchangeRate.Click | btnExchangeRate_Click > FindData > GetFcstType | 8659 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.btnExchangeRate.Click | btnExchangeRate_Click > FindData > GetCustomsHandbook | 8699 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 438 | DM.DMF0082_GET_SPREAD_TITLE | MATCH | SP DMF0082_GET_SPREAD_TITLE |
| event:this.clbCustomer.SelectedIndexChanged | clbCustomer_SelectedIndexChanged > GetSalesSite | 3186 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.clbCustomer.SelectedIndexChanged | clbCustomer_SelectedIndexChanged > GetSalesSite40 | 3208 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.clbDivisions.SelectedIndexChanged | clbDivisions_SelectedIndexChanged > InitSpread > GetSpdTitle | 2706 | DM.DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE | MATCH | SP DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE |
| event:this.Load | Form_Load > InitControls | 243 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 253 | biz:CommonData.CommonDataList [code=UpperDeptId] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetDayRange | 377 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 438 | DM.DMF0082_GET_SPREAD_TITLE | MATCH | SP DMF0082_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetWeekData | 439 | DM.DMF0082_POPUP_GET_WEEKDATA | MATCH | SP DMF0082_POPUP_GET_WEEKDATA |
| event:this.Load | Form_Load > InitControls > GetMeasureCountInfo | 461 | DM.DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE | MATCH | SP DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE |
| event:this.Load | Form_Load > InitControls > GetMeasureCountInfo | 469 | DM.DMF0082_POPUP_GET_MEASURE_COUNTINFO | MATCH | SP DMF0082_POPUP_GET_MEASURE_COUNTINFO |
| event:this.Load | Form_Load > InitControls > GetFuturePriceInfo | 486 | DM.DMF0082_POPUP_GET_FUTUREPRICE_INFO | MATCH | SP DMF0082_POPUP_GET_FUTUREPRICE_INFO |
| event:this.Load | Form_Load > InitControls > GetLookupValues | 2683 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2706 | DM.DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE | MATCH | SP DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE |
| event:this.Load | Form_Load > InitControls > GetLookupValues | 2813 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.Load | Form_Load > InitControls > GetDayRange | 3103 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > InitControls > GetFuturePriceInfo | 3166 | DM.DMF0082_POPUP_GET_FUTUREPRICE_INFO | MATCH | SP DMF0082_POPUP_GET_FUTUREPRICE_INFO |
| event:this.Load | Form_Load > InitControls > GetBucketType | 3230 | DM.DMF0003_GET_BUCKET_TYPE_CODE | MATCH | SP DMF0003_GET_BUCKET_TYPE_CODE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick | 3658 | DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP | MATCH | SP DMF0003_GET_MKT_FCST_COMPARE_POPUP |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick | 3828 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > GetLookupValues | 8719 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted | 7922 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted | 7979 | biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | BIZ_MATCH |  |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted | 8001 | biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | BIZ_MATCH |  |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted | 8027 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted > GetIncotermsType | 8681 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted > GetLookupValues | 8719 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetBizTypebyDivision | 3086 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 8230 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 8261 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 8277 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 8308 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 8312 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 8332 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetLookupValues | 8719 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| unreached:(진입점 미연결) | Dsdm_Changed | 2549 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Dsdm_Changed | 2558 | biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_ITEM_SN, UP_FX_GetCommonDataList:SELECT:SCM_ITEM_M_SN, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ITEM_M_SN, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE_ITEM_PRIORITY, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_ITEM_SN, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_LINE_HIERARCHY_V_SN, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=CURRENCY_LIST] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SalesPlant] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PROJECT_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_ITEM_SN |
| biz:CommonData.CommonDataList [code=UpperDeptId] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO |
| DM.DMF0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DMF0003_GET_BUCKET_TYPE_CODE | EXEC:DMF0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP | MATCH | 1 | SP DMF0003_GET_MKT_FCST_COMPARE_POPUP | EXEC:DMF0003_GET_MKT_FCST_COMPARE_POPUP, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#TEMP_DM_SSP, SELECT:DM_PLN_MKT_FCST, REF:FN_SPLITSTRING, SELECT:#TEMP_DM_SSP, SELECT:DM_PLN_MKT_FCST_CONFIRM, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.DMF0082_GET_MAIN_DATA | MATCH | 1 | SP DMF0082_GET_MAIN_DATA | EXEC:DMF0082_GET_MAIN_DATA, SELECT:SCM_MST_TITLESET_USER, INSERT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, CREATE:#T_VERSION, INSERT:#T_VERSION, REF:FN_NEXT_DAY, SELECT:DM_MST_VERSION, REF:STRING_SPLIT, SELECT:SCP_PLN_INTERFACE_YN, CREATE:#TEMPSITEITEMALL, INSERT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, SELECT:SCM_ITEM_M_SN, INSERT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#TEMPSITEITEMALL, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SITE_ITEM, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_SITE, SELECT:SCM_MST_CITY, SELECT:SCM_MST_COUNTRY, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#TEMPSITEITEM, SELECT:#TEMPSITEITEMALL, SELECT:TB_FX_USER, REF:FN_MULTY_TIME, CREATE:#TEMPSELECTMEASURE, INSERT:#TEMPSELECTMEASURE, SELECT:#TEMPSELECTMEASURE, CREATE:#T_LAST_DATA_SETUP_FCST, CREATE:#T_LAST_DATA_SETUP_PRICE, CREATE:#T_LAST_DATA_SETUP_FCST_C, CREATE:#T_LAST_DATA_SETUP_PRICE_C, INSERT:#T_LAST_DATA_SETUP_FCST, SELECT:DM_PLN_CFM_MKT_DEMAND_PLAN, INSERT:#T_LAST_DATA_SETUP_PRICE, SELECT:DM_PLN_CFM_SELLING_PRICE, INSERT:#T_LAST_DATA_SETUP_FCST_C, SELECT:DM_PLN_CFM_MKT_DEMAND_PLAN_C, SELECT:#T_VERSION, INSERT:#T_LAST_DATA_SETUP_PRICE_C, SELECT:DM_PLN_CFM_SELLING_PRICE_C, CREATE:#T_WS_FCST, INSERT:#T_WS_FCST, CREATE:#TEMPFCSTNPRICE, INSERT:#TEMPFCSTNPRICE, SELECT:#T_LAST_DATA_SETUP_FCST, SELECT:#TEMPSITEITEM, SELECT:#T_WS_FCST, SELECT:#T_LAST_DATA_SETUP_PRICE, SELECT:DM_PLN_SALES_PLAN_RESULT, UPDATE:A |  |
| DM.DMF0082_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0082_GET_SPREAD_TITLE | EXEC:DMF0082_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DMF0082_POPUP_GET_FUTUREPRICE_INFO | MATCH | 2 | SP DMF0082_POPUP_GET_FUTUREPRICE_INFO | EXEC:DMF0082_POPUP_GET_FUTUREPRICE_INFO, SELECT:DM_MST_EXCHANGE_RATE |  |
| DM.DMF0082_POPUP_GET_MEASURE_COUNTINFO | MATCH | 1 | SP DMF0082_POPUP_GET_MEASURE_COUNTINFO | EXEC:DMF0082_POPUP_GET_MEASURE_COUNTINFO, SELECT:SCM_MST_SHEET_MEASURE |  |
| DM.DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE | MATCH | 1 | SP DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE | EXEC:DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE, SELECT:SCM_MST_SHEET_MEASURE |  |
| DM.DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP | MATCH | 1 | SP DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP | EXEC:DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#TMPOVERRANGE, SELECT:DM_PLN_CFM_SELLING_PRICE, INSERT:#TMPOVERRANGELIST, SELECT:#TMPOVERRANGE, INSERT:#TMPITEM, SELECT:DM_MST_ITEM_SINGLE_V, INSERT:#TMPPLANDATA, REF:UF_FX_STRING_SPLITFORIN, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SITE_ITEM, INSERT:#TMPDATA, REF:FN_GET_DEPT_LIST, SELECT:#TMPPLANDATA, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:#TMPITEM, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SSO_USER_INFO, REF:STRING_SPLIT, REF:FN_GET_MULTI_OWNER_NAME, CREATE:#TMPOUTPUT, INSERT:#TMPOUTPUT, SELECT:#TMPDATA, SELECT:#TMPOVERRANGELIST, SELECT:SCM_MST_SHEET_MEASURE, SELECT:#TMPOUTPUT, INSERT:#TMPSALESSITEMODELALL, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, SELECT:DM_MST_CUSTOMER_MODEL, INSERT:#TMPSALESSITEMODEL, SELECT:#TMPSALESSITEMODELALL, EXEC:SP_EXECUTESQL, SELECT:SPLIT, SELECT:TB_FX_USER |  |
| DM.DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE | MATCH | 2 | SP DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE | EXEC:DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DMF0082_POPUP_GET_WEEKDATA | MATCH | 1 | SP DMF0082_POPUP_GET_WEEKDATA | EXEC:DMF0082_POPUP_GET_WEEKDATA, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DMF0082_SAVE_MAIN_DATA | MATCH | 2 | SP DMF0082_SAVE_MAIN_DATA | EXEC:DMF0082_SAVE_MAIN_DATA, EXEC:PR_DM_SYS_LOG_BATCH, CREATE:#T_MAIN, CREATE:#T_PRICE, CREATE:#T_FCST, CREATE:#TEMP_EXCEPTION_BIZ_TYPE, CREATE:#TEMP_EXCEPTION_ITEM_LIST, INSERT:#T_MAIN, SELECT:#T_MAIN, INSERT:#TEMP_DAYINFO, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:#TEMP_DAYINFO, REF:FN_NEXT_DAY, INSERT:#T_PRICE, SELECT:DM_PLN_CFM_SELLING_PRICE, INSERT:#T_FCST, SELECT:DM_PLN_CFM_MKT_DEMAND_PLAN, UPDATE:A, SELECT:SCM_MST_SITE, SELECT:NERP_CONV_MASTER, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_ITEM_SN, INSERT:#TEMP_EXCEPTION_BIZ_TYPE, SELECT:#TEMP_EXCEPTION_BIZ_TYPE, INSERT:#TEMP_EXCEPTION_ITEM_LIST, SELECT:SCM_ITEM_M_SN, SELECT:#TEMP_EXCEPTION_ITEM_LIST, SELECT:#T_FCST, INSERT:#MSHYCHU1, INSERT:#MSHYCHU2, SELECT:#T_PRICE, SELECT:#MSHYCHU1, SELECT:#MSHYCHU2, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_BOM_ENG_SN, SELECT:SCP_MST_BOD_V, SELECT:SCM_MST_SITE_CUSTOMER, DELETE:DM_PLN_CFM_MKT_DEMAND_PLAN, INSERT:DM_PLN_CFM_MKT_DEMAND_PLAN, UPDATE:#T_MAIN, INSERT:#TEMP_EXCH, SELECT:DM_MST_EXCHANGE_RATE, SELECT:#TEMP_EXCH, MERGE:DM_PLN_CFM_SELLING_PRICE, MERGE:DM_PLN_CFM_MKT_DEMAND_PLAN, INSERT:DM_PLN_CFM_SELLING_PRICE_H, INSERT:DM_PLN_CFM_MKT_DEMAND_PLAN_H, EXEC:PR_DM_PLN_CFM_TO_MKT_FCST, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_SCM_SYS_LOG_BATCH, CREATE:#SEND_TARGET_DATA, CREATE:#RESULTS, INSERT:#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN, DELETE:A, SELECT:DM_PLN_MKT_FCST, SELECT:#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN, INSERT:DM_PLN_MKT_FCST, INSERT:#TEMP_DM_PLN_CFM_SELLING_PRICE, SELECT:SCM_MST_FUTURE_PRICE |  |
| DM.PR_GET_DAY_RANGE | MATCH | 2 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| DM.UP_FX_GetCommonDataList_DM | MATCH | 21 | SP UP_FX_GETCOMMONDATALIST_DM | EXEC:UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_PLANT_SN |  |
| SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | EXEC:SCM0001_GET_BIZ_TYPE_BY_DIVISION, SELECT:SCM_MST_PROJECT, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbDivisions_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| Draw | ds.Tables[1].Rows[0] | ISO_WEEK |
| Draw | ds.Tables[2].Rows[0] | THIS_YYYYMMWW, ISO_WEEK |
| Draw | ds.Tables[0].Columns | SORT_ORDER_NO |
| Draw | ds.Tables[0].Rows[i] | NOTATION, MEASURE |
| EditButton | dtWeek.Rows[j] | BASIS_START_DATE |
| FindData | UserInfoContext.Current | NowGroupID |
| FindData | ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1] | MEASURE |
| GetExchangeRate | row[0] | EXCHANGE_PRICE |
| GetExchangeRate | row1[0] | EXCHANGE_PRICE |
| GetExchangeRate | row4[0] | EXCHANGE_PRICE |
| GetExchangeRate | row5[0] | EXCHANGE_PRICE |
| GetFcstType | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitControls | Filter | DIVISION_ID |
| InsertRow | UserInfoContext.Current | NowGroupID |
| SaveData | response.DataSet.Tables[0].Rows[0] | RESULT_CODE, RESULT_CNT, ERR_MESSAGE, RESULT_MSG |
| SaveData | nvc | p_active_flag, p_division_id, p_project_code, p_end_customer, p_scm_site_id, p_item_id, p_dom_exp, p_fcst_type, p_incoterms, p_measure, p_plant_site_id, p_cell_prod_site_id, p_yyyymmdd, p_currency, p_qty, p_created_by |
| SaveData | ds.Tables[0].Rows[0] | RESULT_CODE, RESULT_CNT, ERR_MESSAGE, RESULT_MSG |
| SaveData | ds.Tables[1].Rows[0] | TITLE |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| SetEditList | dtWeek.Rows[0] | MONTH_NAME |
| SetEditList | r | MEASURE, EDIT_FLAG |
| SetSaveData | drNew | Action |
| SetSpreadColumn | dt.Rows[i] | YER, MON, BASIS_START_DATE2, MMDD, BASIS_START_DATE, BASIS_YYYYMM, WEEK_NAME |
| SetSpreadColumn | dt.Rows[i - 1] | BASIS_YYYYMM |
| spdMain_Changed | UserInfoContext.Current | NowGroupID |
| spdMain_Changed | dtSalesBucket.Rows[0] | BUCKET |
| spdMain_Changed | drFind[0] | MONTH_DAY_CNT, WEEK_DAY_CNT |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |
| spdMain_ComboSelChange | dtSalesBucket.Rows[0] | BUCKET |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| OnShown | OnShown:324 | BaseForm.OnShown | NowGroupID, USER_ID |
| GetCheckedListValue | OnShown:326, InitControls:346, InitControls:351, FindData:1669, FindData:1670, Draw:1795, Draw:1796, clbTeam_SelectedIndexChanged:3045 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:420, InitSpread:543 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:421, InitSpread:544 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:1614, SaveButton:1146 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| LoadData | btnExchangeRate_Click:3143, btnSavePricePeriod_Click:3474, spdMain_CellDoubleClick:3698, SaveData:2037 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |
| GetDMInnerTable | SetChangeControl:8745, SetChangeControl:8749, SetChangeControl:8754, SetChangeControl:8758, SetChangeControl:8764, SetChangeControl:8769, SetChangeControl:8772, SetChangeControl:8775 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:209 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:283 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:321 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:358 |
| this.cboBucketType | Click | cboBucketType_Click | InitializeComponent:359 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:519 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:559 |
| this.clbDivision | Click | clbDivision_SelectedIndexChanged | InitializeComponent:594 |
| this.btnSavePricePeriod | Click | btnSavePricePeriod_Click | InitializeComponent:666 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:736 |
| this.btnVersion | Click | btnVersion_Click | InitializeComponent:773 |
| this.btnVersion | KeyDown | txtVersion_KeyDown | InitializeComponent:774 |
| this.btnExchangeRate | Click | btnExchangeRate_Click | InitializeComponent:811 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:1142 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:1143 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1144 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1145 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:1146 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:1147 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:1148 |
| this | Load | Form_Load | .ctor:308 |
| dsdm | Changed | spdMain_Changed | DefineProperty:412 |
| this.spdMain | KeyUp | base.BaseForm_KeyUp | DefineProperty:415 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | cboBucketType_SelectedIndexChanged:3264 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | cboBucketType_SelectedIndexChanged:3274 |
| dsdm | Changed | spdMain_Changed | spdMain_Changed:5547 |
| dsdm | Changed | spdMain_Changed | spdMain_Changed:7624 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:186 |
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:222 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:324 |
| this.drpDateTime | ValueChanged | drpDateTime_ValueChange | InitializeComponent:406 |
| this | Load | Form_Load | .ctor:173 |
| this.umltProject | KeyDown | umltProject_KeyDown | DefineProperty:410 |
| this.clbDivisions | SelectedIndexChanged | clbDivisions_SelectedIndexChanged | DefineProperty:412 |

## 6. 컨트롤 (83개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 26 | lblTeam, lblCustomer, lblBizType, lblSalesSite, lblBucket, lblDivion, Period, lblVersion, lblModel, layoutControlItem1, layoutControlItem11, layoutControlItem7, layoutControlItem5, layoutControlItem4, item1 … |
| EmptySpaceItem | 13 | emptySpaceItem2, emptySpaceItem3, emptySpaceItem7, emptySpaceItem1, emptySpaceItem4, emptySpaceItem5, emptySpaceItem5, emptySpaceItem3, emptySpaceItem2, emptySpaceItem1, emptySpaceItem4, emptySpaceItem6, emptySpaceItem7 |
| UsrButton | 8 | btnMeasure, btnColumn, btnSavePricePeriod, btnItemId, btnVersion, btnExchangeRate, usrButton2, usrButton1 |
| UsrCheckedList | 6 | clbSalesSite, clbBizType, clbCustomer, clbTeam, clbSalesSite, clbCustomer |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrMultiLineEditor | 4 | txtVersion, txtItemId, umltProject, umltItem |
| UsrCombo | 3 | cboBucketType, clbDivision, clbDivisions |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrCheckBox | 2 | chkSum, cboQty |
| UsrDateRangePicker | 2 | drpPeriod, drpDateTime |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| ImageList | 1 | imageList1 |
| UsrButtonList | 1 | btnButtonList |
| Panel | 1 | panel1 |
| Label | 1 | lblProgress |
| ProgressBar | 1 | progressBar1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 7149 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_EXCEL_COLUMNS | 1 | dbmeta_dbo_SCM_ADM_EXCEL_COLUMNS.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 20 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 446 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 69 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 14 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 769 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 6 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 15 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 66 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (2건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 437 | DM.DMF0003_GET_SPREAD_TITLE | commented:MATCH |
| 3165 | DM.DMF0020_GET_FUTUREPRICE_INFO | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0082 | FcstNPrice | 11/27 | 6/11 | 6/11 | 6/11 | 6/11 | 6/11 | 6/11 | 6/10 | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0082 | Sales Price Save All | 8/1 | 10/1 | 10/1 | 10/1 | 10/1 | 10/1 | 10/1 | 9/1 | · | · | · | · | · | · |
| SCM_MST_SHEET_MEASURE | DMF0082 | FcstNPrice | 6/8 | · | · | · | · | · | · | · | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 28개 시트×division 비교, 차이 700건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: FcstNPrice, Sales Price Save All
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:421, CreateSheetHeaderColumn@InitSpread:544
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadHeaderSpan |  | 484 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan |  | 497 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| SetSpreadColumn |  | 555 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") != -1) |
| SetSpreadColumn |  | 559 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") != -1) |
| SetSpreadColumn |  | 565 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 567 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") != -1) |
| SetSpreadColumn |  | 571 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 577 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") != -1) |
| SetSpreadColumn |  | 579 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") != -1) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 586 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sResultYYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 587 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).Substring(2) == sResultYYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 595 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(iso_week == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sResultYYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 596 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(iso_week == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sResultYYYYMMDD.Substring(0, 6)) |
| SetSpreadColumn |  | 603 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Green} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(check == false) ⟫ if(siMain.GetColumnTag(iCol).ToString() == this_YYYYMMWW) |
| SetSpreadColumn |  | 604 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(check == false) ⟫ if(siMain.GetColumnTag(iCol).ToString() == this_YYYYMMWW) |
| EditButton |  | 1572 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | if(this.fps != null) ⟫ if(sv.Columns[xCol1].Visible == false) |
| EditButton |  | 1578 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(this.fps != null) ⟫ else!(sv.Columns[xCol1].Visible == false) |
| Draw |  | 1998 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?DateTime.Today.ToString("yyyyMM")}{?ds.Tables[1].Rows[0]["ISO_WEEK"]} \|\| {?ds.Tables[2].Rows[0]["THIS_YYYYMMWW"]} | if(siMain.GetMaxRowIndex() >= 0) ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if("0">= 2) ⟫ if(int.Parse(sPeriod[0]) > int.Parse(sResultYYYYMMDD)) |
| Draw |  | 2003 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?sResultYYYYMMDD.Substring(0, 6)}{?ds.Tables[2].Rows[0]["ISO_WEEK"]} | if(siMain.GetMaxRowIndex() >= 0) ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if("0">= 2) ⟫ else!(int.Parse(sPeriod[0]) > int.Parse(sResultYYYYMMDD)) |
| Draw |  | 2009 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?DateTime.Today.ToString("yyyyMM")}{?ds.Tables[1].Rows[0]["ISO_WEEK"]} \|\| {?ds.Tables[2].Rows[0]["THIS_YYYYMMWW"]} | if(siMain.GetMaxRowIndex() >= 0) ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ else!("0">= 2) |
| Draw |  | 2016 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | D_{?dateTime2.ToString("yyyyMMdd")} | if(siMain.GetMaxRowIndex() >= 0) ⟫ else!(cboBucketType.ControlValues != "DAILY") ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > 0) |
| InsertRow |  | 2717 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?DateTime.Today.ToString("yyyyMM")}{?ds.Tables[1].Rows[0]["ISO_WEEK"]} \|\| {?ds.Tables[2].Rows[0]["THIS_YYYYMMWW"]} | if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.SheetName == "FcstNPrice") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if("0">= 2) ⟫ if(int.Parse(sPeriod[0]) > int.Parse(sResultYYYYMMDD)) |
| InsertRow |  | 2722 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?sResultYYYYMMDD.Substring(0, 6)}{?ds.Tables[2].Rows[0]["ISO_WEEK"]} | if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.SheetName == "FcstNPrice") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if("0">= 2) ⟫ else!(int.Parse(sPeriod[0]) > int.Parse(sResultYYYYMMDD)) |
| InsertRow |  | 2728 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?DateTime.Today.ToString("yyyyMM")}{?ds.Tables[1].Rows[0]["ISO_WEEK"]} \|\| {?ds.Tables[2].Rows[0]["THIS_YYYYMMWW"]} | if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.SheetName == "FcstNPrice") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ else!("0">= 2) |
| InsertRow |  | 2733 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | D_{?dateTime.ToString("yyyyMMdd")} | if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.SheetName == "FcstNPrice") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > 0) |
| cboBucketType_SelectedIndexChanged |  | 3291 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | D_{?dateTime2.ToString("yyyyMMdd")} | if(siMain != null) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > 0) |
| cboBucketType_SelectedIndexChanged |  | 3323 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?DateTime.Today.ToString("yyyyMM")}{?ds.Tables[1].Rows[0]["ISO_WEEK"]} \|\| {?ds.Tables[2].Rows[0]["THIS_YYYYMMWW"]} | if(siMain != null) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if("0">= 2) ⟫ if(int.Parse(sPeriod[0]) > int.Parse(sResultYYYYMMDD)) |
| cboBucketType_SelectedIndexChanged |  | 3328 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?sResultYYYYMMDD.Substring(0, 6)}{?ds.Tables[2].Rows[0]["ISO_WEEK"]} | if(siMain != null) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ if("0">= 2) ⟫ else!(int.Parse(sPeriod[0]) > int.Parse(sResultYYYYMMDD)) |
| cboBucketType_SelectedIndexChanged |  | 3334 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | W_{?DateTime.Today.ToString("yyyyMM")}{?ds.Tables[1].Rows[0]["ISO_WEEK"]} \|\| {?ds.Tables[2].Rows[0]["THIS_YYYYMMWW"]} | if(siMain != null) ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues != "DAILY") ⟫ if(siMain.GetColumnIndex(this_YYYYMMWW) > 0) ⟫ else!("0">= 2) |
| spdMain_CellDoubleClick |  | 3544 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") != -1) |
| spdMain_CellDoubleClick |  | 3550 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") != -1) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 3566 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") != -1) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| InitializeComponent |  | 1164 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1165 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1166 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1167 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadHeaderSpan |  | 598 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadColumn |  | 670 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 674 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 675 | 표시/라벨 변경 | set:BackColor | BackColor = {?Color.White} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 712 | DB루프 | AddNumColumn | {?dt.Rows[i]["MMDD"]} | {?dt.Rows[i]["BASIS_START_DATE"]} | for(i < dt.Rows.Count) ⟫ if(dt.Rows["0"]["BASIS_START_DATE2"].ToString().IndexOf("M_") != 0) |
| SetSpreadColumn |  | 717 | DB루프 | AddNumColumn | SUM | {?dt.Rows[i]["BASIS_START_DATE"]} | for(i < dt.Rows.Count) ⟫ else!(dt.Rows["0"]["BASIS_START_DATE2"].ToString().IndexOf("M_") != 0) |
| InitializeComponent |  | 703 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 704 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 705 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 706 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| FcstNPrice | META+코드연결 | 11 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | · | · | · | · | · | · |
| Sales Price Save All | META+코드연결 | 8 | 10 | 10 | 10 | 10 | 10 | 10 | 9 | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
