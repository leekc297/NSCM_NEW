# DMF0052 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.csproj | 796 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.csproj | 796 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.csproj | 72 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.csproj | 31 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 265 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 313 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0052_EDISummary.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 796 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0052_EDISummary.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 796 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 211 | DM.DMF0052_GET_SITE_POPUP | MATCH | SP DMF0052_GET_SITE_POPUP |
| button:FindButton | FindButton > FindData_Main | 312 | DM.DMF0052_GET_SUMMARY_DATA | MATCH | SP DMF0052_GET_SUMMARY_DATA |
| button:FindButton | FindButton > FindData_Pjt | 355 | DM.DMF0052_GET_PJT_DATA | MATCH | SP DMF0052_GET_PJT_DATA |
| button:FindButton | FindButton > FindData_Status | 418 | DM.DMF0052_GET_STATUS_DATA | MATCH | SP DMF0052_GET_STATUS_DATA |
| button:FindButton | FindButton > FindData_Status > InitSpread > GetSpdTitle | 696 | DM.DMF0052_GET_SPREAD_TITLE | MATCH | SP DMF0052_GET_SPREAD_TITLE |
| event:this.btnRefresh.Click | BtnRefresh_Click > FindData_GSCMData | 460 | DM.DMF0052_GET_DETAIL_DATA | MATCH | SP DMF0052_GET_DETAIL_DATA |
| event:this.btnRefresh.Click | BtnRefresh_Click > FindData_GSCMData > InitSpread > GetSpdTitle | 696 | DM.DMF0052_GET_SPREAD_TITLE | MATCH | SP DMF0052_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > FindData | 211 | DM.DMF0052_GET_SITE_POPUP | MATCH | SP DMF0052_GET_SITE_POPUP |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 696 | DM.DMF0052_GET_SPREAD_TITLE | MATCH | SP DMF0052_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetEdiSender | 783 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdSummaryPJT.CellDoubleClick | spdPjt_CellDoubleClick > FindData_GSCMData | 460 | DM.DMF0052_GET_DETAIL_DATA | MATCH | SP DMF0052_GET_DETAIL_DATA |
| event:this.spdSummaryPJT.CellDoubleClick | spdPjt_CellDoubleClick > FindData_ERPData | 529 | DM.DMF0052_GET_ERP_DATA | MATCH | SP DMF0052_GET_ERP_DATA |
| event:this.spdSummaryPJT.CellDoubleClick | spdPjt_CellDoubleClick > FindData_ERPData > InitSpread > GetSpdTitle | 696 | DM.DMF0052_GET_SPREAD_TITLE | MATCH | SP DMF0052_GET_SPREAD_TITLE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| DM.DMF0052_GET_DETAIL_DATA | MATCH | 1 | SP DMF0052_GET_DETAIL_DATA | EXEC:DMF0052_GET_DETAIL_DATA, CREATE:#T_EDI, INSERT:#T_EDI, SELECT:DM_DNM_EDI_CALLOFF_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, REF:FN_GET_ITEM_NICKNAME, SELECT:#T_EDI, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_ITEM_SN |  |
| DM.DMF0052_GET_ERP_DATA | MATCH | 1 | SP DMF0052_GET_ERP_DATA | EXEC:DMF0052_GET_ERP_DATA, CREATE:#T_EDI, INSERT:#T_EDI, SELECT:DM_DNM_EDI_CALLOFF_ITEM, REF:STRING_SPLIT, REF:FN_GET_ITEM_NICKNAME, SELECT:#T_EDI, SELECT:SCM_MST_ITEM_SN |  |
| DM.DMF0052_GET_PJT_DATA | MATCH | 1 | SP DMF0052_GET_PJT_DATA | EXEC:DMF0052_GET_PJT_DATA, CREATE:#T_GSCM_DATA, INSERT:#T_GSCM_DATA, REF:FN_GET_ITEM_NICKNAME, SELECT:DM_DNM_EDI_CALLOFF_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, SELECT:SCM_MST_SITE_ITEM, CREATE:#T_ERP_DATA, INSERT:#T_ERP_DATA, SELECT:#T_GSCM_DATA, SELECT:#T_ERP_DATA, SELECT:SCM_MST_ITEM_SN |  |
| DM.DMF0052_GET_SITE_POPUP | MATCH | 1 | SP DMF0052_GET_SITE_POPUP | EXEC:DMF0052_GET_SITE_POPUP, SELECT:DM_DNM_EDI_CALLOFF_ITEM, SELECT:SCM_MST_SITE_CUSTOMER |  |
| DM.DMF0052_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0052_GET_SPREAD_TITLE | EXEC:DMF0052_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0052_GET_STATUS_DATA | MATCH | 1 | SP DMF0052_GET_STATUS_DATA | EXEC:DMF0052_GET_STATUS_DATA, SELECT:DM_DNM_EDI_CALLOFF_ITEM, REF:STRING_SPLIT |  |
| DM.DMF0052_GET_SUMMARY_DATA | MATCH | 1 | SP DMF0052_GET_SUMMARY_DATA | EXEC:DMF0052_GET_SUMMARY_DATA, SELECT:XIF_ERP_EDI_CALLOFF_ITEM_R_SN |  |
| DM.UP_FX_GetCommonDataList_DM | MATCH | 1 | SP UP_FX_GETCOMMONDATALIST_DM | EXEC:UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_PLANT_SN |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:144, FindData_Main:278, FindData_Pjt:344, FindData_Status:407 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:191 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:192 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdSummaryPJT | CellDoubleClick | spdPjt_CellDoubleClick | InitializeComponent:171 |
| this.btnRefresh | Click | BtnRefresh_Click | InitializeComponent:218 |
| this.chkToday | CheckedChanged | chkToday_CheckedChanged | InitializeComponent:255 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:362 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:399 |
| this.spdData | ActiveSheetChanging | spdData_ActiveSheetChanging | InitializeComponent:657 |
| this.spdData | CellDoubleClick | spdData_CellDoubleClick | InitializeComponent:658 |
| this | Load | Form_Load | .ctor:123 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:183 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:227 |
| this | Load | Form_Load | .ctor:76 |

