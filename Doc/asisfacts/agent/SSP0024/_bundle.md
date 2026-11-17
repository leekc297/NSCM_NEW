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


### FILE endpoints.csv (13 rows)
```csv
"variant","file","class","member","line","site_kind","kind","candidate","key","status","sp_or_sql","objects","via","detail"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","FindData","267","ctor","fox","SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP","SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP","MATCH","SP SSP0024_GET_ITEM_BY_DIVISION_POPUP","EXEC:SSP0024_GET_ITEM_BY_DIVISION_POPUP, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:SCM_MST_SITE, REF:STRING_SPLIT","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","GetDivision","405","ctor","fox","SCM.SCM0001_GET_DIVISION","SCM.SCM0001_GET_DIVISION","MATCH","SP SCM0001_GET_DIVISION","EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","GetDivisionbyPlantSiteCode","415","derived","biz","CommonData.CommonDataList [code=PlantSiteByDivision]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.PlantSiteByDivision:Type.PlantSiteByDivision] > Data.CallBizCommonData",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","<field:dtMyDivision>","37","derived","biz","CommonData.CommonDataList [code=MyDivision]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.MyDivision:Type.MyDivision] > Data.CallBizCommonData",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","<field:dtPlantSiteByFactoryForSpread>","41","derived","biz","CommonData.CommonDataList [code=PlantSiteByFactoryEEOperation]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.PlantSiteByFactoryEEOperation:Type.PlantSiteByFactoryEEOperation] > Data.CallBizCommonData",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","<field:dtElectrodePostOperCode>","49","derived","biz","CommonData.CommonDataList [code=ElectrodePostOperCode]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.ElectrodePostOperCode:Type.ElectrodePostOperCode] > Data.CallBizCommonData",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","<field:dtDomExpTypeCode>","51","derived","biz","CommonData.CommonDataList [code=DomExpTypeCode]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.DomExpTypeCode:Type.DomExpTypeCode] > Data.CallBizCommonData",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","<field:dtBuilding>","52","derived","biz","CommonData.CommonDataList [code=BuildingForShipMasterElec]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.BuildingForShipMasterElec:Type.BuildingForShipMasterElec] > Data.CallBizCommonData",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","<field:dtElectrodePackageType>","55","derived","biz","CommonData.CommonDataList [code=ElectrodePackageType]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.ElectrodePackageType:Type.ElectrodePackageType] > Data.CallBizCommonData",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SetChangedControl","191","derived","biz","CommonData.CommonDataList [code=PlantSiteByFactoryEEOperation]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.PlantSiteByFactoryEEOperation:Type.PlantSiteByFactoryEEOperation] > Data.CallBizCommonData",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","FindData","316","ctor","fox","SSP.SSP0024_GET_SHIP_MASTER","SSP.SSP0024_GET_SHIP_MASTER","MATCH","SP SSP0024_GET_SHIP_MASTER","EXEC:SSP0024_GET_SHIP_MASTER, SELECT:SSP_MST_SHIP_MASTER_EE, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:SCM_MST_SITE, REF:STRING_SPLIT","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SaveData","467","ctor","fox","SSP.SSP0024_SAVE_SHIP_MASTER","SSP.SSP0024_SAVE_SHIP_MASTER","MATCH","SP SSP0024_SAVE_SHIP_MASTER","EXEC:SSP0024_SAVE_SHIP_MASTER, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SSP_MST_SHIP_MASTER_EE_H, MERGE:SSP_MST_SHIP_MASTER_EE, INSERT:SCM_SYS_LOG_BATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","GetSSPUserCheck","883","ctor","fox","SSP.SSP0002_GET_USER_INFO_LIST","SSP.SSP0002_GET_USER_INFO_LIST","MATCH","SP SSP0002_GET_USER_INFO_LIST","EXEC:SSP0002_GET_USER_INFO_LIST, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_GROUPINFO, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPAUTHEXTENTION","",""
```

