# SCP0077 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0077_Shipping_Result_Check\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0077_Shipping_Result_Check\SCP0077_Shipping_Result_Check.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0077_Shipping_Result_Check\SCP0077_Shipping_Result_Check.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0077_Shipping_Result_Check\SCP0077_Shipping_Result_Check.csproj | 1214 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0077_Shipping_Result_Check\SCP0077_Shipping_Result_Check.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0077_Shipping_Result_Check\SCP0077_Shipping_Result_Check.csproj | 601 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > SetSpreadInit > GetSpdTitle | 545 | SCP.SCP0077_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0077_GET_SHEET_CALENDAR_3SPAN |
| button:FindButton | FindButton > Find_Data | 415 | SCP.SCP0077_GET_SHIPPING_RESULT_CHECK | MATCH | SP SCP0077_GET_SHIPPING_RESULT_CHECK |
| button:FindButton | FindButton > Find_Data_Daily | 495 | SCP.SCP0077_GET_SHIPPING_RESULT_CHECK_DAILY | MATCH | SP SCP0077_GET_SHIPPING_RESULT_CHECK_DAILY |
| button:FindButton | FindButton > Find_Data > SetSpreadInit > GetSpdTitle | 545 | SCP.SCP0077_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0077_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Main > Find_Data | 415 | SCP.SCP0077_GET_SHIPPING_RESULT_CHECK | MATCH | SP SCP0077_GET_SHIPPING_RESULT_CHECK |
| button:SaveButton | SaveButton > SaveData_Main > Find_Data > SetSpreadInit > GetSpdTitle | 545 | SCP.SCP0077_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0077_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Main | 1092 | SCP.SCP0077_SAVE_SHIPPING_RESULT_CHECK | MATCH | SP SCP0077_SAVE_SHIPPING_RESULT_CHECK |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread > SetSpreadInit > GetSpdTitle | 545 | SCP.SCP0077_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0077_GET_SHEET_CALENDAR_3SPAN |
| event:this.cboBucketType.SelectedIndexChanged | CboBucketType_SelectedIndexChanged > InitSpread > SetSpreadInit > GetSpdTitle | 545 | SCP.SCP0077_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0077_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > GetSpdTitle | 545 | SCP.SCP0077_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0077_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1162 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0077_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0077_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0077_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0077_GET_SHIPPING_RESULT_CHECK | MATCH | 1 | SP SCP0077_GET_SHIPPING_RESULT_CHECK | EXEC:SCP0077_GET_SHIPPING_RESULT_CHECK, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TMP_SCP0077_STD, SELECT:SCM_MST_SITE, SELECT:SCM_MST_PROJECT, SELECT:SCP_RPT_SHIPMENT, SELECT:SCM_MST_VENDOR, REF:STRING_SPLIT, REF:FN_GET_SCM_SITE_TO_PLANT, CREATE:#TMP_SCP0077_DATA, INSERT:#TMP_SCP0077_COLUMN, SELECT:SCM_MST_SHEET_COLUMNS, SELECT:#TMP_SCP0077_COLUMN, REF:FN_SCM_GET_WHERE_SQL, DYNAMIC@SCP0077_GET_SHIPPING_RESULT_CHECK, CREATE:#TMP_SCP0077_REASON, INSERT:#TMP_SCP0077_REASON, REF:FN_SCM_SPLIT, REF:SCM_ARR_SPL_VAL |  |
| SCP.SCP0077_GET_SHIPPING_RESULT_CHECK_DAILY | MATCH | 1 | SP SCP0077_GET_SHIPPING_RESULT_CHECK_DAILY | EXEC:SCP0077_GET_SHIPPING_RESULT_CHECK_DAILY, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TMP_SCP0077_STD, SELECT:SCM_MST_SITE, SELECT:SCM_MST_PROJECT, SELECT:SCP_RPT_SHIPMENT, SELECT:SCM_MST_VENDOR, REF:STRING_SPLIT, REF:FN_GET_SCM_SITE_TO_PLANT, INSERT:#TMP_DAILY_STD, SELECT:SCP_RPT_SHIPMENT_DETAIL, INSERT:#TMP_DAILY_RESULT, SELECT:SCM_MST_DIVISION, SELECT:SCM_PLANT_M_SN, SELECT:#TMP_DAILY_STD, SELECT:#TMP_SCP0077_STD, SELECT:#TMP_DAILY_RESULT, REF:FN_SCM_SPLIT |  |
| SCP.SCP0077_SAVE_SHIPPING_RESULT_CHECK | MATCH | 1 | SP SCP0077_SAVE_SHIPPING_RESULT_CHECK | EXEC:SCP0077_SAVE_SHIPPING_RESULT_CHECK, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SCP_RPT_SHIPMENT, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| Find_Data | ds.Tables[1].Rows[0] | IS_EDITABLE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:223, Find_Data:399, Find_Data:400, Find_Data:401, Find_Data_Daily:481, Find_Data_Daily:482, Find_Data_Daily:483 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | SetSpreadInit:254 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | SetSpreadInit:255 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | SetSpreadInit:268 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:175 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:320 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:321 |
| this.cboBucketType | SelectedIndexChanged | CboBucketType_SelectedIndexChanged | InitEvent:322 |
| this.btnColumn | Click | BtnColumn_Click | InitEvent:323 |
| this.rdUOM | CheckedChanged | rdButton_Changed | InitEvent:324 |
| this.rdCell | CheckedChanged | rdButton_Changed | InitEvent:325 |

