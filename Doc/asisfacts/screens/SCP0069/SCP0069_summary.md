# SCP0069 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0069_GlobalPSI_EE\POPUP\SCPAnalysisScp0069Popup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0069_GlobalPSI_EE\SCP0069_GlobalPSI_EE.csproj | 291 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0069_GlobalPSI_EE\POPUP\SCPAnalysisScp0069Popup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0069_GlobalPSI_EE\SCP0069_GlobalPSI_EE.csproj | 289 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0069_GlobalPSI_EE\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0069_GlobalPSI_EE\SCP0069_GlobalPSI_EE.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0069_GlobalPSI_EE\SCP0069_GlobalPSI_EE.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0069_GlobalPSI_EE\SCP0069_GlobalPSI_EE.csproj | 1932 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0069_GlobalPSI_EE\SCP0069_GlobalPSI_EE.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0069_GlobalPSI_EE\SCP0069_GlobalPSI_EE.csproj | 959 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > InitSpread > GetSpdTitle | 1869 | SCP.SCP0069_GET_SPREAD_TITLE | MATCH | SP SCP0069_GET_SPREAD_TITLE |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 1911 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 1883 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 183 | SCP.SCP0069_LOOKUP_DATA | MATCH | SP SCP0069_LOOKUP_DATA |
| button:FindButton | FindButton > FindData_Main | 468 | SCP.SCP0069_GET_GLOBAL_PSI_EE | MATCH | SP SCP0069_GET_GLOBAL_PSI_EE |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 1869 | SCP.SCP0069_GET_SPREAD_TITLE | MATCH | SP SCP0069_GET_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 468 | SCP.SCP0069_GET_GLOBAL_PSI_EE | MATCH | SP SCP0069_GET_GLOBAL_PSI_EE |
| button:SaveButton | SaveButton > SaveData | 1531 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveGlobalPsiEE] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1531 | SCP\Analysis\SCP0069_GlobalPSI_EE#SaveGlobalPsiEE | MATCH_PATTERN | SP SCP0069_SAVE_GLOBAL_PSI_EE |
| button:SaveButton | SaveButton > SaveData > SCM_SYS_LOG_BATCH | 1764 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| button:SaveButton | SaveButton > SaveData > FindData_Main > InitSpread > GetSpdTitle | 1869 | SCP.SCP0069_GET_SPREAD_TITLE | MATCH | SP SCP0069_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > FindData | 183 | SCP.SCP0069_LOOKUP_DATA | MATCH | SP SCP0069_LOOKUP_DATA |
| event:this.Load | Form_Load > InitControls > SetCombo | 351 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetCombo > GetComboInfo | 1835 | SCP.SCP0069_GET_PLANT_EE | MATCH | SP SCP0069_GET_PLANT_EE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1857 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1869 | SCP.SCP0069_GET_SPREAD_TITLE | MATCH | SP SCP0069_GET_SPREAD_TITLE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveGlobalPsiEE] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0069_GET_GLOBAL_PSI_EE | MATCH | 1 | SP SCP0069_GET_GLOBAL_PSI_EE | EXEC:SCP0069_GET_GLOBAL_PSI_EE, INSERT:#TMP_SCP0069_MEASURE, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#TMP_SCP0069_DAILY, SELECT:SCP_XLS_PSI_GLOBAL_ELECTRODE, SELECT:#TMP_SCP0069_MEASURE, REF:STRING_SPLIT, INSERT:#TMP_SCP0069_WEEKLY, SELECT:#TMP_SCP0069_DAILY, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@SCP0069_GET_GLOBAL_PSI_EE |  |
| SCP.SCP0069_GET_PLANT_EE | MATCH | 1 | SP SCP0069_GET_PLANT_EE | EXEC:SCP0069_GET_PLANT_EE, SELECT:SCM_MST_SITE, SELECT:SCP_XLS_PSI_GLOBAL_ELECTRODE, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0069_GET_SPREAD_TITLE | MATCH | 1 | SP SCP0069_GET_SPREAD_TITLE | EXEC:SCP0069_GET_SPREAD_TITLE, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0069_LOOKUP_DATA | MATCH | 1 | SP SCP0069_LOOKUP_DATA | EXEC:SCP0069_LOOKUP_DATA, SELECT:SCP_XLS_PSI_GLOBAL_ELECTRODE, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:SCM_MST_TACT_TIME_SN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP\Analysis\SCP0069_GlobalPSI_EE#SaveGlobalPsiEE | MATCH_PATTERN | 1 | SP SCP0069_SAVE_GLOBAL_PSI_EE | EXEC:SCP0069_SAVE_GLOBAL_PSI_EE, EXEC:PR_SCP_SYS_LOG_BATCH, MERGE:SCP_XLS_PSI_GLOBAL_ELECTRODE, CREATE:#SCP_ANL_PRODUCTION_PLAN, INSERT:#SCP_ANL_PRODUCTION_PLAN, SELECT:SCP_XLS_PSI_GLOBAL_ELECTRODE, SELECT:SCM_SYS_CALENDAR_M, INSERT:SCP_ANL_PRODUCTION_PLAN, MERGE:SCP_ANL_PRODUCTION_PLAN, SELECT:#SCP_ANL_PRODUCTION_PLAN, INSERT:SCP_ANL_PRODUCTION_PLAN_H, UPDATE:X, SELECT:SCP_ANL_PRODUCTION_PLAN_FIX, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX_H, INSERT:#TBL_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:#TBL_ADM_LOOKUP_MASTER_DETAIL, INSERT:SCM_ADM_LOOKUP_MASTER_DETAIL_H, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InitSpreadDateColumn | dr | COLUMN_NAME, COLUMN_LABEL, SMALL_LABEL_NAME |
| InputScript | dtCalendar.Rows[iRow] | WEEK_NAME, DAY_NAME |
| INVENTORY_PRE_DIO | row | SUPPLY_SITE, ITEM_ID, ELECTRODE_TYPE, PX |
| INVENTORY_PRE_DIO | c | MEASURE, SUPPLY_SITE, ITEM_ID, ELECTRODE_TYPE |
| INVENTORY_PRE_DIO | drInventoryTotal | PX |
| INVENTORY_PRE_DIO | row2 | PX |
| INVENTORY_TOTAL | row | SUPPLY_SITE, ITEM_ID, ELECTRODE_TYPE, PX |
| INVENTORY_TOTAL | row2 | PX |
| INVENTORY_TOTAL | row3 | PX |
| PROD_PLAN_TOTAL | row | SUPPLY_SITE, ITEM_ID, ELECTRODE_TYPE, PX |
| SaveData | dr | ACTIVE_FLAG, DIVISION_ID, PLAN_START_YYYYMMDD, CREATE_FROM_YYYYMMDD, CREATE_TO_YYYYMMDD, PLAN_TYPE, SEQ, CELL_TYPE_GROUP_CODE, SUPPLY_SITE, SUPPLY_SITE_DESC, NICK_NAME, ITEM_ID, ELECTRODE_TYPE, TO_SITE_ID, TO_SITE_DESCRIPTION, LT_WEEK, CONVERT_QTY_CELL, PROD_LINE, PSI_TYPE, MEASURE, MEASURE_LABEL, MEASURE_VALUE1, MEASURE_VALUE1_LABEL, MEASURE_VALUE2, MEASURE_VALUE2_LABEL, CELL_ITEM_ID, UNIT, SORT_ORDER_NO, ATTRIBUTE1, ATTRIBUTE3, ATTRIBUTE8, ATTRIBUTE9, XLS_KEY1, XLS_ATTRIBUTE1, BOH, USER_ID |
| SaveData | dsInput.Tables[0].Rows[0] | DIVISION_ID |
| SaveData | result.Rows[0] | result_code, err_message |
| SetFormulaLowFormat | row | PX |
| SHIP_PLAN_TOTAL | row | SUPPLY_SITE, ITEM_ID, ELECTRODE_TYPE, PX |
| SpdMain_CellDoubleClick | row | ITEM_ID |
| Y_SUM | row | SUPPLY_SITE, ITEM_ID, ELECTRODE_TYPE, PX |
| Y_SUM | row2 | CELL_ITEM_ID, PX |
| Y_SUM | row3 | MEASURE_VALUE2_LABEL, PX |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SaveData | BtnSave_Click:268, SaveButton:425 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetSpdTitle | InitSpread:281 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:282 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:283 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetCheckedListValue | SetCombo:318, SetCombo:340, SetCombo:350, FindData_Main:447, FindData_Main:449, FindData_Main:455, FindData_Main:456, FindData_Main:457 | CString.GetCheckedListValue | CODE |
| SetRowVisible | FindData_Main:503 | MeasureService.SetRowVisible | CATEGORY_ID, DATA_TYPE, _MM_ |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:87 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:120 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:121 |
| btnSave | Click | BtnSave_Click | InitEvent:122 |
| this | Load | Form_Load | .ctor:187 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:204 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:205 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:206 |
| this.btnNew | Click | BtnNew_Click | InitEvent:207 |
| this.BtnCalculation | Click | BtnCalculation_Click | InitEvent:208 |
| this.chkAutoCalculation | CheckedChanged | chkAutoCalculation_CheckedChanged | InitializeComponent:247 |

