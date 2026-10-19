# SSP0007 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0007_ProductionPlan.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 2962 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0007_ProductionPlan.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1145 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 933 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 945 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 949 | biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 957 | biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH |  |
| event:cboOperationGroup.SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | 2591 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 2623 | biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 2836 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 2645 | biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Model_Parallel | 1245 | SSP.SSP0007_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SSP0007_GET_PRODUCTION_PLAN_MODEL |
| button:FindButton | FindButton > FindData_Model_Parallel | 1300 | SSP.SSP0007_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | MATCH | SP SSP0007_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL |
| button:FindButton | FindButton > FindData_Model_Parallel > FindData_Line | 1472 | SSP.SSP0007_GET_PRODUCTION_PLAN_LINE | MATCH | SP SSP0007_GET_PRODUCTION_PLAN_LINE |
| button:FindButton | FindButton > FindData_Model_Parallel > FindData_Line > InitSpread > GetSpdTitle | 2815 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData > FindData_Model_Parallel | 1245 | SSP.SSP0007_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SSP0007_GET_PRODUCTION_PLAN_MODEL |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData > FindData_Model_Parallel | 1300 | SSP.SSP0007_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | MATCH | SP SSP0007_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData > FindData_Model_Parallel > FindData_Line | 1472 | SSP.SSP0007_GET_PRODUCTION_PLAN_LINE | MATCH | SP SSP0007_GET_PRODUCTION_PLAN_LINE |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData > FindData_Model_Parallel > FindData_Line > InitSpread > GetSpdTitle | 2815 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData | 2888 | SCP.PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND | MATCH | SP PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 2815 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetBucketType | 900 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 933 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 945 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 949 | biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 957 | biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2815 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetDayRange | 2836 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Line | 1472 | SSP.SSP0007_GET_PRODUCTION_PLAN_LINE | MATCH | SP SSP0007_GET_PRODUCTION_PLAN_LINE |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > Get_IsEditInfo | 1602 | SSP.SSP0007_GET_PLAN_EDIT_INFO | MATCH | SP SSP0007_GET_PLAN_EDIT_INFO |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Line > InitSpread > GetSpdTitle | 2815 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | <field:dtElectrode> | 52 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetLastPlanVersion | 994 | SSP.SSP_GET_LAST_PLAN_VERSION | MATCH | SP SSP_GET_LAST_PLAN_VERSION |
| unreached:(진입점 미연결) | FindData_Model | 1077 | SSP.SSP0007_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SSP0007_GET_PRODUCTION_PLAN_MODEL |
| unreached:(진입점 미연결) | SaveData_Line | 2396 | SCP.SSP0007_SAVE_PRODUCTION_PLAN_LINE | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | ClbPlantSite_SelectedIndexChanged | 2614 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetDivision | 2768 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | SetChangedPeriod | 2782 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 2785 | biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SSP_ANL_SHIP_PLAN_P, UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCP.PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND | MATCH | 1 | SP PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND | EXEC:PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND, EXEC:PR_SCP_SYS_LOG_BATCH, UPDATE:X, SELECT:SCP_ANL_PRODUCTION_PLAN, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SSP0007_SAVE_PRODUCTION_PLAN_LINE | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| SSP.SSP_GET_LAST_PLAN_VERSION | MATCH | 1 | SP SSP_GET_LAST_PLAN_VERSION | EXEC:SSP_GET_LAST_PLAN_VERSION, REF:FN_GET_SSP_LAST_PLAN_VERSION_ID, REF:FN_SCM_SPLIT, SELECT:SSP_PLAN_VERSION_V |  |
| SSP.SSP0007_GET_PLAN_EDIT_INFO | MATCH | 1 | SP SSP0007_GET_PLAN_EDIT_INFO | EXEC:SSP0007_GET_PLAN_EDIT_INFO, REF:FN_ZERO_LPAD, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_MODELING, REF:FN_GET_BUCKET_YYYYMMDD, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_SITE, REF:FN_DATE_TO_CHAR, REF:FN_GET_START_YYYYMMDD |  |
| SSP.SSP0007_GET_PRODUCTION_PLAN_LINE | MATCH | 1 | SP SSP0007_GET_PRODUCTION_PLAN_LINE | EXEC:SSP0007_GET_PRODUCTION_PLAN_LINE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TBLDYNAMICPIVOT_SCP0007_02, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SSP_ANL_PRODUCTION_PLAN, SELECT:SCM_DNM_PRODUCT_RESULT_V, REF:STRING_SPLIT, DYNAMIC@SSP0007_GET_PRODUCTION_PLAN_LINE |  |
| SSP.SSP0007_GET_PRODUCTION_PLAN_MODEL | MATCH | 2 | SP SSP0007_GET_PRODUCTION_PLAN_MODEL | EXEC:SSP0007_GET_PRODUCTION_PLAN_MODEL, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, INSERT:#TBLDYNAMICPIVOT_SSP0007_NICKITEM, SELECT:SCM_MST_ITEM_SN, CREATE:#TBLDYNAMICPIVOT_SSP0007_02, DYNAMIC@SSP0007_GET_PRODUCTION_PLAN_MODEL, CREATE:#TBLDYNAMICPIVOT_SSP0007_03, INSERT:#TBLDYNAMICPIVOT_SSP0007_01, SELECT:SCM_MST_SHEET_MEASURE, SELECT:#TBLDYNAMICPIVOT_SSP0007_02, SELECT:#TBLDYNAMICPIVOT_SSP0007_03, EXEC:SP_EXECUTESQL |  |
| SSP.SSP0007_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | MATCH | 1 | SP SSP0007_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | EXEC:SSP0007_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, INSERT:#TBLDYNAMICPIVOT_SSP0007_NICKITEM, SELECT:SCM_MST_ITEM_SN, CREATE:#TBLDYNAMICPIVOT_SSP0007_02, DYNAMIC@SSP0007_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL, INSERT:#TBLDYNAMICPIVOT_SSP0007_01, SELECT:SCM_MST_SHEET_MEASURE, SELECT:#TBLDYNAMICPIVOT_SSP0007_02 |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| CalculateSum | dr | measure |
| EditButton | dtIsEditInfo.Rows[0] | osp_yn, fp_plan_period, offset, edit_start_date, confirm_yn, date_chk, is_editable, plan_start_yyyymmdd, plan_type, plan_seq |
| EditButton | dtPlanType.Rows[dtPlanType.Rows.Count - 1] | CODE |
| GetLastPlanVersion | dsBinding.Tables[0].Rows[0] | PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ |
| Set_FPOperationColor | dtIsEditInfo.Rows[0] | osp_yn, fp_plan_period, offset, edit_start_date, confirm_yn, date_chk, is_editable, plan_start_yyyymmdd, plan_type, plan_seq |
| Set_FPOperationColor | dtPlanType.Rows[dtPlanType.Rows.Count - 1] | CODE |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitSpread:264, SetChangedControl:921, SetChangedControl:923, SetChangedControl:948, SetChangedControl:956, GetLastPlanVersion:982, FindData_Model:1052, FindData_Model:1053 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:267 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:311, InitSpread:377 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:316, InitSpread:382 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnCal | Click | btnCal_Click | InitializeComponent:220 |
| this | Load | Form_Load | .ctor:159 |
| dsdmLine | Changed | SpdLine_Changed | SetDataTableDateColumn:487 |
| dsdmLine | Changed | SpdLine_Changed | SetDataTableDateColumn:499 |
| dsdmLine | Changed | SpdLine_Changed | SetDataTableQtyData:505 |
| dsdmLine | Changed | SpdLine_Changed | SetDataTableQtyData:538 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:544 |
| this.spdLine | CellDoubleClick | spdLine_CellDoubleClick | InitEvent:545 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:547 |
| this.spdLine | TopChange | SpdLine_TopChange | InitEvent:548 |
| this.btnMeasure | Click | btnMeasure_Click | InitEvent:550 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:551 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:552 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:553 |
| cboOperationGroup | SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | InitEvent:556 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:558 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:559 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:560 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:561 |
| spdLine | SelectionChanged | SpdLine_SelectionChanged | InitEvent:563 |
| dsdmLine | Changed | SpdLine_Changed | InitEvent:566 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:984 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:985 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:986 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:1025 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:1026 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:1027 |
| dsdmLine | Changed | SpdLine_Changed | FindData_Model_Parallel:1347 |
| dsdmLine | Changed | SpdLine_Changed | FindData_Model_Parallel:1361 |
| dsdmLine | Changed | SpdLine_Changed | CalculateSum:2056 |
| dsdmLine | Changed | SpdLine_Changed | CalculateSum:2160 |
| dsdmLine | Changed | SpdLine_Changed | CalculateSum:2168 |
| dsdmLine | Changed | SpdLine_Changed | CalculateSum:2279 |

