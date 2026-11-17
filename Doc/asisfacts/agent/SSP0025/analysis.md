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
