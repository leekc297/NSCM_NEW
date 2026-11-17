# SSP0060 화면설계서 — Shipment Plan

> **근거**: Fact Pack(SSP0060)과 1차 분석서만 사용했습니다. 없는 값은 **확인 필요**로 표기했습니다.
> §5 액션 명세의 엔드포인트는 업무분석서 §5와 같은 이름을 씁니다. §3 컨트롤명은 단위테스트 '절차' 열에서 그대로 씁니다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0060 |
| 화면명 | Shipment Plan (메인 Form `SSP0060_ShipmentPlan`) |
| 팝업 1 | `SSP0060_ShipmentPlanRequestPopup`: Form Text `"Shipment Request Popup"` |
| 팝업 2 | `SSP0060_ShipmentPlanConfirmDetailPopup`: Form Text `"Request Info Popup"` |
| 도메인 | SSP |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행, 값 미포함) |
| Grid 구성 방식 | HYBRID: META(SCM_MST_SHEET_COLUMNS 196행) + DB 루프(날짜 / EDIT_YN_*) + HARDCODED(Request Info) |
| 시트 | Hold stock, Hold stock Detail, MES Stock, MES Stock Detail, oWMS Detail, Request Info, Shipment Plan, Shipment Plan Detail, Shipment Result, Stock Location Detail (10개) |

---

## 2. 화면 레이아웃 (텍스트 와이어프레임)

### 2-1. 메인 `SSP0060_ShipmentPlan`
> splitContainer1의 **Orientation / SplitterDistance / Size는 props.csv가 잘려 확인 필요**입니다. 따라서 Panel1과 Panel2가 상/하인지 좌/우인지, 비율이 얼마인지 확정할 수 없습니다. 아래는 parent 체인(1차 분석서 web_components §2)만 반영한 트리입니다.

```
SSP0060_ShipmentPlan (Form)
├─ [프레임워크 공통 버튼바]  FindButton · SaveButton · EditButton          (menu-button-dynamic-fetch)
├─ usrConditionPanel1  ── 조회조건 영역
│   └─ usrLayoutControl2
│       ├─ clbCompany_ID      ├─ clbDivision_ID     ├─ clbPlantSite
│       ├─ cboPlanDate        ├─ cboBucketType      ├─ drpPeriod
│       ├─ txtItemId + btnItemId                     ├─ clbProductLevel11
│       ├─ chkSum             ├─ chkTotPSI          ├─ btnMeasure
│       └─ btnSimulation
├─ splitContainer1  (Orientation=확인 필요 · SplitterDistance=확인 필요 · 비율 %=확인 필요)
│   ├─ Panel1 ── 메인 그리드 영역
│   │   └─ spdMain  (spdMain_Sheet1 → 시트 "Shipment Plan")
│   └─ Panel2 ── Detail 영역
│       ├─ usrLayoutControl3  ── Detail 조회조건
│       │   ├─ txtRequestor + btnRequestor   ├─ txtModel2 + btnItemID2
│       │   ├─ drpPeriod2      ├─ drpPeriod3      ├─ clbResultType
│       │   ├─ txtBoxID        ├─ clbProductLevel12
│       │   └─ btnSearch       └─ btnNew
│       └─ spdDetail (spdDetail_Sheet1 → 시트 Shipment Plan Detail / Stock Location Detail /
│                      oWMS Detail / Shipment Result / Hold stock / Hold stock Detail /
│                      MES Stock / MES Stock Detail — 시트별 귀속은 확인 필요)
├─ usrButton1   (parent 없음 — 배치 위치 확인 필요)
├─ usrLayoutControl1 (메인/팝업 중 어느 Form의 어느 parent인지 controls.csv 원문 미수록 → 확인 필요)
└─ imageList1 (비시각)
```

### 2-2. 팝업 `SSP0060_ShipmentPlanRequestPopup` (Dock 기반 상/하 분할)
| 순서 | 컨트롤 | Dock | Size(W×H) | 높이 비율(전체 343) |
|---:|---|---|---|---:|
| 1 | usrConditionPanel1 | Top | 1764×52 | 15.2% |
| 2 | splitter1 | Top | 1764×3 | 0.9% |
| 3 | spdMain (spdMain_Sheet1 → "Request Info") | Fill | 1764×288 | 84.0% |

```
SSP0060_ShipmentPlanRequestPopup  "Shipment Request Popup"
┌───────────────────────────────────────────────────────── 1764 ─┐
│ usrConditionPanel1 (Top, 52)                                    │
│   usrButtonList1 · cboChangeReason "Change Reason*"             │
│   txtReasonDetail "Reason Detail*" · btnAutoSet "Auto Set"      │
│   (내부 LayoutControl 귀속: lcChangeReason/lcReasonDetail 존재, │
│    usrLayoutControl 이름은 확인 필요)                            │
├─ splitter1 (Top, 3) ────────────────────────────────────────────┤
│ spdMain (Fill, 288)  ── Request Info (49컬럼, 2단 헤더)          │
└─────────────────────────────────────────────────────────────────┘
```

### 2-3. 팝업 `SSP0060_ShipmentPlanConfirmDetailPopup` (Dock 기반 상/하 3단)
| 순서 | 컨트롤 | Dock | Size | 높이 비율(전체 370) |
|---:|---|---|---|---:|
| 1 | usrConditionPanel1 | Top | 1764×52 | 14.1% |
| 2 | panel1 (요청 정보, ReadOnly) | Top | 1764×158 | 42.7% |
| 3 | splitter1 | Top | 1764×3 | 0.8% |
| 4 | spdMain (spdMain_Sheet1 → "Request Info") | Fill | 1764×157 | 42.4% |

