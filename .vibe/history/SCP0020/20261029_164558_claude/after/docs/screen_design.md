# SCP0020 Tact Time — 화면설계서

> **근거**: Fact Pack(controls.csv, props.csv, events.csv, grid_effective.csv, grid_code.csv, flow.csv)에 있는 사실만 썼습니다. Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.
> **상호 참조**: §5 액션 명세의 엔드포인트는 업무분석서 §5와 같은 이름을 씁니다. §3 컨트롤명은 단위테스트 '절차' 열에서 그대로 씁니다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SCP0020 |
| 화면 명칭 | Tact Time. 폼 Text 원문은 `Tac Time`(철자 그대로) |
| 메뉴 위치 | **확인 필요**. TB_FX_MenuItemInfo 1행이 있으나 값은 미제공 |
| AS-IS 소스 | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs`(2909줄) / `.Designer.cs`(672줄) |
| 화면 유형 | 조회조건 + 상단 마스터 그리드(시트 2개) + 하단 디테일 그리드(시트 1개), 상/하 분할 |
| 그리드 구성 방식 | META(프레임워크, `SCM_MST_SHEET_COLUMNS` PROGRAM_ID=SCP0020 111행) + 코드 표시 변경 |

---

## 2. 화면 레이아웃

### 2-1. 분할 트리 (controls.csv parent 체인 + props.csv 크기)

기준 높이 = usrConditionPanel1(68) + splitContainer2(506) = 574px, 기준 폭 = 1093px.

```
SCP0020_TactTime (this, Text="Tac Time")                                   W1093 × H574
│
├─ usrConditionPanel1  [parent=this, Dock=Top, 1093×68, UsrPanelType=HidePanel]   ≈ 11.8%  ← 조회조건 영역
│   └─ usrLayoutControl2  [parent=usrConditionPanel1, Dock=Fill, 1093×68, Text="usrLayoutControl2"]
│       └─ layoutControlGroup2 (1093×73)
│           ├─ 행A (높이 25): layoutControlItem2[Plant Site → clbPlantSite](337)
│           │                 layoutControlItem1[Division* → cboDivision](262)
│           │                 layoutControlItem5[Operation Group* → cboOperationGroup](259)
│           │                 emptySpaceItem3(215)                          합계 1073
│           └─ 행B (높이 28): layoutControlItem6[Line → clbLine](262)
│                             layoutControlItem3[Model → txtItemId](294)
│                             layoutControlItem4[(Text 없음) → btnItemId](43)
│                             layoutControlItem9[Valid → cboValid](259)
│                             emptySpaceItem1(215)                          합계 1073
│
└─ splitContainer2  [parent=this, Dock=Fill, Orientation=Horizontal(상/하), 1093×506, SplitterDistance=392]  ≈ 88.2%
    ├─ Panel1 (상)  392/506 = 77.5%
    │   └─ spdMain  [Dock=Fill, 1093×392]   시트: Plant(인덱스 0) | Packer(인덱스 1)   (Designer 기본 시트 spdMain_Sheet1)
    ├─ Splitter     4/506 ≈ 0.8%
    └─ Panel2 (하)  110/506 = 21.7%
        └─ spdExcept [Dock=Fill, 1093×110]  시트: Tact Time Except            (Designer 기본 시트 spdExcept_Sheet1)

(parent 미기재) usrLayoutControl1 [Dock=Fill, 657×184] / layoutControlGroup1 (657×184)
   → controls.csv parent가 비어 있어 배치 위치를 알 수 없습니다(확인 필요). 하위 아이템이 없는 미사용 레이아웃으로 보입니다.
