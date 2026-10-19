# DMF0041 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0041_MDF_Simulator\DMF0041_MDF_Simulator.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0041_MDF_Simulator\DMF0041_MDF_Simulator.csproj | 1181 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0041_MDF_Simulator\DMF0041_MDF_Simulator.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0041_MDF_Simulator\DMF0041_MDF_Simulator.csproj | 810 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0041_MDF_Simulator\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0041_MDF_Simulator\DMF0041_MDF_Simulator.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0041_MDF_Simulator\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0041_MDF_Simulator\DMF0041_MDF_Simulator.csproj | 72 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0041_MDF_Simulator\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0041_MDF_Simulator\DMF0041_MDF_Simulator.csproj | 31 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0041_DMS_SalesSet_Popup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 642 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0041_DMS_SalesSet_Popup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 431 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0041_MDF_Simulator.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1181 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0041_MDF_Simulator.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 810 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > GetOwnerData | 301 | DM.DMF0041_GET_DMS_SAELS_POPUP | MATCH | SP DMF0041_GET_DMS_SAELS_POPUP |
| button:FindButton | FindButton > GetApplication | 338 | DM.DMF0041_GET_APPLICATION_POPUP | MATCH | SP DMF0041_GET_APPLICATION_POPUP |
| button:FindButton | FindButton > FindData | 388 | DM.DMF0041_GET_MDF_SIMULTATOR | MATCH | SP DMF0041_GET_MDF_SIMULTATOR |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 964 | DM.DMF0041_GET_SPREAD_TITLE | MATCH | SP DMF0041_GET_SPREAD_TITLE |
| button:InsertButton | InsertButton > InsertRow | 667 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 670 | biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow > GetUnitCurrency | 1009 | DM.DMF0041_GET_MEASURE_UNIT_CURRENCY | MATCH | SP DMF0041_GET_MEASURE_UNIT_CURRENCY |
| button:SaveButton | SaveButton > SaveData > FindData | 388 | DM.DMF0041_GET_MDF_SIMULTATOR | MATCH | SP DMF0041_GET_MDF_SIMULTATOR |
| button:SaveButton | SaveButton > SaveData | 600 | DM.DMF0041_SAVE_MDF_SIMULTATOR | MATCH | SP DMF0041_SAVE_MDF_SIMULTATOR |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 964 | DM.DMF0041_GET_SPREAD_TITLE | MATCH | SP DMF0041_GET_SPREAD_TITLE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > GetOwnerData | 301 | DM.DMF0041_GET_DMS_SAELS_POPUP | MATCH | SP DMF0041_GET_DMS_SAELS_POPUP |
| event:this.Load | Form_Load > InitControls | 108 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 113 | biz:CommonData.CommonDataList [code=DMF0041_MDF_Team] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 116 | biz:CommonData.CommonDataList [code=APPLICATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 122 | biz:CommonData.CommonDataList [code=DMF0041_MDF_Measure] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 240 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > GetOwnerData | 301 | DM.DMF0041_GET_DMS_SAELS_POPUP | MATCH | SP DMF0041_GET_DMS_SAELS_POPUP |
| event:this.Load | Form_Load > GetApplication | 338 | DM.DMF0041_GET_APPLICATION_POPUP | MATCH | SP DMF0041_GET_APPLICATION_POPUP |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 964 | DM.DMF0041_GET_SPREAD_TITLE | MATCH | SP DMF0041_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetItemType | 981 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls > GetDayRange | 995 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 946 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=APPLICATION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=DMF0041_MDF_Measure] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_MEASURE |
| biz:CommonData.CommonDataList [code=DMF0041_MDF_Team] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DMF0000_GET_COMMON_SPREAD_TITLE | EXEC:DMF0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0041_GET_APPLICATION_POPUP | MATCH | 1 | SP DMF0041_GET_APPLICATION_POPUP | EXEC:DMF0041_GET_APPLICATION_POPUP, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT |  |
| DM.DMF0041_GET_DMS_SAELS_POPUP | MATCH | 1 | SP DMF0041_GET_DMS_SAELS_POPUP | EXEC:DMF0041_GET_DMS_SAELS_POPUP, SELECT:SCM_MST_SITE_ITEM, REF:STRING_SPLIT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0041_GET_MDF_SIMULTATOR | MATCH | 1 | SP DMF0041_GET_MDF_SIMULTATOR | EXEC:DMF0041_GET_MDF_SIMULTATOR, INSERT:#SALES_PLAN_C, SELECT:DM_PLN_SALES_PLAN_C, INSERT:#SALES_PLAN_RESULT_C, SELECT:DM_PLN_SALES_PLAN_RESULT_C, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:TB_FX_USER, INSERT:#MIDDLE_SUM, SELECT:MIDDLE_SUMMARY, SELECT:DM_PLN_MDF_SIMULATOR_DATA, REF:STRING_SPLIT, SELECT:DM_PLN_SALES_PLAN, SELECT:SCM_MST_SITE_ITEM, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:DM_PLN_SALES_PLAN_RESULT, SELECT:#SALES_PLAN_C, SELECT:#SALES_PLAN_RESULT_C, INSERT:#TEMP, SELECT:#MIDDLE_SUM, SELECT:MIDDLE_SUMMARY2, SELECT:MIDDLE_SUMMARY3, INSERT:#TEMP2, SELECT:#TEMP, SELECT:SCM_SYS_CALENDAR_M, EXEC:SP_EXECUTESQL |  |
| DM.DMF0041_GET_MEASURE_UNIT_CURRENCY | MATCH | 1 | SP DMF0041_GET_MEASURE_UNIT_CURRENCY | EXEC:DMF0041_GET_MEASURE_UNIT_CURRENCY, SELECT:SCM_MST_SHEET_MEASURE |  |
| DM.DMF0041_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0041_GET_SPREAD_TITLE | EXEC:DMF0041_GET_SPREAD_TITLE, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DMF0041_SAVE_MDF_SIMULTATOR | MATCH | 1 | SP DMF0041_SAVE_MDF_SIMULTATOR | EXEC:DMF0041_SAVE_MDF_SIMULTATOR, CREATE:#RESULTS_MST, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#RESULTS_MST, SELECT:DM_PLN_MDF_SIMULATOR_DATA, SELECT:#RESULTS_MST, DELETE:DM_PLN_MDF_SIMULATOR_DATA, INSERT:DM_PLN_MDF_SIMULATOR_DATA, INSERT:DM_PLN_MDF_SIMULATOR_DATA_H, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| EditButton | dtMeasureCount.Rows[i] | NAME, CODE |
| FindData | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InsertRow | UserInfoContext.Current | NowGroupID |
| InsertRow | dtMeasureCount.Rows[i] | NAME, CODE |
| SaveData | nvc | p_active_flag, p_MDF_VERSION_NO, p_DIVISION_ID, p_DEPARTMENT_ID, p_DMS_CUSTOMER, p_DMS_SALES, p_APPLICATION, p_BIZ_TYPE, p_ITEM_TYPE, p_MEASURE, p_UNIT_CURRENCY, p_YYYYMM, p_QTY |
| SetTitleSet | svSource.Columns | SUB_TOTAL_FLAG |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |
| spdUser_ButtonClicked | sv.Columns | SUB_TOTAL_FLAG |
| spdUser_RowDragMove | sv.Columns | USER_SELECTABLE_FLAG |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:111, FindData:343, FindData:344, FindData:345, FindData:346, btnMDFVer_Click:801, btnSPVer_Click:818, spdMain_CellDoubleClick:841 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:158, InitSpread:182 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:159, InitSpread:183 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:328 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| LoadData | btnMDFVersion_Click:1170 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:249 |
| this.btnMDFVersion | Click | btnMDFVersion_Click | InitializeComponent:286 |
| this.btnMDFVer | Click | btnMDFVer_Click | InitializeComponent:322 |
| this.btnSPVer | Click | btnSPVer_Click | InitializeComponent:358 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:687 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:688 |
| this | Load | Form_Load | .ctor:89 |
| dsdm | Changed | shtMain_Changed | DefineProperty:136 |
| clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | DefineProperty:138 |
| this.usrButtonList1 | UsrButtonList_Click_Detected | usrButtonList1_UsrButtonList_Click_Detected | InitializeComponent:158 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:210 |
| this.spdBase | CellDoubleClick | spdBase_CellDoubleClick | InitializeComponent:310 |
| this.spdUser | RowDragMove | spdUser_RowDragMove | InitializeComponent:329 |
| this.spdUser | RowDragMoveCompleted | spdUser_RowDragMoveCompleted | InitializeComponent:330 |
| this.spdUser | CellDoubleClick | spdUser_CellDoubleClick | InitializeComponent:331 |
| this.spdUser | ButtonClicked | spdUser_ButtonClicked | InitializeComponent:332 |
| this.btnRight | Click | btnRight_Click | InitializeComponent:365 |
| this.btnLeft | Click | btnLeft_Click | InitializeComponent:375 |
| this | Load | Form_Load | InitializeComponent:389 |
| this | SizeChanged | TitleSetForm_SizeChanged | InitializeComponent:390 |

