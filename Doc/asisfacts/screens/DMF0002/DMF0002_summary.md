# DMF0002 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Master.UIL\BucketConversion.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 1053 |
| only | 06.UIL\GSCM.DM.Master.UIL\BucketConversion.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 372 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindMtoWData | 368 | DM.DMF0002_GET_MONTH_TO_WEEK_DATA | MATCH | SP DMF0002_GET_MONTH_TO_WEEK_DATA |
| button:FindButton | FindButton > FindWtoDData | 403 | DM.DMF0002_GET_WEEK_TO_DAY_DATA | MATCH | SP DMF0002_GET_WEEK_TO_DAY_DATA |
| button:FindButton | FindButton > FindWtoDData > InitSpread > GetSpdTitle | 987 | DM.DMF0002_GET_MTOW_SPREAD_TITLE | MATCH | SP DMF0002_GET_MTOW_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindButton > FindMtoWData | 368 | DM.DMF0002_GET_MONTH_TO_WEEK_DATA | MATCH | SP DMF0002_GET_MONTH_TO_WEEK_DATA |
| button:SaveButton | SaveButton > SaveData > FindButton > FindWtoDData | 403 | DM.DMF0002_GET_WEEK_TO_DAY_DATA | MATCH | SP DMF0002_GET_WEEK_TO_DAY_DATA |
| button:SaveButton | SaveButton > SaveData | 499 | DM.DMF0002_SAVE_BUCKET_CONVERSION_OK | MATCH | SP DMF0002_SAVE_BUCKET_CONVERSION_OK |
| button:SaveButton | SaveButton > SaveData > FindButton > FindWtoDData > InitSpread > GetSpdTitle | 987 | DM.DMF0002_GET_MTOW_SPREAD_TITLE | MATCH | SP DMF0002_GET_MTOW_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > GetSalesSitebyDivision | 960 | SCM_SYS.SCM_SYS_GET_SITE_BY_DIVISION | MATCH | SP SCM_SYS_GET_SITE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > GetDivision | 946 | SCM_SYS.SCM_SYS_GET_DIVISION | MATCH | SP SCM_SYS_GET_DIVISION |
| event:this.Load | Form_Load > InitControls > GetSalesSitebyDivision | 960 | SCM_SYS.SCM_SYS_GET_SITE_BY_DIVISION | MATCH | SP SCM_SYS_GET_SITE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > GetMonthRange | 974 | DM.Get_Month_Range | MATCH | [statement] foxquery_sql\DM.Get_Month_Range.sql |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 987 | DM.DMF0002_GET_MTOW_SPREAD_TITLE | MATCH | SP DMF0002_GET_MTOW_SPREAD_TITLE |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetSalesSitebyDivision | 960 | SCM_SYS.SCM_SYS_GET_SITE_BY_DIVISION | MATCH | SP SCM_SYS_GET_SITE_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| DM.DMF0002_GET_MONTH_TO_WEEK_DATA | MATCH | 1 | SP DMF0002_GET_MONTH_TO_WEEK_DATA | EXEC:DMF0002_GET_MONTH_TO_WEEK_DATA, SELECT:SCM_SYS_CALENDAR_M, EXEC:SP_EXECUTESQL |  |
| DM.DMF0002_GET_MTOW_SPREAD_TITLE | MATCH | 1 | SP DMF0002_GET_MTOW_SPREAD_TITLE | EXEC:DMF0002_GET_MTOW_SPREAD_TITLE, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DMF0002_GET_WEEK_TO_DAY_DATA | MATCH | 1 | SP DMF0002_GET_WEEK_TO_DAY_DATA | EXEC:DMF0002_GET_WEEK_TO_DAY_DATA, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| DM.DMF0002_SAVE_BUCKET_CONVERSION_OK | MATCH | 1 | SP DMF0002_SAVE_BUCKET_CONVERSION_OK | EXEC:DMF0002_SAVE_BUCKET_CONVERSION_OK, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:DM_MST_BUCKET_CONVERSION, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.Get_Month_Range | MATCH | 1 | [statement] foxquery_sql\DM.Get_Month_Range.sql | SELECT:SCM_SYS_CALENDAR_M |  |
| SCM_SYS.SCM_SYS_GET_DIVISION | MATCH | 1 | SP SCM_SYS_GET_DIVISION | EXEC:SCM_SYS_GET_DIVISION | ⚠ DB에 SP 없음 |
| SCM_SYS.SCM_SYS_GET_SITE_BY_DIVISION | MATCH | 1 | SP SCM_SYS_GET_SITE_BY_DIVISION | EXEC:SCM_SYS_GET_SITE_BY_DIVISION | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:180 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SaveData | SaveButton:346 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:217 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:284 |
| this | Load | Form_Load | .ctor:114 |
| dsdm | Changed | shtMainMtoWDataModel_Changed | InitEvent:235 |
| dsdm2 | Changed | shtMainWtoDDataModel_Changed | InitEvent:238 |
| spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitEvent:240 |

## 6. 컨트롤 (14개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 3 | lblDivision, lblMonth, lblSalesSite |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCheckedList | 2 | clbSalesSite, clbDivision |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrMonthRangePicker | 1 | mrpMonth |
| EmptySpaceItem | 1 | emptySpaceItem1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 46 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 947 | DM.Get_Division | commented:NOT_IN_FOXQUERY |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Monthly to Weekly, Weekly to Daily

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 166 | 하드코딩 | AddComboColumn | Division | DIVISION_ID |  |
| InitSpread |  | 167 | 하드코딩 | AddTextColumn | Customer | END_CUSTOMER |  |
| InitSpread |  | 168 | 하드코딩 | AddComboColumn | SalesSite | SCM_SITE_ID |  |
| InitSpread |  | 195 | DB루프 | AddNumTextColumn | {?string.Empty} \|\| {?dr[DefColumns.ColumnLabel]} | {?string.Empty} \|\| {?dr[DefColumns.ColumnName]} | if(siMain.SheetName == "Monthly to Weekly") ⟫ foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpread |  | 211 | 하드코딩 | AddNumTextColumn | MON | D_MON | else!(siMain.SheetName == "Monthly to Weekly") |
| InitSpread |  | 212 | 하드코딩 | AddNumTextColumn | TUE | D_TUE | else!(siMain.SheetName == "Monthly to Weekly") |
| InitSpread |  | 213 | 하드코딩 | AddNumTextColumn | WED | D_WED | else!(siMain.SheetName == "Monthly to Weekly") |
| InitSpread |  | 214 | 하드코딩 | AddNumTextColumn | THU | D_THU | else!(siMain.SheetName == "Monthly to Weekly") |
| InitSpread |  | 215 | 하드코딩 | AddNumTextColumn | FRI | D_FRI | else!(siMain.SheetName == "Monthly to Weekly") |
| InitSpread |  | 216 | 하드코딩 | AddNumTextColumn | SAT | D_SAT | else!(siMain.SheetName == "Monthly to Weekly") |
| InitSpread |  | 217 | 하드코딩 | AddNumTextColumn | SUN | D_SUN | else!(siMain.SheetName == "Monthly to Weekly") |
| InitializeComponent |  | 300 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 301 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 302 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 303 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Monthly to Weekly | 코드 하드코딩 전용(메타 없음) | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 |
| Weekly to Daily | 코드 하드코딩 전용(메타 없음) | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
