# SCP0018 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0018_WaterfallShipmentPlanSemi\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0018_WaterfallShipmentPlanSemi\SCP0018_WaterfallShipmentPlanSemi.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0018_WaterfallShipmentPlanSemi\SCP0018_WaterfallShipmentPlanSemi.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0018_WaterfallShipmentPlanSemi\SCP0018_WaterfallShipmentPlanSemi.csproj | 1161 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0018_WaterfallShipmentPlanSemi\SCP0018_WaterfallShipmentPlanSemi.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0018_WaterfallShipmentPlanSemi\SCP0018_WaterfallShipmentPlanSemi.csproj | 825 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 680 | SCP.SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL | MATCH | SP SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 999 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 999 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread_2 > GetSpdTitle | 999 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread_2 > GetSpdTitle | 999 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.cboBucketType.SelectedIndexChanged | CboBucketType_SelectedIndexChanged > InitSpread_2 > GetSpdTitle | 999 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.cboBucketType.SelectedIndexChanged | CboBucketType_SelectedIndexChanged > InitSpread_2 > GetSpdTitle | 999 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls | 199 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 585 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 590 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 999 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 999 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO, INSERT:#T_M, SELECT:SCM_SYS_CALENDAR_M, INSERT:#T_W, SELECT:#T_M, INSERT:#T_D, SELECT:#T_W, CREATE:#T_WHOLE, SELECT:#T_D, INSERT:#T_WHOLE, SELECT:#T_WHOLE |  |
| SCP.SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL | MATCH | 1 | SP SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL | EXEC:SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_IN_STR, CREATE:#TBLDYNAMICPIVOT_SCP0018, DYNAMIC@SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL, SELECT:SCM_SYS_CALENDAR_M, REF:FN_SCM_SPLIT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread_2:224, InitSpread:300 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread_2:226 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread_2:228, InitSpread:304 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetCheckedListValue | InitSpread_2:234, SetChangedControl:577, FindData_Main:653, FindData_Main:654, FindData_Main:661, FindData_Main:662, SetOperationGroupByDivision:852, GetDayRange:1033 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:272 |
| this | Load | Form_Load | .ctor:161 |
| this.cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged1 | InitEvent:487 |
| this.clbVersion | SelectedIndexChanged | ClbVersion_SelectedIndexChanged | InitEvent:488 |
| this.cboBucketType | SelectedIndexChanged | CboBucketType_SelectedIndexChanged | InitEvent:489 |
| this.btnItem_Id | Click | BtnItem_Id_Click | InitEvent:492 |
| this.btnMeasure | Click | btnMeasure_Click | InitEvent:493 |
| this.chkSum | CheckedChanged | ChkSum_CheckedChanged | InitEvent:494 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:496 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:497 |

