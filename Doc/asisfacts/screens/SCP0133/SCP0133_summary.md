# SCP0133 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0133_WarehouseCapacity\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0133_WarehouseCapacity\SCP0133_WarehouseCapacity.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0133_WarehouseCapacity\SCP0133_WarehouseCapacity.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0133_WarehouseCapacity\SCP0133_WarehouseCapacity.csproj | 1559 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0133_WarehouseCapacity\SCP0133_WarehouseCapacity.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0133_WarehouseCapacity\SCP0133_WarehouseCapacity.csproj | 783 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 644 | {?string.Empty} | UNRESOLVED |  |
| button:FindButton | FindButton > FindData_Main | 644 | SCP.SCP0133_GET_WAREHOUSE_CAPACITY | MATCH | SP SCP0133_GET_WAREHOUSE_CAPACITY |
| button:FindButton | FindButton > FindData_Main | 644 | SCP.SCP0133_GET_WAREHOUSE_ITEM_MAPPING | MATCH | SP SCP0133_GET_WAREHOUSE_ITEM_MAPPING |
| button:SaveButton | SaveButton > SaveData_WhCapa > GetSearchInfo | 250 | SCP.SCP0133_GET_SEARCH_INFO | MATCH | SP SCP0133_GET_SEARCH_INFO |
| button:SaveButton | SaveButton > SaveData_ItemMapping > FindData_Main | 644 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > SaveData_ItemMapping > FindData_Main | 644 | SCP.SCP0133_GET_WAREHOUSE_CAPACITY | MATCH | SP SCP0133_GET_WAREHOUSE_CAPACITY |
| button:SaveButton | SaveButton > SaveData_ItemMapping > FindData_Main | 644 | SCP.SCP0133_GET_WAREHOUSE_ITEM_MAPPING | MATCH | SP SCP0133_GET_WAREHOUSE_ITEM_MAPPING |
| button:SaveButton | SaveButton > SaveData_WhCapa | 878 | SCP.SCP0133_SAVE_WAREHOUSE_CAPACITY | MATCH | SP SCP0133_SAVE_WAREHOUSE_CAPACITY |
| button:SaveButton | SaveButton > SaveData_ItemMapping | 1071 | SCP.SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING | MATCH | SP SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING |
| event:this.Load | Form_Load > InitControls | 184 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.spdMain.ActiveSheetChanged | SpdMain_ActiveSheetChanged > GetSearchInfo | 250 | SCP.SCP0133_GET_SEARCH_INFO | MATCH | SP SCP0133_GET_SEARCH_INFO |
| unreached:(진입점 미연결) | <field:dtValidYn> | 52 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?string.Empty} | UNRESOLVED | 1 |  |  |  |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCP.SCP0133_GET_SEARCH_INFO | MATCH | 1 | SP SCP0133_GET_SEARCH_INFO | EXEC:SCP0133_GET_SEARCH_INFO, SELECT:SCP_OPMZ_PLAN_GR_M, INSERT:#SCM_SITE, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SITE_ITEM, SELECT:#SCM_SITE, SELECT:SCP_OPMZ_WAREHOUSE_CAPACITY, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_MST_FINAL_ITEM |  |
| SCP.SCP0133_GET_WAREHOUSE_CAPACITY | MATCH | 1 | SP SCP0133_GET_WAREHOUSE_CAPACITY | EXEC:SCP0133_GET_WAREHOUSE_CAPACITY, SELECT:SCP_OPMZ_WAREHOUSE_CAPACITY, REF:STRING_SPLIT |  |
| SCP.SCP0133_GET_WAREHOUSE_ITEM_MAPPING | MATCH | 1 | SP SCP0133_GET_WAREHOUSE_ITEM_MAPPING | EXEC:SCP0133_GET_WAREHOUSE_ITEM_MAPPING, SELECT:SCP_OPMZ_WAREHOUSE_ITEM_MAPPING, REF:STRING_SPLIT |  |
| SCP.SCP0133_SAVE_WAREHOUSE_CAPACITY | MATCH | 1 | SP SCP0133_SAVE_WAREHOUSE_CAPACITY | EXEC:SCP0133_SAVE_WAREHOUSE_CAPACITY, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_OPMZ_WAREHOUSE_CAPACITY, INSERT:SCP_OPMZ_WAREHOUSE_CAPACITY, UPDATE:SCP_OPMZ_WAREHOUSE_CAPACITY, DELETE:SCP_OPMZ_WAREHOUSE_CAPACITY, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING | MATCH | 1 | SP SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING | EXEC:SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_OPMZ_WAREHOUSE_ITEM_MAPPING, INSERT:SCP_OPMZ_WAREHOUSE_ITEM_MAPPING, UPDATE:SCP_OPMZ_WAREHOUSE_ITEM_MAPPING, DELETE:SCP_OPMZ_WAREHOUSE_ITEM_MAPPING, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| CopyPlantSite | row | CODE, NAME |
| InitControls | row | CODE, NAME |
| SpdMain_ClipboardPasted | dtPlanGroup.Select().Where(c => c["NAME"].ToString() == siMain.ActiveSheet.Cells[iRow, iCol].Text).FirstOrDefault() | CODE |
| SpdMain_ClipboardPasted | c | NAME |
| SpdMain_ClipboardPasted | dtWarehouseTemp.Rows[0] | SCM_SITE_ID, STAGE |
| SpdMain_ComboSelChange | dtWarehouseTemp.Rows[0] | SCM_SITE_ID, STAGE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:184 | UsrComboBox.DataBind | CODE, NAME |
| GetCheckedListValue | RefreshPlanGroupByDivision:325, RefreshSiteByPlanGroup:338, RefreshSiteByDivision:355, RefreshStageByDivision:378, RefreshWarehouse:387, RefreshWarehouse:393, SetVisibleSheetColumns:515, FindData_Main:619 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumnSCP | InitSpread:451, SetSpreadInit:475 | SpreadInfo.SetSheetHeaderColumnSCP | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:153 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:480 |
| clbPlanGroup | SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged | InitEvent:481 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:483 |
| this.spdMain | CellClick | spdMain_CellClick | InitEvent:484 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:485 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:486 |
| this.spdMain | ActiveSheetChanged | SpdMain_ActiveSheetChanged | InitEvent:487 |
| this.spdMain | ActiveSheetChanging | spdSub_ActiveSheetChanging | InitEvent:488 |
| this.spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:489 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:490 |
| this.spdMain | EditChange | SpdMain_EditChange | InitEvent:493 |
| this.spdMain | EditModeOff | SpdMain_EditModeOff | InitEvent:494 |
| dsdmMain | Changed | SpdMain_Changed | InitEvent:497 |
| dsdmExcept | Changed | SpdMain_Changed | InitEvent:500 |

