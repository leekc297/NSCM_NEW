# DMF0069 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0069_HistoryDataManagingBoard\DMF0069_HistoryDataManagingBoard.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0069_HistoryDataManagingBoard\DMF0069_HistoryDataManagingBoard.csproj | 1241 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0069_HistoryDataManagingBoard\DMF0069_HistoryDataManagingBoard.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0069_HistoryDataManagingBoard\DMF0069_HistoryDataManagingBoard.csproj | 603 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0069_HistoryDataManagingBoard\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0069_HistoryDataManagingBoard\DMF0069_HistoryDataManagingBoard.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0069_HistoryDataManagingBoard\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0069_HistoryDataManagingBoard\DMF0069_HistoryDataManagingBoard.csproj | 72 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0069_HistoryDataManagingBoard\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0069_HistoryDataManagingBoard\DMF0069_HistoryDataManagingBoard.csproj | 31 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0069_HistoryDataManagingBoard.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1208 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0069_HistoryDataManagingBoard.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 603 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 599 | DM.DMF0069_GET_DM_ANL_MKT_STATUSBOARD | MATCH | SP DMF0069_GET_DM_ANL_MKT_STATUSBOARD |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 1190 | DM.DMF0069_GET_SPREAD_TITLE | MATCH | SP DMF0069_GET_SPREAD_TITLE |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle_PSI | 1210 | DM.DMF0003_GET_SPREAD_TITLE_PSI | MATCH | SP DMF0003_GET_SPREAD_TITLE_PSI |
| event:this.btnFind.Click | btnFind_Click > FindData | 599 | DM.DMF0069_GET_DM_ANL_MKT_STATUSBOARD | MATCH | SP DMF0069_GET_DM_ANL_MKT_STATUSBOARD |
| event:this.btnFind.Click | btnFind_Click > FindData > InitSpread > GetSpdTitle | 1190 | DM.DMF0069_GET_SPREAD_TITLE | MATCH | SP DMF0069_GET_SPREAD_TITLE |
| event:this.btnFind.Click | btnFind_Click > FindData > InitSpread > GetSpdTitle_PSI | 1210 | DM.DMF0003_GET_SPREAD_TITLE_PSI | MATCH | SP DMF0003_GET_SPREAD_TITLE_PSI |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1190 | DM.DMF0069_GET_SPREAD_TITLE | MATCH | SP DMF0069_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle_PSI | 1210 | DM.DMF0003_GET_SPREAD_TITLE_PSI | MATCH | SP DMF0003_GET_SPREAD_TITLE_PSI |
| event:this.spd1.CellClick | spd1_CellClick | 684 | DM.DMF0069_GET_DM_ANL_MKT_STATUSLIST | MATCH | SP DMF0069_GET_DM_ANL_MKT_STATUSLIST |
| event:this.spd2.CellDoubleClick | spd2_CellDoubleClick | 744 | DM.DMF0003_GET_DM_ANL_MKT_PSI_DATA | MATCH | SP DMF0003_GET_DM_ANL_MKT_PSI_DATA |
| event:this.spd3.CellClick | spd3_CellClick_1 | 907 | DM.DMF0003_GET_DM_ANL_MKT_PSI_DATA | MATCH | SP DMF0003_GET_DM_ANL_MKT_PSI_DATA |
| event:this.spd3.CellClick | spd3_CellClick_1 | 1011 | DM.DMF0003_GET_DM_ANL_MKT_PSI_DATA | MATCH | SP DMF0003_GET_DM_ANL_MKT_PSI_DATA |
| unreached:(진입점 미연결) | GetDayRange | 1228 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| DM.DMF0003_GET_DM_ANL_MKT_PSI_DATA | MATCH | 3 | SP DMF0003_GET_DM_ANL_MKT_PSI_DATA | EXEC:DMF0003_GET_DM_ANL_MKT_PSI_DATA, CREATE:#TEMP_DATA, CREATE:#TEMP_DM_MST_VERSION, INSERT:#TMP_PROJECT_CODE, SELECT:SCM_MST_PROJECT, REF:FN_NEXT_DAY, INSERT:#TEMP_DM_MST_VERSION, SELECT:DM_MST_VERSION, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TMP_DM_MST_ITEM_SINGLE_V, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_PROJECT_ITEM, INSERT:#TEMP_SCM_MST_SITE, SELECT:SCM_MST_SITE, UPDATE:T1, SELECT:DM_ANL_MKT_PSI, SELECT:DM_PLN_MKT_FCST_RESULT, SELECT:SCM_MST_SITE_ITEM, SELECT:#TEMP_SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:DM_PLN_MKT_FCST_C, SELECT:#TEMP_DM_MST_VERSION, SELECT:#TMP_DM_MST_ITEM_SINGLE_V, SELECT:DM_PLN_MKT_FCST_RESULT_C, INSERT:#TEMP_DATA, UPDATE:#TEMP_DATA, SELECT:#TEMP_DATA |  |
| DM.DMF0003_GET_SPREAD_TITLE_PSI | MATCH | 1 | SP DMF0003_GET_SPREAD_TITLE_PSI | EXEC:DMF0003_GET_SPREAD_TITLE_PSI, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0069_GET_DM_ANL_MKT_STATUSBOARD | MATCH | 1 | SP DMF0069_GET_DM_ANL_MKT_STATUSBOARD | EXEC:DMF0069_GET_DM_ANL_MKT_STATUSBOARD, CREATE:#TEMP_DATA, INSERT:#TEMP_SCM_SYS_CALENDAR_M, SELECT:SCM_SYS_CALENDAR_M, SELECT:#TEMP_SCM_SYS_CALENDAR_M, SELECT:DM_PLN_MKT_FCST_RESULT, INSERT:#TEMP_DATA, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:DM_PLN_MKT_FCST, SELECT:DM_ANL_MKT_PSI, SELECT:#TEMP_DATA |  |
| DM.DMF0069_GET_DM_ANL_MKT_STATUSLIST | MATCH | 1 | SP DMF0069_GET_DM_ANL_MKT_STATUSLIST | EXEC:DMF0069_GET_DM_ANL_MKT_STATUSLIST, CREATE:#TEMP_DATA, INSERT:#TEMP_SCM_SYS_CALENDAR_M, SELECT:SCM_SYS_CALENDAR_M, SELECT:#TEMP_SCM_SYS_CALENDAR_M, SELECT:DM_PLN_MKT_FCST_RESULT, INSERT:#TEMP_DATA, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_PROJECT, SELECT:DM_PLN_MKT_FCST, SELECT:DM_ANL_MKT_PSI, SELECT:#TEMP_DATA |  |
| DM.DMF0069_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0069_GET_SPREAD_TITLE | EXEC:DMF0069_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| OnShown | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| OnShown | OnShown:193 | BaseForm.OnShown | NowGroupID, USER_ID |
| GetSpdTitle | InitSpread:253, InitSpread:267 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:254, InitSpread:268, InitSpread:280 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spd1 | CellClick | spd1_CellClick | InitializeComponent:221 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:299 |
| this.spd2 | CellDoubleClick | spd2_CellDoubleClick | InitializeComponent:390 |
| this.spd3 | CellClick | spd3_CellClick_1 | InitializeComponent:458 |
| this.spd3 | TopChange | spd3_TopChange | InitializeComponent:459 |
| this | Load | Form_Load | .ctor:179 |

