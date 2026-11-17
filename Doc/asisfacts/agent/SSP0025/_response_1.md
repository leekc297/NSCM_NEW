=== FILE: analysis.md ===
# SSP0025 As-is 분석서 — Shipment Requestor PIC

> 출처: AsisFacts 정적 추출 Fact Pack(SSP0025). Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다.
> 주석 처리된 호출(commented_calls)은 0건입니다. 아래 표는 모두 활성 코드 기준입니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0025 |
| 도메인 | SSP |
| 메인 클래스 | `SSP0025_ShipmentRequestorPIC` |
| 팝업 클래스 | `SSP0025_ItembyDivisionPopup` (Form Text = `"Item by DivisionPopup"`, Designer:456) |
| 프로젝트 | `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj` |
| 메인 Form Text | `"SSP0014_ShipmentModelPIC"` (SSP0025_ShipmentRequestorPIC.Designer.cs:539). 화면 ID(SSP0025)와 다릅니다. 실행 시 제목을 덮어쓰는 코드가 있는지는 **확인 필요** |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 |
|---|---|---:|
| current(only) | `06.UIL\GSCM.SSP.Plan.UIL\SSP0025_ShipmentRequestorPIC.cs` | 742 |
| current(only) | `06.UIL\GSCM.SSP.Plan.UIL\SSP0025_ShipmentRequestorPIC.Designer.cs` | 587 |
| current(only) | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0025_ItembyDivisionPopup.cs` | 447 |
| current(only) | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0025_ItembyDivisionPopup.Designer.cs` | 502 |
| shared | 없음 (Fact Pack 미기재) | - |
| legacy | 없음 (모든 파일 variant = `only`) | - |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

### 2-1. 메인 화면 (`SSP0025_ShipmentRequestorPIC`)

| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| event:this.Load | `Form_Load` > InitControls > SetChangedControl | 140 | `biz:CommonData.CommonDataList` [code=PlantCell] | BIZ_MATCH | - |
| event:cboDivision.SelectedIndexChanged | `CboDivision_SelectedIndexChanged` > SetChangedControl | 140 | `biz:CommonData.CommonDataList` [code=PlantCell] | BIZ_MATCH | - |
| event:spdMain.CellClick | `SpdMain_CellClick` | 639 | `biz:CommonData.CommonDataList` [code=PlantCell] | BIZ_MATCH | - |
| button:FindButton | FindButton > FindData_Main | 274 | `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` | MATCH | SSP0025_GET_SHIPMENT_REQUESTOR_PIC |
| button:SaveButton | SaveButton > SaveData | 410 | `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` | MATCH | SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC |
| button:SaveButton | SaveButton > SaveData > GetUserIDChk | 458 | `SSP.SSP0025_GET_USER_ID_CHECK` | MATCH | SSP0025_GET_USER_ID_CHECK |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 274 | `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` | MATCH | SSP0025_GET_SHIPMENT_REQUESTOR_PIC |
| button:EditButton | EditButton > GetSSPUserCheck | 511 | `SSP.SSP0002_GET_USER_INFO_LIST` | MATCH | SSP0002_GET_USER_INFO_LIST |
| unreached(필드 초기화) | `<field:dtMyDivision>` | 45 | `biz:CommonData.CommonDataList` [code=MyDivision] | BIZ_MATCH | - |
| unreached(필드 초기화) | `<field:dtYesOrNo>` | 47 | `biz:CommonData.YesOrNo` | BIZ_MATCH | - |

- SaveData 안에서 SAVE(410), GetUserIDChk(458), FindData_Main(274)이 어떤 순서·조건으로 호출되는지는 Fact Pack에 없습니다(**확인 필요**). 사용자 ID를 먼저 확인하고 저장하는지, 저장 후 재조회하는지 원문으로 확인해야 합니다.
- `dtMyDivision`은 흐름 분석에서 "진입점 미연결"로 분류됐습니다. 그러나 grid_code.csv에 따르면 `InsertRow:318`에서 `SetCellTypeCombo(… DIVISION_ID, dtMyDivision)`로 이 필드를 사용합니다. 클래스 필드 초기화 시점에 호출되는 것으로 봐야 합니다. InsertRow의 진입점(어떤 버튼에서 호출되는지)은 **확인 필요**입니다.
- `dtYesOrNo`(47)를 쓰는 곳은 Fact Pack에 없습니다(**확인 필요**).

### 2-2. 팝업 (`SSP0025_ItembyDivisionPopup`)

| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| event:this.Load | `Form_Load` > InitControls | 206 | `biz:CommonData.CommonDataList` [code=FromSiteByAssembly] | BIZ_MATCH | - |
| event:this.Load | `Form_Load` > FindData | 296 | `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | MATCH | SSP0025_GET_ITEM_BY_DIVISION_POPUP |
| event:this.clbDivisionId.SelectedIndexChanged | `clbDivision_SelectedIndexChanged` | 357 | `biz:CommonData.CommonDataList` [code=FromSiteByAssembly] | BIZ_MATCH | - |
| event:this.btnButtonList.UsrButtonList_Click_Detected | `btnButtonList_UsrButtonList_Click_Detected` > FindData | 296 | `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | MATCH | SSP0025_GET_ITEM_BY_DIVISION_POPUP |
| button:FindButton | FindButton > FindData | 296 | `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | MATCH | SSP0025_GET_ITEM_BY_DIVISION_POPUP |
| unreached(필드 초기화) | `<field:dtMyDivision>` | 37 | `biz:CommonData.CommonDataList` [code=MyDivision] | BIZ_MATCH | - |

- 팝업 InitControls: `txtItemId.Text = sItemId`(201), `txtModelId.Text = sModelId`(202), `clbDivisionId.Enabled = false`(204), `clbFromSiteId.Enabled = true`(205). 팝업에서는 Division을 바꿀 수 없고 From Site만 선택할 수 있습니다.
- `clbDivision_SelectedIndexChanged`는 358줄에서 `c["DIVISION_ID"]`를 읽습니다.
- 메인 `btnItemId_Click`(718)은 `txtItemId.Text = popItem.ItemId`, `btnModelId_Click`(736)은 `txtModelId.Text = popItem.ModelId`를 설정합니다. `popItem`의 생성 구문과 타입은 Fact Pack에 없습니다(**확인 필요**).

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 객체 (EXEC 전이 포함) | DB 보강(코드분기) |
|---|---|---:|---|---|---|
| `biz:CommonData.CommonDataList` [code=FromSiteByAssembly] | BIZ_MATCH | 2 | - | - | UP_FX_GetCommonDataList: SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE |
| `biz:CommonData.CommonDataList` [code=MyDivision] | BIZ_MATCH | 2 | - | - | UP_FX_GetCommonDataList: SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION |
| `biz:CommonData.CommonDataList` [code=PlantCell] | BIZ_MATCH | 2 | - | - | UP_FX_GetCommonDataList: SCM_MST_SITE |
| `biz:CommonData.YesOrNo` | BIZ_MATCH | 1 | - | - | 없음 (via `Data.CallBizData`, 조회 대상은 **확인 필요**) |
| `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | MATCH | 1 | SSP0025_GET_ITEM_BY_DIVISION_POPUP | SELECT: SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL / REF: STRING_SPLIT | - |
| `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` | MATCH | 1 | SSP0025_GET_SHIPMENT_REQUESTOR_PIC | SELECT: SSP_MST_MODEL_USER_EE, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_SITE_ITEM_EE_V, TB_FX_USER / REF: STRING_SPLIT | - |
| `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` | MATCH | 1 | SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC | EXEC: PR_SCM_SYS_LOG_BATCH / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL / MERGE: SSP_MST_MODEL_USER_EE / INSERT: SCM_SYS_LOG_BATCH | - |
| `SSP.SSP0025_GET_USER_ID_CHECK` | MATCH | 1 | SSP0025_GET_USER_ID_CHECK | SELECT: TB_FX_USER / REF: STRING_SPLIT | - |
| `SSP.SSP0002_GET_USER_INFO_LIST` | MATCH | 1 | SSP0002_GET_USER_INFO_LIST | SELECT: SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | - |

- `SSP.SSP0002_GET_USER_INFO_LIST`는 다른 화면(SSP0002)의 SP를 EditButton에서 재사용합니다.
- 상태가 미매칭(NOT FOUND 등)인 엔드포인트는 0건입니다.

## 4. 이벤트 배선 표

| 클래스 | 대상 | 이벤트 | 핸들러 | 배선 위치 | 엔드포인트 호출(Fact Pack 기준) |
|---|---|---|---|---|---|
| 팝업 | this.clbDivisionId | SelectedIndexChanged | `clbDivision_SelectedIndexChanged` | Designer InitializeComponent:188 | CommonDataList[FromSiteByAssembly] |
| 팝업 | this.btnButtonList | UsrButtonList_Click_Detected | `btnButtonList_UsrButtonList_Click_Detected` | Designer InitializeComponent:281 | SSP0025_GET_ITEM_BY_DIVISION_POPUP |
| 팝업 | this.spdMain | CellDoubleClick | `spdMain_CellDoubleClick` | Designer InitializeComponent:362 | 없음 (본문 동작 **확인 필요**) |
| 팝업 | this | Load | `Form_Load` | .ctor:172 | CommonDataList[FromSiteByAssembly], SSP0025_GET_ITEM_BY_DIVISION_POPUP |
| 메인 | this | Load | `Form_Load` | .ctor:102 | CommonDataList[PlantCell] |
| 메인 | spdMain | TopChange | `SpdMain_TopChange` | InitEvent:170 | 없음 (본문 동작 **확인 필요**) |
| 메인 | spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:171 | 없음 (본문 동작 **확인 필요**) |
| 메인 | spdMain | CellClick | `SpdMain_CellClick` | InitEvent:172 | CommonDataList[PlantCell] (639) |
| 메인 | spdMain | ComboSelChange | `SpdMain_ComboSelChange` | InitEvent:173 | 없음 (본문 동작 **확인 필요**) |
| 메인 | cboDivision | SelectedIndexChanged | `CboDivision_SelectedIndexChanged` | InitEvent:175 | CommonDataList[PlantCell] (SetChangedControl:140) |
| 메인 | btnItemId | Click | `btnItemId_Click` | InitEvent:177 | 없음, `txtItemId.Text = popItem.ItemId` (718) |
| 메인 | btnModelId | Click | `btnModelId_Click` | InitEvent:178 | 없음, `txtModelId.Text = popItem.ModelId` (736) |

프레임워크 버튼 진입점: `FindButton`, `SaveButton`, `EditButton` (flow.csv의 button 진입점).

## 5. Grid 구성 방식

**구성 방식: `HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)`**

| 시트 | 소속 클래스 | 연결 규칙 | 생성 위치 | 컬럼 정의 |
|---|---|---|---|---|
| `Shipment Requestor PIC` | 메인 | META+코드연결 | CreateSpread:146 `AddSheet` → InitSpread:157 `InitSheet` → InitSpread:159 `SetSheetHeaderColumn(spdInfo, 1)` | 메타 SCM_MST_SHEET_COLUMNS 19컬럼 |
| `Project` | 팝업 | 코드 하드코딩 전용(메타 없음) | CreateSpread:231 `AddSheet` → InitSpread:240 `InitSheet` → InitSpread:243~253 `Add*Column` | 하드코딩 11컬럼 |

