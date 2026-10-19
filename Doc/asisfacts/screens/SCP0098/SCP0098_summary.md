# SCP0098 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0098_CAPAReprotSmall\POPUP\SCP0098_CopySelect_Popup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0098_CAPAReprotSmall\SCP0098_CAPAReprotSmall.csproj | 146 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0098_CAPAReprotSmall\POPUP\SCP0098_CopySelect_Popup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0098_CAPAReprotSmall\SCP0098_CAPAReprotSmall.csproj | 114 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0098_CAPAReprotSmall\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0098_CAPAReprotSmall\SCP0098_CAPAReprotSmall.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0098_CAPAReprotSmall\SCP0098_CAPAReprotSmall.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0098_CAPAReprotSmall\SCP0098_CAPAReprotSmall.csproj | 4201 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0098_CAPAReprotSmall\SCP0098_CAPAReprotSmall.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0098_CAPAReprotSmall\SCP0098_CAPAReprotSmall.csproj | 1105 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1874 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1883 | biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1890 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > GetLastRange | 3075 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| button:FindButton | FindButton > FindData_Main | 702 | SCP.SCP0098_GET_CAPA_MobilityIT | MATCH | SP SCP0098_GET_CAPA_MobilityIT |
| button:FindButton | FindButton > FindData_Main > InitSpread > SetSpreadInit > GetSpdTitle | 3040 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveDataFull > FindData_Main | 702 | SCP.SCP0098_GET_CAPA_MobilityIT | MATCH | SP SCP0098_GET_CAPA_MobilityIT |
| button:SaveButton | SaveButton > SaveDataFull | 2219 | SCP.SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE | MATCH | SP SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE |
| button:SaveButton | SaveButton > SaveDataFull | 2275 | SCP.SCP0098_SAVE_SCP_CAPA | MATCH | SP SCP0098_SAVE_SCP_CAPA |
| button:SaveButton | SaveButton > SaveDataFull | 2332 | SCP.SCP0098_SAVE_SCP_CAPA_WORK | MATCH | SP SCP0098_SAVE_SCP_CAPA_WORK |
| button:SaveButton | SaveButton > SaveDataFull > FindData_Main > InitSpread > SetSpreadInit > GetSpdTitle | 3040 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnCopyData.Click | btnCopyData_Click > FindData_Main | 702 | SCP.SCP0098_GET_CAPA_MobilityIT | MATCH | SP SCP0098_GET_CAPA_MobilityIT |
| event:this.btnCopyData.Click | btnCopyData_Click > FindData_Main > InitSpread > SetSpreadInit > GetSpdTitle | 3040 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnCopyData.Click | btnCopyData_Click > SCM_SYS_LOG_BATCH | 3336 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.btnCopyData.Click | btnCopyData_Click | 3762 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SCP0098_COPY_MONTH_WEEK] | BIZ_MATCH |  |
| event:this.btnCopyData.Click | btnCopyData_Click | 3762 | SCP\Master\SCP0098_CAPAReprotSmall#SCP0098_COPY_MONTH_WEEK | MATCH_PATTERN | SP SCP0098_COPY_MONTH_WEEK |
| event:this.btnMeasure.Click | BtnMeasure_Click > InitSpread > SetSpreadInit > GetSpdTitle | 3040 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > SetSpreadInit > GetSpdTitle | 3040 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1874 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1883 | biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1890 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > GetSpdTitle | 3040 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetLastRange | 3075 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| event:this.Load | Form_Load > InitControls > GetDayRange | 3095 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.Load | Form_Load > GetSpdTitle2 | 3363 | SCM.SCM_SYS_GET_SPREAD_TITLE | MATCH | SP SCM_SYS_GET_SPREAD_TITLE |
| unreached:(진입점 미연결) | <field:dtElectrodeType> | 52 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveData_CAPA | 2764 | SCP.SCP0098_SAVE_SCP_CAPA | MATCH | SP SCP0098_SAVE_SCP_CAPA |
| unreached:(진입점 미연결) | SaveData_CAPA_PRODUCT_RATE | 2832 | SCP.SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE | MATCH | SP SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE |
| unreached:(진입점 미연결) | SaveData_CAPA_PRODUCT_RATE_OLD | 2900 | SCP.SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE | MATCH | SP SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE |
| unreached:(진입점 미연결) | SaveData_CAPA_WORK | 2969 | SCP.SCP0098_SAVE_SCP_CAPA_WORK | MATCH | SP SCP0098_SAVE_SCP_CAPA_WORK |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SCP0098_COPY_MONTH_WEEK] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:REF:FN_CHAR_TO_DATE, UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V, UP_FX_GetCommonDataList:SELECT:SCM_SYS_CALENDAR_M, UP_FX_GetCommonDataList:SELECT:SCP_PLN_INTERFACE_YN, UP_FX_GetCommonDataList:REF:FN_SPLITSTRING |
| biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_LINE_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| SCM.SCM_SYS_GET_SPREAD_TITLE | MATCH | 1 | SP SCM_SYS_GET_SPREAD_TITLE | EXEC:SCM_SYS_GET_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD | EXEC:SCM0001_GET_SCP_DAILY_PLAN_PERIOD, SELECT:SCM_MST_DIVISION |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0098_GET_CAPA_MobilityIT | MATCH | 1 | SP SCP0098_GET_CAPA_MobilityIT | EXEC:SCP0098_GET_CAPA_MOBILITYIT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#TMP_SCM_ITEM_M_SN, SELECT:SCM_ITEM_M_SN, INSERT:#TMP_SCP0098_ITEM_LIST, SELECT:SCM_LINE_HIERARCHY_V_SN, REF:STRING_SPLIT, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:#TMP_SCM_ITEM_M_SN, INSERT:#TMP_SCP0098_ITEM_LIST_YYYYMM, SELECT:#TMP_SCP0098_ITEM_LIST, INSERT:#TMP_SCP0098_STD_LINE_DATA, INSERT:#TMP_SCP0098_STD_ITEM_DATA, REF:FN_GET_ITEM_NICKNAME, INSERT:#TARGET_MEASURES, SELECT:TARGET_MEASURES, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#TMP_SCP0098_STD_LINE_MEASURE, SELECT:#TMP_SCP0098_STD_LINE_DATA, SELECT:#TARGET_MEASURES, INSERT:#TMP_SCP0098_STD_LINE_MEASURE_DISTINCT, SELECT:#TMP_SCP0098_STD_LINE_MEASURE, INSERT:#TMP_SCP0098_STD_ITEM_MEASURE, SELECT:#TMP_SCP0098_STD_ITEM_DATA, INSERT:#TMP_PROD_READY_RATE, SELECT:SCP_MST_CAPA_WORK, INSERT:#TMP_MEASURE_CAPA_WORK, INSERT:#TMP_MEASURE_CAPA_WORK_DAILYCAPA, SELECT:#TMP_MEASURE_CAPA_WORK, INSERT:#TMP_DAILYCAPA_DAY, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TMP_SCP0098_ITEM_LIST_YYYYMM_TERM, SELECT:W_ITEM_LIST, SELECT:W_YYYYMMDD, SELECT:#TMP_DAILYCAPA_DAY, SELECT:#TMP_SCP0098_ITEM_LIST_YYYYMM, INSERT:#TMP_MEASURE_CAPA, SELECT:#TMP_SCP0098_ITEM_LIST_YYYYMM_TERM, SELECT:SCP_MST_CAPA, INSERT:#TMP_MEASURE_CAPA_NOWORK, INSERT:#TMP_OEE_TERM, INSERT:#SCP_MST_CAPA_YYYYMMDD, SELECT:#TMP_MEASURE_CAPA, INSERT:#TMP_MEASURE_CAPA_WORK_NOWORK, INSERT:#TMP_MEASURE_CAPA_WORK_LOADRATE, INSERT:#TMP_MEASURE_CAPA_WORK_RAMPUP, UPDATE:#SCP_MST_CAPA_YYYYMMDD, SELECT:#SCP_MST_CAPA_YYYYMMDD, SELECT:#TMP_MEASURE_CAPA_WORK_NOWORK, SELECT:#TMP_MEASURE_CAPA_WORK_LOADRATE, SELECT:#TMP_MEASURE_CAPA_WORK_RAMPUP, SELECT:#TMP_PROD_READY_RATE, SELECT:#TMP_MEASURE_CAPA_NOWORK, UPDATE:A, SELECT:SCM_MST_FACTORY_SN, INSERT:#SCP_MST_CAPA_YYYYMMDD_CALC, INSERT:#TMP_FIELD, SELECT:#TMP_FIELD, DYNAMIC@SCP0098_GET_CAPA_MOBILITYIT |  |
| SCP.SCP0098_SAVE_SCP_CAPA | MATCH | 2 | SP SCP0098_SAVE_SCP_CAPA | EXEC:SCP0098_SAVE_SCP_CAPA, REF:SCM_ARR_SPL_CNT, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_VAL, MERGE:SCP_MST_CAPA, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE | MATCH | 3 | SP SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE | EXEC:SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE, REF:SCM_ARR_SPL_CNT, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_VAL, MERGE:SCP_MST_CAPA_WORK, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0098_SAVE_SCP_CAPA_WORK | MATCH | 2 | SP SCP0098_SAVE_SCP_CAPA_WORK | EXEC:SCP0098_SAVE_SCP_CAPA_WORK, REF:SCM_ARR_SPL_CNT, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_VAL, MERGE:SCP_MST_CAPA_WORK, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP\Master\SCP0098_CAPAReprotSmall#SCP0098_COPY_MONTH_WEEK | MATCH_PATTERN | 1 | SP SCP0098_COPY_MONTH_WEEK | EXEC:SCP0098_COPY_MONTH_WEEK, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, SELECT:SCM_SYS_CALENDAR_M, MERGE:SCP_MST_CAPA_WORK, SELECT:SCP_MST_CAPA_WORK, MERGE:SCP_MST_CAPA, SELECT:SCP_MST_CAPA, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnCopyData_Click | result.Rows[0] | result_code, err_code, err_message |
| GetDayOfWeek | row | COLUMN_NAME |
| GetDayOfWeek | dr | DAY_CODE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:241, FindData_Main:654, FindData_Main:655, FindData_Main:657, FindData_Main:660, SetChangedControl:1860, SetChangedControl:1878, GetDayRange:3091 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | SetSpreadInit:265 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | SetSpreadInit:267 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | SetSpreadInit:271 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | MeasureSetForm_Load | InitializeComponent:93 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:94 |
| rbOpt1 | CheckedChanged | rbOpt1_Click | MeasureSetForm_Load:86 |
| rbOpt2 | CheckedChanged | rbOpt2_Click | MeasureSetForm_Load:87 |
| this.btnInput | Click | btnInput_Click | InitializeComponent:211 |
| this.btnCopyData | Click | btnCopyData_Click | InitializeComponent:250 |
| this | Load | Form_Load | .ctor:162 |
| dsdmLine | Changed | SpdMain_Changed | Form_Load:176 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:390 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:392 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:393 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:395 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:396 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:398 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:399 |
| this.btnMeasure | Click | BtnMeasure_Click | InitEvent:400 |
| this.spdMain | ClipboardPasting | SpdMain_ClipboardPasting | InitEvent:402 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:403 |
| chkDetail | CheckedChanged | ChkDetail_CheckedChanged | InitEvent:405 |
| dsdmLine | Changed | SpdMain_Changed | FindData_Main:644 |
| dsdmLine | Changed | SpdMain_Changed | FindData_Main:780 |

