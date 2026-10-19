# SCP0025 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0025_ShipmentPlanFix\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0025_ShipmentPlanFix\SCP0025_ShipmentPlanFix.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0025_ShipmentPlanFix\SCP0025_ShipmentPlanFix.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0025_ShipmentPlanFix\SCP0025_ShipmentPlanFix.csproj | 1271 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0025_ShipmentPlanFix\SCP0025_ShipmentPlanFix.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0025_ShipmentPlanFix\SCP0025_ShipmentPlanFix.csproj | 913 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo_U > FindData_Main > InitSpread_2 > GetSpdTitle | 280 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo_U > FindData_Main | 541 | SCP.SCP0025_GET_SHIPMENT_PLAN_FIX | MATCH | SP SCP0025_GET_SHIPMENT_PLAN_FIX |
| event:btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo_U | 1097 | biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanFix] | BIZ_MATCH |  |
| event:btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo_U | 1097 | SCP\Analysis\SCP0025_ShipmentPlanFix#SaveShipmentPlanFix | MATCH_PATTERN | SP SCP0025_SAVE_SHIPMENT_PLAN_FIX_DATASET |
| event:btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo_U > SCM_SYS_LOG_BATCH | 1156 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:btnUnfix.Click | BtnUnfix_Click > SaveData_FixInfo_U > FindData_Main > InitSpread_2 > GetSpdTitle | 1182 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 280 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 541 | SCP.SCP0025_GET_SHIPMENT_PLAN_FIX | MATCH | SP SCP0025_GET_SHIPMENT_PLAN_FIX |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 1182 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnW26.Click | BtnW26_Click > GetDayRange | 743 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.btnW52.Click | BtnW52_Click > GetDayRange | 743 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.btnWLast.Click | BtnWLast_Click > GetDayRange | 743 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > GetLastRange | 729 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| event:this.Load | Form_Load > InitControls | 192 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 195 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetBucketType | 227 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 280 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetLastRange | 729 | SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD |
| event:this.Load | Form_Load > CreateSpread > GetDayRange | 743 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 1182 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanFix] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_COLUMNS |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD | EXEC:SCM0001_GET_SCP_DAILY_PLAN_PERIOD, SELECT:SCM_MST_DIVISION |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0025_GET_SHIPMENT_PLAN_FIX | MATCH | 1 | SP SCP0025_GET_SHIPMENT_PLAN_FIX | EXEC:SCP0025_GET_SHIPMENT_PLAN_FIX, CREATE:#TBLDYNAMICPIVOT_SCP0025, REF:FN_GET_DIVISION_DIV, INSERT:#TBLDYNAMICPIVOT_SCP0025, SELECT:SCP_ANL_SHIPMENT_PLAN_FIX, SELECT:SCP_MST_BOD_N_V, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@SCP0025_GET_SHIPMENT_PLAN_FIX, SELECT:SCM_MST_DIVISION |  |
| SCP\Analysis\SCP0025_ShipmentPlanFix#SaveShipmentPlanFix | MATCH_PATTERN | 1 | SP SCP0025_SAVE_SHIPMENT_PLAN_FIX_DATASET | EXEC:SCP0025_SAVE_SHIPMENT_PLAN_FIX_DATASET, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#JV_ESS_SCM_SITE_MAP, REF:FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP, INSERT:#DIVISION_LAST_PLAN_INFO, SELECT:SCP_PLAN_INFO, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_DIVISION, INSERT:#BOD_ITEM, SELECT:BOD_ITEM, SELECT:SCP_MST_BOD, SELECT:SCP_MST_BOD_ITEM, SELECT:#JV_ESS_SCM_SITE_MAP, SELECT:SCM_MST_BUCKET, SELECT:#DIVISION_LAST_PLAN_INFO, SELECT:#BOD_ITEM, INSERT:SCP_ANL_SHIPMENT_PLAN_FIX_H, SELECT:SCP_ANL_SHIPMENT_PLAN_FIX, DELETE:A, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_SITE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| BtnUnfix_Click | dtPlanExecYn.Rows[0] | PLAN_STATUS |
| SaveData_FixInfo_U | dr | p_active_flag, p_division_id, p_operation_group, p_item_id, p_to_site, p_from_site, p_bod_id, p_yyyymmdd, p_project_code, p_incoterms, p_qty, p_origin_from_division_id, p_origin_to_division_id, p_electrode_type, p_created_by |
| SaveData_FixInfo_U | result.Rows[0] | result_code, result_cnt, err_message |
| Set_FixReason | dr | FIX_REASON |
| Set_SumValues | dsBinding.Tables[0].Columns | measure |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:201, InitSpread_2:261, CboDivision_SelectedIndexChanged:440, FindData_Main:517, FindData_Main:520, FindData_Main:522, BtnUnfix_Click:765, SetOperationGroupByDivision:867 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread_2:249, InitSpread:334 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread_2:252 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread_2:255, InitSpread:337 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:300 |
| this | Load | Form_Load | .ctor:162 |
| this.cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:423 |
| this.btnItem_Id | Click | BtnItem_Id_Click | InitEvent:424 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:425 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:427 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:428 |
| btnUnfix | Click | BtnUnfix_Click | InitEvent:430 |
| this.btnW26 | Click | BtnW26_Click | InitEvent:431 |
| this.btnW52 | Click | BtnW52_Click | InitEvent:432 |
| this.btnWLast | Click | BtnWLast_Click | InitEvent:433 |

