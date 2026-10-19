# DMF0040 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison\DMF0040_MktFcst_Comparison.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison\DMF0040_MktFcst_Comparison.csproj | 1876 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison\DMF0040_MktFcst_Comparison.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison\DMF0040_MktFcst_Comparison.csproj | 1503 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison\DMF0040_MktFcst_Comparison.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison\DMF0040_MktFcst_Comparison.csproj | 72 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison\DMF0040_MktFcst_Comparison.csproj | 31 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0040_MktFcst_Comparison.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1825 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0040_MktFcst_Comparison.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1503 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 1534 | DM.DMF0040_GET_SPREAD_TITLE | MATCH | SP DMF0040_GET_SPREAD_TITLE |
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 1534 | DM.DMF0040_GET_SPREAD_TITLE | MATCH | SP DMF0040_GET_SPREAD_TITLE |
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > GetDefaultVersion | 1838 | DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | MATCH | SP SCM0002_GET_VERSIONBYWATERFALLPOPUP |
| button:FindButton | FindButton > FindData | 707 | DM.DMF0040_GET_MKT_FCST_COMPARISON | MATCH | SP DMF0040_GET_MKT_FCST_COMPARISON |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 1534 | DM.DMF0040_GET_SPREAD_TITLE | MATCH | SP DMF0040_GET_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 1534 | DM.DMF0040_GET_SPREAD_TITLE | MATCH | SP DMF0040_GET_SPREAD_TITLE |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 1534 | DM.DMF0040_GET_SPREAD_TITLE | MATCH | SP DMF0040_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1517 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 1534 | DM.DMF0040_GET_SPREAD_TITLE | MATCH | SP DMF0040_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1550 | DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE | MATCH | SP DMF0003_GET_REPORT_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetQtyData | 1564 | DM.DMF0003_GET_QTY_TYPE_CODE | MATCH | SP DMF0003_GET_QTY_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetItemType | 1577 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > cboDivision_SelectedIndexChanged > GetDefaultVersion | 1838 | DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | MATCH | SP SCM0002_GET_VERSIONBYWATERFALLPOPUP |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetScmSitebyDivision | 1485 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetPlantSitebyEndCustomer | 1501 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetDivision | 1471 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivision | 1592 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivision | 1606 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetBizTypebyDivision | 1621 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| DM.DMF0003_GET_QTY_TYPE_CODE | MATCH | 1 | SP DMF0003_GET_QTY_TYPE_CODE | EXEC:DMF0003_GET_QTY_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE | MATCH | 1 | SP DMF0003_GET_REPORT_BUCKET_TYPE_CODE | EXEC:DMF0003_GET_REPORT_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0040_GET_MKT_FCST_COMPARISON | MATCH | 1 | SP DMF0040_GET_MKT_FCST_COMPARISON | EXEC:DMF0040_GET_MKT_FCST_COMPARISON, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_TITLESET_USER, INSERT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:SCM_MST_SHEET_MEASURE, SELECT:TB_FX_USER, REF:FN_MULTY_TIME, INSERT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, SELECT:SCM_MST_ITEM_SN, INSERT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_ORI_V, INSERT:#TEMP_DM_MST_ITEM_SINGLE_B_V, INSERT:#TEMP_SKH_DM_MST_ITEM_SINGLE_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_A_V, SELECT:#TEMP_DM_MST_ITEM_SINGLE_B_V, REF:STRING_SPLIT, INSERT:#ITEM_INPUT, SELECT:#TEMP_SKH_DM_MST_ITEM_SINGLE_V, CREATE:#PROJECT_INPUT, SELECT:SCM_MST_DIVISION, INSERT:#PROJECT_INPUT, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_PROJECT, REF:FN_SCM_GET_WHERE_SQL, EXEC:SP_EXECUTESQL, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT, SELECT:CTE_DATE |  |
| DM.DMF0040_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0040_GET_SPREAD_TITLE | EXEC:DMF0040_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | MATCH | 1 | SP SCM0002_GET_VERSIONBYWATERFALLPOPUP | EXEC:SCM0002_GET_VERSIONBYWATERFALLPOPUP, SELECT:DM_MST_VERSION, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, REF:UF_FX_STRING_SPLIT, SELECT:SCP_PLN_INTERFACE_YN |  |
| SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | EXEC:SCM0001_GET_BIZ_TYPE_BY_DIVISION, SELECT:SCM_MST_PROJECT, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_CUSTOMER_BY_DIVISION | EXEC:SCM0001_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | 1 | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | EXEC:SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_TEAM_BY_DIVISION | EXEC:SCM0001_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| GetDefaultVersion | dr | VERSION_NO |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:223, SetChangeControl:230, SetChangeControl:238, SetChangeControl:245, SetChangeControl:254, SetChangeControl:261 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| GetCheckedListValue | InitControls:281, InitControls:290, InitControls:335, InitControls:352, InitControls:353, InitControls:354, FindData:668, FindData:669 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:397 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:398 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| FP_Log2 | cboDivision_SelectedIndexChanged:949, cboDivision_SelectedIndexChanged:1035 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnOwner | Click | btnOwner_Click | InitializeComponent:220 |
| this.btnVersion | Click | btnVersion_Click | InitializeComponent:297 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:334 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:412 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:449 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:521 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:559 |
| this.txtVersion | KeyDown | txtVersion_KeyDown | InitializeComponent:832 |
| this.cboQTY | SelectedIndexChanged | cboQTY_SelectedIndexChanged | InitializeComponent:940 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1350 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1351 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:1352 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:1353 |
| this | Load | Form_Load | .ctor:183 |
| cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:563 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitEvent:564 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitEvent:565 |
| cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:566 |

