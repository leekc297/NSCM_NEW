# SCP0020 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.csproj | 2909 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.csproj | 672 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > Find_Data > Find_Packer | 980 | SCP.SCP0020_GET_TACT_TIME_OSP | MATCH | SP SCP0020_GET_TACT_TIME_OSP |
| button:FindButton | FindButton > Find_Data > FindData_Main | 1041 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Data > FindData_Main | 1067 | SCP.SCP0020_GET_TACT_TIME | MATCH | SP SCP0020_GET_TACT_TIME |
| button:SaveButton | SaveButton > SaveData_Packer > Find_Packer | 980 | SCP.SCP0020_GET_TACT_TIME_OSP | MATCH | SP SCP0020_GET_TACT_TIME_OSP |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 1041 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 1067 | SCP.SCP0020_GET_TACT_TIME | MATCH | SP SCP0020_GET_TACT_TIME |
| button:SaveButton | SaveButton > SaveData_Except_Packer > FindData_Except_Packer | 1321 | SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP | MATCH | SP SCP0020_GET_TACT_TIME_EXCEPT_OSP |
| button:SaveButton | SaveButton > SaveData_Except > FindData_Except | 1397 | SCP.SCP0020_GET_TACT_TIME_EXCEPT | MATCH | SP SCP0020_GET_TACT_TIME_EXCEPT |
| button:SaveButton | SaveButton > SaveData_Packer | 1560 | SCP.SCP0020_SAVE_TACT_TIME_OSP | MATCH | SP SCP0020_SAVE_TACT_TIME_OSP |
| button:SaveButton | SaveButton > SaveData_Main | 1797 | SCP.SCP0020_SAVE_TACT_TIME | MATCH | SP SCP0020_SAVE_TACT_TIME |
| button:SaveButton | SaveButton > SaveData_Except_Packer | 2023 | SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP | MATCH | SP SCP0020_SAVE_TACT_TIME_EXCEPT_OSP |
| button:SaveButton | SaveButton > SaveData_Except | 2227 | SCP.SCP0020_SAVE_TACT_TIME_EXCEPT | MATCH | SP SCP0020_SAVE_TACT_TIME_EXCEPT |
| event:spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Except_Packer | 1321 | SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP | MATCH | SP SCP0020_GET_TACT_TIME_EXCEPT_OSP |
| event:spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Except | 1397 | SCP.SCP0020_GET_TACT_TIME_EXCEPT | MATCH | SP SCP0020_GET_TACT_TIME_EXCEPT |
| event:this.Load | Form_Load > DefineProperty | 199 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 218 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 220 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtValidYN> | 57 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 58 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_LINE_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 3 |  |  |  |
| SCP.SCP0020_GET_TACT_TIME | MATCH | 1 | SP SCP0020_GET_TACT_TIME | EXEC:SCP0020_GET_TACT_TIME, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP1, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP1, SELECT:DM_PLN_MKT_FCST, SELECT:SCM_MST_SITE, SELECT:SCM_MST_MODEL_FINAL_ITEM_BOM_V, REF:FN_NEXT_DAY, REF:STRING_SPLIT, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP1, SELECT:SCP_MST_FINAL_ITEM, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_ITEM_OPERATION_GROUP, SELECT:SCP_MST_TACT_TIME_EXCEPT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_LINE_SN, SELECT:SCP_MST_TACT_TIME, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_PLANT_SN, REF:FN_SCM_SPLIT, SELECT:SCP_MST_LOSS_TIME, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:SCP_MST_TACT_TIME_BIG |  |
| SCP.SCP0020_GET_TACT_TIME_EXCEPT | MATCH | 1 | SP SCP0020_GET_TACT_TIME_EXCEPT | EXEC:SCP0020_GET_TACT_TIME_EXCEPT, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_ITEM_NICKNAME, SELECT:SCP_MST_TACT_TIME, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_MST_TACT_TIME_EXCEPT, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN |  |
| SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP | MATCH | 1 | SP SCP0020_GET_TACT_TIME_EXCEPT_OSP | EXEC:SCP0020_GET_TACT_TIME_EXCEPT_OSP, REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:SCM_MST_ITEM_SN, SELECT:SCP_MST_TACT_TIME_OSP, SELECT:SCP_MST_TACT_TIME_EXCEPT_OSP, SELECT:SCM_MST_SITE |  |
| SCP.SCP0020_GET_TACT_TIME_OSP | MATCH | 1 | SP SCP0020_GET_TACT_TIME_OSP | EXEC:SCP0020_GET_TACT_TIME_OSP, REF:FN_NEXT_DAY, SELECT:SCM_MST_PLAN, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP1, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP1, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL, SELECT:DM_PLN_MKT_FCST, SELECT:SCM_MST_SITE, SELECT:SCM_MST_BOM_SN_V, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_FINAL_ITEM_V, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP1, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:SCP_MST_FINAL_ITEM, REF:STRING_SPLIT, REF:FN_GET_ITEM_OPERATION_GROUP, SELECT:SCP_MST_TACT_TIME_EXCEPT_OSP, SELECT:SCP_MST_TACT_TIME_OSP, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_PLANT_SN, REF:FN_SCM_SPLIT, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP |  |
| SCP.SCP0020_SAVE_TACT_TIME | MATCH | 1 | SP SCP0020_SAVE_TACT_TIME | EXEC:SCP0020_SAVE_TACT_TIME, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_SCP_MST_TACT_TIME_HIST, SELECT:SCP_MST_TACT_TIME, UPDATE:SCP_MST_TACT_TIME, INSERT:SCP_MST_TACT_TIME, INSERT:SCP_MST_TACT_TIME_EXCEPT_H, SELECT:SCP_MST_TACT_TIME_EXCEPT, DELETE:SCP_MST_TACT_TIME_EXCEPT, DELETE:SCP_MST_TACT_TIME, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_MST_TACT_TIME_H |  |
| SCP.SCP0020_SAVE_TACT_TIME_EXCEPT | MATCH | 1 | SP SCP0020_SAVE_TACT_TIME_EXCEPT | EXEC:SCP0020_SAVE_TACT_TIME_EXCEPT, CREATE:#TBLDYNAMIC_SCP0020, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:#TBLDYNAMIC_SCP0020, DELETE:A, SELECT:SCP_MST_TACT_TIME_EXCEPT, SELECT:#TBLDYNAMIC_SCP0020, UPDATE:A, INSERT:SCP_MST_TACT_TIME_EXCEPT, INSERT:SCP_MST_TACT_TIME_EXCEPT_H, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP | MATCH | 1 | SP SCP0020_SAVE_TACT_TIME_EXCEPT_OSP | EXEC:SCP0020_SAVE_TACT_TIME_EXCEPT_OSP, CREATE:#TBLDYNAMIC_SCP0020, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:#TBLDYNAMIC_SCP0020, DELETE:A, SELECT:SCP_MST_TACT_TIME_EXCEPT_OSP, SELECT:#TBLDYNAMIC_SCP0020, UPDATE:A, INSERT:SCP_MST_TACT_TIME_EXCEPT_OSP, INSERT:SCP_MST_TACT_TIME_EXCEPT_OSP_H, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0020_SAVE_TACT_TIME_OSP | MATCH | 1 | SP SCP0020_SAVE_TACT_TIME_OSP | EXEC:SCP0020_SAVE_TACT_TIME_OSP, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP, CREATE:#TBLDYNAMICPIVOT_SCP0020_SAVE_TMP, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:SCP_MST_TACT_TIME_OSP, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:#TBLDYNAMICPIVOT_SCP0020_SAVE_TMP, DELETE:A, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:#TBLDYNAMICPIVOT_SCP0020_SAVE_TMP, INSERT:SCP_MST_TACT_TIME_EXCEPT_OSP_H, SELECT:SCP_MST_TACT_TIME_EXCEPT_OSP, INSERT:SCP_MST_TACT_TIME_OSP_H, INSERT:SCP_MST_TACT_TIME_OSP, UPDATE:A, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| EditButton | drRow | CODE, NAME |
| EditButton | dr | CODE, NAME |
| InsertButton | drRow | CODE, NAME |
| InsertButton | dr | CODE, NAME |
| SaveData_Except | dtErr.Rows[0] | ERR_MESSAGE |
| SaveData_Except_Packer | dtErr.Rows[0] | ERR_MESSAGE |
| SaveData_Main | dtErr.Rows[0] | ERR_MESSAGE |
| SaveData_Packer | dtErr.Rows[0] | ERR_MESSAGE |
| SetChangedControl_Osp | drRow | CODE, NAME |
| SetChangedControl_Osp | dr | CODE, NAME |
| SpdMain_ClipboardPasted | drRow | CODE, NAME |
| SpdMain_ClipboardPasted | dr | CODE, NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | DefineProperty:198, RefreshPlantSiteByDivision:292, RefreshLineByOperation:301, RefreshLineByOperation:302, RefreshLineByOperationOfSpd:315, RefreshLineByOperationOfSpd:316, RefreshLineByPlantPacker:327, RefreshLineByPlantPacker:328 | CString.GetCheckedListValue | CODE |
| DataBind | InitControls:218 | UsrComboBox.DataBind | CODE, NAME |
| SetSheetHeaderColumn | InitSpread:406, SetSpreadInit:438, SetSpreadInit:449 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:271 |
| this.spdMain | EditModeOff | SpdMain_EditModeOff | InitializeComponent:505 |
| this.spdMain | EditChange | SpdMain_EditChange | InitializeComponent:506 |
| this.spdExcept | EditModeOff | spdExcept_EditModeOff | InitializeComponent:558 |
| this.spdExcept | EditChange | spdExcept_EditChange | InitializeComponent:559 |
| this | Load | Form_Load | .ctor:179 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:460 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:461 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:463 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:464 |
| spdMain | CellClick | SpdMain_CellClick | InitEvent:465 |
| spdExcept | TopChange | SpdExcept_TopChange | InitEvent:467 |
| dsdmMain | Changed | SpdMain_Changed | InitEvent:471 |
| dsdmMainPacker | Changed | SpdMain_Changed_Packer | InitEvent:474 |
| spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:476 |
| this.spdMain | ActiveSheetChanged | SpdMain_ActiveSheetChanged | InitEvent:479 |
| dsdmExcept | Changed | SpdExcept_Changed | InitEvent:482 |