## 6. 컨트롤 (28개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| ToolStripMenuItem | 4 | Request_PR, View_PR, Add_History, View_History |
| TableLayoutPanel | 4 | tableLayoutPanel4, tableLayoutPanel5, tableLayoutPanel3, tableLayoutPanel1 |
| FpSpread | 3 | spd1, spd2, spd3 |
| SheetView | 3 | spd1_Sheet1, spd2_Sheet1, spd3_Sheet1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| SplitContainer | 2 | splitContainer1, splitContainer2 |
| SimpleButton | 2 | btnFind, btnUpDown |
| LayoutControlItem | 2 | layoutControlItem3, layoutControlItem1 |
| ContextMenuStrip | 1 | contextMenuStrip1 |
| ImageList | 1 | imageList1 |
| UsrMonthRangePicker | 1 | drpPeriod |
| EmptySpaceItem | 1 | emptySpaceItem1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 15 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 27 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0069 | PSI | · | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0069 | Status Board | · | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0069 | Status List | · | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | · | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 18개 시트×division 비교, 차이 6건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Status Board, PSI, Status List
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:254, CreateSheetHeaderColumn@InitSpread:268, CreateSheetHeaderColumn@InitSpread:280
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan_SP1, SetSpreadColumn, SetSpreadHeaderSpan_SP2, SetSpreadHeaderSpan_SP3

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadHeaderSpan_SP1 |  | 324 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan_SP3 |  | 440 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= 8) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| InitializeComponent |  | 197 | 표시/라벨 변경 | set:ColumnCount | ColumnCount = 1 |  |  |
| InitializeComponent |  | 237 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 238 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 239 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 240 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 265 | 표시/라벨 변경 | set:ColumnCount | ColumnCount = 2 |  |  |
| InitializeComponent |  | 406 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 407 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 408 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 409 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 435 | 표시/라벨 변경 | set:ColumnCount | ColumnCount = 1 |  |  |
| InitializeComponent |  | 475 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 476 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 477 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 478 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 513 | 표시/라벨 변경 | set:ColumnCount | ColumnCount = 2 |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| PSI | META+코드연결 | · | 16 | 16 | 16 | 16 | 16 | 16 | · | · | · | · | · | · | · |
| Status Board | META+코드연결 | · | 4 | 4 | 4 | 4 | 4 | 4 | · | · | · | · | · | · | · |
| Status List | META+코드연결 | · | 6 | 6 | 6 | 6 | 6 | 6 | · | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