```
SSP0060_ShipmentPlanConfirmDetailPopup  "Request Info Popup"
┌──────────────────────────────────────────────── 1764 ─┐
│ usrConditionPanel1 (52)  btnButtonList                 │
├────────────────────────────────────────────────────────┤
│ panel1 (158)  usrLabel2 "Request Confirm Detail"        │
│   txtRequestNo "Request No" · txtRequestor "Requestor"  │
│   txtRequestDeptName "Dept Name" · txtApproval "Approval"│
│   txtAppDeptName "Dept Name"   (모두 ReadOnly)          │
├─ splitter1 (3) ────────────────────────────────────────┤
│ spdMain (157)  Request Info (48컬럼, 2단 헤더)           │
└────────────────────────────────────────────────────────┘
```

---

## 3. 컨트롤 명세 (43개)

> 라벨은 props.csv Text 원문입니다. 메인 화면의 LayoutControlItem Text는 props.csv가 잘려 **확인 필요**이며, 이 경우 LayoutItem 이름만 표기했습니다.

| # | 컨트롤명 | Form | 타입 | 라벨(Text 원문) | 초기값 | 필수 | 연결 이벤트 / 핸들러 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|---|
| 1 | usrLayoutControl1 | 확인 필요 | UsrLayoutControl | – | – | – | – | 레이아웃 컨테이너 |
| 2 | usrConditionPanel1 | 메인/두 팝업 | UsrConditionPanel | – | – | – | – | 조회조건 패널 (공용) |
| 3 | usrLayoutControl2 | 메인(usrConditionPanel1 하위) 외 | UsrLayoutControl | – | – | – | – | 조회조건 Grid 레이아웃 |
| 4 | btnButtonList | ConfirmDetailPopup | UsrButtonList | – | – | – | UsrButtonList_Click_Detected → `btnButtonList_UsrButtonList_Click_Detected` | 팝업 버튼바 |
| 5 | spdMain | 메인/두 팝업 | FpSpread | – | – | – | 메인: KeyDown→`spdMain_KeyDown`, KeyUp→`spdMain_KeyUp`, TopChange→`SpdMain_TopChange`, CellDoubleClick→`SpdMain_CellDoubleClick`, Change→`SpdMain_Change`, ClipboardPasted→`SpdMain_ClipboardPasted` / RequestPopup: ClipboardPasted→`spdMain_ClipboardPasted`, Change→`spdMain_Change`, KeyDown→`spdMain_KeyDown` | Wijmo FlexGrid |
| 6 | spdMain_Sheet1 | 메인/두 팝업 | SheetView | 메인: Shipment Plan / 팝업: Request Info | – | – | – | FlexGrid 컬럼 정의 |
| 7 | usrLayoutControl3 | 메인(splitContainer1.Panel2) | UsrLayoutControl | – | – | – | – | Detail 조회조건 레이아웃 |
| 8 | txtRequestNo | ConfirmDetailPopup | TextBox(ReadOnly) | `Request No` | 조회값(CHANGE_REQ_NO, 확인 필요) | – | – | readonly Input |
| 9 | txtRequestor | ConfirmDetailPopup(TextBox ReadOnly) / 메인(UsrTextBox) | TextBox / UsrTextBox | 팝업 `Requestor` / 메인 LayoutItem `Requestor`(Text 확인 필요) | – | – | 메인: btnRequestor 연동 | readonly Input / 입력+사용자 팝업 |
| 10 | txtRequestDeptName | ConfirmDetailPopup | TextBox(ReadOnly) | `Dept Name` | – | – | – | readonly Input |
| 11 | txtApproval | ConfirmDetailPopup | TextBox(ReadOnly) | `Approval` | – | – | – | readonly Input |
| 12 | txtAppDeptName | ConfirmDetailPopup | TextBox(ReadOnly) | `Dept Name` | – | – | – | readonly Input |
| 13 | usrLabel2 | ConfirmDetailPopup | UsrLabel | `Request Confirm Detail` | – | – | – | 섹션 타이틀 |
| 14 | usrButtonList1 | RequestPopup | UsrButtonList | – | – | – | UsrButtonList_Click_Detected → `usrButtonList1_UsrButtonList_Click_Detected` | 팝업 버튼바 |
| 15 | cboChangeReason | RequestPopup | UsrComboBox | `Change Reason*` | 확인 필요 | Y(라벨 *) | – | ComboBox (필수) |
| 16 | txtReasonDetail | RequestPopup | TextBox | `Reason Detail*` | – | Y(라벨 *) | – | Input (필수) |
| 17 | btnAutoSet | RequestPopup | SimpleButton | `Auto Set` | – | – | Click → `btnAutoSet_Click` | Button |
| 18 | usrButton1 | 메인(parent 없음) | UsrButton | 확인 필요 | – | – | 확인 필요 | 확인 필요 |
| 19 | btnSimulation | 메인 | UsrButton | LayoutItem `lcbtnSimulation`(Text 확인 필요) | – | – | Click → `BtnSimulation_Click` | Button |
| 20 | clbCompany_ID | 메인 | UsrCombo | 확인 필요 | GetSSPInnerTable(InitControls) | 확인 필요 | SelectedIndexChanged → `clbCompanyID_SelectedIndexChanged` | Wijmo ComboBox |
| 21 | chkSum | 메인 | UsrCheckBox | 확인 필요 | 확인 필요 | – | CheckedChanged → `chkSum_CheckedChanged` | Checkbox |
| 22 | btnMeasure | 메인 | UsrButton | 확인 필요 | – | – | Click → `BtnMeasure_Click` | Measure 선택 버튼 |
| 23 | btnItemId | 메인 | UsrButton | 확인 필요 | – | – | Click → `btnItemId_Click` | 품목 팝업 버튼 |
| 24 | clbPlantSite | 메인 | UsrCheckedList | 확인 필요 | 확인 필요 | 확인 필요 | – | Wijmo MultiSelect |
| 25 | drpPeriod | 메인 | UsrDateRangePicker | 확인 필요 | dtShipmentInputPeriod VALUE/Diff_VALUE 연관 여부는 확인 필요 | 확인 필요 | – | InputDate 쌍 |
| 26 | txtItemId | 메인 | UsrMultiLineEditor | LayoutItem `lblItemId` | – | – | btnItemId 연동 | 다건 입력 |
| 27 | clbDivision_ID | 메인 | UsrCombo | 확인 필요 | `SSP.SSP0060_GET_SHIPMENT_DIVISION` | 확인 필요 | SelectedIndexChanged → `clbDivision_ID_SelectedIndexChanged` | Wijmo ComboBox |
| 28 | cboPlanDate | 메인 | UsrCombo | LayoutItem `PlanDate` | 확인 필요 (CODE/FROM_DATE/TO_DATE1) | 확인 필요 | SelectedIndexChanged → `cboPlanDate_SelectedIndexChanged` | Wijmo ComboBox |
| 29 | cboBucketType | 메인 | UsrCombo | LayoutItem `lblBucket` | `DM.DM0003_GET_BUCKET_TYPE_CODE` | 확인 필요 | SelectedIndexChanged → `cboBucketType_SelectedIndexChanged` | Wijmo ComboBox |
| 30 | chkTotPSI | 메인 | UsrCheckBox | 확인 필요 | 확인 필요 | – | CheckedChanged → `chkTotPSI_CheckedChanged` | Checkbox(변경 시 재조회) |
| 31 | clbProductLevel11 | 메인 | UsrCheckedList | LayoutItem `lcProductLevel11` | 확인 필요 | – | – | MultiSelect |
| 32 | spdDetail | 메인 | FpSpread | – | – | – | TopChange→`SpdDetail_TopChange`, SheetTabClick→`SpdDetail_SheetTabClick`, ActiveSheetChanged→`SpdDetail_ActiveSheetChanged`, CellClick→`SpdDetail_CellClick`, ComboSelChange→`SpdDetail_ComboSelChange`, CellDoubleClick→`SpdDetail_CellDoubleClick`, EditChange→`SpdDetail_EditChange`, ClipboardPasted→`SpdDetail_ClipboardPasted` | Wijmo FlexGrid + 시트 탭 |
| 33 | spdDetail_Sheet1 | 메인 | SheetView | Detail 시트들 | – | – | (dsdm Changed → `shtDetail_Change`, 데이터셋 이벤트) | FlexGrid 컬럼 정의 |
| 34 | btnRequestor | 메인 | UsrButton | 확인 필요 | – | – | Click → `BtnRequestor_Click` | 사용자 팝업 버튼 |
| 35 | btnSearch | 메인 | SimpleButton | 확인 필요 | – | – | Click → `BtnSearch_Click` | Detail 조회 버튼 |
| 36 | txtModel2 | 메인 | UsrMultiLineEditor | 확인 필요 | – | – | btnItemID2 연동 | 다건 입력 |
| 37 | btnItemID2 | 메인 | UsrButton | 확인 필요 | – | – | Click → `BtnItemID2_Click` | 품목 팝업 버튼 |
| 38 | drpPeriod2 | 메인 | UsrDateRangePicker | 확인 필요 | 확인 필요 | – | ValueChanged → `DrpPeriod2_ValueChanged` | InputDate 쌍 |
| 39 | drpPeriod3 | 메인 | UsrDateRangePicker | 확인 필요 | 확인 필요 | – | – | InputDate 쌍 |
| 40 | clbResultType | 메인 | UsrCheckedList | 확인 필요 | 확인 필요 | – | – | MultiSelect |
| 41 | txtBoxID | 메인 | UsrMultiLineEditor | 확인 필요 | – | – | – | 다건 입력 |
| 42 | btnNew | 메인 | UsrButton | LayoutItem `lcbtnNew` | – | – | Click → `BtnNew_Click` | Button |
| 43 | clbProductLevel12 | 메인 | UsrCheckedList | LayoutItem `lcProductLevel12` | 확인 필요 | – | – | MultiSelect |

