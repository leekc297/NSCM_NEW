# FP00621 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00621_PlanAmend_Line_Formation.UIL\FP00621_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00621_PlanAmend_Line_Formation.UIL\FP00621_PlanAmend_Line_Formation.UIL.csproj | 446 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00621_PlanAmend_Line_Formation.UIL\FP00621_MeasureSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00621_PlanAmend_Line_Formation.UIL\FP00621_PlanAmend_Line_Formation.UIL.csproj | 559 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00621_PlanAmend_Line_Formation.UIL\FP00621_PlanAmend_Line_Formation.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00621_PlanAmend_Line_Formation.UIL\FP00621_PlanAmend_Line_Formation.UIL.csproj | 8474 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00621_PlanAmend_Line_Formation.UIL\FP00621_PlanAmend_Line_Formation.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00621_PlanAmend_Line_Formation.UIL\FP00621_PlanAmend_Line_Formation.UIL.csproj | 2704 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00621_PlanAmend_Line_Formation.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00621_PlanAmend_Line_Formation.UIL\FP00621_PlanAmend_Line_Formation.UIL.csproj | 37 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00621_InValidationExcelPopup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 276 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00621_InValidationExcelPopup.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 424 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00621_LineCN2ItemPopup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 310 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00621_LineCN2ItemPopup.Designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 456 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:bucke_menu.Click | onZeroBucketMenu > EditByFunc > EditCommon | 4675 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:bucke_menu.Click | onZeroBucketMenu > EditByFunc > EditCommon > SetShortLT_DataSet | 5713 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_fpplanid.MouseClick | Cbo_fpplanid_MouseClick | 323 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed > SetChangeControl | 453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed > SetChangeControl | 453 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed | 3176 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed | 3176 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetFpPlanId > SetChangeControl | 453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetFpPlanId > SetChangeControl | 453 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetFpPlanId > SetBasisTime | 5156 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetPlanner | 5180 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetPlanner | 5182 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetFpPlanId | 5268 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetFpPlanId | 5351 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetFpPlanId | 5351 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 453 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| button:FindButton | FindButton > UIFindData > FindTotalValue | 1089 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 1306 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 1442 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1486 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1492 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1494 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1496 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1499 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1552 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > GetListDataSet | 1578 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > GetListDataSet | 1582 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > GetListDataSet | 1586 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > GetListDataSet | 1590 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > SetEnabledButton | 1599 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| button:FindButton | FindButton > UIFindData > dwCheck | 8189 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > dwCheck | 8189 | FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql |
| button:InsertButton | InsertButton > UIFindData > FindTotalValue | 1089 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend | 1306 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 1442 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1486 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1492 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1494 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1496 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1499 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1552 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > GetListDataSet | 1578 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > GetListDataSet | 1582 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > GetListDataSet | 1586 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > GetListDataSet | 1590 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > SetEnabledButton | 1599 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > Run_Parallels > Exec_Procedure | 2964 | FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_SAVE |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| button:InsertButton | InsertButton > UIFindData > dwCheck | 8189 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > dwCheck | 8189 | FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetChangeControl | 453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetChangeControl | 453 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetChangeControl | 453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetChangeControl | 453 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_line.SelectedIndexChanged | mcbo_line_changed > SetChangeControl | 453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_line.SelectedIndexChanged | mcbo_line_changed > SetChangeControl | 453 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetChangeControl | 453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetChangeControl | 453 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetChangeControl | 453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetChangeControl | 453 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed | 3192 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed | 3192 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_changed > SetChangeControl | 453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_changed > SetChangeControl | 453 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > SetChangeControl | 453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > SetChangeControl | 453 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenLineMemo | 8409 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenLineMemo | 8409 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo | 8427 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo | 8427 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo | 8446 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo | 8446 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:menu_line.Click | onZeroLineMenu > EditByFunc > EditCommon | 4675 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:menu_line.Click | onZeroLineMenu > EditByFunc > EditCommon > SetShortLT_DataSet | 5713 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:menu_material.Click | onZeroMaterialMenu > EditByFunc > EditCommon | 4675 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:menu_material.Click | onZeroMaterialMenu > EditByFunc > EditCommon > SetShortLT_DataSet | 5713 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > FindTotalValue | 1089 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 1306 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:popSql.OnSql | RunSqlSource > Find_Data_CWA_Minus_Activated | 1363 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:popSql.OnSql | RunSqlSource > ApplySearchCondition | 1442 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1486 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1492 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1494 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1496 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1499 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > lfn_setReleaseProcess | 1552 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > GetListDataSet | 1578 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > GetListDataSet | 1582 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > GetListDataSet | 1586 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > GetListDataSet | 1590 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Save_Data_Shorter | 2324 | FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_SAVE |
| event:popSql.OnSql | RunSqlSource > Save_Data_Amend | 2840 | FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_SAVE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 6221 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 6227 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 6229 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 6231 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 6237 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Excel_Import | 6433 | FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL | MATCH | SP PR_UI_FP00621_AMEND_LINE_EXCEL |
| button:SaveButton | SaveButton > UIFindData > FindTotalValue | 1089 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend | 1306 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| button:SaveButton | SaveButton > Find_Data_CWA_Minus_Activated | 1363 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 1442 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1486 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1492 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1494 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1496 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1499 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1552 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > GetListDataSet | 1578 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > GetListDataSet | 1582 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > GetListDataSet | 1586 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > GetListDataSet | 1590 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > SetEnabledButton | 1599 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > Save_Shorter | 2170 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > Save_Shorter > Save_Data_Shorter | 2324 | FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_SAVE |
| button:SaveButton | SaveButton > Save_Out_Data | 2627 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > Save_Out_Data > Save_Data_Amend | 2840 | FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_SAVE |
| button:SaveButton | SaveButton > Run_Parallels > Exec_Procedure | 2964 | FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_SAVE |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| button:SaveButton | SaveButton > UIFindData > dwCheck | 8189 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UIFindData > dwCheck | 8189 | FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql |
| event:sCalendar_planday.DateTimeChanged | planday_changed > SetFpPlanId > SetChangeControl | 453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:sCalendar_planday.DateTimeChanged | planday_changed > SetFpPlanId > SetChangeControl | 453 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:sCalendar_planday.DateTimeChanged | planday_changed > SetFpPlanId > SetBasisTime | 5156 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:sCalendar_planday.DateTimeChanged | planday_changed > SetFpPlanId | 5268 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:sCalendar_planday.DateTimeChanged | planday_changed > SetFpPlanId | 5351 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:sCalendar_planday.DateTimeChanged | planday_changed > SetFpPlanId | 5351 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindTotalValue | 1089 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 1306 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1442 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1486 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1492 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1494 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1496 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1499 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1552 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > GetListDataSet | 1578 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > GetListDataSet | 1582 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > GetListDataSet | 1586 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > GetListDataSet | 1590 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > SetEnabledButton | 1599 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > dwCheck | 8189 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > dwCheck | 8189 | FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > FindTotalValue | 1089 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 1306 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1442 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1486 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1492 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1494 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1496 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1499 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1552 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > GetListDataSet | 1578 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > GetListDataSet | 1582 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > GetListDataSet | 1586 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > GetListDataSet | 1590 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > SetEnabledButton | 1599 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > dwCheck | 8189 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > dwCheck | 8189 | FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetFpPlanId > SetChangeControl | 453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetFpPlanId > SetChangeControl | 453 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > FindTotalValue | 1089 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend | 1306 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1442 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1486 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1492 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1494 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1496 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1499 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1552 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > GetListDataSet | 1578 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > GetListDataSet | 1582 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > GetListDataSet | 1586 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > GetListDataSet | 1590 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > SetEnabledButton | 1599 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click | 3573 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetFpPlanId > SetBasisTime | 5156 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetPlanner | 5180 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetPlanner | 5182 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetFpPlanId | 5268 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetFpPlanId | 5351 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetFpPlanId | 5351 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > dwCheck | 8189 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > dwCheck | 8189 | FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > FindTotalValue | 1089 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend | 1306 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1442 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1486 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1492 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1494 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1496 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1499 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1552 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > GetListDataSet | 1578 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > GetListDataSet | 1582 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > GetListDataSet | 1586 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > GetListDataSet | 1590 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > SetEnabledButton | 1599 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click | 4038 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > dwCheck | 8189 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > dwCheck | 8189 | FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql |
| event:this.btnDWSubmit.Click | btnDWSubmit_Click | 3970 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindTotalValue | 1089 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend | 1306 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > Find_Data_CWA_Minus_Activated | 1363 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1442 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1486 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1492 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1494 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1496 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1499 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1552 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > GetListDataSet | 1578 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > GetListDataSet | 1582 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > GetListDataSet | 1586 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > GetListDataSet | 1590 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > SetEnabledButton | 1599 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > Run_Parallels > Exec_Procedure | 2964 | FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_SAVE |
| event:this.btnExcelImport.Click | btnExcelImport_Click | 4123 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click | 4123 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click | 4129 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > dwCheck | 8189 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > dwCheck | 8189 | FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql |
| event:this.btnMRP.Click | btnMRP_Click | 3515 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnMRP.Click | btnMRP_Click | 3543 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH |  |
| event:this.btnMRP.Click | btnMRP_Click | 3543 | FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql |
| event:this.btnRelease.Click | btnRelease_Click > SetFpPlanId > SetChangeControl | 453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.btnRelease.Click | btnRelease_Click > SetFpPlanId > SetChangeControl | 453 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.btnRelease.Click | btnRelease_Click | 3654 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease.Click | btnRelease_Click | 3655 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease.Click | btnRelease_Click | 3666 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease.Click | btnRelease_Click | 3686 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease.Click | btnRelease_Click | 3689 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease.Click | btnRelease_Click > SetFpPlanId > SetBasisTime | 5156 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease.Click | btnRelease_Click > SetFpPlanId | 5268 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease.Click | btnRelease_Click > SetFpPlanId | 5351 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.btnRelease.Click | btnRelease_Click > SetFpPlanId | 5351 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > FindTotalValue | 1089 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > Find_Data_Amend | 1306 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1442 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1486 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1492 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1494 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1496 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1499 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1552 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > GetListDataSet | 1578 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > GetListDataSet | 1582 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > GetListDataSet | 1586 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > GetListDataSet | 1590 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > SetEnabledButton | 1599 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click | 3458 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > dwCheck | 8189 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH |  |
| event:this.btnRePlan.Click | btnRePlan_Click > UIFindData > dwCheck | 8189 | FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql |
| event:this.btnSimulation.Click | btnSimulation_Click > Find_Data_CWA_Minus_Activated | 1363 | FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | SP PR_UI_FP00621_AMEND_LINE |
| event:this.btnSimulation.Click | btnSimulation_Click > Save_Shorter | 2170 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnSimulation.Click | btnSimulation_Click > Save_Shorter > Save_Data_Shorter | 2324 | FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_SAVE |
| event:this.btnSimulation.Click | btnSimulation_Click > Exec_Procedure | 2964 | FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_SAVE |
| event:this.btnSimulation.Click | btnSimulation_Click | 3842 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > mcbo_line_changed > SetChangeControl | 453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > mcbo_line_changed > SetChangeControl | 453 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > cbo_fpplanid_changed | 3176 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > cbo_fpplanid_changed | 3176 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > mcbo_plant_changed | 3192 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > mcbo_plant_changed | 3192 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > cbo_plan_group_changed > SetFpPlanId > SetBasisTime | 5156 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > cbo_plan_group_changed > SetPlanner | 5180 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > cbo_plan_group_changed > SetPlanner | 5182 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > cbo_plan_group_changed > SetFpPlanId | 5268 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > cbo_plan_group_changed > SetFpPlanId | 5351 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > cbo_plan_group_changed > SetFpPlanId | 5351 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > SetChangeControl | 453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > SetChangeControl | 453 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7703 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7704 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7738 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 7739 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenLineMemo | 8409 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenLineMemo | 8409 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo | 8427 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo | 8427 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo | 8446 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo | 8446 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.spdMain.Change | spdMain_Change > EditByChange > EditCommon | 4675 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.Change | spdMain_Change > EditByChange > EditCommon > SetShortLT_DataSet | 5713 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 145 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_ShipPlan | 1932 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | Save_Data_ShipPlan | 2084 | FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_SAVE |
| unreached:(진입점 미연결) | Exec_PSI_Calculation | 2903 | FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_SAVE |
| unreached:(진입점 미연결) | SetDivision | 5166 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetFactory | 5373 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetFactory | 5373 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| unreached:(진입점 미연결) | ExcelPopup_CheckBeforSave | 6295 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | ExcelPopup_CheckBeforSave | 6313 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer | 6861 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer | 6861 | FP\Common\FP00621_ExcelImport#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer_Old | 6969 | FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE |
| unreached:(진입점 미연결) | Find_Data_Excel_Buffer_Valid | 7022 | FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE |
| unreached:(진입점 미연결) | Save_Data_Excel_Column | 7084 | FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE |
| unreached:(진입점 미연결) | Save_Data_Excel_Row | 7147 | FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE |
| unreached:(진입점 미연결) | Delete_Data_Excel_Buffer | 7188 | FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 8 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 41 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00621_AMEND_LINE | MATCH | 3 | SP PR_UI_FP00621_AMEND_LINE | EXEC:PR_UI_FP00621_AMEND_LINE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL | MATCH | 1 | SP PR_UI_FP00621_AMEND_LINE_EXCEL | EXEC:PR_UI_FP00621_AMEND_LINE_EXCEL | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE | MATCH | 5 | SP PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE | EXEC:PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | MATCH | 5 | SP PR_UI_FP00621_AMEND_LINE_SAVE | EXEC:PR_UI_FP00621_AMEND_LINE_SAVE | ⚠ DB에 SP 없음 |
| FP\Common\AmendMemo#list_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql | SELECT:FP_AMEND_MEMO_M, SELECT:FP_AMEND_SETUP_COLOR_M |  |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 8 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\FP00621_ExcelImport#insert_Excel_buffer | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\PICAlarm#find_Category | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql | SELECT:FP_PROC_PARAMETER_HA |  |
| FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql | REF:FN_SITE_TIME, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql | UPDATE:SCM_FP_PLAN_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO, CATE_VALUE, CATE_TYPE |
| ApplyAmendCalendarCondition | row | MEA_ID, MEA_VALUE |
| ApplyAmendCalendarCondition_ForExcel | Filter | BUCKET_FROM, PLAN_DATE, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO, CATE_VALUE, CATE_TYPE |
| ApplySearchCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, INSTANCE_ID, PLAN_ID, AMEND_TABLE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_SALES_TABLE, AMEND_UTIL_TABLE, PLAN_TYPE, MASTER_ID |
| btnBucket_Click | Application.OpenForms | FP00599_BucketSetForm_Popup |
| btnCatagory_Click | Application.OpenForms | FP00621_MeasureSetForm_Popup |
| btnColumn_Click | Application.OpenForms | FPC0097_ColumnSetForm_Popup |
| btnCreatePlan_Click | Filter | SITE_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE |
| btnCreatePlan_Click | dtPlanRunFlag.Rows[0] | PLAN_ID, INSERT_ID |
| btnCreatePlan_Click | Application.OpenForms | FP00590_PlanTotalPopup |
| btnDppWppCopyDwSubmit_Click | Filter | INSTANCE_ID, PLAN_ID, PLAN_TYPE, BUCKET_FROM, BUCKET_TO, PLAN_DATE, PLANT_ID, SITE_ID, FACTORY_ID, DIVISION_ID |
| btnDppWppCopyDwSubmit_Click | dtAuthChk.Rows[0] | AUTH_YN |
| btnDppWppCopyDwSubmit_Click | CopySubmit.Filter | SUBMIT_TYPE, MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, PLAN_ID, PLAN_DATE, PLANT_ID, SITE_ID, FACTORY_ID, DIVISION_ID, USER_ID |
| btnDWSubmit_Click | Filter | INSTANCE_ID, PLAN_ID, PLAN_TYPE, BUCKET_FROM, BUCKET_TO, PLAN_DATE, PLANT_ID, SITE_ID, FACTORY_ID, DIVISION_ID, CONFIRM_AREA |
| btnDWSubmit_Click | dtAuthChk.Rows[0] | AUTH_YN |
| btnDWSubmit_Click | DwSubmit.Filter | SUBMIT_TYPE, MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, PLAN_ID, PLAN_DATE, PLANT_ID, SITE_ID, FACTORY_ID, DIVISION_ID, USER_ID, PLAN_TYPE, CONFIRM_TYPE, CONFIRM_AREA |
| btnExcelImport_Click | Application.OpenForms | FPC0095_ExcelSelect_Popup |
| btnExcelImport_Click | Filter | PLAN_TYPE, CURR_DATE, INSTANCE_ID, PLAN_DATE |
| btnExcelImport_Click | ds_isCurrWeek.Tables[0].Rows[0] | CURR_DATE |
| btnExcelImport_Click | colPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LINE_ID |
| btnExcelImport_Click | colPopup.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, CELL_GROUP_CODE, ITEM_ID, NICK_NAME, ITEM_TYPE, OPERATION_ID, FACTORY_ID, LOCATION, MARKET, PRODUCTION_TYPE, LINE_ID, LINE_NAME, ELECTRODE_TYPE |
| btnExcelImport_Click | rowPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LINE_ID, PLAN_DATE, QTY |
| btnExcelImport_Click | rowPopup.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, CELL_GROUP_CODE, ITEM_ID, NICK_NAME, ITEM_TYPE, OPERATION_ID, FACTORY_ID, LOCATION, MARKET, PRODUCTION_TYPE, LINE_ID, LINE_NAME, ELECTRODE_TYPE, PLAN_DATE, QTY, MESSAGE |
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
| btnRePlan_Click | Filter | PLAN_TYPE, PLAN_ID, INSTANCE_ID, FP_SITE_ID, PLAN_DATE, CONFIRM_AREA, IS_SAME_PLAN_ID, USE_WOW_STATUS |
| btnRePlan_Click | dtPlanRunFlag.Rows[0] | CNT, PLAN_ID, INSERT_ID |
| btnRePlan_Click | Application.OpenForms | FP00590_RePlanTotalPopup |
| btnSimulation_Click | Filter | READ_ONLY, PLAN_ID, INSTANCE_ID, PLAN_DATE |
| btnSimulation_Click | dtChk.Rows[0] | _TYPE |
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| cbo_fpplanid_changed | dtPlanId.Rows[selected] | PLAN_START_DATE, PLAN_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME, CODE, INSERT_ID, INSERT_TIME, DESCS, BASIC_VERSION, FACTORY_LT |
| cbo_fpplanid_changed | Filter | PLAN_TYPE |
| chk_includeSubOp_onchanged | Filter | AMEND_MAIN_FLAG |
| CreateDataLine | material_column | P_IN, P_IN_CELL, P_OUT, P_OUT_CELL |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_target, chk_mppIn, chk_mppOut, chk_wppIn, chk_wppOut, chk_outqty, chk_result, chk_wip, chk_wipBD, chk_wipAD, chk_act, chk_wipSim, chk_wipSimBD, chk_wipSimAD, chk_pkgProcDate, chk_pkgQty, chk_actSim, chk_memo, chk_setup, chk_capa, chk_off, chk_total, chk_memo_tot, chk_total_2 |
| CreateFilterDataSet | x | _MM_ |
| DrawHeader | Filter | BUCKET_FROM |
| DrawHeader | measure.Data | chk_day, chk_week, chk_month |
| DrawSheet | Filter | DONOTEDIT |
| dwCheck | Filter | PLAN_TYPE, DW_TABLE |
| dwCheck | dsTmp.Tables[0].Rows[0] | IS_SUBMIT |
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
| ExcelPopup_SaveExcel_Column | Filter | MPP_WPP, PLAN_TYPE |
| ExcelPopup_SaveExcel_Row | filter | MPP_WPP |
| ExcelPopup_SaveExcel_Row | Filter | MPP_WPP, PLAN_TYPE |
| ExcelPopup_Search_Column | Filter | BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| ExcelPopup_Search_Column | filter | MPP_WPP |
| ExcelPopup_Search_Row | Filter | BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| ExcelPopup_Search_Row | filter | MPP_WPP |
| Exec_Procedure | Filter | INSTANCE_ID, PLAN_ID |
| Exec_PSI_Calculation | Filter | INSTANCE_ID, PLAN_ID |
| Find_Data_Amend | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, MASTER_ID, PLAN_DATE, PLAN_ID, PLAN_TYPE, PROD_TYPE, ITEM_ID, NICK_NAME, NICK_NAME_LT, CELL_GROUP, CELL_GROUP_CODE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, CATE_INFO, CATE_VALUE, CATE_TYPE, AMEND_TABLE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_SALES_TABLE, AMEND_UTIL_TABLE |
| Find_Data_CWA_Minus_Activated | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, MASTER_ID, PLAN_DATE, PLAN_ID, PLAN_TYPE, PROD_TYPE, ITEM_ID, NICK_NAME, NICK_NAME_LT, CELL_GROUP, CELL_GROUP_CODE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, CATE_INFO, CATE_VALUE, CATE_TYPE, AMEND_TABLE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_SALES_TABLE, AMEND_UTIL_TABLE |
| Find_Line_Savings_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | related_row | CATEGORY_ID, PRODUCTION_TYPE |
| Find_MaterialData_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | related_row | CATEGORY_ID |
| FindButton | Filter | PLAN_ID |
| FindData | Filter | CELL_GROUP_CODE, ITEM_ID, NICK_NAME |
| FindTotalValue | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, MASTER_ID, PLAN_DATE, PLAN_ID, PLAN_TYPE, PROD_TYPE, ITEM_ID, NICK_NAME, NICK_NAME_LT, CELL_GROUP, CELL_GROUP_CODE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, CATE_INFO, CATE_VALUE, CATE_TYPE, AMEND_TABLE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_SALES_TABLE, AMEND_UTIL_TABLE |
| GetListDataSet | Filter | INSTANCE_ID, PLAN_ID, OPERATION_ID, PLAN_TYPE, AMEND_TABLE, PLAN_DATE, AMEND_CUTOFF_BOH_TABLE, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID |
| GetMppWpp | x | DIVISION_ID, SITE_ID, PLANT_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, CUSTOMER_ID |
| GetMppWpp | clicked_row | DIVISION_ID, SITE_ID, PLANT_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, CUSTOMER_ID |
| GetMppWpp | related_row | CATEGORY_ID |
| GetPlanGroup | Filter | USER_ID, MASTER_ID, INSTANCE_ID, USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| GetPlanGroup | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| GoEditMode | Filter | PLAN_TYPE, PLAN_ID |
| GoEditMode | row | DATA_TYPE, CATEGORY_ID, EDIT_YN |
| GoEditModeShortLT | Filter | PLAN_ID |
| GoEditModeShortLT | row | DATA_TYPE, FACTORY_ID, LINE_ID, ITEM_ID, SHORTER_LEAD_TIME |
| GoEditModeShortLT | current_src.Rows[i] | DATA_TYPE, FACTORY_ID, LINE_ID, ITEM_ID, SHORTER_LEAD_TIME |
| InitControls | Filter | USER_ID, MASTER_ID, INSTANCE_ID, CELL_GROUP_CODE |
| Insert_Data_Excel_Buffer | result.Rows[0] | RESULT, EXCEPTION |
| Insert_Data_Excel_Buffer_Old | dsData.Tables[0].Rows[i] | INSTANCE_ID, PLAN_DATE, PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, PRODUCTION_TYPE, LOCATION, MARKET, ELECTRODE_TYPE, CELL_QTY, QTY, NEW_SEQ, MPP_WPP |
| InsertButton | row | DATA_TYPE, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID |
| InsertButton | popup.Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID |
| lfn_setAvailability | dsMainFiltered.Tables[0].Rows[nDefRow] | FORMATION_TOTAL_YIELD |
| lfn_setAvailability | measure | chk_act, chk_actSim, chk_outqty |
| lfn_setAvailability | dsMainFiltered.Tables[0].Rows[nStartRow] | LV1, LINE_ID |
| lfn_setAvailability | dsMainFiltered.Tables[0].Rows[i] | LV1, LINE_ID, DATA_TYPE, CATEGORY_ID |
| lfn_setReleaseProcess | Filter | INSTANCE_ID, PLAN_ID, SITE_ID, CONFIRM_AREA |
| lfn_setReleaseProcess | dtIsCurrWeek.Rows[0] | CURR_DATE |
| lfn_setReleaseProcess | row | _DATE, IS_PLAN |
| MakeMemoFontBold | dsMainFiltered.Tables[0].Rows[i] | CATEGORY_ID |
| MakeMemoFontBold | Filter | PLAN_TYPE |
| onNLFAmendMenu | frm.Filter | MASTER_ID, FP_PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onNLFAmendMenu | Filter | INSTANCE_ID, PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onZeroBucketMenu | row_to_test | CATEGORY_ID |
| onZeroBucketMenu | Filter | PLAN_TYPE |
| onZeroLineMenu | Filter | PLAN_ID, PLAN_TYPE |
| onZeroLineMenu | row | LINE_ID, DIVISION_ID, SITE_ID, FACTORY_ID |
| onZeroLineMenu | dsMainFiltered.Tables[0].Rows[i] | DATA_TYPE, LINE_ID, DIVISION_ID, SITE_ID, FACTORY_ID |
| onZeroLineMenu | row_to_test | CATEGORY_ID, DATA_TYPE |
| onZeroMaterialMenu | Filter | PLAN_ID, PLAN_TYPE |
| onZeroMaterialMenu | row | LINE_ID, ITEM_ID |
| onZeroMaterialMenu | dsMainFiltered.Tables[0].Rows[i] | DATA_TYPE, LINE_ID, ITEM_ID |
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
| Save_Data_Amend | dtData.Rows[i] | ACTION, INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, MARKET, LOCATION, ELECTRODE_TYPE, CUSTOMER_ID, OUT_QTY, MPP_OUT_QTY, WPP_OUT_QTY |
| Save_Data_ShipPlan | dtData.Rows[i] | ACTION, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, MARKET, LOCATION, ELECTRODE_TYPE, SALE_SIMUL_QTY |
| Save_Data_Shorter | dtData.Rows[i] | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ITEM_ID, SHORTER_LT |
| Save_Out_Data | row | CATEGORY_ID |
| Save_Out_Data | Filter | INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, PLAN_TYPE |
| Save_Out_Data | enum_row_from_Saving | EDATE, CATEGORY_ID, EQTY, DIVISION_ID, SITE_ID, PLANT_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, CUSTOMER_ID, COMPANY_ID, FACTORY_ID, ITEM_TYPE, LOCATION, ELECTRODE_TYPE, EIDX |
| Save_Out_Data | x | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, CUSTOMER_ID |
| Save_Out_Data | selected | IN_QTY, OUT_QTY, QTY, ORIG_IN_QTY, ORIG_OUT_QTY, ORIG_QTY, ACTION, MPP_OUT_QTY, ORIG_MPP_OUT_QTY, WPP_OUT_QTY, ORIG_WPP_OUT_QTY |
| Save_Out_Data | newrow | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, LOCATION, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, CUSTOMER_ID, CATEGORY_ID, IN_QTY, OUT_QTY, MPP_OUT_QTY, WPP_OUT_QTY, ACTION, USER_ID |
| Save_Out_Data | dtCheckSave.Rows[0] | _TYPE |
| Save_ShipPlan | Filter | PLAN_TYPE, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE |
| Save_ShipPlan | dtCheckSave.Rows[0] | _TYPE |
| Save_Shorter | Filter | PLAN_TYPE, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE |
| Save_Shorter | dtCheckSave.Rows[0] | _TYPE |
| SaveButton | Filter | PLAN_TYPE, INSTANCE_ID |
| SetBasisTime | dtBaseTime.Rows[0] | BASIS_TIME |
| SetBohTotalQty | row | DATA_TYPE, OPERATION_ID, BOH_QTY, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohTotalQty | each_row | _TYPE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohTotalQty | result.First() | QTY |
| SetChangeControl | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| SetChangeControl | Filter | PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID |
| SetColumnChangeByText | row | DATA_TYPE, CATEGORY_ID |
| SetDivision | Filter | INSTANCE_ID |
| SetEnabledButton | Filter | PLAN_TYPE, INSTANCE_ID, PLAN_ID, SITE_ID, CONFIRM_AREA |
| SetEnabledButton | dtIsCurrWeek.Rows[0] | IS_LATEST_PLAN |
| SetFpPlanId | dtPlanId.Rows[iDx] | CODE, NAME, PLAN_START_DATE, PLAN_END_DATE, DEFAULT_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, BASIS_PLAN_ID, DEMAND_PLAN_ID, SCP_PLAN_ID |
| SetFpPlanId | dtPlanId.Rows[0] | INSERT_ID, INSERT_TIME, DESCS, BASIC_VERSION, FACTORY_LT |
| SetFpPlanId | Filter | PLAN_TYPE |
| SetLine | Filter | ALL_LINE |
| SetPlanner | row | NAME, DEFAULT_CHECK, CODE |
| SetPlanner | Filter | ALL_LINE |
| SetPlanOut_DataSet | dateMap.Tables[0].Rows[dateMap.Tables[0].Rows.Count - 1] | D_VALUE |
| SetPlanOut_DataSet | dsMainFiltered.Tables[0].Rows[cRow] | LV1, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, TOP_ITEM_ID, OPERATION_ID |
| SetPlanOut_DataSet | dsMainFiltered.Tables[0].Rows[i] | LV1, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID, OPERATION_ID, DATA_TYPE, FACTORY_ID, LINE_ID, CATEGORY_ID |
| SetPlanOut_DataSet | clicked_row | CATEGORY_ID |
| SetPlanOut_DataSet | dateMap.Tables[0].Rows[0] | D_VALUE |
| SetPlanPeriod | dtPlanId.Rows[0] | PLAN_START_DATE, PLAN_END_DATE, DEFAULT_START_DATE, DEFAULT_END_DATE |
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
| UIFindData | Filter | DONOTEDIT, PLAN_TYPE, PLAN_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:181, InitControl:258, CheckAndGetMeasure:1628, RefreshSpreadSheet:7519 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| GetCheckedListValue | Cbo_fpplanid_MouseClick:320, SetChangeControl:424, SetChangeControl:436, SetChangeControl:444, SetChangeControl:452, SetChangeControl:461, SetChangeControl:469, SetChangeControl:477 | CString.GetCheckedListValue | CODE |
| SetFilter | InitControls:351, InitControls:352, InitControls:353, InitControls:354, InitControls:357, InitControls:359, InitControls:371, InitControls:372 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetInnerTable | SetChangeControl:420, SetChangeControl:429, SetChangeControl:437, SetChangeControl:445, SetChangeControl:453, SetChangeControl:462, SetChangeControl:470, GetPlanGroup:5243 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| SetTotalColor | RefreshHeader:619, DrawSheet:7678 | SpreadInfo.SetTotalColor | column_cnt, grouping_cnt, row_idx |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:1819 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| GetChanges | Save_Out_Data:2410 | FPExtensions.GetChanges | ROW_ID |
| FP_Log2 | cbo_plan_group_changed:3032, cbo_plan_group_changed:3038 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| FP_PseudoBatch | Insert_Data_Excel_Buffer:6861 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| LoadAmendColumn | DrawHeader:7634 | MeasureService.LoadAmendColumn | DAYTAG, MONTHTAG, WEEKTAG |
| ShowMemoLine | DrawSheet:7687 | MemoService.ShowMemoLine | ATTR1, ATTR2, ATTRIBUTE10, ATTRIBUTE2, COLOR_A, COLOR_B, DATA_TYPE, Default, ELECTRODE_TYPE, EQUIPMENT_ID, INSTANCE_ID, ITEM_ID, PRODUCTION_TYPE, SEGMENT1, UI_COLOR, UI_DESC, UI_PARAM, chk_day |
| ApplyMemoTextLine | Query:7754 | MemoService.ApplyMemoTextLine | ATTR2, CATEGORY_ID, COMPANY_ID, DATA_TYPE, DIVISION_ID, ELECTRODE_TYPE, EQUIPMENT_ID, FACTORY_ID, ITEM_ID, LINE_ID, MARKET, MEMO, OPERATION_ID, PLANT_ID, PLAN_DATE, PRODUCTION_TYPE, TOP_ITEM_ID |
| EditQuery | Query:7755 | FPExtensions.EditQuery | ROW_ID |
| ApplyMemoTagLine | Query:7757 | MemoService.ApplyMemoTagLine | CATEGORY_ID, COMPANY_ID, DATA_TYPE, DIVISION_ID, ELECTRODE_TYPE, FACTORY_ID, ITEM_ID, LINE_ID, MARKET, OPERATION_ID, PLANT_ID, PLAN_DATE, PRODUCTION_TYPE, TOP_ITEM_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:219 |
| cbo_plan_group | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:281 |
| mcbo_planner | SelectedIndexChanged | mcbo_planner_changed | InitEvent:282 |
| sCalendar_planday | DateTimeChanged | planday_changed | InitEvent:283 |
| cbo_fpplanid | SelectedIndexChanged | cbo_fpplanid_changed | InitEvent:284 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:286 |
| mcbo_site | SelectedIndexChanged | mcbo_site_changed | InitEvent:287 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:288 |
| mcbo_factory | SelectedIndexChanged | mcbo_factory_changed | InitEvent:289 |
| mcbo_operation | SelectedIndexChanged | mcbo_operation_changed | InitEvent:290 |
| mcbo_line | SelectedIndexChanged | mcbo_line_changed | InitEvent:291 |
| cbo_fpplanid | MouseClick | Cbo_fpplanid_MouseClick | InitEvent:294 |
| cbo_fpplanid | MouseDown | Cbo_fpplanid_MouseDown | InitEvent:295 |
| txtPjtGroup | TextChanged | TxtPjtGroup_TextChanged | InitEvent:297 |
| txtItem | TextChanged | TxtItem_TextChanged | InitEvent:298 |
| dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitEvent:301 |
| chk_allLine | CheckedChanged | chk_allLine_CheckedChanged | InitEvent:303 |
| popSql | OnSql | RunSqlSource | btnSql_Click:4350 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick:4414 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick:4426 |
| menu_line | Click | onZeroLineMenu | spdMain_CellClick:4438 |
| menu_material | Click | onZeroMaterialMenu | spdMain_CellClick:4447 |
| this.chk_includeSubOp | CheckedChanged | chk_includeSubOp_onchanged | InitializeComponent:299 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:453 |
| this.btnExcelImport | Click | btnExcelImport_Click | InitializeComponent:493 |
| this.btnToggleSave | Click | btnToggleSave_Click | InitializeComponent:532 |
| this.chk_Info | CheckedChanged | chk_Info_CheckedChanged | InitializeComponent:775 |
| this.btnMemo | Click | btnMemo_Click | InitializeComponent:1519 |
| this.btnMRP | Click | btnMRP_Click | InitializeComponent:1558 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:1570 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:1571 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:1572 |
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:1573 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:1574 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:1575 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:1576 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:1577 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1578 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1579 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:1580 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:1581 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:1582 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:1583 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:1584 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:1585 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:1586 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:1587 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:1588 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:1589 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:1590 |
| this.button1 | Click | button1_Click | InitializeComponent:1720 |
| this.btnDWSubmit | Click | btnDWSubmit_Click | InitializeComponent:1906 |
| this.btnDppWppCopyDwSubmit | Click | btnDppWppCopyDwSubmit_Click | InitializeComponent:1944 |
| this.btnRePlan | Click | btnRePlan_Click | InitializeComponent:1983 |
| this.btnSimulation | Click | btnSimulation_Click | InitializeComponent:2021 |
| this.btnMenu | Click | btnMenu_Click | InitializeComponent:2181 |
| this.btnRelease | Click | btnRelease_Click | InitializeComponent:2219 |
| this.btnCreatePlan | Click | btnCreatePlan_Click | InitializeComponent:2257 |
| this.btnBucket | Click | btnBucket_Click | InitializeComponent:2295 |
| this.btnCatagory | Click | btnCatagory_Click | InitializeComponent:2333 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:2371 |
| this.btnSet | Click | btnSet_Click | InitializeComponent:444 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:482 |
| this | Load | MeasureSetForm_Load | InitializeComponent:510 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:511 |
| this | Load | Form_Load | .ctor:96 |
| this | Load | Form_Load | .ctor:107 |
| this.btnExport | Click | btnExport_Click | InitializeComponent:151 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:246 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:279 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:360 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:361 |

