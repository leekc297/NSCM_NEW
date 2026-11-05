# SCP0020 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → React/Wijmo 컴포넌트 매핑

| AS-IS 컨트롤 | 유형 | 라벨(원문) | 필수 표시 | TO-BE 컴포넌트 후보 | 데이터 원천(사실) |
|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Division*` | * | 단일 선택 콤보 (Wijmo ComboBox 계열) | **확인 필요**. LookupCommon(InitControls:220) 대상인지 미확정 |
| clbPlantSite | UsrCheckedList | `Plant Site` | - | 멀티 선택 체크리스트 (Wijmo MultiSelect 계열) | RefreshPlantSiteByDivision:292 (GetCheckedListValue CODE) |
| cboOperationGroup | UsrCombo | `Operation Group*` | * | 단일 선택 콤보 | **확인 필요** |
| clbLine | UsrCheckedList | `Line` | - | 멀티 선택 체크리스트 | RefreshLineByOperation:301·302, RefreshLineByPlantPacker:327·328 / LineByOperation(DefineProperty:199) 관련 가능성은 **확인 필요** |
| txtItemId | UsrMultiLineEditor | `Model` | - | 다중 행 입력(멀티라인 텍스트) | 사용자 입력. btnItemId_Click에서 값 설정 |
| btnItemId | UsrButton | (LayoutControlItem4 Text 없음) | - | 입력칸 옆 아이콘 버튼 | `btnItemId_Click` → txtItemId.Text = sItemId. 팝업 여부는 **확인 필요** |
| cboValid | UsrComboBox | `Valid` | - | 단일 선택 콤보 | `biz:CommonData.YesOrNo` (InitControls:218 DataBind CODE/NAME) |
| spdMain | FpSpread | 시트 `Plant` / `Packer` | - | Wijmo FlexGrid + 시트 탭 | SCP0020_GET_TACT_TIME / SCP0020_GET_TACT_TIME_OSP |
| spdExcept | FpSpread | 시트 `Tact Time Except` | - | Wijmo FlexGrid | SCP0020_GET_TACT_TIME_EXCEPT / SCP0020_GET_TACT_TIME_EXCEPT_OSP |

## 2. 화면 배치

| 영역 | 컨트롤 | 원문 속성 | 해석 |
|---|---|---|---|
| 조회조건 | usrConditionPanel1 | Dock=Top, Size(1093, 68), UsrPanelType=HidePanel | 상단 고정 조회 영역, 접기 가능한 패널 유형 |
| 조회조건 내부 | usrLayoutControl2 / layoutControlGroup2 | Dock=Fill, Size(1093, 68) / Group Size(1093, 73) | 레이아웃 아이템이 2줄로 배치됨(아이템 높이 25·28 기준) |
| 그리드 영역 | splitContainer2 | Dock=Fill, **Orientation=Horizontal**, Size(1093, 506), **SplitterDistance=392** | **상/하 분할** |
| 상단(Panel1) | spdMain | Dock=Fill, Size(1093, 392) | 392/506 ≈ **77.5%** |
| 하단(Panel2) | spdExcept | Dock=Fill, Size(1093, 110) | 110/506 ≈ **21.7%** (나머지 4px은 분할선) |

조회조건 아이템 크기(LayoutControlItem Size):
- 1줄(높이 25): Plant Site(337×25), Division*(262×25), Operation Group*(259×25), emptySpaceItem3(215×25)
- 2줄(높이 28): Line(262×28), Model(294×28), btnItemId(43×28), Valid(259×28), emptySpaceItem1(215×28)
- 줄별 아이템의 좌우 순서는 Location 값이 Fact Pack에 없어 **확인 필요**입니다. 위 분류는 높이만 기준으로 했습니다.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

공통 사항:
- 메타 원천은 `SCM_MST_SHEET_COLUMNS`(PROGRAM_ID=SCP0020)입니다.
- division 14종(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 모두 같습니다. **division별 표시 차이는 없습니다.**
- "기본" = VISIBLE_FLAG·VALID_YN='Y'이고 DEFAULT_FLAG='Y'인 컬럼, "숨김" = 메타 숨김입니다.
- 아래 순서는 grid_effective.csv 행 순서(컬럼명 알파벳순)입니다. 실제 표시 순서는 메타 정렬 컬럼 원문으로 **확인 필요**입니다.

### 3-1. `Packer` (spdMain 시트 2, SpdSheet.shtPacker) — 표시 14 / 메타 18

| 컬럼 | 라벨 | 상태 |
|---|---|---|
| CREATED_BY | Created By | 기본 |
| CREATION_DATE | Creation Date | 기본 |
| DAILY_CAPACITY | Daily Capacity* | 기본 |
| DIVISION_ID | Division* | 기본 |
| ITEM_ID | Model* | 기본 |
| LAST_UPDATE_DATE | Last Update Date | 기본 |
| LAST_UPDATED_BY | Last Updated By | 기본 |
| LINE_ID | Line* | 기본 (셀 콤보: InsertButton:864) |
| NICK_NAME | Nick Name | 기본 |
| OSP_YN | OSP_YN | 기본 |
| PRIORITY | Priority* | 기본 |
| SITE_DESCRIPTION | Plant Site* | 기본 |
| TACT_TIME | Tact Time* | 기본 |
| YIELD | Yield(%)* | 기본 |
| EXCEPT_YN | EXCEPT_YN | 숨김 |
| INPUT_STATUS | INPUT_STATUS | 숨김 |
| OPERATION_ID | OPERATION_ID | 숨김 |
| PLANT_SITE_ID | PLANT_SITE_ID | 숨김 |
| (OPERATION_NAME) | - | CODE_ONLY_CHANGE. 메타 행 없음. 귀속은 **확인 필요**(analysis.md §7 #9) |

### 3-2. `Plant` (spdMain 시트 1, SpdSheet.shtMain) — 표시 23 / 메타 33

| 컬럼 | 라벨 | 상태 |
|---|---|---|
| ACTUAL_CAPACITY | Actual Capacity | 기본 |
| BIG_LAST_UPDATE_DATE | Big Last Update Date | 기본 |
| BIG_TACT_TIME | Big Tact Time | 기본 |
| BOM_MIN_DUE_DATE | Due Date | 기본 |
| CREATED_BY | Created By | 기본 |
| CREATION_DATE | Creation Date | 기본 |
| DAILY_CAPACITY | Daily Capacity | 기본 |
| DIVISION_ID | Division | 기본 |
| ITEM_ID | Model | 기본 |
| ITEM_UOM | Item UOM | 기본 |
| JUMBO_MIN | Jumbo / Min | 기본 |
| LANE_QTY | Slitting Lane | 기본 |
| LAST_UPDATE_DATE | Last Update Date | 기본 |
| LAST_UPDATED_BY | Last Updated By | 기본 |
| LINE_ID | Line* | 기본 (셀 콤보: SpdMain_CellClick:2583, EditButton:641, ClipboardPasted:2773) |
| MODEL_SITE | Model Site | 기본 |
| NICK_NAME | Nick Name | 기본 |
| OPERATION_NAME | Operation | 기본 |
| PLANT_SITE_NAME | Plant Site | 기본 |
| PRIORITY | Priority* | 기본 |
| TACT_TIME | Tact Time* | 기본 |
| UOM_CONVERT_VALUE | UOM Convert | 기본 |
| YIELD | Yield(%)* | 기본 |
| ACTUAL_OUTPUT | Actual Output | 숨김 |
| EFFECTIVE_DATA_COUNT | Effective Data Count | 숨김 |
| EXCEPT_YN | EXCEPT_YN | 숨김 |
| FROM_ACTUAL_CAPACITY | From Actual Capacity | 숨김 |
| INPUT_STATUS | INPUT_STATUS | 숨김 |
| OPERATION_GROUP_ID | OPERATION_GROUP_ID | 숨김 |
| OPERATION_ID | OPERATION_ID | 숨김 |
| PLANT_SITE_ID | PLANT_SITE_ID | 숨김 |
| TO_ACTUAL_CAPACITY | To Actual Capacity | 숨김 |
| VALID_YN | Valid* | 숨김 |

### 3-3. `Tact Time` — 메타 정의만, 코드 미참조(미사용 가능) — 표시 23 / 메타 33

- 컬럼과 라벨, 상태는 `Plant` 시트와 **같습니다**(33행 동일 구성: 기본 23, 숨김 10).
- 코드(CreateSpread·ChangeSheet·SetSheetHeaderColumn)는 이 시트명을 쓰지 않습니다. TO-BE 구현 대상이 아니며 폐기 후보입니다. 최종 판단은 **확인 필요**입니다.

### 3-4. `Tact Time Except` (spdExcept, SpdSheet.shtExcept) — 표시 16 / 메타 27(메타 표시 17)

| 컬럼 | 라벨 | 상태 |
|---|---|---|
| CREATED_BY | Created By | 기본 |
| CREATION_DATE | Creation Date | 기본 |
| DAILY_CAPACITY | Daily Capacity | 기본 → 코드로 바뀜(아래 규칙) |
| DIVISION_ID | Division | 기본 |
| EXCEPT_COMMENT | Comment | 기본 |
| ITEM_ID | Model | 기본 |
| LAST_UPDATE_DATE | Last Update Date | 기본 |
| LAST_UPDATED_BY | Last Updated By | 기본 |
| LINE_ID | Line | 기본 |
| NICK_NAME | Nick Name | 기본 |
| OPERATION_NAME | Operation | 기본 → 코드로 바뀜(아래 규칙) |
| PLANT_SITE_NAME | Plant Site | 기본 |
| TACT_TIME | Tact Time* | 기본 |
| TACT_TIME_END_DATE | End Date* | 기본 |
| TACT_TIME_START_DATE | Start Date* | 기본 |
| USE_YN | Product YN | 기본 |
| YIELD | Yield(%)* | 기본 |
| INPUT_STATUS | INPUT_STATUS | 숨김 |
| OPERATION_ID | OPERATION_ID | 숨김 |
| ORG_DIVISION_ID | ORG_DIVISION_ID | 숨김 |
| ORG_ITEM_ID | ORG_ITEM_ID | 숨김 |
| ORG_LINE_ID | ORG_LINE_ID | 숨김 |
| ORG_OPERATION_ID | ORG_OPERATION_ID | 숨김 |
| ORG_PLANT_SITE_ID | ORG_PLANT_SITE_ID | 숨김 |
| ORG_TACT_TIME_END_DATE | ORG_TACT_TIME_END_DATE | 숨김 |
| ORG_TACT_TIME_START_DATE | ORG_TACT_TIME_START_DATE | 숨김 |
| PLANT_SITE_ID | PLANT_SITE_ID | 숨김 |

코드 표시 변경 규칙(InitSpread:410~416):

| spdMain 활성 시트 | DAILY_CAPACITY | OPERATION_NAME | 표시 수 |
|---|---|---|---:|
| `Plant` | 숨김(410) | 표시(411) | 16 |
| 그 외(`Packer`) | 표시(415) | 숨김(416) | 16 |

## 4. 시트 연결 규칙

| 시트 | 그리드 | 연결 규칙 | 코드 근거 |
|---|---|---|---|
| `Plant` | spdMain(시트 인덱스 0) | META+코드연결 | AddSheet:374, ChangeSheet FindData_Main:1045, SetSpreadInit:435~438, ActiveSheetChanged:2792~2793 |
| `Packer` | spdMain(시트 인덱스 1) | META+코드연결 | AddSheet:377, ChangeSheet Find_Packer:961, InitSpread:425~426, SetSpreadInit:446~449, ActiveSheetChanged:2799~2800 |
| `Tact Time Except` | spdExcept | META+코드연결 | AddSheet:384~386, InitSpread:395~416 |
| `Tact Time` | (없음) | 메타 정의만, 코드 미참조(미사용 가능) | - |

- 상단 spdMain은 시트 탭 2개(Plant/Packer)를 바꿔 가며 씁니다. 하단 spdExcept는 단일 시트입니다.
- 상단 활성 시트에 따라 조회·저장 SP 계열(일반/OSP)과 하단 Except 컬럼 표시가 바뀝니다. 다만 SP 계열 분기 조건 원문은 **확인 필요**입니다.
- 하단 Except 조회는 상단 `SpdMain_CellDoubleClick`에서 시작합니다(마스터→디테일 연결).
