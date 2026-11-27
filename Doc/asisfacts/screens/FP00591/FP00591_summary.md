# FP00591 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00591_Plan_Control_Integration.UIL\FP00591_fixOption_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00591_Plan_Control_Integration.UIL\FP00591_Plan_Control_Integration.UIL.csproj | 301 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00591_Plan_Control_Integration.UIL\FP00591_fixOption_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00591_Plan_Control_Integration.UIL\FP00591_Plan_Control_Integration.UIL.csproj | 371 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00591_Plan_Control_Integration.UIL\FP00591_Plan_Control_Integration.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00591_Plan_Control_Integration.UIL\FP00591_Plan_Control_Integration.UIL.csproj | 2538 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00591_Plan_Control_Integration.UIL\FP00591_Plan_Control_Integration.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00591_Plan_Control_Integration.UIL\FP00591_Plan_Control_Integration.UIL.csproj | 950 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00591_Plan_Control_Integration.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00591_Plan_Control_Integration.UIL\FP00591_Plan_Control_Integration.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged | 1214 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList] | BIZ_MATCH |  |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged | 1214 | FP\Planning\FP00591#findInstanceList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findInstanceList.sql |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged | 1219 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 313 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalInstanceList] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 313 | FP\Planning\FP00591#findTotalInstanceList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findTotalInstanceList.sql |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 319 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 319 | FP\Planning\FP00591#findInstanceList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findInstanceList.sql |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 324 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > FindData_Main | 592 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > FindData_Main | 615 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 615 | FP\Planning\FP00591#findInstanceList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findInstanceList.sql |
| button:FindButton | FindButton > FindData_Main > Find_Data_Main | 638 | FP_Planning.PR_UI_FP00591_PLAN_CONTROL_INTEGRATION | MATCH | SP PR_UI_FP00591_PLAN_CONTROL_INTEGRATION |
| button:FindButton | FindButton > FindData_Main > SetMainSheetControl > FindData_Sub > Find_Data_Sub | 826 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findEngineRun] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main > SetMainSheetControl > FindData_Sub > Find_Data_Sub | 826 | FP\Planning\FP00591#findEngineRun | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findEngineRun.sql |
| button:FindButton | FindButton > FindData_Main > SetMainSheetControl | 2377 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalPlanList] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main > SetMainSheetControl | 2377 | FP\Planning\FP00591#findTotalPlanList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findTotalPlanList.sql |
| button:FindButton | FindButton > FindData_Main > SetMainSheetControl | 2416 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanList] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main > SetMainSheetControl | 2416 | FP\Planning\FP00591#findPlanList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findPlanList.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Main | 638 | FP_Planning.PR_UI_FP00591_PLAN_CONTROL_INTEGRATION | MATCH | SP PR_UI_FP00591_PLAN_CONTROL_INTEGRATION |
| event:popSql.OnSql | RunSqlSource > Find_Data_Sub | 826 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findEngineRun] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Sub | 826 | FP\Planning\FP00591#findEngineRun | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findEngineRun.sql |
| event:this._DoEngineRunSelectEvent1 | DisplayEngineRunData > FindData_Sub > Find_Data_Sub | 826 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findEngineRun] | BIZ_MATCH |  |
| event:this._DoEngineRunSelectEvent1 | DisplayEngineRunData > FindData_Sub > Find_Data_Sub | 826 | FP\Planning\FP00591#findEngineRun | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findEngineRun.sql |
| event:this.btnFind.Click | btnFind_Click > FindData_Sub > Find_Data_Sub | 826 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findEngineRun] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData_Sub > Find_Data_Sub | 826 | FP\Planning\FP00591#findEngineRun | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findEngineRun.sql |
| event:this.dtpPlanDate.ValueChanged | dtpPlanDate_ValueChanged | 1191 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 251 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findSiteList] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 251 | FP\Planning\FP00591#findSiteList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findSiteList.sql |
| event:this.Load | Form_Load > InitControls | 259 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalInstanceList] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 259 | FP\Planning\FP00591#findTotalInstanceList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findTotalInstanceList.sql |
| event:this.Load | Form_Load > InitControls | 268 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 268 | FP\Planning\FP00591#findInstanceList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findInstanceList.sql |
| event:this.Load | Form_Load > InitControls | 270 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellClick | SpdMain_CellClick > Save_End_Action > FindData_Main | 592 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellClick | SpdMain_CellClick > Save_End_Action > FindData_Main | 615 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick > Save_End_Action > FindData_Main | 615 | FP\Planning\FP00591#findInstanceList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findInstanceList.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick > Save_End_Action > FindData_Main > Find_Data_Main | 638 | FP_Planning.PR_UI_FP00591_PLAN_CONTROL_INTEGRATION | MATCH | SP PR_UI_FP00591_PLAN_CONTROL_INTEGRATION |
| event:this.spdMain.CellClick | SpdMain_CellClick > Save_End_Action > FindData_Main > SetMainSheetControl > FindData_Sub > Find_Data_Sub | 826 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findEngineRun] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick > Save_End_Action > FindData_Main > SetMainSheetControl > FindData_Sub > Find_Data_Sub | 826 | FP\Planning\FP00591#findEngineRun | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findEngineRun.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick > Excute_Valid > ExcuteRunValidation | 928 | FP_Planning.PR_UI_FP00591_Plan_Control_Integration | MATCH | SP PR_UI_FP00591_PLAN_CONTROL_INTEGRATION |
| event:this.spdMain.CellClick | SpdMain_CellClick > Save_End_Action > Save_End_Action_Run | 1069 | FP_Planning.PR_UI_FP00591_Plan_Control_Integration | MATCH | SP PR_UI_FP00591_PLAN_CONTROL_INTEGRATION |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1618 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findIsRunningPlan] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1618 | FP\Planning\FP00591#findIsRunningPlan | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findIsRunningPlan.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1679 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1734 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1752 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1768 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1786 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1802 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1843 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=createPlan] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1843 | FP\Planning\FP00591#createPlan | MATCH | [update-batch]  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1846 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLatestPlan] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1846 | FP\Planning\FP00591#findLatestPlan | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findLatestPlan.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1857 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=updateClearStatus] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1857 | FP\Planning\FP00591#updateClearStatus | MATCH | [update-batch]  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1868 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=updateEngineRun] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1868 | FP\Planning\FP00591#updateEngineRun | MATCH | [update-batch]  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1873 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalPlanList] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1873 | FP\Planning\FP00591#findTotalPlanList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findTotalPlanList.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1902 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanList] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1902 | FP\Planning\FP00591#findPlanList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findPlanList.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick | 2046 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellClick | SpdMain_CellClick | 2070 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findRelease_isRecalculation] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 2070 | FP\Planning\FP00591#findRelease_isRecalculation | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findRelease_isRecalculation.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick > Save_End_Action > FindData_Main > SetMainSheetControl | 2377 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalPlanList] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick > Save_End_Action > FindData_Main > SetMainSheetControl | 2377 | FP\Planning\FP00591#findTotalPlanList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findTotalPlanList.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick > Save_End_Action > FindData_Main > SetMainSheetControl | 2416 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanList] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick > Save_End_Action > FindData_Main > SetMainSheetControl | 2416 | FP\Planning\FP00591#findPlanList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findPlanList.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick > GetStepValid | 2463 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick > Save_End_Action > FindData_Main | 592 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick > Save_End_Action > FindData_Main | 615 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick > Save_End_Action > FindData_Main | 615 | FP\Planning\FP00591#findInstanceList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findInstanceList.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick > Save_End_Action > FindData_Main > Find_Data_Main | 638 | FP_Planning.PR_UI_FP00591_PLAN_CONTROL_INTEGRATION | MATCH | SP PR_UI_FP00591_PLAN_CONTROL_INTEGRATION |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick > Save_End_Action > FindData_Main > SetMainSheetControl > FindData_Sub > Find_Data_Sub | 826 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findEngineRun] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick > Save_End_Action > FindData_Main > SetMainSheetControl > FindData_Sub > Find_Data_Sub | 826 | FP\Planning\FP00591#findEngineRun | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findEngineRun.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick > Excute_Valid > ExcuteRunValidation | 928 | FP_Planning.PR_UI_FP00591_Plan_Control_Integration | MATCH | SP PR_UI_FP00591_PLAN_CONTROL_INTEGRATION |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick > Save_End_Action > Save_End_Action_Run | 1069 | FP_Planning.PR_UI_FP00591_Plan_Control_Integration | MATCH | SP PR_UI_FP00591_PLAN_CONTROL_INTEGRATION |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1618 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findIsRunningPlan] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1618 | FP\Planning\FP00591#findIsRunningPlan | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findIsRunningPlan.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1679 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1734 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1752 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1768 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1786 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1802 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1843 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=createPlan] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1843 | FP\Planning\FP00591#createPlan | MATCH | [update-batch]  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1846 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLatestPlan] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1846 | FP\Planning\FP00591#findLatestPlan | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findLatestPlan.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1857 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=updateClearStatus] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1857 | FP\Planning\FP00591#updateClearStatus | MATCH | [update-batch]  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1868 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=updateEngineRun] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1868 | FP\Planning\FP00591#updateEngineRun | MATCH | [update-batch]  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1873 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalPlanList] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1873 | FP\Planning\FP00591#findTotalPlanList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findTotalPlanList.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1902 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanList] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 1902 | FP\Planning\FP00591#findPlanList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findPlanList.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 2046 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 2070 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findRelease_isRecalculation] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick | 2070 | FP\Planning\FP00591#findRelease_isRecalculation | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findRelease_isRecalculation.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick > Save_End_Action > FindData_Main > SetMainSheetControl | 2377 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalPlanList] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick > Save_End_Action > FindData_Main > SetMainSheetControl | 2377 | FP\Planning\FP00591#findTotalPlanList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findTotalPlanList.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick > Save_End_Action > FindData_Main > SetMainSheetControl | 2416 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanList] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick > Save_End_Action > FindData_Main > SetMainSheetControl | 2416 | FP\Planning\FP00591#findPlanList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findPlanList.sql |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > SpdMain_CellClick > GetStepValid | 2463 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.spdMain.ComboSelChange | SpdMain_ComboSelChange > FindData_Sub > Find_Data_Sub | 826 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findEngineRun] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | SpdMain_ComboSelChange > FindData_Sub > Find_Data_Sub | 826 | FP\Planning\FP00591#findEngineRun | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findEngineRun.sql |
| event:this.spdMain.ComboSelChange | SpdMain_ComboSelChange | 1437 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanList] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | SpdMain_ComboSelChange | 1437 | FP\Planning\FP00591#findPlanList | MATCH | [sql] foxquery_sql\FP_Planning_FP00591_findPlanList.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findEngineRun] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findIsRunningPlan] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLatestPlan] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanList] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findRelease_isRecalculation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findSiteList] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalInstanceList] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalPlanList] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=updateClearStatus] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=updateEngineRun] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=createPlan] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 13 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00591_Plan_Control_Integration | MATCH | 2 | SP PR_UI_FP00591_PLAN_CONTROL_INTEGRATION | EXEC:PR_UI_FP00591_PLAN_CONTROL_INTEGRATION | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00591_PLAN_CONTROL_INTEGRATION | MATCH | 1 | SP PR_UI_FP00591_PLAN_CONTROL_INTEGRATION | EXEC:PR_UI_FP00591_PLAN_CONTROL_INTEGRATION | ⚠ DB에 SP 없음 |
| FP\Planning\FP00591#createPlan | MATCH | 1 | [update-batch]  |  |  |
| FP\Planning\FP00591#findEngineRun | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00591_findEngineRun.sql | SELECT:FP_PLAN_STATUS_H, SELECT:_PLAN_INFO, SELECT:SCM_FP_PLAN_H |  |
| FP\Planning\FP00591#findInstanceList | MATCH | 4 | [sql] foxquery_sql\FP_Planning_FP00591_findInstanceList.sql | SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\Planning\FP00591#findIsRunningPlan | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00591_findIsRunningPlan.sql | SELECT:FP_PLAN_STATUS_H, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Planning\FP00591#findLatestPlan | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00591_findLatestPlan.sql | SELECT:SCM_FP_PLAN_H, SELECT:_INSTANCELIST, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Planning\FP00591#findPlanList | MATCH | 3 | [sql] foxquery_sql\FP_Planning_FP00591_findPlanList.sql | SELECT:SCM_FP_PLAN_H |  |
| FP\Planning\FP00591#findRelease_isRecalculation | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00591_findRelease_isRecalculation.sql | SELECT:SCM_FP_PLAN_H |  |
| FP\Planning\FP00591#findSiteList | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00591_findSiteList.sql | SELECT:SCM_SITE_M, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\Planning\FP00591#findTotalInstanceList | MATCH | 2 | [sql] foxquery_sql\FP_Planning_FP00591_findTotalInstanceList.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Planning\FP00591#findTotalPlanList | MATCH | 2 | [sql] foxquery_sql\FP_Planning_FP00591_findTotalPlanList.sql | SELECT:SCM_FP_PLAN_H |  |
| FP\Planning\FP00591#updateClearStatus | MATCH | 1 | [update-batch]  |  |  |
| FP\Planning\FP00591#updateEngineRun | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnPlanInfo_Click | Application.OpenForms | FP00590_PlanInfoPopup |
| btnRun_Click | dtDefaultDate.Rows[0] | LIMIT_DATE |
| CboPlanGroup_SelectedIndexChanged | Filter | SITE_ID, INTG_PLAN_ID |
| CboPlanGroup_SelectedIndexChanged | dtLocalPlanGroupDetail.Rows[0] | INSTANCE_ID |
| CboPlanGroup_SelectedIndexChanged | dt.Rows[0] | CURR_DATE |
| dtpPlanDate_ValueChanged | dtLocalPlanGroup.Rows[0] | INSTANCE_ID |
| dtpPlanDate_ValueChanged | dt.Rows[0] | CURR_DATE |
| Find_Data_Sub | Filter | INTG_PLAN_ID |
| FindData_Main | Filter | SITE_ID, INTG_PLAN_ID |
| FindData_Sub | ds.Tables[0].Rows[i] | STATUS_STEP |
| FindData_Sub | ds.Tables[0].Rows[0] | STATUS_FLAG |
| FindData_Sub | ds.Tables[0].Rows[1] | STATUS_FLAG |
| FindData_Sub | ds.Tables[0].Rows[2] | STATUS_FLAG |
| GetStepValid | dtStepValid.Rows[0] | CHECK_FLAG |
| InitControls | Filter | USER_ID, SITE_ID, INTG_PLAN_ID |
| InitControls | dtLocalPlanGroup.Rows[0] | INSTANCE_ID |
| MeasureSetForm_Load | Filter | PLAN_DATE, TOTAL_INSTANCE_ID |
| MeasureSetForm_Load | dtDefaultDate.Rows[0] | DEFAULT_DATE |
| SetChangedControl | Filter | SITE_ID, INTG_PLAN_ID |
| SetChangedControl | dtLocalPlanGroup.Rows[0] | INSTANCE_ID |
| SetInitMainSheetByRevision | dRow | PLAN_ID, SITE_ID, INSTANCE_ID, PLAN_TYPE, DESCRIPTION, INSERT_ID, INSERT_TIME, CONFIRM_ID, CONFIRM_TIME |
| SetInitMainSheetByRevision | dtResult.Rows[0] | INSERT_ID, DESCRIPTION, CONFIRM_ID, CONFIRM_TIME |
| SetMainSheetControl | Filter | INSTANCE_ID, PLAN_DATE, INTG_PLAN_ID |
| SetMainSheetControl | dr | CODE, NAME |
| SetMainSheetControl | dtRevision.Rows[0] | CODE |
| SetMainSheetControl | dtRevisionDetail.Rows[0] | CODE |
| SpdMain_CellClick | dtLocalPlanGroupDetail.Rows[0] | INSTANCE_ID |
| SpdMain_CellClick | dtPlanRunFlag.Rows[0] | CNT, PLAN_ID, INSERT_ID |
| SpdMain_CellClick | dtLocalPlanGroup.Rows[0] | CODE, NAME |
| SpdMain_CellClick | dtControl.Rows[0] | CREATE_PLAN_LIMIT_YN, CREATE_PLAN_FIX_DATE_YN, CREATE_PLAN_FIX_DATE, CREATE_PLAN_FIX_TYPE_YN, CREATE_PLAN_FIX_TYPE |
| SpdMain_CellClick | dr | CODE, INSTANCE_ID, PLAN_ID, NAME |
| SpdMain_CellClick | dtFormAging.Rows[0] | CNT |
| SpdMain_CellClick | dtLocalCurrDate.Rows[0] | CURR_DATE |
| SpdMain_CellClick | dtRefInfo.Rows[0] | IS_ENABLE |
| SpdMain_CellClick | dtSaveAuth.Rows[0] | CNT |
| SpdMain_CellClick | dtSave.Rows[0] | PLAN_DATE, USER_ID, TOTAL_INSTANCE_ID, FIX_TYPE, FIX_DATE, DESC_CELL, DESC_FORM, DESC_ELEC |
| SpdMain_CellClick | dtRevision.Rows[0] | CODE |
| SpdMain_CellClick | Filter | INTG_PLAN_ID, PLAN_DATE, _RECAL_INSTANCE_ID, _RECAL_PLAN_ID |
| SpdMain_CellClick | dtRevisionDetail.Rows[0] | CODE |
| SpdMain_CellClick | dtEngineFlag.Rows[0] | INBOUND, ENGINE, OUTBOUND |
| SpdMain_CellClick | dtisRecal.Rows[0] | _VALIDATION |
| SpdMain_CellClick | dtParam2.Rows[0] | CONFIRM_AREA, IS_SAME_PLAN_ID, USE_WOW_STATUS |
| SpdMain_CellClick | dRow | PLAN_ID, DESCRIPTION |
| SpdMain_CellClick | dtResult.Rows[0] | DESCRIPTION |
| SpdMain_CellClick | Application.OpenForms | FP00590_GroupReleaseTotalPopup, FP00590_ReleaseTotalPopup |
| SpdMain_ComboSelChange | Filter | INTG_PLAN_ID, PLAN_DATE |
| SpdMain_ComboSelChange | dr | CODE, NAME |
| SpdMain_ComboSelChange | dtRevisionDetail.Rows[0] | CODE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:254, SetChangedControl:310, SetChangedControl:317, FindData_Main:542, FindData_Main:543, FindData_Main:613, FindData_Main:614, btnFind_Click:1121 | CString.GetCheckedListValue | CODE |
| FP_UpdateBatch2 | SpdMain_CellClick:1843 | DataService.FP_UpdateBatch2 | COUNT, EXCEPTION, RESULT |
| FP_PseudoBatch2 | SpdMain_CellClick:1857, SpdMain_CellClick:1868 | DataService.FP_PseudoBatch2 | COUNT, EXCEPTION, RESULT |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | CellClick | SpdMain_CellClick | InitializeComponent:122 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:123 |
| this.spdMain | ComboSelChange | SpdMain_ComboSelChange | InitializeComponent:124 |
| this.dtpPlanDate | ValueChanged | dtpPlanDate_ValueChanged | InitializeComponent:237 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:333 |
| this.btnPlanInfo | Click | btnPlanInfo_Click | InitializeComponent:653 |
| this.chkStatus | CheckedChanged | chkStatus_CheckedChanged | InitializeComponent:727 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:766 |
| this | Activated | FP00591_Plan_Control_Integration_Activated | InitializeComponent:879 |
| this | Deactivate | FP00591_Plan_Control_Integration_Deactivate | InitializeComponent:880 |
| this | FormClosing | FP00591_Plan_Control_Integration_FormClosing | InitializeComponent:881 |
| this | Load | Form_Load | .ctor:187 |
| cboPlanGroup | SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged | InitEvent:208 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:209 |
| this | Deactivate | FP00591_Plan_Control_Integration_Deactivate | InitEvent:211 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1172 |
| this | _DoEngineRunSelectEvent1 | DisplayEngineRunData | ChartThread_Start:1300 |
| this.btnRun | Click | btnRun_Click | InitializeComponent:313 |
| this | Load | MeasureSetForm_Load | InitializeComponent:334 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:335 |
| rbOpt1 | CheckedChanged | rbOpt1_Click | MeasureSetForm_Load:90 |
| rbOpt2 | CheckedChanged | rbOpt2_Click | MeasureSetForm_Load:91 |

