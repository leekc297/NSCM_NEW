# SSP0021 Shipment Plan — 화면설계서

> **근거**: Fact Pack(controls.csv · props.csv · events.csv · flow.csv · grid_effective · grid_code.csv)과 1차 분석서. props.csv는 일부가 잘려 있어 미확인 라벨은 **확인 필요**로 적었다.
> **문서 간 참조**: §5 액션 명세의 엔드포인트 = 업무분석서 §5 데이터 흐름의 엔드포인트. §3 컨트롤명 = 단위테스트 '절차' 열에서 쓰는 이름.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0021 |
| 화면명 | Shipment Plan (클래스 `SSP0021_ShipmentPlan`) |
| 도메인 | SSP (`GSCM.SSP.Forms.UIL\Plan`) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행, 내용 미포함) |
| 화면 유형 | 조회조건(접기 패널) + 상/하 분할 그리드. 상단 = 출하계획 매트릭스(spdMain), 하단 = 상세 조건 줄 + 다중 시트 상세 그리드(spdDetail) |
| 그리드 구성 방식 | HYBRID: META(SCM_MST_SHEET_COLUMNS) + DB 루프(날짜 열) + 코드 표시/라벨 변경 |
| 툴바 | FindButton / EditButton / SaveButton (프레임워크 툴바 진입점. 배선 구조는 **확인 필요**) |

---

## 2. 화면 레이아웃

### 2.1 분할 트리 (controls.csv parent 체인 + props.csv Dock·Size·Orientation·SplitterDistance)

```
this (Form)  폭 1689
├─ usrConditionPanel1 [UsrConditionPanel] Dock=Top, 1689×73, UsrPanelType=HidePanel(접기 가능)
│   └─ usrLayoutControl2 [UsrLayoutControl] Dock=Top, 1689×77  (layoutControlGroup2 1689×77)
│        ※ 자식(77)이 부모 패널(73)보다 큼. 실제 표시 높이는 확인 필요
└─ splitContainer1 [SplitContainer] Dock=Fill, 1689×576, Orientation=Horizontal(상/하), SplitterDistance=303
    ├─ Panel1 (상) 303 / 576 = 52.6%
    │   └─ spdMain [FpSpread] Dock=Fill, 1689×303  (spdMain_Sheet1 → 시트 "Shipment Plan")
    └─ Panel2 (하) 273 / 576 = 47.4%
        ├─ usrLayoutControl3 [UsrLayoutControl] Dock=Top, 1689×40  (layoutControlGroup3 1689×49) ≈ 14.7%
        └─ spdDetail [FpSpread] Dock=Fill, 1689×229 (spdDetail_Sheet1 → 상세 시트 8개) ≈ 83.9%
            ※ 40 + 229 = 269. Panel2 273과 4px 차이 — SplitterWidth 미추출, 확인 필요
(parent 없음) usrButton1 [UsrButton] 75×23 — 화면 배치 여부 확인 필요
(parent 없음) imageList1 [ImageList]
```
- 세로 비율(폼 높이 73 + 576 = 649 기준): 조회조건 영역 11.2%, 분할 영역 88.8%.

### 2.2 텍스트 와이어프레임

```
┌──────────────────────────────────────────────────────────────────────────────────────────┐
│ [툴바] Find │ Edit │ Save                                                (프레임워크)    │
├──────────────────────────────────────────────────────────────────────────────────────────┤
│ usrConditionPanel1 (HidePanel, 접기 가능) > usrLayoutControl2                             │
│ Division*[clbDivision_ID▼] Company*[clbCompany_ID▼] From Site[clbPlantSite☑▼]            │
│ Plan-date*[cboPlanDate▼] Period*[drpPeriod ~ (비활성)] Bucket[cboBucketType▼]            │
│ [☐ Sum chkSum] [btnMeasure] [Simulation btnSimulation] [☐ Show SQL chkSql]               │
│ Model[txtItemId ...............................................][btnItemId]             │
│ ※ 행·열 배치 좌표(Location)는 props.csv에 없어 위 행 구분은 Size 기준 추정 배치가 아님 → 확인 필요 │
├══════════════════════════════════ splitContainer1 (Horizontal) ═══════════════════════════┤
│ Panel1 52.6%  spdMain : Shipment Plan                                                     │
│ ┌ Div │ From Site │ Model │ Nick Name │ PSI │ BOH_TYPE │ BOH_QTY │ Measure │ [날짜 열…] SUM ┐ │
│ │ (헤더 3행: LARGE/SMALL CLASS Span, MergePolicy=Always)                                 │ │
│ └──────────────────────────────────────────────────────────────────────────────────────┘ │
├──────────────────────────────────────── splitter (303) ───────────────────────────────────┤
│ Panel2 47.4%  usrLayoutControl3 (40)                                                      │
│ Shipment Date[drpPeriod2 ~] Shipment Date[drpPeriod3 ~] Model[txtModel2][btnItemID2]      │
│ (라벨 확인 필요)[txtRequestor][btnRequestor] (라벨 확인 필요)[clbResultType☑▼]            │
│ (라벨 확인 필요)[txtBoxID] [Search btnSearch]                                             │
│ spdDetail (229) 시트 탭:                                                                  │
│ [Shipment Plan Detail][Stock Location Detail][oWMS Detail][Hold stock?][Hold stock Detail?]│
│ [MES Stock][MES Stock Detail][Shipment Result]   (탭 순서 3·4는 확인 필요)                 │
└──────────────────────────────────────────────────────────────────────────────────────────┘
```

