# FP00598 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_BucketSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_Plan_Amend_Model_Elec.UIL.csproj | 242 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_BucketSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_Plan_Amend_Model_Elec.UIL.csproj | 236 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_ExcelPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_Plan_Amend_Model_Elec.UIL.csproj | 1036 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_ExcelPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_Plan_Amend_Model_Elec.UIL.csproj | 872 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_Plan_Amend_Model_Elec.UIL.csproj | 404 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_MeasureSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_Plan_Amend_Model_Elec.UIL.csproj | 856 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_Plan_Amend_Model_Elec.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_Plan_Amend_Model_Elec.UIL.csproj | 9286 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_Plan_Amend_Model_Elec.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_Plan_Amend_Model_Elec.UIL.csproj | 2508 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_RowExcelPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_Plan_Amend_Model_Elec.UIL.csproj | 943 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_RowExcelPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_Plan_Amend_Model_Elec.UIL.csproj | 873 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00598_Plan_Amend_Model_Elec.UIL\FP00598_Plan_Amend_Model_Elec.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:bucke_menu.Click | onZeroBucketMenu > EditByFunc > EditCommon > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 6184 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] | BIZ_MATCH |  |
| event:bucke_menu.Click | onZeroBucketMenu > EditByFunc > EditCommon > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 6184 | FP\Planning\FP00595_ROW#find_yieldInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_yieldInfo.sql |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed > SetChangeControl | 370 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed > SetChangeControl | 370 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed | 7470 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed | 7470 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl | 370 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl | 370 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > GetRoundPoint | 3075 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_getRoundPoint] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > GetRoundPoint | 3075 | FP\Planning\FP00595_ROW#find_getRoundPoint | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_getRoundPoint.sql |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > GetPlanner | 3160 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanner_List] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > GetPlanner | 3160 | FP\Planning\FP00595_ROW#findPlanner_List | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_findPlanner_List.sql |
| event:chk_all_line.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 370 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:chk_all_line.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 370 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 212 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 212 | FP\Common\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_WeekCnt.sql |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 213 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 213 | FP\Common\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_DateMap.sql |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 214 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 214 | FP\Common\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_MonthCnt.sql |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 215 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 215 | FP\Common\FP00601_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_BukInfo.sql |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 235 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 235 | FP\Common\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_WeekCnt.sql |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 236 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 236 | FP\Common\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_DateMap.sql |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 237 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 237 | FP\Common\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_MonthCnt.sql |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 238 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > ApplyAmendCalendarCondition | 238 | FP\Common\FP00601_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_BukInfo.sql |
| button:FindButton | FindButton > FindData | 374 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 374 | FP\Planning\FP00595#find_ItemInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_ItemInfo.sql |
| button:FindButton | FindButton > FindData | 375 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 375 | FP\Planning\FP00595#find_LineInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_LineInfo.sql |
| button:FindButton | FindButton > FindData | 387 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 387 | FP\Planning\FP00595#find_ItemInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_ItemInfo.sql |
| button:FindButton | FindButton > FindData | 388 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 388 | FP\Planning\FP00595#find_LineInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_LineInfo.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| button:FindButton | FindButton > UIFindData | 1095 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPDS] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData | 1095 | FP\Planning\FP00595#find_isPDS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_isPDS.sql |
| button:FindButton | FindButton > UIFindData > SetReleaseProcess | 2889 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > SetReleaseProcess | 2889 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_getRoundPoint] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | FP\Planning\FP00595_ROW#find_getRoundPoint | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_getRoundPoint.sql |
| button:FindButton | FindButton > UIFindData > FindTotalValue | 3425 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_totalValue] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindTotalValue | 3425 | FP\Planning\FP00598_carryOver#find_totalValue | MATCH | [sql] foxquery_sql\FP_Planning_FP00598_carryover_find_TotalValue.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YieldInfo_Child] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | FP\Planning\FP00595_ROW#find_YieldInfo_Child | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_YieldInfo_Child.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | FP\Planning\FP00595_ROW#find_UOMInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo_ASIS] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | FP\Planning\FP00595_ROW#find_UOMInfo_ASIS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo_ASIS.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ListData] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | FP\Planning\FP00595_ROW#find_ListData | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_ListData.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_versionType] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | FP\Planning\FP00595_ROW#find_versionType | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_versionType.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Prod_Version_Type] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | FP\Planning\FP00595_ROW#find_Prod_Version_Type | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_Prod_Version_Type.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3630 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3631 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3637 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3638 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | FP\Planning\FP00595#find_yieldInfo_ALL | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_YieldInfo_ALL.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| button:InsertButton | InsertButton > UIFindData | 1095 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPDS] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData | 1095 | FP\Planning\FP00595#find_isPDS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_isPDS.sql |
| button:InsertButton | InsertButton > UIFindData > SetReleaseProcess | 2889 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > SetReleaseProcess | 2889 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_getRoundPoint] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | FP\Planning\FP00595_ROW#find_getRoundPoint | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_getRoundPoint.sql |
| button:InsertButton | InsertButton > UIFindData > FindTotalValue | 3425 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_totalValue] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > FindTotalValue | 3425 | FP\Planning\FP00598_carryOver#find_totalValue | MATCH | [sql] foxquery_sql\FP_Planning_FP00598_carryover_find_TotalValue.sql |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YieldInfo_Child] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | FP\Planning\FP00595_ROW#find_YieldInfo_Child | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_YieldInfo_Child.sql |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | FP\Planning\FP00595_ROW#find_UOMInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo.sql |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo_ASIS] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | FP\Planning\FP00595_ROW#find_UOMInfo_ASIS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo_ASIS.sql |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ListData] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | FP\Planning\FP00595_ROW#find_ListData | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_ListData.sql |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_versionType] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | FP\Planning\FP00595_ROW#find_versionType | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_versionType.sql |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Prod_Version_Type] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | FP\Planning\FP00595_ROW#find_Prod_Version_Type | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_Prod_Version_Type.sql |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3630 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3631 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3637 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3638 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | FP\Planning\FP00595#find_yieldInfo_ALL | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_YieldInfo_ALL.sql |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetChangeControl | 370 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetChangeControl | 370 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetChangeControl | 370 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetChangeControl | 370 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_line.SelectedIndexChanged | mcbo_line_changed > SetChangeControl | 370 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_line.SelectedIndexChanged | mcbo_line_changed > SetChangeControl | 370 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetChangeControl | 370 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetChangeControl | 370 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetChangeControl | 370 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetChangeControl | 370 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed | 7490 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed | 7490 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_prodtype.SelectedIndexChanged | mcbo_prodtype_changed > SetChangeControl | 370 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_prodtype.SelectedIndexChanged | mcbo_prodtype_changed > SetChangeControl | 370 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_changed > SetChangeControl | 370 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_changed > SetChangeControl | 370 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > SetChangeControl | 370 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > SetChangeControl | 370 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > GetRoundPoint | 3075 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_getRoundPoint] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > GetRoundPoint | 3075 | FP\Planning\FP00595_ROW#find_getRoundPoint | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_getRoundPoint.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YieldInfo_Child] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | FP\Planning\FP00595_ROW#find_YieldInfo_Child | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_YieldInfo_Child.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | FP\Planning\FP00595_ROW#find_UOMInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo_ASIS] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | FP\Planning\FP00595_ROW#find_UOMInfo_ASIS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo_ASIS.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > FindBaseData > find_ListData | 3493 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ListData] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > FindBaseData > find_ListData | 3493 | FP\Planning\FP00595_ROW#find_ListData | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_ListData.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > FindBaseData > find_versionType | 3501 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_versionType] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > FindBaseData > find_versionType | 3501 | FP\Planning\FP00595_ROW#find_versionType | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_versionType.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Prod_Version_Type] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | FP\Planning\FP00595_ROW#find_Prod_Version_Type | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_Prod_Version_Type.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 3630 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 3631 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 3637 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 3638 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | FP\Planning\FP00595#find_yieldInfo_ALL | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_YieldInfo_ALL.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData | 1095 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPDS] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData | 1095 | FP\Planning\FP00595#find_isPDS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_isPDS.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 2044 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 2044 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 2118 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_data] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 2118 | FP\Planning\FP00595_MPPWPP#merge_data | MATCH_PATTERN | [update-batch]  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 2125 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_data] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 2125 | FP\Planning\FP00595_MPPWPP#merge_data | MATCH_PATTERN | [update-batch]  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > SetReleaseProcess | 2889 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > SetReleaseProcess | 2889 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_getRoundPoint] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | FP\Planning\FP00595_ROW#find_getRoundPoint | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_getRoundPoint.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue | 3425 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_totalValue] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue | 3425 | FP\Planning\FP00598_carryOver#find_totalValue | MATCH | [sql] foxquery_sql\FP_Planning_FP00598_carryover_find_TotalValue.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YieldInfo_Child] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | FP\Planning\FP00595_ROW#find_YieldInfo_Child | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_YieldInfo_Child.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | FP\Planning\FP00595_ROW#find_UOMInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo_ASIS] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | FP\Planning\FP00595_ROW#find_UOMInfo_ASIS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo_ASIS.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ListData] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | FP\Planning\FP00595_ROW#find_ListData | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_ListData.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_versionType] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | FP\Planning\FP00595_ROW#find_versionType | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_versionType.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Prod_Version_Type] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | FP\Planning\FP00595_ROW#find_Prod_Version_Type | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_Prod_Version_Type.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3630 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3631 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3637 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3638 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | FP\Planning\FP00595#find_yieldInfo_ALL | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_YieldInfo_ALL.sql |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData | 1095 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPDS] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData | 1095 | FP\Planning\FP00595#find_isPDS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_isPDS.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > SetReleaseProcess | 2889 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > SetReleaseProcess | 2889 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_getRoundPoint] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | FP\Planning\FP00595_ROW#find_getRoundPoint | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_getRoundPoint.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindTotalValue | 3425 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_totalValue] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindTotalValue | 3425 | FP\Planning\FP00598_carryOver#find_totalValue | MATCH | [sql] foxquery_sql\FP_Planning_FP00598_carryover_find_TotalValue.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YieldInfo_Child] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | FP\Planning\FP00595_ROW#find_YieldInfo_Child | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_YieldInfo_Child.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | FP\Planning\FP00595_ROW#find_UOMInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo_ASIS] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | FP\Planning\FP00595_ROW#find_UOMInfo_ASIS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo_ASIS.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ListData] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | FP\Planning\FP00595_ROW#find_ListData | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_ListData.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_versionType] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | FP\Planning\FP00595_ROW#find_versionType | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_versionType.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Prod_Version_Type] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | FP\Planning\FP00595_ROW#find_Prod_Version_Type | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_Prod_Version_Type.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3630 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3631 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3637 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3638 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | FP\Planning\FP00595#find_yieldInfo_ALL | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_YieldInfo_ALL.sql |
| event:this.btn_category.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btn_category.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btn_category.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btn_category.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData | 1095 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPDS] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData | 1095 | FP\Planning\FP00595#find_isPDS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_isPDS.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > SetReleaseProcess | 2889 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > SetReleaseProcess | 2889 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_getRoundPoint] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | FP\Planning\FP00595_ROW#find_getRoundPoint | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_getRoundPoint.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindTotalValue | 3425 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_totalValue] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindTotalValue | 3425 | FP\Planning\FP00598_carryOver#find_totalValue | MATCH | [sql] foxquery_sql\FP_Planning_FP00598_carryover_find_TotalValue.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YieldInfo_Child] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | FP\Planning\FP00595_ROW#find_YieldInfo_Child | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_YieldInfo_Child.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | FP\Planning\FP00595_ROW#find_UOMInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo_ASIS] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | FP\Planning\FP00595_ROW#find_UOMInfo_ASIS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo_ASIS.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ListData] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | FP\Planning\FP00595_ROW#find_ListData | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_ListData.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_versionType] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | FP\Planning\FP00595_ROW#find_versionType | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_versionType.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Prod_Version_Type] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | FP\Planning\FP00595_ROW#find_Prod_Version_Type | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_Prod_Version_Type.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3630 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3631 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3637 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3638 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | FP\Planning\FP00595#find_yieldInfo_ALL | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_YieldInfo_ALL.sql |
| event:this.btn_column.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btn_column.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btn_column.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btn_column.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData | 1095 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPDS] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData | 1095 | FP\Planning\FP00595#find_isPDS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_isPDS.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > SetReleaseProcess | 2889 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > SetReleaseProcess | 2889 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_getRoundPoint] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | FP\Planning\FP00595_ROW#find_getRoundPoint | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_getRoundPoint.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > FindTotalValue | 3425 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_totalValue] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > FindTotalValue | 3425 | FP\Planning\FP00598_carryOver#find_totalValue | MATCH | [sql] foxquery_sql\FP_Planning_FP00598_carryover_find_TotalValue.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YieldInfo_Child] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | FP\Planning\FP00595_ROW#find_YieldInfo_Child | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_YieldInfo_Child.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | FP\Planning\FP00595_ROW#find_UOMInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo_ASIS] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | FP\Planning\FP00595_ROW#find_UOMInfo_ASIS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo_ASIS.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ListData] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | FP\Planning\FP00595_ROW#find_ListData | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_ListData.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_versionType] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | FP\Planning\FP00595_ROW#find_versionType | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_versionType.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Prod_Version_Type] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | FP\Planning\FP00595_ROW#find_Prod_Version_Type | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_Prod_Version_Type.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3630 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3631 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3637 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3638 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | FP\Planning\FP00595#find_yieldInfo_ALL | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_YieldInfo_ALL.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click | 7949 | FP_Master.PR_UI_FP00598_FIND_FP00598 | NOT_IN_FOXQUERY |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData | 1095 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPDS] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData | 1095 | FP\Planning\FP00595#find_isPDS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_isPDS.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > SetReleaseProcess | 2889 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > SetReleaseProcess | 2889 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_getRoundPoint] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | FP\Planning\FP00595_ROW#find_getRoundPoint | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_getRoundPoint.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > FindTotalValue | 3425 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_totalValue] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > FindTotalValue | 3425 | FP\Planning\FP00598_carryOver#find_totalValue | MATCH | [sql] foxquery_sql\FP_Planning_FP00598_carryover_find_TotalValue.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YieldInfo_Child] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | FP\Planning\FP00595_ROW#find_YieldInfo_Child | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_YieldInfo_Child.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | FP\Planning\FP00595_ROW#find_UOMInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo_ASIS] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | FP\Planning\FP00595_ROW#find_UOMInfo_ASIS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo_ASIS.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ListData] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | FP\Planning\FP00595_ROW#find_ListData | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_ListData.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_versionType] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | FP\Planning\FP00595_ROW#find_versionType | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_versionType.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Prod_Version_Type] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | FP\Planning\FP00595_ROW#find_Prod_Version_Type | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_Prod_Version_Type.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3630 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3631 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3637 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3638 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | FP\Planning\FP00595#find_yieldInfo_ALL | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_YieldInfo_ALL.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click | 8387 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click | 8387 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| event:this.btnDWSubmit.Click | btnDwSubmit_Click | 8326 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| event:this.btnDWSubmit.Click | btnDwSubmit_Click | 8326 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData | 1095 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPDS] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData | 1095 | FP\Planning\FP00595#find_isPDS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_isPDS.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > SetReleaseProcess | 2889 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > SetReleaseProcess | 2889 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_getRoundPoint] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > GetRoundPoint | 3075 | FP\Planning\FP00595_ROW#find_getRoundPoint | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_getRoundPoint.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindTotalValue | 3425 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_totalValue] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindTotalValue | 3425 | FP\Planning\FP00598_carryOver#find_totalValue | MATCH | [sql] foxquery_sql\FP_Planning_FP00598_carryover_find_TotalValue.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YieldInfo_Child] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > FindBaseData > find_YieldInfo_Child | 3458 | FP\Planning\FP00595_ROW#find_YieldInfo_Child | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_YieldInfo_Child.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3473 | FP\Planning\FP00595_ROW#find_UOMInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo_ASIS] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > FindBaseData > find_UOMInfo | 3478 | FP\Planning\FP00595_ROW#find_UOMInfo_ASIS | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo_ASIS.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ListData] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > FindBaseData > find_ListData | 3493 | FP\Planning\FP00595_ROW#find_ListData | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_ListData.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_versionType] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > FindBaseData > find_versionType | 3501 | FP\Planning\FP00595_ROW#find_versionType | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_versionType.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Prod_Version_Type] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > FindBaseData > find_Prod_Version_Type | 3511 | FP\Planning\FP00595_ROW#find_Prod_Version_Type | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_Prod_Version_Type.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3619 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3630 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3631 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3633 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3637 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3638 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 3640 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > FindBaseData > Find_YieldInfo_All | 6167 | FP\Planning\FP00595#find_yieldInfo_ALL | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_YieldInfo_ALL.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 212 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 212 | FP\Common\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_WeekCnt.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 213 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 213 | FP\Common\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_DateMap.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 214 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 214 | FP\Common\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_MonthCnt.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 215 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 215 | FP\Common\FP00601_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_BukInfo.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 235 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 235 | FP\Common\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_WeekCnt.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 236 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 236 | FP\Common\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_DateMap.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 237 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 237 | FP\Common\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_MonthCnt.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 238 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > ApplyAmendCalendarCondition | 238 | FP\Common\FP00601_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_BukInfo.sql |
| event:this.btnFind.Click | btnFind_Click > FindData | 374 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData | 374 | FP\Planning\FP00595#find_ItemInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_ItemInfo.sql |
| event:this.btnFind.Click | btnFind_Click > FindData | 375 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData | 375 | FP\Planning\FP00595#find_LineInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_LineInfo.sql |
| event:this.btnFind.Click | btnFind_Click > FindData | 387 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData | 387 | FP\Planning\FP00595#find_ItemInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_ItemInfo.sql |
| event:this.btnFind.Click | btnFind_Click > FindData | 388 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData | 388 | FP\Planning\FP00595#find_LineInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_LineInfo.sql |
| event:this.btnMRP.Click | btnMRP_Click | 7896 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| event:this.btnMRP.Click | btnMRP_Click | 7896 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| event:this.btnMRP.Click | btnMRP_Click | 7920 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH |  |
| event:this.btnMRP.Click | btnMRP_Click | 7920 | FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql |
| event:this.btnRelease2.Click | btnRelease_Click | 8048 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| event:this.btnRelease2.Click | btnRelease_Click | 8048 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| event:this.btnRelease2.Click | btnRelease_Click | 8085 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instanceInfo] | BIZ_MATCH |  |
| event:this.btnRelease2.Click | btnRelease_Click | 8085 | FP\Common\XpCommonAmend#find_instanceInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_instanceInfo.sql |
| event:this.btnRelease2.Click | btnRelease_Click | 8086 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo] | BIZ_MATCH |  |
| event:this.btnRelease2.Click | btnRelease_Click | 8086 | FP\Common\XpCommonAmend#find_planInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_planInfo.sql |
| event:this.btnRelease2.Click | btnRelease_Click | 8099 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click | 8125 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click | 8128 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 212 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 212 | FP\Common\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_WeekCnt.sql |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 213 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 213 | FP\Common\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_DateMap.sql |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 214 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 214 | FP\Common\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_MonthCnt.sql |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 215 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 215 | FP\Common\FP00601_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_BukInfo.sql |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 235 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 235 | FP\Common\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_WeekCnt.sql |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 236 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 236 | FP\Common\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_DateMap.sql |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 237 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 237 | FP\Common\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_MonthCnt.sql |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 238 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > ApplyAmendCalendarCondition | 238 | FP\Common\FP00601_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_BukInfo.sql |
| event:this.Load | Form_Load > InitControls > InitControlFilter > mcbo_prodtype_changed > SetChangeControl | 370 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitControlFilter > mcbo_prodtype_changed > SetChangeControl | 370 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > FindData | 374 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 374 | FP\Planning\FP00595#find_ItemInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_ItemInfo.sql |
| event:this.Load | Form_Load > FindData | 375 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 375 | FP\Planning\FP00595#find_LineInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_LineInfo.sql |
| event:this.Load | Form_Load > FindData | 387 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 387 | FP\Planning\FP00595#find_ItemInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_ItemInfo.sql |
| event:this.Load | Form_Load > FindData | 388 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 388 | FP\Planning\FP00595#find_LineInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_find_LineInfo.sql |
| event:this.Load | Form_Load > InitControls > InitControlFilter > cbo_plan_group_changed > GetRoundPoint | 3075 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_getRoundPoint] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitControlFilter > cbo_plan_group_changed > GetRoundPoint | 3075 | FP\Planning\FP00595_ROW#find_getRoundPoint | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_getRoundPoint.sql |
| event:this.Load | Form_Load > InitControls > InitControlFilter > cbo_plan_group_changed > GetPlanner | 3160 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanner_List] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitControlFilter > cbo_plan_group_changed > GetPlanner | 3160 | FP\Planning\FP00595_ROW#findPlanner_List | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_findPlanner_List.sql |
| event:this.Load | Form_Load > InitControls > InitControlFilter > cbo_fpplanid_changed | 7470 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitControlFilter > cbo_fpplanid_changed | 7470 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > InitControlFilter > mcbo_plant_changed | 7490 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitControlFilter > mcbo_plant_changed | 7490 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > SetChangeControl | 370 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > SetChangeControl | 370 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 971 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 972 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1006 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1007 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.spdMain.Change | spdMain_Change > EditByChange > EditCommon > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 6184 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] | BIZ_MATCH |  |
| event:this.spdMain.Change | spdMain_Change > EditByChange > EditCommon > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 6184 | FP\Planning\FP00595_ROW#find_yieldInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_yieldInfo.sql |
| event:usrCheckBox1.CheckedChanged | chk_includeSubOp_onchanged > SetChangeControl | 370 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:usrCheckBox1.CheckedChanged | chk_includeSubOp_onchanged > SetChangeControl | 370 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:zero_all_line_menu.Click | onZeroAllMenu > EditByFunc > EditCommon > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 6184 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] | BIZ_MATCH |  |
| event:zero_all_line_menu.Click | onZeroAllMenu > EditByFunc > EditCommon > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 6184 | FP\Planning\FP00595_ROW#find_yieldInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_yieldInfo.sql |
| event:zero_line_menu.Click | onZeroLineMenu > EditByFunc > EditCommon > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 6184 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] | BIZ_MATCH |  |
| event:zero_line_menu.Click | onZeroLineMenu > EditByFunc > EditCommon > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 6184 | FP\Planning\FP00595_ROW#find_yieldInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_yieldInfo.sql |
| event:zero_mat_menu.Click | onZeroMaterialMenu > EditByFunc > EditCommon > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 6184 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] | BIZ_MATCH |  |
| event:zero_mat_menu.Click | onZeroMaterialMenu > EditByFunc > EditCommon > SetPlanOutCell > lfn_getYieldInfo > FindYieldInfo | 6184 | FP\Planning\FP00595_ROW#find_yieldInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_yieldInfo.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 119 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | findLineCode_List | 532 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | findLineCode_List | 532 | FP\Planning\FP00595_ROW#findLineCode_List | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_findLineCode_List.sql |
| unreached:(진입점 미연결) | find_carryOver | 3535 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_carryOver] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | find_carryOver | 3535 | FP\Planning\FP00595_ROW#find_carryOver | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_row_find_carryOver.sql |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 4646 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 4646 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| unreached:(진입점 미연결) | SaveExcelRows | 4794 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveExcelRows | 4794 | FP\Common\AmendValidation#find_save_seq | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendValidation_find_save_seq.sql |
| unreached:(진입점 미연결) | SaveExcelRows | 4815 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveExcelRows | 4815 | FP\Planning\FP00595_MPPWPP#delete_Excel_buffer | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_MPPWPP_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | SaveExcelRows | 4816 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveExcelRows | 4816 | FP\Planning\FP00595_MPPWPP#insert_Excel_buffer | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | SaveExcelRows | 4859 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveExcelRows | 4859 | FP\Planning\FP00595_MPPWPP#find_Excel_buffer_validation | MATCH | [sql] foxquery_sql\FP_Planning_FP00595_MPPWPP_find_Excel_buffer_validation.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 5140 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 5140 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 5306 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 5306 | FP\Common\AmendValidation#find_save_seq | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendValidation_find_save_seq.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 5348 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 5348 | FP\Common\FP00602_MPPWPP#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 5372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 5372 | FP\Common\FP00602_MPPWPP#find_Excel_buffer_validation | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_MPPWPP_find_Excel_buffer_validation.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_carryOver] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_getRoundPoint] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instanceInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPDS] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ListData] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Prod_Version_Type] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_totalValue] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo_ASIS] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_versionType] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YieldInfo_Child] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanner_List] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_data] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP00598_FIND_FP00598 | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 7 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP\Common\AmendMemo#list_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql | SELECT:FP_AMEND_MEMO_M, SELECT:FP_AMEND_SETUP_COLOR_M |  |
| FP\Common\AmendValidation#find_save_seq | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_AmendValidation_find_save_seq.sql |  |  |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 3 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\FP00601_PlanAmend#find_BukInfo | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_BukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_FP00601_PlanAmend_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_MPPWPP#find_Excel_buffer_validation | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_MPPWPP_find_Excel_buffer_validation.sql | SELECT:BUF_AMEND_PLAN_CELL_RA, SELECT:SCM_FACTORY_MB, SELECT:FP_INSTANCE_INFO_VIV, SELECT:SCM_SYS_LOOKUP_VALUESS, SELECT:SCM_ITEM_MA, SELECT:FP_INSTANCE_OPERATION_VA, SELECT:SCM_OPERATION_MC, SELECT:SCM_LINE_MD, SELECT:SCM_SYS_LOOKUP_VALUEA, SELECT:SCM_SYS_LOOKUP_VALUEB, SELECT:FP_WEEKLY_DEMAND_PRODUCT_PDS_HA, SELECT:FP_INSTANCE_LINE_VA, SELECT:TH_UIS_CALB, SELECT:FP_USER_ROLE_INFO_VR |  |
| FP\Common\FP00602_MPPWPP#insert_Excel_buffer | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo_sun.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\PICAlarm#find_Category | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\XpCommonAmend#find_instanceInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_instanceInfo.sql | SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_INSTANCE_FACTORY_M, SELECT:SCM_FACTORY_M |  |
| FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql | REF:FN_SITE_TIME, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\XpCommonAmend#find_planInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_planInfo.sql | SELECT:SCM_FP_PLAN_H |  |
| FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | 4 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql | SELECT:FP_USER_ROLE_INFO_V |  |
| FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql | UPDATE:SCM_FP_PLAN_H |  |
| FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 3 | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql | SELECT:FP_PLAN_STATUS_H, SELECT:SCM_FP_PLAN_DETAIL_H, SELECT:SCM_FP_PLAN_GROUP_DETAIL_H, SELECT:FP_RELEASE_CALCULATION_STATUS_H |  |
| FP\Planning\FP00595_MPPWPP#delete_Excel_buffer | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_MPPWPP_delete_Excel_buffer.sql | DELETE:BUF_AMEND_DAILY_PLAN_R |  |
| FP\Planning\FP00595_MPPWPP#find_Excel_buffer_validation | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_MPPWPP_find_Excel_buffer_validation.sql | SELECT:BUF_AMEND_DAILY_PLAN_R, SELECT:SCM_FACTORY_M, SELECT:FP_INSTANCE_INFO_V, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:SCM_ITEM_M, SELECT:SCM_ITEM_CLASS_M, SELECT:SCM_OPERATION_M, SELECT:SCM_LINE_M, SELECT:FP_INSTANCE_ITEM_V, SELECT:SCM_ITEM_LINE_ASSIGN_M, SELECT:SCM_TACT_TIME_M, SELECT:FP_INSTANCE_CONFIG_M, SELECT:SCM_EQUIPMENT_M, SELECT:SCM_ITEM_CONV_CALC_M, SELECT:SCM_ITEM_CONV_CALC_USE_M, SELECT:FP_WEEKLY_DEMAND_PRODUCT_PDS_H, SELECT:FP_INSTANCE_LINE_V, SELECT:TH_UIS_CAL, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\Planning\FP00595_MPPWPP#insert_Excel_buffer | MATCH | 1 | [update-batch]  |  |  |
| FP\Planning\FP00595_MPPWPP#merge_data | MATCH_PATTERN | 2 | [update-batch]  |  |  |
| FP\Planning\FP00595_ROW#find_carryOver | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_row_find_carryOver.sql |  |  |
| FP\Planning\FP00595_ROW#find_getRoundPoint | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_row_find_getRoundPoint.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Planning\FP00595_ROW#find_ListData | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_row_find_ListData.sql |  |  |
| FP\Planning\FP00595_ROW#find_Prod_Version_Type | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_row_find_Prod_Version_Type.sql | SELECT:SCM_ITEM_CONV_CALC_MA, SELECT:FP_INSTANCE_FACTORY_MC, SELECT:SCM_SYS_LOOKUP_VALUEA |  |
| FP\Planning\FP00595_ROW#find_UOMInfo | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo.sql | SELECT:SCM_ITEM_CONV_CALC_MA, SELECT:SCM_SYS_LOOKUP_VALUEA |  |
| FP\Planning\FP00595_ROW#find_UOMInfo_ASIS | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_row_find_UOMInfo_ASIS.sql | SELECT:SCM_ITEM_CONV_CALC_MA, SELECT:SCM_SYS_LOOKUP_VALUEA |  |
| FP\Planning\FP00595_ROW#find_versionType | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_row_find_versionType.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Planning\FP00595_ROW#find_yieldInfo | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_row_find_yieldInfo.sql | SELECT:SCM_YIELD_MA, SELECT:SCM_YIELD_EXCEPT_MA |  |
| FP\Planning\FP00595_ROW#find_YieldInfo_Child | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_row_find_YieldInfo_Child.sql |  |  |
| FP\Planning\FP00595_ROW#findLineCode_List | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_row_findLineCode_List.sql | SELECT:SCM_LINE_MA, SELECT:FP_USER_ROLE_INFO_VB, SELECT:SCM_FACTORY_MA, SELECT:FP_INSTANCE_FACTORY_MB |  |
| FP\Planning\FP00595_ROW#findPlanner_List | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_row_findPlanner_List.sql | SELECT:FP_USER_LINE_GROUP_M, SELECT:TH_UIS_USER_DETAIL |  |
| FP\Planning\FP00595#find_isPDS | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_find_isPDS.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Planning\FP00595#find_ItemInfo | MATCH | 2 | [sql] foxquery_sql\FP_Planning_FP00595_find_ItemInfo.sql | SELECT:SCM_ITEM_M |  |
| FP\Planning\FP00595#find_LineInfo | MATCH | 2 | [sql] foxquery_sql\FP_Planning_FP00595_find_LineInfo.sql | SELECT:SCM_LINE_M |  |
| FP\Planning\FP00595#find_yieldInfo_ALL | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00595_find_YieldInfo_ALL.sql |  |  |
| FP\Planning\FP00598_carryOver#find_totalValue | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00598_carryover_find_TotalValue.sql | SELECT:MAINA |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | DATE_INFO, MONTH_INFO, BUCKET, WEEK_INFO, PLAN_DATE, BUCKET_FROM, BUCKET_TO, CATE_INFO |
| ApplySearchCondition | LocalFilter | INSTANCE_ID, BUCKET_FROM, BUCKET_TO, PLAN_DATE, PLAN_ID, MASTER_ID, PRODTYPE_LT, PRODTYPE_ID |
| btnBucket_Click | measure | chk_week_sun |
| btnCapa_Click | Filter | FP_PLAN_ID |
| btnCreatePlan_Click | Filter | SITE_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, PLAN_ID |
| btnCreatePlan_Click | dtPlanRunFlag.Rows[0] | PLAN_ID, INSERT_ID |
| btnCreatePlan_Click | Application.OpenForms | FP00590_PlanTotalPopup |
| btnDppWppCopyDwSubmit_Click | Filter | PLAN_ID, PLAN_TYPE, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, PLAN_DATE, PLANT_ID, SITE_ID, FACTORY_ID, DIVISION_ID |
| btnDppWppCopyDwSubmit_Click | CopySubmit.Filter | SUBMIT_TYPE, MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, PLAN_ID, PLAN_DATE, PLANT_ID, SITE_ID, FACTORY_ID, DIVISION_ID, USER_ID |
| btnDwSubmit_Click | Filter | PLAN_ID, PLAN_TYPE, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, PLAN_DATE, PLANT_ID, SITE_ID, FACTORY_ID, DIVISION_ID |
| btnDwSubmit_Click | DwSubmit.Filter | SUBMIT_TYPE, MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, PLAN_ID, PLAN_DATE, PLANT_ID, SITE_ID, FACTORY_ID, DIVISION_ID, USER_ID |
| btnExcelImport_Click | Filter | DONOTEDIT, IS_PDS |
| btnExcelImport_Click | colPopup.Filter | UI_END_DATE |
| btnExcelImport_Click | colPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, PC_MODEL_ID, VERSION, PLM_EC_NO, PRODUCTION_TYPE, MARKET |
| btnExcelImport_Click | colPopup.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, LINE_NAME, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, NICK_NAME, PC_MODEL_ID, VERSION, PLM_EC_NO, PRODUCTION_TYPE, MARKET |
| btnExcelImport_Click | rowPopup.Filter | UI_END_DATE |
| btnExcelImport_Click | rowPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, PC_MODEL_ID, VERSION, PLM_EC_NO, PRODUCTION_TYPE, MARKET, PLAN_DATE, ADJUST_IN_QTY_BATCH, SEQ |
| btnExcelImport_Click | rowPopup.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, LINE_NAME, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, NICK_NAME, PC_MODEL_ID, VERSION, PLM_EC_NO, PRODUCTION_TYPE, MARKET, PLAN_DATE, ADJUST_IN_QTY_M, ADJUST_IN_QTY_CELL, ADJUST_IN_QTY_JR, ADJUST_IN_QTY_BATCH, SEQ, MESSAGE |
| btnExcelImport_Click | rowPopup.ColumnColor | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, PC_MODEL_ID, VERSION, PLM_EC_NO, PRODUCTION_TYPE, MARKET, PLAN_DATE, ADJUST_IN_QTY_BATCH, SEQ |
| btnExcelImport_Click | rowPopup.ColumnWidth | COMPANY_ID |
| btnFind_Click | Filter | PLAN_DATE, PLAN_TYPE, CURR_DATE |
| btnMemo_Click | Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID |
| btnMemo_Click | memoPopup.Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, MODEL_ID, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID, USER_ID |
| btnMRP_Click | Filter | PLAN_ID, PLAN_TYPE, MASTER_ID, INSTANCE_ID |
| btnRelease_Click | Filter | SITE_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, DESCRIPTION |
| btnRelease_Click | dtPlanInfo.Rows[0] | DESCRIPTION, PLAN_TYPE |
| btnRelease_Click | dtEngineFlag.Rows[0] | INBOUND, ENGINE, OUTBOUND |
| btnRelease_Click | dtPlanRunFlag.Rows[0] | PLAN_ID, INSERT_ID |
| btnRelease_Click | dtParam2.Rows[0] | CONFIRM_AREA, IS_SAME_PLAN_ID, USE_WOW_STATUS |
| btnRelease_Click | Application.OpenForms | FP00590_GroupReleaseTotalPopup |
| call_Excel_After_Import | row | DIVISION_ID, SITE_ID, ITEM_ID, OPERATION_ID, PLANT_ID, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, APPLIED_MODEL, PROD_VERSION_TYPE, WORK_REQUEST_MODEL_ID, PC_MODEL_ID, VERSION |
| call_Excel_After_Import | rows[0] | APPLIED_MODEL, PROD_VERSION_TYPE |
| call_Excel_Col_Save | checkSave.Tables[0].Rows[0] | _TYPE |
| call_Excel_Col_Save | pivotLine | INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, QTY, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, LINE_NAME, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, LOCATION, MARKET, TOP_ITEM_ID, USER_ID, PC_MODEL_ID, WORK_REQUEST_MODEL_ID, VERSION, PLM_EC_NO, ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY_M, ADJUST_IN_QTY_CELL, ADJUST_IN_QTY_JR, ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY_M, ADJUST_OUT_QTY_CELL, ADJUST_OUT_QTY_JR, SEQ |
| call_Excel_Col_Save | popup.Filter | MASTER_ID, PLAN_ID |
| call_Excel_Col_Save | row | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, LINE_NAME, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, LOCATION, MARKET, TOP_ITEM_ID, USER_ID, PC_MODEL_ID, VERSION, PLM_EC_NO |
| call_Excel_Col_Search | popup.Filter | PLAN_TYPE |
| call_Excel_Row_After_Import | row | DIVISION_ID, SITE_ID, ITEM_ID, OPERATION_ID, PLANT_ID, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, APPLIED_MODEL, PROD_VERSION_TYPE, WORK_REQUEST_MODEL_ID, PC_MODEL_ID, VERSION, PLAN_DATE |
| call_Excel_Row_After_Import | rows[0] | APPLIED_MODEL, PROD_VERSION_TYPE |
| call_Excel_Row_Save | checkSave.Tables[0].Rows[0] | _TYPE |
| call_Excel_Row_Save | popup.Filter | PLAN_TYPE, NEW_SEQ, MPP_WPP, FP_PLAN_ID, INSTANCE_ID |
| call_Excel_Row_Save | row | JOB_ORDER, MPP_WPP, NEW_SEQ, IN_QTY_BATCH, IN_QTY_M, IN_QTY_CELL, IN_QTY_JR, IN_QTY, OUT_QTY_BATCH, OUT_QTY_M, OUT_QTY_CELL, OUT_QTY_JR, OUT_QTY, QTY, WORK_REQUEST_MODEL_ID, PC_MODEL_ID, INSTANCE_ID, FP_PLAN_ID |
| call_Excel_Row_Search | popup.Filter | PLAN_TYPE |
| call_Excel_Row_Validation | popup.Filter | PLAN_TYPE, NEW_SEQ, INSTANCE_ID, FP_PLAN_ID, INSTANCE_COND |
| call_Excel_Row_Validation | nSeq.Tables[0].Rows[0] | NEW_SEQ |
| call_Excel_Row_Validation | row | CELL, QTY, INSTANCE_ID, FP_PLAN_ID, NEW_SEQ |
| cbo_fpplanid_changed | Filter | PLAN_TYPE, BUCKET_FROM, BUCKET_TO |
| cbo_fpplanid_changed | dtPlanId.Rows[selected] | PLAN_START_DATE, PLAN_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME, CODE, BASIS_PLAN_ID, INSERT_ID, INSERT_Time, BASIC_VERSION, FACTORY_LT |
| CheckAndGetMeasure | measure.Data | chk_week, chk_day, chk_month, chk_week_sun |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_inqty, chk_pc, chk_jr, chk_cell, chk_batch, chk_outqty, chk_pc_out, chk_jr_out, chk_cell_out, chk_batch_out, chk_inqty_MPP, chk_outqty_MPP, chk_inqty_WPP, chk_outqty_WPP, chk_engine_inqty, chk_engine_outqty, chk_result, chk_capa, chk_i, chk_memo, chk_S_M, chk_S_cell, chk_S_scp, chk_S_batch, chk_past_sales, chk_assy_plan, chk_subTotal, chk_S_M_tot, chk_S_cell_tot, chk_S_scp_tot, chk_S_batch_tot, chk_past_sales_tot, chk_assy_plan_tot, chk_total |
| CreateFilterDataSet | rows[i] | _MM_ |
| CreateFilterDataSet | x | _MM_ |
| dateRange_ValueChanged | Filter | BUCKET_FROM, BUCKET_TO |
| DrawHeader | measure.Data | chk_day, chk_week, chk_month |
| ds_List01_cancolumnchange | clicked_row | CATEGORY_ID |
| find_carryOver | Filter2 | ITEM_ID, ITEM_NAME, ITEMNAME_ID, PRODTYPE_ID, NICKNAME_ID |
| find_carryOver | Filter | ITEM_ID, ITEM_NAME, PRODTYPE_LT, NICKNAME_LT |
| Find_Data_Amend | Filter | FP_PLAN_ID, PLAN_ID |
| find_version_data | clicked_row | PRODUCTION_TYPE, PROD_VERSION_TYPE, FACTORY_ID, OPERATION_ID, ITEM_ID |
| Find_YieldInfo_All | Filter2 | AMEND_BOR_TABLE |
| FindBaseData | Filter | PLAN_TYPE |
| findLineCode_List | LocalFilter | LINE_ID, INSTANCE_ID, CTRL_INSTANCE, CTRL_PLAN_TYPE, PLAN_TYPE, CONFIRM_AREA, MASTER_ID, PLAN_ID, ALL_LINE, CTRL_LINE_LT |
| findLineCode_List | Filter | USER_LT, INSTANCE_ID |
| FindTotalValue | Filter2 | ITEM_ID, ITEM_NAME, ITEMNAME_ID, PRODTYPE_ID, NICKNAME_ID, CTRL_PRODUCTION_TYPE |
| FindTotalValue | Filter | ITEM_ID, ITEM_NAME, PRODTYPE_LT, NICKNAME_LT, PROD_TYPE |
| FindYieldInfo | Filter2 | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, PLAN_DATE |
| FindYieldInfo | Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID |
| FindYieldInfo | ret.Tables[0].Rows[0] | YIELD |
| GetAmendTable | Filter | PLAN_TYPE, AMEND_TABLE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_SALES_TABLE, AMEND_UTIL_TABLE, AMEND_CAPA_TABLE |
| GetBasisTime | dtPeriod.Rows[0] | BASIS_TIME |
| GetMppWpp | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, TOP_ITEM_ID, ITEM_ID |
| GetMppWpp | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, TOP_ITEM_ID, ITEM_ID |
| GetMppWpp | related_row | CATEGORY_ID, MEASURE_NAME |
| GetNickName | Filter2 | LINE_ID, CTRL_TOP_ITEM_ID, TOP_ITEM_ID, CTRL_ITEM_ID, ITEM_ID, PROD_TYPE |
| GetPlanDate | Filter | BUCKET_FROM, BUCKET_TO |
| GetPlanGroup | Filter | USER_ID, MASTER_ID, INSTANCE_ID, USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| GetPlanGroup | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| GetRoundPoint | Filter | ROUND_POINT |
| GoEditMode | Filter | DONOTEDIT |
| GoEditMode | row | DATA_TYPE, CATEGORY_ID, EDIT_YN |
| InitAmendModelELec | Filter | AMEND_INSTANCE, PLAN_DATE, AMEND_FLAG, ALL_LINE, AMEND_MAIN_FLAG, USER_ID |
| InitControlFilter | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, OMIT_ZERO |
| InitControlFilter | dtPeriod.Rows[0] | BASIS_TIME |
| InitControls | Filter | PLAN_TYPE, PLAN_DATE, UI_END_DATE, CURR_DATE, BUCKET_FROM, BUCKET_TO, MPP_WPP |
| InsertButton | Filter | DONOTEDIT |
| InsertButton | row | TOP_ITEM_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| InsertButton | popup.Filter | DIVISION_ID, SITE_ID, PLANT_ID |
| lfn_getExchangeBatch_Validation | x | FACTORY_ID, OPERATION, MODEL_ID, ITEM_ID, VERSION, CATEGORY, PROD_VERSION_TYPE |
| lfn_getExchangeBatch_Validation | clicked_row | FACTORY_ID, OPERATION_ID, PC_MODEL_ID, ITEM_ID, VERSION, PROD_VERSION_TYPE |
| lfn_getExchangeBatch_Validation | pancake_r.First() | VALUE |
| lfn_getYieldInfo | yf | LINE_ID, ITEM_ID, FACTORY_ID |
| lfn_getYieldInfo | clicked_row | LINE_ID, ITEM_ID, FACTORY_ID |
| lfn_setExchangeBatch | clicked_row | PRODUCTION_TYPE, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID |
| lfn_setExchangeBatch | dsUOMInfo.Tables[0].Rows[nExcRow] | VALUE |
| lfn_setExchangeBatch_Detail | objDs | FACTORY_ID, OPERATION_ID, PC_MODEL_ID, ITEM_ID, VERSION |
| lfn_settingValid | row | _MSG, MESSAGE, _VALID |
| lfn_settingValidRow | row | PLAN_DATE, _MSG, MESSAGE, _VALID |
| MakeMemoBold | dsMainFiltered.Tables[0].Rows[i] | CATEGORY_ID, DATA_TYPE |
| onAlarmMenu | row | PRODUCTION_TYPE |
| onAlarmMenu | frm.Filter | MEMO_TYPE |
| onNLFAmendMenu | frm.Filter | MASTER_ID, FP_PLAN_ID |
| onNLFAmendMenu | Filter | INSTANCE_ID, PLAN_ID |
| onZeroAllMenu | row | SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, LOCATION, CATEGORY_ID |
| onZeroAllMenu | row_to_test | CATEGORY_ID |
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
| Query | d | DIVISION_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, MARKET, PLAN_DATE, PRODUCTION_TYPE, SETUP_COLOR_CODE |
| Query | m | ATTR1 |
| Query | rCate | SEGMENT1, ATTRIBUTE2 |
| radioMPP_CheckedChanged | Filter | MPP_WPP |
| radioWPP_CheckedChanged | Filter | MPP_WPP |
| Save_Data | checkSave.Tables[0].Rows[0] | _TYPE |
| Save_Data | BohSet | PLAN_DATE, MASTER_ID, PLAN_ID, AMEND_CUTOFF_BOH_TABLE |
| Save_Data | Filter | PLAN_DATE, INSTANCE_ID, FP_PLAN_ID, PLAN_TYPE |
| Save_Data | row | IN_QTY_BATCH, IN_QTY_M, IN_QTY_CELL, IN_QTY_JR, IN_QTY, OUT_QTY_BATCH, OUT_QTY_M, OUT_QTY_CELL, OUT_QTY_JR, OUT_QTY |
| SaveButton | Filter | DONOTEDIT |
| SaveExcelRows | nSeq.Tables[0].Rows[0] | NEW_SEQ |
| SaveExcelRows | popupFilter | NEW_SEQ, MPP_WPP, FP_PLAN_ID, PLAN_DATE, INSTANCE_ID |
| SaveExcelRows | data.Tables[0].Rows[ii] | JOB_ORDER, NEW_SEQ |
| SaveExcelRows | dr | NEW_SEQ |
| SaveExcelRows | ro | _VALID |
| SaveExcelRows | row | JOB_ORDER, MPP_WPP, NEW_SEQ, ROUND_POINT, IN_QTY_BATCH, IN_QTY_M, IN_QTY_CELL, IN_QTY_JR, IN_QTY, OUT_QTY_BATCH, OUT_QTY_M, OUT_QTY_CELL, OUT_QTY_JR, OUT_QTY, QTY, WORK_REQUEST_MODEL_ID, PC_MODEL_ID, ADJUST_IN_QTY_BATCH |
| SaveExcelRows | Filter | ROUND_POINT |
| SaveExcelRows | BohSet | PLAN_DATE, MASTER_ID, PLAN_ID, AMEND_CUTOFF_BOH_TABLE |
| SaveExcelRows | data.Tables[0].Rows[0] | FP_PLAN_ID |
| SaveToDB | this.Filter | PLAN_TYPE, MPP_WPP |
| SaveToDB | Filter | MPP_WPP, NEW_SEQ, INSTANCE_ID, PLAN_ID |
| SaveToDB | main.Tables[0].Rows[i] | USER_ID, JOB_ORDER |
| SaveToDB | eachRow | _VALID |
| SaveToDB | dr | NEW_SEQ, INSTANCE_ID, FP_PLAN_ID |
| SaveToDB | result.Tables[0].Rows[0] | RESULT, COUNT, EXCEPTION |
| SaveToDB | valrow | _VALID, _MSG |
| SaveToDB | xlsrow | MESSAGE |
| SaveToDB | validation.Tables[0].Rows[0] | NEW_SEQ |
| SetBohQty | row | DATA_TYPE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, ITEM_ID, TOP_ITEM_ID, BOH_QTY |
| SetBohQty | matchs[0] | QTY |
| SetChangeControl | Filter | MASTER_ID, INSTANCE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PRODTYPE_ID, PRODUCTION_TYPE, PROD_TYPE |
| SetChangeControl | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| SetChangeControl | dtOperation.Rows[0] | CODE, NAME |
| SetFpPlanIdFilter | Filter | FP_PLAN_ID, PLAN_ID, PLAN_TYPE, UI_END_DATE, BUCKET_FROM, BUCKET_TO |
| SetFpPlanIdFilter | dtPlanId.Rows[0] | PLAN_ID, PLAN_TYPE, UI_END_DATE, DESCRIPTION, INSERT_ID, INSERT_Time, BASIC_VERSION, FACTORY_LT, PLAN_START_DATE, PLAN_END_DATE |
| SetMemoCell | set | BUCKET_FROM, BUCKET_TO, MEMO |
| SetMemoCell | clicked_row | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, LOCATION, CATEGORY_ID |
| SetPlannerFilter | row | NAME, DEFAULT_CHECK |
| SetPlanOutCell | clicked_row | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, PC_MODEL_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, LOCATION, CATEGORY_ID, VERSION, PROD_SEQ, PLM_EC_NO |
| SetPlanOutCell | x | FACTORY_ID, LOCATION, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ELECTRODE_TYPE, PLAN_DATE, ITEM_ID, PRODUCTION_TYPE, MARKET, WORK_REQUEST_MODEL_ID, VERSION, PLM_EC_NO, RELEASE_TYPE |
| SetPlanOutCell | newRow | INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ELECTRODE_TYPE, PRODUCTION_TYPE, MARKET, ITEM_ID, PLAN_DATE, LOCATION, RELEASE_TYPE, SEQ, WORK_REQUEST_MODEL_ID, VERSION, PROD_SEQ, PLM_EC_NO |
| SetPlanOutCell | Filter | MASTER_ID, PLAN_ID, PLAN_TYPE |
| SetPlanOutCell | ds_ListDataR | RELEASE_TYPE, SEQ |
| SetPlanOutCell | measure | chk_jr, chk_pc, chk_cell, chk_outqty, chk_batch, chk_seq |
| SetPlanOutCell | dsMainFiltered.Tables[0].Rows[idx] | SEQ |
| SetReleaseProcess | Filter | PLAN_TYPE, DONOTEDIT, CURR_DATE, RELEASE_VALUE |
| SetReleaseProcess | ds_isCurrWeek.Tables[0].Rows[0] | CURR_DATE, IS_LATEST_PLAN, RELEASE_VALUE |
| SetReleaseProcess | row | _DATE, IS_PLAN |
| SetTotalColor | row | DATA_TYPE |
| SetTotalColor | dsMainFiltered.Tables[0].Rows[line] | MAX_VER_FLAG, PSI |
| spdMain_CellClick | row | LINE_ID, PRODUCTION_TYPE, DATA_TYPE |
| spdMain_CellClick | Filter | PLAN_TYPE |
| SwitchMemo | r | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET |
| SwitchMemo | memoRow | PRODUCTION_TYPE, ITEM_ID |
| SwitchMemo | memo[k] | ITEM_ID |
| SwitchMemo | materialRow | PRODUCTION_TYPE |
| tbNickName_OnSearchConditionChanged | Filter | NICKNAME_LT, NICKNAME |
| UIFindData | Filter | PLAN_ID, FP_PLAN_ID, INSTANCE_ID, VERSION_YN, IS_PDS, DONOTEDIT, PLAN_TYPE, UI_END_DATE |
| UIFindData | Filter2 | LINE_ID, CTRL_TOP_ITEM_ID, TOP_ITEM_ID, CTRL_ITEM_ID, ITEM_ID, PROD_TYPE |
| UIFindData | row | CATEGORY_ID, RELEASE_TYPE |
| UIFindData | dtPlanId.Rows[0] | UI_END_DATE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:129, InitControl:150, Measure:215, InitControl:318, CheckAndGetMeasure:584 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| FP_Log | SaveToDB:640, SaveToDB:642, SaveToDB:702, SaveToDB:704, SaveToDB:741, SaveToDB:747, SaveToDB:753, SaveToDB:758 | DataService.FP_Log | LOGTYPE, NOTE, USER_ID |
| ReadResult | OpenAndLoadExcelData:871, Save_Data:2119, Save_Data:2126, SaveExcelRows:4818, OpenAndLoadExcelData:763 | DataService.ReadResult | COUNT, EXCEPTION, RESULT |
| CommonDefaultLineCheck | DefaultLineCheck:946, DefaultLineCheck:853 | ExcelService.CommonDefaultLineCheck | BUCKET_FROM, BUCKET_TO, MESSAGE, QTY |
| SetFilter | GetBasisTime:262, InitControlFilter:305, SetChangeControl:343, SetChangeControl:344, SetChangeControl:345, UIFindData:1100, Save_Data:2041, SetPlannerFilter:3209 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetInnerTable | SetChangeControl:337, SetChangeControl:346, SetChangeControl:354, SetChangeControl:362, SetChangeControl:370, SetChangeControl:394, GetPlanGroup:3168 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| GetCheckedListValue | SetChangeControl:341, SetChangeControl:353, SetChangeControl:361, SetChangeControl:369, SetChangeControl:378, SetChangeControl:393, SetChangeControl:401, SetChangeControl:405 | CString.GetCheckedListValue | CODE |
| LoadAmendColumn | DrawHeader:903 | MeasureService.LoadAmendColumn | DAYTAG, MONTHTAG, WEEKTAG |
| EditQuery | DrawSheet:930, Query:1023 | FPExtensions.EditQuery | ROW_ID |
| SetTotalColor | DrawSheet:949 | SpreadInfo.SetTotalColor | column_cnt, grouping_cnt, row_idx |
| GetChanges | Save_Data:1760 | FPExtensions.GetChanges | ROW_ID |
| FP_PseudoBatch2 | Save_Data:2118, Save_Data:2125 | DataService.FP_PseudoBatch2 | COUNT, EXCEPTION, RESULT |
| GetProdType | GetProdType:3280, mcbo_plant_changed:7491 | DataService.GetProdType | CODE, DIVISION_ID, NAME |
| FP_UpdateBatch | SaveExcelRows:4816 | DataService.FP_UpdateBatch | COUNT, RESULT |
| FP_PseudoBatch | call_Excel_Row_Validation:5348 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| FP_Log2 | cbo_plan_group_changed:7301, cbo_plan_group_changed:7328 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.chk_week | CheckedChanged | chk_week_CheckedChanged | InitializeComponent:109 |
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:158 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:195 |
| this | Load | MeasureSetForm_Load | InitializeComponent:209 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:210 |
| this | Load | Form_Load | .ctor:159 |
| dateRange | ValueChanged | dateRange_ValueChanged | Form_Load:174 |
| this.radioMPP | CheckedChanged | radioMPP_CheckedChanged | InitializeComponent:267 |
| this.radioWPP | CheckedChanged | radioWPP_CheckedChanged | InitializeComponent:305 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:379 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:429 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:468 |
| this.btnDownload | Click | btnDownload_Click | InitializeComponent:507 |
| this.btnUpload | Click | btnUpload_Click | InitializeComponent:546 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:757 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:758 |
| this.chk_S_batch | CheckedChanged | chk_result_in_CheckedChanged | InitializeComponent:141 |
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:326 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:364 |
| this | Load | MeasureSetForm_Load | InitializeComponent:771 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:772 |
| this | Load | Form_Load | .ctor:178 |
| cbo_plan_group | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:422 |
| mcbo_planner | SelectedIndexChanged | mcbo_planner_changed | InitEvent:423 |
| sCalendar_planday | ValueChanged | planday_changed | InitEvent:424 |
| cbo_fpplanid | SelectedIndexChanged | cbo_fpplanid_changed | InitEvent:425 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:427 |
| mcbo_site | SelectedIndexChanged | mcbo_site_changed | InitEvent:428 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:429 |
| mcbo_factory | SelectedIndexChanged | mcbo_factory_changed | InitEvent:430 |
| mcbo_operation | SelectedIndexChanged | mcbo_operation_changed | InitEvent:431 |
| mcbo_line | SelectedIndexChanged | mcbo_line_changed | InitEvent:432 |
| edt_item | TextChanged | edt_item_TextChanged | InitEvent:435 |
| mcbo_prodtype | SelectedIndexChanged | mcbo_prodtype_changed | InitEvent:438 |
| dCalendar_planrange | ValueChanged | dCalendar_changed | InitEvent:440 |
| chk_all_line | CheckedChanged | chk_allLine_CheckedChanged | InitEvent:442 |
| chk_Info | CheckedChanged | chk_Info_CheckedChanged | InitEvent:443 |
| chk_omit_zero | CheckedChanged | chk_omit_zero_CheckedChanged | InitEvent:444 |
| usrCheckBox1 | CheckedChanged | chk_includeSubOp_onchanged | InitEvent:445 |
| tbNickName | BeforeOpenSearch | tbNickName_BeforeOpenSearch | InitEvent:448 |
| tbNickName | OnSearchConditionChanged | tbNickName_OnSearchConditionChanged | InitEvent:449 |
| popSql | OnSql | RunSqlSource | btnSql_Click:2264 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick:9144 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick:9166 |
| zero_line_menu | Click | onZeroLineMenu | spdMain_CellClick:9183 |
| zero_mat_menu | Click | onZeroMaterialMenu | spdMain_CellClick:9190 |
| zero_all_line_menu | Click | onZeroAllMenu | spdMain_CellClick:9197 |
| line_change_menu | Click | onLineChangeMenu | spdMain_CellClick:9204 |
| this.btnToggleSave | Click | btnToggleSave_Click | InitializeComponent:306 |
| this.chk_Info | CheckedChanged | chk_Info_CheckedChanged_1 | InitializeComponent:431 |
| this.cbo_fpplanid | DropDown | cbo_fpplanid_DropDown | InitializeComponent:735 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:986 |
| this.btnExcelImport | Click | btnExcelImport_Click | InitializeComponent:1026 |
| this.btnSetupColor | Click | btnSetupColor_Click | InitializeComponent:1384 |
| this.btnCapaSync | Click | btnCapa_Click | InitializeComponent:1421 |
| this.btnMRP | Click | btnMRP_Click | InitializeComponent:1458 |
| this.btnReplan | Click | btnReplan_Click | InitializeComponent:1495 |
| this.btnMemo | Click | btnMemo_Click | InitializeComponent:1532 |
| this.spdMain | ClipboardChanged | spdMain_ClipboardChanged | InitializeComponent:1544 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:1545 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:1546 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:1547 |
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:1548 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:1549 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:1550 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:1551 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:1552 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:1553 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1554 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1555 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:1556 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1557 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:1558 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:1559 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:1560 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:1561 |
| this.spdMain | ClipboardChanging | spdMain_ClipboardChanging | InitializeComponent:1562 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:1563 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:1564 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:1565 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:1566 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:1567 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:1568 |
| this.button1 | Click | button1_Click | InitializeComponent:1697 |
| this.btnDppWppCopyDwSubmit | Click | btnDppWppCopyDwSubmit_Click | InitializeComponent:1883 |
| this.btnMenu | Click | btnMenu_Click | InitializeComponent:2058 |
| this.btnRelease2 | Click | btnRelease_Click | InitializeComponent:2096 |
| this.btnCreatePlan2 | Click | btnCreatePlan_Click | InitializeComponent:2134 |
| this.btn_bucket | Click | btnBucket_Click | InitializeComponent:2172 |
| this.btn_category | Click | btnCatagory_Click | InitializeComponent:2210 |
| this.btn_column | Click | btnColumn_Click | InitializeComponent:2248 |
| this.btnExportBufferData | Click | btnExportBufferData_Click | InitializeComponent:2286 |
| this.btnDWSubmit | Click | btnDwSubmit_Click | InitializeComponent:2339 |
| this | Load | Form_Load | .ctor:139 |
| dateRange | ValueChanged | dateRange_ValueChanged | Form_Load:154 |
| this.radioMPP | CheckedChanged | radioMPP_CheckedChanged | InitializeComponent:266 |
| this.radioWPP | CheckedChanged | radioWPP_CheckedChanged | InitializeComponent:304 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:378 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:428 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:467 |
| this.btnDownload | Click | btnDownload_Click | InitializeComponent:506 |
| this.btnUpload | Click | btnUpload_Click | InitializeComponent:545 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:758 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:759 |

