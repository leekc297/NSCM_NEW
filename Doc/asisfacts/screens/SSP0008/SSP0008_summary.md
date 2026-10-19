# SSP0008 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0008_ProductionPlanLine.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 2570 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0008_ProductionPlanLine.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1172 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1214 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1223 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1227 | biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1235 | biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1242 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:cboOperationGroup.SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | 2427 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboOperationGroup.SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | 2436 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 2448 | biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 2552 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 2468 | biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 1375 | SSP.SSP0008_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SSP0008_GET_PRODUCTION_PLAN_LINEBY |
| button:FindButton | FindButton > Get_IsEditInfo | 2165 | SSP.SSP0008_GET_PLAN_EDIT_INFO | MATCH | SP SSP0008_GET_PLAN_EDIT_INFO |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 2530 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo > FindData_Main | 1375 | SSP.SSP0008_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SSP0008_GET_PRODUCTION_PLAN_LINEBY |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo | 2051 | SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | MATCH | SP SCP0024_SAVE_PRODUCTION_PLAN_FIX |
| event:this.btnFix.Click | btnFix_Click > SaveData_FixInfo > FindData_Main > InitSpread > GetSpdTitle | 2530 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | BtnMeasure_Click > InitSpread > GetSpdTitle | 2530 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo > FindData_Main | 1375 | SSP.SSP0008_GET_PRODUCTION_PLAN_LINEBY | MATCH | SP SSP0008_GET_PRODUCTION_PLAN_LINEBY |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo | 2051 | SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | MATCH | SP SCP0024_SAVE_PRODUCTION_PLAN_FIX |
| event:this.btnUnfix.Click | btnUnfix_Click > SaveData_FixInfo > FindData_Main > InitSpread > GetSpdTitle | 2530 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1182 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1214 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1223 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1227 | biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1235 | biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1242 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2530 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetDayRange | 2552 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| unreached:(진입점 미연결) | <field:dtElectrode> | 54 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetLastPlanVersion | 1281 | SSP.SSP_GET_LAST_PLAN_VERSION | MATCH | SP SSP_GET_LAST_PLAN_VERSION |
| unreached:(진입점 미연결) | SaveData_Line | 1580 | SSP.SSP0007_SAVE_PRODUCTION_PLAN_LINE | MATCH | SP SSP0007_SAVE_PRODUCTION_PLAN_LINE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_LINE_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SSP_ANL_SHIP_PLAN_P, UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | MATCH | 1 | SP SCP0024_SAVE_PRODUCTION_PLAN_FIX | EXEC:SCP0024_SAVE_PRODUCTION_PLAN_FIX, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_ANL_PRODUCTION_PLAN_FIX, EXEC:PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX, UPDATE:SCP_ANL_PRODUCTION_PLAN_FIX, DELETE:SCP_ANL_PRODUCTION_PLAN_FIX, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX_H |  |
| SSP.SSP_GET_LAST_PLAN_VERSION | MATCH | 1 | SP SSP_GET_LAST_PLAN_VERSION | EXEC:SSP_GET_LAST_PLAN_VERSION, REF:FN_GET_SSP_LAST_PLAN_VERSION_ID, REF:FN_SCM_SPLIT, SELECT:SSP_PLAN_VERSION_V |  |
| SSP.SSP0007_SAVE_PRODUCTION_PLAN_LINE | MATCH | 1 | SP SSP0007_SAVE_PRODUCTION_PLAN_LINE | EXEC:SSP0007_SAVE_PRODUCTION_PLAN_LINE | ⚠ DB에 SP 없음 |
| SSP.SSP0008_GET_PLAN_EDIT_INFO | MATCH | 1 | SP SSP0008_GET_PLAN_EDIT_INFO | EXEC:SSP0008_GET_PLAN_EDIT_INFO, REF:FN_ZERO_LPAD, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_MODELING, REF:FN_GET_BUCKET_YYYYMMDD, SELECT:SCM_SYS_CALENDAR_M, SELECT:SSP_ANL_PRODUCTION_PLAN, REF:STRING_SPLIT, SELECT:SCM_MST_SITE, REF:FN_DATE_TO_CHAR, REF:FN_GET_START_YYYYMMDD |  |
| SSP.SSP0008_GET_PRODUCTION_PLAN_LINEBY | MATCH | 1 | SP SSP0008_GET_PRODUCTION_PLAN_LINEBY | EXEC:SSP0008_GET_PRODUCTION_PLAN_LINEBY, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TBLDYNAMICPIVOT_SCP0013_NICKITEM_1, SELECT:SSP_ANL_PRODUCTION_PLAN, SELECT:SCM_MST_ITEM_SN, INSERT:#TBLDYNAMICPIVOT_SCP0013_NICKITEM_2, INSERT:#TBLDYNAMICPIVOT_SSP0008_1, REF:STRING_SPLIT, INSERT:#TBLDYNAMICPIVOT_SSP0008_2, INSERT:#TBLDYNAMICPIVOT_SCP0013_TMP, INSERT:#TBLDYNAMICPIVOT_SSP0008, SELECT:#TBLDYNAMICPIVOT_SCP0013_TMP, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_DNM_PRODUCT_RESULT_V, SELECT:SCP_ANL_WORKING_TIME, SELECT:SCP_ANL_TACT_TIME, SELECT:#TBLDYNAMICPIVOT_SSP0008_1, SELECT:#TBLDYNAMICPIVOT_SSP0008_2, DYNAMIC@SSP0008_GET_PRODUCTION_PLAN_LINEBY, SELECT:SCP_ANL_PRODUCTION_PLAN_FIX |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| CalculateSum | dr | measure |
| EditButton | drs[0] | osp_yn, fp_plan_period, offset, edit_start_date, confirm_yn, date_chk, is_editable, plan_start_yyyymmdd, plan_type, plan_seq |
| EditButton | dtPlanType.Rows[dtPlanType.Rows.Count - 1] | CODE |
| EditButton | dtPlanSeq.Rows[0] | CODE |
| GetLastPlanVersion | dsBinding.Tables[0].Rows[0] | PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ |
| SaveData_Line_DT | dr | A, p_active_flag, p_division_id, p_plan_start_yyyymmdd, p_plan_type, p_seq, p_operation_group, p_scm_site_id, p_item_id, p_line_id, p_operation_id, p_measure, p_yyyymmdd, p_qty, p_fix, p_loc_flag, p_user_id, p_program_id, debug_mode |
| SaveData_Line_DT | dsInput.Tables[0].Rows[0] | p_loc_flag |
| SaveData_Line_DT | dsInput.Tables[0].Rows[nRowCnt - 1] | p_loc_flag |
| SaveData_Line_DT | row | A |
| Set_FixButtonEnabled | dtPlanSeq.Rows[0] | CODE |
| Set_FixCellColor | dr | FIX_KEY, YYYYMMDD, YYYYMM_WEEK |
| Set_FPOperationColor | drs[0] | osp_yn, fp_plan_period, offset, edit_start_date, confirm_yn, date_chk, is_editable, plan_start_yyyymmdd, plan_type, plan_seq |
| Set_FPOperationColor | dtPlanType.Rows[dtPlanType.Rows.Count - 1] | CODE |
| Set_FPOperationColor | dtPlanSeq.Rows[0] | CODE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitSpread:251, SetChangedControl:1193, SetChangedControl:1206, SetChangedControl:1226, SetChangedControl:1234, SetChangedControl:1239, GetLastPlanVersion:1269, FindData_Main:1343 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:254 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:307 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:313 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetChanges | SaveData_Line_DT:1794 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnUnfix | Click | btnUnfix_Click | InitializeComponent:212 |
| this.btnFix | Click | btnFix_Click | InitializeComponent:249 |
| this | Load | Form_Load | .ctor:161 |
| dsdmLine | Changed | SpdMain_Changed | Form_Load:174 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:420 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:422 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:423 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:426 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:427 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:428 |
| cboOperationGroup | SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | InitEvent:431 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:433 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:434 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:435 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:436 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:437 |
| this.btnMeasure | Click | BtnMeasure_Click | InitEvent:441 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:845 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:950 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:958 |
| dsdmLine | Changed | SpdMain_Changed | CalculateSum:1072 |
| dsdmLine | Changed | SpdMain_Changed | CalculateDailyQty:1080 |
| dsdmLine | Changed | SpdMain_Changed | CalculateDailyQty:1127 |
| dsdmLine | Changed | SpdMain_Changed | CalculateDailyQty:1163 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:1271 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:1272 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:1273 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:1312 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:1313 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:1314 |
| dsdmLine | Changed | SpdMain_Changed | FindData_Main:1330 |
| dsdmLine | Changed | SpdMain_Changed | FindData_Main:1454 |

