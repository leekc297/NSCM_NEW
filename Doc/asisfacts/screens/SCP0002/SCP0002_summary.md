# SCP0002 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0002_LineMaster\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0002_LineMaster\SCP0002_LineMaster.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0002_LineMaster\SCP0002_LineMaster.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0002_LineMaster\SCP0002_LineMaster.csproj | 1027 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0002_LineMaster\SCP0002_LineMaster.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0002_LineMaster\SCP0002_LineMaster.csproj | 539 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl > RefreshOperationByBuilding | 166 | biz:CommonData.CommonDataList [code=LocationGroupByCapa] | BIZ_MATCH |  |
| event:clbBuilding.SelectedIndexChanged | ClbBuilding_SelectedIndexChanged > RefreshOperationByBuilding | 166 | biz:CommonData.CommonDataList [code=LocationGroupByCapa] | BIZ_MATCH |  |
| event:clbPlantSite.SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged > RefreshOperationByBuilding | 166 | biz:CommonData.CommonDataList [code=LocationGroupByCapa] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Data > FindData_Plant | 468 | SCP.SCP0002_GET_LINE_MASTER | MATCH | SP SCP0002_GET_LINE_MASTER |
| button:FindButton | FindButton > Find_Data > Find_Packer | 544 | SCP.SCP0002_GET_LINE_MASTER_OSP | MATCH | SP SCP0002_GET_LINE_MASTER_OSP |
| button:SaveButton | SaveButton > Save_Data > Find_Data > FindData_Plant | 468 | SCP.SCP0002_GET_LINE_MASTER | MATCH | SP SCP0002_GET_LINE_MASTER |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Packer | 544 | SCP.SCP0002_GET_LINE_MASTER_OSP | MATCH | SP SCP0002_GET_LINE_MASTER_OSP |
| button:SaveButton | SaveButton > Save_Data | 674 | SCP.SCP0002_SAVE_LINE_MASTER_OSP | MATCH | SP SCP0002_SAVE_LINE_MASTER_OSP |
| event:this.Load | Form_Load > InitControls | 146 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl > RefreshOperationByBuilding | 166 | biz:CommonData.CommonDataList [code=LocationGroupByCapa] | BIZ_MATCH |  |
| event:this.spdMain.ActiveSheetChanged | SpdMain_ActiveSheetChanged > SetChangedControl > RefreshOperationByBuilding | 166 | biz:CommonData.CommonDataList [code=LocationGroupByCapa] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 54 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LocationGroupByCapa] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SCM_MST_OPERATION_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCP.SCP0002_GET_LINE_MASTER | MATCH | 1 | SP SCP0002_GET_LINE_MASTER | EXEC:SCP0002_GET_LINE_MASTER, REF:FN_GET_DIVISION_NAME, REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_SITE, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_MST_OPERATION_SN, REF:STRING_SPLIT, SELECT:SCM_MST_DIVISION |  |
| SCP.SCP0002_GET_LINE_MASTER_OSP | MATCH | 1 | SP SCP0002_GET_LINE_MASTER_OSP | EXEC:SCP0002_GET_LINE_MASTER_OSP, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE, REF:STRING_SPLIT |  |
| SCP.SCP0002_SAVE_LINE_MASTER_OSP | MATCH | 1 | SP SCP0002_SAVE_LINE_MASTER_OSP | EXEC:SCP0002_SAVE_LINE_MASTER_OSP, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SCM_MST_LINE_OSP_H, UPDATE:SCM_MST_LINE_OSP, INSERT:SCM_MST_LINE_OSP, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| Insert_Row | drRow | CODE, NAME |
| Insert_Row | dr | CODE |
| SetChangedControl_Osp | drRow | CODE, NAME |
| SetChangedControl_Osp | dr | CODE, NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:146 | UsrComboBox.DataBind | CODE, NAME |
| GetCheckedListValue | RefreshPlantSiteByDivision:173, RefreshBuildingByPlantSite:181, RefreshLine:189, RefreshLine:190, RefreshLine:191, RefreshLine:192, RefreshtLineByPlantPacker:210, RefreshtLineByPlantPacker:211 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | SetSpreadInit:287 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:114 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:295 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:296 |
| clbBuilding | SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | InitEvent:297 |
| clbOperation | SelectedIndexChanged | ClbOperation_SelectedIndexChanged | InitEvent:298 |
| this.spdMain | ActiveSheetChanged | SpdMain_ActiveSheetChanged | InitEvent:300 |
| this.spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:301 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:302 |

## 6. 컨트롤 (22개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 6 | layoutControlItem2, layoutControlItem6, layoutControlItem9, layoutControlItem4, Division, layoutControlItem5 |
| UsrCheckedList | 4 | clbLine, clbOperation, clbBuilding, clbPlantSite |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem5 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrComboBox | 1 | cboValid |
| UsrCombo | 1 | cboDivision |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 4 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 43 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 12 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 7 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 98 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0002 | Line Master | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |
| SCM_MST_SHEET_COLUMNS | SCP0002 | Packer | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |
| SCM_MST_SHEET_COLUMNS | SCP0002 | Plant | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Plant, Packer
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetSpreadInit:287

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 447 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 448 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 449 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 450 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Line Master | 메타 정의만, 코드 미참조(미사용 가능) | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 |
| Packer | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| Plant | META+코드연결 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
