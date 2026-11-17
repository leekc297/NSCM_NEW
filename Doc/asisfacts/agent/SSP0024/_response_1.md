=== FILE: analysis.md ===
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

=== FILE: source_links.md ===
# SSP0024 소스 링크 (파일·줄 기준)

> 경로 기준: AS-IS GSCM 소스 루트 아래 `06.UIL/GSCM.SSP.Plan.UIL/`. 줄 번호는 Fact Pack 추출값입니다.
> 약어: **MAIN** = `06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs`, **MAIN.D** = `…/SSP0024_ShipmentMasterElectrode.Designer.cs`, **POP** = `06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs`, **POP.D** = `…/Popup/SSP0024_ItembyDivisionPopup.Designer.cs`

## 1. 엔드포인트 호출 지점 (전체 13건)
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [POP:267](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L267) | FindData | 267 | `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` (fox, MATCH) |
| [POP:405](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L405) | GetDivision | 405 | `SCM.SCM0001_GET_DIVISION` (fox, MATCH) |
| [POP:415](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L415) | GetDivisionbyPlantSiteCode | 415 | `biz:CommonData.CommonDataList` [code=PlantSiteByDivision] (Data.Common → Data.CallBizCommonData) |
| [MAIN:37](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L37) | `<field:dtMyDivision>` | 37 | `biz:CommonData.CommonDataList` [code=MyDivision]. `UserInfoContext.Current["NowGroupID"]`를 읽음 |
| [MAIN:41](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L41) | `<field:dtPlantSiteByFactoryForSpread>` | 41 | `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation] |
| [MAIN:49](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L49) | `<field:dtElectrodePostOperCode>` | 49 | `biz:CommonData.CommonDataList` [code=ElectrodePostOperCode] |
| [MAIN:51](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L51) | `<field:dtDomExpTypeCode>` | 51 | `biz:CommonData.CommonDataList` [code=DomExpTypeCode] |
| [MAIN:52](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L52) | `<field:dtBuilding>` | 52 | `biz:CommonData.CommonDataList` [code=BuildingForShipMasterElec] |
| [MAIN:55](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L55) | `<field:dtElectrodePackageType>` | 55 | `biz:CommonData.CommonDataList` [code=ElectrodePackageType] |
| [MAIN:191](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L191) | SetChangedControl | 191 | `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation] |
| [MAIN:316](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L316) | FindData | 316 | `SSP.SSP0024_GET_SHIP_MASTER` (fox, MATCH) |
| [MAIN:467](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L467) | SaveData | 467 | `SSP.SSP0024_SAVE_SHIP_MASTER` (fox, MATCH) |
| [MAIN:883](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L883) | GetSSPUserCheck | 883 | `SSP.SSP0002_GET_USER_INFO_LIST` (fox, MATCH) |

