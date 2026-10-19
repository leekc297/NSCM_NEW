# DMF0006 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0006_CustomerModelMapping\DMF0006_CustomerModelMapping.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0006_CustomerModelMapping\DMF0006_CustomerModelMapping.csproj | 1214 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0006_CustomerModelMapping\DMF0006_CustomerModelMapping.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0006_CustomerModelMapping\DMF0006_CustomerModelMapping.csproj | 880 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0006_CustomerModelMapping\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0006_CustomerModelMapping\DMF0006_CustomerModelMapping.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0006_CustomerModelMapping\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0006_CustomerModelMapping\DMF0006_CustomerModelMapping.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0006_CustomerModelMapping\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0006_CustomerModelMapping\DMF0006_CustomerModelMapping.csproj | 27 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0006_CustomerModelMapping.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 1175 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0006_CustomerModelMapping.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 880 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivisions.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 850 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:clbDivisions.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 1136 | DM.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |
| button:FindButton | FindButton > FindData | 406 | DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | MATCH | SP DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA |
| button:InsertButton | InsertButton > InsertRow | 734 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData_DataService > FindData | 406 | DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | MATCH | SP DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA |
| button:SaveButton | SaveButton > SaveData_DataService | 636 | DM.PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA | MATCH | SP PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA |
| event:this.Load | Form_Load > InitControls | 142 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 153 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1136 | DM.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 901 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 939 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 232 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 5 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| DM.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DM0000_GET_COMMON_SPREAD_TITLE | EXEC:DM0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS |  |
| DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | MATCH | 1 | SP DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | EXEC:DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_GET_DEPT_LIST, SELECT:DM_MST_CUSTOMER_MODEL, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_PROJECT, REF:UF_FX_STRING_SPLITFORIN, REF:UF_FX_STRING_SPLIT, SELECT:TB_FX_USER, SELECT:SPLIT |  |
| DM.PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA | MATCH | 1 | SP PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA | EXEC:PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, DELETE:DM_MST_CUSTOMER_MODEL, INSERT:DM_MST_CUSTOMER_MODEL, UPDATE:DM_MST_CUSTOMER_MODEL, EXEC:PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST, INSERT:SCM_SYS_LOG_BATCH, INSERT:DM_MST_CUSTOMER_MODEL_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbEndCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| FindData | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InsertRow | UserInfoContext.Current | NowGroupID |
| SaveData_DataService | nvcCols | A |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:149, InitControls:162, clbDivision_SelectedIndexChanged:843, clbDivision_SelectedIndexChanged:853, clbDivision_SelectedIndexChanged:866, clbTeam_SelectedIndexChanged:1152, clbTeam_SelectedIndexChanged:1157 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:226 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:227 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:122 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:123 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:124 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:125 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:234 |
| this.btnModelType | Click | btnModelType_Click | InitializeComponent:486 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:526 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:566 |
| this | Load | Form_Load | .ctor:125 |
| this.umltProject | KeyDown | umltProject_KeyDown | DefineProperty:186 |
| this.umltModel | KeyDown | umltModel_KeyDown | DefineProperty:187 |
| clbDivisions | SelectedIndexChanged | clbDivision_SelectedIndexChanged | CreateSpread:216 |
| dsdm | Changed | Dsdm_Changed | CreateSpread:220 |
| dsdm | Changed | Dsdm_Changed | Dsdm_Changed:1182 |
| dsdm | Changed | Dsdm_Changed | Dsdm_Changed:1209 |

## 6. 컨트롤 (35개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 12 | layoutControlItem1, layoutControlItem4, layoutControlItem3, layoutControlItem9, layoutControlItem21, layoutControlItem6, layoutControlItem10, layoutControlItem5, layoutControlItem22, lblActive, layoutControlItem25, Project |
| UsrMultiLineEditor | 4 | umltCustomerPJT, umltCustomerModel, umltModel, umltProject |
| EmptySpaceItem | 4 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem4, emptySpaceItem5 |
| UsrCheckedList | 3 | clbSalesSite, clbTeam, clbEndCustomer |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 2 | btnProject, btnModelType |
| UsrCombo | 2 | clbDivisions, cboActive |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 4 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 19 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0006 | Customer Model Mapping | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 14건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Customer Model Mapping
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:227

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| clbDivision_SelectedIndexChanged |  | 830 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PROJECT_CODE)} | PROJECT_CODE | if(sDivision == "40") |
| clbDivision_SelectedIndexChanged |  | 835 | 표시/라벨 변경 | VisibleColumns | {?siMain.GetColumnIndex(DefColumns.PROJECT_CODE)} | PROJECT_CODE | else!(sDivision == "40") |
| InitializeComponent |  | 141 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 142 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 143 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 144 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Customer Model Mapping | META+코드연결 | 17 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
