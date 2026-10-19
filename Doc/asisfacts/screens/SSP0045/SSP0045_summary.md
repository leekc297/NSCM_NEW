# SSP0045 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1468 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 684 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main > InitSpread_2 | 299 | biz:CommonData.CommonDataList [code=PlantSiteByDivision] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 587 | SSP.SSP0045_GET_SHIPMENT_REQUEST | MATCH | SP SSP0045_GET_SHIPMENT_REQUEST |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 1115 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData > FindData_Main > InitSpread_2 | 299 | biz:CommonData.CommonDataList [code=PlantSiteByDivision] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 587 | SSP.SSP0045_GET_SHIPMENT_REQUEST | MATCH | SP SSP0045_GET_SHIPMENT_REQUEST |
| button:SaveButton | SaveButton > SaveData | 944 | SSP.SSP0045_SAVE_SHIPMENT_REQUEST | MATCH | SP SSP0045_SAVE_SHIPMENT_REQUEST |
| button:SaveButton | SaveButton > SaveData > FindData_Main > InitSpread_2 > GetSpdTitle | 1115 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.cboBizType.SelectedIndexChanged | CboBizType_SelectedIndexChanged | 413 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:this.cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 268 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetBucketType | 279 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 | 299 | biz:CommonData.CommonDataList [code=PlantSiteByDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > GetDayRange | 647 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 1115 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlantSiteByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList_SCP:REF:STRING_SPLIT |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0045_GET_SHIPMENT_REQUEST | MATCH | 1 | SP SSP0045_GET_SHIPMENT_REQUEST | EXEC:SSP0045_GET_SHIPMENT_REQUEST, SELECT:SCP_PLAN_VERSION_V, CREATE:#TBLDYNAMIC_PLAN, CREATE:#TBLDYNAMIC_SHIP_ROW, CREATE:#TBLDYNAMIC_CAL_QTY, CREATE:#TBLDYNAMIC_FILTER, INSERT:#TMP_SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCP_PLN_SHIPMENT_PLAN_PEGGING, SELECT:SCP_PLN_SHIPMENT_PLAN, REF:FN_NEXT_DAY, SELECT:SCP_MST_BOD_N_V, REF:STRING_SPLIT, INSERT:#TBLDYNAMIC_PLAN, SELECT:SCP_ANL_SHIPMENT_PLAN_SEMI, SELECT:SCM_MST_SITE, SELECT:#TMP_SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SSP_ANL_SHIP_CONFIRM, INSERT:#TBLDYNAMIC_PLAN_ERP_RESULT, SELECT:RESULT_ERP_C_EXIST, SELECT:RESULT_ERP_C_NON, SELECT:#TBLDYNAMIC_PLAN, SELECT:SCM_DNM_EXFACTORY_RESULT, SELECT:SCP_MST_FINAL_ITEM, REF:FN_LIST_LOOKUP_VALUE, INSERT:#TBLDYNAMIC_SHIP_REQ, REF:FN_GET_ANL_SHIP_FROZEN_DAY_CNT, SELECT:DM_PLN_SHIPMENT_REQ, INSERT:#TBLDYNAMIC_SHIP_REQ_OWMS_RESULT, SELECT:SSP_DNM_SHIP_RESULT_OWMS_V, SELECT:#TBLDYNAMIC_SHIP_REQ, INSERT:#TBLDYNAMIC_FILTER, INSERT:#TBLDYNAMIC_SCP0045_40_STD, SELECT:#TBLDYNAMIC_FILTER, SELECT:SSP_ANL_SHIP_PLAN_40, INSERT:#TBLDYNAMIC_SHIP_ROW, SELECT:#TBLDYNAMIC_PLAN_ERP_RESULT, SELECT:#TBLDYNAMIC_SHIP_REQ_OWMS_RESULT, SELECT:SCM_DNM_CELL_INHOUSE_PLAN_SN, SELECT:#TBLDYNAMIC_SCP0045_40_STD, SELECT:SCM_DNM_PLAN_FROZEN_V, SELECT:SCM_MST_ITEM_SN, UPDATE:#TBLDYNAMIC_SHIP_ROW, INSERT:#STOCK, SELECT:SSP_DNM_STOCK_C, SELECT:SCM_MST_LOCATION, SELECT:SCM_SYS_CALENDAR_M, SELECT:#TBLDYNAMIC_SHIP_ROW, SELECT:#STOCK, INSERT:#TBLDYNAMIC_CAL_QTY, SELECT:#TBLDYNAMIC_CAL_QTY, INSERT:#TBLDYNAMIC_REQUESTOR, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#TBLDYNAMIC_SHIP_PIVOT, DYNAMIC@SSP0045_GET_SHIPMENT_REQUEST, SELECT:SCM_CODE_LOOKUP_VALUE |  |
| SSP.SSP0045_SAVE_SHIPMENT_REQUEST | MATCH | 1 | SP SSP0045_SAVE_SHIPMENT_REQUEST | EXEC:SSP0045_SAVE_SHIPMENT_REQUEST, CREATE:#TBLDYNAMIC_SSP0045_SHPIMENTREQ, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:#TBLDYNAMIC_SSP0045_SHPIMENTREQ, SELECT:#TBLDYNAMIC_SSP0045_SHPIMENTREQ, UPDATE:A, SELECT:DM_PLN_SHIPMENT_REQ, INSERT:DM_PLN_SHIPMENT_REQ, INSERT:DM_PLN_SHIPMENT_REQ_H, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| checkValidN0 | dr | p_division_id, p_scm_site_id, p_item_id, p_incoterms, p_transport_mode, p_plant_site_id, p_user_id, p_bod_id, p_project_code, p_fcst_type |
| checkValidN0 | cpDr | p_division_id, p_scm_site_id, p_item_id, p_incoterms, p_transport_mode, p_plant_site_id, p_bod_id, p_project_code, p_fcst_type |
| InitSpread_2 | drRow | CODE, NAME |
| Set_SumValues | dsBinding.Tables[0].Columns | MEASURE |
| SetChangeControl | Filter | GROUP_ID, USER_ID |
| SetChangeControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSSPInnerTable | SetChangeControl:176 | DataService.GetSSPInnerTable | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID |
| FP_Log2 | InitControls:199, InitControls:201 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetCheckedListValue | SetChangedControl:264, FindData_Main:565, FindData_Main:568, FindData_Main:570, InsertRow:755, InsertRow2:786, SpdMain_CellClick:1227, SpdMain_CellClick:1228 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread_2:310 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread_2:313 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread_2:316 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| SaveData | SaveButton:527 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:177 |
| this | Load | Form_Load | .ctor:148 |
| this.cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:400 |
| this.btnItem_Id | Click | BtnItem_Id_Click | InitEvent:401 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:402 |
| this.cboBizType | SelectedIndexChanged | CboBizType_SelectedIndexChanged | InitEvent:403 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:405 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:406 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:407 |
| this.spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:408 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | SpdMain_CellClick:1252 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | SpdMain_CellClick:1334 |

## 6. 컨트롤 (25개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 8 | lblCombo, lblCombo1, lblBucket, lblItemId, layoutControlItem4, layoutControlItem6, layoutControlItem9, layoutControlItem3 |
| UsrCombo | 3 | cboBizType, cboDivision, cboBucketType |
| UsrButton | 2 | usrButton1, btnItem_Id |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem3 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckBox | 1 | chkSum |
| UsrMultiLineEditor | 1 | txtItem_Id |
| UsrDateRangePicker | 1 | drpPeriod |
| UsrCheckedList | 1 | clbFromSite |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SheetView | 1 | spdMain_Sheet1 |
| FpSpread | 1 | spdMain |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 120 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 18 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 9 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_Favorite | 14 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 11 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 55 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 834 | SSP.PR_SCM_SYS_LOG_BATCH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0045 | Shipment Request | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |
| SCM_MST_SHEET_MEASURE | SSP0045 | Shipment Request | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Request
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread_2:313
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 354 | DB루프 | AddTextColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 358 | DB루프 | AddNumColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 362 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 1140 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1144 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1149 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1152 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1156 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1161 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1164 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| InitializeComponent |  | 580 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 581 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 582 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 583 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Request | META+코드연결 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