- Form 이벤트: 메인 `Form_Load`(.ctor:306), `SSP0060_ShipmentPlan_Shown`(.ctor:307) / RequestPopup `Form_Load`(.ctor:140), `SSP0060_ShipmentPlanRequestPopup_Shown`(.ctor:141), `SSP0060_ShipmentPlanRequestPopup_FormClosing`(Designer:341) / ConfirmDetailPopup `Form_Load`(.ctor:123).
- `spdMain_KeyDown`/`spdMain_KeyUp`(소문자, Designer 배선)와 `SpdMain_*`(대문자, InitEvent 배선)은 서로 다른 핸들러입니다.

---

## 4. 그리드 명세

> 공통: META 시트는 14개 Division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)에서 표시가 같습니다. 그래서 'division별 표시' 열은 모두 "14 Div 동일"입니다. 컬럼 순서는 grid_effective가 알파벳 정렬이어서 SCM_MST_SHEET_COLUMNS 원문 순서로 **확인 필요**입니다. 셀 타입(CELL_CONTROL_OBJECT_TYPE_CODE) 값은 Fact Pack에 없어 "META(확인 필요)"로 표기했습니다.

### 4-1. Shipment Plan (spdMain · META 13 표시 / 5 숨김 + DB 루프 · MEASURE 14/6)
| 컬럼 | 헤더 | 타입 | 출처 | division별 | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Div | META(확인 필요) | META | 14 Div 동일 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site | META | META | 동일 | 확인 필요 |
| TO_SITE | To Site | META | META | 동일 | 확인 필요 |
| PRODUCT_LEVEL1 | Product Level1 | META | META | 동일 | 확인 필요 |
| ITEM_ID | Model | META | META | 동일 | 확인 필요 |
| NICK_NAME | Nick Name | META | META | 동일 | 확인 필요 |
| FCST_TYPE | FCST Type | META | META | 동일 | 확인 필요 |
| INCOTERMS | Incoterms | META | META | 동일 | 확인 필요 |
| TRANSPORT_MODE | Transmode | META | META | 동일 | 확인 필요 |
| BOH_TYPE | BOH_TYPE | META | META | 동일 | 확인 필요 |
| BOH_QTY | BOH_QTY | META | META | 동일 | 확인 필요 |
| PSI | PSI | META | META | 동일 | 확인 필요 |
| MEASURE_NAME | Measure | META | META | 동일 | 확인 필요 |
| FROM_SITE / MEASURE / BACK_COLOR / CONFIRM_DAY / LOT_YN | Site / Measure / Back Color / Confrim Day(원문) / Lot_YN | META | META | 동일 | 숨김 |
| (날짜 컬럼) | SCP0009_GET_SHEET_CALENDAR_3SPAN 결과 | 동적 | DB 루프(InitSpreadDateColumn) | 동일 | EDIT_YN_* 및 EditByChange(QTY/NOEDIT_QTY) 연관. 규칙은 확인 필요 |
| EDIT_YN_{날짜} | E{COLUMN_LABEL_NAME} | 동적 | DB 루프(SetSpreadColumn) | 동일 | 표시 여부 확인 필요 |

