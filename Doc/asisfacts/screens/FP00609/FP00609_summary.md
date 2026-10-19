# FP00609 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_BucketSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_Pancake_Simul_By_Bld_Elec.UIL.csproj | 254 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_BucketSetForm_Popup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_Pancake_Simul_By_Bld_Elec.UIL.csproj | 194 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_Pancake_Simul_By_Bld_Elec.UIL.csproj | 301 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_MeasureSetForm_Popup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_Pancake_Simul_By_Bld_Elec.UIL.csproj | 283 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_Pancake_Simul_By_Bld_Elec.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_Pancake_Simul_By_Bld_Elec.UIL.csproj | 4341 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_Pancake_Simul_By_Bld_Elec.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_Pancake_Simul_By_Bld_Elec.UIL.csproj | 1885 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_PlanInfoPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_Pancake_Simul_By_Bld_Elec.UIL.csproj | 303 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_PlanInfoPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_Pancake_Simul_By_Bld_Elec.UIL.csproj | 282 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00609_Pancake_Simul_By_Bld_Elec.UIL\FP00609_Pancake_Simul_By_Bld_Elec.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2479 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2479 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_WeekCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2480 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2480 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_DateMap.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2481 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2481 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_MonthCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2482 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2482 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_BukInfo.sql |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2479 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2479 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_WeekCnt.sql |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2480 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2480 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_DateMap.sql |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2481 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2481 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_MonthCnt.sql |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2482 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2482 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_BukInfo.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2479 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2479 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_WeekCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2480 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2480 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_DateMap.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2481 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2481 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_MonthCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2482 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2482 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_BukInfo.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1428 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1428 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1449 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_data] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1449 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#merge_data | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1458 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1458 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#execute_psiCalcul | MATCH | SP PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2479 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2479 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_WeekCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2480 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2480 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_DateMap.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2481 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2481 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_MonthCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2482 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2482 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_BukInfo.sql |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2479 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2479 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_WeekCnt.sql |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2480 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2480 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_DateMap.sql |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2481 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2481 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_MonthCnt.sql |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2482 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2482 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_BukInfo.sql |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2479 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2479 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_WeekCnt.sql |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2480 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2480 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_DateMap.sql |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2481 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2481 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_MonthCnt.sql |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2482 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:this.btnCategory.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2482 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_BukInfo.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 115 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_Confirm | 1522 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_confirm] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_Confirm | 1522 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#execute_confirm | MATCH | SP PR_SCM_OF_CELL_DELIVERY_PLAN_FIX |
| unreached:(진입점 미연결) | Save_Confirm | 1529 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_planSend] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_Confirm | 1529 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#execute_planSend | MATCH | SP PR_SCM_INHOUSE_MOVING_PLAN_SEND |
| unreached:(진입점 미연결) | Save_VersionUp | 1591 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_version] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_VersionUp | 1591 | FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#execute_version | MATCH | SP PR_SCM_OF_CELL_DELIVERY_PLAN |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_confirm] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_planSend] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_version] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_data] | BIZ_MATCH | 1 |  |  |  |
| FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql | SELECT:FP_PLAN_STATUS_H, SELECT:SCM_FP_PLAN_DETAIL_H, SELECT:SCM_FP_PLAN_GROUP_DETAIL_H, SELECT:FP_RELEASE_CALCULATION_STATUS_H |  |
| FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#execute_confirm | MATCH | 1 | SP PR_SCM_OF_CELL_DELIVERY_PLAN_FIX | EXEC:PR_SCM_OF_CELL_DELIVERY_PLAN_FIX | ⚠ DB에 SP 없음 |
| FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#execute_planSend | MATCH | 1 | SP PR_SCM_INHOUSE_MOVING_PLAN_SEND | EXEC:PR_SCM_INHOUSE_MOVING_PLAN_SEND | ⚠ DB에 SP 없음 |
| FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#execute_psiCalcul | MATCH | 1 | SP PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI | EXEC:PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI | ⚠ DB에 SP 없음 |
| FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#execute_version | MATCH | 1 | SP PR_SCM_OF_CELL_DELIVERY_PLAN | EXEC:PR_SCM_OF_CELL_DELIVERY_PLAN | ⚠ DB에 SP 없음 |
| FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_BukInfo | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_BukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_DateMap | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_MonthCnt | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#find_WeekCnt | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00609_Pancake_Simul_By_Bld_Elec_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Planning\FP00609_Pancake_Simul_By_Bld_Elec#merge_data | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | MONTH_INFO, BUCKET, WEEK_INFO, CATE_INFO |
| ApplySearchCondition | Filter | BUCKET_FROM, BUCKET_TO, PLAN_DATE, PLAN_ID, MASTER_ID, INSTANCE_ID |
| btnPlanInfo_Click | Filter | MASTER_ID, INSTANCE_ID, CONFIRM_AREA, PLAN_DATE, RELEASE_FLAG, PLAN_ID |
| btnPlanInfo_Click | planInfoPopup.Filter | MASTER_ID, INSTANCE_ID, CONFIRM_AREA, USER_ID, PLAN_DATE, RELEASE_FLAG, PLAN_ID, PROG_ID |
| cboInstance_changed | dtInstance.Rows[cboInstance.SelectedIndex] | CODE_ID, ROUND_POINT, CONFIRM_AREA |
| cboPlanId_changed | dtPlanId.Rows[selected] | PLAN_TYPE, DESCRIPTION, READ_ONLY, CODE_NAME |
| CheckAndGetMeasure | measure.Data | chk_week, chk_day, chk_month |
| chk_rel_CheckedChanged | Filter | BUCKET_FROM, CURR_DATE, PLAN_DATE |
| chk_rel_CheckedChanged | dtCurrDate.Rows[0] | CURR_DATE |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_assy, chk_post, chk_coaterBatch, chk_coater, chk_shipment, chk_shipmentIn, chk_inv, chk_subtotal, chk_total |
| CreateFilterDataSet | x | _MM_ |
| FindData | Filter | USER_ID |
| FindMainData | Filter | PLAN_NAME |
| FindYieldInfo | row | FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, START_DATE, END_DATE |
| FindYieldInfo | clicked_row | FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID |
| FindYieldInfo | rowTmp | YIELD |
| GetCellType | Filter | CELL_TYPE |
| GetCellType | dtCellType.Rows[0] | CODE |
| GetFpPlandId | Filter | PLAN_ID, PLAN_TYPE, DESCRIPTION, READ_ONLY, PLAN_NAME, BUCKET_FROM, BUCKET_TO |
| GetFpPlandId | dtPlanId.Rows[0] | PLAN_ID, PLAN_TYPE, DESCRIPTION, READ_ONLY, CODE_NAME, DEFAULT_START_DATE, DEFAULT_END_DATE |
| GetPancakeType | Filter | PANCAKE_TYPE |
| GetPancakeType | dtPancakeType.Rows[0] | CODE |
| GetPlanGroup | Filter | MASTER_ID, INSTANCE_ID, ROUND_POINT, CONFIRM_AREA |
| GetPlanGroup | dtInstance.Rows[0] | CODE_ID, ROUND_POINT, CONFIRM_AREA |
| GetUnit | Filter | UNIT |
| GetUnit | dtUnit.Rows[0] | CODE |
| GetUOMType | Filter | UOM_TYPE |
| GetUOMType | dtUOMType.Rows[1] | CODE |
| GoEditMode | row | DATA_TYPE, CATEGORY_ID, IS_ROLE, D0_BACK |
| GoEditMode | Filter | PLAN_TYPE, RELEASE_FLAG |
| InitSpread | Filter | CONFIRM_AREA, PROGRAM_ID, SHEET_NAME |
| InsertButton | Filter | DONOTEDIT, PLAN_TYPE, RELEASE_FLAG |
| InsertButton | row | DATA_TYPE, DIVISION_ID, SITE_ID, LINE_ID |
| InsertButton | popup.Filter | DIVISION_ID, SITE_ID, LINE_ID, FP_PLAN_ID, PLAN_ID |
| lfn_getExchangeBatch_Validation | x | FACTORY_ID, OPERATION, ITEM_ID, CATEGORY, PROD_VERSION_TYPE |
| lfn_getExchangeBatch_Validation | clicked_row | FACTORY_ID, OPERATION_ID, ITEM_ID, PROD_VERSION_TYPE |
| lfn_getExchangeBatch_Validation | pancake_r.First() | VALUE |
| lfn_setExchangeBatch | clicked_row | PRODUCTION_TYPE, PROD_VERSION_TYPE, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID |
| lfn_setExchangeBatch | dtUomInfo.Rows[nExcRow] | VALUE |
| lfn_setExchangeBatch_Detail | objDs | FACTORY_ID, OPERATION_ID, ITEM_ID |
| lfn_setPostQty | clicked_row | ITEM_RANK |
| lfn_setPostQty | row | DATA_TYPE, CATEGORY_ID, ITEM_RANK |
| lfn_setPostQty | x | DATA_TYPE, CATEGORY_ID, ITEM_RANK |
| lfn_setPostQty | yieldRow | FACTORY_ID, ITEM_ID, MONTH |
| lfn_setPostQty | related_row | FACTORY_ID, ITEM_ID |
| lfn_setPostQty | yieldRowTmp | POST_YIELD |
| planday_changed | Filter | PLAN_DATE |
| RefreshHeader | row | DATA_TYPE |
| Save_Data | checkSave.Tables[0].Rows[0] | _TYPE |
| Save_Data | updateResult.Rows[0] | RESULT |
| Save_VersionUp | Filter | BASIS_PLAN_ID, PLAN_ID, CREATE_PLAN_ID, CAL_OPTION, FIX_DATE, COPY_FLAG, USER_ID, TARGET_DATE, CURR_DATE |
| SaveButton | Filter | DONOTEDIT |
| SetCurrDate_Default | dtCurrDate.Rows[0] | CURR_DATE, PLAN_START_DATE, PLAN_END_DATE |
| SetCurrDate_Default | Filter | CURR_DATE, PLAN_DATE, BUCKET_FROM, BUCKET_TO |
| SetInventory | row | DATA_TYPE, CATEGORY_ID, ITEM_RANK, MODEL_ITEM_RANK |
| SetInventory | x | ITEM_RANK, MODEL_ITEM_RANK, DATA_TYPE |
| SetInventory | related_row | CATEGORY_ID |
| SetInventory_Detail | invRow | POST_BOH_QTY, LT |
| SetInventoryTotal_Detail | invRow | POST_BOH_QTY, LT |
| SetPlanOut | clicked_row | DIVISION_ID, SITE_ID, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, CATEGORY_ID, ITEM_RANK |
| SetPlanOut | x | FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, PLAN_DATE, ITEM_ID, PRODUCTION_TYPE, MARKET, RELEASE_TYPE, ITEM_RANK |
| SetPlanOut | newRow | INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, SITE_ID, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ELECTRODE_TYPE, PRODUCTION_TYPE, MARKET, ITEM_ID, PLAN_DATE, RELEASE_TYPE |
| SetPlanOut | Filter | MASTER_ID, PLAN_ID, UOM_TYPE |
| SetPlanOut | row | CATEGORY_ID, DATA_TYPE, FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, ITEM_RANK |
| SetPlanOut | related_row | CATEGORY_ID |
| tbModelNickNameList_OnSearchConditionChanged | Filter | MODEL_NICK_NAME_LIST, MODEL_NICK_NAME_TOP |
| UIFindData | Filter | PLAN_ID, ROUND_POINT |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:128, InitControl:150, Measure:147, InitControl:197, CheckAndGetMeasure:419 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| SetFilter | InitControls:231, InitControls:233, InitControls:235, InitControls:236, InitControls:237, UIFindData:774, Save_Data:1425, Save_Confirm:1515 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| EditQuery | RefreshHeader:459, RefreshHeader:472 | FPExtensions.EditQuery | ROW_ID |
| GetChanges | Save_Data:1359, Save_Data:1368 | FPExtensions.GetChanges | ROW_ID |
| FP_UpdateBatch2 | Save_Data:1449 | DataService.FP_UpdateBatch2 | COUNT, EXCEPTION, RESULT |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:1709 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| GetCheckedListValue | ApplySearchCondition:2507, clbBuilding_changed:3429, cboCellType_changed:3434, cboPancakeType_changed:3439, cboUOMType_changed:3444, cboUnit_changed:3449, GetElecFactory:4175 | CString.GetCheckedListValue | CODE |
| FP_Log2 | cboInstance_changed:3360, cboInstance_changed:3401 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:121 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:137 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:192 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:193 |
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:121 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:158 |
| this | Load | MeasureSetForm_Load | InitializeComponent:172 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:173 |
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:189 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:226 |
| this | Load | MeasureSetForm_Load | InitializeComponent:251 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:252 |
| this | Load | Form_Load | .ctor:164 |
| cboInstance | SelectedIndexChanged | cboInstance_changed | InitEvent:263 |
| drpPlanDate | DateTimeChanged | planday_changed | InitEvent:264 |
| cboPlanId | SelectedIndexChanged | cboPlanId_changed | InitEvent:265 |
| chk_rel | CheckedChanged | chk_rel_CheckedChanged | InitEvent:266 |
| clbBuilding | SelectedIndexChanged | clbBuilding_changed | InitEvent:267 |
| cboCellType | SelectedIndexChanged | cboCellType_changed | InitEvent:269 |
| cboPancakeType | SelectedIndexChanged | cboPancakeType_changed | InitEvent:270 |
| cboUOMType | SelectedIndexChanged | cboUOMType_changed | InitEvent:271 |
| cboUnit | SelectedIndexChanged | cboUnit_changed | InitEvent:272 |
| txtModel | TextChanged | txtModel_TextChanged | InitEvent:274 |
| txtModelNickName | TextChanged | txtModelNickName_TextChanged | InitEvent:275 |
| txtMaterial | TextChanged | txtMaterial_TextChanged | InitEvent:276 |
| txtNickName | TextChanged | txtNickName_TextChanged | InitEvent:277 |
| tbModelNickNameList | BeforeOpenSearch | tbModelNickNameList_BeforeOpenSearch | InitEvent:278 |
| tbModelNickNameList | OnSearchConditionChanged | tbModelNickNameList_OnSearchConditionChanged | InitEvent:279 |
| drpPeriod | ValueChanged | drpPeriod_changed | InitEvent:281 |
| chk_omit_zero | CheckedChanged | chk_omit_zero_CheckedChanged | InitEvent:282 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1619 |
| this.btnToggleSave | Click | btnToggleSave_Click | InitializeComponent:378 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:567 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:1178 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:1179 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:1180 |
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:1181 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:1182 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:1183 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:1184 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:1185 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:1186 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1187 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1188 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:1189 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1190 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:1191 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:1192 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:1193 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:1194 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:1195 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:1196 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:1197 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:1198 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:1199 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:1200 |
| this.btnPlanInfo | Click | btnPlanInfo_Click | InitializeComponent:1474 |
| this.btnBucket | Click | btnBucket_Click | InitializeComponent:1513 |
| this.btnCategory | Click | btnCatagory_Click | InitializeComponent:1551 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:1589 |

