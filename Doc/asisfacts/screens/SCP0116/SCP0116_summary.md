# SCP0116 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0116_Global_PSI_Report_New_ESS\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0116_Global_PSI_Report_New_ESS\SCP0116_Global_PSI_Report_New_ESS.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0116_Global_PSI_Report_New_ESS\SCP0116_Global_PSI_Report_New_ESS.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0116_Global_PSI_Report_New_ESS\SCP0116_Global_PSI_Report_New_ESS.csproj | 2006 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0116_Global_PSI_Report_New_ESS\SCP0116_Global_PSI_Report_New_ESS.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0116_Global_PSI_Report_New_ESS\SCP0116_Global_PSI_Report_New_ESS.csproj | 1636 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > InitSpread > GetSpdTitle | 1305 | SCP.SCP0116_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0116_GET_SHEET_CALENDAR_3SPAN |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > SetCalendar > GetDayRange > GetPlanEndDate | 1986 | biz:CommonData.CommonDataList_REPORT [code={?Data_REPORT.Type.PLAN_END_DATE}] | BIZ_MATCH |  |
| event:dCalendar.ValueChanged | DCalendar_ValueChanged > InitSpread > GetSpdTitle | 1305 | SCP.SCP0116_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0116_GET_SHEET_CALENDAR_3SPAN |
| event:rgrpSearchLevel.SelectedIndexChanged | rgrpSearchLevel_SelectedIndexChanged > InitSpread > GetSpdTitle | 1305 | SCP.SCP0116_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0116_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread > GetSpdTitle | 1305 | SCP.SCP0116_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0116_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 1305 | SCP.SCP0116_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0116_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1305 | SCP.SCP0116_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0116_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetPlanDate | 1344 | SCP.SCP0116_GET_PLAN_DATE | MATCH | SP SCP0116_GET_PLAN_DATE |
| event:this.Load | Form_Load > InitControls > SetCalendar > GetDayRange > GetPlanEndDate | 1986 | biz:CommonData.CommonDataList_REPORT [code={?Data_REPORT.Type.PLAN_END_DATE}] | BIZ_MATCH |  |
| event:this.Shown | SCP0116_Global_PSI_Report_New_ESS_Shown > InitControlsAfter > RefreshToSite > GetSiteList | 1321 | SCP.SCP0116_GET_SITE | MATCH | SP SCP0116_GET_SITE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList_REPORT [code={?Data_REPORT.Type.PLAN_END_DATE}] | BIZ_MATCH | 1 |  |  |  |
| SCP.SCP0116_GET_PLAN_DATE | MATCH | 1 | SP SCP0116_GET_PLAN_DATE | EXEC:SCP0116_GET_PLAN_DATE, INSERT:#TMP_PLAN, REF:FN_CHAR_TO_DATE, SELECT:SCP_PLAN_VERSION_V, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCP_PLN_INTERFACE_YN, REF:FN_SPLITSTRING, SELECT:#TMP_PLAN, SELECT:SCP_RPT_GLOBAL_PSI_MD_MM_ESS, SELECT:SCP_RPT_GLOBAL_PSI_MD_WW_ESS |  |
| SCP.SCP0116_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0116_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0116_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0116_GET_SITE | MATCH | 1 | SP SCP0116_GET_SITE | EXEC:SCP0116_GET_SITE, SELECT:SCP_RPT_GLOBAL_PSI_MD_MM_ESS, REF:FN_SPLITSTRING, SELECT:SCP_RPT_GLOBAL_PSI_MD_WW_ESS |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InitControls | dr | CODE, NAME |
| InitControls | dataRow | CODE, NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | getPlanStartYYYYMMDD:194, getFromSite:285, getToSite:304, getPlanType:323, getSearchLevel:391, getDivision:445 | CString.GetCheckedListValue | CODE |
| OnShown | OnShown:495 | BaseForm.OnShown | NowGroupID, USER_ID |
| GetSpdTitle | InitSpread:704 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:706 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:707 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:474 |
| this | Shown | SCP0116_Global_PSI_Report_New_ESS_Shown | .ctor:475 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:1113 |
| cboGraphType | SelectedIndexChanged | CboGraphType_SelectedIndexChanged | InitEvent:1114 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:1115 |
| cboBucketType | SelectedIndexChanged | CboBucketType_SelectedIndexChanged | InitEvent:1116 |
| cboDisplay | SelectedIndexChanged | CboDisplay_SelectedIndexChanged | InitEvent:1117 |
| cboSearchLevel | SelectedIndexChanged | CboSearchLevel_SelectedIndexChanged | InitEvent:1118 |
| cboUnitQty | SelectedIndexChanged | CboUnitQty_SelectedIndexChanged | InitEvent:1119 |
| rgrpSearchLevel | SelectedIndexChanged | rgrpSearchLevel_SelectedIndexChanged | InitEvent:1120 |
| this.btnItemId | Click | BtnItemId_Click | InitEvent:1122 |
| this.btnMeasure | Click | btnMeasure_Click | InitEvent:1123 |
| this.btnProject | Click | BtnProject_Click | InitEvent:1125 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:1126 |
| this.btnColumn | Click | BtnColumn_Click | InitEvent:1127 |
| dCalendar | ValueChanged | DCalendar_ValueChanged | InitEvent:1129 |
| chkCellQty | CheckedChanged | ChkCellQty_CheckedChanged | InitEvent:1130 |
| chkAS | CheckedChanged | ChkAS_CheckedChanged | InitEvent:1131 |