### 4-2. Shipment Plan Detail (spdDetail · 44 표시 / 27 숨김)
| 컬럼 | 헤더 | 타입 | 출처 | division별 | 편집 |
|---|---|---|---|---|---|
| CHANGE_REASON_CODE | Change Reason* | META | META | 동일 | 필수 표시(편집 추정 금지 → 확인 필요) |
| CHANGE_REASON_DETAIL | Reason Detail* | META | META | 동일 | 필수 표시 |
| CHANGE_REQ_NO | Change Request No | META | META | 동일 | 확인 필요 |
| CONFIRM_ID | Confirm/Plan ID | META | META | 동일 | 확인 필요 |
| DIVISION_ID | Div | META | META | 동일 | 확인 필요 |
| ERP_DO_NO / ERP_SO_NO | DO No / SO No | META | META | 동일 | 확인 필요 |
| FCST_TYPE | FCST Type* | META | META | 동일 | 필수 표시 |
| FROM_SITE_DESCRIPTION | From Site* | META | META | 동일 | 필수 표시 |
| TO_SITE_DESCRIPTION | To Site* | META | META | 동일 | 필수 표시 |
| INCOTERMS | Incoterms* | META | META | 동일 | 필수 표시 |
| ITEM_ID | Model* | META | META | 동일 | 필수 표시 |
| SHIPMENT_CONFIRM_QTY | Shipment Qty* | META | META | 동일 | 필수 표시 · Validation_Check 비교 대상 |
| SHIPMENT_DATE | Shipment Date* | META | META | 동일 | 필수 표시 · Validation_Check 비교 대상 |
| TRANSPORT_MODE | Trans Mode* | META(콤보) | META + `biz:CommonData.CommonDataList`[TransMode] | 동일 | 편집(SpdDetail_EditChange / CellClick / ComboSelChange) |
| REMARKS / REMARKS2 / REMARKS3 | Remarks / Building / Customer Requirement | META | META | 동일 | REMARKS·REMARKS2는 Validation_Check 비교 대상 |
| SHIPMENT_STATUS | Status | META | META | 동일 | 확인 필요 |
| REQUESTOR | Shipment Requestor | META | META | 동일 | 확인 필요 |
| MODEL_USER | Model PIC | META | META | 동일 | 확인 필요 |
| LT_DAY | L/T(Day) | META | META | 동일 | 확인 필요 |
| A_COUNTRY / A_PORT_CODE / A_PORT_NAME | A Contry(원문) / A Port Code / A Port Name | META | META | 동일 | 확인 필요 |
| SHIPTO_DESCRIPTION / SOLDTO_DESCRIPTION | Ship To Party / Sold To Party | META | META | 동일 | 확인 필요 |
| ATTRIBUTE10, CITY_NAME, COUNTRY_NAME, END_CUSTOMER, ETA, ETD, Expected_Shipping_Date, MKT_OWNER, NICK_NAME, PRODUCT_LEVEL1, PROJECT_CODE, PROJECT_NAME, SHIPTO_CITY_NAME, SHIPTO_REGION_NAME, TEAM, UPDATED_BY, UPDATED_DATE | 컬럼명과 같음(라벨 원문은 메타 참조) | META | META | 동일 | 확인 필요 |
| 숨김 27: BOD_ID, CHANGE_TYPE, CHECK_NEED_YN "Checked", EDIT_MAIN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, FROM_SITE "From Site ID", TO_SITE "To Site ID", ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE | — | META | META | 동일 | 숨김 |

### 4-3. Stock Location Detail (20 표시 + EDIT_YN_*)
| 컬럼 | 헤더 | 출처 | division별 | 편집 |
|---|---|---|---|---|
| AVAILABLE_DATE, AVAILABLE_QTY, CUTOFF_DATE, FROM_SITE, HOLDING_DATE, MOVING_QTY, NICK_NAME, OUTSOURCING_FACTORY, OUTSOURCING_FLAG, STOCK_TYPE, TOTAL_QTY | 컬럼명과 같음 | META | 동일 | 조회 전용 여부 확인 필요 |
| COMPANY_ID / DEFECT_QTY / DIVISION_ID / ITEM_ID / PLANT_ID / QTY_UOM / STORAGE_DESCRIPTION / STORAGE_ID / WIPHOLD_YN | Company / Deffect Qty(원문) / Div / Model / Plant / Qty Uom / Storage / Storage ID / Wiphold Yn | META | 동일 | 확인 필요 |
| EDIT_YN_* | E{라벨} | DB 루프 | 동일 | 확인 필요 |