## 6. 컨트롤 (42개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | layoutControlItem1, lblProject, layoutControlItem3, lblModel, layoutControlItem4, Period, lblEDISender, layoutControlItem2, layoutControlItem2 |
| FpSpread | 5 | spdSummary, spdSummaryPJT, spdSummaryStatus, spdData, spdMain |
| SheetView | 5 | spdSummary_Sheet1, spdSummaryPJT_Sheet1, spdSummaryStatus_Sheet1, spdData_Sheet1, spdMain_Sheet1 |
| SplitContainer | 3 | splitContainer1, splitContainer2, splitContainer3 |
| UsrLayoutControl | 3 | usrLayoutControl1, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 3 | layoutControlGroup1, layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrMultiLineEditor | 2 | txtItemId, txtProject |
| UsrButton | 2 | btnProject, btnItemId |
| EmptySpaceItem | 2 | emptySpaceItem3, emptySpaceItem1 |
| SimpleButton | 1 | btnRefresh |
| UsrCheckBox | 1 | chkToday |
| UsrDateRangePicker | 1 | drpPeriod |
| UsrCheckedList | 1 | clbEDISender |
| ImageList | 1 | imageList1 |
| UsrButtonList | 1 | btnButtonList |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 45 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_SearchCondition | 2 | dbmeta_dbo_TB_FX_SearchCondition.csv |
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 12 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0052 | ERP Data | · | 10/0 | · | · | · | · | · | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0052 | GSCM Data | · | 10/0 | · | · | · | · | · | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0052 | Site Popup | · | 9/0 | · | · | · | · | · | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0052 | SUMMARY | · | 4/0 | · | · | · | · | · | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0052 | Summary Pjt | · | 8/0 | · | · | · | · | · | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0052 | Summary Status | · | 4/0 | · | · | · | · | · | · | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 6개 시트×division 비교, 차이 0건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: SUMMARY, Summary Pjt, Summary Status, GSCM Data, ERP Data, EDI Summary GSCM DATA Popup
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:192

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 674 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 675 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 676 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 677 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 144 | 하드코딩 | AddTextColumn | (ERP) EDI Sender | SENDER_NAME |  |
| InitSpread |  | 145 | 하드코딩 | AddTextColumn | (ERP) Company | COMPANY_ID |  |
| InitSpread |  | 146 | 하드코딩 | AddTextColumn | (ERP) Sold to | SOLDTO_CODE |  |
| InitSpread |  | 147 | 하드코딩 | AddTextColumn | (ERP) Ship to | SHIPTO_CODE |  |
| InitSpread |  | 150 | 하드코딩 | AddTextColumn | (GSCM) Sales Site | SCM_SITE_ID | if(PopupType != "CHECK_SALES_SITE") |
| InitSpread |  | 151 | 하드코딩 | AddTextColumn | Active | VALID_YN | if(PopupType != "CHECK_SALES_SITE") |
| InitSpread |  | 152 | 하드코딩 | AddTextColumn | (GSCM) Sold to / Ship to | GSCM_CODE | if(PopupType != "CHECK_SALES_SITE") |
| InitSpread |  | 153 | 하드코딩 | AddTextColumn | Active | CODE_VALID_YN | if(PopupType != "CHECK_SALES_SITE") |
| InitSpread |  | 155 | 하드코딩 | AddTextColumn | Message | Message |  |
| InitializeComponent |  | 243 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 244 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 245 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 246 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| EDI Summary GSCM DATA Popup | 코드 하드코딩 전용(메타 없음) | 9 (?4) | 9 (?4) | 9 (?4) | 9 (?4) | 9 (?4) | 9 (?4) | 9 (?4) | 9 (?4) | 9 (?4) | 9 (?4) | 9 (?4) | 9 (?4) | 9 (?4) | 9 (?4) |
| ERP Data | META+코드연결 | · | 10 | · | · | · | · | · | · | · | · | · | · | · | · |
| GSCM Data | META+코드연결 | · | 10 | · | · | · | · | · | · | · | · | · | · | · | · |
| Site Popup | 메타 정의만, 코드 미참조(미사용 가능) | · | 9 | · | · | · | · | · | · | · | · | · | · | · | · |
| SUMMARY | META+코드연결 | · | 4 | · | · | · | · | · | · | · | · | · | · | · | · |
| Summary Pjt | META+코드연결 | · | 8 | · | · | · | · | · | · | · | · | · | · | · | · |
| Summary Status | META+코드연결 | · | 4 | · | · | · | · | · | · | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:호출파라미터 56 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 56건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.


