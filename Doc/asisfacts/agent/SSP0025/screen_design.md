# SSP0025 화면설계서 — Shipment Requestor PIC

> 근거: AsisFacts Fact Pack(SSP0025) controls.csv / props.csv / events.csv / flow.csv / grid_code.csv / grid_effective.csv
> 엔드포인트 이름은 업무분석서 §5, 단위테스트 '근거' 열과 같고, 컨트롤명은 단위테스트 '절차' 열과 같습니다. 주석 처리된 호출은 0건입니다.

## 1. 화면 개요

| 항목 | 메인 | 팝업 |
|---|---|---|
| 화면 ID | SSP0025 | (SSP0025 소속 팝업) |
| 클래스 | `SSP0025_ShipmentRequestorPIC` | `SSP0025_ItembyDivisionPopup` |
| 명칭 | Shipment Requestor PIC (시트명 기준) | Item by DivisionPopup |
| Form Text(원문) | `"SSP0014_ShipmentModelPIC"` (Designer:539, 화면 ID와 다름, **확인 필요**) | `"Item by DivisionPopup"` (Designer:456) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1건, 내용 미추출) | 메인에서 btnItemId / btnModelId로 호출 |
| 프로젝트 | `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj` | 같음 |

## 2. 화면 레이아웃

### 2-1. 분할 구조 근거
- props.csv에 **SplitContainer(Orientation·SplitterDistance)가 없습니다**. 좌/우 분할은 없습니다.
- 분할은 Dock Top(조회조건 패널) + Dock Fill(그리드)의 **상/하 2단**입니다. 비율은 Size 높이로 계산했습니다.

### 2-2. 메인 `SSP0025_ShipmentRequestorPIC` — parent 체인 트리
```
this (Form, Text="SSP0014_ShipmentModelPIC")
├─ usrConditionPanel1   [UsrConditionPanel, Dock=Top, 1192x41, HidePanel]        ← 상단 6.3% (41/649)
│   └─ usrLayoutControl2 [UsrLayoutControl, Dock=Fill, 1192x41, Text="usrLayoutControl2"]
│        (layoutControlGroup2 1192x48)
│        ├─ cboDivision   [UsrCombo 128x20]          ← LayoutItem Division      "Div*"
│        ├─ clbFromSite   [UsrCheckedList 140x21]    ← LayoutItem layoutToSite  "Plant Site"
│        ├─ txtItemId     [UsrMultiLineEditor 151x21]← LayoutItem lblItemId     "Material"
│        ├─ btnItemId     [UsrButton 39x24]          ← LayoutItem layoutControlItem4 "layoutControlItem2"
│        ├─ txtModelId    [UsrMultiLineEditor 162x21]← LayoutItem lblModelId    "Model"
│        ├─ btnModelId    [UsrButton 39x24]          ← LayoutItem layoutControlItem1 "layoutControlItem2"
│        ├─ txtNickName   [TextBox 135x24]           ← LayoutItem layoutNickName "Nick Name"
│        └─ (emptySpaceItem2 122x28)
└─ spdMain              [FpSpread, Dock=Fill, 1192x608]                           ← 하단 93.7% (608/649)
     └─ spdMain_Sheet1  [SheetView] → 시트 "Shipment Requestor PIC"
(parent 없음) usrButton1 [UsrButton 75x23] — 배치·사용 여부 확인 필요
(parent 없음) imageList1 [ImageList]
```

와이어프레임(메인):
```
┌──────────────────────────────────────────────────────────────────────────────┐
│ [공통 버튼 바: 조회(FindButton) / 편집(EditButton) / 저장(SaveButton) …]       │ ← 프레임워크 영역
├──────────────────────────────────────────────────────────────────────────────┤
│ 조회조건 usrConditionPanel1 (6.3%)                                            │
│ Div*[cboDivision▼] Plant Site[clbFromSite☑▼] Material[txtItemId][btnItemId]   │
│ Model[txtModelId][btnModelId] Nick Name[txtNickName]                          │
├──────────────────────────────────────────────────────────────────────────────┤
│ 그리드 spdMain / spdMain_Sheet1 — 시트 "Shipment Requestor PIC" (93.7%)        │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```
- LayoutControl 안의 컨트롤 좌표(Location)는 Fact Pack에 없습니다. 위 배치 순서는 LayoutItem 선언 순서를 따른 것이고, 실제 좌표 순서는 **확인 필요**입니다.

