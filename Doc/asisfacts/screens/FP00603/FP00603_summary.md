# FP00603 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00603_PlanByModel_Assy.UIL\FP00603_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00603_PlanByModel_Assy.UIL\FP00603_PlanByModel_Assy.UIL.csproj | 467 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00603_PlanByModel_Assy.UIL\FP00603_MeasureSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00603_PlanByModel_Assy.UIL\FP00603_PlanByModel_Assy.UIL.csproj | 646 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00603_PlanByModel_Assy.UIL\FP00603_PlanByModel_Assy.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00603_PlanByModel_Assy.UIL\FP00603_PlanByModel_Assy.UIL.csproj | 3701 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00603_PlanByModel_Assy.UIL\FP00603_PlanByModel_Assy.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00603_PlanByModel_Assy.UIL\FP00603_PlanByModel_Assy.UIL.csproj | 1623 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00603_PlanByModel_Assy.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00603_PlanByModel_Assy.UIL\FP00603_PlanByModel_Assy.UIL.csproj | 37 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP00603_PlanByModel_Assy.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 290 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP00603_PlanByModel_Assy.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 1654 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00603_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 426 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00603_MeasureSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 588 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl | 372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl | 372 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetPlanPeriod | 3303 | biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > SetChangeControl | 372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > SetChangeControl | 372 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 372 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clb_operation.SelectedIndexChanged | mcbo_operation_changed > SetChangeControl | 372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clb_operation.SelectedIndexChanged | mcbo_operation_changed > SetChangeControl | 372 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:dCalendar_planrange.ValueChanged | dCalendarPlanrange_changed | 2662 | biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 1218 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 1218 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 1219 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 1219 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 1220 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 1220 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1272 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1275 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1278 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1281 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1284 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 1348 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplySearchCondition | 1411 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetChangeControl | 372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetChangeControl | 372 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetChangeControl | 372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetChangeControl | 372 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_line.SelectedIndexChanged | mcbo_line_changed > SetChangeControl | 372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_line.SelectedIndexChanged | mcbo_line_changed > SetChangeControl | 372 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetChangeControl | 372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetChangeControl | 372 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed | 2592 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed | 2592 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_prodtype.SelectedIndexChanged | mcbo_prodtype_changed > SetChangeControl | 372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_prodtype.SelectedIndexChanged | mcbo_prodtype_changed > SetChangeControl | 372 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > SetChangeControl | 372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > SetChangeControl | 372 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 1218 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 1218 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 1219 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 1219 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 1220 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 1220 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition | 1272 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition | 1275 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition | 1278 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition | 1281 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplyAmendCalendarCondition | 1284 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplySearchCondition | 1348 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > ApplySearchCondition | 1411 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 1218 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 1218 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 1219 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 1219 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 1220 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 1220 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 1218 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 1218 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 1219 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 1219 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 1220 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnCatagory.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 1220 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1272 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1275 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1278 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1281 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 1284 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1348 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplySearchCondition | 1411 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnColumn.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 1218 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 1218 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 1219 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 1219 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 1220 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 1220 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 372 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.chkInAct.CheckedChanged | chkInAct_CheckedChanged > SetChangeControl | 372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.chkInAct.CheckedChanged | chkInAct_CheckedChanged > SetChangeControl | 372 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | MeasureSetForm_Load > InitControl | 204 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > mcbo_prodtype_changed > SetChangeControl | 372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > mcbo_prodtype_changed > SetChangeControl | 372 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 1218 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 1218 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 1219 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 1219 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 1220 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 1220 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.Load | Form_Load > InitControls > mcbo_plant_changed | 2592 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > mcbo_plant_changed | 2592 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > cbo_plan_group_changed > SetPlanPeriod | 3303 | biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > SetChangeControl | 372 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > SetChangeControl | 372 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 1218 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 1218 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 1219 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 1219 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 1220 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 1220 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 140 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 2 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 8 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP\Common\AmendMemo#list_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 2 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\PICAlarm#find_Category | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO |
| ApplyAmendCalendarCondition | row | MEA_ID, MEA_VALUE |
| ApplySearchCondition | Filter | BUCKET_FROM, BUCKET_TO, INSTANCE_ID |
| ApplySearchCondition | dtWeekMonth.Rows[i] | W_COL, D_COL, M_COL |
| ApplySearchCondition | dtWeekMonth.Rows[i+1] | W_COL, M_COL |
| ApplySearchCondition | dt.Rows[0] | CURR_DATE |
| btnBucket_Click | Application.OpenForms | FP00599_BucketSetForm_Popup |
| btnCatagory_Click | Application.OpenForms | FP00603_MeasureSetForm_Popup |
| btnColumn_Click | Application.OpenForms | FPC0097_ColumnSetForm_Popup |
| btnMemo_Click | Filter | INSTANCE_ID, BUCKET_FROM, BUCKET_TO, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID |
| btnMemo_Click | memoPopup.Filter | MASTER_ID, BUCKET_FROM, BUCKET_TO, MODEL_ID, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID, USER_ID |
| btnPlanInfo_Click | Filter | INSTANCE_ID, CONFIRM_AREA |
| btnPlanInfo_Click | Application.OpenForms | FPC0106_PlanInfoPopup |
| btnPlanInfo_Click | planInfoPopup.Filter | MASTER_ID, INSTANCE_ID, CONFIRM_AREA, USER_ID |
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| CheckAndGetMeasure | measure.Data | chk_week, chk_day, chk_month |
| CreateDataLine | material_column | P_IN, P_IN_CELL, P_OUT, P_OUT_CELL |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_wpp_inqty, chk_wpp_outqty, chk_result, chk_resultExp, chk_mpp_inqty, chk_mpp_outqty, chk_offtime, chk_inqty, chk_outqty, chk_memo, chk_gap, chk_cut, chk_gapWPP, chk_subTotal, chk_wpp_inqty_tot, chk_wpp_outqty_tot, chk_gap_tot, chk_mpp_inqty_tot, chk_mpp_outqty_tot, chk_cut_tot, chk_inqty_tot, chk_outqty_tot, chk_result_tot, chk_resultExp_tot, chk_gapWPP_tot, chk_total, chk_uom, chk_cell |
| CreateFilterDataSet | x | _MM_ |
| dCalendarPlanrange_changed | Filter | INSTANCE_ID |
| dCalendarPlanrange_changed | dtPeriod_Plan.Rows[0] | START_DATE, END_DATE |
| Find_Line_Savings_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | related_row | CATEGORY_ID, PRODUCTION_TYPE |
| Find_MaterialData_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | related_row | CATEGORY_ID |
| GetPlanGroup | Filter | USER_ID, MASTER_ID, INSTANCE_ID, USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| GetPlanGroup | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| GoEditMode | Filter | PLAN_TYPE |
| GoEditMode | row | DATA_TYPE, MEASURE_ID, CATEGORY_ID, EDIT_YN |
| InitColumn | row | CATEGORY_ID |
| InitControls | Filter | USER_ID |
| onNLFAmendMenu | frm.Filter | MASTER_ID, FP_PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onNLFAmendMenu | Filter | INSTANCE_ID, PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onZeroBucketMenu | row_to_test | CATEGORY_ID |
| onZeroMaterialMenu | row_to_test | CATEGORY_ID |
| OpenLineMemo | frm.Filter | MEMO_TYPE |
| OpenMaterialMemo | frm.Filter | MEMO_TYPE |
| Query | rCate | SEGMENT1, ATTRIBUTE2 |
| RefreshHeader | row | DATA_TYPE |
| SetBohQty | row | DATA_TYPE, OPERATION_ID, BOH_QTY, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohQty | each_row | _TYPE, OPERATION_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohQty | result.First() | QTY |
| SetChangeControl | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| SetChangeControl | Filter | MASTER_ID, INSTANCE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, PROD_TYPE, PRODTYPE_ID |
| SetColumnChangeByMemo | dsResult.Tables[0].Rows[k] | DATA_TYPE, CATEGORY_ID |
| SetInitMemo | row | CATEGORY_ID |
| setMeasualFormData | dtCategory.Rows[i] | MEA_ID, MEA_VALUE |
| SetPlanPeriod | Filter | INSTANCE_ID |
| SetPlanPeriod | dtPeriod.Rows[0] | START_DATE, END_DATE |
| spdMain_CellClick | row | LINE_ID, PRODUCTION_TYPE, DATA_TYPE |
| SwitchMemo | r | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET |
| SwitchMemo | memoRow | ITEM_ID |
| SwitchMemo | memo[k] | ITEM_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:195, InitControl:277, RefreshSpreadSheet:1493, CheckAndGetMeasure:2048 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| SetFilter | InitControls:257, InitControls:258, InitControls:259, InitControls:260, InitControls:276, SetChangeControl:343, SetChangeControl:344, SetChangeControl:345 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetCheckedListValue | InitControls:276, SetChangeControl:342, SetChangeControl:355, SetChangeControl:363, SetChangeControl:371, SetChangeControl:380, SetChangeControl:388, SetChangeControl:396 | CString.GetCheckedListValue | CODE |
| GetInnerTable | SetChangeControl:338, SetChangeControl:348, SetChangeControl:356, SetChangeControl:364, SetChangeControl:372, SetChangeControl:381, SetChangeControl:389, GetPlanGroup:3263 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:2024 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| SetRowsUnVisible | CreateFilterDataSet:2027 | MeasureService.SetRowsUnVisible | _MM_ |
| FP_Log2 | cbo_plan_group_changed:2569, cbo_plan_group_changed:2572 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetProdType | SetProdType:3285 | DataService.GetProdType | CODE, DIVISION_ID, NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnSet | Click | btnSet_Click | InitializeComponent:533 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:571 |
| this | Load | MeasureSetForm_Load | InitializeComponent:588 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:589 |
| this | Load | Form_Load | .ctor:198 |
| cbo_plan_group | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:421 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:423 |
| cbo_site | SelectedIndexChanged | cbo_site_changed | InitEvent:424 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:425 |
| mcbo_factory | SelectedIndexChanged | mcbo_factory_changed | InitEvent:426 |
| clb_operation | SelectedIndexChanged | mcbo_operation_changed | InitEvent:427 |
| mcbo_line | SelectedIndexChanged | mcbo_line_changed | InitEvent:428 |
| txtModel | TextChanged | TxtModel_TextChanged | InitEvent:431 |
| txtItem | TextChanged | TxtItem_TextChanged | InitEvent:432 |
| mcbo_prodtype | SelectedIndexChanged | mcbo_prodtype_changed | InitEvent:433 |
| dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitEvent:435 |
| chk_allLine | CheckedChanged | chk_allLine_CheckedChanged | InitEvent:437 |
| popSql | OnSql | RunSqlSource | btnSql_Click:2879 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick:3686 |
| this.txtNickName | TextChanged | txtNickName_TextChanged | InitializeComponent:262 |
| this.txtPjtGroupName | TextChanged | txtPjtGroupName_TextChanged | InitializeComponent:297 |
| this.chkInAct | CheckedChanged | chkInAct_CheckedChanged | InitializeComponent:336 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:376 |
| this.chk_allLine | CheckedChanged | chk_allLine_CheckedChanged | InitializeComponent:578 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1175 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1176 |
| this.btnBucket | Click | btnBucket_Click | InitializeComponent:1348 |
| this.btnCatagory | Click | btnCatagory_Click | InitializeComponent:1386 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:1424 |
| this.btnPlanInfo | Click | btnPlanInfo_Click | InitializeComponent:1478 |
| this.btnMemo | Click | btnMemo_Click | InitializeComponent:1516 |