## 6. 컨트롤 (154개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 28 | layoutControlItem2, layoutControlItem4, layoutControlItem3, layoutControlItem6, layoutControlItem7, layoutControlItem8, layoutControlItem9, Operation, layoutControlItem17, layoutControlItem5, lblImport, lblData, lblSql, layoutControlItem15, layoutControlItem13 … |
| CheckBox | 24 | chk_memo, chk_result, chk_act, chk_actSim, chk_wipSimAD, chk_outqty, chk_wppOut, chk_wppIn, chk_mppOut, chk_mppIn, chk_wipAD, chk_pkgProcDate, chk_pkgQty, chk_wipSim, chk_wipSimBD … |
| UsrButton | 20 | btnSql, btnExcelImport, btnToggleSave, btnMemo, btnMRP, usrButton2, btnDWSubmit, btnDppWppCopyDwSubmit, btnRePlan, btnSimulation, btnMenu, btnRelease, btnCreatePlan, btnBucket, btnCatagory … |
| Label | 14 | label3, txtBuilding, txtBasic, txtDesc, txtCreation, txtCreator, label7, label6, label5, label4, label2, label1, label1, label2 |
| Panel | 9 | infoPanel, menuPanel, panel2, panel5, panel3, panel4, panel1, panel1, panel3 |
| UsrCheckedList2 | 8 | mcbo_nicknamelt, mcbo_line, mcbo_operation, mcbo_factory, mcbo_plant, mcbo_site, mcbo_division, mcbo_planner |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 6 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrTextBox | 6 | txtNickName, txtPjtGroup, txtItem, txtNickName, txtMaterial, txtCellGroup |
| FpSpread | 5 | spdMain, spdEdit, spdInfo, spdMain, spdMain |
| SheetView | 5 | spdMain_Sheet1, spdEdit_Sheet1, spdInfo_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrCheckBox | 3 | chk_includeSubOp, chk_allLine, chk_Info |
| ImageList | 3 | imageList2, imageList1, imageList1 |
| UsrLabel | 3 | txtReleaseAlert, lblPlanID, lblTitle |
| UsrCombo | 2 | cbo_fpplanid, cbo_plan_group |
| UsrDateRangePicker | 1 | dCalendar_planrange |
| DateEdit | 1 | sCalendar_planday |
| SplitContainer | 1 | splitter |
| Button | 1 | button1 |
| GroupBox | 1 | groupBox1 |
| TextBox | 1 | tbLog |
| DataGridView | 1 | dgEdit |
| UsrButtonList | 1 | btnButtonList |
| EmptySpaceItem | 1 | emptySpaceItem1 |

