# FP00612 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00612_PlanBy_Line_Pack.UIL\FP00612_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00612_PlanBy_Line_Pack.UIL\FP00612_PlanBy_Line_Pack.UIL.csproj | 353 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00612_PlanBy_Line_Pack.UIL\FP00612_MeasureSetForm_Popup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00612_PlanBy_Line_Pack.UIL\FP00612_PlanBy_Line_Pack.UIL.csproj | 519 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00612_PlanBy_Line_Pack.UIL\FP00612_PlanBy_Line_Pack.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00612_PlanBy_Line_Pack.UIL\FP00612_PlanBy_Line_Pack.UIL.csproj | 2833 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00612_PlanBy_Line_Pack.UIL\FP00612_PlanBy_Line_Pack.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00612_PlanBy_Line_Pack.UIL\FP00612_PlanBy_Line_Pack.UIL.csproj | 1758 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00612_PlanBy_Line_Pack.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00612_PlanBy_Line_Pack.UIL\FP00612_PlanBy_Line_Pack.UIL.csproj | 37 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP00612_PlanBy_Line_Pack.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 149 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP00612_PlanBy_Line_Pack.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 1768 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00612_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 312 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00612_MeasureSetForm_Popup.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 454 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_plan_group.SelectedIndexChanged | cboInstance_changed > SetChangeControl | 346 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cboInstance_changed > SetChangeControl | 346 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cbo_plan_group.SelectedIndexChanged | cboInstance_changed > GetPlanPeriod | 1870 | biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH |  |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 346 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetChangeControl | 346 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:chk_inActive.CheckedChanged | chk_inActive_CheckedChanged > SetChangeControl | 346 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:chk_inActive.CheckedChanged | chk_inActive_CheckedChanged > SetChangeControl | 346 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbDivision.SelectedIndexChanged | clbDivision_changed > SetChangeControl | 346 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | clbDivision_changed > SetChangeControl | 346 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbFactory.SelectedIndexChanged | clbFactory_changed > SetChangeControl | 346 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | clbFactory_changed > SetChangeControl | 346 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbLine.SelectedIndexChanged | clbLine_changed > SetChangeControl | 346 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | clbLine_changed > SetChangeControl | 346 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbOperation.SelectedIndexChanged | clbOperation_changed > SetChangeControl | 346 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | clbOperation_changed > SetChangeControl | 346 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | clbPlant_changed > SetChangeControl | 346 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | clbPlant_changed > SetChangeControl | 346 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | clbPlant_changed | 2419 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | clbPlant_changed | 2419 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbProdType.SelectedIndexChanged | clbProdType_changed > SetChangeControl | 346 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbProdType.SelectedIndexChanged | clbProdType_changed > SetChangeControl | 346 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbSite.SelectedIndexChanged | clbSite_changed > SetChangeControl | 346 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | clbSite_changed > SetChangeControl | 346 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:drpPeriod.ValueChanged | drpPeriod_changed | 2475 | biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 486 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 486 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 487 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 487 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 488 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 488 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2046 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2046 | FP\Common\AmendCommon#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_WeekCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2047 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2047 | FP\Common\AmendCommon#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_DateMap.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2048 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2048 | FP\Common\AmendCommon#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_MonthCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2049 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2049 | FP\Common\AmendCommon#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_BukInfo.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > SetChangeControl | 346 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > SetChangeControl | 346 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 486 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 486 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 487 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 487 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 488 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 488 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2046 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2046 | FP\Common\AmendCommon#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_WeekCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2047 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2047 | FP\Common\AmendCommon#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_DateMap.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2048 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2048 | FP\Common\AmendCommon#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_MonthCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2049 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2049 | FP\Common\AmendCommon#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_BukInfo.sql |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 486 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 486 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 487 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 487 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 488 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 488 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2046 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2046 | FP\Common\AmendCommon#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_WeekCnt.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2047 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2047 | FP\Common\AmendCommon#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_DateMap.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2048 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2048 | FP\Common\AmendCommon#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_MonthCnt.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2049 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2049 | FP\Common\AmendCommon#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_BukInfo.sql |
| event:this.btn_category.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 486 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 486 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btn_category.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 487 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 487 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btn_category.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 488 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 488 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2046 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2046 | FP\Common\AmendCommon#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_WeekCnt.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2047 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2047 | FP\Common\AmendCommon#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_DateMap.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2048 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2048 | FP\Common\AmendCommon#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_MonthCnt.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2049 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2049 | FP\Common\AmendCommon#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendCommon_find_BukInfo.sql |
| event:this.btn_column.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 486 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 486 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btn_column.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 487 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 487 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btn_column.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 488 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 488 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.Load | Form_Load > InitControls | 220 | biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > clbProdType_changed > SetChangeControl | 346 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > clbProdType_changed > SetChangeControl | 346 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 486 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 486 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 487 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 487 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 488 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 488 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.Load | Form_Load > InitControls > cboInstance_changed > GetPlanPeriod | 1870 | biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > clbPlant_changed | 2419 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > clbPlant_changed | 2419 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > SetChangeControl | 346 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > SetChangeControl | 346 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 486 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 486 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 487 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 487 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 488 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenMaterialMemo > RefreshSpreadSheet > RefreshHeader > Query | 488 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 87 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 2 |  |  |  |
| FP\Common\AmendCommon#find_BukInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendCommon_find_BukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\AmendCommon#find_DateMap | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendCommon_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\AmendCommon#find_MonthCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendCommon_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\AmendCommon#find_WeekCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendCommon_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\AmendMemo#list_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 2 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\PICAlarm#find_Category | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | MONTH_INFO, BUCKET, WEEK_INFO, CATE_INFO, DAY2_WEEK_MONTH, CURR_DATE_COL |
| ApplySearchCondition | Filter | BUCKET_FROM, BUCKET_TO, MASTER_ID, INSTANCE_ID |
| btnMemo_Click | Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID |
| btnMemo_Click | memoPopup.Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, MODEL_ID, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID, USER_ID |
| btnPlanInfo_Click | Filter | MASTER_ID, INSTANCE_ID, CONFIRM_AREA |
| btnPlanInfo_Click | planInfoPopup.Filter | MASTER_ID, INSTANCE_ID, CONFIRM_AREA, USER_ID |
| CheckAndGetMeasure | measure.Data | chk_week, chk_day, chk_month |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_inqty, chk_outqty, chk_mpp_inqty, chk_mpp_outqty, chk_wpp_inqty, chk_wpp_outqty, chk_result, chk_resultExp, chk_gap, chk_gapWPP, chk_memo, chk_offtime, chk_total, chk_wpp_inqty_tot, chk_wpp_outqty_tot, chk_mpp_inqty_tot, chk_mpp_outqty_tot, chk_inqty_tot, chk_outqty_tot, chk_result_tot, chk_resultExp_tot, chk_gap_tot, chk_gapWPP_tot, chk_subTotal, chk_memo_tot |
| CreateFilterDataSet | x | _MM_ |
| drpPeriod_changed | Filter | INSTANCE_ID |
| drpPeriod_changed | dtPeriod_Plan.Rows[0] | START_DATE, END_DATE |
| GetBasisTime | dtPeriod.Rows[0] | BASIS_TIME |
| GetPlanGroup | Filter | USER_ID, MASTER_ID, INSTANCE_ID, USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| GetPlanGroup | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| GetPlanPeriod | Filter | INSTANCE_ID, BUCKET_FROM, BUCKET_TO |
| GetPlanPeriod | dtPlanPeriod.Rows[0] | START_DATE, END_DATE |
| InitControls | Filter | USER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO |
| InitControls | dtPlanPeriod.Rows[0] | START_DATE, END_DATE |
| OpenLineMemo | frm.Filter | MEMO_TYPE |
| OpenMaterialMemo | frm.Filter | MEMO_TYPE |
| Query | rCate | SEGMENT1, ATTRIBUTE2 |
| RefreshHeader | row | DATA_TYPE |
| SetChangeControl | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| SetChangeControl | Filter | MASTER_ID, INSTANCE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, PROD_TYPE |
| spdMain_CellClick | row | LINE_ID, PRODUCTION_TYPE, DATA_TYPE |
| SwitchMemo | r | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET |
| SwitchMemo | memoRow | ITEM_ID |
| SwitchMemo | memo[k] | ITEM_ID |
| tbNickName_OnSearchConditionChanged | Filter | NICK_NAME, NICK_NAME_LT |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:176, InitControl:251, CheckAndGetMeasure:461 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| SetFilter | InitControls:195, InitControls:196, InitControls:197, InitControls:198, GetBasisTime:243, SetChangeControl:317, SetChangeControl:318, SetChangeControl:319 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetInnerTable | SetChangeControl:312, SetChangeControl:322, SetChangeControl:330, SetChangeControl:338, SetChangeControl:346, SetChangeControl:355, SetChangeControl:363, GetPlanGroup:1848 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| GetCheckedListValue | SetChangeControl:316, SetChangeControl:329, SetChangeControl:337, SetChangeControl:345, SetChangeControl:354, SetChangeControl:362, SetChangeControl:370, SetChangeControl:374 | CString.GetCheckedListValue | CODE |
| ApplyMemoTextLine | Query:503 | MemoService.ApplyMemoTextLine | ATTR2, CATEGORY_ID, COMPANY_ID, DATA_TYPE, DIVISION_ID, ELECTRODE_TYPE, EQUIPMENT_ID, FACTORY_ID, ITEM_ID, LINE_ID, MARKET, MEMO, OPERATION_ID, PLANT_ID, PLAN_DATE, PRODUCTION_TYPE, TOP_ITEM_ID |
| ApplyMemoTagLine | Query:506 | MemoService.ApplyMemoTagLine | CATEGORY_ID, COMPANY_ID, DATA_TYPE, DIVISION_ID, ELECTRODE_TYPE, FACTORY_ID, ITEM_ID, LINE_ID, MARKET, OPERATION_ID, PLANT_ID, PLAN_DATE, PRODUCTION_TYPE, TOP_ITEM_ID |
| ShowMemoLine | RefreshHeader:591 | MemoService.ShowMemoLine | ATTR1, ATTR2, ATTRIBUTE10, ATTRIBUTE2, COLOR_A, COLOR_B, DATA_TYPE, Default, ELECTRODE_TYPE, EQUIPMENT_ID, INSTANCE_ID, ITEM_ID, PRODUCTION_TYPE, SEGMENT1, UI_COLOR, UI_DESC, UI_PARAM, chk_day |
| SetRowVisibleOnMeasureDatatypeCategory | CreateFilterDataSet:1762 | MeasureService.SetRowVisibleOnMeasureDatatypeCategory | CATEGORY_ID, DATA_TYPE, MEASURE_ID, _MM_ |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:1763 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| GetProdType | GetProdType:1880, clbPlant_changed:2420 | DataService.GetProdType | CODE, DIVISION_ID, NAME |
| FP_Log2 | cboInstance_changed:2396, cboInstance_changed:2400 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:396 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:434 |
| this | Load | MeasureSetForm_Load | InitializeComponent:469 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:470 |
| this | Load | Form_Load | .ctor:141 |
| cbo_plan_group | SelectedIndexChanged | cboInstance_changed | InitEvent:392 |
| clbDivision | SelectedIndexChanged | clbDivision_changed | InitEvent:393 |
| clbSite | SelectedIndexChanged | clbSite_changed | InitEvent:394 |
| clbPlant | SelectedIndexChanged | clbPlant_changed | InitEvent:395 |
| clbFactory | SelectedIndexChanged | clbFactory_changed | InitEvent:396 |
| clbOperation | SelectedIndexChanged | clbOperation_changed | InitEvent:397 |
| clbLine | SelectedIndexChanged | clbLine_changed | InitEvent:398 |
| edt_pjtGroup | TextChanged | edt_pjtGroup_TextChanged | InitEvent:400 |
| edt_topItem | TextChanged | edt_topItem_TextChanged | InitEvent:401 |
| edt_item | TextChanged | edt_item_TextChanged | InitEvent:402 |
| tbNickName | BeforeOpenSearch | tbNickName_BeforeOpenSearch | InitEvent:403 |
| tbNickName | OnSearchConditionChanged | tbNickName_OnSearchConditionChanged | InitEvent:404 |
| clbProdType | SelectedIndexChanged | clbProdType_changed | InitEvent:406 |
| drpPeriod | ValueChanged | drpPeriod_changed | InitEvent:408 |
| chk_allLine | CheckedChanged | chk_allLine_CheckedChanged | InitEvent:410 |
| chk_inActive | CheckedChanged | chk_inActive_CheckedChanged | InitEvent:411 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1603 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick:2380 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:860 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:1134 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:1135 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:1136 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:1137 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:1138 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:1139 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1140 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1141 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:1142 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1143 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:1144 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:1145 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:1146 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:1147 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:1148 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:1149 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:1150 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:1151 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:1152 |
| this.btnMemo | Click | btnMemo_Click | InitializeComponent:1317 |
| this.btnPlanInfo | Click | btnPlanInfo_Click | InitializeComponent:1355 |
| this.btn_bucket | Click | btnBucket_Click | InitializeComponent:1393 |
| this.btn_category | Click | btnCatagory_Click | InitializeComponent:1431 |
| this.btn_column | Click | btnColumn_Click | InitializeComponent:1469 |

