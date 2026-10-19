# SSP0030 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0030_Logistics_Simulation.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1715 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0030_Logistics_Simulation.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 2766 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btn_Noinfo.Click | btn_Noinfo_Click > FindData_Detail | 503 | SSP.SSP0030_GET_LOGISTICS_SIMULATION_DETAIL | MATCH | SP SSP0030_GET_LOGISTICS_SIMULATION_DETAIL |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl > RefreshPlanDate | 1269 | biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl > RefreshPlanType | 1274 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl > RefreshPlanSeq | 1282 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 1340 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 1676 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 1692 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 407 | SSP.SSP0030_GET_LOGISTICS_SIMULATION | MATCH | SP SSP0030_GET_LOGISTICS_SIMULATION |
| event:this.formDown.Click | formDown_Click_1 > FindData_Excel | 664 | SSP.SSP0030_GET_LOGISTICS_SIMULATION_EXCEL | MATCH | SP SSP0030_GET_LOGISTICS_SIMULATION_EXCEL |
| event:this.Load | Form_Load > InitControls | 248 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > RefreshPlanDate | 1269 | biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > RefreshPlanType | 1274 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > RefreshPlanSeq | 1282 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1340 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail | 503 | SSP.SSP0030_GET_LOGISTICS_SIMULATION_DETAIL | MATCH | SP SSP0030_GET_LOGISTICS_SIMULATION_DETAIL |
| unreached:(진입점 미연결) | GetLastRange | 1326 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:REF:FN_CHAR_TO_DATE, UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V, UP_FX_GetCommonDataList:SELECT:SCM_SYS_CALENDAR_M, UP_FX_GetCommonDataList:SELECT:SCP_PLN_INTERFACE_YN, UP_FX_GetCommonDataList:REF:FN_SPLITSTRING |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD | EXEC:SCM0001_GET_SCP_DAILY_PLAN_PERIOD, SELECT:SCM_MST_DIVISION |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SSP.SSP0030_GET_LOGISTICS_SIMULATION | MATCH | 1 | SP SSP0030_GET_LOGISTICS_SIMULATION | EXEC:SSP0030_GET_LOGISTICS_SIMULATION, INSERT:#TMP_LOGISTICS_SIMULATION_MAIN, REF:FN_GET_SSP_ETA_DATE, SELECT:SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCP_ANL_BOD_N_V_PLAN_H, SELECT:SCP_MST_DISTRIBUTION_ROUTE, SELECT:SCM_MST_SITE, SELECT:SCP_MST_SHIPMENT_LOT_SIZE, SELECT:SCM_MST_PORT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, SELECT:SCP_ANL_SHIPMENT_PLAN_SEMI, DYNAMIC@SSP0030_GET_LOGISTICS_SIMULATION, SELECT:SCP_MST_BOD_N_V, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0030_GET_LOGISTICS_SIMULATION_DETAIL | MATCH | 1 | SP SSP0030_GET_LOGISTICS_SIMULATION_DETAIL | EXEC:SSP0030_GET_LOGISTICS_SIMULATION_DETAIL, INSERT:#TMP_LOGISTICS_SIMULATION_DETAIL, REF:FN_GET_SSP_ETA_DATE, SELECT:SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCP_ANL_BOD_N_V_PLAN_H, SELECT:SCP_MST_DISTRIBUTION_ROUTE, SELECT:SCM_MST_SITE, SELECT:SCP_MST_SHIPMENT_LOT_SIZE, SELECT:SCM_MST_PORT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, SELECT:SCP_ANL_SHIPMENT_PLAN_SEMI, DYNAMIC@SSP0030_GET_LOGISTICS_SIMULATION_DETAIL, SELECT:SCP_MST_BOD_N_V, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0030_GET_LOGISTICS_SIMULATION_EXCEL | MATCH | 1 | SP SSP0030_GET_LOGISTICS_SIMULATION_EXCEL | EXEC:SSP0030_GET_LOGISTICS_SIMULATION_EXCEL, INSERT:#TMP_LOGISTICS_SIMULATION_EXCEL, REF:FN_GET_SSP_ETA_DATE, SELECT:SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCP_ANL_BOD_N_V_PLAN_H, SELECT:SCP_MST_DISTRIBUTION_ROUTE, SELECT:SCM_MST_SITE, SELECT:SCP_MST_SHIPMENT_LOT_SIZE, SELECT:SCM_MST_PORT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, SELECT:SCP_ANL_SHIPMENT_PLAN_SEMI, DYNAMIC@SSP0030_GET_LOGISTICS_SIMULATION_EXCEL, SELECT:SCP_MST_BOD_N_V, SELECT:SCM_SYS_CALENDAR_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtDivision> | UserInfoContext.Current | NowGroupID |
| DataDivision | OriginData.Tables[0].Rows[row] | POD_AREA_V |
| DataDivision | OriginData.Tables[0].Rows[OriginDT] | DIVISION_ID, COMPANY, TYPE, TRANSPORT_MODE, POD_AREA_V |
| InitControls | dataRow | CODE, NAME, SORT_ORDER |
| InitControls | dr | CODE, NAME |
| InitControls | c | DIVISION_ID |
| Make_Division_ComboBox | row | CODE, NAME |
| Search_DataCopyTable | dt.Rows[i] | DIVISION_ID, COMPANY, TYPE, POD_AREA_V |
| Set_FixButtonEnabled | a | CODE |
| Set_MainDataTable | dr | DIVISION_ID, COMPANY, TYPE, POD_AREA, TRANSPORT_MODE, KUBUN, SUM |
| SetChangedControl | c | DIVISION_ID |
| UpdateData | dt.Rows[row] | CONTAINER_QTY, CONTAINER_COST, SEMI_EX_COST, FG_EX_COST |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | _division:165, _operationGroup:172, _planDate:179, _planType:186, InitControls:244, SetChangedControl:270, SetChangedControl:297, FindData_Main:380 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:330 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SetRowVisible | Select_KUBUN:803, Select_KUBUN:821, Select_KUBUN:822, Select_KUBUN:827, Select_KUBUN:828, Select_KUBUN:838, Select_KUBUN:840 | MeasureService.SetRowVisible | CATEGORY_ID, DATA_TYPE, _MM_ |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.formDown | Click | formDown_Click_1 | InitializeComponent:293 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1168 |
| this | Load | Form_Load | .ctor:122 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:1577 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:1578 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:1579 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:1580 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:1581 |
| cboDivisionK | SelectedIndexChanged | cboDivisionK_SelectedIndexChanged | InitEvent:1582 |
| btn_Noinfo | Click | btn_Noinfo_Click | InitEvent:1583 |
| txt_exchangerate | KeyPress | txt_exchangerate_KeyPress | InitEvent:1584 |

