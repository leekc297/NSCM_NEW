# FP02844 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02844_Plan_Elec_Post_WH_Load.UIL\FP02844_Plan_Elec_Post_WH_Load.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02844_Plan_Elec_Post_WH_Load.UIL\FP02844_Plan_Elec_Post_WH_Load.UIL.csproj | 5594 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02844_Plan_Elec_Post_WH_Load.UIL\FP02844_Plan_Elec_Post_WH_Load.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02844_Plan_Elec_Post_WH_Load.UIL\FP02844_Plan_Elec_Post_WH_Load.UIL.csproj | 1661 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02844_Plan_Elec_Post_WH_Load.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02844_Plan_Elec_Post_WH_Load.UIL\FP02844_Plan_Elec_Post_WH_Load.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02844_Plan_Elec_Post_WH_Load.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02844_Plan_Elec_Post_WH_Load.UIL\FP02844_Plan_Elec_Post_WH_Load.UIL.csproj | 64 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02844_Plan_Elec_Post_WH_Load.UIL\Properties\Settings.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02844_Plan_Elec_Post_WH_Load.UIL\FP02844_Plan_Elec_Post_WH_Load.UIL.csproj | 27 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:bucke_menu.Click | onZeroBucketMenu > ManualSetPlanOutCell > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] | BIZ_MATCH |  |
| event:bucke_menu.Click | onZeroBucketMenu > ManualSetPlanOutCell > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | FP\Planning\FP00595_ROW#find_yieldInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_yieldInfo.sql |
| event:bucke_menu.Click | onZeroMaterialMenu > ManualSetPlanOutCell > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] | BIZ_MATCH |  |
| event:bucke_menu.Click | onZeroMaterialMenu > ManualSetPlanOutCell > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | FP\Planning\FP00595_ROW#find_yieldInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_yieldInfo.sql |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed > GetFactory | 1825 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2014 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2014 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2015 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2015 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2016 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2016 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2017 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2017 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > GetSite | 1809 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > GetFactory | 1825 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | BIZ_MATCH |  |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_changed > GetPlant | 1816 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData2 > ApplyAmendCalendarCondition | 2014 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData2 > ApplyAmendCalendarCondition | 2014 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData2 > ApplyAmendCalendarCondition | 2015 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData2 > ApplyAmendCalendarCondition | 2015 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData2 > ApplyAmendCalendarCondition | 2016 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData2 > ApplyAmendCalendarCondition | 2016 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData2 > ApplyAmendCalendarCondition | 2017 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData2 > ApplyAmendCalendarCondition | 2017 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:this.Load | Form_Load > InitControls > InitControlFilter > GetDivision | 1801 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitControlFilter > GetSite | 1809 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitControlFilter > GetPlant | 1816 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitControlFilter > GetFactory | 1825 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitControlFilter > GetPlanGroup | 4788 | biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | BIZ_MATCH |  |
| event:this.spdMain.Change | spdMain_Change > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] | BIZ_MATCH |  |
| event:this.spdMain.Change | spdMain_Change > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | FP\Planning\FP00595_ROW#find_yieldInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_yieldInfo.sql |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted > PasteAuto > ManualSetPlanOutCell > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] | BIZ_MATCH |  |
| event:this.spdMain.ClipboardPasted | spdMain_ClipboardPasted > PasteAuto > ManualSetPlanOutCell > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | FP\Planning\FP00595_ROW#find_yieldInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_yieldInfo.sql |
| event:this.spdMain.ClipboardPasting | spdMain_ClipboardPasting > ManualSetPlanOutCell > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] | BIZ_MATCH |  |
| event:this.spdMain.ClipboardPasting | spdMain_ClipboardPasting > ManualSetPlanOutCell > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | FP\Planning\FP00595_ROW#find_yieldInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_yieldInfo.sql |
| event:this.spdMain.KeyDown | spdMain_KeyDown > ManualSetPlanOutCell > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] | BIZ_MATCH |  |
| event:this.spdMain.KeyDown | spdMain_KeyDown > ManualSetPlanOutCell > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | FP\Planning\FP00595_ROW#find_yieldInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_yieldInfo.sql |
| event:zero_line_menu.Click | onZeroLineMenu > ManualSetPlanOutCell > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] | BIZ_MATCH |  |
| event:zero_line_menu.Click | onZeroLineMenu > ManualSetPlanOutCell > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | FP\Planning\FP00595_ROW#find_yieldInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_yieldInfo.sql |
| event:zero_mat_menu.Click | onZeroMaterialMenu > ManualSetPlanOutCell > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] | BIZ_MATCH |  |
| event:zero_mat_menu.Click | onZeroMaterialMenu > ManualSetPlanOutCell > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 2884 | FP\Planning\FP00595_ROW#find_yieldInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_yieldInfo.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 111 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | findLineCode_List | 480 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | findLineCode_List | 480 | FP\Planning\FP00595_ROW#findLineCode_List | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_findLineCode_List.sql |
| unreached:(진입점 미연결) | Find_YieldInfo_All | 2868 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Find_YieldInfo_All | 2868 | FP\Planning\FP00595#find_yieldInfo_ALL | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_YieldInfo_ALL.sql |
| unreached:(진입점 미연결) | btnMRP_Click | 4724 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnMRP_Click | 4724 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| unreached:(진입점 미연결) | btnMRP_Click | 4748 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnMRP_Click | 4748 | FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 1 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] | BIZ_MATCH | 1 |  |  |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql | SELECT:FP_USER_ROLE_INFO_V |  |
| FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql | UPDATE:SCM_FP_PLAN_H |  |
| FP\Planning\FP00595_ROW#find_yieldInfo | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_row_find_yieldInfo.sql | SELECT:SCM_YIELD_MA, SELECT:SCM_YIELD_EXCEPT_MA |  |
| FP\Planning\FP00595_ROW#findLineCode_List | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_row_findLineCode_List.sql | SELECT:SCM_LINE_MA, SELECT:FP_USER_ROLE_INFO_VB, SELECT:SCM_FACTORY_MA, SELECT:FP_INSTANCE_FACTORY_MB |  |
| FP\Planning\FP00595#find_yieldInfo_ALL | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_find_YieldInfo_ALL.sql |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | MONTH_INFO, BUCKET, WEEK_INFO, CATE_INFO |
| ApplySearchCondition | Filter | PLAN_DATE |
| ApplySearchCondition | LocalFilter | BUCKET_FROM, BUCKET_TO, MASTER_ID, INSTANCE_ID |
| btnMRP_Click | Filter | PLAN_ID, PLAN_TYPE, MASTER_ID, INSTANCE_ID |
| cbo_fpplanid_changed | dtPlanId.Rows[selected] | PLAN_START_DATE, PLAN_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME, CODE, BASIS_PLAN_ID, INSERT_ID, INSERT_Time, BASIC_VERSION, FACTORY_LT, UI_END_DATE |
| cbo_plan_group_changed | Filter | INSTANCE_ID, MASTER_ID |
| CreateFilterDataSet | x | ROW_TYPE |
| dCalendar_changed | Filter | FP_PLAN_ID, BUCKET_FROM, UI_END_DATE, PLAN_DATE, BUCKET_TO |
| DrawHeader | measure.Data | chk_day, chk_week, chk_month |
| DrawSheet | arow | ROW_TYPE, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ELECTRODE_TYPE, CATEGORY_NAME, GRAPH_NAME |
| DrawSheet | datas[i] | CATE, _VI_ |
| ds_List01_cancolumnchange | clicked_row | CATEGORY_ID |
| Find_YieldInfo_All | Filter2 | AMEND_BOR_TABLE |
| findLineCode_List | LocalFilter | LINE_ID, INSTANCE_ID, CTRL_INSTANCE, CTRL_PLAN_TYPE, PLAN_TYPE, CONFIRM_AREA, MASTER_ID, PLAN_ID, CTRL_LINE_LT, ALL_LINE |
| findLineCode_List | Filter | USER_LT, INSTANCE_ID |
| FindYieldInfo | Filter2 | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, PLAN_DATE |
| FindYieldInfo | Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID |
| FindYieldInfo | ret.Tables[0].Rows[0] | YIELD |
| GetDivision | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| GetFactory | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PLAN_TYPE, CONFIRM_AREA, MASTER_ID, PLAN_ID |
| GetOperation | Filter | OPERATION_ID |
| GetPlanGroup | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, AMEND_INSTANCE |
| GetPlant | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| GetSite | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| InitAmendLineELec | Filter | AMEND_INSTANCE, PLAN_DATE, USER_ID |
| InitControlFilter | Filter | MASTER_ID, INSTANCE_ID, USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID, BUCKET_FROM, BUCKET_TO, FP_PLAN_ID, PLAN_ID |
| InitControlFilter | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| lfn_getExchangeBatch_Validation | x | FACTORY_ID, OPERATION, ITEM_ID, CATEGORY, PROD_VERSION_TYPE |
| lfn_getExchangeBatch_Validation | clicked_row | FACTORY_ID, OPERATION_ID, ITEM_ID, PROD_VERSION_TYPE |
| lfn_getExchangeBatch_Validation | pancake_r.First() | VALUE |
| lfn_getYieldInfo | yf | LINE_ID, ITEM_ID, FACTORY_ID |
| lfn_getYieldInfo | clicked_row | LINE_ID, ITEM_ID, FACTORY_ID |
| lfn_setExchangeBatch | clicked_row | PRODUCTION_TYPE, PROD_VERSION_TYPE, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID |
| lfn_setExchangeBatch | dsUOMInfo.Tables[0].Rows[nExcRow] | VALUE |
| lfn_setExchangeBatch_Detail | objDs | FACTORY_ID, OPERATION_ID, ITEM_ID |
| onNLFAmendMenu | frm.Filter | MASTER_ID, FP_PLAN_ID |
| onNLFAmendMenu | Filter | INSTANCE_ID, PLAN_ID |
| onZeroBucketMenu | row_to_test | CATEGORY_ID |
| onZeroLineMenu | row | SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, LOCATION, CATEGORY_ID |
| onZeroLineMenu | row_to_test | CATEGORY_ID |
| onZeroMaterialMenu | row | SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, LOCATION, CATEGORY_ID |
| onZeroMaterialMenu | row_to_test | CATEGORY_ID |
| OpenAlarmMemo | row | PRODUCTION_TYPE |
| OpenAlarmMemo | frm.Filter | MEMO_TYPE |
| OpenLineMemo | frm.Filter | MEMO_TYPE |
| OpenMaterialMemo | frm.Filter | MEMO_TYPE |
| planday_changed | Filter | PLAN_DATE |
| RefreshSpreadSheet | row | _VI_ |
| SetMemoCell | set | BUCKET_FROM, BUCKET_TO, MEMO |
| SetMemoCell | clicked_row | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, LOCATION, CATEGORY_ID |
| SetPlanOutCell | clicked_row | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, LOCATION, CATEGORY_ID |
| SetPlanOutCell | x | FACTORY_ID, LOCATION, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ELECTRODE_TYPE, PLAN_DATE, ITEM_ID, PRODUCTION_TYPE, MARKET, RELEASE_TYPE |
| SetPlanOutCell | newRow | INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ELECTRODE_TYPE, PRODUCTION_TYPE, MARKET, ITEM_ID, PLAN_DATE, LOCATION, RELEASE_TYPE, SEQ |
| SetPlanOutCell | Filter | MASTER_ID, PLAN_ID, PLAN_TYPE |
| SetPlanOutCell | ds_ListDataR | RELEASE_TYPE, SEQ |
| SetPlanOutCell | measure | chk_jr, chk_pc, chk_cell, chk_outqty, chk_batch, chk_seq |
| SetPlanOutCell | dsMainFiltered.Tables[0].Rows[idx] | SEQ |
| spdMain_CellClick | row | LINE_ID, PRODUCTION_TYPE, DATA_TYPE, OPERATION_ID, TOP_ITEM_ID |
| spdMain_CellClick2 | row | LINE_ID, PRODUCTION_TYPE, DATA_TYPE |
| spdMain_CellClick2 | Filter | PLAN_TYPE |
| SwitchMemo | r | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET |
| SwitchMemo | memoRow | PRODUCTION_TYPE, ITEM_ID |
| SwitchMemo | memo[k] | ITEM_ID |
| SwitchMemo | materialRow | PRODUCTION_TYPE |
| UIFindData | Filter | FACTORY_ID, FP_PLAN_ID, DONOTEDIT |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControlFilter:253, InitControlFilter:275, InitControlFilter:279, InitControlFilter:283, InitControlFilter:288, InitControlFilter:303, InitControlFilter:316, UIFindData:1270 | CString.GetCheckedListValue | CODE |
| SetFilter | InitControlFilter:275, InitControlFilter:279, InitControlFilter:283, InitControlFilter:288, InitControlFilter:303, InitControlFilter:316, UIFindData:1270, mcbo_division_changed:4161 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetMeasure | CheckAndGetMeasure:532 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| LoadAmendColumn | DrawHeader:670 | MeasureService.LoadAmendColumn | DAYTAG, MONTHTAG, WEEKTAG |
| EditQuery | DrawSheet:757, DrawSheet:781 | FPExtensions.EditQuery | ROW_ID |
| FP_Log2 | cbo_plan_group_changed:4762, cbo_plan_group_changed:4773 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:145 |
| cbo_plan_group | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:328 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:329 |
| mcbo_site | SelectedIndexChanged | mcbo_site_changed | InitEvent:330 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:331 |
| mcbo_factory | SelectedIndexChanged | mcbo_factory_changed | InitEvent:332 |
| cboUnit | SelectedIndexChanged | cboUnit_changed | InitEvent:333 |
| cboRoundPoint | SelectedIndexChanged | cboRoundPoint_changed | InitEvent:334 |
| sCalendar_planday | ValueChanged | planday_changed | InitEvent:336 |
| cbo_fpplanid | SelectedIndexChanged | cbo_fpplanid_changed | InitEvent:337 |
| dCalendar_cutoff | ValueChanged | dCalendar_changed | InitEvent:339 |
| chk_show_ref_data | CheckedChanged | chk_omit_zero_CheckedChanged | InitEvent:340 |
| spdMain | CellClick | spdMain_CellClick2 | InitEvent:342 |
| cbHorizonalLegend | CheckedChanged | CbHorizonalLegend_CheckedChanged | InitEvent:345 |
| cbShowLegend | CheckedChanged | CbShowLegend_CheckedChanged | InitEvent:346 |
| updownRow | ValueChanged | UpdownRow_ValueChanged | InitEvent:347 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1417 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick2:4032 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick2:4042 |
| zero_line_menu | Click | onZeroLineMenu | spdMain_CellClick2:4059 |
| zero_mat_menu | Click | onZeroMaterialMenu | spdMain_CellClick2:4066 |
| line_change_menu | Click | onLineChangeMenu | spdMain_CellClick2:4073 |
| dCalendar_cutoff | ValueChanged | dCalendar_changed | cbo_fpplanid_changed:4252 |
| dCalendar_cutoff | ValueChanged | dCalendar_changed | cbo_fpplanid_changed:4255 |
| dCalendar_cutoff | ValueChanged | dCalendar_changed | dCalendar_changed:4340 |
| dCalendar_cutoff | ValueChanged | dCalendar_changed | dCalendar_changed:4343 |
| dCalendar_cutoff | ValueChanged | dCalendar_changed | dCalendar_changed:4350 |
| dCalendar_cutoff | ValueChanged | dCalendar_changed | dCalendar_changed:4353 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick:5456 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick:5465 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick:5479 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick:5491 |
| nlfamend_menu | Click | onNLFAmendMenu | spdMain_CellClick:5498 |
| this.chk_Info | CheckedChanged | chk_info_CheckedChanged | InitializeComponent:267 |
| this.btnToggleSave | Click | btnToggleSave_Click | InitializeComponent:355 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:623 |
| this.cbo_fpplanid | DropDown | cbo_fpplanid_DropDown | InitializeComponent:696 |
| this.spdMain | ClipboardChanged | spdMain_ClipboardChanged | InitializeComponent:990 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:991 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:992 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:993 |
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:994 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:995 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:996 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:997 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:998 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:999 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:1000 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1001 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:1002 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:1003 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:1004 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:1005 |
| this.spdMain | ClipboardChanging | spdMain_ClipboardChanging | InitializeComponent:1006 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:1007 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:1008 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:1009 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:1010 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:1011 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:1012 |
| this.button1 | Click | button1_Click_1 | InitializeComponent:1141 |
| this.btnSetting | Click | btnMenu_Click | InitializeComponent:1417 |
| this.chk_show_ref_data | CheckedChanged | chk_show_ref_data_CheckedChanged | InitializeComponent:1430 |
| this.btn_column | Click | btnColumn_Click | InitializeComponent:1468 |
| this | Resize | FP00602_Plan_Amend_Line_Elec_Resize | InitializeComponent:1531 |

