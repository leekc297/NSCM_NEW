# SCP0029 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0029_ProductionPlanLine_SMALL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0029_ProductionPlanLine_SMALL\SCP0029_ProductionPlanLine_SMALL.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0029_ProductionPlanLine_SMALL\SCP0029_ProductionPlanLine_SMALL.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0029_ProductionPlanLine_SMALL\SCP0029_ProductionPlanLine_SMALL.csproj | 2687 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0029_ProductionPlanLine_SMALL\SCP0029_ProductionPlanLine_SMALL.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0029_ProductionPlanLine_SMALL\SCP0029_ProductionPlanLine_SMALL.csproj | 1187 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1271 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1281 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1286 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1291 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1300 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:cboOperationGroup.SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | 2516 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboOperationGroup.SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | 2528 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 2540 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > Set_FixButtonEnabled > InitSpread > GetSpdTitle | 2623 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > Set_FixButtonEnabled > InitSpread > GetSpdTitle > GetBucketSet | 2647 | SCP.SCP0009_GET_SHEET_BUCKET_FIX | MATCH | SP SCP0009_GET_SHEET_BUCKET_FIX |
| event:cboPlanSeq.SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged > Set_FixButtonEnabled > InitSpread > GetSpdTitle | 2623 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:cboPlanSeq.SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged > Set_FixButtonEnabled > InitSpread > GetSpdTitle > GetBucketSet | 2647 | SCP.SCP0009_GET_SHEET_BUCKET_FIX | MATCH | SP SCP0009_GET_SHEET_BUCKET_FIX |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 2560 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged > Set_FixButtonEnabled > InitSpread > GetSpdTitle | 2623 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged > Set_FixButtonEnabled > InitSpread > GetSpdTitle > GetBucketSet | 2647 | SCP.SCP0009_GET_SHEET_BUCKET_FIX | MATCH | SP SCP0009_GET_SHEET_BUCKET_FIX |
| event:clbPlantSite.SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | 2500 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 1431 | SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY |
| button:FindButton | FindButton > Get_IsEditInfo | 2229 | SCP.SCP0013_GET_PLAN_EDIT_INFO | MATCH | SP SCP0013_GET_PLAN_EDIT_INFO |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 2623 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle > GetBucketSet | 2647 | SCP.SCP0009_GET_SHEET_BUCKET_FIX | MATCH | SP SCP0009_GET_SHEET_BUCKET_FIX |
| button:SaveButton | SaveButton > SaveData_Line_DT > FindData_Main | 1431 | SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY |
| button:SaveButton | SaveButton > SaveData_Line_DT > FindData_Main > InitSpread > GetSpdTitle | 2623 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Line_DT > FindData_Main > InitSpread > GetSpdTitle > GetBucketSet | 2647 | SCP.SCP0009_GET_SHEET_BUCKET_FIX | MATCH | SP SCP0009_GET_SHEET_BUCKET_FIX |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo > FindData_Main | 1431 | SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo | 2117 | SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | MATCH | SP SCP0024_SAVE_PRODUCTION_PLAN_FIX |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo > FindData_Main > InitSpread > GetSpdTitle | 2623 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo > FindData_Main > InitSpread > GetSpdTitle > GetBucketSet | 2647 | SCP.SCP0009_GET_SHEET_BUCKET_FIX | MATCH | SP SCP0009_GET_SHEET_BUCKET_FIX |
| event:this.btnMeasure.Click | BtnMeasure_Click > InitSpread > GetSpdTitle | 2623 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | BtnMeasure_Click > InitSpread > GetSpdTitle > GetBucketSet | 2647 | SCP.SCP0009_GET_SHEET_BUCKET_FIX | MATCH | SP SCP0009_GET_SHEET_BUCKET_FIX |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo > FindData_Main | 1431 | SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo | 2117 | SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | MATCH | SP SCP0024_SAVE_PRODUCTION_PLAN_FIX |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo > FindData_Main > InitSpread > GetSpdTitle | 2623 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo > FindData_Main > InitSpread > GetSpdTitle > GetBucketSet | 2647 | SCP.SCP0009_GET_SHEET_BUCKET_FIX | MATCH | SP SCP0009_GET_SHEET_BUCKET_FIX |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1245 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1271 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1281 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1286 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1291 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1300 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2623 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle > GetBucketSet | 2647 | SCP.SCP0009_GET_SHEET_BUCKET_FIX | MATCH | SP SCP0009_GET_SHEET_BUCKET_FIX |
| unreached:(진입점 미연결) | <field:dtElectrodeType> | 55 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetLastPlanVersion | 1334 | SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | SP SCP0011_GET_LAST_PLAN_VERSION |
| unreached:(진입점 미연결) | SaveData_Line | 1633 | SCP.SCP0011_SAVE_PRODUCTION_PLAN_LINE | MATCH | SP SCP0011_SAVE_PRODUCTION_PLAN_LINE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_LINE_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:REF:FN_CHAR_TO_DATE, UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0009_GET_SHEET_BUCKET_FIX | MATCH | 1 | SP SCP0009_GET_SHEET_BUCKET_FIX | EXEC:SCP0009_GET_SHEET_BUCKET_FIX, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_DIVISION |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | 1 | SP SCP0011_GET_LAST_PLAN_VERSION | EXEC:SCP0011_GET_LAST_PLAN_VERSION, REF:FN_GET_SCP_LAST_PLAN_VERSION_ID, REF:FN_SCM_SPLIT, SELECT:SCP_PLAN_VERSION_V |  |
| SCP.SCP0011_SAVE_PRODUCTION_PLAN_LINE | MATCH | 1 | SP SCP0011_SAVE_PRODUCTION_PLAN_LINE | EXEC:SCP0011_SAVE_PRODUCTION_PLAN_LINE, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, INSERT:#JV_ESS_LINE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP, INSERT:#JV_ESS_SCM_SITE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP, INSERT:#DIVISION_LAST_PLAN_INFO, SELECT:SCP_PLAN_INFO, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_DIVISION, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:#JV_ESS_LINE_MAP, SELECT:#JV_ESS_SCM_SITE_MAP, INSERT:#JV_LINE_SYNC_TARGET, EXEC:PR_SCP_ANL_PRODUCTION_PLAN_HIST, MERGE:SCP_ANL_PRODUCTION_PLAN, SELECT:SCP_ANL_PRODUCTION_PLAN, SELECT:#JV_LINE_SYNC_TARGET, SELECT:#DIVISION_LAST_PLAN_INFO, INSERT:SCP_ANL_PRODUCTION_PLAN_H, DELETE:SCP_ANL_PRODUCTION_PLAN, DELETE:PP, UPDATE:SCP_ANL_PRODUCTION_PLAN_FIX, SELECT:SCP_ANL_PRODUCTION_PLAN_FIX, EXEC:PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST, UPDATE:PF, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX_H, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_SITE |  |
| SCP.SCP0013_GET_PLAN_EDIT_INFO | MATCH | 1 | SP SCP0013_GET_PLAN_EDIT_INFO | EXEC:SCP0013_GET_PLAN_EDIT_INFO, REF:FN_ZERO_LPAD, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_MODELING, REF:FN_GET_BUCKET_YYYYMMDD, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_SITE, REF:FN_GET_DIVISION_DIV, REF:FN_SPLITSTRING, REF:FN_DATE_TO_CHAR, REF:FN_GET_START_YYYYMMDD, SELECT:SCM_MST_DIVISION |  |
| SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | MATCH | 1 | SP SCP0013_GET_PRODUCTION_PLAN_LINEBY | EXEC:SCP0013_GET_PRODUCTION_PLAN_LINEBY, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_NEXT_DAY, CREATE:#TBLDYNAMICPIVOT_SCP0013_PLANTLINE_BY_SEARCH, CREATE:#TBLDYNAMICPIVOT_SCP0013_PLANTLINE_BY_TT, INSERT:#JV_ESS_MAP, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_SITE, INSERT:#TBLDYNAMICPIVOT_SCP0013_PLANTLINE_BY_SEARCH, SELECT:SCP_ANL_PRODUCTION_PLAN, REF:FN_GET_ITEM_LIKE_CONDITION, SELECT:SCM_DNM_PRODUCT_RESULT_V, REF:FN_GET_DIVISION_DIV, SELECT:#JV_ESS_MAP, SELECT:HIST_SCP_ANL_PRODUCTION_PLAN, INSERT:#TBLDYNAMICPIVOT_SCP0013_PLANTLINE_BY_TT, SELECT:SCP_MST_TACT_TIME, SELECT:SCP_MST_FINAL_ITEM_V, SELECT:SCM_MST_VENDOR, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCP_MST_OUTSOURCING_CAPA, SELECT:SCP_MST_TACT_TIME_OSP, SELECT:SCM_MST_LINE_OSP, CREATE:#TBLDYNAMICPIVOT_SCP0013_TMP, INSERT:#TBLDYNAMICPIVOT_SCP0013_TMP, SELECT:SCP_MST_FINAL_ITEM, REF:STRING_SPLIT, SELECT:#TBLDYNAMICPIVOT_SCP0013_TMP, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:SCM_MST_ITEM_SN, SELECT:SCP_MST_ITEM_CELL_CF, SELECT:SCM_MST_ITEM_CONV_CALC_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, CREATE:#TBLDYNAMICPIVOT_SCP0013_KEY, INSERT:#TBLDYNAMICPIVOT_SCP0013_KEY, SELECT:#TBLDYNAMICPIVOT_SCP0013_KEY, INSERT:#TBLDYNAMICPIVOT_SCP0013_WORKING_DATA, REF:FN_LINE_WORKINGTIME_BY_LOSS, INSERT:#TBLDYNAMICPIVOT_SCP0013_LOAD, SELECT:#TBLDYNAMICPIVOT_SCP0013_WORKING_DATA, SELECT:SCP_ANL_TACT_TIME, SELECT:SCP_ANL_WORKING_TIME, INSERT:#ISUZU_SCP0013, SELECT:SCM_MST_FINAL_ITEM_V, CREATE:#TBLDYNAMICPIVOT_SCP0013_PERFOR, INSERT:#TBLDYNAMICPIVOT_SCP0013_PERFOR, SELECT:#ISUZU_SCP0013, INSERT:#TBLDYNAMICPIVOT_SCP0013_PERFOR_ESS_JV, UPDATE:A, SELECT:#TBLDYNAMICPIVOT_SCP0013_PERFOR_ESS_JV, INSERT:#TBLDYNAMICPIVOT_SCP0013_PLAN, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#TBLDYNAMICPIVOT_SCP0013, SELECT:SCM_MST_BOM_SN, SELECT:SCM_MST_ITEM_CLASS_M, SELECT:#TBLDYNAMICPIVOT_SCP0013_PLAN, SELECT:#TBLDYNAMICPIVOT_SCP0013_PERFOR |  |
| SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | MATCH | 1 | SP SCP0024_SAVE_PRODUCTION_PLAN_FIX | EXEC:SCP0024_SAVE_PRODUCTION_PLAN_FIX, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_ANL_PRODUCTION_PLAN_FIX, EXEC:PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX, UPDATE:SCP_ANL_PRODUCTION_PLAN_FIX, DELETE:SCP_ANL_PRODUCTION_PLAN_FIX, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| CalculateSum | dr | measure |
| EditButton | drs[0] | osp_yn, fp_plan_period, offset, edit_start_date, confirm_yn, date_chk, is_editable, plan_start_yyyymmdd, plan_type, plan_seq, new_edit_mode |
| EditButton | dtPlanType.Rows[dtPlanType.Rows.Count - 1] | CODE |
| EditButton | dtPlanSeq.Rows[0] | CODE |
| GetLastPlanVersion | dsBinding.Tables[0].Rows[0] | PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ |
| SaveData_FixInfo | dtErr.Rows[0] | ERR_MESSAGE |
| SaveData_Line | dtErr.Rows[0] | ERR_MESSAGE |
| SaveData_Line_DT | dr | A, p_active_flag, p_division_id, p_plan_start_yyyymmdd, p_plan_type, p_seq, p_operation_group, p_scm_site_id, p_item_id, p_line_id, p_operation_id, p_measure, p_origin_division_id, p_electrode_type, p_yyyymmdd, p_qty, p_fix, p_loc_flag, p_user_id, p_program_id, debug_mode |
| SaveData_Line_DT | dsInput.Tables[0].Rows[0] | p_loc_flag |
| SaveData_Line_DT | dsInput.Tables[0].Rows[nRowCnt - 1] | p_loc_flag |
| SaveData_Line_DT | row | A |
| Set_FixButtonEnabled | dtPlanSeq.Rows[0] | CODE |
| Set_FixCellColor | dr | FIX_KEY, YYYYMMDD, YYYYMM_WEEK |
| Set_FPOperationColor | drs[0] | osp_yn, fp_plan_period, offset, edit_start_date, confirm_yn, date_chk, is_editable, plan_start_yyyymmdd, plan_type, plan_seq, new_edit_mode |
| Set_FPOperationColor | dtPlanType.Rows[dtPlanType.Rows.Count - 1] | CODE |
| Set_FPOperationColor | dtPlanSeq.Rows[0] | CODE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitSpread:256, SetChangedControl:1256, SetChangedControl:1265, SetChangedControl:1277, SetChangedControl:1285, SetChangedControl:1290, GetLastPlanVersion:1322, FindData_Main:1402 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:259 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:312 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:320 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetChanges | SaveData_Line_DT:1850 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnUnfix | Click | btnUnfix_Click | InitializeComponent:215 |
| this.btnFix | Click | btnFix_Click | InitializeComponent:252 |
| this | Load | Form_Load | .ctor:166 |
| dsdmLine | Changed | SpdMain_Changed | Form_Load:182 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:427 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:429 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:430 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:433 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:434 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:435 |
| cboOperationGroup | SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | InitEvent:438 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:440 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:441 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:442 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:443 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:444 |
| this.btnMeasure | Click | BtnMeasure_Click | InitEvent:448 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:887 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:992 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:1000 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:1114 |
| dsdmLine | Changed | SpdMain_Changed | CalculateDailyQty:1122 |
| dsdmLine | Changed | SpdMain_Changed | CalculateDailyQty:1172 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:1324 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:1325 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:1326 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:1370 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:1371 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:1372 |
| dsdmLine | Changed | SpdMain_Changed | FindData_Main:1389 |
| dsdmLine | Changed | SpdMain_Changed | FindData_Main:1503 |