## 6. 컨트롤 (22개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | layoutPlant1, layoutUOM, layoutCell, layoutBtnColumn, layoutPlanDate, lblDivision, layoutControlItem1 |
| UsrCombo | 3 | cboDivision, cboPlanDate, cboBucketType |
| EmptySpaceItem | 3 | emptySpaceItem2, emptySpaceItem3, emptySpaceItem6 |
| UsrRadio | 2 | rdCell, rdUOM |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckedList2 | 1 | clbPlant |
| UsrButton | 1 | btnColumn |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 25 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 14 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 24 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 10 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 7 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 12 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0077 | ShippingResultCheck | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: ShippingResultCheck
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetSpreadInit:255
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn_Daily, InitSpreadDateColumn, SetColumnVisible

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadInit |  | 269 | 표시/라벨 변경 | local:SetColumnVisible |  |  | else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") |
| InitSpreadDateColumn |  | 571 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | SHIP_PLAN_SCP | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 574 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 575 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 576 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 580 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | SHIP_PLAN_SSP | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 583 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 584 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 585 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 589 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | SHIP_RESULT | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 592 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 593 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 594 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 598 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | SHIP_RESULT_TOT | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 601 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 602 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 603 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 608 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | SHIP_PLAN_SCP_CELL | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 611 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 612 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 613 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 617 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | SHIP_PLAN_SSP_CELL | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 620 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 621 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 622 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 626 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | SHIP_RESULT_CELL | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 629 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 630 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 631 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 635 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | SHIP_RESULT_TOT_CELL | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 638 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 639 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 640 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 644 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | CO_RATE | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 647 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 648 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 649 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 653 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | AC_RATE | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 656 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 657 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 658 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 662 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | CO_RATE_CELL | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 665 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 666 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 667 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 671 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | AC_RATE_CELL | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 674 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 675 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 676 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 680 | DB루프 | AddTextColumn | {?dr[DefColumns.WEEK_NAME]} | REASON_CODE | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 681 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 682 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 683 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 687 | DB루프 | AddTextColumn | {?dr[DefColumns.WEEK_NAME]} | REASON_DESCRIPTION | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 688 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 689 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 690 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 744 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | BEF4_CO_RATE \|\| BEF3_CO_RATE \|\| BEF2_CO_RATE \|\| BEF1_CO_RATE | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 747 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 748 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 749 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 753 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | BEF4_AC_RATE \|\| BEF3_AC_RATE \|\| BEF2_AC_RATE \|\| BEF1_AC_RATE | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 756 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 757 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 758 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 761 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | BEF4_CO_RATE_CELL \|\| BEF3_CO_RATE_CELL \|\| BEF2_CO_RATE_CELL \|\| BEF1_CO_RATE_CELL | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 764 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 765 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 766 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 770 | DB루프 | AddNumColumn | {?dr[DefColumns.WEEK_NAME]} | BEF4_AC_RATE_CELL \|\| BEF3_AC_RATE_CELL \|\| BEF2_AC_RATE_CELL \|\| BEF1_AC_RATE_CELL | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 773 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 774 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn |  | 775 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sPlanDate == sBasisYyyymmdd) |
| InitSpreadDateColumn_Daily |  | 807 | DB루프 | AddNumColumn | {?dr[DefColumns.DAY_NAME]} | SHIP_PLAN_SCP_D1 | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 809 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 810 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 811 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 814 | DB루프 | AddNumColumn | {?dr[DefColumns.DAY_NAME]} | SHIP_PLAN_SSP_D1 | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 816 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 817 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 818 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 822 | DB루프 | AddNumColumn | {?dr[DefColumns.DAY_NAME]} | SHIP_RESULT_D1 | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 824 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 825 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 826 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 829 | DB루프 | AddNumColumn | {?dr[DefColumns.DAY_NAME]} | SHIP_RESULT_TOT_D1 | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 831 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 832 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 833 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 836 | DB루프 | AddNumColumn | {?dr[DefColumns.DAY_NAME]} | SHIP_CO_RATE_D1 | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 838 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 839 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 840 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 843 | DB루프 | AddNumColumn | {?dr[DefColumns.DAY_NAME]} | SHIP_AC_RATE_D1 | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 845 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 846 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 847 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 858 | DB루프 | AddNumColumn | {?dr[DefColumns.DAY_NAME]} | SHIP_PLAN_SCP_CELL_D1 | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 860 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 861 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 862 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 865 | DB루프 | AddNumColumn | {?dr[DefColumns.DAY_NAME]} | SHIP_PLAN_SSP_CELL_D1 | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 867 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 868 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 869 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 873 | DB루프 | AddNumColumn | {?dr[DefColumns.DAY_NAME]} | SHIP_RESULT_CELL_D1 | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 875 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 876 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 877 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 880 | DB루프 | AddNumColumn | {?dr[DefColumns.DAY_NAME]} | SHIP_RESULT_TOT_CELL_D1 | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 882 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 883 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 884 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 887 | DB루프 | AddNumColumn | {?dr[DefColumns.DAY_NAME]} | SHIP_CO_RATE_CELL_D1 | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 889 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 890 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 891 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 894 | DB루프 | AddNumColumn | {?dr[DefColumns.DAY_NAME]} | SHIP_AC_RATE_CELL_D1 | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 896 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 897 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| InitSpreadDateColumn_Daily |  | 898 | 표시/라벨 변경 | SetColumnHeader | 2 |  | foreach(dr in dsSpdTitle.Tables[1].Rows) |
| HeaderSpan_Daily |  | 919 | 식 | AddColumnHeaderSpanCell | 0 | 0 \|\| {?spdInfo.GetMaxColumnIndex()}1 \|\| {?iStartCol += iColSpanCnt_0} \|\| {?iStartCol += iColSpanCnt_1} | for(iCol < ColLoopCnt_0) |
| HeaderSpan_Daily |  | 926 | 식 | AddColumnHeaderSpanCell | 1 | 0 \|\| {?spdInfo.GetMaxColumnIndex()}1 \|\| {?iStartCol += iColSpanCnt_0} \|\| {?iStartCol += iColSpanCnt_1} | for(iCol < ColLoopCnt_1) |
| SetColumnVisible |  | 968 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  |  |
| SetColumnVisible |  | 969 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  |  |
| SetColumnVisible |  | 970 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  |  |
| SetColumnVisible |  | 971 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  |  |
| SetColumnVisible |  | 972 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  |  |
| SetColumnVisible |  | 973 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  |  |
| SetColumnVisible |  | 974 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  |  |
| SetColumnVisible |  | 975 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  |  |
| SetColumnVisible |  | 976 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  |  |
| SetColumnVisible |  | 977 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  |  |
| SetColumnVisible |  | 978 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  |  |
| SetColumnVisible |  | 979 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  |  |
| SetColumnVisible |  | 980 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  |  |
| SetColumnVisible |  | 981 | 표시/라벨 변경 | set:Visible | Visible = {?rdUOM.Checked} |  |  |
| SetColumnVisible |  | 984 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  |  |
| SetColumnVisible |  | 985 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  |  |
| SetColumnVisible |  | 986 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  |  |
| SetColumnVisible |  | 987 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  |  |
| SetColumnVisible |  | 988 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  |  |
| SetColumnVisible |  | 989 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  |  |
| SetColumnVisible |  | 991 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  |  |
| SetColumnVisible |  | 992 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  |  |
| SetColumnVisible |  | 993 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  |  |
| SetColumnVisible |  | 994 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  |  |
| SetColumnVisible |  | 995 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  |  |
| SetColumnVisible |  | 996 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  |  |
| SetColumnVisible |  | 997 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  |  |
| SetColumnVisible |  | 998 | 표시/라벨 변경 | set:Visible | Visible = {?rdCell.Checked} |  |  |
| SetColumnVisible_Daily |  | 1015 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdCell.Checked) ⟫ if(colName.Contains("_CELL_")) |
| SetColumnVisible_Daily |  | 1019 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(rdCell.Checked) ⟫ else!(colName.Contains("_CELL_")) |
| SetColumnVisible_Daily |  | 1026 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdCell.Checked) ⟫ if(rdUOM.Checked) ⟫ if(colName.Contains("_CELL_")) |
| SetColumnVisible_Daily |  | 1030 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(rdCell.Checked) ⟫ if(rdUOM.Checked) ⟫ else!(colName.Contains("_CELL_")) |
| rdButton_Changed |  | 1206 | 표시/라벨 변경 | local:SetColumnVisible |  |  | else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") |
| InitializeComponent |  | 464 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 465 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 466 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 467 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| ShippingResultCheck | META+코드연결 | 39 (?18) | 39 (?18) | 39 (?18) | 39 (?18) | 39 (?18) | 39 (?18) | 39 (?18) | 39 (?18) | 39 (?18) | 39 (?18) | 39 (?18) | 39 (?18) | 39 (?18) | 39 (?18) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:조회데이터 252 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 252건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