## 6. 컨트롤 (47개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 10 | lblTeam, lblApplication, lblDivision, layoutControlItem7, layoutControlItem3, layoutControlItem1, lblMDFVersion, lblSPVersion, lblModelType, lbDate |
| Panel | 4 | pnlBottom, pnlSearch, pnlCenter, pnlCenterButton |
| UsrCheckedList | 3 | clbApplication, clbTeam, clbModelType |
| UsrButton | 3 | btnMDFVersion, btnMDFVer, btnSPVer |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem3, emptySpaceItem2 |
| FpSpread | 3 | spdMain, spdBase, spdUser |
| SheetView | 3 | spdMain_Sheet1, spdBase_Sheet1, spdUser_Sheet1 |
| UsrButtonList | 3 | usrButtonList2, usrButtonList1, btnButtonList |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrMultiLineEditor | 2 | txtMDFVersion, txtSPVersion |
| Button | 2 | btnRight, btnLeft |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCombo | 1 | clbDivision |
| UsrMonthRangePicker | 1 | drpDateTime |
| ImageList | 1 | imageList1 |
| UsrTextBox | 1 | txtSearch |
| UsrLabel | 1 | usrLabel1 |
| SplitContainer | 1 | splMain |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 19 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 44 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 10 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
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
| SCM_MST_SHEET_COLUMNS | DMF0041 | Application Popup Base | 5/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 |
| SCM_MST_SHEET_COLUMNS | DMF0041 | Application Popup User | 5/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 |
| SCM_MST_SHEET_COLUMNS | DMF0041 | DMS Sales Popup Base | 5/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 |
| SCM_MST_SHEET_COLUMNS | DMF0041 | DMS Sales Popup User | 5/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 |
| SCM_MST_SHEET_COLUMNS | DMF0041 | MDFSimulator | 9/0 | · | · | · | · | · | · | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0041 | MDFVerpopup | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |
| SCM_MST_SHEET_MEASURE | DMF0041 | MDF_Unit | 3/1 | · | · | · | · | · | · | · | · | · | · | · | · | · |
| SCM_MST_SHEET_MEASURE | DMF0041 | MDFSimulator | 6/0 | · | · | · | · | · | · | · | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 84개 시트×division 비교, 차이 141건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: MDFSimulator, DMS Sales Popup Base, DMS Sales Popup User, Application Popup Base, Application Popup User
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:159, CreateSheetHeaderColumn@InitSpread:183

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 704 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 705 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 706 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 707 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetTitleSet | 0 | 398 | 표시/라벨 변경 | set:Value | Value = {?true} | SUB_TOTAL_FLAG | for(r < svSource.Rows.Count) ⟫ if(svSource.Cells[r, svSource.Columns["SUB_TOTAL_FLAG"].Index].Text == "Y") |
| SetTitleSet | 0 | 479 | 표시/라벨 변경 | set:Text | Text = {?sDMS_SALES} |  | foreach(i in selectIndex.Keys) ⟫ if(_Flag == "") |
| SetTitleSet | 0 | 481 | 표시/라벨 변경 | set:Text | Text = {?sDMS_SALES} |  | foreach(i in selectIndex.Keys) ⟫ else!(_Flag == "") |
| SetTitleSet | 0 | 483 | 표시/라벨 변경 | set:Text | Text = {?sSortOrderNo} |  | foreach(i in selectIndex.Keys) |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Application Popup Base | META+코드연결 | 5 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 |
| Application Popup User | META+코드연결 | 5 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 |
| DMS Sales Popup Base | META+코드연결 | 5 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 |
| DMS Sales Popup User | META+코드연결 | 5 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 |
| MDFSimulator | META+코드연결 | 9 | · | · | · | · | · | · | · | · | · | · | · | · | · |
| MDFVerpopup | 메타 정의만, 코드 미참조(미사용 가능) | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