## 6. 컨트롤 (214개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| CheckBox | 49 | chk_week_sun, chk_month, chk_week, chk_day, chk_assy_plan, chk_S_batch, chk_past_sales, chk_S_scp, chk_S_cell, chk_S_M, chk_batch_out, chk_batch, chk_cell_out, chk_jr_out, chk_cell … |
| LayoutControlItem | 40 | layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem6, layoutControlItem7, lciMpphead, lciWpp, lciMpp, layoutControlItem3, planRange, layoutControlItem16, layoutControlItem5, lblSql, layoutControlItem2, layoutControlItem29 … |
| UsrButton | 31 | usrButton1, usrButton2, btnSave, btnClose, btnFind, btnDownload, btnUpload, usrButton1, usrButton2, btnToggleSave, btnSql, btnExcelImport, btnSetupColor, btnCapaSync, btnMRP … |
| Label | 19 | label2, label1, label1, label4, label3, label2, label5, label3, txtBuilding, txtBasic, txtDesc, txtCreation, txtCreator, label7, label6 … |
| Panel | 13 | panel1, panel1, panel2, panel4, panel3, panel5, infoPanel, menuPanel, panel2, panel5, panel3, panel4, panel1 |
| UsrCheckedList2 | 8 | mcbo_line, mcbo_division, mcbo_prodtype, mcbo_operation, mcbo_factory, mcbo_plant, mcbo_planner, mcbo_site |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 6 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrLabel | 6 | usrLabel2, usrLabel1, txtPlanId, usrLabel2, usrLabel2, usrLabel1 |
| UsrRadio | 4 | radioMPP, radioWPP, radioMPP, radioWPP |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| ImageList | 3 | imageList1, imageList1, imageList1 |
| FpSpread | 3 | spdMain, spdMain, spdMain |
| SheetView | 3 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrCheckBox | 3 | usrCheckBox1, chk_Info, chk_all_line |
| EmptySpaceItem | 3 | emptySpaceItem4, emptySpaceItem5, emptySpaceItem2 |
| UsrDateRangePicker2 | 2 | dateRange, dateRange |
| UsrCombo | 2 | cbo_plan_group, cbo_fpplanid |
| Button | 2 | button1, btnExportBufferData |
| UsrDatePickerWtWeek | 1 | sCalendar_planday |
| UsrDateRangePickerWtWeek | 1 | dCalendar_planrange |
| UsrTextBox | 1 | edt_item |
| UsrPopupTextBox | 1 | tbNickName |
| SplitContainer | 1 | splitter |
| GroupBox | 1 | groupBox1 |
| TextBox | 1 | tbLog |
| DataGridView | 1 | dgEdit |