### 4-4. oWMS Detail (25 표시 + EDIT_YN_*)
| 컬럼 | 헤더 | 출처 | division별 | 편집 |
|---|---|---|---|---|
| ALLOCATION_QTY, AVAILABLE_QTY, CUSTOMER_CODE, CUSTOMER_NAME, EXPIRATION_QTY, GRADE, HOLD_QTY, LOT_ID, LOT_ISSUE_DATE, MOVING_QTY, NICK_NAME, PACKING_QTY, PACKING_STATUS, PALLET_ID, PLANT_ID, SOC, STOCK_QTY, UNDECIDED_QTY | 컬럼명과 같음 | META | 동일 | 확인 필요 |
| CAPA_GRADE / DIVISION_ID / ITEM_ID / LONG_TERM_QTY / RECEIVING_QTY / STOCK_STATUS / STORAGE_ID | Capa. Grade / Div / Model / Long-term Qty / Reciving Qty(원문 오타) / Inventory Status / Storage | META | 동일 | 확인 필요 |
| EDIT_YN_* | E{라벨} | DB 루프 | 동일 | 확인 필요 |

### 4-5. Hold stock (10 표시 / 2 숨김)
| 컬럼 | 헤더 | 출처 | division별 | 편집 |
|---|---|---|---|---|
| DIVISION_ID | Div | META | 동일 | 확인 필요 |
| FROM_SITE_NM | From Site | META | 동일 | 확인 필요 |
| ITEM_ID | Model | META | 동일 | 확인 필요 |
| NICK_NAME | NICK_NAME | META | 동일 | 확인 필요 |
| HOLD_QTY | Amend Qty* | META | 동일 | 필수 표시. 저장 엔드포인트 `SSP.SSP0060_SAVE_HOLD_STOCK_DATA` 없음(확인 필요) |
| HOLD_YYYYMMDD | Start Date | META | 동일 | 확인 필요 |
| RELEASE_YYYYMMDD | End Date* | META | 동일 | 필수 표시 |
| REMARKS / LAST_UPDATED_BY / LAST_UPDATE_DATE | 같음 | META | 동일 | 확인 필요 |
| FROM_SITE "Site", HOLD_ID | — | META | 동일 | 숨김 |

### 4-6. Hold stock Detail (10 표시 / 2 숨김)
Hold stock과 컬럼이 같습니다. 라벨에 `*`가 없습니다(HOLD_QTY "Amend Qty", RELEASE_YYYYMMDD "End Date"). 숨김 컬럼은 FROM_SITE, HOLD_ID입니다. 출처는 META, 14 Div 동일입니다. 이 시트를 생성하는 코드 위치와 데이터 소스는 **확인 필요**입니다(코드 생성 시트 목록에 없음).

### 4-7. MES Stock (9 표시 + EDIT_YN_*)
| 컬럼 | 헤더 | 출처 | division별 | 편집 |
|---|---|---|---|---|
| ITEM_ID, NICK_NAME, TOTAL, AVAILABLE_STOCK, BEFORE_OQC, OQC_INSP_REQUEST, OQC_COMPLETE, OQC_NG | Model 외 컬럼명과 같음 | META | 동일 | 확인 필요 |
| QMS_MES_HOLD | QMS/MES Hold | META | 동일 | 확인 필요 |

### 4-8. MES Stock Detail (13 표시 + EDIT_YN_*)
| 컬럼 | 헤더 | 출처 | division별 | 편집 |
|---|---|---|---|---|
| PRODID / PRJT_NAME / LOTID / BOXID | Model / Nick Name / Lot ID / Box ID | META | 동일 | 확인 필요 |
| LOT_QTY, OQC_INSP_RESULT, PROD_VALID_DATE, MES_HOLD_YN, MES_UNHOLD_SCHD_DATE, QMS_HOLD_YN, QMS_UNHOLD_SCHD_DATE | 같음 | META | 동일 | 확인 필요 |
| AVAILABLE_YN / EXP_INSP_VALID_DATE | Available stock YN / Exp Insp Vaild Date(원문 오타) | META | 동일 | 확인 필요 |

### 4-9. Shipment Result (16 표시 + EDIT_YN_*)
| 컬럼 | 헤더 | 출처 | division별 | 편집 |
|---|---|---|---|---|
| CONFIRM_ID / DIVISION_ID / ERP_SO_NO / ETA_DATE / ETD_DATE / ITEM_ID / QTY / TRANSPORT_MODE / TYPE / YYYYMMDD | Confirm/Plan ID / Div / SO No / ETA / ETD / Model / Shipment Qty / Trans Mode / Status / Shipment Date | META | 동일 | 확인 필요 |
| END_CUSTOMER, FROM_SITE, TO_SITE, INCOTERMS, NICK_NAME, SHIP_TYPE | 같음 | META | 동일 | 확인 필요 |

