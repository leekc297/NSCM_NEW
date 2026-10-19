# SSP0011 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0011_PSI.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1037 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0011_PSI.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 938 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 566 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 577 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 581 | biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 588 | biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH |  |
| event:cboOperGroup.SelectedIndexChanged | CboOperGroup_SelectedIndexChanged | 440 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 953 | biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 1023 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 967 | biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 275 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 700 | SSP.SSP0011_GET_PSI | MATCH | SP SSP0011_GET_PSI |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 1006 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetBucketType | 197 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 275 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 566 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 577 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 581 | biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 588 | biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 1006 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1023 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| unreached:(진입점 미연결) | <field:dtElectrode> | 51 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetFromSiteByDivision | 208 | SCM.SCM0001_GET_FROM_SITE | MATCH | SP SCM0001_GET_FROM_SITE |
| unreached:(진입점 미연결) | GetLastPlanVersion | 625 | SSP.SSP_GET_LAST_PLAN_VERSION | MATCH | SP SSP_GET_LAST_PLAN_VERSION |
| unreached:(진입점 미연결) | SetChangedPeriod | 988 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 991 | biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SSP_ANL_SHIP_PLAN_P, UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlanSeqShip] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlanTypeShip] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_COLUMNS |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_FROM_SITE | MATCH | 1 | SP SCM0001_GET_FROM_SITE | EXEC:SCM0001_GET_FROM_SITE, SELECT:SCM_MST_SITE |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP_GET_LAST_PLAN_VERSION | MATCH | 1 | SP SSP_GET_LAST_PLAN_VERSION | EXEC:SSP_GET_LAST_PLAN_VERSION, REF:FN_GET_SSP_LAST_PLAN_VERSION_ID, REF:FN_SCM_SPLIT, SELECT:SSP_PLAN_VERSION_V |  |
| SSP.SSP0011_GET_PSI | MATCH | 1 | SP SSP0011_GET_PSI | EXEC:SSP0011_GET_PSI, CREATE:#TBLDYNAMICPIVOT_SSP0011, REF:STRING_SPLIT, DYNAMIC@SSP0011_GET_PSI, SELECT:SCM_SYS_CALENDAR_M, INSERT:#BOH, SELECT:SSP_PLN_PLANT_ONHAND |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtDivision> | UserInfoContext.Current | NowGroupID |
| GetLastPlanVersion | dsBinding.Tables[0].Rows[0] | PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitSpread_2:227, InitSpread_2:238, InitSpread:285, CboOperGroup_SelectedIndexChanged:436, CboOperGroup_SelectedIndexChanged:437, SetChangedControl:555, SetChangedControl:556, SetChangedControl:580 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread_2:232, InitSpread:283, InitSpread:333 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread_2:235 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread_2:246, InitSpread:336 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:145 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:419 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:421 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:422 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:424 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:425 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:427 |
| cboOperGroup | SelectedIndexChanged | CboOperGroup_SelectedIndexChanged | InitEvent:428 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:429 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:430 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:431 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:613 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:614 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:615 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:649 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:650 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:651 |

## 6. 컨트롤 (33개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 12 | PlanDate, layoutControlItem3, lblItemId, layoutControlItem2, lblFromSite, lblCombo1, PlanType, SEQ, layoutControlItem1, layoutControlItem6, lblBucket, lcElectrode |
| UsrCombo | 6 | cboPlanSeq, cboPlanDate, cboPlanType, cboOperGroup, cboDivision, cboBucketType |
| UsrButton | 3 | usrButton1, btnItemId, usrButton2 |
| UsrCheckedList | 2 | clbFromSite, clbElectrode |
| EmptySpaceItem | 2 | emptySpaceItem2, emptySpaceItem1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckBox | 1 | chkSum |
| UsrMultiLineEditor | 1 | txtItemId |
| UsrDateRangePicker | 1 | drpPeriod |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 7 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 18 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 4 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_GroupMenuAuth | 11 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 24 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1022 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0011 | PSI | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 |
| SCM_MST_SHEET_MEASURE | SSP0011 | CELL | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 |
| SCM_MST_SHEET_MEASURE | SSP0011 | ELECTRODE | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 |
| SCM_MST_SHEET_MEASURE | SSP0011 | PACK | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: PSI
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread_2:235
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumn, InitSpreadDateColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread_2 |  | 243 | 표시/라벨 변경 | set:Width | Width = 0 | ELECTRODE_TYPE | if(!pOperationGroup.Equals("E")) |
| InitSpread_2 |  | 259 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_FROM_DIVISION_ID | if(pDivisionID != "EE") |
| InitSpread_2 |  | 260 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(pDivisionID != "EE") |
| InitSpread_2 |  | 261 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_TO_DIVISION_ID | if(pDivisionID != "EE") |
| InitSpread_2 |  | 265 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_FROM_DIVISION_ID | else!(pDivisionID != "EE") |
| InitSpread_2 |  | 266 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | else!(pDivisionID != "EE") |
| InitSpread_2 |  | 267 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_TO_DIVISION_ID | else!(pDivisionID != "EE") |
| InitSpread | PSI | 292 | 하드코딩 | AddTextColumn | Division | DIVISION_ID |  |
| InitSpread | PSI | 293 | 하드코딩 | AddTextColumn | Operation Group | OPERATION_GROUP_DESC |  |
| InitSpread | PSI | 294 | 하드코딩 | AddTextColumn | From Site | SITE_DESCRIPTION |  |
| InitSpread | PSI | 295 | 하드코딩 | AddTextColumn | ITEM_ID | ITEM_ID |  |
| InitSpread | PSI | 296 | 하드코딩 | AddTextColumn | Nick Name | NICK_NAME |  |
| InitSpread | PSI | 298 | 하드코딩 | AddTextColumn | Electrode Type | ELECTRODE_TYPE |  |
| InitSpread | PSI | 299 | 하드코딩 | AddNumColumn | BOH (From Site) | BOH |  |
| InitSpread | PSI | 300 | 하드코딩 | AddTextColumn | PSI Type | PSI_NAME |  |
| InitSpread | PSI | 301 | 하드코딩 | AddTextColumn | PSI Value | PSI_VALUE |  |
| InitSpread | PSI | 302 | 하드코딩 | AddTextColumn | PSI Type | PSI_TYPE |  |
| InitSpread | PSI | 304 | 하드코딩 | AddTextColumn | FROM_SITE | FROM_SITE |  |
| InitSpread | PSI | 305 | 하드코딩 | AddTextColumn | Division | DIVISION_NAME |  |
| InitSpread | PSI | 306 | 하드코딩 | AddTextColumn | OPERATION_GROUP | OPERATION_GROUP |  |
| InitSpread | PSI | 307 | 하드코딩 | AddTextColumn | PLAN_START_YYYYMMDD | PLAN_START_YYYYMMDD |  |
| InitSpread | PSI | 308 | 하드코딩 | AddTextColumn | PLAN_TYPE | PLAN_TYPE |  |
| InitSpread | PSI | 311 | 하드코딩 | AddTextColumn | SEQ | SEQ |  |
| InitSpreadDateColumn |  | 374 | DB루프 | AddTextColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("D_") > 0) |
| InitSpreadDateColumn |  | 377 | DB루프 | AddNumColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("D_") > 0) |
| InitSpreadDateColumn |  | 380 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("D_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 870 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 874 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 879 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 882 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 886 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 891 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 894 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| InitializeComponent |  | 841 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 842 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 843 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 844 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| PSI | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 18 | 16 | 16 | 16 | 16 | 16 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
