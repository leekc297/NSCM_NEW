# SCP0074 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0074_PSI_RTF_Balance\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0074_PSI_RTF_Balance\SCP0074_PSI_RTF_Balance.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0074_PSI_RTF_Balance\SCP0074_PSI_RTF_Balance.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0074_PSI_RTF_Balance\SCP0074_PSI_RTF_Balance.csproj | 1777 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0074_PSI_RTF_Balance\SCP0074_PSI_RTF_Balance.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0074_PSI_RTF_Balance\SCP0074_PSI_RTF_Balance.csproj | 757 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 595 | biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 599 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 606 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl > GetBucketType | 1571 | SCP.SCP0070_GET_BUCKET_TYPE_CODE | MATCH | SP SCP0070_GET_BUCKET_TYPE_CODE |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 1625 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 1734 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 1716 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 751 | SCP.SCP0074_GET_SUPPLY_PSI_BY_MODEL_ESS | MATCH | SP SCP0074_GET_SUPPLY_PSI_BY_MODEL_ESS |
| button:FindButton | FindButton > FindData_Main | 778 | SCP.SCP0074_GET_SUPPLY_PSI_BY_SHIP_LINE_ESS | MATCH | SP SCP0074_GET_SUPPLY_PSI_BY_SHIP_LINE_ESS |
| button:FindButton | FindButton > FindData_Main | 806 | SCP.SCP0074_GET_PSI_BY_MODEL_SMALL | MATCH | SP SCP0074_GET_PSI_BY_MODEL_SMALL |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 1604 | SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0070_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 595 | biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 599 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 606 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1571 | SCP.SCP0070_GET_BUCKET_TYPE_CODE | MATCH | SP SCP0070_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetQtyData | 1583 | SCP.SCP0070_GET_QTY_TYPE_CODE | MATCH | SP SCP0070_GET_QTY_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1604 | SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0070_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1625 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=DATE_WEEKLY] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:REF:FN_CHAR_TO_DATE, UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V, UP_FX_GetCommonDataList:SELECT:SCM_SYS_CALENDAR_M, UP_FX_GetCommonDataList:SELECT:SCP_PLN_INTERFACE_YN, UP_FX_GetCommonDataList:REF:FN_SPLITSTRING |
| biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0070_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP SCP0070_GET_BUCKET_TYPE_CODE | EXEC:SCP0070_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0070_GET_QTY_TYPE_CODE | MATCH | 1 | SP SCP0070_GET_QTY_TYPE_CODE | EXEC:SCP0070_GET_QTY_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0070_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0070_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0074_GET_PSI_BY_MODEL_SMALL | MATCH | 1 | SP SCP0074_GET_PSI_BY_MODEL_SMALL | EXEC:SCP0074_GET_PSI_BY_MODEL_SMALL, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@SCP0074_GET_PSI_BY_MODEL_SMALL |  |
| SCP.SCP0074_GET_SUPPLY_PSI_BY_MODEL_ESS | MATCH | 1 | SP SCP0074_GET_SUPPLY_PSI_BY_MODEL_ESS | EXEC:SCP0074_GET_SUPPLY_PSI_BY_MODEL_ESS, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@SCP0074_GET_SUPPLY_PSI_BY_MODEL_ESS |  |
| SCP.SCP0074_GET_SUPPLY_PSI_BY_SHIP_LINE_ESS | MATCH | 1 | SP SCP0074_GET_SUPPLY_PSI_BY_SHIP_LINE_ESS | EXEC:SCP0074_GET_SUPPLY_PSI_BY_SHIP_LINE_ESS, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@SCP0074_GET_SUPPLY_PSI_BY_SHIP_LINE_ESS |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InitControls | dr | CODE, NAME |
| InitControls | dataRow | CODE, NAME |
| Set_SumValues | dsBinding.Tables[0].Columns | MEASURE_LABEL |
| Set_SumValues | dsBinding.Tables[0].Rows[iRow] | SCM_SITE_ID, MEASURE_LABEL, LINE_NAME |
| SetChangedControl | dr | CODE, NAME |
| SetChangedControl | dataRow | CODE, NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:270 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:272 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:273 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetCheckedListValue | RdoType_CheckedChanged:377, SetChangedControl:587, SetChangedControl:598, SetChangedControl:605, FindData_Main:727, FindData_Main:729, FindData_Main:730, FindData_Main:731 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:140 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:357 |
| this.cboBucketType | SelectedIndexChanged | CboBucketType_SelectedIndexChanged | InitEvent:359 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:360 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:362 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:363 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:364 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:365 |
| RdoModel | CheckedChanged | RdoType_CheckedChanged | InitEvent:366 |
| cboQTY | SelectedIndexChanged | cboQTY_SelectedIndexChanged | InitEvent:367 |

