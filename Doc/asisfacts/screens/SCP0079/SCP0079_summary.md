# SCP0079 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0079_RTF_Analysis_Report\POPUP\SCP0079_RTF_Analysis_Report_DetailPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0079_RTF_Analysis_Report\SCP0079_RTF_Analysis_Report.csproj | 372 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0079_RTF_Analysis_Report\POPUP\SCP0079_RTF_Analysis_Report_DetailPopup.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0079_RTF_Analysis_Report\SCP0079_RTF_Analysis_Report.csproj | 117 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0079_RTF_Analysis_Report\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0079_RTF_Analysis_Report\SCP0079_RTF_Analysis_Report.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0079_RTF_Analysis_Report\SCP0079_RTF_Analysis_Report.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0079_RTF_Analysis_Report\SCP0079_RTF_Analysis_Report.csproj | 988 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0079_RTF_Analysis_Report\SCP0079_RTF_Analysis_Report.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0079_RTF_Analysis_Report\SCP0079_RTF_Analysis_Report.csproj | 1212 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > FindData_Main | 671 | SCP.SCP0079_GET_RTF_ANALYSIS_REPORT | MATCH | SP SCP0079_GET_RTF_ANALYSIS_REPORT |
| event:cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > FindData_Main > InitSpread > GetSpdTitle | 810 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl > Set_GapDate | 321 | biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl > Set_GapDate | 343 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl > Set_GapDate | 365 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl > Set_PlanDate > SetPlanSeq | 608 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 526 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > SetPlanSeq | 608 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 825 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged > SetPlanSeq | 608 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 168 | SCP.SCP0079_GET_RTF_ANALYSIS_REPORT_DETAIL | MATCH | SP SCP0079_GET_RTF_ANALYSIS_REPORT_DETAIL |
| button:FindButton | FindButton > FindData_Main | 671 | SCP.SCP0079_GET_RTF_ANALYSIS_REPORT | MATCH | SP SCP0079_GET_RTF_ANALYSIS_REPORT |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 810 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > FindData | 168 | SCP.SCP0079_GET_RTF_ANALYSIS_REPORT_DETAIL | MATCH | SP SCP0079_GET_RTF_ANALYSIS_REPORT_DETAIL |
| event:this.Load | Form_Load > InitControls | 172 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 179 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > Set_GapDate | 321 | biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > Set_GapDate | 343 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 359 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > SetChangedControl > Set_GapDate | 365 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > Set_PlanDate > SetPlanSeq | 608 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 810 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetDayRange | 825 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:REF:FN_CHAR_TO_DATE, UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V, UP_FX_GetCommonDataList:SELECT:SCM_SYS_CALENDAR_M, UP_FX_GetCommonDataList:SELECT:SCP_PLN_INTERFACE_YN, UP_FX_GetCommonDataList:REF:FN_SPLITSTRING |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 2 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0079_GET_RTF_ANALYSIS_REPORT | MATCH | 1 | SP SCP0079_GET_RTF_ANALYSIS_REPORT | EXEC:SCP0079_GET_RTF_ANALYSIS_REPORT, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M, CREATE:#TMP_SCP0079_CALENDAR, INSERT:#TMP_SCP0079_CALENDAR, INSERT:#TMP_SCM_SYS_CALENDAR_M, INSERT:#TMP_SCP0079_MEASURE, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#TMP_SCP0079_FG_VER_A, SELECT:SCP_ANL_SHIPMENT_PLAN_FG, SELECT:#TMP_SCM_SYS_CALENDAR_M, SELECT:SCM_MST_SITE_ITEM, REF:FN_GET_DIVISION_DIV, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:HIST_SCP_ANL_SHIPMENT_PLAN_FG, REF:FN_GET_SCP_PLAN_MIN_DATE, INSERT:#TMP_SCP0079_FG_VER_B, INSERT:#TMP_SCP0079_SHIP_PLAN_RESULT, SELECT:PLAN_SSP, SELECT:RESULT_ERP_C_EXIST, SELECT:RESULT_ERP_C_NON, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SSP_MST_MODEL_USER, SELECT:SCM_DNM_EXFACTORY_RESULT, SELECT:SCP_MST_FINAL_ITEM, SELECT:SSP_ANL_SHIP_CONFIRM, INSERT:#TMP_SCP0079_PRODUCTION_RESULT, SELECT:SCM_DNM_PRODUCT_RESULT_V, INSERT:#TMP_SCP0079_RTF_RESULT, SELECT:DM_PLN_MKT_FCST_RESULT, INSERT:#TMP_SCP0079_PLAN_VER_A, SELECT:SCP_ANL_PRODUCTION_PLAN, SELECT:#TMP_SCP0079_FG_VER_A, INSERT:#TMP_SCP0079_PLAN_VER_B, SELECT:#TMP_SCP0079_FG_VER_B, INSERT:#TMP_SCP0079_GLOBAL_VER_A, SELECT:SCP_ANL_PSI_GLOBAL, SELECT:#TMP_SCP0079_CALENDAR, INSERT:#TMP_SCP0079_GLOBAL_VER_B, SELECT:#TMP_SCP0079_PRODUCTION_RESULT, SELECT:#TMP_SCP0079_SHIP_PLAN_RESULT, SELECT:#TMP_SCP0079_RTF_RESULT, SELECT:#TMP_SCP0079_PLAN_VER_A, INSERT:#TMP_SCP0079_FG_GAP, SELECT:#TMP_SCP0079_FG_GAP, INSERT:#TMP_SCP0079_FG_TOTAL, INSERT:#TMP_SCP0079_FG_PIVOT, SELECT:#TMP_SCP0079_FG_TOTAL, SELECT:#TMP_SCP0079_PLAN_VER_B, SELECT:#TMP_SCP0079_GLOBAL_VER_A, SELECT:#TMP_SCP0079_GLOBAL_VER_B, DYNAMIC@SCP0079_GET_RTF_ANALYSIS_REPORT, SELECT:SCM_MST_DIVISION, SELECT:SCP_ANL_SHIPMENT_PLAN_SEMI |  |
| SCP.SCP0079_GET_RTF_ANALYSIS_REPORT_DETAIL | MATCH | 1 | SP SCP0079_GET_RTF_ANALYSIS_REPORT_DETAIL | EXEC:SCP0079_GET_RTF_ANALYSIS_REPORT_DETAIL, SELECT:SCM_SYS_CALENDAR_M, REF:FN_GET_SCP_PLAN_MIN_DATE, INSERT:#TMP_SCP0079_MEASURE, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#TMP_SCP0079_FG_VER_A, SELECT:SCP_ANL_SHIPMENT_PLAN_FG, INSERT:#TMP_SCP0079_FG_VER_B, REF:STRING_SPLIT, INSERT:#TMP_SCP0079_PLAN_VER_A, SELECT:SCP_ANL_PRODUCTION_PLAN, SELECT:#TMP_SCP0079_FG_VER_A, INSERT:#TMP_SCP0079_PLAN_VER_B, SELECT:#TMP_SCP0079_FG_VER_B, INSERT:#TMP_SCP0079_PLAN_VER_AA, SELECT:SCP_ANL_PSI_GLOBAL, INSERT:#TMP_SCP0079_PLAN_VER_BB, INSERT:#TMP_SCP0079_PLAN_RESULT, REF:FN_GET_ITEM_NICKNAME, SELECT:PLAN_SSP, SELECT:RESULT_ERP_C_EXIST, SELECT:RESULT_ERP_C_NON, SELECT:SCP_MST_BOD_V, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SSP_MST_MODEL_USER, SELECT:SCM_DNM_EXFACTORY_RESULT, SELECT:SCP_MST_FINAL_ITEM, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCM_MST_SITE_ITEM, INSERT:#TMP_SCP0079_RTF_RESULT, SELECT:DM_PLN_MKT_FCST_RESULT, SELECT:#TMP_SCP0079_PLAN_RESULT, SELECT:#TMP_SCP0079_RTF_RESULT, INSERT:#TMP_SCP0079_FG_GAP, INSERT:#TMP_SCP0079_FG_PIVOT, SELECT:#TMP_SCP0079_FG_GAP, SELECT:#TMP_SCP0079_PLAN_VER_A, SELECT:#TMP_SCP0079_PLAN_VER_B, SELECT:#TMP_SCP0079_PLAN_VER_AA, SELECT:#TMP_SCP0079_PLAN_VER_BB, REF:FN_GET_DIVISION_DIV, DYNAMIC@SCP0079_GET_RTF_ANALYSIS_REPORT_DETAIL, SELECT:SCP_ANL_SHIPMENT_PLAN_SEMI, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_DIVISION |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| GetDataTableTempFN | drRow | CODE, NAME |
| InitControls | UserInfoContext.Current | NowGroupID |
| Set_GapDate | drType | code, name |
| Set_GapDate | drSeq | CODE, NAME |
| Set_PlanDate | drRow | CODE, NAME |
| SetChangedControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:138, InitSpread:256 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:140, InitSpread:258 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:142, InitSpread:260 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetCheckedListValue | InitControls:164, SetChangedControl:194, Set_PlanDate:275, Set_PlanDate:280, Set_GapDate:319, Set_GapDate:327, Set_GapDate:342, Set_GapDate:364 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:102 |
| this | Load | Form_Load | .ctor:134 |
| this.btnProject | Click | BtnProject_Click | InitEvent:483 |
| this.btnItem_Id | Click | BtnItem_Id_Click | InitEvent:484 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:486 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:487 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:489 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:490 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:491 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:492 |
| cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:494 |

