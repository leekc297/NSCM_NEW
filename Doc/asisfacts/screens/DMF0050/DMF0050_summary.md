# DMF0050 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0050_EDIWaterfall\DMF0050_EDIWaterfall.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0050_EDIWaterfall\DMF0050_EDIWaterfall.csproj | 1183 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0050_EDIWaterfall\DMF0050_EDIWaterfall.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0050_EDIWaterfall\DMF0050_EDIWaterfall.csproj | 899 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0050_EDIWaterfall\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0050_EDIWaterfall\DMF0050_EDIWaterfall.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0050_EDIWaterfall\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0050_EDIWaterfall\DMF0050_EDIWaterfall.csproj | 72 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0050_EDIWaterfall\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0050_EDIWaterfall\DMF0050_EDIWaterfall.csproj | 31 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0050_EDIWaterfall.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1143 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0050_EDIWaterfall.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 899 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 503 | DM.DMF0050_GET_EDI_WATERFALL | MATCH | SP DMF0050_GET_EDI_WATERFALL |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 1045 | DM.DMF0050_GET_SPREAD_TITLE | MATCH | SP DMF0050_GET_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 1045 | DM.DMF0050_GET_SPREAD_TITLE | MATCH | SP DMF0050_GET_SPREAD_TITLE |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 1045 | DM.DMF0050_GET_SPREAD_TITLE | MATCH | SP DMF0050_GET_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged | 695 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 1045 | DM.DMF0050_GET_SPREAD_TITLE | MATCH | SP DMF0050_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls | 204 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 210 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1028 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1045 | DM.DMF0050_GET_SPREAD_TITLE | MATCH | SP DMF0050_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1064 | DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE | MATCH | SP DMF0003_GET_REPORT_BUCKET_TYPE_CODE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE | MATCH | 1 | SP DMF0003_GET_REPORT_BUCKET_TYPE_CODE | EXEC:DMF0003_GET_REPORT_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0050_GET_EDI_WATERFALL | MATCH | 1 | SP DMF0050_GET_EDI_WATERFALL | EXEC:DMF0050_GET_EDI_WATERFALL, SELECT:SCM_SYS_CALENDAR_M, CREATE:#T_VERSION, CREATE:#RAW_DATA, INSERT:#T_VERSION, REF:FN_NEXT_DAY, REF:STRING_SPLIT, SELECT:DM_MST_VERSION, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:#RAW_DATA, INSERT:#RAW_DATA, SELECT:DM_DNM_EDI_CALLOFF_ITEM_C, SELECT:#T_VERSION, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_COUNTRY, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, DELETE:A, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, CREATE:#T_COLUMN_SETUP, INSERT:#T_COLUMN_SETUP, INSERT:#T, REF:UF_FX_STRING_SPLIT, SELECT:#T_COLUMN_SETUP, SELECT:#T, EXEC:SP_EXECUTESQL |  |
| DM.DMF0050_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0050_GET_SPREAD_TITLE | EXEC:DMF0050_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ClbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| FindData | ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1] | BACK_ORDER |
| FindData | ds.Tables[1].Rows[0] | BASIS_DATE |
| InitControls | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:206, InitControls:226, FindData:472, ClbDivision_SelectedIndexChanged:690, ClbDivision_SelectedIndexChanged:707, ClbDivision_SelectedIndexChanged:709, SetClbVersion:732, btnItemId_Click:1123 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:287 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:288 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnVersion | Click | btnVersion_Click | InitializeComponent:213 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:253 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:293 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:331 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:424 |
| this.txtVersion | KeyDown | txtVersion_KeyDown | InitializeComponent:460 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:569 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:779 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:780 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:781 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:782 |
| this | FormClosed | DM0050_EDIWaterfall_FormClosed | InitializeComponent:834 |
| this | Load | DMF0050_EDIWaterfall_Load | InitializeComponent:835 |
| this | Load | Form_Load | .ctor:171 |
| this.clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:349 |

## 6. 컨트롤 (30개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 11 | lblCustomer, lblVersion, layoutControlItem5, lblBucket, lbldivision, Period, layoutControlItem2, layoutControlItem6, lblModel1, layoutControlItem7, layoutControlItem1 |
| UsrButton | 3 | btnVersion, btnColumn, btnItemId |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCheckBox | 2 | chkMem, chkSum |
| UsrCombo | 2 | cboBucketType, clbDivision |
| UsrMultiLineEditor | 2 | txtVersion, txtItemId |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePickerWtWeek | 1 | drpPeriod |
| UsrCheckedList | 1 | clbCustomer |
| EmptySpaceItem | 1 | emptySpaceItem2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 11 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 12 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 20 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 2 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 11 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 20 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0050 | EDI Waterfall | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 128건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: EDI Waterfall
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:288
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| spdMain_CellDoubleClick |  | 784 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| spdMain_CellDoubleClick |  | 790 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(fBucket == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 796 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ else!(fBucket == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(!siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 813 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(fBucket == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadHeader |  | 893 | 표시/라벨 변경 | set:Text | Text = {?sLargeLabelName} |  | foreach(dr in dt.Rows) ⟫ else!("0"< iStartCol) |
| SetSpreadHeader |  | 894 | 표시/라벨 변경 | set:Text | Text = {?sSmallLabelName} |  | foreach(dr in dt.Rows) ⟫ else!("0"< iStartCol) |
| SetSpreadHeader |  | 895 | 표시/라벨 변경 | set:Text | Text = SUM |  | foreach(dr in dt.Rows) ⟫ else!("0"< iStartCol) |
| SetSpreadHeaderSpan |  | 936 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan |  | 946 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| SetSpreadColumn |  | 997 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1000 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1005 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1007 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1010 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1015 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1017 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 798 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 799 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 800 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 801 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| EDI Waterfall | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
