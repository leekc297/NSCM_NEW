# SSP0012 화면설계서 — Shipment Plan Confirm Detail

> **작성 근거**: AsisFacts Fact Pack(SSP0012). controls.csv, props.csv, events.csv, grid_*.csv 를 사용했습니다.
> **표기**: 사실이 없으면 **확인 필요**로 적었습니다.
> **관련 문서**: 업무분석서 §5와 엔드포인트 이름이 같고, 단위테스트 절차 열에서 §3의 컨트롤명을 그대로 씁니다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0012 |
| 화면명(폼 Text) | `Shipment Plan Confirm` (Designer.cs:545) |
| 클래스 | `SSP0012_ShipmentPlanConfirmDetail` |
| 프로젝트 | `06.UIL\GSCM.SSP.Plan.UIL` |
| 메뉴 위치 | **확인 필요** (`TB_FX_MenuItemInfo` 4행의 내용 미추출) |
| 화면 유형 | 조회 전용(조회조건 + 단일 그리드) |
| 그리드 시트 | `Shipment Plan Confirm Detail` (1개) |
| 소스 | `SSP0012_ShipmentPlanConfirmDetail.cs`(619줄), `SSP0012_ShipmentPlanConfirmDetail.Designer.cs`(598줄) |

---

## 2. 화면 레이아웃

### 2-1. 분할 구조

- props.csv 에 **SplitContainer(Orientation·SplitterDistance)가 없습니다**. 그래서 분할 트리는 Dock 속성과 controls.csv 의 parent 체인으로 그렸습니다.

**parent 체인 (controls.csv)**

```
this (Form, Text="Shipment Plan Confirm")
├─ usrConditionPanel1   [UsrConditionPanel, Dock=Top, 1192×73, UsrPanelType=HidePanel]
│   └─ usrLayoutControl2 [UsrLayoutControl, Dock=Top, 1192×73, Text="usrLayoutControl2"]
│       ├─ clbPlantSite   (layoutControlItem7 "From Site", 161×29)
│       ├─ txtItemId      (lblItemId "Model", 313×29)
│       ├─ btnItemId      (layoutControlItem2, Text 없음, 43×29)
│       ├─ drpPeriod      (layoutControlItem6 "Period*", 309×29)
│       ├─ clbDivision    (lcDivision "Division", 148×29)
│       ├─ txtSoldToParty (layoutControlItem1 "Sold To Party", 356×29)
│       ├─ txtShipToParty (layoutControlItem3 "Ship To Party", 351×29)
│       └─ btnColumn      (layoutControlItem5, Text 없음, 43×29)
│       (layoutControlGroup2 1192×78 · emptySpaceItem3 464×29 · emptySpaceItem1 156×29)
├─ spdMain              [FpSpread, Dock=Fill, 1192×576]
│   └─ spdMain_Sheet1   [SheetView] → 시트 "Shipment Plan Confirm Detail"
└─ (parent 없음) usrButton1 [UsrButton, 75×23] — 배치 여부 확인 필요
   (parent 없음) imageList1 [ImageList]
```

### 2-2. 텍스트 와이어프레임 (상/하 2단, 높이 비율 = 73 : 576)

```
┌──────────────────────────────────────────────────────────────────────────────┐ ─┐
│ usrConditionPanel1 (HidePanel · 접기 가능)                  높이 73 ≈ 11.2%    │  │
│  From Site[clbPlantSite▼]  Model[txtItemId      ][btnItemId]                 │  │상
│  Period*[drpPeriod  ~  ]   Division[clbDivision▼]                            │  │
│  Sold To Party[txtSoldToParty      ]  Ship To Party[txtShipToParty     ][btnColumn] │
│  ※ 항목 높이는 모두 29. 행·열 Location 은 미추출이므로 실제 행 배치는 확인 필요         │  │
├──────────────────────────────────────────────────────────────────────────────┤ ─┤
│ spdMain (Dock Fill)                                         높이 576 ≈ 88.8%   │  │
│ ┌──────────────────────────────────────────────────────────────────────────┐ │  │하
│ │ 시트: Shipment Plan Confirm Detail  (헤더 2행, 표시 컬럼 44)                   │ │  │
│ │ ...                                                                      │ │  │
│ └──────────────────────────────────────────────────────────────────────────┘ │  │
└──────────────────────────────────────────────────────────────────────────────┘ ─┘
 폭: 상·하 모두 1192 (100%). 좌/우 분할 없음.
 버튼 영역: 표준 툴바 FindButton(조회)은 프레임워크 버튼이며 Designer 컨트롤 목록에는 없음.
 팝업 영역: btnItemId 의 팝업 여부 확인 필요.
```