## 6. 컨트롤 (26개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | layoutControlItem2, layoutControlItem1, layoutControlItem6, layoutControlItem3, layoutControlItem4, layoutControlItem9, layoutControlItem5 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCombo | 2 | cboOperationGroup, cboDivision |
| UsrCheckedList | 2 | clbLine, clbPlantSite |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem3 |
| FpSpread | 2 | spdMain, spdExcept |
| SheetView | 2 | spdMain_Sheet1, spdExcept_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrMultiLineEditor | 1 | txtItemId |
| UsrButton | 1 | btnItemId |
| UsrComboBox | 1 | cboValid |
| SplitContainer | 1 | splitContainer2 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 49 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 14 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 111 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 21 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 255 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0020 | Packer | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |
| SCM_MST_SHEET_COLUMNS | SCP0020 | Plant | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |
| SCM_MST_SHEET_COLUMNS | SCP0020 | Tact Time | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |
| SCM_MST_SHEET_COLUMNS | SCP0020 | Tact Time Except | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Plant, Packer, Tact Time Except
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:406, SetSheetHeaderColumn@SetSpreadInit:438, SetSheetHeaderColumn@SetSpreadInit:449

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 410 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DAILY_CAPACITY | if(spreadInfo.SheetName == "Tact Time Except") ⟫ if(siMain.ActiveSheet.SheetName == "Plant") |
| InitSpread |  | 411 | 표시/라벨 변경 | set:Visible | Visible = {?true} | OPERATION_NAME | if(spreadInfo.SheetName == "Tact Time Except") ⟫ if(siMain.ActiveSheet.SheetName == "Plant") |
| InitSpread |  | 415 | 표시/라벨 변경 | set:Visible | Visible = {?true} | DAILY_CAPACITY | if(spreadInfo.SheetName == "Tact Time Except") ⟫ else!(siMain.ActiveSheet.SheetName == "Plant") |
| InitSpread |  | 416 | 표시/라벨 변경 | set:Visible | Visible = {?false} | OPERATION_NAME | if(spreadInfo.SheetName == "Tact Time Except") ⟫ else!(siMain.ActiveSheet.SheetName == "Plant") |
| InitializeComponent |  | 522 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 523 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 524 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 525 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 575 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 576 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 577 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 578 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Packer | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |
| Plant | META+코드연결 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 |
| Tact Time | 메타 정의만, 코드 미참조(미사용 가능) | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 |
| Tact Time Except | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.