### FILE flow.csv (18 rows)
```csv
"variant","file","class","entry_kind","entry","path","member","line","endpoint","status","sp_or_sql","objects"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","event","this.clbDivisionId.SelectedIndexChanged","clbDivision_SelectedIndexChanged > GetDivisionbyPlantSiteCode","GetDivisionbyPlantSiteCode","415","biz:CommonData.CommonDataList [code=PlantSiteByDivision]","BIZ_MATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","event","this.btnButtonList.UsrButtonList_Click_Detected","btnButtonList_UsrButtonList_Click_Detected > FindData","FindData","267","SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP","MATCH","SP SSP0024_GET_ITEM_BY_DIVISION_POPUP","EXEC:SSP0024_GET_ITEM_BY_DIVISION_POPUP, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:SCM_MST_SITE, REF:STRING_SPLIT"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","event","this.Load","Form_Load > FindData","FindData","267","SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP","MATCH","SP SSP0024_GET_ITEM_BY_DIVISION_POPUP","EXEC:SSP0024_GET_ITEM_BY_DIVISION_POPUP, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:SCM_MST_SITE, REF:STRING_SPLIT"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","event","this.Load","Form_Load > InitControls > GetDivisionbyPlantSiteCode","GetDivisionbyPlantSiteCode","415","biz:CommonData.CommonDataList [code=PlantSiteByDivision]","BIZ_MATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","event","this.Load","Form_Load > InitControls > GetDivision","GetDivision","405","SCM.SCM0001_GET_DIVISION","MATCH","SP SCM0001_GET_DIVISION","EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","button","FindButton","FindButton > FindData","FindData","267","SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP","MATCH","SP SSP0024_GET_ITEM_BY_DIVISION_POPUP","EXEC:SSP0024_GET_ITEM_BY_DIVISION_POPUP, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:SCM_MST_SITE, REF:STRING_SPLIT"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","event","this.Load","Form_Load > InitControls > SetChangedControl","SetChangedControl","191","biz:CommonData.CommonDataList [code=PlantSiteByFactoryEEOperation]","BIZ_MATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","event","cboDivision.SelectedIndexChanged","ClbDivision_SelectedIndexChanged > SetChangedControl","SetChangedControl","191","biz:CommonData.CommonDataList [code=PlantSiteByFactoryEEOperation]","BIZ_MATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","button","FindButton","FindButton > FindData","FindData","316","SSP.SSP0024_GET_SHIP_MASTER","MATCH","SP SSP0024_GET_SHIP_MASTER","EXEC:SSP0024_GET_SHIP_MASTER, SELECT:SSP_MST_SHIP_MASTER_EE, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:SCM_MST_SITE, REF:STRING_SPLIT"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","button","EditButton","EditButton > GetSSPUserCheck","GetSSPUserCheck","883","SSP.SSP0002_GET_USER_INFO_LIST","MATCH","SP SSP0002_GET_USER_INFO_LIST","EXEC:SSP0002_GET_USER_INFO_LIST, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_GROUPINFO, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPAUTHEXTENTION"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","button","SaveButton","SaveButton > SaveData","SaveData","467","SSP.SSP0024_SAVE_SHIP_MASTER","MATCH","SP SSP0024_SAVE_SHIP_MASTER","EXEC:SSP0024_SAVE_SHIP_MASTER, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SSP_MST_SHIP_MASTER_EE_H, MERGE:SSP_MST_SHIP_MASTER_EE, INSERT:SCM_SYS_LOG_BATCH"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","button","SaveButton","SaveButton > SaveData > FindData","FindData","316","SSP.SSP0024_GET_SHIP_MASTER","MATCH","SP SSP0024_GET_SHIP_MASTER","EXEC:SSP0024_GET_SHIP_MASTER, SELECT:SSP_MST_SHIP_MASTER_EE, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:SCM_MST_SITE, REF:STRING_SPLIT"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","unreached","(진입점 미연결)","<field:dtMyDivision>","<field:dtMyDivision>","37","biz:CommonData.CommonDataList [code=MyDivision]","BIZ_MATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","unreached","(진입점 미연결)","<field:dtBuilding>","<field:dtBuilding>","52","biz:CommonData.CommonDataList [code=BuildingForShipMasterElec]","BIZ_MATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","unreached","(진입점 미연결)","<field:dtPlantSiteByFactoryForSpread>","<field:dtPlantSiteByFactoryForSpread>","41","biz:CommonData.CommonDataList [code=PlantSiteByFactoryEEOperation]","BIZ_MATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","unreached","(진입점 미연결)","<field:dtElectrodePostOperCode>","<field:dtElectrodePostOperCode>","49","biz:CommonData.CommonDataList [code=ElectrodePostOperCode]","BIZ_MATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","unreached","(진입점 미연결)","<field:dtDomExpTypeCode>","<field:dtDomExpTypeCode>","51","biz:CommonData.CommonDataList [code=DomExpTypeCode]","BIZ_MATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","unreached","(진입점 미연결)","<field:dtElectrodePackageType>","<field:dtElectrodePackageType>","55","biz:CommonData.CommonDataList [code=ElectrodePackageType]","BIZ_MATCH","",""
```