## 7. 확인 필요 (8건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 4123 | btnExcelImport_Click | FP\{?default:part_service}\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 7703 | Query | FP\{?default:part_service}\AmendMemo#list_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 7704 | Query | FP\{?default:part_service}\AmendMemo#list_setup_color_code | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 8189 | dwCheck | FP\{?default:part_service}\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3543 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 7738 | Query | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 7739 | Query | FP\{?default:part_service}\PICAlarm#find_Category_Color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 6861 | Insert_Data_Excel_Buffer | FP\{?default:part_service}\FP00621_EXCELIMPORT#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 53 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 55 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 29 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 195 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00621 | Amend | 11/10 | 11/10 | 11/10 | 11/10 | 11/10 | 11/10 | 11/10 | 11/10 | 11/10 | 11/10 | 11/10 | 11/10 | 11/10 | 11/10 |
| SCM_MST_SHEET_COLUMNS | FP00621 | CN2MaterialPopup | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |
| SCM_MST_SHEET_COLUMNS | FP00621 | InvalidationCWSPopup | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend, CN2MaterialPopup, {?sSheetName}
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@DrawHeader:7583, SetSheetHeaderColumn_FP@SetSpreadInit:155, SetSheetHeaderColumn_FP@SetSpreadInit:187
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetCalenderColor |  | 7780 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 7786 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| spdMain_CellDoubleClick |  | 8261 | 표시/라벨 변경 | set:Visible | Visible = {?!spdMain.ActiveSheet.Columns[idx].Visible} |  | else!(!sHeadNameLevel2.Equals("Week Sum")) ⟫ for(idx < iWeekCount) |
| InitializeComponent |  | 1606 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1607 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1608 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1609 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2416 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2417 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2418 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2419 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2467 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2468 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2469 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2470 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 349 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 350 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 351 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 352 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 377 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 378 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 379 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 380 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |
| CN2MaterialPopup | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| InvalidationCWSPopup | 메타 정의만, 코드 미참조(미사용 가능) | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
