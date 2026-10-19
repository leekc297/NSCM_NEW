# FP01991 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01991_ConfigSetting\FP01991_ConfigSetting_SqlPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01991_ConfigSetting\FP01991_ConfigSetting.csproj | 215 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01991_ConfigSetting\FP01991_ConfigSetting_SqlPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01991_ConfigSetting\FP01991_ConfigSetting.csproj | 317 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01991_ConfigSetting\FP01991_ConfigSetting.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01991_ConfigSetting\FP01991_ConfigSetting.csproj | 887 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01991_ConfigSetting\FP01991_ConfigSetting.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01991_ConfigSetting\FP01991_ConfigSetting.csproj | 522 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01991_ConfigSetting\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01991_ConfigSetting\FP01991_ConfigSetting.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01991_ConfigSetting\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01991_ConfigSetting\FP01991_ConfigSetting.csproj | 64 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01991_ConfigSetting\Properties\Settings.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01991_ConfigSetting\FP01991_ConfigSetting.csproj | 27 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 41 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| Find_Data_Amend | Filter | INSTANCE_ID, CATEGORY_ID, KEY_ID |
| Find_Data_sub | Filter | LOOKUP_TYPE_CODE |
| SaveData | SaveFilter | INSTANCE_ID, CATEGORY_ID, KEY_ID, PART_ID, KEY_VALUE, VALUE_TYPE, KEY_PRIORITY, TOLERANCE, TOLERANCE_UOM, VIEW_FLAG, USE_YN, DESCRIPTION, OLD_KEY_ID, OLD_PART_ID, OLD_KEY_VALUE |
| SuperRoleSQL_Click | Application.OpenForms | FP01991_ConfigSetting_SqlPopup |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| EditQuery | RefreshSpreadSheet:346 | FPExtensions.EditQuery | ROW_ID |
| SaveData | SaveButton:384 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetLauncherType | btnSave_Click:168 | GAppSettings.GetLauncherType | LauncherType |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.SuperRoleSQL | Click | SuperRoleSQL_Click | InitializeComponent:210 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:250 |
| this | Load | Form_Load | .ctor:105 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:106 |
| popSql | OnSql | RunSqlSource | btnSql_Click:840 |
| this | Load | Form_Load | .ctor:53 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:103 |
| this.panel1 | SizeChanged | panel1_SizeChanged | InitializeComponent:134 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:202 |
| this | Load | FPC0001_SqlPopup_Load | InitializeComponent:275 |

## 6. 컨트롤 (34개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| EmptySpaceItem | 8 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem4, emptySpaceItem4, emptySpaceItem3, emptySpaceItem1, emptySpaceItem2 |
| LayoutControlItem | 6 | layoutControlItem2, layoutControlItem1, layoutControlItem4, layoutControlItem3, layoutControlItem_SSQL, layoutControlItem1 |
| UsrButton | 4 | SuperRoleSQL, btnSql, btnClose, btnSave |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl1 |
| UsrCombo | 2 | cboInstance, usrComboBox_Category |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup1 |
| Panel | 2 | panel1, panel2 |
| SplitContainer | 1 | splitContainer1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrTextBox | 1 | txtKeyType |
| RichTextBox | 1 | rtxtSQL |
| GroupControl | 1 | groupControl1 |
| ContextMenuStrip | 1 | contextMenuStrip1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 16 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 2 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 406 | SCM.SCM0003_GET_LOOKUP_MASTER | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP01991 | Main | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:197

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 118 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 119 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 120 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 121 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
