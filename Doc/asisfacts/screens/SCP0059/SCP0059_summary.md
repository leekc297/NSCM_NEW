# SCP0059 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0059_Shipment_Plan_SEMI_JV\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0059_Shipment_Plan_SEMI_JV\SCP0059_Shipment_Plan_SEMI_JV.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0059_Shipment_Plan_SEMI_JV\SCP0059_Shipment_Plan_SEMI_JV.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0059_Shipment_Plan_SEMI_JV\SCP0059_Shipment_Plan_SEMI_JV.csproj | 4527 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0059_Shipment_Plan_SEMI_JV\SCP0059_Shipment_Plan_SEMI_JV.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0059_Shipment_Plan_SEMI_JV\SCP0059_Shipment_Plan_SEMI_JV.csproj | 1366 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 660 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 703 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 707 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 714 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > GetLastRange | 3889 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 3903 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 4021 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 4005 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 913 | SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI | MATCH | SP SCP0010_GET_SHIPMENT_PLAN_SEMI |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 3853 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 913 | SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI | MATCH | SP SCP0010_GET_SHIPMENT_PLAN_SEMI |
| button:SaveButton | SaveButton > SaveData_Main > Get_IsSaveYn | 1431 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| button:SaveButton | SaveButton > SaveData_Main | 2461 | biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData_Main | 2461 | {?definition_path}#dbo.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET | UNRESOLVED |  |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main > InitSpread_2 > GetSpdTitle | 3853 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Main > SCM_SYS_LOG_BATCH | 4241 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo > FindData_Main | 913 | SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI | MATCH | SP SCP0010_GET_SHIPMENT_PLAN_SEMI |
| event:this.btnFix.Click | BtnFix_Click > Get_IsSaveYn | 1431 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo | 3488 | biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET] | BIZ_MATCH |  |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo | 3488 | {?definition_path}#dbo.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET | UNRESOLVED |  |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo > FindData_Main > InitSpread_2 > GetSpdTitle | 3853 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnFix.Click | BtnFix_Click > SaveData_FixInfo > SCM_SYS_LOG_BATCH | 4241 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread_2 > GetSpdTitle | 3853 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnNew.Click | BtnNew_Click > FindData_Main | 913 | SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI | MATCH | SP SCP0010_GET_SHIPMENT_PLAN_SEMI |
| event:this.btnNew.Click | BtnNew_Click > Get_IsSaveYn | 1431 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| event:this.btnNew.Click | BtnNew_Click > FindData_Main > InitSpread_2 > GetSpdTitle | 3853 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo > FindData_Main | 913 | SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI | MATCH | SP SCP0010_GET_SHIPMENT_PLAN_SEMI |
| event:this.btnUnfix.Click | BtnUnfix_Click > Get_IsSaveYn | 1431 | SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | SP SCP0013_GET_PLAN_TYPE_SAVE_YN |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo | 3488 | biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET] | BIZ_MATCH |  |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo | 3488 | {?definition_path}#dbo.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET | UNRESOLVED |  |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo > FindData_Main > InitSpread_2 > GetSpdTitle | 3853 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo > SCM_SYS_LOG_BATCH | 4241 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.btnW26.Click | BtnW26_Click > GetDayRange | 3903 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.btnW52.Click | BtnW52_Click > GetDayRange | 3903 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.btnWLast.Click | BtnWLast_Click > GetDayRange | 3903 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.Load | Form_Load > InitControls | 284 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 660 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 703 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 707 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 714 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1633 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 3853 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetLastRange | 3889 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| event:this.Load | Form_Load > InitControls > GetDayRange | 3903 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.Load | Form_Load > FindData_Division | 4504 | SystemManager.UP_FX_GetUserGroupAuthExtentionList | MATCH | SP UP_FX_GetUserGroupAuthExtentionList |
| unreached:(진입점 미연결) | GetLastPlanVersion | 747 | SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | SP SCP0011_GET_LAST_PLAN_VERSION |
| unreached:(진입점 미연결) | GetDivision | 3817 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | SetChangedPeriod | 3830 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 3834 | biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?definition_path}#dbo.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET | UNRESOLVED | 1 |  |  |  |
| {?definition_path}#dbo.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET | UNRESOLVED | 1 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET] | BIZ_MATCH | 1 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:REF:FN_CHAR_TO_DATE, UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD | EXEC:SCM0001_GET_SCP_DAILY_PLAN_PERIOD, SELECT:SCM_MST_DIVISION |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI | MATCH | 1 | SP SCP0010_GET_SHIPMENT_PLAN_SEMI | EXEC:SCP0010_GET_SHIPMENT_PLAN_SEMI, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, INSERT:#TBLDYNAMICPIVOT_SCP0010_MEASURE, SELECT:SCM_MST_SHEET_MEASURE, CREATE:#TBLDYNAMICPIVOT_SCP0010_STD, INSERT:#TBLDYNAMICPIVOT_SCP0010_STD, SELECT:SCP_ANL_SHIPMENT_PLAN_SEMI, REF:FN_GET_ITEM_LIKE_CONDITION, SELECT:#TBLDYNAMICPIVOT_SCP0010_MEASURE, SELECT:SCP_ANL_BOD_N_V_PLAN_H, INSERT:#TBLDYNAMICPIVOT_SCP0010_VALUE_1, SELECT:#TBLDYNAMICPIVOT_SCP0010_STD, INSERT:#TBLDYNAMICPIVOT_SCP0010_VALUE_2, SELECT:SCM_DNM_EXFACTORY_RESULT, REF:FN_GET_DIVISION_DIV, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:#TBLDYNAMICPIVOT_SCP0010_VALUE_2, CREATE:#TBLDYNAMICPIVOT_SCP0010_DATA, INSERT:#TBLDYNAMICPIVOT_SCP0010_DATA, SELECT:#TBLDYNAMICPIVOT_SCP0010_VALUE_1, INSERT:#TBLDYNAMICPIVOT_SCP0010_01, SELECT:#TBLDYNAMICPIVOT_SCP0010_DATA, INSERT:#BOH_E, SELECT:SCP_PLN_PLANT_ONHAND, INSERT:#BOH_A, INSERT:#ESS_TYPE_INFO, SELECT:SCM_MST_SITE, SELECT:ESS_TYPE_INFO, DYNAMIC@SCP0010_GET_SHIPMENT_PLAN_SEMI, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_MODELING, SELECT:SCM_MST_PLAN, SELECT:SCP_PLAN_VERSION_V, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCM_MST_DIVISION |  |
| SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | 1 | SP SCP0011_GET_LAST_PLAN_VERSION | EXEC:SCP0011_GET_LAST_PLAN_VERSION, REF:FN_GET_SCP_LAST_PLAN_VERSION_ID, REF:FN_SCM_SPLIT, SELECT:SCP_PLAN_VERSION_V |  |
| SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | MATCH | 1 | SP SCP0013_GET_PLAN_TYPE_SAVE_YN | EXEC:SCP0013_GET_PLAN_TYPE_SAVE_YN, SELECT:SCM_MST_MODELING, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_PLAN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SystemManager.UP_FX_GetUserGroupAuthExtentionList | MATCH | 1 | SP UP_FX_GetUserGroupAuthExtentionList | EXEC:UP_FX_GETUSERGROUPAUTHEXTENTIONLIST, SELECT:SCM_MST_DIVISION, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_VENDOR, SELECT:SCM_MST_SITE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| CalculateSum | dr | measure |
| FindButton | clbFromSite.DataSource.Rows[i] | CODE |
| FindData_Division | ds.Tables[0].Rows[i] | Code, JV_PLANT_ID |
| FindData_Main | dsBinding.Tables[1].Rows[0] | plan_start_date |
| GetIsEditable | dtEditable.Rows[0] | is_editable |
| GetIsEditable | dr | PLAN_STATUS |
| GetIsEditable | founded[0] | confirm_yn |
| GetLastPlanVersion | dsBinding.Tables[0].Rows[0] | PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ |
| InsertRow | dtCaller.Rows[0] | ELECTRODE_TYPE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID |
| SaveData_FixInfo | dr | p_active_flag, p_division_id, p_biz_type, p_item_id, p_to_site, p_from_site, p_bod_id, p_yyyymmdd, p_qty, p_origin_from_division_id, p_origin_to_division_id, p_electrode_type, p_fix_reason, p_created_by, p_last_updated_by, p_time_zone, debug_mode |
| SaveData_FixInfo | result.Rows[0] | result_code, result_cnt, err_message |
| SaveData_Main | dr | A, p_active_flag, p_division_id, p_plan_start_yyyymmdd, p_plan_type, p_seq, p_operation_group, p_item_id, p_from_site, p_bod_id, p_measure, p_yyyymmdd, p_to_site, p_qty, p_origin_from_division_id, p_origin_to_division_id, p_electrode_type, p_created_by, p_last_updated_by, p_time_zone |
| SaveData_Main | dRow | A, p_active_flag, p_division_id, p_plan_start_yyyymmdd, p_plan_type, p_seq, p_operation_group, p_biz_type, p_item_id, p_from_site, p_bod_id, p_measure, p_yyyymmdd, p_to_site, p_qty, p_origin_from_division_id, p_origin_to_division_id, p_electrode_type, p_created_by, p_last_updated_by, p_time_zone, debug_mode |
| SaveData_Main | saveDS.Tables[0].Rows[0] | p_first_row |
| SaveData_Main | saveDS.Tables[0].Rows[iCount - 1] | p_last_row |
| SaveData_Main | result.Rows[0] | result_code, result_cnt, err_message |
| Set_FixButtonEnabled | a | CODE |
| Set_FixCellColor | dr | yyyymmdd |
| Set_SumValues | dsBinding.Tables[0].Columns | measure |
| SetCalcMeasure | dtBinding.Columns | BOH, TO_SITE, MEASURE |
| SetChangedControl | c | CODE |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:298, InitSpread_2:323, SetChangedControl:645, SetChangedControl:662, SetChangedControl:706, SetChangedControl:713, GetLastPlanVersion:734, FindData_Main:884 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread_2:326, InitSpread:406 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread_2:328 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread_2:330, InitSpread:409 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:519 |
| this | Load | Form_Load | .ctor:215 |
| dsdm | Changed | spdMain_Changed | InitEvent:502 |
| this.btnItem_Id | Click | BtnItem_Id_Click | InitEvent:504 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:505 |
| this.chkSum | CheckedChanged | ChkSum_CheckedChanged | InitEvent:506 |
| this.cboBucketType | SelectedIndexChanged | CboBucketType_SelectedIndexChanged | InitEvent:507 |
| this.cboOperGroup | SelectedIndexChanged | cboOperGrp_SelectedIndexChanged | InitEvent:508 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:510 |
| this.spdMain | CellClick | spdMain_CellClick | InitEvent:511 |
| this.spdMain | KeyUp | SpdMain_KeyUp | InitEvent:512 |
| this.btnFix | Click | BtnFix_Click | InitEvent:515 |
| this.btnUnfix | Click | BtnUnfix_Click | InitEvent:516 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:518 |
| cboOperGroup | SelectedIndexChanged | CboOperGroup_SelectedIndexChanged | InitEvent:519 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:520 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:521 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:522 |
| this.btnNew | Click | BtnNew_Click | InitEvent:525 |
| this.btnW26 | Click | BtnW26_Click | InitEvent:527 |
| this.btnW52 | Click | BtnW52_Click | InitEvent:528 |
| this.btnWLast | Click | BtnWLast_Click | InitEvent:529 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:736 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:737 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:738 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:775 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:776 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:777 |

