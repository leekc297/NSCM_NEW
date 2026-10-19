# SCP0013 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| shared | 06.UIL\GSCM.SCM.Popup.UIL\SCP0013_ProductionPlanLineLoadPopup.cs | 06.UIL\GSCM.SCM.Popup.UIL\GSCM.SCM.Popup.UIL.csproj | 580 |
| shared | 06.UIL\GSCM.SCM.Popup.UIL\SCP0013_ProductionPlanLineLoadPopup.Designer.cs | 06.UIL\GSCM.SCM.Popup.UIL\GSCM.SCM.Popup.UIL.csproj | 291 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0013_ProductionPlanLine\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0013_ProductionPlanLine\SCP0013_ProductionPlanLine.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0013_ProductionPlanLine\SCP0013_ProductionPlanLine.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0013_ProductionPlanLine\SCP0013_ProductionPlanLine.csproj | 4172 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0013_ProductionPlanLine\SCP0013_ProductionPlanLine.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0013_ProductionPlanLine\SCP0013_ProductionPlanLine.csproj | 1812 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnNew.Click | BtnNew_Click > FindData_Main | 2051 | SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY |
| event:btnNew.Click | BtnNew_Click > Get_IsEditInfo | 3360 | SCP.SCP0013_GET_PLAN_EDIT_INFO | MATCH | SP SCP0013_GET_PLAN_EDIT_INFO |
| event:btnNew.Click | BtnNew_Click > Get_IsSaveYn | 3442 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| event:btnNew.Click | BtnNew_Click > FindData_Main > InitSpread > GetSpdTitle | 4061 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:btnW26.Click | BtnW26_Click > GetDayRange | 4116 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:btnW52.Click | BtnW52_Click > GetDayRange | 4116 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:btnWLast.Click | BtnWLast_Click > GetDayRange | 4116 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:cboCellTypeGr.SelectedIndexChanged | CboCellTypeGr_SelectedIndexChanged > GetLineList | 4152 | SCP.SCP0013_GET_LINE_LIST | MATCH | SP SCP0013_GET_LINE_LIST |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 4061 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > GetLastRange | 4101 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| event:cboOperationGroup.SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged > InitSpread > GetSpdTitle | 4061 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > Set_FixButtonEnabled > InitSpread > GetSpdTitle | 4061 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 4116 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:cboPlanSeq.SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged > Set_FixButtonEnabled > InitSpread > GetSpdTitle | 4061 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged > Set_FixButtonEnabled > InitSpread > GetSpdTitle | 4061 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:FindButton | FindButton > FindData_Main | 2051 | SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY |
| button:FindButton | FindButton > Get_IsEditInfo | 3360 | SCP.SCP0013_GET_PLAN_EDIT_INFO | MATCH | SP SCP0013_GET_PLAN_EDIT_INFO |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 4061 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Line_DT > FindData_Main | 2051 | SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY |
| button:SaveButton | SaveButton > SaveData_Line_DT | 2699 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveProductionPlanLine] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData_Line_DT | 2699 | SCP\Analysis\SCP0013_ProductionPlanLine#SaveProductionPlanLine | MATCH_PATTERN | SP SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET |
| button:SaveButton | SaveButton > SaveData_Line_DT > Get_IsSaveYn | 3442 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| button:SaveButton | SaveButton > SaveData_Line_DT > SCM_SYS_LOG_BATCH | 3693 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| button:SaveButton | SaveButton > SaveData_Line_DT > FindData_Main > InitSpread > GetSpdTitle | 4061 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindDataMain | 240 | SCM.SCP0013_PRODUCTION_PLAN_LINE_LOAD_POPUP | MATCH | SP SCP0013_PRODUCTION_PLAN_LINE_LOAD_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindDataMain > InitSpread > GetSpdTitle | 568 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo > FindData_Main | 2051 | SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo | 3170 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveProductionPlanFix] | BIZ_MATCH |  |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo | 3170 | SCP\Analysis\SCP0013_ProductionPlanLine#SaveProductionPlanFix\|SCP\Analysis\SCP0024_ProductionPlanFix#SaveProductionPlanFix | MATCH_PATTERN | SP SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET \| SP SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET |
| event:this.btnFix.Click | btnFix_Click > Get_IsSaveYn | 3442 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo > SCM_SYS_LOG_BATCH | 3693 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo > FindData_Main > InitSpread > GetSpdTitle | 4061 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | BtnMeasure_Click > InitSpread > GetSpdTitle | 4061 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo > FindData_Main | 2051 | SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo | 3170 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveProductionPlanFix] | BIZ_MATCH |  |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo | 3170 | SCP\Analysis\SCP0013_ProductionPlanLine#SaveProductionPlanFix\|SCP\Analysis\SCP0024_ProductionPlanFix#SaveProductionPlanFix | MATCH_PATTERN | SP SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET \| SP SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET |
| event:this.btnUnfix.Click | btnUnfix_Click > Get_IsSaveYn | 3442 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo > SCM_SYS_LOG_BATCH | 3693 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo > FindData_Main > InitSpread > GetSpdTitle | 4061 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 4061 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.chkAll.CheckedChanged | ChkAll_CheckedChanged > InitSpread > GetSpdTitle | 4061 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > FindDataMain | 240 | SCM.SCP0013_PRODUCTION_PLAN_LINE_LOAD_POPUP | MATCH | SP SCP0013_PRODUCTION_PLAN_LINE_LOAD_POPUP |
| event:this.Load | Form_Load > FindDataMain > InitSpread > GetSpdTitle | 568 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1760 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > GetSpdTitle2 | 3759 | SCM.SCM_SYS_GET_SPREAD_TITLE | MATCH | SP SCM_SYS_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 4061 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetLastRange | 4101 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| event:this.Load | Form_Load > InitControls > GetDayRange | 4116 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| unreached:(진입점 미연결) | <field:dtOperation> | 40 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtElectrodeType> | 77 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetExtraSpecAll | 469 | SCP.SCP0013_GET_EXTRA_SPEC | MATCH | SP SCP0013_GET_EXTRA_SPEC |
| unreached:(진입점 미연결) | GetLastPlanVersion | 1922 | SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | SP SCP0011_GET_LAST_PLAN_VERSION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveProductionPlanFix] | BIZ_MATCH | 1 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveProductionPlanLine] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM_SYS_GET_SPREAD_TITLE | MATCH | 1 | SP SCM_SYS_GET_SPREAD_TITLE | EXEC:SCM_SYS_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS |  |
| SCM.SCP0013_PRODUCTION_PLAN_LINE_LOAD_POPUP | MATCH | 1 | SP SCP0013_PRODUCTION_PLAN_LINE_LOAD_POPUP | EXEC:SCP0013_PRODUCTION_PLAN_LINE_LOAD_POPUP, CREATE:#TBLDYNAMICPIVOT_SCP0013_QTY, INSERT:#TBLDYNAMICPIVOT_SCP0013_BASE, SELECT:SCP_ANL_PRODUCTION_PLAN, REF:STRING_SPLIT, INSERT:#TBLDYNAMICPIVOT_SCP0013_QTY, SELECT:#TBLDYNAMICPIVOT_SCP0013_BASE, SELECT:SCM_MST_SITE, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCP_ANL_WORKING_TIME, SELECT:SCP_ANL_TACT_TIME, SELECT:#TBLDYNAMICPIVOT_SCP0013_QTY, INSERT:#TBLDYNAMICPIVOT_SCP0013_SUM, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@SCP0013_PRODUCTION_PLAN_LINE_LOAD_POPUP |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD | EXEC:SCM0001_GET_SCP_DAILY_PLAN_PERIOD, SELECT:SCM_MST_DIVISION |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 2 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | 1 | SP SCP0011_GET_LAST_PLAN_VERSION | EXEC:SCP0011_GET_LAST_PLAN_VERSION, REF:FN_GET_SCP_LAST_PLAN_VERSION_ID, REF:FN_SCM_SPLIT, SELECT:SCP_PLAN_VERSION_V |  |
| SCP.SCP0013_GET_EXTRA_SPEC | MATCH | 1 | SP SCP0013_GET_EXTRA_SPEC | EXEC:SCP0013_GET_EXTRA_SPEC, SELECT:SCM_MST_ITEM_SN |  |
| SCP.SCP0013_GET_LINE_LIST | MATCH | 1 | SP SCP0013_GET_LINE_LIST | EXEC:SCP0013_GET_LINE_LIST, INSERT:#TMP_LINE, SELECT:SCP_ANL_PRODUCTION_PLAN, SELECT:SCP_MST_FINAL_ITEM, REF:STRING_SPLIT, SELECT:#TMP_LINE, SELECT:SCM_MST_LINE_SN |  |
| SCP.SCP0013_GET_PLAN_EDIT_INFO | MATCH | 1 | SP SCP0013_GET_PLAN_EDIT_INFO | EXEC:SCP0013_GET_PLAN_EDIT_INFO, REF:FN_ZERO_LPAD, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_MODELING, REF:FN_GET_BUCKET_YYYYMMDD, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_SITE, REF:FN_GET_DIVISION_DIV, REF:FN_SPLITSTRING, REF:FN_DATE_TO_CHAR, REF:FN_GET_START_YYYYMMDD, SELECT:SCM_MST_DIVISION |  |
| SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | 1 | SP SCP0013_GET_PLAN_TYPE_SAVE_YN | EXEC:SCP0013_GET_PLAN_TYPE_SAVE_YN, SELECT:SCM_MST_MODELING, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_PLAN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | 1 | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY | EXEC:SCP0013_GET_PRODUCTION_PLAN_LINEBY, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_NEXT_DAY, CREATE:#TBLDYNAMICPIVOT_SCP0013_PLANTLINE_BY_SEARCH, CREATE:#TBLDYNAMICPIVOT_SCP0013_PLANTLINE_BY_TT, INSERT:#JV_ESS_MAP, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_SITE, INSERT:#TBLDYNAMICPIVOT_SCP0013_PLANTLINE_BY_SEARCH, SELECT:SCP_ANL_PRODUCTION_PLAN, REF:FN_GET_ITEM_LIKE_CONDITION, SELECT:SCM_DNM_PRODUCT_RESULT_V, REF:FN_GET_DIVISION_DIV, SELECT:#JV_ESS_MAP, SELECT:HIST_SCP_ANL_PRODUCTION_PLAN, INSERT:#TBLDYNAMICPIVOT_SCP0013_PLANTLINE_BY_TT, SELECT:SCP_MST_TACT_TIME, SELECT:SCP_MST_FINAL_ITEM_V, SELECT:SCM_MST_VENDOR, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCP_MST_OUTSOURCING_CAPA, SELECT:SCP_MST_TACT_TIME_OSP, SELECT:SCM_MST_LINE_OSP, CREATE:#TBLDYNAMICPIVOT_SCP0013_TMP, INSERT:#TBLDYNAMICPIVOT_SCP0013_TMP, SELECT:SCP_MST_FINAL_ITEM, REF:STRING_SPLIT, SELECT:#TBLDYNAMICPIVOT_SCP0013_TMP, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:SCM_MST_ITEM_SN, SELECT:SCP_MST_ITEM_CELL_CF, SELECT:SCM_MST_ITEM_CONV_CALC_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, CREATE:#TBLDYNAMICPIVOT_SCP0013_KEY, INSERT:#TBLDYNAMICPIVOT_SCP0013_KEY, SELECT:#TBLDYNAMICPIVOT_SCP0013_KEY, INSERT:#TBLDYNAMICPIVOT_SCP0013_WORKING_DATA, REF:FN_LINE_WORKINGTIME_BY_LOSS, INSERT:#TBLDYNAMICPIVOT_SCP0013_LOAD, SELECT:#TBLDYNAMICPIVOT_SCP0013_WORKING_DATA, SELECT:SCP_ANL_TACT_TIME, SELECT:SCP_ANL_WORKING_TIME, INSERT:#ISUZU_SCP0013, SELECT:SCM_MST_FINAL_ITEM_V, CREATE:#TBLDYNAMICPIVOT_SCP0013_PERFOR, INSERT:#TBLDYNAMICPIVOT_SCP0013_PERFOR, SELECT:#ISUZU_SCP0013, INSERT:#TBLDYNAMICPIVOT_SCP0013_PERFOR_ESS_JV, UPDATE:A, SELECT:#TBLDYNAMICPIVOT_SCP0013_PERFOR_ESS_JV, INSERT:#TBLDYNAMICPIVOT_SCP0013_PLAN, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#TBLDYNAMICPIVOT_SCP0013, SELECT:SCM_MST_BOM_SN, SELECT:SCM_MST_ITEM_CLASS_M, SELECT:#TBLDYNAMICPIVOT_SCP0013_PLAN, SELECT:#TBLDYNAMICPIVOT_SCP0013_PERFOR |  |
| SCP\Analysis\SCP0013_ProductionPlanLine#SaveProductionPlanFix\|SCP\Analysis\SCP0024_ProductionPlanFix#SaveProductionPlanFix | MATCH_PATTERN | 1 | SP SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET \| SP SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET | EXEC:SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET, CREATE:#TBLDYNAMIC_SCP0013FIX, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#JV_ESS_LINE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP, INSERT:#JV_ESS_SCM_SITE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP, INSERT:#DIVISION_LAST_PLAN_INFO, SELECT:SCP_PLAN_INFO, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_DIVISION, INSERT:#TBLDYNAMIC_SCP0013FIX, SELECT:#JV_ESS_SCM_SITE_MAP, SELECT:#JV_ESS_LINE_MAP, SELECT:#DIVISION_LAST_PLAN_INFO, UPDATE:X, SELECT:#TBLDYNAMIC_SCP0013FIX, SELECT:SCP_ANL_PRODUCTION_PLAN, UPDATE:#TBLDYNAMIC_SCP0013FIX, UPDATE:B, SELECT:SCP_ANL_PRODUCTION_PLAN_FIX, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX, UPDATE:A, EXEC:PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST_DATASET, DELETE:A, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_SITE, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX_H |  |
| SCP\Analysis\SCP0013_ProductionPlanLine#SaveProductionPlanLine | MATCH_PATTERN | 1 | SP SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET | EXEC:SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, CREATE:#TBLDYNAMIC_SCP0013, INSERT:#JV_ESS_LINE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP, INSERT:#JV_ESS_SCM_SITE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP, INSERT:#DIVISION_LAST_PLAN_INFO, SELECT:SCP_PLAN_INFO, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_DIVISION, SELECT:#JV_ESS_SCM_SITE_MAP, SELECT:#JV_ESS_LINE_MAP, SELECT:#DIVISION_LAST_PLAN_INFO, INSERT:#TBLDYNAMIC_SCP0013_TEMP, SELECT:CC, SELECT:DD, SELECT:BB, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TBLDYNAMIC_SCP0013, SELECT:#TBLDYNAMIC_SCP0013_TEMP, UPDATE:A, SELECT:SCP_ANL_PRODUCTION_PLAN, SELECT:#TBLDYNAMIC_SCP0013, EXEC:PR_SCP_ANL_PRODUCTION_PLAN_HIST_DATASET, SELECT:SCP_ANL_PRODUCTION_PLAN_FIX, EXEC:PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST_DATASET, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_SITE, INSERT:SCP_ANL_PRODUCTION_PLAN_H, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| CalculateSum | dr | measure |
| CalculateSum | dtTitle.Rows[nCol] | COLUMN_NAME |
| EditButton | drs[0] | osp_yn, fp_plan_period, offset, edit_start_date, confirm_yn, date_chk, is_editable, plan_start_yyyymmdd, plan_type, plan_seq, new_edit_mode |
| EditButton | dtPlanType.Rows[dtPlanType.Rows.Count - 1] | CODE |
| EditButton | dtPlanSeq.Rows[0] | CODE |
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
| Set_Ratio | row | DIVISION_ID, SCM_SITE_ID, OPERATION_ID, LINE_ID, MEASURE |
| Set_Ratio | row2 | MEASURE, DIVISION_ID, SCM_SITE_ID, OPERATION_ID, LINE_ID |
| SetFormationYield | dr | measure |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:169, InitSpread:325 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| InitSpreadDateColumn | InitSpread:171, InitSpread:333 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetCheckedListValue | InitControls:297, InitSpread:322, RefreshExtraSpec:484, btnItemId_Click:826, BtnLoad_Click:917, BtnLoad_Click:931, BtnLoad_Click:932, BtnLoad_Click:933 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:331 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:157 |
| this | Load | Form_Load | .ctor:99 |
| this.btnUnfix | Click | btnUnfix_Click | InitializeComponent:614 |
| this.btnFix | Click | btnFix_Click | InitializeComponent:652 |
| this | Load | Form_Load | .ctor:215 |
| dsdmLine | Changed | SpdMain_Changed | Form_Load:230 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:500 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:502 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:503 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:506 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:507 |
| this.chkAll | CheckedChanged | ChkAll_CheckedChanged | InitEvent:508 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:509 |
| cboOperationGroup | SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | InitEvent:512 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:514 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:515 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:516 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:517 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:518 |
| cboCellTypeGr | SelectedIndexChanged | CboCellTypeGr_SelectedIndexChanged | InitEvent:519 |
| btnNew | Click | BtnNew_Click | InitEvent:521 |
| this.btnMeasure | Click | BtnMeasure_Click | InitEvent:523 |
| this.spdMain | ClipboardPasting | SpdMain_ClipboardPasting | InitEvent:525 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:526 |
| btnLoad | Click | BtnLoad_Click | InitEvent:528 |
| btnW26 | Click | BtnW26_Click | InitEvent:530 |
| btnW52 | Click | BtnW52_Click | InitEvent:531 |
| btnWLast | Click | BtnWLast_Click | InitEvent:532 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:1269 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:1430 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:1438 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:1554 |
| dsdmLine | Changed | SpdMain_Changed | CalculateDailyQty:1563 |
| dsdmLine | Changed | SpdMain_Changed | CalculateDailyQty:1611 |
| dsdmLine | Changed | SpdMain_Changed | CalculateDailyQty:1669 |
| dsdmLine | Changed | SpdMain_Changed | CalculateDailyQty2:1690 |
| dsdmLine | Changed | SpdMain_Changed | CalculateDailyQty2:1747 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:1912 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:1913 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:1914 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:1959 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:1960 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:1961 |
| dsdmLine | Changed | SpdMain_Changed | FindData_Main:1976 |
| dsdmLine | Changed | SpdMain_Changed | FindData_Main:2139 |

