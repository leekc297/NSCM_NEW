# FP00641 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00641_Cell_Simulation_Cell_Pack.UIL\FP00641_Cell_Simulation_Cell_Pack.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00641_Cell_Simulation_Cell_Pack.UIL\FP00641_Cell_Simulation_Cell_Pack.csproj | 12008 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00641_Cell_Simulation_Cell_Pack.UIL\FP00641_Cell_Simulation_Cell_Pack.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00641_Cell_Simulation_Cell_Pack.UIL\FP00641_Cell_Simulation_Cell_Pack.csproj | 2857 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00641_Cell_Simulation_Cell_Pack.UIL\FP00641_InvDetail_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00641_Cell_Simulation_Cell_Pack.UIL\FP00641_Cell_Simulation_Cell_Pack.csproj | 414 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00641_Cell_Simulation_Cell_Pack.UIL\FP00641_InvDetail_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00641_Cell_Simulation_Cell_Pack.UIL\FP00641_Cell_Simulation_Cell_Pack.csproj | 209 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00641_Cell_Simulation_Cell_Pack.UIL\FP00641_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00641_Cell_Simulation_Cell_Pack.UIL\FP00641_Cell_Simulation_Cell_Pack.csproj | 390 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00641_Cell_Simulation_Cell_Pack.UIL\FP00641_MeasureSetForm_Popup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00641_Cell_Simulation_Cell_Pack.UIL\FP00641_Cell_Simulation_Cell_Pack.csproj | 752 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00641_Cell_Simulation_Cell_Pack.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00641_Cell_Simulation_Cell_Pack.UIL\FP00641_Cell_Simulation_Cell_Pack.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetPlanner | 681 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetPlanner | 683 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetPlanner > mcbo_planner_Form_changed > GetLine | 784 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetCurrDate | 3433 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetCurrDate | 3433 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_currdate.sql |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetLastReleaseTime | 3443 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetLastReleaseTime | 3443 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_LastestReleaseTime.sql |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetListBucketDate | 3452 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] | BIZ_MATCH |  |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetListBucketDate | 3452 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_bucketdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_bucketdate.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetPlanner | 681 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetPlanner | 683 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetPlanner > mcbo_planner_Form_changed > GetLine | 784 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance | 3391 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance_by_simul] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance | 3391 | FP\COMMON\BigFilter_FP#find_instance_by_simul | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_find_instance_by_simul.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 3433 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 3433 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_currdate.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 3443 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 3443 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_LastestReleaseTime.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetListBucketDate | 3452 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetListBucketDate | 3452 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_bucketdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_bucketdate.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetPlan | 3474 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetPlan | 3474 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetPlan | 3497 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetPlan | 3497 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetPlan | 3519 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetPlan | 3519 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed | 10859 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed | 10859 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed | 10860 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed | 10860 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed | 10861 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed | 10861 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:chk_allLine_Cell.CheckedChanged | chk_allLine_Cell_CheckedChanged > GetLine | 784 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:chk_allLine_Form.CheckedChanged | chk_allLine_Form_CheckedChanged > GetLine | 784 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:chk_allLine_Pack.CheckedChanged | chk_allLine_Pack_CheckedChanged > GetLine | 784 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:date_instance.ValueChanged | plan_day_changed > GetListBucketDate | 3452 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetListBucketDate | 3452 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_bucketdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_bucketdate.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 3474 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 3474 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 3497 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 3497 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 3519 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 3519 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed | 10901 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed | 10901 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed | 10902 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed | 10902 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed | 10903 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed | 10903 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| button:FindButton | FindButton > UIFindData > FindMainData | 3720 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData | 3720 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindMainData | 3748 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData | 3748 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindMainData | 3776 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData | 3776 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 3855 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 3855 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 3883 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 3883 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 3911 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 3911 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 3951 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOM_RATE] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 3951 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_BOM_RATE | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_BOM_RATE.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 3952 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YLD_F6000] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 3952 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_YLD_F6000 | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_YLD_F6000.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 3953 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AGING_STOCK] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 3953 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_AGING_STOCK | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_AGING_STOCK.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 3954 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Cell_ExchangeValue] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 3954 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Cell_ExchangeValue | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Cell_ExchangeValue.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 3956 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yield_F1000] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 3956 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_yield_F1000 | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_yield_F1000.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3975 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3975 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3976 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3976 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3977 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3977 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3978 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3978 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:mcbo_planner_Cell.SelectedIndexChanged | mcbo_planner_Cell_changed > GetLine | 784 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_planner_Form.SelectedIndexChanged | mcbo_planner_Form_changed > GetLine | 784 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_planner_Pack.SelectedIndexChanged | mcbo_planner_Pack_changed > GetLine | 784 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > FindMainData | 3720 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData | 3720 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData | 3748 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData | 3748 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData | 3776 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData | 3776 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 3975 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 3975 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 3976 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 3976 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 3977 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 3977 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 3978 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 3978 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data > Save_Data_Sim | 1669 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_shipment] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data > Save_Data_Sim | 1669 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#merge_shipment | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > UISaveData > Save_Data > Save_Data_Pack | 1872 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data > Save_Data_Pack | 1872 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data > Save_Data_Cell | 2112 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data > Save_Data_Cell | 2112 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data > Save_Data_Form | 2345 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data > Save_Data_Form | 2345 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data > Save_Data_Form > Save_Data_Amend | 2516 | FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_SAVE |
| button:SaveButton | SaveButton > UISaveData > Save_Data > Save_Data_Form > Exec_Procedure | 2579 | FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | MATCH | SP PR_UI_FP00621_AMEND_LINE_SAVE |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 3720 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 3720 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 3748 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 3748 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 3776 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 3776 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3855 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3855 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3883 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3883 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3911 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3911 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3951 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOM_RATE] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3951 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_BOM_RATE | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_BOM_RATE.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3952 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YLD_F6000] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3952 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_YLD_F6000 | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_YLD_F6000.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3953 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AGING_STOCK] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3953 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_AGING_STOCK | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_AGING_STOCK.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3954 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Cell_ExchangeValue] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3954 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Cell_ExchangeValue | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Cell_ExchangeValue.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3956 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yield_F1000] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 3956 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_yield_F1000 | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_yield_F1000.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3975 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3975 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3976 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3976 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3977 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3977 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3978 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 3978 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:this.cbo_cell_plan_id.DropDown | cbo_cell_plan_id_DropDown > GetPlan | 3474 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.cbo_cell_plan_id.DropDown | cbo_cell_plan_id_DropDown > GetPlan | 3474 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.cbo_cell_plan_id.DropDown | cbo_cell_plan_id_DropDown > GetPlan | 3497 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.cbo_cell_plan_id.DropDown | cbo_cell_plan_id_DropDown > GetPlan | 3497 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.cbo_cell_plan_id.DropDown | cbo_cell_plan_id_DropDown > GetPlan | 3519 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.cbo_cell_plan_id.DropDown | cbo_cell_plan_id_DropDown > GetPlan | 3519 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.cbo_cell_plan_id.DropDown | cbo_cell_plan_id_DropDown | 11985 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.cbo_cell_plan_id.DropDown | cbo_cell_plan_id_DropDown | 11985 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.cbo_form_plan_id.DropDown | cbo_form_plan_id_DropDown > GetPlan | 3474 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.cbo_form_plan_id.DropDown | cbo_form_plan_id_DropDown > GetPlan | 3474 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.cbo_form_plan_id.DropDown | cbo_form_plan_id_DropDown > GetPlan | 3497 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.cbo_form_plan_id.DropDown | cbo_form_plan_id_DropDown > GetPlan | 3497 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.cbo_form_plan_id.DropDown | cbo_form_plan_id_DropDown > GetPlan | 3519 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.cbo_form_plan_id.DropDown | cbo_form_plan_id_DropDown > GetPlan | 3519 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.cbo_form_plan_id.DropDown | cbo_form_plan_id_DropDown | 11981 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.cbo_form_plan_id.DropDown | cbo_form_plan_id_DropDown | 11981 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.cbo_pack_plan_id.DropDown | cbo_pack_plan_id_DropDown > GetPlan | 3474 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.cbo_pack_plan_id.DropDown | cbo_pack_plan_id_DropDown > GetPlan | 3474 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.cbo_pack_plan_id.DropDown | cbo_pack_plan_id_DropDown > GetPlan | 3497 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.cbo_pack_plan_id.DropDown | cbo_pack_plan_id_DropDown > GetPlan | 3497 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.cbo_pack_plan_id.DropDown | cbo_pack_plan_id_DropDown > GetPlan | 3519 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.cbo_pack_plan_id.DropDown | cbo_pack_plan_id_DropDown > GetPlan | 3519 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.cbo_pack_plan_id.DropDown | cbo_pack_plan_id_DropDown | 11977 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.cbo_pack_plan_id.DropDown | cbo_pack_plan_id_DropDown | 11977 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.Load | Form_Load > InitControls | 263 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 263 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.Load | Form_Load > InitControls | 264 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 264 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.Load | Form_Load > InitControls | 265 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 265 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.Load | Form_Load > InitControls > GetPlanner | 681 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > GetPlanner | 683 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > GetLine | 784 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > GetSite | 3384 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_site] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetSite | 3384 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_site | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_site.sql |
| event:this.Load | Form_Load > InitControls > GetInstance | 3391 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance_by_simul] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetInstance | 3391 | FP\COMMON\BigFilter_FP#find_instance_by_simul | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_find_instance_by_simul.sql |
| event:this.Load | Form_Load > InitControls > GetCurrDate | 3433 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetCurrDate | 3433 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_currdate.sql |
| event:this.Load | Form_Load > InitControls > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 3443 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 3443 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_LastestReleaseTime.sql |
| event:this.Load | Form_Load > InitControls > GetListBucketDate | 3452 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetListBucketDate | 3452 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_bucketdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_bucketdate.sql |
| event:this.Load | Form_Load > InitControls > GetPlan | 3474 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlan | 3474 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.Load | Form_Load > InitControls > GetPlan | 3497 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlan | 3497 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| event:this.Load | Form_Load > InitControls > GetPlan | 3519 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlan | 3519 | FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 104 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetReleaseProcess | 3123 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetReleaseProcess | 3123 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AGING_STOCK] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOM_RATE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Cell_ExchangeValue] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance_by_simul] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH | 15 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH | 6 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_site] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yield_F1000] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YLD_F6000] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_shipment] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 3 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | MATCH | 2 | SP PR_UI_FP00621_AMEND_LINE_SAVE | EXEC:PR_UI_FP00621_AMEND_LINE_SAVE | ⚠ DB에 SP 없음 |
| FP\COMMON\BigFilter_FP#find_instance_by_simul | MATCH | 1 | [sql] foxquery_sql\FP_Common_BigFilter_FP_find_instance_by_simul.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql | REF:FN_SITE_TIME, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 3 | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql | SELECT:FP_PLAN_STATUS_H, SELECT:SCM_FP_PLAN_DETAIL_H, SELECT:SCM_FP_PLAN_GROUP_DETAIL_H, SELECT:FP_RELEASE_CALCULATION_STATUS_H |  |
| FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_AGING_STOCK | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_AGING_STOCK.sql | SELECT:TH_MST_STOCK_PLAN_V, SELECT:FP_CELL_ASSY_PRODUCT_MAP_V, SELECT:FP_INSTANCE_LINE_V |  |
| FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_BOM_RATE | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_BOM_RATE.sql | SELECT:SCM_BOM_M, SELECT:FP_INSTANCE_FACTORY_M, SELECT:SCM_FACTORY_M, SELECT:SCM_ITEM_M, SELECT:SCM_ITEM_CLASS_M, SELECT:SCM_ITEM_LINE_ASSIGN_M |  |
| FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_bucketdate | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_bucketdate.sql | SELECT:TH_UIS_CALENDAR, SELECT:TH_UIS_CAL, SELECT:CURR_DATE |  |
| FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Cell_ExchangeValue | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Cell_ExchangeValue.sql | SELECT:SCM_MODEL_COMP_EFFECTIVE_DATEMCT |  |
| FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_currdate | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_currdate.sql | REF:FN_SITE_TIME, SELECT:FP_INSTANCE_START_TIME_V, SELECT:SITE_T, SELECT:FP_INSTANCE_OPERATION_V |  |
| FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_LastestReleaseTime | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_LastestReleaseTime.sql | SELECT:HIS_FP_PLAN_DETAIL_H, SELECT:HIS_FP_PLAN_GROUP_DETAIL_H |  |
| FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_plan | MATCH | 15 | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_plan.sql | SELECT:SCM_FP_PLAN_H |  |
| FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_Release_Plan_list | MATCH | 6 | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_Release_Plan_list.sql | SELECT:FP_RELEASE_PLAN_INFO_H, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_site | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_site.sql | SELECT:SCM_SITE_M, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_yield_F1000 | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_yield_F1000.sql | SELECT:SCM_YIELD_M, SELECT:FP_INSTANCE_FACTORY_M, SELECT:SCM_FACTORY_M, SELECT:FP_CELL_ASSY_PRODUCT_MAP_V |  |
| FP\Planning\FP00641_Cell_Simulation_Cell_Pack#find_YLD_F6000 | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00641_Cell_Simulation_Cell_Pack_find_YLD_F6000.sql | SELECT:FP_INSTANCE_FACTORY_M, SELECT:SCM_FACTORY_M, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_YIELD_M, SELECT:SCM_YIELD_EXCEPT_M, SELECT:FP_CELL_ASSY_PRODUCT_MAP_V |  |
| FP\Planning\FP00641_Cell_Simulation_Cell_Pack#merge_shipment | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | MONTH_INFO, BUCKET, WEEK_INFO |
| cbo_cell_plan_id_changed | Filter | ASSY_PLAN_ID |
| cbo_form_plan_id_changed | Filter | FORM_PLAN_ID |
| cbo_pack_plan_group_changed | Filter | PLAN_DATE |
| cbo_pack_plan_id_changed | Filter | PACK_PLAN_ID |
| cbo_site_changed | Filter | SITE_ID |
| chk_changed | Filter | IS_REL_PACK, IS_REL_FORM, IS_REL_ASSY |
| chk_info_changed | Filter | INSTANCE_ID, PACK_INSTANCE_ID, PLAN_ID, PACK_PLAN_ID, FORM_INSTANCE_ID, FORM_PLAN_ID, ASSY_INSTANCE_ID, ASSY_PLAN_ID |
| chk_info_changed | dtPlanId.Rows[0] | DESCRIPTION, INSERT_ID, INSERT_Time, BASIC_VERSION, FACTORY_LT |
| chk_input_mode_changed | Filter | IS_INPUT_MODE |
| CreateDataLine | material_column | P_IN, P_IN_CELL, P_OUT, P_OUT_CELL |
| Exec_Procedure | Filter | INSTANCE_ID, PLAN_ID |
| FilterValidation | Filter | PACK_PLAN_ID, IS_REL_PACK, FORM_PLAN_ID, IS_REL_FORM, ASSY_PLAN_ID, IS_REL_ASSY, BUCKET_FROM, BUCKET_TO |
| Find_Line_Savings_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, CELL_ITEM_ID, CELL_GROUP_CODE |
| Find_Line_Savings_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, CELL_ITEM_ID, CELL_GROUP_CODE |
| Find_Line_Savings_Index_FromData | related_row | CATEGORY_ID |
| Find_MaterialData_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, CELL_ITEM_ID, CELL_GROUP_CODE |
| Find_MaterialData_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, CELL_ITEM_ID, CELL_GROUP_CODE |
| Find_MaterialData_Index_FromData | related_row | CATEGORY_ID |
| FindListData | Filter | PACK_AMEND_TABLE, PACK_AMEND_SALES_TABLE, FORM_AMEND_TABLE, CELL_AMEND_TABLE, CELL_AMEND_SALES_TABLE, IS_REL_PACK, TARGET_INSTANCE, PACK_INSTANCE_ID, PACK_PLAN_LT, PACK_PLAN_ID, IS_REL_FORM, FORM_INSTANCE_ID, FORM_PLAN_LT, FORM_PLAN_ID, IS_REL_ASSY, ASSY_INSTANCE_ID, ASSY_PLAN_LT, ASSY_PLAN_ID, PLAN_ID_SCRIPT |
| FindListData | dtReleasePlanList.Rows[i] | release_plan_id |
| FindMainData | Filter | CATE_INFO, PACK_AMEND_TABLE, PACK_AMEND_SALES_TABLE, FORM_AMEND_TABLE, CELL_AMEND_TABLE, CELL_AMEND_SALES_TABLE, IS_REL_PACK, TARGET_INSTANCE, PACK_INSTANCE_ID, PACK_PLAN_LT, PACK_CONFIRM_AREA, PACK_PLAN_ID, IS_REL_FORM, FORM_INSTANCE_ID, FORM_PLAN_LT, FORM_CONFIRM_AREA, FORM_PLAN_ID, IS_REL_ASSY, ASSY_INSTANCE_ID, ASSY_PLAN_LT, ASSY_CONFIRM_AREA, ASSY_PLAN_ID |
| FindMainData | dtReleasePlanList.Rows[i] | release_plan_id |
| GetCellDataOfCellGroup | x | DATA_TYPE, SHOP_TYPE, CELL_GROUP_CODE, CELL_ITEM_ID, CELL_GROUP_CODE_RANK, PACK_RANK |
| GetCellDataOfCellGroup | click_row | CELL_GROUP_CODE, CELL_ITEM_ID, CELL_GROUP_CODE_RANK, PACK_RANK |
| GetCurrDate | dtCurrdate.Rows[0] | CURR_DATE |
| GetDataOfCellGroup | x | DATA_TYPE, CELL_GROUP_CODE |
| GetDataOfCellGroup | click_row | CELL_GROUP_CODE |
| GetFormDataOfCellGroup | x | DATA_TYPE, SHOP_TYPE, CELL_GROUP_CODE, CELL_GROUP_CODE_RANK |
| GetFormDataOfCellGroup | click_row | CELL_GROUP_CODE, CELL_GROUP_CODE_RANK |
| GetInstance | pack_row | CODE, NAME |
| GetInstance | row | PACK_INSTANCE_ID, PACK_INSTANCE_NAME, CELL_INSTANCE_ID, CELL_INSTANCE_NAME, INSTANCE_ID, INSTANCE_NAME |
| GetInstance | cell_row | CODE, NAME |
| GetInstance | form_row | CODE, NAME |
| GetLastReleaseTime | Filter | LAST_RELEASE_TIME |
| GetLastReleaseTime | dtLastestRel.Rows[0] | LAST_TIME |
| GetLine | Filter | PLANNER_YN, PLANNER_YN_CELL, ALL_LINE, LINE_ID_CELL, INSTANCE_ID, ASSY_INSTANCE_ID, USER_LT, USER_CELL_LT, PLANNER_YN_PACK, LINE_ID_PACK, PACK_INSTANCE_ID, USER_PACK_LT, PLANNER_YN_FORM, LINE_ID_FORM, FORM_INSTANCE_ID, USER_FORM_LT, PLAN_ID, PLAN_TYPE, CONFIRM_AREA, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID |
| GetListBucketDate | dtBucketdate.Rows[0] | START_DATE, END_DATE |
| GetPackDataOfCellGroup | x | DATA_TYPE, SHOP_TYPE, CELL_GROUP_CODE, CELL_GROUP_CODE_RANK, PACK_RANK |
| GetPackDataOfCellGroup | click_row | CELL_GROUP_CODE, CELL_GROUP_CODE_RANK, PACK_RANK |
| GetPlan | Filter | SHOP, INSTANCE_ID, PACK_PLAN_ID, FORM_PLAN_ID, ASSY_PLAN_ID |
| GetPlanner | Filter | INSTANCE_ID, ASSY_INSTANCE_ID, PACK_INSTANCE_ID, FORM_INSTANCE_ID, ALL_LINE_FORM |
| GetPlanner | row | NAME, DEFAULT_CHECK, CODE |
| GetPlanner | dtInstance.Rows[0] | INSTANCE_ID |
| GoEditMode | Filter | PLAN_TYPE |
| GoEditMode | row | CATEGORY_ID, DATA_TYPE, MEASURE_ID, EDIT_YN |
| InitControls | Filter | BUCKET, USER_ID, IS_REL_PACK, IS_REL_FORM, IS_REL_ASSY, IS_INPUT_MODE, SITE_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO |
| lfn_setCell_EOH | x | CATEGORY_ID |
| lfn_setCell_EOH | Filter | PLAN_DATE |
| lfn_setCell_EOH | cell_data_rows.ElementAt(0) | BOH_QTY |
| lfn_setCell_EOH | planout | LT |
| lfn_setCell_Form_Request | x | CATEGORY_ID |
| lfn_setCell_SCP_Balance | x | CATEGORY_ID |
| lfn_setCell_SCP_Balance | Filter | PLAN_DATE |
| lfn_setForm_Activated_Cell | x | CATEGORY_ID |
| lfn_setForm_Activated_Cell_Detail | x | CATEGORY_ID, FACTORY_ID, CELL_ITEM_ID, LINE_ID, PLAN_DATE, OPERATION_ID, ITEM_ID |
| lfn_setForm_Activated_Cell_Detail | form_p_out | FACTORY_ID, CELL_ITEM_ID, LINE_ID, OPERATION_ID |
| lfn_setForm_Activated_Cell_Detail | Filter | PLAN_DATE |
| lfn_setForm_Activated_Cell_Detail | nYieldRow.ElementAt(0) | YIELD |
| lfn_setForm_Activated_Cell_Detail | planout | LT |
| lfn_setForm_Aging_Wip | x | CATEGORY_ID |
| lfn_setForm_Aging_Wip | each_row | CATEGORY_ID |
| lfn_setForm_Aging_Wip | Filter | PLAN_DATE |
| lfn_setForm_Aging_Wip | data_rows.ElementAt(0) | BOH_QTY, GOOD_QTY |
| lfn_setForm_Aging_Wip_ | x | CATEGORY_ID |
| lfn_setForm_Aging_Wip_D | x | CATEGORY_ID |
| lfn_setForm_Aging_Wip_D | each_row | CATEGORY_ID, CELL_GROUP_CODE |
| lfn_setForm_Aging_Wip_D | form_p_out | CELL_GROUP_CODE |
| lfn_setForm_Aging_Wip_D | Filter | PLAN_DATE |
| lfn_setForm_Aging_Wip_D | result.ElementAt(0) | BOH_QTY, GOOD_QTY, LT |
| lfn_setForm_Aging_Wip_Detail | x | CATEGORY_ID |
| lfn_setForm_Aging_Wip_Detail | each_row | CATEGORY_ID |
| lfn_setForm_Aging_Wip_Detail | Filter | PLAN_DATE |
| lfn_setForm_Aging_Wip_Detail | data_rows.ElementAt(0) | LT |
| lfn_setForm_Cell_Request | x | CATEGORY_ID, RNK, PLANT_ID, CELL_ITEM_ID, PARENT_ITEM_ID, MONTH |
| lfn_setForm_Cell_Request | out_row | PLANT_ID, CELL_ITEM_ID, PACK_ITEM_ID |
| lfn_setForm_Cell_Request | nBOMTmp_row.ElementAt(0) | BOM_RATE_CELL, BOM_RATE_P5000 |
| lfn_setForm_EOH | x | CATEGORY_ID |
| lfn_setForm_EOH | Filter | PLAN_DATE |
| lfn_setForm_EOH | data_rows.ElementAt(0) | BOH_QTY, GOOD_QTY |
| lfn_setForm_EOH | planout | LT |
| lfn_setForm_Pack_Group | x | CATEGORY_ID, RNK, PLANT_ID, PARENT_ITEM_ID, MONTH |
| lfn_setForm_Pack_Group | out_row | PLANT_ID, PACK_ITEM_ID |
| lfn_setForm_Pack_Group | nBOMTmp_row.ElementAt(0) | BOM_RATE_CELL, BOM_RATE_P5000 |
| lfn_setForm_Remained_Activated_Cell | x | CATEGORY_ID |
| lfn_setForm_Remained_Activated_Cell_Detail | x | FACTORY_ID, CELL_ITEM_ID, LINE_ID, CATEGORY_ID, PLAN_DATE, ITEM_ID, OPERATION_ID, MONTH |
| lfn_setForm_Remained_Activated_Cell_Detail | form_p_remined | FACTORY_ID, CELL_ITEM_ID, LINE_ID, OPERATION_ID |
| lfn_setForm_Remained_Activated_Cell_Detail | Filter | PLAN_DATE |
| lfn_setForm_Remained_Activated_Cell_Detail | nAgingRow.ElementAt(0) | AGING_STOCK |
| lfn_setForm_Remained_Activated_Cell_Detail | nYieldRow.ElementAt(0) | YIELD |
| lfn_setForm_Remained_Activated_Cell_Detail | planout | LT |
| lfn_setForm_Remained_Activated_Cell_Detail | yield_f1000.ElementAt(0) | YIELD |
| lfn_setPack_EOH_SCPTarget | x | CATEGORY_ID |
| lfn_setPack_EOH_SCPTarget | Filter | PLAN_DATE |
| lfn_setPack_EOH_ShippingPlan | x | CATEGORY_ID |
| lfn_setPack_EOH_ShippingPlan | Filter | PLAN_DATE |
| lfn_setPack_EOH_ShippingPlan | data_rows.ElementAt(0) | BOH_QTY, GOOD_QTY |
| lfn_setPack_EOH_ShippingPlan | planout | LT |
| lfn_setUpdateTotalValue | Filter | PLAN_DATE |
| lfn_setUpdateTotalValue | x | CELL_GROUP_CODE, DATA_TYPE, SHOP_TYPE |
| MakeInstanceLT | Filter | PACK_INSTANCE_ID, FORM_INSTANCE_ID, ASSY_INSTANCE_ID, INSTANCE_LT |
| onNLFAmendMenu | frm.Filter | MASTER_ID, FP_PLAN_ID |
| onNLFAmendMenu | Filter | INSTANCE_ID, PLAN_ID |
| onZeroMaterialMenu | row_to_test | CATEGORY_ID |
| OpenAlarmMemo | row | PRODUCTION_TYPE |
| OpenAlarmMemo | frm.Filter | MEMO_TYPE |
| OpenLineMemo | frm.Filter | MEMO_TYPE |
| OpenMaterialMemo | frm.Filter | MEMO_TYPE |
| plan_day_changed | Filter | PLAN_DATE |
| plan_range_changed | Filter | BUCKET_FROM, BUCKET_TO |
| RefreshSpreadSheet | Filter | DONOTEDIT |
| Save_Data_Amend | dtData.Rows[i] | M, INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, MARKET, LOCATION, ELECTRODE_TYPE, CUSTOMER_ID, OUT_QTY |
| Save_Data_Cell | Filter | ASSY_INSTANCE_ID, FP_PLAN_ID, ASSY_PLAN_ID, PLAN_TYPE, PLAN_DATE |
| Save_Data_Cell | enum_row_from_Saving | EQTY, EDATE, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, CELL_ITEM_ID, CELL_ASSY_ITEM_ID, VERSION, CATEGORY_ID |
| Save_Data_Cell | x | INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, CATEGORY_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, PLAN_DATE, TOP_ITEM_ID, ITEM_ID, VERSION |
| Save_Data_Cell | selected | ORIG_OUT_QTY, IN_QTY, OUT_QTY, M |
| Save_Data_Cell | newrow | CATEGORY_ID, INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, PLAN_DATE, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, IN_QTY, OUT_QTY, M, USER_ID, VERSION, PLM_EC_NO |
| Save_Data_Cell | checkSave.Tables[0].Rows[0] | _TYPE |
| Save_Data_Cell | BohSet | PLAN_DATE, MASTER_ID, PLAN_ID, AMEND_CUTOFF_BOH_TABLE |
| Save_Data_Form | Filter | FORM_INSTANCE_ID, FORM_PLAN_ID |
| Save_Data_Form | enum_row_from_Saving | EDATE, EQTY, DIVISION_ID, SITE_ID, PLANT_ID, LINE_ID, OPERATION_ID, CELL_ITEM_ID, CELL_ASSY_ITEM_ID, PRODUCTION_TYPE, MARKET, CATEGORY_ID, COMPANY_ID, FACTORY_ID |
| Save_Data_Form | x | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, CATEGORY_ID, DIVISION_ID, SITE_ID, PLANT_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET |
| Save_Data_Form | selected | ORIG_OUT_QTY, IN_QTY, OUT_QTY, M |
| Save_Data_Form | newrow | INSTANCE_ID, PLAN_DATE, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, LOCATION, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, CUSTOMER_ID, CATEGORY_ID, IN_QTY, OUT_QTY, M, USER_ID |
| Save_Data_Form | checkSave.Tables[0].Rows[0] | _TYPE |
| Save_Data_Pack | Filter | PACK_INSTANCE_ID, FP_PLAN_ID, PACK_PLAN_ID, PLAN_TYPE, PLAN_DATE |
| Save_Data_Pack | enum_row_from_Saving | CATEGORY_ID, EQTY, EDATE, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, PACK_ITEM_ID |
| Save_Data_Pack | x | INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, CATEGORY_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, PLAN_DATE, ITEM_ID |
| Save_Data_Pack | selected | ORIG_OUT_QTY, IN_QTY, OUT_QTY, M |
| Save_Data_Pack | newrow | CATEGORY_ID, INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, PLAN_DATE, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, IN_QTY, OUT_QTY, M, USER_ID |
| Save_Data_Pack | checkSave.Tables[0].Rows[0] | _TYPE |
| Save_Data_Pack | BohSet | PLAN_DATE, MASTER_ID, PLAN_ID, AMEND_CUTOFF_BOH_TABLE |
| Save_Data_Sim | Filter | PACK_INSTANCE_ID, FP_PLAN_ID, PACK_PLAN_ID |
| Save_Data_Sim | enum_row_from_Saving | CATEGORY_ID, EQTY, EDATE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PACK_GROUP_CODE |
| Save_Data_Sim | x | INSTANCE_ID, FP_PLAN_ID, CATEGORY_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PLAN_DATE, TOP_ITEM_ID |
| Save_Data_Sim | selected | ORG_SALES_QTY, SALES_QTY, M |
| Save_Data_Sim | newrow | INSTANCE_ID, FP_PLAN_ID, CATEGORY_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PLAN_DATE, TOP_ITEM_ID, SALES_QTY, M, USER_ID |
| Save_Data_Sim | dr | SEQ |
| Save_Data_Sim | dtResult.Rows[0] | RESULT |
| SaveButton | Filter | DONOTEDIT |
| SetBohQty | row | DATA_TYPE, OPERATION_ID, BOH_QTY, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohQty | each_row | _TYPE, OPERATION_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohQty | result.First() | QTY |
| SetMemoCell | set | BUCKET_FROM, BUCKET_TO, MEMO |
| SetPlanOutCell | Filter | IS_INPUT_MODE |
| SetPlanOutCellRaw | clicked_row | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, CELL_GROUP_CODE, PACK_ITEM_ID, CELL_ITEM_ID, PRODUCTION_TYPE, MARKET, ITEM_TYPE, CATEGORY_ID |
| SetPlanOutCellRaw | x | FACTORY_ID, LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, PLAN_DATE, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, DIVISION_ID, SITE_ID, PLANT_ID |
| SetPlanOutCellRaw | new_row | INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, PRODUCTION_TYPE, MARKET, ITEM_ID, TOP_ITEM_ID, PLAN_DATE, LOCATION, ITEM_TYPE, M, SEQ |
| SetPlanOutCellRaw | Filter | PACK_INSTANCE_ID, PACK_PLAN_ID, FORM_INSTANCE_ID, FORM_PLAN_ID |
| SetPlanOutCellRaw | editorCurrentRow | OUT_QTY, ORG_QTY |
| SetPlanOutCellRaw | row | CELL_GROUP_CODE, PACK_GROUP_CODE, FACTORY_ID, LINE_ID, CELL_ITEM_ID |
| SetPlanOutCellRaw | rowYield[0] | F6000_YIELD, DEGAS_YIELD, BEFORE_DEGAS_YIELD, AFTER_DEGAS_YIELD |
| SetPlanOutCellRaw | rowLT[0] | STANDARD_LT, STANDARD_LT_SUM |
| SetReleaseProcess | Filter | PLAN_TYPE |
| SetReleaseProcess | ds_isCurrWeek.Tables[0].Rows[0] | CURR_DATE |
| SetReleaseProcess | row | _DATE, IS_PLAN |
| spdMain_CellClick | row | PRODUCTION_TYPE, DATA_TYPE, OPERATION_ID, TOP_ITEM_ID |
| spdMain_CellClick2 | row | LINE_ID, PRODUCTION_TYPE, DATA_TYPE, OPERATION_ID, TOP_ITEM_ID |
| spdMain_CellDoubleClick | clicked_row | SHOP_TYPE, DIVISION_ID, SITE_ID, PLANT_ID, CELL_GROUP_CODE, CELL_ITEM_ID, PACK_GROUP_CODE |
| spdMain_CellDoubleClick | Filter | FORM_INSTANCE_ID, PLAN_DATE, FORM_PLAN_ID, BUCKET_FROM, BUCKET_TO |
| spdMain_CellDoubleClick | inputFilter | PLAN_DATE, DIVISION_ID, SITE_ID, PLANT_ID, GROUP_CELL_CODE, CELL_ITEM_ID, PACK_ITEM_ID, SHOP_TYPE, BUCKET_FROM, BUCKET_TO, ITEM_IN, GROUP_CELL_YN |
| SwitchMemo | r | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET |
| SwitchMemo | memoRow | PRODUCTION_TYPE, ITEM_ID |
| SwitchMemo | memo[k] | ITEM_ID |
| SwitchMemo | materialRow | PRODUCTION_TYPE |
| UIFindData | Filter | PLAN_TYPE, DONOTEDIT, PLAN_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:207, InitControl:281, CheckAndGetMeasure:844, btnCatagory_Click:11287, btnCategory_Click:11621 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| GetCheckedListValue | InitControls:241, MakeInstanceLT:319, MakeInstanceLT:320, MakeInstanceLT:321, mcbo_planner_Cell_changed:547, mcbo_planner_Pack_changed:562, mcbo_planner_Form_changed:576, GetPlanner:674 | CString.GetCheckedListValue | CODE |
| SetFilter | chk_allLine_Cell_CheckedChanged:522, chk_allLine_Pack_CheckedChanged:527, chk_allLine_Form_CheckedChanged:532, mcbo_planner_Cell_changed:545, mcbo_planner_Cell_changed:548, mcbo_planner_Pack_changed:560, mcbo_planner_Pack_changed:563, mcbo_planner_Form_changed:575 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| EditQuery | RefreshHeader:888, RefreshHeader:915 | FPExtensions.EditQuery | ROW_ID |
| GetChanges | Save_Data_Sim:1522, Save_Data_Pack:1711, Save_Data_Cell:1951, Save_Data_Form:2194 | FPExtensions.GetChanges | ROW_ID |
| FP_UpdateBatch | Save_Data_Sim:1669 | DataService.FP_UpdateBatch | COUNT, RESULT |
| GetInnerTable | GetInstance:3391, SetChangeControl:11995 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| SetManualCondition | spdMain_CellDoubleClick:11489, spdMain_CellDoubleClick:11490, spdMain_CellDoubleClick:11491, spdMain_CellDoubleClick:11492, spdMain_CellDoubleClick:11493, spdMain_CellDoubleClick:11494, spdMain_CellDoubleClick:11497 | BaseForm.SetManualCondition | ControlName, ControlValue |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:512 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:549 |
| this | Load | MeasureSetForm_Load | InitializeComponent:681 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:682 |
| this | Load | Form_Load | .ctor:169 |
| cbo_site | SelectedIndexChanged | cbo_site_changed | InitEvent:471 |
| cbo_pack_plan_id | SelectedIndexChanged | cbo_pack_plan_id_changed | InitEvent:477 |
| cbo_form_plan_id | SelectedIndexChanged | cbo_form_plan_id_changed | InitEvent:478 |
| cbo_cell_plan_id | SelectedIndexChanged | cbo_cell_plan_id_changed | InitEvent:479 |
| date_instance | ValueChanged | plan_day_changed | InitEvent:482 |
| range_plan | ValueChanged | plan_range_changed | InitEvent:483 |
| txt_pack_code | TextChanged | pack_code_changed | InitEvent:485 |
| txt_cell_code | TextChanged | cell_code_changed | InitEvent:486 |
| txt_pack_nick | TextChanged | pack_nick_changed | InitEvent:487 |
| txt_cell_nick | TextChanged | cell_nick_changed | InitEvent:488 |
| txt_group_cell | TextChanged | group_cell_changed | InitEvent:489 |
| chk_form_plan_group | CheckedChanged | chk_changed | InitEvent:491 |
| chk_pack_plan_group | CheckedChanged | chk_changed | InitEvent:492 |
| chk_cell_plan_group | CheckedChanged | chk_changed | InitEvent:493 |
| chk_input_mode | CheckedChanged | chk_input_mode_changed | InitEvent:494 |
| chk_pack_plan_info | CheckedChanged | chk_info_changed | InitEvent:496 |
| chk_form_plan_info | CheckedChanged | chk_info_changed | InitEvent:497 |
| chk_cell_plan_info | CheckedChanged | chk_info_changed | InitEvent:498 |
| spdMain | CellClick | spdMain_CellClick2 | InitEvent:500 |
| mcbo_planner_Cell | SelectedIndexChanged | mcbo_planner_Cell_changed | InitEvent:507 |
| mcbo_planner_Pack | SelectedIndexChanged | mcbo_planner_Pack_changed | InitEvent:508 |
| mcbo_planner_Form | SelectedIndexChanged | mcbo_planner_Form_changed | InitEvent:509 |
| chk_allLine_Cell | CheckedChanged | chk_allLine_Cell_CheckedChanged | InitEvent:511 |
| chk_allLine_Pack | CheckedChanged | chk_allLine_Pack_CheckedChanged | InitEvent:512 |
| chk_allLine_Form | CheckedChanged | chk_allLine_Form_CheckedChanged | InitEvent:513 |
| chk_allLine_Cell | CheckedChanged | chk_allLine_Cell_CheckedChanged | mcbo_planner_Cell_changed:539 |
| chk_allLine_Cell | CheckedChanged | chk_allLine_Cell_CheckedChanged | mcbo_planner_Cell_changed:544 |
| chk_allLine_Pack | CheckedChanged | chk_allLine_Pack_CheckedChanged | mcbo_planner_Pack_changed:554 |
| chk_allLine_Pack | CheckedChanged | chk_allLine_Pack_CheckedChanged | mcbo_planner_Pack_changed:559 |
| chk_allLine_Form | CheckedChanged | chk_allLine_Form_CheckedChanged | mcbo_planner_Form_changed:569 |
| chk_allLine_Form | CheckedChanged | chk_allLine_Form_CheckedChanged | mcbo_planner_Form_changed:574 |
| popSql | OnSql | RunSqlSource | btnSql_Click:2637 |
| cbo_pack_plan_group | SelectedIndexChanged | cbo_pack_plan_group_changed | GetInstance:3392 |
| cbo_pack_plan_group | SelectedIndexChanged | cbo_pack_plan_group_changed | GetInstance:3428 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick2:10577 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick2:10587 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick2:10602 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick2:10614 |
| nlfamend_menu | Click | onNLFAmendMenu | spdMain_CellClick2:10621 |
| date_instance | ValueChanged | plan_day_changed | cbo_pack_plan_group_changed:10667 |
| date_instance | ValueChanged | plan_day_changed | cbo_pack_plan_group_changed:10672 |
| range_plan | ValueChanged | plan_range_changed | plan_range_changed:11087 |
| range_plan | ValueChanged | plan_range_changed | plan_range_changed:11095 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick:11821 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick:11843 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick:11860 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick:11872 |
| nlfamend_menu | Click | onNLFAmendMenu | spdMain_CellClick:11879 |
| this.chk_pack_plan_info | CheckedChanged | chk_pack_plan_info_CheckedChanged | InitializeComponent:594 |
| this.cbo_form_plan_id | DropDown | cbo_form_plan_id_DropDown | InitializeComponent:778 |
| this.cbo_cell_plan_id | DropDown | cbo_cell_plan_id_DropDown | InitializeComponent:850 |
| this.btnToggleSave | Click | btnToggleSave_Click | InitializeComponent:961 |
| this.cbo_pack_plan_id | DropDown | cbo_pack_plan_id_DropDown | InitializeComponent:1176 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:1321 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:2046 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:2047 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:2048 |
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:2049 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:2050 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:2051 |
| this.spdMain | ColumnWidthChanged | spdMain_ColumnWidthChanged | InitializeComponent:2052 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:2053 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:2054 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:2055 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:2056 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:2057 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:2058 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:2059 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:2060 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:2061 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:2062 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:2063 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:2064 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:2065 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:2066 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:2067 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:2068 |
| this.button1 | Click | button1_Click | InitializeComponent:2202 |
| this.btnCategory | Click | btnCategory_Click | InitializeComponent:2397 |
| this.btn_column | Click | btnColumn_Click | InitializeComponent:2509 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:122 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:123 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:124 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:125 |
| this.spdMain | EnabledChanged | spdMain_EnabledChanged | InitializeComponent:126 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:127 |
| this | Load | Form_Load | .ctor:109 |

