# SCP0024 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0024_ProductionPlanFix\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0024_ProductionPlanFix\SCP0024_ProductionPlanFix.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0024_ProductionPlanFix\SCP0024_ProductionPlanFix.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0024_ProductionPlanFix\SCP0024_ProductionPlanFix.csproj | 1752 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0024_ProductionPlanFix\SCP0024_ProductionPlanFix.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0024_ProductionPlanFix\SCP0024_ProductionPlanFix.csproj | 1033 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo_U > FindData_Main | 876 | SCP.SCP0024_GET_PRODUCTION_PLAN_FIX | MATCH | SP SCP0024_GET_PRODUCTION_PLAN_FIX |
| event:btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo_U > FindData_Main > InitSpread > GetSpdTitle | 1151 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo_U | 1494 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveProductionPlanFix] | BIZ_MATCH |  |
| event:btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo_U | 1494 | SCP\Analysis\SCP0013_ProductionPlanLine#SaveProductionPlanFix\|SCP\Analysis\SCP0024_ProductionPlanFix#SaveProductionPlanFix | MATCH_PATTERN | SP SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET \| SP SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET |
| event:btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo_U > SCM_SYS_LOG_BATCH | 1553 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > GetLastRange | 1177 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| button:FindButton | FindButton > FindData_Main | 876 | SCP.SCP0024_GET_PRODUCTION_PLAN_FIX | MATCH | SP SCP0024_GET_PRODUCTION_PLAN_FIX |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 1151 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnW26.Click | BtnW26_Click > GetDayRange | 1190 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.btnW52.Click | BtnW52_Click > GetDayRange | 1190 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.btnWLast.Click | BtnWLast_Click > GetDayRange | 1190 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.Load | Form_Load > InitControls > RefreshBucketType > GetBucketType | 765 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1151 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetLastRange | 1177 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1190 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| unreached:(진입점 미연결) | <field:dtElectrodeType> | 291 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveData | 1012 | SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | MATCH | SP SCP0024_SAVE_PRODUCTION_PLAN_FIX |
| unreached:(진입점 미연결) | SaveData_FixInfo | 1684 | SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | MATCH | SP SCP0024_SAVE_PRODUCTION_PLAN_FIX |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveProductionPlanFix] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD | EXEC:SCM0001_GET_SCP_DAILY_PLAN_PERIOD, SELECT:SCM_MST_DIVISION |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0024_GET_PRODUCTION_PLAN_FIX | MATCH | 1 | SP SCP0024_GET_PRODUCTION_PLAN_FIX | EXEC:SCP0024_GET_PRODUCTION_PLAN_FIX, INSERT:#TBLDYNAMICPIVOT_SCP0024, SELECT:SCP_ANL_PRODUCTION_PLAN_FIX, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@SCP0024_GET_PRODUCTION_PLAN_FIX |  |
| SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | MATCH | 2 | SP SCP0024_SAVE_PRODUCTION_PLAN_FIX | EXEC:SCP0024_SAVE_PRODUCTION_PLAN_FIX, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_ANL_PRODUCTION_PLAN_FIX, EXEC:PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX, UPDATE:SCP_ANL_PRODUCTION_PLAN_FIX, DELETE:SCP_ANL_PRODUCTION_PLAN_FIX, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX_H |  |
| SCP\Analysis\SCP0013_ProductionPlanLine#SaveProductionPlanFix\|SCP\Analysis\SCP0024_ProductionPlanFix#SaveProductionPlanFix | MATCH_PATTERN | 1 | SP SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET \| SP SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET | EXEC:SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET, CREATE:#TBLDYNAMIC_SCP0013FIX, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#JV_ESS_LINE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP, INSERT:#JV_ESS_SCM_SITE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP, INSERT:#DIVISION_LAST_PLAN_INFO, SELECT:SCP_PLAN_INFO, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_DIVISION, INSERT:#TBLDYNAMIC_SCP0013FIX, SELECT:#JV_ESS_SCM_SITE_MAP, SELECT:#JV_ESS_LINE_MAP, SELECT:#DIVISION_LAST_PLAN_INFO, UPDATE:X, SELECT:#TBLDYNAMIC_SCP0013FIX, SELECT:SCP_ANL_PRODUCTION_PLAN, UPDATE:#TBLDYNAMIC_SCP0013FIX, UPDATE:B, SELECT:SCP_ANL_PRODUCTION_PLAN_FIX, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX, UPDATE:A, EXEC:PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST_DATASET, DELETE:A, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_SITE, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| SaveData_FixInfo | dtErr.Rows[0] | ERR_MESSAGE |
| SaveData_FixInfo_U | dr | p_active_flag, p_division_id, p_operation_group, p_scm_site_id, p_line_id, p_item_id, p_operation_id, p_yyyymmdd, p_qty, p_fix_reason, p_origin_division_id, p_electrode_type, p_user_id |
| SaveData_FixInfo_U | result.Rows[0] | result_code, result_cnt, err_message |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | getDivision:58, getOperationGroup:82, getPlantSite:106, getLine:131, getElectrodeType:227 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:459 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:465 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:467 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:387 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:570 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:572 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:575 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:576 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:577 |
| cboOperationGroup | SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | InitEvent:579 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:581 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:582 |
| btnUnfix | Click | BtnUnfix_Click | InitEvent:584 |
| this.btnW26 | Click | BtnW26_Click | InitEvent:586 |
| this.btnW52 | Click | BtnW52_Click | InitEvent:587 |
| this.btnWLast | Click | BtnWLast_Click | InitEvent:588 |