### 2-3. 팝업 `SSP0025_ItembyDivisionPopup` — parent 체인 트리
```
this (Form, Text="Item by DivisionPopup")
├─ usrConditionPanel1   [UsrConditionPanel, Dock=Top, 985x50, HidePanel]          ← 상단 8.7% (50/574)
│   └─ usrLayoutControl2 [UsrLayoutControl, Dock=Fill, 985x50, Text="usrLayoutControl2"]
│        (layoutControlGroup2 985x50)
│        ├─ clbDivisionId [UsrCheckedList 141x21]    ← LayoutItem lblDivision "Division"
│        ├─ clbFromSiteId [UsrCheckedList 147x21]    ← LayoutItem lblFromSite "From Site"
│        ├─ txtItemId     [UsrMultiLineEditor 150x21]← LayoutItem lbItemId    "Material"
│        ├─ txtModelId    [UsrMultiLineEditor 169x21]← LayoutItem lbModelId   "Model"
│        ├─ btnButtonList [UsrButtonList 105x26]     ← LayoutItem layoutControlItem1 (Text 없음)
│        └─ (emptySpaceItem1 35x30)
└─ spdMain              [FpSpread, Dock=Fill, 985x524]                            ← 하단 91.3% (524/574)
     └─ spdMain_Sheet1  [SheetView] → 시트 "Project"
(parent 없음) usrLayoutControl1 [UsrLayoutControl, Dock=Fill, 657x184] / layoutControlGroup1 657x184 — 용도 확인 필요
```

와이어프레임(팝업):
```
┌─────────────────────────────────────────────────────────────────┐
│ 조회조건 (8.7%)                                                 │
│ Division[clbDivisionId(비활성)] From Site[clbFromSiteId]         │
│ Material[txtItemId] Model[txtModelId] [btnButtonList]            │
├─────────────────────────────────────────────────────────────────┤
│ 그리드 spdMain / spdMain_Sheet1 — 시트 "Project" (91.3%)         │
└─────────────────────────────────────────────────────────────────┘
```

## 3. 컨트롤 명세

### 3-1. 메인
| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | - | Dock=Top, HidePanel | - | - | 조회조건 패널 |
| usrLayoutControl2 | UsrLayoutControl | `usrLayoutControl2` | Dock=Fill | - | - | 조회조건 레이아웃 |
| cboDivision | UsrCombo | `Div*` | **확인 필요** | 예(`*` 표시) | SelectedIndexChanged → `CboDivision_SelectedIndexChanged` | 단일선택 ComboBox |
| clbFromSite | UsrCheckedList | `Plant Site` | `biz:CommonData.CommonDataList` [code=PlantCell] 결과 | 아니오(표시 없음) | - | MultiSelect(체크리스트) |
| txtItemId | UsrMultiLineEditor | `Material` | 빈값(**확인 필요**) | 아니오 | - | 멀티라인 입력 |
| btnItemId | UsrButton | `layoutControlItem2` (LayoutItem 기본 Text, 표시 여부 **확인 필요**) | - | - | Click → `btnItemId_Click` | 팝업 호출 버튼 |
| txtModelId | UsrMultiLineEditor | `Model` | 빈값(**확인 필요**) | 아니오 | - | 멀티라인 입력 |
| btnModelId | UsrButton | `layoutControlItem2` (위와 같음) | - | - | Click → `btnModelId_Click` | 팝업 호출 버튼 |
| txtNickName | TextBox | `Nick Name` | 빈값(**확인 필요**) | 아니오 | - | 텍스트 입력 |
| spdMain | FpSpread | - | Dock=Fill | - | TopChange / CellDoubleClick / CellClick / ComboSelChange | Wijmo FlexGrid |
| spdMain_Sheet1 | SheetView | 시트 `Shipment Requestor PIC` | - | - | - | FlexGrid 시트 |
| usrButton1 | UsrButton | - | 75x23, parent 없음 | - | 없음 | 사용 여부 **확인 필요** |