## 6. 컨트롤 (170개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| CheckBox | 41 | chk_pack_unhold_exp_qty, chk_pack_eoh_good_unhold_exp, chk_pack_yield, chk_pack_result, chk_pack_plan_out, chk_pack_eoh_good_sim, chk_pack_eoh_sim, chk_pack_eoh_good, chk_pack_eoh, chk_pack_prod_target, chk_pack_scp_target, chk_pack_shipping_gap, chk_pack_shipping_plan_sim, chk_pack_shipping_result, chk_pack_shipping_plan … |
| LayoutControlItem | 32 | lblSql, layoutControlItem15, layoutControlItem10, layoutControlItem22, layoutControlItem11, layoutControlItem29, layoutControlItem8, layoutControlItem5, layoutControlItem3, layoutControlItem30, layoutControlItem17, layoutControlItem6, layoutControlItem4, layoutControlItem1, layoutControlItem13 … |
| Label | 15 | label1, label2, label3, label3, txtBuilding, txtBasic, txtDesc, txtCreation, txtCreator, label7, label6, label5, label4, label2, label1 |
| UsrCheckBox | 10 | chk_allLine_Cell, chk_allLine_Pack, chk_cell_plan_info, chk_form_plan_info, chk_pack_plan_info, chk_input_mode, chk_pack_plan_group, chk_cell_plan_group, chk_form_plan_group, chk_allLine_Form |
| UsrButton | 8 | usrButton1, usrButton2, btnToggleSave, btnSql, btnReplan, usrButton2, btnCategory, btn_column |
| EmptySpaceItem | 8 | emptySpaceItem4, emptySpaceItem5, emptySpaceItem6, emptySpaceItem2, emptySpaceItem3, emptySpaceItem7, emptySpaceItem8, emptySpaceItem1 |
| Panel | 7 | panel1, panel3, panel2, infoPanel, panel2, panel4, panel1 |
| UsrCombo | 7 | cbo_form_plan_id, cbo_form_plan_group, cbo_cell_plan_id, cbo_cell_plan_group, cbo_pack_plan_group, cbo_pack_plan_id, cbo_site |
| UsrCheckedList2 | 6 | mcbo_line_Form, mcbo_line_Pack, mcbo_planner_Pack, mcbo_planner_Form, mcbo_planner_Cell, mcbo_line_Cell |
| UsrTextBox | 5 | txt_group_cell, txt_cell_nick, txt_pack_code, txt_pack_nick, txt_cell_code |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| DataGridView | 4 | dgEditSim, dgEditCell, dgEditForm, dgEditPack |
| FpSpread | 3 | spdMain, spdEdit, spdMain |
| SheetView | 3 | spdMain_Sheet1, spdEdit_Sheet1, spdMain_Sheet1 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrLabel | 2 | txtPlanId, usrLabel2 |
| Splitter | 2 | splitter2, splitter1 |
| UsrDatePicker2 | 1 | date_instance |
| UsrDateRangePicker2 | 1 | range_plan |
| SplitContainer | 1 | splitter |
| Button | 1 | button1 |
| ImageList | 1 | imageList1 |
| GroupBox | 1 | groupBox1 |
| TextBox | 1 | tbLog |

## 7. 확인 필요 (8건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1872 | Save_Data_Pack | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2112 | Save_Data_Cell | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2345 | Save_Data_Form | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3123 | SetReleaseProcess | FP\{?default:part_service}\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3975 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3976 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3977 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3978 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 52 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 16 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 17 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 163 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00641 | InvDetail | 14/1 | 14/1 | 14/1 | 14/1 | 14/1 | 14/1 | 14/1 | 14/1 | 14/1 | 14/1 | 14/1 | 14/1 | 14/1 | 14/1 |
| SCM_MST_SHEET_COLUMNS | FP00641 | Main | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main, InvDetail
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@RefreshHeaderOnly:1031, SetSheetHeaderColumn_FP@SetSpreadInit:167
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 2084 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2085 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2086 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2087 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2601 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2602 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2603 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2604 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 143 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 144 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 145 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 146 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| InvDetail | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |
| Main | META+코드연결 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