## 6. 컨트롤 (44개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 15 | lblItemId, layoutControlItem2, layoutControlItem10, PlanType, PlanDate, Division, layoutControlItem1, layoutControlItem6, SEQ, layoutControlItem7, lblBucket, layoutControlItem8, layoutControlItem3, lcElectrode, layoutControlItem4 |
| UsrCombo | 6 | cboOperationGroup, cboDivision, cboPlanSeq, cboPlanDate, cboPlanType, cboBucketType |
| EmptySpaceItem | 5 | emptySpaceItem3, emptySpaceItem4, emptySpaceItem10, emptySpaceItem5, emptySpaceItem6 |
| UsrButton | 4 | usrButton1, btnCal, btnMeasure, btnItemId |
| UsrCheckedList | 2 | clbPlantSite, clbElectrode |
| FpSpread | 2 | spdMain, spdLine |
| SheetView | 2 | spdMain_Sheet1, spdLine_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckBox | 1 | chkSum |
| UsrDateRangePicker | 1 | drpPeriod |
| UsrMultiLineEditor | 1 | txtItemId |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SplitContainer | 1 | splitContainer1 |
| TextBox | 1 | txtNickName |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 2396 | SaveData_Line | SCP.SSP0007_SAVE_PRODUCTION_PLAN_LINE | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 22 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 36 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 9 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_GroupMenuAuth | 11 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 16 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (2건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1078 | SCP.SSP0007_GET_PRODUCTION_PLAN_MODEL_tuning3 | commented:NOT_IN_FOXQUERY |
| 2835 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0007 | Line | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SSP0007 | Model | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |
| SCM_MST_SHEET_MEASURE | SSP0007 | LINE | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 |
| SCM_MST_SHEET_MEASURE | SSP0007 | MODEL | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Model, Line
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:311, SetSheetHeaderColumn@InitSpread:377
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 326 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Model") ⟫ if(pDivisionID != "EE") |
| InitSpread |  | 327 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Model") ⟫ if(pDivisionID != "EE") |
| InitSpread |  | 331 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Model") ⟫ else!(pDivisionID != "EE") |
| InitSpread |  | 332 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Model") ⟫ else!(pDivisionID != "EE") |
| InitSpread |  | 392 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Line") ⟫ if(pDivisionID != "EE") |
| InitSpread |  | 393 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Line") ⟫ if(pDivisionID != "EE") |
| InitSpread |  | 397 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Line") ⟫ else!(pDivisionID != "EE") |
| InitSpread |  | 398 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Line") ⟫ else!(pDivisionID != "EE") |
| InitSpreadDateColumn |  | 436 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 440 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 444 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 854 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 859 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 866 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 870 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 875 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 882 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 886 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 967 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 968 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 969 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 970 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Line | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 10 | 8 | 8 | 8 | 8 | 8 |
| Model | META+코드연결 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 8 | 6 | 6 | 6 | 6 | 6 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
