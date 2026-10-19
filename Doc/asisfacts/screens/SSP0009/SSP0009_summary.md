# SSP0009 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0009_Shipment_Plan_FG.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 2754 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0009_Shipment_Plan_FG.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1328 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 296 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 300 | biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 307 | biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 804 | biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 2474 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 824 | biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 971 | SSP.SSP0009_GET_SHIPMENT_PLAN_FG | MATCH | SP SSP0009_GET_SHIPMENT_PLAN_FG |
| button:FindButton | FindButton > FindData_Main | 1008 | SSP.SSP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | MATCH | SP SSP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 2446 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 971 | SSP.SSP0009_GET_SHIPMENT_PLAN_FG | MATCH | SP SSP0009_GET_SHIPMENT_PLAN_FG |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 1008 | SSP.SSP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | MATCH | SP SSP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main > InitSpread_2 > GetSpdTitle | 2446 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread_2 > GetSpdTitle | 2446 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread_2 > GetSpdTitle | 2446 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetBucketType | 278 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 296 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 300 | biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 307 | biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 2446 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetDayRange | 2474 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_PeggingInfo | 2287 | SSP.SSP0009_GET_SHIPMENT_PLAN_FG_PEGGING | MATCH | SP SSP0009_GET_SHIPMENT_PLAN_FG_PEGGING |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_PlanProblem | 2352 | SSP.SSP0009_GET_SHIPMENT_PLAN_FG_PROBLEM | MATCH | SP SSP0009_GET_SHIPMENT_PLAN_FG_PROBLEM |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_PlanProblem > InitSpread_2 > GetSpdTitle | 2446 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | <field:dtElectrode> | 53 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SSP_ANL_SHIP_PLAN_P, UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0009_GET_SHIPMENT_PLAN_FG | MATCH | 1 | SP SSP0009_GET_SHIPMENT_PLAN_FG | EXEC:SSP0009_GET_SHIPMENT_PLAN_FG, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, CREATE:#TBLDYNAMICPIVOT_SSP0009_02, DYNAMIC@SSP0009_GET_SHIPMENT_PLAN_FG, CREATE:#TBLDYNAMICPIVOT_SSP0009_03, INSERT:#TBLDYNAMICPIVOT_SSP0009_01, SELECT:#TBLDYNAMICPIVOT_SSP0009_02, SELECT:#TBLDYNAMICPIVOT_SSP0009_03 |  |
| SSP.SSP0009_GET_SHIPMENT_PLAN_FG_PEGGING | MATCH | 1 | SP SSP0009_GET_SHIPMENT_PLAN_FG_PEGGING | EXEC:SSP0009_GET_SHIPMENT_PLAN_FG_PEGGING, REF:FN_GET_LOOKUP_CODE_DESC, SELECT:SSP_ANL_PROBLEM_REPORT_PEGGING, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_SCM_SPLIT |  |
| SSP.SSP0009_GET_SHIPMENT_PLAN_FG_PROBLEM | MATCH | 1 | SP SSP0009_GET_SHIPMENT_PLAN_FG_PROBLEM | EXEC:SSP0009_GET_SHIPMENT_PLAN_FG_PROBLEM, SELECT:SSP_ANL_PROBLEM_REPORT_DESC, REF:FN_SCM_SPLIT |  |
| SSP.SSP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | MATCH | 1 | SP SSP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | EXEC:SSP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, CREATE:#TBLDYNAMICPIVOT_SSP0009_02, DYNAMIC@SSP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL, INSERT:#TBLDYNAMICPIVOT_SSP0009_01, SELECT:#TBLDYNAMICPIVOT_SSP0009_02 |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtDivision> | UserInfoContext.Current | NowGroupID |
| GetIsEditable | item | code |
| InsertRow | dr | division_id, BIZ_TYPE_NAME, ITEM_ID, NICK_NAME, BOH, PROJECT_CODE, MEASURE_LABEL, measure, key_idx, biz_type, MEASURE_ORDER_NO, plan_start_yyyymmdd, plan_type, seq, to_yyyymmdd |
| InsertRow | row | Measure, division_id, BIZ_TYPE_NAME, ITEM_ID, NICK_NAME, BOH, PROJECT_CODE, MEASURE_LABEL, key_idx, biz_type, MEASURE_ORDER_NO, plan_start_yyyymmdd, plan_type, seq, to_yyyymmdd |
| SaveData_Main | dr | A, p_active_flag, p_division_id, p_plan_start_yyyymmdd, p_plan_type, p_seq, p_biz_type, p_project_code, p_item_id, p_to_site, p_incoterms, p_from_site, p_bod_id, p_measure, p_yyyymmdd, p_qty, p_created_by, p_last_updated_by, p_time_zone |
| SaveData_Main | saveDS.Tables[0].Rows[0] | p_first_row |
| SaveData_Main | saveDS.Tables[0].Rows[iCount - 1] | p_last_row |
| SaveData_Main | row | A |
| Set_FixButtonEnabled | a | CODE |
| Set_SumValues | dsBinding.Tables[0].Columns | to_yyyymmdd, measure |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:285, SetChangedControl:299, SetChangedControl:306, InitSpread_2:397, CboPlanDate_SelectedIndexChanged:801, CboPlanDate_SelectedIndexChanged:802, CboPlanType_SelectedIndexChanged:820, CboPlanType_SelectedIndexChanged:821 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread_2:403 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread_2:405, InitSpread_2:435, InitSpread_2:455 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread_2:411 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetChanges | SaveData_Main:2079 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:344 |
| this | Load | Form_Load | .ctor:222 |
| this.btnProject | Click | BtnProject_Click | InitEvent:656 |
| this.btnItem_Id | Click | BtnItem_Id_Click | InitEvent:657 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:658 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:659 |
| this.btnMeasure | Click | btnMeasure_Click | InitEvent:660 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:663 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:664 |
| this.spdMain | KeyUp | SpdMain_KeyUp | InitEvent:665 |
| this.btnFix | Click | BtnFix_Click | InitEvent:668 |
| this.btnUnfix | Click | BtnUnfix_Click | InitEvent:669 |
| this.btnColumn | Click | BtnColumn_Click | InitEvent:672 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:674 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:675 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:676 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:677 |

