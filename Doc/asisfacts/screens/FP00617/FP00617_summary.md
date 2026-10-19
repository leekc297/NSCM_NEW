# FP00617 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00617_PlanBy_Line_PreMix.UIL\FP00617_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00617_PlanBy_Line_PreMix.UIL\FP00617_PlanBy_Line_PreMix.UIL.csproj | 451 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00617_PlanBy_Line_PreMix.UIL\FP00617_MeasureSetForm_Popup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00617_PlanBy_Line_PreMix.UIL\FP00617_PlanBy_Line_PreMix.UIL.csproj | 564 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00617_PlanBy_Line_PreMix.UIL\FP00617_PlanBy_Line_PreMix.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00617_PlanBy_Line_PreMix.UIL\FP00617_PlanBy_Line_PreMix.UIL.csproj | 2992 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00617_PlanBy_Line_PreMix.UIL\FP00617_PlanBy_Line_PreMix.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00617_PlanBy_Line_PreMix.UIL\FP00617_PlanBy_Line_PreMix.UIL.csproj | 1967 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00617_PlanBy_Line_PreMix.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00617_PlanBy_Line_PreMix.UIL\FP00617_PlanBy_Line_PreMix.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetDivision | 2147 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetLine | 2208 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetProdType | 2220 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetNickNameLT | 2229 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetPlanPeriod | 2250 | biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > SetPlant | 2167 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetLine | 2208 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetNickNameLT | 2229 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:dCalendar_planrange.ValueChanged | dCalendarPlanrange_changed | 1469 | biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 726 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 729 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 732 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 735 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 738 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 801 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 828 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2822 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2822 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2823 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2823 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2824 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2824 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetSite | 2156 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetOperation | 2192 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetLine | 2208 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetFactory | 2180 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > GetOperation | 1729 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2822 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2822 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2823 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2823 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2824 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2824 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition | 726 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition | 729 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition | 732 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition | 735 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition | 738 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplySearchCondition | 801 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplySearchCondition | 828 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 726 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 729 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 732 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 735 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 738 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 801 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 828 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2822 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2822 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2823 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2823 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2824 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2824 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 726 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 729 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 732 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 735 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 738 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 801 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 828 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2822 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2822 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2823 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2823 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2824 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2824 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2822 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2822 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2823 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2823 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2824 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2824 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetLine | 2208 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetNickNameLT | 2229 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.chkInAct.CheckedChanged | chkInAct_CheckedChanged > SetLine | 2208 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.chkInAct.CheckedChanged | chkInAct_CheckedChanged > SetNickNameLT | 2229 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.dCalendar_planrange.ValueChanged | dCalendarPlanrange_changed | 1469 | biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetPlanGroup | 2132 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetDivision | 2147 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetSite | 2156 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetPlant | 2167 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetFactory | 2180 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetOperation | 2192 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetLine | 2208 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetProdType | 2220 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetNickNameLT | 2229 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetPlanPeriod | 2250 | biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > GetOperation | 1729 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2822 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2822 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2823 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2823 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2824 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeadAndBody > DrawSheet > Query | 2824 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 134 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 1 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 13 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP\Common\AmendMemo#list_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\PICAlarm#find_Category | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO, CATE_VALUE, CATE_TYPE |
| ApplyAmendCalendarCondition | row | MEA_ID, MEA_VALUE |
| ApplySearchCondition | Filter | BUCKET_FROM, BUCKET_TO, INSTANCE_ID, PLAN_ID, SITE_ID, CONFIRM_AREA, MASTER_ID |
| ApplySearchCondition | dt.Rows[0] | CURR_DATE |
| btnBucket_Click | Application.OpenForms | FP00599_BucketSetForm_Popup |
| btnCatagory_Click | Application.OpenForms | FP00617_MeasureSetForm_Popup |
| btnColumn_Click | Application.OpenForms | FPC0097_ColumnSetForm_Popup |
| btnMemo_Click | Filter | INSTANCE_ID, BUCKET_FROM, BUCKET_TO, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID |
| btnMemo_Click | memoPopup.Filter | MASTER_ID, BUCKET_FROM, BUCKET_TO, MODEL_ID, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID, USER_ID |
| btnPlanInfo_Click | Filter | INSTANCE_ID, CONFIRM_AREA |
| btnPlanInfo_Click | Application.OpenForms | FPC0106_PlanInfoPopup |
| btnPlanInfo_Click | planInfoPopup.Filter | MASTER_ID, INSTANCE_ID, CONFIRM_AREA, USER_ID |
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| cbo_plan_group_changed | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| CreateDataLine | material_column | P_IN, P_IN_CELL, P_OUT, P_OUT_CELL |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_wpp_inqty, chk_wpp_outqty, chk_result_in, chk_mpp_inqty, chk_mpp_outqty, chk_seq, chk_memo, chk_inqty, chk_outqty, chk_offtime, chk_subTotal, chk_memo_tot, chk_wpp_inqty_tot, chk_wpp_outqty_tot, chk_result_in_tot, chk_mpp_inqty_tot, chk_mpp_outqty_tot, chk_result_out_tot, chk_inqty_tot, chk_outqty_tot, chk_total, chk_kg, chk_batch |
| CreateFilterDataSet | x | MEASURE_NAME, _MM_ |
| dCalendarPlanrange_changed | Filter | INSTANCE_ID |
| dCalendarPlanrange_changed | dtPeriod_Plan.Rows[0] | START_DATE, END_DATE |
| DrawHeader | Filter | BUCKET_FROM |
| DrawHeader | measure.Data | chk_day, chk_week, chk_month |
| Find_Line_Savings_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | related_row | CATEGORY_ID, PRODUCTION_TYPE |
| Find_MaterialData_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | related_row | CATEGORY_ID |
| GetOperation | Filter | MASTER_ID, INSTANCE_ID, DIVISION_ID, SITE_ID, AMEND_MAIN_FLAG |
| InitControls | Filter | USER_ID |
| onNLFAmendMenu | frm.Filter | MASTER_ID, FP_PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onNLFAmendMenu | Filter | INSTANCE_ID, PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onZeroBucketMenu | row_to_test | CATEGORY_ID |
| onZeroMaterialMenu | row_to_test | CATEGORY_ID |
| OpenLineMemo | frm.Filter | MEMO_TYPE |
| OpenMaterialMemo | frm.Filter | MEMO_TYPE |
| Query | rCate | SEGMENT1, ATTRIBUTE2 |
| SetDivision | Filter | INSTANCE_ID |
| SetFactory | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| SetLine | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, USER_LT |
| setMeasualFormData | dtCategory.Rows[i] | MEA_ID, MEA_VALUE |
| SetNickNameLT | Filter | BUCKET_FROM, BUCKET_TO, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, PROD_TYPE, ITEM_ID |
| SetOperation | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, AMEND_MAIN_FLAG |
| SetPlanGroup | dtInstance.Rows[0] | CONFIRM_AREA |
| SetPlanPeriod | Filter | INSTANCE_ID |
| SetPlanPeriod | dtPeriod.Rows[0] | START_DATE, END_DATE |
| SetPlant | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID |
| SetProdType | Filter | DIVISION_ID |
| SetSite | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID |
| SetTotalColor | row | DATA_TYPE |
| spdMain_CellClick | row | LINE_ID, PRODUCTION_TYPE, DATA_TYPE |
| SwitchMemo | r | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET |
| SwitchMemo | memoRow | ITEM_ID |
| SwitchMemo | memo[k] | ITEM_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:186, InitControl:260, CheckAndGetMeasure:1110, RefreshSpreadSheet:2678 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| SetFilter | InitControls:279, InitControls:280, InitControls:281, InitControls:282, InitControls:290, UIFindData:441, ApplySearchCondition:789, ApplySearchCondition:797 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetCheckedListValue | InitControls:290, UIFindData:441, ApplySearchCondition:789, ApplySearchCondition:799, cbo_plan_group_changed:1290, mcbo_division_changed:1306, cbo_site_changed:1317, mcbo_plant_changed:1323 | CString.GetCheckedListValue | CODE |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:1082 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| SetRowsUnVisible | CreateFilterDataSet:1085 | MeasureService.SetRowsUnVisible | _MM_ |
| FP_Log2 | cbo_plan_group_changed:1288, cbo_plan_group_changed:1300 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| LoadAmendColumn | DrawHeader:2794 | MeasureService.LoadAmendColumn | DAYTAG, MONTHTAG, WEEKTAG |
| ApplyMemoTextLine | Query:2839 | MemoService.ApplyMemoTextLine | ATTR2, CATEGORY_ID, COMPANY_ID, DATA_TYPE, DIVISION_ID, ELECTRODE_TYPE, EQUIPMENT_ID, FACTORY_ID, ITEM_ID, LINE_ID, MARKET, MEMO, OPERATION_ID, PLANT_ID, PLAN_DATE, PRODUCTION_TYPE, TOP_ITEM_ID |
| EditQuery | Query:2840 | FPExtensions.EditQuery | ROW_ID |
| ApplyMemoTagLine | Query:2842 | MemoService.ApplyMemoTagLine | CATEGORY_ID, COMPANY_ID, DATA_TYPE, DIVISION_ID, ELECTRODE_TYPE, FACTORY_ID, ITEM_ID, LINE_ID, MARKET, OPERATION_ID, PLANT_ID, PLAN_DATE, PRODUCTION_TYPE, TOP_ITEM_ID |
| SetTotalColor | DrawSheet:2865 | SpreadInfo.SetTotalColor | column_cnt, grouping_cnt, row_idx |
| ShowMemoLine | DrawSheet:2874 | MemoService.ShowMemoLine | ATTR1, ATTR2, ATTRIBUTE10, ATTRIBUTE2, COLOR_A, COLOR_B, DATA_TYPE, Default, ELECTRODE_TYPE, EQUIPMENT_ID, INSTANCE_ID, ITEM_ID, PRODUCTION_TYPE, SEGMENT1, UI_COLOR, UI_DESC, UI_PARAM, chk_day |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnSet | Click | btnSet_Click | InitializeComponent:400 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:439 |
| this | Load | MeasureSetForm_Load | InitializeComponent:510 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:511 |
| this | Load | Form_Load | .ctor:197 |
| cbo_plan_group | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:249 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:251 |
| cbo_site | SelectedIndexChanged | cbo_site_changed | InitEvent:252 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:253 |
| mcbo_factory | SelectedIndexChanged | mcbo_factory_changed | InitEvent:254 |
| mcbo_operation | SelectedIndexChanged | mcbo_operation_changed | InitEvent:255 |
| mcbo_line | SelectedIndexChanged | mcbo_line_changed | InitEvent:256 |
| txtItem | TextChanged | TxtItem_TextChanged | InitEvent:258 |
| mcbo_prod_type | SelectedIndexChanged | mcbo_prod_type_changed | InitEvent:259 |
| mcbo_nickname_lt | SelectedIndexChanged | mcbo_nickname_lt_changed | InitEvent:260 |
| dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitEvent:261 |
| chk_allLine | CheckedChanged | chk_allLine_CheckedChanged | InitEvent:263 |
| chk_IncludeSubOp | CheckedChanged | chk_IncludeSubOp_CheckedChanged | InitEvent:264 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1716 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick:1951 |
| this.chk_IncludeSubOp | CheckedChanged | chk_IncludeSubOp_CheckedChanged | InitializeComponent:515 |
| this.txtNickName | TextChanged | txtNickName_TextChanged | InitializeComponent:585 |
| this.chkInAct | CheckedChanged | chkInAct_CheckedChanged | InitializeComponent:624 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:664 |
| this.dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitializeComponent:717 |
| this.chk_allLine | CheckedChanged | chk_allLine_CheckedChanged | InitializeComponent:833 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1501 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1502 |
| this.btnBucket | Click | btnBucket_Click | InitializeComponent:1674 |
| this.btnCatagory | Click | btnCatagory_Click | InitializeComponent:1712 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:1750 |
| this.usrButton1 | Click | btnPlanInfo_Click | InitializeComponent:1804 |
| this.usrButton3 | Click | btnMemo_Click | InitializeComponent:1842 |