```

- 행A·행B는 LayoutControlItem의 높이(25/28)로만 나눴습니다. 행 안의 좌→우 순서는 Location이 추출되지 않아 **확인 필요**입니다(위 순서는 Designer 선언 순서가 아니라 행별 나열입니다).
- 행 폭 합계가 둘 다 1073으로 같아, 2행 그리드 배치와 일치합니다.

### 2-2. 영역 정의

| 영역 | 컨트롤 | 비율 | 비고 |
|---|---|---:|---|
| 조회조건 | usrConditionPanel1 > usrLayoutControl2 | 높이 11.8% | HidePanel(접기 가능 유형) |
| 버튼 | 프레임워크 공통 버튼(FindButton, SaveButton, InsertButton, EditButton) | - | 폼 Designer에 없음. 위치는 프레임워크 툴바로 추정되나 **확인 필요**. Delete 계열 유무는 **확인 필요** |
| 상단 그리드 | spdMain (Plant / Packer 탭) | 그리드 영역의 77.5% | 마스터 |
| 하단 그리드 | spdExcept (Tact Time Except) | 그리드 영역의 21.7% | 디테일(상단 더블클릭으로 조회) |
| 팝업 | btnItemId → `btnItemId_Click` | - | txtItemId.Text = sItemId(2560). 팝업 여부는 **확인 필요** |

---

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrLayoutControl1 | UsrLayoutControl | (Text 없음) | - | - | - | 미사용 가능. TO-BE 불필요(**확인 필요**) |
| usrConditionPanel1 | UsrConditionPanel | (Text 없음) | HidePanel | - | - | 조회조건 영역(SearchArea, 접기 가능) |
| usrLayoutControl2 | UsrLayoutControl | `usrLayoutControl2` | - | - | - | 조회조건 그리드 레이아웃 |
| cboDivision | UsrCombo | `Division*` | **확인 필요** | Y(라벨 `*`) | SelectedIndexChanged → `ClbDivision_SelectedIndexChanged` | 단일 선택 콤보(Wijmo ComboBox) |
| clbPlantSite | UsrCheckedList | `Plant Site` | **확인 필요** | - | SelectedIndexChanged → `ClbPlantSite_SelectedIndexChanged` | 멀티 선택(Wijmo MultiSelect) |
| cboOperationGroup | UsrCombo | `Operation Group*` | **확인 필요** | Y(라벨 `*`) | - | 단일 선택 콤보 |
| clbLine | UsrCheckedList | `Line` | **확인 필요** | - | - | 멀티 선택 |
| txtItemId | UsrMultiLineEditor | `Model` | - | - | (btnItemId_Click에서 값 설정) | 멀티라인 입력 |
| btnItemId | UsrButton | (layoutControlItem4 Text 없음) | - | - | Click → `btnItemId_Click` | 입력칸 옆 아이콘 버튼 |
| cboValid | UsrComboBox | `Valid` | `biz:CommonData.YesOrNo` 바인딩(CODE/NAME). 기본 선택값은 **확인 필요** | - | - | 단일 선택 콤보 |
| spdMain | FpSpread | 시트 `Plant` / `Packer` | - | - | EditModeOff → `SpdMain_EditModeOff`, EditChange → `SpdMain_EditChange`, CellDoubleClick → `SpdMain_CellDoubleClick`, TopChange → `SpdMain_TopChange`, CellClick → `SpdMain_CellClick`, ClipboardPasted → `SpdMain_ClipboardPasted`, ActiveSheetChanged → `SpdMain_ActiveSheetChanged` | Wijmo FlexGrid + 시트 탭 2개 |
| spdMain_Sheet1 | SheetView | (Designer 기본 시트) | - | - | (dsdmMain Changed → `SpdMain_Changed`, dsdmMainPacker Changed → `SpdMain_Changed_Packer`. 데이터소스 단위) | 코드 AddSheet(Plant/Packer)와의 관계는 **확인 필요** |
| spdExcept | FpSpread | 시트 `Tact Time Except` | - | - | EditModeOff → `spdExcept_EditModeOff`, EditChange → `spdExcept_EditChange`, TopChange → `SpdExcept_TopChange` | Wijmo FlexGrid |
| spdExcept_Sheet1 | SheetView | (Designer 기본 시트) | - | - | (dsdmExcept Changed → `SpdExcept_Changed`) | 코드 AddSheet(Tact Time Except)와의 관계는 **확인 필요** |

- 컨트롤 크기(props.csv): cboOperationGroup 152×20, cboDivision 207×20, txtItemId 253×21, btnItemId 39×24, cboValid 225×20, clbLine 231×21, clbPlantSite 276×21.
- 콤보 데이터 원천: cboValid만 확인됨(`biz:CommonData.YesOrNo`). cboDivision, cboOperationGroup, clbLine, clbPlantSite의 원천은 **확인 필요**입니다. 관련 메서드로 RefreshPlantSiteByDivision:292, RefreshLineByOperation:301·302, RefreshLineByOperationOfSpd:315·316, RefreshLineByPlantPacker:327·328(GetCheckedListValue CODE)이 있습니다.

---

## 4. 그리드 명세

공통:
- 출처는 모두 META(`SCM_MST_SHEET_COLUMNS`)입니다. 코드로 표시를 바꾸는 부분만 따로 적었습니다.
- division별 표시: 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 같습니다. 아래 "표시" 열은 14개 division 공통입니다.
- 타입: 메타 `CELL_CONTROL_OBJECT_TYPE_CODE` 값이 Fact Pack에 없어 **확인 필요**입니다. 코드로 콤보를 적용하는 LINE_ID만 "콤보(코드)"로 적었습니다.
- 편집 가능 여부: 메타 기준 값이 없어 **확인 필요**입니다. 코드로 콤보 편집을 여는 조건이 있는 경우만 적었습니다.
- 컬럼 순서: grid_effective.csv 행 순서(알파벳)입니다. 실제 표시 순서는 **확인 필요**입니다.
- 헤더 라벨의 `*`는 원문 그대로 옮긴 것입니다.

### 4-1. 시트 `Packer` (spdMain 인덱스 1, SpdSheet.shtPacker) — 표시 14 / 메타 18

| 컬럼 | 헤더 | 타입 | 출처 | 표시(division 공통) | 편집 |
|---|---|---|---|---|---|
| CREATED_BY | Created By | 확인 필요 | META | 기본 | 확인 필요 |
| CREATION_DATE | Creation Date | 확인 필요 | META | 기본 | 확인 필요 |
| DAILY_CAPACITY | Daily Capacity* | 확인 필요 | META | 기본 | 확인 필요 |
| DIVISION_ID | Division* | 확인 필요 | META | 기본 | 확인 필요 |
| ITEM_ID | Model* | 확인 필요 | META | 기본 | 확인 필요 |
| LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 기본 | 확인 필요 |
| LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 기본 | 확인 필요 |
| LINE_ID | Line* | 콤보(코드) | META(+코드 SetCellTypeCombo) | 기본 | InsertButton:864(Packer, 잠금 아님), EditButton:641(INPUT_STATUS="I") 조건에서 콤보 |
| NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| OSP_YN | OSP_YN | 확인 필요 | META | 기본 | 확인 필요 |
| PRIORITY | Priority* | 확인 필요 | META | 기본 | 확인 필요 |
| SITE_DESCRIPTION | Plant Site* | 확인 필요 | META | 기본 | 확인 필요 |
| TACT_TIME | Tact Time* | 확인 필요 | META | 기본 | 확인 필요 |
| YIELD | Yield(%)* | 확인 필요 | META | 기본 | 확인 필요 |
| EXCEPT_YN | EXCEPT_YN | - | META | 숨김 | - |
| INPUT_STATUS | INPUT_STATUS | - | META | 숨김 | - |
| OPERATION_ID | OPERATION_ID | - | META | 숨김 | - |
| PLANT_SITE_ID | PLANT_SITE_ID | - | META | 숨김 | - |
| (OPERATION_NAME) | (없음) | - | CODE_ONLY_CHANGE | - | 메타 행 없음. 코드 변경 대상은 Tact Time Except이므로 파서 귀속 오류 가능성 있음(**확인 필요**) |

### 4-2. 시트 `Plant` (spdMain 인덱스 0, SpdSheet.shtMain) — 표시 23 / 메타 33

| 컬럼 | 헤더 | 타입 | 출처 | 표시 | 편집 |
|---|---|---|---|---|---|
| ACTUAL_CAPACITY | Actual Capacity | 확인 필요 | META | 기본 | 확인 필요 |
| BIG_LAST_UPDATE_DATE | Big Last Update Date | 확인 필요 | META | 기본 | 확인 필요 |
| BIG_TACT_TIME | Big Tact Time | 확인 필요 | META | 기본 | 확인 필요 |
| BOM_MIN_DUE_DATE | Due Date | 확인 필요 | META | 기본 | 확인 필요 |
| CREATED_BY | Created By | 확인 필요 | META | 기본 | 확인 필요 |
| CREATION_DATE | Creation Date | 확인 필요 | META | 기본 | 확인 필요 |
| DAILY_CAPACITY | Daily Capacity | 확인 필요 | META | 기본 | 확인 필요 |
| DIVISION_ID | Division | 확인 필요 | META | 기본 | 확인 필요 |
| ITEM_ID | Model | 확인 필요 | META | 기본 | 확인 필요 |
| ITEM_UOM | Item UOM | 확인 필요 | META | 기본 | 확인 필요 |
| JUMBO_MIN | Jumbo / Min | 확인 필요 | META | 기본 | 확인 필요 |
| LANE_QTY | Slitting Lane | 확인 필요 | META | 기본 | 확인 필요 |
| LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 기본 | 확인 필요 |
| LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 기본 | 확인 필요 |
| LINE_ID | Line* | 콤보(코드) | META(+코드 SetCellTypeCombo) | 기본 | SpdMain_CellClick:2583(IsLock("Plant")=false, IsLockCell=false, 활성 시트 Plant), SpdMain_ClipboardPasted:2773 조건에서 콤보 |
| MODEL_SITE | Model Site | 확인 필요 | META | 기본 | 확인 필요 |
| NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| OPERATION_NAME | Operation | 확인 필요 | META | 기본 | 확인 필요 |
| PLANT_SITE_NAME | Plant Site | 확인 필요 | META | 기본 | 확인 필요 |
| PRIORITY | Priority* | 확인 필요 | META | 기본 | 확인 필요 |
| TACT_TIME | Tact Time* | 확인 필요 | META | 기본 | 확인 필요 |
| UOM_CONVERT_VALUE | UOM Convert | 확인 필요 | META | 기본 | 확인 필요 |
| YIELD | Yield(%)* | 확인 필요 | META | 기본 | 확인 필요 |
| ACTUAL_OUTPUT | Actual Output | - | META | 숨김 | - |
| EFFECTIVE_DATA_COUNT | Effective Data Count | - | META | 숨김 | - |
| EXCEPT_YN | EXCEPT_YN | - | META | 숨김 | - |
| FROM_ACTUAL_CAPACITY | From Actual Capacity | - | META | 숨김 | - |
| INPUT_STATUS | INPUT_STATUS | - | META | 숨김 | - |
| OPERATION_GROUP_ID | OPERATION_GROUP_ID | - | META | 숨김 | - |
| OPERATION_ID | OPERATION_ID | - | META | 숨김 | - |
| PLANT_SITE_ID | PLANT_SITE_ID | - | META | 숨김 | - |
| TO_ACTUAL_CAPACITY | To Actual Capacity | - | META | 숨김 | - |
| VALID_YN | Valid* | - | META | 숨김 | - |

### 4-3. 시트 `Tact Time` — 메타 정의만 있고 코드 미참조(미사용 가능), 표시 23 / 메타 33

- 코드(CreateSpread, ChangeSheet, SetSheetHeaderColumn)는 이 시트명을 쓰지 않습니다. TO-BE 구현 대상이 아니며 폐기 후보입니다(**확인 필요**).
- 메타 정의(grid_effective.csv 원문, 출처 META, 14개 division 공통):
  - 기본 23: ACTUAL_CAPACITY(Actual Capacity), BIG_LAST_UPDATE_DATE(Big Last Update Date), BIG_TACT_TIME(Big Tact Time), BOM_MIN_DUE_DATE(Due Date), CREATED_BY(Created By), CREATION_DATE(Creation Date), DAILY_CAPACITY(Daily Capacity), DIVISION_ID(Division), ITEM_ID(Model), ITEM_UOM(Item UOM), JUMBO_MIN(Jumbo / Min), LANE_QTY(Slitting Lane), LAST_UPDATE_DATE(Last Update Date), LAST_UPDATED_BY(Last Updated By), LINE_ID(Line*), MODEL_SITE(Model Site), NICK_NAME(Nick Name), OPERATION_NAME(Operation), PLANT_SITE_NAME(Plant Site), PRIORITY(Priority*), TACT_TIME(Tact Time*), UOM_CONVERT_VALUE(UOM Convert), YIELD(Yield(%)*)
  - 숨김 10: ACTUAL_OUTPUT, EFFECTIVE_DATA_COUNT, EXCEPT_YN, FROM_ACTUAL_CAPACITY, INPUT_STATUS, OPERATION_GROUP_ID, OPERATION_ID, PLANT_SITE_ID, TO_ACTUAL_CAPACITY, VALID_YN(Valid*)
- 구성이 `Plant` 시트 33행과 같습니다.

### 4-4. 시트 `Tact Time Except` (spdExcept, SpdSheet.shtExcept) — 표시 16 / 메타 27(메타 표시 17)

| 컬럼 | 헤더 | 타입 | 출처 | 표시 | 편집 |
|---|---|---|---|---|---|
| CREATED_BY | Created By | 확인 필요 | META | 기본 | 확인 필요 |
| CREATION_DATE | Creation Date | 확인 필요 | META | 기본 | 확인 필요 |
| DAILY_CAPACITY | Daily Capacity | 확인 필요 | META+코드 | 상단 Plant 활성 시 숨김(410), 그 외 표시(415) | 확인 필요 |
| DIVISION_ID | Division | 확인 필요 | META | 기본 | 확인 필요 |
| EXCEPT_COMMENT | Comment | 확인 필요 | META | 기본 | 확인 필요 |
| ITEM_ID | Model | 확인 필요 | META | 기본 | 확인 필요 |
| LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 기본 | 확인 필요 |
| LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 기본 | 확인 필요 |
| LINE_ID | Line | 확인 필요 | META | 기본 | 확인 필요 |
| NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| OPERATION_NAME | Operation | 확인 필요 | META+코드 | 상단 Plant 활성 시 표시(411), 그 외 숨김(416) | 확인 필요 |
| PLANT_SITE_NAME | Plant Site | 확인 필요 | META | 기본 | 확인 필요 |
| TACT_TIME | Tact Time* | 확인 필요 | META | 기본 | 확인 필요 |
| TACT_TIME_END_DATE | End Date* | 확인 필요 | META | 기본 | 확인 필요 |
| TACT_TIME_START_DATE | Start Date* | 확인 필요 | META | 기본 | 확인 필요 |
| USE_YN | Product YN | 확인 필요 | META | 기본 | 확인 필요 |
| YIELD | Yield(%)* | 확인 필요 | META | 기본 | 확인 필요 |
| INPUT_STATUS | INPUT_STATUS | - | META | 숨김 | - |
| OPERATION_ID | OPERATION_ID | - | META | 숨김 | - |
| ORG_DIVISION_ID | ORG_DIVISION_ID | - | META | 숨김 | - |
| ORG_ITEM_ID | ORG_ITEM_ID | - | META | 숨김 | - |
| ORG_LINE_ID | ORG_LINE_ID | - | META | 숨김 | - |
| ORG_OPERATION_ID | ORG_OPERATION_ID | - | META | 숨김 | - |
| ORG_PLANT_SITE_ID | ORG_PLANT_SITE_ID | - | META | 숨김 | - |
| ORG_TACT_TIME_END_DATE | ORG_TACT_TIME_END_DATE | - | META | 숨김 | - |
| ORG_TACT_TIME_START_DATE | ORG_TACT_TIME_START_DATE | - | META | 숨김 | - |
| PLANT_SITE_ID | PLANT_SITE_ID | - | META | 숨김 | - |

코드 표시 변경 규칙(InitSpread, 조건 `spreadInfo.SheetName == "Tact Time Except"`):

| spdMain 활성 시트 | DAILY_CAPACITY | OPERATION_NAME | 표시 컬럼 수 |
|---|---|---|---:|
| `Plant` | 숨김(410) | 표시(411) | 16 |
| 그 외(`Packer`) | 표시(415) | 숨김(416) | 16 |

- Designer 522~525·575~578줄: 컬럼헤더 기본 스타일(HorizontalAlignment General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced, VerticalAlignment General).

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A01 | 화면 Load | `Form_Load` | DefineProperty:199, InitControls:218·220 | `biz:CommonData.CommonDataList` [code=LineByOperation], `biz:CommonData.YesOrNo`, `biz:CommonData.CommonDataList` [code=LookupCommon] | cboValid 바인딩. LookupCommon과 LineByOperation 결과의 반영 대상은 **확인 필요** |
| A02 | (필드 초기화) | `<field:dtValidYN>`:57, `<field:dtYesOrNo>`:58 | 진입점 미연결 | `biz:CommonData.YesOrNo` | **확인 필요** |
| A03 | 조회(FindButton) — Plant | FindButton → Find_Data → FindData_Main | LineByOperation 재조회 → GET → ChangeSheet(Plant, 1045) | `biz:CommonData.CommonDataList` [code=LineByOperation], `SCP.SCP0020_GET_TACT_TIME` | spdMain `Plant` |
| A04 | 조회(FindButton) — Packer | FindButton → Find_Data → Find_Packer | GET → ChangeSheet(Packer, 961) | `SCP.SCP0020_GET_TACT_TIME_OSP` | spdMain `Packer` |
| A05 | 저장(SaveButton) — Plant | SaveButton → SaveData_Main | SAVE → ERR_MESSAGE(1874) → FindData_Main | `SCP.SCP0020_SAVE_TACT_TIME` → `SCP.SCP0020_GET_TACT_TIME` | spdMain `Plant` 재조회 |
| A06 | 저장(SaveButton) — Packer | SaveButton → SaveData_Packer | SAVE → ERR_MESSAGE(1622) → Find_Packer | `SCP.SCP0020_SAVE_TACT_TIME_OSP` → `SCP.SCP0020_GET_TACT_TIME_OSP` | spdMain `Packer` 재조회 |
| A07 | 저장(SaveButton) — Except(Packer 계열) | SaveButton → SaveData_Except_Packer | SAVE → ERR_MESSAGE(2094) → FindData_Except_Packer | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` → `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` | spdExcept `Tact Time Except` 재조회 |
| A08 | 저장(SaveButton) — Except(Plant 계열) | SaveButton → SaveData_Except | SAVE → ERR_MESSAGE(2297) → FindData_Except | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT` → `SCP.SCP0020_GET_TACT_TIME_EXCEPT` | spdExcept `Tact Time Except` 재조회 |
| A09 | 행 추가(InsertButton) | InsertButton | Packer 시트, 잠금 아님 → LINE_ID SetCellTypeCombo(864). CODE/NAME(859~860) | - (클라이언트) | 새 행 LINE_ID 콤보 |
| A10 | 편집(EditButton) | EditButton | 시트 인덱스 0: GetSheetInfo(563). 인덱스 1: GetSheetInfo(607), INPUT_STATUS="I"이면 LINE_ID 콤보(641). spdExcept: GetSheetInfo(673) | - | 편집 모드 |
| A11 | btnItemId 클릭 | `btnItemId_Click` | txtItemId.Text = sItemId(2560) | - (팝업 여부 **확인 필요**) | txtItemId 값 |
| A12 | cboDivision 변경 | `ClbDivision_SelectedIndexChanged` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A13 | clbPlantSite 변경 | `ClbPlantSite_SelectedIndexChanged` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A14 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | FindData_Except_Packer 또는 FindData_Except(분기 **확인 필요**) | `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` / `SCP.SCP0020_GET_TACT_TIME_EXCEPT` | spdExcept `Tact Time Except` |
| A15 | spdMain 셀 클릭 | `SpdMain_CellClick` | Plant·잠금 아님·LINE_ID → SetCellTypeCombo(2583) | - (LineByOperation 캐시 또는 Data.Common) | LINE_ID 콤보 |
| A16 | spdMain 붙여넣기 | `SpdMain_ClipboardPasted` | 범위 안 LINE_ID 셀에 SetCellTypeCombo(2773). CODE/NAME(2769~2770) | - | LINE_ID 콤보 |
| A17 | spdMain 시트 탭 전환 | `SpdMain_ActiveSheetChanged` | Plant → shtMain(2792~2793), Packer → shtPacker(2799~2800) | - | 활성 시트 정보 전환 |
| A18 | spdMain 스크롤 | `SpdMain_TopChange` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A19 | spdExcept 스크롤 | `SpdExcept_TopChange` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A20 | spdMain 편집 종료 | `SpdMain_EditModeOff` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A21 | spdMain 편집 변경 | `SpdMain_EditChange` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A22 | spdExcept 편집 종료 | `spdExcept_EditModeOff` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A23 | spdExcept 편집 변경 | `spdExcept_EditChange` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A24 | dsdmMain 변경 | `SpdMain_Changed` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A25 | dsdmMainPacker 변경 | `SpdMain_Changed_Packer` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A26 | dsdmExcept 변경 | `SpdExcept_Changed` | 내부 동작 **확인 필요** | - | **확인 필요** |

- 저장 액션 A05~A08 중 무엇이 실행될지 정하는 조건은 **확인 필요**입니다.
- `SetChangedControl_Osp`(362~363줄)는 CODE/NAME을 읽지만 이벤트 배선이 없습니다. 호출하는 곳은 **확인 필요**입니다.

---

## 6. 검증·메시지

| 항목 | 사실 | 상태 |
|---|---|---|
| 조회 필수 | 라벨 `Division*`, `Operation Group*` | 검증 코드와 메시지 ID는 **확인 필요** |
| 그리드 필수 | 헤더 `*` 컬럼(§4) | 검증 주체(FE 또는 SP)는 **확인 필요** |
| 저장 결과 | 저장 SP 4종의 `ERR_MESSAGE`(1622/1874/2094/2297) | 판정 조건과 메시지 ID는 **확인 필요** |
| 잠금 | `IsLock`/`IsLockCell`이 거짓일 때만 LINE_ID 콤보 | 잠금일 때 메시지가 있는지는 **확인 필요** |

---

## 7. 권한(C/R/U/D)

| 항목 | 사실 |
|---|---|
| 권한 메타 | `TB_FX_GroupMenuAuth` 13행. C/R/U/D 값은 **확인 필요** |
| 확인된 공통 버튼 | FindButton(R), SaveButton(C/U/D — 저장 SP 안에 INSERT/UPDATE/DELETE 포함), InsertButton(C), EditButton(U) |
| Delete 버튼 | Fact Pack에 없음(**확인 필요**). 저장 SP에 DELETE가 있음 |
| 잠금 | `siMain.IsLock(...)`. 권한 연동 여부는 **확인 필요** |

---

## 8. To-Be 전환 메모 (Wijmo·Oracle)

| 영역 | AS-IS | TO-BE 고려사항 |
|---|---|---|
| 레이아웃 | SplitContainer 상/하 392:110 | 상단 FlexGrid(탭 Plant/Packer) 약 77.5%, 하단 FlexGrid 약 21.7%의 상하 분할 |
| 시트 탭 | spdMain 시트 2개 | 탭 전환 시 GET/SAVE 계열(일반/OSP)과 하단 Except 컬럼 표시(DAILY_CAPACITY↔OPERATION_NAME)를 함께 바꿔야 함 |
| 그리드 메타 | SCM_MST_SHEET_COLUMNS 기반 SetSheetHeaderColumn | TO-BE 메타(SHEET_COLUMNS)를 그대로 가져와 시트명 `Plant`/`Packer`/`Tact Time Except` 기준으로 생성. `Tact Time`은 제외 후보 |
| 셀 콤보 | SetCellTypeCombo(LINE_ID) 조건부 | Wijmo DataMap으로 셀 단위 콤보 구성. 조건(잠금·Plant/Packer·INPUT_STATUS="I")은 유지 |
| 마스터-디테일 | CellDoubleClick → Except 조회 | 행 더블클릭 이벤트에 하단 조회 연결 |
| 임시 테이블 | `#TBLDYNAMICPIVOT_SCP0020_TMP`, `_TMP1`, `_SAVE_TMP`, `#TBLDYNAMIC_SCP0020` | Oracle GTT로 전환 |
| MSSQL 함수 | `STRING_SPLIT`, `FN_SCM_SPLIT`, `SCM_ARR_SPL_CNT/VAL` | Oracle 대체 구현 필요(존재 여부 **확인 필요**) |
| 하위 PR | `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`, `PR_SCP_MST_TACT_TIME_HIST` | Oracle 쪽 존재 여부 **확인 필요** |
| 저장 결과 | `ERR_MESSAGE` | 결과 커서의 성공/실패 판정 방식을 TO-BE 공통 계약에 맞춰야 함 |

---

## 9. 미확정

| # | 항목 |
|---:|---|
| 1 | 메뉴 위치 |
| 2 | 조회조건 행 안의 좌우 순서(Location 미추출) |
| 3 | usrLayoutControl1의 배치 위치(parent 미기재) |
| 4 | spdMain_Sheet1·spdExcept_Sheet1과 코드 AddSheet 시트의 관계 |
| 5 | 콤보 4종(cboDivision, cboOperationGroup, clbLine, clbPlantSite)의 데이터 원천과 초기값 |
| 6 | btnItemId 팝업 여부 |
| 7 | 내부 동작이 미추출된 이벤트 핸들러 11개 |
| 8 | 조회·저장·더블클릭의 분기 조건 |
| 9 | 그리드 컬럼의 타입·편집 가능 여부·표시 순서 |
| 10 | Packer `OPERATION_NAME` CODE_ONLY_CHANGE 귀속 |
| 11 | SetSpreadInit:442 `ActiveSheet.Visible=false`의 분기 귀속 |
| 12 | 권한 C/R/U/D 값과 Delete 버튼 |
