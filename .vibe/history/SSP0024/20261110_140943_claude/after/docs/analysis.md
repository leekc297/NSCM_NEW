# SSP0024 As-is 분석서 — Shipment Master Electrode

> 출처: AsisFacts 정적 추출 Fact Pack(SSP0024). 이 문서는 Fact Pack에 있는 사실만 담았습니다. Fact Pack에 없는 내용은 '확인 필요'로 적었습니다.
> 주석 처리된 호출(commented_calls)은 0건입니다.

## 1. 화면 개요

| 항목 | 내용 |
|---|---|
| 화면 ID | SSP0024 |
| 도메인 | SSP (프로젝트 `GSCM.SSP.Plan.UIL`) |
| 메인 폼 클래스 | `SSP0024_ShipmentMasterElectrode` (Designer Text = `"SSP0024_ShipmentMasterElectrode"`) |
| 팝업 클래스 | `SSP0024_ItembyDivisionPopup` (Designer Text = `"Item by DivisionPopup"`) |
| Grid 구성 방식 | `HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)` |
| 시트 | `Ship Master Elec`(메인, 메타+코드 연결), `Project`(팝업, 코드 하드코딩 전용) |

### 1-1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.cs | GSCM.SSP.Plan.UIL.csproj | 902 |
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\SSP0024_ShipmentMasterElectrode.Designer.cs | GSCM.SSP.Plan.UIL.csproj | 556 |
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.cs | GSCM.SSP.Plan.UIL.csproj | 422 |
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0024_ItembyDivisionPopup.Designer.cs | GSCM.SSP.Plan.UIL.csproj | 450 |
| shared | 없음 (Fact Pack에 shared 구분 파일 없음) | - | - |
| legacy | 없음 (모든 파일이 variant `only`) | - | - |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

