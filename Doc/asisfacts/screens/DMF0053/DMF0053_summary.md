# DMF0053 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0053_CustFcstWaterfall\DMF0053_CustFcstWaterfall.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0053_CustFcstWaterfall\DMF0053_CustFcstWaterfall.csproj | 1823 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0053_CustFcstWaterfall\DMF0053_CustFcstWaterfall.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0053_CustFcstWaterfall\DMF0053_CustFcstWaterfall.csproj | 1612 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0053_CustFcstWaterfall\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0053_CustFcstWaterfall\DMF0053_CustFcstWaterfall.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0053_CustFcstWaterfall\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0053_CustFcstWaterfall\DMF0053_CustFcstWaterfall.csproj | 72 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0053_CustFcstWaterfall\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0053_CustFcstWaterfall\DMF0053_CustFcstWaterfall.csproj | 31 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0053_CustFcstWaterfall.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1786 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0053_CustFcstWaterfall.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1612 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 1563 | DM.DMF0053_GET_SPREAD_TITLE | MATCH | SP DMF0053_GET_SPREAD_TITLE |
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 1563 | DM.DMF0053_GET_SPREAD_TITLE | MATCH | SP DMF0053_GET_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 734 | DM.DMF0053_GET_CUST_FCST_WATERFALL | MATCH | SP DMF0053_GET_CUST_FCST_WATERFALL |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 1563 | DM.DMF0053_GET_SPREAD_TITLE | MATCH | SP DMF0053_GET_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 1563 | DM.DMF0053_GET_SPREAD_TITLE | MATCH | SP DMF0053_GET_SPREAD_TITLE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 1563 | DM.DMF0053_GET_SPREAD_TITLE | MATCH | SP DMF0053_GET_SPREAD_TITLE |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 1563 | DM.DMF0053_GET_SPREAD_TITLE | MATCH | SP DMF0053_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1540 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 1563 | DM.DMF0053_GET_SPREAD_TITLE | MATCH | SP DMF0053_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1579 | DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE | MATCH | SP DMF0003_GET_REPORT_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetQtyData | 1592 | DM.DMF0003_GET_QTY_TYPE_CODE | MATCH | SP DMF0003_GET_QTY_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetItemType | 1605 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetScmSitebyDivision | 1508 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetPlantSitebyEndCustomer | 1524 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetDivision | 1494 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivision | 1620 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivision | 1634 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetBizTypebyDivision | 1649 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| DM.DMF0003_GET_QTY_TYPE_CODE | MATCH | 1 | SP DMF0003_GET_QTY_TYPE_CODE | EXEC:DMF0003_GET_QTY_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE | MATCH | 1 | SP DMF0003_GET_REPORT_BUCKET_TYPE_CODE | EXEC:DMF0003_GET_REPORT_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0053_GET_CUST_FCST_WATERFALL | MATCH | 1 | SP DMF0053_GET_CUST_FCST_WATERFALL | EXEC:DMF0053_GET_CUST_FCST_WATERFALL, CREATE:#RAW_DATA, SELECT:SCM_MST_TITLESET_USER, INSERT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#SELECT_MEASURE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:DM_MST_CUSTOMER_FCST, INSERT:#TEMP_DM_DNM_EDI_CALLOFF_ITEM, SELECT:DM_DNM_EDI_CALLOFF_ITEM, INSERT:#RAW_DATA, SELECT:DM_PLN_CUST_FCST_H, SELECT:#SELECT_MEASURE, SELECT:#TEMP_DM_DNM_EDI_CALLOFF_ITEM, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_ITEM_SN, SELECT:#RAW_DATA, INSERT:#CALENDAR, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TEMP_SCM_MST_SITE_ITEM, REF:FN_GET_DM_MKT_OWNER_NAME, SELECT:SCM_MST_SSO_USER_INFO, REF:STRING_SPLIT, SELECT:SCM_MST_SITE_ITEM, DELETE:#RAW_DATA, DELETE:A, SELECT:SCM_MST_PROJECT, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:#TEMP_SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE, INSERT:#TEMP_SCM_MST_SITE, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CITY, SELECT:SCM_MST_COUNTRY, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V_T, SELECT:SCM_MST_SHEET_COLUMNS, CREATE:#T_COLUMN_SETUP, INSERT:#T_COLUMN_SETUP, INSERT:#T, REF:UF_FX_STRING_SPLIT, SELECT:#T_COLUMN_SETUP, SELECT:#T, EXEC:SP_EXECUTESQL |  |
| DM.DMF0053_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0053_GET_SPREAD_TITLE | EXEC:DMF0053_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
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
| FindData | UserInfoContext.Current | Dept_ID, NowGroupID |
| FindData | ds.Tables[2].Rows[0] | DATA_ORDER |
| FindData | ds.Tables[1].Rows[0] | ISO_WEEK |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:216, SetChangeControl:223, SetChangeControl:231, SetChangeControl:238, SetChangeControl:247, SetChangeControl:254 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| GetCheckedListValue | InitControls:274, InitControls:283, InitControls:326, InitControls:343, InitControls:344, InitControls:345, FindData:674, FindData:675 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:388 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:389 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| FP_Log2 | cboDivision_SelectedIndexChanged:930, cboDivision_SelectedIndexChanged:1027 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:234 |
| this.btnOwner | Click | btnOwner_Click | InitializeComponent:271 |
| this.btnVersion | Click | btnVersion_Click | InitializeComponent:349 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:386 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:463 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:535 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:573 |
| this.txtVersion | KeyDown | txtVersion_KeyDown | InitializeComponent:856 |
| this.cboQTY | SelectedIndexChanged | cboQTY_SelectedIndexChanged | InitializeComponent:964 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:1001 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1421 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1422 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:1423 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:1424 |
| this | Load | Form_Load | .ctor:178 |
| cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:559 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitEvent:560 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitEvent:561 |
| cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:562 |

