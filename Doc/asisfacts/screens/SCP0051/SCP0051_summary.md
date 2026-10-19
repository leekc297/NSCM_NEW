# SCP0051 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0051_ProductionPlanTarget\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0051_ProductionPlanTarget\SCP0051_ProductionPlanTarget.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0051_ProductionPlanTarget\SCP0051_ProductionPlanTarget.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0051_ProductionPlanTarget\SCP0051_ProductionPlanTarget.csproj | 1621 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0051_ProductionPlanTarget\SCP0051_ProductionPlanTarget.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0051_ProductionPlanTarget\SCP0051_ProductionPlanTarget.csproj | 701 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 475 | SCP.SCP0051_GET_PRODUCTION_PLAN_TARGET | MATCH | SP SCP0051_GET_PRODUCTION_PLAN_TARGET |
| button:InsertButton | InsertButton > InsertRow > Get_DataTable_Info | 674 | SCP.SCP0051_GET_NEW_INFO | MATCH | SP SCP0051_GET_NEW_INFO |
| button:InsertButton | InsertButton > InsertRow | 716 | SCP.SCP0051_GET_NEW_INFO | MATCH | SP SCP0051_GET_NEW_INFO |
| button:InsertButton | InsertButton > InsertRow | 743 | SCP.SCP0051_GET_NEW_INFO | MATCH | SP SCP0051_GET_NEW_INFO |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 475 | SCP.SCP0051_GET_PRODUCTION_PLAN_TARGET | MATCH | SP SCP0051_GET_PRODUCTION_PLAN_TARGET |
| button:SaveButton | SaveButton > SaveData_Main | 607 | SCP.SCP0051_SAVE_PRODUCTION_PLAN_TARGET | MATCH | SP SCP0051_SAVE_PRODUCTION_PLAN_TARGET |
| event:spdMain.ComboSelChange | SpdMain_ComboSelChange | 272 | SCP.SCP0051_GET_NEW_INFO | MATCH | SP SCP0051_GET_NEW_INFO |
| event:spdMain.ComboSelChange | SpdMain_ComboSelChange | 287 | SCP.SCP0051_GET_NEW_INFO | MATCH | SP SCP0051_GET_NEW_INFO |
| event:spdMain.ComboSelChange | SpdMain_ComboSelChange | 293 | SCP.SCP0051_GET_NEW_INFO | MATCH | SP SCP0051_GET_NEW_INFO |
| event:spdMain.ComboSelChange | SpdMain_ComboSelChange > Get_DataTable_Info | 674 | SCP.SCP0051_GET_NEW_INFO | MATCH | SP SCP0051_GET_NEW_INFO |
| event:this.btnConfirm.Click | btnConfirm_Click > FindData_Main | 475 | SCP.SCP0051_GET_PRODUCTION_PLAN_TARGET | MATCH | SP SCP0051_GET_PRODUCTION_PLAN_TARGET |
| event:this.btnConfirm.Click | btnConfirm_Click | 863 | SCP.SCP0051_SAVE_PRODUCTION_PLAN_TARGET_CONFIRM | MATCH | SP SCP0051_SAVE_PRODUCTION_PLAN_TARGET_CONFIRM |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| SCP.SCP0051_GET_NEW_INFO | MATCH | 6 | SP SCP0051_GET_NEW_INFO | EXEC:SCP0051_GET_NEW_INFO, REF:FN_GET_LOOKUP_VALUE, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_SITE, SELECT:SCM_MST_TACT_TIME_SN, SELECT:SCM_MST_PLAN, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCP_MST_OUTSOURCING_CAPA, SELECT:SCP_MST_TACT_TIME_OSP, SELECT:SCM_MST_LINE_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_FINAL_ITEM_V, REF:STRING_SPLIT, SELECT:SCM_CODE_LOOKUP_VALUE |  |
| SCP.SCP0051_GET_PRODUCTION_PLAN_TARGET | MATCH | 1 | SP SCP0051_GET_PRODUCTION_PLAN_TARGET | EXEC:SCP0051_GET_PRODUCTION_PLAN_TARGET, SELECT:SCM_MST_SITE, SELECT:SCP_ANL_PRODUCTION_PLAN_TARGET, SELECT:SCP_MST_FINAL_ITEM, REF:FN_GET_DIVISION_DIV, REF:STRING_SPLIT, SELECT:SCM_MST_DIVISION |  |
| SCP.SCP0051_SAVE_PRODUCTION_PLAN_TARGET | MATCH | 1 | SP SCP0051_SAVE_PRODUCTION_PLAN_TARGET | EXEC:SCP0051_SAVE_PRODUCTION_PLAN_TARGET, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, DELETE:SCP_ANL_PRODUCTION_PLAN_TARGET, SELECT:SCM_CODE_LOOKUP_VALUE, SELECT:SCP_ANL_PRODUCTION_PLAN_TARGET, INSERT:SCP_ANL_PRODUCTION_PLAN_TARGET, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0051_SAVE_PRODUCTION_PLAN_TARGET_CONFIRM | MATCH | 1 | SP SCP0051_SAVE_PRODUCTION_PLAN_TARGET_CONFIRM | EXEC:SCP0051_SAVE_PRODUCTION_PLAN_TARGET_CONFIRM, EXEC:PR_SCM_SYS_LOG_BATCH, UPDATE:SCP_ANL_PRODUCTION_PLAN_TARGET, REF:STRING_SPLIT, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InsertRow | drRow | CODE, NAME |
| InsertRow | dr | PLANT_SITE_ID, SITE_DESCRIPTION |
| SetBtnConfirm | UserInfoContext.Current | NowGroupID |
| setRowForEE | drRow | CODE, NAME, OSP_YN, OPERATION_ID |
| setRowForEE | dr | CODE, NAME, PLANT_SITE_ID, SITE_DESCRIPTION, OSP_YN, OPERATION_ID |
| setRowForEE | drOrigin | CODE |
| setRowForEE | drPlant | OPERATION_ID, CODE, OSP_YN |
| setRowForEE | dr1 | CODE, NAME |
| setRowForEE | drLine | CODE |
| setRowForNotEE | drRow | CODE, NAME, OSP_YN, OPERATION_ID |
| setRowForNotEE | dr | PLANT_SITE_ID, SITE_DESCRIPTION, OSP_YN, OPERATION_ID, CODE, NAME |
| setRowForNotEE | drPlant | OPERATION_ID, CODE, OSP_YN |
| setRowForNotEE | dr1 | CODE, NAME |
| setRowForNotEE | drLine | CODE |
| SpdMain_ComboSelChange | dr | OPERATION_ID, OSP_YN |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitSpread:176, RefreshPlantSite:386, RefreshLine:401, RefreshLine:402, SetChangedControl:426, FindData_Main:449, FindData_Main:450, FindData_Main:452 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:178 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:116 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:238 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:239 |
| this.spdMain | ClipboardPasting | SpdMain_ClipboardPasting | InitEvent:240 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:241 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:243 |
| this.btnConfirm | Click | btnConfirm_Click | InitEvent:244 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:246 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:247 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:248 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | SpdMain_ComboSelChange:260 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | SpdMain_ComboSelChange:262 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | setRowForEE:1114 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | setRowForEE:1116 |