### FILE endpoints.csv (7 rows)
```csv
"variant","file","class","member","line","site_kind","kind","candidate","key","status","sp_or_sql","objects","via","detail"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","FindData_Main","312","ctor","fox","DM.DMF0052_GET_SUMMARY_DATA","DM.DMF0052_GET_SUMMARY_DATA","MATCH","SP DMF0052_GET_SUMMARY_DATA","EXEC:DMF0052_GET_SUMMARY_DATA, SELECT:XIF_ERP_EDI_CALLOFF_ITEM_R_SN","",""
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","FindData_Pjt","355","ctor","fox","DM.DMF0052_GET_PJT_DATA","DM.DMF0052_GET_PJT_DATA","MATCH","SP DMF0052_GET_PJT_DATA","EXEC:DMF0052_GET_PJT_DATA, CREATE:#T_GSCM_DATA, INSERT:#T_GSCM_DATA, REF:FN_GET_ITEM_NICKNAME, SELECT:DM_DNM_EDI_CALLOFF_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, SELECT:SCM_MST_SITE_ITEM, CREATE:#T_ERP_DATA, INSERT:#T_ERP_DATA, SELECT:#T_GSCM_DATA, SELECT:#T_ERP_DATA, SELECT:SCM_MST_ITEM_SN","",""
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","FindData_Status","418","ctor","fox","DM.DMF0052_GET_STATUS_DATA","DM.DMF0052_GET_STATUS_DATA","MATCH","SP DMF0052_GET_STATUS_DATA","EXEC:DMF0052_GET_STATUS_DATA, SELECT:DM_DNM_EDI_CALLOFF_ITEM, REF:STRING_SPLIT","",""
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","FindData_GSCMData","460","ctor","fox","DM.DMF0052_GET_DETAIL_DATA","DM.DMF0052_GET_DETAIL_DATA","MATCH","SP DMF0052_GET_DETAIL_DATA","EXEC:DMF0052_GET_DETAIL_DATA, CREATE:#T_EDI, INSERT:#T_EDI, SELECT:DM_DNM_EDI_CALLOFF_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, REF:FN_GET_ITEM_NICKNAME, SELECT:#T_EDI, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_ITEM_SN","",""
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","FindData_ERPData","529","ctor","fox","DM.DMF0052_GET_ERP_DATA","DM.DMF0052_GET_ERP_DATA","MATCH","SP DMF0052_GET_ERP_DATA","EXEC:DMF0052_GET_ERP_DATA, CREATE:#T_EDI, INSERT:#T_EDI, SELECT:DM_DNM_EDI_CALLOFF_ITEM, REF:STRING_SPLIT, REF:FN_GET_ITEM_NICKNAME, SELECT:#T_EDI, SELECT:SCM_MST_ITEM_SN","",""
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","GetSpdTitle","696","ctor","fox","DM.DMF0052_GET_SPREAD_TITLE","DM.DMF0052_GET_SPREAD_TITLE","MATCH","SP DMF0052_GET_SPREAD_TITLE","EXEC:DMF0052_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT","",""
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","GetEdiSender","783","ctor","fox","DM.UP_FX_GetCommonDataList_DM","DM.UP_FX_GetCommonDataList_DM","MATCH","SP UP_FX_GETCOMMONDATALIST_DM","EXEC:UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_PLANT_SN","",""
```

### FILE flow.csv (11 rows)
```csv
"variant","file","class","entry_kind","entry","path","member","line","endpoint","status","sp_or_sql","objects"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","event","this.spdSummaryPJT.CellDoubleClick","spdPjt_CellDoubleClick > FindData_ERPData","FindData_ERPData","529","DM.DMF0052_GET_ERP_DATA","MATCH","SP DMF0052_GET_ERP_DATA","EXEC:DMF0052_GET_ERP_DATA, CREATE:#T_EDI, INSERT:#T_EDI, SELECT:DM_DNM_EDI_CALLOFF_ITEM, REF:STRING_SPLIT, REF:FN_GET_ITEM_NICKNAME, SELECT:#T_EDI, SELECT:SCM_MST_ITEM_SN"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","event","this.spdSummaryPJT.CellDoubleClick","spdPjt_CellDoubleClick > FindData_ERPData > InitSpread > GetSpdTitle","GetSpdTitle","696","DM.DMF0052_GET_SPREAD_TITLE","MATCH","SP DMF0052_GET_SPREAD_TITLE","EXEC:DMF0052_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","event","this.spdSummaryPJT.CellDoubleClick","spdPjt_CellDoubleClick > FindData_GSCMData","FindData_GSCMData","460","DM.DMF0052_GET_DETAIL_DATA","MATCH","SP DMF0052_GET_DETAIL_DATA","EXEC:DMF0052_GET_DETAIL_DATA, CREATE:#T_EDI, INSERT:#T_EDI, SELECT:DM_DNM_EDI_CALLOFF_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, REF:FN_GET_ITEM_NICKNAME, SELECT:#T_EDI, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_ITEM_SN"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","event","this.btnRefresh.Click","BtnRefresh_Click > FindData_GSCMData","FindData_GSCMData","460","DM.DMF0052_GET_DETAIL_DATA","MATCH","SP DMF0052_GET_DETAIL_DATA","EXEC:DMF0052_GET_DETAIL_DATA, CREATE:#T_EDI, INSERT:#T_EDI, SELECT:DM_DNM_EDI_CALLOFF_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, REF:FN_GET_ITEM_NICKNAME, SELECT:#T_EDI, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_ITEM_SN"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","event","this.btnRefresh.Click","BtnRefresh_Click > FindData_GSCMData > InitSpread > GetSpdTitle","GetSpdTitle","696","DM.DMF0052_GET_SPREAD_TITLE","MATCH","SP DMF0052_GET_SPREAD_TITLE","EXEC:DMF0052_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","event","this.Load","Form_Load > CreateSpread > InitSpread > GetSpdTitle","GetSpdTitle","696","DM.DMF0052_GET_SPREAD_TITLE","MATCH","SP DMF0052_GET_SPREAD_TITLE","EXEC:DMF0052_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","event","this.Load","Form_Load > InitControls > GetEdiSender","GetEdiSender","783","DM.UP_FX_GetCommonDataList_DM","MATCH","SP UP_FX_GETCOMMONDATALIST_DM","EXEC:UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_PLANT_SN"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","button","FindButton","FindButton > FindData_Status","FindData_Status","418","DM.DMF0052_GET_STATUS_DATA","MATCH","SP DMF0052_GET_STATUS_DATA","EXEC:DMF0052_GET_STATUS_DATA, SELECT:DM_DNM_EDI_CALLOFF_ITEM, REF:STRING_SPLIT"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","button","FindButton","FindButton > FindData_Status > InitSpread > GetSpdTitle","GetSpdTitle","696","DM.DMF0052_GET_SPREAD_TITLE","MATCH","SP DMF0052_GET_SPREAD_TITLE","EXEC:DMF0052_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","button","FindButton","FindButton > FindData_Pjt","FindData_Pjt","355","DM.DMF0052_GET_PJT_DATA","MATCH","SP DMF0052_GET_PJT_DATA","EXEC:DMF0052_GET_PJT_DATA, CREATE:#T_GSCM_DATA, INSERT:#T_GSCM_DATA, REF:FN_GET_ITEM_NICKNAME, SELECT:DM_DNM_EDI_CALLOFF_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, SELECT:SCM_MST_SITE_ITEM, CREATE:#T_ERP_DATA, INSERT:#T_ERP_DATA, SELECT:#T_GSCM_DATA, SELECT:#T_ERP_DATA, SELECT:SCM_MST_ITEM_SN"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","button","FindButton","FindButton > FindData_Main","FindData_Main","312","DM.DMF0052_GET_SUMMARY_DATA","MATCH","SP DMF0052_GET_SUMMARY_DATA","EXEC:DMF0052_GET_SUMMARY_DATA, SELECT:XIF_ERP_EDI_CALLOFF_ITEM_R_SN"
```