### FILE events.csv (12 rows)
```csv
"variant","file","class","member","line","target","event","handler","op"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","184","this.clbDivisionId","SelectedIndexChanged","clbDivision_SelectedIndexChanged","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","277","this.btnButtonList","UsrButtonList_Click_Detected","btnButtonList_UsrButtonList_Click_Detected","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","357","this.spdMain","CellDoubleClick","spdMain_CellDoubleClick","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup",".ctor","156","this","Load","Form_Load","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode",".ctor","109","this","Load","Form_Load","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","InitControls","177","cboDivision","SelectedIndexChanged","ClbDivision_SelectedIndexChanged","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","InitControls","178","spdMain","CellClick","SpdMain_CellClick","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","InitControls","179","spdMain","ComboSelChange","SpdMain_ComboSelChange","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","InitControls","180","spdMain","ClipboardPasted","SpdMain_ClipboardPasted","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","InitControls","181","spdMain","KeyPress","SpdMain_KeyPress","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","InitControls","183","this.btnMaterialId","Click","BtnMaterialId_Click","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","InitControls","184","this.btnModelId","Click","BtnModelId_Click","+="
```

### FILE controls.csv (38 rows)
```csv
"variant","file","class","name","type","parent","line"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","usrLayoutControl1","GSCM.Windows.Forms.Controls.UsrLayoutControl","","36"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","layoutControlGroup1","DevExpress.XtraLayout.LayoutControlGroup","","37"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","usrConditionPanel1","GSCM.Windows.Forms.Controls.UsrConditionPanel","this","38"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","usrLayoutControl2","GSCM.Windows.Forms.Controls.UsrLayoutControl","usrConditionPanel1","39"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","txtMaterialId","GSCM.Windows.Forms.Controls.UsrMultiLineEditor","usrLayoutControl2","40"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","clbDivisionId","GSCM.Windows.Forms.Controls.UsrCheckedList","usrLayoutControl2","41"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","clbPlantSiteId","GSCM.Windows.Forms.Controls.UsrCheckedList","usrLayoutControl2","42"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","btnButtonList","GSCM.Windows.Forms.Controls.UsrButtonList","usrLayoutControl2","43"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","layoutControlGroup2","DevExpress.XtraLayout.LayoutControlGroup","","44"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","layoutControlItem1","DevExpress.XtraLayout.LayoutControlItem","","45"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","lblPlantSite","DevExpress.XtraLayout.LayoutControlItem","","46"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","lblDivision","DevExpress.XtraLayout.LayoutControlItem","","47"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","lbMaterialID","DevExpress.XtraLayout.LayoutControlItem","","48"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","emptySpaceItem1","DevExpress.XtraLayout.EmptySpaceItem","","49"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","spdMain","FarPoint.Win.Spread.FpSpread","this","50"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","spdMain_Sheet1","FarPoint.Win.Spread.SheetView","","51"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","usrLayoutControl1","GSCM.Windows.Forms.Controls.UsrLayoutControl","","33"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","layoutControlGroup1","DevExpress.XtraLayout.LayoutControlGroup","","34"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","usrConditionPanel1","GSCM.Windows.Forms.Controls.UsrConditionPanel","this","35"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","usrLayoutControl2","GSCM.Windows.Forms.Controls.UsrLayoutControl","usrConditionPanel1","36"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","btnModelId","GSCM.Windows.Forms.Controls.UsrButton","usrLayoutControl2","37"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","cboPlantSite","GSCM.Windows.Forms.Controls.UsrCheckedList","usrLayoutControl2","38"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","cboDivision","GSCM.Windows.Forms.Controls.UsrCombo","usrLayoutControl2","39"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","txtMaterialId","GSCM.Windows.Forms.Controls.UsrMultiLineEditor","usrLayoutControl2","40"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","btnMaterialId","GSCM.Windows.Forms.Controls.UsrButton","usrLayoutControl2","41"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","txtNickName","DevExpress.XtraEditors.TextEdit","usrLayoutControl2","42"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","txtModelId","GSCM.Windows.Forms.Controls.UsrMultiLineEditor","usrLayoutControl2","43"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","layoutControlGroup2","DevExpress.XtraLayout.LayoutControlGroup","","44"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","PlanSite","DevExpress.XtraLayout.LayoutControlItem","","45"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","Division","DevExpress.XtraLayout.LayoutControlItem","","46"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","MaterialID","DevExpress.XtraLayout.LayoutControlItem","","47"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","layoutControlItem5","DevExpress.XtraLayout.LayoutControlItem","","48"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","NickName","DevExpress.XtraLayout.LayoutControlItem","","49"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","layoutControlItem4","DevExpress.XtraLayout.LayoutControlItem","","50"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","ModelId","DevExpress.XtraLayout.LayoutControlItem","","51"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","emptySpaceItem1","DevExpress.XtraLayout.EmptySpaceItem","","52"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","spdMain","FarPoint.Win.Spread.FpSpread","this","53"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","spdMain_Sheet1","FarPoint.Win.Spread.SheetView","","54"
```