## 6. 컨트롤 (95개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| CheckBox | 24 | chk_result_out, chk_seq, chk_offtime, chk_result_in, chk_memo, chk_outqty, chk_inqty, chk_mpp_outqty, chk_mpp_inqty, chk_wpp_outqty, chk_wpp_inqty, chk_result_out_tot, chk_subTotal, chk_total, chk_result_in_tot … |
| LayoutControlItem | 22 | layoutControlItem17, lblSql, layoutControlItem5, layoutControlItem7, layoutControlItem8, Operation, layoutControlItem10, layoutControlItem2, layoutControlItem11, layoutControlItem1, layoutControlItem6, layoutControlItem9, layoutControlItem14, layoutControlItem13, layoutControlItem16 … |
| UsrButton | 9 | btnSet, btnOK, btnSql, usrButton2, btnBucket, btnCatagory, btnColumn, usrButton1, usrButton3 |
| UsrCheckedList2 | 7 | mcbo_nickname_lt, mcbo_prod_type, mcbo_line, mcbo_operation, mcbo_factory, mcbo_plant, mcbo_division |
| Panel | 6 | panel1, panel3, panel2, panel2, panel4, panel1 |
| UsrLabel | 6 | usrLabel3, usrLabel2, usrLabel1, lblCylindrical, lblPouch, lblFullWashing |
| Label | 3 | label1, label2, label3 |
| UsrCheckBox | 3 | chk_IncludeSubOp, chkInAct, chk_allLine |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCombo | 2 | cbo_site, cbo_plan_group |
| UsrTextBox | 2 | txtNickName, txtItem |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePickerWtWeek | 1 | dCalendar_planrange |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| SplitContainer | 1 | splitter |
| ImageList | 1 | imageList1 |
| TextBox | 1 | tbLog |

## 7. 확인 필요 (3건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 2822 | Query | FP\{?default:part_service}\AmendMemo#list_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2823 | Query | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2824 | Query | FP\{?default:part_service}\PICAlarm#find_Category_Color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 25 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 11 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 22 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 644 | FP_Planning.PR_UI_FP00622_AMEND_LINE | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00617 | Amend | 17/4 | 17/4 | 17/4 | 17/4 | 17/4 | 17/4 | 17/4 | 17/4 | 17/4 | 17/4 | 17/4 | 17/4 | 17/4 | 17/4 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@DrawHeader:2743
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| spdMain_CellDoubleClick |  | 1911 | 표시/라벨 변경 | set:Visible | Visible = {?!spdMain.ActiveSheet.Columns[idx].Visible} |  | else!(!sHeadNameLevel2.Equals("Week Sum")) ⟫ for(idx < iWeekCount) |
| SetCalenderColor |  | 2944 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 2950 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| InitializeComponent |  | 1518 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1519 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1520 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1521 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
