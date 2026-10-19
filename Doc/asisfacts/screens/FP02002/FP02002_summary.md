# FP02002 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP02002_Job_Moniter.UIL\FP02002_Job_Moniter_RECIPIENT.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP02002_Job_Moniter.UIL\FP02002_Job_Moniter.UIL.csproj | 326 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP02002_Job_Moniter.UIL\FP02002_Job_Moniter_RECIPIENT.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP02002_Job_Moniter.UIL\FP02002_Job_Moniter.UIL.csproj | 164 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP02002_Job_Moniter.UIL\FP02002_Job_Moniter.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP02002_Job_Moniter.UIL\FP02002_Job_Moniter.UIL.csproj | 538 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP02002_Job_Moniter.UIL\FP02002_Job_Moniter.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP02002_Job_Moniter.UIL\FP02002_Job_Moniter.UIL.csproj | 506 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP02002_Job_Moniter.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP02002_Job_Moniter.UIL\FP02002_Job_Moniter.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP02002_Job_Moniter.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP02002_Job_Moniter.UIL\FP02002_Job_Moniter.UIL.csproj | 64 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP02002_Job_Moniter.UIL\Properties\Settings.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP02002_Job_Moniter.UIL\FP02002_Job_Moniter.UIL.csproj | 27 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 229 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 408 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 408 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Activated | FP02002_Job_Moniter_Activated > UIFindData > Find_Data_Amend | 408 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > FindData | 229 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > timerEngine > UIFindData > Find_Data_Amend | 408 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:timer.Tick | Find_Timer_Tick > UIFindData > Find_Data_Amend | 408 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 2 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| DefaultLineCheck | row | MESSAGE |
| RECIPIENT_Click | Application.OpenForms | FP02002_Job_Moniter_RECIPIENT |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| EditQuery | RefreshSpreadSheet:355 | FPExtensions.EditQuery | ROW_ID |
| SaveData | SaveButton:381 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | ScrollTipFetch | spdMain_ScrollTipFetch | InitializeComponent:105 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:212 |
| this.cboTimerONOFF | SelectedIndexChanged | cboTimerONOFF_SelectedIndexChanged | InitializeComponent:247 |
| this.RECIPIENT | Click | RECIPIENT_Click | InitializeComponent:298 |
| this | DragDrop | FP02002_Job_Moniter_DragDrop | InitializeComponent:449 |
| this | MouseClick | FP02002_Job_Moniter_MouseClick | InitializeComponent:450 |
| this | MouseUp | FP02002_Job_Moniter_MouseUp | InitializeComponent:451 |
| this | Move | FP02002_Job_Moniter_Move | InitializeComponent:452 |
| this | Resize | FP02002_Job_Moniter_Resize | InitializeComponent:453 |
| this | Load | Form_Load | .ctor:89 |
| timer | Tick | Find_Timer_Tick | timerEngine:96 |
| timer | Tick | Find_Timer_Tick | Find_Timer_Tick:113 |
| usrComboBox_Interval | SelectedIndexChanged | UsrComboBox_Interval_SelectedIndexChanged | EventInit:140 |
| cboTimerONOFF | MouseUp | CboTimerONOFF_MouseUp | EventInit:142 |
| this | Activated | FP02002_Job_Moniter_Activated | EventInit:143 |
| this | FormClosed | FP02002_Job_Moniter_FormClosed | EventInit:144 |
| popSql | OnSql | RunSqlSource | btnSql_Click:461 |
| this | Load | Form_Load | .ctor:124 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:88 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:89 |

## 6. 컨트롤 (26개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 6 | layoutControlItem2, layoutControlItem4, layoutControlItem3, layoutControlItem1, layoutControlItem5, layoutControlItem7 |
| EmptySpaceItem | 5 | emptySpaceItem2, emptySpaceItem3, emptySpaceItem4, emptySpaceItem1, emptySpaceItem5 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl1 |
| UsrCombo | 2 | cboTimerONOFF, usrComboBox_Interval |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup1 |
| SplitContainer | 1 | splitContainer1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrButton | 1 | btnSql |
| SimpleButton | 1 | RECIPIENT |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 6 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 2 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP02002 | Main | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main, PlanInfoPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:232

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| FindData |  | 237 | 표시/라벨 변경 | set:Width | Width = 100 |  |  |
| FindData |  | 238 | 표시/라벨 변경 | set:Width | Width = 250 |  |  |
| FindData |  | 242 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.Center} |  |  |
| FindData |  | 243 | 표시/라벨 변경 | set:Locked | Locked = {?true} |  |  |
| FindData |  | 244 | 표시/라벨 변경 | set:Locked | Locked = {?true} |  |  |
| InitializeComponent |  | 105 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 106 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 107 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 108 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 121 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 122 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 123 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 124 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