## 6. 컨트롤 (26개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 8 | Division, layoutPlantSite, layoutLine, layoutModel, layoutControlItem4, layoutNickName, layoutConfirm, layoutControlItem2 |
| UsrButton | 3 | usrButton1, btnConfirm, btnItemId |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3 |
| UsrCheckedList | 2 | clbLine, clbPlantSite |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker3 | 1 | dCalendar |
| UsrMultiLineEditor | 1 | txtItemId |
| UsrCombo | 1 | cboDivision |
| TextBox | 1 | txtNickName |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 12 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 24 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 15 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 36 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0051 | Target | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Target
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:178

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Target | 185 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  | if(spdInfo.SheetName == "Target") |
| InitSpread | Target | 186 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  | if(spdInfo.SheetName == "Target") |
| SetHeaderCheckBox |  | 203 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(bCheckVisible) |
| SetHeaderCheckBox |  | 204 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(bCheckVisible) |
| SetHeaderCheckBox |  | 205 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(bCheckVisible) |
| SetHeaderCheckBox |  | 210 | 표시/라벨 변경 | set:CellType | CellType = {?txt} | CHK | else!(bCheckVisible) |
| SetHeaderCheckBox |  | 211 | 표시/라벨 변경 | set:Value | Value =  | CHK | else!(bCheckVisible) |
| InitializeComponent |  | 606 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 607 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 608 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 609 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Target | META+코드연결 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
