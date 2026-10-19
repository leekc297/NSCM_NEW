# SSP0028 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0028_Delivery_Tracking_LT.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1398 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0028_Delivery_Tracking_LT.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1654 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboFromCountry.SelectedIndexChanged | cboFromCountry_SelectedIndexChanged > Set_City_ComboBox | 161 | SSP.SSP0028_GET_CITY | MATCH | SP SSP0028_GET_CITY |
| event:cboToCountry.SelectedIndexChanged | cboToCountry_SelectedIndexChanged > Set_City_ComboBox | 161 | SSP.SSP0028_GET_CITY | MATCH | SP SSP0028_GET_CITY |
| event:clbDivision_ID.SelectedIndexChanged | clbDivision_ID_SelectedIndexChanged > SetChangedControl > Set_Country_ComboBox | 142 | SSP.SSP0028_GET_COUNTRY | MATCH | [statement] foxquery_sql\SSP.SSP0028_GET_COUNTRY.sql |
| event:clbDivision_ID.SelectedIndexChanged | clbDivision_ID_SelectedIndexChanged > SetChangedControl > Set_City_ComboBox | 161 | SSP.SSP0028_GET_CITY | MATCH | SP SSP0028_GET_CITY |
| event:clbDivision_ID.SelectedIndexChanged | clbDivision_ID_SelectedIndexChanged > SetChangedControl > Make_Area_ComboBox | 424 | SSP.SSP0028_GET_AREA | MATCH | [statement] foxquery_sql\SSP.SSP0028_GET_AREA.sql |
| button:FindButton | FindButton > FindData_Main | 519 | SSP.SSP0028_GET_DELIVERY_TRACKING_LT | MATCH | SP SSP0028_GET_DELIVERY_TRACKING_LT |
| event:spdMain.CellDoubleClick | spdMain_CellDoubleClick | 1174 | SSP.SSP0028_GET_DELIVERY_TRACKING_LT_DETAIL | MATCH | SP SSP0028_GET_DELIVERY_TRACKING_LT_DETAIL |
| event:this.btn_Search.Click | btn_Search_Click | 1319 | SSP.SSP0028_GET_DELIVERY_TRACKING_LT_DETAIL | MATCH | SP SSP0028_GET_DELIVERY_TRACKING_LT_DETAIL |
| event:this.Load | Form_Load > InitControls > SetChangedControl > Set_Country_ComboBox | 142 | SSP.SSP0028_GET_COUNTRY | MATCH | [statement] foxquery_sql\SSP.SSP0028_GET_COUNTRY.sql |
| event:this.Load | Form_Load > InitControls > SetChangedControl > Set_City_ComboBox | 161 | SSP.SSP0028_GET_CITY | MATCH | SP SSP0028_GET_CITY |
| event:this.Load | Form_Load > InitControls > SetChangedControl > Make_Area_ComboBox | 424 | SSP.SSP0028_GET_AREA | MATCH | [statement] foxquery_sql\SSP.SSP0028_GET_AREA.sql |
| event:this.Load | Form_Load > InitControls > GetDayRange | 469 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SSP.SSP0028_GET_AREA | MATCH | 1 | [statement] foxquery_sql\SSP.SSP0028_GET_AREA.sql | EXEC:SSP0028_GET_AREA, SELECT:SCM_MST_PORT |  |
| SSP.SSP0028_GET_CITY | MATCH | 1 | SP SSP0028_GET_CITY | EXEC:SSP0028_GET_CITY, REF:FN_GET_IN_STR, DYNAMIC@SSP0028_GET_CITY, REF:FN_SCM_SPLIT |  |
| SSP.SSP0028_GET_COUNTRY | MATCH | 1 | [statement] foxquery_sql\SSP.SSP0028_GET_COUNTRY.sql | EXEC:SSP0028_GET_COUNTRY, SELECT:SCP_MST_DISTRIBUTION_ROUTE, SELECT:SCM_MST_COUNTRY |  |
| SSP.SSP0028_GET_DELIVERY_TRACKING_LT | MATCH | 1 | SP SSP0028_GET_DELIVERY_TRACKING_LT | EXEC:SSP0028_GET_DELIVERY_TRACKING_LT, REF:FN_GET_IN_STR, DYNAMIC@SSP0028_GET_DELIVERY_TRACKING_LT, REF:FN_SCM_SPLIT |  |
| SSP.SSP0028_GET_DELIVERY_TRACKING_LT_DETAIL | MATCH | 2 | SP SSP0028_GET_DELIVERY_TRACKING_LT_DETAIL | EXEC:SSP0028_GET_DELIVERY_TRACKING_LT_DETAIL, REF:FN_GET_IN_STR, DYNAMIC@SSP0028_GET_DELIVERY_TRACKING_LT_DETAIL, REF:FN_SCM_SPLIT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:G_dtMyDivision> | UserInfoContext.Current | NowGroupID |
| InitControls | c | CODE |
| Make_Accuracy_ComboBox | row | CODE, NAME |
| Make_Area_ComboBox | row | NAME, CODE |
| Make_InquiryClassification_ComboBox | row | CODE, NAME |
| SameDataMerge | ds.Tables[1].Rows[i] | BOD_ID |
| SameDataMerge | ds.Tables[0].Rows[j] | BOD_ID, YYYYYMM |
| Set_CommonInformation | ds.Tables[0].Rows[j] | DIVISIONID, FROM_SITE, TO_SITE, POL_AREA, POD_AREA, D_PORT_CODE, A_PORT_CODE, FROM_CITY, TO_CITY, TRANSPORT_MODE, BOD_ID, ROUTE_ID, SSP_INCOTERMS, NDR1, NDR2, NDR3, NDR4, NDR5 |
| Set_CommonInformation | ds.Tables[1].Rows[i] | SHIPMENTCOUNT |
| SET_MONTH | ds.Tables[0].Rows[r] | YYYYYMM |
| SetChangedControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:190, FindData_Main:498, FindData_Main:499, FindData_Main:500, FindData_Main:503, FindData_Main:504, FindData_Main:505, FindData_Main:506 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:237 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SetRowVisible | TTLROWHIDE:348, AccuracyRange_OK:1079, AccuracyRange_OK:1086, AccuracyRange_NO:1100, AccuracyRange_NoNumber:1115, AccuracyRange_SelectALL:1138, AccuracyRange_SelectALL:1145, spdMain_CellDoubleClick:1222 | MeasureService.SetRowVisible | CATEGORY_ID, DATA_TYPE, _MM_ |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btn_Search | Click | btn_Search_Click | InitializeComponent:1067 |
| this | Load | Form_Load | .ctor:95 |
| clbDivision_ID | SelectedIndexChanged | clbDivision_ID_SelectedIndexChanged | InitEvent:444 |
| cboFromCountry | SelectedIndexChanged | cboFromCountry_SelectedIndexChanged | InitEvent:445 |
| cboToCountry | SelectedIndexChanged | cboToCountry_SelectedIndexChanged | InitEvent:446 |
| cboInquiryClassification | SelectedIndexChanged | cboInquiryClassification_SelectedIndexChanged | InitEvent:447 |
| spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitEvent:448 |
| cboAccuracy | SelectedIndexChanged | cboAccuracy_SelectedIndexChanged | InitEvent:449 |

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
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 19 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 66 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 2 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 10 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
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
| SCM_MST_SHEET_COLUMNS | SSP0028 | BOD Detail | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 |
| SCM_MST_SHEET_COLUMNS | SSP0028 | BOD Main | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: BOD Main, BOD Detail
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:237

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| CreateMonthlyGrid |  | 268 | 식 | AddColumns | 0 \|\| {?spdMain.Sheets[0].ColumnCount} | 6 | for(i < G_GRID_MONTH_HEADER.Count) |
| CreateMonthlyGrid |  | 276 | 표시/라벨 변경 | SetColumnHeader | 2 |  | for(i < G_GRID_MONTH_HEADER.Count) |
| CreateMonthlyGrid |  | 277 | 표시/라벨 변경 | SetColumnHeader | 2 |  | for(i < G_GRID_MONTH_HEADER.Count) |
| CreateMonthlyGrid |  | 278 | 표시/라벨 변경 | SetColumnHeader | 2 |  | for(i < G_GRID_MONTH_HEADER.Count) |
| Set_Accuracy_Row |  | 1008 | 표시/라벨 변경 | SetColumnLabel | 0 |  | if(cboAccuracy.ControlValues != "ALL") |
| AccuracyRange_SelectALL |  | 1128 | 표시/라벨 변경 | SetColumnLabel | 0 |  |  |
| KuBunHeaderClick_ALL_Close |  | 1263 | 표시/라벨 변경 | SetColumnLabel | 0 |  | for(i < this.spdMain.Sheets[0].RowCount) ⟫ if(sep2.Length == 2) |
| KuBunHeaderClick_ALL_Show |  | 1287 | 표시/라벨 변경 | SetColumnLabel | 0 |  | for(i < this.spdMain.Sheets[0].RowCount) ⟫ if(sep2.Length == 2) |
| InitializeComponent |  | 934 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 935 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 936 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 937 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1009 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1010 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1011 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1012 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| BOD Detail | META+코드연결 | 36 | 36 | 36 | 36 | 36 | 36 | 36 | 36 | 36 | 36 | 36 | 36 | 36 | 36 |
| BOD Main | META+코드연결 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
