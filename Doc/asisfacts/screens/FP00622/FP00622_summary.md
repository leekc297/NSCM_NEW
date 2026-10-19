# FP00622 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00622_PlanAmend_Line_NJ_Pouch.UIL\FP00622_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00622_PlanAmend_Line_NJ_Pouch.UIL\FP00622_PlanAmend_Line_NJ_Pouch.UIL.csproj | 450 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00622_PlanAmend_Line_NJ_Pouch.UIL\FP00622_MeasureSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00622_PlanAmend_Line_NJ_Pouch.UIL\FP00622_PlanAmend_Line_NJ_Pouch.UIL.csproj | 663 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00622_PlanAmend_Line_NJ_Pouch.UIL\FP00622_PlanAmend_Line_NJ_Pouch.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00622_PlanAmend_Line_NJ_Pouch.UIL\FP00622_PlanAmend_Line_NJ_Pouch.UIL.csproj | 7561 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00622_PlanAmend_Line_NJ_Pouch.UIL\FP00622_PlanAmend_Line_NJ_Pouch.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00622_PlanAmend_Line_NJ_Pouch.UIL\FP00622_PlanAmend_Line_NJ_Pouch.UIL.csproj | 2811 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00622_PlanAmend_Line_NJ_Pouch.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00622_PlanAmend_Line_NJ_Pouch.UIL\FP00622_PlanAmend_Line_NJ_Pouch.UIL.csproj | 37 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP00622_PlanAmend_Line_NJ_Pouch.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 6726 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP00622_PlanAmend_Line_NJ_Pouch.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 2684 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00622_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 442 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00622_MeasureSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 633 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed > SetChangeControl | 406 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed > SetChangeControl | 406 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed | 2810 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed | 2810 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl | 406 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl | 406 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetPlanner | 4573 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetFpPlanId | 4648 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 406 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 406 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| button:FindButton | FindButton > UIFindData | 759 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData | 759 | FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 977 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 987 | FP_Planning.PR_UI_FP00622_AMEND_LINE | MATCH | SP PR_UI_FP00622_AMEND_LINE |
| button:FindButton | FindButton > UIFindData > SetReleaseProcess | 1045 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > SetReleaseProcess | 1080 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1101 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1103 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1105 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1107 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1110 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1114 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1119 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 1200 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| button:InsertButton | InsertButton > UIFindData | 759 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData | 759 | FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend | 977 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend | 987 | FP_Planning.PR_UI_FP00622_AMEND_LINE | MATCH | SP PR_UI_FP00622_AMEND_LINE |
| button:InsertButton | InsertButton > UIFindData > SetReleaseProcess | 1045 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > SetReleaseProcess | 1080 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1101 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1103 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1105 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1107 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1110 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1114 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1119 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 1200 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetChangeControl | 406 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetChangeControl | 406 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetChangeControl | 406 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetChangeControl | 406 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_line.SelectedIndexChanged | mcbo_line_changed > SetChangeControl | 406 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_line.SelectedIndexChanged | mcbo_line_changed > SetChangeControl | 406 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetChangeControl | 406 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetChangeControl | 406 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetChangeControl | 406 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetChangeControl | 406 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed | 2838 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed | 2838 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_prodtype.SelectedIndexChanged | mcbo_prodtype_changed > SetChangeControl | 406 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_prodtype.SelectedIndexChanged | mcbo_prodtype_changed > SetChangeControl | 406 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_changed > SetChangeControl | 406 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_changed > SetChangeControl | 406 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > GetOperation | 7555 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 977 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 987 | FP_Planning.PR_UI_FP00622_AMEND_LINE | MATCH | SP PR_UI_FP00622_AMEND_LINE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1101 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1103 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1105 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1107 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1110 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1114 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1119 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplySearchCondition | 1200 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Save_Data_Amend | 2410 | FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00622_AMEND_LINE_SAVE |
| event:popSql.OnSql | RunSqlSource > Save_Data_Amend_MPPWPP | 2552 | FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00622_AMEND_LINE_SAVE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 5835 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 5837 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 5839 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 5841 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 5844 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 5848 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 5853 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Excel_Import | 6083 | FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL | MATCH | SP PR_UI_FP00594_AMEND_MODEL_EXCEL |
| event:sCalendar_planday.DateTimeChanged | planday_changed > SetFpPlanId | 4648 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:sCalendar_planday.DateTimeChanged | planday_changed > SetFactory | 4742 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:sCalendar_planday.DateTimeChanged | planday_changed > SetFactory | 4742 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData | 759 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData | 759 | FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 977 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 987 | FP_Planning.PR_UI_FP00622_AMEND_LINE | MATCH | SP PR_UI_FP00622_AMEND_LINE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > SetReleaseProcess | 1045 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > SetReleaseProcess | 1080 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1101 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1103 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1105 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1107 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1110 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1114 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1119 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1200 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCal.Click | btnCal_Click > Exec_Procedure | 2618 | FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00622_AMEND_LINE_SAVE |
| event:this.btnCal.Click | btnCal_Click | 3930 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData | 759 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData | 759 | FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 977 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 987 | FP_Planning.PR_UI_FP00622_AMEND_LINE | MATCH | SP PR_UI_FP00622_AMEND_LINE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > SetReleaseProcess | 1045 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > SetReleaseProcess | 1080 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1101 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1103 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1105 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1107 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1110 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1114 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1119 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1200 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetChangeControl | 406 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetChangeControl | 406 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click | 3155 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetPlanner | 4573 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetFpPlanId | 4648 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData | 759 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData | 759 | FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend | 977 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend | 987 | FP_Planning.PR_UI_FP00622_AMEND_LINE | MATCH | SP PR_UI_FP00622_AMEND_LINE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > SetReleaseProcess | 1045 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > SetReleaseProcess | 1080 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1101 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1103 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1105 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1107 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1110 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1114 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1119 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1200 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnDppWppCopyDwSubmit.Click | btnDppWppCopyDwSubmit_Click | 3658 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnDWSubmit.Click | btnDWSubmit_Click | 3591 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > SetReleaseProcess | 1045 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > SetReleaseProcess | 1080 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnMRP.Click | btnMRP_Click | 3098 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnMRP.Click | btnMRP_Click | 3125 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH |  |
| event:this.btnMRP.Click | btnMRP_Click | 3125 | FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql |
| event:this.btnPSICalculation.Click | btnPSICalculation_Click > Exec_Procedure | 2618 | FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00622_AMEND_LINE_SAVE |
| event:this.btnPSICalculation.Click | btnPSICalculation_Click | 3344 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnPSICalculation.Click | btnPSICalculation_Click | 3366 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click | 3236 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click | 3237 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click | 3248 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click | 3266 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click | 3269 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnWOWStatus.Click | btnWOWStatus_Click | 3427 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnWOWStatus.Click | btnWOWStatus_Click | 3436 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.cbo_fpplanid.Click | cbo_fpplanid_Click > SetFpPlanId | 4648 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | MeasureSetForm_Load > InitControl | 211 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > mcbo_prodtype_changed > SetChangeControl | 406 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > mcbo_prodtype_changed > SetChangeControl | 406 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > cbo_fpplanid_changed | 2810 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > cbo_fpplanid_changed | 2810 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > mcbo_plant_changed | 2838 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > mcbo_plant_changed | 2838 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > cbo_plan_group_changed > SetPlanner | 4573 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetFpPlanId | 4648 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1409 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1410 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1444 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 1445 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > GetOperation | 7555 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.Change | spdMain_Change > SetPlanOutQty > Save_Data | 2116 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.Change | spdMain_Change > SetPlanOutQty > Save_Data > Save_Data_Amend | 2410 | FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00622_AMEND_LINE_SAVE |
| event:this.spdMain.Change | spdMain_Change > SetPlanOutQty > Save_Data > Save_Data_Amend_MPPWPP | 2552 | FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00622_AMEND_LINE_SAVE |
| event:this.spdMain.Change | spdMain_Change | 4239 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.ClipboardPasting | spdMain_ClipboardPasting > SetPlanOutQty > Save_Data | 2116 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.ClipboardPasting | spdMain_ClipboardPasting > SetPlanOutQty > Save_Data > Save_Data_Amend | 2410 | FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00622_AMEND_LINE_SAVE |
| event:this.spdMain.ClipboardPasting | spdMain_ClipboardPasting > SetPlanOutQty > Save_Data > Save_Data_Amend_MPPWPP | 2552 | FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00622_AMEND_LINE_SAVE |
| event:this.spdMain.KeyDown | spdMain_KeyDown > SetPlanOutQty > Save_Data | 2116 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.KeyDown | spdMain_KeyDown > SetPlanOutQty > Save_Data > Save_Data_Amend | 2410 | FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00622_AMEND_LINE_SAVE |
| event:this.spdMain.KeyDown | spdMain_KeyDown > SetPlanOutQty > Save_Data > Save_Data_Amend_MPPWPP | 2552 | FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00622_AMEND_LINE_SAVE |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 134 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_Data_Boh | 2273 | FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00622_AMEND_LINE_SAVE |
| unreached:(진입점 미연결) | btnSSP_Click | 3047 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | btnSSP_Click | 3073 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_SSP_Transit] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnSSP_Click | 3073 | FP\Common\XpCommonAmend#saveAll_SSP_Transit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_SSP_Transit.sql |
| unreached:(진입점 미연결) | SetBasisTime | 4550 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | SetDivision | 4560 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetBohQtyByEditCell | 5111 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | ExcelPopup_CheckBeforSave | 5916 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | ExcelPopup_CheckBeforSave | 5944 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | ExcelPopup_BufferValidation_Column | 6152 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | ExcelPopup_BufferValidation_Row | 6405 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer | 6545 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer | 6545 | FP\Common\FP00594_ExcelImport#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer_old | 6660 | FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | MATCH | SP PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE |
| unreached:(진입점 미연결) | Find_Data_Excel_Buffer_Valid | 6714 | FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | MATCH | SP PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE |
| unreached:(진입점 미연결) | Save_Data_Excel_Column | 6790 | FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | MATCH | SP PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE |
| unreached:(진입점 미연결) | Save_Data_Excel_Row | 6868 | FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | MATCH | SP PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE |
| unreached:(진입점 미연결) | Delete_Data_Excel_Buffer | 6925 | FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | MATCH | SP PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE |
| unreached:(진입점 미연결) | dwCheck | 7268 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | dwCheck | 7268 | FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_SSP_Transit] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 45 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL | MATCH | 1 | SP PR_UI_FP00594_AMEND_MODEL_EXCEL | EXEC:PR_UI_FP00594_AMEND_MODEL_EXCEL | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | MATCH | 5 | SP PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | EXEC:PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00622_AMEND_LINE | MATCH | 1 | SP PR_UI_FP00622_AMEND_LINE | EXEC:PR_UI_FP00622_AMEND_LINE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | 4 | SP PR_UI_FP00622_AMEND_LINE_SAVE | EXEC:PR_UI_FP00622_AMEND_LINE_SAVE | ⚠ DB에 SP 없음 |
| FP\Common\AmendMemo#list_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql | SELECT:FP_AMEND_MEMO_M, SELECT:FP_AMEND_SETUP_COLOR_M |  |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 4 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\FP00594_ExcelImport#insert_Excel_buffer | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\PICAlarm#find_Category | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_dwSubmit_check.sql | SELECT:FP_PROC_PARAMETER_HA |  |
| FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql | UPDATE:SCM_FP_PLAN_H |  |
| FP\Common\XpCommonAmend#saveAll_SSP_Transit | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_SSP_Transit.sql | UPDATE:SCM_FP_PLAN_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, INSTANCE_ID, PLAN_ID, AMEND_CUTOFF_BOH_TABLE, OPERATION_ID, AMEND_TABLE, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO, CATE_VALUE, CATE_TYPE |
| ApplyAmendCalendarCondition | row | MEA_ID, MEA_VALUE |
| ApplyAmendCalendarCondition_ForExcel | Filter | BUCKET_FROM, PLAN_DATE, BUCKET_TO, INSTANCE_ID, PLAN_ID, AMEND_CUTOFF_BOH_TABLE, OPERATION_ID, AMEND_TABLE, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO, CATE_VALUE, CATE_TYPE |
| ApplySearchCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, INSTANCE_ID, PLAN_ID, SITE_ID, CONFIRM_AREA, AMEND_TABLE, AMEND_SALES_TABLE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_UTIL_TABLE, PLAN_TYPE, MASTER_ID |
| btnBucket_Click | Application.OpenForms | FP00599_BucketSetForm_Popup |
| btnCal_Click | Filter | PLAN_TYPE, INSTANCE_ID, PLAN_ID |
| btnCal_Click | dtSyncCal.Rows[0] | PSI_CAL_STATUS |
| btnCatagory_Click | Application.OpenForms | FP00622_MeasureSetForm_Popup |
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
| btnExcelImport_Click | Filter | PLAN_ID, MPP_WPP, PLAN_TYPE, CURR_DATE, PLAN_DATE |
| btnExcelImport_Click | Application.OpenForms | FPC0095_ExcelSelect_Popup |
| btnExcelImport_Click | colPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE, VERSION |
| btnExcelImport_Click | colPopup.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, NICK_NAME, ITEM_TYPE, VERSION, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, LINE_NAME, ELECTRODE_TYPE |
| btnExcelImport_Click | rowPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, VERSION, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE, PLAN_DATE, QTY |
| btnExcelImport_Click | rowPopup.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, NICK_NAME, ITEM_TYPE, VERSION, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, LINE_NAME, ELECTRODE_TYPE, PLAN_DATE, QTY, MESSAGE |
| btnMemo_Click | Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID |
| btnMemo_Click | memoPopup.Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, MODEL_ID, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID, USER_ID |
| btnMRP_Click | Filter | INSTANCE_ID, PLAN_ID, PLAN_TYPE, MASTER_ID |
| btnMRP_Click | dtAuthChk.Rows[0] | AUTH_YN |
| btnPSICalculation_Click | Filter | INSTANCE_ID, PLAN_TYPE, PLAN_ID |
| btnPSICalculation_Click | dtAuthChk.Rows[0] | AUTH_YN |
| btnPSICalculation_Click | dtSyncCalculation.Rows[0] | PSI_CAL_STATUS |
| btnRelease_Click | Filter | SITE_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, DESCRIPTION, PLAN_ID |
| btnRelease_Click | dtPlanInfo.Rows[0] | DESCRIPTION |
| btnRelease_Click | dtEngineFlag.Rows[0] | INBOUND, ENGINE, OUTBOUND |
| btnRelease_Click | dtPlanRunFlag.Rows[0] | PLAN_ID, INSERT_ID |
| btnRelease_Click | dtParam2.Rows[0] | CONFIRM_AREA, IS_SAME_PLAN_ID, USE_WOW_STATUS |
| btnRelease_Click | Application.OpenForms | FP00590_GroupReleaseTotalPopup, FP00590_ReleaseTotalPopup |
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| btnSSP_Click | Filter | INSTANCE_ID, PLAN_ID, PLAN_TYPE, MASTER_ID |
| btnSSP_Click | dtAuthChk.Rows[0] | AUTH_YN |
| btnWOWStatus_Click | Filter | INSTANCE_ID, PLAN_DATE, PLAN_ID |
| btnWOWStatus_Click | dtDataInfo.Rows[0] | USE_WOW_STATUS |
| btnWOWStatus_Click | dtParam2.Rows[0] | CONFIRM_AREA, IS_SAME_PLAN_ID |
| btnWOWStatus_Click | Application.OpenForms | FP00590_WoWStatusPopup |
| cbo_fpplanid_changed | dtPlanId.Rows[selected] | PLAN_START_DATE, PLAN_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME, CODE, INSERT_ID, INSERT_TIME, DESCS, BASIC_VERSION, FACTORY_LT |
| CreateDataLine | material_column | P_IN, P_IN_CELL, P_OUT, P_OUT_CELL |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_wpp_inqty, chk_wpp_outqty, chk_mpp_inqty, chk_mpp_outqty, chk_inqty, chk_outqty, chk_result, chk_engine_inqty, chk_engine_outqty, chk_target, chk_memo, chk_subTotal, chk_memo_tot, chk_wpp_inqty_tot, chk_wpp_outqty_tot, chk_mpp_inqty_tot, chk_mpp_outqty_tot, chk_inqty_tot, chk_outqty_tot, chk_result_tot, chk_engine_inqty_tot, chk_engine_outqty_tot, chk_target_tot, chk_off, chk_setup, chk_capa, chk_total, chk_uom, chk_cell |
| CreateFilterDataSet | x | _MM_ |
| DrawHeader | Filter | BUCKET_FROM |
| DrawHeader | measure.Data | chk_day, chk_week, chk_month |
| DrawSheet | Filter | DONOTEDIT |
| dwCheck | Filter | PLAN_TYPE, DW_TABLE |
| dwCheck | dsTmp.Tables[0].Rows[0] | IS_SUBMIT |
| ExcelPopup_BufferValidation_Column | filter | MPP_WPP |
| ExcelPopup_BufferValidation_Column | Filter | PLAN_TYPE, INSTANCE_ID, PLAN_ID, COMPANY_ID, NEW_SEQ, CONFIRM_AREA, RELEASE_VALUE |
| ExcelPopup_BufferValidation_Column | dateMap.Tables[0].Rows[j] | _DATE |
| ExcelPopup_BufferValidation_Column | newrow | INSTANCE_ID, PLAN_DATE, PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, PRODUCTION_TYPE, LOCATION, MARKET, ELECTRODE_TYPE, CELL_QTY, QTY, NEW_SEQ, JOB_ORDER, PLM_EC_NO, VERSION |
| ExcelPopup_BufferValidation_Column | data.Tables[0].Rows[i] | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, PRODUCTION_TYPE, LOCATION, MARKET, ELECTRODE_TYPE, VERSION |
| ExcelPopup_BufferValidation_Column | each_row | _VALID |
| ExcelPopup_BufferValidation_Row | filter | MPP_WPP |
| ExcelPopup_BufferValidation_Row | data.Tables[0].Rows[i] | QTY, PLAN_DATE, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, PRODUCTION_TYPE, LOCATION, MARKET, ELECTRODE_TYPE, VERSION |
| ExcelPopup_BufferValidation_Row | newrow | INSTANCE_ID, PLAN_DATE, PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, PRODUCTION_TYPE, LOCATION, MARKET, ELECTRODE_TYPE, CELL_QTY, QTY, PLM_EC_NO, VERSION, NEW_SEQ, JOB_ORDER |
| ExcelPopup_BufferValidation_Row | Filter | INSTANCE_ID, PLAN_ID, COMPANY_ID, NEW_SEQ, PLAN_TYPE, PLAN_DATE, CONFIRM_AREA, RELEASE_VALUE |
| ExcelPopup_BufferValidation_Row | each_row | _VALID |
| ExcelPopup_CheckBeforSave | Filter | PLAN_TYPE, INSTANCE_ID, PLAN_ID, SITE_ID, CONFIRM_AREA, RELEASE_VALUE, PLAN_DATE |
| ExcelPopup_CheckBeforSave | dtIsCurrWeek.Rows[0] | RELEASE_VALUE, IS_LATEST_PLAN, RELEASE_PLAN_ID |
| ExcelPopup_CheckBeforSave | dtChk.Rows[0] | _TYPE |
| ExcelPopup_SaveExcel_Column | filter | MPP_WPP |
| ExcelPopup_SaveExcel_Column | Filter | PLAN_TYPE, NEW_SEQ, MPP_WPP |
| ExcelPopup_SaveExcel_Row | filter | MPP_WPP |
| ExcelPopup_SaveExcel_Row | Filter | PLAN_TYPE, PLAN_ID, NEW_SEQ, MPP_WPP |
| ExcelPopup_Search_Column | Filter | BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| ExcelPopup_Search_Column | filter | MPP_WPP |
| ExcelPopup_Search_Row | Filter | BUCKET_FROM, BUCKET_TO, PLAN_ID, PLAN_TYPE |
| ExcelPopup_Search_Row | filter | MPP_WPP |
| Exec_Procedure | Filter | INSTANCE_ID, PLAN_ID |
| Find_Data_Amend | Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, PLAN_DATE, INSTANCE_ID, MASTER_ID, PLAN_ID, PLAN_TYPE, PROD_TYPE, NICK_NAME, NICK_NAME_LT, TOP_ITEM_ID, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, CATE_INFO, CATE_VALUE, CATE_TYPE, AMEND_TABLE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_SALES_TABLE, AMEND_UTIL_TABLE |
| Find_Line_Savings_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | related_row | CATEGORY_ID, PRODUCTION_TYPE |
| Find_MaterialData_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | related_row | CATEGORY_ID |
| GetOperation | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, AMEND_MAIN_FLAG, OPERATION_ID |
| GetPlanGroup | Filter | USER_ID, MASTER_ID, INSTANCE_ID, USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| GetPlanGroup | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| GoEditMode | Filter | PLAN_TYPE, PLAN_ID |
| GoEditMode | row | DATA_TYPE, MEASURE_ID, CATEGORY_ID, EDIT_YN |
| InitControls | Filter | USER_ID, MASTER_ID, INSTANCE_ID |
| Insert_Data_Excel_Buffer | result.Rows[0] | RESULT, EXCEPTION |
| Insert_Data_Excel_Buffer_old | dsData.Tables[0].Rows[i] | INSTANCE_ID, PLAN_DATE, PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, PRODUCTION_TYPE, LOCATION, MARKET, ELECTRODE_TYPE, CELL_QTY, QTY, NEW_SEQ, MPP_WPP |
| InsertButton | row | DATA_TYPE, DIVISION_ID, SITE_ID, PLANT_ID |
| InsertButton | popup.Filter | DIVISION_ID, SITE_ID, PLANT_ID |
| onNLFAmendMenu | frm.Filter | MASTER_ID, FP_PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onNLFAmendMenu | Filter | INSTANCE_ID, PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onZeroBucketMenu | row_to_test | CATEGORY_ID |
| onZeroMaterialMenu | row_to_test | CATEGORY_ID |
| OpenAlarmMemo | row | PRODUCTION_TYPE |
| OpenAlarmMemo | frm.Filter | MEMO_TYPE |
| OpenLineMemo | frm.Filter | MEMO_TYPE |
| OpenMaterialMemo | frm.Filter | MEMO_TYPE |
| planday_changed | Filter | PLAN_DATE |
| Query | d | DIVISION_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, MARKET, PLAN_DATE, PRODUCTION_TYPE, SETUP_COLOR_CODE |
| Query | m | ATTR1 |
| Query | rCate | SEGMENT1, ATTRIBUTE2 |
| RunSqlSource | Filter | PLAN_TYPE |
| Save_Data | Filter | INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, PLAN_TYPE |
| Save_Data | dtCheckSave.Rows[0] | _TYPE |
| Save_Data_Amend | dtData.Rows[i] | M, INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ITEM_ID, TOP_ITEM_ID, ITEM_TYPE, LOCATION, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, CATEGORY_ID, P_IN_QTY, P_OUT_QTY, MPP_IN_QTY, MPP_OUT_QTY, WPP_IN_QTY, WPP_OUT_QTY, PLM_EC_NO, VERSION |
| Save_Data_Amend_MPPWPP | dtData.Rows[i] | M, INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ITEM_ID, TOP_ITEM_ID, ITEM_TYPE, LOCATION, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, CATEGORY_ID, P_IN_QTY, P_OUT_QTY, MPP_IN_QTY, MPP_OUT_QTY, WPP_IN_QTY, WPP_OUT_QTY, PLM_EC_NO, VERSION |
| Save_Data_Boh | dsBoh.Tables[0].Rows[i] | ACTION, INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, TOP_ITEM_ID, LOCATION, QTY |
| SetBasisTime | dtBaseTime.Rows[0] | BASIS_TIME |
| SetBohQty | row | DATA_TYPE, OPERATION_ID, BOH_QTY, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohQty | each_row | _TYPE, OPERATION_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohQty | result.First() | QTY |
| SetBohQtyByEditCell | each_row | IS_PLAN |
| SetBohQtyByEditCell | dtResult.Rows[0] | D_VALUE |
| SetBohQtyByEditCell | dtResult.Rows[dtResult.Rows.Count - 1] | D_VALUE |
| SetBohQtyByEditCell | dsMainFiltered.Tables[0].Rows[cRow] | LV1, DATA_TYPE |
| SetBohQtyByEditCell | dsMainFiltered.Tables[0].Rows[i] | LV1, PSI, CATEGORY_ID, BOH_QTY, DATA_TYPE, S_ROW |
| SetBohQtyByEditCell | Filter | INSTANCE_ID, PLAN_ID, PLAN_DATE, AMEND_CUTOFF_BOH_TABLE |
| SetBohQtyByEditCell | x | DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, LOCATION, TOP_ITEM_ID, ITEM_ID |
| SetBohQtyByEditCell | row | DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, LOCATION, TOP_ITEM_ID, ITEM_ID, INSTANCE_ID, FP_PLAN_ID, COMPANY_ID |
| SetBohQtyByEditCell | selected | ORIG_QTY, ACTION, QTY |
| SetBohQtyByEditCell | newrow | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, TOP_ITEM_ID, LOCATION, QTY, ORIG_QTY, ACTION |
| SetChangeControl | Filter | MASTER_ID, INSTANCE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PRODTYPE_ID, PRODUCTION_TYPE, PROD_TYPE |
| SetChangeControl | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| SetDivision | Filter | INSTANCE_ID |
| SetFpPlanId | dtPlanId.Rows[iDx] | PLAN_START_DATE, PLAN_END_DATE, UI_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME, CODE |
| SetFpPlanId | dtPlanId.Rows[0] | INSERT_ID, INSERT_TIME, DESCS, BASIC_VERSION, FACTORY_LT |
| SetFpPlanId | Filter | PLAN_TYPE |
| SetLine | Filter | ALL_LINE |
| setMeasualFormData | dtCategory.Rows[i] | MEA_ID, MEA_VALUE |
| SetNickName_LT | Filter | AMEND_TABLE, AMEND_SALES_TABLE, PLAN_TYPE |
| SetPlanner | row | NAME, DEFAULT_CHECK, CODE |
| SetPlanner | Filter | ALL_LINE |
| SetPlanOutQty | clicked_row | CATEGORY_ID |
| SetPlanOutQty | each_row | IS_PLAN |
| SetPlanOutQty | dtResult.Rows[0] | D_VALUE |
| SetPlanOutQty | dtResult.Rows[dtResult.Rows.Count - 1] | D_VALUE |
| SetPlanOutQty | dsMainFiltered.Tables[0].Rows[cRow] | LINE_ID |
| SetPlanOutQty | dsMainFiltered.Tables[0].Rows[i] | DATA_TYPE, LINE_ID, CATEGORY_ID |
| SetPlanOutQty | Filter | INSTANCE_ID, FP_PLAN_ID |
| SetPlanOutQty | x | INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, CATEGORY_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, LOCATION, PLAN_DATE, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, PLM_EC_NO, VERSION |
| SetPlanOutQty | row | DIVISION_ID, CATEGORY_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, LOCATION, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, PLM_EC_NO, VERSION, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE |
| SetPlanOutQty | selected | P_IN_QTY, P_OUT_QTY, ORIG_IN_QTY, ORIG_OUT_QTY, M, MPP_IN_QTY, MPP_OUT_QTY, WPP_IN_QTY, WPP_OUT_QTY |
| SetPlanOutQty | newrow | INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, COMPANY_ID, CATEGORY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, PLAN_DATE, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, PLM_EC_NO, VERSION, P_IN_QTY, P_OUT_QTY, ORIG_IN_QTY, ORIG_OUT_QTY, MPP_IN_QTY, MPP_OUT_QTY, WPP_IN_QTY, WPP_OUT_QTY, M |
| SetPlanPeriod | dtPlanId.Rows[0] | PLAN_START_DATE, PLAN_END_DATE, DEFAULT_START_DATE, DEFAULT_END_DATE |
| SetReleaseProcess | Filter | PLAN_TYPE, INSTANCE_ID, PLAN_ID, SITE_ID, CONFIRM_AREA, IS_LATEST_PLAN, CURR_DATE, RELEASE_VALUE |
| SetReleaseProcess | dtIsCurrWeek.Rows[0] | CURR_DATE, IS_LATEST_PLAN, RELEASE_VALUE |
| SetReleaseProcess | row | _DATE, IS_PLAN |
| SetReleaseProcess | dtLastestSubmitInfo.Rows[0] | FP_PLAN_ID, RELEASE_TYPE |
| SetTotalColor | row | DATA_TYPE |
| spdMain_CellClick | row | LINE_ID, PRODUCTION_TYPE, DATA_TYPE, OPERATION_ID, TOP_ITEM_ID |
| spdMain_Change | Filter | PLAN_TYPE, INSTANCE_ID, PLAN_ID, SITE_ID, CONFIRM_AREA |
| spdMain_Change | dtIsCurrWeek.Rows[0] | IS_LATEST_PLAN, RELEASE_PLAN_ID, RELEASE_VALU |
| SwitchMemo | r | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET |
| SwitchMemo | memoRow | PRODUCTION_TYPE, ITEM_ID |
| SwitchMemo | memo[k] | ITEM_ID |
| SwitchMemo | materialRow | PRODUCTION_TYPE |
| UIFindData | Filter | PLAN_ID, DONOTEDIT, COMPANY_ID, USE_WOW_STATUS, PLAN_TYPE, PLAN_NAME, DW_TABLE |
| UIFindData | dsMain.Tables[0].Rows[0] | COMPANY_ID |
| UIFindData | dsTmp.Tables[0].Rows[0] | IS_SUBMIT |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:202, InitControl:286, RefreshSpreadSheet:1241, CheckAndGetMeasure:1721 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| SetFilter | InitControls:306, InitControls:307, InitControls:308, InitControls:309, InitControls:310, InitControls:320, InitControls:321, SetChangeControl:379 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetInnerTable | SetChangeControl:373, SetChangeControl:382, SetChangeControl:390, SetChangeControl:398, SetChangeControl:406, SetChangeControl:415, SetChangeControl:423, GetPlanGroup:4624 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| GetCheckedListValue | SetChangeControl:377, SetChangeControl:389, SetChangeControl:397, SetChangeControl:405, SetChangeControl:414, SetChangeControl:422, SetChangeControl:430, SetChangeControl:439 | CString.GetCheckedListValue | CODE |
| SetTotalColor | RefreshHeader:574, DrawSheet:1389 | SpreadInfo.SetTotalColor | column_cnt, grouping_cnt, row_idx |
| LoadAmendColumn | DrawHeader:1349 | MeasureService.LoadAmendColumn | DAYTAG, MONTHTAG, WEEKTAG |
| ShowMemoLine | DrawSheet:1392 | MemoService.ShowMemoLine | ATTR1, ATTR2, ATTRIBUTE10, ATTRIBUTE2, COLOR_A, COLOR_B, DATA_TYPE, Default, ELECTRODE_TYPE, EQUIPMENT_ID, INSTANCE_ID, ITEM_ID, PRODUCTION_TYPE, SEGMENT1, UI_COLOR, UI_DESC, UI_PARAM, chk_day |
| ApplyMemoTextLine | Query:1460 | MemoService.ApplyMemoTextLine | ATTR2, CATEGORY_ID, COMPANY_ID, DATA_TYPE, DIVISION_ID, ELECTRODE_TYPE, EQUIPMENT_ID, FACTORY_ID, ITEM_ID, LINE_ID, MARKET, MEMO, OPERATION_ID, PLANT_ID, PLAN_DATE, PRODUCTION_TYPE, TOP_ITEM_ID |
| EditQuery | Query:1461 | FPExtensions.EditQuery | ROW_ID |
| ApplyMemoTagLine | Query:1463 | MemoService.ApplyMemoTagLine | CATEGORY_ID, COMPANY_ID, DATA_TYPE, DIVISION_ID, ELECTRODE_TYPE, FACTORY_ID, ITEM_ID, LINE_ID, MARKET, OPERATION_ID, PLANT_ID, PLAN_DATE, PRODUCTION_TYPE, TOP_ITEM_ID |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:2061 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| SetRowsUnVisible | CreateFilterDataSet:2064 | MeasureService.SetRowsUnVisible | _MM_ |
| FP_Log2 | mcbo_planner_changed:2701, mcbo_planner_changed:2706 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetProdType | SetProdType:4761 | DataService.GetProdType | CODE, DIVISION_ID, NAME |
| FP_PseudoBatch | Insert_Data_Excel_Buffer:6545 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnSet | Click | btnSet_Click | InitializeComponent:537 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:575 |
| this | Load | MeasureSetForm_Load | InitializeComponent:604 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:605 |
| this | Load | Form_Load | .ctor:200 |
| cbo_plan_group | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:263 |
| mcbo_planner | SelectedIndexChanged | mcbo_planner_changed | InitEvent:264 |
| sCalendar_planday | DateTimeChanged | planday_changed | InitEvent:265 |
| cbo_fpplanid | SelectedIndexChanged | cbo_fpplanid_changed | InitEvent:266 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:268 |
| mcbo_site | SelectedIndexChanged | mcbo_site_changed | InitEvent:269 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:270 |
| mcbo_factory | SelectedIndexChanged | mcbo_factory_changed | InitEvent:271 |
| mcbo_operation | SelectedIndexChanged | mcbo_operation_changed | InitEvent:272 |
| mcbo_line | SelectedIndexChanged | mcbo_line_changed | InitEvent:273 |
| txtModel | TextChanged | TxtModel_TextChanged | InitEvent:276 |
| txtItem | TextChanged | TxtItem_TextChanged | InitEvent:277 |
| mcbo_prodtype | SelectedIndexChanged | mcbo_prodtype_changed | InitEvent:280 |
| dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitEvent:282 |
| chk_allLine | CheckedChanged | chk_allLine_CheckedChanged | InitEvent:284 |
| popSql | OnSql | RunSqlSource | btnSql_Click:3970 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick:4049 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick:4061 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick:4076 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick:4088 |
| nlfamend_menu | Click | onNLFAmendMenu | spdMain_CellClick:4095 |
| this.btnCal | Click | btnCal_Click | InitializeComponent:339 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:424 |
| this.btnExcelImport | Click | btnExcelImport_Click | InitializeComponent:464 |
| this.btnToggleSave | Click | btnToggleSave_Click | InitializeComponent:503 |
| this.chk_Info | CheckedChanged | chk_Info_CheckedChanged | InitializeComponent:824 |
| this.cbo_fpplanid | Click | cbo_fpplanid_Click | InitializeComponent:1033 |
| this.btnWOWStatus | Click | btnWOWStatus_Click | InitializeComponent:1584 |
| this.btnPSICalculation | Click | btnPSICalculation_Click | InitializeComponent:1623 |
| this.btnMemo | Click | btnMemo_Click | InitializeComponent:1662 |
| this.btnMRP | Click | btnMRP_Click | InitializeComponent:1701 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:1713 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:1714 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:1715 |
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:1716 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:1717 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:1718 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:1719 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1720 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1721 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:1722 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:1723 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:1724 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:1725 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:1726 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:1727 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:1728 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:1729 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:1730 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:1731 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:1732 |
| this.button1 | Click | button1_Click | InitializeComponent:1862 |
| this.btnDWSubmit | Click | btnDWSubmit_Click | InitializeComponent:2048 |
| this.btnDppWppCopyDwSubmit | Click | btnDppWppCopyDwSubmit_Click | InitializeComponent:2086 |
| this.btnMenu | Click | btnMenu_Click | InitializeComponent:2285 |
| this.btnRelease2 | Click | btnRelease_Click | InitializeComponent:2323 |
| this.btnCreatePlan2 | Click | btnCreatePlan_Click | InitializeComponent:2361 |
| this.btnBucket | Click | btnBucket_Click | InitializeComponent:2399 |
| this.btnCatagory | Click | btnCatagory_Click | InitializeComponent:2437 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:2475 |