### 4-10. Request Info (두 팝업 · HARDCODED · 2단 헤더 `Confirmed` / `Change`)
| 필드 | 헤더 | 타입 | 폭 | 출처 | ConfirmDetail 표시 | RequestPopup 표시 |
|---|---|---|---:|---|---|---|
| (CAppSetting.StringAction) | A | Text | 10 | HARDCODED | 숨김 | 확인 필요 |
| CHANGE_REQ_NO | change_req_no | Text | 100 | HARDCODED | 숨김 | 확인 필요 |
| DIVISION_ID | Division ID | Text | 100 | HARDCODED | 숨김 | 확인 필요 |
| NEW_YN | New YN | Text | 10 | HARDCODED(RequestPopup만, :205) | – | 숨김 |
| CONFIRM_ID | Confirm/Plan ID | Text | 100 | HARDCODED | 표시 | 확인 필요 |
| ERP_SO_NO | SO No | Text | 100 | HARDCODED | 표시 | 확인 필요 |
| PROJECT_NAME | Project Name | Text | 100 | HARDCODED | 표시 | 확인 필요 |
| FCST_TYPE | FCST Type | Combo (`biz:CommonData.CommonDataList`[LookupCommon] `SALES_TYPE_CODE`) | 100 | HARDCODED | 표시 | 확인 필요 |
| ITEM_ID / FROM_SITE / TO_SITE / INCOTERMS | Model / From Site / To Site / Incoterms | Text | 80/60/100/65 | HARDCODED | 표시 | 확인 필요 |
| [Confirmed] LT_DAY / ETD / ETA / TRANSPORT_MODE / SHIPMENT_DATE / SHIPMENT_CONFIRM_QTY | L/T(Day) / ETD / ETA / Trans Mode / Shipment Date / Qty | Text/Date/Date/Text/Date/Num | 60/70/70/45/70/60 | HARDCODED | 표시 | 확인 필요 |
| [Change] NEW_LT_DAY / NEW_ETD / NEW_ETA / NEW_TRANSPORT_MODE / NEW_SHIPMENT_DATE / NEW_SHIPMENT_CONFIRM_QTY | 같은 헤더 | 같은 타입 | 같은 폭 | HARDCODED | 표시 | 확인 필요 |
| DIFF_QTY | Diff Qty | Num | 60 | HARDCODED | 표시 | 확인 필요 |
| CHANGE_REASON_CODE | Change Reason | Combo (`GetSSPInnerTable("CHANGE_REASON_CODE_ALL")`) | 100 | HARDCODED | 표시 | 확인 필요 |
| CHANGE_REASON_DETAIL | Reason Detail | Text | 100 | HARDCODED | 표시 | 확인 필요 |
| NEW_BOD_ID, NEW_ROUTE_ID, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_TO_COUNTRY | 같은 이름 | Text | 100 | HARDCODED | 숨김 | 확인 필요 |
| **ELECTRODE_YN** | **NEW_TO_CITY** (원문 그대로, 교차) | Text | 100 | HARDCODED | 숨김 | 확인 필요 |
| **NEW_TO_CITY** | **ELECTRODE_YN** (원문 그대로, 교차) | Text | 100 | HARDCODED | 숨김 | 확인 필요 |
| ELECTRODE_TYPE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, EDIT_REMARKS, EDIT_MAIN, REMARKS, REMARKS2, REMARKS3, PRODUCT_LEVEL1, NICK_NAME, FROM_SITE_DESCRIPTION, TO_SITE_DESCRIPTION, PROJECT_CODE | 같은 이름 | Text | 100 | HARDCODED | 숨김 | 확인 필요 |

