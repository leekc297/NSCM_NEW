# SCP0093 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0093_DIO_Trend_Report\POPUP\SCP0093_DioTrendReportPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0093_DIO_Trend_Report\SCP0093_DIO_Trend_Report.csproj | 1307 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0093_DIO_Trend_Report\POPUP\SCP0093_DioTrendReportPopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0093_DIO_Trend_Report\SCP0093_DIO_Trend_Report.csproj | 895 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0093_DIO_Trend_Report\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0093_DIO_Trend_Report\SCP0093_DIO_Trend_Report.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0093_DIO_Trend_Report\SCP0093_DIO_Trend_Report.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0093_DIO_Trend_Report\SCP0093_DIO_Trend_Report.csproj | 3078 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0093_DIO_Trend_Report\SCP0093_DIO_Trend_Report.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0093_DIO_Trend_Report\SCP0093_DIO_Trend_Report.csproj | 1226 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnSearch.Click | BtnSearch_Click > FindCopyData | 553 | SCP.SCP0093_GET_DIO_TREND_DATA_REASON | MATCH | SP SCP0093_GET_DIO_TREND_DATA_REASON |
| event:cboBucketType.SelectedIndexChanged | CboBucketType_SelectedIndexChanged > EditButton > Find_Data_Reset > InitSpread > GetSpdTitle | 2583 | SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0070_GET_SHEET_CALENDAR_3SPAN |
| button:EditButton | EditButton > Find_Data_Reset > InitSpread > GetSpdTitle | 2583 | SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0070_GET_SHEET_CALENDAR_3SPAN |
| button:FindButton | FindButton > FindData | 392 | SCP.SCP0093_GET_DIO_TREND_DATA_REASON | MATCH | SP SCP0093_GET_DIO_TREND_DATA_REASON |
| button:FindButton | FindButton > FindPrice | 452 | SCP.SCP0093_GET_DIO_TREND_DATA_PRICE | MATCH | SP SCP0093_GET_DIO_TREND_DATA_PRICE |
| button:FindButton | FindButton > FindData > GetListPrice | 506 | SCP.SCP0093_GET_DIO_TREND_DATA_PRICE | MATCH | SP SCP0093_GET_DIO_TREND_DATA_PRICE |
| button:FindButton | FindButton > Find_Data | 1422 | SCP.SCP0093_GET_DIO_TREND_DATA | MATCH | SP SCP0093_GET_DIO_TREND_DATA |
| button:FindButton | FindButton > Find_Data > InitSpread > GetSpdTitle | 2583 | SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0070_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData > FindData | 392 | SCP.SCP0093_GET_DIO_TREND_DATA_REASON | MATCH | SP SCP0093_GET_DIO_TREND_DATA_REASON |
| button:SaveButton | SaveButton > SaveData > FindData > GetListPrice | 506 | SCP.SCP0093_GET_DIO_TREND_DATA_PRICE | MATCH | SP SCP0093_GET_DIO_TREND_DATA_PRICE |
| button:SaveButton | SaveButton > SaveData | 650 | SCP.SCP0093_SAVE_DIO_REPORT_REASON | MATCH | SP SCP0093_SAVE_DIO_REPORT_REASON |
| button:SaveButton | SaveButton > Save_Data > Find_Data | 1422 | SCP.SCP0093_GET_DIO_TREND_DATA | MATCH | SP SCP0093_GET_DIO_TREND_DATA |
| button:SaveButton | SaveButton > Save_Data | 1904 | SCP.SCP0093_SAVE_DIO_TREND_DATA | MATCH | SP SCP0093_SAVE_DIO_TREND_DATA |
| button:SaveButton | SaveButton > Save_Data > Find_Data > InitSpread > GetSpdTitle | 2583 | SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0070_GET_SHEET_CALENDAR_3SPAN |
| event:spdMain.ActiveSheetChanged | SpdMain_ActiveSheetChanged > FindPrice | 452 | SCP.SCP0093_GET_DIO_TREND_DATA_PRICE | MATCH | SP SCP0093_GET_DIO_TREND_DATA_PRICE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData | 392 | SCP.SCP0093_GET_DIO_TREND_DATA_REASON | MATCH | SP SCP0093_GET_DIO_TREND_DATA_REASON |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > FindData > GetListPrice | 506 | SCP.SCP0093_GET_DIO_TREND_DATA_PRICE | MATCH | SP SCP0093_GET_DIO_TREND_DATA_PRICE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 650 | SCP.SCP0093_SAVE_DIO_REPORT_REASON | MATCH | SP SCP0093_SAVE_DIO_REPORT_REASON |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 2583 | SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0070_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > FindData | 392 | SCP.SCP0093_GET_DIO_TREND_DATA_REASON | MATCH | SP SCP0093_GET_DIO_TREND_DATA_REASON |
| event:this.Load | Form_Load > FindData > GetListPrice | 506 | SCP.SCP0093_GET_DIO_TREND_DATA_PRICE | MATCH | SP SCP0093_GET_DIO_TREND_DATA_PRICE |
| event:this.Load | Form_Load > InitControls > GetMonthRange | 839 | SCP.SCP0084_GET_MONTH_RANGE | MATCH | SP SCP0084_GET_MONTH_RANGE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2583 | SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0070_GET_SHEET_CALENDAR_3SPAN |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > Find_Chart_Model | 1620 | SCP.SCP0093_GET_DIO_TREND_REPORT_CHART_MODEL | MATCH | SP SCP0093_GET_DIO_TREND_REPORT_CHART_MODEL |
| unreached:(진입점 미연결) | SCM_SYS_LOG_BATCH | 717 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0070_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0070_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0084_GET_MONTH_RANGE | MATCH | 1 | SP SCP0084_GET_MONTH_RANGE | EXEC:SCP0084_GET_MONTH_RANGE, SELECT:SCP_ANL_LONG_TERM_STOCK |  |
| SCP.SCP0093_GET_DIO_TREND_DATA | MATCH | 1 | SP SCP0093_GET_DIO_TREND_DATA | EXEC:SCP0093_GET_DIO_TREND_DATA, EXEC:SCP0093_GET_DIO_TREND_DATA_MM, INSERT:#TARGET_CATEGORY, INSERT:#TARGET_MEASURES, SELECT:TARGET_MEASURES, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#ITEM_NICK_NAME_INFO, SELECT:SCM_MST_ITEM_SN, INSERT:#YIELD_INFO, SELECT:SCM_MST_YIELD_SN, SELECT:CELL_GROUP_INFO, SELECT:SCP_MST_FINAL_ITEM, INSERT:#TMP_MM_DAYS_INFO, SELECT:DAYS_INFO, SELECT:SCM_MST_BUCKET, INSERT:#QUALITY_ISSUES, SELECT:SCP_RPT_DIO_TREND_MM_REASON, INSERT:#SCP_RPT_DIO_TREND_MM, SELECT:SCP_RPT_DIO_TREND_MM, SELECT:#TARGET_CATEGORY, SELECT:#ITEM_NICK_NAME_INFO, DELETE:A, SELECT:#SCP_RPT_DIO_TREND_MM, REF:STRING_SPLIT, SELECT:#TARGET_MEASURES, INSERT:#TMP_RTF, INSERT:#TMP_AVAILABLE_QTY, SELECT:#QUALITY_ISSUES, INSERT:#TMP_AVAILABLE_DIO, SELECT:#TMP_AVAILABLE_QTY, SELECT:#TMP_MM_DAYS_INFO, SELECT:#TMP_RTF, SELECT:#TMP_AVAILABLE_DIO, INSERT:#TMP_TOT_RTF, INSERT:#TMP_TOT_AVAILABLE_QTY, SELECT:QUALITY_ISSUES, INSERT:#TMP_TOT_AVAILABLE_DIO, SELECT:#TMP_TOT_AVAILABLE_QTY, SELECT:#TMP_TOT_RTF, SELECT:#TMP_TOT_AVAILABLE_DIO, INSERT:#FDATA, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_PROJECT, SELECT:#YIELD_INFO, SELECT:DIO_REASON, DELETE:#FDATA, SELECT:MM_LIST, EXEC:SP_EXECUTESQL |  |
| SCP.SCP0093_GET_DIO_TREND_DATA_PRICE | MATCH | 2 | SP SCP0093_GET_DIO_TREND_DATA_PRICE | EXEC:SCP0093_GET_DIO_TREND_DATA_PRICE, SELECT:SCP_RPT_DIO_TREND_MM, REF:STRING_SPLIT |  |
| SCP.SCP0093_GET_DIO_TREND_DATA_REASON | MATCH | 2 | SP SCP0093_GET_DIO_TREND_DATA_REASON | EXEC:SCP0093_GET_DIO_TREND_DATA_REASON, CREATE:#T_CELL_GROUP_INFO, SELECT:SCP_RPT_DIO_TREND_MM, INSERT:#T_CELL_GROUP_INFO, SELECT:W_REASON_LIST, SELECT:W_DATA, REF:STRING_SPLIT, SELECT:W_GAP, SELECT:W_SUM, SELECT:#T_CELL_GROUP_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_MST_DIVISION, SELECT:SCP_RPT_DIO_TREND_MM_REASON |  |
| SCP.SCP0093_GET_DIO_TREND_REPORT_CHART_MODEL | MATCH | 1 | SP SCP0093_GET_DIO_TREND_REPORT_CHART_MODEL | EXEC:SCP0093_GET_DIO_TREND_REPORT_CHART_MODEL, INSERT:#TMP_MONTH, SELECT:SCM_MST_BUCKET, INSERT:#TMP_DATA, SELECT:SCP_RPT_DIO_TREND_MM, SELECT:TARGET_INFO, SELECT:MEASURES, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_MEASURE, SELECT:#TMP_MONTH, SELECT:#TMP_DATA |  |
| SCP.SCP0093_SAVE_DIO_REPORT_REASON | MATCH | 1 | SP SCP0093_SAVE_DIO_REPORT_REASON | EXEC:SCP0093_SAVE_DIO_REPORT_REASON, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SCP_RPT_DIO_TREND_MM_REASON, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0093_SAVE_DIO_TREND_DATA | MATCH | 1 | SP SCP0093_SAVE_DIO_TREND_DATA | EXEC:SCP0093_SAVE_DIO_TREND_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SCP_RPT_DIO_TREND_MM, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ChartDataPivot | row | yyyymm, value, DATA_TYPE |
| GetChartPivotRange | dtPivot.Rows[i] | value |
| GetChartPivotRange | row2 | GUBUN, DATA_MIN, DATA_MAX, SPACING |
| InitControls | UserInfoContext.Current | NowGroupID |
| SetCalculating_chart | dsKrwChart.Tables[x].Rows[i] | GUBUN, DATA_TYPE |
| SetChart_Measure | dtRange.Rows[0] | data_min, data_max, spacing |
| SetChartRange | ds.Tables[5].Rows[0] | data_min, data_max, spacing |
| SetChartRange | ds.Tables[5].Rows[1] | data_min, data_max, spacing |
| SetChartRange | ds.Tables[5].Rows[2] | data_min, data_max, spacing |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | SetSpreadInit:255, InitSpread:414 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:351, btnButtonList_UsrButtonList_Click_Detected:904 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetCheckedListValue | FindData:381, FindData:383, FindPrice:440, FindPrice:442, GetListPrice:497, GetListPrice:499, FindCopyData:543, FindCopyData:545 | CString.GetCheckedListValue | CODE |
| OnShown | OnShown:300 | BaseForm.OnShown | NowGroupID, USER_ID |
| GetSpdTitle | InitSpread:412, Find_Data:1377, Find_Data_Reset:1511 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| InitSpreadDateColumn | InitSpread:415 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:266 |
| this | Load | Form_Load | .ctor:151 |
| btnCopy | Click | BtnCopy_Click | InitEvent:201 |
| btnSearch | Click | BtnSearch_Click | InitEvent:202 |
| this.btnItemId | Click | BtnItemId_Click | InitEvent:203 |
| spdMain.ActiveSheet | CellChanged | ActiveSheet_CellChanged | InitEvent:204 |
| spdMain | ActiveSheetChanged | SpdMain_ActiveSheetChanged | InitEvent:206 |
| this | Load | Form_Load | .ctor:286 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:755 |
| cboSearchType | SelectedIndexChanged | CboSearchType_SelectedIndexChanged | InitEvent:756 |
| cboGraphType | SelectedIndexChanged | CboGraphType_SelectedIndexChanged | InitEvent:757 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:758 |
| cboBucketType | SelectedIndexChanged | CboBucketType_SelectedIndexChanged | InitEvent:759 |
| cboUnitAmount | SelectedIndexChanged | CboUnitAmount_SelectedIndexChanged | InitEvent:760 |
| cboUnitQty | SelectedIndexChanged | CboUnitQty_SelectedIndexChanged | InitEvent:761 |
| cboDisplay | SelectedIndexChanged | CboDisplay_SelectedIndexChanged | InitEvent:762 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:763 |
| this.spdMain | TabIndexChanged | SpdMain_TabIndexChanged | InitEvent:764 |
| this.btnItemId | Click | BtnItemId_Click | InitEvent:766 |
| this.btnMeasure | Click | btnMeasure_Click | InitEvent:767 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1086 |