## 6. 컨트롤 (49개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 20 | lblCombo1, layoutControlItem1, layoutControlItem7, layoutControlItem5, lblBucket, PlanDate, PlanType, SEQ, lblItemId, layoutControlItem4, layoutControlItem6, layoutControlItem2, layoutControlItem8, layoutControlItem3, layoutControlItem10 … |
| UsrButton | 9 | usrButton1, btnWLast, btnW52, btnW26, btnUnfix, btnFix, btnMeasure, btnItem_Id, btnNew |
| UsrCombo | 6 | cboOperGroup, cboDivision, cboBucketType, cboPlanDate, cboPlanType, cboPlanSeq |
| UsrCheckedList | 3 | clbFromSite, clbElecType, clbToSite |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3 |
| UsrConditionPanel | 1 | pnlCondition |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckBox | 1 | chkSum |
| UsrMultiLineEditor | 1 | txtItemId |
| UsrDateRangePicker | 1 | drpPeriod |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SheetView | 1 | spdMain_Sheet1 |
| FpSpread | 1 | spdMain |

## 7. 확인 필요 (2건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 2461 | SaveData_Main | {?definition_path}#dbo.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |
| 3488 | SaveData_FixInfo | {?definition_path}#dbo.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 25 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 13 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (6건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 2505 |  | commented:EMPTY |
| 2561 | SCP.SCM0001_GET_SCP_DAY_PERIOD | commented:MATCH |
| 3538 | SCP.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX | commented:MATCH |
| 3863 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |
| 3874 | SCP.SCM0001_GET_SCP_PERIOD | commented:MATCH |
| 3873 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0059 | Shipment Plan SEMI | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 |
| SCM_MST_SHEET_MEASURE | SCP0059 | CELL | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_MEASURE | SCP0059 | ELECTRODE | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Plan SEMI
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread_2:328
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread_2 | Shipment Plan SEMI | 332 | 표시/라벨 변경 | set:Font | Font = {?new Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold)} | T0_SITE_DESCRIPTION |  |
| InitSpread_2 | Shipment Plan SEMI | 333 | 표시/라벨 변경 | set:Font | Font = {?new Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold)} | transport_mode |  |
| InitSpread_2 | Shipment Plan SEMI | 340 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Plan SEMI | 341 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_FROM_DIVISION_ID | if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Plan SEMI | 342 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_TO_DIVISION_ID | if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Plan SEMI | 346 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Plan SEMI | 347 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_FROM_DIVISION_ID | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 | Shipment Plan SEMI | 348 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_TO_DIVISION_ID | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread | Shipment Plan SEMI | 357 | 하드코딩 | AddTextColumn | KEY_IDX | key_idx |  |
| InitSpread | Shipment Plan SEMI | 358 | 하드코딩 | AddTextColumn | Division | division_id |  |
| InitSpread | Shipment Plan SEMI | 359 | 하드코딩 | AddTextColumn | Operation Group | OPERATION_GROUP_DESC |  |
| InitSpread | Shipment Plan SEMI | 360 | 하드코딩 | AddTextColumn | Model | item_id |  |
| InitSpread | Shipment Plan SEMI | 361 | 하드코딩 | AddTextColumn | Nick Name | nick_name |  |
| InitSpread | Shipment Plan SEMI | 363 | 하드코딩 | AddTextColumn | From Site | FROM_SITE_DESCRIPTION |  |
| InitSpread | Shipment Plan SEMI | 364 | 하드코딩 | AddNumColumn | BOH (From Site) | boh |  |
| InitSpread | Shipment Plan SEMI | 365 | 하드코딩 | AddTextColumn | To Site | T0_SITE_DESCRIPTION |  |
| InitSpread | Shipment Plan SEMI | 366 | 하드코딩 | AddTextColumn | Trans Mode | transport_mode |  |
| InitSpread | Shipment Plan SEMI | 367 | 하드코딩 | AddTextColumn | L/T(Day) | lt_day |  |
| InitSpread | Shipment Plan SEMI | 369 | 하드코딩 | AddTextColumn | Measure | measure_label |  |
| InitSpread | Shipment Plan SEMI | 370 | 하드코딩 | AddTextColumn | Measure | measure |  |
| InitSpread | Shipment Plan SEMI | 371 | 하드코딩 | AddTextColumn | Division Name | division_name |  |
| InitSpread | Shipment Plan SEMI | 372 | 하드코딩 | AddTextColumn | Operation Group | operation_group |  |
| InitSpread | Shipment Plan SEMI | 373 | 하드코딩 | AddTextColumn | from_site | from_site |  |
| InitSpread | Shipment Plan SEMI | 375 | 하드코딩 | AddTextColumn | to_site | to_site |  |
| InitSpread | Shipment Plan SEMI | 376 | 하드코딩 | AddTextColumn | BOD ID | bod_id |  |
| InitSpread | Shipment Plan SEMI | 377 | 하드코딩 | AddTextColumn | MEASURE_ORDER_NO | measure_order_no |  |
| InitSpread | Shipment Plan SEMI | 378 | 하드코딩 | AddDateColumn | SHIP_FROZEN | SHIP_FROZEN |  |
| InitSpread | Shipment Plan SEMI | 379 | 하드코딩 | AddTextColumn | from_yyyymmdd | from_yyyymmdd |  |
| InitSpread | Shipment Plan SEMI | 381 | 하드코딩 | AddTextColumn | to_yyyymmdd | to_yyyymmdd |  |
| InitSpreadDateColumn |  | 449 | DB루프 | AddTextColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 454 | DB루프 | AddNumColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 459 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 605 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 610 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 617 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 621 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 626 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 633 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 637 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 1231 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1232 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1233 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1234 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Plan SEMI | META+코드연결 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 24 | 24 | 24 | 24 | 24 | 24 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