- 비율 계산: 73 / (73 + 576) = 11.2%, 576 / 649 = 88.8% (props.csv Size 기준).
- `layoutControlGroup2` 높이는 78입니다. 패널 높이 73보다 큽니다. 실제 렌더링 높이는 **확인 필요**입니다.

---

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨 (props.csv Text 원문) | 초기값 | 필수여부 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| `usrConditionPanel1` | UsrConditionPanel | (Text 없음) | HidePanel(펼침/접힘 초기 상태는 **확인 필요**) | - | - | 조회조건 영역(접기 가능 패널) |
| `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2` (디자이너 기본 Text) | - | - | - | 조회조건 레이아웃 그리드 |
| `clbPlantSite` | UsrCheckedList | `From Site` (layoutControlItem7) | **확인 필요** (항목 출처 미추출) | `*` 없음 | - | 다중 선택 콤보(MultiSelect) |
| `txtItemId` | UsrMultiLineEditor | `Model` (lblItemId) | 빈값(**확인 필요**) | `*` 없음 | btnItemId_Click 결과 대입(341행) | 여러 줄 입력 |
| `btnItemId` | UsrButton | (Text 없음, layoutControlItem2) | - | - | `btnItemId_Click` | 검색 아이콘 버튼(팝업 여부 **확인 필요**) |
| `drpPeriod` | UsrDateRangePicker | `Period*` (layoutControlItem6) | `SCP.SCM0001_GET_SCP_DAY_PERIOD` 결과(Form_Load) | **필수 표시 `*`** (검증 로직 **확인 필요**) | Division 변경 시 재설정 | 날짜 범위(From~To) |
| `clbDivision` | UsrCheckedList | `Division` (lcDivision) | **확인 필요** (`NowGroupID` 관련 여부) | `*` 없음 | `clbDivision_SelectedIndexChanged` | 다중 선택 콤보 |
| `txtSoldToParty` | TextBox | `Sold To Party` (layoutControlItem1) | 빈값(**확인 필요**) | `*` 없음 | - | 텍스트 입력 |
| `txtShipToParty` | TextBox | `Ship To Party` (layoutControlItem3) | 빈값(**확인 필요**) | `*` 없음 | - | 텍스트 입력 |
| `btnColumn` | UsrButton | (Text 없음, layoutControlItem5) | - | - | `BtnColumn_Click` | 아이콘 버튼(기능 **확인 필요**) |
| `usrButton1` | UsrButton | (Text 없음) | - | - | 배선 없음 | **확인 필요** (parent 없음. 배치되지 않은 컨트롤일 수 있음) |
| `spdMain` | FpSpread | - | 시트 `Shipment Plan Confirm Detail` | - | `SpdMain_TopChange`, `SpdMain_CellClick` | Wijmo FlexGrid |
| `spdMain_Sheet1` | SheetView | - | 런타임에 `AddSheet`/`ChangeSheet` 로 구성 | - | - | FlexGrid 시트(단일) |

- 보조 항목: `imageList1`(ImageList, 이미지 셀 관련 여부 **확인 필요**), `emptySpaceItem3`/`emptySpaceItem1`(여백).

---

## 4. 그리드 명세 — 시트 `Shipment Plan Confirm Detail`

- 생성: `CreateSpread:253` `AddSheet(spdMain, "Shipment Plan Confirm Detail", "Shipment Plan Confirm Detail", 2, 1, 30)`. 인자 2/1/30 의 의미는 **확인 필요**입니다.
- 컬럼: `InitSpread:266` `SetSheetHeaderColumn(spdInfo, 2)` 로 메타 `SCM_MST_SHEET_COLUMNS` 47행에서 만듭니다. 헤더는 **2행**이고, 상단 그룹 텍스트는 **확인 필요**입니다.
- 순서: 아래 표는 컬럼명 순입니다. 실제 메타 정렬 순서·폭·정렬·고정은 **확인 필요**입니다.
- 편집 가능 여부: 저장 엔드포인트가 없으므로 조회 전용입니다. 컬럼별 Lock 메타는 미추출이므로 각 행을 "조회 전용(확인 필요)"으로 표기했습니다.
- division별 표시: 14개 division 모두 같습니다(아래 "division" 열에 공통으로 표기).

