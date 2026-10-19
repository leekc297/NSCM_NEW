# SCP0084 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0084_LongTermStock\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0084_LongTermStock\SCP0084_LongTermStock.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0084_LongTermStock\SCP0084_LongTermStock.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0084_LongTermStock\SCP0084_LongTermStock.csproj | 816 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0084_LongTermStock\SCP0084_LongTermStock.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0084_LongTermStock\SCP0084_LongTermStock.csproj | 439 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:ExcelButton | ExcelButton > ExportExcelData > SCM_SYS_LOG_BATCH | 514 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| button:FindButton | FindButton > Find_Data | 308 | SCP.SCP0084_GET_LONG_TERM_STOCK | MATCH | SP SCP0084_GET_LONG_TERM_STOCK |
| button:SaveButton | SaveButton > SaveData_Memo > Find_Data | 308 | SCP.SCP0084_GET_LONG_TERM_STOCK | MATCH | SP SCP0084_GET_LONG_TERM_STOCK |
| button:SaveButton | SaveButton > SaveData_Memo | 450 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveLongTermStockMemo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData_Memo | 450 | SCP\Report\SCP0084_LongTermStock#SaveLongTermStockMemo | MATCH_PATTERN | SP SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET |
| button:SaveButton | SaveButton > SaveData_Memo > SCM_SYS_LOG_BATCH | 514 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.Load | Form_Load > InitControls > GetMonthRange | 354 | SCP.SCP0084_GET_MONTH_RANGE | MATCH | SP SCP0084_GET_MONTH_RANGE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveLongTermStockMemo] | BIZ_MATCH | 1 |  |  |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0084_GET_LONG_TERM_STOCK | MATCH | 1 | SP SCP0084_GET_LONG_TERM_STOCK | EXEC:SCP0084_GET_LONG_TERM_STOCK, SELECT:W_CELL_CF_BOM, SELECT:SCP_ANL_LONG_TERM_STOCK, SELECT:SCM_PLANT_M_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_ITEM_CLASS_M, SELECT:W_CELL_CF, SELECT:SCP_MST_PIC_INFO, SELECT:SCP_MST_NO_USE_3M, REF:STRING_SPLIT, SELECT:SCP_MST_ITEM_CELL_CF, SELECT:SCM_MODEL_COMP_TEMP_SN, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_ITEM_CLASS_SN |  |
| SCP.SCP0084_GET_MONTH_RANGE | MATCH | 1 | SP SCP0084_GET_MONTH_RANGE | EXEC:SCP0084_GET_MONTH_RANGE, SELECT:SCP_ANL_LONG_TERM_STOCK |  |
| SCP\Report\SCP0084_LongTermStock#SaveLongTermStockMemo | MATCH_PATTERN | 1 | SP SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET | EXEC:SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, UPDATE:A, SELECT:SCP_ANL_LONG_TERM_STOCK, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InitControls | dataRow | CODE, NAME |
| SaveData_Memo | dr | YYYYMM, PLANT_ID, DIVISION_ID, ITEM_ID, CHARG, DEVALUATION_AGE, MEMO, USER_ID, PROGRAM_ID, DEBUG_MODE |
| SaveData_Memo | result.Rows[0] | result_code, err_code, err_message |
| SetMonthRange | dtMonthRange.Rows[0] | MAX_YYYYMM, MIN_YYYYMM |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:175, Find_Data:294, Find_Data:295, Find_Data:296 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | SetSpreadInit:205 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:117 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:213 |

## 6. 컨트롤 (15개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 4 | layoutDivision1, layoutPlant1, layoutControlItem1, layoutLongTermType |
| UsrCheckedList2 | 3 | cboDivision, clbPlant, cboLongTermType |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem6 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrMonthPicker | 1 | monthPicker |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 450 | SaveData_Memo | {?definition_path}#SaveLongTermStockMemo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 29 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 59 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 7 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 30 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0084 | Long Term Stock | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Long Term Stock
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetSpreadInit:205

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| ExportExcelData |  | 614 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ switch(columnName)case "CELL_CONVER_QUANTITY"/"LONG_TERM_STOCK_QTY"/"LONG_TERM_STOCK_AMOUNT"/"UNIT_PRICE"/"AMOUNT"/"UNIT_PRICE_KRW" |
| ExportExcelData |  | 622 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ switch(columnName)case "CELL_CONVER_QUANTITY_XLS"/"LONG_TERM_STOCK_QTY_XLS"/"LONG_TERM_STOCK_AMOUNT_XLS"/"UNIT_PRICE_XLS"/"AMOUNT_XLS"/"UNIT_PRICE_KRW_XLS" |
| ExportExcelData |  | 671 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| ExportExcelData |  | 713 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| InitializeComponent |  | 297 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 298 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 299 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 300 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Long Term Stock | META+코드연결 | 46 | 46 | 46 | 46 | 46 | 46 | 46 | 46 | 46 | 46 | 46 | 46 | 46 | 46 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
