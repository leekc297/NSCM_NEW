# FPC0112 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0112_AlarmPopup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 969 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0112_AlarmPopup.designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 701 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:this.btnSave.Click | btnSave_Click > SaveToDB | 762 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=saveAll_planAmendAlarmMemoP] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > SaveToDB | 762 | FP\Common\PlanAmendMemo#saveAll_planAmendAlarmMemoP | MATCH_PATTERN | [update-batch]  |
| event:this.spdMain.CellClick | spdMain_CellClick | 868 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | spdMain_CellClick | 868 | FP\Common\PICAlarm#find_alarm | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_alarm.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=saveAll_planAmendAlarmMemoP] | BIZ_MATCH | 1 |  |  |  |
| FP\Common\PICAlarm#find_alarm | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_alarm.sql | SELECT:FP_AMEND_PIC_ALARM |  |
| FP\Common\PlanAmendMemo#saveAll_planAmendAlarmMemoP | MATCH_PATTERN | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnAdd_Click | Filter | MEMO_TYPE |
| FindData | er | ITEM_ID, ALARM_TIME, PLAN_DATE |
| SaveToDB | m2.Columns | ALARM_TIME |
| SaveToDB | ro | USER_ID |
| spdMain_CellClick | row | ITEM_ID, ALARM_TIME, PIC_REF |
| spdMain_CellClick | Filter | OLD_PIC_REF, PIC_REF |
| spdMain_CellClick | r | USER_ID, USERID, TEAM_NAME, DEPT_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| HasMemoAuthority | InitControls:252, FindData:586, SaveToDB:783 | UserService.HasMemoAuthority | NowGroupID |
| FP_PseudoBatch2 | SaveToDB:762 | DataService.FP_PseudoBatch2 | COUNT, EXCEPTION, RESULT |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:215 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:172 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:224 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:264 |
| this.btnPlus | Click | btnAdd_Click | InitializeComponent:304 |
| this.spdMain | SelectionChanged | spdMain_SelectionChanged | InitializeComponent:376 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:377 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:378 |
| this.dtPicker | ValueChanged | dtPicker_ValueChanged | InitializeComponent:600 |

## 6. 컨트롤 (28개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| UsrButton | 4 | btnSave, btnClose, btnFind, btnPlus |
| LayoutControlItem | 4 | layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem6 |
| Label | 3 | label1, label3, label2 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| SplitContainer | 2 | splitContainer1, splitContainer2 |
| Panel | 2 | panel1, panel2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| ImageList | 1 | imageList1 |
| EmptySpaceItem | 1 | emptySpaceItem1 |
| RichTextBox | 1 | txtMemo |
| UsrDateTimePickerWtWeek | 1 | dtPicker |

## 7. 확인 필요 (2건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 868 | spdMain_CellClick | FP\{?default:part_service}\PICAlarm#find_alarm | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 762 | SaveToDB | FP\{?default:part_service}\PlanAmendMemo#saveAll_planAmendAlarmMemoP | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 26 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FPC0112 | MemoPopup | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 |
| SCM_MST_SHEET_COLUMNS | FPC0112 | PIC | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: MemoPopup, PIC
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:290, SetSheetHeaderColumn_FP@InitSpread:328

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 301 | 표시/라벨 변경 | set:Visible | Visible = {?false} | HASALARM | if(spreadInfo.SheetName == "MemoPopup") |
| InitSpread |  | 303 | 표시/라벨 변경 | set:Visible | Visible = {?true} | CHK | if(spreadInfo.SheetName == "MemoPopup") ⟫ if(IsRef==true) |
| InitSpread |  | 318 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(spreadInfo.SheetName == "MemoPopup") |
| InitSpread |  | 319 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(spreadInfo.SheetName == "MemoPopup") |
| InitSpread |  | 320 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(spreadInfo.SheetName == "MemoPopup") |
| InitializeComponent |  | 394 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 395 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 396 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 397 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 514 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 515 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 516 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 517 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| MemoPopup | META+코드연결 | 21 (?1) | 21 (?1) | 21 (?1) | 21 (?1) | 21 (?1) | 21 (?1) | 21 (?1) | 21 (?1) | 21 (?1) | 21 (?1) | 21 (?1) | 21 (?1) | 21 (?1) | 21 (?1) |
| PIC | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 정적평가 미지원식 14 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 14건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
