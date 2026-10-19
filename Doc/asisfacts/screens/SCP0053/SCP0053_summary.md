# SCP0053 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0053_SCPBOM\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0053_SCPBOM\SCP0053_SCPBOM.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0053_SCPBOM\SCP0053_SCPBOM.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0053_SCPBOM\SCP0053_SCPBOM.csproj | 677 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0053_SCPBOM\SCP0053_SCPBOM.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0053_SCPBOM\SCP0053_SCPBOM.csproj | 690 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > Find_Data > FindData_Main | 387 | SCP.SCP0053_GET_SCP_BOM | MATCH | SP SCP0053_GET_SCP_BOM |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 387 | SCP.SCP0053_GET_SCP_BOM | MATCH | SP SCP0053_GET_SCP_BOM |
| button:SaveButton | SaveButton > SaveData_Main | 496 | SCP.SCP0053_SAVE_SCP_BOM | MATCH | SP SCP0053_SAVE_SCP_BOM |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| SCP.SCP0053_GET_SCP_BOM | MATCH | 1 | SP SCP0053_GET_SCP_BOM | EXEC:SCP0053_GET_SCP_BOM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#TBLSCP0053_PARENTITEM, SELECT:SCM_MST_ITEM_SN, INSERT:#TBLSCP0053_CHILDITEM, INSERT:#TBLSCP0053_ALTERRAW, SELECT:SCM_MST_BOM_SN, SELECT:SCM_MST_ALTER_BOM_MODEL, REF:STRING_SPLIT, SELECT:#TBLSCP0053_PARENTITEM, SELECT:#TBLSCP0053_CHILDITEM, SELECT:#TBLSCP0053_ALTERRAW, SELECT:SCM_MST_BOM_ENG_SN, REF:FN_NEXT_DAY, SELECT:SCM_MST_ALTER_BOM, INSERT:#TBLSCP0053_RAW, INSERT:#TBLSCP0053_ALLRAW, SELECT:#TBLSCP0053_RAW, SELECT:#TBLSCP0053_ALLRAW |  |
| SCP.SCP0053_SAVE_SCP_BOM | MATCH | 1 | SP SCP0053_SAVE_SCP_BOM | EXEC:SCP0053_SAVE_SCP_BOM, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_SCM_MST_ALTER_BOM_H, UPDATE:SCM_MST_ALTER_BOM, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_MST_ALTER_BOM_H, SELECT:SCM_MST_ALTER_BOM |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| SaveData_Main | dtErr.Rows[0] | ERR_MESSAGE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | DefineProperty:116, SetChangedControl:184, SetChangedControl:189, EditButton:282, FindData_Main:366, FindData_Main:371, ClbPlantSite_SelectedIndexChanged:570, ClbPlantSite_SelectedIndexChanged:574 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | SetSpreadInit:216 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| OnShown | OnShown:669 | BaseForm.OnShown | NowGroupID, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:272 |
| this.spdMain | EditModeOff | SpdMain_EditModeOff | InitializeComponent:558 |
| this.spdMain | EditChange | SpdMain_EditChange | InitializeComponent:559 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:560 |
| this | Load | Form_Load | .ctor:97 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:224 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:225 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:227 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:228 |
| spdMain | CellClick | SpdMain_CellClick | InitEvent:229 |
| dsdmMain | Changed | SpdMain_Changed | InitEvent:232 |
| spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:234 |
| this.spdMain | ActiveSheetChanged | SpdMain_ActiveSheetChanged | InitEvent:236 |

## 6. 컨트롤 (28개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | layoutControlItem2, layoutControlItem1, layoutControlItem3, layoutControlItem4, layoutControlItem5, layoutControlItem6, layoutControlItem7 |
| EmptySpaceItem | 6 | emptySpaceItem3, emptySpaceItem2, emptySpaceItem4, emptySpaceItem5, emptySpaceItem6, emptySpaceItem7 |
| UsrMultiLineEditor | 3 | txtModelID, txtParentID, txtChildID |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| SheetView | 2 | spdMain_Sheet1, spdExcept_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCheckBox | 1 | ucbAltBOM |
| UsrCombo | 1 | cboDivision |
| UsrButton | 1 | btnItemId |
| UsrCheckedList | 1 | clbPlantSite |
| FpSpread | 1 | spdMain |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 66 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 27 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 6 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 14 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 27 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0053 | SCP BOM | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: SCP BOM
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetSpreadInit:216

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 576 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 577 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 578 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 579 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCP BOM | META+코드연결 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