## 6. 컨트롤 (50개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 17 | lblProject, layoutControlItem9, lblCombo, lblCombo1, layoutControlItem2, lblItemId, PlanDate, PlanType, layoutControlItem4, layoutControlItem1, SEQ, layoutControlItem6, layoutControlItem3, layoutControlItem5, layoutControlItem7 … |
| UsrButton | 7 | usrButton1, btnUnfix, btnFix, btnMeasure, btnProject, btnItem_Id, btnColumn |
| UsrCombo | 6 | cboBizType, cboPlanDate, cboPlanType, cboDivision, cboBucketType, cboPlanSeq |
| EmptySpaceItem | 4 | emptySpaceItem2, emptySpaceItem1, emptySpaceItem4, emptySpaceItem3 |
| FpSpread | 3 | spdMain, spdPeggingInfo, spdPlanProblem |
| SheetView | 3 | spdMain_Sheet1, spdPeggingInfo_Sheet1, spdPlanProblem_Sheet1 |
| UsrMultiLineEditor | 2 | txtItem_Id, txtProject |
| SplitContainer | 2 | splitContainer1, splitContainer2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckBox | 1 | chkSum |
| UsrDateRangePicker | 1 | drpPeriod |
| UsrCheckedList | 1 | clbElectrode |
| LayoutControlGroup | 1 | layoutControlGroup2 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 26 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 53 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 8 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_GroupMenuAuth | 11 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 37 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (7건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 339 | SSP.SSP_GET_LAST_PLAN_VERSION | commented:MATCH |
| 1049 | SSP.SSP0009_GET_SHIPMENT_PLAN_FG | commented:MATCH |
| 2351 | SSP.SSP0009_GET_SHIPMENT_PLAN_FG_PEGGING | commented:MATCH |
| 2460 | SCP.SCM0001_GET_SCP_PERIOD | commented:MATCH |
| 2459 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |
| 2473 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |
| 2705 | SCP.SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0009 | Pegging Info | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |
| SCM_MST_SHEET_COLUMNS | SSP0009 | Plan Problem | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |
| SCM_MST_SHEET_COLUMNS | SSP0009 | Shipment Request | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 |
| SCM_MST_SHEET_MEASURE | SSP0009 | Shipment Plan FG | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Request, Pegging Info, Plan Problem
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread_2:405, SetSheetHeaderColumn@InitSpread_2:435, SetSheetHeaderColumn@InitSpread_2:455
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread_2 | Shipment Request | 419 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Shipment Request") ⟫ if(pDivisionID != "EE") |
| InitSpread_2 | Shipment Request | 420 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_TO_DIVISION_ID | if(spdInfo.SheetName == "Shipment Request") ⟫ if(pDivisionID != "EE") |
| InitSpread_2 | Shipment Request | 421 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_FROM_DIVISION_ID | if(spdInfo.SheetName == "Shipment Request") ⟫ if(pDivisionID != "EE") |
| InitSpread_2 | Shipment Request | 425 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Shipment Request") ⟫ else!(pDivisionID != "EE") |
| InitSpread_2 | Shipment Request | 426 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_TO_DIVISION_ID | if(spdInfo.SheetName == "Shipment Request") ⟫ else!(pDivisionID != "EE") |
| InitSpread_2 | Shipment Request | 427 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_FROM_DIVISION_ID | if(spdInfo.SheetName == "Shipment Request") ⟫ else!(pDivisionID != "EE") |
| InitSpread_2 | Pegging Info | 440 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | else!(spdInfo.SheetName == "Shipment Request") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ if(pDivisionID != "EE") |
| InitSpread_2 | Pegging Info | 441 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_FROM_DIVISION_ID | else!(spdInfo.SheetName == "Shipment Request") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ if(pDivisionID != "EE") |
| InitSpread_2 | Pegging Info | 442 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_TO_DIVISION_ID | else!(spdInfo.SheetName == "Shipment Request") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ if(pDivisionID != "EE") |
| InitSpread_2 | Pegging Info | 446 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | else!(spdInfo.SheetName == "Shipment Request") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ else!(pDivisionID != "EE") |
| InitSpread_2 | Pegging Info | 447 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_FROM_DIVISION_ID | else!(spdInfo.SheetName == "Shipment Request") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ else!(pDivisionID != "EE") |
| InitSpread_2 | Pegging Info | 448 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_TO_DIVISION_ID | else!(spdInfo.SheetName == "Shipment Request") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ else!(pDivisionID != "EE") |
| InitSpreadDateColumn |  | 607 | DB루프 | AddTextColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 610 | DB루프 | AddNumColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 614 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 2503 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2507 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2512 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 2515 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2519 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 2524 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2527 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| InitializeComponent |  | 1124 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1125 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1126 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1127 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Pegging Info | META+코드연결 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 14 | 11 | 11 | 11 | 11 | 11 |
| Plan Problem | META+코드연결 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |
| Shipment Request | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 19 | 16 | 16 | 16 | 16 | 16 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