## 6. 컨트롤 (46개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 16 | lblProject, lblCombo, lblCombo1, layoutControlItem2, lblItemId, layoutControlItem4, PlanDate, layoutControlItem7, PlanType, lblTeam, GapDate, GapPlanType, SEQ, GapSeq, layoutControlItem5 … |
| UsrCombo | 9 | cboGapSeq, cboGapType, cboGapDate, cboPlanSeq, cboPlanType, cboBizType, cboDivision, cboPlanDate, cboBucketType |
| EmptySpaceItem | 6 | emptySpaceItem1, emptySpaceItem5, emptySpaceItem4, emptySpaceItem8, emptySpaceItem2, emptySpaceItem3 |
| UsrButton | 3 | usrButton1, btnProject, btnItem_Id |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrMultiLineEditor | 2 | txtItem_Id, txtProject |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckedList2 | 1 | clbTeam |
| UsrCheckedList | 1 | clbElecType |
| UsrDateRangePicker3 | 1 | dCalendar |
| LayoutControlGroup | 1 | layoutControlGroup2 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 40 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 32 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 7 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 7 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 10 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0079 | RTF Analysis Detail | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 |
| SCM_MST_SHEET_COLUMNS | SCP0079 | RTF Analysis Main | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |
| SCM_MST_SHEET_MEASURE | SCP0079 | RTF Analysis Main | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: RTF Analysis Detail, RTF Analysis Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:140, SetSheetHeaderColumn@InitSpread:258
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 236 | DB루프 | AddTextColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 240 | DB루프 | AddNumColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 245 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 293 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siMain.ActiveSheet.Columns.Count) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 297 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siMain.ActiveSheet.Columns.Count) ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 302 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siMain.ActiveSheet.Columns.Count) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 67 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 68 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 69 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 70 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpreadDateColumn |  | 437 | DB루프 | AddTextColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 441 | DB루프 | AddNumColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 445 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 847 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siMain.ActiveSheet.Columns.Count) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 851 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siMain.ActiveSheet.Columns.Count) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 858 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siMain.ActiveSheet.Columns.Count) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 862 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siMain.ActiveSheet.Columns.Count) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 869 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siMain.ActiveSheet.Columns.Count) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 873 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siMain.ActiveSheet.Columns.Count) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 1083 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1084 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1085 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1086 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| RTF Analysis Detail | META+코드연결 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 |
| RTF Analysis Main | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
