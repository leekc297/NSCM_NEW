# SCP0102 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0102_BOD_Validation_Report\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0102_BOD_Validation_Report\SCP0102_BOD_Validation_Report.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0102_BOD_Validation_Report\SCP0102_BOD_Validation_Report.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0102_BOD_Validation_Report\SCP0102_BOD_Validation_Report.csproj | 1853 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0102_BOD_Validation_Report\SCP0102_BOD_Validation_Report.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0102_BOD_Validation_Report\SCP0102_BOD_Validation_Report.csproj | 1657 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboFromCountry.SelectedIndexChanged | cboFromCountry_SelectedIndexChanged > Set_City_ComboBox | 188 | SSP.SSP0028_GET_CITY | MATCH | SP SSP0028_GET_CITY |
| event:cboToCountry.SelectedIndexChanged | cboToCountry_SelectedIndexChanged > Set_City_ComboBox | 188 | SSP.SSP0028_GET_CITY | MATCH | SP SSP0028_GET_CITY |
| event:clbDivision_ID.SelectedIndexChanged | clbDivision_ID_SelectedIndexChanged > SetChangedControl > Set_Country_ComboBox | 169 | SSP.SSP0028_GET_COUNTRY | MATCH | [statement] foxquery_sql\SSP.SSP0028_GET_COUNTRY.sql |
| event:clbDivision_ID.SelectedIndexChanged | clbDivision_ID_SelectedIndexChanged > SetChangedControl > Set_City_ComboBox | 188 | SSP.SSP0028_GET_CITY | MATCH | SP SSP0028_GET_CITY |
| event:clbDivision_ID.SelectedIndexChanged | clbDivision_ID_SelectedIndexChanged > SetChangedControl > Make_Area_ComboBox | 473 | SSP.SSP0028_GET_AREA | MATCH | [statement] foxquery_sql\SSP.SSP0028_GET_AREA.sql |
| button:FindButton | FindButton > FindData_Main | 609 | SCP.SCP0102_GET_BOD_VALIDATION_REPORT | MATCH | SP SCP0102_GET_BOD_VALIDATION_REPORT |
| event:spdMain.CellDoubleClick | spdMain_CellDoubleClick | 1593 | SCP.SCP0102_GET_BOD_VALIDATION_REPORT_DETAIL | MATCH | SP SCP0102_GET_BOD_VALIDATION_REPORT_DETAIL |
| event:this.btn_Search.Click | btn_Search_Click | 1764 | SCP.SCP0102_GET_BOD_VALIDATION_REPORT_DETAIL | MATCH | SP SCP0102_GET_BOD_VALIDATION_REPORT_DETAIL |
| event:this.Load | Form_Load > InitControls > SetChangedControl > Set_Country_ComboBox | 169 | SSP.SSP0028_GET_COUNTRY | MATCH | [statement] foxquery_sql\SSP.SSP0028_GET_COUNTRY.sql |
| event:this.Load | Form_Load > InitControls > SetChangedControl > Set_City_ComboBox | 188 | SSP.SSP0028_GET_CITY | MATCH | SP SSP0028_GET_CITY |
| event:this.Load | Form_Load > InitControls > SetChangedControl > Make_Area_ComboBox | 473 | SSP.SSP0028_GET_AREA | MATCH | [statement] foxquery_sql\SSP.SSP0028_GET_AREA.sql |
| event:this.Load | Form_Load > InitControls > GetDayRange | 559 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0102_GET_BOD_VALIDATION_REPORT | MATCH | 1 | SP SCP0102_GET_BOD_VALIDATION_REPORT | EXEC:SCP0102_GET_BOD_VALIDATION_REPORT, REF:FN_GET_IN_STR, INSERT:#TMP_CONFIRM, SELECT:SCM_DNM_EXFACTORY_RESULT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_ANL_SHIP_CONFIRM_ROUTE, DYNAMIC@SCP0102_GET_BOD_VALIDATION_REPORT, REF:FN_SCM_SPLIT |  |
| SCP.SCP0102_GET_BOD_VALIDATION_REPORT_DETAIL | MATCH | 2 | SP SCP0102_GET_BOD_VALIDATION_REPORT_DETAIL | EXEC:SCP0102_GET_BOD_VALIDATION_REPORT_DETAIL, REF:FN_GET_IN_STR, DYNAMIC@SCP0102_GET_BOD_VALIDATION_REPORT_DETAIL, REF:FN_SCM_SPLIT |  |
| SSP.SSP0028_GET_AREA | MATCH | 1 | [statement] foxquery_sql\SSP.SSP0028_GET_AREA.sql | EXEC:SSP0028_GET_AREA, SELECT:SCM_MST_PORT |  |
| SSP.SSP0028_GET_CITY | MATCH | 1 | SP SSP0028_GET_CITY | EXEC:SSP0028_GET_CITY, REF:FN_GET_IN_STR, DYNAMIC@SSP0028_GET_CITY, REF:FN_SCM_SPLIT |  |
| SSP.SSP0028_GET_COUNTRY | MATCH | 1 | [statement] foxquery_sql\SSP.SSP0028_GET_COUNTRY.sql | EXEC:SSP0028_GET_COUNTRY, SELECT:SCP_MST_DISTRIBUTION_ROUTE, SELECT:SCM_MST_COUNTRY |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:G_dtMyDivision> | UserInfoContext.Current | NowGroupID |
| GetCI80 | row | CI_TTL |
| GetCI80_OLD | row | CI_TTL_UP, CI_TTL_DOWN |
| Individual_Accuracy_Values | ds.Tables[0].Rows[j] | BOD_ID |
| InitControls | c | CODE |
| Make_Accuracy_ComboBox | row | CODE, NAME |
| Make_Area_ComboBox | row | NAME, CODE |
| Make_InquiryClassification_ComboBox | row | CODE, NAME |
| PastPlanAverage_Maximum_Minimum_SUM | ds.Tables[0].Rows[j] | BOD_ID |
| SameDataMerge | ds.Tables[0].Columns | TTL_MIN |
| SameDataMerge | ds.Tables[1].Rows[i] | BOD_ID |
| SameDataMerge | ds.Tables[0].Rows[j] | BOD_ID, YYYYYMM |
| Set_CommonInformation | ds.Tables[0].Rows[j] | DIVISIONID, FROM_SITE, TO_SITE, POL_AREA, POD_AREA, D_PORT_CODE, A_PORT_CODE, FROM_CITY, TO_CITY, TRANSPORT_MODE, BOD_ID, ROUTE_ID, SSP_INCOTERMS, NDR12, NDR3, NDR45 |
| Set_CommonInformation | ds.Tables[1].Rows[i] | SHIPMENTCOUNT, CONTAINER_COUNT |
| SET_MONTH | ds.Tables[0].Rows[r] | YYYYYMM |
| SetChangedControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:217, FindData_Main:588, FindData_Main:589, FindData_Main:590, FindData_Main:593, FindData_Main:594, FindData_Main:595, FindData_Main:596 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:264 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SetRowVisible | TTLROWHIDE:397, AccuracyRange_OK:1496, AccuracyRange_OK:1503, AccuracyRange_NO:1517, AccuracyRange_NoNumber:1532, AccuracyRange_SelectALL:1555, AccuracyRange_SelectALL:1562, spdMain_CellDoubleClick:1641 | MeasureService.SetRowVisible | CATEGORY_ID, DATA_TYPE, _MM_ |
| SetManualCondition | OpenDistributionRoute:524, spdMain_CellDoubleClick:1685 | BaseForm.SetManualCondition | ControlName, ControlValue |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:114 |
| clbDivision_ID | SelectedIndexChanged | clbDivision_ID_SelectedIndexChanged | InitEvent:493 |
| cboFromCountry | SelectedIndexChanged | cboFromCountry_SelectedIndexChanged | InitEvent:494 |
| cboToCountry | SelectedIndexChanged | cboToCountry_SelectedIndexChanged | InitEvent:495 |
| cboInquiryClassification | SelectedIndexChanged | cboInquiryClassification_SelectedIndexChanged | InitEvent:496 |
| spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitEvent:497 |
| cboAccuracy | SelectedIndexChanged | cboAccuracy_SelectedIndexChanged | InitEvent:498 |
| spdDetail | CellDoubleClick | SpdDetail_CellDoubleClick | InitEvent:500 |
| this.btn_Search | Click | btn_Search_Click | InitializeComponent:1068 |