### FILE endpoints.csv (14 rows)
```csv
"variant","file","class","member","line","site_kind","kind","candidate","key","status","sp_or_sql","objects","via","detail"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","<field:dtValidYN>","57","derived","biz","CommonData.YesOrNo","biz:CommonData.YesOrNo","BIZ_MATCH","","","Data.Common[case Type.YesOrNo:Type.YesOrNo] > Data.CallBizData",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","<field:dtYesOrNo>","58","derived","biz","CommonData.YesOrNo","biz:CommonData.YesOrNo","BIZ_MATCH","","","Data.Common[case Type.YesOrNo:Type.YesOrNo] > Data.CallBizData",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","DefineProperty","199","derived","biz","CommonData.CommonDataList [code=LineByOperation]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.LineByOperation:Type.LineByOperation] > Data.CallBizCommonData",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitControls","218","derived","biz","CommonData.YesOrNo","biz:CommonData.YesOrNo","BIZ_MATCH","","","UsrComboBox.DataBind[case Type.YesOrNo:Type.YesOrNo] > Data.Common[case param:Type.YesOrNo] > Data.CallBizData",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitControls","220","derived","biz","CommonData.CommonDataList [code=LookupCommon]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.LookupCommon:Type.LookupCommon] > Data.CallBizCommonData",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","Find_Packer","980","ctor","fox","SCP.SCP0020_GET_TACT_TIME_OSP","SCP.SCP0020_GET_TACT_TIME_OSP","MATCH","SP SCP0020_GET_TACT_TIME_OSP","EXEC:SCP0020_GET_TACT_TIME_OSP, REF:FN_NEXT_DAY, SELECT:SCM_MST_PLAN, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP1, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP1, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL, SELECT:DM_PLN_MKT_FCST, SELECT:SCM_MST_SITE, SELECT:SCM_MST_BOM_SN_V, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_FINAL_ITEM_V, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP1, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:SCP_MST_FINAL_ITEM, REF:STRING_SPLIT, REF:FN_GET_ITEM_OPERATION_GROUP, SELECT:SCP_MST_TACT_TIME_EXCEPT_OSP, SELECT:SCP_MST_TACT_TIME_OSP, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_PLANT_SN, REF:FN_SCM_SPLIT, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","FindData_Main","1041","derived","biz","CommonData.CommonDataList [code=LineByOperation]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.LineByOperation:Type.LineByOperation] > Data.CallBizCommonData",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","FindData_Main","1067","ctor","fox","SCP.SCP0020_GET_TACT_TIME","SCP.SCP0020_GET_TACT_TIME","MATCH","SP SCP0020_GET_TACT_TIME","EXEC:SCP0020_GET_TACT_TIME, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP1, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP1, SELECT:DM_PLN_MKT_FCST, SELECT:SCM_MST_SITE, SELECT:SCM_MST_MODEL_FINAL_ITEM_BOM_V, REF:FN_NEXT_DAY, REF:STRING_SPLIT, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP1, SELECT:SCP_MST_FINAL_ITEM, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_ITEM_OPERATION_GROUP, SELECT:SCP_MST_TACT_TIME_EXCEPT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_LINE_SN, SELECT:SCP_MST_TACT_TIME, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_PLANT_SN, REF:FN_SCM_SPLIT, SELECT:SCP_MST_LOSS_TIME, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:SCP_MST_TACT_TIME_BIG","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","FindData_Except_Packer","1321","ctor","fox","SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP","SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP","MATCH","SP SCP0020_GET_TACT_TIME_EXCEPT_OSP","EXEC:SCP0020_GET_TACT_TIME_EXCEPT_OSP, REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:SCM_MST_ITEM_SN, SELECT:SCP_MST_TACT_TIME_OSP, SELECT:SCP_MST_TACT_TIME_EXCEPT_OSP, SELECT:SCM_MST_SITE","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","FindData_Except","1397","ctor","fox","SCP.SCP0020_GET_TACT_TIME_EXCEPT","SCP.SCP0020_GET_TACT_TIME_EXCEPT","MATCH","SP SCP0020_GET_TACT_TIME_EXCEPT","EXEC:SCP0020_GET_TACT_TIME_EXCEPT, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_ITEM_NICKNAME, SELECT:SCP_MST_TACT_TIME, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_MST_TACT_TIME_EXCEPT, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SaveData_Packer","1560","ctor","fox","SCP.SCP0020_SAVE_TACT_TIME_OSP","SCP.SCP0020_SAVE_TACT_TIME_OSP","MATCH","SP SCP0020_SAVE_TACT_TIME_OSP","EXEC:SCP0020_SAVE_TACT_TIME_OSP, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP, CREATE:#TBLDYNAMICPIVOT_SCP0020_SAVE_TMP, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:SCP_MST_TACT_TIME_OSP, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:#TBLDYNAMICPIVOT_SCP0020_SAVE_TMP, DELETE:A, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:#TBLDYNAMICPIVOT_SCP0020_SAVE_TMP, INSERT:SCP_MST_TACT_TIME_EXCEPT_OSP_H, SELECT:SCP_MST_TACT_TIME_EXCEPT_OSP, INSERT:SCP_MST_TACT_TIME_OSP_H, INSERT:SCP_MST_TACT_TIME_OSP, UPDATE:A, INSERT:SCM_SYS_LOG_BATCH","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SaveData_Main","1797","ctor","fox","SCP.SCP0020_SAVE_TACT_TIME","SCP.SCP0020_SAVE_TACT_TIME","MATCH","SP SCP0020_SAVE_TACT_TIME","EXEC:SCP0020_SAVE_TACT_TIME, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_SCP_MST_TACT_TIME_HIST, SELECT:SCP_MST_TACT_TIME, UPDATE:SCP_MST_TACT_TIME, INSERT:SCP_MST_TACT_TIME, INSERT:SCP_MST_TACT_TIME_EXCEPT_H, SELECT:SCP_MST_TACT_TIME_EXCEPT, DELETE:SCP_MST_TACT_TIME_EXCEPT, DELETE:SCP_MST_TACT_TIME, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_MST_TACT_TIME_H","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SaveData_Except_Packer","2023","ctor","fox","SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP","SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP","MATCH","SP SCP0020_SAVE_TACT_TIME_EXCEPT_OSP","EXEC:SCP0020_SAVE_TACT_TIME_EXCEPT_OSP, CREATE:#TBLDYNAMIC_SCP0020, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:#TBLDYNAMIC_SCP0020, DELETE:A, SELECT:SCP_MST_TACT_TIME_EXCEPT_OSP, SELECT:#TBLDYNAMIC_SCP0020, UPDATE:A, INSERT:SCP_MST_TACT_TIME_EXCEPT_OSP, INSERT:SCP_MST_TACT_TIME_EXCEPT_OSP_H, INSERT:SCM_SYS_LOG_BATCH","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SaveData_Except","2227","ctor","fox","SCP.SCP0020_SAVE_TACT_TIME_EXCEPT","SCP.SCP0020_SAVE_TACT_TIME_EXCEPT","MATCH","SP SCP0020_SAVE_TACT_TIME_EXCEPT","EXEC:SCP0020_SAVE_TACT_TIME_EXCEPT, CREATE:#TBLDYNAMIC_SCP0020, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:#TBLDYNAMIC_SCP0020, DELETE:A, SELECT:SCP_MST_TACT_TIME_EXCEPT, SELECT:#TBLDYNAMIC_SCP0020, UPDATE:A, INSERT:SCP_MST_TACT_TIME_EXCEPT, INSERT:SCP_MST_TACT_TIME_EXCEPT_H, INSERT:SCM_SYS_LOG_BATCH","",""
```