메인 시트에 코드로 덧붙인 처리:
- InitSpread:162~164: `if(spdInfo.SheetName == "Shipment Requestor PIC")` 안에서 `CellType = cellTypeImage`를 3회 설정합니다. 적용되는 컬럼은 **확인 필요**입니다.
- InsertRow:318: DIVISION_ID 셀을 콤보로 바꿉니다(`dtMyDivision` = CommonDataList[MyDivision]).
- InsertRow:320: SITE_DESCRIPTION 셀을 콤보로 바꿉니다(`dtToSite` = CommonDataList[PlantCell], 인자 pDivisionID 또는 sDivisionId).
- SpdMain_CellClick:640: 행 액션이 `"I"`(신규)이고 클릭한 컬럼이 `SITE_DESCRIPTION`일 때 PlantCell 콤보를 다시 설정합니다. 조건: `siMain.IsLock(...) == false`.

### 5-1. Division별 차이

| 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Project | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |
| Shipment Requestor PIC | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |

- 14개 division 모두 컬럼 수가 같아 **division별 차이가 없습니다**. 메타의 19컬럼은 모두 '기본'이고 '선택'은 0입니다. 코드 분기 가운데 division 조건은 0건입니다.
- 팝업 `Project` 시트의 `DIVISION_NAME`(244줄)은 `bVisible = false`로 추가됩니다. grid_effective가 '코드추가'로 센 11컬럼에는 이 숨김 컬럼이 포함되므로, 실제로 보이는 컬럼은 10개입니다.

## 6. 확인 필요 항목

| # | 항목 | 근거 |
|---|---|---|
| 1 | 메인 Form Text가 `"SSP0014_ShipmentModelPIC"`임. 실행 시 화면 제목이 무엇으로 표시되는지 | Designer:539 |
| 2 | SaveData 안의 GetUserIDChk / SAVE / FindData_Main 호출 순서와 분기 | flow.csv(순서 정보 없음) |
| 3 | §4-2 메타 소비 표에서 `SaveData`(SaveButton:234)가 `PersonalSettingPopup.SaveData`로 해석됨. 이 화면 자신의 SaveData와 다른 것으로 해석됐는지(파서 오해석인지) | Fact Pack §4-2 |
| 4 | `cellTypeImage`를 적용하는 3개 컬럼과 imageList1 사용 여부 | InitSpread:162~164 |
| 5 | `dtYesOrNo` 사용처 (VALID_YN 콤보 여부 포함) | `<field:dtYesOrNo>`:47 |
| 6 | InsertRow의 진입점 버튼 | grid_code InsertRow:318/320 |
| 7 | SpdMain_TopChange / SpdMain_CellDoubleClick / SpdMain_ComboSelChange / 팝업 spdMain_CellDoubleClick의 본문 동작 | events.csv(엔드포인트 없음) |
| 8 | `popItem` 인스턴스의 타입과 생성 위치 | btnItemId_Click:718, btnModelId_Click:736 |
| 9 | EditButton > GetSSPUserCheck(SSP0002_GET_USER_INFO_LIST) 결과로 편집 가능 여부를 정하는 조건 | flow.csv |
| 10 | `biz:CommonData.YesOrNo` 데이터의 원천 | DB 보강 없음 |
| 11 | usrButton1(75x23, parent 없음)의 사용 여부 | controls.csv, props.csv:102 |

=== FILE: source_links.md ===
# SSP0025 소스 링크 표

> 경로 기준: AS-IS 소스 루트(GSCM)부터의 상대 경로입니다. 링크는 `경로#L줄` 형식입니다.
> 약어: **M** = `06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs`, **MD** = `…/SSP0025_ShipmentRequestorPIC.Designer.cs`, **P** = `06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs`, **PD** = `…/Popup/SSP0025_ItembyDivisionPopup.Designer.cs`

## 1. 엔드포인트 호출 지점 (endpoints.csv 12행 전체)

| # | 파일 | 메서드 | 줄 | 내용 |
|---:|---|---|---:|---|
| 1 | [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L37) | `<field:dtMyDivision>` | 37 | `biz:CommonData.CommonDataList` [code=MyDivision] (Data.Common → CallBizCommonData) |
| 2 | [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L206) | InitControls | 206 | `biz:CommonData.CommonDataList` [code=FromSiteByAssembly] |
| 3 | [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L296) | FindData | 296 | `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` |
| 4 | [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L357) | clbDivision_SelectedIndexChanged | 357 | `biz:CommonData.CommonDataList` [code=FromSiteByAssembly] |
| 5 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L45) | `<field:dtMyDivision>` | 45 | `biz:CommonData.CommonDataList` [code=MyDivision] |
| 6 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L47) | `<field:dtYesOrNo>` | 47 | `biz:CommonData.YesOrNo` (Data.Common → CallBizData) |
| 7 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L140) | SetChangedControl | 140 | `biz:CommonData.CommonDataList` [code=PlantCell] |
| 8 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L274) | FindData_Main | 274 | `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` |
| 9 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L410) | SaveData | 410 | `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` |
| 10 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L458) | GetUserIDChk | 458 | `SSP.SSP0025_GET_USER_ID_CHECK` |
| 11 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L511) | GetSSPUserCheck | 511 | `SSP.SSP0002_GET_USER_INFO_LIST` |
| 12 | [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L639) | SpdMain_CellClick | 639 | `biz:CommonData.CommonDataList` [code=PlantCell] |