## 6. 컨트롤 (65개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 27 | lblCombo1, layoutControlItem23, layoutControlItem5, layoutControlItem9, layoutControlItem7, layoutControlItem2, layoutControlItem1, lblCombo2, lblCombo3, layoutControlItem6, layoutControlItem10, layoutControlItem3, layoutControlItem21, lblCombo4, layoutControlItem4 … |
| UsrCheckedList | 7 | clbFromSite, clbToSite, cboFromCity, cboFromCountry, cboToCountry, cboInquiryClassification, cboToCity |
| EmptySpaceItem | 5 | emptySpaceItem3, emptySpaceItem4, emptySpaceItem7, emptySpaceItem1, emptySpaceItem5 |
| UsrCombo | 4 | clbDivision_ID, cboFromArea, cboToArea, cboAccuracy |
| UsrDateRangePicker | 4 | drpPeriod, drpExfactory, drpFDest, usrDateRangePicker1 |
| SimpleButton | 3 | btn_Search, btnApproval, simpleButton1 |
| UsrRadio | 3 | rdoExFactory, rdoFDest, usrRadio1 |
| UsrLayoutControl | 2 | usrLayoutControl2, usrLayoutControl3 |
| LayoutControlGroup | 2 | layoutControlGroup2, layoutControlGroup3 |
| FpSpread | 2 | spdMain, spdDetail |
| SheetView | 2 | spdMain_Sheet1, spdDetail_Sheet1 |
| UsrButton | 1 | usrButton1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| SplitContainer | 1 | splitContainer1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 47 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 101 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 2 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 11 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0102 | BOD Detail | 65/0 | 65/0 | 65/0 | 65/0 | 65/0 | 65/0 | 65/0 | 65/0 | 65/0 | 65/0 | 65/0 | 65/0 | 65/0 | 65/0 |
| SCM_MST_SHEET_COLUMNS | SCP0102 | BOD Main | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: BOD Main, BOD Detail
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:264

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| CreateMonthlyGrid |  | 295 | 식 | AddColumns | 0 \|\| {?spdMain.Sheets[0].ColumnCount} | 7 | for(i < G_GRID_MONTH_HEADER.Count) |
| CreateMonthlyGrid |  | 303 | 표시/라벨 변경 | SetColumnHeader | 2 |  | for(i < G_GRID_MONTH_HEADER.Count) |
| CreateMonthlyGrid |  | 304 | 표시/라벨 변경 | SetColumnHeader | 2 |  | for(i < G_GRID_MONTH_HEADER.Count) |
| CreateMonthlyGrid |  | 305 | 표시/라벨 변경 | SetColumnHeader | 2 |  | for(i < G_GRID_MONTH_HEADER.Count) |
| CreateMonthlyGrid |  | 306 | 표시/라벨 변경 | SetColumnHeader | 2 |  | for(i < G_GRID_MONTH_HEADER.Count) |
| Set_Accuracy_Row |  | 1425 | 표시/라벨 변경 | SetColumnLabel | 0 |  | if(cboAccuracy.ControlValues != "ALL") |
| AccuracyRange_SelectALL |  | 1545 | 표시/라벨 변경 | SetColumnLabel | 0 |  |  |
| KuBunHeaderClick_ALL_Close |  | 1708 | 표시/라벨 변경 | SetColumnLabel | 0 |  | for(i < this.spdMain.Sheets[0].RowCount) ⟫ if(sep2.Length == 2) |
| KuBunHeaderClick_ALL_Show |  | 1732 | 표시/라벨 변경 | SetColumnLabel | 0 |  | for(i < this.spdMain.Sheets[0].RowCount) ⟫ if(sep2.Length == 2) |
| InitializeComponent |  | 935 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 936 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 937 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 938 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1010 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1011 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1012 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1013 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| BOD Detail | META+코드연결 | 66 | 66 | 66 | 66 | 66 | 66 | 66 | 66 | 66 | 66 | 66 | 66 | 66 | 66 |
| BOD Main | META+코드연결 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
