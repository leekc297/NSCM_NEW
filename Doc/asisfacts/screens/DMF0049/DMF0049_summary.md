# DMF0049 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0049_Sales_ETC_Reports\DMF0049_Sales_ETC_Reports.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0049_Sales_ETC_Reports\DMF0049_Sales_ETC_Reports.csproj | 1728 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0049_Sales_ETC_Reports\DMF0049_Sales_ETC_Reports.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0049_Sales_ETC_Reports\DMF0049_Sales_ETC_Reports.csproj | 599 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0049_Sales_ETC_Reports\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0049_Sales_ETC_Reports\DMF0049_Sales_ETC_Reports.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0049_Sales_ETC_Reports\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0049_Sales_ETC_Reports\DMF0049_Sales_ETC_Reports.csproj | 72 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0049_Sales_ETC_Reports\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0049_Sales_ETC_Reports\DMF0049_Sales_ETC_Reports.csproj | 31 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0049_Sales_ETC_Reports.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1649 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0049_Sales_ETC_Reports.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 599 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbType.SelectedIndexChanged | clbType_SelectedIndexChanged > InitSpread | 254 | DM.DMF0049_GET_SPREAD_TITLE | MATCH | SP DMF0049_GET_SPREAD_TITLE |
| event:dsdm.Changed | spdMain_Changed > GetLookupData | 1130 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:dsdm.Changed | spdMain_Changed | 1268 | biz:CommonData.CommonDataList [code=DMF0044_DEPARTMENT_TEAM] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 1294 | biz:CommonData.CommonDataList [code=DMF0044_DEPARTMENT_TEAM2] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 1337 | biz:CommonData.CommonDataList [code=EndCustReport] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 1346 | biz:CommonData.CommonDataList [code=DMF0005_REPORT_GROUP2] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 1367 | biz:CommonData.CommonDataList [code=DMF0005_REPORT_GROUP2] | BIZ_MATCH |  |
| button:EditButton | EditButton | 350 | biz:CommonData.CommonDataList [code=DM_LOOKUP_DIV] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > InitSpread | 254 | DM.DMF0049_GET_SPREAD_TITLE | MATCH | SP DMF0049_GET_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 549 | DM.DMF0049_GET_SALES_ETC_REPORTS_DATA | MATCH | SP DMF0049_GET_SALES_ETC_REPORTS_DATA |
| button:InsertButton | InsertButton > InsertRow | 951 | biz:CommonData.CommonDataList [code=DM_LOOKUP_DIV] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 958 | biz:CommonData.CommonDataList [code=DMF0044_DEPARTMENT_TEAM2] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread | 254 | DM.DMF0049_GET_SPREAD_TITLE | MATCH | SP DMF0049_GET_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData | 549 | DM.DMF0049_GET_SALES_ETC_REPORTS_DATA | MATCH | SP DMF0049_GET_SALES_ETC_REPORTS_DATA |
| button:SaveButton | SaveButton > SaveData | 849 | DM.DMF0049_SAVE_SALES_ETC_REPORT_C | MATCH | SP DMF0049_SAVE_SALES_ETC_REPORT_C |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread | 254 | DM.DMF0049_GET_SPREAD_TITLE | MATCH | SP DMF0049_GET_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread | 254 | DM.DMF0049_GET_SPREAD_TITLE | MATCH | SP DMF0049_GET_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > GetMeasure | 1145 | DM.DMF0049_GET_MEASURE | MATCH | SP DMF0049_GET_MEASURE |
| event:this.clbPlanResult.SelectedIndexChanged | clbPlanResult_SelectedIndexChanged > InitSpread | 254 | DM.DMF0049_GET_SPREAD_TITLE | MATCH | SP DMF0049_GET_SPREAD_TITLE |
| event:this.clbType.SelectedIndexChanged | clbType_SelectedIndexChanged > InitSpread | 254 | DM.DMF0049_GET_SPREAD_TITLE | MATCH | SP DMF0049_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > CreateSpread > InitSpread | 254 | DM.DMF0049_GET_SPREAD_TITLE | MATCH | SP DMF0049_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetLookupData | 1130 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls > GetMeasure | 1145 | DM.DMF0049_GET_MEASURE | MATCH | SP DMF0049_GET_MEASURE |
| event:this.Load | Form_Load > InitControls > YearSet > GetCalendarYYYY | 1184 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.spdMain.CellClick | spdMain_CellClick | 1597 | biz:CommonData.CommonDataList [code=DMF0005_REPORT_GROUP2] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=DM_LOOKUP_DIV] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DMF0005_REPORT_GROUP2] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DMF0044_DEPARTMENT_TEAM] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO |
| biz:CommonData.CommonDataList [code=DMF0044_DEPARTMENT_TEAM2] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=EndCustReport] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM.DMF0049_GET_MEASURE | MATCH | 1 | SP DMF0049_GET_MEASURE | EXEC:DMF0049_GET_MEASURE, SELECT:SCM_MST_SHEET_MEASURE |  |
| DM.DMF0049_GET_SALES_ETC_REPORTS_DATA | MATCH | 1 | SP DMF0049_GET_SALES_ETC_REPORTS_DATA | EXEC:DMF0049_GET_SALES_ETC_REPORTS_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:TB_FX_USER, SELECT:SCM_MST_TITLESET_USER, INSERT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#SELECT_MEASURE, INSERT:#PJT, SELECT:SCM_MST_PROJECT, INSERT:#TEMP, SELECT:DM_PLN_SALES_ETC_REPORT_C, SELECT:SCM_MST_SITE_ITEM, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_SITE, SELECT:SCM_MST_COUNTRY, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:#PJT, SELECT:SCM_SYS_CALENDAR_M, EXEC:SP_EXECUTESQL |  |
| DM.DMF0049_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0049_GET_SPREAD_TITLE | EXEC:DMF0049_GET_SPREAD_TITLE, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DMF0049_SAVE_SALES_ETC_REPORT_C | MATCH | 1 | SP DMF0049_SAVE_SALES_ETC_REPORT_C | EXEC:DMF0049_SAVE_SALES_ETC_REPORT_C, CREATE:#RESULTS_MST, EXEC:PR_DM_SYS_LOG_BATCH, INSERT:#RESULTS_MST, SELECT:#RESULTS_MST, SELECT:NERP_CONV_MASTER, UPDATE:#RESULTS_MST, DELETE:#RESULTS_MST, INSERT:#RESULTS_MST_PRICE, SELECT:#RESULTS_MST_PRICE, SELECT:SCM_SYS_CALENDAR_M, REF:FN_GET_COUNTRY_KR_NAME, SELECT:DM_PLN_SALES_ETC_REPORT_C, SELECT:DM_MDF_VERSION, SELECT:DM_MST_VERSION, DELETE:A, UPDATE:A, INSERT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE_ITEM, SELECT:#TEMP_DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_SITE, SELECT:SCM_MST_COUNTRY, REF:FN_GET_DM_MKT_OWNER_NAME, INSERT:DM_PLN_SALES_ETC_REPORT_C, INSERT:DM_PLN_SALES_ETC_REPORT_H, EXEC:DMF0044_MOBILE_REPORT_CREATE, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_DIVISION, UPDATE:DM_MDF_VERSION, DELETE:DM_PLN_SALES_PLAN_REPORT_C, INSERT:DM_PLN_SALES_PLAN_REPORT_C, EXEC:DMF0044_SALES_REPORT_PRODUCT_CREATE, EXEC:DMF0044_SALES_REPORT_DEPT_CREATE, EXEC:DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE, SELECT:DM_MOBILE_REPORT_PRODUCT, DELETE:DM_MOBILE_REPORT_PRODUCT, INSERT:#TEMP_REPORT_C, SELECT:DM_PLN_SALES_PLAN_REPORT_C, INSERT:DM_MOBILE_REPORT_PRODUCT, SELECT:#TEMP_REPORT_C, SELECT:DM_MOBILE_REPORT_DEPT, DELETE:DM_MOBILE_REPORT_DEPT, INSERT:DM_MOBILE_REPORT_DEPT, SELECT:DM_MOBILE_REPORT_EXCHANGE_RATE, DELETE:DM_MOBILE_REPORT_EXCHANGE_RATE, INSERT:#TEMP_EXCHANGE_C, SELECT:DM_PLN_SALES_REPORT_EXCHANGE_C, INSERT:DM_MOBILE_REPORT_EXCHANGE_RATE, SELECT:#TEMP_EXCHANGE_C |  |
| DM.UP_FX_GetCommonDataList_DM | MATCH | 1 | SP UP_FX_GETCOMMONDATALIST_DM | EXEC:UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_PLANT_SN |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| EditButton | UserInfoContext.Current | NowGroupID |
| FindData | UserInfoContext.Current | NowGroupID |
| InsertRow | UserInfoContext.Current | NowGroupID |
| InsertRow | dtMeasure.Rows[i] | CODE |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| spdMain_Changed | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:174, SetChangeControl:182 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| FP_Log2 | InitControls:194, InitControls:217 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetMeasure | InitControls:221, clbDivision_SelectedIndexChanged:1560 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| CreateSheetHeaderColumnDtDiv | InitSpread:265 | SpreadInfo.CreateSheetHeaderColumnDtDiv | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:467 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnSPVer | Click | btnSPVer_Click | InitializeComponent:190 |
| this.clbType | SelectedIndexChanged | clbType_SelectedIndexChanged | InitializeComponent:225 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:296 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:331 |
| this.clbPlanResult | SelectedIndexChanged | clbPlanResult_SelectedIndexChanged | InitializeComponent:369 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:536 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:537 |
| this | Load | Form_Load | .ctor:143 |
| clbType | SelectedIndexChanged | clbType_SelectedIndexChanged | InitControls:203 |
| clbType | SelectedIndexChanged | clbType_SelectedIndexChanged | InitControls:225 |
| dsdm | Changed | spdMain_Changed | DefineProperty:234 |