## 2. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [PD](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.Designer.cs#L188) | InitializeComponent | 188 | `clbDivisionId.SelectedIndexChanged += clbDivision_SelectedIndexChanged` |
| [PD](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.Designer.cs#L281) | InitializeComponent | 281 | `btnButtonList.UsrButtonList_Click_Detected += btnButtonList_UsrButtonList_Click_Detected` |
| [PD](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.Designer.cs#L362) | InitializeComponent | 362 | `spdMain.CellDoubleClick += spdMain_CellDoubleClick` |
| [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L172) | .ctor | 172 | `this.Load += Form_Load` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L102) | .ctor | 102 | `this.Load += Form_Load` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L170) | InitEvent | 170 | `spdMain.TopChange += SpdMain_TopChange` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L171) | InitEvent | 171 | `spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L172) | InitEvent | 172 | `spdMain.CellClick += SpdMain_CellClick` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L173) | InitEvent | 173 | `spdMain.ComboSelChange += SpdMain_ComboSelChange` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L175) | InitEvent | 175 | `cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L177) | InitEvent | 177 | `btnItemId.Click += btnItemId_Click` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L178) | InitEvent | 178 | `btnModelId.Click += btnModelId_Click` |

## 3. Grid 구성 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L146) | CreateSpread | 146 | `AddSheet(spdMain, SpdSheet.shtMain(="Shipment Requestor PIC"), …, 1, 1, 30)` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L147) | CreateSpread | 147 | `GetSheetInfo(spdMain.Name, 0)` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L149) | CreateSpread | 149 | `ChangeSheet` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L157) | InitSpread | 157 | `InitSheet("Shipment Requestor PIC")` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L159) | InitSpread | 159 | `SetSheetHeaderColumn(spdInfo, 1)`, 메타 컬럼 생성 |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L162) | InitSpread | 162~164 | `CellType = cellTypeImage` ×3 |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L220) | EditButton | 220 | `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)`, 조건 `fps != null && fps.Name == "spdMain"` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L318) | InsertRow | 318 | `SetCellTypeCombo(ActiveRow, DIVISION_ID, dtMyDivision)` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L320) | InsertRow | 320 | `SetCellTypeCombo(ActiveRow, SITE_DESCRIPTION, dtToSite)` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L640) | SpdMain_CellClick | 640 | `SetCellTypeCombo(e.Row, SITE_DESCRIPTION, dtToSite)`, 조건 Action=="I" && 컬럼==SITE_DESCRIPTION |
| [MD](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.Designer.cs#L499) | InitializeComponent | 499~502 | ColumnHeader 스타일(General 정렬, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced) |
| [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L231) | CreateSpread | 231 | `AddSheet(spdMain, SpdSheet.shtMain(="Project"), …, 1, 1, 30)` |
| [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L240) | InitSpread | 240 | `InitSheet(siMain.SheetName)` |
| [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L243) | InitSpread | 243~253 | `AddTextColumn` ×10 + `AddNumColumnEx` ×1 |
| [PD](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.Designer.cs#L378) | InitializeComponent | 378~381 | ColumnHeader 스타일(위와 같음) |

## 4. 메타 소비·컨트롤 값 설정 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L139) | SetChangedControl | 139 | `GetCheckedListValue` (CODE) |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L258) | FindData_Main | 258, 259 | `GetCheckedListValue` (CODE) |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L234) | SaveButton | 234 | `SaveData`. 파서는 PersonalSettingPopup.SaveData로 해석했음(**확인 필요**) |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L718) | btnItemId_Click | 718 | `txtItemId.Text = popItem.ItemId` |
| [M](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs#L736) | btnModelId_Click | 736 | `txtModelId.Text = popItem.ModelId` |
| [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L201) | InitControls | 201~205 | txtItemId/txtModelId 초기값, clbDivisionId.Enabled=false, clbFromSiteId.Enabled=true |
| [P](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.cs#L358) | clbDivision_SelectedIndexChanged | 358 | `c["DIVISION_ID"]` 읽기 |
| [MD](06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.Designer.cs#L539) | InitializeComponent | 539 | `this.Text = "SSP0014_ShipmentModelPIC"` |
| [PD](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0025_ItembyDivisionPopup.Designer.cs#L456) | InitializeComponent | 456 | `this.Text = "Item by DivisionPopup"` |

=== FILE: web_components.md ===
# SSP0025 Web 컴포넌트 매핑 (As-is → React/Wijmo)

## 1. 메인 화면 컨트롤 매핑

| As-is 컨트롤 | 유형 | 라벨(원문) | LayoutItem | 크기 | React/Wijmo 후보 |
|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Div*` | Division | 128x20 | 단일선택 ComboBox (필수 표시) |
| clbFromSite | UsrCheckedList | `Plant Site` | layoutToSite | 140x21 | 다중선택 MultiSelect (체크리스트) |
| txtItemId | UsrMultiLineEditor | `Material` | lblItemId | 151x21 | 멀티라인 입력(여러 값) |
| btnItemId | UsrButton | `layoutControlItem2` (LayoutItem 기본 Text, 화면 표시 여부 **확인 필요**) | layoutControlItem4 | 39x24 | 팝업 호출 버튼 → Item by Division 팝업 |
| txtModelId | UsrMultiLineEditor | `Model` | lblModelId | 162x21 | 멀티라인 입력(여러 값) |
| btnModelId | UsrButton | `layoutControlItem2` (위와 같음) | layoutControlItem1 | 39x24 | 팝업 호출 버튼 → Item by Division 팝업 |
| txtNickName | TextBox | `Nick Name` | layoutNickName | 135x24 | 단일 텍스트 입력 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | 시트 `Shipment Requestor PIC` | - | 1192x608 | Wijmo FlexGrid (편집 가능) |
| usrButton1 | UsrButton | - | 없음(parent 없음) | 75x23 | 사용 여부 **확인 필요** |
| imageList1 | ImageList | - | - | - | 이미지 셀(cellTypeImage)과의 관련 여부 **확인 필요** |
| usrConditionPanel1 | UsrConditionPanel | - | - | 1192x41, HidePanel | 조회조건 패널 |
| emptySpaceItem2 | EmptySpaceItem | - | - | 122x28 | 여백 |
| (프레임워크) | 버튼 | FindButton / SaveButton / EditButton | - | - | 공통 버튼 바(조회/저장/편집). 행 추가는 InsertRow(진입 버튼 **확인 필요**) |

## 2. 팝업(`SSP0025_ItembyDivisionPopup`, 제목 `Item by DivisionPopup`) 컨트롤 매핑

| As-is 컨트롤 | 유형 | 라벨(원문) | LayoutItem | 크기 | 초기 상태 | React/Wijmo 후보 |
|---|---|---|---|---|---|---|
| clbDivisionId | UsrCheckedList | `Division` | lblDivision | 141x21 | Enabled=false | 읽기전용 MultiSelect |
| clbFromSiteId | UsrCheckedList | `From Site` | lblFromSite | 147x21 | Enabled=true | MultiSelect |
| txtItemId | UsrMultiLineEditor | `Material` | lbItemId | 150x21 | Text=sItemId | 멀티라인 입력 |
| txtModelId | UsrMultiLineEditor | `Model` | lbModelId | 169x21 | Text=sModelId | 멀티라인 입력 |
| btnButtonList | UsrButtonList | - | layoutControlItem1 | 105x26 | - | 팝업 내 조회 버튼 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | 시트 `Project` | - | 985x524 | - | Wijmo FlexGrid (조회 전용, 더블클릭 동작 **확인 필요**) |
| usrLayoutControl1 / layoutControlGroup1 | UsrLayoutControl | - | - | 657x184, Dock Fill | - | 용도 **확인 필요** |
| emptySpaceItem1 | EmptySpaceItem | - | - | 35x30 | - | 여백 |

## 3. 화면 배치

props.csv에는 SplitContainer(Orientation·SplitterDistance)가 **없습니다**. 따라서 좌/우 분할은 없고 Dock Top + Dock Fill의 상/하 2단 구성입니다.

| 화면 | 상단 (Dock Top) | 하단 (Dock Fill) | 높이 비율(Size 기준) |
|---|---|---|---|
| 메인 | usrConditionPanel1 1192x41 | spdMain 1192x608 | 상 41 : 하 608 (≈ 6.3% : 93.7%) |
| 팝업 | usrConditionPanel1 985x50 | spdMain 985x524 | 상 50 : 하 524 (≈ 8.7% : 91.3%) |

조회조건 배치 순서(LayoutItem 기준): Div* → Plant Site → Material(+버튼) → Model(+버튼) → Nick Name. LayoutControl 안의 실제 좌표 순서는 Fact Pack에 Location이 없어 **확인 필요**입니다.

## 4. 시트별 Grid 컬럼

### 4-1. 시트 `Shipment Requestor PIC` (메인, META+코드연결)

메타 SCM_MST_SHEET_COLUMNS 19행은 모두 '기본'입니다. 14개 division의 차이는 없습니다. 메타의 순서(COLUMN 순번)와 폭은 grid_effective에 없어 **확인 필요**입니다(아래 표는 grid_effective의 행 순서).

| # | COLUMN_NAME | 라벨(메타) | 출처 | 코드 추가 처리 |
|---:|---|---|---|---|
| 1 | CELL_TYPE | Cell Type | META | - |
| 2 | CREATED_BY | Created By | META | - |
| 3 | CREATION_DATE | Creation Date | META | - |
| 4 | DIVISION_ID | Division | META | InsertRow:318 신규 행 콤보(MyDivision) |
| 5 | ELECTRODE_TYPE | Electrode Type | META | - |
| 6 | ITEM_ID | Material* | META | - |
| 7 | LAST_UPDATE_DATE | Last Update Date | META | - |
| 8 | LAST_UPDATED_BY | Last Updated By | META | - |
| 9 | MODEL_ID | Model | META | - |
| 10 | NICK_NAME | Nick Name | META | - |
| 11 | PART_LEADER | Part Leader | META | - |
| 12 | PART_LEADER_NAME | Part Leader Name | META | - |
| 13 | SITE_DESCRIPTION | Plant Site* | META | InsertRow:320 / SpdMain_CellClick:640 신규 행 콤보(PlantCell) |
| 14 | TEAM_LEADER | Team Leader | META | - |
| 15 | TEAM_LEADER_NAME | Team Leader Name | META | - |
| 16 | TO_SITE | Plant Site Code | META | - |
| 17 | USER_ID | User ID* | META | - |
| 18 | USER_NAME | User Name | META | - |
| 19 | VALID_YN | Valid* | META | 콤보 원천(dtYesOrNo 여부) **확인 필요** |

추가 처리: InitSpread:162~164에서 3개 컬럼에 `cellTypeImage`를 적용합니다. 대상 컬럼은 **확인 필요**입니다. 헤더 스타일은 General 정렬, NoteIndicatorColor=Red, Parent=`ColumnHeaderDefaultEnhanced`입니다(Designer:499~502).

### 4-2. 시트 `Project` (팝업, 코드 하드코딩 전용)

| # | 필드 | 헤더 | 유형 | 폭 | 표시 | 가로 정렬 |
|---:|---|---|---|---:|---|---|
| 1 | DIVISION_ID | division | Text | 60 | true | Center |
| 2 | DIVISION_NAME | division | Text | 80 | **false (숨김)** | 미지정 |
| 3 | FROM_SITE_CODE | From Site Code | Text | 70 | true | 미지정 |
| 4 | FROM_SITE | From Site | Text | 150 | true | Left |
| 5 | ITEM_ID | Material | Text | 100 | true | Center |
| 6 | MODEL_ID | Model | Text | 100 | true | Center |
| 7 | CELL_TYPE | Cell Type | Text | 80 | true | Center |
| 8 | NICK_NAME | Nick Name | Text | 100 | true | Left |
| 9 | ELECTRODE_TYPE | Electrode Type | Text | 80 | true | Center |
| 10 | ITEM_UOM | UOM | Text | 60 | true | Center |
| 11 | UOM_CONVERT_IN_TACT_TIME | Pancake (m/cell) | Num(FixedPoint, 소수 5자리) | 120 | true | 미지정 |

모든 컬럼은 Merge=None입니다. 세로 정렬은 지정된 컬럼에서 Center입니다. grid_effective는 11컬럼을 '코드추가'로 셉니다. 이 중 DIVISION_NAME은 숨김이므로 실제 표시 컬럼은 10개입니다. division별 차이는 없습니다.

## 5. 시트 연결 규칙

| 시트 | 연결 규칙 | 설명 |
|---|---|---|
| Shipment Requestor PIC | META+코드연결 | 코드가 `AddSheet`(146)로 메타 시트명을 사용합니다. `SetSheetHeaderColumn`(159)이 메타로 컬럼을 만들고, 코드는 셀 유형(이미지·콤보)만 덮어씁니다 |
| Project | 코드 하드코딩 전용(메타 없음) | 팝업 InitSpread에서 Add*Column으로 직접 구성합니다. SCM_MST_SHEET_COLUMNS에는 해당 시트가 없습니다 |

- 메인 시트와 팝업 시트는 그리드끼리 연결되지 않습니다(마스터-디테일 아님). 연결은 팝업에서 고른 ItemId/ModelId를 메인 조회조건 txtItemId/txtModelId에 넣는 방식입니다(btnItemId_Click:718, btnModelId_Click:736).

=== FILE: oracle_migration.md ===
# SSP0025 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 위치 | 동작 | 참조 객체 | EXEC 체인 |
|---|---|---|---|---|
| `SSP0025_GET_ITEM_BY_DIVISION_POPUP` | 팝업 FindData:296 | 조회 | SELECT: SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL / REF: STRING_SPLIT | 없음 |
| `SSP0025_GET_SHIPMENT_REQUESTOR_PIC` | 메인 FindData_Main:274 | 조회 | SELECT: SSP_MST_MODEL_USER_EE, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_SITE_ITEM_EE_V, TB_FX_USER / REF: STRING_SPLIT | 없음 |
| `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` | 메인 SaveData:410 | 저장 | MERGE: SSP_MST_MODEL_USER_EE / INSERT: SCM_SYS_LOG_BATCH / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | → `PR_SCM_SYS_LOG_BATCH` |
| `SSP0025_GET_USER_ID_CHECK` | 메인 GetUserIDChk:458 | 검증 조회 | SELECT: TB_FX_USER / REF: STRING_SPLIT | 없음 |
| `SSP0002_GET_USER_INFO_LIST` | 메인 GetSSPUserCheck:511 (EditButton) | 사용자 권한 조회 | SELECT: SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | 없음 |

쓰기 대상 테이블: `SSP_MST_MODEL_USER_EE`(MERGE), `SCM_SYS_LOG_BATCH`(INSERT, PR_SCM_SYS_LOG_BATCH 경유를 포함하는지는 **확인 필요**).

## 2. 공통코드 분기 (UP_FX_GetCommonDataList)

| 호출 | code | 참조 테이블 | 사용처 |
|---|---|---|---|
| `biz:CommonData.CommonDataList` | FromSiteByAssembly | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE | 팝업 InitControls:206, clbDivision_SelectedIndexChanged:357 → From Site 목록 |
| `biz:CommonData.CommonDataList` | MyDivision | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION | 메인/팝업 `dtMyDivision` 필드(45/37). 인자 NowGroupID, UserId |
| `biz:CommonData.CommonDataList` | PlantCell | SCM_MST_SITE | 메인 SetChangedControl:140, SpdMain_CellClick:639 → Plant Site 목록·그리드 콤보 |
| `biz:CommonData.YesOrNo` | (code 없음, Data.CallBizData) | DB 보강 없음, **확인 필요** | 메인 `dtYesOrNo`(47) |

## 3. FoxQuery 미등록 / 직접 호출 SP

- 엔드포인트 5개(SSP.*)는 모두 상태 **MATCH**입니다(FoxQuery에 등록돼 있고 SP와 매칭됨).
- 미등록, 직접 SQL, 미매칭 엔드포인트는 **0건**입니다.
- 주석 처리된 호출은 0건입니다.
- `SSP0002_GET_USER_INFO_LIST`는 SSP0002 화면과 공유하는 SP입니다. TO-BE에서 공용 API로 둘지 결정해야 합니다.

## 4. Oracle 전환 시 확인 포인트

| # | 대상 | 사실 | 전환 확인 포인트 |
|---|---|---|---|
| 1 | `SSP0025_GET_ITEM_BY_DIVISION_POPUP`, `SSP0025_GET_SHIPMENT_REQUESTOR_PIC`, `SSP0025_GET_USER_ID_CHECK` | REF: `STRING_SPLIT` | MSSQL 전용 함수(절대 금지 ⑩)이므로 Oracle 대체 구현이 필요합니다(예: 프로젝트 공용 분할 함수 또는 REGEXP/CONNECT BY). 사용하는 파라미터(멀티라인 Material/Model, 다중선택 Plant Site 추정)는 SP 원문에서 **확인 필요** |
| 2 | `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` | REF: `SCM_ARR_SPL_CNT`, `SCM_ARR_SPL_VAL` | 배열 분할 사용자 함수입니다. Oracle 쪽 동일 객체의 존재와 시노님 여부 **확인 필요** |
| 3 | `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` | MERGE: `SSP_MST_MODEL_USER_EE` | MSSQL MERGE → Oracle MERGE 문법 차이(OUTPUT 절, 세미콜론, WHEN NOT MATCHED BY SOURCE 사용 여부)는 SP 원문 **확인 필요**. MERGE 키 컬럼 **확인 필요** |
| 4 | `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC` | EXEC `PR_SCM_SYS_LOG_BATCH`, INSERT `SCM_SYS_LOG_BATCH` | 공통 로그 프로시저입니다. Oracle 전환본 존재 여부와 시그니처 **확인 필요** |
| 5 | `SSP_MST_SITE_ITEM_EE_V` | 뷰 (3개 SP가 참조) | 뷰 정의가 Oracle에 전환됐는지 **확인 필요** |
| 6 | `SSP0025_GET_USER_ID_CHECK` | TB_FX_USER 조회 + STRING_SPLIT | 저장 전 USER_ID 존재 검증으로 보입니다. 반환 형식(오류 메시지/건수)이 FE 판정에 쓰이는지 **확인 필요** |
| 7 | `SSP0002_GET_USER_INFO_LIST` | TB_FX_* 권한 테이블 5종 | TO-BE 권한 체계(TB_FX_* 대응 테이블)와 매핑 **확인 필요** |
| 8 | 저장 화면 공통 | SaveData의 호출 순서 미추출 | GetUserIDChk → SAVE → 재조회 순서는 **확인 필요**. 트랜잭션 경계(SP 단위 COMMIT 여부) **확인 필요** |

## 5. 난이도 판단 근거 (사실 기반)

| 근거 | 값 |
|---|---|
| 호출 SP 수 | 5 (조회 3, 저장 1, 권한 조회 1) |
| MSSQL 전용 함수 참조 | STRING_SPLIT 3개 SP |
| 쓰기 테이블 | 2 (SSP_MST_MODEL_USER_EE MERGE, SCM_SYS_LOG_BATCH INSERT) |
| 하위 EXEC 체인 | 1단계 (PR_SCM_SYS_LOG_BATCH) |
| 미매칭/직접 SQL | 0 |
| division별 분기 | 0 |

SP 본문의 줄 수, 동적 SQL 사용 여부, 임시 테이블 사용 여부는 Fact Pack에 없습니다. 그래서 정량적인 난이도 등급은 매기지 않았습니다(**확인 필요**).

=== FILE: tobe_design.md ===
# SSP0025 TO-BE 설계 입력 (As-is 사실 기반)

## 1. 조회조건 (메인)

| 순서 | As-is 컨트롤 | 라벨 | 유형 | 필수 표시 | 데이터 원천 | 연동 |
|---:|---|---|---|---|---|---|
| 1 | cboDivision | Div* | 단일 콤보 | `*` 있음 | 원천 **확인 필요** (MyDivision 사용 여부 미추출) | 변경 시 CboDivision_SelectedIndexChanged → SetChangedControl → Plant Site 재조회 |
| 2 | clbFromSite | Plant Site | 체크리스트(다중) | 없음 | CommonDataList[PlantCell] | Division에 종속 |
| 3 | txtItemId (+btnItemId) | Material | 멀티라인 + 팝업 버튼 | 없음 | 직접 입력 / 팝업 결과 popItem.ItemId | - |
| 4 | txtModelId (+btnModelId) | Model | 멀티라인 + 팝업 버튼 | 없음 | 직접 입력 / 팝업 결과 popItem.ModelId | - |
| 5 | txtNickName | Nick Name | 텍스트 | 없음 | 직접 입력 | - |

FindData_Main:258·259에서 `GetCheckedListValue`를 호출해 체크리스트 값(CODE)을 조회 파라미터로 넘깁니다. 정확한 SP 파라미터 목록은 **확인 필요**입니다.

### 1-1. 팝업 조회조건 (`Item by DivisionPopup`)

| 컨트롤 | 라벨 | 상태 | 원천 |
|---|---|---|---|
| clbDivisionId | Division | 비활성(Enabled=false) | 메인에서 넘긴 값으로 보이나 전달 방식은 **확인 필요** |
| clbFromSiteId | From Site | 활성 | CommonDataList[FromSiteByAssembly] |
| txtItemId | Material | 초기값 sItemId | 메인 입력값 |
| txtModelId | Model | 초기값 sModelId | 메인 입력값 |

## 2. 액션별 호출 API 후보

| 액션 | As-is 진입점 | As-is 엔드포인트 | TO-BE API 후보 |
|---|---|---|---|
| 화면 로드 | Form_Load > InitControls > SetChangedControl | CommonDataList[PlantCell] | 공통코드 API (PlantCell) |
| Division 변경 | CboDivision_SelectedIndexChanged | CommonDataList[PlantCell] | 공통코드 API (PlantCell, division 파라미터) |
| 조회 | FindButton > FindData_Main | SSP0025_GET_SHIPMENT_REQUESTOR_PIC | `GET/POST …/ssp0025/search` → SP 조회 |
| 편집 진입 | EditButton > GetSSPUserCheck | SSP0002_GET_USER_INFO_LIST | 사용자 권한 확인 API (SSP0002와 공용) |
| 행 추가 | InsertRow (진입 버튼 **확인 필요**) | CommonDataList[MyDivision], [PlantCell] | 신규 행 콤보: Division / Plant Site 공통코드 |
| 그리드 셀 클릭(신규 행 Plant Site) | SpdMain_CellClick | CommonDataList[PlantCell] | 공통코드 API (PlantCell) |
| 저장 | SaveButton > SaveData (> GetUserIDChk, > FindData_Main) | SSP0025_GET_USER_ID_CHECK, SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC, SSP0025_GET_SHIPMENT_REQUESTOR_PIC | 사용자 ID 검증 + 저장 API + 재조회 (순서 **확인 필요**) |
| Material 팝업 | btnItemId_Click | (팝업 내부) SSP0025_GET_ITEM_BY_DIVISION_POPUP | 팝업 조회 API |
| Model 팝업 | btnModelId_Click | (팝업 내부) SSP0025_GET_ITEM_BY_DIVISION_POPUP | 팝업 조회 API (같은 SP) |
| 팝업 로드/조회 | Form_Load, btnButtonList_UsrButtonList_Click_Detected, FindButton | CommonDataList[FromSiteByAssembly], SSP0025_GET_ITEM_BY_DIVISION_POPUP | 공통코드 API + 팝업 조회 API |
| 팝업 Division 변경 | clbDivision_SelectedIndexChanged | CommonDataList[FromSiteByAssembly] | 공통코드 API (컨트롤이 비활성이라 사용자가 직접 바꾸는 경우는 없음) |
| 팝업 행 더블클릭 | spdMain_CellDoubleClick | 없음 | 선택값 반환 (동작 **확인 필요**) |
| 그리드 TopChange / CellDoubleClick / ComboSelChange (메인) | SpdMain_TopChange 등 | 없음 | 동작 **확인 필요** |

## 3. Division별 Grid 변형 요약

| 시트 | 구성 | division별 차이 |
|---|---|---|
| Shipment Requestor PIC | 메타 19컬럼(모두 기본) + 코드 셀 유형 변경(이미지 3, 콤보 2) | 없음 (14개 division 모두 19) |
| Project (팝업) | 하드코딩 11컬럼(DIVISION_NAME 숨김 → 표시 10) | 없음 |

메타 기반 그리드이므로 TO-BE에서는 SCM_MST_SHEET_COLUMNS(PROGRAM_ID=SSP0025, SHEET_NAME=`Shipment Requestor PIC`) 19행을 컬럼 메타 원천으로 씁니다. 팝업 `Project` 시트는 메타가 없어 TO-BE에서 메타를 새로 등록할지, 코드로 정의할지 결정해야 합니다(미확정).

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 출처 |
|---|---|
| TB_FX_GroupMenuAuth에 SSP0025 행 12건 | DB 메타 §8 |
| TB_FX_MenuItemInfo 1건, TB_FX_ProgramInfo 1건 | DB 메타 §8 |
| TB_FX_SearchCondition 4건(저장된 조회조건) | DB 메타 §8 |
| TB_FX_Favorite 5건 | DB 메타 §8 |
| EditButton에서 SSP0002_GET_USER_INFO_LIST로 사용자 정보·권한(TB_FX_USERGROUPAUTHEXTENTION 등) 조회 | flow.csv |
| 신규 행 Division 콤보 = MyDivision(사용자 그룹 권한 TB_FX_USERGROUPAUTHEXTENTION 기준) | grid_code InsertRow:318 |
| 그리드 잠금 여부 `siMain.IsLock(SheetName)`가 행 추가·셀 콤보 설정 조건 | grid_code InsertRow / SpdMain_CellClick |

그룹별 C/R/U/D 플래그 값(12행의 내용)은 Fact Pack에 없어 **확인 필요**입니다.

## 5. 미확정 사항

1. 메인 Form Text `"SSP0014_ShipmentModelPIC"`와 화면명 `Shipment Requestor PIC`가 다릅니다. TO-BE 화면 제목 기준이 미확정입니다.
2. 저장 절차(USER_ID 검증 → MERGE → 재조회)의 정확한 순서와 오류 처리는 원문 확인이 필요합니다.
3. EditButton 권한 확인 결과로 편집을 허용하는 조건은 원문 확인이 필요합니다.
4. 이미지 셀(cellTypeImage) 3컬럼의 대상과 TO-BE 표현 방식(아이콘 셀) 미확정.
5. VALID_YN 콤보 원천(`biz:CommonData.YesOrNo` 여부) 미확정.
6. cboDivision(Div*) 콤보 데이터 원천 미확정.
7. 팝업과 메인 사이 값 전달(sItemId/sModelId 입력, popItem.ItemId/ModelId 반환, Division 전달) 인터페이스 확정 필요.
8. 팝업 `Project` 시트의 TO-BE 컬럼 정의 방식(메타 등록 / 코드) 미확정.
9. STRING_SPLIT, SCM_ARR_SPL_CNT/VAL, PR_SCM_SYS_LOG_BATCH의 Oracle 대응 객체 존재 여부 미확인.
10. usrButton1, imageList1, usrLayoutControl1(팝업)의 사용 여부 미확인.
