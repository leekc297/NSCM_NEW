# SCP0081 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0081_ProductionPlanReport\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0081_ProductionPlanReport\SCP0081_ProductionPlanReport.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0081_ProductionPlanReport\SCP0081_ProductionPlanReport.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0081_ProductionPlanReport\SCP0081_ProductionPlanReport.csproj | 1058 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0081_ProductionPlanReport\SCP0081_ProductionPlanReport.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0081_ProductionPlanReport\SCP0081_ProductionPlanReport.csproj | 1194 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread > SetSpreadInit > GetSpdTitle | 756 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | BtnMeasure_Click > InitSpread > SetSpreadInit > GetSpdTitle | 756 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > RefreshBucket | 427 | biz:CommonData.CommonDataList [code=BucketType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > GetSpdTitle | 756 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | GetDayRange | 859 | SCP.SCP0052_GET_DAY_RANGE | MATCH | SP SCP0052_GET_DAY_RANGE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=BucketType] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0052_GET_DAY_RANGE | MATCH | 1 | SP SCP0052_GET_DAY_RANGE | EXEC:SCP0052_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| initSubTotal | dataRow | CODE, NAME |
| initSubTotal | dr | COLUMN_NAME, COLUMN_LABEL_NAME |
| initSubTotal | row | CODE, NAME, SORT_ORDER |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | getDivision:140, getOperation:156, getPlantId:171, getLineId:186, getVersionId:261, getGroupColumn:329 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | SetSpreadInit:530, initSubTotal:1015 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | SetSpreadInit:532 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | SetSpreadInit:536, SetSpreadInit:540 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:439 |
| this.cmbDivision | SelectedIndexChanged | cmbDivision_SelectedIndexChanged | InitEvent:648 |
| this.cmbOperationGroup | SelectedIndexChanged | cmbOperation_SelectedIndexChanged | InitEvent:649 |
| this.cmbPlant | SelectedIndexChanged | cmbPlant_SelectedIndexChanged | InitEvent:650 |
| this.cmbVersion | SelectedIndexChanged | cmbVersion_SelectedIndexChanged | InitEvent:651 |
| this.cmbBucketType | SelectedIndexChanged | cmbBucketType_SelectedIndexChanged | InitEvent:652 |
| this.cmbSubTotal | SelectedIndexChanged | cmbSubTotal_SelectedIndexChanged | InitEvent:653 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:655 |
| this.rdUOM | CheckedChanged | rdButton_Changed | InitEvent:658 |
| this.rdCell | CheckedChanged | rdButton_Changed | InitEvent:659 |
| this.btnMeasure | Click | BtnMeasure_Click | InitEvent:661 |
| this.btnColumn | Click | BtnColumn_Click | InitEvent:662 |

## 6. 컨트롤 (48개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 15 | Division, layoutOperationGroup, layoutPlant1, layoutLine, z, layoutModel, layoutNickName, layoutControlItem3, layoutBucket, layoutSubTotal, layoutControlItem1, layoutBtnColumn, layoutSum, layoutCell, layoutUOM |
| EmptySpaceItem | 13 | emptySpaceItem10, emptySpaceItem14, emptySpaceItem7, emptySpaceItem4, emptySpaceItem5, emptySpaceItem9, emptySpaceItem12, emptySpaceItem8, emptySpaceItem1, emptySpaceItem3, emptySpaceItem2, emptySpaceItem11, emptySpaceItem6 |
| UsrCheckedList | 4 | cmbLine, cmbPlant, cmbOperationGroup, cmbVersion |
| UsrCombo | 3 | cmbDivision, cmbBucketType, cmbSubTotal |
| UsrButton | 2 | btnMeasure, btnColumn |
| UsrRadio | 2 | rdCell, rdUOM |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker3 | 1 | dCalendar |
| TextBox | 1 | txtNickName |
| UsrMultiLineEditor | 1 | txtModelId |
| UsrCheckBox | 1 | chkSum |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 38 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 14 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 9 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 28 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 5 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 11 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 100 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0081 | Production Plan Report | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |
| SCM_MST_SHEET_MEASURE | SCP0081 | Production Plan Report | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Production Plan Report
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetSpreadInit:532
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadColumn |  | 594 | 표시/라벨 변경 | set:Visible | Visible = {?this.IsVisibleCell(colName)} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cmbBucketType.ControlValues)case "DAILY" ⟫ if(colName.IndexOf("D_") == 0 \|\| colName.IndexOf("W_") == 0) |
| SetSpreadColumn |  | 600 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked && this.IsVisibleCell(colName)} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cmbBucketType.ControlValues)case "DAILY" ⟫ if(colName.IndexOf("M_") == 0 \|\| colName.IndexOf("W_") == 0) |
| SetSpreadColumn |  | 609 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cmbBucketType.ControlValues)case "WEEKLY" ⟫ if(colName.IndexOf("D_") == 0) |
| SetSpreadColumn |  | 613 | 표시/라벨 변경 | set:Visible | Visible = {?this.IsVisibleCell(colName)} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cmbBucketType.ControlValues)case "WEEKLY" ⟫ else!(colName.IndexOf("D_") == 0) ⟫ if(colName.IndexOf("W_") == 0) |
| SetSpreadColumn |  | 618 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked && this.IsVisibleCell(colName)} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cmbBucketType.ControlValues)case "WEEKLY" ⟫ if(colName.IndexOf("M_") == 0) |
| SetSpreadColumn |  | 627 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cmbBucketType.ControlValues)case "MONTHLY" ⟫ if(colName.IndexOf("D_") == 0 \|\| colName.IndexOf("W_") == 0) |
| SetSpreadColumn |  | 631 | 표시/라벨 변경 | set:Visible | Visible = {?this.IsVisibleCell(colName)} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cmbBucketType.ControlValues)case "MONTHLY" ⟫ else!(colName.IndexOf("D_") == 0 \|\| colName.IndexOf("W_") == 0) ⟫ if(colName.IndexOf("M_") == 0) |
| InitSpreadDateColumn |  | 810 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} \|\| {?sColumnName += "_CELL"} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 814 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| InitializeComponent |  | 1052 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1053 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1054 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1055 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Production Plan Report | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