### FILE props.csv (77 rows)
```csv
"variant","file","class","member","line","target","prop","value"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","72","usrLayoutControl1","Dock","System.Windows.Forms.DockStyle.Fill"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","76","usrLayoutControl1","Size","new System.Drawing.Size(657, 184)"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","85","layoutControlGroup1","Size","new System.Drawing.Size(657, 184)"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","90","usrConditionPanel1","Dock","System.Windows.Forms.DockStyle.Top"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","93","usrConditionPanel1","Size","new System.Drawing.Size(985, 50)"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","95","usrConditionPanel1","UsrPanelType","GSCM.Windows.Forms.Controls.UsrConditionPanel.PanelType.HidePanel"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","104","usrLayoutControl2","Dock","System.Windows.Forms.DockStyle.Fill"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","108","usrLayoutControl2","Size","new System.Drawing.Size(985, 50)"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","110","usrLayoutControl2","Text","""usrLayoutControl2"""
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","142","txtMaterialId","Size","new System.Drawing.Size(150, 21)"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","178","clbDivisionId","Size","new System.Drawing.Size(141, 21)"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","218","clbPlantSiteId","Size","new System.Drawing.Size(147, 21)"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","252","btnButtonList","Size","new System.Drawing.Size(175, 26)"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","291","layoutControlGroup2","Size","new System.Drawing.Size(985, 50)"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","296","layoutControlItem1","Control","this.btnButtonList"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","299","layoutControlItem1","Size","new System.Drawing.Size(179, 30)"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","305","lblPlantSite","Control","this.clbPlantSiteId"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","310","lblPlantSite","Size","new System.Drawing.Size(216, 30)"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","311","lblPlantSite","Text","""Plant Site"""
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","318","lblDivision","Control","this.clbDivisionId"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","321","lblDivision","Size","new System.Drawing.Size(189, 30)"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","322","lblDivision","Text","""Division"""
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","329","lbMaterialID","Control","this.txtMaterialId"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","333","lbMaterialID","Size","new System.Drawing.Size(208, 30)"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","334","lbMaterialID","Text","""Material"""
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","344","emptySpaceItem1","Size","new System.Drawing.Size(173, 30)"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","350","spdMain","Dock","System.Windows.Forms.DockStyle.Fill"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","355","spdMain","Size","new System.Drawing.Size(985, 524)"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","407","this","Text","""Item by DivisionPopup"""
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","InitControls","188","txtMaterialId","Text","sMaterial"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","InitControls","190","clbDivisionId","Enabled","false"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","InitControls","191","clbPlantSiteId","Enabled","false"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","79","usrLayoutControl1","Dock","System.Windows.Forms.DockStyle.Fill"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","83","usrLayoutControl1","Size","new System.Drawing.Size(657, 184)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","92","layoutControlGroup1","Size","new System.Drawing.Size(657, 184)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","97","usrConditionPanel1","Dock","System.Windows.Forms.DockStyle.Top"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","100","usrConditionPanel1","Size","new System.Drawing.Size(1093, 41)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","102","usrConditionPanel1","UsrPanelType","GSCM.Windows.Forms.Controls.UsrConditionPanel.PanelType.HidePanel"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","114","usrLayoutControl2","Dock","System.Windows.Forms.DockStyle.Fill"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","118","usrLayoutControl2","Size","new System.Drawing.Size(1093, 41)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","120","usrLayoutControl2","Text","""usrLayoutControl2"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","151","btnModelId","Size","new System.Drawing.Size(28, 25)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","189","cboPlantSite","Size","new System.Drawing.Size(138, 21)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","228","cboDivision","Size","new System.Drawing.Size(110, 20)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","262","txtMaterialId","Size","new System.Drawing.Size(121, 21)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","295","btnMaterialId","Size","new System.Drawing.Size(39, 25)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","305","txtNickName","Size","new System.Drawing.Size(134, 20)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","339","txtModelId","Size","new System.Drawing.Size(115, 21)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","358","layoutControlGroup2","Size","new System.Drawing.Size(1093, 49)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","363","PlanSite","Control","this.cboPlantSite"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","366","PlanSite","Size","new System.Drawing.Size(199, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","367","PlanSite","Text","""Plant Site"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","374","Division","Control","this.cboDivision"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","378","Division","Size","new System.Drawing.Size(135, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","379","Division","Text","""Div"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","386","MaterialID","Control","this.txtMaterialId"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","390","MaterialID","Size","new System.Drawing.Size(185, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","391","MaterialID","Text","""Material"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","396","layoutControlItem5","Control","this.btnMaterialId"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","402","layoutControlItem5","Size","new System.Drawing.Size(43, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","404","layoutControlItem5","Text","""layoutControlItem4"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","410","NickName","Control","this.txtNickName"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","413","NickName","Size","new System.Drawing.Size(198, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","414","NickName","Text","""Nick Name"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","419","layoutControlItem4","Control","this.btnModelId"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","422","layoutControlItem4","Size","new System.Drawing.Size(32, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","428","ModelId","Control","this.txtModelId"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","432","ModelId","Size","new System.Drawing.Size(179, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","433","ModelId","Text","""Model"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","441","emptySpaceItem1","Size","new System.Drawing.Size(102, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","447","spdMain","Dock","System.Windows.Forms.DockStyle.Fill"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","452","spdMain","Size","new System.Drawing.Size(1093, 533)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","503","this","Text","""SSP0024_ShipmentMasterElectrode"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SetChangedControl","194","txtMaterialId","Text",""""""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SetChangedControl","195","txtModelId","Text",""""""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","BtnMaterialId_Click","746","txtMaterialId","Text","sMaterialId"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","BtnModelId_Click","767","txtModelId","Text","sModelId"
```

