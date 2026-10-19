# SCP0101 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0101_InventoryTrend\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0101_InventoryTrend\SCP0101_InventoryTrend.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0101_InventoryTrend\SCP0101_InventoryTrend.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0101_InventoryTrend\SCP0101_InventoryTrend.csproj | 1023 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0101_InventoryTrend\SCP0101_InventoryTrend.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0101_InventoryTrend\SCP0101_InventoryTrend.csproj | 622 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:ExcelButton | ExcelButton > ExportExcelData > SCM_SYS_LOG_BATCH | 659 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| button:FindButton | FindButton > Find_Data | 301 | SCP.SCP0101_GET_INVENTORY_TREND | MATCH | SP SCP0101_GET_INVENTORY_TREND |
| event:this.Load | Form_Load > InitControls > GetMonthRange | 634 | SCP.SCP0084_GET_MONTH_RANGE | MATCH | SP SCP0084_GET_MONTH_RANGE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0084_GET_MONTH_RANGE | MATCH | 1 | SP SCP0084_GET_MONTH_RANGE | EXEC:SCP0084_GET_MONTH_RANGE, SELECT:SCP_ANL_LONG_TERM_STOCK |  |
| SCP.SCP0101_GET_INVENTORY_TREND | MATCH | 1 | SP SCP0101_GET_INVENTORY_TREND | EXEC:SCP0101_GET_INVENTORY_TREND, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#TMP_SCP_ANL_LONG_TERM_STOCK_FOCUS, SELECT:SCP_ANL_LONG_TERM_STOCK, REF:STRING_SPLIT, INSERT:#TMP_SCP_ANL_LONG_TERM_STOCK_MONTH, INSERT:#TMP_SCP_ANL_LONG_TERM_STOCK, SELECT:#TMP_SCP_ANL_LONG_TERM_STOCK_FOCUS, SELECT:#TMP_SCP_ANL_LONG_TERM_STOCK_MONTH, INSERT:#TMP_SCP_ANL_LONG_TERM_STOC_MONTH_SUM, INSERT:#W_CELL_CF, SELECT:SCP_MST_ITEM_CELL_CF, INSERT:#W_CELL_CF_BOM, SELECT:SCM_MODEL_COMP_TEMP_SN, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_ITEM_CLASS_SN, INSERT:#SCP_MST_FINAL_ITEM, SELECT:SCP_MST_FINAL_ITEM, INSERT:#TMP_ITEM_CLASS, SELECT:SCM_MST_ITEM_SN, INSERT:#TMP_LONG_TERM_STOCK_FINISH, SELECT:#TMP_SCP_ANL_LONG_TERM_STOC_MONTH_SUM, SELECT:#SCP_MST_FINAL_ITEM, SELECT:#W_CELL_CF_BOM, SELECT:#TMP_SCP_ANL_LONG_TERM_STOCK, SELECT:W_PLANT, SELECT:W_EXTRA_SPEC, SELECT:SCM_MST_ITEM_CLASS_M, SELECT:#W_CELL_CF, SELECT:W_SI, SELECT:SCM_PLANT_M_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:#TMP_ITEM_CLASS, CREATE:#TMP_MONTH_END_STOCK, INSERT:#TMP_MONTH_END_STOCK, SELECT:SCP_ANL_MONTH_END_STOCK_R, INSERT:#TMP_MONTH_END_STOCK_MONTH, INSERT:#TMP_SCP_ANL_LONG_TERM_STOCK_JOIN, SELECT:#TMP_LONG_TERM_STOCK_FINISH, INSERT:#TMP_MONTH_END_STOCK_JOIN, SELECT:#TMP_SCP_ANL_LONG_TERM_STOCK_JOIN, SELECT:#TMP_MONTH_END_STOCK, INSERT:#TMP_MONTH_END_STOCK_FINISH, SELECT:#TMP_MONTH_END_STOCK_MONTH, SELECT:#TMP_MONTH_END_STOCK_JOIN, SELECT:#TMP_MONTH_END_STOCK_FINISH, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| SetMonthRange | dtMonthRange.Rows[0] | MAX_YYYYMM, MIN_YYYYMM |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:163, Find_Data:287, Find_Data:288 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | SetSpreadInit:190 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:125 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:204 |
| this.btnColumn | Click | BtnColumn_Click | InitEvent:205 |
| this.btnItem_Id | Click | BtnItem_Id_Click | InitEvent:206 |
| monthPicker | ValueChanged | MonthPicker_ValueChanged | InitEvent:207 |
| chkDetail | CheckedChanged | ChkDetail_CheckedChanged | InitEvent:208 |