## 6. 컨트롤 (22개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | lblSPVersion, layoutControlItem1, lblType, lblYear, layoutControlItem4, lblDivision, lblType1 |
| UsrCombo | 4 | clbType, usrYear, clbDivision, clbPlanResult |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 2 | btnSPVer, btnMeasure |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrMultiLineEditor | 1 | txtSPVersion |
| EmptySpaceItem | 1 | emptySpaceItem1 |
| SheetView | 1 | spdMain_Sheet1 |
| FpSpread | 1 | spdMain |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 167 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 42 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 3 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 37 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 8 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0049 | MDF Reports | 23/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 14/0 | · | · | · | · | · | · |
| SCM_MST_SHEET_MEASURE | DMF0049 | MDF Reports | 3/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 1/0 | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 75건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: MDF Reports
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumnDtDiv@InitSpread:265

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| DefineProperty |  | 236 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DEPARTMENT_ID |  |
| DefineProperty |  | 237 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DEPT_ID |  |
| EditButton |  | 391 | 표시/라벨 변경 | set:Visible | Visible = {?true} | DEPARTMENT_ID | if(this.fps != null) |
| EditButton |  | 392 | 표시/라벨 변경 | set:Visible | Visible = {?true} | DEPT_ID | if(this.fps != null) |
| EditButton |  | 393 | 표시/라벨 변경 | set:Visible | Visible = {?false} | T_DEPARTMENT_ID | if(this.fps != null) |
| EditButton |  | 394 | 표시/라벨 변경 | set:Visible | Visible = {?false} | T_DEPT_ID | if(this.fps != null) |
| FindData |  | 571 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DEPARTMENT_ID |  |
| FindData |  | 572 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DEPT_ID |  |
| InsertRow |  | 946 | 표시/라벨 변경 | set:Visible | Visible = {?true} | DEPARTMENT_ID | if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.SheetName == "MDF Reports") |
| InsertRow |  | 947 | 표시/라벨 변경 | set:Visible | Visible = {?true} | DEPT_ID | if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.SheetName == "MDF Reports") |
| InsertRow |  | 948 | 표시/라벨 변경 | set:Visible | Visible = {?false} | T_DEPARTMENT_ID | if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.SheetName == "MDF Reports") |
| InsertRow |  | 949 | 표시/라벨 변경 | set:Visible | Visible = {?false} | T_DEPT_ID | if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.SheetName == "MDF Reports") |
| InitializeComponent |  | 500 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 501 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 502 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 503 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| MDF Reports | META+코드연결 | 21 (?4) | 15 (?4) | 15 (?4) | 15 (?4) | 15 (?4) | 15 (?4) | 15 (?4) | 12 (?4) | 2 (?4) | 2 (?4) | 2 (?4) | 2 (?4) | 2 (?4) | 2 (?4) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 정적평가 미지원식 112 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 112건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