### 3-2. 팝업
| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrLayoutControl1 | UsrLayoutControl | - | Dock=Fill, 657x184 | - | - | 용도 **확인 필요** |
| usrConditionPanel1 | UsrConditionPanel | - | Dock=Top, HidePanel | - | - | 조회조건 패널 |
| usrLayoutControl2 | UsrLayoutControl | `usrLayoutControl2` | Dock=Fill | - | - | 조회조건 레이아웃 |
| clbDivisionId | UsrCheckedList | `Division` | `Enabled=false` (InitControls:204) | - | SelectedIndexChanged → `clbDivision_SelectedIndexChanged` | 읽기전용 MultiSelect |
| clbFromSiteId | UsrCheckedList | `From Site` | `Enabled=true` (205), `biz:CommonData.CommonDataList` [code=FromSiteByAssembly] | - | - | MultiSelect |
| txtItemId | UsrMultiLineEditor | `Material` | `sItemId` (201) | - | - | 멀티라인 입력 |
| txtModelId | UsrMultiLineEditor | `Model` | `sModelId` (202) | - | - | 멀티라인 입력 |
| btnButtonList | UsrButtonList | (Text 없음) | - | - | UsrButtonList_Click_Detected → `btnButtonList_UsrButtonList_Click_Detected` | 팝업 조회 버튼 |
| spdMain | FpSpread | - | Dock=Fill | - | CellDoubleClick → `spdMain_CellDoubleClick` | Wijmo FlexGrid |
| spdMain_Sheet1 | SheetView | 시트 `Project` | - | - | - | FlexGrid 시트 |

## 4. 그리드 명세

### 4-1. 시트 `Shipment Requestor PIC` (메인, 연결 규칙 META+코드연결)
- 생성: CreateSpread:146 `AddSheet` → InitSpread:157 `InitSheet` → InitSpread:159 `SetSheetHeaderColumn(spdInfo, 1)` (메타 SCM_MST_SHEET_COLUMNS).
- 컬럼 순서·폭·정렬은 메타 값(COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE 등)을 따릅니다. grid_effective에는 해당 값이 없어 아래는 grid_effective의 행 순서입니다(**메타 순번 확인 필요**).

| # | 컬럼 | 헤더(메타 라벨) | 타입 | 출처 | division별 표시 | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | CELL_TYPE | Cell Type | 메타 정의(**확인 필요**) | META | 14개 전부 기본 | **확인 필요** |
| 2 | CREATED_BY | Created By | 〃 | META | 〃 | **확인 필요** |
| 3 | CREATION_DATE | Creation Date | 〃 | META | 〃 | **확인 필요** |
| 4 | DIVISION_ID | Division | 신규 행 콤보(MyDivision, InsertRow:318) | META+코드 | 〃 | 신규 행: 콤보 선택 / 기존 행 **확인 필요** |
| 5 | ELECTRODE_TYPE | Electrode Type | 메타 | META | 〃 | **확인 필요** |
| 6 | ITEM_ID | Material* | 메타 | META | 〃 | **확인 필요** |
| 7 | LAST_UPDATE_DATE | Last Update Date | 메타 | META | 〃 | **확인 필요** |
| 8 | LAST_UPDATED_BY | Last Updated By | 메타 | META | 〃 | **확인 필요** |
| 9 | MODEL_ID | Model | 메타 | META | 〃 | **확인 필요** |
| 10 | NICK_NAME | Nick Name | 메타 | META | 〃 | **확인 필요** |
| 11 | PART_LEADER | Part Leader | 메타 | META | 〃 | **확인 필요** |
| 12 | PART_LEADER_NAME | Part Leader Name | 메타 | META | 〃 | **확인 필요** |
| 13 | SITE_DESCRIPTION | Plant Site* | 신규 행 콤보(PlantCell, InsertRow:320 / SpdMain_CellClick:640) | META+코드 | 〃 | 신규 행(Action=I): 콤보 선택 |
| 14 | TEAM_LEADER | Team Leader | 메타 | META | 〃 | **확인 필요** |
| 15 | TEAM_LEADER_NAME | Team Leader Name | 메타 | META | 〃 | **확인 필요** |
| 16 | TO_SITE | Plant Site Code | 메타 | META | 〃 | **확인 필요** |
| 17 | USER_ID | User ID* | 메타 | META | 〃 | **확인 필요** |
| 18 | USER_NAME | User Name | 메타 | META | 〃 | **확인 필요** |
| 19 | VALID_YN | Valid* | 메타(콤보 원천 `biz:CommonData.YesOrNo` 여부 **확인 필요**) | META | 〃 | **확인 필요** |