### FILE events.csv (8 rows)
```csv
"variant","file","class","member","line","target","event","handler","op"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","InitializeComponent","171","this.spdSummaryPJT","CellDoubleClick","spdPjt_CellDoubleClick","+="
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","InitializeComponent","218","this.btnRefresh","Click","BtnRefresh_Click","+="
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","InitializeComponent","255","this.chkToday","CheckedChanged","chkToday_CheckedChanged","+="
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","InitializeComponent","362","this.btnProject","Click","btnProject_Click","+="
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","InitializeComponent","399","this.btnItemId","Click","btnItemId_Click","+="
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","InitializeComponent","657","this.spdData","ActiveSheetChanging","spdData_ActiveSheetChanging","+="
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","InitializeComponent","658","this.spdData","CellDoubleClick","spdData_CellDoubleClick","+="
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary",".ctor","123","this","Load","Form_Load","+="
```

### FILE controls.csv (32 rows)
```csv
"variant","file","class","name","type","parent","line"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","splitContainer1","System.Windows.Forms.SplitContainer","this","35"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","splitContainer2","System.Windows.Forms.SplitContainer","splitContainer1.Panel1","36"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","spdSummary","FarPoint.Win.Spread.FpSpread","splitContainer2.Panel1","37"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","spdSummary_Sheet1","FarPoint.Win.Spread.SheetView","","38"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","spdSummaryPJT","FarPoint.Win.Spread.FpSpread","splitContainer2.Panel2","39"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","spdSummaryPJT_Sheet1","FarPoint.Win.Spread.SheetView","","40"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","usrConditionPanel1","GSCM.Windows.Forms.Controls.UsrConditionPanel","splitContainer1.Panel1","41"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","usrLayoutControl1","GSCM.Windows.Forms.Controls.UsrLayoutControl","usrConditionPanel1","42"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","btnRefresh","DevExpress.XtraEditors.SimpleButton","usrLayoutControl1","43"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","chkToday","GSCM.Windows.Forms.Controls.UsrCheckBox","usrLayoutControl1","44"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","txtItemId","GSCM.Windows.Forms.Controls.UsrMultiLineEditor","usrLayoutControl1","45"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","txtProject","GSCM.Windows.Forms.Controls.UsrMultiLineEditor","usrLayoutControl1","46"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","btnProject","GSCM.Windows.Forms.Controls.UsrButton","usrLayoutControl1","47"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","btnItemId","GSCM.Windows.Forms.Controls.UsrButton","usrLayoutControl1","48"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","drpPeriod","GSCM.Windows.Forms.Controls.UsrDateRangePicker","usrLayoutControl1","49"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","clbEDISender","GSCM.Windows.Forms.Controls.UsrCheckedList","usrLayoutControl1","50"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","layoutControlGroup1","DevExpress.XtraLayout.LayoutControlGroup","","51"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","emptySpaceItem3","DevExpress.XtraLayout.EmptySpaceItem","","52"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","layoutControlItem1","DevExpress.XtraLayout.LayoutControlItem","","53"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","lblProject","DevExpress.XtraLayout.LayoutControlItem","","54"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","layoutControlItem3","DevExpress.XtraLayout.LayoutControlItem","","55"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","lblModel","DevExpress.XtraLayout.LayoutControlItem","","56"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","layoutControlItem4","DevExpress.XtraLayout.LayoutControlItem","","57"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","Period","DevExpress.XtraLayout.LayoutControlItem","","58"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","lblEDISender","DevExpress.XtraLayout.LayoutControlItem","","59"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","layoutControlItem2","DevExpress.XtraLayout.LayoutControlItem","","60"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","splitContainer3","System.Windows.Forms.SplitContainer","splitContainer1.Panel2","61"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","spdSummaryStatus","FarPoint.Win.Spread.FpSpread","splitContainer3.Panel1","62"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","spdSummaryStatus_Sheet1","FarPoint.Win.Spread.SheetView","","63"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","spdData","FarPoint.Win.Spread.FpSpread","splitContainer3.Panel2","64"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","spdData_Sheet1","FarPoint.Win.Spread.SheetView","","65"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","imageList1","System.Windows.Forms.ImageList","","66"
```