## 6. 컨트롤 (32개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 12 | lblCombo, lblCombo1, lblBucket, lblItemId, layoutControlItem4, layoutControlItem9, layoutControlItem3, layoutControlItem1, layoutControlItem2, layoutControlItem5, layoutControlItem7, layoutControlItem8 |
| UsrButton | 6 | usrButton1, btnWLast, btnW52, btnW26, btnItem_Id, btnUnfix |
| UsrCombo | 3 | cboBizType, cboDivision, cboBucketType |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem3 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckBox | 1 | chkSum |
| UsrMultiLineEditor | 1 | txtItem_Id |
| UsrCheckedList | 1 | clbElecType |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SheetView | 1 | spdMain_Sheet1 |
| FpSpread | 1 | spdMain |
| UsrDateRangePicker3 | 1 | dCalendar |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1097 | SaveData_FixInfo_U | {?definition_path}#SaveShipmentPlanFix | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 29 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 20 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 9 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 58 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (2건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 710 | SCP.SCM0001_GET_SCP_PERIOD | commented:MATCH |
| 709 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0025 | Shipment Plan Fix | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Plan Fix
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread_2:252
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread_2 |  | 264 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 265 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_TO_DIVISION_ID | if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 266 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_FROM_DIVISION_ID | if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 270 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 271 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_TO_DIVISION_ID | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 272 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_FROM_DIVISION_ID | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread | Shipment Plan Fix | 292 | 하드코딩 | AddTextColumn | Division | division_id | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpread | Shipment Plan Fix | 293 | 하드코딩 | AddTextColumn | Operation Group | biz_type_name | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpread | Shipment Plan Fix | 294 | 하드코딩 | AddTextColumn | Model | item_id | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpread | Shipment Plan Fix | 295 | 하드코딩 | AddTextColumn | Nick Name | nick_name | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpread | Shipment Plan Fix | 296 | 하드코딩 | AddTextColumn | To Site | to_site_description | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpread | Shipment Plan Fix | 298 | 하드코딩 | AddTextColumn | From Site | from_site_description | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpread | Shipment Plan Fix | 299 | 하드코딩 | AddTextColumn | Incoterms | incoterms | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpread | Shipment Plan Fix | 300 | 하드코딩 | AddTextColumn | Project Code | project_code | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpread | Shipment Plan Fix | 301 | 하드코딩 | AddTextColumn | Trans Mode | transport_mode | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpread | Shipment Plan Fix | 302 | 하드코딩 | AddTextColumn | L/T(Day) | lt_total | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpread | Shipment Plan Fix | 304 | 하드코딩 | AddTextColumn | Measure | measure | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpread | Shipment Plan Fix | 305 | 하드코딩 | AddTextColumn | Division | division_name | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpread | Shipment Plan Fix | 306 | 하드코딩 | AddTextColumn | BIZ_TYPE | biz_type | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpread | Shipment Plan Fix | 307 | 하드코딩 | AddTextColumn | To Site | to_site | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpread | Shipment Plan Fix | 308 | 하드코딩 | AddTextColumn | FROM_SITE | from_site | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpread | Shipment Plan Fix | 310 | 하드코딩 | AddTextColumn | to_yyyymmdd | to_yyyymmdd | if(spdInfo.SheetName == "Shipment Plan Fix") |
| InitSpreadDateColumn |  | 374 | DB루프 | AddTextColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 378 | DB루프 | AddNumColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 382 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 1206 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1210 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1215 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1218 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1222 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1227 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1230 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| InitializeComponent |  | 739 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 740 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 741 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 742 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Plan Fix | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 19 | 19 | 19 | 19 | 19 | 19 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