## 6. 컨트롤 (61개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 21 | Division, layModel, layoutbtnitem, layoutControlItem1, lblToSite, lblCellGroup1, lblCellGroup, layoutControlItem2, lblBucket, PlanType, layDisplay, layoutPlanDate, lblGraphType, layPeriod, layMeasure … |
| EmptySpaceItem | 9 | emptySpaceItem1, emptySpaceItem5, emptySpaceItem7, emptySpaceItem6, emptySpaceItem4, emptySpaceItem13, emptySpaceItem3, emptySpaceItem8, emptySpaceItem10 |
| UsrCombo | 8 | cboDivision, cboPlanDate, cboBucketType, cboGraphType, cboDisplay, cboPlanType, cboSearchLevel, cboUnitQty |
| UsrButton | 5 | usrButton1, btnItemId, btnMeasure, btnProject, btnColumn |
| UsrTextBox | 3 | txtItemId, txtProject, txtCellGroup |
| UsrCheckBox | 2 | chkCellQty, chkAS |
| UsrCheckedList2 | 2 | clbFromSite, clbToSite |
| FpSpread | 2 | spdSearchLevel, spdDetail |
| SheetView | 2 | spdMain_Sheet, spdSearchLevel_Sheet |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| RadioGroup | 1 | rgrpSearchLevel |
| UsrDateRangePicker3 | 1 | dCalendar |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SplitContainer | 1 | splitContainer1 |
| ChartControl | 1 | chartMain |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 67 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_TITLESET_USER | 164 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_GroupMenuAuth | 2 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 11 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: SEARCH_LEVEL_ESS, REPORT_ESS
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:706
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 756 | DB루프 | AddTextColumn | {?string.Empty} \|\| {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?string.Empty} \|\| {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 761 | DB루프 | AddNumColumn | {?string.Empty} \|\| {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?string.Empty} \|\| {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 768 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sColumnName.StartsWith("M_")) ⟫ if(sColumnName.Contains(_plan_start_yyyymm)) |
| InitSpreadDateColumn |  | 775 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Blue} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ else!(sColumnName.StartsWith("M_")) ⟫ if(sColumnName.StartsWith("W_")) ⟫ if(sColumnLabelname.Contains("A")) |
| InitSpreadDateColumn |  | 779 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Blue} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ else!(sColumnName.StartsWith("M_")) ⟫ if(sColumnName.StartsWith("W_")) ⟫ else!(sColumnLabelname.Contains("A")) ⟫ if(sColumnLabelname.Contains("B")) |
| SetSpreadColumn |  | 1089 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < _SI.ActiveSheet.Columns.Count) ⟫ if(_bucket_type.Equals("MONTHLY")) ⟫ if(ColName.IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1093 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < _SI.ActiveSheet.Columns.Count) ⟫ if(_bucket_type.Equals("MONTHLY")) ⟫ else!(ColName.IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1100 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < _SI.ActiveSheet.Columns.Count) ⟫ else!(_bucket_type.Equals("MONTHLY")) ⟫ if(_bucket_type.Equals("WEEKLY")) ⟫ if(ColName.IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1104 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < _SI.ActiveSheet.Columns.Count) ⟫ else!(_bucket_type.Equals("MONTHLY")) ⟫ if(_bucket_type.Equals("WEEKLY")) ⟫ else!(ColName.IndexOf("W_") == 0) |
| SetVisibleColumnCycle |  | 1269 | 표시/라벨 변경 | VisibleColumns | {?_SI.GetColumnIndex(day)} | {?string.Empty} \|\| D0 \|\| D1 | for(i < _SI.ActiveSheet.ColumnCount) |
| SetLayout |  | 1475 | 표시/라벨 변경 | VisibleColumns | {?_SI.GetColumnIndex("PRODUCT_LEVEL1")} | PRODUCT_LEVEL1 | if(!_is_detail) ⟫ switch(cboSearchLevel.SelectedIndex)case 1 |
| SetLayout |  | 1476 | 표시/라벨 변경 | VisibleColumns | {?_SI.GetColumnIndex("PRODUCT_LEVEL2")} | PRODUCT_LEVEL2 | if(!_is_detail) ⟫ switch(cboSearchLevel.SelectedIndex)case 1 |
| SetLayout |  | 1477 | 표시/라벨 변경 | VisibleColumns | {?_SI.GetColumnIndex("PRODUCT_LEVEL3")} | PRODUCT_LEVEL3 | if(!_is_detail) ⟫ switch(cboSearchLevel.SelectedIndex)case 1 |
| SetLayout |  | 1483 | 표시/라벨 변경 | VisibleColumns | {?_SI.GetColumnIndex("PRODUCT_LEVEL1")} | PRODUCT_LEVEL1 | if(!_is_detail) ⟫ switch(cboSearchLevel.SelectedIndex)case 2 |
| SetLayout |  | 1484 | 표시/라벨 변경 | VisibleColumns | {?_SI.GetColumnIndex("PRODUCT_LEVEL2")} | PRODUCT_LEVEL2 | if(!_is_detail) ⟫ switch(cboSearchLevel.SelectedIndex)case 2 |
| SetLayout |  | 1485 | 표시/라벨 변경 | VisibleColumns | {?_SI.GetColumnIndex("PRODUCT_LEVEL3")} | PRODUCT_LEVEL3 | if(!_is_detail) ⟫ switch(cboSearchLevel.SelectedIndex)case 2 |
| SetLayout |  | 1491 | 표시/라벨 변경 | VisibleColumns | {?_SI.GetColumnIndex("PRODUCT_LEVEL1")} | PRODUCT_LEVEL1 | if(!_is_detail) ⟫ switch(cboSearchLevel.SelectedIndex)case 3 |
| SetLayout |  | 1492 | 표시/라벨 변경 | VisibleColumns | {?_SI.GetColumnIndex("PRODUCT_LEVEL2")} | PRODUCT_LEVEL2 | if(!_is_detail) ⟫ switch(cboSearchLevel.SelectedIndex)case 3 |
| SetLayout |  | 1493 | 표시/라벨 변경 | VisibleColumns | {?_SI.GetColumnIndex("PRODUCT_LEVEL3")} | PRODUCT_LEVEL3 | if(!_is_detail) ⟫ switch(cboSearchLevel.SelectedIndex)case 3 |
| SetLayout |  | 1499 | 표시/라벨 변경 | VisibleColumns | {?_SI.GetColumnIndex("PRODUCT_LEVEL1")} | PRODUCT_LEVEL1 | if(!_is_detail) ⟫ switch(cboSearchLevel.SelectedIndex)case  |
| SetLayout |  | 1500 | 표시/라벨 변경 | VisibleColumns | {?_SI.GetColumnIndex("PRODUCT_LEVEL2")} | PRODUCT_LEVEL2 | if(!_is_detail) ⟫ switch(cboSearchLevel.SelectedIndex)case  |
| SetLayout |  | 1501 | 표시/라벨 변경 | VisibleColumns | {?_SI.GetColumnIndex("PRODUCT_LEVEL3")} | PRODUCT_LEVEL3 | if(!_is_detail) ⟫ switch(cboSearchLevel.SelectedIndex)case  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| REPORT_ESS | 코드 시트, 컬럼 미확인(DB루프/동적) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) |
| SEARCH_LEVEL_ESS | 코드 시트, 컬럼 미확인(DB루프/동적) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) | 0 (?3) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:화면컨트롤값 336 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 336건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