## 6. 컨트롤 (74개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 28 | layoutControlItem6, PlanType, PlanDate, Division, layoutControlItem1, layoutControlItem4, layoutControlItem5, layoutControlItem9, layoutControlItem11, layoutControlItem12, layoutControlItem13, layoutControlItem10, lcCellTypeGr, SEQ, layoutControlItem8 … |
| UsrButton | 10 | usrButton1, btnWLast, btnW52, btnW26, btnLoad, btnUnfix, btnFix, btnItemId, btnNew, btnMeasure |
| UsrCombo | 6 | cboOperationGroup, cboDivision, cboPlanSeq, cboPlanDate, cboPlanType, cboBucketType |
| EmptySpaceItem | 4 | baseInfoLbl, emptySpaceItem1, emptySpaceItem1, emptySpaceItem2 |
| UsrLayoutControl | 3 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl2 |
| LayoutControlGroup | 3 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup2 |
| UsrCheckBox | 3 | chkAll, chkSum, chkLineAssign |
| UsrCheckedList2 | 3 | clbLine, clbPlantSite, clbExtraSpec |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrTextBox | 2 | txtItemId, txtModel |
| UsrCheckedList | 2 | cboElectrode, cboCellTypeGr |
| UsrButtonList | 1 | btnButtonList |
| ImageList | 1 | imageList1 |
| UsrDateRangePicker3 | 1 | dCalendar |
| TextBox | 1 | txtNickName |