### 2.3 영역 정의
| 영역 | 구성 컨트롤 | 비고 |
|---|---|---|
| 조회조건 | usrConditionPanel1 > usrLayoutControl2: clbDivision_ID, clbCompany_ID, clbPlantSite, cboPlanDate, drpPeriod, cboBucketType, chkSum, txtItemId, chkSql | 접기 가능 패널 |
| 버튼(조회조건 내) | btnItemId, btnMeasure, btnSimulation | |
| 상단 그리드 | spdMain / spdMain_Sheet1 | Shipment Plan |
| 하단 조건 | usrLayoutControl3: drpPeriod2, drpPeriod3, txtModel2, btnItemID2, txtRequestor, btnRequestor, clbResultType, txtBoxID, btnSearch | 상세 재조회 |
| 하단 그리드 | spdDetail / spdDetail_Sheet1 | 상세 시트 8개 |
| 팝업 | btnItemId_Click, BtnItemID2_Click, BtnRequestor_Click, BtnMeasure_Click가 여는 팝업 | 팝업 화면 ID **확인 필요** |
| 배치 미확인 | usrButton1 | parent 없음 |

---

## 3. 컨트롤 명세

| # | 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 크기 | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트(후보) |
|---:|---|---|---|---|---|---|---|---|
| 1 | `usrButton1` | UsrButton | (Text 미추출) | 75×23 | — | — | 없음 | 확인 필요 (parent 없음, 반영 여부 판단) |
| 2 | `usrConditionPanel1` | UsrConditionPanel | — | 1689×73, Dock Top | HidePanel | — | 없음 | 공용 조회조건 패널(접기) |
| 3 | `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2`(컨트롤 Text) | 1689×77, Dock Top | — | — | 없음 | 조회조건 레이아웃 |
| 4 | `chkSql` | UsrCheckBox | `Show SQL` (lblSql) | 98×20 | 확인 필요 | — | 배선 없음 | 확인 필요 (개발용 여부) |
| 5 | `btnSimulation` | UsrButton | `Simulation` | 106×25 | — | — | `BtnSimulation_Click` | Button |
| 6 | `clbCompany_ID` | UsrCombo | `Company*` (layoutControlItem1) | 178×20 | 확인 필요 (dtMyCompany NAME) | Y(`*`) | `clbCompanyID_SelectedIndexChanged` | Wijmo ComboBox |
| 7 | `chkSum` | UsrCheckBox | `Sum` (layoutControlItem8) | 84×25 | 확인 필요 | — | `chkSum_CheckedChanged` | CheckBox |
| 8 | `btnMeasure` | UsrButton | (Text 없음, layoutControlItem10) | 39×25 | — | — | `BtnMeasure_Click` | 아이콘 버튼(팝업) |
| 9 | `btnItemId` | UsrButton | (Text 없음, layoutControlItem2) | 39×24 | — | — | `btnItemId_Click` | 아이콘 버튼(팝업) |
| 10 | `clbPlantSite` | UsrCheckedList | `From Site` (layoutControlItem7) | 220×21 | `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` 결과 | — | 없음(GetCheckedListValue) | Wijmo MultiSelect |
| 11 | `drpPeriod` | UsrDateRangePicker | `Period*` (layoutControlItem6) | 197×20 | **Enabled=false**, Plan-date FROM/TO | Y(`*`) | 없음 | InputDate ×2 (읽기전용) |
| 12 | `txtItemId` | UsrMultiLineEditor | `Model` (lblItemId) | 695×21 | 빈값(확인 필요) | — | 없음 | 다중값 입력 |
| 13 | `clbDivision_ID` | UsrCombo | `Division*` (lblCombo1) | 150×20 | `SSP.SSP0021_GET_SHIPMENT_DIVISION` 결과 | Y(`*`) | `clbDivision_ID_SelectedIndexChanged` | Wijmo ComboBox |
| 14 | `cboPlanDate` | UsrCombo | `Plan-date*` (PlanDate) | 138×20 | 확인 필요 | Y(`*`) | `cboPlanDate_SelectedIndexChanged` (Company 변경 중 -=/+=) | Wijmo ComboBox |
| 15 | `cboBucketType` | UsrCombo | `Bucket` (lblBucket) | 320×20 | `DM.DM0003_GET_BUCKET_TYPE_CODE` 결과 (DAILY/WEEKLY/MONTHLY) | — | `cboBucketType_SelectedIndexChanged` | Wijmo ComboBox |
| 16 | `spdMain` | FpSpread | — | 1689×303, Dock Fill | — | — | `SpdMain_TopChange`, `SpdMain_CellDoubleClick`, `SpdMain_Change`, `SpdMain_ClipboardPasted` | Wijmo FlexGrid (다단 헤더, allowMerging) |
| 17 | `spdMain_Sheet1` | SheetView | 시트 `Shipment Plan` | — | — | — | — | FlexGrid columns 정의 |
| 18 | `spdDetail` | FpSpread | — | 1689×229, Dock Fill | 활성 시트 Shipment Plan Detail | — | `SpdDetail_TopChange`, `SpdDetail_SheetTabClick`, `SpdDetail_ActiveSheetChanged`, `SpdDetail_CellClick`, `SpdDetail_ComboSelChange`, `SpdDetail_CellDoubleClick`, `SpdDetail_EditChange`, `SpdDetail_ClipboardPasted` | Tab + 시트별 Wijmo FlexGrid |
| 19 | `spdDetail_Sheet1` | SheetView | 상세 시트 8개 | — | — | — | — | FlexGrid columns 정의 |
| 20 | `usrLayoutControl3` | UsrLayoutControl | `usrLayoutControl3`(컨트롤 Text) | 1689×40, Dock Top | — | — | 없음 | 하단 조건 레이아웃 |
| 21 | `btnRequestor` | UsrButton | (Text 없음, layoutControlItem9) | 39×24 | — | — | `BtnRequestor_Click` | 아이콘 버튼(팝업) |
| 22 | `txtRequestor` | UsrTextBox | 확인 필요 (LayoutControlItem `Requestor`, Text 잘림) | 147×25 | 확인 필요 | — | 없음 | TextInput |
| 23 | `btnSearch` | SimpleButton | `Search` (layoutControlItem3) | 47×25 | — | — | `BtnSearch_Click` | Button |
| 24 | `txtModel2` | UsrMultiLineEditor | `Model` (layoutControlItem4) | 264×21 | 확인 필요 | — | 없음 | 다중값 입력 |
| 25 | `btnItemID2` | UsrButton | `layoutControlItem2` (layoutControlItem5 Text 원문. 화면 표시 여부 확인 필요) | 39×25 | — | — | `BtnItemID2_Click` | 아이콘 버튼(팝업) |
| 26 | `drpPeriod2` | UsrDateRangePicker | `Shipment Date` (layoutControlItem11) | 197×20 | 확인 필요 | — | `DrpPeriod2_ValueChanged` | InputDate ×2 |
| 27 | `drpPeriod3` | UsrDateRangePicker | `Shipment Date` (layoutControlItem13) | 197×20 | 확인 필요 | — | 없음 | InputDate ×2 |
| 28 | `clbResultType` | UsrCheckedList | 확인 필요 | 104×21 | 확인 필요 | — | 없음 | Wijmo MultiSelect |
| 29 | `txtBoxID` | UsrMultiLineEditor | 확인 필요 | 205×21 | 확인 필요 | — | 없음 | 다중값 입력 |