### FILE flow.csv (19 rows)
```csv
"variant","file","class","entry_kind","entry","path","member","line","endpoint","status","sp_or_sql","objects"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","event","this.Load","Form_Load > InitControls","InitControls","220","biz:CommonData.CommonDataList [code=LookupCommon]","BIZ_MATCH","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","event","this.Load","Form_Load > InitControls","InitControls","218","biz:CommonData.YesOrNo","BIZ_MATCH","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","event","this.Load","Form_Load > DefineProperty","DefineProperty","199","biz:CommonData.CommonDataList [code=LineByOperation]","BIZ_MATCH","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","event","spdMain.CellDoubleClick","SpdMain_CellDoubleClick > FindData_Except_Packer","FindData_Except_Packer","1321","SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP","MATCH","SP SCP0020_GET_TACT_TIME_EXCEPT_OSP","EXEC:SCP0020_GET_TACT_TIME_EXCEPT_OSP, REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:SCM_MST_ITEM_SN, SELECT:SCP_MST_TACT_TIME_OSP, SELECT:SCP_MST_TACT_TIME_EXCEPT_OSP, SELECT:SCM_MST_SITE"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","event","spdMain.CellDoubleClick","SpdMain_CellDoubleClick > FindData_Except","FindData_Except","1397","SCP.SCP0020_GET_TACT_TIME_EXCEPT","MATCH","SP SCP0020_GET_TACT_TIME_EXCEPT","EXEC:SCP0020_GET_TACT_TIME_EXCEPT, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_ITEM_NICKNAME, SELECT:SCP_MST_TACT_TIME, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_MST_TACT_TIME_EXCEPT, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","button","FindButton","FindButton > Find_Data > Find_Packer","Find_Packer","980","SCP.SCP0020_GET_TACT_TIME_OSP","MATCH","SP SCP0020_GET_TACT_TIME_OSP","EXEC:SCP0020_GET_TACT_TIME_OSP, REF:FN_NEXT_DAY, SELECT:SCM_MST_PLAN, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP1, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP1, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL, SELECT:DM_PLN_MKT_FCST, SELECT:SCM_MST_SITE, SELECT:SCM_MST_BOM_SN_V, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_FINAL_ITEM_V, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP1, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:SCP_MST_FINAL_ITEM, REF:STRING_SPLIT, REF:FN_GET_ITEM_OPERATION_GROUP, SELECT:SCP_MST_TACT_TIME_EXCEPT_OSP, SELECT:SCP_MST_TACT_TIME_OSP, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_PLANT_SN, REF:FN_SCM_SPLIT, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","button","FindButton","FindButton > Find_Data > FindData_Main","FindData_Main","1067","SCP.SCP0020_GET_TACT_TIME","MATCH","SP SCP0020_GET_TACT_TIME","EXEC:SCP0020_GET_TACT_TIME, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP1, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP1, SELECT:DM_PLN_MKT_FCST, SELECT:SCM_MST_SITE, SELECT:SCM_MST_MODEL_FINAL_ITEM_BOM_V, REF:FN_NEXT_DAY, REF:STRING_SPLIT, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP1, SELECT:SCP_MST_FINAL_ITEM, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_ITEM_OPERATION_GROUP, SELECT:SCP_MST_TACT_TIME_EXCEPT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_LINE_SN, SELECT:SCP_MST_TACT_TIME, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_PLANT_SN, REF:FN_SCM_SPLIT, SELECT:SCP_MST_LOSS_TIME, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:SCP_MST_TACT_TIME_BIG"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","button","FindButton","FindButton > Find_Data > FindData_Main","FindData_Main","1041","biz:CommonData.CommonDataList [code=LineByOperation]","BIZ_MATCH","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","button","SaveButton","SaveButton > SaveData_Except_Packer","SaveData_Except_Packer","2023","SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP","MATCH","SP SCP0020_SAVE_TACT_TIME_EXCEPT_OSP","EXEC:SCP0020_SAVE_TACT_TIME_EXCEPT_OSP, CREATE:#TBLDYNAMIC_SCP0020, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:#TBLDYNAMIC_SCP0020, DELETE:A, SELECT:SCP_MST_TACT_TIME_EXCEPT_OSP, SELECT:#TBLDYNAMIC_SCP0020, UPDATE:A, INSERT:SCP_MST_TACT_TIME_EXCEPT_OSP, INSERT:SCP_MST_TACT_TIME_EXCEPT_OSP_H, INSERT:SCM_SYS_LOG_BATCH"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","button","SaveButton","SaveButton > SaveData_Except_Packer > FindData_Except_Packer","FindData_Except_Packer","1321","SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP","MATCH","SP SCP0020_GET_TACT_TIME_EXCEPT_OSP","EXEC:SCP0020_GET_TACT_TIME_EXCEPT_OSP, REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:SCM_MST_ITEM_SN, SELECT:SCP_MST_TACT_TIME_OSP, SELECT:SCP_MST_TACT_TIME_EXCEPT_OSP, SELECT:SCM_MST_SITE"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","button","SaveButton","SaveButton > SaveData_Except","SaveData_Except","2227","SCP.SCP0020_SAVE_TACT_TIME_EXCEPT","MATCH","SP SCP0020_SAVE_TACT_TIME_EXCEPT","EXEC:SCP0020_SAVE_TACT_TIME_EXCEPT, CREATE:#TBLDYNAMIC_SCP0020, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:#TBLDYNAMIC_SCP0020, DELETE:A, SELECT:SCP_MST_TACT_TIME_EXCEPT, SELECT:#TBLDYNAMIC_SCP0020, UPDATE:A, INSERT:SCP_MST_TACT_TIME_EXCEPT, INSERT:SCP_MST_TACT_TIME_EXCEPT_H, INSERT:SCM_SYS_LOG_BATCH"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","button","SaveButton","SaveButton > SaveData_Except > FindData_Except","FindData_Except","1397","SCP.SCP0020_GET_TACT_TIME_EXCEPT","MATCH","SP SCP0020_GET_TACT_TIME_EXCEPT","EXEC:SCP0020_GET_TACT_TIME_EXCEPT, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_ITEM_NICKNAME, SELECT:SCP_MST_TACT_TIME, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_MST_TACT_TIME_EXCEPT, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","button","SaveButton","SaveButton > SaveData_Packer","SaveData_Packer","1560","SCP.SCP0020_SAVE_TACT_TIME_OSP","MATCH","SP SCP0020_SAVE_TACT_TIME_OSP","EXEC:SCP0020_SAVE_TACT_TIME_OSP, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP, CREATE:#TBLDYNAMICPIVOT_SCP0020_SAVE_TMP, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:SCP_MST_TACT_TIME_OSP, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:#TBLDYNAMICPIVOT_SCP0020_SAVE_TMP, DELETE:A, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:#TBLDYNAMICPIVOT_SCP0020_SAVE_TMP, INSERT:SCP_MST_TACT_TIME_EXCEPT_OSP_H, SELECT:SCP_MST_TACT_TIME_EXCEPT_OSP, INSERT:SCP_MST_TACT_TIME_OSP_H, INSERT:SCP_MST_TACT_TIME_OSP, UPDATE:A, INSERT:SCM_SYS_LOG_BATCH"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","button","SaveButton","SaveButton > SaveData_Packer > Find_Packer","Find_Packer","980","SCP.SCP0020_GET_TACT_TIME_OSP","MATCH","SP SCP0020_GET_TACT_TIME_OSP","EXEC:SCP0020_GET_TACT_TIME_OSP, REF:FN_NEXT_DAY, SELECT:SCM_MST_PLAN, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP1, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP1, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL, SELECT:DM_PLN_MKT_FCST, SELECT:SCM_MST_SITE, SELECT:SCM_MST_BOM_SN_V, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_FINAL_ITEM_V, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP1, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:SCP_MST_FINAL_ITEM, REF:STRING_SPLIT, REF:FN_GET_ITEM_OPERATION_GROUP, SELECT:SCP_MST_TACT_TIME_EXCEPT_OSP, SELECT:SCP_MST_TACT_TIME_OSP, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_PLANT_SN, REF:FN_SCM_SPLIT, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","button","SaveButton","SaveButton > SaveData_Main","SaveData_Main","1797","SCP.SCP0020_SAVE_TACT_TIME","MATCH","SP SCP0020_SAVE_TACT_TIME","EXEC:SCP0020_SAVE_TACT_TIME, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_SCP_MST_TACT_TIME_HIST, SELECT:SCP_MST_TACT_TIME, UPDATE:SCP_MST_TACT_TIME, INSERT:SCP_MST_TACT_TIME, INSERT:SCP_MST_TACT_TIME_EXCEPT_H, SELECT:SCP_MST_TACT_TIME_EXCEPT, DELETE:SCP_MST_TACT_TIME_EXCEPT, DELETE:SCP_MST_TACT_TIME, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_MST_TACT_TIME_H"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","button","SaveButton","SaveButton > SaveData_Main > FindData_Main","FindData_Main","1067","SCP.SCP0020_GET_TACT_TIME","MATCH","SP SCP0020_GET_TACT_TIME","EXEC:SCP0020_GET_TACT_TIME, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP, CREATE:#TBLDYNAMICPIVOT_SCP0020_TMP1, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP1, SELECT:DM_PLN_MKT_FCST, SELECT:SCM_MST_SITE, SELECT:SCM_MST_MODEL_FINAL_ITEM_BOM_V, REF:FN_NEXT_DAY, REF:STRING_SPLIT, INSERT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP1, SELECT:SCP_MST_FINAL_ITEM, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_ITEM_OPERATION_GROUP, SELECT:SCP_MST_TACT_TIME_EXCEPT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_LINE_SN, SELECT:SCP_MST_TACT_TIME, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_PLANT_SN, REF:FN_SCM_SPLIT, SELECT:SCP_MST_LOSS_TIME, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:#TBLDYNAMICPIVOT_SCP0020_TMP, SELECT:SCP_MST_TACT_TIME_BIG"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","button","SaveButton","SaveButton > SaveData_Main > FindData_Main","FindData_Main","1041","biz:CommonData.CommonDataList [code=LineByOperation]","BIZ_MATCH","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","unreached","(진입점 미연결)","<field:dtValidYN>","<field:dtValidYN>","57","biz:CommonData.YesOrNo","BIZ_MATCH","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","unreached","(진입점 미연결)","<field:dtYesOrNo>","<field:dtYesOrNo>","58","biz:CommonData.YesOrNo","BIZ_MATCH","",""
```