## 6. 컨트롤 (59개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 22 | lblSalesSite, lblProject, lblPlantSite, lblTeam, lblModel, layoutControlItem2, layoutControlItem1, lblDivion, lblBizType, Period, lblItemType, lblCustomer, layoutControlItem3, lblBucket, lblOwner … |
| EmptySpaceItem | 8 | emptySpaceItem1, emptySpaceItem3, emptySpaceItem10, emptySpaceItem7, emptySpaceItem5, emptySpaceItem2, emptySpaceItem4, emptySpaceItem8 |
| UsrButton | 6 | btnColumn, btnOwner, btnVersion, btnProject, btnItemId, btnMeasure |
| UsrCheckedList | 6 | clbItemType, clbPlantSite, clbSalesSite, clbBizType, clbCustomer, clbTeam |
| UsrMultiLineEditor | 4 | txtProject, txtItemId, txtVersion, txtOwner |
| UsrCombo | 3 | cboBucketType, cboDivision, cboQTY |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrDateRangePickerWtWeek | 2 | drpPeriod, drpCreateDate |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCheckBox | 1 | chkSum |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 111 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 66 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 2 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 162 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 6 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 30 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1495 | DM.Get_Division | commented:NOT_IN_FOXQUERY |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0053 | CUST Fcst Waterfall | 14/30 | 20/21 | 20/20 | 20/20 | 20/20 | 20/20 | 20/21 | 18/16 | · | · | · | · | · | · |
| SCM_MST_SHEET_MEASURE | DMF0053 | CUST Fcst Waterfall | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 120건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: CUST Fcst Waterfall
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:389
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadHeader |  | 457 | 표시/라벨 변경 | set:Text | Text = {?sLargeLabelName} |  | foreach(dr in dt.Rows) ⟫ else!("0"< iStartCol) |
| SetSpreadHeader |  | 458 | 표시/라벨 변경 | set:Text | Text = {?sSmallLabelName} |  | foreach(dr in dt.Rows) ⟫ else!("0"< iStartCol) |
| SetSpreadHeader |  | 459 | 표시/라벨 변경 | set:Text | Text = SUM |  | foreach(dr in dt.Rows) ⟫ else!("0"< iStartCol) |
| SetSpreadHeaderSpan |  | 501 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan |  | 514 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| spdMain_CellDoubleClick |  | 1169 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| spdMain_CellDoubleClick |  | 1175 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(fBucket == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 1181 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ else!(fBucket == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(!siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 1199 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(fBucket == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1380 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1383 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1388 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1390 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1393 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1398 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1400 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 1440 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1441 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1442 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1443 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| CUST Fcst Waterfall | META+코드연결 | 14 | 20 | 20 | 20 | 20 | 20 | 20 | 18 | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
