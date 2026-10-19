# SCP0056 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0056_MPP_Result_Mgmt\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0056_MPP_Result_Mgmt\SCP0056_MPP_Result_Mgmt.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0056_MPP_Result_Mgmt\SCP0056_MPP_Result_Mgmt.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0056_MPP_Result_Mgmt\SCP0056_MPP_Result_Mgmt.csproj | 1197 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0056_MPP_Result_Mgmt\SCP0056_MPP_Result_Mgmt.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0056_MPP_Result_Mgmt\SCP0056_MPP_Result_Mgmt.csproj | 1391 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 239 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbGroup.SelectedIndexChanged | clbGroup_SelectedIndexChanged | 1097 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged | 358 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | 1117 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Data > FindData_Main | 874 | SCP.SCP0056_GET_MPP | MATCH | SP SCP0056_GET_MPP |
| button:SaveButton | SaveButton | 638 | SCP.SCP0056_SET_MPP_NOTE | MATCH | SP SCP0056_SET_MPP_NOTE |
| button:SaveButton | SaveButton > FindData_Main | 874 | SCP.SCP0056_GET_MPP | MATCH | SP SCP0056_GET_MPP |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 239 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:this.spdMain.ActiveSheetChanged | SpdMain_ActiveSheetChanged > SetChangedControl | 239 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetBucketType | 261 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_LINE_HIERARCHY_V_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_OPERATION_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP_ALL:SELECT:SCM_LINE_HIERARCHY_CPS_V_SN, UP_FX_GetCommonDataList_SCP_ALL:SELECT:SCM_MST_OPERATION_SN |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0056_GET_MPP | MATCH | 1 | SP SCP0056_GET_MPP | EXEC:SCP0056_GET_MPP, INSERT:#TMP_SCP0056_BASIS_DATE, SELECT:SCM_SYS_CALENDAR_M, INSERT:#TMP_SCP0056_DAILY_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_GET_ITEM_OPERATION_GROUP, SELECT:SCM_DNM_MPP, REF:STRING_SPLIT, SELECT:#TMP_SCP0056_DAILY_DATA, SELECT:#TMP_SCP0056_BASIS_DATE, INSERT:#TMP_SCP0056_WEEKLY_DATA, SELECT:#TMP_SCP0056_WEEKLY_DATA, INSERT:#TMP_SCP0056_MONTHLY_DATA, SELECT:#TMP_SCP0056_MONTHLY_DATA, INSERT:#TMP_SCP0056_SUM_DATA_DAILY, INSERT:#TMP_SCP0056_SUM_DATA_WEEKLY, SELECT:SCM_DNM_MPP_REASON, INSERT:#TMP_SCP0056_SUM_DATA_MONTHLY, SELECT:#TMP_SCP0056_SUM_DATA_MONTHLY, SELECT:#TMP_SCP0056_SUM_DATA_WEEKLY, SELECT:#TMP_SCP0056_SUM_DATA_DAILY, SELECT:SCM_MST_ITEM_SN |  |
| SCP.SCP0056_SET_MPP_NOTE | MATCH | 1 | SP SCP0056_SET_MPP_NOTE | EXEC:SCP0056_SET_MPP_NOTE, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, SELECT:SCM_DNM_MPP_SNAPSHOT, UPDATE:SCM_DNM_MPP_REASON, INSERT:SCM_DNM_MPP_REASON, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| Set_SumValues | dsBinding.Tables[0].Columns | GAP_ACC, GAP, GAP_ACC_CELL, GAP_CELL, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, BASIC_ITEM, PROD_TYPE, EXTRA_SPEC, SORT_ORDER |
| SetReasonColumn | siMain.ActiveSheet.Columns | MPP_OUT, RESULT_RP, GAP, GAP_ACC, GAP_CELL, GAP_ACC_CELL, DEMAND, PRODUCT_MOD, PRODUCT_SETBACK, SEMI_PRODUCT, MATERIAL, ETC_REASON, PRODUCT_OVER, MPP_OUT_CELL, RESULT_RP_CELL, DEMAND_CELL, PRODUCT_MOD_CELL, PRODUCT_SETBACK_CELL, SEMI_PRODUCT_CELL, MATERIAL_CELL, ETC_REASON_CELL, PRODUCT_OVER_CELL, NOTE1, NOTE2, NOTE3 |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | DefineProperty:165, SetChangedControl:216, SetChangedControl:220, SetChangedControl:224, SetChangedControl:232, SetChangedControl:237, SetChangedControl:242, SetChangedControl:247 | CString.GetCheckedListValue | CODE |
| InitSpreadDateColumn | CreateSpread:275, FindData_Main:774 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| SetSheetHeaderColumn | InitSpreadDateColumn:294, SetSpreadInit:303 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | EditModeOff | SpdMain_EditModeOff | InitializeComponent:1155 |
| this.spdMain | EditChange | SpdMain_EditChange | InitializeComponent:1156 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:1157 |
| this | Load | Form_Load | .ctor:146 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:311 |
| clbGroup | SelectedIndexChanged | clbGroup_SelectedIndexChanged | InitEvent:313 |
| clbPlant | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:314 |
| clbBuilding | SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | InitEvent:315 |
| clbLine | SelectedIndexChanged | ClbLine_SelectedIndexChanged | InitEvent:316 |
| clbOperation | SelectedIndexChanged | clbOperation_SelectedIndexChanged | InitEvent:317 |
| clbItemExtraSpec | SelectedIndexChanged | clbItemExtraSpec_SelectedIndexChanged | InitEvent:318 |
| RdoUOMCheck | CheckedChanged | RdoUOMCheck_CheckedChanged | InitEvent:319 |
| cbNote | CheckedChanged | cbNote_CheckedChanged | InitEvent:320 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:322 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:323 |
| spdMain | CellClick | SpdMain_CellClick | InitEvent:324 |
| dsdmMain | Changed | SpdMain_Changed | InitEvent:327 |
| spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:329 |
| this.spdMain | ActiveSheetChanged | SpdMain_ActiveSheetChanged | InitEvent:331 |

