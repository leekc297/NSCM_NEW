# SSP0001 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0001_ShipmentPlanConfirm.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1823 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0001_ShipmentPlanConfirm.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 911 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 1750 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > SetChangedControl | 780 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > SetChangedControl > GetDayRange | 1750 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| button:FindButton | FindButton > FindData_Main | 829 | SSP.SSP0001_GET_SHIPMENT_PLAN_CONFIRM | MATCH | SP SSP0001_GET_SHIPMENT_PLAN_CONFIRM |
| button:FindButton | FindButton > FindData_Main > FindData_Detail | 996 | SSP.SSP0001_GET_SHIPMENT_PLAN_CONFIRM_DETAIL | MATCH | SP SSP0001_GET_SHIPMENT_PLAN_CONFIRM_DETAIL |
| button:FindButton | FindButton > FindData_Main > FindData_Detail > InitSpread > GetSpdTitle | 1729 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Main | 829 | SSP.SSP0001_GET_SHIPMENT_PLAN_CONFIRM | MATCH | SP SSP0001_GET_SHIPMENT_PLAN_CONFIRM |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Main > FindData_Detail | 996 | SSP.SSP0001_GET_SHIPMENT_PLAN_CONFIRM_DETAIL | MATCH | SP SSP0001_GET_SHIPMENT_PLAN_CONFIRM_DETAIL |
| button:SaveButton | SaveButton > SaveData_Detail | 1495 | SSP.SSP0001_SAVE_SHIPMENT_PLAN_CONFIRM_DETAIL | MATCH | SP SSP0001_SAVE_SHIPMENT_PLAN_CONFIRM_DETAIL |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Main > FindData_Detail > InitSpread > GetSpdTitle | 1729 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 1729 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetBucketType | 745 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 780 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1729 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1750 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail | 996 | SSP.SSP0001_GET_SHIPMENT_PLAN_CONFIRM_DETAIL | MATCH | SP SSP0001_GET_SHIPMENT_PLAN_CONFIRM_DETAIL |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail > InitSpread > GetSpdTitle | 1729 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | <field:dtFcstType> | 54 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetDivision | 1682 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | SetChangedPeriod | 1696 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 1699 | biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetDayRange__ | 1790 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SSP_ANL_SHIP_PLAN_P, UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 2 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0001_GET_SHIPMENT_PLAN_CONFIRM | MATCH | 1 | SP SSP0001_GET_SHIPMENT_PLAN_CONFIRM | EXEC:SSP0001_GET_SHIPMENT_PLAN_CONFIRM, SELECT:SCM_MST_TITLESET_USER, CREATE:#TBLDYNAMICPIVOT_SSP0001_1, REF:FN_GET_IN_STR, DYNAMIC@SSP0001_GET_SHIPMENT_PLAN_CONFIRM, SELECT:SCM_SYS_CALENDAR_M, REF:FN_SCM_SPLIT |  |
| SSP.SSP0001_GET_SHIPMENT_PLAN_CONFIRM_DETAIL | MATCH | 1 | SP SSP0001_GET_SHIPMENT_PLAN_CONFIRM_DETAIL | EXEC:SSP0001_GET_SHIPMENT_PLAN_CONFIRM_DETAIL, REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_GET_PROJECT_NAME, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SITE_CUSTOMER_INFO, SELECT:SSP_ANL_SHIP_PLAN, SELECT:SCP_MST_BOD_N_V, SELECT:SSP_ANL_SHIP_CONFIRM_H, SELECT:TB_FX_USER, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCM_MST_SITE, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_SITE_CUSTOMER |  |
| SSP.SSP0001_SAVE_SHIPMENT_PLAN_CONFIRM_DETAIL | MATCH | 1 | SP SSP0001_SAVE_SHIPMENT_PLAN_CONFIRM_DETAIL | EXEC:SSP0001_SAVE_SHIPMENT_PLAN_CONFIRM_DETAIL, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SSP_ANL_SHIP_PLAN, EXEC:PR_SSP_ANL_SHIP_UPDATE_BOH_VAL, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_SCP_SYS_LOG_BATCH, CREATE:#TMP_SSP_ANL_SHIP_UPDATE_BOH, SELECT:SSP_PLAN_VERSION_V, SELECT:SSP_ANL_SHIP_PLAN, INSERT:#TMP_SSP_ANL_SHIP_UPDATE_BOH, SELECT:#TMP_SSP_ANL_SHIP_UPDATE_BOH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| CalculateSum | dr | measure |
| SetBalanceMinus | dr | DivisionID, FromSite, ItemID |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |
| SetPlanQtyNon | dr | DivisionID, FromSite, ItemID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:285 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:291, InitSpread:305 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:294 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetCheckedListValue | SetChangedControl:765, FindData_Main:805, FindData_Main:807, FindData_Main:811, SetChangedPeriod:1691 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:200 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:478 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:480 |
| this.spdDetail | TopChange | SpdDetail_TopChange | InitEvent:481 |
| this.btnMeasure | Click | btnMeasure_Click | InitEvent:483 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:484 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:485 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:486 |
| this.spdDetail | CellClick | SpdDetail_CellClick | InitEvent:488 |
| clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitEvent:490 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:491 |

## 6. 컨트롤 (34개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 11 | layoutControlItem7, lblItemId, layoutControlItem2, PlanDate, layoutControlItem6, layoutControlItem10, layoutControlItem3, layoutControlItem1, lcDivision, lblBucket, layoutControlItem8 |
| UsrButton | 3 | usrButton1, btnMeasure, btnItemId |
| UsrCheckBox | 3 | chkSum, chkBalance, chkPlanZero |
| UsrCombo | 2 | cboPlanDate, cboBucketType |
| UsrCheckedList | 2 | clbPlantSite, clbDivision |
| EmptySpaceItem | 2 | emptySpaceItem3, emptySpaceItem1 |
| FpSpread | 2 | spdMain, spdDetail |
| SheetView | 2 | spdMain_Sheet1, spdDetail_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker | 1 | drpPeriod |
| UsrMultiLineEditor | 1 | txtItemId |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SplitContainer | 1 | splitContainer1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 15 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 46 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 6 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_Favorite | 13 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 12 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 350 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (6건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1749 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |
| 1768 | SCP.SCM0001_GET_SCP_PERIOD | commented:MATCH |
| 1767 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |
| 1789 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |
| 1808 | SCP.SCM0001_GET_SCP_PERIOD | commented:MATCH |
| 1807 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0001 | Shipment Plan Confirm | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | SSP0001 | Shipment Plan Confirm Detail | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_MEASURE | SSP0001 | Shipment Plan Confirm | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Plan Confirm, Shipment Plan Confirm Detail
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:291, SetSheetHeaderColumn@InitSpread:305
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 427 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 431 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 435 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 699 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 704 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 711 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 715 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 720 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 727 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 731 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 767 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 768 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 769 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 770 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Plan Confirm | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| Shipment Plan Confirm Detail | META+코드연결 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