## 6. 컨트롤 (94개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 24 | layoutControlItem23, layoutControlItem7, layoutControlItem8, layoutControlItem3, layoutControlItem9, layoutControlItem4, layoutControlItem1, layoutControlItem27, layoutControlItem10, layoutControlItem2, layoutControlItem5, layoutControlItem16, layoutControlItem6, layoutControlItem18, layoutControlItem15 … |
| UsrButton | 19 | usrButton1, formDown, btnWLast, btnW52, btnW26, btnColumn, btnUnfix, btnFix, btnNew, btnMeasure, btnItem_Id, btnProject, usrButton2, usrButton3, usrButton4 … |
| EmptySpaceItem | 10 | emptySpaceItem6, emptySpaceItem7, emptySpaceItem4, emptySpaceItem3, emptySpaceItem2, emptySpaceItem1, emptySpaceItem9, emptySpaceItem10, emptySpaceItem8, emptySpaceItem5 |
| UsrCombo | 8 | clbCompany_ID, cboPlanSeq, cboPlanType, cboBizType, cboPlanDate, cboDivision, cboBucketType, usrCombo1 |
| UsrCheckedList | 5 | clbTransportMode, cboDivisionK, clbIncomterms, clbElecType, usrCheckedList1 |
| UsrMultiLineEditor | 4 | txtProject, txtItem_Id, usrMultiLineEditor1, usrMultiLineEditor2 |
| UsrCheckBox | 4 | chkAll, usrCheckBox1, chkSum, usrCheckBox2 |
| FpSpread | 3 | spdMain, spdDetail, spdSub |
| SheetView | 3 | spdMain_Sheet1, spdDetail_Sheet1, spdSub_Sheet1 |
| UsrLayoutControl | 2 | usrLayoutControl2, usrLayoutControl3 |
| LayoutControlGroup | 2 | layoutControlGroup2, layoutControlGroup3 |
| UsrCheckedList2 | 2 | clbTeam, usrCheckedList21 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| TextBox | 1 | txt_exchangerate |
| UsrComboBox | 1 | cbo_Kubun |
| UsrDateRangePicker3 | 1 | dCalendar |
| SplitContainer | 1 | splitContainer1 |
| SimpleButton | 1 | btn_Noinfo |
| ImageList | 1 | imageList1 |
| UsrDateRangePicker | 1 | usrDateRangePicker1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 13 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 57 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0030 | Logistics Simulation Detail | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |
| SCM_MST_SHEET_COLUMNS | SSP0030 | Logistics Simulation Excel | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 |
| SCM_MST_SHEET_COLUMNS | SSP0030 | Logistics Simulation Main | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Logistics Simulation Main, Logistics Simulation Detail, Logistics Simulation Excel
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:330

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| CreateMonthlyGrid |  | 1234 | 식 | AddColumns | 8 | 0 | if(G_TempYear.Count > 0) ⟫ for(i < G_TempYear.Count) |
| CreateMonthlyGrid |  | 1241 | 표시/라벨 변경 | SetColumnHeader | 1 |  | if(G_TempYear.Count > 0) ⟫ for(i < G_TempYear.Count) ⟫ for(k < sep2.Length) ⟫ if("0"== 0) |
| CreateMonthlyGrid |  | 1242 | 표시/라벨 변경 | SetColumnHeader | 1 |  | if(G_TempYear.Count > 0) ⟫ for(i < G_TempYear.Count) ⟫ for(k < sep2.Length) ⟫ else!("0"== 0) |
| ExportExcel |  | 1467 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| ExportExcel |  | 1509 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| InitializeComponent |  | 1184 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1185 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1186 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1187 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2287 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2288 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2289 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2290 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2439 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2440 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2441 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2442 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Logistics Simulation Detail | META+코드연결 | 24 (?1) | 24 (?1) | 24 (?1) | 24 (?1) | 24 (?1) | 24 (?1) | 24 (?1) | 24 (?1) | 24 (?1) | 24 (?1) | 24 (?1) | 24 (?1) | 24 (?1) | 24 (?1) |
| Logistics Simulation Excel | META+코드연결 | 27 (?1) | 27 (?1) | 27 (?1) | 27 (?1) | 27 (?1) | 27 (?1) | 27 (?1) | 27 (?1) | 27 (?1) | 27 (?1) | 27 (?1) | 27 (?1) | 27 (?1) | 27 (?1) |
| Logistics Simulation Main | META+코드연결 | 8 (?1) | 8 (?1) | 8 (?1) | 8 (?1) | 8 (?1) | 8 (?1) | 8 (?1) | 8 (?1) | 8 (?1) | 8 (?1) | 8 (?1) | 8 (?1) | 8 (?1) | 8 (?1) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 정적평가 미지원식 42 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 42건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
