# FP00600 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00600_PlanAmend_Model_Pack.UIL\FP00600_PlanAmend_Model_Pack.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00600_PlanAmend_Model_Pack.UIL\FP00600_PlanAmend_Model_Pack.UIL.csproj | 5496 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00600_PlanAmend_Model_Pack.UIL\FP00600_PlanAmend_Model_Pack.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00600_PlanAmend_Model_Pack.UIL\FP00600_PlanAmend_Model_Pack.UIL.csproj | 2462 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00600_PlanAmend_Model_Pack.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00600_PlanAmend_Model_Pack.UIL\FP00600_PlanAmend_Model_Pack.UIL.csproj | 37 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00600_BucketSetForm_Popup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 256 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00600_BucketSetForm_Popup.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 192 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00600_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 342 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00600_MeasureSetForm_Popup.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 452 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP00600_PlanAmend_Model_Pack.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 5748 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP00600_PlanAmend_Model_Pack.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 2462 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboInstance.SelectedIndexChanged | cbo_plan_group_changed > GetDivision | 1962 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cboPlanId.SelectedIndexChanged | cboPlanId_changed > GetFactory | 2063 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | mcbo_site_changed > GetPlant | 2054 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | mcbo_division_changed > GetSite | 2047 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | mcbo_plant_changed > GetFactory | 2063 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 630 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 630 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 631 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 631 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 665 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 665 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 666 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 666 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetPlanGroup | 2018 | biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2279 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2279 | FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2280 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2280 | FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2281 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2281 | FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2282 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2282 | FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 630 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 630 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 631 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 631 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 665 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 665 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 666 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:memo_menu.Click | onMemoMenu > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 666 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2279 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2279 | FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2280 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2280 | FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2281 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2281 | FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2282 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2282 | FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 630 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 630 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 631 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 631 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 665 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 665 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 666 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 666 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetPlanGroup | 2018 | biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2279 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2279 | FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2280 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2280 | FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2281 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2281 | FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2282 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2282 | FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 630 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 630 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 631 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 631 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 665 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 665 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnBucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 666 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > RefreshHeaderOnly > RefreshHeader > Query | 666 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindTotalValue > GetPlanGroup | 2018 | biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2279 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2279 | FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2280 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2280 | FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2281 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2281 | FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2282 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2282 | FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql |
| event:this.btnCategory.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 630 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnCategory.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 630 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnCategory.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 631 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnCategory.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 631 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnCategory.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 665 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnCategory.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 665 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnCategory.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 666 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnCategory.Click | btnCatagory_Click > RefreshHeaderOnly > RefreshHeader > Query | 666 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindTotalValue > GetPlanGroup | 2018 | biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | BIZ_MATCH |  |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2279 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2279 | FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2280 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2280 | FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2281 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2281 | FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2282 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2282 | FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 630 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 630 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 631 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 631 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 665 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 665 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnColumn.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 666 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnColumn.Click | btnColumn_Click > RefreshHeaderOnly > RefreshHeader > Query | 666 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 630 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 630 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 631 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 631 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 665 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 665 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 666 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 666 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > FindTotalValue > GetPlanGroup | 2018 | biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2279 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2279 | FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2280 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2280 | FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2281 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2281 | FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2282 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2282 | FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql |
| event:this.btnCreatePlan.Click | btnCreatePlan_Click | 4956 | FP_Master.PR_UI_FP00600_ETC | NOT_IN_FOXQUERY |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 630 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 630 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 631 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 631 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 665 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 665 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 666 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > RefreshSpreadSheet > RefreshHeader > Query | 666 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindTotalValue > GetPlanGroup | 2018 | biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2279 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2279 | FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2280 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2280 | FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2281 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2281 | FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2282 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2282 | FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql |
| event:this.btnMrp.Click | btnMRP_Click | 4908 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| event:this.btnMrp.Click | btnMRP_Click | 4908 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| event:this.btnMrp.Click | btnMRP_Click | 4933 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH |  |
| event:this.btnMrp.Click | btnMRP_Click | 4933 | FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql |
| event:this.btnRelease.Click | btnRelease_Click | 5045 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| event:this.btnRelease.Click | btnRelease_Click | 5045 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| event:this.btnRelease.Click | btnRelease_Click | 5083 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instanceInfo] | BIZ_MATCH |  |
| event:this.btnRelease.Click | btnRelease_Click | 5083 | FP\Common\XpCommonAmend#find_instanceInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_instanceInfo.sql |
| event:this.btnRelease.Click | btnRelease_Click | 5084 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo] | BIZ_MATCH |  |
| event:this.btnRelease.Click | btnRelease_Click | 5084 | FP\Common\XpCommonAmend#find_planInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_planInfo.sql |
| event:this.btnRelease.Click | btnRelease_Click | 5097 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease.Click | btnRelease_Click | 5121 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease.Click | btnRelease_Click | 5124 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 189 | biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 308 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 321 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 327 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 333 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 630 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 630 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 631 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 631 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 665 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 665 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 666 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > Query | 666 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 630 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 630 | FP\Common\AmendMemo#list_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 631 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 631 | FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 665 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 665 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 666 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SwitchMemo > OpenAlarmMemo > RefreshSpreadSheet > RefreshHeader > Query | 666 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 83 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2531 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2531 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2552 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_ExcelImport] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2552 | FP\Common\FP00601_Excel_Import#merge_ExcelImport | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2572 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul_2] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2572 | FP\Common\FP00600_PlanAmend#execute_psiCalcul_2 | MATCH_PATTERN | SP PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_A |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2572 | biz:AppService.GeneralRunProcedureCustomTable [procedure=execute_psiCalcul_2] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2572 | FP00600_PlanAmend#execute_psiCalcul_2 | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2582 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2582 | FP\Common\FP00600_PlanAmend#execute_psiCalcul | MATCH_PATTERN | SP PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_B |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2582 | biz:AppService.GeneralRunProcedureCustomTable [procedure=execute_psiCalcul] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2582 | FP00600_PlanAmend#execute_psiCalcul | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2723 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2723 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2744 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_ExcelImport] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2744 | FP\Common\FP00601_Excel_Import#merge_ExcelImport | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2763 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul_2] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2763 | FP\Common\FP00600_PlanAmend#execute_psiCalcul_2 | MATCH_PATTERN | SP PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_A |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2763 | biz:AppService.GeneralRunProcedureCustomTable [procedure=execute_psiCalcul_2] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2763 | FP00600_PlanAmend#execute_psiCalcul_2 | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2773 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2773 | FP\Common\FP00600_PlanAmend#execute_psiCalcul | MATCH_PATTERN | SP PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_B |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2773 | biz:AppService.GeneralRunProcedureCustomTable [procedure=execute_psiCalcul] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2773 | FP00600_PlanAmend#execute_psiCalcul | NOT_IN_FOXQUERY |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=execute_psiCalcul_2] | BIZ_MATCH | 2 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=execute_psiCalcul] | BIZ_MATCH | 2 |  |  |  |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 2 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instanceInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul_2] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_ExcelImport] | BIZ_MATCH | 2 |  |  |  |
| FP_Master.PR_UI_FP00600_ETC | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 3 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP\Common\AmendMemo#list_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\AmendMemo#list_setup_color_code | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_list_setup_color_code.sql | SELECT:FP_AMEND_MEMO_M, SELECT:FP_AMEND_SETUP_COLOR_M |  |
| FP\Common\FP00600_PlanAmend#execute_psiCalcul | MATCH_PATTERN | 2 | SP PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_B | EXEC:PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_B | ⚠ DB에 SP 없음 |
| FP\Common\FP00600_PlanAmend#execute_psiCalcul_2 | MATCH_PATTERN | 2 | SP PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_A | EXEC:PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_A | ⚠ DB에 SP 없음 |
| FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00601_Excel_Import#merge_ExcelImport | MATCH_PATTERN | 2 | [update-batch]  |  |  |
| FP\Common\PICAlarm#find_Category | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\XpCommonAmend#find_instanceInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_instanceInfo.sql | SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_INSTANCE_FACTORY_M, SELECT:SCM_FACTORY_M |  |
| FP\Common\XpCommonAmend#find_planInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_planInfo.sql | SELECT:SCM_FP_PLAN_H |  |
| FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql | SELECT:FP_USER_ROLE_INFO_V |  |
| FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql | UPDATE:SCM_FP_PLAN_H |  |
| FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql | SELECT:FP_PLAN_STATUS_H, SELECT:SCM_FP_PLAN_DETAIL_H, SELECT:SCM_FP_PLAN_GROUP_DETAIL_H, SELECT:FP_RELEASE_CALCULATION_STATUS_H |  |
| FP00600_PlanAmend#execute_psiCalcul | NOT_IN_FOXQUERY | 2 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP00600_PlanAmend#execute_psiCalcul_2 | NOT_IN_FOXQUERY | 2 |  |  | DB에도 없음 (폐기/오타 가능) |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | MONTH_INFO, BUCKET, WEEK_INFO, CATE_INFO |
| ApplySearchCondition | Filter | BUCKET_FROM, BUCKET_TO, PLAN_DATE, PLAN_ID, AMEND_TABLE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_SALES_TABLE, AMEND_UTIL_TABLE, PLAN_TYPE, RESULT_QTY, MASTER_ID, INSTANCE_ID |
| btnCreatePlan_Click | Filter | SITE_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, PLAN_ID |
| btnCreatePlan_Click | dtPlanRunFlag.Rows[0] | PLAN_ID, INSERT_ID |
| btnCreatePlan_Click | Application.OpenForms | FP00590_PlanTotalPopup |
| btnExcelImport_Click | Filter | PLAN_TYPE |
| btnExcelImport_Click | colPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID |
| btnExcelImport_Click | colPopup.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, NICK_NAME, ITEM_TYPE, OPERATION_ID, FACTORY_ID, LOCATION, MARKET, PRODUCTION_TYPE, LINE_ID, LINE_NAME, ELECTRODE_TYPE |
| btnExcelImport_Click | rowPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, PLAN_DATE, QTY |
| btnExcelImport_Click | rowPopup.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, NICK_NAME, ITEM_TYPE, OPERATION_ID, FACTORY_ID, LOCATION, MARKET, PRODUCTION_TYPE, LINE_ID, LINE_NAME, ELECTRODE_TYPE, PLAN_DATE, QTY, MESSAGE |
| btnMemo_Click | Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID |
| btnMemo_Click | memoPopup.Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, MODEL_ID, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID, USER_ID |
| btnMRP_Click | Filter | PLAN_ID, PLAN_TYPE, MASTER_ID, INSTANCE_ID |
| btnRelease_Click | Filter | SITE_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_ID, PLAN_DATE, DESCRIPTION |
| btnRelease_Click | dtPlanInfo.Rows[0] | DESCRIPTION, PLAN_TYPE |
| btnRelease_Click | dtEngineFlag.Rows[0] | INBOUND, ENGINE, OUTBOUND |
| btnRelease_Click | dtPlanRunFlag.Rows[0] | PLAN_ID, INSERT_ID |
| btnRelease_Click | dtParam2.Rows[0] | CONFIRM_AREA, IS_SAME_PLAN_ID, USE_WOW_STATUS |
| btnRelease_Click | Application.OpenForms | FP00590_GroupReleaseTotalPopup |
| call_Excel_Col_Save | checkSave.Tables[0].Rows[0] | _TYPE |
| call_Excel_Col_Save | popup.Filter | PLAN_TYPE |
| call_Excel_Col_Save | result.Rows[0] | RESULT |
| call_Excel_Col_Search | popup.Filter | PLAN_TYPE |
| call_Excel_Col_Validation | popup.Filter | PLAN_TYPE, MASTER_ID, PLAN_ID, COMPANY_ID |
| call_Excel_Col_Validation | pivotLine | INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, PLAN_DATE, QTY, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE, TOP_ITEM_ID, ITEM_TYPE |
| call_Excel_Col_Validation | row | DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, TOP_ITEM_ID, ITEM_TYPE |
| call_Excel_Col_Validation | Filter | PLAN_ID, INSTANCE_ID |
| call_Excel_Row_Save | popup.Filter | PLAN_TYPE |
| call_Excel_Row_Save | checkSave.Tables[0].Rows[0] | _TYPE |
| call_Excel_Row_Save | result.Rows[0] | RESULT |
| call_Excel_Row_Search | popup.Filter | PLAN_TYPE |
| call_Excel_Row_Validation | popup.Filter | PLAN_TYPE |
| call_Excel_Row_Validation | Filter | PLAN_ID, INSTANCE_ID |
| cbo_plan_group_changed | dtInstance.Rows[cboInstance.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| cboPlanId_changed | dtPlanId.Rows[selected] | PLAN_START_DATE, PLAN_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME, CODE, INSERT_ID, INSERT_Time, BASIC_VERSION, FACTORY_LT, UI_END_DATE |
| cboPlanId_changed | Filter | FP_PLAN_ID |
| CheckAndGetMeasure | measure.Data | chk_week, chk_day, chk_month |
| CreateDataLine | material_column | P_IN, P_OUT, BOH_2ND_ACTIVATED, BOH_2ND_EXPECT |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_sales, chk_ssp, chk_past_sales, chk_inqty, chk_outqty, chk_result, chk_mpp_inqty, chk_mpp_outqty, chk_wpp_inqty, chk_wpp_outqty, chk_inventory, chk_ssp_inventory, chk_do, chk_BOH_2nd, chk_activated, chk_sspSimul, chk_sspSimul_inventory, chk_memo, chk_total, chk_total_2 |
| CreateFilterDataSet | x | _MM_ |
| EditCommon | clicked_row | CATEGORY_ID |
| Find_Line_Savings_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | related_row | CATEGORY_ID, PRODUCTION_TYPE |
| Find_MaterialData_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | related_row | CATEGORY_ID |
| GetBasisTime | dtPeriod.Rows[0] | BASIS_TIME |
| GetDivision | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| GetFactory | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PLAN_TYPE, CONFIRM_AREA, MASTER_ID, PLAN_ID |
| GetFpPlandId | Filter | PLAN_ID, FP_PLAN_ID, PLAN_TYPE |
| GetFpPlandId | dtPlanId.Rows[0] | PLAN_ID, PLAN_TYPE |
| GetFpPlanId | Filter | PLAN_ID, FP_PLAN_ID, PLAN_TYPE, UI_END_DATE, BUCKET_FROM, BUCKET_TO |
| GetFpPlanId | dtPlanId.Rows[0] | PLAN_ID, PLAN_TYPE, UI_END_DATE, DESCRIPTION, INSERT_ID, INSERT_Time, BASIC_VERSION, FACTORY_LT, PLAN_START_DATE, PLAN_END_DATE |
| GetLine | Filter | ALL_LINE, LINE_ID |
| GetPlanGroup | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, AMEND_INSTANCE |
| GetPlanner | row | NAME, DEFAULT_CHECK |
| GetPlant | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| GetSite | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| GoEditMode | Filter | PLAN_TYPE |
| GoEditMode | row | DATA_TYPE, PSI, CATEGORY_ID, EDIT_YN |
| InitControls | Filter | USER_ID, INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, AMEND_INSTANCE, PLAN_DATE, MASTER_ID |
| InsertButton | row | TOP_ITEM_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| InsertButton | popup.Filter | DIVISION_ID, SITE_ID, PLANT_ID |
| MakeMemoBold | dsMainFiltered.Tables[0].Rows[i] | CATEGORY_ID |
| mcbo_planner_changed | row | DEFAULT_CHECK, CODE, NAME |
| onAlarmMenu | row | PRODUCTION_TYPE |
| onAlarmMenu | frm.Filter | MEMO_TYPE |
| onNLFAmendMenu | frm.Filter | MASTER_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onNLFAmendMenu | Filter | INSTANCE_ID, FP_PLAN_ID, PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onZeroBucketMenu | row_to_test | CATEGORY_ID, DATA_TYPE, ZERO_YN |
| onZeroMaterialMenu | row_to_test | CATEGORY_ID, DATA_TYPE, ZERO_YN |
| OpenAlarmMemo | row | PRODUCTION_TYPE |
| OpenAlarmMemo | frm.Filter | MEMO_TYPE |
| OpenLineMemo | frm.Filter | MEMO_TYPE |
| OpenMaterialMemo | frm.Filter | MEMO_TYPE |
| planday_changed | Filter | PLAN_DATE |
| Query | d | DIVISION_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, MARKET, PLAN_DATE, PRODUCTION_TYPE, SETUP_COLOR_CODE |
| Query | m | ATTR1 |
| Query | rCate | SEGMENT1, ATTRIBUTE2 |
| RefreshHeader | row | DATA_TYPE |
| Save_Data | Filter | INSTANCE_ID, FP_PLAN_ID, PLAN_ID, PLAN_TYPE, PLAN_DATE |
| Save_Data | enum_row_from_Saving | CATEGORY_ID, EQTY, EDATE, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Save_Data | x | INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, CATEGORY_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, PLAN_DATE, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Save_Data | selected | ORIG_OUT_QTY, IN_QTY, OUT_QTY, M, ORG_SALES_QTY, SALES_QTY |
| Save_Data | newrow | INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, COMPANY_ID, CATEGORY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, PLAN_DATE, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, IN_QTY, OUT_QTY, ORIG_IN_QTY, ORIG_OUT_QTY, M, SALES_QTY |
| Save_Data | BohSet | PLAN_DATE, MASTER_ID, PLAN_ID, AMEND_CUTOFF_BOH_TABLE |
| SetBohQty | row | DATA_TYPE, OPERATION_ID, BOH_QTY, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohQty | each_row | _TYPE, OPERATION_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohQty | result.First() | QTY |
| SetChangeControl | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PLAN_TYPE, CONFIRM_AREA, MASTER_ID, PLAN_ID |
| SetMemoCell | set | BUCKET_FROM, BUCKET_TO, MEMO |
| SetPlanOutCell | clicked_row | PLANT_ID, TOP_ITEM_ID, ITEM_ID, DIVISION_ID, SITE_ID, FACTORY_ID, OPERATION_ID, LINE_ID, CATEGORY_ID |
| SetPlanOutCell | row | PLANT_ID, TOP_ITEM_ID, OPERATION_ID, ITEM_ID, LINE_ID |
| SetPlanOutCell | ocvlt | ITEM_ID, KEEP_DAYS |
| SetShipmentOutCell | clicked_row | PLANT_ID, TOP_ITEM_ID, ITEM_ID, DIVISION_ID, SITE_ID, FACTORY_ID, OPERATION_ID, LINE_ID, CATEGORY_ID |
| SetShipmentOutCell | row | PLANT_ID, TOP_ITEM_ID |
| spdMain_CellClick | row | LINE_ID, PRODUCTION_TYPE, DATA_TYPE, FACTORY_ID |
| spdMain_CellClick | Filter | PLAN_TYPE |
| SwitchMemo | r | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET |
| SwitchMemo | memoRow | PRODUCTION_TYPE, ITEM_ID |
| SwitchMemo | memo[k] | ITEM_ID |
| SwitchMemo | materialRow | PRODUCTION_TYPE |
| tbNickName_OnSearchConditionChanged | Filter | NICK_NAME, NICK_NAME_LT |
| UIFindData | Filter | PLAN_ID, FP_PLAN_ID |
| UISaveData | Filter | PLAN_TYPE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetFilter | InitControls:182, InitControls:183, InitControls:184, InitControls:185, InitControls:205, InitControls:206, InitControls:221, GetBasisTime:288 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetCheckedListValue | InitControls:204, InitControls:221, SetChangeControl:311, SetChangeControl:318, SetChangeControl:324, SetChangeControl:330, SetChangeControl:339, SetChangeControl:344 | CString.GetCheckedListValue | CODE |
| GetMeasure | CheckAndGetMeasure:443, Measure:130, InitControl:152, Measure:167, InitControl:235 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| EditQuery | RefreshHeader:485, Query:682 | FPExtensions.EditQuery | ROW_ID |
| GetChanges | Save_Data:1303 | FPExtensions.GetChanges | ROW_ID |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:1803 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| SetRowsUnVisible | CreateFilterDataSet:1804 | MeasureService.SetRowsUnVisible | _MM_ |
| FP_UpdateBatch | call_Excel_Col_Save:2552, call_Excel_Row_Save:2744 | DataService.FP_UpdateBatch | COUNT, RESULT |
| FP_Log2 | cbo_plan_group_changed:4240, cbo_plan_group_changed:4261 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetProdType | mcbo_division_changed:4390 | DataService.GetProdType | CODE, DIVISION_ID, NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:116 |
| cboInstance | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:367 |
| clbPlanner | SelectedIndexChanged | mcbo_planner_changed | InitEvent:368 |
| drpPlanDate | DateTimeChanged | planday_changed | InitEvent:369 |
| cboPlanId | SelectedIndexChanged | cboPlanId_changed | InitEvent:370 |
| clbDivision | SelectedIndexChanged | mcbo_division_changed | InitEvent:371 |
| cboSite | SelectedIndexChanged | mcbo_site_changed | InitEvent:372 |
| clbPlant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:373 |
| clbFactory | SelectedIndexChanged | mcbo_factory_changed | InitEvent:374 |
| clbOperation | SelectedIndexChanged | mcbo_operation_changed | InitEvent:375 |
| clbLine | SelectedIndexChanged | mcbo_line_changed | InitEvent:376 |
| txtModel | TextChanged | edt_topItem_TextChanged | InitEvent:377 |
| txtItem | TextChanged | edt_item_TextChanged | InitEvent:378 |
| txtPjtGroup | TextChanged | edt_pjtGroup_TextChanged | InitEvent:379 |
| tbNickName | BeforeOpenSearch | tbNickName_BeforeOpenSearch | InitEvent:381 |
| tbNickName | OnSearchConditionChanged | tbNickName_OnSearchConditionChanged | InitEvent:382 |
| clbProdType | SelectedIndexChanged | mcbo_prodtype_changed | InitEvent:383 |
| drpPeriod | ValueChanged | dCalendar_changed | InitEvent:384 |
| chk_allLine | CheckedChanged | chk_allLine_CheckedChanged | InitEvent:385 |
| chk_info | CheckedChanged | chk_Info_CheckedChanged | InitEvent:386 |
| cboShipment | SelectedIndexChanged | cboShipment_changed | InitEvent:387 |
| dsdmAmend | Changed | SheetChanged | InitEvent:391 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1606 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick:4177 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick:4189 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick:4203 |
| this.btnToggleSave | Click | btnToggleSave_Click | InitializeComponent:354 |
| this.cboPlanId | DropDown | cboPlanId_DropDown | InitializeComponent:832 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:1118 |
| this.btnExcelImport | Click | btnExcelImport_Click | InitializeComponent:1158 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:1504 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:1505 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:1506 |
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:1507 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:1508 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:1509 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:1510 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:1511 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:1512 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1513 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1514 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:1515 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1516 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:1517 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:1518 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:1519 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:1520 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:1521 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:1522 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:1523 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:1524 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:1525 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:1526 |
| this.button1 | Click | button1_Click | InitializeComponent:1654 |
| this.btnMemo | Click | btnMemo_Click | InitializeComponent:1935 |
| this.btnMrp | Click | btnMRP_Click | InitializeComponent:1973 |
| this.btnRelease | Click | btnRelease_Click | InitializeComponent:2011 |
| this.btnCreatePlan | Click | btnCreatePlan_Click | InitializeComponent:2049 |
| this.btnBucket | Click | btnBucket_Click | InitializeComponent:2087 |
| this.btnCategory | Click | btnCatagory_Click | InitializeComponent:2125 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:2163 |
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:119 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:156 |
| this | Load | MeasureSetForm_Load | InitializeComponent:170 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:171 |
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:345 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:382 |
| this | Load | MeasureSetForm_Load | InitializeComponent:407 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:408 |

## 6. 컨트롤 (126개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| CheckBox | 23 | chk_month, chk_week, chk_day, chk_sspSimul_inventory, chk_sspSimul, chk_activated, chk_BOH_2nd, chk_ssp_inventory, chk_do, chk_inventory, chk_wpp_outqty, chk_wpp_inqty, chk_mpp_outqty, chk_mpp_inqty, chk_result … |
| LayoutControlItem | 22 | lblPlanner, lblPlanID, lblSql, lblInstance, lblData, lblDivision, lblOperation, lblItem, lblNickName, lblModel, layoutControlItem13, lblFactory, lblLine, lblSite, layoutControlItem12 … |
| UsrButton | 15 | btnToggleSave, btnSql, btnExcelImport, usrButton2, btnMemo, btnMrp, btnRelease, btnCreatePlan, btnBucket, btnCategory, btnColumn, usrButton1, usrButton2, usrButton1, usrButton2 |
| Label | 14 | label3, txtBuilding, txtBasic, txtDesc, txtCreation, txtCreator, label7, label6, label5, label4, label2, label1, label1, label2 |
| UsrCheckedList2 | 8 | clbLine, clbDivision, clbProdType, clbOperation, clbFactory, clbPlant, clbPlanner, cboSite |
| Panel | 8 | infoPanel, panel2, panel3, panel4, panel1, panel1, panel1, panel3 |
| EmptySpaceItem | 6 | emptySpaceItem4, emptySpaceItem2, emptySpaceItem1, emptySpaceItem6, emptySpaceItem5, emptySpaceItem3 |
| UsrCombo | 3 | cboShipment, cboInstance, cboPlanId |
| UsrTextBox | 3 | txtPjtGroup, txtItem, txtModel |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCheckBox | 2 | chk_info, chk_allLine |
| FpSpread | 2 | spdMain, spdEdit |
| SheetView | 2 | spdMain_Sheet1, spdEdit_Sheet1 |
| SplitContainer | 2 | splitter, splitContainer1 |
| UsrLabel | 2 | txtPlanId, usrLabel1 |
| DataGridView | 2 | dgEdit, dgShipment |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDatePicker2 | 1 | drpPlanDate |
| UsrPopupTextBox | 1 | tbNickName |
| UsrDateRangePicker2 | 1 | drpPeriod |
| Button | 1 | button1 |
| ImageList | 1 | imageList1 |
| GroupBox | 1 | groupBox1 |
| TextBox | 1 | tbLog |

## 7. 확인 필요 (26건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 4956 | btnCreatePlan_Click | FP_Master.PR_UI_FP00600_ETC | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 630 | Query | FP\{?default:part_service}\AmendMemo#list_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 631 | Query | FP\{?default:part_service}\AmendMemo#list_setup_color_code | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2279 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2280 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2281 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2282 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2531 | call_Excel_Col_Save | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2723 | call_Excel_Row_Save | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2572 | call_Excel_Col_Save | FP\{?default:part_service}\FP00600_PlanAmend#execute_psiCalcul_2 | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2582 | call_Excel_Col_Save | FP\{?default:part_service}\FP00600_PlanAmend#execute_psiCalcul | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2763 | call_Excel_Row_Save | FP\{?default:part_service}\FP00600_PlanAmend#execute_psiCalcul_2 | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2773 | call_Excel_Row_Save | FP\{?default:part_service}\FP00600_PlanAmend#execute_psiCalcul | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 4933 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2572 | call_Excel_Col_Save | FP00600_PlanAmend#execute_psiCalcul_2 | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) |
| 2582 | call_Excel_Col_Save | FP00600_PlanAmend#execute_psiCalcul | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) |
| 2763 | call_Excel_Row_Save | FP00600_PlanAmend#execute_psiCalcul_2 | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) |
| 2773 | call_Excel_Row_Save | FP00600_PlanAmend#execute_psiCalcul | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) |
| 665 | Query | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 666 | Query | FP\{?default:part_service}\PICAlarm#find_Category_Color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 4908 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5045 | btnRelease_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5083 | btnRelease_Click | FP\{?default:part_service}\XpCommonAmend#find_instanceInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5084 | btnRelease_Click | FP\{?default:part_service}\XpCommonAmend#find_planInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2552 | call_Excel_Col_Save | FP\{?default:part_service}\FP00601_EXCEL_IMPORT#merge_ExcelImport | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2744 | call_Excel_Row_Save | FP\{?default:part_service}\FP00601_EXCEL_IMPORT#merge_ExcelImport | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 49 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 12 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 5 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 7 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 78 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00600 | Amend | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 |
| SCM_MST_SHEET_COLUMNS | FP00600 | Main | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@RefreshHeaderOnly:744
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| RefreshHeader |  | 558 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| RefreshHeader |  | 564 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| spdMain_CellDoubleClick |  | 5277 | 표시/라벨 변경 | set:Visible | Visible = {?!spdMain.ActiveSheet.Columns[idx].Visible} |  | else!(!sHeadNameLevel2.Equals("Week Sum")) ⟫ for(idx < iWeekCount) |
| InitializeComponent |  | 1542 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1543 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1544 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1545 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2235 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2236 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2237 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2238 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |
| Main | 메타 정의만, 코드 미참조(미사용 가능) | 28 | 28 | 28 | 28 | 28 | 28 | 28 | 28 | 28 | 28 | 28 | 28 | 28 | 28 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
