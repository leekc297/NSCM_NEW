# FP00637 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00637_Material_Cell_Simulation_Pack.UIL\FP00637_BucketSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00637_Material_Cell_Simulation_Pack.UIL\FP00637_Material_Cell_Simulation_Pack.UIL.csproj | 234 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00637_Material_Cell_Simulation_Pack.UIL\FP00637_BucketSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00637_Material_Cell_Simulation_Pack.UIL\FP00637_Material_Cell_Simulation_Pack.UIL.csproj | 224 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00637_Material_Cell_Simulation_Pack.UIL\FP00637_Material_Cell_Simulation_Pack.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00637_Material_Cell_Simulation_Pack.UIL\FP00637_Material_Cell_Simulation_Pack.UIL.csproj | 2868 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00637_Material_Cell_Simulation_Pack.UIL\FP00637_Material_Cell_Simulation_Pack.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00637_Material_Cell_Simulation_Pack.UIL\FP00637_Material_Cell_Simulation_Pack.UIL.csproj | 3259 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00637_Material_Cell_Simulation_Pack.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00637_Material_Cell_Simulation_Pack.UIL\FP00637_Material_Cell_Simulation_Pack.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00637_Material_Cell_Simulation_Pack.UIL\TestCode.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00637_Material_Cell_Simulation_Pack.UIL\FP00637_Material_Cell_Simulation_Pack.UIL.csproj | 48 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboInstance.SelectedIndexChanged | cboInstance_changed > GetDivision | 675 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | cboSite_changed > GetPlant | 689 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | clbDivision_changed > GetSite | 682 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | clbPlant_changed > GetFactory | 698 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1919 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1919 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_WeekCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1920 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1920 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_DateMap.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1921 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1921 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_MonthCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1922 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1922 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_BukInfo.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1919 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1919 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_WeekCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1920 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1920 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_DateMap.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1921 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1921 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_MonthCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1922 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1922 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_BukInfo.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1616 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_data] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1616 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#merge_data | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1622 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_calculation] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1622 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#execute_calculation | MATCH | SP PR_SCM_PACK_MATERIAL_SIMULATION |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1919 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1919 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_WeekCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1920 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1920 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_DateMap.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1921 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1921 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_MonthCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1922 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1922 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_BukInfo.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1919 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1919 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_WeekCnt.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1920 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1920 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_DateMap.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1921 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1921 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_MonthCnt.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1922 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1922 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_BukInfo.sql |
| event:this.btnCreatePlan.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1919 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1919 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_WeekCnt.sql |
| event:this.btnCreatePlan.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1920 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1920 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_DateMap.sql |
| event:this.btnCreatePlan.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1921 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1921 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_MonthCnt.sql |
| event:this.btnCreatePlan.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1922 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1922 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_BukInfo.sql |
| event:this.btnCreatePlan.Click | btnCratePlan_Click | 2803 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_calculation] | BIZ_MATCH |  |
| event:this.btnCreatePlan.Click | btnCratePlan_Click | 2803 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#execute_calculation | MATCH | SP PR_SCM_PACK_MATERIAL_SIMULATION |
| event:this.btnCreatePlanxx.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1919 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btnCreatePlanxx.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1919 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_WeekCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_WeekCnt.sql |
| event:this.btnCreatePlanxx.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1920 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btnCreatePlanxx.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1920 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_DateMap | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_DateMap.sql |
| event:this.btnCreatePlanxx.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1921 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnCreatePlanxx.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1921 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_MonthCnt | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_MonthCnt.sql |
| event:this.btnCreatePlanxx.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1922 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:this.btnCreatePlanxx.Click | btnCratePlan_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1922 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_BukInfo | MATCH | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_BukInfo.sql |
| event:this.btnCreatePlanxx.Click | btnCratePlan_Click | 2803 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_calculation] | BIZ_MATCH |  |
| event:this.btnCreatePlanxx.Click | btnCratePlan_Click | 2803 | FP\Planning\FP00637_Material_Cell_Simulation_Pack#execute_calculation | MATCH | SP PR_SCM_PACK_MATERIAL_SIMULATION |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 244 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 250 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 257 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 263 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 83 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 2 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_calculation] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_data] | BIZ_MATCH | 1 |  |  |  |
| FP\Planning\FP00637_Material_Cell_Simulation_Pack#execute_calculation | MATCH | 2 | SP PR_SCM_PACK_MATERIAL_SIMULATION | EXEC:PR_SCM_PACK_MATERIAL_SIMULATION | ⚠ DB에 SP 없음 |
| FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_BukInfo | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_BukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_DateMap | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_MonthCnt | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Planning\FP00637_Material_Cell_Simulation_Pack#find_WeekCnt | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00637_Material_Cell_Simulation_Pack_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Planning\FP00637_Material_Cell_Simulation_Pack#merge_data | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | MONTH_INFO, BUCKET, WEEK_INFO, CATE_INFO |
| ApplySearchCondition | Filter | BUCKET_FROM, BUCKET_TO, TABLE_NAME, RELEASE_FLAG, PLAN_TYPE, MASTER_ID, INSTANCE_ID |
| btnCratePlan_Click | Filter | MASTER_ID, PLAN_ID |
| btnCratePlan_Click | dtNewPlan.Rows[0] | PLAN_ID |
| cboPlanId_changed | dtPlanId.Rows[cboPlanId.SelectedIndex] | PLAN_TYPE, DESCRIPTION, NAME, HISTORY_YN, INSERT_ID, INSERT_DTTM, UPDATE_ID, UPDATE_DTTM |
| CheckAndGetMeasure | measure.Data | chk_week, chk_day, chk_month |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | x | _MM_ |
| drpPeriod_changed | Filter | PLAN_DATE |
| drpPlanDate_changed | dtPlanDate.Rows[0] | PLAN_START_DATE, PLAN_END_DATE |
| GetDivision | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| GetFactory | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PLAN_TYPE, BUILDING, MASTER_ID, PLAN_ID |
| GetLine | Filter | LINE_ID |
| GetPlanId | dtPlanId.Rows[cboPlanId.SelectedIndex] | DESCRIPTION, INSERT_ID, INSERT_DTTM, UPDATE_ID, UPDATE_DTTM, PLAN_TYPE, NAME, HISTORY_YN |
| GetPlanPeriod | dtPlanId.Rows[cboPlanId.SelectedIndex] | PLAN_START_DATE, PLAN_END_DATE, PLAN_TYPE, DESCRIPTION, NAME, HISTORY_YN |
| GetPlanPeriod | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO |
| GetPlant | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| GetSite | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| GoEditMode | row | DATA_TYPE, EDIT_YN |
| InitControls | Filter | USER_ID, MASTER_ID, INSTANCE_ID |
| InitControls | dtInstance.Rows[0] | CONFIRM_AREA |
| RefreshHeader | row | DATA_TYPE |
| Save_Data | Filter | INSTANCE_ID, FP_PLAN_ID, PLAN_ID, SIM_PLAN_ID |
| Save_Data | enum_row_from_Saving | EQTY, EDATE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, MODEL_ID, ITEM_ID |
| Save_Data | x | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, MODEL_ID, ITEM_ID, CATEGORY_ID, PLAN_DATE, INSTANCE_ID, PLAN_ID |
| Save_Data | selected | ORG_SIM_QTY, SIM_QTY, M |
| Save_Data | newrow | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, MODEL_ID, ITEM_ID, CATEGORY_ID, PLAN_DATE, INSTANCE_ID, PLAN_ID, SIM_QTY, ORG_SIM_QTY, M |
| Save_Data | dr | USER_ID, SIM_PLAN_ID |
| Save_Data | resultDT.Rows[0] | RESULT |
| SetChangeControl | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PLAN_TYPE, BUILDING, MASTER_ID, PLAN_ID |
| SetCurrentDate | dtIsPast.Rows[0] | CURR_DATE, PLAN_START_DATE, PLAN_END_DATE |
| SetCurrentDate | Filter | PLAN_DATE |
| spdMain_CellDoubleClick | dsMainFiltered.Tables[0].Rows[e.Row] | ITEM_ID, LINE_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID |
| spdMain_CellDoubleClick | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, HISTORY_YN |
| spdMain_CellDoubleClick | dtCellCode.Rows[0] | CELL_CODE |
| UIFindData | Filter | PLAN_ID, RELEASE_FLAG |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:132, InitControl:155, CheckAndGetMeasure:781 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| SetFilter | InitControls:190, InitControls:191, InitControls:192, InitControls:193, InitControls:208, InitControls:209, InitControls:210, SetChangeControl:239 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetCheckedListValue | InitControls:207, SetChangeControl:247, SetChangeControl:253, SetChangeControl:260, SetChangeControl:269, SetChangeControl:280, SetChangeControl:286, GetPlanId:343 | CString.GetCheckedListValue | CODE |
| FP_Log2 | cboInstance_changed:457, cboInstance_changed:475 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| EditQuery | RefreshHeader:841, RefreshHeader:864 | FPExtensions.EditQuery | ROW_ID |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:1331 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| GetChanges | Save_Data:1409 | FPExtensions.GetChanges | ROW_ID |
| FP_UpdateBatch | Save_Data:1616 | DataService.FP_UpdateBatch | COUNT, RESULT |
| SetManualCondition | spdMain_CellDoubleClick:2503, spdMain_CellDoubleClick:2504, spdMain_CellDoubleClick:2505, spdMain_CellDoubleClick:2506, spdMain_CellDoubleClick:2507, spdMain_CellDoubleClick:2508, spdMain_CellDoubleClick:2509, spdMain_CellDoubleClick:2518 | BaseForm.SetManualCondition | ControlName, ControlValue |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btbSet | Click | btnSet_Click | InitializeComponent:148 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:185 |
| this | Load | MeasureSetForm_Load | InitializeComponent:200 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:201 |
| this | Load | Form_Load | .ctor:132 |
| clbDivision | SelectedIndexChanged | clbDivision_changed | InitEvent:308 |
| cboSite | SelectedIndexChanged | cboSite_changed | InitEvent:309 |
| clbPlant | SelectedIndexChanged | clbPlant_changed | InitEvent:310 |
| clbFactory | SelectedIndexChanged | clbFactory_changed | InitEvent:311 |
| clbOperation | SelectedIndexChanged | clbOperation_changed | InitEvent:312 |
| clbLine | SelectedIndexChanged | clbLine_changed | InitEvent:313 |
| cboInstance | SelectedIndexChanged | cboInstance_changed | InitEvent:317 |
| cboPlanId | SelectedIndexChanged | cboPlanId_changed | InitEvent:319 |
| edtPjtGroupName | TextChanged | edtPjtGroupName_TextChanged | InitEvent:321 |
| edtModelName | TextChanged | edtModelName_TextChanged | InitEvent:322 |
| edtModel | TextChanged | edtModel_TextChanged | InitEvent:323 |
| edtNickName | TextChanged | edtNickName_TextChanged | InitEvent:324 |
| edtItem | TextChanged | edtItem_TextChanged | InitEvent:325 |
| drpPlanDate | DateTimeChanged | drpPlanDate_changed | InitEvent:328 |
| drpPeriod | ValueChanged | drpPeriod_changed | InitEvent:329 |
| drpPlanDate | DateTimeChanged | drpPlanDate_changed | drpPlanDate_changed:625 |
| drpPlanDate | DateTimeChanged | drpPlanDate_changed | drpPlanDate_changed:643 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1294 |
| this.chk_Info | CheckedChanged | chk_Info_CheckedChanged | InitializeComponent:324 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:867 |
| this.btnData | Click | btnData_Click | InitializeComponent:2094 |
| this.btnCreatePlanxx | Click | btnCratePlan_Click | InitializeComponent:2398 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:2410 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:2411 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:2412 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:2413 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:2414 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:2415 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:2416 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:2417 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:2418 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:2419 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:2420 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:2421 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:2422 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:2423 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:2424 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:2425 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:2426 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:2427 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:2428 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:2429 |
| this.button1 | Click | button1_Click | InitializeComponent:2559 |
| this.btnCreatePlan | Click | btnCratePlan_Click | InitializeComponent:2764 |
| this.btnMenu | Click | btnMenu_Click | InitializeComponent:2777 |
| this.btn_bucket | Click | btnBucket_Click | InitializeComponent:2815 |
| this.btn_category | Click | btnCatagory_Click | InitializeComponent:2854 |
| this.btn_column | Click | btnColumn_Click | InitializeComponent:2892 |

