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
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 12 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 45 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 2 | dbmeta_dbo_TB_FX_SearchCondition.csv |

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
