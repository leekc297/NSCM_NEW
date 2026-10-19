# SCP0083 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\POPUP\SCP0083_DIOReportAgingPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\SCP0083_DIOReport.csproj | 255 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\POPUP\SCP0083_DIOReportAgingPopup.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\SCP0083_DIOReport.csproj | 117 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\POPUP\SCP0083_DIOReportOperationPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\SCP0083_DIOReport.csproj | 260 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\POPUP\SCP0083_DIOReportOperationPopup.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\SCP0083_DIOReport.csproj | 117 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\POPUP\SCP0083_DIOReportPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\SCP0083_DIOReport.csproj | 201 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\POPUP\SCP0083_DIOReportPopup.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\SCP0083_DIOReport.csproj | 115 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\SCP0083_DIOReport.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\SCP0083_DIOReport.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\SCP0083_DIOReport.csproj | 3490 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\SCP0083_DIOReport.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0083_DIOReport\SCP0083_DIOReport.csproj | 747 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnVersionCreate.Click | BtnVersionCreate_Click > Find_Data | 551 | SCP.SCP0083_GET_DIO_REPORT | MATCH | SP SCP0083_GET_DIO_REPORT |
| event:btnVersionCreate.Click | BtnVersionCreate_Click > Find_Data > Find_Data_Cycle | 719 | SCP.SCP0083_GET_DIO_CYCLE_INVENTORY | MATCH | SP SCP0083_GET_DIO_CYCLE_INVENTORY |
| event:btnVersionCreate.Click | BtnVersionCreate_Click > SetSaveAfterChangedControl > SetComboVersion > GetVersionCombo | 1729 | SCP.SCP0083_GET_DIO_VERSION_INFO | MATCH | SP SCP0083_GET_DIO_VERSION_INFO |
| event:btnVersionCreate.Click | BtnVersionCreate_Click | 2934 | SCP.PR_SCP_ANL_DIO_REPORT | MATCH | SP PR_SCP_ANL_DIO_REPORT |
| event:btnVersionDelete.Click | BtnVersionDelete_Click > Find_Data | 551 | SCP.SCP0083_GET_DIO_REPORT | MATCH | SP SCP0083_GET_DIO_REPORT |
| event:btnVersionDelete.Click | BtnVersionDelete_Click > Find_Data > Find_Data_Cycle | 719 | SCP.SCP0083_GET_DIO_CYCLE_INVENTORY | MATCH | SP SCP0083_GET_DIO_CYCLE_INVENTORY |
| event:btnVersionDelete.Click | BtnVersionDelete_Click > SetSaveAfterChangedControl > SetComboVersion > GetVersionCombo | 1729 | SCP.SCP0083_GET_DIO_VERSION_INFO | MATCH | SP SCP0083_GET_DIO_VERSION_INFO |
| event:btnVersionDelete.Click | BtnVersionDelete_Click | 3041 | SCP.PR_SCP_ANL_DIO_REPORT_VERSION_DELETE | MATCH | SP PR_SCP_ANL_DIO_REPORT_VERSION_DELETE |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl > GetPlanCombo | 1710 | SCP.SCP0083_GET_PLAN_VERSION_INFO | MATCH | SP SCP0083_GET_PLAN_VERSION_INFO |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl > SetComboVersion > GetVersionCombo | 1729 | SCP.SCP0083_GET_DIO_VERSION_INFO | MATCH | SP SCP0083_GET_DIO_VERSION_INFO |
| event:cboPlan.SelectedIndexChanged | CboPlan_SelectedIndexChanged > SetComboVersion > GetVersionCombo | 1729 | SCP.SCP0083_GET_DIO_VERSION_INFO | MATCH | SP SCP0083_GET_DIO_VERSION_INFO |
| button:FindButton | FindButton > FindData | 152 | SCP.SCP0083_GET_DIO_OPERATION_LT | MATCH | SP SCP0083_GET_DIO_OPERATION_LT |
| button:FindButton | FindButton > FindData | 167 | SCP.SCP0083_GET_DIO_REPORT_H | MATCH | SP SCP0083_GET_DIO_REPORT_H |
| button:FindButton | FindButton > FindData | 170 | SCP.SCP0083_GET_DIO_AGING_LT | MATCH | SP SCP0083_GET_DIO_AGING_LT |
| button:FindButton | FindButton > Find_Data_Cycle > Find_Data | 551 | SCP.SCP0083_GET_DIO_REPORT | MATCH | SP SCP0083_GET_DIO_REPORT |
| button:FindButton | FindButton > Find_Data_Cycle | 719 | SCP.SCP0083_GET_DIO_CYCLE_INVENTORY | MATCH | SP SCP0083_GET_DIO_CYCLE_INVENTORY |
| button:SaveButton | SaveButton > SaveData_Cycle > Find_Data_Cycle > Find_Data | 551 | SCP.SCP0083_GET_DIO_REPORT | MATCH | SP SCP0083_GET_DIO_REPORT |
| button:SaveButton | SaveButton > SaveData_Cycle > Find_Data_Cycle | 719 | SCP.SCP0083_GET_DIO_CYCLE_INVENTORY | MATCH | SP SCP0083_GET_DIO_CYCLE_INVENTORY |
| button:SaveButton | SaveButton > SaveData_Main | 1055 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveDioReport] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData_Main | 1055 | SCP\Report\SCP0083_DIOReport#SaveDioReport | MATCH_PATTERN | SP SCP0083_SAVE_DIO_REPORT_ROW_DATASET |
| button:SaveButton | SaveButton > SaveData_Cycle | 1258 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveDioCycleInventory] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData_Cycle | 1258 | SCP\Report\SCP0083_DIOReport#SaveDioCycleInventory | MATCH_PATTERN | SP SCP0083_SAVE_DIO_CYCLE_INVENTORY_ROW_DATASET |
| button:SaveButton | SaveButton > SaveData_Cycle > SCM_SYS_LOG_BATCH | 2808 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.Load | Form_Load > FindData | 152 | SCP.SCP0083_GET_DIO_OPERATION_LT | MATCH | SP SCP0083_GET_DIO_OPERATION_LT |
| event:this.Load | Form_Load > FindData | 167 | SCP.SCP0083_GET_DIO_REPORT_H | MATCH | SP SCP0083_GET_DIO_REPORT_H |
| event:this.Load | Form_Load > FindData | 170 | SCP.SCP0083_GET_DIO_AGING_LT | MATCH | SP SCP0083_GET_DIO_AGING_LT |
| event:this.Load | Form_Load > InitControls > SetChangedControl > GetPlanCombo | 1710 | SCP.SCP0083_GET_PLAN_VERSION_INFO | MATCH | SP SCP0083_GET_PLAN_VERSION_INFO |
| event:this.Load | Form_Load > InitControls > SetChangedControl > SetComboVersion > GetVersionCombo | 1729 | SCP.SCP0083_GET_DIO_VERSION_INFO | MATCH | SP SCP0083_GET_DIO_VERSION_INFO |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveDioCycleInventory] | BIZ_MATCH | 1 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveDioReport] | BIZ_MATCH | 1 |  |  |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.PR_SCP_ANL_DIO_REPORT | MATCH | 1 | SP PR_SCP_ANL_DIO_REPORT | EXEC:PR_SCP_ANL_DIO_REPORT, SELECT:SCM_MST_DIVISION, EXEC:PR_SCP_SYS_LOG_BATCH, SELECT:SCP_ANL_DIO_REPORT_VERSION, INSERT:SCP_ANL_DIO_REPORT_VERSION, INSERT:#LAST_PLAN, SELECT:SCP_ANL_DIO_REPORT, INSERT:#LAST_PLAN_KEYIN, SELECT:#LAST_PLAN, INSERT:#REPORT1, SELECT:SCP_ANL_PSI_GLOBAL, SELECT:SCM_MST_SITE, INSERT:#SCM_MST_SITE, SELECT:SCM_MST_PLANT_SN, INSERT:#TMP_SCM_MST_MODEL_FINAL_ITEM_BOM_V, SELECT:SCM_MST_MODEL_FINAL_ITEM_BOM_V, INSERT:#TBLDYNAMICPIVOT_CLASS_TYPE_TEMP, SELECT:SCM_MST_ITEM_SN, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:#TMP_SCM_MST_MODEL_FINAL_ITEM_BOM_V, SELECT:#REPORT1, INSERT:#TBLDYNAMICPIVOT_CLASS_TYPE, SELECT:#TBLDYNAMICPIVOT_CLASS_TYPE_TEMP, INSERT:#REPORT1_1, SELECT:#TBLDYNAMICPIVOT_CLASS_TYPE, INSERT:#REPORT1_2, SELECT:#REPORT1_1, INSERT:#LINE_WEIGHT, SELECT:#REPORT1_2, INSERT:#SCP_MST_FORMATION_LINE_ITEM, SELECT:SCM_MST_AGING_ITEM_FLOW_M_SN, INSERT:#SCP_MST_FORMATION_LINE, SELECT:#SCP_MST_FORMATION_LINE_ITEM, INSERT:#AGING_LT, SELECT:#SCP_MST_FORMATION_LINE, SELECT:#LINE_WEIGHT, INSERT:#AGING_LT_N, SELECT:#AGING_LT, INSERT:#REPORT1_3, SELECT:#AGING_LT_N, DELETE:SCP_ANL_DIO_REPORT_DETAIL_AGING, INSERT:SCP_ANL_DIO_REPORT_DETAIL_AGING, SELECT:#REPORT1_3, INSERT:#OPERATION_LT, SELECT:SCP_MST_OPERATION_LT, INSERT:#SUMQTY_NICKNAME, INSERT:#BOD_WEIGHT, SELECT:#SUMQTY_NICKNAME, INSERT:#BOD_LT, SELECT:SCP_MST_BOD, SELECT:SCP_MST_DISTRIBUTION_ROUTE, INSERT:#DEPARTURE_LT, SELECT:#BOD_WEIGHT, SELECT:#BOD_LT, DELETE:SCP_ANL_DIO_REPORT_DETAIL, INSERT:SCP_ANL_DIO_REPORT_DETAIL, INSERT:#REPORT1_3_1, INSERT:#REPORT1_4, SELECT:#REPORT1_3_1 |  |
| SCP.PR_SCP_ANL_DIO_REPORT_VERSION_DELETE | MATCH | 1 | SP PR_SCP_ANL_DIO_REPORT_VERSION_DELETE | EXEC:PR_SCP_ANL_DIO_REPORT_VERSION_DELETE, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCP_ANL_DIO_REPORT_VERSION, EXEC:PR_SCP_SYS_LOG_BATCH, UPDATE:SCP_ANL_DIO_REPORT_VERSION, DELETE:SCP_ANL_DIO_REPORT, DELETE:SCP_ANL_DIO_REPORT_DETAIL, DELETE:SCP_ANL_DIO_REPORT_H, DELETE:SCP_ANL_DIO_CYCLE_INVENTORY, DELETE:SCP_ANL_DIO_REPORT_DETAIL_AGING, DELETE:SCP_ANL_DIO_REPORT_VERSION, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0083_GET_DIO_AGING_LT | MATCH | 1 | SP SCP0083_GET_DIO_AGING_LT | EXEC:SCP0083_GET_DIO_AGING_LT, SELECT:FDATA, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_PLANT_SN, SELECT:LINE_NAME_INFO, SELECT:SCM_MST_YIELD_SN, SELECT:FP_FORMATION_SHORTER_LT_M_SN, SELECT:SCP_ANL_DIO_REPORT_DETAIL_AGING, SELECT:SCM_MST_LINE_SN, SELECT:SCP_ANL_DIO_REPORT_DETAIL |  |
| SCP.SCP0083_GET_DIO_CYCLE_INVENTORY | MATCH | 1 | SP SCP0083_GET_DIO_CYCLE_INVENTORY | EXEC:SCP0083_GET_DIO_CYCLE_INVENTORY, INSERT:#TMP_SCP0083_A, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_ANL_DIO_CYCLE_INVENTORY, SELECT:MODEL_SUM, SELECT:NON_OPERATION, SELECT:GLOBAL_RATIO, SELECT:GLOBAL_SITE_RATIO, INSERT:#TMP_SCP0083_P, DYNAMIC@SCP0083_GET_DIO_CYCLE_INVENTORY |  |
| SCP.SCP0083_GET_DIO_OPERATION_LT | MATCH | 1 | SP SCP0083_GET_DIO_OPERATION_LT | EXEC:SCP0083_GET_DIO_OPERATION_LT, CREATE:#TMP_SCP0083_REPORT_DETAIL, INSERT:#TMP_SCP0083_REPORT_DETAIL, SELECT:SCP_ANL_DIO_REPORT_DETAIL, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_MST_BOD_V, SELECT:#TMP_SCP0083_REPORT_DETAIL |  |
| SCP.SCP0083_GET_DIO_REPORT | MATCH | 1 | SP SCP0083_GET_DIO_REPORT | EXEC:SCP0083_GET_DIO_REPORT, SELECT:AA, SELECT:SCP_ANL_DIO_REPORT |  |
| SCP.SCP0083_GET_DIO_REPORT_H | MATCH | 1 | SP SCP0083_GET_DIO_REPORT_H | EXEC:SCP0083_GET_DIO_REPORT_H, DYNAMIC@SCP0083_GET_DIO_REPORT_H |  |
| SCP.SCP0083_GET_DIO_VERSION_INFO | MATCH | 1 | SP SCP0083_GET_DIO_VERSION_INFO | EXEC:SCP0083_GET_DIO_VERSION_INFO, SELECT:SCP_ANL_DIO_REPORT_VERSION |  |
| SCP.SCP0083_GET_PLAN_VERSION_INFO | MATCH | 1 | SP SCP0083_GET_PLAN_VERSION_INFO | EXEC:SCP0083_GET_PLAN_VERSION_INFO, SELECT:SCP_ANL_DIO_REPORT, SELECT:SCP_PLAN_VERSION_V, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP\Report\SCP0083_DIOReport#SaveDioCycleInventory | MATCH_PATTERN | 1 | SP SCP0083_SAVE_DIO_CYCLE_INVENTORY_ROW_DATASET | EXEC:SCP0083_SAVE_DIO_CYCLE_INVENTORY_ROW_DATASET, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, UPDATE:A, SELECT:SCP_ANL_DIO_CYCLE_INVENTORY, INSERT:#SCP0083_CYCLE_SUM, SELECT:SCP_ANL_DIO_REPORT, SELECT:#SCP0083_CYCLE_SUM, SELECT:SCP_ANL_DIO_REPORT_H, INSERT:SCP_ANL_DIO_REPORT_H, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP\Report\SCP0083_DIOReport#SaveDioReport | MATCH_PATTERN | 1 | SP SCP0083_SAVE_DIO_REPORT_ROW_DATASET | EXEC:SCP0083_SAVE_DIO_REPORT_ROW_DATASET, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, UPDATE:A, SELECT:SCP_ANL_DIO_REPORT, SELECT:SCP_ANL_DIO_REPORT_H, INSERT:SCP_ANL_DIO_REPORT_H, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| BtnVersionCreate_Click | response.DataSet.Tables[0].Rows[0] | RESULT |
| BtnVersionDelete_Click | response.DataSet.Tables[0].Rows[0] | RESULT |
| BtnVersionDelete_Click | ds.Tables[0].Rows[0] | RESULT |
| CalculateTotalRatio | a | MODEL_SUM2 |
| EditButton | row | EDIT_CYCLE_VERSION |
| GetParamVersionRange | dtVersion.Rows[i] | CODE, NAME, data_range |
| SaveData_Cycle | dr | ACTIVE_FLAG, DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, VER, NICK_NAME, PLANT_ID, TRANSPORT_MODE_LINE, FROM_SITE, PACK_GROUP, OPERATION_GROUP, PRIVATE_FLAG, CYCLE, WEIGHT_CYCLE_STOCK, GLOBAL_MODEL_SUM, GLOBAL_SITE_RATIO, USER_ID, PROGRAM_ID, DEBUG_MODE |
| SaveData_Cycle | result.Rows[0] | result_code, err_code, err_message |
| SaveData_Main | dr | ACTIVE_FLAG, DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, VER, ITEM_ID, NICK_NAME, PLANT_ID, VERSION, FROM_SITE, CELL_AGING_LT, CELL_EOL_SHIPPING_LOT, PACK_INCOMMIN, PACK_OPERATION_LT, SHIPMENT_CELL_INSPECTION_LOAD, SHIPMENT_CELL_INSPECTION_WAITING, SHIPMENT_PACK_INSPECTION_LOAD, SHIPMENT_PACK_INSPECTION_WAITING, PRE_INSPECTION_CELL, PRE_INSPECTION_PACK, VMI_CELL, VMI_PACK, FOREIGN_CORP, RACK_BIZ, DEPARTURE_INTRANSIT_VMI, SAFETY_STOCK_CELL, SAFETY_STOCK_PACK, OTHER_STOCK_CELL, OTHER_STOCK_PACK, PRODUCTION_CYCLE_CELL, PRODUCTION_CYCLE_PACK, STANDARD_DIO, ASSEMBLY_QTY, ASSEMBLY_TYPE_RATIO, ASSEMBLY_TOTAL_RATIO, WEIGHT_DIO, SHIPMENT_CELL_SUM, SHIPMENT_PACK_SUM, SHIPMENT_SUM, USER_ID, PROGRAM_ID, DEBUG_MODE, ATTRIBUTE1 |
| SaveData_Main | result.Rows[0] | result_code, err_code, err_message |
| SetComboVersion | row | CODE, NAME |
| SetVisibleColumnCycle | row | DATA_RANGE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | InitSpread:109, InitSpread:105, InitSpread:107, SetSpreadInit:302, SetSpreadInit:316 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| GetCheckedListValue | Find_Data:523, Find_Data:530, Find_Data:535, Find_Data_Reset:629, Find_Data_Cycle:683, Find_Data_Cycle:684, Find_Data_Cycle:696, SaveData_Main:805 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:72 |
| this | Load | SCP0083_DIOReportAgingPopup_Load | InitializeComponent:102 |
| this | Load | Form_Load | .ctor:69 |
| this | Load | SCP0083_DIOReportOperationPopup_Load | InitializeComponent:102 |
| this | Load | Form_Load | .ctor:70 |
| this | Load | SCP0083_DIOReportPopup_Load | InitializeComponent:100 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:513 |
| this | Load | Form_Load | .ctor:234 |
| this.spdMain | ClipboardPasting | SpdMain_ClipboardPasting | InitEvent:326 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:327 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:328 |
| this.spdMain | EditChange | SpdMain_EditChange | InitEvent:329 |
| this.spdMain | TabIndexChanged | SpdMain_TabIndexChanged | InitEvent:330 |
| this.spdCycle | ClipboardPasting | SpdMain_ClipboardPasting | InitEvent:332 |
| this.spdCycle | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:333 |
| this.spdCycle | DragDrop | SpdCycle_DragDrop | InitEvent:334 |
| this.spdCycle | Change | SpdCycle_Change | InitEvent:335 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:337 |
| cboPlan | SelectedIndexChanged | CboPlan_SelectedIndexChanged | InitEvent:338 |
| cboVersion | SelectedIndexChanged | CboVersion_SelectedIndexChanged | InitEvent:339 |
| btnVersionCreate | Click | BtnVersionCreate_Click | InitEvent:340 |
| btnVersionDelete | Click | BtnVersionDelete_Click | InitEvent:341 |
| chkDetail | CheckedChanged | ChkDetail_CheckedChanged | InitEvent:342 |
| txtRange | CommonValueChanged | TxtRange_CommonValueChanged | InitEvent:343 |

