# SCP0060 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0060_ProductionPlan_JV\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0060_ProductionPlan_JV\SCP0060_ProductionPlan_JV.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0060_ProductionPlan_JV\SCP0060_ProductionPlan_JV.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0060_ProductionPlan_JV\SCP0060_ProductionPlan_JV.csproj | 3521 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0060_ProductionPlan_JV\SCP0060_ProductionPlan_JV.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0060_ProductionPlan_JV\SCP0060_ProductionPlan_JV.csproj | 1219 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1017 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1021 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1061 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1066 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1071 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboOperationGroup.SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | 3020 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboOperationGroup.SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | 3024 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 3065 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 3091 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Model_Parallel | 1356 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL |
| button:FindButton | FindButton > FindData_Model_Parallel | 1402 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL |
| button:FindButton | FindButton > FindData_Model_Parallel | 1470 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL |
| button:FindButton | FindButton > FindData_Model_Parallel > FindData_Line | 1614 | SCP.SCP0011_GET_PRODUCTION_PLAN_LINE | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_LINE |
| button:FindButton | FindButton > FindData_Model_Parallel > FindData_Line > InitSpread > GetSpdTitle | 3287 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Line > SaveChage_CalData > FindData_Model_Parallel | 1356 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL |
| button:SaveButton | SaveButton > SaveData_Line > SaveChage_CalData > FindData_Model_Parallel | 1402 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL |
| button:SaveButton | SaveButton > SaveData_Line > SaveChage_CalData > FindData_Model_Parallel | 1470 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL |
| button:SaveButton | SaveButton > SaveData_Line > SaveChage_CalData > FindData_Model_Parallel > FindData_Line | 1614 | SCP.SCP0011_GET_PRODUCTION_PLAN_LINE | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_LINE |
| button:SaveButton | SaveButton > SaveData_Line | 2790 | SCP.SCP0011_SAVE_PRODUCTION_PLAN_LINE | MATCH | SP SCP0011_SAVE_PRODUCTION_PLAN_LINE |
| button:SaveButton | SaveButton > SaveData_Line > SaveChage_CalData > FindData_Model_Parallel > FindData_Line > InitSpread > GetSpdTitle | 3287 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Line > SaveChage_CalData | 3348 | SCP.PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND | MATCH | SP PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData > FindData_Model_Parallel | 1356 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData > FindData_Model_Parallel | 1402 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData > FindData_Model_Parallel | 1470 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData > FindData_Model_Parallel > FindData_Line | 1614 | SCP.SCP0011_GET_PRODUCTION_PLAN_LINE | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_LINE |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData > FindData_Model_Parallel > FindData_Line > InitSpread > GetSpdTitle | 3287 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData | 3348 | SCP.PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND | MATCH | SP PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 3287 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetBucketType | 973 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1017 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1021 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1061 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1066 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1071 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 3287 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > FindData_Division | 3494 | SystemManager.UP_FX_GetUserGroupAuthExtentionList | MATCH | SP UP_FX_GetUserGroupAuthExtentionList |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Line | 1614 | SCP.SCP0011_GET_PRODUCTION_PLAN_LINE | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_LINE |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > Get_IsEditInfo | 1746 | SCP.SCP0011_GET_PLAN_EDIT_INFO | MATCH | SP SCP0011_GET_PLAN_EDIT_INFO |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Line > InitSpread > GetSpdTitle | 3287 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | <field:dtElectrodeType> | 67 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetLastPlanVersion | 1112 | SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | SP SCP0011_GET_LAST_PLAN_VERSION |
| unreached:(진입점 미연결) | FindData_Model | 1195 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL |
| unreached:(진입점 미연결) | GetDivision | 3232 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | SetChangedPeriod | 3247 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 3251 | biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:REF:FN_CHAR_TO_DATE, UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCP.PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND | MATCH | 1 | SP PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND | EXEC:PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND, EXEC:PR_SCP_SYS_LOG_BATCH, UPDATE:X, SELECT:SCP_ANL_PRODUCTION_PLAN, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | 1 | SP SCP0011_GET_LAST_PLAN_VERSION | EXEC:SCP0011_GET_LAST_PLAN_VERSION, REF:FN_GET_SCP_LAST_PLAN_VERSION_ID, REF:FN_SCM_SPLIT, SELECT:SCP_PLAN_VERSION_V |  |
| SCP.SCP0011_GET_PLAN_EDIT_INFO | MATCH | 1 | SP SCP0011_GET_PLAN_EDIT_INFO | EXEC:SCP0011_GET_PLAN_EDIT_INFO, REF:FN_ZERO_LPAD, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_MODELING, REF:FN_GET_BUCKET_YYYYMMDD, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_SITE, REF:FN_DATE_TO_CHAR, REF:FN_GET_START_YYYYMMDD |  |
| SCP.SCP0011_GET_PRODUCTION_PLAN_LINE | MATCH | 1 | SP SCP0011_GET_PRODUCTION_PLAN_LINE | EXEC:SCP0011_GET_PRODUCTION_PLAN_LINE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, CREATE:#TBLDYNAMICPIVOT_SCP0011_02, INSERT:#TBLDYNAMICPIVOT_SCP0011_02, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCP_ANL_PRODUCTION_PLAN, REF:STRING_SPLIT, SELECT:SCM_DNM_PRODUCT_RESULT_V, SELECT:SCM_MST_DIVISION, SELECT:HIST_SCP_ANL_PRODUCTION_PLAN, DYNAMIC@SCP0011_GET_PRODUCTION_PLAN_LINE |  |
| SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | 3 | SP SCP0011_GET_PRODUCTION_PLAN_MODEL | EXEC:SCP0011_GET_PRODUCTION_PLAN_MODEL, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, INSERT:#TBLDYNAMICPIVOT_SCP0011_NICKITEM, SELECT:SCM_MST_ITEM_SN, CREATE:#TBLDYNAMICPIVOT_SCP0011_03, INSERT:#ISUZU, SELECT:SCM_MST_FINAL_ITEM_V, SELECT:SCP_MST_FINAL_ITEM_V, DYNAMIC@SCP0011_GET_PRODUCTION_PLAN_MODEL, INSERT:#TBLDYNAMICPIVOT_SCP0011_01, SELECT:SCM_MST_SHEET_MEASURE, SELECT:#TBLDYNAMICPIVOT_SCP0011_03, UPDATE:A, SELECT:#TBLDYNAMICPIVOT_SCP0011_01, EXEC:SP_EXECUTESQL |  |
| SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | MATCH | 1 | SP SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | EXEC:SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, INSERT:#TBLDYNAMICPIVOT_SCP0011_NICKITEM, SELECT:SCM_MST_ITEM_SN, CREATE:#TBLDYNAMICPIVOT_SCP0011_02, INSERT:#ISUZU, SELECT:SCM_MST_FINAL_ITEM_V, SELECT:SCP_MST_FINAL_ITEM_V, DYNAMIC@SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL, INSERT:#TBLDYNAMICPIVOT_SCP0011_01, SELECT:SCM_MST_SHEET_MEASURE, SELECT:#TBLDYNAMICPIVOT_SCP0011_02 |  |
| SCP.SCP0011_SAVE_PRODUCTION_PLAN_LINE | MATCH | 1 | SP SCP0011_SAVE_PRODUCTION_PLAN_LINE | EXEC:SCP0011_SAVE_PRODUCTION_PLAN_LINE, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, INSERT:#JV_ESS_LINE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP, INSERT:#JV_ESS_SCM_SITE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP, INSERT:#DIVISION_LAST_PLAN_INFO, SELECT:SCP_PLAN_INFO, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_DIVISION, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:#JV_ESS_LINE_MAP, SELECT:#JV_ESS_SCM_SITE_MAP, INSERT:#JV_LINE_SYNC_TARGET, EXEC:PR_SCP_ANL_PRODUCTION_PLAN_HIST, MERGE:SCP_ANL_PRODUCTION_PLAN, SELECT:SCP_ANL_PRODUCTION_PLAN, SELECT:#JV_LINE_SYNC_TARGET, SELECT:#DIVISION_LAST_PLAN_INFO, INSERT:SCP_ANL_PRODUCTION_PLAN_H, DELETE:SCP_ANL_PRODUCTION_PLAN, DELETE:PP, UPDATE:SCP_ANL_PRODUCTION_PLAN_FIX, SELECT:SCP_ANL_PRODUCTION_PLAN_FIX, EXEC:PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST, UPDATE:PF, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX_H, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_SITE |  |
| SystemManager.UP_FX_GetUserGroupAuthExtentionList | MATCH | 1 | SP UP_FX_GetUserGroupAuthExtentionList | EXEC:UP_FX_GETUSERGROUPAUTHEXTENTIONLIST, SELECT:SCM_MST_DIVISION, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_VENDOR, SELECT:SCM_MST_SITE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| CalculateSum | dr | measure |
| EditButton | dtIsEditInfo.Rows[0] | osp_yn, fp_plan_period, offset, edit_start_date, confirm_yn, date_chk, is_editable, plan_start_yyyymmdd, plan_type, plan_seq |
| EditButton | dtPlanType.Rows[dtPlanType.Rows.Count - 1] | CODE |
| FindButton | clbPlantSite.DataSource.Rows[i] | CODE |
| FindData_Division | ds.Tables[0].Rows[i] | Code, JV_PLANT_ID |
| GetLastPlanVersion | dsBinding.Tables[0].Rows[0] | PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ |
| SaveData_Line | dtErr.Rows[0] | ERR_MESSAGE |
| Set_FPOperationColor | dtIsEditInfo.Rows[0] | osp_yn, fp_plan_period, offset, edit_start_date, confirm_yn, date_chk, is_editable, plan_start_yyyymmdd, plan_type, plan_seq |
| Set_FPOperationColor | dtPlanType.Rows[dtPlanType.Rows.Count - 1] | CODE |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |
| SetFormationYield | dr | measure |
| SetFormationYield1 | dr | measure |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitSpread:285, InitSpread:334, SetChangedControl:998, SetChangedControl:1006, SetChangedControl:1065, SetChangedControl:1070, GetLastPlanVersion:1100, FindData_Model:1169 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:288 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:332, InitSpread:408 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:349, InitSpread:413 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnCal | Click | btnCal_Click | InitializeComponent:261 |
| this | Load | SCP0060_ProductionPlan_JV_Load | InitializeComponent:1126 |
| this | Load | Form_Load | .ctor:179 |
| dsdmLine | Changed | SpdLine_Changed | SetDataTableDateColumn:520 |
| dsdmLine | Changed | SpdLine_Changed | SetDataTableDateColumn:532 |
| dsdmLine | Changed | SpdLine_Changed | SetDataTableQtyData:538 |
| dsdmLine | Changed | SpdLine_Changed | SetDataTableQtyData:571 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:578 |
| this.spdLine | CellDoubleClick | spdLine_CellDoubleClick | InitEvent:579 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:581 |
| this.spdLine | TopChange | SpdLine_TopChange | InitEvent:582 |
| this.btnMeasure | Click | btnMeasure_Click | InitEvent:584 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:585 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:586 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:587 |
| cboOperationGroup | SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | InitEvent:590 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:592 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:593 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:594 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:595 |
| spdLine | SelectionChanged | SpdLine_SelectionChanged | InitEvent:597 |
| dsdmLine | Changed | SpdLine_Changed | InitEvent:600 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:1102 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:1103 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:1104 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:1143 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:1144 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:1145 |
| dsdmLine | Changed | SpdLine_Changed | SetFormationYield1:2283 |
| dsdmLine | Changed | SpdLine_Changed | SetFormationYield1:2302 |
| dsdmLine | Changed | SpdLine_Changed | SetFormationYield:2314 |
| dsdmLine | Changed | SpdLine_Changed | SetFormationYield:2418 |
| dsdmLine | Changed | SpdLine_Changed | CalculateSum:2431 |
| dsdmLine | Changed | SpdLine_Changed | CalculateSum:2543 |
| dsdmLine | Changed | SpdLine_Changed | CalculateSum:2551 |
| dsdmLine | Changed | SpdLine_Changed | CalculateSum:2668 |