## 6. 컨트롤 (53개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 22 | lblCustomer, lblSalesSite, lblProject, layoutControlItem1, lblBucket, layoutControlItem2, lblPlantSite, lblVersion, layoutControlItem5, layoutControlItem6, Period, lblBizType, lblTeam, layoutControlItem3, lblModel … |
| UsrCheckedList | 6 | clbItemType, clbPlantSite, clbSalesSite, clbBizType, clbCustomer, clbTeam |
| UsrButton | 5 | btnOwner, btnVersion, btnColumn, btnProject, btnItemId |
| UsrMultiLineEditor | 4 | txtProject, txtItemId, txtVersion, txtOwner |
| UsrCheckBox | 3 | chkSum, cboCellQty, cboDiff |
| UsrCombo | 3 | cboBucketType, cboDivision, cboQTY |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 2 | emptySpaceItem8, emptySpaceItem6 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePickerWtWeek | 1 | drpPeriod |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 246 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 48 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 152 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 32 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 576 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1472 | DM.Get_Division | commented:NOT_IN_FOXQUERY |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0040 | Mkt Fcst Waterfall | 6/28 | 5/22 | 5/22 | 5/22 | 5/22 | 5/22 | 5/22 | 5/21 | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 534건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Mkt Fcst Waterfall
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:398
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadHeader |  | 463 | 표시/라벨 변경 | set:Text | Text = {?sLargeLabelName} |  | foreach(dr in dt.Rows) ⟫ else!("0"< iStartCol) |
| SetSpreadHeader |  | 464 | 표시/라벨 변경 | set:Text | Text = {?sSmallLabelName} |  | foreach(dr in dt.Rows) ⟫ else!("0"< iStartCol) |
| SetSpreadHeader |  | 465 | 표시/라벨 변경 | set:Text | Text = SUM |  | foreach(dr in dt.Rows) ⟫ else!("0"< iStartCol) |
| SetSpreadHeaderSpan |  | 508 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan |  | 519 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| spdMain_CellDoubleClick |  | 1184 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| spdMain_CellDoubleClick |  | 1190 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 1206 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1379 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1384 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1391 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1395 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1400 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1407 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1411 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 1369 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1370 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1371 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1372 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Mkt Fcst Waterfall | META+코드연결 | 6 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
