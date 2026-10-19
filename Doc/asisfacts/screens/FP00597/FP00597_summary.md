# FP00597 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_BucketSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_PlanAmend_Model_PreMix.UIL.csproj | 263 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_BucketSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_PlanAmend_Model_PreMix.UIL.csproj | 200 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_ExcelPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_PlanAmend_Model_PreMix.UIL.csproj | 1077 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_ExcelPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_PlanAmend_Model_PreMix.UIL.csproj | 659 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_PlanAmend_Model_PreMix.UIL.csproj | 403 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_MeasureSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_PlanAmend_Model_PreMix.UIL.csproj | 363 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_PlanAmend_Model_PreMix.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_PlanAmend_Model_PreMix.UIL.csproj | 6804 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_PlanAmend_Model_PreMix.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_PlanAmend_Model_PreMix.UIL.csproj | 2389 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_RowExcelPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_PlanAmend_Model_PreMix.UIL.csproj | 1093 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_RowExcelPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_PlanAmend_Model_PreMix.UIL.csproj | 589 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_PlanAmend_Model_PreMix.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00597_PlanAmend_Model_PreMix.UIL\FP00597_PlanAmend_Model_PreMix.UIL.csproj | 64 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:bucke_menu.Click | onZeroBucketMenu > EditByFunc > EditCommon > SetPlanInBatch_DataSet | 4148 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:bucke_menu.Click | onZeroBucketMenu > EditByFunc > EditCommon > SetPlanInBatch_DataSet > lfn_getYieldInfo | 4651 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed > SetFactory | 3960 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetBasisTime | 3759 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetDivision | 3769 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetPlanner | 3782 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetFpPlanId | 3875 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetSite | 3942 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetPlant | 3949 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetFactory | 3960 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetOperation | 3971 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetLine | 3985 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetLine | 3985 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > FindTotalValue | 865 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 944 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1059 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1065 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1067 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1069 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1072 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1132 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > GetListDataSet | 1160 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > GetListDataSet | 1163 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > GetListDataSet | 1167 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > FindTotalValue > SetPlanGroup | 3843 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| button:InsertButton | InsertButton > UIFindData > FindTotalValue | 865 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend | 944 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1059 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1065 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1067 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1069 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1072 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1132 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > GetListDataSet | 1160 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > GetListDataSet | 1163 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > GetListDataSet | 1167 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > FindTotalValue > SetPlanGroup | 3843 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetPlant | 3949 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetOperation | 3971 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetLine | 3985 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_planner.SelectedIndexChanged | mcbo_planner_changed > SetLine | 3985 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetFactory | 3960 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_changed > SetPlant | 3949 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > GetOperation | 6798 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:menu_line.Click | onZeroLineMenu > EditByFunc > EditCommon > SetPlanInBatch_DataSet | 4148 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:menu_line.Click | onZeroLineMenu > EditByFunc > EditCommon > SetPlanInBatch_DataSet > lfn_getYieldInfo | 4651 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:menu_material.Click | onZeroMaterialMenu > EditByFunc > EditCommon > SetPlanInBatch_DataSet | 4148 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:menu_material.Click | onZeroMaterialMenu > EditByFunc > EditCommon > SetPlanInBatch_DataSet > lfn_getYieldInfo | 4651 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > FindTotalValue | 865 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 944 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| event:popSql.OnSql | RunSqlSource > ApplySearchCondition | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1059 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1065 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1067 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1069 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 1072 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > lfn_setReleaseProcess | 1132 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > GetListDataSet | 1160 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > GetListDataSet | 1163 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel > GetListDataSet | 1167 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Save_Valid | 1788 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| event:popSql.OnSql | RunSqlSource > Save_Data_Amend | 1926 | FP_Planning.PR_UI_FP00597_AMEND_MODEL_SAVE | MATCH | SP PR_UI_FP00597_AMEND_MODEL_SAVE |
| event:popSql.OnSql | RunSqlSource > FindTotalValue > SetPlanGroup | 3843 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 4922 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 4928 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 4930 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 4932 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition_ForExcel | 4938 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Excel_Import | 5151 | FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL | MATCH | SP PR_UI_FP00596_AMEND_LINE_EXCEL |
| button:SaveButton | SaveButton > UIFindData > FindTotalValue | 865 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend | 944 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1059 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1065 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1067 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1069 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1072 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1132 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > GetListDataSet | 1160 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > GetListDataSet | 1163 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > GetListDataSet | 1167 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > Save_PIanBatch_Data | 1656 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > Save_PIanBatch_Data > Find_Save_Valid | 1788 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| button:SaveButton | SaveButton > Save_PIanBatch_Data > Save_Data_Amend | 1926 | FP_Planning.PR_UI_FP00597_AMEND_MODEL_SAVE | MATCH | SP PR_UI_FP00597_AMEND_MODEL_SAVE |
| button:SaveButton | SaveButton > Exec_Procedure | 1988 | FP_Planning.PR_UI_FP00597_AMEND_MODEL_SAVE | MATCH | SP PR_UI_FP00597_AMEND_MODEL_SAVE |
| button:SaveButton | SaveButton > UIFindData > FindTotalValue > SetPlanGroup | 3843 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:sCalendar_planday.DateTimeChanged | planday_changed > SetFpPlanId > SetBasisTime | 3759 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:sCalendar_planday.DateTimeChanged | planday_changed > SetFpPlanId | 3875 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindTotalValue | 865 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 944 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1059 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1065 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1067 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1069 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1072 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1132 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > GetListDataSet | 1160 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > GetListDataSet | 1163 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > GetListDataSet | 1167 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindTotalValue > SetPlanGroup | 3843 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > FindTotalValue | 865 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 944 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1059 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1065 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1067 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1069 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1072 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1132 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > GetListDataSet | 1160 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > GetListDataSet | 1163 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > GetListDataSet | 1167 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > FindTotalValue > SetPlanGroup | 3843 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > FindTotalValue | 865 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend | 944 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1059 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1065 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1067 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1069 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1072 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1132 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > GetListDataSet | 1160 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > GetListDataSet | 1163 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > GetListDataSet | 1167 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click | 2559 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetChangeControl > SetBasisTime | 3759 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetChangeControl > SetDivision | 3769 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetChangeControl > SetPlanner | 3782 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > FindTotalValue > SetPlanGroup | 3843 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetFpPlanId | 3875 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetChangeControl > SetSite | 3942 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetChangeControl > SetPlant | 3949 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetChangeControl > SetFactory | 3960 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetChangeControl > SetOperation | 3971 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > cbo_plan_group_changed > SetChangeControl > SetLine | 3985 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnCreatePlan2.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindTotalValue | 865 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend | 944 | FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | SP PR_UI_FP00597_AMEND_MODEL |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1015 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1059 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1065 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1067 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1069 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1072 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1132 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > GetListDataSet | 1160 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > GetListDataSet | 1163 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > GetListDataSet | 1167 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > Exec_Procedure | 1988 | FP_Planning.PR_UI_FP00597_AMEND_MODEL_SAVE | MATCH | SP PR_UI_FP00597_AMEND_MODEL_SAVE |
| event:this.btnExcelImport.Click | btnExcelImport_Click | 2824 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindTotalValue > SetPlanGroup | 3843 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnMRP.Click | btnMRP_Click | 2501 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnMRP.Click | btnMRP_Click | 2529 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH |  |
| event:this.btnMRP.Click | btnMRP_Click | 2529 | FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql |
| event:this.btnRelease2.Click | btnRelease_Click | 2640 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click | 2641 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click | 2652 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click | 2672 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click | 2675 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click > SetFpPlanId > SetBasisTime | 3759 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease2.Click | btnRelease_Click > SetFpPlanId | 3875 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnUpload.Click | btnUpload_Click > SearchListInfoAll | 935 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnUpload.Click | btnUpload_Click > SearchListInfoAll | 942 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnUpload.Click | btnUpload_Click > SearchListInfoAll | 945 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.chk_includeSubOp.CheckedChanged | chk_includeSubOp_onchanged > SetOperation | 3971 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | MeasureSetForm_Load > InitControl | 168 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetBasisTime | 3759 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetDivision | 3769 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetPlanner | 3782 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetPlanGroup | 3843 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetFpPlanId | 3875 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetSite | 3942 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetPlant | 3949 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetFactory | 3960 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetOperation | 3971 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetLine | 3985 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6352 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6353 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6387 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 6388 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > GetOperation | 6798 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.Change | spdMain_Change > EditByChange > EditCommon > SetPlanInBatch_DataSet | 4148 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.Change | spdMain_Change > EditByChange > EditCommon > SetPlanInBatch_DataSet > lfn_getYieldInfo | 4651 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 138 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Exec_Procedure | 773 | FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00622_AMEND_LINE_SAVE |
| unreached:(진입점 미연결) | ExcelPopup_CheckBeforSave | 5008 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | SearchListInfoAll | 5038 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | SearchListInfoAll | 5041 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer | 5497 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer | 5497 | FP\Common\FP00596_ExcelImport#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | Find_Data_Excel_Buffer_Valid | 5540 | FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE | MATCH | SP PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE |
| unreached:(진입점 미연결) | Save_Data_Excel_Column | 5599 | FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE | MATCH | SP PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE |
| unreached:(진입점 미연결) | Save_Data_Excel_Row | 5658 | FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE | MATCH | SP PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE |
| unreached:(진입점 미연결) | Delete_Data_Excel_Buffer | 5698 | FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE | MATCH | SP PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 1 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 41 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL | MATCH | 1 | SP PR_UI_FP00596_AMEND_LINE_EXCEL | EXEC:PR_UI_FP00596_AMEND_LINE_EXCEL | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE | MATCH | 4 | SP PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE | EXEC:PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00597_AMEND_MODEL | MATCH | 3 | SP PR_UI_FP00597_AMEND_MODEL | EXEC:PR_UI_FP00597_AMEND_MODEL | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00597_AMEND_MODEL_SAVE | MATCH | 2 | SP PR_UI_FP00597_AMEND_MODEL_SAVE | EXEC:PR_UI_FP00597_AMEND_MODEL_SAVE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | MATCH | 1 | SP PR_UI_FP00622_AMEND_LINE_SAVE | EXEC:PR_UI_FP00622_AMEND_LINE_SAVE | ⚠ DB에 SP 없음 |
| FP\Common\AmendMemo#list_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql | SELECT:FP_AMEND_MEMO_M, SELECT:FP_AMEND_SETUP_COLOR_M |  |
| FP\Common\FP00596_ExcelImport#insert_Excel_buffer | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\PICAlarm#find_Category | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql | UPDATE:SCM_FP_PLAN_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO, CATE_VALUE, CATE_TYPE |
| ApplyAmendCalendarCondition | row | MEA_ID, MEA_VALUE |
| ApplyAmendCalendarCondition_ForExcel | Filter | BUCKET_FROM, PLAN_DATE, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO, CATE_VALUE, CATE_TYPE |
| ApplySearchCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, INSTANCE_ID, PLAN_ID, AMEND_TABLE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_BOH_TABLE, AMEND_SALES_TABLE, AMEND_UTIL_TABLE, AMEND_CAPA_TABLE, PLAN_TYPE, MASTER_ID |
| btnBucket_Click | Application.OpenForms | FP00597_BucketSetForm_Popup |
| btnCatagory_Click | Application.OpenForms | FP00597_MeasureSetForm_Popup |
| btnColumn_Click | Application.OpenForms | FPC0097_ColumnSetForm_Popup |
| btnCreatePlan_Click | Filter | SITE_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE |
| btnCreatePlan_Click | dtPlanRunFlag.Rows[0] | PLAN_ID, INSERT_ID |
| btnCreatePlan_Click | Application.OpenForms | FP00590_PlanTotalPopup |
| btnExcelImport_Click | Filter | PLAN_TYPE, INSTANCE_ID, PLAN_DATE |
| btnExcelImport_Click | Application.OpenForms | FPC0095_ExcelSelect_Popup |
| btnExcelImport_Click | colPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, MARKET |
| btnExcelImport_Click | colPopup.ColumnTitle | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, LINE_NAME, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, MARKET |
| btnExcelImport_Click | rowPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, PLAN_DATE, QTY, SEQ |
| btnExcelImport_Click | rowPopup.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, LINE_NAME, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, MARKET, PLAN_DATE, ADJUST_IN_QTY_KG, QTY, SEQ |
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
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| btnUpload_Click | each_row | DIVISION_ID, ITEM_ID |
| btnUpload_Click | row | DIVISION_ID, ITEM_ID, APPLIED_MODEL |
| btnUpload_Click | UomResult.First() | VALUE |
| btnUpload_Click | dsSource.Tables[0].Rows[iRow] | PLAN_DATE, QTY, ADJUST_IN_QTY_KG |
| cbo_fpplanid_changed | dtPlanId.Rows[selected] | PLAN_START_DATE, PLAN_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME, CODE, INSERT_ID, INSERT_TIME, DESCS, BASIC_VERSION, FACTORY_LT |
| cbo_plan_group_changed | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| chk_includeSubOp_onchanged | Filter | AMEND_MAIN_FLAG |
| CreateDataLine | material_column | P_IN, P_IN_CELL, P_OUT, P_OUT_CELL |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_inqty, chk_outqty, chk_result, chk_s, chk_i, chk_memo, chk_subTotal, chk_total, chk_kg, chk_batch |
| CreateFilterDataSet | x | _MM_ |
| Delete_Data_Excel_Buffer | Filter | INSTANCE_ID |
| DrawHeader | Filter | BUCKET_FROM |
| DrawHeader | measure.Data | chk_day, chk_week, chk_month |
| DrawSheet | Filter | DONOTEDIT |
| dtpPeriod_ValueChanged | Filter | PLAN_TYPE, CURR_DATE |
| ExcelPopup_BufferValidation_Column | filter | MPP_WPP |
| ExcelPopup_BufferValidation_Column | Filter | PLAN_TYPE, INSTANCE_ID, PLAN_ID, COMPANY_ID, PLAN_DATE, SITE_ID |
| ExcelPopup_BufferValidation_Column | dateMap.Tables[0].Rows[j] | _DATE |
| ExcelPopup_BufferValidation_Column | newrow | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, QTY, SEQ, ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY_KG, ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY_KG, USER_ID, JOB_ORDER |
| ExcelPopup_BufferValidation_Column | data.Tables[0].Rows[i] | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, MARKET |
| ExcelPopup_BufferValidation_Column | each_row | _VALID |
| ExcelPopup_BufferValidation_Row | filter | MPP_WPP |
| ExcelPopup_BufferValidation_Row | data.Tables[0].Rows[i] | QTY, PLAN_DATE, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, SEQ |
| ExcelPopup_BufferValidation_Row | newrow | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, QTY, SEQ, ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY_KG, ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY_KG, USER_ID, JOB_ORDER |
| ExcelPopup_BufferValidation_Row | Filter | INSTANCE_ID, PLAN_ID, COMPANY_ID, PLAN_DATE, SITE_ID |
| ExcelPopup_BufferValidation_Row | each_row | _VALID |
| ExcelPopup_CheckBeforSave | Filter | PLAN_TYPE, INSTANCE_ID, PLAN_ID, PLAN_DATE |
| ExcelPopup_CheckBeforSave | dtChk.Rows[0] | _TYPE |
| ExcelPopup_SaveExcel_Column | filter | MPP_WPP, INSTANCE_ID, SITE_ID |
| ExcelPopup_SaveExcel_Column | Filter | MPP_WPP |
| ExcelPopup_SaveExcel_Row | filter | MPP_WPP, INSTANCE_ID, SITE_ID |
| ExcelPopup_SaveExcel_Row | Filter | MPP_WPP |
| ExcelPopup_Search_Column | Filter | BUCKET_FROM, BUCKET_TO |
| ExcelPopup_Search_Column | filter | MPP_WPP |
| ExcelPopup_Search_Row | Filter | BUCKET_FROM, BUCKET_TO |
| ExcelPopup_Search_Row | filter | MPP_WPP |
| Exec_Procedure | Filter | INSTANCE_ID, PLAN_ID |
| Exec_Procedure | this.Filter | INSTANCE_ID, PLAN_ID |
| Find_Data | Filter | BUCKET_FROM, BUCKET_TO, MPP_WPP |
| Find_Data_Amend | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, MASTER_ID, PLAN_DATE, PLAN_ID, PLAN_TYPE, PROD_TYPE, TOP_ITEM_ID, ITEM_ID, NICK_NAME, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, CATE_INFO, CATE_VALUE, CATE_TYPE, AMEND_TABLE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_BOH_TABLE, AMEND_SALES_TABLE, AMEND_UTIL_TABLE, AMEND_CAPA_TABLE |
| Find_Line_Savings_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | related_row | CATEGORY_ID, PRODUCTION_TYPE |
| Find_MaterialData_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | related_row | CATEGORY_ID |
| Find_Save_Valid | Filter | INSTANCE_ID, MASTER_ID, PLAN_DATE, PLAN_ID |
| FindData | Filter | BUCKET_FROM, BUCKET_TO, MPP_WPP |
| FindData | this.Filter | PLAN_TYPE |
| FindTotalValue | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, MASTER_ID, PLAN_DATE, PLAN_ID, PLAN_TYPE, PROD_TYPE, TOP_ITEM_ID, ITEM_ID, NICK_NAME, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, CATE_INFO, CATE_VALUE, CATE_TYPE, AMEND_TABLE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_BOH_TABLE, AMEND_SALES_TABLE, AMEND_UTIL_TABLE, AMEND_CAPA_TABLE |
| GetListDataSet | Filter | INSTANCE_ID, PLAN_ID, OPERATION_ID, AMEND_TABLE, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, AMEND_BOR_TABLE, LINE_ID, ITEM_ID |
| GetOperation | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, AMEND_MAIN_FLAG, OPERATION_ID |
| GoEditMode | Filter | PLAN_ID, PLAN_TYPE |
| GoEditMode | row | DATA_TYPE, CATEGORY_ID, EDIT_YN |
| InitControls | Filter | UI_END_DATE, BUCKET_FROM, CURR_DATE, BUCKET_TO, MPP_WPP, USER_ID, MASTER_ID, INSTANCE_ID |
| InitControls | this.Filter | PLAN_TYPE, BUCKET_FROM, CURR_DATE, BUCKET_TO |
| Insert_Data_Excel_Buffer | result.Rows[0] | RESULT, EXCEPTION |
| InsertButton | row | DATA_TYPE, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, NICK_NAME, ELECTRODE_TYPE, PRODUCTION_TYPE, MARKET |
| InsertButton | popup.Filter | INSTANCE_ID, PLAN_DATE, PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, NICK_NAME, ELECTRODE_TYPE, PRODUCTION_TYPE, MARKET |
| InsertButton | Filter | INSTANCE_ID, PLAN_DATE, PLAN_ID |
| lfn_getYieldInfo | row | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID |
| lfn_getYieldInfo | dtYieldOut.Rows[0] | YIELD |
| lfn_getYieldInfo_Excel | each_row | D_VALUE, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ITEM_ID, START_DATE, END_DATE |
| lfn_getYieldInfo_Excel | Result.First() | _DATE |
| lfn_getYieldInfo_Excel | row | FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ITEM_ID |
| lfn_getYieldInfo_Excel | YieldResult.First() | YIELD |
| lfn_setExchangeBatch | x | FACTORY_ID, OPERATION_ID, ITEM_ID, CATEGORY |
| lfn_setExchangeBatch | row | FACTORY_ID, OPERATION_ID, ITEM_ID |
| lfn_setExchangeBatch | selected | VALUE |
| lfn_setExchangeBatch_Excel | each_row | D_VALUE, FACTORY_ID, OPERATION_ID, ITEM_ID, CATEGORY, LINE_ID, EQUIPMENT_ID, START_DATE, END_DATE |
| lfn_setExchangeBatch_Excel | Result.First() | _DATE |
| lfn_setExchangeBatch_Excel | row | FACTORY_ID, OPERATION_ID, ITEM_ID, LINE_ID, EQUIPMENT_ID |
| lfn_setExchangeBatch_Excel | UomResult.First() | VALUE |
| lfn_setExchangeBatch_Excel | YieldResult.First() | CHILD_YIELD |
| lfn_setReleaseProcess | Filter | INSTANCE_ID, PLAN_ID, SITE_ID, CONFIRM_AREA |
| lfn_setReleaseProcess | dtIsCurrWeek.Rows[0] | CURR_DATE |
| lfn_setReleaseProcess | row | _DATE, IS_PLAN |
| MakeMemoFontBold | dsMainFiltered.Tables[0].Rows[i] | CATEGORY_ID |
| MakeMemoFontBold | Filter | PLAN_TYPE |
| onAlarmMenu | row | PRODUCTION_TYPE |
| onAlarmMenu | frm.Filter | MEMO_TYPE |
| onNLFAmendMenu | frm.Filter | MASTER_ID, FP_PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onNLFAmendMenu | Filter | INSTANCE_ID, PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onZeroBucketMenu | row_to_test | CATEGORY_ID, DATA_TYPE |
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
| OpenLineMemo | frm.Filter | MEMO_TYPE |
| OpenMaterialMemo | frm.Filter | MEMO_TYPE |
| planday_changed | Filter | PLAN_DATE |
| Query | d | DIVISION_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, MARKET, PLAN_DATE, PRODUCTION_TYPE, SETUP_COLOR_CODE |
| Query | m | ATTR1 |
| Query | rCate | SEGMENT1, ATTRIBUTE2 |
| RunSqlSource | Filter | PLAN_TYPE |
| Save_Data_Amend | dtData.Rows[i] | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, SEQ, ADJUST_IN_QTY, ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY_KG, ADJUST_OUT_QTY, ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY_KG |
| Save_PIanBatch_Data | Filter | INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, PLAN_TYPE |
| Save_PIanBatch_Data | dtCheckSave.Rows[0] | _TYPE |
| Save_PIanBatch_Data | x | _VALID |
| Save_PIanBatch_Data | Application.OpenForms | FP00596_InValidationPopup |
| SaveToDB | dsMain.Tables[0].Rows[i] | MESSAGE, USER_ID, JOB_ORDER |
| SaveToDB | this.Filter | PLAN_TYPE, MPP_WPP |
| SaveToDB | Filter | MPP_WPP |
| SaveToDB | eachRow | _VALID |
| SaveToDB | Application.OpenForms | FP00597_InValidationExcelPopup |
| SaveToDB | valrow | _VALID, _MSG |
| SaveToDB | xlsrow | MESSAGE |
| SearchListInfoAll | Filter | INSTANCE_ID, PLAN_ID, AMEND_BOR_TABLE, PLAN_DATE, BUCKET_FROM, BUCKET_TO |
| SetBasisTime | dtBaseTime.Rows[0] | BASIS_TIME |
| SetBohTotalQty | row | DATA_TYPE, BOH_QTY, COMPANY_ID, SITE_ID, OPERATION_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohTotalQty | each_row | _TYPE, COMPANY_ID, SITE_ID, OPERATION_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohTotalQty | result.First() | QTY |
| SetColumnChangeByText | dsResult.Tables[0].Rows[k] | DATA_TYPE, CATEGORY_ID |
| SetDivision | Filter | INSTANCE_ID |
| SetFactory | Filter | INSTANCE_ID, PLAN_ID, PLAN_TYPE, CONFIRM_AREA, DIVISION_ID, SITE_ID, PLANT_ID |
| SetFpPlanId | dtPlanId.Rows[iDx] | CODE, NAME, PLAN_START_DATE, PLAN_END_DATE, DEFAULT_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, BASIS_PLAN_ID, DEMAND_PLAN_ID, SCP_PLAN_ID |
| SetFpPlanId | dtPlanId.Rows[0] | INSERT_ID, INSERT_TIME, DESCS, BASIC_VERSION, FACTORY_LT |
| SetLine | Filter | ALL_LINE, INSTANCE_ID, PLAN_ID, PLAN_TYPE, CONFIRM_AREA, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, USER_LT |
| setMeasualFormData | dtCategory.Rows[i] | MEA_ID, MEA_VALUE |
| SetOperation | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, AMEND_MAIN_FLAG |
| SetPlanGroup | dtInstance.Rows[0] | CODE, USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| SetPlanInBatch_DataSet | clicked_row | CATEGORY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, LOCATION, PSI, LV1, COMPANY_ID |
| SetPlanInBatch_DataSet | Filter | INSTANCE_ID, PLANT_ID, OPERATION_ID, AMEND_TABLE, PLAN_ID, PLAN_DATE |
| SetPlanInBatch_DataSet | measure | chk_i, chk_inqty, chk_kg, chk_outqty, chk_batch |
| SetPlanInBatch_DataSet | dateMap.Tables[0].Rows[dateMap.Tables[0].Rows.Count - 1] | D_VALUE |
| SetPlanInBatch_DataSet | dsMainFiltered.Tables[0].Rows[i] | LV1, DIVISION_ID, SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, DATA_TYPE, PSI, CATEGORY_ID, CATEGORY_ORDER |
| SetPlanInBatch_DataSet | x | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, MARKET, LOCATION, PLAN_DATE |
| SetPlanInBatch_DataSet | row1 | ADJUST_IN_QTY, ADJUST_OUT_QTY_BATCH, ADJUST_IN_QTY_KG, ADJUST_OUT_QTY, ADJUST_IN_QTY_BATCH, ADJUST_OUT_QTY_KG |
| SetPlanInBatch_DataSet | row | SEQ |
| SetPlanInBatch_DataSet | newrow | INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, PLAN_DATE, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, CUSTOMER_ID, SEQ, ADJUST_IN_QTY, ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY_KG, ADJUST_OUT_QTY, ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY_KG |
| SetPlanInBatch_DataSet | dsPlanSave.Tables | Table |
| SetPlanInBatch_DataSet | dsMainFiltered.Tables[0].Rows[nRowStart] | BOH_QTY |
| SetPlanner | row | NAME, DEFAULT_CHECK, CODE |
| SetPlanner | Filter | ALL_LINE |
| SetPlanPeriod | dtPlanId.Rows[0] | PLAN_START_DATE, PLAN_END_DATE, DEFAULT_START_DATE, DEFAULT_END_DATE |
| SetPlant | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID |
| SetSite | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID |
| SetTotalColor | row | DATA_TYPE |
| spdMain_CellClick | row | LINE_ID, PRODUCTION_TYPE, DATA_TYPE |
| SwitchMemo | r | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET |
| SwitchMemo | memoRow | PRODUCTION_TYPE, ITEM_ID |
| SwitchMemo | memo[k] | ITEM_ID |
| SwitchMemo | materialRow | PRODUCTION_TYPE |
| UIFindData | Filter | PLAN_ID, PLAN_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:130, InitControl:151, Measure:158, InitControl:215, CheckAndGetMeasure:1414, RefreshSpreadSheet:6169 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| FP_Log | OpenAndLoadExcelData:712, OpenAndLoadExcelData:730 | DataService.FP_Log | LOGTYPE, NOTE, USER_ID |
| CommonDefaultLineCheck | DefaultLineCheck:961, DefaultLineCheck:757 | ExcelService.CommonDefaultLineCheck | BUCKET_FROM, BUCKET_TO, MESSAGE, QTY |
| SetFilter | InitControls:322, InitControls:323, InitControls:324, InitControls:325, InitControls:327, InitControls:329, InitControls:339, InitControls:340 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetCheckedListValue | UIFindData:575, ApplySearchCondition:1001, cbo_plan_group_changed:2059, mcbo_planner_changed:2086, mcbo_division_changed:2249, mcbo_site_changed:2257, mcbo_plant_changed:2263, mcbo_factory_changed:2269 | CString.GetCheckedListValue | CODE |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:1542 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| SetRowsUnVisible | CreateFilterDataSet:1545 | MeasureService.SetRowsUnVisible | _MM_ |
| FP_Log2 | cbo_plan_group_changed:2057, cbo_plan_group_changed:2073 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetSpdTitle | SearchListInfoAll:5035, SearchListInfoAll:939 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| FP_PseudoBatch | Insert_Data_Excel_Buffer:5497 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| LoadAmendColumn | DrawHeader:6283 | MeasureService.LoadAmendColumn | DAYTAG, MONTHTAG, WEEKTAG |
| SetTotalColor | DrawSheet:6327 | SpreadInfo.SetTotalColor | column_cnt, grouping_cnt, row_idx |
| EditQuery | Query:6404 | FPExtensions.EditQuery | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btbSet | Click | btnSet_Click | InitializeComponent:125 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:163 |
| this | Load | MeasureSetForm_Load | InitializeComponent:178 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:179 |
| this | Load | Form_Load | .ctor:161 |
| this.dtpPeriod | ValueChanged | dtpPeriod_ValueChanged | InitializeComponent:180 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:256 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:308 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:349 |
| this.btnDownload | Click | btnDownload_Click | InitializeComponent:390 |
| this.btnUpload | Click | btnUpload_Click | InitializeComponent:431 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:547 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:548 |
| this.btnSet | Click | btnSet_Click | InitializeComponent:237 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:274 |
| this | Load | MeasureSetForm_Load | InitializeComponent:323 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:324 |
| this | Load | Form_Load | .ctor:212 |
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
| txtItem | TextChanged | TxtItem_TextChanged | InitEvent:295 |
| dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitEvent:298 |
| chk_allLine | CheckedChanged | chk_allLine_CheckedChanged | InitEvent:300 |
| popSql | OnSql | RunSqlSource | btnSql_Click:3006 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick:3066 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick:3078 |
| menu_line | Click | onZeroLineMenu | spdMain_CellClick:3091 |
| menu_material | Click | onZeroMaterialMenu | spdMain_CellClick:3100 |
| this.chk_includeSubOp | CheckedChanged | chk_includeSubOp_onchanged | InitializeComponent:279 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:354 |
| this.btnExcelImport | Click | btnExcelImport_Click | InitializeComponent:394 |
| this.btnToggleSave | Click | btnToggleSave_Click | InitializeComponent:433 |
| this.chk_Info | CheckedChanged | chk_Info_CheckedChanged | InitializeComponent:684 |
| this.btnMemo | Click | btnMemo_Click | InitializeComponent:1429 |
| this.btnMRP | Click | btnMRP_Click | InitializeComponent:1468 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:1480 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:1481 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:1482 |
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:1483 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:1484 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:1485 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:1486 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:1487 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1488 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1489 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:1490 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:1491 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:1492 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:1493 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:1494 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:1495 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:1496 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:1497 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:1498 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:1499 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:1500 |
| this.button1 | Click | button1_Click | InitializeComponent:1630 |
| this.btnMenu2 | Click | btnMenu_Click | InitializeComponent:1885 |
| this.btnRelease2 | Click | btnRelease_Click | InitializeComponent:1923 |
| this.btnCreatePlan2 | Click | btnCreatePlan_Click | InitializeComponent:1961 |
| this.btnBucket | Click | btnBucket_Click | InitializeComponent:1999 |
| this.btnCatagory | Click | btnCatagory_Click | InitializeComponent:2037 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:2075 |
| this | Load | Form_Load | .ctor:168 |
| this.dtpPeriod | ValueChanged | dtpPeriod_ValueChanged | InitializeComponent:172 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:213 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:265 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:306 |
| this.btnDownload | Click | btnDownload_Click | InitializeComponent:347 |
| this.btnUpload | Click | btnUpload_Click | InitializeComponent:388 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:476 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:477 |

