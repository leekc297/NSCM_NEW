# SCP0010 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0010_Shipment_Plan_SEMI\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0010_Shipment_Plan_SEMI\SCP0010_Shipment_Plan_SEMI.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0010_Shipment_Plan_SEMI\SCP0010_Shipment_Plan_SEMI.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0010_Shipment_Plan_SEMI\SCP0010_Shipment_Plan_SEMI.csproj | 5258 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0010_Shipment_Plan_SEMI\SCP0010_Shipment_Plan_SEMI.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0010_Shipment_Plan_SEMI\SCP0010_Shipment_Plan_SEMI.csproj | 1462 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl > RefreshOperationGroup | 700 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl > RefreshOperationGroup | 704 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > GetLastRange | 4655 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 4669 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| button:FindButton | FindButton > FindData_Main | 1026 | SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI | MATCH | SP SCP0010_GET_SHIPMENT_PLAN_SEMI |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 4619 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 1026 | SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI | MATCH | SP SCP0010_GET_SHIPMENT_PLAN_SEMI |
| button:SaveButton | SaveButton > SaveData_Main > Get_IsSaveYn | 1504 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| button:SaveButton | SaveButton > SaveData_Main | 2911 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanSemiWeekly] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData_Main | 2911 | SCP\Analysis\SCP0010_Shipment_Plan_SEMI#SaveShipmentPlanSemiWeekly | MATCH_PATTERN | SP SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_WEEKLY |
| button:SaveButton | SaveButton > SaveData_Main | 2915 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanSemiDataset] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData_Main | 2915 | SCP\Analysis\SCP0010_Shipment_Plan_SEMI#SaveShipmentPlanSemiDataset | MATCH_PATTERN | SP SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main > InitSpread_2 > GetSpdTitle | 4619 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Main > SCM_SYS_LOG_BATCH | 5002 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo > FindData_Main | 1026 | SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI | MATCH | SP SCP0010_GET_SHIPMENT_PLAN_SEMI |
| event:this.btnFix.Click | BtnFix_Click > Get_IsSaveYn | 1504 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo | 4254 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanSemiFix] | BIZ_MATCH |  |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo | 4254 | SCP\Analysis\SCP0010_Shipment_Plan_SEMI#SaveShipmentPlanSemiFix | MATCH_PATTERN | SP SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo > FindData_Main > InitSpread_2 > GetSpdTitle | 4619 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo > SCM_SYS_LOG_BATCH | 5002 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread_2 > GetSpdTitle | 4619 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnNew.Click | BtnNew_Click > FindData_Main | 1026 | SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI | MATCH | SP SCP0010_GET_SHIPMENT_PLAN_SEMI |
| event:this.btnNew.Click | BtnNew_Click > Get_IsSaveYn | 1504 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| event:this.btnNew.Click | BtnNew_Click > FindData_Main > InitSpread_2 > GetSpdTitle | 4619 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo > FindData_Main | 1026 | SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI | MATCH | SP SCP0010_GET_SHIPMENT_PLAN_SEMI |
| event:this.btnUnfix.Click | BtnUnfix_Click > Get_IsSaveYn | 1504 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo | 4254 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanSemiFix] | BIZ_MATCH |  |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo | 4254 | SCP\Analysis\SCP0010_Shipment_Plan_SEMI#SaveShipmentPlanSemiFix | MATCH_PATTERN | SP SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo > FindData_Main > InitSpread_2 > GetSpdTitle | 4619 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo > SCM_SYS_LOG_BATCH | 5002 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.btnW26.Click | BtnW26_Click > GetDayRange | 4669 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.btnW52.Click | BtnW52_Click > GetDayRange | 4669 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.btnWLast.Click | BtnWLast_Click > GetDayRange | 4669 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.cboBucketType.SelectedIndexChanged | CboBucketType_SelectedIndexChanged > InitSpread_2 > GetSpdTitle | 4619 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls | 337 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > RefreshOperationGroup | 700 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > RefreshOperationGroup | 704 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1706 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 4619 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetLastRange | 4655 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| event:this.Load | Form_Load > InitControls > GetDayRange | 4669 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| unreached:(진입점 미연결) | GetLastPlanVersion | 836 | SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | SP SCP0011_GET_LAST_PLAN_VERSION |
| unreached:(진입점 미연결) | GetDivision | 4583 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | SetChangedPeriod | 4596 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 4600 | biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanSemiDataset] | BIZ_MATCH | 1 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanSemiFix] | BIZ_MATCH | 1 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanSemiWeekly] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD | EXEC:SCM0001_GET_SCP_DAILY_PLAN_PERIOD, SELECT:SCM_MST_DIVISION |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI | MATCH | 1 | SP SCP0010_GET_SHIPMENT_PLAN_SEMI | EXEC:SCP0010_GET_SHIPMENT_PLAN_SEMI, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, INSERT:#TBLDYNAMICPIVOT_SCP0010_MEASURE, SELECT:SCM_MST_SHEET_MEASURE, CREATE:#TBLDYNAMICPIVOT_SCP0010_STD, INSERT:#TBLDYNAMICPIVOT_SCP0010_STD, SELECT:SCP_ANL_SHIPMENT_PLAN_SEMI, REF:FN_GET_ITEM_LIKE_CONDITION, SELECT:#TBLDYNAMICPIVOT_SCP0010_MEASURE, SELECT:SCP_ANL_BOD_N_V_PLAN_H, INSERT:#TBLDYNAMICPIVOT_SCP0010_VALUE_1, SELECT:#TBLDYNAMICPIVOT_SCP0010_STD, INSERT:#TBLDYNAMICPIVOT_SCP0010_VALUE_2, SELECT:SCM_DNM_EXFACTORY_RESULT, REF:FN_GET_DIVISION_DIV, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:#TBLDYNAMICPIVOT_SCP0010_VALUE_2, CREATE:#TBLDYNAMICPIVOT_SCP0010_DATA, INSERT:#TBLDYNAMICPIVOT_SCP0010_DATA, SELECT:#TBLDYNAMICPIVOT_SCP0010_VALUE_1, INSERT:#TBLDYNAMICPIVOT_SCP0010_01, SELECT:#TBLDYNAMICPIVOT_SCP0010_DATA, INSERT:#BOH_E, SELECT:SCP_PLN_PLANT_ONHAND, INSERT:#BOH_A, INSERT:#ESS_TYPE_INFO, SELECT:SCM_MST_SITE, SELECT:ESS_TYPE_INFO, DYNAMIC@SCP0010_GET_SHIPMENT_PLAN_SEMI, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_MODELING, SELECT:SCM_MST_PLAN, SELECT:SCP_PLAN_VERSION_V, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCM_MST_DIVISION |  |
| SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | 1 | SP SCP0011_GET_LAST_PLAN_VERSION | EXEC:SCP0011_GET_LAST_PLAN_VERSION, REF:FN_GET_SCP_LAST_PLAN_VERSION_ID, REF:FN_SCM_SPLIT, SELECT:SCP_PLAN_VERSION_V |  |
| SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | 1 | SP SCP0013_GET_PLAN_TYPE_SAVE_YN | EXEC:SCP0013_GET_PLAN_TYPE_SAVE_YN, SELECT:SCM_MST_MODELING, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_PLAN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP\Analysis\SCP0010_Shipment_Plan_SEMI#SaveShipmentPlanSemiDataset | MATCH_PATTERN | 1 | SP SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET | EXEC:SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET, CREATE:#TBLDYNAMIC_SCP0010, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, INSERT:#JV_ESS_SCM_SITE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP, INSERT:#DIVISION_LAST_PLAN_INFO, SELECT:SCP_PLAN_INFO, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_DIVISION, INSERT:#BOD_ITEM, SELECT:BOD_ITEM, SELECT:SCP_MST_BOD, SELECT:SCP_MST_BOD_ITEM, SELECT:#JV_ESS_SCM_SITE_MAP, SELECT:#DIVISION_LAST_PLAN_INFO, SELECT:#BOD_ITEM, REF:FN_MULTY_TIME, INSERT:#TBLDYNAMIC_SCP0010, SELECT:#TBLDYNAMIC_SCP0010, UPDATE:A, SELECT:SCP_ANL_SHIPMENT_PLAN_SEMI, UPDATE:B, INSERT:SCP_ANL_SHIPMENT_PLAN_SEMI, DELETE:A, SELECT:SCP_ANL_SHIPMENT_PLAN_FIX, EXEC:PR_SCP_ANL_SHIPMENT_PLAN_SEMI_FIX_HIST_DATASET, EXEC:PR_SCP_ANL_SHIPMENT_PLAN_SEMI_HIST_DATASET, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_SITE, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:SCP_ANL_SHIPMENT_PLAN_FIX_H, INSERT:SCP_ANL_SHIPMENT_PLAN_SEMI_H, SELECT:CTE_DATE |  |
| SCP\Analysis\SCP0010_Shipment_Plan_SEMI#SaveShipmentPlanSemiFix | MATCH_PATTERN | 1 | SP SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET | EXEC:SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET, CREATE:#TBLDYNAMIC_SCP0010FIX, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#JV_ESS_SCM_SITE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP, INSERT:#DIVISION_LAST_PLAN_INFO, SELECT:SCP_PLAN_INFO, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_DIVISION, INSERT:#BOD_ITEM, SELECT:BOD_ITEM, SELECT:SCP_MST_BOD, SELECT:SCP_MST_BOD_ITEM, SELECT:#JV_ESS_SCM_SITE_MAP, SELECT:SCM_MST_BUCKET, SELECT:#DIVISION_LAST_PLAN_INFO, SELECT:#BOD_ITEM, INSERT:#TBLDYNAMIC_SCP0010FIX, SELECT:#TBLDYNAMIC_SCP0010FIX, UPDATE:#TBLDYNAMIC_SCP0010FIX, UPDATE:B, SELECT:SCP_ANL_SHIPMENT_PLAN_FIX, INSERT:SCP_ANL_SHIPMENT_PLAN_FIX, UPDATE:A, EXEC:PR_SCP_ANL_SHIPMENT_PLAN_SEMI_FIX_HIST_DATASET, DELETE:A, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_SITE, INSERT:SCP_ANL_SHIPMENT_PLAN_FIX_H |  |
| SCP\Analysis\SCP0010_Shipment_Plan_SEMI#SaveShipmentPlanSemiWeekly | MATCH_PATTERN | 1 | SP SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_WEEKLY | EXEC:SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_WEEKLY, CREATE:#TBLDYNAMIC_SCP0010, CREATE:#LAST_INFO_TABLE, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, INSERT:#JV_ESS_SCM_SITE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP, INSERT:#DIVISION_LAST_PLAN_INFO, SELECT:SCP_PLAN_INFO, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_DIVISION, INSERT:#BOD_ITEM, SELECT:BOD_ITEM, SELECT:SCP_MST_BOD, SELECT:SCP_MST_BOD_ITEM, SELECT:#JV_ESS_SCM_SITE_MAP, SELECT:#DIVISION_LAST_PLAN_INFO, SELECT:#BOD_ITEM, REF:FN_MULTY_TIME, INSERT:#TBLDYNAMIC_SCP0010, SELECT:#TBLDYNAMIC_SCP0010, UPDATE:A, SELECT:SCP_ANL_SHIPMENT_PLAN_SEMI, UPDATE:B, INSERT:SCP_ANL_SHIPMENT_PLAN_SEMI, DELETE:A, SELECT:SCP_ANL_SHIPMENT_PLAN_FIX, EXEC:PR_SCP_ANL_SHIPMENT_PLAN_SEMI_FIX_HIST_DATASET, EXEC:PR_SCP_ANL_SHIPMENT_PLAN_SEMI_HIST_DATASET, INSERT:#SHIPMENT_EXIST_DATA, SELECT:SCP_MST_BOD_N_V, INSERT:#SHIPMENT_EXIST_INFO, SELECT:#SHIPMENT_EXIST_DATA, SELECT:SCM_SYS_CALENDAR_M, SELECT:#SHIPMENT_EXIST_INFO, SELECT:SCP_MST_SHIPMENT_LOT_SIZE, UPDATE:#SHIPMENT_EXIST_INFO, DYNAMIC@SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_WEEKLY, SELECT:#LAST_INFO_TABLE, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_SITE, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:SCP_ANL_SHIPMENT_PLAN_FIX_H, INSERT:SCP_ANL_SHIPMENT_PLAN_SEMI_H, SELECT:CTE_DATE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| CalculateSum | dr | measure |
| FindData_Main | dsBinding.Tables[1].Rows[0] | plan_start_date |
| GetIsEditable | dtEditable.Rows[0] | is_editable |
| GetIsEditable | dr | PLAN_STATUS |
| GetIsEditable | founded[0] | confirm_yn |
| GetLastPlanVersion | dsBinding.Tables[0].Rows[0] | PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ |
| InsertRow | dtCaller.Rows[0] | ELECTRODE_TYPE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID |
| SaveData_FixInfo | dr | p_active_flag, p_division_id, p_biz_type, p_item_id, p_to_site, p_from_site, p_bod_id, p_yyyymmdd, p_qty, p_origin_from_division_id, p_origin_to_division_id, p_electrode_type, p_fix_reason, p_created_by, p_last_updated_by, p_time_zone, debug_mode |
| SaveData_FixInfo | result.Rows[0] | result_code, result_cnt, err_message |
| SaveData_Main | dr | A, p_active_flag, p_division_id, p_plan_start_yyyymmdd, p_plan_type, p_seq, p_operation_group, p_item_id, p_from_site, p_bod_id, p_measure, p_yyyymmdd, p_to_site, p_qty, p_origin_from_division_id, p_origin_to_division_id, p_electrode_type, p_created_by, p_last_updated_by, p_time_zone, p_biz_type, p_bucket_type, p_trans_mode, debug_mode |
| SaveData_Main | dRow | A, p_active_flag, p_division_id, p_plan_start_yyyymmdd, p_plan_type, p_seq, p_operation_group, p_biz_type, p_item_id, p_from_site, p_bod_id, p_measure, p_yyyymmdd, p_to_site, p_qty, p_origin_from_division_id, p_origin_to_division_id, p_electrode_type, p_bucket_type, p_created_by, p_last_updated_by, p_time_zone, p_trans_mode, debug_mode |
| SaveData_Main | saveDS.Tables[0].Rows[0] | p_first_row |
| SaveData_Main | saveDS.Tables[0].Rows[iCount - 1] | p_last_row |
| SaveData_Main | result.Rows[0] | result_code, result_cnt, err_message |
| Set_FixButtonEnabled | a | CODE |
| Set_FixCellColor | dr | yyyymmdd |
| Set_SumValues | dsBinding.Tables[0].Columns | measure |
| SetCalcMeasure | dtBinding.Columns | BOH, TO_SITE, MEASURE |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | _division:295, _operationGroup:302, _planDate:309, _planType:316, InitControls:351, InitSpread_2:376, GetLastPlanVersion:823, FindData_Main:998 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread_2:379, InitSpread:459 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread_2:381 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread_2:383, InitSpread:462 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:577 |
| this | Load | Form_Load | .ctor:229 |
| dsdm | Changed | spdMain_Changed | InitEvent:555 |
| this.btnItem_Id | Click | BtnItem_Id_Click | InitEvent:557 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:558 |
| this.chkSum | CheckedChanged | ChkSum_CheckedChanged | InitEvent:559 |
| this.cboBucketType | SelectedIndexChanged | CboBucketType_SelectedIndexChanged | InitEvent:560 |
| this.cboOperGroup | SelectedIndexChanged | cboOperGrp_SelectedIndexChanged | InitEvent:561 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:563 |
| this.spdMain | CellClick | spdMain_CellClick | InitEvent:564 |
| this.spdMain | KeyUp | SpdMain_KeyUp | InitEvent:565 |
| this.btnFix | Click | BtnFix_Click | InitEvent:568 |
| this.btnUnfix | Click | BtnUnfix_Click | InitEvent:569 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:571 |
| cboOperGroup | SelectedIndexChanged | CboOperGroup_SelectedIndexChanged | InitEvent:572 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:573 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:574 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:575 |
| this.btnNew | Click | BtnNew_Click | InitEvent:578 |
| this.btnW26 | Click | BtnW26_Click | InitEvent:580 |
| this.btnW52 | Click | BtnW52_Click | InitEvent:581 |
| this.btnWLast | Click | BtnWLast_Click | InitEvent:582 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:825 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:826 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:827 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:864 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:865 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:866 |

