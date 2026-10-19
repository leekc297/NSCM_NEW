# FP00620 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\FP00620_BucketSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\FP00620_PlanBy_Line_Electrode_Production.csproj | 254 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\FP00620_BucketSetForm_Popup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\FP00620_PlanBy_Line_Electrode_Production.csproj | 248 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\FP00620_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\FP00620_PlanBy_Line_Electrode_Production.csproj | 397 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\FP00620_MeasureSetForm_Popup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\FP00620_PlanBy_Line_Electrode_Production.csproj | 391 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\FP00620_PlanBy_Line_Electrode_Production.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\FP00620_PlanBy_Line_Electrode_Production.csproj | 5368 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\FP00620_PlanBy_Line_Electrode_Production.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\FP00620_PlanBy_Line_Electrode_Production.csproj | 1558 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\FP00620_PlanBy_Line_Electrode_Production.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\FP00620_PlanBy_Line_Electrode_Production.csproj | 72 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\Properties\Settings.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00620_PlanBy_Line_Electrode_Production\FP00620_PlanBy_Line_Electrode_Production.csproj | 31 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl | 573 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl | 573 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetPlanPeriod | 4921 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PlanPeriod] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetPlanPeriod | 4921 | FP\Planning\FP00620#find_PlanPeriod | MATCH | [sql] foxquery_sql\FP_Planning_FP00620_find_PlanPeriod.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > SetChangeControl | 573 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > SetChangeControl | 573 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 573 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 573 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:chk_IncludeSubOp.CheckedChanged | chk_IncludeSubOp_CheckedChanged > SetChangeControl | 573 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:chk_IncludeSubOp.CheckedChanged | chk_IncludeSubOp_CheckedChanged > SetChangeControl | 573 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:dCalendar_planrange.ValueChanged | dCalendarPlanrange_changed | 3511 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:dCalendar_planrange.ValueChanged | dCalendarPlanrange_changed | 3515 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PlanPeriod] | BIZ_MATCH |  |
| event:dCalendar_planrange.ValueChanged | dCalendarPlanrange_changed | 3515 | FP\Planning\FP00620#find_PlanPeriod | MATCH | [sql] foxquery_sql\FP_Planning_FP00620_find_PlanPeriod.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 2202 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 2204 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 2209 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 2211 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 2214 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 2220 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 2224 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 2228 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 2320 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 2347 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2419 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2419 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2420 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2420 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2421 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2421 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetChangeControl | 573 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetChangeControl | 573 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetChangeControl | 573 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetChangeControl | 573 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_line.SelectedIndexChanged | mcbo_line_changed > SetChangeControl | 573 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_line.SelectedIndexChanged | mcbo_line_changed > SetChangeControl | 573 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetChangeControl | 573 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetChangeControl | 573 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetChangeControl | 573 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetChangeControl | 573 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed | 3434 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed | 3434 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > SetChangeControl | 573 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > SetChangeControl | 573 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2419 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2419 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2420 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2420 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2421 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2421 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 2202 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 2204 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 2209 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 2211 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 2214 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 2220 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 2224 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 2228 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplySearchCondition | 2320 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplySearchCondition | 2347 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > SaveData > Find_Data > Find_Data_Amend | 2202 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > SaveData > Find_Data > Find_Data_Amend | 2204 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > SaveData > Find_Data > Find_Data_Amend | 2209 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > SaveData > Find_Data > Find_Data_Amend | 2211 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > SaveData > Find_Data > Find_Data_Amend | 2214 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > SaveData > Find_Data > Find_Data_Amend | 2220 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > SaveData > Find_Data > Find_Data_Amend | 2224 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > SaveData > Find_Data > Find_Data_Amend | 2228 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > SaveData > Find_Data > Find_Data_Amend > ApplySearchCondition | 2320 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > SaveData > Find_Data > Find_Data_Amend > ApplySearchCondition | 2347 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:SaveButton | SaveButton > SaveData > Find_Data > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2419 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > Find_Data > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2419 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:SaveButton | SaveButton > SaveData > Find_Data > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2420 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > Find_Data > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2420 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:SaveButton | SaveButton > SaveData > Find_Data > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2421 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > Find_Data > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2421 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 2202 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 2204 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 2209 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 2211 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 2214 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 2220 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 2224 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 2228 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 2320 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 2347 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2419 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2419 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2420 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2420 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2421 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2421 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 2202 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 2204 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 2209 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 2211 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 2214 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 2220 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 2224 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 2228 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 2320 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 2347 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2419 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2419 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2420 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2420 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2421 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2421 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2419 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2419 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2420 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2420 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2421 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2421 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 573 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 573 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.chk_IncludeSubOp.CheckedChanged | chk_IncludeSubOp_CheckedChanged > SetChangeControl | 573 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.chk_IncludeSubOp.CheckedChanged | chk_IncludeSubOp_CheckedChanged > SetChangeControl | 573 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.chkInAct.CheckedChanged | chkInAct_CheckedChanged > SetChangeControl | 573 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.chkInAct.CheckedChanged | chkInAct_CheckedChanged > SetChangeControl | 573 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.dCalendar_planrange.ValueChanged | dCalendarPlanrange_changed | 3511 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.dCalendar_planrange.ValueChanged | dCalendarPlanrange_changed | 3515 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PlanPeriod] | BIZ_MATCH |  |
| event:this.dCalendar_planrange.ValueChanged | dCalendarPlanrange_changed | 3515 | FP\Planning\FP00620#find_PlanPeriod | MATCH | [sql] foxquery_sql\FP_Planning_FP00620_find_PlanPeriod.sql |
| event:this.Load | Form_Load > InitControls | 478 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 478 | FP\Common\AmendMemo#find_SetupColor_P | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_find_SetupColor_P.sql |
| event:this.Load | Form_Load > InitControls > mcbo_line_changed > SetChangeControl | 573 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > mcbo_line_changed > SetChangeControl | 573 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > mcbo_plant_changed | 3434 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > mcbo_plant_changed | 3434 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > cbo_plan_group_changed > SetPlanPeriod | 4921 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PlanPeriod] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > cbo_plan_group_changed > SetPlanPeriod | 4921 | FP\Planning\FP00620#find_PlanPeriod | MATCH | [sql] foxquery_sql\FP_Planning_FP00620_find_PlanPeriod.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > SetChangeControl | 573 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > SetChangeControl | 573 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2419 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2419 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2420 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2420 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2421 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2421 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 144 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PlanPeriod] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 2 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 11 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP\Common\AmendMemo#find_SetupColor_P | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_find_SetupColor_P.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\AmendMemo#list_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 2 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\PICAlarm#find_Category | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Planning\FP00620#find_PlanPeriod | MATCH | 2 | [sql] foxquery_sql\FP_Planning_FP00620_find_PlanPeriod.sql | SELECT:TH_UIS_CALENDAR, SELECT:TH_UIS_CAL, SELECT:FP_WEEKLY_DEMAND_PRODUCT_H, SELECT:SCM_FACTORY_M, SELECT:FP_INSTANCE_FACTORY_M, SELECT:SCM_SYS_LOOKUP_VALUE, REF:FN_SITE_TIME, SELECT:FP_INSTANCE_INFO_V |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplySearchCondition | Filter | BUCKET_FROM, BUCKET_TO, INSTANCE_ID, PLAN_ID, SITE_ID, CONFIRM_AREA, MASTER_ID |
| ApplySearchCondition | dt.Rows[0] | CURR_DATE |
| btn_setupinfo_Click | Filter | INSTANCE_ID |
| btn_setupinfo_Click | Application.OpenForms | FPC0108_btn_setupinfoPopup |
| btnBucket_Click | Application.OpenForms | FP00620_BucketSetForm_Popup |
| btnBucket_Click | measure | chk_week_sun |
| btnCatagory_Click | Application.OpenForms | FP00620_MeasureSetForm_Popup |
| btnColumn_Click | Application.OpenForms | FPC0097_ColumnSetForm_Popup |
| btnMemo_Click | Filter | INSTANCE_ID, BUCKET_FROM, BUCKET_TO, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID |
| btnMemo_Click | memoPopup.Filter | MASTER_ID, BUCKET_FROM, BUCKET_TO, MODEL_ID, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID, USER_ID |
| btnPlanInfo_Click | Filter | INSTANCE_ID, CONFIRM_AREA |
| btnPlanInfo_Click | Application.OpenForms | FPC0106_PlanInfoPopup |
| btnPlanInfo_Click | planInfoPopup.Filter | MASTER_ID, INSTANCE_ID, CONFIRM_AREA, USER_ID |
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| CheckAndGetMeasure | measure.Data | chk_week, chk_day, chk_month, chk_totalBatch, chk_week_sun |
| checkTotalBatch | SP_DataSource.Tables[0].Columns | CATEGORY_NAME, MEASURE_NAME |
| CreateDataLine | material_column | P_IN, P_IN_CELL, P_OUT, P_OUT_CELL |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_total, chk_inqty_tot, chk_batch, chk_jr, chk_pc, chk_cell, chk_outqty_tot, chk_inqty, chk_outqty, chk_seq, chk_offtime, chk_memo, chk_subTotal, chk_memo_tot |
| CreateFilterDataSet | x | _MM_ |
| dCalendarPlanrange_changed | dtPeriod.Rows[0] | END_DATE |
| DrawHeader | measure.Data | chk_totalBatch, chk_day, chk_week, chk_month |
| DrawHeader | Filter | BUCKET_FROM |
| Find_Data_Amend | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, CURR_DATE_COL, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO, CATE_VALUE, CATE_TYPE |
| Find_Data_Amend | row | MEA_ID, MEA_VALUE |
| Find_Line_Savings_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | related_row | CATEGORY_ID, PRODUCTION_TYPE |
| Find_MaterialData_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | related_row | CATEGORY_ID |
| GetPlanGroup | Filter | USER_ID, MASTER_ID, INSTANCE_ID, USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| GetPlanGroup | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| InitControls | Filter | USER_ID |
| onNLFAmendMenu | frm.Filter | MASTER_ID, FP_PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onNLFAmendMenu | Filter | INSTANCE_ID, PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onZeroBucketMenu | row_to_test | CATEGORY_ID |
| onZeroMaterialMenu | row_to_test | CATEGORY_ID |
| OpenLineMemo | frm.Filter | MEMO_TYPE |
| OpenMaterialMemo | frm.Filter | MEMO_TYPE |
| Query | rCate | SEGMENT1, ATTRIBUTE2 |
| Query | row | CATEGORY_ID |
| SaveData | SP_DataSource.Tables[0].Columns | MEASURE_NAME, CATEGORY_NAME, DATA_TYPE, LINE_NAME |
| SaveData | SP_DataSource.Tables[0].Rows[iRow] | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LINE_ID, OPERATION_ID, MARKET, PRODUCTION_TYPE, ELECTRODE_TYPE, LOCATION, EQUIPMENT_ID, PC_MODEL_ID, VERSION, PLM_EC_NO, PROD_SEQ |
| SaveData | Filter | WEEK_INFO |
| SaveData | weekInfo.Tables[0].Rows[w] | WEEK_NAME |
| SetChangeControl | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| SetChangeControl | Filter | MASTER_ID, INSTANCE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID |
| SetChangeControl | dtOperation.Rows[0] | CODE, NAME |
| SetColumnsFormat | SP_DataSource.Tables[0].Columns | MEASURE_NAME, CATEGORY_NAME |
| SetEditMode | dsMain.Tables[0].Columns | DATA_TYPE, MEASURE_NAME, CATEGORY_NAME, W0 |
| SetEditMode | SP_DataSource.Tables[0].Columns | CATEGORY_NAME, MEASURE_NAME, LINE_NAME |
| setMeasualFormData | dtCategory.Rows[i] | MEA_ID, MEA_VALUE |
| SetPlanPeriod | dtPeriod.Rows[0] | START_DATE, END_DATE |
| SetTotalColor | row | DATA_TYPE |
| SetTotalColor | dsMainFiltered.Tables[0].Rows[line] | MAX_VER_FLAG |
| spdMain_CellClick | row | LINE_ID, PRODUCTION_TYPE, DATA_TYPE |
| SwitchMemo | r | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET |
| SwitchMemo | memoRow | ITEM_ID |
| SwitchMemo | memo[k] | ITEM_ID |
| UIFindData | Filter | BUCKET_FROM, BUCKET_TO |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:135, InitControl:159, Measure:170, InitControl:232, RefreshSpreadSheet:2364, CheckAndGetMeasure:3215 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| SetFilter | InitControls:448, InitControls:449, InitControls:450, InitControls:451, InitControls:466, SetChangeControl:544, SetChangeControl:545, SetChangeControl:546 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetCheckedListValue | InitControls:466, SetChangeControl:543, SetChangeControl:556, SetChangeControl:564, SetChangeControl:572, SetChangeControl:581, SetChangeControl:596, SetChangeControl:604 | CString.GetCheckedListValue | CODE |
| GetInnerTable | SetChangeControl:539, SetChangeControl:549, SetChangeControl:557, SetChangeControl:565, SetChangeControl:573, SetChangeControl:597, GetPlanGroup:4862 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| SaveData | SaveButton:911 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| ApplyMemoTextLine | Query:2436 | MemoService.ApplyMemoTextLine | ATTR2, CATEGORY_ID, COMPANY_ID, DATA_TYPE, DIVISION_ID, ELECTRODE_TYPE, EQUIPMENT_ID, FACTORY_ID, ITEM_ID, LINE_ID, MARKET, MEMO, OPERATION_ID, PLANT_ID, PLAN_DATE, PRODUCTION_TYPE, TOP_ITEM_ID |
| EditQuery | Query:2465 | FPExtensions.EditQuery | ROW_ID |
| ApplyMemoTagLine | Query:2467 | MemoService.ApplyMemoTagLine | CATEGORY_ID, COMPANY_ID, DATA_TYPE, DIVISION_ID, ELECTRODE_TYPE, FACTORY_ID, ITEM_ID, LINE_ID, MARKET, OPERATION_ID, PLANT_ID, PLAN_DATE, PRODUCTION_TYPE, TOP_ITEM_ID |
| SetTotalColor | DrawSheet:2492 | SpreadInfo.SetTotalColor | column_cnt, grouping_cnt, row_idx |
| ShowMemoLine | DrawSheet:2501 | MemoService.ShowMemoLine | ATTR1, ATTR2, ATTRIBUTE10, ATTRIBUTE2, COLOR_A, COLOR_B, DATA_TYPE, Default, ELECTRODE_TYPE, EQUIPMENT_ID, INSTANCE_ID, ITEM_ID, PRODUCTION_TYPE, SEGMENT1, UI_COLOR, UI_DESC, UI_PARAM, chk_day |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:3185 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| SetRowsUnVisible | CreateFilterDataSet:3188 | MeasureService.SetRowsUnVisible | _MM_ |
| FP_Log2 | cbo_plan_group_changed:3408, cbo_plan_group_changed:3411 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| LoadAmendColumn | DrawHeader:3878 | MeasureService.LoadAmendColumn | DAYTAG, MONTHTAG, WEEKTAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:169 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:206 |
| this | Load | MeasureSetForm_Load | InitializeComponent:220 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:221 |
| this.btnSet | Click | btnSet_Click | InitializeComponent:159 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:197 |
| this | Load | MeasureSetForm_Load | InitializeComponent:348 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:349 |
| this | Load | Form_Load | .ctor:217 |
| dsdmLine | Changed | SpdMain_Changed | Form_Load:235 |
| cbo_plan_group | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:299 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:301 |
| cbo_site | SelectedIndexChanged | cbo_site_changed | InitEvent:302 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:303 |
| mcbo_factory | SelectedIndexChanged | mcbo_factory_changed | InitEvent:304 |
| mcbo_operation | SelectedIndexChanged | mcbo_operation_changed | InitEvent:305 |
| mcbo_line | SelectedIndexChanged | mcbo_line_changed | InitEvent:306 |
| dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitEvent:311 |
| chk_allLine | CheckedChanged | chk_allLine_CheckedChanged | InitEvent:313 |
| chk_IncludeSubOp | CheckedChanged | chk_IncludeSubOp_CheckedChanged | InitEvent:314 |
| usrCombo_Zoom | SelectedIndexChanged | usrCombo_Zoom_SelectedIndexChanged | InitEvent:318 |
| chk_totalBatch | CheckedChanged | Chk_totalBatch_CheckedChanged | InitEvent:320 |
| spdMain.ActiveSheet | CellChanged | ActiveSheet_CellChanged | InitEvent:323 |
| chk_totalBatch | CheckedChanged | Chk_totalBatch_CheckedChanged | Chk_totalBatch_CheckedChanged:337 |
| popSql | OnSql | RunSqlSource | btnSql_Click:4109 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick:4627 |
| this.chk_IncludeSubOp | CheckedChanged | chk_IncludeSubOp_CheckedChanged | InitializeComponent:227 |
| this.chkInAct | CheckedChanged | chkInAct_CheckedChanged | InitializeComponent:301 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:341 |
| this.dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitializeComponent:394 |
| this.chk_allLine | CheckedChanged | chk_allLine_CheckedChanged | InitializeComponent:432 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:1073 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1074 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1075 |
| this.btnMemo | Click | btnMemo_Click | InitializeComponent:1235 |
| this.btnPlanInfo | Click | btnPlanInfo_Click | InitializeComponent:1273 |
| this.btnSetupColor | Click | btn_setupinfo_Click | InitializeComponent:1311 |
| this.btnBucket | Click | btnBucket_Click | InitializeComponent:1349 |
| this.btnCatagory | Click | btnCatagory_Click | InitializeComponent:1387 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:1425 |

