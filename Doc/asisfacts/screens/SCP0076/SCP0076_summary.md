# SCP0076 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0076_Production_Result_Check\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0076_Production_Result_Check\SCP0076_Production_Result_Check.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0076_Production_Result_Check\SCP0076_Production_Result_Check.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0076_Production_Result_Check\SCP0076_Production_Result_Check.csproj | 1268 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0076_Production_Result_Check\SCP0076_Production_Result_Check.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0076_Production_Result_Check\SCP0076_Production_Result_Check.csproj | 627 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl > GetSpdTitle | 358 | SCP.SCP0076_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0076_GET_SHEET_CALENDAR_3SPAN |
| event:cboPlanDateEnd.SelectedIndexChanged | CboPlanDateEnd_SelectedIndexChanged > SetSpreadInit > GetSpdTitle | 358 | SCP.SCP0076_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0076_GET_SHEET_CALENDAR_3SPAN |
| event:cboPlanDateStart.SelectedIndexChanged | CboPlanDateStart_SelectedIndexChanged > SetSpreadInit > GetSpdTitle | 358 | SCP.SCP0076_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0076_GET_SHEET_CALENDAR_3SPAN |
| button:FindButton | FindButton > Find_Data > FindData_Main > SetSpreadInit > GetSpdTitle | 358 | SCP.SCP0076_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0076_GET_SHEET_CALENDAR_3SPAN |
| button:FindButton | FindButton > Find_Data > FindData_Main | 985 | SCP.SCP0076_GET_PRODUCTION_RESULT_CHECK | MATCH | SP SCP0076_GET_PRODUCTION_RESULT_CHECK |
| button:SaveButton | SaveButton > SaveData_Main > Find_Data > FindData_Main > SetSpreadInit > GetSpdTitle | 358 | SCP.SCP0076_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0076_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Main > Find_Data > FindData_Main | 985 | SCP.SCP0076_GET_PRODUCTION_RESULT_CHECK | MATCH | SP SCP0076_GET_PRODUCTION_RESULT_CHECK |
| button:SaveButton | SaveButton > SaveData_Main | 1092 | SCP.SCP0076_SAVE_PROD_RESULT_CHECK | MATCH | SP SCP0076_SAVE_PROD_RESULT_CHECK |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread > SetSpreadInit > GetSpdTitle | 358 | SCP.SCP0076_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0076_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > GetSpdTitle | 358 | SCP.SCP0076_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0076_GET_SHEET_CALENDAR_3SPAN |
| event:this.spdMain.ActiveSheetChanged | SpdMain_ActiveSheetChanged > SetChangedControl > GetSpdTitle | 358 | SCP.SCP0076_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0076_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | <field:dtReason> | 43 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| SCP.SCP0076_GET_PRODUCTION_RESULT_CHECK | MATCH | 1 | SP SCP0076_GET_PRODUCTION_RESULT_CHECK | EXEC:SCP0076_GET_PRODUCTION_RESULT_CHECK, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TMP_SCP0076_STD, SELECT:SCM_PLANT_M_SN, SELECT:SCP_RPT_PRODUCTION, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_VENDOR, REF:STRING_SPLIT, CREATE:#TMP_SCP0076_DATA_OSP_YN, CREATE:#TMP_SCP0076_DATA, INSERT:#TMP_SCP0076_COLUMN, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:#TMP_SCP0076_COLUMN, INSERT:#TMP_SCP0076_DATA_OSP_YN, SELECT:#TMP_SCP0076_STD, INSERT:#TMP_SCP0076_DATA, SELECT:#TMP_SCP0076_DATA_OSP_YN, INSERT:#TMP_WW_LIST, SELECT:SCM_MST_BUCKET, SELECT:WW_CASE_LIST, SELECT:#TMP_WW_LIST, SELECT:SELECTED_COLS, DYNAMIC@SCP0076_GET_PRODUCTION_RESULT_CHECK |  |
| SCP.SCP0076_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0076_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0076_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0076_SAVE_PROD_RESULT_CHECK | MATCH | 1 | SP SCP0076_SAVE_PROD_RESULT_CHECK | EXEC:SCP0076_SAVE_PROD_RESULT_CHECK, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SCP_RPT_PRODUCTION, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | DefineProperty:228, RefreshanDateFrom:273, RefreshanDateTo:282, RefreshReport:291, FindData_Main:961, FindData_Main:962, FindData_Main:963, FindData_Main:964 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | SetChangedControl:313, SetSpreadInit:598 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | SetSpreadInit:600, FindData_Main:951 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | SetSpreadInit:602 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | EditModeOff | SpdMain_EditModeOff | InitializeComponent:505 |
| this.spdMain | EditChange | SpdMain_EditChange | InitializeComponent:506 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:507 |
| this | Load | Form_Load | .ctor:209 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:772 |
| this.rdUOM | CheckedChanged | rdButton_Changed | InitEvent:774 |
| this.rdCell | CheckedChanged | rdButton_Changed | InitEvent:775 |
| cboPlanDateStart | SelectedIndexChanged | CboPlanDateStart_SelectedIndexChanged | InitEvent:776 |
| cboPlanDateEnd | SelectedIndexChanged | CboPlanDateEnd_SelectedIndexChanged | InitEvent:777 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:779 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:780 |
| spdMain | CellClick | SpdMain_CellClick | InitEvent:781 |
| this.btnColumn | Click | BtnColumn_Click | InitEvent:782 |
| dsdmMain | Changed | SpdMain_Changed | InitEvent:785 |
| spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:787 |
| this.spdMain | ActiveSheetChanged | SpdMain_ActiveSheetChanged | InitEvent:789 |