- InitSpread:162~164: `if(spdInfo.SheetName == "Shipment Requestor PIC")` 안에서 `CellType = cellTypeImage`를 3회 설정합니다. 대상 컬럼은 **확인 필요**입니다.
- 컬럼 헤더 스타일(Designer:499~502): HorizontalAlignment=General, NoteIndicatorColor=Red, Parent=`ColumnHeaderDefaultEnhanced`, VerticalAlignment=General.
- division 차이: 14개 division 모두 19컬럼(선택 0)입니다.

### 4-2. 시트 `Project` (팝업, 코드 하드코딩 전용 — 메타 없음)
생성: CreateSpread:231 `AddSheet` → InitSpread:240 `InitSheet` → InitSpread:243~253 `Add*Column`.

| # | 컬럼 | 헤더 | 타입 | 폭 | 표시 | 가로 정렬 | 출처 | division별 표시 | 편집 가능 |
|---:|---|---|---|---:|---|---|---|---|---|
| 1 | DIVISION_ID | division | Text | 60 | true | Center | HARDCODED(243) | 14개 동일 | **확인 필요** |
| 2 | DIVISION_NAME | division | Text | 80 | **false(숨김)** | 미지정 | HARDCODED(244) | 14개 동일 | - |
| 3 | FROM_SITE_CODE | From Site Code | Text | 70 | true | 미지정 | HARDCODED(245) | 〃 | **확인 필요** |
| 4 | FROM_SITE | From Site | Text | 150 | true | Left | HARDCODED(246) | 〃 | **확인 필요** |
| 5 | ITEM_ID | Material | Text | 100 | true | Center | HARDCODED(247) | 〃 | **확인 필요** |
| 6 | MODEL_ID | Model | Text | 100 | true | Center | HARDCODED(248) | 〃 | **확인 필요** |
| 7 | CELL_TYPE | Cell Type | Text | 80 | true | Center | HARDCODED(249) | 〃 | **확인 필요** |
| 8 | NICK_NAME | Nick Name | Text | 100 | true | Left | HARDCODED(250) | 〃 | **확인 필요** |
| 9 | ELECTRODE_TYPE | Electrode Type | Text | 80 | true | Center | HARDCODED(251) | 〃 | **확인 필요** |
| 10 | ITEM_UOM | UOM | Text | 60 | true | Center | HARDCODED(252) | 〃 | **확인 필요** |
| 11 | UOM_CONVERT_IN_TACT_TIME | Pancake (m/cell) | Num(FixedPoint, 소수 5자리) | 120 | true | 미지정 | HARDCODED(253) | 〃 | **확인 필요** |