## 6. 컨트롤 (134개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| CheckBox | 29 | chk_memo, chk_target, chk_engine_outqty, chk_engine_inqty, chk_result, chk_outqty, chk_inqty, chk_mpp_outqty, chk_mpp_inqty, chk_wpp_outqty, chk_wpp_inqty, chk_cell, chk_uom, chk_wpp_outqty_tot, chk_wpp_inqty_tot … |
| LayoutControlItem | 22 | layoutControlItem2, layoutControlItem4, layoutControlItem3, layoutControlItem6, layoutControlItem7, layoutControlItem8, Operation, layoutControlItem10, layoutControlItem11, layoutControlItem17, layoutControlItem5, lblImport, lblData, lblSql, layoutControlItem14 … |
| UsrButton | 19 | btnSet, btnOK, btnCal, btnSql, btnExcelImport, btnToggleSave, btnWOWStatus, btnPSICalculation, btnMemo, btnMRP, usrButton2, btnDWSubmit, btnDppWppCopyDwSubmit, btnMenu, btnRelease2 … |
| Label | 15 | label1, label4, label2, label3, txtBuilding, txtBasic, txtDesc, txtCreation, txtCreator, label7, label6, label5, label4, label2, label1 |
| Panel | 10 | panel1, panel2, panel3, infoPanel, menuPanel, panel2, panel3, panel6, panel4, panel1 |
| UsrCheckedList2 | 9 | mcbo_nickname, mcbo_prodtype, mcbo_line, mcbo_operation, mcbo_factory, mcbo_plant, mcbo_site, mcbo_division, mcbo_planner |
| UsrTextBox | 3 | txtNickName, txtItem, txtModel |
| FpSpread | 3 | spdMain, spdEdit, spdInfo |
| SheetView | 3 | spdMain_Sheet1, spdEdit_Sheet1, spdInfo_Sheet1 |
| UsrLabel | 3 | txtReleaseAlert, lblSummitInfo, lblPlanID |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCheckBox | 2 | chk_allLine, chk_Info |
| UsrCombo | 2 | cbo_fpplanid, cbo_plan_group |
| ImageList | 2 | imageList2, imageList1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePicker | 1 | dCalendar_planrange |
| DateEdit | 1 | sCalendar_planday |
| SplitContainer | 1 | splitter |
| Button | 1 | button1 |
| GroupBox | 1 | groupBox1 |
| TextBox | 1 | tbLog |
| DataGridView | 1 | dgEdit |