## 6. 컨트롤 (97개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 18 | layoutControlItem2, lblSql, lblData, lblInstance, lblInstance3, lblInstance4, @__Material, lblInstance1, S, layoutControlItem14, lblPlanID, lblDivision, lblItem1, layoutControlItem1, lblItem … |
| UsrButton | 12 | btnClose, usrButton1, usrButton2, usrButton1, usrButton2, btnToggleSave, btnSql, usrButton2, btnPlanInfo, btnBucket, btnCategory, btnColumn |
| CheckBox | 11 | chk_month, chk_week, chk_day, chk_inv, chk_coater, chk_coaterBatch, chk_post, chk_assy, chk_subtotal, chk_total, chk_omit_zero |
| Panel | 8 | panel1, panel1, panel3, panel2, panel5, panel3, panel4, panel1 |
| UsrCombo | 6 | cboInstance, cboPlanId, cboUOMType, cboUnit, cboCellType, cboPancakeType |
| EmptySpaceItem | 5 | emptySpaceItem1, emptySpaceItem4, emptySpaceItem5, emptySpaceItem1, emptySpaceItem2 |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| FpSpread | 4 | spdMain, spdMain, spdEdit, spdInfo |
| SheetView | 4 | spdMain_Sheet1, spdMain_Sheet1, spdEdit_Sheet1, spdInfo_Sheet1 |
| UsrTextBox | 4 | txtModel, txtModelNickName, txtMaterial, txtNickName |
| Label | 3 | label1, label2, label1 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| ImageList | 2 | imageList1, imageList1 |
| UsrLabel | 2 | lblCoaterPlan, usrLabel1 |
| UsrCheckBox | 1 | chk_rel |
| UsrDateRangePicker2 | 1 | drpPeriod |
| UsrDatePicker2 | 1 | drpPlanDate |
| UsrCheckedList2 | 1 | clbBuilding |
| UsrPopupTextBox | 1 | tbModelNickNameList |
| SplitContainer | 1 | splitter |
| TextBox | 1 | tbLog |
| DataGridView | 1 | dgEdit |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1428 | Save_Data | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 25 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
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
| SCM_MST_SHEET_COLUMNS | FP00609 | Amend | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: PlanInfoPopup, Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:166, SetSheetHeaderColumn_FP@InitSpread:393, SetSheetHeaderColumn_FP@RefreshHeaderOnly:584
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| RefreshHeader |  | 535 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| RefreshHeader |  | 541 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| InitializeComponent |  | 1216 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1217 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1218 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1219 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1633 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1634 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1635 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1636 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1684 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1685 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1686 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1687 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 169 | 표시/라벨 변경 | SetColumnHeader | 0 |  | if(Filter["CONFIRM_AREA"].ToString() != "BUILDING") |
| InitializeComponent |  | 209 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 210 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 211 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 212 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
