# SCM0016 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SCM.Master.UIL\SCM0016_BatchLog.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 386 |
| only | 06.UIL\GSCM.SCM.Master.UIL\SCM0016_BatchLog.Designer.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 432 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 288 | SCM.SCM0016_GET_BATCH_LOG | MATCH | SP SCM0016_GET_BATCH_LOG |
| event:spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_Step | 322 | SCM.SCM0016_GET_BATCH_STEP_INFO | MATCH | SP SCM0016_GET_BATCH_STEP_INFO |
| event:spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindData_Hist | 358 | SCM.SCM0016_GET_BATCH_LOG_HIST | MATCH | SP SCM0016_GET_BATCH_LOG_HIST |
| unreached:(진입점 미연결) | <field:dtRunStatus> | 43 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| SCM.SCM0016_GET_BATCH_LOG | MATCH | 1 | SP SCM0016_GET_BATCH_LOG | EXEC:SCM0016_GET_BATCH_LOG, REF:FN_GET_LOOKUP_CODE_DESC, SELECT:SYSJOBS, SELECT:SYSJOBSCHEDULES, SELECT:SYSJOBHISTORY, SELECT:SERVERS, SELECT:SYSJOBSTEPS, SELECT:SYSSCHEDULES, REF:STRING_SPLIT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0016_GET_BATCH_LOG_HIST | MATCH | 1 | SP SCM0016_GET_BATCH_LOG_HIST | EXEC:SCM0016_GET_BATCH_LOG_HIST, REF:FN_GET_LOOKUP_CODE_DESC, SELECT:SYSJOBHISTORY, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0016_GET_BATCH_STEP_INFO | MATCH | 1 | SP SCM0016_GET_BATCH_STEP_INFO | EXEC:SCM0016_GET_BATCH_STEP_INFO, SELECT:SYSJOBSTEPS, SELECT:SYSJOBS |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | FindData:280, FindData_Step:314, FindData_Hist:350 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:104 |
| spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitEvent:142 |