## 6. 컨트롤 (43개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 17 | PlanType, PlanDate, Division, layoutControlItem1, layoutControlItem6, SEQ, layoutControlItem7, lblBucket, layoutControlItem3, layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem9, layoutControlItem11, layoutControlItem10 … |
| UsrCombo | 6 | cboOperationGroup, cboDivision, cboPlanSeq, cboPlanDate, cboPlanType, cboBucketType |
| UsrButton | 5 | usrButton1, btnUnfix, btnFix, btnItemId, btnMeasure |
| UsrCheckedList | 3 | clbLine, clbPlantSite, cboElectrode |
| EmptySpaceItem | 3 | emptySpaceItem3, emptySpaceItem10, emptySpaceItem2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrMultiLineEditor | 1 | txtItemId |
| UsrDateRangePicker | 1 | drpPeriod |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| UsrCheckBox | 1 | chkSum |
| TextBox | 1 | txtNickName |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (2건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 2671 | SCP.SCM0001_GET_SCP_PERIOD | commented:MATCH |
| 2670 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Line
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:312
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Line | 329 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Line") ⟫ if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread | Line | 330 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Line") ⟫ if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread | Line | 334 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Line") ⟫ else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread | Line | 335 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Line") ⟫ else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpreadDateColumn |  | 375 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 379 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 384 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 814 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(int.Parse(siObj.GetColumnTag(iCol).Substring(2))<= int.Parse(bs_Day)) |
| SetSpreadColumn |  | 816 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ else!(int.Parse(siObj.GetColumnTag(iCol).Substring(2))<= int.Parse(bs_Day)) |
| SetSpreadColumn |  | 831 | 표시/라벨 변경 | set:Visible | Visible = {?viewYN} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 850 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 854 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 859 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 866 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 870 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 939 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 940 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 941 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 942 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Line | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | 2 | 2 | 2 | 2 | 2 | 2 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