## 6. 컨트롤 (27개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | lblCombo1, PlanDate, PlanType, SEQ, lblBucket, layoutControlItem1, layoutControlItem5, lblQty, layoutControlItem2 |
| UsrCombo | 6 | cboDivision, cboBucketType, cboPlanDate, cboPlanType, cboPlanSeq, cboQTY |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem3, emptySpaceItem2 |
| UsrRadio | 2 | RdoShipLine, RdoModel |
| UsrButton | 1 | usrButton1 |
| UsrConditionPanel | 1 | pnlCondition |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SheetView | 1 | spdMain_Sheet1 |
| FpSpread | 1 | spdMain |
| UsrDateRangePicker3 | 1 | dCalendar |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 12 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 12 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 10 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
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
| SCM_MST_SHEET_COLUMNS | SCP0074 | PSI RTF Balance | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |
| SCM_MST_SHEET_MEASURE | SCP0074 | PSI RTF Balance | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 |
| SCM_MST_SHEET_MEASURE | SCP0074 | SUPPLY_PSI_BY_MODEL | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: PSI RTF Balance
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:272
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 309 | DB루프 | AddTextColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 313 | DB루프 | AddNumColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| RdoType_CheckedChanged |  | 385 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MATERIAL_CLASS_NAME | if(division.Equals("82")) ⟫ if(siMain != null) |
| RdoType_CheckedChanged |  | 386 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TYPE | if(division.Equals("82")) ⟫ if(siMain != null) |
| RdoType_CheckedChanged |  | 388 | 표시/라벨 변경 | set:Visible | Visible = {?true} | CELL_ITEM_ID | if(division.Equals("82")) ⟫ if(siMain != null) ⟫ if(RdoModel.Checked) |
| RdoType_CheckedChanged |  | 390 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CELL_ITEM_ID | if(division.Equals("82")) ⟫ if(siMain != null) ⟫ else!(RdoModel.Checked) |
| RdoType_CheckedChanged |  | 392 | 표시/라벨 변경 | set:Visible | Visible = {?true} | SCM_SITE_ID | if(division.Equals("82")) ⟫ if(siMain != null) |
| RdoType_CheckedChanged |  | 393 | 표시/라벨 변경 | set:Visible | Visible = {?true} | LINE_NAME | if(division.Equals("82")) ⟫ if(siMain != null) |
| SetSpreadColumn |  | 526 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("Q_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("Y_") == 0) |
| SetSpreadColumn |  | 531 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 542 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("Q_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("Y_") == 0) |
| SetSpreadColumn |  | 547 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 558 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(cboBucketType.ControlValues == "MONTHLY") ⟫ if(cboBucketType.ControlValues == "QUATERLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("Y_") == 0) |
| SetSpreadColumn |  | 563 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(cboBucketType.ControlValues == "MONTHLY") ⟫ if(cboBucketType.ControlValues == "QUATERLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("Q_") == 0) |
| SetSpreadColumn |  | 574 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(cboBucketType.ControlValues == "QUATERLY") ⟫ if(cboBucketType.ControlValues == "YEARLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("Q_") == 0) |
| SetSpreadColumn |  | 579 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(cboBucketType.ControlValues == "QUATERLY") ⟫ if(cboBucketType.ControlValues == "YEARLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("Y_") == 0) |
| SetChangedControl |  | 613 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MATERIAL_CLASS_NAME | if(cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ⟫ if(division.Equals("82")) ⟫ if(siMain != null) |
| SetChangedControl |  | 614 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TYPE | if(cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ⟫ if(division.Equals("82")) ⟫ if(siMain != null) |
| SetChangedControl |  | 616 | 표시/라벨 변경 | set:Visible | Visible = {?true} | CELL_ITEM_ID | if(cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ⟫ if(division.Equals("82")) ⟫ if(siMain != null) ⟫ if(RdoModel.Checked) |
| SetChangedControl |  | 618 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CELL_ITEM_ID | if(cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ⟫ if(division.Equals("82")) ⟫ if(siMain != null) ⟫ else!(RdoModel.Checked) |
| SetChangedControl |  | 620 | 표시/라벨 변경 | set:Visible | Visible = {?true} | SCM_SITE_ID | if(cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ⟫ if(division.Equals("82")) ⟫ if(siMain != null) |
| SetChangedControl |  | 621 | 표시/라벨 변경 | set:Visible | Visible = {?true} | LINE_NAME | if(cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ⟫ if(division.Equals("82")) ⟫ if(siMain != null) |
| SetChangedControl |  | 635 | 표시/라벨 변경 | set:Visible | Visible = {?true} | MATERIAL_CLASS_NAME | if(cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ⟫ else!(division.Equals("82")) ⟫ if(division.Equals("40")) ⟫ if(siMain != null) |
| SetChangedControl |  | 636 | 표시/라벨 변경 | set:Visible | Visible = {?true} | TYPE | if(cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ⟫ else!(division.Equals("82")) ⟫ if(division.Equals("40")) ⟫ if(siMain != null) |
| SetChangedControl |  | 637 | 표시/라벨 변경 | set:Visible | Visible = {?true} | CELL_ITEM_ID | if(cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ⟫ else!(division.Equals("82")) ⟫ if(division.Equals("40")) ⟫ if(siMain != null) |
| SetChangedControl |  | 638 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SCM_SITE_ID | if(cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ⟫ else!(division.Equals("82")) ⟫ if(division.Equals("40")) ⟫ if(siMain != null) |
| SetChangedControl |  | 639 | 표시/라벨 변경 | set:Visible | Visible = {?false} | LINE_NAME | if(cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ⟫ else!(division.Equals("82")) ⟫ if(division.Equals("40")) ⟫ if(siMain != null) |
| FindData_Main |  | 766 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MATERIAL_CLASS_NAME | if(division.Equals("82")) ⟫ if(RdoModel.Checked) ⟫ if(siMain != null) |
| FindData_Main |  | 767 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TYPE | if(division.Equals("82")) ⟫ if(RdoModel.Checked) ⟫ if(siMain != null) |
| FindData_Main |  | 768 | 표시/라벨 변경 | set:Visible | Visible = {?true} | CELL_ITEM_ID | if(division.Equals("82")) ⟫ if(RdoModel.Checked) ⟫ if(siMain != null) |
| FindData_Main |  | 769 | 표시/라벨 변경 | set:Visible | Visible = {?true} | SCM_SITE_ID | if(division.Equals("82")) ⟫ if(RdoModel.Checked) ⟫ if(siMain != null) |
| FindData_Main |  | 770 | 표시/라벨 변경 | set:Visible | Visible = {?true} | LINE_NAME | if(division.Equals("82")) ⟫ if(RdoModel.Checked) ⟫ if(siMain != null) |
| FindData_Main |  | 793 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MATERIAL_CLASS_NAME | if(division.Equals("82")) ⟫ else!(RdoModel.Checked) ⟫ if(siMain != null) |
| FindData_Main |  | 794 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TYPE | if(division.Equals("82")) ⟫ else!(RdoModel.Checked) ⟫ if(siMain != null) |
| FindData_Main |  | 795 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CELL_ITEM_ID | if(division.Equals("82")) ⟫ else!(RdoModel.Checked) ⟫ if(siMain != null) |
| FindData_Main |  | 796 | 표시/라벨 변경 | set:Visible | Visible = {?true} | SCM_SITE_ID | if(division.Equals("82")) ⟫ else!(RdoModel.Checked) ⟫ if(siMain != null) |
| FindData_Main |  | 797 | 표시/라벨 변경 | set:Visible | Visible = {?true} | LINE_NAME | if(division.Equals("82")) ⟫ else!(RdoModel.Checked) ⟫ if(siMain != null) |
| FindData_Main |  | 821 | 표시/라벨 변경 | set:Visible | Visible = {?true} | MATERIAL_CLASS_NAME | else!(division.Equals("82")) ⟫ if(siMain != null) |
| FindData_Main |  | 822 | 표시/라벨 변경 | set:Visible | Visible = {?true} | TYPE | else!(division.Equals("82")) ⟫ if(siMain != null) |
| FindData_Main |  | 823 | 표시/라벨 변경 | set:Visible | Visible = {?true} | CELL_ITEM_ID | else!(division.Equals("82")) ⟫ if(siMain != null) |
| FindData_Main |  | 824 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SCM_SITE_ID | else!(division.Equals("82")) ⟫ if(siMain != null) |
| FindData_Main |  | 825 | 표시/라벨 변경 | set:Visible | Visible = {?false} | LINE_NAME | else!(division.Equals("82")) ⟫ if(siMain != null) |
| InitializeComponent |  | 585 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 586 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 587 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 588 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| PSI RTF Balance | META+코드연결 | 6 (?5) | 6 (?5) | 6 (?5) | 6 (?5) | 6 (?5) | 6 (?5) | 6 (?5) | 5 (?5) | 6 (?5) | 6 (?5) | 6 (?5) | 6 (?5) | 6 (?5) | 6 (?5) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 정적평가 미지원식 69, 런타임:화면컨트롤값 23 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 92건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
