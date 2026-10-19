# DMF0046 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Plan.UIL\DMF0046_GetBODItemPrjRoutePopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 351 |
| only | 06.UIL\GSCM.DM.Plan.UIL\DMF0046_GetBODItemPrjRoutePopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 289 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 294 | {?string.Empty} | UNRESOLVED |  |
| button:FindButton | FindButton > FindData | 294 | DM.DMF0046_GET_BODITEM_FOR_PRJROUTE_POPUP | MATCH | SP DMF0046_GET_BODITEM_FOR_PRJROUTE_POPUP |
| event:this.Load | Form_Load > FindData | 294 | {?string.Empty} | UNRESOLVED |  |
| event:this.Load | Form_Load > FindData | 294 | DM.DMF0046_GET_BODITEM_FOR_PRJROUTE_POPUP | MATCH | SP DMF0046_GET_BODITEM_FOR_PRJROUTE_POPUP |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?string.Empty} | UNRESOLVED | 1 |  |  |  |
| DM.DMF0046_GET_BODITEM_FOR_PRJROUTE_POPUP | MATCH | 1 | SP DMF0046_GET_BODITEM_FOR_PRJROUTE_POPUP | EXEC:DMF0046_GET_BODITEM_FOR_PRJROUTE_POPUP, SELECT:SCP_MST_BOD_V, SELECT:SCP_MST_BOD_ITEM, SELECT:SCP_MST_BOD, SELECT:SCM_MST_SITE, SELECT:SCP_MST_DISTRIBUTION_ROUTE, SELECT:SCM_MST_SSO_DEPT_INFO |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:147 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:203 |
| this | Load | Form_Load | .ctor:165 |

## 6. 컨트롤 (11개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlGroup | 3 | layoutControlGroup1, layoutControlGroup2, Root |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrButtonList | 1 | btnButtonList |
| LayoutControlItem | 1 | layoutControlItem3 |
| EmptySpaceItem | 1 | emptySpaceItem1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 294 | FindData | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 1 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: BOD Item Master

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 205 | 하드코딩 | AddTextColumn | LOCK | LOCK |  |
| InitSpread |  | 206 | 하드코딩 | AddTextColumn | FROM_SITE | FROM_SITE |  |
| InitSpread |  | 207 | 하드코딩 | AddTextColumn | FROM_DIVISION_ID | FROM_DIVISION_ID |  |
| InitSpread |  | 208 | 하드코딩 | AddTextColumn | From Site | FROM_SITE_NAME |  |
| InitSpread |  | 209 | 하드코딩 | AddTextColumn | TO_SITE | TO_SITE |  |
| InitSpread |  | 210 | 하드코딩 | AddTextColumn | TO_DIVISION_ID | TO_DIVISION_ID |  |
| InitSpread |  | 211 | 하드코딩 | AddTextColumn | To Site | TO_SITE_NAME |  |
| InitSpread |  | 212 | 하드코딩 | AddTextColumn | Model | ITEM_ID |  |
| InitSpread |  | 213 | 하드코딩 | AddTextColumn | Priority | PRIORITY |  |
| InitSpread |  | 214 | 하드코딩 | AddTextColumn | BOD_ID | BOD_ID |  |
| InitSpread |  | 215 | 하드코딩 | AddTextColumn | FROZEN_YYYYMMDD | FROZEN_YYYYMMDD |  |
| InitSpread |  | 216 | 하드코딩 | AddTextColumn | Incoterms | INCOTERMS |  |
| InitSpread |  | 217 | 하드코딩 | AddTextColumn | Trans Mode | TRANSPORT_MODE |  |
| InitSpread |  | 218 | 하드코딩 | AddTextColumn | BOD Item Valid | BOD_ITEM_VALID |  |
| InitSpread |  | 219 | 하드코딩 | AddTextColumn | Mon | DAYS_MON |  |
| InitSpread |  | 220 | 하드코딩 | AddTextColumn | Tue | DAYS_TUE |  |
| InitSpread |  | 221 | 하드코딩 | AddTextColumn | Wed | DAYS_WED |  |
| InitSpread |  | 222 | 하드코딩 | AddTextColumn | Thu | DAYS_THU |  |
| InitSpread |  | 223 | 하드코딩 | AddTextColumn | Fri | DAYS_FRI |  |
| InitSpread |  | 224 | 하드코딩 | AddTextColumn | Sat | DAYS_SAT |  |
| InitSpread |  | 225 | 하드코딩 | AddTextColumn | Sun | DAYS_SUN |  |
| InitSpread |  | 226 | 하드코딩 | AddTextColumn | L/T(Day) | LEAD_TIME |  |
| InitSpread |  | 227 | 하드코딩 | AddTextColumn | END_CUSTOMER | END_CUSTOMER |  |
| InitSpread |  | 228 | 하드코딩 | AddTextColumn | DEPT_NAME_KO | DEPT_NAME_KO |  |
| InitializeComponent |  | 219 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 220 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 221 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 222 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| BOD Item Master | 코드 하드코딩 전용(메타 없음) | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
