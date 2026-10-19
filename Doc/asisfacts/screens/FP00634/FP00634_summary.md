# FP00634 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00634_Tray_Simulation.UIL\FP00634_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00634_Tray_Simulation.UIL\FP00634_Tray_Simulation.UIL.csproj | 426 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00634_Tray_Simulation.UIL\FP00634_MeasureSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00634_Tray_Simulation.UIL\FP00634_Tray_Simulation.UIL.csproj | 588 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00634_Tray_Simulation.UIL\FP00634_PlanInfoPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00634_Tray_Simulation.UIL\FP00634_Tray_Simulation.UIL.csproj | 331 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00634_Tray_Simulation.UIL\FP00634_PlanInfoPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00634_Tray_Simulation.UIL\FP00634_Tray_Simulation.UIL.csproj | 281 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00634_Tray_Simulation.UIL\FP00634_Tray_Simulation.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00634_Tray_Simulation.UIL\FP00634_Tray_Simulation.UIL.csproj | 2603 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00634_Tray_Simulation.UIL\FP00634_Tray_Simulation.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00634_Tray_Simulation.UIL\FP00634_Tray_Simulation.UIL.csproj | 1437 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00634_Tray_Simulation.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00634_Tray_Simulation.UIL\FP00634_Tray_Simulation.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed > GetBasisTime | 314 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBasisTime] | BIZ_MATCH |  |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed > GetBasisTime | 314 | FP\Common\PRAMEND_planamend#findBasisTime | MATCH | [sql] foxquery_sql\FP_Common_PRAMEND_planamend_findBasisTime.sql |
| event:cbo_fpplanid.SelectedIndexChanged | cbo_fpplanid_changed > GetDivision | 323 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > GetInstanceTime | 290 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPast] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > GetInstanceTime | 290 | FP\Planning\FP00634_Tray_Simulation#find_isPast | MATCH | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_find_isPast.sql |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > GetFpPlanId | 302 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findFpPlan_info] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > GetFpPlanId | 302 | FP\Planning\FP00634_Tray_Simulation#findFpPlan_info | MATCH | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_findFpPlan_info.sql |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > GetFpPlanId > GetBasisTime | 314 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBasisTime] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > GetFpPlanId > GetBasisTime | 314 | FP\Common\PRAMEND_planamend#findBasisTime | MATCH | [sql] foxquery_sql\FP_Common_PRAMEND_planamend_findBasisTime.sql |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > GetFpPlanId > GetDivision | 323 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > SetPlant | 2261 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:dp_plan_date.ValueChanged | planday_changed > GetFpPlanId | 302 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findFpPlan_info] | BIZ_MATCH |  |
| event:dp_plan_date.ValueChanged | planday_changed > GetFpPlanId | 302 | FP\Planning\FP00634_Tray_Simulation#findFpPlan_info | MATCH | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_findFpPlan_info.sql |
| event:dp_plan_date.ValueChanged | planday_changed > GetFpPlanId > GetBasisTime | 314 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBasisTime] | BIZ_MATCH |  |
| event:dp_plan_date.ValueChanged | planday_changed > GetFpPlanId > GetBasisTime | 314 | FP\Common\PRAMEND_planamend#findBasisTime | MATCH | [sql] foxquery_sql\FP_Common_PRAMEND_planamend_findBasisTime.sql |
| event:dp_plan_date.ValueChanged | planday_changed > GetFpPlanId > GetDivision | 323 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 270 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo_p] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 270 | FP\Planning\FP00634_Tray_Simulation#find_planInfo_p | MATCH | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_find_planInfo_p.sql |
| button:FindButton | FindButton > UIFindData | 725 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=chk_PlanId] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData | 725 | FP\Planning\FP00634_Tray_Simulation#chk_PlanId | MATCH | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_chk_PlanId.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1088 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1088 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1089 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1089 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1090 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1090 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1091 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1091 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplySearchCondition | 1137 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplySearchCondition | 1207 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetSite | 2250 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetProdType | 2300 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetOperation | 2289 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetLine | 2313 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetFactory | 2272 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1088 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1088 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1089 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1089 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1090 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1090 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1091 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1091 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplySearchCondition | 1137 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplySearchCondition | 1207 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.chk_all_line.CheckedChanged | chk_allLine_CheckedChanged > SetLine | 2313 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.chk_rel.CheckedChanged | chkInAct_CheckedChanged > GetFpPlanId | 302 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findFpPlan_info] | BIZ_MATCH |  |
| event:this.chk_rel.CheckedChanged | chkInAct_CheckedChanged > GetFpPlanId | 302 | FP\Planning\FP00634_Tray_Simulation#findFpPlan_info | MATCH | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_findFpPlan_info.sql |
| event:this.chk_rel.CheckedChanged | chkInAct_CheckedChanged > GetFpPlanId > GetBasisTime | 314 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBasisTime] | BIZ_MATCH |  |
| event:this.chk_rel.CheckedChanged | chkInAct_CheckedChanged > GetFpPlanId > GetBasisTime | 314 | FP\Common\PRAMEND_planamend#findBasisTime | MATCH | [sql] foxquery_sql\FP_Common_PRAMEND_planamend_findBasisTime.sql |
| event:this.chk_rel.CheckedChanged | chkInAct_CheckedChanged > GetFpPlanId > GetDivision | 323 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | MeasureSetForm_Load > InitControl | 199 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > FindData | 270 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo_p] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 270 | FP\Planning\FP00634_Tray_Simulation#find_planInfo_p | MATCH | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_find_planInfo_p.sql |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetInstance | 281 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList_common] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetInstance | 281 | FP\Planning\FP00634_Tray_Simulation#findInstanceList_common | MATCH | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_findInstanceList_common.sql |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetInstanceTime | 290 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPast] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetInstanceTime | 290 | FP\Planning\FP00634_Tray_Simulation#find_isPast | MATCH | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_find_isPast.sql |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetFpPlanId | 302 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findFpPlan_info] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetFpPlanId | 302 | FP\Planning\FP00634_Tray_Simulation#findFpPlan_info | MATCH | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_findFpPlan_info.sql |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetBasisTime | 314 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBasisTime] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetBasisTime | 314 | FP\Common\PRAMEND_planamend#findBasisTime | MATCH | [sql] foxquery_sql\FP_Common_PRAMEND_planamend_findBasisTime.sql |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetDivision | 323 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetSite | 330 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetPlant | 339 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetFactory | 347 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetOperation | 369 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findOperationCode_common] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetOperation | 369 | FP\Planning\FP00634_Tray_Simulation#findOperationCode_common | MATCH | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_findOperationCode_common.sql |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetLine | 436 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetLine | 436 | FP\Planning\FP00634_Tray_Simulation#findLineCode_List | MATCH | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_findLineCode_List.sql |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetModel | 467 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Model_List] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetModel | 467 | FP\Planning\FP00634_Tray_Simulation#find_Model_List | MATCH | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_find_Model_List.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 126 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetPlanGroup | 2224 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | SetDivision | 2241 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetPlanPeriod | 2343 | biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 2 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=chk_PlanId] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPast] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Model_List] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo_p] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBasisTime] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findFpPlan_info] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList_common] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findOperationCode_common] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 8 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\PRAMEND_planamend#findBasisTime | MATCH | 1 | [sql] foxquery_sql\FP_Common_PRAMEND_planamend_findBasisTime.sql | REF:FN_GET_BASISTIME |  |
| FP\Planning\FP00634_Tray_Simulation#chk_PlanId | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_chk_PlanId.sql | SELECT:FP_RELEASE_PLAN_INFO_H, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:SCM_FP_PLAN_H, REF:FN_SITE_TIME, SELECT:FP_INSTANCE_START_TIME_V, SELECT:FP_INSTANCE_FACTORY_M, SELECT:SCM_FACTORY_M |  |
| FP\Planning\FP00634_Tray_Simulation#find_isPast | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_find_isPast.sql | SELECT:TH_UIS_CALENDAR, SELECT:TH_UIS_CAL, REF:FN_SITE_TIME, SELECT:FP_INSTANCE_START_TIME_V, SELECT:FP_INSTANCE_FACTORY_M, SELECT:SCM_FACTORY_M |  |
| FP\Planning\FP00634_Tray_Simulation#find_Model_List | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_find_Model_List.sql | SELECT:FP_DAILY_PRODUCTIOIN_PLAN_HA, SELECT:SCM_DAILY_PRODUCT_RESULT_HA |  |
| FP\Planning\FP00634_Tray_Simulation#find_planInfo_p | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_find_planInfo_p.sql | SELECT:FP_RELEASE_PLAN_INFO_HA, SELECT:SCM_FP_PLAN_HA, SELECT:FORM_PLAN |  |
| FP\Planning\FP00634_Tray_Simulation#findFpPlan_info | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_findFpPlan_info.sql | SELECT:FP_RELEASE_PLAN_INFO_HB, SELECT:FP_RELEASE_PLAN_INFO_HA, SELECT:TH_UIS_CALENDAR, SELECT:TH_UIS_CALA, SELECT:SCM_FP_PLAN_HSA, SELECT:SCM_FP_PLAN_HA, SELECT:RELEASE_PLANC |  |
| FP\Planning\FP00634_Tray_Simulation#findInstanceList_common | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_findInstanceList_common.sql | SELECT:FP_USER_ROLE_INFO_V, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:SCM_FACTORY_M, SELECT:FP_INSTANCE_FACTORY_M, SELECT:FP_AMEND_UI_V |  |
| FP\Planning\FP00634_Tray_Simulation#findLineCode_List | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_findLineCode_List.sql | SELECT:SCM_LINE_MA, SELECT:FP_USER_ROLE_INFO_VB, SELECT:SCM_FACTORY_MA, SELECT:FP_INSTANCE_FACTORY_MB |  |
| FP\Planning\FP00634_Tray_Simulation#findOperationCode_common | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00634_Tray_Simulation_findOperationCode_common.sql | SELECT:FP_INSTANCE_OPERATION_VA, SELECT:FP_USER_ROLE_INFO_VB |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET |
| ApplySearchCondition | Filter | INSTANCE_ID, BUCKET_FROM, BUCKET_TO, TOP_ITEM_ID, DAY2WEEK, DAY2MONTH, CURR_DATE |
| ApplySearchCondition | dtWeekMonth.Rows[i] | W_COL, D_COL, M_COL |
| ApplySearchCondition | dtWeekMonth.Rows[i + 1] | W_COL, M_COL |
| ApplySearchCondition | dt.Rows[0] | CURR_DATE |
| btnBucket_Click | Application.OpenForms | FP00599_BucketSetForm_Popup |
| btnCatagory_Click | Application.OpenForms | FP00603_MeasureSetForm_Popup |
| btnColumn_Click | Application.OpenForms | FPC0097_ColumnSetForm_Popup |
| btnPlanInfo_Click | Filter | INSTANCE_ID, CONFIRM_AREA |
| btnPlanInfo_Click | Application.OpenForms | FP00634_PlanInfoPopup |
| btnPlanInfo_Click | planInfoPopup.Filter | MASTER_ID, INSTANCE_ID, CONFIRM_AREA, USER_ID |
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| cbo_fpplanid_changed | Filter | PLAN_ID, FP_PLAN_ID |
| cbo_plan_group_changed | Filter | INSTANCE_ID, IS_SAME_PLAN_ID, FACTORY_YN, CURR_DATE, PLAN_DATE, BUCKET_FROM, BUCKET_TO |
| cbo_plan_group_changed | dtInstance.Rows[cbo_plan_group.SelectedIndex] | IS_SAME_PLAN_ID, FACTORY_YN |
| cbo_plan_group_changed | dtPastInfo.Rows[0] | CURR_DATE, PLAN_START_DATE, PLAN_END_DATE |
| cbo_site_changed | Filter | SITE_ID |
| chk_allLine_CheckedChanged | Filter | ALL_LINE |
| chk_sub_op_CheckedChanged | Filter | AMEND_MAIN_FLAG |
| chkInAct_CheckedChanged | Filter | RELEASE_FLAG |
| CreateFilterDataSet | x | DEGAS_BEFORE_TYPE, CATEGORY_NAME, CATEGORY_ID, PSI |
| dCalendarPlanrange_changed | Filter | BUCKET_FROM, BUCKET_TO |
| FilterInstanceID | Filter | PLAN_ID, FP_PLAN_ID, BUCKET_FROM, BUCKET_TO, FP_SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, PLAN_NAME |
| FilterInstanceID | dtPlanId.Rows[idx] | DEFAULT_START_DATE, DEFAULT_END_DATE, PLAN_START_DATE, PLAN_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME |
| FindData | Filter | RELEASE_FLAG, CTRL_WHERE, CTRL_AND |
| FindMainData | Filter | RELEASE_FLAG, PLAN_TYPE, PLAN_ID, CHK_PLANID, DIVISION_ID, FACTORY_ID, PLANT_ID, BUCKET_FROM, LINE_ID, OPERATION_ID, BUCKET, DAY2WEEK, MONTH2WEEK, USER_ID, GROUP_TRAY_ID |
| FindMainData | bukInfo.Tables[0].Rows[0] | _TYPE, _DATE |
| FindMainData | bukInfo.Tables[0].Rows[i] | _TYPE, _DATE |
| GetBasisTime | Filter | BASIS_START_TIME |
| GetBasisTime | dtBaseTime.Rows[0] | BASIS_TIME |
| GetDivision | Filter | INSTANCE_ID |
| GetFactory | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PLAN_TYPE, CONFIRM_AREA, MASTER_ID, PLAN_ID |
| GetFpPlanId | Filter | PLAN_DATE, CTRL_INSTANCE_DATE, CTRL_START_TIME, INSTANCE_ID, CTRL_INSTANCE |
| GetLine | Filter2 | LINE_ID, INSTANCE_ID, CTRL_INSTANCE, CTRL_PLAN_TYPE, PLAN_TYPE, CONFIRM_AREA, MASTER_ID, PLAN_ID, ALL_LINE |
| GetModel | Filter | AMEND_TABLE, AMEND_CUTOFF_BOH_TABLE, AMEND_BOR_TABLE, AMEND_SALES_TABLE, AMEND_UTIL_TABLE, PLAN_TYPE |
| GetOperation | Filter | AMEND_MAIN_FLAG, CTRL_AMEND |
| GetPlant | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID |
| GetSite | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID |
| GoEditMode | row | DATA_TYPE, DEGAS_BEFORE_TYPE, CATEGORY_NAME, CATEGORY_ID |
| InitControls | Filter | AMEND_INSTANCE, CTRL_SITE_ID, SITE_ID, MASTER_ID |
| InitSpread | Filter | CONFIRM_AREA |
| lfn_setActivated | row | CELL_CNT, LOAD_YIELD, PKG_CAPA, DIVISION_ID, GROUP_TRAY_ID, TRAY_FACTORY_ID, TRAY_ID, ITEM_ID, LINE_ID |
| lfn_setActivated | x | TRAY_ID, ITEM_ID, LINE_ID, GROUP_TRAY_ID, TRAY_FACTORY_ID, CATEGORY_ID |
| lfn_setInventory | row | CELL_CNT, DEGAS_BEFORE_TYPE, BOH_QTY, BOH_INT, BOH_HOLD, GROUP_IDX, GROUP_CNT, LOAD_YIELD, PKG_CAPA, DIVISION_ID, BOH_SUM, BOH_INT_SUM |
| lfn_setInventory | x | DIVISION_ID, GROUP_IDX, CATEGORY_ID |
| mcbo_division_changed | Filter | DIVISION_ID |
| mcbo_factory_changed | Filter | FACTORY_ID |
| mcbo_line_changed | Filter | LINE_ID |
| mcbo_operation_changed | Filter | OPERATION_ID |
| mcbo_plant_changed | Filter | PLANT_ID |
| planday_changed | Filter | PLAN_DATE |
| RefreshHeader | Filter | FACTORY_YN |
| RefreshHeaderOnly | Filter | FACTORY_YN |
| SetBohQty | row | DATA_TYPE, OPERATION_ID, BOH_QTY, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohQty | each_row | _TYPE, OPERATION_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohQty | result.First() | QTY |
| SetChangeControl | Filter | USER_ID, INSTANCE_ID, FACTORY_YN, CURR_DATE, PLAN_DATE, BUCKET_FROM, BUCKET_TO, DIVISION_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, SITE_ID |
| SetChangeControl | dtInstance.Rows[cbo_plan_group.SelectedIndex] | FACTORY_YN |
| SetChangeControl | dtPastInfo.Rows[0] | CURR_DATE, PLAN_START_DATE, PLAN_END_DATE |
| SetDivision | Filter | INSTANCE_ID, DIVISION_ID |
| SetFactory | Filter | INSTANCE_ID, PLAN_ID, PLAN_TYPE, CONFIRM_AREA, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID |
| SetLine | Filter | INSTANCE_ID, PLAN_ID, PLAN_TYPE, CONFIRM_AREA, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, USER_LT, LINE_ID |
| setMeasualFormData | dtCategory.Rows[i] | MEA_ID, MEA_VALUE |
| SetOperation | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, AMEND_MAIN_FLAG, OPERATION_ID |
| SetPlanDate | Filter | PLAN_DATE |
| SetPlanGroup | Filter | INSTANCE_ID, CONFIRM_AREA, FACTORY_YN |
| SetPlanGroup | dtInstance.Rows[0] | CONFIRM_AREA |
| SetPlanGroup | dtInstance.Rows[cbo_plan_group.SelectedIndex] | FACTORY_YN |
| SetPlanPeriod | Filter | INSTANCE_ID |
| SetPlanPeriod | dtPeriod.Rows[0] | START_DATE, END_DATE |
| SetPlant | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| SetProdType | Filter | INSATNCE_ID, DIVISION_ID |
| SetSite | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID |
| spdMain_Change | row | LOAD_YIELD, CELL_CNT |
| TxtModel_TextChanged | Filter | TOP_ITEM_ID |
| UIFindData | Filter | CHK_PLANID, DIVISION_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:190, InitControl:266 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| GetCheckedListValue | FilterInstanceID:484, SetChangeControl:561, SetChangeControl:581, SetChangeControl:586, SetChangeControl:589, SetChangeControl:592, SetChangeControl:595, SetChangeControl:603 | CString.GetCheckedListValue | CODE |
| FP_Log2 | cbo_plan_group_changed:1889, cbo_plan_group_changed:1906 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnSet | Click | btnSet_Click | InitializeComponent:479 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:517 |
| this | Load | MeasureSetForm_Load | InitializeComponent:534 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:535 |
| this | Load | Form_Load | .ctor:120 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:136 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:191 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:192 |
| this | Load | Form_Load | .ctor:184 |
| cbo_plan_group | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:237 |
| cbo_fpplanid | SelectedIndexChanged | cbo_fpplanid_changed | InitEvent:238 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:239 |
| cbo_site | SelectedIndexChanged | cbo_site_changed | InitEvent:240 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:241 |
| mcbo_factory | SelectedIndexChanged | mcbo_factory_changed | InitEvent:242 |
| mcbo_operation | SelectedIndexChanged | mcbo_operation_changed | InitEvent:243 |
| mcbo_line | SelectedIndexChanged | mcbo_line_changed | InitEvent:244 |
| txt_group_id | TextChanged | TxtModel_TextChanged | InitEvent:246 |
| dp_plan_date | ValueChanged | planday_changed | InitEvent:248 |
| rp_plan_period | ValueChanged | dCalendarPlanrange_changed | InitEvent:249 |
| popSql | OnSql | RunSqlSource | btnSql_Click:2181 |
| this.chk_sub_op | CheckedChanged | chk_sub_op_CheckedChanged | InitializeComponent:222 |
| this.chk_rel | CheckedChanged | chkInAct_CheckedChanged | InitializeComponent:383 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:423 |
| this.chk_all_line | CheckedChanged | chk_allLine_CheckedChanged | InitializeComponent:547 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:1121 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:1122 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1123 |
| this.btnPlanInfo | Click | btnPlanInfo_Click | InitializeComponent:1267 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:1317 |