## 6. 컨트롤 (47개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 16 | lblItemId, layoutControlItem2, layoutControlItem10, PlanType, PlanDate, Division, layoutControlItem1, layoutControlItem6, SEQ, layoutControlItem7, lblBucket, layoutControlItem8, layoutControlItem3, layoutControlItem9, layoutControlItem4 … |
| UsrCombo | 6 | cboOperationGroup, cboDivision, cboPlanSeq, cboPlanDate, cboPlanType, cboBucketType |
| EmptySpaceItem | 6 | emptySpaceItem10, emptySpaceItem6, emptySpaceItem9, emptySpaceItem3, emptySpaceItem1, emptySpaceItem7 |
| UsrButton | 4 | usrButton1, btnCal, btnMeasure, btnItemId |
| UsrCheckBox | 2 | chkAll, chkSum |
| UsrCheckedList | 2 | clbPlantSite, cboElectrode |
| FpSpread | 2 | spdMain, spdLine |
| SheetView | 2 | spdMain_Sheet1, spdLine_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker | 1 | drpPeriod |
| UsrMultiLineEditor | 1 | txtItemId |
| TextBox | 1 | txtNickName |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SplitContainer | 1 | splitContainer1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 36 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 10 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1196 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL_tuning3 | commented:NOT_IN_FOXQUERY |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0060 | Line | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SCP0060 | Model | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |
| SCM_MST_SHEET_MEASURE | SCP0060 | LINE | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 |
| SCM_MST_SHEET_MEASURE | SCP0060 | MODEL | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Model, Line
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:332, SetSheetHeaderColumn@InitSpread:408
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumn, InitSpreadDateColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 358 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Model") ⟫ if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread |  | 359 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Model") ⟫ if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread |  | 363 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Model") ⟫ else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread |  | 364 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Model") ⟫ else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread |  | 423 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Line") ⟫ if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread |  | 424 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Line") ⟫ if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread |  | 428 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Line") ⟫ else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread |  | 429 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Line") ⟫ else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpreadDateColumn |  | 469 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 473 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 477 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 927 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 932 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 939 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 943 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 948 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 955 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 959 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 1056 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1057 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1058 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1059 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Line | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 10 | 10 | 10 | 10 | 10 | 10 |
| Model | META+코드연결 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