## 6. 컨트롤 (94개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| CheckBox | 25 | chk_gapWPP, chk_offtime, chk_result, chk_gap, chk_memo, chk_outqty, chk_inqty, chk_mpp_outqty, chk_mpp_inqty, chk_wpp_outqty, chk_wpp_inqty, chk_gapWPP_tot, chk_memo_tot, chk_gap_tot, chk_subTotal … |
| LayoutControlItem | 16 | lblSql, layoutControlItem19, layoutControlItem30, layoutControlItem7, layoutControlItem15, layoutControlItem9, layoutControlItem14, layoutControlItem12, layoutControlItem3, layoutControlItem11, layoutControlItem29, layoutControlItem21, layoutControlItem17, layoutControlItem8, layoutControlItem6 … |
| UsrButton | 9 | usrButton1, usrButton2, btnSql, usrButton2, btnMemo, btnPlanInfo, btn_bucket, btn_category, btn_column |
| UsrCheckedList2 | 7 | clbLine, clbDivision, clbProdType, clbOperation, clbFactory, clbPlant, clbSite |
| EmptySpaceItem | 6 | emptySpaceItem4, emptySpaceItem5, emptySpaceItem2, emptySpaceItem6, emptySpaceItem3, emptySpaceItem1 |
| Panel | 5 | panel1, panel3, panel2, panel4, panel1 |
| Label | 3 | label1, label2, label1 |
| UsrTextBox | 3 | edt_pjtGroup, edt_item, edt_topItem |
| FpSpread | 3 | spdMain, spdEdit, spdInfo |
| SheetView | 3 | spdMain_Sheet1, spdEdit_Sheet1, spdInfo_Sheet1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCheckBox | 2 | chk_inActive, chk_allLine |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrPopupTextBox | 1 | tbNickName |
| UsrCombo | 1 | cbo_plan_group |
| UsrDateRangePickerWtWeek | 1 | drpPeriod |
| SplitContainer | 1 | splitter |
| TextBox | 1 | tbLog |
| DataGridView | 1 | dgEdit |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (7건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 486 | Query | FP\{?default:part_service}\AmendMemo#list_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2046 | ApplyAmendCalendarCondition | FP\{?default:part_service}\AmendCommon#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2047 | ApplyAmendCalendarCondition | FP\{?default:part_service}\AmendCommon#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2048 | ApplyAmendCalendarCondition | FP\{?default:part_service}\AmendCommon#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2049 | ApplyAmendCalendarCondition | FP\{?default:part_service}\AmendCommon#find_bukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 487 | Query | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 488 | Query | FP\{?default:part_service}\PICAlarm#find_Category_Color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 23 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 8 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 96 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 11 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 1639 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00612 | Amend | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@RefreshHeaderOnly:704
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| RefreshHeader |  | 651 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| RefreshHeader |  | 657 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| ExportExcelSimple |  | 937 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ else!(RemoveActionCell == true && i == 0 && newSheet.Columns[i].DataField.ToUpper() == "ACTION") ⟫ else!(RemoveInvisibleCell && newSheet.Columns[i].Width <= 0) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| ExportExcelSimple |  | 1017 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| spdMain_CellDoubleClick |  | 2333 | 표시/라벨 변경 | set:Visible | Visible = {?!spdMain.ActiveSheet.Columns[idx].Visible} |  | else!(!sHeadNameLevel2.Equals("Week Sum")) ⟫ for(idx < iWeekCount) |
| InitializeComponent |  | 1168 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1169 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1170 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1171 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1513 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1514 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1515 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1516 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1564 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1565 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1566 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1567 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