- Merge는 모두 None이고, 세로 정렬이 지정된 컬럼은 Center입니다. 표시 컬럼은 10개입니다(DIVISION_NAME 숨김).
- 헤더 스타일(Designer:378~381): General / NoteIndicatorColor=Red / Parent=`ColumnHeaderDefaultEnhanced`.

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A1 | 메인 this.Load | `Form_Load` (.ctor:102) | InitControls > SetChangedControl(140) | `biz:CommonData.CommonDataList` [code=PlantCell] | clbFromSite 목록 |
| A2 | 메인 필드 초기화 | `<field:dtMyDivision>`:45, `<field:dtYesOrNo>`:47 | 공통코드 준비 | `biz:CommonData.CommonDataList` [code=MyDivision], `biz:CommonData.YesOrNo` | dtMyDivision → 신규 행 DIVISION_ID 콤보, dtYesOrNo 사용처 **확인 필요** |
| A3 | cboDivision.SelectedIndexChanged | `CboDivision_SelectedIndexChanged` (InitEvent:175) | SetChangedControl(140), GetCheckedListValue(139) | `biz:CommonData.CommonDataList` [code=PlantCell] | clbFromSite 목록 재설정 |
| A4 | 조회(FindButton) | FindButton > FindData_Main (274) | GetCheckedListValue(258·259)로 조건 구성 | `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` | 시트 `Shipment Requestor PIC` 바인딩 |
| A5 | 편집(EditButton) | EditButton > GetSSPUserCheck (511) | 사용자 정보·권한 확인 | `SSP.SSP0002_GET_USER_INFO_LIST` | 편집 허용 여부(**확인 필요**) |
| A6 | 행 추가(InsertRow, 진입 버튼 **확인 필요**) | InsertRow (318·320) | 시트 잠금 해제 + 시트명 일치 시 셀 콤보 설정 | `biz:CommonData.CommonDataList` [code=MyDivision], [code=PlantCell] | 신규 행 DIVISION_ID·SITE_DESCRIPTION 콤보 |
| A7 | spdMain.CellClick | `SpdMain_CellClick` (InitEvent:172) | 잠금 해제 + Action=`"I"` + 컬럼=`SITE_DESCRIPTION`이면 콤보 재설정(640) | `biz:CommonData.CommonDataList` [code=PlantCell] | SITE_DESCRIPTION 콤보 갱신 |
| A8 | spdMain.TopChange | `SpdMain_TopChange` (InitEvent:170) | 본문 **확인 필요** | 없음 | **확인 필요** |
| A9 | spdMain.CellDoubleClick | `SpdMain_CellDoubleClick` (InitEvent:171) | 본문 **확인 필요** | 없음 | **확인 필요** |
| A10 | spdMain.ComboSelChange | `SpdMain_ComboSelChange` (InitEvent:173) | 본문 **확인 필요** | 없음 | **확인 필요** |
| A11 | 저장(SaveButton) | SaveButton > SaveData (410) > GetUserIDChk (458) > FindData_Main (274) | 사용자 ID 확인, 저장, 재조회(순서 **확인 필요**) | `SSP.SSP0025_GET_USER_ID_CHECK`, `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`, `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC` | SSP_MST_MODEL_USER_EE MERGE, 그리드 재조회 |
| A12 | btnItemId.Click | `btnItemId_Click` (InitEvent:177) | 팝업 호출 후 결과 반영 | (팝업 경유) `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | `txtItemId.Text = popItem.ItemId` (718) |
| A13 | btnModelId.Click | `btnModelId_Click` (InitEvent:178) | 팝업 호출 후 결과 반영 | (팝업 경유) `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | `txtModelId.Text = popItem.ModelId` (736) |
| A14 | 팝업 this.Load | `Form_Load` (.ctor:172) | InitControls(201~206) > FindData(296) | `biz:CommonData.CommonDataList` [code=FromSiteByAssembly], `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | 조건 초기값 설정, 시트 `Project` 바인딩 |
| A15 | 팝업 clbDivisionId.SelectedIndexChanged | `clbDivision_SelectedIndexChanged` (InitializeComponent:188) | `c["DIVISION_ID"]`(358) 기준 From Site 재조회 | `biz:CommonData.CommonDataList` [code=FromSiteByAssembly] | clbFromSiteId 목록 |
| A16 | 팝업 btnButtonList | `btnButtonList_UsrButtonList_Click_Detected` (InitializeComponent:281) | FindData(296) | `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | 시트 `Project` 재조회 |
| A17 | 팝업 조회(FindButton) | FindButton > FindData (296) | FindData | `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP` | 시트 `Project` 재조회 |
| A18 | 팝업 spdMain.CellDoubleClick | `spdMain_CellDoubleClick` (InitializeComponent:362) | 본문 **확인 필요**(선택값 반환으로 보이나 미확인) | 없음 | **확인 필요** |

엔드포인트 전체 목록(업무분석서 §5와 같음): `biz:CommonData.CommonDataList`, `biz:CommonData.YesOrNo`, `SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP`, `SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC`, `SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`, `SSP.SSP0025_GET_USER_ID_CHECK`, `SSP.SSP0002_GET_USER_INFO_LIST`.

## 6. 검증·메시지

| # | 검증 | 근거 | 메시지 |
|---|---|---|---|
| V1 | Division 필수 표시(`Div*`) | props.csv:392 | 메시지 원문 **확인 필요** |
| V2 | 저장 시 사용자 ID 존재 확인(`SSP.SSP0025_GET_USER_ID_CHECK`, TB_FX_USER) | flow.csv GetUserIDChk:458 | 메시지 원문 **확인 필요** |
| V3 | 시트 잠금(`IsLock`)이면 행 추가 콤보·셀 콤보 설정 생략 | grid_code.csv:318·320·640 | 메시지 없음(Fact Pack 기준) |
| V4 | 그리드 라벨 `*` 컬럼(ITEM_ID, SITE_DESCRIPTION, USER_ID, VALID_YN)의 필수 검증 | grid_effective.csv | 검증 수행 여부·메시지 **확인 필요** |
| V5 | Fact Pack §7 "확인 필요(메시지 하드코딩 등)" | 0건 | - |