## 6. 컨트롤 (71개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 13 | lblSql, lblData, layoutControlItem11, lblInstance, layoutControlItem1, layoutControlItem15, layoutControlItem21, lblPlanID, layoutControlItem8, layoutControlItem19, layoutControlItem3, layoutControlItem4, lblRoundPoint |
| Label | 13 | label3, txtBuilding, txtBasic, txtDesc, txtCreation, txtCreator, label7, label6, label5, label4, label8, label2, label1 |
| UsrButton | 6 | btnToggleSave, btnSql, btnReplan, usrButton2, btnSetting, btn_column |
| Panel | 5 | infoPanel, refPanel, panel2, panel4, panel1 |
| UsrCombo | 4 | cboUnit, cbo_plan_group, cbo_fpplanid, cboRoundPoint |
| UsrCheckedList2 | 4 | mcbo_division, mcbo_factory, mcbo_plant, mcbo_site |
| EmptySpaceItem | 4 | emptySpaceItem5, emptySpaceItem2, emptySpaceItem4, emptySpaceItem1 |
| CheckBox | 3 | cbShowLegend, cbHorizonalLegend, chk_show_ref_data |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| Button | 2 | button1, btnExportBufferData |
| GroupBox | 2 | groupBox2, groupBox1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCheckBox | 1 | chk_Info |
| UsrDatePickerWtWeek | 1 | sCalendar_planday |
| UsrDateRangePickerWtWeek | 1 | dCalendar_cutoff |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| SplitContainer | 1 | splitter |
| ImageList | 1 | imageList1 |
| NumericUpDown | 1 | updownRow |
| TextBox | 1 | tbLog |
| DataGridView | 1 | dgEdit |

## 7. 확인 필요 (6건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 2014 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2015 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2016 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2017 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 4748 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 4724 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 8 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 8 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 3 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP02844 | Amend | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@DrawHeader:615

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetCalenderColor |  | 584 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 590 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| InitializeComponent |  | 1028 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1029 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1030 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1031 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
