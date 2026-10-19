# SCP0057 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0057_ProductionPlanLine_JV\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0057_ProductionPlanLine_JV\SCP0057_ProductionPlanLine_JV.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0057_ProductionPlanLine_JV\SCP0057_ProductionPlanLine_JV.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0057_ProductionPlanLine_JV\SCP0057_ProductionPlanLine_JV.csproj | 3492 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0057_ProductionPlanLine_JV\SCP0057_ProductionPlanLine_JV.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0057_ProductionPlanLine_JV\SCP0057_ProductionPlanLine_JV.csproj | 1666 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnNew.Click | BtnNew_Click > FindData_Main | 1799 | SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY |
| event:btnNew.Click | BtnNew_Click > Get_IsEditInfo | 2791 | SCP.SCP0013_GET_PLAN_EDIT_INFO | MATCH | SP SCP0013_GET_PLAN_EDIT_INFO |
| event:btnNew.Click | BtnNew_Click > Get_IsSaveYn | 2839 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| event:btnNew.Click | BtnNew_Click > FindData_Main > InitSpread > GetSpdTitle | 3404 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:btnW26.Click | BtnW26_Click > GetDayRange | 3434 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:btnW52.Click | BtnW52_Click > GetDayRange | 3434 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:btnWLast.Click | BtnWLast_Click > GetDayRange | 3434 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1589 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1593 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1610 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1615 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1620 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > GetLastRange | 3419 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| event:cboOperationGroup.SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | 3274 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboOperationGroup.SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | 3275 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 3304 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > Set_FixButtonEnabled > InitSpread > GetSpdTitle | 3404 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 3434 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:cboPlanSeq.SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged > Set_FixButtonEnabled > InitSpread > GetSpdTitle | 3404 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 3325 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged > Set_FixButtonEnabled > InitSpread > GetSpdTitle | 3404 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:FindButton | FindButton > FindData_Main | 1799 | SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY |
| button:FindButton | FindButton > Get_IsEditInfo | 2791 | SCP.SCP0013_GET_PLAN_EDIT_INFO | MATCH | SP SCP0013_GET_PLAN_EDIT_INFO |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 3404 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Line_DT > FindData_Main | 1799 | SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY |
| button:SaveButton | SaveButton > SaveData_Line_DT | 2133 | biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData_Line_DT | 2133 | {?definition_path}#dbo.SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET | UNRESOLVED |  |
| button:SaveButton | SaveButton > SaveData_Line_DT > Get_IsSaveYn | 2839 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| button:SaveButton | SaveButton > SaveData_Line_DT > SCM_SYS_LOG_BATCH | 3074 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| button:SaveButton | SaveButton > SaveData_Line_DT > FindData_Main > InitSpread > GetSpdTitle | 3404 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo > FindData_Main | 1799 | SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo | 2604 | biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET] | BIZ_MATCH |  |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo | 2604 | {?definition_path}#dbo.SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET | UNRESOLVED |  |
| event:this.btnFix.Click | btnFix_Click > Get_IsSaveYn | 2839 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo > SCM_SYS_LOG_BATCH | 3074 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo > FindData_Main > InitSpread > GetSpdTitle | 3404 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | BtnMeasure_Click > InitSpread > GetSpdTitle | 3404 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo > FindData_Main | 1799 | SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo | 2604 | biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET] | BIZ_MATCH |  |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo | 2604 | {?definition_path}#dbo.SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET | UNRESOLVED |  |
| event:this.btnUnfix.Click | btnUnfix_Click > Get_IsSaveYn | 2839 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo > SCM_SYS_LOG_BATCH | 3074 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo > FindData_Main > InitSpread > GetSpdTitle | 3404 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 3404 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.chkAll.CheckedChanged | ChkAll_CheckedChanged > InitSpread > GetSpdTitle | 3404 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1522 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > FindData_Division > SetChangedControl | 1589 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData_Division > SetChangedControl | 1593 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData_Division > SetChangedControl | 1610 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData_Division > SetChangedControl | 1615 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData_Division > SetChangedControl | 1620 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:this.Load | Form_Load > GetSpdTitle2 | 3124 | SCM.SCM_SYS_GET_SPREAD_TITLE | MATCH | SP SCM_SYS_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 3404 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetLastRange | 3419 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| event:this.Load | Form_Load > InitControls > GetDayRange | 3434 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.Load | Form_Load > FindData_Division | 3465 | SystemManager.UP_FX_GetUserGroupAuthExtentionList | MATCH | SP UP_FX_GetUserGroupAuthExtentionList |
| unreached:(진입점 미연결) | <field:dtElectrodeType> | 64 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedControlPart | 1657 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedControlPart | 1658 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetLastPlanVersion | 1686 | SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | SP SCP0011_GET_LAST_PLAN_VERSION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?definition_path}#dbo.SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET | UNRESOLVED | 1 |  |  |  |
| {?definition_path}#dbo.SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET | UNRESOLVED | 1 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET] | BIZ_MATCH | 1 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:REF:FN_CHAR_TO_DATE, UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH | 6 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM_SYS_GET_SPREAD_TITLE | MATCH | 1 | SP SCM_SYS_GET_SPREAD_TITLE | EXEC:SCM_SYS_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD | EXEC:SCM0001_GET_SCP_DAILY_PLAN_PERIOD, SELECT:SCM_MST_DIVISION |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | 1 | SP SCP0011_GET_LAST_PLAN_VERSION | EXEC:SCP0011_GET_LAST_PLAN_VERSION, REF:FN_GET_SCP_LAST_PLAN_VERSION_ID, REF:FN_SCM_SPLIT, SELECT:SCP_PLAN_VERSION_V |  |
| SCP.SCP0013_GET_PLAN_EDIT_INFO | MATCH | 1 | SP SCP0013_GET_PLAN_EDIT_INFO | EXEC:SCP0013_GET_PLAN_EDIT_INFO, REF:FN_ZERO_LPAD, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_MODELING, REF:FN_GET_BUCKET_YYYYMMDD, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_SITE, REF:FN_GET_DIVISION_DIV, REF:FN_SPLITSTRING, REF:FN_DATE_TO_CHAR, REF:FN_GET_START_YYYYMMDD, SELECT:SCM_MST_DIVISION |  |
| SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | 1 | SP SCP0013_GET_PLAN_TYPE_SAVE_YN | EXEC:SCP0013_GET_PLAN_TYPE_SAVE_YN, SELECT:SCM_MST_MODELING, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_PLAN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | 1 | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY | EXEC:SCP0013_GET_PRODUCTION_PLAN_LINEBY, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_NEXT_DAY, CREATE:#TBLDYNAMICPIVOT_SCP0013_PLANTLINE_BY_SEARCH, CREATE:#TBLDYNAMICPIVOT_SCP0013_PLANTLINE_BY_TT, INSERT:#JV_ESS_MAP, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_SITE, INSERT:#TBLDYNAMICPIVOT_SCP0013_PLANTLINE_BY_SEARCH, SELECT:SCP_ANL_PRODUCTION_PLAN, REF:FN_GET_ITEM_LIKE_CONDITION, SELECT:SCM_DNM_PRODUCT_RESULT_V, REF:FN_GET_DIVISION_DIV, SELECT:#JV_ESS_MAP, SELECT:HIST_SCP_ANL_PRODUCTION_PLAN, INSERT:#TBLDYNAMICPIVOT_SCP0013_PLANTLINE_BY_TT, SELECT:SCP_MST_TACT_TIME, SELECT:SCP_MST_FINAL_ITEM_V, SELECT:SCM_MST_VENDOR, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCP_MST_OUTSOURCING_CAPA, SELECT:SCP_MST_TACT_TIME_OSP, SELECT:SCM_MST_LINE_OSP, CREATE:#TBLDYNAMICPIVOT_SCP0013_TMP, INSERT:#TBLDYNAMICPIVOT_SCP0013_TMP, SELECT:SCP_MST_FINAL_ITEM, REF:STRING_SPLIT, SELECT:#TBLDYNAMICPIVOT_SCP0013_TMP, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:SCM_MST_ITEM_SN, SELECT:SCP_MST_ITEM_CELL_CF, SELECT:SCM_MST_ITEM_CONV_CALC_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, CREATE:#TBLDYNAMICPIVOT_SCP0013_KEY, INSERT:#TBLDYNAMICPIVOT_SCP0013_KEY, SELECT:#TBLDYNAMICPIVOT_SCP0013_KEY, INSERT:#TBLDYNAMICPIVOT_SCP0013_WORKING_DATA, REF:FN_LINE_WORKINGTIME_BY_LOSS, INSERT:#TBLDYNAMICPIVOT_SCP0013_LOAD, SELECT:#TBLDYNAMICPIVOT_SCP0013_WORKING_DATA, SELECT:SCP_ANL_TACT_TIME, SELECT:SCP_ANL_WORKING_TIME, INSERT:#ISUZU_SCP0013, SELECT:SCM_MST_FINAL_ITEM_V, CREATE:#TBLDYNAMICPIVOT_SCP0013_PERFOR, INSERT:#TBLDYNAMICPIVOT_SCP0013_PERFOR, SELECT:#ISUZU_SCP0013, INSERT:#TBLDYNAMICPIVOT_SCP0013_PERFOR_ESS_JV, UPDATE:A, SELECT:#TBLDYNAMICPIVOT_SCP0013_PERFOR_ESS_JV, INSERT:#TBLDYNAMICPIVOT_SCP0013_PLAN, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#TBLDYNAMICPIVOT_SCP0013, SELECT:SCM_MST_BOM_SN, SELECT:SCM_MST_ITEM_CLASS_M, SELECT:#TBLDYNAMICPIVOT_SCP0013_PLAN, SELECT:#TBLDYNAMICPIVOT_SCP0013_PERFOR |  |
| SystemManager.UP_FX_GetUserGroupAuthExtentionList | MATCH | 1 | SP UP_FX_GetUserGroupAuthExtentionList | EXEC:UP_FX_GETUSERGROUPAUTHEXTENTIONLIST, SELECT:SCM_MST_DIVISION, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_VENDOR, SELECT:SCM_MST_SITE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| CalculateSum | dr | measure |
| CalculateSum | dtTitle.Rows[nCol] | COLUMN_NAME |
| EditButton | drs[0] | osp_yn, fp_plan_period, offset, edit_start_date, confirm_yn, date_chk, is_editable, plan_start_yyyymmdd, plan_type, plan_seq, new_edit_mode |
| EditButton | dtPlanType.Rows[dtPlanType.Rows.Count - 1] | CODE |
| EditButton | dtPlanSeq.Rows[0] | CODE |
| FindButton | clbPlantSite.DataSource.Rows[i] | CODE |
| FindData_Division | ds.Tables[0].Rows[i] | Code, JV_PLANT_ID |
| GetLastPlanVersion | dsBinding.Tables[0].Rows[0] | PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ |
| SaveData_FixInfo | dr | p_active_flag, p_division_id, p_plan_start_yyyymmdd, p_plan_type, p_seq, p_operation_group, p_scm_site_id, p_line_id, p_item_id, p_operation_id, p_yyyymmdd, p_qty, p_fix_reason, p_origin_division_id, p_electrode_type, p_user_id, p_bucket_type |
| SaveData_FixInfo | result.Rows[0] | result_code, result_cnt, err_message |
| SaveData_Line_DT | dr | A, p_active_flag, p_division_id, p_plan_start_yyyymmdd, p_plan_type, p_seq, p_operation_group, p_scm_site_id, p_item_id, p_line_id, p_operation_id, p_measure, p_origin_division_id, p_electrode_type, p_yyyymmdd, p_qty, p_fix, p_loc_flag, p_user_id, p_bucket_type, p_from_yyyymmdd, p_to_yyyymmdd, p_program_id, debug_mode |
| SaveData_Line_DT | dsInput.Tables[0].Rows[0] | p_loc_flag |
| SaveData_Line_DT | dsInput.Tables[0].Rows[nRowCnt - 1] | p_loc_flag |
| SaveData_Line_DT | result.Rows[0] | result_code, err_code, err_message |
| Set_FixButtonEnabled | dtPlanSeq.Rows[0] | CODE |
| Set_FixCellColor | row | division_id, operation_group, scm_site_id, item_id, line_id, operation_id, origin_division_id, electrode_type, FIX_KEY |
| Set_FixCellColor | dr | FIX_KEY, YYYYMMDD, basis_yyyymm, iso_week |
| Set_FPOperationColor | drs[0] | osp_yn, fp_plan_period, offset, edit_start_date, confirm_yn, date_chk, is_editable, plan_start_yyyymmdd, plan_type, plan_seq, new_edit_mode |
| Set_FPOperationColor | dtPlanType.Rows[dtPlanType.Rows.Count - 1] | CODE |
| Set_FPOperationColor | dtPlanSeq.Rows[0] | CODE |
| SetFormationYield | dr | measure |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:257, InitSpread:281, BtnLoad_Click:798, BtnLoad_Click:811, BtnLoad_Click:812, BtnLoad_Click:813, BtnLoad_Click:815, BtnLoad_Click:818 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:284 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:290 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:292 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnUnfix | Click | btnUnfix_Click | InitializeComponent:510 |
| this.btnFix | Click | btnFix_Click | InitializeComponent:548 |
| this | Load | Form_Load | .ctor:183 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:408 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:410 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:411 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:414 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:415 |
| this.chkAll | CheckedChanged | ChkAll_CheckedChanged | InitEvent:416 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:417 |
| cboOperationGroup | SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | InitEvent:420 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:422 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:423 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:424 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:425 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:426 |
| btnNew | Click | BtnNew_Click | InitEvent:428 |
| this.btnMeasure | Click | BtnMeasure_Click | InitEvent:430 |
| this.spdMain | ClipboardPasting | SpdMain_ClipboardPasting | InitEvent:432 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:433 |
| btnLoad | Click | BtnLoad_Click | InitEvent:435 |
| btnW26 | Click | BtnW26_Click | InitEvent:437 |
| btnW52 | Click | BtnW52_Click | InitEvent:438 |
| btnWLast | Click | BtnWLast_Click | InitEvent:439 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:1050 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:1210 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:1218 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:1334 |
| dsdmLine | Changed | SpdMain_Changed | CalculateDailyQty:1343 |
| dsdmLine | Changed | SpdMain_Changed | CalculateDailyQty:1391 |
| dsdmLine | Changed | SpdMain_Changed | CalculateDailyQty:1431 |
| dsdmLine | Changed | SpdMain_Changed | CalculateDailyQty2:1452 |
| dsdmLine | Changed | SpdMain_Changed | CalculateDailyQty2:1509 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:1676 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:1677 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:1678 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:1723 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:1724 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:1725 |
| dsdmLine | Changed | SpdMain_Changed | FindData_Main:1743 |
| dsdmLine | Changed | SpdMain_Changed | FindData_Main:1880 |