## 7. 확인 필요 (2건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 2699 | SaveData_Line_DT | {?definition_path}#SaveProductionPlanLine | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3170 | SaveData_FixInfo | {?definition_path}#SaveProductionPlanFix | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=2 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 621 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 27 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 7 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 37 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 317 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 4814 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (7건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 2385 | SCP.SCP0011_SAVE_PRODUCTION_PLAN_LINE | commented:MATCH |
| 2751 |  | commented:EMPTY |
| 3258 | SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | commented:MATCH |
| 3387 | SCP.SCP0013_GET_PLAN_EDIT_INFO | commented:MATCH |
| 3708 | SCP.PR_SCM_SYS_LOG_BATCH | commented:MATCH |
| 4084 | SCP.SCM0001_GET_SCP_PERIOD | commented:MATCH |
| 4083 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0013 | Line | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 |
| SCM_MST_SHEET_MEASURE | SCP0013 | LINE | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 168건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: LinLoad, Line
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:331
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 157 | 하드코딩 | AddComboColumn | Plant Site | SCM_SITE_ID | if(spreadInfo.SheetName == "LinLoad") |
| InitSpread |  | 158 | 하드코딩 | AddTextColumn | Building | FACTORY_NAME | if(spreadInfo.SheetName == "LinLoad") |
| InitSpread |  | 159 | 하드코딩 | AddComboColumn | Operation | OPERATION_ID | if(spreadInfo.SheetName == "LinLoad") |
| InitSpread |  | 160 | 하드코딩 | AddTextColumn | Line | LINE_NAME | if(spreadInfo.SheetName == "LinLoad") |
| InitSpreadDateColumn |  | 321 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 325 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 330 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 394 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 398 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 404 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 214 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 215 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 216 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 217 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread | Line | 341 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Line") ⟫ if(division.Substring(0, 2).Equals("EE") == false) |
| InitSpread | Line | 342 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Line") ⟫ if(division.Substring(0, 2).Equals("EE") == false) |
| InitSpread | Line | 343 | 표시/라벨 변경 | set:Visible | Visible = {?false} | UNIT | if(spdInfo.SheetName == "Line") ⟫ if(division.Substring(0, 2).Equals("EE") == false) |
| InitSpread | Line | 346 | 표시/라벨 변경 | set:Visible | Visible = {?true} | CELL_TYPE_GROUP_CODE | if(spdInfo.SheetName == "Line") ⟫ if(division.Substring(0, 2).Equals("EE") == false) ⟫ if(division == "40") |
| InitSpread | Line | 348 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CELL_TYPE_GROUP_CODE | if(spdInfo.SheetName == "Line") ⟫ if(division.Substring(0, 2).Equals("EE") == false) ⟫ else!(division == "40") |
| InitSpread | Line | 350 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CELL_ID | if(spdInfo.SheetName == "Line") ⟫ if(division.Substring(0, 2).Equals("EE") == false) |
| InitSpread | Line | 354 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Line") ⟫ else!(division.Substring(0, 2).Equals("EE") == false) |
| InitSpread | Line | 355 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Line") ⟫ else!(division.Substring(0, 2).Equals("EE") == false) |
| InitSpread | Line | 356 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CELL_TYPE_GROUP_CODE | if(spdInfo.SheetName == "Line") ⟫ else!(division.Substring(0, 2).Equals("EE") == false) |
| InitSpread | Line | 360 | 표시/라벨 변경 | set:Visible | Visible = {?true} | UNIT | if(spdInfo.SheetName == "Line") ⟫ else!(division.Substring(0, 2).Equals("EE") == false) ⟫ if(operationGroup.Equals("E")) |
| InitSpread | Line | 361 | 표시/라벨 변경 | set:Visible | Visible = {?true} | CELL_ID | if(spdInfo.SheetName == "Line") ⟫ else!(division.Substring(0, 2).Equals("EE") == false) ⟫ if(operationGroup.Equals("E")) |
| InitSpread | Line | 365 | 표시/라벨 변경 | set:Visible | Visible = {?false} | UNIT | if(spdInfo.SheetName == "Line") ⟫ else!(division.Substring(0, 2).Equals("EE") == false) ⟫ else!(operationGroup.Equals("E")) |
| InitSpread | Line | 366 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CELL_ID | if(spdInfo.SheetName == "Line") ⟫ else!(division.Substring(0, 2).Equals("EE") == false) ⟫ else!(operationGroup.Equals("E")) |
| InitSpread | Line | 370 | 표시/라벨 변경 | set:Visible | Visible = {?(division == "40")} | EXTRA_SPEC | if(spdInfo.SheetName == "Line") |
| InitSpreadDateColumn |  | 410 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 414 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 419 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 1220 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1225 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1232 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1236 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1241 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1248 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1252 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetColumnModelVisible |  | 3916 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | switch(pOperationGroup)case "A" |
| SetColumnModelVisible |  | 3919 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | switch(pOperationGroup)case "P" |
| InitializeComponent |  | 1665 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1666 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1667 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1668 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Line | META+코드연결 | 12 (?5) | 11 (?5) | 11 (?5) | 11 (?5) | 11 (?5) | 11 (?5) | 11 (?5) | 11 (?5) | 11 (?5) | 11 (?5) | 11 (?5) | 11 (?5) | 11 (?5) | 11 (?5) |
| LinLoad | 코드 하드코딩 전용(메타 없음) | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 정적평가 미지원식 168 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 168건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