### FILE events.csv (17 rows)
```csv
"variant","file","class","member","line","target","event","handler","op"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","271","this.btnItemId","Click","btnItemId_Click","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","505","this.spdMain","EditModeOff","SpdMain_EditModeOff","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","506","this.spdMain","EditChange","SpdMain_EditChange","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","558","this.spdExcept","EditModeOff","spdExcept_EditModeOff","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","559","this.spdExcept","EditChange","spdExcept_EditChange","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime",".ctor","179","this","Load","Form_Load","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitEvent","460","cboDivision","SelectedIndexChanged","ClbDivision_SelectedIndexChanged","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitEvent","461","clbPlantSite","SelectedIndexChanged","ClbPlantSite_SelectedIndexChanged","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitEvent","463","spdMain","CellDoubleClick","SpdMain_CellDoubleClick","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitEvent","464","spdMain","TopChange","SpdMain_TopChange","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitEvent","465","spdMain","CellClick","SpdMain_CellClick","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitEvent","467","spdExcept","TopChange","SpdExcept_TopChange","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitEvent","471","dsdmMain","Changed","SpdMain_Changed","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitEvent","474","dsdmMainPacker","Changed","SpdMain_Changed_Packer","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitEvent","476","spdMain","ClipboardPasted","SpdMain_ClipboardPasted","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitEvent","479","this.spdMain","ActiveSheetChanged","SpdMain_ActiveSheetChanged","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitEvent","482","dsdmExcept","Changed","SpdExcept_Changed","+="
```

### FILE controls.csv (26 rows)
```csv
"variant","file","class","name","type","parent","line"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","usrLayoutControl1","GSCM.Windows.Forms.Controls.UsrLayoutControl","","32"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","layoutControlGroup1","DevExpress.XtraLayout.LayoutControlGroup","","33"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","usrConditionPanel1","GSCM.Windows.Forms.Controls.UsrConditionPanel","this","34"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","usrLayoutControl2","GSCM.Windows.Forms.Controls.UsrLayoutControl","usrConditionPanel1","35"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","cboOperationGroup","GSCM.Windows.Forms.Controls.UsrCombo","usrLayoutControl2","36"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","cboDivision","GSCM.Windows.Forms.Controls.UsrCombo","usrLayoutControl2","37"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","txtItemId","GSCM.Windows.Forms.Controls.UsrMultiLineEditor","usrLayoutControl2","38"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","btnItemId","GSCM.Windows.Forms.Controls.UsrButton","usrLayoutControl2","39"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","cboValid","GSCM.Windows.Forms.Controls.UsrComboBox","usrLayoutControl2","40"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","clbLine","GSCM.Windows.Forms.Controls.UsrCheckedList","usrLayoutControl2","41"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","clbPlantSite","GSCM.Windows.Forms.Controls.UsrCheckedList","usrLayoutControl2","42"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","layoutControlGroup2","DevExpress.XtraLayout.LayoutControlGroup","","43"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","layoutControlItem2","DevExpress.XtraLayout.LayoutControlItem","","44"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","layoutControlItem1","DevExpress.XtraLayout.LayoutControlItem","","45"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","layoutControlItem6","DevExpress.XtraLayout.LayoutControlItem","","46"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","emptySpaceItem1","DevExpress.XtraLayout.EmptySpaceItem","","47"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","layoutControlItem3","DevExpress.XtraLayout.LayoutControlItem","","48"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","layoutControlItem4","DevExpress.XtraLayout.LayoutControlItem","","49"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","layoutControlItem9","DevExpress.XtraLayout.LayoutControlItem","","50"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","emptySpaceItem3","DevExpress.XtraLayout.EmptySpaceItem","","51"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","layoutControlItem5","DevExpress.XtraLayout.LayoutControlItem","","52"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","splitContainer2","System.Windows.Forms.SplitContainer","this","53"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","spdMain","FarPoint.Win.Spread.FpSpread","splitContainer2.Panel1","54"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","spdMain_Sheet1","FarPoint.Win.Spread.SheetView","","55"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","spdExcept","FarPoint.Win.Spread.FpSpread","splitContainer2.Panel2","56"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","spdExcept_Sheet1","FarPoint.Win.Spread.SheetView","","57"
```

### FILE props.csv (54 rows)
```csv
"variant","file","class","member","line","target","prop","value"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","88","usrLayoutControl1","Dock","System.Windows.Forms.DockStyle.Fill"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","92","usrLayoutControl1","Size","new System.Drawing.Size(657, 184)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","101","layoutControlGroup1","Size","new System.Drawing.Size(657, 184)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","106","usrConditionPanel1","Dock","System.Windows.Forms.DockStyle.Top"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","109","usrConditionPanel1","Size","new System.Drawing.Size(1093, 68)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","111","usrConditionPanel1","UsrPanelType","GSCM.Windows.Forms.Controls.UsrConditionPanel.PanelType.HidePanel"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","123","usrLayoutControl2","Dock","System.Windows.Forms.DockStyle.Fill"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","127","usrLayoutControl2","Size","new System.Drawing.Size(1093, 68)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","129","usrLayoutControl2","Text","""usrLayoutControl2"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","163","cboOperationGroup","Size","new System.Drawing.Size(152, 20)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","199","cboDivision","Size","new System.Drawing.Size(207, 20)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","233","txtItemId","Size","new System.Drawing.Size(253, 21)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","266","btnItemId","Size","new System.Drawing.Size(39, 24)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","280","cboValid","Size","new System.Drawing.Size(225, 20)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","315","clbLine","Size","new System.Drawing.Size(231, 21)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","354","clbPlantSite","Size","new System.Drawing.Size(276, 21)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","377","layoutControlGroup2","Size","new System.Drawing.Size(1093, 73)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","382","layoutControlItem2","Control","this.clbPlantSite"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","386","layoutControlItem2","Size","new System.Drawing.Size(337, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","388","layoutControlItem2","Text","""Plant Site"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","395","layoutControlItem1","Control","this.cboDivision"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","398","layoutControlItem1","Size","new System.Drawing.Size(262, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","399","layoutControlItem1","Text","""Division*"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","406","layoutControlItem6","Control","this.clbLine"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","409","layoutControlItem6","Size","new System.Drawing.Size(262, 28)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","410","layoutControlItem6","Text","""Line"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","420","emptySpaceItem1","Size","new System.Drawing.Size(215, 28)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","425","layoutControlItem3","Control","this.txtItemId"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","428","layoutControlItem3","Size","new System.Drawing.Size(294, 28)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","429","layoutControlItem3","Text","""Model"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","436","layoutControlItem4","Control","this.btnItemId"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","441","layoutControlItem4","Size","new System.Drawing.Size(43, 28)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","448","layoutControlItem9","Control","this.cboValid"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","451","layoutControlItem9","Size","new System.Drawing.Size(259, 28)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","452","layoutControlItem9","Text","""Valid"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","463","emptySpaceItem3","Size","new System.Drawing.Size(215, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","468","layoutControlItem5","Control","this.cboOperationGroup"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","471","layoutControlItem5","Size","new System.Drawing.Size(259, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","472","layoutControlItem5","Text","""Operation Group*"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","479","splitContainer2","Dock","System.Windows.Forms.DockStyle.Fill"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","482","splitContainer2","Orientation","System.Windows.Forms.Orientation.Horizontal"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","491","splitContainer2","Size","new System.Drawing.Size(1093, 506)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","492","splitContainer2","SplitterDistance","392"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","498","spdMain","Dock","System.Windows.Forms.DockStyle.Fill"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","503","spdMain","Size","new System.Drawing.Size(1093, 392)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","551","spdExcept","Dock","System.Windows.Forms.DockStyle.Fill"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","556","spdExcept","Size","new System.Drawing.Size(1093, 110)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","609","this","Text","""Tac Time"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitSpread","410","spreadInfo.ActiveSheet.Columns[spreadInfo.GetColumnIndex(""DAILY_CAPACITY"")]","Visible","false"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitSpread","411","spreadInfo.ActiveSheet.Columns[spreadInfo.GetColumnIndex(""OPERATION_NAME"")]","Visible","true"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitSpread","415","spreadInfo.ActiveSheet.Columns[spreadInfo.GetColumnIndex(""DAILY_CAPACITY"")]","Visible","true"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitSpread","416","spreadInfo.ActiveSheet.Columns[spreadInfo.GetColumnIndex(""OPERATION_NAME"")]","Visible","false"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SetSpreadInit","442","siMain.ActiveSheet","Visible","false"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","btnItemId_Click","2560","txtItemId","Text","sItemId"
```