## 6. 컨트롤 (73개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 28 | layButton, layoutDiv, layMonth, layCell, lblYYYYMM, lblPlanStartYYYYMMDD, laySearch, layReason, layoutbtnitem, layCopy, layPrice, layModel, layoutPlanDate, Division, layPeriod … |
| UsrCombo | 10 | cboDivision, cboDioReason, cboDivision, cboPlanDate, cboBucketType, cboSearchType, cboGraphType, cboUnitAmount, cboUnitQty, cboDisplay |
| UsrTextBox | 7 | txtItemId, txtYYYYMM, txtCellGroup, txtPlanStartYYYYMMDD, txtPrice, txtItemId, txtCellGroup |
| UsrButton | 6 | btnCopy, btnItemId, btnSearch, usrButton1, btnItemId, btnMeasure |
| UsrLayoutControl | 3 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl2 |
| LayoutControlGroup | 3 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup2 |
| UsrCheckBox | 3 | chkCategoryCC, chkCategoryCell, chkCategoryPack |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet |
| EmptySpaceItem | 2 | emptySpaceItem2, emptySpaceItem3 |
| UsrButtonList | 1 | btnButtonList |
| UsrMonthPicker | 1 | monthPicker |
| UsrDateRangePicker3 | 1 | dCalendar |
| SplitContainer | 1 | splitContainer1 |
| ChartControl | 1 | chartMain |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 43 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 22 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 34 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 22 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0093 | MAIN | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | SCP0093 | POPUP | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |
| SCM_MST_SHEET_MEASURE | SCP0093 | MAIN | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_MEASURE | SCP0093 | POP_DIO_REASON | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: POPUP, PRICE, MAIN
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetSpreadInit:255, SetSheetHeaderColumn@InitSpread:414
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn, SetMeasureData

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 796 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 797 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 798 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 799 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpreadDateColumn |  | 494 | DB루프 | AddNumColumn | {?string.Empty} \|\| {?ScpUtils.GetValue(dr[DefColumns.COLUMN_LABEL_NAME])} | {?string.Empty} \|\| {?ScpUtils.GetValue(dr[DefColumns.COLUMN_NAME])} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 498 | 식 | AddTextColumn | {?string.Empty} \|\| {?GetColumnNameReason(sColumnName)} | {?string.Empty} \|\| {?GetColumnNameReason(sColumnName)} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 520 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?headerColor} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 521 | 표시/라벨 변경 | set:Font | Font = {?fontCellBold} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| SetHeaderColor |  | 596 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?DefGridColor.REASON} |  | if(useReason.Equals("Y")) |
| SetPastColumnColor |  | 610 | 표시/라벨 변경 | set:BackColor | BackColor = {?DefGridColor.CELL_PAST} |  | if(ColName.IndexOf("M_") == 0) ⟫ if(!string.IsNullOrWhiteSpace(PLAN_DATE_YYYYMM) && ScpUtils.CheckDiffMonth(ColName, PLAN_DATE_YYYYMM) < 0) |
| InitSpreadAddColumn |  | 656 | 하드코딩 | AddNumColumn | CELL 환산계수 | CELL_CF |  |
| InitSpreadAddColumn |  | 657 | 하드코딩 | AddTextColumn | 팀 | DEPT_NAME_KO |  |
| InitSpreadAddColumn |  | 658 | 하드코딩 | AddTextColumn | 프로젝트 | PROJECT_NAME |  |
| InitSpreadAddColumn |  | 659 | 하드코딩 | AddNumColumn | 단가 | UNIT_PRICE_LAST |  |
| InitSpreadAddColumn |  | 660 | 하드코딩 | AddNumColumn | 주기재고 | PRODUCTION_CYCLE |  |
| InitSpreadAddColumn |  | 661 | 하드코딩 | AddNumColumn | 안전재고 | SAFETY_STOCK |  |
| InitSpreadAddColumn |  | 662 | 하드코딩 | AddNumColumn | 전진검사 | PRE_INSPECTION |  |
| InitSpreadAddColumn |  | 663 | 하드코딩 | AddTextColumn | 담당자 | PIC_NAME |  |
| InitSpreadAddColumn |  | 664 | 하드코딩 | AddNumColumn | 전진검사 | YIELD |  |
| InitSpreadAddColumn |  | 665 | 하드코딩 | AddTextColumn | Target Cell | TARGET_CELL |  |
| InitSpreadAddColumn |  | 670 | 하드코딩 | AddTextColumn | AGGR_DV | AGGR_DV |  |
| InitSpreadAddColumn |  | 671 | 하드코딩 | AddTextColumn | CELL_CONVERT_YN | CELL_CONVERT_YN |  |
| InitSpreadAddColumn |  | 672 | 하드코딩 | AddTextColumn | OPERATION_GROUP | OPERATION_GROUP |  |
| InitSpreadAddColumn |  | 673 | 하드코딩 | AddTextColumn | CATEGORY_DV | CATEGORY_DV |  |
| SetVisibleTargetCell |  | 689 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefMainColumns.TARGET_CELL)} | TARGET_CELL |  |
| SetSpreadColumn |  | 712 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siMain.ActiveSheet.Columns.Count) ⟫ if(ColName.IndexOf("D_") == 0 \|\| ColName.IndexOf("W_") == 0 \|\| ColName.IndexOf("Y_") == 0 \|\| ColName.IndexOf("Q_") == 0) |
| SetSpreadColumn |  | 716 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siMain.ActiveSheet.Columns.Count) ⟫ else!(ColName.IndexOf("D_") == 0 \|\| ColName.IndexOf("W_") == 0 \|\| ColName.IndexOf("Y_") == 0 \|\| ColName.IndexOf("Q_") == 0) ⟫ if(ColName.IndexOf("M_") == 0) |
| SetSpreadColumn |  | 727 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siMain.ActiveSheet.Columns.Count) ⟫ else!(ColName.IndexOf("D_") == 0 \|\| ColName.IndexOf("W_") == 0 \|\| ColName.IndexOf("Y_") == 0 \|\| ColName.IndexOf("Q_") == 0) ⟫ else!(ColName.IndexOf("M_") == 0) ⟫ if(ColName.IndexOf("D_") == 0) |
| Find_Data |  | 1488 | 표시/라벨 변경 | set:MergePolicy | MergePolicy = {?FarPoint.Win.Spread.Model.MergePolicy.Always} |  | if(ScpUtils.CheckDataEmpty(ds) == false) ⟫ if(ds.Tables[0].Rows.Count > 0) |
| Find_Data_Reset |  | 1530 | 표시/라벨 변경 | set:MergePolicy | MergePolicy = {?FarPoint.Win.Spread.Model.MergePolicy.Always} |  | if(dsOrigianlCopy != null && dsOrigianlCopy.Tables[0].Rows.Count > 0) |
| SetVisibleColumnCycle |  | 2000 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(day)} | {?string.Empty} \|\| D0 \|\| D1 | for(i < siMain.ActiveSheet.ColumnCount) |
| SetColumnSearchType |  | 2050 | 표시/라벨 변경 | set:Visible | Visible = {?isVisible} |  |  |
| SetColumnSearchType |  | 2051 | 표시/라벨 변경 | set:Visible | Visible = {?isVisible} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| MAIN | META+코드연결 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |
| POPUP | META+코드연결 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
