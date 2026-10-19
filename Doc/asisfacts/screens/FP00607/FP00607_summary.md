# FP00607 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00607_PlanAmend_Model_Formation.UIL\FP00607_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00607_PlanAmend_Model_Formation.UIL\FP00607_PlanAmend_Model_Formation.UIL.csproj | 465 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00607_PlanAmend_Model_Formation.UIL\FP00607_MeasureSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00607_PlanAmend_Model_Formation.UIL\FP00607_PlanAmend_Model_Formation.UIL.csproj | 667 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00607_PlanAmend_Model_Formation.UIL\FP00607_PlanAmend_Model_Formation.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00607_PlanAmend_Model_Formation.UIL\FP00607_PlanAmend_Model_Formation.UIL.csproj | 9038 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00607_PlanAmend_Model_Formation.UIL\FP00607_PlanAmend_Model_Formation.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00607_PlanAmend_Model_Formation.UIL\FP00607_PlanAmend_Model_Formation.UIL.csproj | 2605 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00607_PlanAmend_Model_Formation.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00607_PlanAmend_Model_Formation.UIL\FP00607_PlanAmend_Model_Formation.UIL.csproj | 37 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00607_ExcelPopup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 1077 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00607_ExcelPopup.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 659 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00607_ItemPopup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 396 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00607_ItemPopup.Designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 455 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00607_LineAddPopup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 921 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00607_LineAddPopup.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 2077 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00607_RowExcelPopup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 1113 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00607_RowExcelPopup.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 646 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:bucke_menu.Click | onZeroBucketMenu > EditByFunc > EditCommon | 5040 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:bucke_menu.Click | onZeroBucketMenu > EditByFunc > EditCommon > SetShipPlan_DataSet | 6138 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:bucke_menu.Click | onZeroBucketMenu > EditByFunc > EditCommon > SetShortLT_DataSet | 6339 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_fpplanid.MouseClick | Cbo_fpplanid_MouseClick | 329 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed > SetChangeControl | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed > SetChangeControl | 463 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed | 3740 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed | 3740 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetPlanner > mcbo_planner_changed > SetChangeControl | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetPlanner > mcbo_planner_changed > SetChangeControl | 463 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetFpPlanId > SetBasisTime | 5513 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetPlanner | 5537 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetPlanner | 5539 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetFpPlanId | 5631 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 463 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:dpPlanDate.ValueChanged | dpPlanDate_ValueChanged | 626 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=check_plan_date_limit] | BIZ_MATCH |  |
| event:dpPlanDate.ValueChanged | dpPlanDate_ValueChanged | 626 | FP\Planning\PlanControl#check_plan_date_limit | MATCH | [sql] foxquery_sql\FP_Planning_planControl_check_plan_date_limit.sql |
| button:FindButton | FindButton > FindData > Find_Data_Item | 271 | FP_Planning.PR_UI_FP00607_ADD_LINE | MATCH | SP PR_UI_FP00607_ADD_LINE |
| button:FindButton | FindButton > UIFindData > FindTotalValue | 1232 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 1378 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 1456 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1501 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1503 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1505 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1507 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1510 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > GetListDataSet | 1569 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > GetListDataSet | 1573 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > GetListDataSet | 1577 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > GetListDataSet | 1581 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > GetListDataSet | 1584 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| button:InsertButton | InsertButton > UIFindData > FindTotalValue | 1232 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend | 1378 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 1456 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1501 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1503 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1505 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1507 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1510 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > GetListDataSet | 1569 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > GetListDataSet | 1573 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > GetListDataSet | 1577 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > GetListDataSet | 1581 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > GetListDataSet | 1584 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetChangeControl | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetChangeControl | 463 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetChangeControl | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetChangeControl | 463 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_line.SelectedIndexChanged | mcbo_line_changed > SetChangeControl | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_line.SelectedIndexChanged | mcbo_line_changed > SetChangeControl | 463 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetChangeControl | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetChangeControl | 463 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_planner.SelectedIndexChanged | mcbo_planner_changed > SetChangeControl | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_planner.SelectedIndexChanged | mcbo_planner_changed > SetChangeControl | 463 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetChangeControl | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetChangeControl | 463 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed | 3759 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed | 3759 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_changed > SetChangeControl | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_changed > SetChangeControl | 463 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > GetOperation | 9032 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:menu_material.Click | onZeroMaterialMenu > EditByFunc > EditCommon | 5040 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:menu_material.Click | onZeroMaterialMenu > EditByFunc > EditCommon > SetShipPlan_DataSet | 6138 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:menu_material.Click | onZeroMaterialMenu > EditByFunc > EditCommon > SetShortLT_DataSet | 6339 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Save_Data_Add | 572 | FP_Planning.PR_UI_FP00607_ADD_LINE | MATCH | SP PR_UI_FP00607_ADD_LINE |
| event:popSql.OnSql | RunSqlSource > FindTotalValue | 1232 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| event:popSql.OnSql | RunSqlSource > Find_Data_CWA_Minus_Activated | 1298 | FP_Planning.PR_UI_FP00607_AMEND_LINE | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 1378 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| event:popSql.OnSql | RunSqlSource > ApplySearchCondition | 1456 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1501 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1503 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1505 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1507 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1510 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > GetListDataSet | 1569 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > GetListDataSet | 1573 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > GetListDataSet | 1577 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > GetListDataSet | 1581 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > GetListDataSet | 1584 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Save_Data_Shorter | 3032 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | MATCH | SP PR_UI_FP00607_AMEND_MODEL_SAVE |
| event:popSql.OnSql | RunSqlSource > Save_Data_Amend | 3412 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | MATCH | SP PR_UI_FP00607_AMEND_MODEL_SAVE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 7493 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 7495 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 7497 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 7499 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 7505 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Excel_Import | 7692 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL_EXCEL |
| button:SaveButton | SaveButton > UIFindData > FindTotalValue | 1232 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| button:SaveButton | SaveButton > Find_Data_CWA_Minus_Activated | 1298 | FP_Planning.PR_UI_FP00607_AMEND_LINE | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend | 1378 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 1456 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1501 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1503 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1505 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1507 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1510 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > GetListDataSet | 1569 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > GetListDataSet | 1573 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > GetListDataSet | 1577 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > GetListDataSet | 1581 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > GetListDataSet | 1584 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| button:SaveButton | SaveButton > Save_ShipPlan | 2641 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > Save_ShipPlan > Save_Data_ShipPlan | 2793 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | MATCH | SP PR_UI_FP00607_AMEND_MODEL_SAVE |
| button:SaveButton | SaveButton > Save_Shorter | 2880 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > Save_Shorter > Save_Data_Shorter | 3032 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | MATCH | SP PR_UI_FP00607_AMEND_MODEL_SAVE |
| button:SaveButton | SaveButton > Save_P_Out | 3261 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > Save_P_Out > Save_Data_Amend | 3412 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | MATCH | SP PR_UI_FP00607_AMEND_MODEL_SAVE |
| button:SaveButton | SaveButton > Run_Parallels > Exec_Procedure | 3533 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | MATCH | SP PR_UI_FP00607_AMEND_MODEL_SAVE |
| event:sCalendar_planday.DateTimeChanged | planday_changed > SetFpPlanId > SetBasisTime | 5513 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:sCalendar_planday.DateTimeChanged | planday_changed > SetFpPlanId | 5631 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindTotalValue | 1232 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 1378 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1456 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1501 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1503 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1505 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1507 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1510 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > GetListDataSet | 1569 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > GetListDataSet | 1573 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > GetListDataSet | 1577 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > GetListDataSet | 1581 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > GetListDataSet | 1584 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > Find_Data_Item | 271 | FP_Planning.PR_UI_FP00607_ADD_LINE | MATCH | SP PR_UI_FP00607_ADD_LINE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > FindTotalValue | 1232 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 1378 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1456 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1501 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1503 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1505 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1507 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1510 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > GetListDataSet | 1569 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > GetListDataSet | 1573 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > GetListDataSet | 1577 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > GetListDataSet | 1581 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > GetListDataSet | 1584 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetPlanner > mcbo_planner_changed > SetChangeControl | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetPlanner > mcbo_planner_changed > SetChangeControl | 463 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > FindTotalValue | 1232 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend | 1378 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1456 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1501 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1503 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1505 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1507 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1510 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > GetListDataSet | 1569 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > GetListDataSet | 1573 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > GetListDataSet | 1577 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > GetListDataSet | 1581 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > GetListDataSet | 1584 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click | 4142 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetFpPlanId > SetBasisTime | 5513 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetPlanner | 5537 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetPlanner | 5539 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetFpPlanId | 5631 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindTotalValue | 1232 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| event:this.btnExcelImport.Click | btnExcelImport_Click > Find_Data_CWA_Minus_Activated | 1298 | FP_Planning.PR_UI_FP00607_AMEND_LINE | NOT_IN_FOXQUERY |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend | 1378 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1456 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1501 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1503 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1505 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1507 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1510 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > GetListDataSet | 1569 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > GetListDataSet | 1573 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > GetListDataSet | 1577 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > GetListDataSet | 1581 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > GetListDataSet | 1584 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > Run_Parallels > Exec_Procedure | 3533 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | MATCH | SP PR_UI_FP00607_AMEND_MODEL_SAVE |
| event:this.btnExcelImport.Click | btnExcelImport_Click | 4494 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnLine.Click | btnLine_Click | 746 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnMRP.Click | btnMRP_Click | 4081 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnMRP.Click | btnMRP_Click | 4110 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH |  |
| event:this.btnMRP.Click | btnMRP_Click | 4110 | FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql |
| event:this.btnRelease2.Click | btnRelease_Click | 4223 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click | 4224 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click | 4235 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click | 4255 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click | 4258 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > FindTotalValue | 1232 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > Find_Data_Amend | 1378 | FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | SP PR_UI_FP00607_AMEND_MODEL |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1456 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1501 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1503 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1505 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1507 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1510 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > GetListDataSet | 1569 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > GetListDataSet | 1573 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > GetListDataSet | 1577 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > GetListDataSet | 1581 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > GetListDataSet | 1584 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnRePlan.Click | btnRePlan_Click | 4024 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 360 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 367 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 414 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Add | 572 | FP_Planning.PR_UI_FP00607_ADD_LINE | MATCH | SP PR_UI_FP00607_ADD_LINE |
| event:this.btnSave.Click | btnSave_Click > SaveToDB > Exec_Procedure | 950 | FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00622_AMEND_LINE_SAVE |
| event:this.btnSimulation.Click | btnSimulation_Click > Find_Data_CWA_Minus_Activated | 1298 | FP_Planning.PR_UI_FP00607_AMEND_LINE | NOT_IN_FOXQUERY |  |
| event:this.btnSimulation.Click | btnSimulation_Click > Save_Shorter | 2880 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnSimulation.Click | btnSimulation_Click > Save_Shorter > Save_Data_Shorter | 3032 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | MATCH | SP PR_UI_FP00607_AMEND_MODEL_SAVE |
| event:this.btnSimulation.Click | btnSimulation_Click > Exec_Procedure | 3533 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | MATCH | SP PR_UI_FP00607_AMEND_MODEL_SAVE |
| event:this.btnSimulation.Click | btnSimulation_Click | 4408 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.chk_includeSubOp.CheckedChanged | chk_includeSubOp_onchanged > SetChangeControl | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.chk_includeSubOp.CheckedChanged | chk_includeSubOp_onchanged > SetChangeControl | 463 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.dpPlanDate.ValueChanged | dpPlanDate_ValueChanged | 626 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=check_plan_date_limit] | BIZ_MATCH |  |
| event:this.dpPlanDate.ValueChanged | dpPlanDate_ValueChanged | 626 | FP\Planning\PlanControl#check_plan_date_limit | MATCH | [sql] foxquery_sql\FP_Planning_planControl_check_plan_date_limit.sql |
| event:this.Load | Form_Load > InitControls | 146 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=check_plan_date_limit] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 146 | FP\Planning\PlanControl#check_plan_date_limit | MATCH | [sql] foxquery_sql\FP_Planning_planControl_check_plan_date_limit.sql |
| event:this.Load | MeasureSetForm_Load > InitControl | 197 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > mcbo_line_changed > SetChangeControl | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > mcbo_line_changed > SetChangeControl | 463 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > cbo_fpplanid_changed | 3740 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > cbo_fpplanid_changed | 3740 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > mcbo_plant_changed | 3759 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > mcbo_plant_changed | 3759 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > cbo_plan_group_changed > SetFpPlanId > SetBasisTime | 5513 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > cbo_plan_group_changed > SetPlanner | 5537 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > cbo_plan_group_changed > SetPlanner | 5539 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > cbo_plan_group_changed > SetFpPlanId | 5631 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1820 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1821 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1855 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1856 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > GetOperation | 9032 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.Change | spdMain_Change > EditByChange > EditCommon | 5040 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.Change | spdMain_Change > EditByChange > EditCommon > SetShipPlan_DataSet | 6138 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.Change | spdMain_Change > EditByChange > EditCommon > SetShortLT_DataSet | 6339 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 149 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Exec_PSI_Calculation | 3474 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | MATCH | SP PR_UI_FP00607_AMEND_MODEL_SAVE |
| unreached:(진입점 미연결) | ExcelPopup_CheckBeforSave | 7563 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | ExcelPopup_CheckBeforSave | 7581 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer | 8116 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer | 8116 | FP\Common\FP00607_ExcelImport#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer_Old | 8224 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE | MATCH | SP PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE |
| unreached:(진입점 미연결) | Find_Data_Excel_Buffer_Valid | 8277 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE | MATCH | SP PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE |
| unreached:(진입점 미연결) | Save_Data_Excel_Column | 8337 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE | MATCH | SP PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE |
| unreached:(진입점 미연결) | Save_Data_Excel_Row | 8398 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE | MATCH | SP PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE |
| unreached:(진입점 미연결) | Delete_Data_Excel_Buffer | 8438 | FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE | MATCH | SP PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=check_plan_date_limit] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 45 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00607_ADD_LINE | MATCH | 2 | SP PR_UI_FP00607_ADD_LINE | EXEC:PR_UI_FP00607_ADD_LINE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00607_AMEND_LINE | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Planning.PR_UI_FP00607_AMEND_MODEL | MATCH | 2 | SP PR_UI_FP00607_AMEND_MODEL | EXEC:PR_UI_FP00607_AMEND_MODEL | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL | MATCH | 1 | SP PR_UI_FP00607_AMEND_MODEL_EXCEL | EXEC:PR_UI_FP00607_AMEND_MODEL_EXCEL | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE | MATCH | 5 | SP PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE | EXEC:PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | MATCH | 5 | SP PR_UI_FP00607_AMEND_MODEL_SAVE | EXEC:PR_UI_FP00607_AMEND_MODEL_SAVE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | 1 | SP PR_UI_FP00622_AMEND_LINE_SAVE | EXEC:PR_UI_FP00622_AMEND_LINE_SAVE | ⚠ DB에 SP 없음 |
| FP\Common\AmendMemo#list_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql | SELECT:FP_AMEND_MEMO_M, SELECT:FP_AMEND_SETUP_COLOR_M |  |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 3 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\FP00607_ExcelImport#insert_Excel_buffer | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\PICAlarm#find_Category | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql | UPDATE:SCM_FP_PLAN_H |  |
| FP\Planning\PlanControl#check_plan_date_limit | MATCH | 2 | [sql] foxquery_sql\FP_Planning_planControl_check_plan_date_limit.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO, CATE_VALUE, CATE_TYPE |
| ApplyAmendCalendarCondition | row | MEA_ID, MEA_VALUE |
| ApplyAmendCalendarCondition_ForExcel | Filter | BUCKET_FROM, PLAN_DATE, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO, CATE_VALUE, CATE_TYPE |
| ApplySearchCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, INSTANCE_ID, PLAN_ID, AMEND_TABLE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_SALES_TABLE, AMEND_UTIL_TABLE, PLAN_TYPE, MASTER_ID |
| btnBucket_Click | Application.OpenForms | FP00599_BucketSetForm_Popup |
| btnCatagory_Click | Application.OpenForms | FP00607_MeasureSetForm_Popup |
| btnColumn_Click | Application.OpenForms | FPC0097_ColumnSetForm_Popup |
| btnCreatePlan_Click | Filter | SITE_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE |
| btnCreatePlan_Click | dtPlanRunFlag.Rows[0] | PLAN_ID, INSERT_ID |
| btnCreatePlan_Click | Application.OpenForms | FP00590_PlanTotalPopup |
| btnExcelImport_Click | Filter | PLAN_TYPE, INSTANCE_ID, PLAN_DATE |
| btnExcelImport_Click | Application.OpenForms | FPC0095_ExcelSelect_Popup |
| btnExcelImport_Click | colPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LINE_ID |
| btnExcelImport_Click | colPopup.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, CELL_GROUP_CODE, ITEM_ID, NICK_NAME, ITEM_TYPE, OPERATION_ID, FACTORY_ID, LOCATION, MARKET, PRODUCTION_TYPE, LINE_ID, LINE_NAME, ELECTRODE_TYPE |
| btnExcelImport_Click | rowPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LINE_ID, PLAN_DATE, QTY |
| btnExcelImport_Click | rowPopup.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, CELL_GROUP_CODE, ITEM_ID, NICK_NAME, ITEM_TYPE, OPERATION_ID, FACTORY_ID, LOCATION, MARKET, PRODUCTION_TYPE, LINE_ID, LINE_NAME, ELECTRODE_TYPE, PLAN_DATE, QTY, MESSAGE |
| btnLine_Click | Filter | DATE, INSTANCE_ID, PLAN_ID, SITE_ID, CONFIRM_AREA, RELEASE_VALUE, DIVISION_ID, PLANT_ID, FACTORY_ID, LINE_ID, PLAN_TYPE, OPERATION_ID, ELECTRODE_TYPE, LOCATION |
| btnLine_Click | dtCurrWeek.Rows[0] | RELEASE_VALUE |
| btnLine_Click | popup.Filter | INSTANCE_ID, PLAN_DATE, PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, PLAN_TYPE, RELEASE_VALUE, CONFIRM_AREA, OPERATION_ID, FORM_OPERATION_ID |
| btnLine_Click | data | FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, LOCATION |
| btnMaterial_Click | popup.Filter | CELL_GROUP_CODE, FROM_OPERATION_ID |
| btnMaterial_Click | Filter | CELL_GROUP_CODE, ITEM_ID, NICK_NAME, ITEM_TYPE, TOP_ITEM_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, LOCATION |
| btnMaterial_Click | data | CELL_GROUP_CODE, ITEM_ID, NICK_NAME, ITEM_TYPE, MODEL_ID |
| btnMemo_Click | Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID |
| btnMemo_Click | memoPopup.Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, MODEL_ID, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID, USER_ID |
| btnMRP_Click | Filter | INSTANCE_ID, PLAN_ID, PLAN_TYPE, MASTER_ID |
| btnMRP_Click | dtAuthChk.Rows[0] | AUTH_YN |
| btnRelease_Click | Filter | SITE_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, DESCRIPTION, PLAN_ID |
| btnRelease_Click | dtPlanInfo.Rows[0] | DESCRIPTION |
| btnRelease_Click | dtEngineFlag.Rows[0] | INBOUND, ENGINE, OUTBOUND |
| btnRelease_Click | dtPlanRunFlag.Rows[0] | PLAN_ID, INSERT_ID |
| btnRelease_Click | dtParam2.Rows[0] | CONFIRM_AREA, IS_SAME_PLAN_ID, USE_WOW_STATUS |
| btnRelease_Click | Application.OpenForms | FP00590_GroupReleaseTotalPopup, FP00590_ReleaseTotalPopup |
| btnRePlan_Click | Filter | PLAN_TYPE, PLAN_ID, INSTANCE_ID, FP_SITE_ID, MASTER_ID, PLAN_DATE, CONFIRM_AREA, IS_SAME_PLAN_ID, USE_WOW_STATUS |
| btnRePlan_Click | dtPlanRunFlag.Rows[0] | CNT, PLAN_ID, INSERT_ID |
| btnRePlan_Click | Application.OpenForms | FP00590_RePlanTotalPopup |
| btnSimulation_Click | Filter | READ_ONLY, PLAN_ID, INSTANCE_ID, PLAN_DATE |
| btnSimulation_Click | dtChk.Rows[0] | _TYPE |
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| CbMPP_CheckedChanged | Filter | MPP_WPP |
| cbo_fpplanid_changed | dtPlanId.Rows[selected] | PLAN_START_DATE, PLAN_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME, CODE, INSERT_ID, INSERT_TIME, DESCS, BASIC_VERSION, FACTORY_LT |
| cbo_fpplanid_changed | Filter | PLAN_TYPE |
| CbWPP_CheckedChanged | Filter | MPP_WPP |
| chk_includeSubOp_onchanged | Filter | AMEND_MAIN_FLAG |
| CreateDataLine | material_column | P_IN, P_IN_CELL, P_OUT, P_OUT_CELL |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_past_sales, chk_target, chk_cellBiz, chk_packSemi, chk_shipPlanPlanner, chk_carryOver, chk_shipResult, chk_memo, chk_wip, chk_wipSim, chk_pkgProcDate, chk_wipBD, chk_wipSimBD, chk_pkgQty, chk_wipAD, chk_wipSimAD, chk_actSim, chk_act, chk_calAgingQty, chk_mpp_inqty, chk_mpp_outqty, chk_wpp_inqty, chk_wpp_outqty, chk_inqty, chk_yield, chk_outqty, chk_result, chk_inventory, chk_inventory_simul, chk_total, chk_total_2 |
| CreateFilterDataSet | x | _MM_ |
| dpPlanDate_ValueChanged | dtCheckPlanDate.Rows[0] | CREATE_PLAN_FIX_DATE |
| dpPlanDate_ValueChanged | Filter | PLAN_DATE |
| DrawHeader | Filter | BUCKET_FROM |
| DrawHeader | measure.Data | chk_day, chk_week, chk_month |
| DrawSheet | Filter | DONOTEDIT |
| EditCommon | curRow | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID |
| EditCommon | dtValid.Rows[0] | AFTER_DEGAS_LT |
| ExcelPopup_BufferValidation_Column | filter | MPP_WPP |
| ExcelPopup_BufferValidation_Column | Filter | PLAN_TYPE, INSTANCE_ID, PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, CONFIRM_AREA, RELEASE_VALUE |
| ExcelPopup_BufferValidation_Column | dateMap.Tables[0].Rows[j] | _DATE |
| ExcelPopup_BufferValidation_Column | newrow | INSTANCE_ID, PLAN_DATE, PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ITEM_ID, LOCATION, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, QTY, USER_ID, JOB_ORDER |
| ExcelPopup_BufferValidation_Column | data.Tables[0].Rows[i] | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ITEM_ID, LOCATION, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE |
| ExcelPopup_BufferValidation_Column | each_row | _VALID |
| ExcelPopup_BufferValidation_Row | filter | MPP_WPP |
| ExcelPopup_BufferValidation_Row | data.Tables[0].Rows[i] | QTY, PLAN_DATE, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ITEM_ID, LOCATION, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE |
| ExcelPopup_BufferValidation_Row | newrow | INSTANCE_ID, PLAN_DATE, PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ITEM_ID, LOCATION, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, QTY, USER_ID, JOB_ORDER |
| ExcelPopup_BufferValidation_Row | Filter | INSTANCE_ID, PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, CONFIRM_AREA, RELEASE_VALUE |
| ExcelPopup_BufferValidation_Row | each_row | _VALID |
| ExcelPopup_CheckBeforSave | Filter | PLAN_TYPE, INSTANCE_ID, PLAN_ID, SITE_ID, CONFIRM_AREA, PLAN_DATE |
| ExcelPopup_CheckBeforSave | dtIsCurrWeek.Rows[0] | IS_LATEST_PLAN, RELEASE_PLAN_ID, RELEASE_VALU |
| ExcelPopup_CheckBeforSave | dtChk.Rows[0] | _TYPE |
| ExcelPopup_SaveExcel_Column | filter | MPP_WPP |
| ExcelPopup_SaveExcel_Row | filter | MPP_WPP |
| ExcelPopup_Search_Column | Filter | BUCKET_FROM, BUCKET_TO |
| ExcelPopup_Search_Column | filter | MPP_WPP |
| ExcelPopup_Search_Row | Filter | BUCKET_FROM, BUCKET_TO |
| ExcelPopup_Search_Row | filter | MPP_WPP |
| Exec_Procedure | Filter | INSTANCE_ID, PLAN_ID |
| Exec_Procedure | this.Filter | INSTANCE_ID, PLAN_ID |
| Exec_PSI_Calculation | Filter | INSTANCE_ID, PLAN_ID |
| Find_Data_Amend | Filter | AMEND_TABLE, PLAN_TYPE, INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, MASTER_ID, PLAN_DATE, PLAN_ID, PROD_TYPE, ITEM_ID, NICK_NAME, NICK_NAME_LT, CELL_GROUP, CELL_GROUP_CODE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, CATE_INFO, CATE_VALUE, CATE_TYPE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_SALES_TABLE, AMEND_UTIL_TABLE |
| Find_Data_CWA_Minus_Activated | Filter | AMEND_TABLE, PLAN_TYPE, INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, MASTER_ID, PLAN_DATE, PLAN_ID, PROD_TYPE, ITEM_ID, NICK_NAME, NICK_NAME_LT, CELL_GROUP, CELL_GROUP_CODE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, CATE_INFO, CATE_VALUE, CATE_TYPE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_SALES_TABLE, AMEND_UTIL_TABLE |
| Find_Data_Item | Filter | INSTANCE_ID, DATE, PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, FROM_OPERATION_ID |
| Find_Line_Savings_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | related_row | CATEGORY_ID, PRODUCTION_TYPE |
| Find_MaterialData_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | related_row | CATEGORY_ID |
| FindData | Filter | BUCKET_FROM, BUCKET_TO, MPP_WPP |
| FindData | this.Filter | PLAN_TYPE |
| FindTotalValue | Filter | AMEND_TABLE, PLAN_TYPE, INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, MASTER_ID, PLAN_DATE, PLAN_ID, PROD_TYPE, ITEM_ID, NICK_NAME, NICK_NAME_LT, CELL_GROUP, CELL_GROUP_CODE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, CATE_INFO, CATE_VALUE, CATE_TYPE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_SALES_TABLE, AMEND_UTIL_TABLE |
| GetListDataSet | Filter | AMEND_TABLE, PLAN_TYPE, INSTANCE_ID, PLAN_ID, OPERATION_ID, PLAN_DATE, AMEND_CUTOFF_BOH_TABLE, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID |
| GetOperation | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, AMEND_MAIN_FLAG, OPERATION_ID |
| GoEditMode | Filter | PLAN_ID |
| GoEditMode | row | DATA_TYPE, PSI, CATEGORY_ID, EDIT_YN |
| GoEditModeShortLT | Filter | PLAN_ID, PLAN_TYPE |
| GoEditModeShortLT | row | S_ROW, PSI, FACTORY_ID, LINE_ID, SHORTER_LEAD_TIME |
| GoEditModeShortLT | current_src.Rows[i] | PSI, FACTORY_ID, LINE_ID, SHORTER_LEAD_TIME |
| InitControls | Filter | USER_ID, MASTER_ID, INSTANCE_ID, TOP_ITEM_ID, CELL_GROUP_CODE, PLAN_DATE, DATE, NICK_NAME, OPERATON_ID, PRODUCTION_TYPE, ITEM_TYPE, ITEM_ID, FACTORY_ID, ELECTRODE_TYPE, LOCATION, PLAN_TYPE, MPP_WPP, PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, LINE_ID, OPERATION_ID, FROM_OPERATION_ID, UI_END_DATE, BUCKET_FROM, CURR_DATE, BUCKET_TO |
| InitControls | InitRow | CELL_GROUP_CODE, NICK_NAME, OPERATION_ID, ITEM_TYPE, TOP_ITEM_ID, ITEM_ID, FACTORY_ID, ELECTRODE_TYPE, LOCATION |
| InitControls | dtCheckPlanDate.Rows[0] | CREATE_PLAN_FIX_DATE |
| InitControls | this.Filter | PLAN_TYPE, BUCKET_FROM, CURR_DATE, BUCKET_TO |
| Insert_Data_Excel_Buffer | result.Rows[0] | RESULT, EXCEPTION |
| Insert_Data_Excel_Buffer_Old | dsData.Tables[0].Rows[i] | INSTANCE_ID, PLAN_DATE, PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, PRODUCTION_TYPE, LOCATION, MARKET, ELECTRODE_TYPE, CELL_QTY, QTY, NEW_SEQ, MPP_WPP |
| InsertButton | row | DATA_TYPE, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID |
| InsertButton | popup.Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID |
| lfn_setAvailability | dsMainFiltered.Tables[0].Rows[nDefRow] | FORMATION_TOTAL_YIELD |
| lfn_setAvailability | measure | chk_act, chk_actSim, chk_outqty |
| lfn_setAvailability | dsMainFiltered.Tables[0].Rows[nStartRow] | LV1, LINE_ID |
| lfn_setAvailability | dsMainFiltered.Tables[0].Rows[i] | LV1, LINE_ID, DATA_TYPE, CATEGORY_ID |
| lfn_setEOH | measure | chk_inventory, chk_target, chk_carryOver, chk_outqty |
| lfn_setEOH | dsMainFiltered.Tables[0].Rows[nStartRow] | LV1, PLANt_ID, BOH |
| lfn_setEOH | dsMainFiltered.Tables[0].Rows[i] | LV1, PLANT_ID, DATA_TYPE, CATEGORY_ID |
| lfn_setEOH | dsMainFiltered.Tables[0].Rows[idx] | LV1, PLANT_ID, DATA_TYPE, CATEGORY_ID |
| lfn_setEOH | dsMainFiltered.Tables[0].Rows[nArrTmp] | FACTORY_ID, OPERATION_ID, ITEM_ID |
| lfn_setEOH | dsBodLT.Tables[0].Rows[idx] | FACTORY_ID, OPERATION_ID, ITEM_ID |
| lfn_setEOH | dsBodLT.Tables[0].Rows[nLT_tmp_row] | MOVING_TIME_DAY |
| lfn_setEOH | dateMap.Tables[0].Rows[iRow] | D_VALUE, _DATE, IS_PLAN |
| lfn_setEOH | Filter | PLAN_DATE |
| lfn_setEOH | dateMap.Tables[0].Rows[k] | D_VALUE, IS_PLAN |
| lfn_setEOH_ShipmentPlan | measure | chk_inventory_simul, chk_shipPlanPlanner, chk_carryOver, chk_outqty |
| lfn_setEOH_ShipmentPlan | dsMainFiltered.Tables[0].Rows[nStartRow] | LV1, PLANT_ID, BOH |
| lfn_setEOH_ShipmentPlan | dsMainFiltered.Tables[0].Rows[i] | LV1, PLANT_ID, DATA_TYPE, CATEGORY_ID |
| lfn_setEOH_ShipmentPlan | dsMainFiltered.Tables[0].Rows[nArrTmp] | LV1, PLANT_ID, DATA_TYPE, CATEGORY_ID, FACTORY_ID, OPERATION_ID, ITEM_ID |
| lfn_setEOH_ShipmentPlan | dsBodLT.Tables[0].Rows[nStartRow] | FACTORY_ID, OPERATION_ID, ITEM_ID |
| lfn_setEOH_ShipmentPlan | dsBodLT.Tables[0].Rows[nLT_tmp_row] | MOVING_TIME_DAY |
| lfn_setEOH_ShipmentPlan | dsBodLT.Tables[0].Rows[nArrTmp] | FACTORY_ID |
| lfn_setEOH_ShipmentPlan | dateMap.Tables[0].Rows[iRow] | D_VALUE, _DATE, IS_PLAN |
| lfn_setEOH_ShipmentPlan | Filter | PLAN_DATE |
| lfn_setEOH_ShipmentPlan | dateMap.Tables[0].Rows[k] | D_VALUE, IS_PLAN |
| MakeMemoFontBold | dsMainFiltered.Tables[0].Rows[i] | CATEGORY_ID |
| MakeMemoFontBold | Filter | PLAN_TYPE |
| onNLFAmendMenu | frm.Filter | MASTER_ID, FP_PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onNLFAmendMenu | Filter | INSTANCE_ID, PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onZeroBucketMenu | row_to_test | CATEGORY_ID |
| onZeroLineMenu | Filter | PLAN_ID, PLAN_TYPE |
| onZeroLineMenu | row | LINE_ID, DIVISION_ID, SITE_ID, FACTORY_ID |
| onZeroLineMenu | dsMainFiltered.Tables[0].Rows[i] | DATA_TYPE, LINE_ID, DIVISION_ID, SITE_ID, FACTORY_ID |
| onZeroLineMenu | row_to_test | CATEGORY_ID, DATA_TYPE |
| onZeroMaterialMenu | Filter | PLAN_ID, PLAN_TYPE |
| onZeroMaterialMenu | row | DIVISION_ID, SITE_ID, FACTORY_ID, LINE_ID, ITEM_ID |
| onZeroMaterialMenu | dsMainFiltered.Tables[0].Rows[i] | DATA_TYPE, DIVISION_ID, SITE_ID, FACTORY_ID, LINE_ID, ITEM_ID |
| onZeroMaterialMenu | row_to_test | CATEGORY_ID, DATA_TYPE |
| OpenAlarmMemo | row | PRODUCTION_TYPE |
| OpenAlarmMemo | frm.Filter | MEMO_TYPE |
| OpenLineMemo | frm.Filter | MEMO_TYPE, COMPANY_ID |
| OpenLineMemo | row | COMPANY_ID |
| OpenMaterialMemo | frm.Filter | MEMO_TYPE, COMPANY_ID |
| OpenMaterialMemo | row | COMPANY_ID |
| planday_changed | Filter | PLAN_DATE |
| Query | d | DIVISION_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, MARKET, PLAN_DATE, PRODUCTION_TYPE, SETUP_COLOR_CODE |
| Query | m | ATTR1 |
| Query | rCate | SEGMENT1, ATTRIBUTE2 |
| RunSqlSource | Filter | PLAN_TYPE |
| Save_Data | Filter | PLAN_TYPE, INSTANCE_ID, DATE, PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID, OPERATION_ID, FACTORY_ID, LINE_ID, PLAN_DATE, FROM_OPERATION_ID, ITEM_TYPE, PRODUCTION_TYPE, NICK_NAME, MPP_WPP |
| Save_Data | dup.Rows[0] | CNT |
| Save_Data | dtCheckSave.Rows[0] | _TYPE |
| Save_Data_Add | dtSave.Rows[0] | INSTANCE_ID, DATE, PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, FROM_OPERATION_ID, ITEM_ID, TOP_ITEM_ID, ITEM_TYPE, LOCATION, PRODUCTION_TYPE, ELECTRODE_TYPE, QTY, MPP_WPP |
| Save_Data_Amend | dtData.Rows[i] | ACTION, INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, MARKET, LOCATION, ELECTRODE_TYPE, CUSTOMER_ID, OUT_QTY |
| Save_Data_ShipPlan | dtData.Rows[i] | ACTION, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, MARKET, LOCATION, ELECTRODE_TYPE, SALE_SIMUL_QTY |
| Save_Data_Shorter | dtData.Rows[i] | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ITEM_ID, SHORTER_LT |
| Save_P_Out | row | CATEGORY_ID |
| Save_P_Out | Filter | INSTANCE_ID, FP_PLAN_ID, PLAN_TYPE, PLAN_DATE |
| Save_P_Out | enum_row_from_Saving | EDATE, CATEGORY_ID, EQTY, DIVISION_ID, SITE_ID, PLANT_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, CUSTOMER_ID, COMPANY_ID, FACTORY_ID, ITEM_TYPE, LOCATION, ELECTRODE_TYPE |
| Save_P_Out | x | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, CUSTOMER_ID |
| Save_P_Out | selected | IN_QTY, OUT_QTY, QTY, ORIG_IN_QTY, ORIG_QTY, ACTION |
| Save_P_Out | newrow | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, LOCATION, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, CUSTOMER_ID, CATEGORY_ID, IN_QTY, OUT_QTY, QTY, ORIG_IN_QTY, ORIG_QTY, ACTION |
| Save_P_Out | dtCheckSave.Rows[0] | _TYPE |
| Save_ShipPlan | Filter | PLAN_TYPE, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE |
| Save_ShipPlan | dtCheckSave.Rows[0] | _TYPE |
| Save_Shorter | Filter | PLAN_TYPE, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE |
| Save_Shorter | dtCheckSave.Rows[0] | _TYPE |
| SaveButton | Filter | INSTANCE_ID |
| SaveToDB | dsMain.Tables[0].Rows[i] | MESSAGE, USER_ID, JOB_ORDER |
| SaveToDB | this.Filter | PLAN_TYPE, MPP_WPP |
| SaveToDB | Filter | MPP_WPP |
| SaveToDB | eachRow | _VALID |
| SaveToDB | Application.OpenForms | FP00607_InValidationExcelPopup |
| SaveToDB | valrow | _VALID, _MSG |
| SaveToDB | xlsrow | MESSAGE |
| SetBasisTime | dtBaseTime.Rows[0] | BASIS_TIME |
| SetBohTotalQty | row | DATA_TYPE, OPERATION_ID, BOH_QTY, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohTotalQty | each_row | _TYPE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohTotalQty | result.First() | QTY |
| SetChangeControl | Filter | INSTANCE_ID, MASTER_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID |
| SetChangeControl | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| SetColumnChangeByText | row | DATA_TYPE, CATEGORY_ID |
| SetFpPlanId | dtPlanId.Rows[iDx] | CODE, NAME, PLAN_START_DATE, PLAN_END_DATE, DEFAULT_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, BASIS_PLAN_ID, DEMAND_PLAN_ID, SCP_PLAN_ID |
| SetFpPlanId | Filter | FP_PLAN_ID, PLAN_ID, PLAN_TYPE |
| SetFpPlanId | dtPlanId.Rows[0] | INSERT_ID, INSERT_TIME, DESCS, BASIC_VERSION, FACTORY_LT |
| setMeasualFormData | dtCategory.Rows[i] | MEA_ID, MEA_VALUE |
| SetPlanGroup | dtInstance.Rows[0] | CODE, USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| SetPlanner | row | NAME, DEFAULT_CHECK, CODE |
| SetPlanner | Filter | ALL_LINE |
| SetPlanOut_DataSet | dateMap.Tables[0].Rows[dateMap.Tables[0].Rows.Count - 1] | D_VALUE |
| SetPlanOut_DataSet | measure | chk_inventory |
| SetPlanOut_DataSet | dsMainFiltered.Tables[0].Rows[cRow] | LV1, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, TOP_ITEM_ID, OPERATION_ID |
| SetPlanOut_DataSet | dsMainFiltered.Tables[0].Rows[i] | LV1, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID, OPERATION_ID, DATA_TYPE, PSI, CATEGORY_ID, FACTORY_ID, LINE_ID |
| SetPlanOut_DataSet | clicked_row | CATEGORY_ID |
| SetPlanOut_DataSet | Filter | PLAN_DATE |
| SetPlanOut_DataSet | dsMainFiltered.Tables[0].Rows[nRowStart] | BOH |
| SetPlanOut_DataSet | dateMap.Tables[0].Rows[0] | D_VALUE |
| SetPlanPeriod | dtPlanId.Rows[0] | PLAN_START_DATE, PLAN_END_DATE, DEFAULT_START_DATE, DEFAULT_END_DATE |
| SetSaveDataTable | Filter | INSTANCE_ID, PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, TOP_ITEM_ID, ITEM_TYPE, PRODUCTION_TYPE, NICK_NAME, PLAN_TYPE |
| SetShipPlan_DataSet | clicked_row | CATEGORY_ID |
| SetShipPlan_DataSet | Filter | INSTANCE_ID, FP_PLAN_ID |
| SetShipPlan_DataSet | x | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, LOCATION, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, CATEGORY_ID |
| SetShipPlan_DataSet | row | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, LOCATION, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, CATEGORY_ID, COMPANY_ID |
| SetShipPlan_DataSet | selected | SALE_SIMUL_QTY, ORIG_QTY, ACTION |
| SetShipPlan_DataSet | newrow | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ITEM_ID, TOP_ITEM_ID, ITEM_TYPE, LOCATION, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, CATEGORY_ID, SALE_SIMUL_QTY, ORIG_QTY, ACTION |
| SetShipPlan_DataSet | dsShipPlan.Tables | Table |
| SetShipPlan_DataSet | dsMainFiltered.Tables[0].Rows[cRow] | LV1, PLANT_ID |
| SetShipPlan_DataSet | dsMainFiltered.Tables[0].Rows[i] | LV1, PLANT_ID, DATA_TYPE |
| SetShipPlan_DataSet | dateMap.Tables[0].Rows[0] | D_VALUE |
| SetShipPlan_DataSet | dateMap.Tables[0].Rows[dateMap.Tables[0].Rows.Count - 1] | D_VALUE |
| SetShortLT_DataSet | Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID |
| SetShortLT_DataSet | x | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ITEM_ID |
| SetShortLT_DataSet | row | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ITEM_ID, COMPANY_ID |
| SetShortLT_DataSet | selected | SHORTER_LT |
| SetShortLT_DataSet | newrow | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LINE_ID, OPERATION_ID, SHORTER_LT |
| SetShortLT_DataSet | dsShorterLT.Tables | Table |
| SetShortLT_DataSet | dsMainFiltered.Tables[0].Rows[cRow] | DIVISION_ID, SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, OPERATION_ID, MARKET, PRODUCTION_TYPE, FACTORY_ID, LOCATION, LINE_ID, ELECTRODE_TYPE, LV1 |
| SetShortLT_DataSet | dsMainFiltered.Tables[0].Rows[i] | DIVISION_ID, SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, OPERATION_ID, MARKET, PRODUCTION_TYPE, FACTORY_ID, LOCATION, LINE_ID, ELECTRODE_TYPE |
| SetTotalColor | row | DATA_TYPE |
| spdMain_CellClick | row | LINE_ID, PRODUCTION_TYPE, DATA_TYPE |
| SwitchMemo | r | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET |
| SwitchMemo | memoRow | PRODUCTION_TYPE, ITEM_ID |
| SwitchMemo | memo[k] | ITEM_ID |
| SwitchMemo | materialRow | PRODUCTION_TYPE |
| UIFindData | Filter | PLAN_ID, DONOTEDIT, PLAN_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:188, InitControl:276, RefreshSpreadSheet:1593, CheckAndGetMeasure:2294 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| GetCheckedListValue | Cbo_fpplanid_MouseClick:326, SetChangeControl:434, SetChangeControl:446, SetChangeControl:454, SetChangeControl:462, SetChangeControl:471, SetChangeControl:479, SetChangeControl:487 | CString.GetCheckedListValue | CODE |
| SetFilter | InitControls:359, InitControls:360, InitControls:361, InitControls:362, InitControls:364, InitControls:366, InitControls:378, InitControls:379 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetInnerTable | SetChangeControl:430, SetChangeControl:439, SetChangeControl:447, SetChangeControl:455, SetChangeControl:463, SetChangeControl:472, SetChangeControl:480, SetDivision:5523 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| LoadAmendColumn | DrawHeader:1706 | MeasureService.LoadAmendColumn | DAYTAG, MONTHTAG, WEEKTAG |
| SetTotalColor | DrawSheet:1794 | SpreadInfo.SetTotalColor | column_cnt, grouping_cnt, row_idx |
| EditQuery | Query:1872 | FPExtensions.EditQuery | ROW_ID |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:2524 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| GetChanges | Save_P_Out:3116 | FPExtensions.GetChanges | ROW_ID |
| FP_Log2 | cbo_plan_group_changed:3600, cbo_plan_group_changed:3605 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| FP_PseudoBatch | Insert_Data_Excel_Buffer:8116 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| CommonDefaultLineCheck | DefaultLineCheck:961, DefaultLineCheck:934 | ExcelService.CommonDefaultLineCheck | BUCKET_FROM, BUCKET_TO, MESSAGE, QTY |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:225 |
| cbo_plan_group | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:287 |
| mcbo_planner | SelectedIndexChanged | mcbo_planner_changed | InitEvent:288 |
| sCalendar_planday | DateTimeChanged | planday_changed | InitEvent:289 |
| cbo_fpplanid | SelectedIndexChanged | cbo_fpplanid_changed | InitEvent:290 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:292 |
| mcbo_site | SelectedIndexChanged | mcbo_site_changed | InitEvent:293 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:294 |
| mcbo_factory | SelectedIndexChanged | mcbo_factory_changed | InitEvent:295 |
| mcbo_operation | SelectedIndexChanged | mcbo_operation_changed | InitEvent:296 |
| mcbo_line | SelectedIndexChanged | mcbo_line_changed | InitEvent:297 |
| cbo_fpplanid | MouseClick | Cbo_fpplanid_MouseClick | InitEvent:300 |
| cbo_fpplanid | MouseDown | Cbo_fpplanid_MouseDown | InitEvent:302 |
| txtPjtGroup | TextChanged | TxtPjtGroup_TextChanged | InitEvent:303 |
| txtItem | TextChanged | TxtItem_TextChanged | InitEvent:304 |
| dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitEvent:307 |
| chk_allLine | CheckedChanged | chk_allLine_CheckedChanged | InitEvent:309 |
| popSql | OnSql | RunSqlSource | btnSql_Click:4705 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick:4768 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick:4780 |
| menu_material | Click | onZeroMaterialMenu | spdMain_CellClick:4792 |
| this.chk_includeSubOp | CheckedChanged | chk_includeSubOp_onchanged | InitializeComponent:291 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:445 |
| this.btnExcelImport | Click | btnExcelImport_Click | InitializeComponent:485 |
| this.btnToggleSave | Click | btnToggleSave_Click | InitializeComponent:524 |
| this.chk_Info | CheckedChanged | chk_Info_CheckChanged | InitializeComponent:776 |
| this.btnMemo | Click | btnMemo_Click | InitializeComponent:1556 |
| this.btnMRP | Click | btnMRP_Click | InitializeComponent:1595 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:1607 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:1608 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:1609 |
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:1610 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:1611 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:1612 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:1613 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:1614 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1615 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1616 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:1617 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:1618 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:1619 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:1620 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:1621 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:1622 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:1623 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:1624 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:1625 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:1626 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:1627 |
| this.button1 | Click | button1_Click | InitializeComponent:1757 |
| this.btnRePlan | Click | btnRePlan_Click | InitializeComponent:1942 |
| this.btnSimulation | Click | btnSimulation_Click | InitializeComponent:1980 |
| this.btnMenu | Click | btnMenu_Click | InitializeComponent:2091 |
| this.btnRelease2 | Click | btnRelease_Click | InitializeComponent:2129 |
| this.btnCreatePlan2 | Click | btnCreatePlan_Click | InitializeComponent:2167 |
| this.btnBucket | Click | btnBucket_Click | InitializeComponent:2205 |
| this.btnCatagory | Click | btnCatagory_Click | InitializeComponent:2243 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:2281 |
| this.btnSet | Click | btnSet_Click | InitializeComponent:545 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:583 |
| this | Load | MeasureSetForm_Load | InitializeComponent:611 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:612 |
| this.dtpPeriod | ValueChanged | dtpPeriod_ValueChanged | InitializeComponent:180 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:256 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:308 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:349 |
| this.btnDownload | Click | btnDownload_Click | InitializeComponent:390 |
| this.btnUpload | Click | btnUpload_Click | InitializeComponent:431 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:547 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:548 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:278 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:359 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:360 |
| this | Load | Form_Load | .ctor:100 |
| this | Load | Form_Load | .ctor:76 |
| this.dpPlanDate | ValueChanged | dpPlanDate_ValueChanged | InitEvent:235 |
| cbWPP | CheckedChanged | CbWPP_CheckedChanged | InitEvent:237 |
| cbMPP | CheckedChanged | CbMPP_CheckedChanged | InitEvent:238 |
| cbWPP | CheckedChanged | CbWPP_CheckedChanged | CbMPP_CheckedChanged:244 |
| cbMPP | CheckedChanged | CbMPP_CheckedChanged | CbMPP_CheckedChanged:245 |
| cbWPP | CheckedChanged | CbWPP_CheckedChanged | CbMPP_CheckedChanged:258 |
| cbMPP | CheckedChanged | CbMPP_CheckedChanged | CbMPP_CheckedChanged:259 |
| cbWPP | CheckedChanged | CbWPP_CheckedChanged | CbWPP_CheckedChanged:264 |
| cbMPP | CheckedChanged | CbMPP_CheckedChanged | CbWPP_CheckedChanged:265 |
| cbWPP | CheckedChanged | CbWPP_CheckedChanged | CbWPP_CheckedChanged:278 |
| cbMPP | CheckedChanged | CbMPP_CheckedChanged | CbWPP_CheckedChanged:279 |
| dpPlanDate | ValueChanged | dpPlanDate_ValueChanged | dpPlanDate_ValueChanged:624 |
| dpPlanDate | ValueChanged | dpPlanDate_ValueChanged | dpPlanDate_ValueChanged:669 |
| popSql | OnSql | RunSqlSource | btnSql_Click:810 |
| this | Load | Form_Load | .ctor:161 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:282 |
| this.btnLine | Click | btnLine_Click | InitializeComponent:479 |
| this.btnMaterial | Click | btnMaterial_Click | InitializeComponent:534 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:1353 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:1393 |
| this | Load | Form_Load | .ctor:162 |
| this.dtpPeriod | ValueChanged | dtpPeriod_ValueChanged | InitializeComponent:178 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:254 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:306 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:347 |
| this.btnDownload | Click | btnDownload_Click | InitializeComponent:388 |
| this.btnUpload | Click | btnUpload_Click | InitializeComponent:429 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:536 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:537 |