### FILE grid_effective.csv (112 rows)
```csv
"sheet","sheet_rule","column","label","source","40","81","81_HD","81_HG","81_HM","81_ST","81_UC","82","EE","EE_HD","EE_HG","EE_HM","EE_ST","EE_UC"
"Packer","META+코드연결","OPERATION_NAME","","CODE_ONLY_CHANGE","","","","","","","","","","","","","",""
"Packer","META+코드연결","CREATED_BY","Created By","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Packer","META+코드연결","CREATION_DATE","Creation Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Packer","META+코드연결","DAILY_CAPACITY","Daily Capacity*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Packer","META+코드연결","DIVISION_ID","Division*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Packer","META+코드연결","EXCEPT_YN","EXCEPT_YN","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Packer","META+코드연결","INPUT_STATUS","INPUT_STATUS","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Packer","META+코드연결","ITEM_ID","Model*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Packer","META+코드연결","LAST_UPDATE_DATE","Last Update Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Packer","META+코드연결","LAST_UPDATED_BY","Last Updated By","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Packer","META+코드연결","LINE_ID","Line*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Packer","META+코드연결","NICK_NAME","Nick Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Packer","META+코드연결","OPERATION_ID","OPERATION_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Packer","META+코드연결","OSP_YN","OSP_YN","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Packer","META+코드연결","PLANT_SITE_ID","PLANT_SITE_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Packer","META+코드연결","PRIORITY","Priority*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Packer","META+코드연결","SITE_DESCRIPTION","Plant Site*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Packer","META+코드연결","TACT_TIME","Tact Time*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Packer","META+코드연결","YIELD","Yield(%)*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","ACTUAL_CAPACITY","Actual Capacity","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","ACTUAL_OUTPUT","Actual Output","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Plant","META+코드연결","BIG_LAST_UPDATE_DATE","Big Last Update Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","BIG_TACT_TIME","Big Tact Time","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","BOM_MIN_DUE_DATE","Due Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","CREATED_BY","Created By","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","CREATION_DATE","Creation Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","DAILY_CAPACITY","Daily Capacity","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","DIVISION_ID","Division","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","EFFECTIVE_DATA_COUNT","Effective Data Count","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Plant","META+코드연결","EXCEPT_YN","EXCEPT_YN","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Plant","META+코드연결","FROM_ACTUAL_CAPACITY","From Actual Capacity","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Plant","META+코드연결","INPUT_STATUS","INPUT_STATUS","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Plant","META+코드연결","ITEM_ID","Model","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","ITEM_UOM","Item UOM","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","JUMBO_MIN","Jumbo / Min","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","LANE_QTY","Slitting Lane","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","LAST_UPDATE_DATE","Last Update Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","LAST_UPDATED_BY","Last Updated By","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","LINE_ID","Line*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","MODEL_SITE","Model Site","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","NICK_NAME","Nick Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","OPERATION_GROUP_ID","OPERATION_GROUP_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Plant","META+코드연결","OPERATION_ID","OPERATION_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Plant","META+코드연결","OPERATION_NAME","Operation","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","PLANT_SITE_ID","PLANT_SITE_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Plant","META+코드연결","PLANT_SITE_NAME","Plant Site","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","PRIORITY","Priority*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","TACT_TIME","Tact Time*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","TO_ACTUAL_CAPACITY","To Actual Capacity","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Plant","META+코드연결","UOM_CONVERT_VALUE","UOM Convert","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Plant","META+코드연결","VALID_YN","Valid*","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Plant","META+코드연결","YIELD","Yield(%)*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","ACTUAL_CAPACITY","Actual Capacity","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","ACTUAL_OUTPUT","Actual Output","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","BIG_LAST_UPDATE_DATE","Big Last Update Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","BIG_TACT_TIME","Big Tact Time","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","BOM_MIN_DUE_DATE","Due Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","CREATED_BY","Created By","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","CREATION_DATE","Creation Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","DAILY_CAPACITY","Daily Capacity","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","DIVISION_ID","Division","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","EFFECTIVE_DATA_COUNT","Effective Data Count","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","EXCEPT_YN","EXCEPT_YN","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","FROM_ACTUAL_CAPACITY","From Actual Capacity","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","INPUT_STATUS","INPUT_STATUS","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","ITEM_ID","Model","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","ITEM_UOM","Item UOM","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","JUMBO_MIN","Jumbo / Min","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","LANE_QTY","Slitting Lane","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","LAST_UPDATE_DATE","Last Update Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","LAST_UPDATED_BY","Last Updated By","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","LINE_ID","Line*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","MODEL_SITE","Model Site","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","NICK_NAME","Nick Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","OPERATION_GROUP_ID","OPERATION_GROUP_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","OPERATION_ID","OPERATION_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","OPERATION_NAME","Operation","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","PLANT_SITE_ID","PLANT_SITE_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","PLANT_SITE_NAME","Plant Site","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","PRIORITY","Priority*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","TACT_TIME","Tact Time*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","TO_ACTUAL_CAPACITY","To Actual Capacity","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","UOM_CONVERT_VALUE","UOM Convert","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","VALID_YN","Valid*","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time","메타 정의만, 코드 미참조(미사용 가능)","YIELD","Yield(%)*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time Except","META+코드연결","CREATED_BY","Created By","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time Except","META+코드연결","CREATION_DATE","Creation Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time Except","META+코드연결","DAILY_CAPACITY","Daily Capacity","META","기본 →표시","기본 →표시","기본 →표시","기본 →표시","기본 →표시","기본 →표시","기본 →표시","기본 →표시","기본 →표시","기본 →표시","기본 →표시","기본 →표시","기본 →표시","기본 →표시"
"Tact Time Except","META+코드연결","DIVISION_ID","Division","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time Except","META+코드연결","EXCEPT_COMMENT","Comment","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time Except","META+코드연결","INPUT_STATUS","INPUT_STATUS","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time Except","META+코드연결","ITEM_ID","Model","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time Except","META+코드연결","LAST_UPDATE_DATE","Last Update Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time Except","META+코드연결","LAST_UPDATED_BY","Last Updated By","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time Except","META+코드연결","LINE_ID","Line","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time Except","META+코드연결","NICK_NAME","Nick Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time Except","META+코드연결","OPERATION_ID","OPERATION_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time Except","META+코드연결","OPERATION_NAME","Operation","META","기본 →숨김","기본 →숨김","기본 →숨김","기본 →숨김","기본 →숨김","기본 →숨김","기본 →숨김","기본 →숨김","기본 →숨김","기본 →숨김","기본 →숨김","기본 →숨김","기본 →숨김","기본 →숨김"
"Tact Time Except","META+코드연결","ORG_DIVISION_ID","ORG_DIVISION_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time Except","META+코드연결","ORG_ITEM_ID","ORG_ITEM_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time Except","META+코드연결","ORG_LINE_ID","ORG_LINE_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time Except","META+코드연결","ORG_OPERATION_ID","ORG_OPERATION_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time Except","META+코드연결","ORG_PLANT_SITE_ID","ORG_PLANT_SITE_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time Except","META+코드연결","ORG_TACT_TIME_END_DATE","ORG_TACT_TIME_END_DATE","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time Except","META+코드연결","ORG_TACT_TIME_START_DATE","ORG_TACT_TIME_START_DATE","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time Except","META+코드연결","PLANT_SITE_ID","PLANT_SITE_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Tact Time Except","META+코드연결","PLANT_SITE_NAME","Plant Site","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time Except","META+코드연결","TACT_TIME","Tact Time*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time Except","META+코드연결","TACT_TIME_END_DATE","End Date*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time Except","META+코드연결","TACT_TIME_START_DATE","Start Date*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time Except","META+코드연결","USE_YN","Product YN","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Tact Time Except","META+코드연결","YIELD","Yield(%)*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
```

