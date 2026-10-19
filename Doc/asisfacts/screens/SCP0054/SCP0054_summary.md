# SCP0054 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0054_CAPA_Simulation.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0054_CAPA_Simulation.UIL\SCP0054_CAPA_Simulation.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0054_CAPA_Simulation.UIL\SCP0054_CAPA_SIMULATION.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0054_CAPA_Simulation.UIL\SCP0054_CAPA_Simulation.UIL.csproj | 1337 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0054_CAPA_Simulation.UIL\SCP0054_CAPA_SIMULATION.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0054_CAPA_Simulation.UIL\SCP0054_CAPA_Simulation.UIL.csproj | 953 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0054_CAPA_Simulation.UIL\TestCode.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0054_CAPA_Simulation.UIL\SCP0054_CAPA_Simulation.UIL.csproj | 48 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0054_CAPA_SIMULATION\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0054_CAPA_SIMULATION\SCP0054_CAPA_SIMULATION.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0054_CAPA_SIMULATION\SCP0054_CAPA_SIMULATION.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0054_CAPA_SIMULATION\SCP0054_CAPA_SIMULATION.csproj | 1338 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0054_CAPA_SIMULATION\SCP0054_CAPA_SIMULATION.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0054_CAPA_SIMULATION\SCP0054_CAPA_SIMULATION.csproj | 953 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 302 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 303 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 306 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 307 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 313 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 314 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 1311 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 1312 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 1324 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 1325 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboVersionId.SelectedIndexChanged | CboVersionId_SelectedIndexChanged | 1221 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:cboVersionId.SelectedIndexChanged | CboVersionId_SelectedIndexChanged | 1222 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:cboVersionId.SelectedIndexChanged | CboVersionId_SelectedIndexChanged | 1225 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboVersionId.SelectedIndexChanged | CboVersionId_SelectedIndexChanged | 1226 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboVersionId.SelectedIndexChanged | CboVersionId_SelectedIndexChanged | 1232 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboVersionId.SelectedIndexChanged | CboVersionId_SelectedIndexChanged | 1233 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 607 | SCP.SCP0054_GET_CAPA_SIMULATION | MATCH | SP SCP0054_GET_CAPA_SIMULATION |
| button:FindButton | FindButton > FindData_Main | 608 | SCP.SCP0054_GET_CAPA_SIMULATION | MATCH | SP SCP0054_GET_CAPA_SIMULATION |
| button:FindButton | FindButton > FindData_Main > InitSpread > SetSpreadInit > GetSpdTitle | 681 | SCP.SCP0054_GET_SHEET_CALENDAR | MATCH | SP SCP0054_GET_SHEET_CALENDAR |
| button:FindButton | FindButton > FindData_Main > InitSpread > SetSpreadInit > GetSpdTitle | 682 | SCP.SCP0054_GET_SHEET_CALENDAR | MATCH | SP SCP0054_GET_SHEET_CALENDAR |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread > SetSpreadInit > GetSpdTitle | 681 | SCP.SCP0054_GET_SHEET_CALENDAR | MATCH | SP SCP0054_GET_SHEET_CALENDAR |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread > SetSpreadInit > GetSpdTitle | 682 | SCP.SCP0054_GET_SHEET_CALENDAR | MATCH | SP SCP0054_GET_SHEET_CALENDAR |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 302 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 303 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 306 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 307 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 313 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 314 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > GetSpdTitle | 681 | SCP.SCP0054_GET_SHEET_CALENDAR | MATCH | SP SCP0054_GET_SHEET_CALENDAR |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > GetSpdTitle | 682 | SCP.SCP0054_GET_SHEET_CALENDAR | MATCH | SP SCP0054_GET_SHEET_CALENDAR |
| event:this.Load | Form_Load > InitControls > GetDayRange | 715 | SCP.SCP0054_GET_DAY_RANGE | MATCH | SP SCP0054_GET_DAY_RANGE |
| event:this.Load | Form_Load > InitControls > GetDayRange | 716 | SCP.SCP0054_GET_DAY_RANGE | MATCH | SP SCP0054_GET_DAY_RANGE |
| unreached:(진입점 미연결) | <field:dtMyDivision> | 41 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:REF:FN_CHAR_TO_DATE, UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH | 6 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH | 6 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| SCP.SCP0054_GET_CAPA_SIMULATION | MATCH | 2 | SP SCP0054_GET_CAPA_SIMULATION | EXEC:SCP0054_GET_CAPA_SIMULATION, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MASTER_VERSION_INFO_H_SN, SELECT:SCM_SYS_LOOKUP_VALUE_SN, INSERT:#TMP_SCP0054_LOOKUP, INSERT:#TMP_SCP0054_STD, SELECT:SCM_LINE_HIERARCHY_V_SN, REF:STRING_SPLIT, CREATE:#TMP_SCP0054_MM, CREATE:#TMP_SCP0054_AVG_DATA, CREATE:#TMP_SCP0054_AVG, CREATE:#TMP_SCP0054_AVG_MIN_MAX, CREATE:#TMP_SCP0054_ADD_STD, CREATE:#TMP_SCP0054_LTY, CREATE:#TMP_SCP0054_ALL, CREATE:#TMP_SCP0054_PRODUCTION, CREATE:#TMP_SCP0054_PRODUCTION_AVG, INSERT:#TMP_SCP0054_PRODUCTION, SELECT:SCP_ANL_PRODUCTION_PLAN, SELECT:#TMP_SCP0054_STD, SELECT:SCM_DNM_DAILY_PRODUCT_RESULT_SN, INSERT:#TMP_SCP0054_AVG_DATA, INSERT:#TMP_SCP0054_STD_ITEM, SELECT:#TMP_SCP0054_PRODUCTION, SELECT:SCM_ITEM_M_SN, INSERT:#TMP_SCP0054_STD_ITEM_TACT, SELECT:#TMP_SCP0054_STD_ITEM, INSERT:#TMP_SCP0054_STD_ITEM_YIELD, SELECT:#TMP_SCP0054_LOOKUP, SELECT:SCM_WORK_CALENDAR_M_SN, SELECT:SCM_LOSS_M_SN, SELECT:HIST_SCM_WORK_CALENDAR_M_SN, SELECT:HIST_SCM_LOSS_M_SN, SELECT:SCM_MST_TACT_TIME_SN, SELECT:#TMP_SCP0054_STD_ITEM_TACT, SELECT:HIST_SCM_TACT_TIME_M_SN, SELECT:SCM_MST_YIELD_SN, SELECT:#TMP_SCP0054_STD_ITEM_YIELD, SELECT:HIST_SCM_YIELD_M_SN, INSERT:#TMP_SCP0054_AVG, SELECT:#TMP_SCP0054_AVG_DATA, INSERT:#TMP_SCP0054_AVG_MIN_MAX, INSERT:#TMP_SCP0054_MM, SELECT:SCM_WORK_CAL_VER_H_SN, SELECT:SCM_LOSS_VER_H_SN, INSERT:#TMP_SCP0054_LTY, SELECT:SCM_TACT_TIME_VER_H_SN, SELECT:SCM_YIELD_VER_H_SN, INSERT:#TMP_SCP0054_ADD_STD, SELECT:#TMP_SCP0054_MM, INSERT:#TMP_SCP0054_ALL, SELECT:#TMP_SCP0054_ADD_STD, SELECT:#TMP_SCP0054_LTY, SELECT:#TMP_SCP0054_ALL, UPDATE:X, SELECT:#TMP_SCP0054_AVG, SELECT:#TMP_SCP0054_AVG_MIN_MAX, INSERT:#TMP_SCP0054_ALL_LINE, INSERT:#TMP_SCP0054_RESULT, SELECT:#TMP_SCP0054_ALL_LINE |  |
| SCP.SCP0054_GET_DAY_RANGE | MATCH | 2 | SP SCP0054_GET_DAY_RANGE | EXEC:SCP0054_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0054_GET_SHEET_CALENDAR | MATCH | 2 | SP SCP0054_GET_SHEET_CALENDAR | EXEC:SCP0054_GET_SHEET_CALENDAR, SELECT:SCM_SYS_CALENDAR_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| FindData_Main | UserInfoContext.Current | NowGroupID |
| InitControls | dataRow | CODE, NAME, SORT_ORDER |
| InitControls | dr | CODE, NAME |
| InitControls | dt.Rows[0] | FROM_VALUE, TO_VALUE |
| Set_CalculatorBestWorst | a | value |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:277, SetChangedControl:281, SetChangedControl:286, SetChangedControl:291, SetChangedControl:300, SetChangedControl:305, SetChangedControl:312, FindData_Main:570 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:334, InitSpread:335 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| GetSpdTitle | SetSpreadInit:350, SetSpreadInit:351 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| InitSpreadDateColumn | SetSpreadInit:352, SetSpreadInit:353 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:199 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:384 |
| clbGroup | SelectedIndexChanged | ClbGroup_SelectedIndexChanged | InitEvent:385 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:386 |
| clbBuilding | SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | InitEvent:387 |
| cboVersionId | SelectedIndexChanged | CboVersionId_SelectedIndexChanged | InitEvent:388 |
| cboVersionId | Click | CboVersionId_Click | InitEvent:389 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:391 |
| dsdm | Changed | shtMain_Changed | InitEvent:395 |
| this.btnColumn | Click | BtnColumn_Click | InitEvent:397 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:399 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:400 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:401 |
| this | Load | Form_Load | .ctor:200 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:385 |
| clbGroup | SelectedIndexChanged | ClbGroup_SelectedIndexChanged | InitEvent:386 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:387 |
| clbBuilding | SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | InitEvent:388 |
| cboVersionId | SelectedIndexChanged | CboVersionId_SelectedIndexChanged | InitEvent:389 |
| cboVersionId | Click | CboVersionId_Click | InitEvent:390 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:392 |
| dsdm | Changed | shtMain_Changed | InitEvent:396 |
| this.btnColumn | Click | BtnColumn_Click | InitEvent:398 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:400 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:401 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:402 |

