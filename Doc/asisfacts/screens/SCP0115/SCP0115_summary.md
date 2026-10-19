# SCP0115 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0115_PolicyInvManagement\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0115_PolicyInvManagement\SCP0115_PolicyInvMgmt.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0115_PolicyInvManagement\Properties\Resources.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0115_PolicyInvManagement\SCP0115_PolicyInvMgmt.csproj | 84 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0115_PolicyInvManagement\SCP0115_PolicyInvMgmt.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0115_PolicyInvManagement\SCP0115_PolicyInvMgmt.csproj | 2145 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0115_PolicyInvManagement\SCP0115_PolicyInvMgmt.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0115_PolicyInvManagement\SCP0115_PolicyInvMgmt.csproj | 772 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:ExcelButton | ExcelButton > ExportExcelData > CreateComboboxCellType > GetComboBoxMasterData | 520 | SCP.SCP0115_GET_COMBOBOX_DATA | MATCH | SP SCP0115_GET_COMBOBOX_DATA |
| button:FindButton | FindButton > Find_Data | 427 | SCP.SCP0115_GET_POLICY_INV_MGMT_PLAN | MATCH | SP SCP0115_GET_POLICY_INV_MGMT_PLAN |
| button:SaveButton | SaveButton > SaveData > Find_Data | 427 | SCP.SCP0115_GET_POLICY_INV_MGMT_PLAN | MATCH | SP SCP0115_GET_POLICY_INV_MGMT_PLAN |
| button:SaveButton | SaveButton > SaveData | 990 | SCP.SCP0115_GET_POLICY_INV_MGMT_PLAN | MATCH | SP SCP0115_GET_POLICY_INV_MGMT_PLAN |
| button:SaveButton | SaveButton > SaveData > SavePlanData | 1120 | SCP.SCP0115_SAVE_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN | MATCH | SP SCP0115_SAVE_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN |
| event:this.Load | Form_Load > LoadMasterData > GetComboBoxMasterData | 520 | SCP.SCP0115_GET_COMBOBOX_DATA | MATCH | SP SCP0115_GET_COMBOBOX_DATA |
| event:this.Load | Form_Load > InitControls > GetPlanDateComboBox | 548 | SCP.SCP0115_GET_POLICY_INV_MGMT_PLAN_DATE | MATCH | SP SCP0115_GET_POLICY_INV_MGMT_PLAN_DATE |
| unreached:(진입점 미연결) | Save_Data_Import | 1244 | SCP.SCP0115_SAVE_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN | MATCH | SP SCP0115_SAVE_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| SCP.SCP0115_GET_COMBOBOX_DATA | MATCH | 1 | SP SCP0115_GET_COMBOBOX_DATA | EXEC:SCP0115_GET_COMBOBOX_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0115_GET_POLICY_INV_MGMT_PLAN | MATCH | 2 | SP SCP0115_GET_POLICY_INV_MGMT_PLAN | EXEC:SCP0115_GET_POLICY_INV_MGMT_PLAN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_ANL_LGTM_PCY_INV_MGMT_PLAN, SELECT:SCM_MST_SITE, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_ITEM_CLASS_M, REF:STRING_SPLIT |  |
| SCP.SCP0115_GET_POLICY_INV_MGMT_PLAN_DATE | MATCH | 1 | SP SCP0115_GET_POLICY_INV_MGMT_PLAN_DATE | EXEC:SCP0115_GET_POLICY_INV_MGMT_PLAN_DATE, SELECT:SCP_ANL_LGTM_PCY_INV_MGMT_PLAN |  |
| SCP.SCP0115_SAVE_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN | MATCH | 2 | SP SCP0115_SAVE_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN | EXEC:SCP0115_SAVE_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SCP_ANL_LGTM_PCY_INV_MGMT_PLAN, SELECT:SCP_ANL_LGTM_PCY_INV_MGMT_PLAN, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| convertMasterDataToList | row | Code, Name |
| CreateDivComboboxById | row | DIVISION_ID |
| GetLabelNameByName | foundRows[0] | COLUMN_LABEL_NAME |
| SetPlantChangedControl | row | DIVISION_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:204, SetChangedControl:212, SetPlantChangedControl:222, SetPlantChangedControl:235, Find_Data:410, Find_Data:411, Find_Data:412, Find_Data:414 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | SetSpreadInit:262 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:347 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:158 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:294 |
| clbPlant | SelectedIndexChanged | clbPlant_SelectedIndexChanged | InitEvent:295 |
| this.spdMain | Change | spdMain_Change | InitEvent:296 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitEvent:297 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:333 |
| this.btnImport | Click | btnImport_Click | InitializeComponent:370 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:639 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:640 |

## 6. 컨트롤 (31개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 11 | layoutDivision1, layoutPlant1, layoutControlItem3, layoutControlItem4, layoutControlItem5, layoutControlItem2, layoutControlItem1, layoutControlItem6, layoutControlItem7, layoutControlItem8, layoutControlItem9 |
| UsrLayoutControl | 4 | usrLayoutControl2, usrLayoutControl4, usrLayoutControl3, usrLayoutControl1 |
| LayoutControlGroup | 4 | layoutControlGroup3, layoutControlGroup1, Root, layoutControlGroup2 |
| UsrCombo | 2 | cboCategory, cboPlanDate |
| UsrButton | 2 | btnColumn, btnImport |
| UsrCheckedList2 | 2 | cboDivision, clbPlant |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePicker3 | 1 | dCalendar |
| UsrMultiLineEditor | 1 | txtItemId |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet |
| EmptySpaceItem | 1 | emptySpaceItem6 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 29 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_EXCEL_COLUMNS | 1 | dbmeta_dbo_SCM_ADM_EXCEL_COLUMNS.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 22 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 85 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_GroupMenuAuth | 2 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0115 | Policy Inv Management | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Policy Inv Management
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetSpreadInit:262

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| ExportExcelData |  | 726 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| ExportExcelData |  | 762 | 표시/라벨 변경 | set:CellType | CellType = {?dateCell} |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ if(dateColPos >= 0) |
| ExportExcelData |  | 853 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| InitializeComponent |  | 656 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 657 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 658 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 659 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Policy Inv Management | META+코드연결 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