## 6. 컨트롤 (79개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| CheckBox | 18 | chk_week_sun, chk_totalBatch, chk_month, chk_week, chk_day, chk_subTotal, chk_total, chk_outqty_tot, chk_inqty_tot, chk_cell, chk_jr, chk_pc, chk_batch, chk_inqty, chk_outqty … |
| LayoutControlItem | 14 | lblSql, layoutControlItem5, layoutControlItem7, layoutControlItem8, Operation, layoutControlItem10, layoutControlItem2, layoutControlItem11, layoutControlItem6, layoutControlItem9, layoutControlItem17, layoutControlItem3, layoutControlItem1, layoutControlItem4 |
| UsrButton | 12 | usrButton1, usrButton2, btnSet, btnOK, btnSql, usrButton2, btnMemo, btnPlanInfo, btnSetupColor, btnBucket, btnCatagory, btnColumn |
| Panel | 7 | panel1, panel3, panel2, panel1, panel2, panel4, panel1 |
| Label | 5 | label2, label1, label2, label3, label1 |
| UsrCheckedList2 | 5 | mcbo_line, mcbo_operation, mcbo_factory, mcbo_plant, mcbo_division |
| UsrCheckBox | 4 | chk_IncludeSubOp, chkInAct, chk_allLine, chk_totalBatch |
| UsrCombo | 3 | cbo_site, cbo_plan_group, usrCombo_Zoom |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePickerWtWeek | 1 | dCalendar_planrange |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| SplitContainer | 1 | splitter |
| TextBox | 1 | tbLog |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (4건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 478 | InitControls | FP\{?default:part_service}\AmendMemo#find_SetupColor_P | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2419 | Query | FP\{?default:part_service}\AmendMemo#list_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2420 | Query | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2421 | Query | FP\{?default:part_service}\PICAlarm#find_Category_Color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 45 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 28 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 45 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 12 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 480 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 2019 | FP_Planning.PR_UI_FP00622_AMEND_LINE | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00620 | Amend | 20/23 | 20/23 | 20/23 | 20/23 | 20/23 | 20/23 | 20/23 | 20/23 | 20/23 | 20/23 | 20/23 | 20/23 | 20/23 | 20/23 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@DrawHeader:3782
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| ExportExcelSimple |  | 1105 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ else!(RemoveActionCell == true && i == 0 && newSheet.Columns[i].DataField.ToUpper() == "ACTION") ⟫ else!(RemoveInvisibleCell && newSheet.Columns[i].Width <= 0) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| ExportExcelSimple |  | 1185 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| SetCalenderColor |  | 2583 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 2589 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| SetColumnsFormat |  | 2925 | 표시/라벨 변경 | set:CellType | CellType = {?num_ppm} |  | if(siMain != null) ⟫ if(ippm != -1) |
| spdMain_CellDoubleClick |  | 4590 | 표시/라벨 변경 | set:Visible | Visible = {?!spdMain.ActiveSheet.Columns[idx].Visible} |  | else!(!sHeadNameLevel2.Equals("Week Sum")) ⟫ for(idx > e.Column - 1 - 7) |
| InitializeComponent |  | 1091 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1092 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1093 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1094 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
