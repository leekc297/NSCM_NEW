# SSP0024 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 422 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 450 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 902 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 556 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 191 | biz:CommonData.CommonDataList [code=PlantSiteByFactoryEEOperation] | BIZ_MATCH |  |
| button:EditButton | EditButton > GetSSPUserCheck | 883 | SSP.SSP0002_GET_USER_INFO_LIST | MATCH | SP SSP0002_GET_USER_INFO_LIST |
| button:FindButton | FindButton > FindData | 267 | SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP | MATCH | SP SSP0024_GET_ITEM_BY_DIVISION_POPUP |
| button:FindButton | FindButton > FindData | 316 | SSP.SSP0024_GET_SHIP_MASTER | MATCH | SP SSP0024_GET_SHIP_MASTER |
| button:SaveButton | SaveButton > SaveData > FindData | 316 | SSP.SSP0024_GET_SHIP_MASTER | MATCH | SP SSP0024_GET_SHIP_MASTER |
| button:SaveButton | SaveButton > SaveData | 467 | SSP.SSP0024_SAVE_SHIP_MASTER | MATCH | SP SSP0024_SAVE_SHIP_MASTER |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 267 | SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP | MATCH | SP SSP0024_GET_ITEM_BY_DIVISION_POPUP |
| event:this.clbDivisionId.SelectedIndexChanged | clbDivision_SelectedIndexChanged > GetDivisionbyPlantSiteCode | 415 | biz:CommonData.CommonDataList [code=PlantSiteByDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 191 | biz:CommonData.CommonDataList [code=PlantSiteByFactoryEEOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 267 | SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP | MATCH | SP SSP0024_GET_ITEM_BY_DIVISION_POPUP |
| event:this.Load | Form_Load > InitControls > GetDivision | 405 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| event:this.Load | Form_Load > InitControls > GetDivisionbyPlantSiteCode | 415 | biz:CommonData.CommonDataList [code=PlantSiteByDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtMyDivision> | 37 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtPlantSiteByFactoryForSpread> | 41 | biz:CommonData.CommonDataList [code=PlantSiteByFactoryEEOperation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtElectrodePostOperCode> | 49 | biz:CommonData.CommonDataList [code=ElectrodePostOperCode] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtDomExpTypeCode> | 51 | biz:CommonData.CommonDataList [code=DomExpTypeCode] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtBuilding> | 52 | biz:CommonData.CommonDataList [code=BuildingForShipMasterElec] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtElectrodePackageType> | 55 | biz:CommonData.CommonDataList [code=ElectrodePackageType] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=BuildingForShipMasterElec] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_FACTORY_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=DomExpTypeCode] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=ElectrodePackageType] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=ElectrodePostOperCode] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=PlantSiteByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList_SCP:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlantSiteByFactoryEEOperation] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_FACTORY_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SSP.SSP0002_GET_USER_INFO_LIST | MATCH | 1 | SP SSP0002_GET_USER_INFO_LIST | EXEC:SSP0002_GET_USER_INFO_LIST, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_GROUPINFO, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPAUTHEXTENTION |  |
| SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP | MATCH | 1 | SP SSP0024_GET_ITEM_BY_DIVISION_POPUP | EXEC:SSP0024_GET_ITEM_BY_DIVISION_POPUP, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:SCM_MST_SITE, REF:STRING_SPLIT |  |
| SSP.SSP0024_GET_SHIP_MASTER | MATCH | 1 | SP SSP0024_GET_SHIP_MASTER | EXEC:SSP0024_GET_SHIP_MASTER, SELECT:SSP_MST_SHIP_MASTER_EE, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:SCM_MST_SITE, REF:STRING_SPLIT |  |
| SSP.SSP0024_SAVE_SHIP_MASTER | MATCH | 1 | SP SSP0024_SAVE_SHIP_MASTER | EXEC:SSP0024_SAVE_SHIP_MASTER, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SSP_MST_SHIP_MASTER_EE_H, MERGE:SSP_MST_SHIP_MASTER_EE, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| DefineProperty | dr | CODE |
| DefineProperty | drRow | CODE, NAME |
| DefineProperty | drAllRow | CODE, NAME |
| GetSelectedListName | dt.Rows[i] | CODE |
| Re_Design | c | DIVISION_ID |
| SetCellCombo | drRow | CODE, NAME |
| SetCellCombo | dr | CODE, NAME |
| SpdMain_ComboSelChange | c | CODE |
| SpdMain_ComboSelChange | row | DIVISION_ID, CODE |
| SpdMain_ComboSelChange | drOperLT | POST_OPER_LT |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:189, FindData:301, FindData:302, Re_Design:355, InsertRow:379 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:221 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:282 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.clbDivisionId | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:184 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:277 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:357 |
| this | Load | Form_Load | .ctor:156 |
| this | Load | Form_Load | .ctor:109 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitControls:177 |
| spdMain | CellClick | SpdMain_CellClick | InitControls:178 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | InitControls:179 |
| spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitControls:180 |
| spdMain | KeyPress | SpdMain_KeyPress | InitControls:181 |
| this.btnMaterialId | Click | BtnMaterialId_Click | InitControls:183 |
| this.btnModelId | Click | BtnModelId_Click | InitControls:184 |

## 6. 컨트롤 (38개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 11 | layoutControlItem1, lblPlantSite, lblDivision, lbMaterialID, PlanSite, Division, MaterialID, layoutControlItem5, NickName, layoutControlItem4, ModelId |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrMultiLineEditor | 3 | txtMaterialId, txtMaterialId, txtModelId |
| UsrCheckedList | 3 | clbDivisionId, clbPlantSiteId, cboPlantSite |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem1 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrButton | 2 | btnModelId, btnMaterialId |
| UsrButtonList | 1 | btnButtonList |
| UsrCombo | 1 | cboDivision |
| TextEdit | 1 | txtNickName |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 7 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 25 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 3 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 12 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
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
| SCM_MST_SHEET_COLUMNS | SSP0024 | Ship Master Elec | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Project, Ship Master Elec
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:221

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 214 | 하드코딩 | AddTextColumn | division | DIVISION_ID |  |
| InitSpread |  | 215 | 하드코딩 | AddTextColumn | division | DIVISION_NAME |  |
| InitSpread |  | 216 | 하드코딩 | AddTextColumn | Plant Site Code | PLANT_SITE_CODE |  |
| InitSpread |  | 217 | 하드코딩 | AddTextColumn | Plant Site | PLANT_SITE_ID |  |
| InitSpread |  | 218 | 하드코딩 | AddTextColumn | Material | MATERIAL_ID |  |
| InitSpread |  | 219 | 하드코딩 | AddTextColumn | Model | MODEL_ID |  |
| InitSpread |  | 220 | 하드코딩 | AddTextColumn | Cell Type | CELL_TYPE |  |
| InitSpread |  | 221 | 하드코딩 | AddTextColumn | Nick Name | NICK_NAME |  |
| InitSpread |  | 222 | 하드코딩 | AddTextColumn | Electrode Type | ELECTRODE_TYPE |  |
| InitSpread |  | 223 | 하드코딩 | AddTextColumn | UOM | ITEM_UOM |  |
| InitSpread |  | 224 | 하드코딩 | AddTextColumn | Pancake (m/cell) | UOM_CONVERT_IN_TACT_TIME |  |
| InitializeComponent |  | 373 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 374 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 375 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 376 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 469 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 470 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 471 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 472 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Project | 코드 하드코딩 전용(메타 없음) | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |
| Ship Master Elec | META+코드연결 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
