# FP02845 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\FP02845_BucketSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\FP02845_Plan_Result_Elec_Post_Shift.UIL.csproj | 266 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\FP02845_BucketSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\FP02845_Plan_Result_Elec_Post_Shift.UIL.csproj | 250 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\FP02845_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\FP02845_Plan_Result_Elec_Post_Shift.UIL.csproj | 364 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\FP02845_MeasureSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\FP02845_Plan_Result_Elec_Post_Shift.UIL.csproj | 287 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\FP02845_Plan_Result_Elec_Post_Shift.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\FP02845_Plan_Result_Elec_Post_Shift.UIL.csproj | 4646 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\FP02845_Plan_Result_Elec_Post_Shift.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\FP02845_Plan_Result_Elec_Post_Shift.UIL.csproj | 2038 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\FP02845_Plan_Result_Elec_Post_Shift.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02845_Plan_Result_Elec_Post_Shift\FP02845_Plan_Result_Elec_Post_Shift.UIL.csproj | 64 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetDivision | 3273 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetSite | 3307 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetPlant | 3314 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetFactory | 3325 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetOperation | 3335 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetLine | 3359 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:chk_allLine.CheckedChanged | chk_allLine_CheckedChanged > SetLine | 3359 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:dCalendar_planrange.ValueChanged | dCalendarPlanrange_changed | 1991 | biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 849 | FP_Planning.PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT | MATCH | SP PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 949 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 955 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 957 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 959 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1016 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetPlant | 3314 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetOperation | 3335 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetLine | 3359 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetFactory | 3325 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_changed > SetPlant | 3314 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 849 | FP_Planning.PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT | MATCH | SP PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 949 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 955 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 957 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 959 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1016 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend | 849 | FP_Planning.PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT | MATCH | SP PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 949 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 955 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 957 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 959 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnBucket.Click | btnBucket_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1016 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend | 849 | FP_Planning.PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT | MATCH | SP PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 949 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 955 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 957 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition | 959 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnCatagory.Click | btnCatagory_Click > UIFindData > Find_Data_Amend > ApplyAmendCalendarCondition > lfn_setReleaseProcess | 1016 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnMRP2.Click | btnMRP_Click | 2221 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnMRP2.Click | btnMRP_Click | 2249 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH |  |
| event:this.btnMRP2.Click | btnMRP_Click | 2249 | FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql |
| event:this.chk_includeSubOp.CheckedChanged | chk_includeSubOp_onchanged > SetOperation | 3335 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | MeasureSetForm_Load > InitControl | 157 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetDivision | 3273 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetPlanGroup | 3282 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetSite | 3307 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetPlant | 3314 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetFactory | 3325 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetOperation | 3335 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetLine | 3359 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 140 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_PIn_Data | 1492 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | Find_Save_Valid | 1621 | FP_Planning.PR_UI_FP02845_AMEND_LINE | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | Save_Data_Amend | 1741 | FP_Planning.PR_UI_FP02845_AMEND_SAVE | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | Exec_Procedure | 1794 | FP_Planning.PR_UI_FP02845_AMEND_LINE_SAVE | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | btnCreatePlan_Click | 2273 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | btnRelease_Click | 2348 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | btnRelease_Click | 2349 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | btnRelease_Click | 2360 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | btnRelease_Click | 2380 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | btnRelease_Click | 2383 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | lfn_getYieldInfo | 3823 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 1 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 17 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP02845_AMEND_LINE | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Planning.PR_UI_FP02845_AMEND_LINE_SAVE | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Planning.PR_UI_FP02845_AMEND_SAVE | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Planning.PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT | MATCH | 1 | SP PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT | EXEC:PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT | ⚠ DB에 SP 없음 |
| FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql | UPDATE:SCM_FP_PLAN_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO |
| ApplySearchCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, AMEND_TABLE, TOTAL_TABLE, MASTER_ID, INSTANCE_ID |
| btnBucket_Click | Application.OpenForms | FP02845_BucketSetForm_Popup |
| btnCatagory_Click | Application.OpenForms | FP02845_MeasureSetForm_Popup |
| btnColumn_Click | Application.OpenForms | FPC0097_ColumnSetForm_Popup |
| btnCreatePlan_Click | Filter | SITE_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE |
| btnCreatePlan_Click | dtPlanRunFlag.Rows[0] | PLAN_ID, INSERT_ID |
| btnCreatePlan_Click | Application.OpenForms | FP00590_PlanTotalPopup |
| btnMemo_Click | Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID |
| btnMemo_Click | memoPopup.Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, MODEL_ID, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID, USER_ID |
| btnMRP_Click | Filter | INSTANCE_ID, PLAN_ID, PLAN_TYPE, MASTER_ID |
| btnMRP_Click | dtAuthChk.Rows[0] | AUTH_YN |
| btnRelease_Click | Filter | SITE_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, DESCRIPTION, PLAN_ID |
| btnRelease_Click | dtPlanInfo.Rows[0] | DESCRIPTION |
| btnRelease_Click | dtEngineFlag.Rows[0] | INBOUND, ENGINE, OUTBOUND |
| btnRelease_Click | dtPlanRunFlag.Rows[0] | PLAN_ID, INSERT_ID |
| btnRelease_Click | dtParam2.Rows[0] | CONFIRM_AREA, IS_SAME_PLAN_ID, USE_WOW_STATUS |
| btnRelease_Click | Application.OpenForms | FP00590_GroupReleaseTotalPopup, FP00590_ReleaseTotalPopup |
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| cbo_plan_group_changed | dtInstance.Rows[cbo_plan_group.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| chk_includeSubOp_onchanged | Filter | AMEND_MAIN_FLAG |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_roll, chk_outqty, chk_result, chk_achieve, chk_subTotal, chk_total |
| CreateFilterDataSet | x | _MM_ |
| dCalendarPlanrange_changed | Filter | INSTANCE_ID |
| dCalendarPlanrange_changed | dtPeriod_Plan.Rows[0] | START_DATE, END_DATE |
| DrawSheet | Filter | DONOTEDIT |
| Exec_Procedure | Filter | INSTANCE_ID, PLAN_ID |
| Find_Data_Amend | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, MASTER_ID, PLAN_DATE, PLAN_ID, PLAN_TYPE, PROD_TYPE, TOP_ITEM_ID, ITEM_ID, NICK_NAME, UOM, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, CATE_INFO, CATE_VALUE, CATE_TYPE, AMEND_TABLE, PRODUCTION_TYPE |
| Find_Line_Savings_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, FACTORY_ID, TOP_ITEM_ID, ITEM_ID |
| Find_Line_Savings_Index_FromData | related_row | CATEGORY_ID, PRODUCTION_TYPE |
| Find_MaterialData_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, FACTORY_ID, LINE_ID, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| Find_MaterialData_Index_FromData | related_row | CATEGORY_ID |
| Find_Save_Valid | Filter | INSTANCE_ID, MASTER_ID, PLAN_DATE, PLAN_ID |
| GoEditMode | Filter | PLAN_ID |
| InitControls | Filter | USER_ID, MASTER_ID, INSTANCE_ID |
| lfn_getYieldInfo | row | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID |
| lfn_getYieldInfo | dtYieldOut.Rows[0] | YIELD |
| lfn_setExchangeBatch | x | FACTORY_ID, OPERATION_ID, ITEM_ID, CATEGORY, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, START_DATE, END_DATE |
| lfn_setExchangeBatch | row | FACTORY_ID, OPERATION_ID, ITEM_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID |
| lfn_setExchangeBatch | selected | VALUE |
| lfn_setExchangeBatch | selected2 | CHILD_YIELD |
| lfn_setReleaseProcess | Filter | INSTANCE_ID, PLAN_ID, SITE_ID, CONFIRM_AREA |
| lfn_setReleaseProcess | dtIsCurrWeek.Rows[0] | CURR_DATE |
| lfn_setReleaseProcess | row | _DATE, IS_PLAN |
| MakeMemoFontBold | dsMainFiltered.Tables[0].Rows[i] | CATEGORY_ID |
| MakeMemoFontBold | Filter | PLAN_TYPE |
| onZeroBucketMenu | row_to_test | CATEGORY_ID, DATA_TYPE |
| onZeroBucketMenu | Filter | PLAN_TYPE |
| planday_changed | Filter | PLAN_DATE |
| rdo_uom_SelectedIndexChanged | Filter | UOM |
| Save_Data_Amend | dtData.Rows[i] | INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, EQUIPMENT_ID, PLAN_DATE, SHIFT, JR_OUT_QTY, PC_OUT_QTY, PRODUCTION_TYPE |
| Save_PIn_Data | Filter | INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, PLAN_TYPE |
| Save_PIn_Data | dtCheckSave.Rows[0] | _TYPE |
| SetBohTotalQty | row | DATA_TYPE, OPERATION_ID, BOH_QTY, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohTotalQty | each_row | _TYPE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohTotalQty | result.First() | QTY |
| SetColMerge | row | VISIBLE_FLAG |
| SetColMerge | measure | chk_Shift_1, chk_Shift_2 |
| SetColMerge | dtTmp.Rows[j] | CATEGORY_ID |
| SetColumnChangeByText | dsResult.Tables[0].Rows[k] | DATA_TYPE, CATEGORY_ID |
| SetDivision | Filter | INSTANCE_ID |
| SetFactory | Filter | INSTANCE_ID, PLAN_ID, PLAN_TYPE, CONFIRM_AREA, DIVISION_ID, SITE_ID, PLANT_ID |
| SetLine | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID |
| setMeasualFormData | dtCategory.Rows[i] | MEA_ID, MEA_VALUE |
| SetOperation | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID |
| SetPlanGroup | dtInstance.Rows[0] | CODE, USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| SetPlanInBatch_DataSet | dateMap.Tables[0].Rows[dateMap.Tables[0].Rows.Count - 1] | D_VALUE |
| SetPlanInBatch_DataSet | clicked_row | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID, ITEM_ID, ELECTRODE_TYPE, CATEGORY_ID |
| SetPlanInBatch_DataSet | x | FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, PLAN_DATE, ITEM_ID, SHIFT |
| SetPlanInBatch_DataSet | selected | JR_OUT_QTY, PC_OUT_QTY |
| SetPlanInBatch_DataSet | newrow | INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, EQUIPMENT_ID, PLAN_DATE, SHIFT, PRODUCTION_TYPE, JR_OUT_QTY, PC_OUT_QTY |
| SetPlanInBatch_DataSet | Filter | INSTANCE_ID, PLAN_ID |
| SetPlanInBatch_DataSet | row | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, EQUIPMENT_ID |
| SetPlanInBatch_DataSet | dsListData.Tables | Table |
| SetPlanPeriod | dtmp.Rows[0] | START_DATE, END_DATE |
| SetPlanPeriod | Filter | BUCKET_FROM, BUCKET_TO |
| SetPlant | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID |
| SetSite | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID |
| SetTotalColor | row | DATA_TYPE |
| spdMain_CellClick2 | row | LINE_ID, PRODUCTION_TYPE, DATA_TYPE |
| spdMain_Change | dsMainFiltered.Tables[0].Rows[e.Row] | CATEGORY_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:132, InitControl:156, Measure:148, InitControl:177, CheckAndGetMeasure:1297, RefreshSpreadSheet:4251 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| SetFilter | InitControls:318, InitControls:319, InitControls:320, InitControls:321, InitControls:323, InitControls:325, InitControls:335, InitControls:336 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetSpdTitle | SetAmendHeaderColumn_FP_Local:437 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetMenuColumn | SetAmendHeaderColumn_FP_Local:461, SetAmendHeaderColumn_FP_Local:486, SetAmendHeaderColumn_FP_Local:520 | MenuService.SetMenuColumn | CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, DATA_SORT_METHOD_CODE, DEFAULT_FLAG, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, SORT_ORDER_NO, UPPERCASE_APPLY_FLAG, USER_SELECTABLE_FLAG, VALID_YN |
| SetSheetHeaderColumn | SetAmendHeaderColumn_FP_Local:545 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| GetCheckedListValue | UIFindData:686, ApplySearchCondition:912, cbo_plan_group_changed:1865, mcbo_division_changed:1917, mcbo_site_changed:1925, mcbo_plant_changed:1931, mcbo_factory_changed:1937, mcbo_operation_changed:1946 | CString.GetCheckedListValue | CODE |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:1388 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| GetChanges | Save_PIn_Data:1509 | FPExtensions.GetChanges | ROW_ID |
| FP_Log2 | cbo_plan_group_changed:1863, cbo_plan_group_changed:1876 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| LoadAmendColumn | DrawHeader:4367 | MeasureService.LoadAmendColumn | DAYTAG, MONTHTAG, WEEKTAG |
| EditQuery | DrawSheet:4404 | FPExtensions.EditQuery | ROW_ID |
| SetTotalColor | DrawSheet:4412 | SpreadInfo.SetTotalColor | column_cnt, grouping_cnt, row_idx |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btbSet | Click | btnSet_Click | InitializeComponent:145 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:182 |
| this | Load | MeasureSetForm_Load | InitializeComponent:219 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:220 |
| this.btnSet | Click | btnSet_Click | InitializeComponent:190 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:227 |
| this | Load | MeasureSetForm_Load | InitializeComponent:256 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:257 |
| this | Load | Form_Load | .ctor:212 |
| cbo_plan_group | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:271 |
| sCalendar_planday | DateTimeChanged | planday_changed | InitEvent:272 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:274 |
| mcbo_site | SelectedIndexChanged | mcbo_site_changed | InitEvent:275 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:276 |
| mcbo_factory | SelectedIndexChanged | mcbo_factory_changed | InitEvent:277 |
| mcbo_operation | SelectedIndexChanged | mcbo_operation_changed | InitEvent:278 |
| mcbo_line | SelectedIndexChanged | mcbo_line_changed | InitEvent:279 |
| mcbo_prodtype | SelectedIndexChanged | mcbo_prodtype_changed | InitEvent:280 |
| txtItem | TextChanged | TxtItem_TextChanged | InitEvent:282 |
| dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitEvent:284 |
| chk_allLine | CheckedChanged | chk_allLine_CheckedChanged | InitEvent:286 |
| spdMain | CellClick | spdMain_CellClick2 | InitEvent:287 |
| popSql | OnSql | RunSqlSource | btnSql_Click:2488 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick2:2534 |
| menu_line | Click | onZeroLineMenu | spdMain_CellClick2:2558 |
| menu_material | Click | onZeroMaterialMenu | spdMain_CellClick2:2567 |
| this.chk_includeSubOp | CheckedChanged | chk_includeSubOp_onchanged | InitializeComponent:294 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:369 |
| this.btnToggleSave | Click | btnToggleSave_Click | InitializeComponent:408 |
| this.rdo_uom | SelectedIndexChanged | rdo_uom_SelectedIndexChanged | InitializeComponent:840 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:1327 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:1328 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:1329 |
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:1330 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:1331 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:1332 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:1333 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:1334 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1335 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:1336 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:1337 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:1338 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:1339 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:1340 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:1341 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:1342 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:1343 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:1344 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:1345 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:1346 |
| this.btnMemo2 | Click | btnMemo_Click | InitializeComponent:1511 |
| this.btnMRP2 | Click | btnMRP_Click | InitializeComponent:1549 |
| this.btnBucket | Click | btnBucket_Click | InitializeComponent:1661 |
| this.btnCatagory | Click | btnCatagory_Click | InitializeComponent:1699 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:1737 |

## 6. 컨트롤 (86개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 18 | Operation, layoutControlItem5, lblSql, lblData, layoutControlItem10, layoutControlItem11, layoutControlItem16, layoutControlItem14, layoutControlItem13, layoutControlItem7, layoutControlItem8, layoutControlItem6, layoutControlItem12, layoutControlItem4, layoutControlItem3 … |
| UsrButton | 14 | btbSet, btnOK, btnSet, btnOK, btnSql, btnToggleSave, usrButton2, btnMemo2, btnMRP2, btnRelease2, btnCreatePlan2, btnBucket, btnCatagory, btnColumn |
| CheckBox | 11 | chk_week, chk_month, chk_day, chk_Shift_2, chk_Shift_1, chk_roll, chk_outqty, chk_result, chk_total, chk_subTotal, chk_achieve |
| Panel | 7 | panel1, panel2, panel1, panel3, panel2, panel4, panel1 |
| UsrCheckedList2 | 7 | mcbo_line, mcbo_operation, mcbo_factory, mcbo_plant, mcbo_site, mcbo_division, mcbo_prodtype |
| Label | 4 | label2, label1, label2, label1 |
| UsrCheckBox | 3 | chk_plannedline, chk_includeSubOp, chk_allLine |
| FpSpread | 3 | spdMain, spdEdit, spdInfo |
| SheetView | 3 | spdMain_Sheet1, spdEdit_Sheet1, spdInfo_Sheet1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrTextBox | 2 | txtNickName, txtItem |
| ImageList | 2 | imageList1, imageList2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDatePickerWtWeek | 1 | sCalendar_planday |
| UsrCombo | 1 | cbo_plan_group |
| RadioGroup | 1 | rdo_uom |
| UsrDateRangePickerWtWeek | 1 | dCalendar_planrange |
| SplitContainer | 1 | splitter |
| TextBox | 1 | tbLog |
| DataGridView | 1 | dgEdit |

## 7. 확인 필요 (4건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1621 | Find_Save_Valid | FP_Planning.PR_UI_FP02845_AMEND_LINE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 1741 | Save_Data_Amend | FP_Planning.PR_UI_FP02845_AMEND_SAVE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 1794 | Exec_Procedure | FP_Planning.PR_UI_FP02845_AMEND_LINE_SAVE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 2249 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 18 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 3 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 12 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP02845 | Amend | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetAmendHeaderColumn_FP_Local:545, SetSheetHeaderColumn_FP@DrawHeader:4308
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetCalenderColor |  | 4546 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day != null) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 4550 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day != null) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 4557 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day != null) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 4560 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day != null) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| InitializeComponent |  | 1362 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1363 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1364 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1365 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1781 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1782 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1783 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1784 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1832 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1833 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1834 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1835 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