### FILE grid_effective.csv (36 rows)
```csv
"sheet","sheet_rule","column","label","source","40","81","81_HD","81_HG","81_HM","81_ST","81_UC","82","EE","EE_HD","EE_HG","EE_HM","EE_ST","EE_UC"
"Project","코드 하드코딩 전용(메타 없음)","CELL_TYPE","Cell Type","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"Project","코드 하드코딩 전용(메타 없음)","DIVISION_ID","division","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"Project","코드 하드코딩 전용(메타 없음)","DIVISION_NAME","division","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"Project","코드 하드코딩 전용(메타 없음)","ELECTRODE_TYPE","Electrode Type","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"Project","코드 하드코딩 전용(메타 없음)","ITEM_UOM","UOM","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"Project","코드 하드코딩 전용(메타 없음)","MATERIAL_ID","Material","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"Project","코드 하드코딩 전용(메타 없음)","MODEL_ID","Model","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"Project","코드 하드코딩 전용(메타 없음)","NICK_NAME","Nick Name","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"Project","코드 하드코딩 전용(메타 없음)","PLANT_SITE_CODE","Plant Site Code","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"Project","코드 하드코딩 전용(메타 없음)","PLANT_SITE_ID","Plant Site","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"Project","코드 하드코딩 전용(메타 없음)","UOM_CONVERT_IN_TACT_TIME","Pancake (m/cell)","CODE","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가","코드추가"
"Ship Master Elec","META+코드연결","BOX_PER_CUT","Box/Cut*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","BUILDING","Building*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","BUILDING_DESC","Building Desc.","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","CELL_TYPE","Cell Type","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","CREATED_BY","Created By","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","CREATION_DATE","Creation Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","DIVISION_ID","Div*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","DOM_EXP_TYPE_CODE","DOM/EXP.*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","ELECTRODE_TYPE","Electrode Type","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","ITEM_UOM","UOM","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","LAST_UPDATE_DATE","Last Update Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","LAST_UPDATED_BY","Last Updated By","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","MATERIAL_ID","Material*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","MODEL_ID","Model","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","NICK_NAME","Nick Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","PACKAGE_TYPE_CODE","Package Type*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","PC_ROLL_LENGTH","Pancake Roll Length","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","PLANT_SITE_CODE","Plant Site Code","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","PLANT_SITE_ID","Plant Site*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","POST_OPER","Post Oper.*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","POST_OPER_LT","Post Oper.LT(Day)","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","REMARKS","Remarks","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","STEELCRATE_PER_CUT","Steelcrate/Cut*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","STEELRACK_PER_CUT","Steelrack/Cut*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Ship Master Elec","META+코드연결","UOM_CONVERT_IN_TACT_TIME","Pancake (m/cell)","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
```

