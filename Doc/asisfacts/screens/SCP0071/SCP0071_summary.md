# SCP0071 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0071_CAPA_Balance_Small\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0071_CAPA_Balance_Small\SCP0071_CAPA_Balance_Small.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0071_CAPA_Balance_Small\SCP0071_CAPA_Balance_Small.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0071_CAPA_Balance_Small\SCP0071_CAPA_Balance_Small.csproj | 1011 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0071_CAPA_Balance_Small\SCP0071_CAPA_Balance_Small.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0071_CAPA_Balance_Small\SCP0071_CAPA_Balance_Small.csproj | 646 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 449 | biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 453 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 460 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 859 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 968 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 950 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 534 | SCP.SCP0071_GET_CAPA_BALANCE_SMALL | MATCH | SP SCP0071_GET_CAPA_BALANCE_SMALL |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 839 | SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0070_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 449 | biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 453 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 460 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetBucketType | 807 | SCP.SCP0070_GET_BUCKET_TYPE_CODE | MATCH | SP SCP0070_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetQtyData | 819 | SCP.SCP0070_GET_QTY_TYPE_CODE | MATCH | SP SCP0070_GET_QTY_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 839 | SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0070_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetDayRange | 859 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:REF:FN_CHAR_TO_DATE, UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V, UP_FX_GetCommonDataList:SELECT:SCM_SYS_CALENDAR_M, UP_FX_GetCommonDataList:SELECT:SCP_PLN_INTERFACE_YN, UP_FX_GetCommonDataList:REF:FN_SPLITSTRING |
| biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0070_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP SCP0070_GET_BUCKET_TYPE_CODE | EXEC:SCP0070_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0070_GET_QTY_TYPE_CODE | MATCH | 1 | SP SCP0070_GET_QTY_TYPE_CODE | EXEC:SCP0070_GET_QTY_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0070_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0070_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0071_GET_CAPA_BALANCE_SMALL | MATCH | 1 | SP SCP0071_GET_CAPA_BALANCE_SMALL | EXEC:SCP0071_GET_CAPA_BALANCE_SMALL, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@SCP0071_GET_CAPA_BALANCE_SMALL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| Set_SumValues | dsBinding.Tables[0].Columns | measure, measure_color |
| Set_SumValues | dsBinding.Tables[0].Rows[iRow] | TYPE, MEASURE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:210 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:212 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:213 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetCheckedListValue | SetChangedControl:438, SetChangedControl:452, SetChangedControl:459, FindData_Main:512, FindData_Main:517, FindData_Main:518, FindData_Main:519, GetDayRange:855 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:146 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:300 |
| this.cboBucketType | SelectedIndexChanged | CboBucketType_SelectedIndexChanged | InitEvent:302 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:304 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:306 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:307 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:308 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:309 |
| cboQTY | SelectedIndexChanged | cboQTY_SelectedIndexChanged | InitEvent:310 |

## 6. 컨트롤 (23개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | lblCombo1, PlanDate, PlanType, SEQ, lblBucket, lblQty, layoutControlItem1 |
| UsrCombo | 6 | cboDivision, cboBucketType, cboPlanDate, cboPlanType, cboPlanSeq, cboQTY |
| EmptySpaceItem | 3 | emptySpaceItem3, emptySpaceItem1, emptySpaceItem2 |
| UsrButton | 1 | usrButton1 |
| UsrConditionPanel | 1 | pnlCondition |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker3 | 1 | dCalendar |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SheetView | 1 | spdMain_Sheet1 |
| FpSpread | 1 | spdMain |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 2 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 5 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 17 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 7 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0071 | CAPA Balance Small | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 |
| SCM_MST_SHEET_MEASURE | SCP0071 | Capa Balance | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: CAPA Balance Small
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:212
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 256 | DB루프 | AddNumColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| SetSpreadColumn |  | 425 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("Q_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("Y_") == 0) |
| SetSpreadColumn |  | 430 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 550 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 551 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 552 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 553 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| CAPA Balance Small | META+코드연결 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