## 6. 컨트롤 (154개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 33 | layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem6, layoutControlItem3, layoutControlItem7, layoutControlItem1, lblMPPWPP, layoutControlItem2, layoutControlItem4, layoutControlItem3, layoutControlItem6, layoutControlItem7, layoutControlItem8, layoutControlItem9 … |
| UsrButton | 26 | btbSet, btnOK, btnSave, btnClose, btnFind, btnDownload, btnUpload, btnSet, btnOK, btnSql, btnExcelImport, btnToggleSave, btnMemo, btnMRP, usrButton2 … |
| Label | 15 | label1, label2, label3, label3, txtBuilding, txtBasic, txtDesc, txtCreation, txtCreator, label7, label6, label5, label4, label2, label1 |
| CheckBox | 13 | chk_week, chk_month, chk_day, chk_i, chk_s, chk_result, chk_outqty, chk_inqty, chk_batch, chk_kg, chk_total, chk_subTotal, chk_memo |
| Panel | 10 | panel1, panel1, panel3, panel2, infoPanel, menuPanel, panel2, panel3, panel4, panel1 |
| UsrCheckedList2 | 7 | mcbo_line, mcbo_operation, mcbo_factory, mcbo_plant, mcbo_site, mcbo_division, mcbo_planner |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 6 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| FpSpread | 5 | spdMain, spdMain, spdEdit, spdInfo, spdMain |
| SheetView | 5 | spdMain_Sheet1, spdMain_Sheet1, spdEdit_Sheet1, spdInfo_Sheet1, spdMain_Sheet1 |
| ImageList | 4 | imageList1, imageList2, imageList1, imageList1 |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrCheckBox | 3 | chk_includeSubOp, chk_allLine, chk_Info |
| UsrDateRangePicker2 | 2 | dtpPeriod, dtpPeriod |
| UsrLabel | 2 | usrLabel1, lblPlanID |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem1 |
| UsrTextBox | 2 | txtNickName, txtItem |
| UsrCombo | 2 | cbo_fpplanid, cbo_plan_group |
| RadioGroup | 1 | rdoGroup1 |
| UsrDateRangePickerWtWeek | 1 | dCalendar_planrange |
| UsrDatePickerWtWeek | 1 | sCalendar_planday |
| SplitContainer | 1 | splitter |
| Button | 1 | button1 |
| GroupBox | 1 | groupBox1 |
| TextBox | 1 | tbLog |
| DataGridView | 1 | dgEdit |