## 6. 컨트롤 (132개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 38 | layoutControlItem1, layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem10, layoutControlItem16, layoutControlItem18, layoutControlItem22, layoutControlItem23, layoutControlItem24, layoutControlItem25, layoutControlItem26, layoutControlItem27, layoutControlItem28, layoutControlItem31 … |
| UsrButton | 13 | btbSet, btnOK, btnSql, btnToggleSave, usrButton1, btnExcelImport, btnData, btnCreatePlanxx, usrButton2, btnCreatePlan, btn_bucket, btn_category, btn_column |
| UsrCheckedList2 | 13 | clbLine, clbOperation, clbFactory, clbPlant, clbDivision, mcbo_line, mcbo_division, mcbo_prodtype, mcbo_operation, mcbo_factory, mcbo_plant, mcbo_planner, mcbo_site |
| Label | 12 | label3, txtDesc, txtUpdation, txtUpdater, txtCreation, txtCreator, label7, label6, label5, label4, label2, label1 |
| UsrTextBox | 8 | edtNickName, edtItem, edtModel, edtPjtGroupName, edtModelName, edt_pjtGroup, usrTextBox1, usrTextBox2 |
| Panel | 6 | panel1, infoPanel, menuPanel, panel2, panel4, panel1 |
| EmptySpaceItem | 6 | emptySpaceItem7, emptySpaceItem8, emptySpaceItem4, emptySpaceItem5, emptySpaceItem2, emptySpaceItem1 |
| CheckBox | 5 | chk_day, chk_cell_qty, chk_avail_qty, chk_mat_qty, chk_plan_qty |
| UsrCombo | 5 | cboSite, cboPlanId, cboInstance, cbo_plan_group, cbo_fpplanid |
| UsrLayoutControl | 3 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl3 |
| LayoutControlGroup | 3 | layoutControlGroup1, layoutControlGroup4, layoutControlGroup2 |
| FpSpread | 3 | spdMain, spdEdit, spdInfo |
| SheetView | 3 | spdMain_Sheet1, spdEdit_Sheet1, spdInfo_Sheet1 |
| UsrCheckBox | 2 | chk_Info, usrCheckBox1 |
| Button | 2 | button1, btnMenu |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDatePickerWtWeek | 1 | drpPlanDate |
| UsrPopupTextBox | 1 | usrPopupTextBox1 |
| UsrDateRangePickerWtWeek | 1 | dCalendar_planrange |
| UsrDateRangePicker2 | 1 | drpPeriod |
| SplitContainer | 1 | splitter |
| ImageList | 1 | imageList1 |
| GroupBox | 1 | groupBox1 |
| TextBox | 1 | tbLog |
| DataGridView | 1 | dgEdit |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 16 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 16 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00637 | Amend | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:755, SetSheetHeaderColumn_FP@RefreshHeaderOnly:1002
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| RefreshHeader |  | 953 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?colorBlue} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| RefreshHeader |  | 959 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?colorRed} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| InitializeComponent |  | 2445 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2446 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2447 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2448 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2936 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2937 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2938 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2939 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2987 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2988 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2989 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2990 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