## 7. 확인 필요 (33건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 7949 | btnCreatePlan_Click | FP_Master.PR_UI_FP00598_FIND_FP00598 | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 235 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 236 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 237 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 238 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_bukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 971 | Query | FP\{?default:part_service}\AmendMemo#list_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 972 | Query | FP\{?default:part_service}\AmendMemo#list_setup_color_code | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2044 | Save_Data | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2889 | SetReleaseProcess | FP\{?default:part_service}\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3619 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3633 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3640 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_bukInfo_sun | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 4646 | call_Excel_Col_Save | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 4794 | SaveExcelRows | FP\{?default:part_service}\AmendValidation#find_save_seq | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5140 | call_Excel_Row_Save | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5306 | call_Excel_Row_Validation | FP\{?default:part_service}\AmendValidation#find_save_seq | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5372 | call_Excel_Row_Validation | FP\{?default:part_service}\FP00602_MPPWPP#find_Excel_buffer_validation | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 212 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 213 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 214 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 215 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00601_PlanAmend#find_bukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2118 | Save_Data | FP\{?default:part_service}\FP00595_MPPWPP#merge_data | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2125 | Save_Data | FP\{?default:part_service}\FP00595_MPPWPP#merge_data | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 7920 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1006 | Query | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1007 | Query | FP\{?default:part_service}\PICAlarm#find_Category_Color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 7896 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 8048 | btnRelease_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 8085 | btnRelease_Click | FP\{?default:part_service}\XpCommonAmend#find_instanceInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 8086 | btnRelease_Click | FP\{?default:part_service}\XpCommonAmend#find_planInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 8326 | btnDwSubmit_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 8387 | btnDppWppCopyDwSubmit_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5348 | call_Excel_Row_Validation | FP\{?default:part_service}\FP00602_MPPWPP#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 47 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 87 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 28 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00598 | Amend | 30/16 | 30/16 | 30/16 | 30/16 | 30/16 | 30/16 | 30/16 | 30/16 | 30/16 | 30/16 | 30/16 | 30/16 | 30/16 | 30/16 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: AutoExcelPopup, Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@DrawHeader:842
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| FindData |  | 400 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(DoSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 401 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(DoSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 402 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(DoSearchData != null) ⟫ if(AutoCHK) |
| InitializeComponent |  | 774 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 775 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 776 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 777 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetCalenderColor |  | 721 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 727 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| spdMain_CellDoubleClick |  | 8964 | 표시/라벨 변경 | set:Visible | Visible = {?!spdMain.ActiveSheet.Columns[idx].Visible} |  | else!(!sHeadNameLevel2.Equals("Week Sum")) ⟫ for(idx < iWeekCount) |
| InitializeComponent |  | 1584 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1585 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1586 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1587 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| FindData |  | 386 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(DoSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 387 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(DoSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 388 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(DoSearchData != null) ⟫ if(AutoCHK) |
| InitializeComponent |  | 775 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 776 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 777 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 778 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