### 2-1. 메인 폼 `SSP0024_ShipmentMasterElectrode`
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| event:this.Load | `Form_Load` > InitControls > SetChangedControl | 191 | `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation] | BIZ_MATCH | (UP_FX_GetCommonDataList 코드분기) |
| event:cboDivision.SelectedIndexChanged | `ClbDivision_SelectedIndexChanged` > SetChangedControl | 191 | `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation] | BIZ_MATCH | (UP_FX_GetCommonDataList 코드분기) |
| button:FindButton | FindButton > FindData | 316 | `SSP.SSP0024_GET_SHIP_MASTER` | MATCH | SP SSP0024_GET_SHIP_MASTER |
| button:SaveButton | SaveButton > SaveData | 467 | `SSP.SSP0024_SAVE_SHIP_MASTER` | MATCH | SP SSP0024_SAVE_SHIP_MASTER |
| button:SaveButton | SaveButton > SaveData > FindData | 316 | `SSP.SSP0024_GET_SHIP_MASTER` | MATCH | SP SSP0024_GET_SHIP_MASTER (저장 후 재조회) |
| button:EditButton | EditButton > GetSSPUserCheck | 883 | `SSP.SSP0002_GET_USER_INFO_LIST` | MATCH | SP SSP0002_GET_USER_INFO_LIST |
| unreached(진입점 미연결) | `<field:dtMyDivision>` | 37 | `biz:CommonData.CommonDataList` [code=MyDivision] | BIZ_MATCH | - |
| unreached(진입점 미연결) | `<field:dtPlantSiteByFactoryForSpread>` | 41 | `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation] | BIZ_MATCH | - |
| unreached(진입점 미연결) | `<field:dtElectrodePostOperCode>` | 49 | `biz:CommonData.CommonDataList` [code=ElectrodePostOperCode] | BIZ_MATCH | - |
| unreached(진입점 미연결) | `<field:dtDomExpTypeCode>` | 51 | `biz:CommonData.CommonDataList` [code=DomExpTypeCode] | BIZ_MATCH | - |
| unreached(진입점 미연결) | `<field:dtBuilding>` | 52 | `biz:CommonData.CommonDataList` [code=BuildingForShipMasterElec] | BIZ_MATCH | - |
| unreached(진입점 미연결) | `<field:dtElectrodePackageType>` | 55 | `biz:CommonData.CommonDataList` [code=ElectrodePackageType] | BIZ_MATCH | - |

> 위 `unreached` 6건은 필드 초기화식(`<field:...>`)입니다. 정적 파서는 이벤트 진입점에 연결하지 못했습니다. 다만 grid_code.csv의 InsertRow(374~377) 원문 인자에서 `dtPlantSiteByFactoryForSpread`, `dtElectrodePostOperCode`, `dtBuilding`이 셀 콤보 데이터로 쓰입니다. 필드 초기화식이 실행되는 시점(인스턴스 생성 시점인지)은 **확인 필요**입니다. `dtDomExpTypeCode`, `dtElectrodePackageType`이 어디에 쓰이는지도 **확인 필요**입니다.

### 2-2. 팝업 `SSP0024_ItembyDivisionPopup`
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| event:this.Load | `Form_Load` > InitControls > GetDivision | 405 | `SCM.SCM0001_GET_DIVISION` | MATCH | SP SCM0001_GET_DIVISION |
| event:this.Load | `Form_Load` > InitControls > GetDivisionbyPlantSiteCode | 415 | `biz:CommonData.CommonDataList` [code=PlantSiteByDivision] | BIZ_MATCH | (UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP 코드분기) |
| event:this.Load | `Form_Load` > FindData | 267 | `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` | MATCH | SP SSP0024_GET_ITEM_BY_DIVISION_POPUP |
| event:this.clbDivisionId.SelectedIndexChanged | `clbDivision_SelectedIndexChanged` > GetDivisionbyPlantSiteCode | 415 | `biz:CommonData.CommonDataList` [code=PlantSiteByDivision] | BIZ_MATCH | - |
| event:this.btnButtonList.UsrButtonList_Click_Detected | `btnButtonList_UsrButtonList_Click_Detected` > FindData | 267 | `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` | MATCH | SP SSP0024_GET_ITEM_BY_DIVISION_POPUP |
| button:FindButton | FindButton > FindData | 267 | `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` | MATCH | SP SSP0024_GET_ITEM_BY_DIVISION_POPUP |

## 3. 엔드포인트 전체 표
| # | 엔드포인트 | 상태 | 호출 수 | 호출 위치(클래스.메서드:줄) | SP | 참조 객체(EXEC 전이 포함) |
|---:|---|---|---:|---|---|---|
| 1 | `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` | MATCH | 1 | ItembyDivisionPopup.FindData:267 | SSP0024_GET_ITEM_BY_DIVISION_POPUP | SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:SCM_MST_SITE, REF:STRING_SPLIT |
| 2 | `SCM.SCM0001_GET_DIVISION` | MATCH | 1 | ItembyDivisionPopup.GetDivision:405 | SCM0001_GET_DIVISION | SELECT:SCM_MST_DIVISION |
| 3 | `biz:CommonData.CommonDataList` [code=PlantSiteByDivision] | BIZ_MATCH | 1 | ItembyDivisionPopup.GetDivisionbyPlantSiteCode:415 | - | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, REF:STRING_SPLIT / UP_FX_GetCommonDataList_SCP:SELECT:SCM_MST_SITE, REF:STRING_SPLIT |
| 4 | `biz:CommonData.CommonDataList` [code=MyDivision] | BIZ_MATCH | 1 | ShipmentMasterElectrode.`<field:dtMyDivision>`:37 | - | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| 5 | `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation] | BIZ_MATCH | 2 | ShipmentMasterElectrode.`<field:dtPlantSiteByFactoryForSpread>`:41, SetChangedControl:191 | - | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, SELECT:SCM_MST_FACTORY_SN, REF:STRING_SPLIT |
| 6 | `biz:CommonData.CommonDataList` [code=ElectrodePostOperCode] | BIZ_MATCH | 1 | ShipmentMasterElectrode.`<field:dtElectrodePostOperCode>`:49 | - | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT |
| 7 | `biz:CommonData.CommonDataList` [code=DomExpTypeCode] | BIZ_MATCH | 1 | ShipmentMasterElectrode.`<field:dtDomExpTypeCode>`:51 | - | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| 8 | `biz:CommonData.CommonDataList` [code=BuildingForShipMasterElec] | BIZ_MATCH | 1 | ShipmentMasterElectrode.`<field:dtBuilding>`:52 | - | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_MST_SITE, REF:STRING_SPLIT |
| 9 | `biz:CommonData.CommonDataList` [code=ElectrodePackageType] | BIZ_MATCH | 1 | ShipmentMasterElectrode.`<field:dtElectrodePackageType>`:55 | - | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| 10 | `SSP.SSP0024_GET_SHIP_MASTER` | MATCH | 1 | ShipmentMasterElectrode.FindData:316 | SSP0024_GET_SHIP_MASTER | SELECT:SSP_MST_SHIP_MASTER_EE, SELECT:SSP_MST_SITE_ITEM_EE_V, SELECT:SCM_MST_SITE, REF:STRING_SPLIT |
| 11 | `SSP.SSP0024_SAVE_SHIP_MASTER` | MATCH | 1 | ShipmentMasterElectrode.SaveData:467 | SSP0024_SAVE_SHIP_MASTER | EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SSP_MST_SHIP_MASTER_EE_H, MERGE:SSP_MST_SHIP_MASTER_EE, INSERT:SCM_SYS_LOG_BATCH |
| 12 | `SSP.SSP0002_GET_USER_INFO_LIST` | MATCH | 1 | ShipmentMasterElectrode.GetSSPUserCheck:883 | SSP0002_GET_USER_INFO_LIST | SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_GROUPINFO, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPAUTHEXTENTION |

> InsertRow:375~377 원문에도 `Data.Common(Data.Type.PlantSiteByFactoryEEOperation, false, "40,81,82,81_UC")`, `Data.Common(Data.Type.ElectrodePostOperCode, false, "", "")`, `Data.Common(Data.Type.BuildingForShipMasterElec, false, "","")` 식이 나옵니다(grid_code.csv의 args 컬럼). 그런데 raw 컬럼에서 실제 인자는 필드 변수(`dtPlantSiteByFactoryForSpread` 등)입니다. 그래서 이 식은 필드 초기화식이 전개된 것으로 보이며, 이 위치에서 별도 호출이 일어나는지는 **확인 필요**입니다.

## 4. 이벤트 배선 표
| # | 클래스 | 대상 | 이벤트 | 핸들러 | 배선 위치 |
|---:|---|---|---|---|---|
| 1 | ItembyDivisionPopup | this.clbDivisionId | SelectedIndexChanged | `clbDivision_SelectedIndexChanged` | Designer InitializeComponent:184 |
| 2 | ItembyDivisionPopup | this.btnButtonList | UsrButtonList_Click_Detected | `btnButtonList_UsrButtonList_Click_Detected` | Designer InitializeComponent:277 |
| 3 | ItembyDivisionPopup | this.spdMain | CellDoubleClick | `spdMain_CellDoubleClick` | Designer InitializeComponent:357 |
| 4 | ItembyDivisionPopup | this | Load | `Form_Load` | .ctor:156 |
| 5 | ShipmentMasterElectrode | this | Load | `Form_Load` | .ctor:109 |
| 6 | ShipmentMasterElectrode | cboDivision | SelectedIndexChanged | `ClbDivision_SelectedIndexChanged` | InitControls:177 |
| 7 | ShipmentMasterElectrode | spdMain | CellClick | `SpdMain_CellClick` | InitControls:178 |
| 8 | ShipmentMasterElectrode | spdMain | ComboSelChange | `SpdMain_ComboSelChange` | InitControls:179 |
| 9 | ShipmentMasterElectrode | spdMain | ClipboardPasted | `SpdMain_ClipboardPasted` | InitControls:180 |
| 10 | ShipmentMasterElectrode | spdMain | KeyPress | `SpdMain_KeyPress` | InitControls:181 |
| 11 | ShipmentMasterElectrode | this.btnMaterialId | Click | `BtnMaterialId_Click` | InitControls:183 |
| 12 | ShipmentMasterElectrode | this.btnModelId | Click | `BtnModelId_Click` | InitControls:184 |