### FILE grid_code.csv (43 rows)
```csv
"variant","file","class","member","line","sheet_hint","kind","api","source","header","field","columns","args","arg_names","conditions","raw"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","CreateSpread","374","Plant","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ Plant ¦ Plant ¦ 1 ¦ 1 ¦ 30","","","spdMain ¦ SpdSheet.shtMain ¦ SpdSheet.shtMain ¦ 1 ¦ 1 ¦ 30"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","CreateSpread","375","Plant","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ {?spdMain.ActiveSheetIndex}","","","spdMain.Name ¦ spdMain.ActiveSheetIndex"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","CreateSpread","377","Packer","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ Packer ¦ Packer ¦ 1 ¦ 1 ¦ 30","","","spdMain ¦ SpdSheet.shtPacker ¦ SpdSheet.shtPacker ¦ 1 ¦ 1 ¦ 30"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","CreateSpread","378","Packer","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ {?spdMain.ActiveSheetIndex}","","","spdMain.Name ¦ spdMain.ActiveSheetIndex"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","CreateSpread","380","Packer","SHEET","ChangeSheet","EXPR","","","","","","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","CreateSpread","384","Tact Time Except","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ Tact Time Except ¦ Tact Time Except ¦ 1 ¦ 1 ¦ 30","","","spdExcept ¦ SpdSheet.shtExcept ¦ SpdSheet.shtExcept ¦ 1 ¦ 1 ¦ 30"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","CreateSpread","385","Tact Time Except","SHEET","GetSheetInfo","EXPR","","","","{?spdExcept.Name} ¦ {?spdExcept.ActiveSheetIndex}","","","spdExcept.Name ¦ spdExcept.ActiveSheetIndex"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","CreateSpread","386","Tact Time Except","SHEET","ChangeSheet","EXPR","","","","","","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitSpread","395","","SHEET","InitSheet","EXPR","","","","{?spreadInfo.SheetName}","","if(spreadInfo.SheetName == ""Tact Time Except"")","spreadInfo.SheetName"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitSpread","406","","META_BUILD","SetSheetHeaderColumn","EXPR","","","","{p:spreadInfo} ¦ 1","siObj,iColumnHeaderRowCount","if(spreadInfo.SheetName == ""Tact Time Except"")","spreadInfo ¦ 1"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitSpread","410","","OVERRIDE","set:Visible","EXPR","","","DAILY_CAPACITY","{?false}","Visible","if(spreadInfo.SheetName == ""Tact Time Except"") ⟫ if(siMain.ActiveSheet.SheetName == ""Plant"")","false"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitSpread","411","","OVERRIDE","set:Visible","EXPR","","","OPERATION_NAME","{?true}","Visible","if(spreadInfo.SheetName == ""Tact Time Except"") ⟫ if(siMain.ActiveSheet.SheetName == ""Plant"")","true"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitSpread","415","","OVERRIDE","set:Visible","EXPR","","","DAILY_CAPACITY","{?true}","Visible","if(spreadInfo.SheetName == ""Tact Time Except"") ⟫ else!(siMain.ActiveSheet.SheetName == ""Plant"")","true"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitSpread","416","","OVERRIDE","set:Visible","EXPR","","","OPERATION_NAME","{?false}","Visible","if(spreadInfo.SheetName == ""Tact Time Except"") ⟫ else!(siMain.ActiveSheet.SheetName == ""Plant"")","false"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitSpread","425","1","SHEET","ChangeSheet","EXPR","","","","1","","else!(spreadInfo.SheetName == ""Tact Time Except"")","1"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InitSpread","426","Packer","SHEET","ChangeActiveSheet","HARDCODED","","","","Packer","sSheetName","else!(spreadInfo.SheetName == ""Tact Time Except"")","SpdSheet.shtPacker"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SetSpreadInit","435","0","SHEET","ChangeSheet","EXPR","","","","0","","if(sheetName.Equals(""Plant""))","0"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SetSpreadInit","436","0","SHEET","InitSheet","EXPR","","","","0","","if(sheetName.Equals(""Plant""))","0"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SetSpreadInit","438","0","META_BUILD","SetSheetHeaderColumn","EXPR","","","","{?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} || {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)} ¦ 1","siObj,iColumnHeaderRowCount","if(sheetName.Equals(""Plant""))","siMain ¦ 1"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SetSpreadInit","446","1","SHEET","ChangeSheet","EXPR","","","","1","","else!(sheetName.Equals(""Plant""))","1"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SetSpreadInit","447","1","SHEET","InitSheet","EXPR","","","","1","","else!(sheetName.Equals(""Plant""))","1"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SetSpreadInit","449","1","META_BUILD","SetSheetHeaderColumn","EXPR","","","","{?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} || {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)} ¦ 1","siObj,iColumnHeaderRowCount","else!(sheetName.Equals(""Plant""))","siMain ¦ 1"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","EditButton","563","","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ {?fps.ActiveSheetIndex}","","if(fps != null) ⟫ if(fps.Name == ""spdMain"" && spdMain.ActiveSheetIndex == 0)","spdMain.Name ¦ fps.ActiveSheetIndex"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","EditButton","607","","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ {?fps.ActiveSheetIndex}","","if(fps != null) ⟫ else!(fps.Name == ""spdMain"" && spdMain.ActiveSheetIndex == 0) ⟫ if(fps.Name == ""spdMain"" && spdMain.ActiveSheetIndex == 1)","spdMain.Name ¦ fps.ActiveSheetIndex"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","EditButton","641","","OTHER","SetCellTypeCombo","EXPR","","","LINE_ID","0 ¦ {?siMain.GetColumnIndex(DefColumns.LINE_ID)} ¦ {?new DataTable()}","iRow,iCol,dt","if(fps != null) ⟫ else!(fps.Name == ""spdMain"" && spdMain.ActiveSheetIndex == 0) ⟫ if(fps.Name == ""spdMain"" && spdMain.ActiveSheetIndex == 1) ⟫ for(i < siMain.ActiveSheet.RowCount) ⟫ else!(siMain.ActiveSheet.GetText(""0"", siMain.GetColumnIndex(""INPUT_STATUS"")).ToString() == ""M"") ⟫ if(siMain.ActiveSheet.GetText(""0"", siMain.GetColumnIndex(""INPUT_STATUS"")).ToString() == ""I"")","i ¦ siMain.GetColumnIndex(DefColumns.LINE_ID) ¦ dtComboIns"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","EditButton","673","","SHEET","GetSheetInfo","EXPR","","","","{?spdExcept.Name} ¦ {?fps.ActiveSheetIndex}","","if(fps != null) ⟫ else!(fps.Name == ""spdMain"" && spdMain.ActiveSheetIndex == 0) ⟫ else!(fps.Name == ""spdMain"" && spdMain.ActiveSheetIndex == 1) ⟫ if(fps.Name == ""spdExcept"")","spdExcept.Name ¦ fps.ActiveSheetIndex"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InsertButton","864","","OTHER","SetCellTypeCombo","EXPR","","","LINE_ID","{?siMain.ActiveRowIndex} ¦ {?siMain.GetColumnIndex(DefColumns.LINE_ID)} ¦ {?new DataTable()}","iRow,iCol,dt","if(fps.Name == ""spdMain"" && (spdMain.ActiveSheetIndex == 0 || spdMain.ActiveSheetIndex == 1)) ⟫ if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ else!(siMain.SheetName == ""Plant"") ⟫ if(siMain.SheetName == ""Packer"")","siMain.ActiveRowIndex ¦ siMain.GetColumnIndex(DefColumns.LINE_ID) ¦ dtComboIns"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","Find_Packer","961","Packer","SHEET","ChangeSheet","HARDCODED","","","","Packer","","","SpdSheet.shtPacker"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","FindData_Main","1045","Plant","SHEET","ChangeSheet","HARDCODED","","","","Plant","","","SpdSheet.shtMain"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SpdMain_CellClick","2583","","OTHER","SetCellTypeCombo","EXPR","","","","{?e.Row} ¦ {?e.Column} ¦ {?new DataTable()} || {?DBUtils.Filter(dtLineByOperationOfSpdAll, ""DIVISION_ID = '"" + division + ""' AND FACTORY_ID = '"" + pFactoryID + ""' AND OP…} || {?Data.Common(Data.Type.LineByOperation, false, division, """", """", """", """")}","iRow,iCol,dt","if(fps != null && siMain.IsLock(""Plant"") == false && siMain.IsLockCell(e.Row, e.Column) == false && siMain.ActiveSheet.SheetName == ""Plant"") ⟫ if(e.Column == siMain.GetColumnIndex(""LINE_ID""))","e.Row ¦ e.Column ¦ dtLineByOperationOfSpd"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SpdMain_ClipboardPasted","2773","","OTHER","SetCellTypeCombo","EXPR","","","","{?e.CellRange.Row} ¦ {?e.CellRange.Column} ¦ {?new DataTable()}","iRow,iCol,dt","if(fps != null) ⟫ if(fps.Name == ""spdMain"" && siMain.IsLock(siMain.SheetName) == false && siMain.Sheet().Rows.Count > 0 && (siMain.ActiveSheet.SheetName == SpdSheet.shtMain || siMain.ActiveSheet.SheetName == SpdSheet.shtP…) ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(iCol== siMain.GetColumnIndex(""LINE_ID"")) ⟫ if(drArr != null && drArr.Length>0)","iRow ¦ iCol ¦ dtLine"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SpdMain_ActiveSheetChanged","2792","Plant","SHEET","ChangeSheet","HARDCODED","","","","Plant","","if(((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == ""Plant"")","SpdSheet.shtMain"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SpdMain_ActiveSheetChanged","2793","Plant","SHEET","ChangeActiveSheet","HARDCODED","","","","Plant","sSheetName","if(((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == ""Plant"")","SpdSheet.shtMain"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SpdMain_ActiveSheetChanged","2799","Packer","SHEET","ChangeSheet","HARDCODED","","","","Packer","","else!(((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == ""Plant"") ⟫ if(((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == ""Packer"")","SpdSheet.shtPacker"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SpdMain_ActiveSheetChanged","2800","Packer","SHEET","ChangeActiveSheet","HARDCODED","","","","Packer","sSheetName","else!(((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == ""Plant"") ⟫ if(((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == ""Packer"")","SpdSheet.shtPacker"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","522","","OVERRIDE","set:HorizontalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellHorizontalAlignment.General}","HorizontalAlignment","","FarPoint.Win.Spread.CellHorizontalAlignment.General"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","523","","OVERRIDE","set:NoteIndicatorColor","EXPR","","","","{?System.Drawing.Color.Red}","NoteIndicatorColor","","System.Drawing.Color.Red"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","524","","OVERRIDE","set:Parent","HARDCODED","","","","ColumnHeaderDefaultEnhanced","Parent","","""ColumnHeaderDefaultEnhanced"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","525","","OVERRIDE","set:VerticalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellVerticalAlignment.General}","VerticalAlignment","","FarPoint.Win.Spread.CellVerticalAlignment.General"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","575","","OVERRIDE","set:HorizontalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellHorizontalAlignment.General}","HorizontalAlignment","","FarPoint.Win.Spread.CellHorizontalAlignment.General"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","576","","OVERRIDE","set:NoteIndicatorColor","EXPR","","","","{?System.Drawing.Color.Red}","NoteIndicatorColor","","System.Drawing.Color.Red"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","577","","OVERRIDE","set:Parent","HARDCODED","","","","ColumnHeaderDefaultEnhanced","Parent","","""ColumnHeaderDefaultEnhanced"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs","SCP0020_TactTime","InitializeComponent","578","","OVERRIDE","set:VerticalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellVerticalAlignment.General}","VerticalAlignment","","FarPoint.Win.Spread.CellVerticalAlignment.General"
```