## 7. 권한(C/R/U/D) 사실

| 항목 | 사실 |
|---|---|
| TB_FX_GroupMenuAuth | SSP0025 행 12건. C/R/U/D 플래그 값은 **확인 필요** |
| TB_FX_ProgramInfo / TB_FX_MenuItemInfo | 각 1건 |
| TB_FX_SearchCondition | 4건(저장된 조회조건) |
| TB_FX_Favorite | 5건 |
| 편집 진입 | EditButton → `SSP.SSP0002_GET_USER_INFO_LIST`(TB_FX_USERGROUPAUTHEXTENTION 등 조회) |
| 신규 행 Division | MyDivision(NowGroupID·UserId) → 사용자 권한 Division만 표시 |
| 시트 잠금 | `siMain.IsLock(SheetName)` |

## 8. To-Be 전환 메모 (Wijmo·Oracle)

| # | As-Is | To-Be 관점 |
|---|---|---|
| M1 | FarPoint Spread 시트 `Shipment Requestor PIC`(메타 SCM_MST_SHEET_COLUMNS 19행) | Wijmo FlexGrid. 컬럼은 같은 메타(PROGRAM_ID=SSP0025, SHEET_NAME=`Shipment Requestor PIC`)에서 생성 |
| M2 | 팝업 시트 `Project`(하드코딩 11컬럼, 메타 없음) | 메타 신규 등록 또는 코드 정의 중 결정 필요(미확정) |
| M3 | `SetCellTypeCombo`로 신규 행에서만 DIVISION_ID / SITE_DESCRIPTION 콤보 | FlexGrid 행 상태(신규) 기반 셀 에디터(DataMap) 전환. PlantCell은 행의 Division에 종속 |
| M4 | `cellTypeImage` 3컬럼 | 대상 컬럼 확인 후 아이콘 셀 템플릿으로 표현(미확정) |
| M5 | UsrCheckedList(clbFromSite, clbFromSiteId, clbDivisionId) | MultiSelect. 값은 CODE(GetCheckedListValue) |
| M6 | UsrMultiLineEditor(txtItemId, txtModelId) | 다중값 입력. SP의 STRING_SPLIT / SCM_ARR_SPL_CNT·SCM_ARR_SPL_VAL은 Oracle 대응 함수·객체로 변환 필요(존재 여부 미확인) |
| M7 | MSSQL SP 5종 | Oracle 19c 변환 대상: `SSP0025_GET_ITEM_BY_DIVISION_POPUP`, `SSP0025_GET_SHIPMENT_REQUESTOR_PIC`, `SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC`(MERGE, PR_SCM_SYS_LOG_BATCH), `SSP0025_GET_USER_ID_CHECK`, `SSP0002_GET_USER_INFO_LIST`(SSP0002와 공용) |
| M8 | Form Text `"SSP0014_ShipmentModelPIC"` | To-Be 화면 제목 기준 확정 필요 |
| M9 | usrButton1, usrLayoutControl1(팝업), imageList1 | 사용 여부 확인 후 To-Be 반영 여부 결정 |

## 9. 미확정

1. 메인 Form Text와 메뉴 위치.
2. SaveData 내부 호출 순서(GetUserIDChk / SAVE / FindData_Main)와 오류 처리.
3. EditButton(GetSSPUserCheck)의 편집 허용 조건.
4. InsertRow 진입 버튼.
5. `cellTypeImage` 적용 컬럼 3개.
6. `dtYesOrNo` 사용처(VALID_YN 콤보 여부), cboDivision 콤보 원천.
7. `SpdMain_TopChange` / `SpdMain_CellDoubleClick` / `SpdMain_ComboSelChange` / 팝업 `spdMain_CellDoubleClick`의 본문 동작.
8. `popItem`의 타입과 생성 위치, 메인→팝업 Division 전달 방식.
9. 메인 시트 컬럼의 메타 순번·폭·편집 가능 여부.
10. usrButton1 / usrLayoutControl1 / imageList1 사용 여부.