## 6. 컨트롤 (29개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | lblCombo1, lblStage, lblValid, lblPeriod, lblWarehouse, lblItemId, lblItemIdButton, lblPlanGroup, lblSite |
| EmptySpaceItem | 5 | emptySpaceItem5, emptySpaceItem6, emptySpaceItem4, emptySpaceItem1, emptySpaceItem8 |
| UsrComboBox | 2 | cboValid, cboStage |
| UsrButton | 2 | btnItemId, usrButton1 |
| UsrCheckedList | 2 | clbPlanGroup, clbSite |
| SheetView | 1 | spdMain_Sheet1 |
| FpSpread | 1 | spdMain |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckedList2 | 1 | clbWarehouse |
| UsrCombo | 1 | cboDivision |
| UsrDateRangePicker3 | 1 | dCalendar |
| UsrMultiLineEditor | 1 | txtItemId |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| UsrConditionPanel | 1 | pnlCondition |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 644 | FindData_Main | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 80 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 31 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
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
| SCM_MST_SHEET_COLUMNS | SCP0133 | Warehouse Capacity | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 |
| SCM_MST_SHEET_COLUMNS | SCP0133 | Warehouse Item Mapping | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Warehouse Capacity, Warehouse Item Mapping
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumnSCP@InitSpread:451, SetSheetHeaderColumnSCP@SetSpreadInit:475

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetVisibleSheetColumns |  | 522 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.sht01WhCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.sht02ItemMap)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | if(_sActiveSheetName == "Warehouse Item Mapping") ⟫ if(division.IndexOf("81_UC") >= 0) |
| SetVisibleSheetColumns |  | 526 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.sht01WhCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.sht02ItemMap)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | if(_sActiveSheetName == "Warehouse Item Mapping") ⟫ else!(division.IndexOf("81_UC") >= 0) |
| InitializeComponent |  | 102 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 103 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 104 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 105 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Warehouse Capacity | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |
| Warehouse Item Mapping | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
