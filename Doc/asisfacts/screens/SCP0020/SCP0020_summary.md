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
