# SCP0011 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0011_ProductionPlan\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0011_ProductionPlan\SCP0011_ProductionPlan.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0011_ProductionPlan\SCP0011_ProductionPlan.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0011_ProductionPlan\SCP0011_ProductionPlan.csproj | 3527 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0011_ProductionPlan\SCP0011_ProductionPlan.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0011_ProductionPlan\SCP0011_ProductionPlan.csproj | 1272 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Model_Parallel | 1378 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL |
| button:FindButton | FindButton > FindData_Model_Parallel | 1425 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL |
| button:FindButton | FindButton > FindData_Model_Parallel | 1494 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL |
| button:FindButton | FindButton > FindData_Model_Parallel > FindData_Line | 1639 | SCP.SCP0011_GET_PRODUCTION_PLAN_LINE | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_LINE |
| button:FindButton | FindButton > FindData_Model_Parallel > FindData_Line > InitSpread > GetSpdTitle | 3311 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Line > FindData_Model_Parallel | 1378 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL |
| button:SaveButton | SaveButton > SaveData_Line > FindData_Model_Parallel | 1425 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL |
| button:SaveButton | SaveButton > SaveData_Line > FindData_Model_Parallel | 1494 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL |
| button:SaveButton | SaveButton > SaveData_Line > FindData_Model_Parallel > FindData_Line | 1639 | SCP.SCP0011_GET_PRODUCTION_PLAN_LINE | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_LINE |
| button:SaveButton | SaveButton > SaveData_Line | 2806 | SCP.SCP0011_SAVE_PRODUCTION_PLAN_LINE | MATCH | SP SCP0011_SAVE_PRODUCTION_PLAN_LINE |
| button:SaveButton | SaveButton > SaveData_Line > FindData_Model_Parallel > FindData_Line > InitSpread > GetSpdTitle | 3311 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData > FindData_Model_Parallel | 1378 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData > FindData_Model_Parallel | 1425 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData > FindData_Model_Parallel | 1494 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData > FindData_Model_Parallel > FindData_Line | 1639 | SCP.SCP0011_GET_PRODUCTION_PLAN_LINE | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_LINE |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData > FindData_Model_Parallel > FindData_Line > InitSpread > GetSpdTitle | 3311 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnCal.Click | btnCal_Click > SaveChage_CalData | 3372 | SCP.PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND | MATCH | SP PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 3311 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetBucketType | 979 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 3311 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Line | 1639 | SCP.SCP0011_GET_PRODUCTION_PLAN_LINE | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_LINE |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > Get_IsEditInfo | 1771 | SCP.SCP0011_GET_PLAN_EDIT_INFO | MATCH | SP SCP0011_GET_PLAN_EDIT_INFO |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Line > InitSpread > GetSpdTitle | 3311 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | GetLastPlanVersion | 1134 | SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | SP SCP0011_GET_LAST_PLAN_VERSION |
| unreached:(진입점 미연결) | FindData_Model | 1217 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | SP SCP0011_GET_PRODUCTION_PLAN_MODEL |
| unreached:(진입점 미연결) | GetDivision | 3256 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | SetChangedPeriod | 3271 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 3275 | biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCP.PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND | MATCH | 1 | SP PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND | EXEC:PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND, EXEC:PR_SCP_SYS_LOG_BATCH, UPDATE:X, SELECT:SCP_ANL_PRODUCTION_PLAN, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | 1 | SP SCP0011_GET_LAST_PLAN_VERSION | EXEC:SCP0011_GET_LAST_PLAN_VERSION, REF:FN_GET_SCP_LAST_PLAN_VERSION_ID, REF:FN_SCM_SPLIT, SELECT:SCP_PLAN_VERSION_V |  |
| SCP.SCP0011_GET_PLAN_EDIT_INFO | MATCH | 1 | SP SCP0011_GET_PLAN_EDIT_INFO | EXEC:SCP0011_GET_PLAN_EDIT_INFO, REF:FN_ZERO_LPAD, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_MODELING, REF:FN_GET_BUCKET_YYYYMMDD, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_SITE, REF:FN_DATE_TO_CHAR, REF:FN_GET_START_YYYYMMDD |  |
| SCP.SCP0011_GET_PRODUCTION_PLAN_LINE | MATCH | 1 | SP SCP0011_GET_PRODUCTION_PLAN_LINE | EXEC:SCP0011_GET_PRODUCTION_PLAN_LINE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, CREATE:#TBLDYNAMICPIVOT_SCP0011_02, INSERT:#TBLDYNAMICPIVOT_SCP0011_02, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCP_ANL_PRODUCTION_PLAN, REF:STRING_SPLIT, SELECT:SCM_DNM_PRODUCT_RESULT_V, SELECT:SCM_MST_DIVISION, SELECT:HIST_SCP_ANL_PRODUCTION_PLAN, DYNAMIC@SCP0011_GET_PRODUCTION_PLAN_LINE |  |
| SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | MATCH | 3 | SP SCP0011_GET_PRODUCTION_PLAN_MODEL | EXEC:SCP0011_GET_PRODUCTION_PLAN_MODEL, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, INSERT:#TBLDYNAMICPIVOT_SCP0011_NICKITEM, SELECT:SCM_MST_ITEM_SN, CREATE:#TBLDYNAMICPIVOT_SCP0011_03, INSERT:#ISUZU, SELECT:SCM_MST_FINAL_ITEM_V, SELECT:SCP_MST_FINAL_ITEM_V, DYNAMIC@SCP0011_GET_PRODUCTION_PLAN_MODEL, INSERT:#TBLDYNAMICPIVOT_SCP0011_01, SELECT:SCM_MST_SHEET_MEASURE, SELECT:#TBLDYNAMICPIVOT_SCP0011_03, UPDATE:A, SELECT:#TBLDYNAMICPIVOT_SCP0011_01, EXEC:SP_EXECUTESQL |  |
| SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | MATCH | 1 | SP SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | EXEC:SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, INSERT:#TBLDYNAMICPIVOT_SCP0011_NICKITEM, SELECT:SCM_MST_ITEM_SN, CREATE:#TBLDYNAMICPIVOT_SCP0011_02, INSERT:#ISUZU, SELECT:SCM_MST_FINAL_ITEM_V, SELECT:SCP_MST_FINAL_ITEM_V, DYNAMIC@SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL, INSERT:#TBLDYNAMICPIVOT_SCP0011_01, SELECT:SCM_MST_SHEET_MEASURE, SELECT:#TBLDYNAMICPIVOT_SCP0011_02 |  |
| SCP.SCP0011_SAVE_PRODUCTION_PLAN_LINE | MATCH | 1 | SP SCP0011_SAVE_PRODUCTION_PLAN_LINE | EXEC:SCP0011_SAVE_PRODUCTION_PLAN_LINE, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, INSERT:#JV_ESS_LINE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP, INSERT:#JV_ESS_SCM_SITE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP, INSERT:#DIVISION_LAST_PLAN_INFO, SELECT:SCP_PLAN_INFO, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_DIVISION, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:#JV_ESS_LINE_MAP, SELECT:#JV_ESS_SCM_SITE_MAP, INSERT:#JV_LINE_SYNC_TARGET, EXEC:PR_SCP_ANL_PRODUCTION_PLAN_HIST, MERGE:SCP_ANL_PRODUCTION_PLAN, SELECT:SCP_ANL_PRODUCTION_PLAN, SELECT:#JV_LINE_SYNC_TARGET, SELECT:#DIVISION_LAST_PLAN_INFO, INSERT:SCP_ANL_PRODUCTION_PLAN_H, DELETE:SCP_ANL_PRODUCTION_PLAN, DELETE:PP, UPDATE:SCP_ANL_PRODUCTION_PLAN_FIX, SELECT:SCP_ANL_PRODUCTION_PLAN_FIX, EXEC:PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST, UPDATE:PF, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX_H, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_SITE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| CalculateSum | dr | measure |
| EditButton | dtIsEditInfo.Rows[0] | osp_yn, fp_plan_period, offset, edit_start_date, confirm_yn, date_chk, is_editable, plan_start_yyyymmdd, plan_type, plan_seq |
| EditButton | dtPlanType.Rows[dtPlanType.Rows.Count - 1] | CODE |
| GetLastPlanVersion | dsBinding.Tables[0].Rows[0] | PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ |
| SaveData_Line | dtErr.Rows[0] | ERR_MESSAGE |
| Set_FPOperationColor | dtIsEditInfo.Rows[0] | osp_yn, fp_plan_period, offset, edit_start_date, confirm_yn, date_chk, is_editable, plan_start_yyyymmdd, plan_type, plan_seq |
| Set_FPOperationColor | dtPlanType.Rows[dtPlanType.Rows.Count - 1] | CODE |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |
| SetFormationYield | dr | measure |
| SetFormationYield1 | dr | measure |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitSpread:276, InitSpread:325, _division:1004, _operationGroup:1011, _planDate:1019, _planType:1026, GetLastPlanVersion:1122, FindData_Model:1191 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:279 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:323, InitSpread:399 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:340, InitSpread:404 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnCal | Click | btnCal_Click | InitializeComponent:317 |
| this | Load | SCP0011_ProductionPlan_Load | InitializeComponent:1174 |
| this | Load | Form_Load | .ctor:175 |
| dsdmLine | Changed | SpdLine_Changed | SetDataTableDateColumn:513 |
| dsdmLine | Changed | SpdLine_Changed | SetDataTableDateColumn:525 |
| dsdmLine | Changed | SpdLine_Changed | SetDataTableQtyData:531 |
| dsdmLine | Changed | SpdLine_Changed | SetDataTableQtyData:564 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:571 |
| this.spdLine | CellDoubleClick | spdLine_CellDoubleClick | InitEvent:572 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:574 |
| this.spdLine | TopChange | SpdLine_TopChange | InitEvent:575 |
| this.btnMeasure | Click | btnMeasure_Click | InitEvent:577 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:578 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:579 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:580 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:582 |
| cboOperationGroup | SelectedIndexChanged | CboOperationGroup_SelectedIndexChanged | InitEvent:583 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:584 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:585 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:586 |
| spdLine | SelectionChanged | SpdLine_SelectionChanged | InitEvent:587 |
| dsdmLine | Changed | SpdLine_Changed | InitEvent:590 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:1124 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:1125 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:1126 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:1165 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:1166 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:1167 |
| dsdmLine | Changed | SpdLine_Changed | SetFormationYield1:2308 |
| dsdmLine | Changed | SpdLine_Changed | SetFormationYield1:2327 |
| dsdmLine | Changed | SpdLine_Changed | SetFormationYield:2339 |
| dsdmLine | Changed | SpdLine_Changed | SetFormationYield:2443 |
| dsdmLine | Changed | SpdLine_Changed | CalculateSum:2456 |
| dsdmLine | Changed | SpdLine_Changed | CalculateSum:2568 |
| dsdmLine | Changed | SpdLine_Changed | CalculateSum:2576 |
| dsdmLine | Changed | SpdLine_Changed | CalculateSum:2693 |