## 6. 컨트롤 (87개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| CheckBox | 28 | chk_resultExp, chk_gapWPP, chk_gap, chk_cut, chk_memo, chk_offtime, chk_result, chk_outqty, chk_inqty, chk_mpp_outqty, chk_mpp_inqty, chk_wpp_outqty, chk_wpp_inqty, chk_cell, chk_uom … |
| LayoutControlItem | 16 | layoutControlItem17, lblSql, layoutControlItem5, layoutControlItem7, layoutControlItem8, Operation, layoutControlItem10, layoutControlItem2, layoutControlItem11, layoutControlItem12, layoutControlItem14, layoutControlItem1, layoutControlItem3, layoutControlItem4, layoutControlItem16 … |
| UsrButton | 9 | btnSet, btnOK, btnSql, usrButton2, btnBucket, btnCatagory, btnColumn, btnPlanInfo, btnMemo |
| Panel | 6 | panel1, panel2, panel3, panel2, panel4, panel1 |
| UsrCheckedList2 | 6 | mcbo_prodtype, mcbo_line, clb_operation, mcbo_factory, mcbo_plant, mcbo_division |
| UsrTextBox | 4 | txtNickName, txtPjtGroupName, txtItem, txtModel |
| Label | 3 | label1, label4, label2 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCombo | 2 | cbo_site, cbo_plan_group |
| UsrCheckBox | 2 | chkInAct, chk_allLine |
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
| 1218 | Query | FP\{?default:part_service}\AmendMemo#list_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1219 | Query | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1220 | Query | FP\{?default:part_service}\PICAlarm#find_Category_Color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 24 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 34 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 15 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 11 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 379 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00603 | Amend | 20/1 | 20/1 | 20/1 | 20/1 | 20/1 | 20/1 | 20/1 | 20/1 | 20/1 | 20/1 | 20/1 | 20/1 | 20/1 | 20/1 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@RefreshHeaderOnly:486
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| ExportExcelSimple |  | 845 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ else!(RemoveActionCell == true && i == 0 && newSheet.Columns[i].DataField.ToUpper() == "ACTION") ⟫ else!(RemoveInvisibleCell && newSheet.Columns[i].Width <= 0) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| ExportExcelSimple |  | 925 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| RefreshHeader |  | 1706 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| RefreshHeader |  | 1712 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| spdMain_CellDoubleClick |  | 2927 | 표시/라벨 변경 | set:Visible | Visible = {?!spdMain.ActiveSheet.Columns[idx].Visible} |  | else!(!sHeadNameLevel2.Equals("Week Sum")) ⟫ for(idx < iWeekCount) |
| InitializeComponent |  | 1192 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1193 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1194 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1195 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