## 6. 컨트롤 (88개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| CheckBox | 24 | chk_gap, chk_cut, chk_memo, chk_offtime, chk_result, chk_outqty, chk_inqty, chk_mpp_outqty, chk_mpp_inqty, chk_wpp_outqty, chk_wpp_inqty, chk_cell, chk_uom, chk_wpp_outqty_tot, chk_wpp_inqty_tot … |
| LayoutControlItem | 16 | layoutControlItem2, layoutControlItem17, lblSql, layoutControlItem5, layoutControlItem7, layoutControlItem8, Operation, layoutControlItem10, layoutControlItem2, layoutControlItem11, layoutControlItem12, layoutControlItem1, layoutControlItem6, lclDate, lciPlanId … |
| UsrButton | 7 | btnSet, btnOK, btnClose, btnSql, usrButton2, btnPlanInfo, btnColumn |
| Panel | 6 | panel1, panel2, panel3, panel2, panel4, panel1 |
| UsrCheckedList2 | 5 | mcbo_line, mcbo_operation, mcbo_factory, mcbo_plant, mcbo_division |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| Label | 3 | label1, label4, label2 |
| UsrCheckBox | 3 | chk_sub_op, chk_rel, chk_all_line |
| UsrCombo | 3 | cbo_fpplanid, cbo_site, cbo_plan_group |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| ImageList | 2 | imageList1, imageList1 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| EmptySpaceItem | 1 | emptySpaceItem1 |
| UsrDatePicker2 | 1 | dp_plan_date |
| UsrDateRangePicker2 | 1 | rp_plan_period |
| UsrTextBox | 1 | txt_group_id |
| SplitContainer | 1 | splitter |

## 7. 확인 필요 (4건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1088 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1089 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1090 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1091 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 28 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 5 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 20 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 893 | FP_Planning.PR_UI_FP00622_AMEND_LINE | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00634 | Main | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |
| SCM_MST_SHEET_COLUMNS | FP00634 | PlanInfoPopup | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: PlanInfoPopup, Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:165, SetSheetHeaderColumn_FP@RefreshHeaderOnly:662
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 168 | 표시/라벨 변경 | SetColumnHeader | 0 |  | if(Filter["CONFIRM_AREA"].ToString() != "BUILDING") |
| InitializeComponent |  | 208 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 209 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 210 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 211 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| spdMain_CellDoubleClick |  | 2204 | 표시/라벨 변경 | set:Visible | Visible = {?!spdMain.ActiveSheet.Columns[idx].Visible} |  | for(idx < iWeekCount) |
| InitializeComponent |  | 1139 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1140 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1141 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1142 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 |
| PlanInfoPopup | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