## 6. 컨트롤 (36개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 14 | Division, layoutControlItem1, layoutControlItem7, lblBucket, layoutControlItem3, layoutControlItem2, layoutControlItem4, layoutControlItem11, layoutControlItem8, layoutControlItem9, layoutControlItem5, layoutControlItem10, layoutControlItem12, layoutControlItem13 |
| UsrButton | 6 | usrButton1, btnWLast, btnW52, btnW26, btnItemId, btnUnfix |
| UsrCheckedList | 3 | clbLine, clbPlantSite, cboElectrode |
| UsrCombo | 3 | cboOperationGroup, cboDivision, cboBucketType |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker3 | 1 | dCalendar |
| UsrMultiLineEditor | 1 | txtItemId |
| UsrCheckBox | 1 | chkSum |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1494 | SaveData_FixInfo_U | {?definition_path}#SaveProductionPlanFix | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=2 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 26 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 12 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 2 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_Favorite | 12 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 109 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0024 | Model | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_MEASURE | SCP0024 | PRODUCTION_PLAN_FIX | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Model
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:465
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Model | 475 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Model") ⟫ if(!_division.Substring(0, 2).Equals("EE")) |
| InitSpread | Model | 476 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Model") ⟫ if(!_division.Substring(0, 2).Equals("EE")) |
| InitSpread | Model | 480 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Model") ⟫ else!(!_division.Substring(0, 2).Equals("EE")) |
| InitSpread | Model | 481 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Model") ⟫ else!(!_division.Substring(0, 2).Equals("EE")) |
| InitSpreadDateColumn |  | 520 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 524 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 528 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 719 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(_bucket_type == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 724 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(_bucket_type == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 731 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(_bucket_type == "DAILY") ⟫ if(_bucket_type == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 735 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(_bucket_type == "DAILY") ⟫ if(_bucket_type == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 740 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(_bucket_type == "DAILY") ⟫ if(_bucket_type == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 747 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(_bucket_type == "DAILY") ⟫ else!(_bucket_type == "WEEKLY") ⟫ if(_bucket_type == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 751 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(_bucket_type == "DAILY") ⟫ else!(_bucket_type == "WEEKLY") ⟫ if(_bucket_type == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 928 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 929 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 930 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 931 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Model | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 10 | 10 | 10 | 10 | 10 | 10 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