## 7. 확인 필요 (9건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 759 | UIFindData | FP\{?default:part_service}\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1409 | Query | FP\{?default:part_service}\AmendMemo#list_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1410 | Query | FP\{?default:part_service}\AmendMemo#list_setup_color_code | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 7268 | dwCheck | FP\{?default:part_service}\XpCommonAmend#find_dwSubmit_check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3073 | btnSSP_Click | FP\{?default:part_service}\XpCommonAmend#saveAll_SSP_Transit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3125 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1444 | Query | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1445 | Query | FP\{?default:part_service}\PICAlarm#find_Category_Color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 6545 | Insert_Data_Excel_Buffer | FP\{?default:part_service}\FP00594_EXCELIMPORT#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 24 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 27 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 6 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 7 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 24 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 910 | FP_Planning.PR_UI_FP00622_AMEND_LINE | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00622 | Amend | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@DrawHeader:1298
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetCalenderColor |  | 1486 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 1492 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| spdMain_CellDoubleClick |  | 7342 | 표시/라벨 변경 | set:Visible | Visible = {?!spdMain.ActiveSheet.Columns[idx].Visible} |  | else!(!sHeadNameLevel2.Equals("Week Sum")) ⟫ for(idx < iWeekCount) |
| InitializeComponent |  | 1748 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1749 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1750 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1751 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2519 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2520 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2521 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2522 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2570 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2571 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2572 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2573 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