- 컬럼 수: ConfirmDetailPopup 48, RequestPopup 49(NEW_YN 포함). 두 팝업 모두 division에 따른 분기가 없습니다(HARDCODED, 조건은 `SheetName == "Request Info"`만 있음).
- 헤더 스타일: HorizontalAlignment=General, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced, VerticalAlignment=General.

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 메인 Load | `Form_Load` | InitControls > SetChangedControl / GetBucketType, CreateSpread > InitSpread > GetSpdTitle | `SSP.SSP0060_GET_SHIPMENT_DIVISION`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | clbDivision_ID, clbPlantSite(확인 필요), cboBucketType, spdMain 헤더 |
| A2 | 메인 Shown | `SSP0060_ShipmentPlan_Shown` | 확인 필요 | — | 확인 필요 |
| A3 | FindButton(메인) | FindButton | FindData_Main (> InitSpread > GetSpdTitle) | `SSP.SSP0060_GET_SHIPMENT_PLAN`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain "Shipment Plan" |
| A4 | SaveButton(메인) | SaveButton | SaveData_Main | `SSP.SSP0060_SAVE_SHIPMENT_PLAN` | 저장 후 처리 확인 필요 |
| A5 | SaveButton(메인) | SaveButton | SaveData_Detail: Validation_Check, chkERPIFBlockYn | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` | — |
| A6 | 〃 | 〃 | GetERPInterface | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.SSP0060_GET_ERP_SO_NO_CNT`, `SSP.SSP0060_GET_SHIPMENT_STATUS`, `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | 분기 판정 |
| A7 | 〃 | 〃 | SoNo / NonSoNo, GetErpIFCheckNew | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | ERP IF 기록 |
| A8 | 〃 | 〃 | Hold stock 저장(3460) | `SSP.SSP0060_SAVE_HOLD_STOCK_DATA` (NOT_IN_FOXQUERY) | **확인 필요** |
| A9 | 〃 | 〃 | 재조회 FindData_Main / Detail / hold_stock | `SSP.SSP0060_GET_SHIPMENT_PLAN`, `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0060_GET_HOLD_STOCK`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain, spdDetail |
| A10 | EditButton | EditButton | GetSSPUserCheck | `SSP.SSP0002_GET_USER_INFO_LIST` | 권한 판정 후 처리 확인 필요 |
| A11 | clbDivision_ID 변경 | `clbDivision_ID_SelectedIndexChanged` | GetNERPCode | `SSP.SSP0002_GET_NERP_CODE` | SEGMENT2 보관 |
| A12 | clbCompany_ID 변경 | `clbCompanyID_SelectedIndexChanged` | cboPlanDate 이벤트 해제(7196) → InitSpread > GetSpdTitle → 재연결(7200) | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain 헤더 |
| A13 | cboPlanDate 변경 | `cboPlanDate_SelectedIndexChanged` | GetSpdTitle, InitSpreadDateColumn | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 날짜 컬럼 |
| A14 | cboBucketType 변경 | `cboBucketType_SelectedIndexChanged` | 확인 필요 | — | 확인 필요 |
| A15 | chkSum 변경 | `chkSum_CheckedChanged` | 합계 표시(CalculateSum / Set_SumValues 연관은 확인 필요) | — | spdMain |
| A16 | chkTotPSI 변경 | `chkTotPSI_CheckedChanged` | FindData_Main | `SSP.SSP0060_GET_SHIPMENT_PLAN`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain 재조회 |
| A17 | btnMeasure | `BtnMeasure_Click` | InitSpread > GetSpdTitle | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain 재구성 |
| A18 | btnItemId | `btnItemId_Click` | 품목 팝업(확인 필요) | — | txtItemId |
| A19 | btnItemID2 | `BtnItemID2_Click` | 품목 팝업(확인 필요) | — | txtModel2 |
| A20 | btnSearch | `BtnSearch_Click` | FindData_Detail / Stock_Detail / oWMS_Detail / Shipment_Result / MES_stock / MES_stock_Detail | `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0060_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0060_GET_OWMS_DETAIL`, `SSP.SSP0060_GET_SHIPMENT_RESULT`, `SSP.SSP0060_GET_MES_STOCK`, `SSP.SSP0060_GET_MES_STOCK_DETAIL`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdDetail 시트 |
| A21 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | A20과 같은 조회 + FindData_hold_stock | A20의 엔드포인트 + `SSP.SSP0060_GET_HOLD_STOCK` | spdDetail (Hold stock 포함) |
| A22 | btnNew | `BtnNew_Click` | 확인 필요 | — | 확인 필요 |
| A23 | btnRequestor | `BtnRequestor_Click` | 사용자 팝업(확인 필요) | — | txtRequestor |
| A24 | btnSimulation | `BtnSimulation_Click` | Simulation (Container_Qty) | — | spdMain 값 |
| A25 | spdMain 스크롤 | `SpdMain_TopChange` | 스크롤 동기화(대상 확인 필요) | — | — |
| A26 | spdDetail 스크롤 | `SpdDetail_TopChange` | 〃 | — | — |
| A27 | spdMain 키 | `spdMain_KeyDown`, `spdMain_KeyUp` | 확인 필요 | — | — |
| A28 | spdMain 변경/붙여넣기 | `SpdMain_Change`, `SpdMain_ClipboardPasted` | EditByChange / SetNote_Display 연관은 확인 필요 | — | spdMain |
| A29 | spdDetail 탭 | `SpdDetail_SheetTabClick`, `SpdDetail_ActiveSheetChanged` | 시트 전환 처리(확인 필요) | — | spdDetail |
| A30 | spdDetail 셀 클릭 | `SpdDetail_CellClick` | Trans Mode 콤보 재조회 | `biz:CommonData.CommonDataList` [TransMode] | TRANSPORT_MODE 콤보 |
| A31 | spdDetail 편집 | `SpdDetail_EditChange` | 〃 (1380, 1389) | `biz:CommonData.CommonDataList` [TransMode] | 〃 |
| A32 | spdDetail 콤보 선택 | `SpdDetail_ComboSelChange` | 확인 필요 | — | — |
| A33 | spdDetail 더블클릭 | `SpdDetail_CellDoubleClick` | 확인 필요(팝업 호출 여부 확인 필요) | — | — |
| A34 | spdDetail 붙여넣기 | `SpdDetail_ClipboardPasted` | c.CODE 사용 | — | spdDetail |
| A35 | dsdm Changed | `shtDetail_Change` | 확인 필요 | — | — |
| A36 | drpPeriod2 변경 | `DrpPeriod2_ValueChanged` | 확인 필요 | — | drpPeriod3 연동 여부 확인 필요 |
| A37 | RequestPopup Load | `Form_Load` | FindData_Main | `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | spdMain "Request Info" |
| A38 | RequestPopup Shown / FormClosing | `SSP0060_ShipmentPlanRequestPopup_Shown`, `SSP0060_ShipmentPlanRequestPopup_FormClosing` | 확인 필요 | — | — |
| A39 | RequestPopup 저장 | SaveButton / `usrButtonList1_UsrButtonList_Click_Detected` | SaveData > ChkEngProcessing | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`, `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` | — |
| A40 | 〃 | 〃 | GetERPInterface | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE`, `SSP.SSP0060_GET_ERP_SO_NO_CNT`, `SSP.SSP0060_GET_SHIPMENT_STATUS` | 분기 판정 |
| A41 | 〃 | 〃 | SoNo / NonSoNo / GetErpIFCheckNew | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C` | ERP IF 기록 |
| A42 | RequestPopup Auto Set | `btnAutoSet_Click` | 클라이언트 로직(확인 필요) | — | spdMain |
| A43 | RequestPopup spdMain | `spdMain_ClipboardPasted`, `spdMain_Change`, `spdMain_KeyDown` | 확인 필요 | — | spdMain |
| A44 | ConfirmDetailPopup Load / Find | `Form_Load`, FindButton | FindDataMain | `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | txtRequestNo 외, spdMain |
| A45 | ConfirmDetailPopup 버튼바 | `btnButtonList_UsrButtonList_Click_Detected` | 확인 필요 | — | — |
| A46 | Request Info FCST Type 콤보 | 필드 초기화식 `<field:dtFcstType>` | LookupCommon SALES_TYPE_CODE | `biz:CommonData.CommonDataList` [LookupCommon] | FCST_TYPE 콤보 |
| A47 | (unreached) RequestPopup GetErpIFCheck | — | 진입점 없음 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | 이관 여부 확인 필요 |
| A48 | (unreached) 메인 GetErpIFCheck / GetErpIFCheckNew_ / NewNonSoNo | — | 진입점 없음 | `SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING` | 이관 여부 확인 필요 |

---

## 6. 검증·메시지