### FILE grid_effective.csv (54 rows)
```csv
"sheet","sheet_rule","column","label","source","40","81","81_HD","81_HG","81_HM","81_ST","81_UC","82","EE","EE_HD","EE_HG","EE_HM","EE_ST","EE_UC"
"EDI Summary GSCM DATA Popup","코드 하드코딩 전용(메타 없음)","CODE_VALID_YN","Active","CODE","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?"
"EDI Summary GSCM DATA Popup","코드 하드코딩 전용(메타 없음)","COMPANY_ID","(ERP) Company","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"EDI Summary GSCM DATA Popup","코드 하드코딩 전용(메타 없음)","GSCM_CODE","(GSCM) Sold to / Ship to","CODE","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?"
"EDI Summary GSCM DATA Popup","코드 하드코딩 전용(메타 없음)","Message","Message","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"EDI Summary GSCM DATA Popup","코드 하드코딩 전용(메타 없음)","SCM_SITE_ID","(GSCM) Sales Site","CODE","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?"
"EDI Summary GSCM DATA Popup","코드 하드코딩 전용(메타 없음)","SENDER_NAME","(ERP) EDI Sender","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"EDI Summary GSCM DATA Popup","코드 하드코딩 전용(메타 없음)","SHIPTO_CODE","(ERP) Ship to","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"EDI Summary GSCM DATA Popup","코드 하드코딩 전용(메타 없음)","SOLDTO_CODE","(ERP) Sold to","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"EDI Summary GSCM DATA Popup","코드 하드코딩 전용(메타 없음)","VALID_YN","Active","CODE","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?","코드추가?"
"ERP Data","META+코드연결","COMPANY_ID","Company","META","","기본","","","","","","","","","","","",""
"ERP Data","META+코드연결","EDI_IF_SEQ","EDI_IF_SEQ","META","","기본","","","","","","","","","","","",""
"ERP Data","META+코드연결","ERP_STATUS","(ERP) Status","META","","기본","","","","","","","","","","","",""
"ERP Data","META+코드연결","GSCM_STATUS","Status","META","","기본","","","","","","","","","","","",""
"ERP Data","META+코드연결","ITEM_ID","Model","META","","기본","","","","","","","","","","","",""
"ERP Data","META+코드연결","NICK_NAME","Nickname","META","","기본","","","","","","","","","","","",""
"ERP Data","META+코드연결","SENDER_NAME","EDI Sender","META","","기본","","","","","","","","","","","",""
"ERP Data","META+코드연결","SHIPTO_CODE","Ship to","META","","기본","","","","","","","","","","","",""
"ERP Data","META+코드연결","SOLDTO_CODE","Sold to","META","","기본","","","","","","","","","","","",""
"ERP Data","META+코드연결","STATUS_DETAIL","Status Detail","META","","기본","","","","","","","","","","","",""
"GSCM Data","META+코드연결","CHECK_INCOTERMS","EDI Incoterms(SSPM)","META","","기본","","","","","","","","","","","",""
"GSCM Data","META+코드연결","CHECK_SALES_ACTIVE","Sales Site Active","META","","기본","","","","","","","","","","","",""
"GSCM Data","META+코드연결","CHECK_SALES_SITE","Sales Site 누락","META","","기본","","","","","","","","","","","",""
"GSCM Data","META+코드연결","CHECK_SSPM","SSPM 누락","META","","기본","","","","","","","","","","","",""
"GSCM Data","META+코드연결","CHECK_SSPM_ACTIVE","SSPM Active","META","","기본","","","","","","","","","","","",""
"GSCM Data","META+코드연결","ITEM_ID","Model","META","","기본","","","","","","","","","","","",""
"GSCM Data","META+코드연결","NICK_NAME","Nickname","META","","기본","","","","","","","","","","","",""
"GSCM Data","META+코드연결","PROJECT_CODE","Project Code","META","","기본","","","","","","","","","","","",""
"GSCM Data","META+코드연결","SENDER_CODE","EDI Sender Code","META","","기본","","","","","","","","","","","",""
"GSCM Data","META+코드연결","SENDER_NAME","EDI Sender","META","","기본","","","","","","","","","","","",""
"Site Popup","메타 정의만, 코드 미참조(미사용 가능)","CODE_VALID_YN","Active","META","","기본","","","","","","","","","","","",""
"Site Popup","메타 정의만, 코드 미참조(미사용 가능)","COMPANY_ID","Company","META","","기본","","","","","","","","","","","",""
"Site Popup","메타 정의만, 코드 미참조(미사용 가능)","GSCM_CODE","(GSCM) Sold to / Ship to","META","","기본","","","","","","","","","","","",""
"Site Popup","메타 정의만, 코드 미참조(미사용 가능)","MESSAGE","MESSAGE","META","","기본","","","","","","","","","","","",""
"Site Popup","메타 정의만, 코드 미참조(미사용 가능)","SCM_SITE_ID","(GSCM) Sales Site","META","","기본","","","","","","","","","","","",""
"Site Popup","메타 정의만, 코드 미참조(미사용 가능)","SENDER_NAME","EDI Sender","META","","기본","","","","","","","","","","","",""
"Site Popup","메타 정의만, 코드 미참조(미사용 가능)","SHIPTO_CODE","Ship to","META","","기본","","","","","","","","","","","",""
"Site Popup","메타 정의만, 코드 미참조(미사용 가능)","SOLDTO_CODE","Sold to","META","","기본","","","","","","","","","","","",""
"Site Popup","메타 정의만, 코드 미참조(미사용 가능)","VALID_YN","Active","META","","기본","","","","","","","","","","","",""
"SUMMARY","META+코드연결","RCV_CNT","GSCM 수신한 데이터 수","META","","기본","","","","","","","","","","","",""
"SUMMARY","META+코드연결","SEND_CNT","ERP전송 데이터 수","META","","기본","","","","","","","","","","","",""
"SUMMARY","META+코드연결","STATUS","Status","META","","기본","","","","","","","","","","","",""
"SUMMARY","META+코드연결","YYYYMMDD","날짜","META","","기본","","","","","","","","","","","",""
"Summary Pjt","META+코드연결","CHECK_ERP_CNT","ERP Data 확인 필요","META","","기본","","","","","","","","","","","",""
"Summary Pjt","META+코드연결","CHECK_GSCM_CNT","Master Data 정비 필요 건 수 (GSCM)","META","","기본","","","","","","","","","","","",""
"Summary Pjt","META+코드연결","COMPLETED_CNT","정상","META","","기본","","","","","","","","","","","",""
"Summary Pjt","META+코드연결","CREATION_DATE","최종 수신일","META","","기본","","","","","","","","","","","",""
"Summary Pjt","META+코드연결","PROJECT_CNT","수신한 데이터 수","META","","기본","","","","","","","","","","","",""
"Summary Pjt","META+코드연결","PROJECT_CODE","Project Code","META","","기본","","","","","","","","","","","",""
"Summary Pjt","META+코드연결","SENDER_CODE","EDI Sender Code","META","","기본","","","","","","","","","","","",""
"Summary Pjt","META+코드연결","SENDER_NAME","EDI Sender","META","","기본","","","","","","","","","","","",""
"Summary Status","META+코드연결","AVG_PERCENT","%","META","","기본","","","","","","","","","","","",""
"Summary Status","META+코드연결","QTY","Qty","META","","기본","","","","","","","","","","","",""
"Summary Status","META+코드연결","STATUS_ERP","Status ERP","META","","기본","","","","","","","","","","","",""
"Summary Status","META+코드연결","STATUS_GSCM","Status GSCM","META","","기본","","","","","","","","","","","",""
```