## 6. 컨트롤 (53개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 17 | layoutControlItem1, layoutControlItem8, layoutControlItem3, layoutControlItem4, layoutControlItem5, layoutControlItem6, layoutControlItem7, layoutControlItem12, layoutGroup, layoutControlItem2, layoutControlItem13, layoutControlItem15, layoutControlItem11, layoutControlItem16, lcCellTypeGr … |
| EmptySpaceItem | 11 | emptySpaceItem2, emptySpaceItem4, emptySpaceItem6, emptySpaceItem7, emptySpaceItem13, emptySpaceItem5, emptySpaceItem1, emptySpaceItem9, emptySpaceItem3, emptySpaceItem8, emptySpaceItem10 |
| UsrCheckedList2 | 6 | clbOperation, clbLine, clbBuilding, clbPlant, clbItemExtraSpec, clbGroup |
| UsrCheckBox | 4 | cbNote, cbDay, cbWeek, cbMonth |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrRadio | 2 | RdoCellCheck, RdoUOMCheck |
| UsrMultiLineEditor | 2 | txtMaterial, txtNickName |
| SheetView | 2 | spdMain_Sheet1, spdExcept_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCheckedList | 1 | cboCellTypeGr |
| UsrCombo | 1 | cboDivision |
| FpSpread | 1 | spdMain |
| UsrDateRangePicker3 | 1 | dCalendar |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 11 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 50 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 15 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 166 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0056 | MPP vs Result Mgmt. | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: MPP vs Result Mgmt.
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpreadDateColumn:294, SetSheetHeaderColumn@SetSpreadInit:303
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetReasonColumn |  | 412 | 표시/라벨 변경 | set:Visible | Visible = {?true} | MPP_OUT | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 413 | 표시/라벨 변경 | set:Visible | Visible = {?true} | RESULT_RP | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 414 | 표시/라벨 변경 | set:Visible | Visible = {?true} | GAP | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 415 | 표시/라벨 변경 | set:Visible | Visible = {?true} | GAP_ACC | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 416 | 표시/라벨 변경 | set:Visible | Visible = {?false} | GAP_CELL | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 417 | 표시/라벨 변경 | set:Visible | Visible = {?false} | GAP_ACC_CELL | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 419 | 표시/라벨 변경 | set:Visible | Visible = {?true} | DEMAND | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 420 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PRODUCT_MOD | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 421 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PRODUCT_SETBACK | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 422 | 표시/라벨 변경 | set:Visible | Visible = {?true} | SEMI_PRODUCT | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 423 | 표시/라벨 변경 | set:Visible | Visible = {?true} | MATERIAL | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 424 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ETC_REASON | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 425 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PRODUCT_OVER | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 427 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MPP_OUT_CELL | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 428 | 표시/라벨 변경 | set:Visible | Visible = {?false} | RESULT_RP_CELL | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 429 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DEMAND_CELL | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 430 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PRODUCT_MOD_CELL | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 431 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PRODUCT_SETBACK_CELL | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 432 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SEMI_PRODUCT_CELL | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 433 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MATERIAL_CELL | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 434 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ETC_REASON_CELL | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 435 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PRODUCT_OVER_CELL | if(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 439 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MPP_OUT | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 440 | 표시/라벨 변경 | set:Visible | Visible = {?false} | RESULT_RP | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 441 | 표시/라벨 변경 | set:Visible | Visible = {?false} | GAP | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 442 | 표시/라벨 변경 | set:Visible | Visible = {?false} | GAP_ACC | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 443 | 표시/라벨 변경 | set:Visible | Visible = {?true} | GAP_CELL | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 444 | 표시/라벨 변경 | set:Visible | Visible = {?true} | GAP_ACC_CELL | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 446 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DEMAND | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 447 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PRODUCT_MOD | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 448 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PRODUCT_SETBACK | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 449 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SEMI_PRODUCT | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 450 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MATERIAL | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 451 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ETC_REASON | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 452 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PRODUCT_OVER | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 454 | 표시/라벨 변경 | set:Visible | Visible = {?true} | MPP_OUT_CELL | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 455 | 표시/라벨 변경 | set:Visible | Visible = {?true} | RESULT_RP_CELL | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 456 | 표시/라벨 변경 | set:Visible | Visible = {?true} | DEMAND_CELL | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 457 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PRODUCT_MOD_CELL | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 458 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PRODUCT_SETBACK_CELL | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 459 | 표시/라벨 변경 | set:Visible | Visible = {?true} | SEMI_PRODUCT_CELL | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 460 | 표시/라벨 변경 | set:Visible | Visible = {?true} | MATERIAL_CELL | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 461 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ETC_REASON_CELL | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 462 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PRODUCT_OVER_CELL | if(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 464 | 표시/라벨 변경 | set:Visible | Visible = {?true} | NOTE1 | if(cbNote.Checked) |
| SetReasonColumn |  | 465 | 표시/라벨 변경 | set:Visible | Visible = {?true} | NOTE2 | if(cbNote.Checked) |
| SetReasonColumn |  | 466 | 표시/라벨 변경 | set:Visible | Visible = {?true} | NOTE3 | if(cbNote.Checked) |
| SetReasonColumn |  | 472 | 표시/라벨 변경 | set:Visible | Visible = {?true} | MPP_OUT | else!(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 473 | 표시/라벨 변경 | set:Visible | Visible = {?true} | RESULT_RP | else!(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 474 | 표시/라벨 변경 | set:Visible | Visible = {?true} | GAP | else!(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 475 | 표시/라벨 변경 | set:Visible | Visible = {?true} | GAP_ACC | else!(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 477 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MPP_OUT_CELL | else!(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 478 | 표시/라벨 변경 | set:Visible | Visible = {?false} | RESULT_RP_CELL | else!(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 479 | 표시/라벨 변경 | set:Visible | Visible = {?false} | GAP_CELL | else!(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 480 | 표시/라벨 변경 | set:Visible | Visible = {?false} | GAP_ACC_CELL | else!(cbNote.Checked) ⟫ if(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 484 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MPP_OUT | else!(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 485 | 표시/라벨 변경 | set:Visible | Visible = {?false} | RESULT_RP | else!(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 486 | 표시/라벨 변경 | set:Visible | Visible = {?false} | GAP | else!(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 487 | 표시/라벨 변경 | set:Visible | Visible = {?false} | GAP_ACC | else!(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 489 | 표시/라벨 변경 | set:Visible | Visible = {?true} | MPP_OUT_CELL | else!(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 490 | 표시/라벨 변경 | set:Visible | Visible = {?true} | RESULT_RP_CELL | else!(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 491 | 표시/라벨 변경 | set:Visible | Visible = {?true} | GAP_CELL | else!(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 492 | 표시/라벨 변경 | set:Visible | Visible = {?true} | GAP_ACC_CELL | else!(cbNote.Checked) ⟫ else!(RdoUOMCheck.Checked) |
| SetReasonColumn |  | 494 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DEMAND | else!(cbNote.Checked) |
| SetReasonColumn |  | 495 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PRODUCT_MOD | else!(cbNote.Checked) |
| SetReasonColumn |  | 496 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PRODUCT_SETBACK | else!(cbNote.Checked) |
| SetReasonColumn |  | 497 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SEMI_PRODUCT | else!(cbNote.Checked) |
| SetReasonColumn |  | 498 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MATERIAL | else!(cbNote.Checked) |
| SetReasonColumn |  | 499 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ETC_REASON | else!(cbNote.Checked) |
| SetReasonColumn |  | 500 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PRODUCT_OVER | else!(cbNote.Checked) |
| SetReasonColumn |  | 502 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DEMAND_CELL | else!(cbNote.Checked) |
| SetReasonColumn |  | 503 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PRODUCT_MOD_CELL | else!(cbNote.Checked) |
| SetReasonColumn |  | 504 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PRODUCT_SETBACK_CELL | else!(cbNote.Checked) |
| SetReasonColumn |  | 505 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SEMI_PRODUCT_CELL | else!(cbNote.Checked) |
| SetReasonColumn |  | 506 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MATERIAL_CELL | else!(cbNote.Checked) |
| SetReasonColumn |  | 507 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ETC_REASON_CELL | else!(cbNote.Checked) |
| SetReasonColumn |  | 508 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PRODUCT_OVER_CELL | else!(cbNote.Checked) |
| SetReasonColumn |  | 510 | 표시/라벨 변경 | set:Visible | Visible = {?false} | NOTE1 | else!(cbNote.Checked) |
| SetReasonColumn |  | 511 | 표시/라벨 변경 | set:Visible | Visible = {?false} | NOTE2 | else!(cbNote.Checked) |
| SetReasonColumn |  | 512 | 표시/라벨 변경 | set:Visible | Visible = {?false} | NOTE3 | else!(cbNote.Checked) |
| InitializeComponent |  | 1173 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1174 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1175 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1176 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| MPP vs Result Mgmt. | META+코드연결 | 21 (?25) | 21 (?25) | 21 (?25) | 21 (?25) | 21 (?25) | 21 (?25) | 21 (?25) | 21 (?25) | 21 (?25) | 21 (?25) | 21 (?25) | 21 (?25) | 21 (?25) | 21 (?25) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:화면컨트롤값 1120 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 1120건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