핸들러별 사실(Fact Pack 근거):
- `ClbDivision_SelectedIndexChanged`: 메인의 `cboDivision`(UsrCombo)에 배선되어 있고, SetChangedControl을 거쳐 PlantSiteByFactoryEEOperation을 조회합니다(191). SetChangedControl:194~195는 `txtMaterialId.Text = ""`, `txtModelId.Text = ""`로 값을 비웁니다. 핸들러 이름은 `Clb`로 시작하지만 배선 대상은 UsrCombo입니다.
- `SpdMain_ComboSelChange`: `c["CODE"]`(612), `row.Field("DIVISION_ID")`(616), `row.Field("CODE")`(617), `drOperLT["POST_OPER_LT"]`(621)를 읽습니다. POST_OPER_LT 값을 어느 셀에 반영하는지는 **확인 필요**입니다.
- `SpdMain_ClipboardPasted`(700): 붙여넣은 범위를 순회합니다. 열이 DIVISION_ID이고 `rDivisionID`가 빈값이면(`else!(rDivisionID != "")`) PLANT_SITE_ID 셀 콤보를 빈 DataTable(`dtEmpty`)로 설정합니다.
- `BtnMaterialId_Click`(746): `txtMaterialId.Text = sMaterialId`. `BtnModelId_Click`(767): `txtModelId.Text = sModelId`. 값을 어디서 받아오는지(SSP0024_ItembyDivisionPopup를 띄우는지 등)는 **확인 필요**입니다.
- `SpdMain_CellClick`, `SpdMain_KeyPress`, `spdMain_CellDoubleClick`(팝업): 내부 동작이 Fact Pack에 없어 **확인 필요**입니다.
- `clbDivision_SelectedIndexChanged`(팝업): GetDivisionbyPlantSiteCode를 거쳐 PlantSiteByDivision을 조회합니다(415).
- `btnButtonList_UsrButtonList_Click_Detected`(팝업): FindData를 거쳐 SSP0024_GET_ITEM_BY_DIVISION_POPUP을 호출합니다(267).
- `Form_Load`(팝업): InitControls(GetDivision, GetDivisionbyPlantSiteCode)를 실행한 뒤 FindData로 자동 조회합니다. InitControls:188 `txtMaterialId.Text = sMaterial`, :190 `clbDivisionId.Enabled = false`, :191 `clbPlantSiteId.Enabled = false`.
- `Form_Load`(메인): InitControls를 거쳐 SetChangedControl을 실행합니다(191).

## 5. Grid 구성 방식
**구성 방식: `HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)`**

| 시트 | 클래스 | 생성 | 컬럼 정의 | 연결 규칙 | 컬럼 수 |
|---|---|---|---|---|---:|
| `Ship Master Elec` | ShipmentMasterElectrode | CreateSpread:206 AddSheet(`Ship Master Elec`, 1, 1, 30) → GetSheetInfo:207 → ChangeSheet:208 | InitSpread:221 `SetSheetHeaderColumn(siMain, 1)`. 메타는 SCM_MST_SHEET_COLUMNS 25행 | META+코드연결 | 25 |
| `Project` | ItembyDivisionPopup | CreateSpread:202 AddSheet(`Project`, 1, 1, 30) → GetSheetInfo:203 → ChangeSheet:204 | InitSpread:214~224 AddTextColumn 11개(하드코딩) | 코드 하드코딩 전용(메타 없음) | 11 (DIVISION_NAME은 bVisible=false) |

> grid_effective는 `Project` 시트를 division마다 11개로 집계합니다. 하지만 grid_code 원문에서 DIVISION_NAME(215)은 `bVisible=false`입니다. 실제로 보이는 컬럼 수(10개인지)는 **확인 필요**입니다.