### FILE grid_code.csv (35 rows)
```csv
"variant","file","class","member","line","sheet_hint","kind","api","source","header","field","columns","args","arg_names","conditions","raw"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","CreateSpread","202","Project","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ Project ¦ Project ¦ 1 ¦ 1 ¦ 30","","","spdMain ¦ SpdSheet.shtMain ¦ SpdSheet.shtMain ¦ 1 ¦ 1 ¦ 30"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","CreateSpread","203","Project","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ {?spdMain.ActiveSheetIndex}","","","spdMain.Name ¦ spdMain.ActiveSheetIndex"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","CreateSpread","204","Project","SHEET","ChangeSheet","EXPR","","","","","","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","InitSpread","211","","SHEET","InitSheet","EXPR","","","","{?siMain.SheetName}","","","siMain.SheetName"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","InitSpread","214","","COLUMN","AddTextColumn","HARDCODED","division","DIVISION_ID","","division ¦ DIVISION_ID ¦ {?FPMerge.None} ¦ 60 ¦ {?true} ¦ {?FPHAlign.Center} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","","DefColumnsLabel.DivisionName ¦ DefColumns.Division ¦ FPMerge.None ¦ 60 ¦ true ¦ FPHAlign.Center ¦ FPVAlign.Center"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","InitSpread","215","","COLUMN","AddTextColumn","HARDCODED","division","DIVISION_NAME","","division ¦ DIVISION_NAME ¦ {?FPMerge.None} ¦ 80 ¦ {?false}","sHeaderText,sFieldName,merge,fWidth,bVisible","","DefColumnsLabel.DivisionName ¦ DefColumns.DivisionName ¦ FPMerge.None ¦ 80 ¦ false"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","InitSpread","216","","COLUMN","AddTextColumn","HARDCODED","Plant Site Code","PLANT_SITE_CODE","","Plant Site Code ¦ PLANT_SITE_CODE ¦ {?FPMerge.None} ¦ 80 ¦ {?true}","sHeaderText,sFieldName,merge,fWidth,bVisible","","DefColumnsLabel.PlantSiteCode ¦ DefColumns.PlantSiteCode ¦ FPMerge.None ¦ 80 ¦ true"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","InitSpread","217","","COLUMN","AddTextColumn","HARDCODED","Plant Site","PLANT_SITE_ID","","Plant Site ¦ PLANT_SITE_ID ¦ {?FPMerge.None} ¦ 80 ¦ {?true} ¦ {?FPHAlign.Center} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","","DefColumnsLabel.PlantSiteId ¦ DefColumns.PlantSiteId ¦ FPMerge.None ¦ 80 ¦ true ¦ FPHAlign.Center ¦ FPVAlign.Center"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","InitSpread","218","","COLUMN","AddTextColumn","HARDCODED","Material","MATERIAL_ID","","Material ¦ MATERIAL_ID ¦ {?FPMerge.None} ¦ 100 ¦ {?true} ¦ {?FPHAlign.Center} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","","DefColumnsLabel.MaterialId ¦ DefColumns.MaterialId ¦ FPMerge.None ¦ 100 ¦ true ¦ FPHAlign.Center ¦ FPVAlign.Center"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","InitSpread","219","","COLUMN","AddTextColumn","HARDCODED","Model","MODEL_ID","","Model ¦ MODEL_ID ¦ {?FPMerge.None} ¦ 150 ¦ {?true} ¦ {?FPHAlign.Center} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","","DefColumnsLabel.ModelId ¦ DefColumns.ModelId ¦ FPMerge.None ¦ 150 ¦ true ¦ FPHAlign.Center ¦ FPVAlign.Center"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","InitSpread","220","","COLUMN","AddTextColumn","HARDCODED","Cell Type","CELL_TYPE","","Cell Type ¦ CELL_TYPE ¦ {?FPMerge.None} ¦ 80 ¦ {?true} ¦ {?FPHAlign.Center} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","","DefColumnsLabel.CellType ¦ DefColumns.CellType ¦ FPMerge.None ¦ 80 ¦ true ¦ FPHAlign.Center ¦ FPVAlign.Center"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","InitSpread","221","","COLUMN","AddTextColumn","HARDCODED","Nick Name","NICK_NAME","","Nick Name ¦ NICK_NAME ¦ {?FPMerge.None} ¦ 150 ¦ {?true} ¦ {?FPHAlign.Center} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","","DefColumnsLabel.NickName ¦ DefColumns.NickName ¦ FPMerge.None ¦ 150 ¦ true ¦ FPHAlign.Center ¦ FPVAlign.Center"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","InitSpread","222","","COLUMN","AddTextColumn","HARDCODED","Electrode Type","ELECTRODE_TYPE","","Electrode Type ¦ ELECTRODE_TYPE ¦ {?FPMerge.None} ¦ 80 ¦ {?true} ¦ {?FPHAlign.Center} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","","DefColumnsLabel.ElectrodeType ¦ DefColumns.ElectrodeType ¦ FPMerge.None ¦ 80 ¦ true ¦ FPHAlign.Center ¦ FPVAlign.Center"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","InitSpread","223","","COLUMN","AddTextColumn","HARDCODED","UOM","ITEM_UOM","","UOM ¦ ITEM_UOM ¦ {?FPMerge.None} ¦ 60 ¦ {?true} ¦ {?FPHAlign.Center} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,fph,fpv","","DefColumnsLabel.ITEM_UOM ¦ DefColumns.ItemUOM ¦ FPMerge.None ¦ 60 ¦ true ¦ FPHAlign.Center ¦ FPVAlign.Center"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs","SSP0024_ItembyDivisionPopup","InitSpread","224","","COLUMN","AddTextColumn","HARDCODED","Pancake (m/cell)","UOM_CONVERT_IN_TACT_TIME","","Pancake (m/cell) ¦ UOM_CONVERT_IN_TACT_TIME ¦ {?FPMerge.None} ¦ 120 ¦ {?true}","sHeaderText,sFieldName,merge,fWidth,bVisible","","DefColumnsLabel.UomConvertInTactTime ¦ DefColumns.UomConvertInTactTime ¦ FPMerge.None ¦ 120 ¦ true"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","373","","OVERRIDE","set:HorizontalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellHorizontalAlignment.General}","HorizontalAlignment","","FarPoint.Win.Spread.CellHorizontalAlignment.General"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","374","","OVERRIDE","set:NoteIndicatorColor","EXPR","","","","{?System.Drawing.Color.Red}","NoteIndicatorColor","","System.Drawing.Color.Red"
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","375","","OVERRIDE","set:Parent","HARDCODED","","","","ColumnHeaderDefaultEnhanced","Parent","","""ColumnHeaderDefaultEnhanced"""
"only","06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs","SSP0024_ItembyDivisionPopup","InitializeComponent","376","","OVERRIDE","set:VerticalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellVerticalAlignment.General}","VerticalAlignment","","FarPoint.Win.Spread.CellVerticalAlignment.General"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","CreateSpread","206","Ship Master Elec","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ Ship Master Elec ¦ Ship Master Elec ¦ 1 ¦ 1 ¦ 30","","","spdMain ¦ SpdSheet.shtMain ¦ SpdSheet.shtMain ¦ 1 ¦ 1 ¦ 30"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","CreateSpread","207","Ship Master Elec","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ {?spdMain.ActiveSheetIndex}","","","spdMain.Name ¦ spdMain.ActiveSheetIndex"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","CreateSpread","208","Ship Master Elec","SHEET","ChangeSheet","EXPR","","","","","","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","InitSpread","215","","SHEET","InitSheet","EXPR","","","","{?siMain.SheetName}","","","siMain.SheetName"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","InitSpread","221","","META_BUILD","SetSheetHeaderColumn","EXPR","","","","{?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} || {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)} ¦ 1","siObj,iColumnHeaderRowCount","","siMain ¦ 1"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","EditButton","252","","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ {?fps.ActiveSheetIndex}","","","spdMain.Name ¦ fps.ActiveSheetIndex"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","InsertRow","374","","OTHER","SetCellTypeCombo","EXPR","","","DIVISION_ID","{?siMain.ActiveRowIndex} ¦ {?siMain.GetColumnIndex(DefColumns.DIVISION_ID)} ¦ {?new DataTable()}","iRow,iCol,dt","if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.SheetName == ""Ship Master Elec"")","siMain.ActiveRowIndex ¦ siMain.GetColumnIndex(DefColumns.DIVISION_ID) ¦ dtMyDivisionIns"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","InsertRow","375","","OTHER","SetCellTypeCombo","EXPR","","","PLANT_SITE_ID","{?siMain.ActiveRowIndex} ¦ {?siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)} ¦ {?Data.Common(Data.Type.PlantSiteByFactoryEEOperation, false, ""40,81,82,81_UC"")}","iRow,iCol,dt","if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.SheetName == ""Ship Master Elec"")","siMain.ActiveRowIndex ¦ siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID) ¦ dtPlantSiteByFactoryForSpread"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","InsertRow","376","","OTHER","SetCellTypeCombo","EXPR","","","POST_OPER","{?siMain.ActiveRowIndex} ¦ {?siMain.GetColumnIndex(DefColumns.POST_OPER)} ¦ {?Data.Common(Data.Type.ElectrodePostOperCode, false, """", """")}","iRow,iCol,dt","if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.SheetName == ""Ship Master Elec"")","siMain.ActiveRowIndex ¦ siMain.GetColumnIndex(DefColumns.POST_OPER) ¦ dtElectrodePostOperCode"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","InsertRow","377","","OTHER","SetCellTypeCombo","EXPR","","","BUILDING","{?siMain.ActiveRowIndex} ¦ {?siMain.GetColumnIndex(DefColumns.BUILDING)} ¦ {?Data.Common(Data.Type.BuildingForShipMasterElec, false, """","""")}","iRow,iCol,dt","if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.SheetName == ""Ship Master Elec"")","siMain.ActiveRowIndex ¦ siMain.GetColumnIndex(DefColumns.BUILDING) ¦ dtBuilding"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SpdMain_ClipboardPasted","700","","OTHER","SetCellTypeCombo","EXPR","","","PLANT_SITE_ID","{?e.CellRange.Row} ¦ {?siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)} ¦ {?new DataTable()}","iRow,iCol,dt","for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(rDivisionID != """")","iRow ¦ siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID) ¦ dtEmpty"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SetCellCombo","852","","OTHER","SetCellTypeCombo","EXPR","","","","{p:nRow} ¦ {p:nCol} ¦ {p:dtRstDataTable} || {?new DataTable()}","iRow,iCol,dt","if("""" != pdivision)","nRow ¦ nCol ¦ dtRstDataTable"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","469","","OVERRIDE","set:HorizontalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellHorizontalAlignment.General}","HorizontalAlignment","","FarPoint.Win.Spread.CellHorizontalAlignment.General"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","470","","OVERRIDE","set:NoteIndicatorColor","EXPR","","","","{?System.Drawing.Color.Red}","NoteIndicatorColor","","System.Drawing.Color.Red"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","471","","OVERRIDE","set:Parent","HARDCODED","","","","ColumnHeaderDefaultEnhanced","Parent","","""ColumnHeaderDefaultEnhanced"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs","SSP0024_ShipmentMasterElectrode","InitializeComponent","472","","OVERRIDE","set:VerticalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellVerticalAlignment.General}","VerticalAlignment","","FarPoint.Win.Spread.CellVerticalAlignment.General"
```