## 6. 컨트롤 (53개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 21 | lblCombo1, layoutControlItem1, layoutControlItem7, layoutControlItem5, lblBucket, PlanDate, PlanType, SEQ, lblItemId, layoutControlItem4, layoutControlItem2, layoutControlItem8, layoutControlItem3, layoutControlItem10, lblToSite … |
| UsrButton | 9 | usrButton1, btnWLast, btnW52, btnW26, btnUnfix, btnFix, btnMeasure, btnItem_Id, btnNew |
| UsrCombo | 6 | cboOperGroup, cboDivision, cboBucketType, cboPlanDate, cboPlanType, cboPlanSeq |
| EmptySpaceItem | 5 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem4, emptySpaceItem5 |
| UsrCheckedList | 3 | clbFromSite, clbElecType, clbToSite |
| UsrCheckBox | 2 | chkSum, chkAll |
| UsrConditionPanel | 1 | pnlCondition |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker3 | 1 | dCalendar |
| UsrMultiLineEditor | 1 | txtItemId |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SheetView | 1 | spdMain_Sheet1 |
| FpSpread | 1 | spdMain |

## 7. 확인 필요 (3건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 2911 | SaveData_Main | {?definition_path}#SaveShipmentPlanSemiWeekly | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2915 | SaveData_Main | {?definition_path}#SaveShipmentPlanSemiDataset | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 4254 | SaveData_FixInfo | {?definition_path}#SaveShipmentPlanSemiFix | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 237 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 27 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 13 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 13 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 58 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 360 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (6건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 2959 |  | commented:EMPTY |
| 3015 | SCP.SCM0001_GET_SCP_DAY_PERIOD | commented:MATCH |
| 4304 | SCP.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX | commented:MATCH |
| 4629 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |
| 4640 | SCP.SCM0001_GET_SCP_PERIOD | commented:MATCH |
| 4639 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0010 | Shipment Plan SEMI | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 |
| SCM_MST_SHEET_MEASURE | SCP0010 | CELL | 3/2 | 3/2 | 3/2 | 3/2 | 3/2 | 3/2 | 3/2 | 3/2 | 3/2 | 3/2 | 3/2 | 3/2 | 3/2 | 3/2 |
| SCM_MST_SHEET_MEASURE | SCP0010 | ELECTRODE | 6/2 | 6/2 | 6/2 | 6/2 | 6/2 | 6/2 | 6/2 | 6/2 | 6/2 | 6/2 | 6/2 | 6/2 | 6/2 | 6/2 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Plan SEMI
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread_2:381
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread_2 | Shipment Plan SEMI | 385 | 표시/라벨 변경 | set:Font | Font = {?new Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold)} | T0_SITE_DESCRIPTION |  |
| InitSpread_2 | Shipment Plan SEMI | 386 | 표시/라벨 변경 | set:Font | Font = {?new Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold)} | transport_mode |  |
| InitSpread_2 | Shipment Plan SEMI | 393 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Plan SEMI | 394 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_FROM_DIVISION_ID | if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Plan SEMI | 395 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_TO_DIVISION_ID | if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Plan SEMI | 399 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Plan SEMI | 400 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_FROM_DIVISION_ID | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Plan SEMI | 401 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_TO_DIVISION_ID | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread | Shipment Plan SEMI | 410 | 하드코딩 | AddTextColumn | KEY_IDX | key_idx |  |
| InitSpread | Shipment Plan SEMI | 411 | 하드코딩 | AddTextColumn | Division | division_id |  |
| InitSpread | Shipment Plan SEMI | 412 | 하드코딩 | AddTextColumn | Operation Group | OPERATION_GROUP_DESC |  |
| InitSpread | Shipment Plan SEMI | 413 | 하드코딩 | AddTextColumn | Model | item_id |  |
| InitSpread | Shipment Plan SEMI | 414 | 하드코딩 | AddTextColumn | Nick Name | nick_name |  |
| InitSpread | Shipment Plan SEMI | 416 | 하드코딩 | AddTextColumn | From Site | FROM_SITE_DESCRIPTION |  |
| InitSpread | Shipment Plan SEMI | 417 | 하드코딩 | AddNumColumn | BOH (From Site) | boh |  |
| InitSpread | Shipment Plan SEMI | 418 | 하드코딩 | AddTextColumn | To Site | T0_SITE_DESCRIPTION |  |
| InitSpread | Shipment Plan SEMI | 419 | 하드코딩 | AddTextColumn | Trans Mode | transport_mode |  |
| InitSpread | Shipment Plan SEMI | 420 | 하드코딩 | AddTextColumn | L/T(Day) | lt_day |  |
| InitSpread | Shipment Plan SEMI | 422 | 하드코딩 | AddTextColumn | Measure | measure_label |  |
| InitSpread | Shipment Plan SEMI | 423 | 하드코딩 | AddTextColumn | Measure | measure |  |
| InitSpread | Shipment Plan SEMI | 424 | 하드코딩 | AddTextColumn | Division Name | division_name |  |
| InitSpread | Shipment Plan SEMI | 425 | 하드코딩 | AddTextColumn | Operation Group | operation_group |  |
| InitSpread | Shipment Plan SEMI | 426 | 하드코딩 | AddTextColumn | from_site | from_site |  |
| InitSpread | Shipment Plan SEMI | 428 | 하드코딩 | AddTextColumn | to_site | to_site |  |
| InitSpread | Shipment Plan SEMI | 429 | 하드코딩 | AddTextColumn | BOD ID | bod_id |  |
| InitSpread | Shipment Plan SEMI | 430 | 하드코딩 | AddTextColumn | MEASURE_ORDER_NO | measure_order_no |  |
| InitSpread | Shipment Plan SEMI | 431 | 하드코딩 | AddDateColumn | SHIP_FROZEN | SHIP_FROZEN |  |
| InitSpread | Shipment Plan SEMI | 432 | 하드코딩 | AddTextColumn | from_yyyymmdd | from_yyyymmdd |  |
| InitSpread | Shipment Plan SEMI | 434 | 하드코딩 | AddTextColumn | to_yyyymmdd | to_yyyymmdd |  |
| InitSpreadDateColumn |  | 502 | DB루프 | AddTextColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 507 | DB루프 | AddNumColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 512 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 658 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 663 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 670 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 674 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 679 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 686 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 690 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 1319 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1320 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1321 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1322 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Plan SEMI | META+코드연결 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 24 | 24 | 24 | 24 | 24 | 24 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