## 6. 컨트롤 (58개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 25 | PlanType, PlanDate, Division, layoutControlItem1, layoutControlItem6, lblBucket, layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem9, layoutControlItem11, layoutControlItem12, layoutControlItem13, layoutControlItem14, layoutControlItem10 … |
| UsrButton | 10 | usrButton1, btnWLast, btnW52, btnW26, btnLoad, btnUnfix, btnFix, btnItemId, btnNew, btnMeasure |
| UsrCombo | 6 | cboOperationGroup, cboDivision, cboPlanSeq, cboPlanDate, cboPlanType, cboBucketType |
| UsrCheckBox | 3 | chkAll, chkSum, chkLineAssign |
| UsrCheckedList2 | 2 | clbLine, clbPlantSite |
| UsrCheckedList | 2 | cboElectrode, cboCellTypeGr |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrMultiLineEditor | 1 | txtItemId |
| UsrDateRangePicker | 1 | drpPeriod |
| TextBox | 1 | txtNickName |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (2건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 2133 | SaveData_Line_DT | {?definition_path}#dbo.SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |
| 2604 | SaveData_FixInfo | {?definition_path}#dbo.SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 24 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 5 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (2건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 2185 |  | commented:EMPTY |
| 2692 | SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0057 | Line | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |
| SCM_MST_SHEET_MEASURE | SCP0057 | LINE | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 168건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Line
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:290
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Line | 300 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Line") ⟫ if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread | Line | 301 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Line") ⟫ if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread | Line | 304 | 표시/라벨 변경 | set:Visible | Visible = {?true} | CELL_TYPE_GROUP_CODE | if(spdInfo.SheetName == "Line") ⟫ if(!division.Substring(0, 2).Equals("EE")) ⟫ if(division == "40") |
| InitSpread | Line | 306 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CELL_TYPE_GROUP_CODE | if(spdInfo.SheetName == "Line") ⟫ if(!division.Substring(0, 2).Equals("EE")) ⟫ else!(division == "40") |
| InitSpread | Line | 311 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Line") ⟫ else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread | Line | 312 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Line") ⟫ else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread | Line | 313 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CELL_TYPE_GROUP_CODE | if(spdInfo.SheetName == "Line") ⟫ else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread | Line | 316 | 표시/라벨 변경 | set:Visible | Visible = {?(division == "40")} | EXTRA_SPEC | if(spdInfo.SheetName == "Line") |
| InitSpreadDateColumn |  | 355 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 359 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 364 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 1007 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1012 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1019 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1023 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1028 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1035 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1039 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 1529 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1530 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1531 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1532 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Line | META+코드연결 | 10 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 10 | 10 | 10 | 10 | 10 | 10 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