## 6. 컨트롤 (23개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | layoutControlItem1, layoutControlItem3, layoutControlItem11, layoutControlItem16, layoutControlItem2, PlanDate, PlanDateStart |
| UsrCombo | 3 | cboDivision, cboPlanDateEnd, cboPlanDateStart |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrRadio | 2 | rdCell, rdUOM |
| SheetView | 2 | spdMain_Sheet1, spdExcept_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrButton | 1 | btnColumn |
| UsrCheckedList2 | 1 | clbPlant |
| EmptySpaceItem | 1 | emptySpaceItem8 |
| FpSpread | 1 | spdMain |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 11 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 10 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 10 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 11 | dbmeta_dbo_TB_FX_Favorite.csv |
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
| SCM_MST_SHEET_COLUMNS | SCP0076 | Production Result Check | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Production Result Check
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetSpreadInit:600, SetSheetHeaderColumn@FindData_Main:951
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetColumnVisible

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 441 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | PROD_PLAN_SCP_{?dr[DefColumns.ISO_YYYYWW]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 443 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 444 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 445 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 448 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | PROD_PLAN_FP_{?dr[DefColumns.ISO_YYYYWW]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 450 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 451 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 452 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 458 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | PROD_RESULT_{?dr[DefColumns.ISO_YYYYWW]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 460 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 461 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 462 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 465 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | PROD_RESULT_TOT_{?dr[DefColumns.ISO_YYYYWW]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 467 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 468 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 469 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 474 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | CO_RATE_{?dr[DefColumns.ISO_YYYYWW]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 476 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 477 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 478 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 482 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | AC_RATE_{?dr[DefColumns.ISO_YYYYWW]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 484 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 485 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 486 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 492 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | PROD_PLAN_SCP_CELL_{?dr[DefColumns.ISO_YYYYWW]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 494 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 495 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 496 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 499 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | PROD_PLAN_FP_CELL_{?dr[DefColumns.ISO_YYYYWW]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 501 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 502 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 503 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 508 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | PROD_RESULT_CELL_{?dr[DefColumns.ISO_YYYYWW]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 510 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 511 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 512 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 515 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | PROD_RESULT_TOT_CELL_{?dr[DefColumns.ISO_YYYYWW]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 517 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 518 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 519 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 523 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | CO_RATE_CELL_{?dr[DefColumns.ISO_YYYYWW]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 525 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 526 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 527 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 531 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | AC_RATE_CELL_{?dr[DefColumns.ISO_YYYYWW]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 533 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 534 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 535 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn |  | 556 | DB루프 | AddComboColumn | {?dr[DefColumns.WEEK_NAME]} | REASON_CODE | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate != sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 557 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate != sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 558 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate != sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 559 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate != sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 563 | DB루프 | AddTextColumn | {?dr[DefColumns.WEEK_NAME]} | REASON_DESCRIPTION | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate != sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 564 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate != sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 565 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate != sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 566 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate != sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 581 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate != sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 582 | 표시/라벨 변경 | set:Font | Font = {?fontCellBold} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate != sBasisYyyymmdd) |
| SetSpreadInit |  | 606 | 표시/라벨 변경 | local:SetColumnVisible |  |  |  |
| SetColumnVisible |  | 658 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case ""/"ACTION"/"PLAN_START_YYYYMMDD"/"PLAN_WEEK"/"OPERATION_GROUP"/"DIVISION_ID"/"PLANT_ID" |
| SetColumnVisible |  | 666 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case "DIVISION_NAME"/"CELL_TYPE_GR"/"OPERATION_GROUP_NAME"/"PLANT_NAME"/"MODEL_TYPE_GR" |
| SetColumnVisible |  | 671 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case "REASON_CODE"/"REASON_DESCRIPTION" |
| SetColumnVisible |  | 689 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case "PROD_PLAN_SCP"/"PROD_PLAN_FP"/"PROD_RESULT"/"PROD_RESULT_TOT"/"CO_RATE"/"AC_RATE"/"PROD_PLAN_SCP_CELL"/"PROD_PLAN_FP_CELL"/"PROD_RESULT_CELL"/"PROD_RESULT_TOT_CELL"/"CO_RATE_CELL"/"AC_RATE_CELL" ⟫ if(useVisible) |
| SetColumnVisible |  | 690 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case "PROD_PLAN_SCP"/"PROD_PLAN_FP"/"PROD_RESULT"/"PROD_RESULT_TOT"/"CO_RATE"/"AC_RATE"/"PROD_PLAN_SCP_CELL"/"PROD_PLAN_FP_CELL"/"PROD_RESULT_CELL"/"PROD_RESULT_TOT_CELL"/"CO_RATE_CELL"/"AC_RATE_CELL" ⟫ if(useVisible) |
| SetColumnVisible |  | 691 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case "PROD_PLAN_SCP"/"PROD_PLAN_FP"/"PROD_RESULT"/"PROD_RESULT_TOT"/"CO_RATE"/"AC_RATE"/"PROD_PLAN_SCP_CELL"/"PROD_PLAN_FP_CELL"/"PROD_RESULT_CELL"/"PROD_RESULT_TOT_CELL"/"CO_RATE_CELL"/"AC_RATE_CELL" ⟫ if(useVisible) |
| SetColumnVisible |  | 692 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case "PROD_PLAN_SCP"/"PROD_PLAN_FP"/"PROD_RESULT"/"PROD_RESULT_TOT"/"CO_RATE"/"AC_RATE"/"PROD_PLAN_SCP_CELL"/"PROD_PLAN_FP_CELL"/"PROD_RESULT_CELL"/"PROD_RESULT_TOT_CELL"/"CO_RATE_CELL"/"AC_RATE_CELL" ⟫ if(useVisible) |
| SetColumnVisible |  | 693 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case "PROD_PLAN_SCP"/"PROD_PLAN_FP"/"PROD_RESULT"/"PROD_RESULT_TOT"/"CO_RATE"/"AC_RATE"/"PROD_PLAN_SCP_CELL"/"PROD_PLAN_FP_CELL"/"PROD_RESULT_CELL"/"PROD_RESULT_TOT_CELL"/"CO_RATE_CELL"/"AC_RATE_CELL" ⟫ if(useVisible) |
| SetColumnVisible |  | 694 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case "PROD_PLAN_SCP"/"PROD_PLAN_FP"/"PROD_RESULT"/"PROD_RESULT_TOT"/"CO_RATE"/"AC_RATE"/"PROD_PLAN_SCP_CELL"/"PROD_PLAN_FP_CELL"/"PROD_RESULT_CELL"/"PROD_RESULT_TOT_CELL"/"CO_RATE_CELL"/"AC_RATE_CELL" ⟫ if(useVisible) |
| SetColumnVisible |  | 695 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case "PROD_PLAN_SCP"/"PROD_PLAN_FP"/"PROD_RESULT"/"PROD_RESULT_TOT"/"CO_RATE"/"AC_RATE"/"PROD_PLAN_SCP_CELL"/"PROD_PLAN_FP_CELL"/"PROD_RESULT_CELL"/"PROD_RESULT_TOT_CELL"/"CO_RATE_CELL"/"AC_RATE_CELL" ⟫ if(useVisible) |
| SetColumnVisible |  | 696 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case "PROD_PLAN_SCP"/"PROD_PLAN_FP"/"PROD_RESULT"/"PROD_RESULT_TOT"/"CO_RATE"/"AC_RATE"/"PROD_PLAN_SCP_CELL"/"PROD_PLAN_FP_CELL"/"PROD_RESULT_CELL"/"PROD_RESULT_TOT_CELL"/"CO_RATE_CELL"/"AC_RATE_CELL" ⟫ if(useVisible) |
| SetColumnVisible |  | 697 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case "PROD_PLAN_SCP"/"PROD_PLAN_FP"/"PROD_RESULT"/"PROD_RESULT_TOT"/"CO_RATE"/"AC_RATE"/"PROD_PLAN_SCP_CELL"/"PROD_PLAN_FP_CELL"/"PROD_RESULT_CELL"/"PROD_RESULT_TOT_CELL"/"CO_RATE_CELL"/"AC_RATE_CELL" ⟫ if(useVisible) |
| SetColumnVisible |  | 698 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case "PROD_PLAN_SCP"/"PROD_PLAN_FP"/"PROD_RESULT"/"PROD_RESULT_TOT"/"CO_RATE"/"AC_RATE"/"PROD_PLAN_SCP_CELL"/"PROD_PLAN_FP_CELL"/"PROD_RESULT_CELL"/"PROD_RESULT_TOT_CELL"/"CO_RATE_CELL"/"AC_RATE_CELL" ⟫ if(useVisible) |
| SetColumnVisible |  | 699 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case "PROD_PLAN_SCP"/"PROD_PLAN_FP"/"PROD_RESULT"/"PROD_RESULT_TOT"/"CO_RATE"/"AC_RATE"/"PROD_PLAN_SCP_CELL"/"PROD_PLAN_FP_CELL"/"PROD_RESULT_CELL"/"PROD_RESULT_TOT_CELL"/"CO_RATE_CELL"/"AC_RATE_CELL" ⟫ if(useVisible) |
| SetColumnVisible |  | 700 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case "PROD_PLAN_SCP"/"PROD_PLAN_FP"/"PROD_RESULT"/"PROD_RESULT_TOT"/"CO_RATE"/"AC_RATE"/"PROD_PLAN_SCP_CELL"/"PROD_PLAN_FP_CELL"/"PROD_RESULT_CELL"/"PROD_RESULT_TOT_CELL"/"CO_RATE_CELL"/"AC_RATE_CELL" ⟫ if(useVisible) |
| SetColumnVisible |  | 701 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case "PROD_PLAN_SCP"/"PROD_PLAN_FP"/"PROD_RESULT"/"PROD_RESULT_TOT"/"CO_RATE"/"AC_RATE"/"PROD_PLAN_SCP_CELL"/"PROD_PLAN_FP_CELL"/"PROD_RESULT_CELL"/"PROD_RESULT_TOT_CELL"/"CO_RATE_CELL"/"AC_RATE_CELL" ⟫ if(useVisible) |
| SetColumnVisible |  | 709 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case  |
| SetColumnVisible |  | 716 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case  ⟫ if(colName.StartsWith("REASON")) ⟫ if(p_plan_date_end == colNameLastWW) |
| SetColumnVisible |  | 726 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case  ⟫ else!(colName.StartsWith("REASON")) ⟫ switch(colNameLast)case "DEN" |
| SetColumnVisible |  | 729 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case  ⟫ else!(colName.StartsWith("REASON")) ⟫ switch(colNameLast)case "CELL" |
| SetColumnVisible |  | 732 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  | for(iCol < siMain.ActiveSheet.ColumnCount) ⟫ switch(colName)case  ⟫ else!(colName.StartsWith("REASON")) ⟫ switch(colNameLast)case  |
| rdButton_Changed |  | 1187 | 표시/라벨 변경 | local:SetColumnVisible |  |  |  |
| InitializeComponent |  | 523 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 524 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 525 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 526 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Production Result Check | META+코드연결 | 19 (?2) | 19 (?2) | 19 (?2) | 19 (?2) | 19 (?2) | 19 (?2) | 19 (?2) | 19 (?2) | 19 (?2) | 19 (?2) | 19 (?2) | 19 (?2) | 19 (?2) | 19 (?2) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:조회데이터 28 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 28건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