## 7. 확인 필요 (6건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 6352 | Query | FP\{?default:part_service}\AmendMemo#list_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 6353 | Query | FP\{?default:part_service}\AmendMemo#list_setup_color_code | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2529 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 6387 | Query | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 6388 | Query | FP\{?default:part_service}\PICAlarm#find_Category_Color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5497 | Insert_Data_Excel_Buffer | FP\{?default:part_service}\FP00596_EXCELIMPORT#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 32 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 11 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00597 | Amend | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: AutoExcelPopup, Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@DrawHeader:6232
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| FindData |  | 399 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(OnSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 400 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(OnSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 401 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(OnSearchData != null) ⟫ if(AutoCHK) |
| InitializeComponent |  | 564 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 565 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 566 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 567 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetCalenderColor |  | 6477 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 6483 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| spdMain_CellDoubleClick |  | 6585 | 표시/라벨 변경 | set:Visible | Visible = {?!spdMain.ActiveSheet.Columns[idx].Visible} |  | else!(!sHeadNameLevel2.Equals("Week Sum")) ⟫ for(idx < iWeekCount) |
| InitializeComponent |  | 1516 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1517 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1518 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1519 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2119 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2120 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2121 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2122 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2170 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2171 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2172 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2173 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| Find_Data |  | 392 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(OnSearchData != null) ⟫ if(AutoCHK) |
| Find_Data |  | 393 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(OnSearchData != null) ⟫ if(AutoCHK) |
| Find_Data |  | 394 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(OnSearchData != null) ⟫ if(AutoCHK) |
| InitializeComponent |  | 493 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 494 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 495 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 496 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