## 6. 컨트롤 (42개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 17 | PlanType, PlanDate, Division, layoutControlItem1, layoutControlItem6, SEQ, layoutControlItem7, lblBucket, layoutControlItem3, layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem9, lcElectrode, layoutControlItem13 … |
| UsrCombo | 6 | cboOperationGroup, cboDivision, cboPlanSeq, cboPlanDate, cboPlanType, cboBucketType |
| UsrButton | 5 | usrButton1, btnUnfix, btnFix, btnItemId, btnMeasure |
| UsrCheckedList | 3 | clbLine, clbPlantSite, clbElectrode |
| EmptySpaceItem | 2 | emptySpaceItem3, emptySpaceItem1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrMultiLineEditor | 1 | txtItemId |
| UsrCheckBox | 1 | chkSum |
| UsrDateRangePicker | 1 | drpPeriod |
| TextBox | 1 | txtNickName |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 8 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 22 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 2 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_GroupMenuAuth | 11 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 27 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 2551 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0008 | Line | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_MEASURE | SSP0008 | LINE | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Line
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:307
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Line | 323 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Line") ⟫ if(pDivisionID != "EE") |
| InitSpread | Line | 324 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Line") ⟫ if(pDivisionID != "EE") |
| InitSpread | Line | 328 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Line") ⟫ else!(pDivisionID != "EE") |
| InitSpread | Line | 329 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Line") ⟫ else!(pDivisionID != "EE") |
| InitSpreadDateColumn |  | 368 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 372 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 377 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 796 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 801 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 808 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 812 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 817 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 824 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 828 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol < siObj.ActiveSheet.ColumnCount) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 1059 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1060 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1061 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1062 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Line | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 10 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