- 기타 컨트롤: splitContainer1(SplitContainer), layoutControlGroup2/3, LayoutControlItem 21개, EmptySpaceItem 4개, imageList1. 이들은 레이아웃용이고 이벤트 배선이 없다.
- `dsdm`(Changed → `shtDetail_Change`)은 controls.csv에 없는 개체다. 정체는 **확인 필요**.

---

## 4. 그리드 명세

### 4.0 공통
- **출처**: 9개 시트 모두 META(`SpreadInfo.SetSheetHeaderColumn` ← SCM_MST_SHEET_COLUMNS, InitSpread 610·634·647·658·698·708·718줄)다. Shipment Plan에는 날짜 열 DB 루프(HARDCODED 코드 생성)가 더해진다.
- **타입**: META `CELL_CONTROL_OBJECT_TYPE_CODE` 값이 Fact Pack에 없어 컬럼별 셀 타입은 **확인 필요**다. 아래 표의 타입 열은 코드에서 확인된 것만 적었다.
- **division별 표시**: 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)에서 모두 같다(표에서는 '전 div 동일'). 예외는 Shipment Result CHILD_QTY 너비(82 → 75) 1건.
- **편집 가능**: 셀 Locked 메타가 Fact Pack에 없다. 라벨 `*`와 저장 검증 필드에서 확인되는 것만 '편집(근거)'로 적었고 나머지는 **확인 필요**. 시트 잠금은 `siDetail.IsLock(SheetName)`으로 판정한다.
- **순서**: 표의 컬럼 순서는 grid_effective의 알파벳순이다. 실제 순서(SORT_ORDER)는 **확인 필요**.