## 6. 컨트롤 (263개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 73 | layoutControlItem2, layoutControlItem4, layoutControlItem3, layoutControlItem6, layoutControlItem7, layoutControlItem8, layoutControlItem9, Operation, layoutControlItem17, layoutControlItem5, lblImport, lblData, lblSql, layoutControlItem15, layoutControlItem13 … |
| UsrButton | 31 | btnSql, btnExcelImport, btnToggleSave, btnMemo, btnMRP, usrButton2, btnRePlan, btnSimulation, btnMenu, btnRelease2, btnCreatePlan2, btnBucket, btnCatagory, btnColumn, btnSet … |
| CheckBox | 31 | chk_yield, chk_inqty, chk_calAgingQty, chk_result, chk_act, chk_actSim, chk_wipSimAD, chk_inventory_simul, chk_inventory, chk_outqty, chk_wpp_outqty, chk_wpp_inqty, chk_mpp_outqty, chk_mpp_inqty, chk_wipAD … |
| UsrTextBox | 17 | txtNickName, txtPjtGroup, txtItem, txtNickName, txtMaterial, txtCellGroup, txtLocation, txtItem, txtElectrodType, txtBuilding, txtCellGroup, txtOperation, txtNickName, txtQty, txtLine … |
| UsrLabel | 17 | lblPlanID, usrLabel1, labelMppWPP, usrLabel15, usrLabel13, usrLabel12, usrLabel11, usrLabel10, usrLabel9, usrLabel8, usrLabel7, usrLabel4, usrLabel2, usrLabel1, labelTitle … |
| Label | 14 | label3, txtBuilding, txtBasic, txtDesc, txtCreation, txtCreator, label7, label6, label5, label4, label2, label1, label1, label2 |
| UsrLayoutControl | 10 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 10 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrCheckedList2 | 8 | mcbo_nicknamelt, mcbo_line, mcbo_operation, mcbo_factory, mcbo_plant, mcbo_site, mcbo_division, mcbo_planner |
| Panel | 8 | infoPanel, menuPanel, panel2, panel3, panel4, panel1, panel1, panel3 |
| FpSpread | 6 | spdMain, spdEdit, spdInfo, spdMain, spdMain, spdMain |
| SheetView | 6 | spdMain_Sheet1, spdEdit_Sheet1, spdInfo_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrConditionPanel | 5 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrCheckBox | 5 | chk_includeSubOp, chk_allLine, chk_Info, cbMPP, cbWPP |
| ImageList | 5 | imageList2, imageList1, imageList1, imageList1, imageList1 |
| UsrCombo | 2 | cbo_fpplanid, cbo_plan_group |
| RadioGroup | 2 | rdoGroup1, rdoGroup1 |
| UsrDateRangePicker2 | 2 | dtpPeriod, dtpPeriod |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem1 |
| UsrDateRangePickerWtWeek | 1 | dCalendar_planrange |
| UsrDatePickerWtWeek | 1 | sCalendar_planday |
| SplitContainer | 1 | splitter |
| Button | 1 | button1 |
| GroupBox | 1 | groupBox1 |
| TextBox | 1 | tbLog |
| DataGridView | 1 | dgEdit |
| UsrButtonList | 1 | btnButtonList |
| UsrDatePicker2 | 1 | dpPlanDate |