| # | 컬럼 | 헤더(라벨) | 타입 | 출처 | division별 표시 | 편집 |
|---:|---|---|---|---|---|---|
| 1 | A_COUNTRY | Country* | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 2 | A_PORT_CODE | Port Code* | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 3 | A_PORT_NAME | Port* | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 4 | BIZ_TYPE_NAME | Biz Name | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 5 | BOD_ID | bod_id | 확인 필요 | META | 전 division **숨김** | - |
| 6 | CHANGE_REQ_NO | Change Request No | **Image** (`cellTypeImage`, InitSpread:271) | META(+코드 변경) | 전 division 기본 | 조회 전용(확인 필요) |
| 7 | CONFIRM_ID | Confirm ID | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 8 | CONFIRM_QTY | Confirmed Qty | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 9 | D_COUNTRY | Country* | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 10 | D_PORT_CODE | Port Code* | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 11 | D_PORT_NAME | Port* | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 12 | DAYS_FRI | Fri | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 13 | DAYS_MON | Mon | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 14 | DAYS_SAT | Sat | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 15 | DAYS_SUN | Sun | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 16 | DAYS_THU | Thu | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 17 | DAYS_TUE | Tue | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 18 | DAYS_WED | Wed | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 19 | DIVISION_ID | Division | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 20 | ERP_SO_NO | SO No | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 21 | ETA | ETA | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 22 | ETD | ETD | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 23 | Expected_Shipping_Date | Expected Shipping Date | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 24 | FCST_TYPE | FCST Type | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 25 | FROM_SITE_DESCRIPTION | From Site | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 26 | INCOTERMS | Incoterms | **Image** (`cellTypeImage`, InitSpread:270) | META(+코드 변경) | 전 division 기본 | 조회 전용(확인 필요) |
| 27 | ITEM_ID | Model | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 28 | LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 29 | LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 30 | LT_ARRIVAL_INLAND | Arrival Inland | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 31 | LT_DAY | L/T(Day) | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 32 | LT_DEPARTURE_INLAND | Departure Inland | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 33 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 34 | LT_SUM | Total L/T | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 35 | LT_TYPE | L/T Type | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 36 | LT_VOYAGE | Voyage | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 37 | LT_WAIT_SHIPPING | Waiting For Shipping | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 38 | MTK_OWNER | MKT Owner | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 39 | NICK_NAME | Nick Name | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 40 | ORIGIN_FROM_DIVISION_ID | ORIGIN_FROM_DIVISION_ID | 확인 필요 | META | 전 division **숨김** | - |
| 41 | PLAN_DATE | Shipment Date(GI) | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 42 | PLAN_QTY | Planned Qty | 확인 필요 | META | 전 division **숨김** | - |
| 43 | PROJECT_NAME | Project Name | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 44 | SHIPTO_DESCRIPTION | Ship To Party | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 45 | SOLDTO_DESCRIPTION | Sold To Party | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 46 | TO_SITE_DESCRIPTION | To Site | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |
| 47 | TRANSPORT_MODE | Trans Mode | 확인 필요 | META | 전 division 기본 | 조회 전용(확인 필요) |

- 집계: 메타 47개 / 표시 44개 / 숨김 3개 / HARDCODED 컬럼 0개 / 코드 변경 2개(CellType)
- division: 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC 모두 44/0입니다.
- `A_*` 와 `D_*` 의 라벨이 같습니다(`Country*`, `Port Code*`, `Port*`). 2행 헤더의 상단 그룹으로 두 묶음을 구분하는 것으로 보이나, 상단 그룹 텍스트는 **확인 필요**입니다.

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 폼 로드 (`this.Load`, .ctor:186) | `Form_Load` | InitControls > GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | `drpPeriod` 기간 설정(**확인 필요**) |
| A2 | Division 변경 (`clbDivision.SelectedIndexChanged`, InitEvent:282) | `clbDivision_SelectedIndexChanged` | SetChangedControl(GetCheckedListValue CODE, 366행) > GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | `drpPeriod` 재설정(**확인 필요**) |
| A3 | 조회 (툴바 `FindButton`) | `FindData_Main` (프레임워크 버튼 진입) | GetCheckedListValue CODE(398·399행) 후 SP 호출(418행) | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | `spdMain` 시트 `Shipment Plan Confirm Detail` 바인딩 |
| A4 | Model 버튼 (`btnItemId.Click`, InitEvent:278) | `btnItemId_Click` | `txtItemId.Text = sItemId` (341행) | 추출된 엔드포인트 없음 | `txtItemId` 값 설정 |
| A5 | 컬럼 버튼 (`btnColumn.Click`, InitEvent:284) | `BtnColumn_Click` | **확인 필요** | 추출된 엔드포인트 없음 | **확인 필요** |
| A6 | 셀 클릭 (`spdMain.CellClick`, InitEvent:280) | `SpdMain_CellClick` | **확인 필요** | 추출된 엔드포인트 없음 | **확인 필요** |
| A7 | 스크롤 (`spdMain.TopChange`, InitEvent:277) | `SpdMain_TopChange` | **확인 필요** | 추출된 엔드포인트 없음 | **확인 필요** |
| A8 | (진입점 미연결) 필드 초기화 `dtFcstType`/`dtBaseDay` | - | 공통코드 LookupCommon 조회 | `biz:CommonData.CommonDataList` | 사용처 **확인 필요** |
| A9 | (진입점 미연결) `SetChangedPeriod` | - | PERIOD_{값} \|\| PERIOD_DEFAULT 조회 → FROM_VALUE/TO_VALUE | `biz:CommonData.CommonDataList` | 호출 여부 **확인 필요** |