## 6. 컨트롤 (30개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 10 | lblCombo1, lciSum, layoutControlItem1, lblBucket, lblItemId, layoutControlItem3, layoutControlItem2, layoutControlItem5, layoutControlItem4, layoutControlItem6 |
| EmptySpaceItem | 4 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem4, emptySpaceItem6 |
| UsrButton | 3 | usrButton1, btnMeasure, btnItem_Id |
| UsrCombo | 3 | cboOperGroup, cboDivision, cboBucketType |
| UsrCheckedList | 2 | clbVersion, clbElecType |
| UsrConditionPanel | 1 | pnlCondition |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker3 | 1 | dCalendar |
| UsrCheckBox | 1 | chkSum |
| UsrMultiLineEditor | 1 | txtItemId |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SheetView | 1 | spdMain_Sheet1 |
| FpSpread | 1 | spdMain |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 4 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 24 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 13 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_Favorite | 3 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 27 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (2건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1025 | SCP.SCM0001_GET_SCP_PERIOD | commented:MATCH |
| 1024 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0018 | Waterfall Shipment Plan | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |
| SCM_MST_SHEET_MEASURE | SCP0018 | CELL | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_MEASURE | SCP0018 | ELECTRODE | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Waterfall Shipment Plan
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread_2:226
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn, InitSpreadDateColumnISO, InitSpreadDateColumnNotISO

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread_2 |  | 238 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 239 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_FROM_DIVISION_ID | if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 240 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_TO_DIVISION_ID | if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 244 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 245 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_FROM_DIVISION_ID | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 246 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_TO_DIVISION_ID | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread | Waterfall Shipment Plan | 255 | 하드코딩 | AddTextColumn | KEY_IDX | key_idx |  |
| InitSpread | Waterfall Shipment Plan | 256 | 하드코딩 | AddTextColumn | Division | division_id |  |
| InitSpread | Waterfall Shipment Plan | 257 | 하드코딩 | AddTextColumn | Operation Group | operation_group_name |  |
| InitSpread | Waterfall Shipment Plan | 258 | 하드코딩 | AddTextColumn | Model | item_id |  |
| InitSpread | Waterfall Shipment Plan | 259 | 하드코딩 | AddTextColumn | Nick Name | nick_name |  |
| InitSpread | Waterfall Shipment Plan | 260 | 하드코딩 | AddTextColumn | From Site | from_site_name |  |
| InitSpread | Waterfall Shipment Plan | 261 | 하드코딩 | AddNumColumn | BOH (From Site) | boh |  |
| InitSpread | Waterfall Shipment Plan | 262 | 하드코딩 | AddTextColumn | To Site | to_site_name |  |
| InitSpread | Waterfall Shipment Plan | 263 | 하드코딩 | AddTextColumn | Trans Mode | transport_mode |  |
| InitSpread | Waterfall Shipment Plan | 264 | 하드코딩 | AddTextColumn | L/T(Day) | lt_day |  |
| InitSpread | Waterfall Shipment Plan | 265 | 하드코딩 | AddTextColumn | Version | version_no |  |
| InitSpread | Waterfall Shipment Plan | 266 | 하드코딩 | AddTextColumn | Measure | measure_label |  |
| InitSpread | Waterfall Shipment Plan | 267 | 하드코딩 | AddTextColumn | Measure | measure |  |
| InitSpread | Waterfall Shipment Plan | 268 | 하드코딩 | AddTextColumn | Division Name | DIVISION_NAME |  |
| InitSpread | Waterfall Shipment Plan | 269 | 하드코딩 | AddTextColumn | Operation Group | operation_group |  |
| InitSpread | Waterfall Shipment Plan | 270 | 하드코딩 | AddTextColumn | from_site | from_site |  |
| InitSpread | Waterfall Shipment Plan | 271 | 하드코딩 | AddTextColumn | to_site | to_site |  |
| InitSpread | Waterfall Shipment Plan | 272 | 하드코딩 | AddTextColumn | BOD ID | bod_id |  |
| InitSpread | Waterfall Shipment Plan | 273 | 하드코딩 | AddTextColumn | MEASURE_ORDER_NO | measure_order_no |  |
| InitSpread | Waterfall Shipment Plan | 274 | 하드코딩 | AddTextColumn | from_yyyymmdd | from_yyyymmdd |  |
| InitSpread | Waterfall Shipment Plan | 275 | 하드코딩 | AddTextColumn | to_yyyymmdd | to_yyyymmdd |  |
| InitSpreadDateColumnISO |  | 344 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | for(i <= dsSpdTitle.Tables[0].Rows.Count-1) |
| InitSpreadDateColumnNotISO |  | 413 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(COLUMN_NAME.IndexOf("B_") > 0) |
| InitSpreadDateColumnNotISO |  | 421 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(COLUMN_NAME.IndexOf("B_") > 0) |
| InitSpreadDateColumnNotISO |  | 427 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?DAY_CODE == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(COLUMN_NAME.IndexOf("B_") > 0) ⟫ if(DAY_CODE == "SAT"\|\| DAY_CODE == "SUN") |
| SetSpreadColumn |  | 524 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ if(isDaily \|\| isWeekly) |
| SetSpreadColumn |  | 529 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ if(isMonthly \|\| isWeekly) |
| SetSpreadColumn |  | 538 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY" ⟫ if(isDaily) |
| SetSpreadColumn |  | 542 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY" ⟫ else!(isDaily) ⟫ if(isWeekly) |
| SetSpreadColumn |  | 547 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY" ⟫ if(isMonthly) |
| SetSpreadColumn |  | 554 | 표시/라벨 변경 | set:Visible | Visible = {?isWeeklyISO} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY_ISO" |
| SetSpreadColumn |  | 562 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "MONTHLY" ⟫ if(isDaily \|\| isWeekly) |
| SetSpreadColumn |  | 566 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "MONTHLY" ⟫ else!(isDaily \|\| isWeekly) |
| InitializeComponent |  | 718 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 719 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 720 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 721 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Waterfall Shipment Plan | META+코드연결 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 24 | 24 | 24 | 24 | 24 | 24 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