## 7. 확인 필요 (7건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1298 | Find_Data_CWA_Minus_Activated | FP_Planning.PR_UI_FP00607_AMEND_LINE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 1820 | Query | FP\{?default:part_service}\AmendMemo#list_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1821 | Query | FP\{?default:part_service}\AmendMemo#list_setup_color_code | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 4110 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1855 | Query | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1856 | Query | FP\{?default:part_service}\PICAlarm#find_Category_Color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 8116 | Insert_Data_Excel_Buffer | FP\{?default:part_service}\FP00607_EXCELIMPORT#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 38 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 18 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 8 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 51 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00607 | AddItemPopup | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | FP00607 | Amend | 14/8 | 14/8 | 14/8 | 14/8 | 14/8 | 14/8 | 14/8 | 14/8 | 14/8 | 14/8 | 14/8 | 14/8 | 14/8 | 14/8 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend, AddItemPopup, AutoExcelPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@DrawHeader:1655, SetSheetHeaderColumn_FP@SetSpreadInit:158
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetCalenderColor |  | 1897 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 1903 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| spdMain_CellDoubleClick |  | 8817 | 표시/라벨 변경 | set:Visible | Visible = {?!spdMain.ActiveSheet.Columns[idx].Visible} |  | else!(!sHeadNameLevel2.Equals("Week Sum")) ⟫ for(idx < iWeekCount) |
| InitializeComponent |  | 1643 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1644 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1645 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1646 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2325 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2326 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2327 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2328 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2376 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2377 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2378 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2379 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| FindData |  | 399 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(OnSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 400 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(OnSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 401 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(OnSearchData != null) ⟫ if(AutoCHK) |
| InitializeComponent |  | 564 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 565 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 566 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 567 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadInit | 0 | 161 | 표시/라벨 변경 | SetColumnVisible | {?siMain.GetColumnIndex(DefColumns.DIVISION_ID)} | DIVISION_ID |  |
| SetSpreadInit | 0 | 162 | 표시/라벨 변경 | SetColumnVisible | {?siMain.GetColumnIndex(DefColumns.SITE_ID)} | SITE_ID |  |
| InitializeComponent |  | 376 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 377 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 378 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 379 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| FindData |  | 395 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(OnSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 396 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(OnSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 397 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(OnSearchData != null) ⟫ if(AutoCHK) |
| InitializeComponent |  | 553 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 554 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 555 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 556 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| AddItemPopup | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| Amend | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