### FILE meta_reads.csv (20 rows)
```csv
"variant","file","class","member","line","receiver","column","via"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","<field:dtMyDivision>","37","UserInfoContext.Current","NowGroupID","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","DefineProperty","136","dr","CODE","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","DefineProperty","147","drRow","CODE","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","DefineProperty","147","dr","CODE","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","DefineProperty","148","drRow","NAME","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","DefineProperty","148","dr","CODE","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","DefineProperty","156","drAllRow","CODE","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","DefineProperty","157","drAllRow","NAME","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","Re_Design","357","c","DIVISION_ID","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SpdMain_ComboSelChange","612","c","CODE","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SpdMain_ComboSelChange","616","row","DIVISION_ID","Field"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SpdMain_ComboSelChange","617","row","CODE","Field"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SpdMain_ComboSelChange","621","drOperLT","POST_OPER_LT","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SetCellCombo","838","drRow","CODE","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SetCellCombo","838","dr","CODE","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SetCellCombo","839","drRow","NAME","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SetCellCombo","839","dr","NAME","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SetCellCombo","846","drRow","CODE","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","SetCellCombo","847","drRow","NAME","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs","SSP0024_ShipmentMasterElectrode","GetSelectedListName","865","dt.Rows[i]","CODE","[]"
```

### FILE commented_calls.csv (0 rows)
```csv
"variant","file","line","kind","candidate","key","status"
```
