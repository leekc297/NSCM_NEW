# SCP0016 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0016_WaterfallShipmentPlanFG\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0016_WaterfallShipmentPlanFG\SCP0016_WaterfallShipmentPlanFG.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0016_WaterfallShipmentPlanFG\SCP0016_WaterfallShipmentPlanFG.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0016_WaterfallShipmentPlanFG\SCP0016_WaterfallShipmentPlanFG.csproj | 1359 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0016_WaterfallShipmentPlanFG\SCP0016_WaterfallShipmentPlanFG.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0016_WaterfallShipmentPlanFG\SCP0016_WaterfallShipmentPlanFG.csproj | 975 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 739 | SCP.SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | MATCH | SP SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL |
| button:FindButton | FindButton > FindData_Main | 782 | SCP.SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | MATCH | SP SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 1123 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 1123 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread_2 > GetSpdTitle | 1123 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread_2 > GetSpdTitle | 1123 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread_2 > GetSpdTitle | 1123 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread_2 > GetSpdTitle | 1123 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread_2 > GetSpdTitle | 1123 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread_2 > GetSpdTitle | 1123 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.dCalendar.ValueChanged | dCalendar_ValueChanged > cboBucketType_SelectedIndexChanged > InitSpread_2 > GetSpdTitle | 1123 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.dCalendar.ValueChanged | dCalendar_ValueChanged > cboBucketType_SelectedIndexChanged > InitSpread_2 > GetSpdTitle | 1123 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls | 207 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 210 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 1123 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 1123 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO, INSERT:#T_M, SELECT:SCM_SYS_CALENDAR_M, INSERT:#T_W, SELECT:#T_M, INSERT:#T_D, SELECT:#T_W, CREATE:#T_WHOLE, SELECT:#T_D, INSERT:#T_WHOLE, SELECT:#T_WHOLE |  |
| SCP.SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | MATCH | 1 | SP SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | EXEC:SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_IN_STR, CREATE:#TMP_SCP0016_DATA1, DYNAMIC@SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL, INSERT:#TMP_SCP0016_BOD_N_V, SELECT:SCP_MST_BOD_N_V, CREATE:#TBLDYNAMICPIVOT_SCP0016, REF:FN_GET_DIVISION_DIV, SELECT:SCM_SYS_CALENDAR_M, REF:FN_SCM_SPLIT, SELECT:SCM_MST_DIVISION |  |
| SCP.SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | MATCH | 1 | SP SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | EXEC:SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL, REF:FN_GET_IN_STR, SELECT:SCM_MST_TITLESET_USER, CREATE:#TBLDYNAMICPIVOT_SCP0016, REF:FN_GET_DIVISION_DIV, DYNAMIC@SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL, SELECT:SCM_SYS_CALENDAR_M, REF:FN_SCM_SPLIT, SELECT:SCM_MST_DIVISION |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:232, FindData_Main:671, FindData_Main:674, FindData_Main:679, FindData_Main:680, SetOperationGroupByDivision:927, GetDayRange:1148 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread_2:306 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread_2:308 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread_2:310 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:171 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:564 |
| clbVersion | SelectedIndexChanged | ClbVersion_SelectedIndexChanged | InitEvent:565 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:566 |
| this.dCalendar | ValueChanged | dCalendar_ValueChanged | InitEvent:567 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:570 |
| this.btnProject | Click | BtnProject_Click | InitEvent:572 |
| this.btnItem_Id | Click | BtnItem_Id_Click | InitEvent:573 |
| this.btnMeasure | Click | btnMeasure_Click | InitEvent:574 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:576 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:577 |
| this.btnColumn | Click | BtnColumn_Click | InitEvent:580 |

## 6. 컨트롤 (35개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 13 | lblProject, lciSum, lblCombo, lblCombo1, layoutControlItem2, lblItemId, layoutControlItem4, layoutControlItem1, lblBucket, layoutControlItem3, layoutControlItem5, layoutControlItem7, layoutControlItem6 |
| UsrButton | 5 | usrButton1, btnColumn, btnMeasure, btnProject, btnItem_Id |
| UsrCombo | 3 | cboBizType, cboDivision, cboBucketType |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem3, emptySpaceItem2 |
| UsrMultiLineEditor | 2 | txtItem_Id, txtProject |
| UsrCheckedList | 2 | clbVersion, clbElecType |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker3 | 1 | dCalendar |
| UsrCheckBox | 1 | chkSum |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SheetView | 1 | spdMain_Sheet1 |
| FpSpread | 1 | spdMain |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 21 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 28 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 8 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 20 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 6 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 63 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (4건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 267 | SCP.SCP0011_GET_LAST_PLAN_VERSION | commented:MATCH |
| 825 | SCP.SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | commented:MATCH |
| 1157 | SCP.SCM0001_GET_SCP_PERIOD | commented:MATCH |
| 1156 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0016 | Waterfall Shipment Plan | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 |
| SCM_MST_SHEET_MEASURE | SCP0016 | Shipment Plan FG | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Waterfall Shipment Plan
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread_2:308
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn, InitSpreadDateColumnISO, InitSpreadDateColumnNotISO

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumnISO |  | 420 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | for(i <= dsSpdTitle.Tables[0].Rows.Count-1) |
| InitSpreadDateColumnNotISO |  | 493 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(cCOLUMN_NAME.IndexOf("B_") > 0) |
| InitSpreadDateColumnNotISO |  | 501 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(cCOLUMN_NAME.IndexOf("B_") > 0) |
| InitSpreadDateColumnNotISO |  | 507 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?cDAY_CODE == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(cCOLUMN_NAME.IndexOf("B_") > 0) ⟫ if(cDAY_CODE == "SAT"\|\| cDAY_CODE == "SUN") |
| SetSpreadColumn |  | 1235 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ if(isDaily \|\| isWeekly) |
| SetSpreadColumn |  | 1240 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ if(isMonthly \|\| isWeekly) |
| SetSpreadColumn |  | 1249 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY" ⟫ if(isDaily) |
| SetSpreadColumn |  | 1253 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY" ⟫ else!(isDaily) ⟫ if(isWeekly) |
| SetSpreadColumn |  | 1258 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY" ⟫ if(isMonthly) |
| SetSpreadColumn |  | 1265 | 표시/라벨 변경 | set:Visible | Visible = {?isWeeklyISO} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY_ISO" |
| SetSpreadColumn |  | 1273 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "MONTHLY" ⟫ if(isDaily \|\| isWeekly) |
| SetSpreadColumn |  | 1277 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "MONTHLY" ⟫ else!(isDaily \|\| isWeekly) |
| InitializeComponent |  | 861 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 862 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 863 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 864 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Waterfall Shipment Plan | META+코드연결 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