코드 표시 변경(OVERRIDE)은 두 Designer 모두 ColumnHeader 스타일입니다: HorizontalAlignment=General, NoteIndicatorColor=Red, Parent=`"ColumnHeaderDefaultEnhanced"`, VerticalAlignment=General. 위치는 팝업 Designer 373~376, 메인 Designer 469~472입니다.

`Ship Master Elec` 셀 콤보(코드 설정): InsertRow:374~377에서 조건 `siMain != null && siMain.IsLock(siMain.SheetName) == false` 및 `siMain.SheetName == "Ship Master Elec"`일 때 설정합니다.
| 컬럼 | 데이터 |
|---|---|
| DIVISION_ID | `dtMyDivisionIns` |
| PLANT_SITE_ID | `dtPlantSiteByFactoryForSpread` (PlantSiteByFactoryEEOperation, `"40,81,82,81_UC"`) |
| POST_OPER | `dtElectrodePostOperCode` |
| BUILDING | `dtBuilding` |
그 밖에 SetCellCombo:852(조건 `"" != pdivision`)와 ClipboardPasted:700(PLANT_SITE_ID → dtEmpty)도 셀 콤보를 설정합니다.

### 5-1. Division별 차이
| 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `Project` | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |
| `Ship Master Elec` | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |

- 메타 규칙상 모든 division에서 25컬럼이 전부 `기본`이고 `선택`은 0입니다(필수+기본/선택 = 25/0).
- 코드에 division 분기로 컬럼을 표시하거나 숨기는 변경은 없습니다(분기 판단불가 0건).
- division에 따라 달라지는 부분은 셀 콤보 데이터입니다. PLANT_SITE_ID 콤보는 `"40,81,82,81_UC"` 인자로 조회하고, SetCellCombo는 pdivision 값에 따라 동작합니다.
- 실제 SP 실행 결과와 시트를 대조하는 단계는 실행되지 않았습니다(Fact Pack 10장: "매칭되는 시트가 없습니다").

## 6. 확인 필요 항목
| # | 항목 | 근거 |
|---:|---|---|
| 1 | `<field:...>` 6건(MyDivision, PlantSiteByFactoryEEOperation, ElectrodePostOperCode, DomExpTypeCode, BuildingForShipMasterElec, ElectrodePackageType)의 실행 시점과 사용처 | flow.csv `unreached` |
| 2 | DomExpTypeCode / ElectrodePackageType 데이터가 DOM_EXP_TYPE_CODE / PACKAGE_TYPE_CODE 셀 콤보에 연결되는지 | InsertRow에는 4컬럼 콤보만 추출됨 |
| 3 | InsertRow:374 `dtMyDivisionIns`의 출처 | Fact Pack에 정의 없음 |
| 4 | 4-2절 `SaveButton:282 → PersonalSettingPopup.SaveData` 매핑(같은 클래스의 SaveData:467과 충돌 — 파서 오매핑 가능성) | Fact Pack 4-2 |
| 5 | EditButton → GetSSPUserCheck(SSP0002_GET_USER_INFO_LIST) 결과로 편집 가부를 어떻게 판단하는지 | flow.csv |
| 6 | BtnMaterialId_Click / BtnModelId_Click이 여는 팝업과 반환값 | props.csv 746, 767 |
| 7 | 팝업 spdMain_CellDoubleClick의 반환 동작 | events.csv |
| 8 | 메인 SpdMain_CellClick / SpdMain_KeyPress 동작 | events.csv |
| 9 | Project 시트에서 실제 보이는 컬럼 수(DIVISION_NAME bVisible=false) | grid_code.csv 215 |
| 10 | 메타 테이블 행(TB_FX_GroupMenuAuth 12, TB_FX_SearchCondition 6, TB_FX_Favorite 3, SCM_ADM_DB_SCRIPT_BACKUP 7) 내용 | Fact Pack 8장(파일명만 제공) |
| 11 | 메인 SetChangedControl:189, FindData:301/302, Re_Design:355, InsertRow:379의 GetCheckedListValue 대상 컨트롤 | Fact Pack 4-2 |