## 6. 컨트롤 (16개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| FpSpread | 3 | spdMain, spdStep, spdHist |
| SheetView | 3 | spdMain_Sheet1, spdStep_Sheet1, spdHist_Sheet1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| SplitContainer | 2 | splitContainer1, splitContainer2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCheckedList | 1 | clbRunStatus |
| EmptySpaceItem | 1 | emptySpaceItem1 |
| LayoutControlItem | 1 | layoutControlItem1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 3 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Batch Log, Step Info, Batch Run Log

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 182 | 하드코딩 | AddTextColumn | JOB_ID | JOB_ID | if(spreadInfo.SheetName == "Batch Log") |
| InitSpread |  | 183 | 하드코딩 | AddTextColumn | JobName | JOB_NAME | if(spreadInfo.SheetName == "Batch Log") |
| InitSpread |  | 184 | 하드코딩 | AddTextColumn | Job Description | JOB_DESCRIPTION | if(spreadInfo.SheetName == "Batch Log") |
| InitSpread |  | 185 | 하드코딩 | AddTextColumn | STEP_ID | STEP_ID | if(spreadInfo.SheetName == "Batch Log") |
| InitSpread |  | 186 | 하드코딩 | AddTextColumn | Step Name | STEP_NAME | if(spreadInfo.SheetName == "Batch Log") |
| InitSpread |  | 187 | 하드코딩 | AddTextColumn | SCHEDULE_UID | SCHEDULE_UID | if(spreadInfo.SheetName == "Batch Log") |
| InitSpread |  | 188 | 하드코딩 | AddTextColumn | Schedule Name | SCHEDULE_NAME | if(spreadInfo.SheetName == "Batch Log") |
| InitSpread |  | 189 | 하드코딩 | AddTextColumn | Last Run Date | RUN_DATE | if(spreadInfo.SheetName == "Batch Log") |
| InitSpread |  | 190 | 하드코딩 | AddTextColumn | RUN_STATUS | RUN_STATUS | if(spreadInfo.SheetName == "Batch Log") |
| InitSpread |  | 191 | 하드코딩 | AddTextColumn | Last Run Status | RUN_STATUS_NAME | if(spreadInfo.SheetName == "Batch Log") |
| InitSpread |  | 192 | 하드코딩 | AddTextColumn | Last Run Duration | RUN_DURATION | if(spreadInfo.SheetName == "Batch Log") |
| InitSpread |  | 193 | 하드코딩 | AddTextColumn | Last Run Status Message | RUN_STATUS_MESSAGE | if(spreadInfo.SheetName == "Batch Log") |
| InitSpread |  | 194 | 하드코딩 | AddTextColumn | Next Run Date | NEXT_RUN_DATE | if(spreadInfo.SheetName == "Batch Log") |
| InitSpread |  | 202 | 하드코딩 | AddTextColumn | JOB_ID | JOB_ID | else!(spreadInfo.SheetName == "Batch Log") ⟫ if(spreadInfo.SheetName == "Step Info") |
| InitSpread |  | 203 | 하드코딩 | AddTextColumn | JOB_NAME | JOB_NAME | else!(spreadInfo.SheetName == "Batch Log") ⟫ if(spreadInfo.SheetName == "Step Info") |
| InitSpread |  | 204 | 하드코딩 | AddTextColumn | STEP_UID | STEP_UID | else!(spreadInfo.SheetName == "Batch Log") ⟫ if(spreadInfo.SheetName == "Step Info") |
| InitSpread |  | 205 | 하드코딩 | AddTextColumn | STEP_ID | STEP_ID | else!(spreadInfo.SheetName == "Batch Log") ⟫ if(spreadInfo.SheetName == "Step Info") |
| InitSpread |  | 206 | 하드코딩 | AddTextColumn | Step Name | STEP_NAME | else!(spreadInfo.SheetName == "Batch Log") ⟫ if(spreadInfo.SheetName == "Step Info") |
| InitSpread |  | 207 | 하드코딩 | AddTextColumn | Step Type | STEP_TYPE | else!(spreadInfo.SheetName == "Batch Log") ⟫ if(spreadInfo.SheetName == "Step Info") |
| InitSpread |  | 208 | 하드코딩 | AddTextColumn | Command | EXEC_COMMAND | else!(spreadInfo.SheetName == "Batch Log") ⟫ if(spreadInfo.SheetName == "Step Info") |
| InitSpread |  | 209 | 하드코딩 | AddTextColumn | OnSuccessAction | ON_SUCCESS_ACTION | else!(spreadInfo.SheetName == "Batch Log") ⟫ if(spreadInfo.SheetName == "Step Info") |
| InitSpread |  | 210 | 하드코딩 | AddTextColumn | Retry Attempts | RETRY_ATTEMPTS | else!(spreadInfo.SheetName == "Batch Log") ⟫ if(spreadInfo.SheetName == "Step Info") |
| InitSpread |  | 211 | 하드코딩 | AddTextColumn | Retry Interval(Minutes) | RETRY_INTERVAL | else!(spreadInfo.SheetName == "Batch Log") ⟫ if(spreadInfo.SheetName == "Step Info") |
| InitSpread |  | 212 | 하드코딩 | AddTextColumn | OnFailureAction | ON_FAILURE_ACTION | else!(spreadInfo.SheetName == "Batch Log") ⟫ if(spreadInfo.SheetName == "Step Info") |
| InitSpread |  | 222 | 하드코딩 | AddTextColumn | JOB_ID | JOB_ID | else!(spreadInfo.SheetName == "Batch Log") ⟫ else!(spreadInfo.SheetName == "Step Info") ⟫ if(spreadInfo.SheetName == "Batch Run Log") |
| InitSpread |  | 223 | 하드코딩 | AddTextColumn | RUN_DATE | RUN_DATE | else!(spreadInfo.SheetName == "Batch Log") ⟫ else!(spreadInfo.SheetName == "Step Info") ⟫ if(spreadInfo.SheetName == "Batch Run Log") |
| InitSpread |  | 224 | 하드코딩 | AddTextColumn | RUN_STATUS | RUN_STATUS | else!(spreadInfo.SheetName == "Batch Log") ⟫ else!(spreadInfo.SheetName == "Step Info") ⟫ if(spreadInfo.SheetName == "Batch Run Log") |
| InitSpread |  | 225 | 하드코딩 | AddTextColumn | Run Status | RUN_STATUS_NAME | else!(spreadInfo.SheetName == "Batch Log") ⟫ else!(spreadInfo.SheetName == "Step Info") ⟫ if(spreadInfo.SheetName == "Batch Run Log") |
| InitSpread |  | 226 | 하드코딩 | AddTextColumn | Run Duration | RUN_DURATION | else!(spreadInfo.SheetName == "Batch Log") ⟫ else!(spreadInfo.SheetName == "Step Info") ⟫ if(spreadInfo.SheetName == "Batch Run Log") |
| InitSpread |  | 227 | 하드코딩 | AddTextColumn | Run Status Message | RUN_STATUS_MESSAGE | else!(spreadInfo.SheetName == "Batch Log") ⟫ else!(spreadInfo.SheetName == "Step Info") ⟫ if(spreadInfo.SheetName == "Batch Run Log") |
| InitializeComponent |  | 211 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 212 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 213 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 214 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 297 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 298 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 299 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 300 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 348 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 349 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 350 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 351 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Batch Log | 코드 하드코딩 전용(메타 없음) | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 |
| Batch Run Log | 코드 하드코딩 전용(메타 없음) | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |
| Step Info | 코드 하드코딩 전용(메타 없음) | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
