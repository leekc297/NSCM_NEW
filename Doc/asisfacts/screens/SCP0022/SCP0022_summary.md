# SCP0022 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0022_Formation\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0022_Formation\SCP0022_Formation.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0022_Formation\SCP0022_Formation.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0022_Formation\SCP0022_Formation.csproj | 1921 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0022_Formation\SCP0022_Formation.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0022_Formation\SCP0022_Formation.csproj | 524 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 1690 | SCP.SCP0022_GET_FORMATION | MATCH | SP SCP0022_GET_FORMATION |
| button:FindButton | FindButton > FindData_Except | 1767 | SCP.SCP0022_GET_FORMATION_EXCEPT | MATCH | SP SCP0022_GET_FORMATION_EXCEPT |
| button:FindButton | FindButton > FindData_ExceptLT | 1817 | SCP.SCP0022_GET_FORMATION_EXCEPT_LT | MATCH | SP SCP0022_GET_FORMATION_EXCEPT_LT |
| button:SaveButton | SaveButton > SaveData_Main | 845 | SCP.SCP0022_SAVE_Formation | MATCH | SP SCP0022_SAVE_FORMATION |
| button:SaveButton | SaveButton > SaveExcept | 955 | SCP.SCP0022_SAVE_FORMATION_EXCEPT | MATCH | SP SCP0022_SAVE_FORMATION_EXCEPT |
| button:SaveButton | SaveButton > SaveExceptLT | 1097 | SCP.SCP0022_SAVE_FORMATION_EXCEPT_LT | MATCH | SP SCP0022_SAVE_FORMATION_EXCEPT_LT |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 1690 | SCP.SCP0022_GET_FORMATION | MATCH | SP SCP0022_GET_FORMATION |
| button:SaveButton | SaveButton > SaveExcept > FindData_Except | 1767 | SCP.SCP0022_GET_FORMATION_EXCEPT | MATCH | SP SCP0022_GET_FORMATION_EXCEPT |
| button:SaveButton | SaveButton > SaveExceptLT > FindData_ExceptLT | 1817 | SCP.SCP0022_GET_FORMATION_EXCEPT_LT | MATCH | SP SCP0022_GET_FORMATION_EXCEPT_LT |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| SCP.SCP0022_GET_FORMATION | MATCH | 1 | SP SCP0022_GET_FORMATION | EXEC:SCP0022_GET_FORMATION, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_ITEM_NICKNAME, SELECT:SCM_MST_ITEM_SN, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_FINAL_ITEM_V, REF:STRING_SPLIT, SELECT:SCP_MST_FORMATION, SELECT:SSP_MST_MODEL_USER, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SITE |  |
| SCP.SCP0022_GET_FORMATION_EXCEPT | MATCH | 1 | SP SCP0022_GET_FORMATION_EXCEPT | EXEC:SCP0022_GET_FORMATION_EXCEPT, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_ITEM_NICKNAME, SELECT:SCP_MST_FORMATION, SELECT:SCP_MST_FORMATION_EXCEPT, REF:STRING_SPLIT, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN |  |
| SCP.SCP0022_GET_FORMATION_EXCEPT_LT | MATCH | 1 | SP SCP0022_GET_FORMATION_EXCEPT_LT | EXEC:SCP0022_GET_FORMATION_EXCEPT_LT, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_ITEM_NICKNAME, SELECT:SCP_MST_FORMATION, SELECT:SCP_OPMZ_MST_FORMATION_EXCEPT_LT, REF:STRING_SPLIT, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN |  |
| SCP.SCP0022_SAVE_Formation | MATCH | 1 | SP SCP0022_SAVE_FORMATION | EXEC:SCP0022_SAVE_FORMATION, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCM_MST_SITE, SELECT:SCM_MST_PLANT_SN, EXEC:PR_SCP_MST_FORMATION_HIST, MERGE:SCP_MST_FORMATION, INSERT:#SCP_MST_FORMATION_VIRTUAL_SITE, SELECT:SCP_MST_FORMATION, INSERT:SCP_MST_FORMATION_H, SELECT:#SCP_MST_FORMATION_VIRTUAL_SITE, UPDATE:TG, INSERT:SCP_MST_FORMATION, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0022_SAVE_FORMATION_EXCEPT | MATCH | 1 | SP SCP0022_SAVE_FORMATION_EXCEPT | EXEC:SCP0022_SAVE_FORMATION_EXCEPT, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCM_MST_SITE, SELECT:SCM_MST_PLANT_SN, SELECT:SCP_MST_FORMATION_EXCEPT, MERGE:SCP_MST_FORMATION_EXCEPT, EXEC:PR_SCP_MST_FORMATION_EXCEPT_HIST, INSERT:#SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE, INSERT:SCP_MST_FORMATION_EXCEPT_H, SELECT:#SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE, DELETE:TG, UPDATE:TG, INSERT:SCP_MST_FORMATION_EXCEPT, INSERT:#SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE_TO_DELETE, SELECT:#SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE_TO_DELETE, DELETE:SCP_MST_FORMATION_EXCEPT, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0022_SAVE_FORMATION_EXCEPT_LT | MATCH | 1 | SP SCP0022_SAVE_FORMATION_EXCEPT_LT | EXEC:SCP0022_SAVE_FORMATION_EXCEPT_LT, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCM_MST_SITE, SELECT:SCM_MST_PLANT_SN, SELECT:SCP_OPMZ_MST_FORMATION_EXCEPT_LT, MERGE:SCP_OPMZ_MST_FORMATION_EXCEPT_LT, EXEC:PR_SCP_MST_FORMATION_EXCEPT_LT_HIST, INSERT:#SCP_MST_FORMATION_EXECPT_LT_VIRTUAL, INSERT:SCP_OPMZ_MST_FORMATION_EXCEPT_LT_H, SELECT:#SCP_MST_FORMATION_EXECPT_LT_VIRTUAL, DELETE:TG, UPDATE:TG, INSERT:SCP_OPMZ_MST_FORMATION_EXCEPT_LT, INSERT:#SCP_MST_FORMATION_EXECPT_LT_VIRTUAL_TO_DEL, SELECT:#SCP_MST_FORMATION_EXECPT_LT_VIRTUAL_TO_DEL, DELETE:SCP_OPMZ_MST_FORMATION_EXCEPT_LT, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| SaveExcept | dtErr.Rows[0] | ERR_MESSAGE |
| SaveExceptLT | dtErr.Rows[0] | ERR_MESSAGE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | InitSpread:304, InitSpread:320, InitSpread:335 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| GetCheckedListValue | SetChangedControl:1656, FindData_Main:1672, FindData_Main:1673, FindData_Except:1736, FindData_Except:1737, FindData_ExceptLT:1801, FindData_ExceptLT:1802 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:213 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:349 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:350 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:353 |
| this.spdMain | EditChange | SpdMain_EditChange | InitEvent:355 |
| this.spdMain | EditModeOff | SpdMain_EditModeOff | InitEvent:356 |
| this.spdExcept | EditChange | SpdExcept_EditChange | InitEvent:358 |
| this.spdExcept | EditModeOff | SpdExcept_EditModeOff | InitEvent:359 |
| dsdmMain | Changed | SpdMain_Changed | InitEvent:363 |
| dsdmExcept | Changed | SpdExcept_Changed | InitEvent:366 |
| this.spdExcept | ActiveSheetChanged | SpdExcept_ActiveSheetChanged | InitEvent:370 |
| this.spdExcept | ActiveSheetChanging | SpdExcept_ActiveSheetChanging | InitEvent:371 |

## 6. 컨트롤 (18개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 4 | Division, layoutControlItem7, lblItemId, layoutControlItem4 |
| UsrButton | 2 | usrButton1, btnItemId |
| FpSpread | 2 | spdMain, spdExcept |
| SheetView | 2 | spdMain_Sheet1, spdExcept_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCombo | 1 | cboDivision |
| UsrCheckedList | 1 | clbPlantSite |
| UsrMultiLineEditor | 1 | txtItemId |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| EmptySpaceItem | 1 | emptySpaceItem1 |
| SplitContainer | 1 | splitContainer1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 119 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 55 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 52 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 66 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1753 | SCP.SCP0022_GET_FORMATION_EXCEPT | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0022 | Formation | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 |
| SCM_MST_SHEET_COLUMNS | SCP0022 | Formation Except | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |
| SCM_MST_SHEET_COLUMNS | SCP0022 | Formation Except LT | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Formation, Formation Except, Formation Except LT
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:304, SetSheetHeaderColumn@InitSpread:320, SetSheetHeaderColumn@InitSpread:335

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 392 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 393 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 394 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 395 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 443 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 444 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 445 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 446 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Formation | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |
| Formation Except | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |
| Formation Except LT | META+코드연결 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
