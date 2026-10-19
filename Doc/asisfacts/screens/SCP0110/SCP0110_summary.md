# SCP0110 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0110_GroupModelMapping\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0110_GroupModelMapping\SCP0110_GroupModelMapping.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0110_GroupModelMapping\Properties\Resources.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0110_GroupModelMapping\SCP0110_GroupModelMapping.csproj | 64 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0110_GroupModelMapping\SCP0110_GroupModelMapping.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0110_GroupModelMapping\SCP0110_GroupModelMapping.csproj | 1104 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0110_GroupModelMapping\SCP0110_GroupModelMapping.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0110_GroupModelMapping\SCP0110_GroupModelMapping.csproj | 631 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main_Sub | 397 | SCP.SCP0110_GET_GROUP_MASTER | MATCH | SP SCP0110_GET_GROUP_MASTER |
| button:FindButton | FindButton > FindData_Main_Sub | 434 | SCP.SCP0110_GET_MODEL_LIST | MATCH | SP SCP0110_GET_MODEL_LIST |
| button:SaveButton | SaveButton > SaveData > RefreshModelList | 219 | SCP.SCP0110_GET_MODEL_LIST | MATCH | SP SCP0110_GET_MODEL_LIST |
| button:SaveButton | SaveButton > SaveData > FindData_Main_Sub | 397 | SCP.SCP0110_GET_GROUP_MASTER | MATCH | SP SCP0110_GET_GROUP_MASTER |
| button:SaveButton | SaveButton > SaveData > FindData_Main_Sub | 434 | SCP.SCP0110_GET_MODEL_LIST | MATCH | SP SCP0110_GET_MODEL_LIST |
| button:SaveButton | SaveButton > SaveData | 733 | SCP.SCP0110_SAVE_GROUP_MASTER | MATCH | SP SCP0110_SAVE_GROUP_MASTER |
| button:SaveButton | SaveButton > SaveData | 884 | SCP.SCP0110_SAVE_MODEL_LIST | MATCH | SP SCP0110_SAVE_MODEL_LIST |
| event:this.Load | Form_Load > DefineProperty | 152 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 201 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > RefreshModelList | 219 | SCP.SCP0110_GET_MODEL_LIST | MATCH | SP SCP0110_GET_MODEL_LIST |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub | 573 | SCP.SCP0110_GET_MODEL_LIST | MATCH | SP SCP0110_GET_MODEL_LIST |
| unreached:(진입점 미연결) | FindData_Main | 498 | SCP.SCP0110_GET_GROUP_MASTER | MATCH | SP SCP0110_GET_GROUP_MASTER |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_LINE_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| SCP.SCP0110_GET_GROUP_MASTER | MATCH | 2 | SP SCP0110_GET_GROUP_MASTER | EXEC:SCP0110_GET_GROUP_MASTER, SELECT:SCP_MST_ITEM_GROUP |  |
| SCP.SCP0110_GET_MODEL_LIST | MATCH | 3 | SP SCP0110_GET_MODEL_LIST | EXEC:SCP0110_GET_MODEL_LIST, SELECT:SCP_MST_ITEM_GROUP_DETAIL, SELECT:SCP_MST_ITEM_GROUP, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCM_MST_PROJECT, REF:STRING_SPLIT |  |
| SCP.SCP0110_SAVE_GROUP_MASTER | MATCH | 1 | SP SCP0110_SAVE_GROUP_MASTER | EXEC:SCP0110_SAVE_GROUP_MASTER, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_MST_ITEM_GROUP, UPDATE:SCP_MST_ITEM_GROUP, INSERT:SCP_MST_ITEM_GROUP, UPDATE:SCP_MST_ITEM_GROUP_DETAIL, DELETE:SCP_MST_ITEM_GROUP, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0110_SAVE_MODEL_LIST | MATCH | 1 | SP SCP0110_SAVE_MODEL_LIST | EXEC:SCP0110_SAVE_MODEL_LIST, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_MST_ITEM_GROUP_DETAIL, UPDATE:SCP_MST_ITEM_GROUP_DETAIL, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InitControls | dr | CODE, NAME |
| InitControls | dataRow | CODE, NAME |
| SaveData | dtGroupMaster.Rows[k] | CODE, NAME |
| SaveData | dtModelListAll.Rows[k] | PROJECT_CODE, GROUP_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | DefineProperty:151, RefreshModelList:212, InitSpread:283, InitSpread:284, FindData_Main_Sub:382, FindData_Main_Sub:383, FindData_Main:486, FindData_Sub:558 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:274 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SetSheetHeaderColumnSCP | InitSpread:290 | SpreadInfo.SetSheetHeaderColumnSCP | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:362 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdSub | ActiveSheetChanging | spdSub_ActiveSheetChanging | InitializeComponent:164 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:165 |
| this.spdSub | ComboSelChange | SpdSub_ComboSelChange | InitializeComponent:166 |
| this.spdSub | EditChange | spdSub_EditChange | InitializeComponent:167 |
| this.spdSub | TopChange | spdSub_TopChange | InitializeComponent:168 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:395 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:432 |
| this | Load | Form_Load | .ctor:106 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:108 |
| this.spdMain | KeyPress | SpdMain_KeyPress | .ctor:110 |
| this.spdSub | KeyPress | SpdMain_KeyPress | .ctor:114 |
| this.spdSub | ClipboardPasted | SpdSub_ClipboardPasted | .ctor:115 |
| spdSub | ActiveSheetChanged | SpdSub_ActiveSheetChanged | InitEvent:146 |
| dsdm | Changed | Dsdm_Changed | CreateSpread:261 |
| dsdmMain | Changed | spdMainDsdm_Changed | CreateSpread:264 |

## 6. 컨트롤 (25개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | layoutControlItem4, layoutControlItem3, layoutControlItem2, layoutControlItem8, layoutControlItem5, layoutControlItem6, layoutControlItem9 |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| UsrMultiLineEditor | 2 | txtItemId, txtProject |
| UsrButton | 2 | btnProject, btnItemId |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem3 |
| SplitContainer | 1 | splitContainer1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| UsrCombo | 1 | cboDivision |
| UsrComboBox | 1 | cboOperationGroup |
| TextBox | 1 | txtGroupName |
| LayoutControlGroup | 1 | layoutControlGroup1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 13 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 11 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 6 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0110 | Group Name | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | SCP0110 | Model List | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Group Name, Model List
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:274, SetSheetHeaderColumnSCP@InitSpread:290

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 128 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 129 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 130 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 131 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 184 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 185 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 186 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 187 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Group Name | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| Model List | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