## 6. 컨트롤 (45개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 14 | layoutControlItem2, PlanDate, lblToSite, lblItemId, layoutControlItem4, layoutControlItem13, lblBucket, PlanType, SEQ, lblCombo1, layoutControlItem1, layoutControlItem3, layoutControlItem2, layoutControlItem6 |
| UsrButton | 5 | btnSave, usrButton1, BtnCalculation, btnNew, btnItem_Id |
| UsrCombo | 5 | cboDivision, cboBucketType, cboPlanDate, cboPlanType, cboPlanSeq |
| EmptySpaceItem | 4 | emptySpaceItem2, emptySpaceItem1, emptySpaceItem3, emptySpaceItem2 |
| FpSpread | 3 | spdMain, spdSub, spdMain |
| SheetView | 3 | spdMain_Sheet1, spdSub_Sheet1, spdMain_Sheet1 |
| UsrConditionPanel | 2 | usrConditionPanel1, pnlCondition |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrDateRangePicker3 | 1 | dCalendar |
| UsrCheckBox | 1 | chkAutoCalculation |
| UsrMultiLineEditor | 1 | txtItemId |
| TextBox | 1 | txtNickName |
| UsrCheckedList2 | 1 | clbPlant |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1531 | SaveData | {?definition_path}#SaveGlobalPsiEE | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 24 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 35 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 21 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 6 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0069 | Global_PSI_EE | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 |
| SCM_MST_SHEET_MEASURE | SCP0069 | Global_PSI_EE | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Add Production Line, Working Time & Tact Time, Global_PSI_EE
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:282
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 130 | 하드코딩 | AddCheckColumn | CHK | CHK | if(sheetName == "Add Production Line") |
| InitSpread |  | 131 | 하드코딩 | AddTextColumn | SUPPLY_SITE | SUPPLY_SITE | if(sheetName == "Add Production Line") |
| InitSpread |  | 132 | 하드코딩 | AddTextColumn | ITEM_ID | ITEM_ID | if(sheetName == "Add Production Line") |
| InitSpread |  | 133 | 하드코딩 | AddTextColumn | LINE_ID | LINE_ID | if(sheetName == "Add Production Line") |
| InitSpread |  | 142 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(sheetName == "Add Production Line") |
| InitSpread |  | 143 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(sheetName == "Add Production Line") |
| InitSpread |  | 144 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(sheetName == "Add Production Line") |
| InitSpread |  | 152 | 하드코딩 | AddTextColumn | MEASURE | MEASURE | else!(sheetName == "Add Production Line") ⟫ if(sheetName == "Working Time & Tact Time") |
| InitSpread |  | 153 | 하드코딩 | AddTextColumn | ITEM_ID | ITEM_ID | else!(sheetName == "Add Production Line") ⟫ if(sheetName == "Working Time & Tact Time") |
| InitSpread |  | 154 | 하드코딩 | AddTextColumn | WORKING_TIME | WORKING_TIME | else!(sheetName == "Add Production Line") ⟫ if(sheetName == "Working Time & Tact Time") |
| InitSpread |  | 155 | 하드코딩 | AddTextColumn | TACT_TIME | TACT_TIME | else!(sheetName == "Add Production Line") ⟫ if(sheetName == "Working Time & Tact Time") |
| InitializeComponent |  | 169 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 170 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 171 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 172 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 220 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 221 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 222 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 223 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpreadDateColumn |  | 301 | DB루프 | AddNumColumn | {?string.Empty} \|\| {?dr["COLUMN_LABEL"]} | {?string.Empty} \|\| {?dr["COLUMN_NAME"]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitializeComponent |  | 845 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 846 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 847 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 848 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Add Production Line | 코드 하드코딩 전용(메타 없음) | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 |
| Global_PSI_EE | META+코드연결 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 |
| Working Time & Tact Time | 코드 하드코딩 전용(메타 없음) | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
