# SCP0067 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0067_GlobalPSI\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0067_GlobalPSI\SCP0067_GlobalPSI.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0067_GlobalPSI\SCP0067_GlobalPSI.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0067_GlobalPSI\SCP0067_GlobalPSI.csproj | 1547 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0067_GlobalPSI\SCP0067_GlobalPSI.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0067_GlobalPSI\SCP0067_GlobalPSI.csproj | 846 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 280 | biz:CommonData.CommonDataList [code=FromSiteByDivision] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 305 | biz:CommonData.CommonDataList [code=ToSiteByDivision] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 330 | biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 334 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 341 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 436 | SCP.SCP0067_GET_GLOBAL_PSI | MATCH | SP SCP0067_GET_GLOBAL_PSI |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 1493 | SCP.SCP0067_GET_SPREAD_TITLE | MATCH | SP SCP0067_GET_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 436 | SCP.SCP0067_GET_GLOBAL_PSI | MATCH | SP SCP0067_GET_GLOBAL_PSI |
| button:SaveButton | SaveButton > SaveData_Main | 597 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveGlobalPSIRow] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData_Main | 597 | SCP\Analysis\SCP0067_GlobalPSI#SaveGlobalPSIRow | MATCH_PATTERN | SP SCP0067_SAVE_GLOBAL_PSI_ROW_DATASET |
| button:SaveButton | SaveButton > SaveData_Main > SCM_SYS_LOG_BATCH | 1461 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main > InitSpread > GetSpdTitle | 1493 | SCP.SCP0067_GET_SPREAD_TITLE | MATCH | SP SCP0067_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 280 | biz:CommonData.CommonDataList [code=FromSiteByDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 305 | biz:CommonData.CommonDataList [code=ToSiteByDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 330 | biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 334 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 341 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1493 | SCP.SCP0067_GET_SPREAD_TITLE | MATCH | SP SCP0067_GET_SPREAD_TITLE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveGlobalPSIRow] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:REF:FN_CHAR_TO_DATE, UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V, UP_FX_GetCommonDataList:SELECT:SCM_SYS_CALENDAR_M, UP_FX_GetCommonDataList:SELECT:SCP_PLN_INTERFACE_YN, UP_FX_GetCommonDataList:REF:FN_SPLITSTRING |
| biz:CommonData.CommonDataList [code=FromSiteByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GetCommonDataList_SCP:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList_SCP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=ToSiteByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GetCommonDataList_SCP:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList_SCP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0067_GET_GLOBAL_PSI | MATCH | 1 | SP SCP0067_GET_GLOBAL_PSI | EXEC:SCP0067_GET_GLOBAL_PSI, SELECT:SCP_XLS_PSI_GLOBAL, INSERT:#TMP_SCP0067_FILTER_ITEM, REF:STRING_SPLIT, INSERT:#TMP_SCP0067_MEASURE, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#TMP_SCP0067_DAILY, SELECT:#TMP_SCP0067_MEASURE, SELECT:#TMP_SCP0067_FILTER_ITEM, INSERT:#TMP_SCP0067_WEEKLY, SELECT:#TMP_SCP0067_DAILY, SELECT:SCM_SYS_CALENDAR_M, UPDATE:X, SELECT:#TMP_SCP0067_WEEKLY, DYNAMIC@SCP0067_GET_GLOBAL_PSI |  |
| SCP.SCP0067_GET_SPREAD_TITLE | MATCH | 1 | SP SCP0067_GET_SPREAD_TITLE | EXEC:SCP0067_GET_SPREAD_TITLE, SELECT:SCP_XLS_PSI_GLOBAL, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP\Analysis\SCP0067_GlobalPSI#SaveGlobalPSIRow | MATCH_PATTERN | 1 | SP SCP0067_SAVE_GLOBAL_PSI_ROW_DATASET | EXEC:SCP0067_SAVE_GLOBAL_PSI_ROW_DATASET | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InitControls | dr | CODE, NAME |
| InitControls | dataRow | CODE, NAME |
| InitSpreadDateColumn | dr | COLUMN_NAME, COLUMN_LABEL, SMALL_LABEL_NAME |
| SaveData_Main | dr | p_user_id, p_division_id, p_plan_start_yyyymmdd, p_plan_type, p_seq, p_item_id, p_measure, p_xls_key1, p_qty |
| SaveData_Main | result.Rows[0] | result_code, err_code, err_message |
| Set_Formula_Cell_EOH | row | CELL_ITEM_ID, ITEM_ID, FROM_SITE, MEASURE, ROW_NUM, TO_SITE |
| Set_Formula_Cell_EOH | dr_SHIP_PLAN_PLANT | ROW_NUM |
| Set_Formula_CELL_SHIP_PLAN_TOTAL | row | CELL_ITEM_ID, ITEM_ID, FROM_SITE, MEASURE |
| Set_Formula_CELL_SHIP_PLAN_TOTAL | dr | ROW_NUM |
| Set_Formula_PACK_CELL_EOH | row | CELL_ITEM_ID, FROM_SITE, MEASURE, TO_SITE |
| Set_Formula_PACK_CELL_EOH | dr_SEMI_WHIN_TOTAL | ROW_NUM |
| Set_Formula_PACK_CELL_EOH | drIdx | ROW_NUM |
| Set_Formula_PARTIAL_WEEK_EOH | c | COLUMN_LABEL |
| Set_Formula_PARTIAL_WEEK_EOH | drDayCnt | DAY_CNT |
| Set_Formula_PARTIAL_WEEK_LT_DAY | c | COLUMN_NAME, COLUMN_LABEL, CAL_ORDER_NUM |
| Set_Formula_PARTIAL_WEEK_LT_DAY | drCalOrderNum | CAL_ORDER_NUM |
| Set_Formula_PARTIAL_WEEK_LT_DAY | drDayCnt | DAY_CNT |
| Set_Formula_PARTIAL_WEEK_LT_DAY | dr | COLUMN_NAME |
| Set_Formula_PLAN_FG | row | CELL_ITEM_ID, ITEM_ID, TO_SITE, ROW_NUM, MEASURE |
| Set_Formula_PROD | row | CELL_ITEM_ID, ITEM_ID, FROM_SITE, ROW_NUM, MEASURE |
| Set_Formula_PROD | dr | ROW_NUM |
| Set_Formula_SEMI | row | CELL_ITEM_ID, ITEM_ID, TO_SITE, FROM_SITE, ROW_NUM |
| Set_Formula_SEMI_WHIN_TOTAL | row | CELL_ITEM_ID, ITEM_ID, TO_SITE, MEASURE |
| Set_Formula_SEMI_WHIN_TOTAL | dr | ROW_NUM |
| SetChangedControl | UserInfoContext.Current | NowGroupID |
| SetChangedControl | dr1 | CODE, NAME |
| SetChangedControl | drRow | CODE, NAME |
| SetChangedControl | drtmp | CODE, NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:227 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:229 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:230 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetCheckedListValue | SetChangedControl:328, SetChangedControl:333, SetChangedControl:340, FindData_Main:419, FindData_Main:422, FindData_Main:423 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:147 |
| this.btnItem_Id | Click | BtnItem_Id_Click | InitEvent:266 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:267 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:269 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:271 |

## 6. 컨트롤 (30개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 10 | lblCombo1, lblItemId, layoutControlItem4, lbPlanDate, lbPlanType, lbSeq, lbNickName, lbFormSite, lbToSite, layoutControlItem2 |
| UsrCombo | 4 | cboPlanSeq, cboPlanType, cboPlanDate, cboDivision |
| EmptySpaceItem | 4 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem4 |
| UsrButton | 2 | usrButton1, btnItem_Id |
| UsrCheckedList2 | 2 | clbToSite, clbFromSite |
| UsrConditionPanel | 1 | pnlCondition |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrTextBox | 1 | txtNickName |
| UsrMultiLineEditor | 1 | txtItemId |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SheetView | 1 | spdMain_Sheet1 |
| FpSpread | 1 | spdMain |
| UsrDateRangePicker3 | 1 | dCalendar |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 597 | SaveData_Main | {?definition_path}#SaveGlobalPSIRow | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 8 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 20 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 35 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 6 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0067 | Global PSI | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |
| SCM_MST_SHEET_MEASURE | SCP0067 | Global PSI | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 | 35/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Global PSI
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:229
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 249 | DB루프 | AddNumColumn | {?string.Empty} \|\| {?dr["COLUMN_LABEL"]} | {?string.Empty} \|\| {?dr["COLUMN_NAME"]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitializeComponent |  | 675 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 676 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 677 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 678 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Global PSI | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
