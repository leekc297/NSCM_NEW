# SCP0091 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0091_INTRANSIT\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0091_INTRANSIT\SCP0091_INTRANSIT.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0091_INTRANSIT\SCP0091_INTRANSIT.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0091_INTRANSIT\SCP0091_INTRANSIT.csproj | 1178 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0091_INTRANSIT\SCP0091_INTRANSIT.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0091_INTRANSIT\SCP0091_INTRANSIT.csproj | 1026 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > Find_Data | 612 | SCP.SCP0091_GET_VALIDATION_SHIPMENT_REPORT | MATCH | SP SCP0091_GET_VALIDATION_SHIPMENT_REPORT |
| button:FindButton | FindButton > Find_Data > InitSpread > SetSpreadInit > GetSpdTitle | 929 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindDetail_Data | 766 | SCP.SCP0091_GET_VALIDATION_SHIPMENT_DETAIL | MATCH | SP SCP0091_GET_VALIDATION_SHIPMENT_DETAIL |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread > SetSpreadInit > GetSpdTitle | 929 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls | 184 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 195 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > GetSpdTitle | 929 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | GoPage | 865 | MenuContainer.UP_FX_GetGSCMAuthenticationMenuList | MATCH | SP UP_FX_GetGSCMAuthenticationMenuList |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| MenuContainer.UP_FX_GetGSCMAuthenticationMenuList | MATCH | 1 | SP UP_FX_GetGSCMAuthenticationMenuList | EXEC:UP_FX_GETGSCMAUTHENTICATIONMENULIST, SELECT:TB_FX_MENUITEMINFO, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_GROUPMENUAUTH, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:MENUCTE1, SELECT:TB_FX_PROGRAMINFO |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0091_GET_VALIDATION_SHIPMENT_DETAIL | MATCH | 1 | SP SCP0091_GET_VALIDATION_SHIPMENT_DETAIL | EXEC:SCP0091_GET_VALIDATION_SHIPMENT_DETAIL, SELECT:SCM_SYS_CALENDAR_M, REF:FN_SCM_GET_WHERE_SQL, DYNAMIC@SCP0091_GET_VALIDATION_SHIPMENT_DETAIL, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT |  |
| SCP.SCP0091_GET_VALIDATION_SHIPMENT_REPORT | MATCH | 1 | SP SCP0091_GET_VALIDATION_SHIPMENT_REPORT | EXEC:SCP0091_GET_VALIDATION_SHIPMENT_REPORT, SELECT:SCM_DNM_INTRANSIT_C, SELECT:SCP_MST_BOD_N_V, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, REF:FN_GET_ITEM_OPERATION_GROUP, INSERT:#TMP_WEEKLY_TERM, SELECT:#TMP_WEEKLY_TERM, SELECT:SCM_MST_TITLESET_USER, INSERT:#TMP_SCP0091_COLUMN, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:#TMP_SCP0091_COLUMN, REF:FN_SCM_GET_WHERE_SQL, DYNAMIC@SCP0091_GET_VALIDATION_SHIPMENT_REPORT, SELECT:SCM_MST_ITEM_SN, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InitControls | UserInfoContext.Current | NowGroupID |
| SetChangedControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:205, Find_Data:563, Find_Data:574, FindDetail_Data:682 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpreadDetail:261, SetSpreadInit:274 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| GetSpdTitle | SetSpreadInit:272 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| InitSpreadDateColumn | SetSpreadInit:278, SetSpreadInit:282 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnItemId | Click | btnItemId_Click_1 | InitializeComponent:319 |
| this | Load | Form_Load | .ctor:141 |
| this.btnProjectID | Click | BtnProjectID_Click | InitEvent:157 |
| this.btnItemId | Click | BtnItemId_Click | InitEvent:158 |
| this.cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:159 |
| this.cboBucketType | SelectedIndexChanged | CboBucketType_SelectedIndexChanged | InitEvent:160 |
| this.btnProject | Click | btnProject_Click | InitEvent:161 |
| spdMain | CellClick | SpdMain_CellClick | InitEvent:163 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:164 |
| this.btnColumn | Click | BtnColumn_Click | InitEvent:166 |

## 6. 컨트롤 (37개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 13 | layoutDiv, layoutSalesSite, layoutControlItem2, layoutOpGroup, layoutResultDate, layoutPeriod, layoutProject, layoutBtnColumn, layoutModel, layoutBucket, layoutControlItem3, layoutControlItem1, lblPlantSite |
| UsrButton | 4 | btnItemId, btnProjectID, btnColumn, btnProject |
| UsrCombo | 3 | cboDivision, cboBucketType, cboOpGroup |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3 |
| FpSpread | 2 | spdMain, spdDetail |
| SheetView | 2 | spdMain_Sheet1, spdDetail_Sheet |
| UsrDateRangePicker | 2 | drpResult, drpPeriod |
| UsrMultiLineEditor | 2 | txtProject, txtItemId |
| SplitContainer | 1 | splitContainer1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| TextBox | 1 | txtSaleSite |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| UsrCheckedList | 1 | clbPlantSite |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 32 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 51 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 2 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (3건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 974 | SCM.GET_DATE_RANGE_YESTERDAY_BEFORE_1MONTH | commented:MATCH |
| 1022 | SCP.SCM0001_GET_SCP_MONTH_PERIOD | commented:MATCH |
| 1021 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0091 | DETAIL | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 |
| SCM_MST_SHEET_COLUMNS | SCP0091 | REPORT | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: REPORT, DETAIL
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpreadDetail:261, SetSheetHeaderColumn@SetSpreadInit:274
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn, SetSpreadColumnDetail

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 336 | DB루프 | AddNumColumn | {?dr[DefCols.COLUMN_LABEL_NAME]} | {?dr[DefCols.COLUMN_NAME]} \|\| {?sColumnName += "_CELL"} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 340 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 420 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) |
| SetSpreadColumn |  | 426 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(colName.IndexOf("D_") == 0 && colName.Contains("_CELL") == false) |
| SetSpreadColumn |  | 431 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(colName.IndexOf("W_") == 0 \|\| colName.IndexOf("M_") == 0) |
| SetSpreadColumn |  | 438 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(colName.IndexOf("W_") == 0 && colName.Contains("_CELL") == false) |
| SetSpreadColumn |  | 445 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(colName.IndexOf("M_") == 0 && colName.Contains("_CELL") == false) |
| InitializeComponent |  | 147 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 148 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 149 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 150 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 860 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 861 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 862 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 863 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| DETAIL | META+코드연결 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 |
| REPORT | META+코드연결 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