## 6. 컨트롤 (44개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 15 | Division, layoutControlItem16, layoutControlItem19, layoutControlItem14, layoutControlItem2, layoutControlItem7, layoutControlItem4, layoutControlItem13, lblBucket, layoutControlItem1, layoutControlItem3, layoutControlItem5, layoutControlItem6, layoutControlItem8, layoutControlItem9 |
| UsrButton | 5 | usrButton1, btnInput, btnCopyData, btnItemId, btnMeasure |
| UsrCombo | 4 | cboDivision, cboBucketType, cboCategory, cboDayWeek |
| EmptySpaceItem | 4 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem4 |
| RadioButton | 2 | rbOpt2, rbOpt1 |
| UsrCheckedList2 | 2 | clbLine, clbPlantSite |
| TextBox | 2 | txtNickName, txtInpuValue |
| Panel | 1 | panel1 |
| Label | 1 | label_msg |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckBox | 1 | chkDetail |
| UsrDateRangePicker3 | 1 | dCalendar |
| UsrTextBox | 1 | txtItemId |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 3762 | btnCopyData_Click | {?definition_path}#SCP0098_COPY_MONTH_WEEK | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 179 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 19 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 4 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 28 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0098 | CAPA_SMALL | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_MEASURE | SCP0098 | CAPA_SMALL | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 112건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: CAPA_SMALL
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetSpreadInit:267
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet, InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadInit |  | 279 | 표시/라벨 변경 | set:Tag | Tag = {?string.Format(GetNowMonth(), "월\r\nCapa/일(OEE 반영)")} |  |  |
| InitSpreadDateColumn |  | 336 | DB루프 | AddNumColumn | {?string.Empty} \|\| {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?string.Empty} \|\| {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 340 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetLayout |  | 3202 | 표시/라벨 변경 | VisibleColumns | 0 |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ if(colName.IndexOf("D_") == 0) |
| SetLayout |  | 3204 | 표시/라벨 변경 | VisibleColumns | 0 |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ if(colName.IndexOf("M_") == 0) |
| SetSpreadColumn |  | 3234 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= RowCount) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ if(colName.IndexOf("D_") == 0) |
| SetSpreadColumn |  | 3235 | 표시/라벨 변경 | set:CellType | CellType = {?textType} |  | for(iCol <= RowCount) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ if(colName.IndexOf("D_") == 0) |
| SetSpreadColumn |  | 3236 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?CellHorizontalAlignment.Right} |  | for(iCol <= RowCount) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ if(colName.IndexOf("D_") == 0) |
| SetSpreadColumn |  | 3241 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= RowCount) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ else!(colName.IndexOf("D_") == 0) ⟫ if(colName.IndexOf("M_") == 0) |
| SetSpreadColumn |  | 3245 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= RowCount) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ else!(colName.IndexOf("D_") == 0) ⟫ else!(colName.IndexOf("M_") == 0) ⟫ if(colName.IndexOf("W_") == 0) |
| SetSpreadColumn |  | 3249 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= RowCount) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ else!(colName.IndexOf("D_") == 0) ⟫ else!(colName.IndexOf("M_") == 0) ⟫ else!(colName.IndexOf("W_") == 0) ⟫ if(colName.IndexOf("PR_M_") == 0) |
| InitializeComponent |  | 990 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 991 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 992 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 993 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| CAPA_SMALL | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