| # | 검증 | 위치 | 메시지 원문 |
|---|---|---|---|
| M1 | confirm_id 단위 비교: shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks | Validation_Check(3644~3786) | 확인 필요 |
| M2 | ERP IF Block: BLOCK_YN, PERIOD | chkERPIFBlockYn(3568/3577), 팝업 ChkERPIFBlockYn(756/765) | 확인 필요 |
| M3 | 계획 처리 중 확인 | ChkEngProcessing → `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | 확인 필요 |
| M4 | 확정 변경 시각 확인 | ChkConfirmChangeTime → `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` / `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE` | 확인 필요 |
| M5 | 출하 상태 확인 (Tables[0..2] CONFIRM_ID) | GetShipmentStatusChk → `SSP.SSP0060_GET_SHIPMENT_STATUS` | 확인 필요 |
| M6 | 필수 표시 `*`: Change Reason*, Reason Detail*(팝업과 Detail 시트), FCST Type*, From Site*, To Site*, Incoterms*, Model*, Shipment Qty*, Shipment Date*, Trans Mode*, Amend Qty*, End Date* | 라벨 | 코드 강제 여부와 메시지는 확인 필요 |
| M7 | ERP 결과 코드 result_code | GetErpIFCheck(unreached) | 확인 필요 |

---

## 7. 권한 (C/R/U/D 사실)

| 권한 | 사실 |
|---|---|
| R | FindButton(메인과 두 팝업). Detail 조회는 btnSearch와 spdMain 더블클릭 |
| C/U | SaveButton(메인: SaveData_Main/SaveData_Detail, RequestPopup: SaveData), usrButtonList1 |
| D | 전용 진입점 없음. `SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING`은 unreached. 저장 체인 안에서 `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`이 DELETE SSP_ANL_SHIP_CONFIRM을 수행 |
| Edit | EditButton > `SSP.SSP0002_GET_USER_INFO_LIST` (TB_FX_USERGROUPAUTHEXTENTION 외) |
| 데이터 범위 | `SSP.SSP0060_GET_SHIPMENT_DIVISION`이 TB_FX_USERGROUPAUTHEXTENTION 기준으로 Division/Site를 필터. NowGroupID와 Filter GROUP_ID/USER_ID 사용 |
| 메뉴 권한 값 | TB_FX_GroupMenuAuth 13행. 값은 **확인 필요** |

---

## 8. To-Be 전환 메모 (Wijmo · Oracle 관점)

| # | 항목 | 전환 메모 |
|---|---|---|
| T1 | FpSpread → Wijmo FlexGrid | spdMain과 spdDetail(다중 시트 탭)은 FlexGrid + 탭 구성으로 바꿉니다. spdDetail 8개 시트(Hold stock Detail 귀속은 확인 필요)를 탭으로 전환합니다 |
| T2 | 동적 컬럼 | 날짜 컬럼(`SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`)과 `EDIT_YN_*` 컬럼은 FE 동적 생성이 필요합니다. Plan Date와 Bucket이 바뀌면 재생성합니다 |
| T3 | 메타 컬럼 | SetSheetHeaderColumn이 읽는 메타(COLUMN_LABEL_NAME, VISIBLE_FLAG, VALID_YN, COLUMN_WIDTH, FIXED_FLAG, CELL_CONTROL_OBJECT_TYPE_CODE 등)는 `ui-category-setup-column-meta` 기준으로 매핑합니다 |
| T4 | 버튼 | FindButton/SaveButton/EditButton → `menu-button-dynamic-fetch`. 화면 속성은 `ui-dynamic-property-management` |
| T5 | Request Info | HARDCODED 2단 헤더(Confirmed/Change)는 FlexGrid columnGroups로 옮깁니다. ELECTRODE_YN↔NEW_TO_CITY 헤더/필드 교차를 유지할지는 결정이 필요합니다 |
| T6 | 이벤트 일시 해제 | clbCompanyID → cboPlanDate 이벤트 해제와 재연결(7196/7200)은 React 상태 갱신 순서 제어(연쇄 호출 방지)로 바꿉니다 |
| T7 | Oracle 전환 | SP 내부의 STRING_SPLIT 참조(`SSP0060_GET_SHIPMENT_STATUS`, `SSP0060_GET_SHIPMENT_PLAN` 등), `#` 임시 테이블, 동적 SQL(`SSP0060_GET_SHIPMENT_PLAN`, `SSP0060_GET_SHIPMENT_PLAN_DETAIL`)은 Oracle 19c 문법으로 바꿔야 합니다(MSSQL 키워드 잔존 금지) |
| T8 | 미존재 엔드포인트 | `SSP.SSP0060_SAVE_HOLD_STOCK_DATA`를 어떻게 대체할지 결정이 필요합니다 |
| T9 | 트랜잭션 | 저장 체인(확정 → ERP IF → 메일 → DM 동기화)을 하나의 트랜잭션으로 묶을지, 단계별 커밋을 유지할지 결정이 필요합니다 |
| T10 | 공통 콤보 | `biz:CommonData.CommonDataList`(LookupCommon / TransMode)를 공용 콤보 API로 바꿉니다 |

---

## 9. 미확정

1. splitContainer1의 Orientation, SplitterDistance, Size와 메인 영역 비율 %
2. 메인 LayoutControlItem Text(조회조건 라벨) 전체
3. usrLayoutControl1과 usrButton1의 parent와 배치
4. 시트별 Spread 귀속(특히 Hold stock Detail)과 더블클릭 셀별 조회 분기
5. RequestPopup Request Info 컬럼의 표시 여부, 폭, 정렬
6. 두 팝업을 메인에서 여는 지점과 파라미터
7. 각 핸들러 내부 처리(확인 필요로 표기한 액션 A2, A14, A22, A27, A32, A33, A35, A36, A38, A42, A43, A45)
8. 검증 메시지 원문 전체
9. TB_FX_GroupMenuAuth 권한 값과 메뉴 위치