- 주석 처리된 호출(595행) 1건은 현행 액션이 아니므로 위 표에서 뺐습니다.

---

## 6. 검증·메시지

| 항목 | 사실 | 상태 |
|---|---|---|
| Period 필수 | 라벨 `Period*` 에 필수 표시가 있습니다. | 검증 코드와 메시지 원문은 **확인 필요** |
| 조회 0건 메시지 | 미추출 | **확인 필요** |
| 오류 메시지 | 미추출 | **확인 필요** |
| Fact Pack §7 확인 필요 항목 | 0건 | - |

---

## 7. 권한 (C/R/U/D)

| 구분 | 사실 |
|---|---|
| C (생성) | 엔드포인트 없음 |
| R (조회) | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `biz:CommonData.CommonDataList` |
| U (수정) | 엔드포인트 없음 |
| D (삭제) | 엔드포인트 없음 |
| 권한 메타 | `TB_FX_GroupMenuAuth` 16행. 그룹별 값은 **확인 필요** |
| 사용자 정보 | `UserInfoContext.Current.NowGroupID` (48행) |

---

## 8. To-Be 전환 메모 (Wijmo·Oracle)

| # | 항목 | AS-IS | To-Be 관점 |
|---:|---|---|---|
| 1 | 그리드 | FarPoint `spdMain` + `SetSheetHeaderColumn(spdInfo, 2)` | Wijmo FlexGrid + 메타 기반 컬럼 생성. 2행 헤더는 ColumnGroup 으로 구성하고, 상단 그룹 텍스트를 확인한 뒤 정합니다. |
| 2 | 이미지 셀 | `INCOTERMS`, `CHANGE_REQ_NO` = `cellTypeImage` | FlexGrid cellTemplate(아이콘) 후보. 클릭 동작은 `SpdMain_CellClick` 확인 후 정합니다. |
| 3 | 조회조건 패널 | `usrConditionPanel1` HidePanel | 접기 가능한 조회조건 영역 |
| 4 | 다중 선택 | `clbPlantSite`, `clbDivision` (UsrCheckedList, CODE) | 다중 선택 콤보. 선택 CODE 를 구분자 문자열로 전달할지 여부는 SP 파라미터 확인 후 정합니다. |
| 5 | 동적 피벗 SP | MSSQL `#TBLDYNAMICPIVOT_SSP0012` + 동적 SQL | Oracle 19c 에서는 `#` 임시 테이블이 없습니다. GTT 또는 PIVOT/동적 SQL(REF CURSOR)로 바꿔야 합니다. |
| 6 | 분해 함수 | `FN_SCM_SPLIT`, `FN_GET_IN_STR` | Oracle 대응 함수가 있는지 확인해야 합니다. MSSQL 키워드는 남기지 않습니다. |
| 7 | 기간 SP | `SCM0001_GET_SCP_DAY_PERIOD` (CTE `CTE_DATE`, 달력) | 공용 기간 조회 API로 재사용합니다. |
| 8 | 미배치 컨트롤 | `usrButton1` (parent 없음) | 배치 여부를 확인한 뒤 To-Be 포함 여부를 정합니다. |

---

## 9. 미확정

1. `SpdMain_TopChange`, `SpdMain_CellClick`, `BtnColumn_Click` 동작, `btnItemId_Click` 의 팝업 여부
2. 조회조건 실제 행·열 배치(Location 미추출), `usrConditionPanel1` 초기 펼침 상태
3. 그리드 컬럼 실제 순서·폭·정렬·고정·타입, 2행 헤더 상단 그룹 텍스트
4. `AddSheet` 인자 2/1/30 의 의미
5. `clbPlantSite`·`clbDivision` 항목 출처와 기본 선택값
6. Period 필수 검증 메시지, 조회 0건 메시지
7. `usrButton1` 배치 여부, `imageList1` 용도
8. 메뉴 위치, 권한 16행 내용