## 6. 컨트롤 (22개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | layoutDivision1, layoutControlItem1, layoutPlant1, layoutBtnColumn, lblItemId, layoutControlItem4, layoutDetail |
| EmptySpaceItem | 3 | emptySpaceItem2, emptySpaceItem1, emptySpaceItem6 |
| UsrCheckedList2 | 2 | cboDivision, clbPlant |
| UsrButton | 2 | btnColumn, btnItem_Id |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrMonthPicker | 1 | monthPicker |
| UsrMultiLineEditor | 1 | txtItem_Id |
| UsrCheckBox | 1 | chkDetail |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 107 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 47 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 84 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0101 | Inventory Trend | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 | 41/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Inventory Trend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetSpreadInit:190

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadHeader |  | 365 | 표시/라벨 변경 | set:Text | Text = {?month1} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ switch(colName)case "QTY_MONTH1" |
| SetSpreadHeader |  | 368 | 표시/라벨 변경 | set:Text | Text = {?month2} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ switch(colName)case "QTY_MONTH2" |
| SetSpreadHeader |  | 371 | 표시/라벨 변경 | set:Text | Text = {?month3} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ switch(colName)case "QTY_MONTH3" |
| SetSpreadHeader |  | 374 | 표시/라벨 변경 | set:Text | Text = {?month4} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ switch(colName)case "QTY_MONTH4" |
| SetSpreadHeader |  | 377 | 표시/라벨 변경 | set:Text | Text = {?month5} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ switch(colName)case "QTY_MONTH5" |
| SetSpreadHeader |  | 380 | 표시/라벨 변경 | set:Text | Text = {?monthFocus} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ switch(colName)case "QTY_MONTH_FOCUS" |
| SetSpreadHeader |  | 381 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?colorFocus} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ switch(colName)case "QTY_MONTH_FOCUS" |
| SetSpreadHeader |  | 382 | 표시/라벨 변경 | set:Font | Font = {?fontFocus} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ switch(colName)case "QTY_MONTH_FOCUS" |
| SetSpreadHeader |  | 385 | 표시/라벨 변경 | set:Text | Text = Amount KRW |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ switch(colName)case "LONG_TERM_STOCK_AMOUNT" |
| SetSpreadHeader |  | 386 | 표시/라벨 변경 | set:Text | Text = {?monthFocus} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ switch(colName)case "LONG_TERM_STOCK_AMOUNT" |
| SetSpreadHeader |  | 394 | 표시/라벨 변경 | set:Text | Text = {?string.Format("{0} {1}", monthFocus, "Inventory Status")} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ switch(colName)case "INV_STATUS_AVAILABLE"/"INV_STATUS_HOLDING"/"INV_STATUS_QT"/"INV_STATUS_BLOCKED" |
| SetLayout |  | 425 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("ITEM_NAME")} | ITEM_NAME |  |
| SetLayout |  | 426 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("PROCESS_DETAIL")} | PROCESS_DETAIL |  |
| SetLayout |  | 427 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("GPLM_CELL_MODEL")} | GPLM_CELL_MODEL |  |
| SetLayout |  | 428 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("MDM_NICK_NAME")} | MDM_NICK_NAME |  |
| SetLayout |  | 429 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("SCP_EXTRA_SPEC")} | SCP_EXTRA_SPEC |  |
| SetLayout |  | 430 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("GPLM_CELL_CONVERSION_FACTOR")} | GPLM_CELL_CONVERSION_FACTOR |  |
| SetLayout |  | 431 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("LEVEL_1_NAME")} | LEVEL_1_NAME |  |
| SetLayout |  | 432 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("LEVEL_2_NAME")} | LEVEL_2_NAME |  |
| SetLayout |  | 433 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("LEVEL_3_NAME")} | LEVEL_3_NAME |  |
| SetLayout |  | 434 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("LEVEL_4_NAME")} | LEVEL_4_NAME |  |
| SetLayout |  | 435 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("VALUATION_CLASS")} | VALUATION_CLASS |  |
| SetLayout |  | 436 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("UNIT_PRICE_KRW")} | UNIT_PRICE_KRW |  |
| SetLayout |  | 438 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("INV_STATUS_QT")} | INV_STATUS_QT |  |
| SetLayout |  | 439 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("INV_STATUS_HOLD")} | INV_STATUS_HOLD |  |
| SetLayout |  | 440 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("INV_STATUS_BLOCKED")} | INV_STATUS_BLOCKED |  |
| SetLayout |  | 442 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("CURRENCY")} | CURRENCY |  |
| SetLayout |  | 443 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("AMOUNT")} | AMOUNT |  |
| SetLayout |  | 444 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("UNIT_PRICE")} | UNIT_PRICE |  |
| SetLayout |  | 445 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("EX_TO_BAMT")} | EX_TO_BAMT |  |
| SetLayout |  | 446 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("CELL_TYPE_GR")} | CELL_TYPE_GR |  |
| SetLayout |  | 447 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("CELL_GROUP")} | CELL_GROUP |  |
| SetLayout |  | 448 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex("PACK_GROUP")} | PACK_GROUP |  |
| ExportExcelData |  | 816 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| ExportExcelData |  | 858 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| InitializeComponent |  | 525 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 526 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 527 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 528 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Inventory Trend | META+코드연결 | 42 (?22) | 42 (?22) | 42 (?22) | 42 (?22) | 42 (?22) | 42 (?22) | 42 (?22) | 42 (?22) | 42 (?22) | 42 (?22) | 42 (?22) | 42 (?22) | 42 (?22) | 42 (?22) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