## 6. 컨트롤 (76개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 22 | layoutDivision, layoutVersionId, layoutBtnColumn, layoutPeriodMonth, layoutGroup, layoutPlant, layoutBuilding, layoutLine, layoutPlanDate, layoutPlanType, layoutSeq, layoutDivision, layoutVersionId, layoutBtnColumn, layoutPeriodMonth … |
| EmptySpaceItem | 16 | emptySpaceItem5, emptySpaceItem3, emptySpaceItem15, emptySpaceItem1, emptySpaceItem13, emptySpaceItem14, emptySpaceItem2, emptySpaceItem6, emptySpaceItem5, emptySpaceItem3, emptySpaceItem15, emptySpaceItem1, emptySpaceItem13, emptySpaceItem14, emptySpaceItem2 … |
| UsrCombo | 10 | cboPlanSeq, cboPlanType, cboPlanDate, cboVersionId, cboDivision, cboPlanSeq, cboPlanType, cboPlanDate, cboVersionId, cboDivision |
| UsrCheckedList2 | 8 | clbLine, clbBuilding, clbPlant, clbGroup, clbLine, clbBuilding, clbPlant, clbGroup |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrMonthRangePicker | 2 | drpPeriodMonth, drpPeriodMonth |
| UsrButton | 2 | btnColumn, btnColumn |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| ImageList | 2 | imageList1, imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 30 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 40 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 14 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 35 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0054 | CAPA SIMULATION | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: CAPA SIMULATION
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:334, SetSheetHeaderColumn@InitSpread:335
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumnTitle, SetSpreadColumn, SetSpreadColumnRESULT, InitSpreadDateColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadColumnRESULT |  | 377 | 표시/라벨 변경 | set:Visible | Visible = {?bVisibleResult} |  | for(i <= 5) |
| InitSpreadDateColumn |  | 706 | DB루프 | AddNumColumnEx | {?dr[DefColumnsTitle.COLUMN_LABEL_NAME]} | {?dr[DefColumnsTitle.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(spdInfo.SheetName == "CAPA SIMULATION") |
| SetSpreadColumnTitle |  | 1134 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M6_RESULT |  |
| SetSpreadColumnTitle |  | 1135 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M5_RESULT |  |
| SetSpreadColumnTitle |  | 1136 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M4_RESULT |  |
| SetSpreadColumnTitle |  | 1137 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M3_RESULT |  |
| SetSpreadColumnTitle |  | 1138 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M2_RESULT |  |
| SetSpreadColumnTitle |  | 1139 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M1_RESULT |  |
| SetSpreadColumn |  | 1153 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 826 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 827 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 828 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 829 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadColumnRESULT |  | 378 | 표시/라벨 변경 | set:Visible | Visible = {?bVisibleResult} |  | for(i <= 5) |
| InitSpreadDateColumn |  | 707 | DB루프 | AddNumColumnEx | {?dr[DefColumnsTitle.COLUMN_LABEL_NAME]} | {?dr[DefColumnsTitle.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(spdInfo.SheetName == "CAPA SIMULATION") |
| SetSpreadColumnTitle |  | 1135 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M6_RESULT |  |
| SetSpreadColumnTitle |  | 1136 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M5_RESULT |  |
| SetSpreadColumnTitle |  | 1137 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M4_RESULT |  |
| SetSpreadColumnTitle |  | 1138 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M3_RESULT |  |
| SetSpreadColumnTitle |  | 1139 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M2_RESULT |  |
| SetSpreadColumnTitle |  | 1140 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M1_RESULT |  |
| SetSpreadColumn |  | 1154 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 826 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 827 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 828 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 829 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| CAPA SIMULATION | META+코드연결 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