## 6. 컨트롤 (50개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 17 | lblItemId, layoutControlItem2, layoutControlItem10, PlanType, PlanDate, Division, layoutControlItem1, SEQ, layoutControlItem7, layoutControlItem8, layoutControlItem3, layoutControlItem9, lbchkAll, layoutControlItem6, layoutControlItem5 … |
| EmptySpaceItem | 7 | emptySpaceItem10, emptySpaceItem9, emptySpaceItem3, emptySpaceItem1, emptySpaceItem7, emptySpaceItem2, emptySpaceItem6 |
| UsrCombo | 6 | cboOperationGroup, cboDivision, cboPlanSeq, cboPlanDate, cboPlanType, cboBucketType |
| UsrButton | 4 | usrButton1, btnCal, btnMeasure, btnItemId |
| UsrCheckBox | 2 | chkAll, chkSum |
| UsrCheckedList | 2 | clbPlantSite, cboElectrode |
| TextBox | 2 | txtNickName, txtModelId |
| FpSpread | 2 | spdMain, spdLine |
| SheetView | 2 | spdMain_Sheet1, spdLine_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker3 | 1 | dCalendar |
| UsrMultiLineEditor | 1 | txtItemId |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SplitContainer | 1 | splitContainer1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 72 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 38 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 13 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 38 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 34 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 966 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1218 | SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL_tuning3 | commented:NOT_IN_FOXQUERY |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0011 | Line | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 |
| SCM_MST_SHEET_COLUMNS | SCP0011 | Model | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 |
| SCM_MST_SHEET_MEASURE | SCP0011 | LINE | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 |
| SCM_MST_SHEET_MEASURE | SCP0011 | MODEL | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Model, Line
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:323, SetSheetHeaderColumn@InitSpread:399
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumn, InitSpreadDateColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 349 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Model") ⟫ if(!this._isEE) |
| InitSpread |  | 350 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Model") ⟫ if(!this._isEE) |
| InitSpread |  | 354 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Model") ⟫ else!(!this._isEE) |
| InitSpread |  | 355 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Model") ⟫ else!(!this._isEE) |
| InitSpread |  | 414 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Line") ⟫ if(!this._isEE) |
| InitSpread |  | 415 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Line") ⟫ if(!this._isEE) |
| InitSpread |  | 419 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "Line") ⟫ else!(!this._isEE) |
| InitSpread |  | 420 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Line") ⟫ else!(!this._isEE) |
| InitSpreadDateColumn |  | 462 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 466 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 470 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 933 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 938 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 945 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 949 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 954 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 961 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 965 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetColumnModelVisible |  | 3053 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | switch(pOperationGroup)case "A" |
| SetColumnModelVisible |  | 3056 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | switch(pOperationGroup)case "P" |
| InitializeComponent |  | 1103 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1104 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1105 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1106 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Line | META+코드연결 | 11 (?2) | 11 (?2) | 11 (?2) | 11 (?2) | 11 (?2) | 11 (?2) | 11 (?2) | 11 (?2) | 11 (?2) | 11 (?2) | 11 (?2) | 11 (?2) | 11 (?2) | 11 (?2) |
| Model | META+코드연결 | 9 (?2) | 9 (?2) | 9 (?2) | 9 (?2) | 9 (?2) | 9 (?2) | 9 (?2) | 9 (?2) | 9 (?2) | 9 (?2) | 9 (?2) | 9 (?2) | 9 (?2) | 9 (?2) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:호출파라미터 56, 정적평가 미지원식 56 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 112건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