### FILE grid_code.csv (45 rows)
```csv
"variant","file","class","member","line","sheet_hint","kind","api","source","header","field","columns","args","arg_names","conditions","raw"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","CreateSpread","158","SUMMARY","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ SUMMARY ¦ SUMMARY ¦ 1 ¦ 1 ¦ 30","","","spdSummary ¦ SpdSheet.shtMain ¦ SpdSheet.shtMain ¦ 1 ¦ 1 ¦ 30"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","CreateSpread","159","SUMMARY","SHEET","GetSheetInfo","EXPR","","","","{?spdSummary.Name} ¦ {?spdSummary.ActiveSheetIndex}","","","spdSummary.Name ¦ spdSummary.ActiveSheetIndex"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","CreateSpread","162","Summary Pjt","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ Summary Pjt ¦ Summary Pjt ¦ 1 ¦ 1 ¦ 30","","","spdSummaryPJT ¦ SpdSheet.shtPjt ¦ SpdSheet.shtPjt ¦ 1 ¦ 1 ¦ 30"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","CreateSpread","163","Summary Pjt","SHEET","GetSheetInfo","EXPR","","","","{?spdSummaryPJT.Name} ¦ {?spdSummaryPJT.ActiveSheetIndex}","","","spdSummaryPJT.Name ¦ spdSummaryPJT.ActiveSheetIndex"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","CreateSpread","166","Summary Status","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ Summary Status ¦ Summary Status ¦ 1 ¦ 1 ¦ 30","","","spdSummaryStatus ¦ SpdSheet.shtStatus ¦ SpdSheet.shtStatus ¦ 1 ¦ 1 ¦ 30"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","CreateSpread","167","Summary Status","SHEET","GetSheetInfo","EXPR","","","","{?spdSummaryStatus.Name} ¦ {?spdSummaryStatus.ActiveSheetIndex}","","","spdSummaryStatus.Name ¦ spdSummaryStatus.ActiveSheetIndex"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","CreateSpread","170","GSCM Data","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ GSCM Data ¦ GSCM Data ¦ 1 ¦ 1 ¦ 30","","","spdData ¦ SpdSheet.shtDetail ¦ SpdSheet.shtDetail ¦ 1 ¦ 1 ¦ 30"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","CreateSpread","171","ERP Data","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ ERP Data ¦ ERP Data ¦ 1 ¦ 1 ¦ 30","","","spdData ¦ SpdSheet.shtErp ¦ SpdSheet.shtErp ¦ 1 ¦ 1 ¦ 30"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","CreateSpread","173","GSCM Data","SHEET","GetSheetInfo","HARDCODED","","","","{?spdData.Name} ¦ GSCM Data","","","spdData.Name ¦ SpdSheet.shtDetail"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","CreateSpread","174","ERP Data","SHEET","GetSheetInfo","HARDCODED","","","","{?spdData.Name} ¦ ERP Data","","","spdData.Name ¦ SpdSheet.shtErp"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","CreateSpread","176","GSCM Data","SHEET","ChangeSheet","HARDCODED","","","","GSCM Data","","","SpdSheet.shtDetail"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","CreateSpread","179","ERP Data","SHEET","ChangeSheet","HARDCODED","","","","ERP Data","","","SpdSheet.shtErp"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","CreateSpread","182","GSCM Data","SHEET","ChangeSheet","HARDCODED","","","","GSCM Data","","","SpdSheet.shtDetail"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","CreateSpread","186","GSCM Data","SHEET","ChangeSheet","EXPR","","","","","","",""
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","InitSpread","192","","META_BUILD","CreateSheetHeaderColumn","EXPR","","","","{p:spreadInfo} ¦ 1 ¦ {?GetSpdTitle(spreadInfo.ActiveSheet.SheetName)}","siObj,iColumnHeaderRowCount,dtSheetColumnConfig","","spreadInfo ¦ 1 ¦ dtTitle"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","FindData_Main","272","GSCM Data","SHEET","ChangeSheet","HARDCODED","","","","GSCM Data","","","SpdSheet.shtDetail"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","FindData_Main","275","ERP Data","SHEET","ChangeSheet","HARDCODED","","","","ERP Data","","","SpdSheet.shtErp"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","spdPjt_CellDoubleClick","596","GSCM Data","SHEET","ChangeSheet","HARDCODED","","","","GSCM Data","","if(siPjt.IsLock(siPjt.SheetName) == true) ⟫ if((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(""CHECK_GSCM_CNT"")) && siPjt.GetText(e.Row, siPjt.GetColumnIndex(""CHECK_GSCM_CNT"")) != ""0"") || (siPjt.GetColumnTag(e.Column) == …)","SpdSheet.shtDetail"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","spdPjt_CellDoubleClick","597","GSCM Data","SHEET","ChangeActiveSheet","HARDCODED","","","","GSCM Data","sSheetName","if(siPjt.IsLock(siPjt.SheetName) == true) ⟫ if((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(""CHECK_GSCM_CNT"")) && siPjt.GetText(e.Row, siPjt.GetColumnIndex(""CHECK_GSCM_CNT"")) != ""0"") || (siPjt.GetColumnTag(e.Column) == …)","SpdSheet.shtDetail"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","spdPjt_CellDoubleClick","603","ERP Data","SHEET","ChangeSheet","HARDCODED","","","","ERP Data","","if(siPjt.IsLock(siPjt.SheetName) == true) ⟫ if((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(""CHECK_GSCM_CNT"")) && siPjt.GetText(e.Row, siPjt.GetColumnIndex(""CHECK_GSCM_CNT"")) != ""0"") || (siPjt.GetColumnTag(e.Column) == …)","SpdSheet.shtErp"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","spdPjt_CellDoubleClick","604","ERP Data","SHEET","ChangeActiveSheet","HARDCODED","","","","ERP Data","sSheetName","if(siPjt.IsLock(siPjt.SheetName) == true) ⟫ if((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(""CHECK_GSCM_CNT"")) && siPjt.GetText(e.Row, siPjt.GetColumnIndex(""CHECK_GSCM_CNT"")) != ""0"") || (siPjt.GetColumnTag(e.Column) == …)","SpdSheet.shtErp"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","spdPjt_CellDoubleClick","611","ERP Data","SHEET","ChangeSheet","EXPR","","","","{?string.Empty} || GSCM Data || ERP Data","","if(siPjt.IsLock(siPjt.SheetName) == true) ⟫ if((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(""CHECK_GSCM_CNT"")) && siPjt.GetText(e.Row, siPjt.GetColumnIndex(""CHECK_GSCM_CNT"")) != ""0"") || (siPjt.GetColumnTag(e.Column) == …)","_sActiveSheetName"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","spdPjt_CellDoubleClick","612","ERP Data","SHEET","ChangeActiveSheet","EXPR","","","","{?string.Empty} || GSCM Data || ERP Data","sSheetName","if(siPjt.IsLock(siPjt.SheetName) == true) ⟫ if((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(""CHECK_GSCM_CNT"")) && siPjt.GetText(e.Row, siPjt.GetColumnIndex(""CHECK_GSCM_CNT"")) != ""0"") || (siPjt.GetColumnTag(e.Column) == …)","_sActiveSheetName"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs","DMF0052_EDISummary","spdData_CellDoubleClick","639","","SHEET","ChangeSheet","EXPR","","","","","","if(siPjt.IsLock(siPjt.SheetName))",""
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","InitializeComponent","674","","OVERRIDE","set:HorizontalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellHorizontalAlignment.General}","HorizontalAlignment","","FarPoint.Win.Spread.CellHorizontalAlignment.General"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","InitializeComponent","675","","OVERRIDE","set:NoteIndicatorColor","EXPR","","","","{?System.Drawing.Color.Red}","NoteIndicatorColor","","System.Drawing.Color.Red"
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","InitializeComponent","676","","OVERRIDE","set:Parent","HARDCODED","","","","ColumnHeaderDefaultEnhanced","Parent","","""ColumnHeaderDefaultEnhanced"""
"current","06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs","DMF0052_EDISummary","InitializeComponent","677","","OVERRIDE","set:VerticalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellVerticalAlignment.General}","VerticalAlignment","","FarPoint.Win.Spread.CellVerticalAlignment.General"
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs","DMF0052_GSCMDataPopup","CreateSpread","129","EDI Summary GSCM DATA Popup","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ EDI Summary GSCM DATA Popup ¦ EDI Summary GSCM DATA Popup ¦ 1 ¦ 1 ¦ 30","","","spdMain ¦ SpdSheet.shtMain ¦ SpdSheet.shtMain ¦ 1 ¦ 1 ¦ 30"
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs","DMF0052_GSCMDataPopup","CreateSpread","130","EDI Summary GSCM DATA Popup","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ {?spdMain.ActiveSheetIndex}","","","spdMain.Name ¦ spdMain.ActiveSheetIndex"
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs","DMF0052_GSCMDataPopup","CreateSpread","132","EDI Summary GSCM DATA Popup","SHEET","ChangeSheet","EXPR","","","","","","",""
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs","DMF0052_GSCMDataPopup","InitSpread","140","","SHEET","InitSheet","EXPR","","","","{?siMain.SheetName}","","","siMain.SheetName"
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs","DMF0052_GSCMDataPopup","InitSpread","144","","COLUMN","AddTextColumn","HARDCODED","(ERP) EDI Sender","SENDER_NAME","","(ERP) EDI Sender ¦ SENDER_NAME ¦ {?FPMerge.Restricted} ¦ 100 ¦ {?true} ¦ {?FPHAlign.Left} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","","""(ERP) EDI Sender"" ¦ DefColumns.EDISender ¦ FPMerge.Restricted ¦ 100 ¦ true ¦ FPHAlign.Left ¦ FPVAlign.Center"
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs","DMF0052_GSCMDataPopup","InitSpread","145","","COLUMN","AddTextColumn","HARDCODED","(ERP) Company","COMPANY_ID","","(ERP) Company ¦ COMPANY_ID ¦ {?FPMerge.Restricted} ¦ 100 ¦ {?true} ¦ {?FPHAlign.Left} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","","""(ERP) Company"" ¦ DefColumns.Company ¦ FPMerge.Restricted ¦ 100 ¦ true ¦ FPHAlign.Left ¦ FPVAlign.Center"
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs","DMF0052_GSCMDataPopup","InitSpread","146","","COLUMN","AddTextColumn","HARDCODED","(ERP) Sold to","SOLDTO_CODE","","(ERP) Sold to ¦ SOLDTO_CODE ¦ {?FPMerge.Restricted} ¦ 100 ¦ {?true} ¦ {?FPHAlign.Left} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","","""(ERP) Sold to"" ¦ DefColumns.SoldTo ¦ FPMerge.Restricted ¦ 100 ¦ true ¦ FPHAlign.Left ¦ FPVAlign.Center"
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs","DMF0052_GSCMDataPopup","InitSpread","147","","COLUMN","AddTextColumn","HARDCODED","(ERP) Ship to","SHIPTO_CODE","","(ERP) Ship to ¦ SHIPTO_CODE ¦ {?FPMerge.Restricted} ¦ 100 ¦ {?true} ¦ {?FPHAlign.Left} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","","""(ERP) Ship to"" ¦ DefColumns.ShipTo ¦ FPMerge.Restricted ¦ 100 ¦ true ¦ FPHAlign.Left ¦ FPVAlign.Center"
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs","DMF0052_GSCMDataPopup","InitSpread","150","","COLUMN","AddTextColumn","HARDCODED","(GSCM) Sales Site","SCM_SITE_ID","","(GSCM) Sales Site ¦ SCM_SITE_ID ¦ {?FPMerge.Restricted} ¦ 100 ¦ {?true} ¦ {?FPHAlign.Left} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","if(PopupType != ""CHECK_SALES_SITE"")","""(GSCM) Sales Site"" ¦ DefColumns.SalesSite ¦ FPMerge.Restricted ¦ 100 ¦ true ¦ FPHAlign.Left ¦ FPVAlign.Center"
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs","DMF0052_GSCMDataPopup","InitSpread","151","","COLUMN","AddTextColumn","HARDCODED","Active","VALID_YN","","Active ¦ VALID_YN ¦ {?FPMerge.Restricted} ¦ 50 ¦ {?true} ¦ {?FPHAlign.Left} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","if(PopupType != ""CHECK_SALES_SITE"")","""Active"" ¦ DefColumns.Active ¦ FPMerge.Restricted ¦ 50 ¦ true ¦ FPHAlign.Left ¦ FPVAlign.Center"
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs","DMF0052_GSCMDataPopup","InitSpread","152","","COLUMN","AddTextColumn","HARDCODED","(GSCM) Sold to / Ship to","GSCM_CODE","","(GSCM) Sold to / Ship to ¦ GSCM_CODE ¦ {?FPMerge.Restricted} ¦ 150 ¦ {?true} ¦ {?FPHAlign.Left} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","if(PopupType != ""CHECK_SALES_SITE"")","""(GSCM) Sold to / Ship to"" ¦ DefColumns.GscmCode ¦ FPMerge.Restricted ¦ 150 ¦ true ¦ FPHAlign.Left ¦ FPVAlign.Center"
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs","DMF0052_GSCMDataPopup","InitSpread","153","","COLUMN","AddTextColumn","HARDCODED","Active","CODE_VALID_YN","","Active ¦ CODE_VALID_YN ¦ {?FPMerge.Restricted} ¦ 50 ¦ {?true} ¦ {?FPHAlign.Left} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","if(PopupType != ""CHECK_SALES_SITE"")","""Active"" ¦ DefColumns.CodeActive ¦ FPMerge.Restricted ¦ 50 ¦ true ¦ FPHAlign.Left ¦ FPVAlign.Center"
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs","DMF0052_GSCMDataPopup","InitSpread","155","","COLUMN","AddTextColumn","HARDCODED","Message","Message","","Message ¦ Message ¦ {?FPMerge.Restricted} ¦ 350 ¦ {?true} ¦ {?FPHAlign.Left} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","","""Message"" ¦ DefColumns.Message ¦ FPMerge.Restricted ¦ 350 ¦ true ¦ FPHAlign.Left ¦ FPVAlign.Center"
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.Designer.cs","DMF0052_GSCMDataPopup","InitializeComponent","243","","OVERRIDE","set:HorizontalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellHorizontalAlignment.General}","HorizontalAlignment","","FarPoint.Win.Spread.CellHorizontalAlignment.General"
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.Designer.cs","DMF0052_GSCMDataPopup","InitializeComponent","244","","OVERRIDE","set:NoteIndicatorColor","EXPR","","","","{?System.Drawing.Color.Red}","NoteIndicatorColor","","System.Drawing.Color.Red"
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.Designer.cs","DMF0052_GSCMDataPopup","InitializeComponent","245","","OVERRIDE","set:Parent","HARDCODED","","","","ColumnHeaderDefaultEnhanced","Parent","","""ColumnHeaderDefaultEnhanced"""
"shared","06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.Designer.cs","DMF0052_GSCMDataPopup","InitializeComponent","246","","OVERRIDE","set:VerticalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellVerticalAlignment.General}","VerticalAlignment","","FarPoint.Win.Spread.CellVerticalAlignment.General"
```

### FILE meta_reads.csv (0 rows)
```csv
"variant","file","class","member","line","receiver","column","via"
```

### FILE commented_calls.csv (0 rows)
```csv
"variant","file","line","kind","candidate","key","status"
```