## 6. 컨트롤 (43개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | lblSql, layoutControlItem8, lblSite, layoutControlItem2, layoutControlItem9, layoutControlItem1, layoutControlItem6, layoutControlItem7, layoutControlItem3 |
| UsrLabel | 6 | usrLabel2, usrLabel1, usrlblFixDate1, usrLabel1, usrLabel2, usrLabel3 |
| UsrButton | 4 | btnSql, btnPlanInfo, btnFind, btnRun |
| TextBox | 3 | txt_cellDesc, txt_formDesc, txt_elecDesc |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl3 |
| UsrCombo | 2 | cboPlanGroup, cboSite |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup3 |
| Panel | 2 | StockPanel, panel1 |
| RadioButton | 2 | rbOpt2, rbOpt1 |
| UsrDatePicker2 | 1 | dtpPlanDate |
| ImageList | 1 | imageList1 |
| EmptySpaceItem | 1 | emptySpaceItem7 |
| UsrCheckBox | 1 | chkStatus |
| Splitter | 1 | splitter1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| DateTimePicker | 1 | dtpFixDate1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 42 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 3 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 2 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 792 | FP_Planning.PR_UI_FP00591_Plan_Control_Integration | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00591 | EngineRun | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | FP00591 | PlanControl | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: PlanControl, EngineRun
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:373, SetSheetHeaderColumn_FP@InitSpread:412
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 381 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 382 | 표시/라벨 변경 | set:Visible | Visible = {?false} | INSTANCE_ID | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 383 | 표시/라벨 변경 | set:Visible | Visible = {?false} | WOW_ID | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 384 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ROLE_ID | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 385 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ROLE_NAME | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 386 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLAN_SEQ | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 387 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ACTION_01_TYPE | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 388 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ACTION_01_VALUE | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 389 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ACTION_02_TYPE | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 390 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ACTION_02_VALUE | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 391 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ACTION_03_TYPE | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 392 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ACTION_03_VALUE | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 393 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ACTION_03_NAME | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 394 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ACTION_04_TYPE | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 395 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ACTION_04_VALUE | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 396 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ACTION_05_TYPE | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 397 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ACTION_05_VALUE | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 398 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ACTION_06_TYPE | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 399 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ACTION_06_VALUE | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 400 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ACTION_06_NAME | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 401 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLAN_DATE | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 402 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLAN_USER | if(spreadInfo.SheetName == "PlanControl") |
| InitSpread |  | 417 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ENGINE_STATUS | else!(spreadInfo.SheetName == "PlanControl") ⟫ if(spreadInfo.SheetName == "EngineRun") |
| InitSpread |  | 418 | 표시/라벨 변경 | set:Visible | Visible = {?false} | STATUS_FLAG | else!(spreadInfo.SheetName == "PlanControl") ⟫ if(spreadInfo.SheetName == "EngineRun") |
| InitSpread |  | 419 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID | else!(spreadInfo.SheetName == "PlanControl") ⟫ if(spreadInfo.SheetName == "EngineRun") |
| InitSpread |  | 420 | 표시/라벨 변경 | set:Visible | Visible = {?false} | STATUS_START | else!(spreadInfo.SheetName == "PlanControl") ⟫ if(spreadInfo.SheetName == "EngineRun") |
| InitSpread |  | 421 | 표시/라벨 변경 | set:Visible | Visible = {?false} | STATUS_END | else!(spreadInfo.SheetName == "PlanControl") ⟫ if(spreadInfo.SheetName == "EngineRun") |
| InitializeComponent |  | 140 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 141 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 142 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 143 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 574 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 575 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 576 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 577 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| EngineRun | META+코드연결 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |
| PlanControl | META+코드연결 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
