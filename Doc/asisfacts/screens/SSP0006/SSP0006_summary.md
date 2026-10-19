# SSP0006 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0006_Plan_Problem.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1378 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0006_Plan_Problem.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1194 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 719 | biz:CommonData.CommonDataList [code=SaleSiteByDivision] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 735 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 739 | biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 746 | biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 1201 | biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 1334 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 1218 | biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 864 | SSP.SSP0006_GET_PROBLEM_REPORT | MATCH | SP SSP0006_GET_PROBLEM_REPORT |
| event:this.Load | Form_Load > InitControls | 366 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 719 | biz:CommonData.CommonDataList [code=SaleSiteByDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 735 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 739 | biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 746 | biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1109 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1334 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_PeggingInfo | 1011 | SSP.SSP0006_GET_PEGGING_INFO | MATCH | SP SSP0006_GET_PEGGING_INFO |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_PlanProblem | 1069 | SSP.SSP0006_GET_PLAN_PROBLEM | MATCH | SP SSP0006_GET_PLAN_PROBLEM |
| unreached:(진입점 미연결) | <field:dtElectrode> | 53 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetSalesSitebyDivision | 380 | SCM_SYS.SCM_SYS_GET_SITE_BY_DIVISION | MATCH | SP SCM_SYS_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetLastPlanVersion | 780 | SSP.SSP_GET_LAST_PLAN_VERSION | MATCH | SP SSP_GET_LAST_PLAN_VERSION |
| unreached:(진입점 미연결) | GetDivision | 1295 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | SetChangedPeriods | 1302 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetSpdTitle | 1316 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SSP_ANL_SHIP_PLAN_P, UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=SaleSiteByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM_SYS.SCM_SYS_GET_SITE_BY_DIVISION | MATCH | 1 | SP SCM_SYS_GET_SITE_BY_DIVISION | EXEC:SCM_SYS_GET_SITE_BY_DIVISION | ⚠ DB에 SP 없음 |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP_GET_LAST_PLAN_VERSION | MATCH | 1 | SP SSP_GET_LAST_PLAN_VERSION | EXEC:SSP_GET_LAST_PLAN_VERSION, REF:FN_GET_SSP_LAST_PLAN_VERSION_ID, REF:FN_SCM_SPLIT, SELECT:SSP_PLAN_VERSION_V |  |
| SSP.SSP0006_GET_PEGGING_INFO | MATCH | 1 | SP SSP0006_GET_PEGGING_INFO | EXEC:SSP0006_GET_PEGGING_INFO, REF:FN_GET_LOOKUP_CODE_DESC, SELECT:SSP_ANL_PROBLEM_REPORT_PEGGING, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SSP.SSP0006_GET_PLAN_PROBLEM | MATCH | 1 | SP SSP0006_GET_PLAN_PROBLEM | EXEC:SSP0006_GET_PLAN_PROBLEM, SELECT:SSP_ANL_PROBLEM_REPORT_DESC |  |
| SSP.SSP0006_GET_PROBLEM_REPORT | MATCH | 1 | SP SSP0006_GET_PROBLEM_REPORT | EXEC:SSP0006_GET_PROBLEM_REPORT, CREATE:#TBLDYNAMICPIVOT_SSP0006, INSERT:#TBLDYNAMICPIVOT_SSP0006, SELECT:SSP_ANL_PROBLEM_REPORT_DEMAND, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, DYNAMIC@SSP0006_GET_PROBLEM_REPORT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtDivision> | UserInfoContext.Current | NowGroupID |
| GetLastPlanVersion | dsBinding.Tables[0].Rows[0] | PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ |
| GetSearchCondition | a | DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_SITE_ID, SALES_SITE_ID, PROJECT_CODE, ITEM_ID, DOM_EXP, FCST_TYPE, yyyymmdd, ELECTRODE_TYPE |
| GetSearchCondition | dr | DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ENG_DEMAND_ID, ITEM_ID, problem_type, ELECTRODE_TYPE |
| PaintProblemCell | a | DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_SITE_ID, SALES_SITE_ID, PROJECT_CODE, ITEM_ID, DOM_EXP, FCST_TYPE, ELECTRODE_TYPE |
| PaintProblemCell | dr | yyyymmdd, problem_type |
| SetChangedPeriods | dt.Rows[0] | FROM_VALUE, TO_VALUE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitSpread_2:286, SetChangedControl:714, SetChangedControl:738, SetChangedControl:745, GetLastPlanVersion:766, FindData_Main:832, FindData_Main:833, FindData_Main:834 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread_2:293, InitSpread_2:319, InitSpread_2:339 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread_2:294, InitSpread:452 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetSpdTitle | InitSpread:450 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| GetSearchCondition | SpdMain_CellDoubleClick:1285 | BaseForm.GetSearchCondition | ControlName, ControlValue |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:214 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:580 |
| this.btnProject | Click | btnProject_Click | InitEvent:581 |
| this.btnItem_Id | Click | btnItemId_Click | InitEvent:582 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:584 |
| this.spdPeggingInfo | TopChange | SpdPeggingInfo_TopChange | InitEvent:585 |
| this.spdPlanProblem | TopChange | SpdPlanProblem_TopChange | InitEvent:586 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:589 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:590 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:591 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:593 |
| cboBucketType | SelectedIndexChanged | CboBucketType_SelectedIndexChanged | InitEvent:594 |
| chkSum | CheckedChanged | ChkSum_CheckedChanged | InitEvent:596 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:768 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:769 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:770 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:802 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:803 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:804 |

## 6. 컨트롤 (45개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 15 | Division, SEQ, layoutControlItem3, layoutControlItem7, layoutControlItem1, PlanDate, layoutControlItem5, lblItemId, layoutControlItem2, PlanType, layoutControlItem4, lblBucket, layoutControlItem6, layoutControlItem9, layoutControlItem8 |
| UsrCombo | 5 | cboDivision, cboPlanSeq, cboPlanDate, cboPlanType, cboBucketType |
| UsrCheckedList | 4 | clbSalesSite, clbPlantSite, clbProblem, clbElectrode |
| UsrButton | 3 | usrButton1, btnItem_Id, btnProject |
| EmptySpaceItem | 3 | emptySpaceItem3, emptySpaceItem1, emptySpaceItem2 |
| FpSpread | 3 | spdMain, spdPeggingInfo, spdPlanProblem |
| SheetView | 3 | spdMain_Sheet1, spdPeggingInfo_Sheet1, spdPlanProblem_Sheet1 |
| UsrMultiLineEditor | 2 | txtProject, txtItemId |
| SplitContainer | 2 | splitContainer1, splitContainer2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckBox | 1 | chkSum |
| UsrDateRangePicker | 1 | drpPeriod |
| LayoutControlGroup | 1 | layoutControlGroup2 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 6 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 41 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 3 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 11 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 44 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1333 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0006 | Demand | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 |
| SCM_MST_SHEET_COLUMNS | SSP0006 | Pegging Info | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |
| SCM_MST_SHEET_COLUMNS | SSP0006 | Plan Problem | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Demand, Pegging Info, Plan Problem
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread_2:293, SetSheetHeaderColumn@InitSpread_2:319, SetSheetHeaderColumn@InitSpread_2:339
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumn, InitSpreadDateColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread_2 | Demand | 304 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_FROM_DIVISION_ID | if(spdInfo.SheetName == "Demand") ⟫ if(pDivisionID != "EE") |
| InitSpread_2 | Demand | 305 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_TO_DIVISION_ID | if(spdInfo.SheetName == "Demand") ⟫ if(pDivisionID != "EE") |
| InitSpread_2 | Demand | 306 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Demand") ⟫ if(pDivisionID != "EE") |
| InitSpread_2 | Demand | 310 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_FROM_DIVISION_ID | if(spdInfo.SheetName == "Demand") ⟫ else!(pDivisionID != "EE") |
| InitSpread_2 | Demand | 311 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_TO_DIVISION_ID | if(spdInfo.SheetName == "Demand") ⟫ else!(pDivisionID != "EE") |
| InitSpread_2 | Demand | 312 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | if(spdInfo.SheetName == "Demand") ⟫ else!(pDivisionID != "EE") |
| InitSpread_2 | Pegging Info | 325 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_FROM_DIVISION_ID | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ if(pDivisionID != "EE") |
| InitSpread_2 | Pegging Info | 326 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_TO_DIVISION_ID | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ if(pDivisionID != "EE") |
| InitSpread_2 | Pegging Info | 327 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ if(pDivisionID != "EE") |
| InitSpread_2 | Pegging Info | 331 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_FROM_DIVISION_ID | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ else!(pDivisionID != "EE") |
| InitSpread_2 | Pegging Info | 332 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_TO_DIVISION_ID | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ else!(pDivisionID != "EE") |
| InitSpread_2 | Pegging Info | 333 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") ⟫ else!(pDivisionID != "EE") |
| InitSpread | Demand | 412 | 하드코딩 | AddTextColumn | division_id | division_id | if(spdInfo.SheetName == "Demand") |
| InitSpread | Demand | 413 | 하드코딩 | AddTextColumn | Division | division_name | if(spdInfo.SheetName == "Demand") |
| InitSpread | Demand | 414 | 하드코딩 | AddTextColumn | plan_start_yyyymmdd | plan_start_yyyymmdd | if(spdInfo.SheetName == "Demand") |
| InitSpread | Demand | 415 | 하드코딩 | AddTextColumn | PLAN_TYPE | PLAN_TYPE | if(spdInfo.SheetName == "Demand") |
| InitSpread | Demand | 416 | 하드코딩 | AddTextColumn | SEQ | SEQ | if(spdInfo.SheetName == "Demand") |
| InitSpread | Demand | 417 | 하드코딩 | AddTextColumn | Plant_id | plant_site_id | if(spdInfo.SheetName == "Demand") |
| InitSpread | Demand | 418 | 하드코딩 | AddTextColumn | Plant | plant_site_description | if(spdInfo.SheetName == "Demand") |
| InitSpread | Demand | 419 | 하드코딩 | AddTextColumn | sales_site_id | sales_site_id | if(spdInfo.SheetName == "Demand") |
| InitSpread | Demand | 420 | 하드코딩 | AddTextColumn | Sales Site | sales_site_description | if(spdInfo.SheetName == "Demand") |
| InitSpread | Demand | 421 | 하드코딩 | AddTextColumn | Project | project_code | if(spdInfo.SheetName == "Demand") |
| InitSpread | Demand | 422 | 하드코딩 | AddTextColumn | Model | ITEM_ID | if(spdInfo.SheetName == "Demand") |
| InitSpread | Demand | 423 | 하드코딩 | AddTextColumn | Nick Name | nick_name | if(spdInfo.SheetName == "Demand") |
| InitSpread | Demand | 425 | 하드코딩 | AddTextColumn | DOM/EXP | dom_exp | if(spdInfo.SheetName == "Demand") |
| InitSpread | Demand | 426 | 하드코딩 | AddTextColumn | FCST Type | fcst_type | if(spdInfo.SheetName == "Demand") |
| InitSpread | Demand | 427 | 하드코딩 | AddTextColumn | Problem | problem_type | if(spdInfo.SheetName == "Demand") |
| InitSpread | Demand | 428 | 하드코딩 | AddTextColumn | ENG_DEMAND_ID | ENG_DEMAND_ID | if(spdInfo.SheetName == "Demand") |
| InitSpread | Pegging Info | 461 | 하드코딩 | AddTextColumn | Pegging Operation | PEGGING_OPERATION | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") |
| InitSpread | Pegging Info | 462 | 하드코딩 | AddTextColumn | Item | item_id | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") |
| InitSpread | Pegging Info | 463 | 하드코딩 | AddTextColumn | From Site | FROM_SITE | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") |
| InitSpread | Pegging Info | 464 | 하드코딩 | AddTextColumn | To Site | to_site | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") |
| InitSpread | Pegging Info | 465 | 하드코딩 | AddDateColumn | Due Date | DUE_DATE | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") |
| InitSpread | Pegging Info | 466 | 하드코딩 | AddDateColumn | Start Date | PLAN_START_DATE | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") |
| InitSpread | Pegging Info | 467 | 하드코딩 | AddDateColumn | End Date | PLAN_END_DATE | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") |
| InitSpread | Pegging Info | 468 | 하드코딩 | AddTextColumn | Operation Group | OPERATION_GROUP | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") |
| InitSpread | Pegging Info | 470 | 하드코딩 | AddTextColumn | Required Qty | REQUIRED_QTY | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") |
| InitSpread | Pegging Info | 471 | 하드코딩 | AddNumColumn | Planned Qty | PLANNED_QTY | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") |
| InitSpread | Pegging Info | 473 | 하드코딩 | AddDateTextColumn | LPST | LPST | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") |
| InitSpread | Pegging Info | 474 | 하드코딩 | AddTextColumn | Stock Plan Lot Id | STOCK_PLAN_LOT_ID | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") |
| InitSpread | Pegging Info | 476 | 하드코딩 | AddTextColumn | Problem Type | PROBLEM_TYPE | else!(spdInfo.SheetName == "Demand") ⟫ if(spdInfo.SheetName == "Pegging Info") |
| InitSpread | Plan Problem | 483 | 하드코딩 | AddTextColumn | Problem Seq | problem_seq | else!(spdInfo.SheetName == "Demand") ⟫ else!(spdInfo.SheetName == "Pegging Info") ⟫ if(spdInfo.SheetName == "Plan Problem") |
| InitSpread | Plan Problem | 484 | 하드코딩 | AddTextColumn | Problem Type | ENG_PROBLEM_TYPE | else!(spdInfo.SheetName == "Demand") ⟫ else!(spdInfo.SheetName == "Pegging Info") ⟫ if(spdInfo.SheetName == "Plan Problem") |
| InitSpread | Plan Problem | 485 | 하드코딩 | AddTextColumn | Problem Desc | ENG_PROBLEM_DESC | else!(spdInfo.SheetName == "Demand") ⟫ else!(spdInfo.SheetName == "Pegging Info") ⟫ if(spdInfo.SheetName == "Plan Problem") |
| InitSpread | Plan Problem | 486 | 하드코딩 | AddDateColumn | Request Date | REQUEST_TIME | else!(spdInfo.SheetName == "Demand") ⟫ else!(spdInfo.SheetName == "Pegging Info") ⟫ if(spdInfo.SheetName == "Plan Problem") |
| InitSpread | Plan Problem | 487 | 하드코딩 | AddDateColumn | Response Date | RESPONSE_TIME | else!(spdInfo.SheetName == "Demand") ⟫ else!(spdInfo.SheetName == "Pegging Info") ⟫ if(spdInfo.SheetName == "Plan Problem") |
| InitSpread | Plan Problem | 488 | 하드코딩 | AddNumColumn | Problem Qty | problem_qty | else!(spdInfo.SheetName == "Demand") ⟫ else!(spdInfo.SheetName == "Pegging Info") ⟫ if(spdInfo.SheetName == "Plan Problem") |
| InitSpreadDateColumn |  | 531 | DB루프 | AddTextColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 535 | DB루프 | AddNumColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 540 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 1126 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1131 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1138 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1142 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1147 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1154 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1157 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| InitializeComponent |  | 990 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 991 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 992 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 993 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Demand | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 19 | 16 | 16 | 16 | 16 | 16 |
| Pegging Info | META+코드연결 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 16 | 13 | 13 | 13 | 13 | 13 |
| Plan Problem | META+코드연결 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