### 4.1 Shipment Plan (spdMain, 표시 8 / 메타 13 + 날짜 DB 루프 열)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| BACK_COLOR | Back Color | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| BOH_QTY | BOH_QTY | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 (더블클릭 대상) |
| BOH_TYPE | BOH_TYPE | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CONFIRM_DAY | Confrim Day | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| DIVISION_ID | Div | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE | Site | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LOT_YN | Lot_YN | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MEASURE | Measure | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MEASURE_NAME | Measure | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PSI | PSI | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| (날짜 열, 컬럼명에 `B_` 포함) | COLUMN_LABEL_NAME | 숨김(너비 0) | Text (AddTextColumn) | HARDCODED(DB 루프, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`) | 전 div 동일 | 확인 필요 |
| (날짜 열, 그 외) | COLUMN_LABEL_NAME | 표시(너비 70). SAT 파랑 / SUN 빨강. D_/W_/M_ 태그별 Bucket·Sum 규칙 적용 | Num (AddNumColumn) | HARDCODED(DB 루프) | 전 div 동일 | 확인 필요 (`SpdMain_Change`·`SpdMain_ClipboardPasted` 배선 있음) |
- 헤더 3행(LARGE/SMALL CLASS Span + "SUM"). MergePolicy = Always. Measure 행 9건(SCM_MST_SHEET_MEASURE).

### 4.2 Shipment Plan Detail (표시 42 / 메타 69)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| A_COUNTRY | A Contry | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| A_PORT_CODE | A Port Code | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| A_PORT_NAME | A Port Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ATTRIBUTE10 | ATTRIBUTE10 | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| BOD_ID | bod_id | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CHANGE_REASON_CODE | Change Reason | 표시 | 확인 필요(콤보 후보, `SpdDetail_ComboSelChange`) | META | 전 div 동일 | 확인 필요 |
| CHANGE_REASON_DETAIL | Reason Detail | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CHANGE_REQ_NO | Change Request No | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CHANGE_TYPE | CHANGE_TYPE | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CHECK_NEED_YN | Checked | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CITY_NAME | City Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CONFIRM_ID | Confirm/Plan ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 (검증 키 confirm_id) |
| COUNTRY_NAME | Country Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| DIVISION_ID | Div | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| EDIT_MAIN | EDIT_MAIN | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| EDIT_REMARKS | EDIT_REMARKS | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ELECTRODE_TYPE | ELECTRODE_TYPE | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ELECTRODE_YN | ELECTRODE_YN | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| END_CUSTOMER | End Customer | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ERP_SO_NO | SO No | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 (SO No 유무 → NonSoNo/SoNo 분기) |
| ERP_STATUS | erp_status | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ETA | ETA | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ETD | ETD | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| Expected_Shipping_Date | Expected Shipping Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FCST_TYPE | FCST Type | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE | From Site ID | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| INCOTERMS | Incoterms | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LT_DAY | L/T(Day) | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MODEL_USER | Model PIC | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MTK_OWNER | MKT Owner | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_A_COUNTRY | A Country | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_A_PORT_CODE | A Port | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_BOD_ID | new bod | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_CUSTOMER_LT | Customer LT | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_D_COUNTRY | D Country | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_D_PORT_CODE | D Port | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_ETA | ETA | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_ETD | ETD | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_INCOTERMS | new incoterms | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_LT_DAY | L/T(Day) | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_ROUTE_ID | Route | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_SHIPMENT_DATE | Shipment Date* | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_TO_CITY | To City | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_TO_COUNTRY | To Country | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_TRANSPORT_MODE | Trans Mode | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ORIGIN_FROM_DIVISION_ID | ORIGIN_FROM_DIVISION_ID | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ORIGIN_TO_DIVISION_ID | ORIGIN_TO_DIVISION_ID | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PROJECT_CODE | Project Code | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PROJECT_NAME | Project Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| REMARKS | Remarks | 표시 | 확인 필요 | META | 전 div 동일 | 편집(근거: Validation_Check remarks) |
| REMARKS2 | Building | 표시 | 확인 필요 | META | 전 div 동일 | 편집(근거: Validation_Check remarks2) |
| REMARKS3 | Customer Requirement | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| REQUESTOR | Shipment Requestor | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| SHIPMENT_CONFIRM_QTY | Shipment Qty* | 표시 | 확인 필요 | META | 전 div 동일 | 편집·필수(근거: `*` + Validation_Check shipment_confirm_qty) |
| SHIPMENT_DATE | Shipment Date* | 표시 | 확인 필요 | META | 전 div 동일 | 편집·필수(근거: `*` + Validation_Check shipment_date) |
| SHIPMENT_STATUS | Status | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| SHIPTO_CITY_NAME | Ship To City Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| SHIPTO_DESCRIPTION | Ship To Party | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| SHIPTO_REGION_NAME | Ship To Region Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| SOLDTO_DESCRIPTION | Sold To Party | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TEAM | Team | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TO_SITE | To Site ID | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TO_SITE_DESCRIPTION | To Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TRANSPORT_MODE | Trans Mode* | 표시 | 확인 필요 | META | 전 div 동일 | 편집·필수(근거: `*` + Validation_Check TRANSPORT_MODE) |
| UPDATED_BY | Updated By | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| UPDATED_DATE | Updated Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
- 헤더 체크박스 전체 선택/해제(`SpdDetail_CellClick`)가 적용되는 열은 **확인 필요**.

### 4.3 Stock Location Detail (표시 20 / 메타 20)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| AVAILABLE_DATE | Available Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| AVAILABLE_QTY | Available Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| COMPANY_ID | Company | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CUTOFF_DATE | Cutoff Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| DEFECT_QTY | Deffect Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| DIVISION_ID | Div | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE | From Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| HOLDING_DATE | Holding Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MOVING_QTY | Moving Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| OUTSOURCING_FACTORY | Outsourcing Factory | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| OUTSOURCING_FLAG | Outsourcing Flag | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PLANT_ID | Plant | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| QTY_UOM | Qty Uom | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| STOCK_TYPE | Stock Type | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| STORAGE_DESCRIPTION | Storage | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| STORAGE_ID | Storage ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TOTAL_QTY | Total Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| WIPHOLD_YN | Wiphold Yn | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |

### 4.4 oWMS Detail (표시 25 / 메타 25)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| ALLOCATION_QTY | Allocation Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| AVAILABLE_QTY | Available Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CAPA_GRADE | Capa. Grade | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CUSTOMER_CODE | Customer Code | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CUSTOMER_NAME | Customer Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| DIVISION_ID | Div | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| EXPIRATION_QTY | Expiration Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| GRADE | Grade | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| HOLD_QTY | Hold Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LONG_TERM_QTY | Long-term Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LOT_ID | Lot ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LOT_ISSUE_DATE | Lot Issue Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MOVING_QTY | Moving Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PACKING_QTY | Packing Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PACKING_STATUS | Packing Status | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PALLET_ID | Pallet ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PLANT_ID | Plant ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| RECEIVING_QTY | Reciving Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| SOC | SOC | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| STOCK_QTY | Stock Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| STOCK_STATUS | Inventory Status | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| STORAGE_ID | Storage | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| UNDECIDED_QTY | Undecided Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |

### 4.5 Hold stock (표시 10 / 메타 12)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| DIVISION_ID | Div | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE | Site | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE_NM | From Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| HOLD_ID | HOLD_ID | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| HOLD_QTY | Amend Qty* | 표시 | 확인 필요 | META | 전 div 동일 | 편집·필수(근거: `*`) |
| HOLD_YYYYMMDD | Start Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LAST_UPDATE_DATE | Last Updated Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LAST_UPDATED_BY | Last Updated By | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| RELEASE_YYYYMMDD | End Date* | 표시 | 확인 필요 | META | 전 div 동일 | 편집·필수(근거: `*`) |
| REMARKS | Remarks | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
- 저장 엔드포인트 `SSP.SSP0021_SAVE_HOLD_STOCK_DATA`는 ⚠ DB에 SP가 없다.

### 4.6 Hold stock Detail (표시 10 / 메타 12)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| DIVISION_ID | Div | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE | Site | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE_NM | From Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| HOLD_ID | HOLD_ID | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| HOLD_QTY | Amend Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| HOLD_YYYYMMDD | Start Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LAST_UPDATE_DATE | Last Updated Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LAST_UPDATED_BY | Last Updated By | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| RELEASE_YYYYMMDD | End Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| REMARKS | Remarks | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
- 이 시트를 생성하거나 전환하는 코드 위치는 Fact Pack 표시 범위에서 확인되지 않았다 → **확인 필요**.

### 4.7 MES Stock (표시 9 / 메타 9)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| AVAILABLE_STOCK | Available Stock | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| BEFORE_OQC | Before OQC | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| OQC_COMPLETE | OQC Complete | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| OQC_INSP_REQUEST | OQC Insp Request | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| OQC_NG | OQC NG | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| QMS_MES_HOLD | QMS/MES Hold | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TOTAL | Total | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |

### 4.8 MES Stock Detail (표시 13 / 메타 13)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| AVAILABLE_YN | Available stock YN | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| BOXID | Box ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| EXP_INSP_VALID_DATE | Exp Insp Vaild Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LOT_QTY | Lot Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LOTID | Lot ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MES_HOLD_YN | MES Hold YN | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MES_UNHOLD_SCHD_DATE | MES Unhold Sched Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| OQC_INSP_RESULT | OQC Insp Result | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PRJT_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PROD_VALID_DATE | Prod Valid Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PRODID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| QMS_HOLD_YN | QMS Hold YN | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| QMS_UNHOLD_SCHD_DATE | QMS Unhold Sched Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |

### 4.9 Shipment Result (표시 18 / 메타 18)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| CHILD_QTY | Shipment Pack Qty | 표시 | 확인 필요 | META + 코드(Width) | **82: Width=75** (InitSpread 727줄) / 그 외: 메타 너비 | 확인 필요 |
| CONFIRM_ID | Confirm/Plan ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| DIVISION_ID | Div | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| END_CUSTOMER | End Customer | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ERP_SO_NO | SO No | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ETA_DATE | ETA | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ETD_DATE | ETD | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE | From Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| INCOTERMS | Incoterms | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PROJECT_CODE | Prj Code | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| QTY | Shipment Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| SHIP_TYPE | Ship Type | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TO_SITE | To Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TRANSPORT_MODE | Trans Mode | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TYPE | Status | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| YYYYMMDD | Shipment Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |

### 4.10 시트 탭·생성 순서
| 항목 | 사실 |
|---|---|
| CreateSpread 생성 순서 | 548 Shipment Plan Detail → 549 Stock Location Detail → 550 oWMS Detail → (551~555 미표시) → 556 MES Stock → 557 MES Stock Detail → 559 Shipment Result → 594 Shipment Plan Detail 활성 |
| SpdDetail_SheetTabClick 분기(2138~2154줄) | 0 = Shipment Plan Detail, 1 = Stock Location Detail, 2 = oWMS Detail, 5 = Shipment Result. 3·4와 Hold stock 계열은 **확인 필요** |

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 Load | `Form_Load` | InitControls → SetChangedControl / GetBucketType, CreateSpread → InitSpread → GetSpdTitle | `SSP.SSP0021_GET_SHIPMENT_DIVISION`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | clbDivision_ID, cboBucketType 구성. spdMain·spdDetail 헤더 생성 |
| A2 | 툴바 Find | FindButton(프레임워크) | FindData_Main → InitSpread | `SSP.SSP0021_GET_SHIPMENT_PLAN`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain(Shipment Plan) |
| A3 | 툴바 Edit | EditButton(프레임워크) | GetSSPUserCheck | `SSP.SSP0002_GET_USER_INFO_LIST` | 편집 허용 여부 (판정 **확인 필요**) |
| A4 | 툴바 Save | SaveButton(프레임워크) | SaveData_Detail → Validation_Check → 저장 → GetERPInterface → 재조회 | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0021_SAVE_HOLD_STOCK_DATA`, `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`, `SSP.SSP0021_GET_ERP_SO_NO_CNT`, `SSP.SSP0021_GET_SHIPMENT_STATUS`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`, 재조회 `SSP.SSP0021_GET_SHIPMENT_PLAN`·`SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL`·`SSP.SSP0021_GET_HOLD_STOCK`·`SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain, spdDetail(Shipment Plan Detail / Hold stock) 갱신 |
| A5 | clbDivision_ID 변경 | `clbDivision_ID_SelectedIndexChanged` | c["DIVISION_ID"], dtDiv_Company_ID NAME 읽음 | 없음 | Company 관련 값 반영(**확인 필요**) |
| A6 | clbCompany_ID 변경 | `clbCompanyID_SelectedIndexChanged` | From Site 조회. cboPlanDate 이벤트 -=(5933) / +=(5937). InitSpread | `SSP.SSP0021_GET_SHIPMENT_FROM_SITE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | clbPlantSite, 그리드 헤더 |
| A7 | cboPlanDate 변경 | `cboPlanDate_SelectedIndexChanged` | FROM_DATE/TO_DATE → drpPeriod. GetSpdTitle → InitSpreadDateColumn | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | drpPeriod, spdMain 날짜 열 |
| A8 | cboBucketType 변경 | `cboBucketType_SelectedIndexChanged` | SetSpreadColumn (4451줄) | 없음 | spdMain D_/W_/M_ 열 표시 |
| A9 | chkSum 변경 | `chkSum_CheckedChanged` | SetSpreadColumn (4456줄) | 없음 | spdMain 합계(M_ 등) 열 표시 |
| A10 | btnMeasure 클릭 | `BtnMeasure_Click` | InitSpread → GetSpdTitle | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain 재구성 |
| A11 | btnItemId 클릭 | `btnItemId_Click` | 팝업(대상 **확인 필요**) | 없음 | txtItemId |
| A12 | btnItemID2 클릭 | `BtnItemID2_Click` | 팝업(대상 **확인 필요**) | 없음 | txtModel2 |
| A13 | btnRequestor 클릭 | `BtnRequestor_Click` | 요청자 팝업(**확인 필요**) | 없음 | txtRequestor |
| A14 | btnSimulation 클릭 | `BtnSimulation_Click` | Simulation(6124~6130줄, 연결 **확인 필요**) | 없음 | **확인 필요** |
| A15 | btnSearch 클릭 | `BtnSearch_Click` | 활성 시트에 맞는 FindData_* | `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0021_GET_OWMS_DETAIL`, `SSP.SSP0021_GET_SHIPMENT_RESULT`, `SSP.SSP0021_GET_MES_STOCK`, `SSP.SSP0021_GET_MES_STOCK_DETAIL`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 해당 상세 시트 |
| A16 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | 클릭 열·MEASURE·BOH_TYPE 분기(2059~2094줄) | `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0021_GET_OWMS_DETAIL`, `SSP.SSP0021_GET_HOLD_STOCK`, `SSP.SSP0021_GET_MES_STOCK`, `SSP.SSP0021_GET_MES_STOCK_DETAIL`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdDetail 시트 전환 + 데이터 |
| A17 | spdMain 값 변경 | `SpdMain_Change` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A18 | spdMain 붙여넣기 | `SpdMain_ClipboardPasted` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A19 | spdMain 스크롤 | `SpdMain_TopChange` | 세부 로직 **확인 필요** (상·하 스크롤 동기화 여부) | 없음 | **확인 필요** |
| A20 | spdDetail 스크롤 | `SpdDetail_TopChange` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A21 | spdDetail 탭 클릭 | `SpdDetail_SheetTabClick` | ChangeSheet/ChangeActiveSheet(인덱스 0·1·2·5) | 없음 | 활성 시트 전환 |
| A22 | spdDetail 활성 시트 변경 | `SpdDetail_ActiveSheetChanged` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A23 | spdDetail 셀 클릭 | `SpdDetail_CellClick` | IsLock=false + 헤더 체크박스이면 전체 토글(1802·1837·1841줄) | 없음 | 체크 열 일괄 변경 |
| A24 | spdDetail 콤보 선택 | `SpdDetail_ComboSelChange` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A25 | spdDetail 더블클릭 | `SpdDetail_CellDoubleClick` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A26 | spdDetail 편집 | `SpdDetail_EditChange` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A27 | spdDetail 붙여넣기 | `SpdDetail_ClipboardPasted` | c["CODE"] 매칭(1509줄) | 없음 | 붙여넣은 값 코드 변환(**확인 필요**) |
| A28 | drpPeriod2 변경 | `DrpPeriod2_ValueChanged` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A29 | dsdm 변경 | `shtDetail_Change` | dsdm 개체 정체 **확인 필요** | 없음 | **확인 필요** |
| A30 | (진입점 미연결) | GetErpIFCheck / GetErpIFCheckNew_ / NewNonSoNo | 정적 분석상 호출 경로 없음 | `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` | 현행 화면 액션 아님. 사용 여부 **확인 필요** |

엔드포인트 23종 대조: `SSP.SSP0021_GET_SHIPMENT_DIVISION`(A1) · `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM`(A4) · `SSP.SSP0021_SAVE_HOLD_STOCK_DATA`(A4) · `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`(A4) · `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`(A4) · `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING`(A4·A30) · `SSP.SSP0021_GET_ERP_SO_NO_CNT`(A4) · `SSP.SSP0021_GET_SHIPMENT_STATUS`(A4) · `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING`(A30) · `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`(A4) · `DM.DM0003_GET_BUCKET_TYPE_CODE`(A1) · `SSP.SSP0021_GET_SHIPMENT_PLAN`(A2·A4) · `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL`(A4·A15·A16) · `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL`(A15·A16) · `SSP.SSP0021_GET_OWMS_DETAIL`(A15·A16) · `SSP.SSP0021_GET_SHIPMENT_RESULT`(A15) · `SSP.SSP0021_GET_HOLD_STOCK`(A4·A16) · `SSP.SSP0021_GET_MES_STOCK`(A15·A16) · `SSP.SSP0021_GET_MES_STOCK_DETAIL`(A15·A16) · `SSP.SSP0002_GET_USER_INFO_LIST`(A3) · `SSP.SSP0021_GET_SHIPMENT_FROM_SITE`(A6) · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`(A1·A2·A4·A6·A7·A10·A15·A16) · `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`(A4).

---

## 6. 검증·메시지

| # | 검증 | 대상 | 근거 | 메시지 |
|---:|---|---|---|---|
| V1 | 조회조건 필수 | Division*, Company*, Plan-date*, Period* | 라벨 `*` | 메시지 문구·검증 위치 **확인 필요** |
| V2 | 저장 행 검증(SO No 없음) | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks | Validation_Check(Validationdr) 3006~3011줄 등 | **확인 필요** |
| V3 | 저장 행 검증(SO No 있음) | 위와 같은 5개 필드 | Validation_Check(SONoValidationdr) | **확인 필요** |
| V4 | 그리드 필수 표기 | Shipment Qty*, Shipment Date*, Trans Mode* / Amend Qty*, End Date* | 메타 라벨 | **확인 필요** |
| V5 | ERP I/F 차단 | BLOCK_YN, PERIOD | chkERPIFBlockYn 2930·2939줄 | **확인 필요** |
| V6 | 확정 변경 시각 | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | **확인 필요** |
| V7 | ERP SO 건수 | CNT | `SSP.SSP0021_GET_ERP_SO_NO_CNT` 3853줄 | **확인 필요** |
| V8 | 출하 상태 | Tables[0~2].CONFIRM_ID | `SSP.SSP0021_GET_SHIPMENT_STATUS` | **확인 필요** |
| V9 | 시트 잠금 | IsLock(SheetName) | SpdDetail_CellClick | 메시지 없음(토글 차단만, 확인 필요) |

---

## 7. 권한 (C/R/U/D) 사실

| 구분 | 진입점 | 근거 |
|---|---|---|
| C | SaveButton (신규 확정 INSERT SSP_ANL_SHIP_CONFIRM, 변경요청 INSERT) | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| R | FindButton, BtnSearch_Click, SpdMain_CellDoubleClick | 조회 엔드포인트 |
| U | EditButton(사용자 확인) → SaveButton | `SSP.SSP0002_GET_USER_INFO_LIST` |
| D | 툴바 DeleteButton 진입점 없음. 저장 체인 내부에서만 DELETE SSP_ANL_SHIP_CONFIRM | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| 그룹·메뉴 | NowGroupID, TB_FX_GroupMenuAuth 14행 | 그룹별 값 **확인 필요** |

---

## 8. To-Be 전환 메모 (Wijmo·Oracle)

| # | 항목 | AS-IS | To-Be 고려 |
|---:|---|---|---|
| T1 | 상단 매트릭스 | FpSpread, 헤더 3행 Span, MergePolicy Always, 동적 날짜 열 | Wijmo FlexGrid columnHeaders 다단 행 + allowMerging. 날짜 열은 캘린더 API 결과로 동적 생성. `B_` 열 숨김, SAT/SUN 색은 셀 포맷 |
| T2 | Bucket/Sum 표시 전환 | SetSpreadColumn(태그 D_/W_/M_) | FE 열 visible 토글. DAILY의 W_ 최종값은 AS-IS 실행으로 먼저 확인 |
| T3 | 상세 다중 시트 | spdDetail 시트 8개 + 탭 | 탭 + 시트별 FlexGrid. 탭 인덱스 3·4(Hold 계열)는 AS-IS 확인 후 구성 |
| T4 | 헤더 체크박스 | CheckBoxCellType 헤더 토글 | FlexGrid 헤더 체크박스(잠금 시 비활성) |
| T5 | 조회조건 | UsrCombo / UsrCheckedList / UsrDateRangePicker / UsrMultiLineEditor | 공용 ComboBox / MultiSelect / 기간 입력 / 다중값 입력. drpPeriod는 읽기전용 |
| T6 | 이벤트 해제·재연결 | cboPlanDate 이벤트 -=/+= | 상태 업데이트 중 연쇄 조회 억제 플래그로 같은 동작 보장 |
| T7 | FoxQuery 미등록 SP | `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` | Mapper 신규 등록. DB 객체 P의 원문으로 Oracle 변환 |
| T8 | DB 미존재 SP | `SSP.SSP0021_SAVE_HOLD_STOCK_DATA` | 원본 확보 전 구현 보류 → 확인 필요 |
| T9 | MSSQL 구문 | STRING_SPLIT, #임시테이블, MERGE #TMP, 동적 SQL(DYNAMIC@), UF_FX_STRING_SPLIT | Oracle 19c: 분할 함수/파이프라인 함수, GTT 또는 WITH, 동적 SQL은 EXECUTE IMMEDIATE / REF CURSOR |
| T10 | 저장 체인 | UI가 여러 SP를 순차 호출 | BE Service 트랜잭션 경계 설계. 단계별 분기 조건은 AS-IS 원문으로 먼저 확정 |
| T11 | 다중 결과셋 | `SSP0021_GET_SHIPMENT_STATUS` Tables[0~2] | Oracle에서 REF CURSOR 3개 또는 API 분리 |
| T12 | 개발용 컨트롤 | chkSql(Show SQL), usrButton1(parent 없음) | 반영 여부 판단 필요 |
| T13 | 미연결 메서드 | GetErpIFCheck / GetErpIFCheckNew_ / NewNonSoNo | 구현 제외 후보(확인 필요) |

---

## 9. 미확정

1. 메뉴 위치, 그룹별 메뉴 권한.
2. txtRequestor·clbResultType·txtBoxID 라벨(props.csv 잘림), btnItemID2 LayoutControlItem Text(`layoutControlItem2`)의 실제 표시 여부.
3. 조회조건 영역의 행·열 배치(Location 미추출). usrLayoutControl2(77)와 usrConditionPanel1(73)의 높이 차이.
4. Panel2 높이 273 중 4px 차이(SplitterWidth).
5. Hold stock / Hold stock Detail 시트 생성 위치, 탭 인덱스 3·4.
6. 그리드 컬럼 셀 타입(CELL_CONTROL_OBJECT_TYPE_CODE), Locked 여부, 실제 컬럼 순서.
7. 핸들러 세부 로직: SpdMain_TopChange, SpdDetail_TopChange, SpdMain_Change, SpdMain_ClipboardPasted, SpdDetail_ActiveSheetChanged, SpdDetail_ComboSelChange, SpdDetail_CellDoubleClick, SpdDetail_EditChange, DrpPeriod2_ValueChanged, shtDetail_Change(dsdm), BtnSimulation_Click.
8. 팝업 대상 화면(btnItemId, btnItemID2, btnRequestor, btnMeasure).
9. 검증 메시지 문구 전체.
10. `SSP.SSP0021_SAVE_HOLD_STOCK_DATA`(DB 미존재), `SSP.SSP0021_GET_SHIPMENT_FROM_SITE`(FoxQuery 미등록).