## 2. 이벤트 배선 지점
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [POP.D:184](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.Designer.cs#L184) | InitializeComponent | 184 | `this.clbDivisionId.SelectedIndexChanged += clbDivision_SelectedIndexChanged` |
| [POP.D:277](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.Designer.cs#L277) | InitializeComponent | 277 | `this.btnButtonList.UsrButtonList_Click_Detected += btnButtonList_UsrButtonList_Click_Detected` |
| [POP.D:357](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.Designer.cs#L357) | InitializeComponent | 357 | `this.spdMain.CellDoubleClick += spdMain_CellDoubleClick` |
| [POP:156](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L156) | .ctor | 156 | `this.Load += Form_Load` |
| [MAIN:109](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L109) | .ctor | 109 | `this.Load += Form_Load` |
| [MAIN:177](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L177) | InitControls | 177 | `cboDivision.SelectedIndexChanged += ClbDivision_SelectedIndexChanged` |
| [MAIN:178](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L178) | InitControls | 178 | `spdMain.CellClick += SpdMain_CellClick` |
| [MAIN:179](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L179) | InitControls | 179 | `spdMain.ComboSelChange += SpdMain_ComboSelChange` |
| [MAIN:180](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L180) | InitControls | 180 | `spdMain.ClipboardPasted += SpdMain_ClipboardPasted` |
| [MAIN:181](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L181) | InitControls | 181 | `spdMain.KeyPress += SpdMain_KeyPress` |
| [MAIN:183](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L183) | InitControls | 183 | `this.btnMaterialId.Click += BtnMaterialId_Click` |
| [MAIN:184](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L184) | InitControls | 184 | `this.btnModelId.Click += BtnModelId_Click` |

## 3. Grid 정의 지점
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [POP:202](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L202) | CreateSpread | 202 | AddSheet `Project` (SpdSheet.shtMain, 1, 1, 30) |
| [POP:203](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L203) | CreateSpread | 203 | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) |
| [POP:204](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L204) | CreateSpread | 204 | ChangeSheet |
| [POP:211](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L211) | InitSpread | 211 | InitSheet(siMain.SheetName) |
| [POP:214](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L214) | InitSpread | 214 | AddTextColumn DIVISION_ID (w60, visible, Center) |
| [POP:215](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L215) | InitSpread | 215 | AddTextColumn DIVISION_NAME (w80, **visible=false**) |
| [POP:216](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L216) | InitSpread | 216 | AddTextColumn PLANT_SITE_CODE (w80) |
| [POP:217](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L217) | InitSpread | 217 | AddTextColumn PLANT_SITE_ID (w80, Center) |
| [POP:218](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L218) | InitSpread | 218 | AddTextColumn MATERIAL_ID (w100, Center) |
| [POP:219](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L219) | InitSpread | 219 | AddTextColumn MODEL_ID (w150, Center) |
| [POP:220](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L220) | InitSpread | 220 | AddTextColumn CELL_TYPE (w80, Center) |
| [POP:221](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L221) | InitSpread | 221 | AddTextColumn NICK_NAME (w150, Center) |
| [POP:222](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L222) | InitSpread | 222 | AddTextColumn ELECTRODE_TYPE (w80, Center) |
| [POP:223](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L223) | InitSpread | 223 | AddTextColumn ITEM_UOM (w60, Center) |
| [POP:224](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L224) | InitSpread | 224 | AddTextColumn UOM_CONVERT_IN_TACT_TIME (w120) |
| [POP.D:373](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.Designer.cs#L373) | InitializeComponent | 373~376 | ColumnHeader 스타일 override(H/V Align General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced) |
| [MAIN:206](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L206) | CreateSpread | 206 | AddSheet `Ship Master Elec` (SpdSheet.shtMain, 1, 1, 30) |
| [MAIN:207](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L207) | CreateSpread | 207 | GetSheetInfo |
| [MAIN:208](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L208) | CreateSpread | 208 | ChangeSheet |
| [MAIN:215](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L215) | InitSpread | 215 | InitSheet(siMain.SheetName) |
| [MAIN:221](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L221) | InitSpread | 221 | `SetSheetHeaderColumn(siMain, 1)` — 메타 컬럼 생성 |
| [MAIN:252](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L252) | EditButton | 252 | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) |
| [MAIN:374](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L374) | InsertRow | 374 | SetCellTypeCombo DIVISION_ID ← dtMyDivisionIns |
| [MAIN:375](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L375) | InsertRow | 375 | SetCellTypeCombo PLANT_SITE_ID ← dtPlantSiteByFactoryForSpread |
| [MAIN:376](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L376) | InsertRow | 376 | SetCellTypeCombo POST_OPER ← dtElectrodePostOperCode |
| [MAIN:377](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L377) | InsertRow | 377 | SetCellTypeCombo BUILDING ← dtBuilding |
| [MAIN:700](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L700) | SpdMain_ClipboardPasted | 700 | SetCellTypeCombo PLANT_SITE_ID ← dtEmpty (DIVISION_ID 빈값일 때) |
| [MAIN:852](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L852) | SetCellCombo | 852 | SetCellTypeCombo(nRow, nCol, dtRstDataTable), 조건 `"" != pdivision` |
| [MAIN.D:469](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.Designer.cs#L469) | InitializeComponent | 469~472 | ColumnHeader 스타일 override(팝업과 같은 4항목) |

## 4. 메타·데이터 컬럼 읽기 / 컨트롤 값 변경
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [MAIN:136](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L136) | DefineProperty | 136 | `dr["CODE"]` |
| [MAIN:147](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L147) | DefineProperty | 147~148 | `drRow["CODE"]`, `drRow["NAME"]`, `dr["CODE"]` |
| [MAIN:156](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L156) | DefineProperty | 156~157 | `drAllRow["CODE"]`, `drAllRow["NAME"]` |
| [MAIN:189](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L189) | SetChangedControl | 189 | GetCheckedListValue (CODE) |
| [MAIN:194](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L194) | SetChangedControl | 194~195 | `txtMaterialId.Text = ""`, `txtModelId.Text = ""` |
| [MAIN:282](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L282) | SaveButton | 282 | SaveData 호출(4-2절은 PersonalSettingPopup.SaveData로 매핑 — 확인 필요) |
| [MAIN:301](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L301) | FindData | 301~302 | GetCheckedListValue ×2 |
| [MAIN:355](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L355) | Re_Design | 355~357 | GetCheckedListValue, `c["DIVISION_ID"]` |
| [MAIN:379](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L379) | InsertRow | 379 | GetCheckedListValue |
| [MAIN:612](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L612) | SpdMain_ComboSelChange | 612~621 | `c["CODE"]`, `row.Field("DIVISION_ID")`, `row.Field("CODE")`, `drOperLT["POST_OPER_LT"]` |
| [MAIN:746](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L746) | BtnMaterialId_Click | 746 | `txtMaterialId.Text = sMaterialId` |
| [MAIN:767](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L767) | BtnModelId_Click | 767 | `txtModelId.Text = sModelId` |
| [MAIN:838](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L838) | SetCellCombo | 838~847 | `drRow/dr["CODE"]`, `drRow/dr["NAME"]` |
| [MAIN:865](06.UIL/GSCM.SSP.Plan.UIL/SSP0024_ShipmentMasterElectrode.cs#L865) | GetSelectedListName | 865 | `dt.Rows[i]["CODE"]` |
| [POP:188](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L188) | InitControls | 188 | `txtMaterialId.Text = sMaterial` |
| [POP:190](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0024_ItembyDivisionPopup.cs#L190) | InitControls | 190~191 | `clbDivisionId.Enabled = false`, `clbPlantSiteId.Enabled = false` |

=== FILE: web_components.md ===
# SSP0024 Web 컴포넌트 매핑 (React + Wijmo)

> 라벨은 props.csv의 LayoutControlItem.Text 원문을 그대로 옮겼습니다. 아래 React/Wijmo 컴포넌트는 매핑 **후보**이며, TO-BE 공용 컴포넌트 이름은 이 Fact Pack에 없어 일반 명칭으로 적었습니다.

## 1. 메인 화면 `SSP0024_ShipmentMasterElectrode` 컨트롤 매핑
| AS-IS 컨트롤 | 유형 | LayoutItem(라벨 원문) | 크기(컨트롤 / 아이템) | 기능 사실 | TO-BE 후보 |
|---|---|---|---|---|---|
| cboPlantSite | UsrCheckedList | PlanSite → `"Plant Site"` | 138×21 / 199×29 | 데이터: PlantSiteByFactoryEEOperation(SetChangedControl:191) | 다중선택 콤보(Wijmo MultiSelect) |
| cboDivision | UsrCombo | Division → `"Div"` | 110×20 / 135×29 | SelectedIndexChanged → ClbDivision_SelectedIndexChanged → Plant Site 재조회, Material/Model 비움 | 단일 선택 콤보(Wijmo ComboBox) |
| txtMaterialId | UsrMultiLineEditor | MaterialID → `"Material"` | 121×21 / 185×29 | BtnMaterialId_Click에서 값 설정 | 멀티라인 입력 |
| btnMaterialId | UsrButton | layoutControlItem5 → `"layoutControlItem4"`(표시 여부 확인 필요) | 39×25 / 43×29 | Click → BtnMaterialId_Click | 돋보기 버튼(팝업 호출 여부 확인 필요) |
| txtNickName | TextEdit | NickName → `"Nick Name"` | 134×20 / 198×29 | - | 텍스트 입력 |
| txtModelId | UsrMultiLineEditor | ModelId → `"Model"` | 115×21 / 179×29 | BtnModelId_Click에서 값 설정 | 멀티라인 입력 |
| btnModelId | UsrButton | layoutControlItem4 (Text 없음) | 28×25 / 32×29 | Click → BtnModelId_Click | 돋보기 버튼 |
| emptySpaceItem1 | EmptySpaceItem | - | 102×29 | - | 여백 |
| usrConditionPanel1 | UsrConditionPanel | - | 1093×41, Dock=Top, PanelType=HidePanel | 조회조건 영역 | 조회조건 패널(접기 가능) |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | - | 1093×533, Dock=Fill | 시트 `Ship Master Elec` | Wijmo FlexGrid |
| (공통 버튼) | FindButton / SaveButton / EditButton | - | - | flow.csv 진입점 | 공통 툴바 버튼(메뉴 버튼 메타 기준 — 확인 필요) |

## 2. 팝업 `SSP0024_ItembyDivisionPopup` 컨트롤 매핑
| AS-IS 컨트롤 | 유형 | LayoutItem(라벨 원문) | 크기(컨트롤 / 아이템) | 기능 사실 | TO-BE 후보 |
|---|---|---|---|---|---|
| clbPlantSiteId | UsrCheckedList | lblPlantSite → `"Plant Site"` | 147×21 / 216×30 | InitControls:191 Enabled=false. 데이터: PlantSiteByDivision | 다중선택 콤보(비활성) |
| clbDivisionId | UsrCheckedList | lblDivision → `"Division"` | 141×21 / 189×30 | InitControls:190 Enabled=false. SelectedIndexChanged → Plant Site 재조회. 데이터: SCM0001_GET_DIVISION | 다중선택 콤보(비활성) |
| txtMaterialId | UsrMultiLineEditor | lbMaterialID → `"Material"` | 150×21 / 208×30 | InitControls:188 초기값 = sMaterial | 멀티라인 입력 |
| btnButtonList | UsrButtonList | layoutControlItem1 (Text 없음) | 175×26 / 179×30 | UsrButtonList_Click_Detected → FindData | 팝업 내 버튼 그룹 |
| emptySpaceItem1 | EmptySpaceItem | - | 173×30 | - | 여백 |
| usrConditionPanel1 | UsrConditionPanel | - | 985×50, Dock=Top, HidePanel | - | 조회조건 패널 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | - | 985×524, Dock=Fill | 시트 `Project`, CellDoubleClick | Wijmo FlexGrid(더블클릭 선택) |
| 폼 | - | Text `"Item by DivisionPopup"` | - | - | 모달 팝업 |

## 3. 화면 배치
- props.csv에는 SplitContainer(Orientation·SplitterDistance)가 **없습니다**. 두 화면 모두 Dock 구성(위쪽 조건 패널 Dock=Top, 아래쪽 그리드 Dock=Fill)인 **상/하 2단**입니다.

| 화면 | 상단(조건 패널) | 하단(그리드) | 상:하 비율(높이 기준 계산) |
|---|---|---|---|
| 메인 | usrConditionPanel1 1093×41 | spdMain 1093×533 | 41 : 533 ≈ 7.1% : 92.9% |
| 팝업 | usrConditionPanel1 985×50 | spdMain 985×524 | 50 : 524 ≈ 8.7% : 91.3% |

- 메인 조건 영역은 한 줄입니다. layoutControlGroup2는 1093×49이고, 아이템 높이는 모두 29입니다. 아이템 배치 순서(좌표)는 Fact Pack에 없어 **확인 필요**입니다. 컨트롤 선언 순서는 btnModelId, cboPlantSite, cboDivision, txtMaterialId, btnMaterialId, txtNickName, txtModelId입니다.
- usrLayoutControl1(657×184, Dock=Fill)은 두 화면 모두 Designer에 있습니다. 화면에서의 역할은 **확인 필요**입니다.

## 4. 시트별 Grid 컬럼

### 4-1. `Ship Master Elec` (메인 · META+코드연결 · 메타 SCM_MST_SHEET_COLUMNS 25행)
생성: InitSpread:221 `SetSheetHeaderColumn`. 메타 소비 컬럼은 COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, UPPERCASE_APPLY_FLAG, VISIBLE_FLAG, VALID_YN, ATTRIBUTE1~5입니다. 컬럼별 폭·정렬·셀 타입 값은 Fact Pack에 없어 **확인 필요**입니다.

| # | 컬럼 | 라벨(메타 원문) | 메타 판정 | 코드 셀 콤보 |
|---:|---|---|---|---|
| 1 | DIVISION_ID | `Div*` | 기본 | InsertRow:374 dtMyDivisionIns |
| 2 | PLANT_SITE_ID | `Plant Site*` | 기본 | InsertRow:375 dtPlantSiteByFactoryForSpread / Paste:700 dtEmpty |
| 3 | PLANT_SITE_CODE | `Plant Site Code` | 기본 | - |
| 4 | MATERIAL_ID | `Material*` | 기본 | - |
| 5 | MODEL_ID | `Model` | 기본 | - |
| 6 | NICK_NAME | `Nick Name` | 기본 | - |
| 7 | CELL_TYPE | `Cell Type` | 기본 | - |
| 8 | ELECTRODE_TYPE | `Electrode Type` | 기본 | - |
| 9 | ITEM_UOM | `UOM` | 기본 | - |
| 10 | UOM_CONVERT_IN_TACT_TIME | `Pancake (m/cell)` | 기본 | - |
| 11 | PC_ROLL_LENGTH | `Pancake Roll Length` | 기본 | - |
| 12 | DOM_EXP_TYPE_CODE | `DOM/EXP.*` | 기본 | 확인 필요(dtDomExpTypeCode 연결 여부) |
| 13 | PACKAGE_TYPE_CODE | `Package Type*` | 기본 | 확인 필요(dtElectrodePackageType 연결 여부) |
| 14 | POST_OPER | `Post Oper.*` | 기본 | InsertRow:376 dtElectrodePostOperCode |
| 15 | POST_OPER_LT | `Post Oper.LT(Day)` | 기본 | ComboSelChange:621에서 POST_OPER_LT 읽음 |
| 16 | BUILDING | `Building*` | 기본 | InsertRow:377 dtBuilding |
| 17 | BUILDING_DESC | `Building Desc.` | 기본 | - |
| 18 | BOX_PER_CUT | `Box/Cut*` | 기본 | - |
| 19 | STEELCRATE_PER_CUT | `Steelcrate/Cut*` | 기본 | - |
| 20 | STEELRACK_PER_CUT | `Steelrack/Cut*` | 기본 | - |
| 21 | REMARKS | `Remarks` | 기본 | - |
| 22 | CREATED_BY | `Created By` | 기본 | - |
| 23 | CREATION_DATE | `Creation Date` | 기본 | - |
| 24 | LAST_UPDATED_BY | `Last Updated By` | 기본 | - |
| 25 | LAST_UPDATE_DATE | `Last Update Date` | 기본 | - |

> 위 표의 컬럼 순서는 grid_effective.csv 행 순서(알파벳순)를 그대로 따른 것이 아니라 업무 그룹별로 다시 묶은 것입니다. 실제 표시 순서(메타 정렬 컬럼)는 Fact Pack에 없어 **확인 필요**입니다.

### 4-2. `Project` (팝업 · 코드 하드코딩 전용, 메타 없음)
| # | 컬럼 | 헤더 원문 | 폭 | 표시 | 정렬 |
|---:|---|---|---:|---|---|
| 1 | DIVISION_ID | `division` (DefColumnsLabel.DivisionName) | 60 | true | Center/Center |
| 2 | DIVISION_NAME | `division` (DefColumnsLabel.DivisionName) | 80 | **false** | - |
| 3 | PLANT_SITE_CODE | `Plant Site Code` | 80 | true | (지정 없음) |
| 4 | PLANT_SITE_ID | `Plant Site` | 80 | true | Center/Center |
| 5 | MATERIAL_ID | `Material` | 100 | true | Center/Center |
| 6 | MODEL_ID | `Model` | 150 | true | Center/Center |
| 7 | CELL_TYPE | `Cell Type` | 80 | true | Center/Center |
| 8 | NICK_NAME | `Nick Name` | 150 | true | Center/Center |
| 9 | ELECTRODE_TYPE | `Electrode Type` | 80 | true | Center/Center |
| 10 | ITEM_UOM | `UOM` | 60 | true | Center/Center |
| 11 | UOM_CONVERT_IN_TACT_TIME | `Pancake (m/cell)` | 120 | true | (지정 없음) |

모든 컬럼이 AddTextColumn이며 병합(FPMerge)은 None입니다.

### 4-3. Division별 표시 차이 (grid_effective 기준)
| 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `Ship Master Elec` | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |
| `Project` | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |
→ division에 따른 컬럼 표시 차이는 없습니다. (`Project`의 DIVISION_NAME bVisible=false는 division과 관계없는 코드 속성입니다.)

## 5. 시트 연결 규칙
| 시트 | 연결 규칙 | 의미 |
|---|---|---|
| `Ship Master Elec` | META+코드연결 | 코드가 AddSheet(`Ship Master Elec`)로 만든 시트에 메타(SCM_MST_SHEET_COLUMNS, PROGRAM_ID=SSP0024)를 SetSheetHeaderColumn으로 적용합니다. 셀 콤보는 코드(InsertRow·SetCellCombo·ClipboardPasted)가 덧붙입니다. |
| `Project` | 코드 하드코딩 전용(메타 없음) | 팝업에서 AddSheet(`Project`) 후 AddTextColumn 11개로 구성합니다. |
| 두 시트 공통 | ColumnHeader 스타일 OVERRIDE | Designer에서 ColumnHeaderDefaultEnhanced 기반으로 정렬 General, NoteIndicatorColor Red를 지정합니다. |

=== FILE: oracle_migration.md ===
# SSP0024 Oracle 전환 분석

> 출처: Fact Pack의 SP 참조 객체(EXEC 전이 포함)입니다. SP 본문(파라미터·로직)은 Fact Pack에 없으므로 상세 변환 내용은 **확인 필요**입니다.

## 1. 호출 SP 인벤토리
| # | SP | FoxQuery 키 | 호출 위치 | 참조 테이블/객체 | EXEC 체인 | DML |
|---:|---|---|---|---|---|---|
| 1 | `SSP0024_GET_ITEM_BY_DIVISION_POPUP` | SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP | 팝업 FindData:267 | SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE | (없음) | SELECT |
| 2 | `SCM0001_GET_DIVISION` | SCM.SCM0001_GET_DIVISION | 팝업 GetDivision:405 | SCM_MST_DIVISION | (없음) | SELECT |
| 3 | `SSP0024_GET_SHIP_MASTER` | SSP.SSP0024_GET_SHIP_MASTER | 메인 FindData:316 | SSP_MST_SHIP_MASTER_EE, SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE | (없음) | SELECT |
| 4 | `SSP0024_SAVE_SHIP_MASTER` | SSP.SSP0024_SAVE_SHIP_MASTER | 메인 SaveData:467 | SSP_MST_SHIP_MASTER_EE(MERGE), SSP_MST_SHIP_MASTER_EE_H(INSERT), SCM_SYS_LOG_BATCH(INSERT), SCM_ARR_SPL_CNT·SCM_ARR_SPL_VAL(REF) | → PR_SCM_SYS_LOG_BATCH | MERGE / INSERT |
| 5 | `SSP0002_GET_USER_INFO_LIST` | SSP.SSP0002_GET_USER_INFO_LIST | 메인 GetSSPUserCheck:883 | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | (없음) | SELECT |

SP 내부에서 참조하는 MSSQL 함수:
| SP | REF |
|---|---|
| SSP0024_GET_ITEM_BY_DIVISION_POPUP | STRING_SPLIT |
| SSP0024_GET_SHIP_MASTER | STRING_SPLIT |
| SSP0024_SAVE_SHIP_MASTER | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL (객체 유형 — 함수인지 등 — 확인 필요) |
| SCM0001_GET_DIVISION | (REF 없음) |
| SSP0002_GET_USER_INFO_LIST | (REF 없음) |

## 2. 공통코드 분기 (`biz:CommonData.CommonDataList` → UP_FX_GetCommonDataList)
| code | 호출 위치 | 처리 프로시저 | 참조 테이블 | MSSQL REF |
|---|---|---|---|---|
| MyDivision | 메인 `<field:dtMyDivision>`:37 (NowGroupID 사용) | UP_FX_GetCommonDataList | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION | - |
| PlantSiteByFactoryEEOperation | 메인 `<field:dtPlantSiteByFactoryForSpread>`:41, SetChangedControl:191 | UP_FX_GetCommonDataList | SCM_MST_SITE, SCM_MST_FACTORY_SN | STRING_SPLIT |
| ElectrodePostOperCode | 메인 `<field:dtElectrodePostOperCode>`:49 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL | STRING_SPLIT |
| DomExpTypeCode | 메인 `<field:dtDomExpTypeCode>`:51 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL | - |
| BuildingForShipMasterElec | 메인 `<field:dtBuilding>`:52 | UP_FX_GetCommonDataList | SCM_MST_FACTORY_SN, SCM_MST_SITE | STRING_SPLIT |
| ElectrodePackageType | 메인 `<field:dtElectrodePackageType>`:55 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL | - |
| PlantSiteByDivision | 팝업 GetDivisionbyPlantSiteCode:415 | UP_FX_GetCommonDataList **및** UP_FX_GetCommonDataList_SCP | SCM_MST_SITE | STRING_SPLIT |

- PlantSiteByDivision 하나만 두 프로시저(UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP)에 코드 분기가 있습니다. 실제로 어느 쪽이 호출되는지는 **확인 필요**입니다.
- 공통코드 분기에 넘기는 인자: InsertRow 원문에 `PlantSiteByFactoryEEOperation, false, "40,81,82,81_UC"`, `ElectrodePostOperCode, false, "", ""`, `BuildingForShipMasterElec, false, "",""`가 나옵니다. 나머지 code의 인자는 **확인 필요**입니다.
- ElectrodePostOperCode / DomExpTypeCode / ElectrodePackageType의 LOOKUP 마스터 키 값은 Fact Pack에 없어 **확인 필요**입니다.

## 3. FoxQuery 미등록 / 직접 호출 SP
| 구분 | 건수 | 내용 |
|---|---:|---|
| FoxQuery 미등록(MISS) | 0 | 엔드포인트 5개 모두 MATCH |
| 직접 SQL / 직접 SP 호출 | 0 | Fact Pack에 해당 항목 없음 |
| Biz 경유(BIZ_MATCH) | 7 code | `biz:CommonData.CommonDataList` → UP_FX_GetCommonDataList(_SCP) |
| 주석 처리된 호출 | 0 | commented_calls.csv 0행 |

## 4. Oracle 전환 시 확인 포인트
| # | 포인트 | 근거(사실) |
|---:|---|---|
| 1 | **STRING_SPLIT 대체**. 금지 키워드(MSSQL) 목록에 해당하므로 Oracle 구문(분할 함수 또는 계층 쿼리 등)으로 바꿔야 함 | GET_ITEM_BY_DIVISION_POPUP, GET_SHIP_MASTER, UP_FX_GetCommonDataList(_SCP) 코드분기(PlantSiteByFactoryEEOperation, PlantSiteByDivision, ElectrodePostOperCode, BuildingForShipMasterElec) |
| 2 | **SCM_ARR_SPL_CNT / SCM_ARR_SPL_VAL** 객체가 Oracle에 있는지와 시그니처 | SAVE_SHIP_MASTER REF |
| 3 | **MERGE SSP_MST_SHIP_MASTER_EE** — 키 컬럼과 MERGE 문법 차이(MSSQL MERGE → Oracle MERGE INTO ... USING ... ON) | SAVE_SHIP_MASTER |
| 4 | **이력 INSERT SSP_MST_SHIP_MASTER_EE_H** — MERGE와 같은 트랜잭션 순서인지 | SAVE_SHIP_MASTER |
| 5 | **PR_SCM_SYS_LOG_BATCH / SCM_SYS_LOG_BATCH** 로그 체인이 Oracle 공용 객체에 있는지 | SAVE_SHIP_MASTER EXEC 체인 |
| 6 | **SSP_MST_SITE_ITEM_EE_V** 뷰 전환 여부 | POPUP·GET_SHIP_MASTER 공통 참조 |
| 7 | 저장 파라미터 형식(구분자 배열 문자열로 여러 행을 넘기는지) | SCM_ARR_SPL_* 참조. 파라미터 정의는 Fact Pack에 없음 → **확인 필요** |
| 8 | 권한 SP **SSP0002_GET_USER_INFO_LIST**는 다른 화면과 공유하는 SP — 시그니처 변경 시 영향 범위 | SP 이름 접두 SSP0002 |
| 9 | **SCM0001_GET_DIVISION** 공용 SP(SCM 도메인) 재사용 | SP 이름 접두 SCM0001 |
| 10 | 공통코드 프로시저 UP_FX_GetCommonDataList / _SCP 분기 7종의 Oracle 측 구현 상태 | 코드분기 표 |

### 4-1. 난이도 (사실 근거만)
| SP | 근거 | 판단 |
|---|---|---|
| SCM0001_GET_DIVISION | 단일 테이블 SELECT, MSSQL REF 없음 | 낮음 |
| SSP0002_GET_USER_INFO_LIST | 5개 테이블 SELECT, MSSQL REF 없음 | 낮음~중간(조인 수) |
| SSP0024_GET_ITEM_BY_DIVISION_POPUP | 뷰 + 1테이블, STRING_SPLIT | 중간(STRING_SPLIT 대체) |
| SSP0024_GET_SHIP_MASTER | 2테이블 + 뷰, STRING_SPLIT | 중간(STRING_SPLIT 대체) |
| SSP0024_SAVE_SHIP_MASTER | MERGE + 이력 INSERT + 로그 SP EXEC + 배열 분할 객체 2종 | 상대적으로 높음(전환 대상 요소 수 최다) |

> 줄 수·커서·동적 SQL·임시테이블 사용 여부 같은 SP 본문 정보는 Fact Pack에 없습니다. 위 판단은 참조 객체 수와 MSSQL REF만 근거로 했습니다.

=== FILE: tobe_design.md ===
# SSP0024 TO-BE 설계 입력 (Shipment Master Electrode)

> Fact Pack 기반 TO-BE 설계 후보입니다. 확정 사항이 아닌 것은 '미확정'에 모았습니다.

## 1. 조회조건 (컨트롤 기준)

### 1-1. 메인
| 라벨(원문) | AS-IS 컨트롤 | 유형 | 데이터 / 연동 | TO-BE 후보 |
|---|---|---|---|---|
| `Plant Site` | cboPlantSite | UsrCheckedList(다중) | PlantSiteByFactoryEEOperation (Div 변경 시 재조회) | 다중선택 콤보 |
| `Div` | cboDivision | UsrCombo(단일) | 변경 시 → Plant Site 재조회, Material·Model 비움(SetChangedControl:191·194·195). 콤보 원천 데이터 = 확인 필요 | 단일 콤보 |
| `Material` | txtMaterialId + btnMaterialId | UsrMultiLineEditor + 버튼 | 버튼 클릭 → `txtMaterialId.Text = sMaterialId` | 멀티 입력 + 팝업 버튼 |
| `Nick Name` | txtNickName | TextEdit | - | 텍스트 입력 |
| `Model` | txtModelId + btnModelId | UsrMultiLineEditor + 버튼 | 버튼 클릭 → `txtModelId.Text = sModelId` | 멀티 입력 + 팝업 버튼 |

FindData:301~302에서 GetCheckedListValue를 2회 호출합니다. SSP0024_GET_SHIP_MASTER에 넘기는 파라미터 목록은 **미확정**입니다.

### 1-2. 팝업 (Item by DivisionPopup)
| 라벨(원문) | AS-IS 컨트롤 | 상태 | 데이터 |
|---|---|---|---|
| `Division` | clbDivisionId | Enabled=false | SCM.SCM0001_GET_DIVISION |
| `Plant Site` | clbPlantSiteId | Enabled=false | CommonData PlantSiteByDivision |
| `Material` | txtMaterialId | 초기값 sMaterial | - |

## 2. 액션별 호출 API 후보
| 화면 | 액션(버튼/이벤트) | AS-IS 경로 | 호출 엔드포인트 | TO-BE API 후보 |
|---|---|---|---|---|
| 메인 | 화면 로드 | Form_Load > InitControls > SetChangedControl | CommonData PlantSiteByFactoryEEOperation | 공통코드 조회 API |
| 메인 | Div 변경 | ClbDivision_SelectedIndexChanged > SetChangedControl | CommonData PlantSiteByFactoryEEOperation | 공통코드 조회 API(division 파라미터) |
| 메인 | 조회 | FindButton > FindData | SSP.SSP0024_GET_SHIP_MASTER | 조회 API → SSP0024_GET_SHIP_MASTER |
| 메인 | 저장 | SaveButton > SaveData → FindData | SSP.SSP0024_SAVE_SHIP_MASTER → SSP.SSP0024_GET_SHIP_MASTER | 저장 API → SSP0024_SAVE_SHIP_MASTER, 성공 후 재조회 |
| 메인 | 편집 | EditButton > GetSSPUserCheck | SSP.SSP0002_GET_USER_INFO_LIST | 사용자 권한 확인 API |
| 메인 | 행 추가 | InsertRow (진입 버튼 = 확인 필요) | (셀 콤보 데이터: MyDivision(Ins), PlantSiteByFactoryEEOperation "40,81,82,81_UC", ElectrodePostOperCode, BuildingForShipMasterElec) | 공통코드 조회 API ×4 (화면 로드 때 미리 받아두는 방식 검토) |
| 메인 | 셀 콤보 변경 | SpdMain_ComboSelChange | (API 호출 없음, POST_OPER_LT 등 로컬 데이터 참조) | FE 처리 |
| 메인 | 붙여넣기 | SpdMain_ClipboardPasted | (API 호출 없음) DIVISION_ID 빈값이면 PLANT_SITE_ID 콤보를 비움 | FE 처리 |
| 메인 | 셀 클릭 / 키 입력 | SpdMain_CellClick / SpdMain_KeyPress | 동작 확인 필요 | 미확정 |
| 메인 | Material/Model 버튼 | BtnMaterialId_Click / BtnModelId_Click | 직접 호출 엔드포인트 없음. 팝업 연계 여부 확인 필요 | 팝업 컴포넌트 |
| 팝업 | 로드 | Form_Load > InitControls / FindData | SCM.SCM0001_GET_DIVISION, CommonData PlantSiteByDivision, SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP | division 조회 + 공통코드 + 팝업 조회 API |
| 팝업 | Division 변경 | clbDivision_SelectedIndexChanged | CommonData PlantSiteByDivision | 공통코드 조회 API |
| 팝업 | 조회(버튼) | FindButton / btnButtonList_UsrButtonList_Click_Detected > FindData | SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP | 팝업 조회 API |
| 팝업 | 행 더블클릭 | spdMain_CellDoubleClick | (동작 확인 필요) | 선택값 반환 |

## 3. Division별 Grid 변형 요약
| 시트 | 구성 | Division별 컬럼 수 | 변형 |
|---|---|---|---|
| `Ship Master Elec` | 메타 25컬럼(전부 기본) + 코드 셀 콤보 | 14개 division 모두 25 | 컬럼 표시 변형 없음. 셀 콤보 데이터만 division 영향(PLANT_SITE_ID: `"40,81,82,81_UC"` 인자, SetCellCombo `pdivision` 조건) |
| `Project`(팝업) | 하드코딩 11컬럼 | 14개 division 모두 11 | 변형 없음. DIVISION_NAME은 bVisible=false |

## 4. 권한(C/R/U/D) 관련 사실
| 사실 | 출처 |
|---|---|
| 메뉴 권한 메타 TB_FX_GroupMenuAuth에 SSP0024 행 12건이 있음(값 내용은 미제공) | Fact Pack 8장 |
| TB_FX_MenuItemInfo 1건, TB_FX_ProgramInfo 1건, TB_FX_SearchCondition 6건, TB_FX_Favorite 3건 | Fact Pack 8장 |
| EditButton → GetSSPUserCheck → SSP0002_GET_USER_INFO_LIST(TB_FX_USER, TB_FX_USERGROUPINFO, TB_FX_GROUPINFO, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SSO_DEPT_INFO 참조) — 편집 진입 시 사용자 정보 확인 | flow.csv |
| MyDivision 공통코드가 `UserInfoContext.Current["NowGroupID"]`와 TB_FX_USERGROUPAUTHEXTENTION을 참조 — 사용자 그룹 기준 division 목록 | meta_reads.csv, 엔드포인트 표 |
| InsertRow의 셀 콤보 설정 조건 `siMain.IsLock(siMain.SheetName) == false` — 시트 잠금 상태면 행 추가 시 콤보를 설정하지 않음 | grid_code.csv 374~377 |
| 저장은 MERGE(C/U)와 이력 INSERT. 삭제(D) 처리 여부는 Fact Pack에 없음 | 엔드포인트 표 |

## 5. 미확정 사항
| # | 항목 | 필요한 확인 |
|---:|---|---|
| 1 | TB_FX_GroupMenuAuth 12행의 버튼별 권한 값 | 메타 CSV(dbmeta_dbo_TB_FX_GroupMenuAuth.csv) 확인 |
| 2 | TB_FX_SearchCondition 6행(조회조건 저장 항목) | dbmeta_dbo_TB_FX_SearchCondition.csv 확인 |
| 3 | GetSSPUserCheck 결과로 편집 가부를 판정하는 조건 | MAIN:883 주변 소스 |
| 4 | 행 추가 버튼과 InsertRow의 연결, 삭제 기능 유무 | 메인 소스 |
| 5 | DOM_EXP_TYPE_CODE / PACKAGE_TYPE_CODE 셀 콤보 설정 위치 | 메인 소스(dtDomExpTypeCode, dtElectrodePackageType 사용처) |
| 6 | SpdMain_ComboSelChange에서 POST_OPER_LT를 반영하는 대상 셀 | MAIN:612~621 |
| 7 | Material/Model 버튼이 여는 팝업(SSP0024_ItembyDivisionPopup 여부)과 넘기는 값 | MAIN:746, 767 |
| 8 | 팝업 CellDoubleClick 반환 컬럼 | POP.D:357 핸들러 |
| 9 | 메인 cboDivision 콤보 원천 데이터(MyDivision 여부) | 메인 InitControls |
| 10 | 조회·저장 SP 파라미터 정의 | SP 원문 |
| 11 | Ship Master Elec 메타 25행의 폭·정렬·셀 타입·고정·대문자 속성 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| 12 | 4-2절 SaveButton:282 → PersonalSettingPopup.SaveData 매핑의 진위 | 파서 결과 재검토 |