### FILE meta_reads.csv (20 rows)
```csv
"variant","file","class","member","line","receiver","column","via"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SetChangedControl_Osp","362","drRow","CODE","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SetChangedControl_Osp","362","dr","CODE","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SetChangedControl_Osp","363","drRow","NAME","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SetChangedControl_Osp","363","dr","NAME","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","EditButton","636","drRow","CODE","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","EditButton","636","dr","CODE","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","EditButton","637","drRow","NAME","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","EditButton","637","dr","NAME","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InsertButton","859","drRow","CODE","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InsertButton","859","dr","CODE","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InsertButton","860","drRow","NAME","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","InsertButton","860","dr","NAME","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SaveData_Packer","1622","dtErr.Rows[0]","ERR_MESSAGE","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SaveData_Main","1874","dtErr.Rows[0]","ERR_MESSAGE","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SaveData_Except_Packer","2094","dtErr.Rows[0]","ERR_MESSAGE","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SaveData_Except","2297","dtErr.Rows[0]","ERR_MESSAGE","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SpdMain_ClipboardPasted","2769","drRow","CODE","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SpdMain_ClipboardPasted","2769","dr","CODE","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SpdMain_ClipboardPasted","2770","drRow","NAME","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs","SCP0020_TactTime","SpdMain_ClipboardPasted","2770","dr","NAME","[]"
```

### FILE commented_calls.csv (0 rows)
```csv
"variant","file","line","kind","candidate","key","status"
```