## 6. 컨트롤 (34개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 8 | layoutDivision, layoutPlan, layoutDetail, layoutVerCreate, Range, Month, layoutVersion, layoutControlItem1 |
| FpSpread | 5 | spdMain, spdMain, spdMain, spdMain, spdCycle |
| SheetView | 5 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet, spdCycle_Sheet |
| UsrCombo | 3 | cboDivision, cboPlan, cboVersion |
| UsrButton | 2 | btnVersionCreate, btnVersionDelete |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem6 |
| TabPage | 2 | tabPage1, tabPage2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrLabel | 1 | usrLabel2 |
| UsrTextBox | 1 | txtRange |
| UsrCheckBox | 1 | chkDetail |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| TabControl | 1 | tabControl1 |

## 7. 확인 필요 (2건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1055 | SaveData_Main | {?definition_path}#SaveDioReport | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1258 | SaveData_Cycle | {?definition_path}#SaveDioCycleInventory | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 30 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 203 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 10 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 8 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0083 | Cycle Stock | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 | 32/0 |
| SCM_MST_SHEET_COLUMNS | SCP0083 | DIO Aging L/T | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 |
| SCM_MST_SHEET_COLUMNS | SCP0083 | DIO Operation L/T | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 |
| SCM_MST_SHEET_COLUMNS | SCP0083 | DIO Report | 71/0 | 71/0 | 71/0 | 71/0 | 71/0 | 71/0 | 71/0 | 71/0 | 71/0 | 71/0 | 71/0 | 71/0 | 71/0 | 71/0 |
| SCM_MST_SHEET_COLUMNS | SCP0083 | DIO Report History | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: DIO Aging L/T, DIO Operation L/T, DIO Report History, DIO Report, Cycle Stock
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:109, SetSheetHeaderColumn@InitSpread:105, SetSheetHeaderColumn@InitSpread:107, SetSheetHeaderColumn@SetSpreadInit:302, SetSheetHeaderColumn@SetSpreadInit:316
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetVisibleColumnCycle |  | 208 | 표시/라벨 변경 | SetColumnHeader | 0 | M1 | for(i < 13) ⟫ if("1"<= data_range) |
| SetVisibleColumnCycle |  | 212 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(month)} | M1 | for(i < 13) ⟫ else!("1"<= data_range) |
| InitializeComponent |  | 67 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 68 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 69 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 70 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 109 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.END_CUSTOMER)} | END_CUSTOMER | if(DIVISION_ID.Equals("81")) |
| InitSpread |  | 110 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)} | PRODUCTION_TYPE | if(DIVISION_ID.Equals("81")) |
| InitSpread |  | 111 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.EXTRA_SPEC)} | EXTRA_SPEC | if(DIVISION_ID.Equals("81")) |
| InitSpread |  | 112 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)} | CELL_ITEM_ID | if(DIVISION_ID.Equals("81")) |
| InitSpread |  | 117 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.END_CUSTOMER)} | END_CUSTOMER | else!(DIVISION_ID.Equals("81")) ⟫ if(DIVISION_ID.Equals("40")) |
| InitSpread |  | 118 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)} | PRODUCTION_TYPE | else!(DIVISION_ID.Equals("81")) ⟫ if(DIVISION_ID.Equals("40")) |
| InitSpread |  | 119 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.EXTRA_SPEC)} | EXTRA_SPEC | else!(DIVISION_ID.Equals("81")) ⟫ if(DIVISION_ID.Equals("40")) |
| InitSpread |  | 120 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)} | CELL_ITEM_ID | else!(DIVISION_ID.Equals("81")) ⟫ if(DIVISION_ID.Equals("40")) |
| InitSpread |  | 124 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.END_CUSTOMER)} | END_CUSTOMER | else!(DIVISION_ID.Equals("81")) ⟫ else!(DIVISION_ID.Equals("40")) ⟫ if(DIVISION_ID.Equals("82")) |
| InitSpread |  | 125 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)} | PRODUCTION_TYPE | else!(DIVISION_ID.Equals("81")) ⟫ else!(DIVISION_ID.Equals("40")) ⟫ if(DIVISION_ID.Equals("82")) |
| InitSpread |  | 126 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.EXTRA_SPEC)} | EXTRA_SPEC | else!(DIVISION_ID.Equals("81")) ⟫ else!(DIVISION_ID.Equals("40")) ⟫ if(DIVISION_ID.Equals("82")) |
| InitSpread |  | 127 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)} | CELL_ITEM_ID | else!(DIVISION_ID.Equals("81")) ⟫ else!(DIVISION_ID.Equals("40")) ⟫ if(DIVISION_ID.Equals("82")) |
| SetVisibleColumnCycle |  | 192 | 표시/라벨 변경 | SetColumnHeader | 0 | M1 | for(i < 13) ⟫ if("1"<= data_range) |
| SetVisibleColumnCycle |  | 196 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(month)} | M1 | for(i < 13) ⟫ else!("1"<= data_range) |
| InitializeComponent |  | 67 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 68 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 69 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 70 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 111 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.END_CUSTOMER)} | END_CUSTOMER | if(DIVISION_ID.Equals("81")) |
| InitSpread |  | 113 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)} | PRODUCTION_TYPE | if(DIVISION_ID.Equals("81")) |
| InitSpread |  | 114 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.EXTRA_SPEC)} | EXTRA_SPEC | if(DIVISION_ID.Equals("81")) |
| InitSpread |  | 116 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)} | CELL_ITEM_ID | if(DIVISION_ID.Equals("81")) |
| InitSpread |  | 122 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.END_CUSTOMER)} | END_CUSTOMER | else!(DIVISION_ID.Equals("81")) ⟫ if(DIVISION_ID.Equals("40")) |
| InitSpread |  | 124 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)} | PRODUCTION_TYPE | else!(DIVISION_ID.Equals("81")) ⟫ if(DIVISION_ID.Equals("40")) |
| InitSpread |  | 125 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.EXTRA_SPEC)} | EXTRA_SPEC | else!(DIVISION_ID.Equals("81")) ⟫ if(DIVISION_ID.Equals("40")) |
| InitSpread |  | 127 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)} | CELL_ITEM_ID | else!(DIVISION_ID.Equals("81")) ⟫ if(DIVISION_ID.Equals("40")) |
| InitSpread |  | 132 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.END_CUSTOMER)} | END_CUSTOMER | else!(DIVISION_ID.Equals("81")) ⟫ else!(DIVISION_ID.Equals("40")) ⟫ if(DIVISION_ID.Equals("82")) |
| InitSpread |  | 134 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)} | PRODUCTION_TYPE | else!(DIVISION_ID.Equals("81")) ⟫ else!(DIVISION_ID.Equals("40")) ⟫ if(DIVISION_ID.Equals("82")) |
| InitSpread |  | 135 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.EXTRA_SPEC)} | EXTRA_SPEC | else!(DIVISION_ID.Equals("81")) ⟫ else!(DIVISION_ID.Equals("40")) ⟫ if(DIVISION_ID.Equals("82")) |
| InitSpread |  | 137 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)} | CELL_ITEM_ID | else!(DIVISION_ID.Equals("81")) ⟫ else!(DIVISION_ID.Equals("40")) ⟫ if(DIVISION_ID.Equals("82")) |
| FindData |  | 159 | 표시/라벨 변경 | SetColumnHeader | 0 | SEL_COLUMN |  |
| InitializeComponent |  | 65 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 66 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 67 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 68 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetLayout |  | 1821 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION)} | FROM_SITE_DESCRIPTION | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1822 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.END_CUSTOMER)} | END_CUSTOMER | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1823 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)} | PRODUCTION_TYPE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1824 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.EXTRA_SPEC)} | EXTRA_SPEC | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1825 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.NICK_NAME)} | NICK_NAME | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1826 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.ITEM_ID)} | ITEM_ID | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1827 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)} | CELL_ITEM_ID | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1828 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.BIZ_TYPE)} | BIZ_TYPE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1829 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.INCOTERMS)} | INCOTERMS | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1830 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.CELL_AGING_LT)} | CELL_AGING_LT | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1831 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.CELL_EOL_SHIPPING_LOT)} | CELL_EOL_SHIPPING_LOT | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1832 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.CELL_SUM)} | CELL_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1833 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PACK_INCOMMING)} | PACK_INCOMMING | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1834 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PACK_OPERATION_LT)} | PACK_OPERATION_LT | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1835 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PACK_SUM)} | PACK_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1836 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SHIPMENT_CELL_SUM)} | SHIPMENT_CELL_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1837 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SHIPMENT_PACK_SUM)} | SHIPMENT_PACK_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1838 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SHIPMENT_SUM)} | SHIPMENT_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1839 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_DEPARTURE_DAYS)} | DNI_CELL_DEPARTURE_DAYS | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1840 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_DEPARTURE_INLAND)} | DNI_CELL_DEPARTURE_INLAND | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1841 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_WAITING_FOR_SHIPPING)} | DNI_CELL_WAITING_FOR_SHIPPING | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1842 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_VOYAGE)} | DNI_CELL_VOYAGE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1843 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE)} | DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1844 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_ARRIVAL_INLAND)} | DNI_CELL_ARRIVAL_INLAND | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1845 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_SUM)} | DNI_CELL_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1846 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_DEPARTURE_DAYS)} | DNI_PACK_DEPARTURE_DAYS | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1847 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_DEPARTURE_INLAND)} | DNI_PACK_DEPARTURE_INLAND | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1848 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_WAITING_FOR_SHIPPING)} | DNI_PACK_WAITING_FOR_SHIPPING | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1849 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_VOYAGE)} | DNI_PACK_VOYAGE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1850 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE)} | DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1851 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_ARRIVAL_INLAND)} | DNI_PACK_ARRIVAL_INLAND | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1852 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_SUM)} | DNI_PACK_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1853 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_DEPARTURE_DAYS_SUM)} | DNI_DEPARTURE_DAYS_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1854 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_DEPARTURE_INLAND_SUM)} | DNI_DEPARTURE_INLAND_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1855 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_WAITING_FOR_SHIPPING_SUM)} | DNI_WAITING_FOR_SHIPPING_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1856 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_VOYAGE_SUM)} | DNI_VOYAGE_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1857 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_LAY_OFF_CUSTOMS_CLEARANCE_SUM)} | DNI_LAY_OFF_CUSTOMS_CLEARANCE_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1858 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_ARRIVAL_INLAND_SUM)} | DNI_ARRIVAL_INLAND_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1859 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_SUM)} | DNI_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1860 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_CELL)} | PRE_INSPECTION_CELL | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1861 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_PACK)} | PRE_INSPECTION_PACK | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1862 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_SUM)} | PRE_INSPECTION_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1863 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.VMI_CELL)} | VMI_CELL | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1864 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.VMI_PACK)} | VMI_PACK | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1865 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.VMI_SUM)} | VMI_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1866 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.FOREIGN_CORP)} | FOREIGN_CORP | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1867 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.RACK_BIZ)} | RACK_BIZ | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1868 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_CELL)} | SAFETY_STOCK_CELL | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1869 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_PACK)} | SAFETY_STOCK_PACK | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1870 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_PIN_HOUSE)} | SAFETY_STOCK_PIN_HOUSE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1871 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_SUM)} | SAFETY_STOCK_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1872 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.OTHER_STOCK_CELL)} | OTHER_STOCK_CELL | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1873 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.OTHER_STOCK_PACK)} | OTHER_STOCK_PACK | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1874 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.OTHER_STOCK_SUM)} | OTHER_STOCK_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1875 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_CELL)} | PRODUCTION_CYCLE_CELL | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1876 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_PACK)} | PRODUCTION_CYCLE_PACK | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1877 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_SUM)} | PRODUCTION_CYCLE_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1878 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.STANDARD_DIO_AUTO)} | STANDARD_DIO_AUTO | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1879 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.ASSEMBLY_QTY)} | ASSEMBLY_QTY | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1880 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.ASSEMBLY_TYPE_RATIO)} | ASSEMBLY_TYPE_RATIO | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1881 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.ASSEMBLY_TOTAL_RATIO)} | ASSEMBLY_TOTAL_RATIO | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1882 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.WEIGHT_DIO_AUTO)} | WEIGHT_DIO_AUTO | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1883 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.OP_LT_TOTAL_AUTO)} | OP_LT_TOTAL_AUTO | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1884 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.CYCLE_TOTAL_AUTO)} | CYCLE_TOTAL_AUTO | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1885 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.INTRANSIT_TOTAL_AUTO)} | INTRANSIT_TOTAL_AUTO | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1886 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.WEIGHT_OPEARTION_TYPE_AUTO)} | WEIGHT_OPEARTION_TYPE_AUTO | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1887 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.WEIGHT_OPEARTION_TOTAL_AUTO)} | WEIGHT_OPEARTION_TOTAL_AUTO | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1888 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.WEIGHT_CYCLE_TYPE_AUTO)} | WEIGHT_CYCLE_TYPE_AUTO | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1889 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.WEIGHT_CYCLE_TOTAL_AUTO)} | WEIGHT_CYCLE_TOTAL_AUTO | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1890 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.WEIGHT_INTRANSIT_TYPE_AUTO)} | WEIGHT_INTRANSIT_TYPE_AUTO | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1891 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.WEIGHT_INTRANSIT_TOTAL_AUTO)} | WEIGHT_INTRANSIT_TOTAL_AUTO | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) |
| SetLayout |  | 1898 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.NICK_NAME)} | NICK_NAME | if(p_division_id.Equals("81")) |
| SetLayout |  | 1899 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.ITEM_ID)} | ITEM_ID | if(p_division_id.Equals("81")) |
| SetLayout |  | 1900 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.MODEL_AVG)} | MODEL_AVG | if(p_division_id.Equals("81")) |
| SetLayout |  | 1901 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.EXTRA_SPEC)} | EXTRA_SPEC | if(p_division_id.Equals("81")) |
| SetLayout |  | 1902 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.PACK_GROUP)} | PACK_GROUP | if(p_division_id.Equals("81")) |
| SetLayout |  | 1903 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.CELL_GROUP)} | CELL_GROUP | if(p_division_id.Equals("81")) |
| SetLayout |  | 1904 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.CELL_TYPE_GROUP_CODE)} | CELL_TYPE_GROUP_CODE | if(p_division_id.Equals("81")) |
| SetLayout |  | 1905 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.PRIVATE_FLAG)} | PRIVATE_FLAG | if(p_division_id.Equals("81")) |
| SetLayout |  | 1906 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.CYCLE)} | CYCLE | if(p_division_id.Equals("81")) |
| SetLayout |  | 1911 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.NICK_NAME)} | NICK_NAME | else!(p_division_id.Equals("81")) ⟫ if(p_division_id.Equals("40")) |
| SetLayout |  | 1912 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.ITEM_ID)} | ITEM_ID | else!(p_division_id.Equals("81")) ⟫ if(p_division_id.Equals("40")) |
| SetLayout |  | 1913 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.MODEL_AVG)} | MODEL_AVG | else!(p_division_id.Equals("81")) ⟫ if(p_division_id.Equals("40")) |
| SetLayout |  | 1914 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.EXTRA_SPEC)} | EXTRA_SPEC | else!(p_division_id.Equals("81")) ⟫ if(p_division_id.Equals("40")) |
| SetLayout |  | 1915 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.PACK_GROUP)} | PACK_GROUP | else!(p_division_id.Equals("81")) ⟫ if(p_division_id.Equals("40")) |
| SetLayout |  | 1916 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.CELL_GROUP)} | CELL_GROUP | else!(p_division_id.Equals("81")) ⟫ if(p_division_id.Equals("40")) |
| SetLayout |  | 1917 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.CELL_TYPE_GROUP_CODE)} | CELL_TYPE_GROUP_CODE | else!(p_division_id.Equals("81")) ⟫ if(p_division_id.Equals("40")) |
| SetLayout |  | 1918 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.PRIVATE_FLAG)} | PRIVATE_FLAG | else!(p_division_id.Equals("81")) ⟫ if(p_division_id.Equals("40")) |
| SetLayout |  | 1919 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.CYCLE)} | CYCLE | else!(p_division_id.Equals("81")) ⟫ if(p_division_id.Equals("40")) |
| SetLayout |  | 1925 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.NICK_NAME)} | NICK_NAME | else!(p_division_id.Equals("81")) ⟫ else!(p_division_id.Equals("40")) ⟫ if(p_division_id.Equals("82")) |
| SetLayout |  | 1926 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.ITEM_ID)} | ITEM_ID | else!(p_division_id.Equals("81")) ⟫ else!(p_division_id.Equals("40")) ⟫ if(p_division_id.Equals("82")) |
| SetLayout |  | 1927 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.MODEL_AVG)} | MODEL_AVG | else!(p_division_id.Equals("81")) ⟫ else!(p_division_id.Equals("40")) ⟫ if(p_division_id.Equals("82")) |
| SetLayout |  | 1928 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.EXTRA_SPEC)} | EXTRA_SPEC | else!(p_division_id.Equals("81")) ⟫ else!(p_division_id.Equals("40")) ⟫ if(p_division_id.Equals("82")) |
| SetLayout |  | 1929 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.PACK_GROUP)} | PACK_GROUP | else!(p_division_id.Equals("81")) ⟫ else!(p_division_id.Equals("40")) ⟫ if(p_division_id.Equals("82")) |
| SetLayout |  | 1930 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.CELL_GROUP)} | CELL_GROUP | else!(p_division_id.Equals("81")) ⟫ else!(p_division_id.Equals("40")) ⟫ if(p_division_id.Equals("82")) |
| SetLayout |  | 1931 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.CELL_TYPE_GROUP_CODE)} | CELL_TYPE_GROUP_CODE | else!(p_division_id.Equals("81")) ⟫ else!(p_division_id.Equals("40")) ⟫ if(p_division_id.Equals("82")) |
| SetLayout |  | 1932 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.PRIVATE_FLAG)} | PRIVATE_FLAG | else!(p_division_id.Equals("81")) ⟫ else!(p_division_id.Equals("40")) ⟫ if(p_division_id.Equals("82")) |
| SetLayout |  | 1933 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(DefColumns.CYCLE)} | CYCLE | else!(p_division_id.Equals("81")) ⟫ else!(p_division_id.Equals("40")) ⟫ if(p_division_id.Equals("82")) |
| SetLoadSpreadColumn |  | 2137 | 표시/라벨 변경 | set:Font | Font = {?new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)))} |  | for(j < siMain.ActiveSheet.ColumnCount) |
| SetSpreadColumn |  | 2271 | 표시/라벨 변경 | set:Font | Font = {?fontCellBold} |  | else!(isEditAfter) ⟫ for(j < siMain.ActiveSheet.ColumnCount) |
| SetSpreadColumn |  | 2290 | 표시/라벨 변경 | set:Font | Font = {?fontCellBold} |  | else!(isEditAfter) ⟫ for(j < siMain.ActiveSheet.ColumnCount) ⟫ switch(colTag)case "CELL_SUM"/"PACK_SUM"/"SHIPMENT_SUM"/"DNI_CELL_SUM"/"DNI_PACK_SUM"/"DNI_SUM"/"PRE_INSPECTION_SUM"/"SAFETY_STOCK_SUM"/"PRODUCTION_CYCLE_SUM"/"STANDARD_DIO_AUTO"/"VMI_SUM"/"OTHER_STOCK_SUM" |
| SetSpreadColumn |  | 2307 | 표시/라벨 변경 | set:BackColor | BackColor = {?DefGridColor.Gainsboro} |  | else!(isEditAfter) ⟫ for(j < siMain.ActiveSheet.ColumnCount) ⟫ switch(colTag)case "CELL_SUM"/"PACK_SUM"/"SHIPMENT_SUM"/"DNI_SUM"/"PRE_INSPECTION_SUM"/"SAFETY_STOCK_SUM"/"PRODUCTION_CYCLE_SUM"/"VMI_SUM"/"OTHER_STOCK_SUM" |
| SetSpreadColumn |  | 2312 | 표시/라벨 변경 | set:BackColor | BackColor = {?DefGridColor.Honeydew} |  | else!(isEditAfter) ⟫ for(j < siMain.ActiveSheet.ColumnCount) ⟫ switch(colTag)case "DNI_CELL_SUM"/"DNI_PACK_SUM" |
| SetSpreadColumn |  | 2316 | 표시/라벨 변경 | set:BackColor | BackColor = {?DefGridColor.MistyRose} |  | else!(isEditAfter) ⟫ for(j < siMain.ActiveSheet.ColumnCount) ⟫ switch(colTag)case "STANDARD_DIO_AUTO" |
| SetSpreadColumn |  | 2319 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?DefGridColor.Black} |  | else!(isEditAfter) ⟫ for(j < siMain.ActiveSheet.ColumnCount) ⟫ switch(colTag)case  |
| SetSpreadColumn |  | 2329 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?DefGridColor.Black} |  | else!(isEditAfter) ⟫ for(j < siMain.ActiveSheet.ColumnCount) ⟫ switch(colTag)case "SHIPMENT_CELL_SUM"/"SHIPMENT_PACK_SUM" |
| SetVisibleColumnCycle |  | 2430 | 표시/라벨 변경 | SetColumnHeader | 0 | M1 | for(i < 13) ⟫ if("1"<= data_range) |
| SetVisibleColumnCycle |  | 2434 | 표시/라벨 변경 | VisibleColumns | {?siCycle.GetColumnIndex(month)} | M1 | for(i < 13) ⟫ else!("1"<= data_range) |
| SetDetailSetting |  | 2694 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SHIPMENT_CELL_SUM)} | SHIPMENT_CELL_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2697 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SHIPMENT_PACK_SUM)} | SHIPMENT_PACK_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2699 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_DEPARTURE_DAYS)} | DNI_CELL_DEPARTURE_DAYS | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2700 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_DEPARTURE_INLAND)} | DNI_CELL_DEPARTURE_INLAND | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2701 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_WAITING_FOR_SHIPPING)} | DNI_CELL_WAITING_FOR_SHIPPING | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2702 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_VOYAGE)} | DNI_CELL_VOYAGE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2703 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE)} | DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2704 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_ARRIVAL_INLAND)} | DNI_CELL_ARRIVAL_INLAND | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2706 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_DEPARTURE_DAYS)} | DNI_PACK_DEPARTURE_DAYS | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2707 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_DEPARTURE_INLAND)} | DNI_PACK_DEPARTURE_INLAND | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2708 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_WAITING_FOR_SHIPPING)} | DNI_PACK_WAITING_FOR_SHIPPING | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2709 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_VOYAGE)} | DNI_PACK_VOYAGE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2710 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE)} | DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2711 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_ARRIVAL_INLAND)} | DNI_PACK_ARRIVAL_INLAND | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2715 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.CELL_AGING_LT)} | CELL_AGING_LT | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2716 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.CELL_EOL_SHIPPING_LOT)} | CELL_EOL_SHIPPING_LOT | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2717 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PACK_INCOMMING)} | PACK_INCOMMING | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2718 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PACK_OPERATION_LT)} | PACK_OPERATION_LT | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2719 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SHIPMENT_CELL_SUM)} | SHIPMENT_CELL_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2720 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SHIPMENT_PACK_SUM)} | SHIPMENT_PACK_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2722 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_DEPARTURE_DAYS_SUM)} | DNI_DEPARTURE_DAYS_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2723 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_DEPARTURE_INLAND_SUM)} | DNI_DEPARTURE_INLAND_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2724 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_WAITING_FOR_SHIPPING_SUM)} | DNI_WAITING_FOR_SHIPPING_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2725 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_VOYAGE_SUM)} | DNI_VOYAGE_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2726 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_LAY_OFF_CUSTOMS_CLEARANCE_SUM)} | DNI_LAY_OFF_CUSTOMS_CLEARANCE_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2727 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_ARRIVAL_INLAND_SUM)} | DNI_ARRIVAL_INLAND_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2730 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_CELL)} | PRE_INSPECTION_CELL | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2731 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_PACK)} | PRE_INSPECTION_PACK | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2734 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_CELL)} | SAFETY_STOCK_CELL | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2735 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_PACK)} | SAFETY_STOCK_PACK | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2736 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_PIN_HOUSE)} | SAFETY_STOCK_PIN_HOUSE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2739 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_CELL)} | PRODUCTION_CYCLE_CELL | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2740 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_PACK)} | PRODUCTION_CYCLE_PACK | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ if(chkDetail.Checked) |
| SetDetailSetting |  | 2748 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SHIPMENT_CELL_SUM)} | SHIPMENT_CELL_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2751 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SHIPMENT_PACK_SUM)} | SHIPMENT_PACK_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2753 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_DEPARTURE_DAYS)} | DNI_CELL_DEPARTURE_DAYS | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2754 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_DEPARTURE_INLAND)} | DNI_CELL_DEPARTURE_INLAND | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2755 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_WAITING_FOR_SHIPPING)} | DNI_CELL_WAITING_FOR_SHIPPING | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2756 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_VOYAGE)} | DNI_CELL_VOYAGE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2757 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE)} | DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2758 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_CELL_ARRIVAL_INLAND)} | DNI_CELL_ARRIVAL_INLAND | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2760 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_DEPARTURE_DAYS)} | DNI_PACK_DEPARTURE_DAYS | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2761 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_DEPARTURE_INLAND)} | DNI_PACK_DEPARTURE_INLAND | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2762 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_WAITING_FOR_SHIPPING)} | DNI_PACK_WAITING_FOR_SHIPPING | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2763 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_VOYAGE)} | DNI_PACK_VOYAGE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2764 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE)} | DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2765 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_PACK_ARRIVAL_INLAND)} | DNI_PACK_ARRIVAL_INLAND | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2769 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.CELL_AGING_LT)} | CELL_AGING_LT | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2770 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.CELL_EOL_SHIPPING_LOT)} | CELL_EOL_SHIPPING_LOT | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2771 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PACK_INCOMMING)} | PACK_INCOMMING | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2772 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PACK_OPERATION_LT)} | PACK_OPERATION_LT | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2773 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SHIPMENT_CELL_SUM)} | SHIPMENT_CELL_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2774 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SHIPMENT_PACK_SUM)} | SHIPMENT_PACK_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2776 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_DEPARTURE_DAYS_SUM)} | DNI_DEPARTURE_DAYS_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2777 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_DEPARTURE_INLAND_SUM)} | DNI_DEPARTURE_INLAND_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2778 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_WAITING_FOR_SHIPPING_SUM)} | DNI_WAITING_FOR_SHIPPING_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2779 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_VOYAGE_SUM)} | DNI_VOYAGE_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2780 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_LAY_OFF_CUSTOMS_CLEARANCE_SUM)} | DNI_LAY_OFF_CUSTOMS_CLEARANCE_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2781 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.DNI_ARRIVAL_INLAND_SUM)} | DNI_ARRIVAL_INLAND_SUM | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2784 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_CELL)} | PRE_INSPECTION_CELL | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2785 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_PACK)} | PRE_INSPECTION_PACK | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2788 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_CELL)} | SAFETY_STOCK_CELL | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2789 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_PACK)} | SAFETY_STOCK_PACK | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2790 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_PIN_HOUSE)} | SAFETY_STOCK_PIN_HOUSE | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2793 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_CELL)} | PRODUCTION_CYCLE_CELL | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| SetDetailSetting |  | 2794 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_PACK)} | PRODUCTION_CYCLE_PACK | if(siMain.ActiveSheet.SheetName.Equals("DIO Report")) ⟫ else!(chkDetail.Checked) |
| InitializeComponent |  | 529 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 530 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 531 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 532 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 592 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 593 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 594 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 595 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Cycle Stock | META+코드연결 | 27 (?1) | 27 (?1) | 31 (?1) | 31 (?1) | 31 (?1) | 31 (?1) | 31 (?1) | 27 (?1) | 31 (?1) | 31 (?1) | 31 (?1) | 31 (?1) | 31 (?1) | 31 (?1) |
| DIO Aging L/T | META+코드연결 | 25 (?1) | 25 (?1) | 25 (?1) | 25 (?1) | 25 (?1) | 25 (?1) | 25 (?1) | 25 (?1) | 25 (?1) | 25 (?1) | 25 (?1) | 25 (?1) | 25 (?1) | 25 (?1) |
| DIO Operation L/T | META+코드연결 | 35 (?1) | 33 (?1) | 32 (?1) | 32 (?1) | 32 (?1) | 32 (?1) | 32 (?1) | 33 (?1) | 32 (?1) | 32 (?1) | 32 (?1) | 32 (?1) | 32 (?1) | 32 (?1) |
| DIO Report | META+코드연결 | 42 (?72) | 42 (?72) | 40 (?72) | 40 (?72) | 40 (?72) | 40 (?72) | 40 (?72) | 42 (?72) | 40 (?72) | 40 (?72) | 40 (?72) | 40 (?72) | 40 (?72) | 40 (?72) |
| DIO Report History | META+코드연결 | 11 | 9 | 12 | 12 | 12 | 12 | 12 | 9 | 12 | 12 | 12 | 12 | 12 | 12 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:화면컨트롤값 924, 정적평가 미지원식 56 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 980건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
