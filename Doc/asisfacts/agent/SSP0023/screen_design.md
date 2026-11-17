# SSP0023 Shipment Plan(Electrode) — 화면설계서

> **근거**: Fact Pack(controls.csv · events.csv · flow.csv · endpoints.csv · props.csv · grid_rule/grid_code/grid_effective)과 1차 분석서만 사용했습니다. props.csv가 41,721자에서 잘려 일부 라벨과 SplitContainer 속성을 확인할 수 없고, 해당 항목은 **확인 필요**로 표기했습니다.
> 관련 문서: 업무분석서 §5 데이터 흐름 ↔ 이 문서 §5 액션 명세 ↔ 단위테스트 근거 열은 같은 엔드포인트 이름을 씁니다. §3 컨트롤명은 단위테스트 절차 열에 그대로 나옵니다.

---

## 1. 화면 개요
| 항목 | 값 |
|---|---|
| 화면 ID | SSP0023 |
| 화면명 | Shipment Plan(Electrode) |
| AS-IS 클래스 | `SSP0023_ShipmentPlanElectrode` |
| 도메인 | SSP (Plan) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행, 내용은 Fact Pack에 없음) |
| 소스 | `SSP0023_ShipmentPlanElectrode.cs` 6,823줄 / `.Designer.cs` 2,382줄 (current) |
| 컨트롤 수 | 88 (controls.csv) |
| Spread | `spdMain`, `spdDetail`, `spdSub` |
| Grid 구성 방식 | HYBRID: META(SetSheetHeaderColumn ×5) + DB 루프(InitSpreadDateColumn) + 코드 표시 변경 |

---

## 2. 화면 레이아웃

### 2-1. 분할 트리 (controls.csv parent 체인 + props.csv)
```
SSP0023_ShipmentPlanElectrode (this)
├─ usrConditionPanel1  [UsrConditionPanel] Dock=Top · Size=1689×101 · UsrPanelType=HidePanel
│   └─ usrLayoutControl2  [UsrLayoutControl] Dock=Top · Size=1689×98   (Root: layoutControlGroup2 1689×106)
│       ├─ [조회조건] clbCompany_ID · clbDivision_ID · cboPlanDate · drpPeriod · cboBucketType
│       │            clbFromSite · txtItemId(+btnItemId) · txtModelId · textNickName
│       ├─ [표시옵션] usrLabel1(UOM Type) · rdButton1 · rdButton2 · rdButton3 · chkSum · btnMeasure
│       │            chkMyModel · chkDelegateeModel · chkTeamLeader · chkPartLeader · chkPastPeriod
│       └─ [버튼]     btnSimulation · formDown · btnExcelUpload
│
└─ splitContainer1  [SplitContainer]
    │   Orientation     = 확인 필요 (props.csv 잘림 구간)
    │   SplitterDistance= 확인 필요
    │   Size            = 확인 필요
    │   parent          = 확인 필요 (controls.csv 해당 행 잘림 구간)
    ├─ Panel1
    │   └─ spdMain [FpSpread] ─ spdMain_Sheet1  → 시트 "Shipment Plan(Electrode)"
    └─ Panel2
        ├─ usrLayoutControl3 [UsrLayoutControl]  (Root: layoutControlGroup3)
        │   └─ [상세 조건] txtNickName2 · txtModel2 · txtItemId2(+btnItemId2) · txtLotID
        │                 clbResultType · drpPeriod2 · drpPeriod3 · txtRequestor(+btnRequestor) · btnSearch
        ├─ spdDetail [FpSpread] ─ spdDetail_Sheet1 → 탭 "Shipment Plan Detail" / "Stock Detail" / "Shipment Result"
        └─ spdSub [FpSpread] ─ spdSub_Sheet1     → 시트 "Shipment Plan Detail Excel" (표시 여부 확인 필요)

(부모 없음) usrButton1 [UsrButton] Size=75×23 — 배치 위치·용도 확인 필요
(비시각)    imageList1 [ImageList]
```
- **상/하 또는 좌/우 분할 방향과 비율(%)**: Orientation과 SplitterDistance 값이 Fact Pack에 없어 **산출할 수 없습니다(확인 필요)**. Panel1에는 마스터 그리드(spdMain), Panel2에는 상세 조건과 상세 그리드가 있다는 것만 사실입니다.
- 조회조건 영역의 높이는 101px(usrConditionPanel1)입니다. 내부 LayoutControlItem의 행·열 배치 좌표는 Fact Pack에 없습니다(확인 필요).
- 팝업: Material(btnItemId, btnItemId2), Requestor(btnRequestor), Measure(btnMeasure). 팝업 화면 ID는 확인 필요입니다.

---

## 3. 컨트롤 명세

> 라벨 = props.csv의 Text 원문(LayoutControlItem 또는 컨트롤 Text). "확인 필요" = props.csv 잘림 구간.

### 3-1. 상단 조회조건 (usrConditionPanel1 / usrLayoutControl2)
| 컨트롤명 | 타입 | 라벨(Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| `usrConditionPanel1` | UsrConditionPanel | — | Dock=Top, HidePanel | — | — | 조회조건 패널(접기 가능) |
| `usrLayoutControl2` | UsrLayoutControl | — | Dock=Top | — | — | 조회조건 그리드 레이아웃 |
| `clbCompany_ID` | UsrCombo | `Company*` | dtCompany.Rows[0].CODE (InitControls) | Y | SelectedIndexChanged → `clbCompanyID_SelectedIndexChanged` | Wijmo ComboBox(단일) |
| `clbDivision_ID` | UsrCombo | `Division*` | 확인 필요 | Y | SelectedIndexChanged → `clbDivision_ID_SelectedIndexChanged` | Wijmo ComboBox(단일) |
| `cboPlanDate` | UsrCombo | `Plan-date*` | 확인 필요 (CODE/FROM_DATE/TO_DATE) | Y | SelectedIndexChanged → `cboPlanDate_SelectedIndexChanged` | Wijmo ComboBox |
| `drpPeriod` | UsrDateRangePicker | `Period*` | Enabled=false | Y | — | 기간 입력(읽기 전용) |
| `cboBucketType` | UsrCombo | `Bucket` | 확인 필요 (DAILY/WEEKLY/MONTHLY) | N | SelectedIndexChanged → `cboBucketType_SelectedIndexChanged` | Wijmo ComboBox |
| `clbFromSite` | UsrCheckedList | `From Site` | 확인 필요 | N | — | Wijmo MultiSelect |
| `txtItemId` | UsrMultiLineEditor | `Material` | 빈값 | N | — | 멀티라인 입력 |
| `btnItemId` | UsrButton | 확인 필요 | — | — | Click → `btnItemId_Click` | 아이콘 버튼(Material 팝업) |
| `txtModelId` | UsrMultiLineEditor | 확인 필요 | 빈값 | N | — | 멀티라인 입력 |
| `textNickName` | UsrMultiLineEditor | 확인 필요 | 빈값 | N | — | 멀티라인 입력 |
| `usrLabel1` | UsrLabel | `UOM Type` | — | — | — | 라벨 |
| `rdButton1` | UsrRadio | `UOM` | Checked=true | — | CheckedChanged → `rdButton_Changed` | RadioGroup 항목 |
| `rdButton2` | UsrRadio | `Cell` | false | — | CheckedChanged → `rdButton_Changed` | RadioGroup 항목 |
| `rdButton3` | UsrRadio | `Pancake m` | false | — | **배선 없음** (events.csv) | RadioGroup 항목 |
| `chkSum` | UsrCheckBox | `Sum` | 확인 필요 | — | CheckedChanged → `chkSum_CheckedChanged` | CheckBox |
| `btnMeasure` | UsrButton | 확인 필요 | — | — | Click → `BtnMeasure_Click` | 아이콘 버튼(Measure 선택) |
| `chkMyModel` | UsrCheckBox | `My Model` | 확인 필요 | — | — | CheckBox |
| `chkDelegateeModel` | UsrCheckBox | `Delegatee Model` | 확인 필요 | — | — | CheckBox |
| `chkTeamLeader` | UsrCheckBox | `Team Leader` | 확인 필요 | — | — | CheckBox |
| `chkPartLeader` | UsrCheckBox | `Part Leader` | 확인 필요 | — | — | CheckBox |
| `chkPastPeriod` | UsrCheckBox | `Including Past Period` | 확인 필요 | — | CheckedChanged → `chkPastPeriod_CheckedChanged` | CheckBox |
| `btnSimulation` | UsrButton | `Simulation` | — | — | Click → `BtnSimulation_Click` | 버튼 |
| `formDown` | UsrButton | `Excel Form` | — | — | Click → `btnExcelFormDownload_Click` | 버튼 |
| `btnExcelUpload` | UsrButton | `Upload` | — | — | Click → `btnExcelUpload_Click` | 버튼(파일 업로드) |
| `usrButton1` | UsrButton | 확인 필요 | Size 75×23, parent 없음 | — | 배선 없음 | 미사용 여부 확인 필요 |

### 3-2. 하단 상세 조건 (splitContainer1.Panel2 / usrLayoutControl3)
| 컨트롤명 | 타입 | 라벨(Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| `usrLayoutControl3` | UsrLayoutControl | — | — | — | — | 상세 조건 레이아웃 |
| `txtNickName2` | UsrMultiLineEditor | 확인 필요 (layoutNickNameDetail) | 빈값 | 확인 필요 | — | 멀티라인 입력 |
| `txtModel2` | UsrMultiLineEditor | 확인 필요 (layoutModelDetail) | 빈값 | 확인 필요 | — | 멀티라인 입력 |
| `txtItemId2` | UsrMultiLineEditor | 확인 필요 (layoutMaterialDetail) | 빈값 | 확인 필요 | — | 멀티라인 입력 |
| `btnItemId2` | UsrButton | 확인 필요 (layoutMaterialBtn) | — | — | Click → `BtnMaterialId2_Click` | 팝업 버튼 |
| `txtLotID` | UsrMultiLineEditor | 확인 필요 (layoutLotId) | 빈값 | 확인 필요 | — | 멀티라인 입력 |
| `clbResultType` | UsrCheckedList | 확인 필요 (layoutResultType) | 확인 필요 | 확인 필요 | — | Wijmo MultiSelect |
| `drpPeriod2` | UsrDateRangePicker | 확인 필요 (layoutShipmentDate2) | 확인 필요 | 확인 필요 | — | 기간 입력 |
| `drpPeriod3` | UsrDateRangePicker | 확인 필요 (layoutShipmentDate1) | 확인 필요 | 확인 필요 | — | 기간 입력 |
| `txtRequestor` | UsrTextBox | 확인 필요 (Requestor) | 빈값 | 확인 필요 | — | 텍스트 입력 |
| `btnRequestor` | UsrButton | 확인 필요 (layoutRequestorBtn) | — | — | Click → `BtnRequestor_Click` | 사용자 팝업 버튼 |
| `btnSearch` | SimpleButton | 확인 필요 (layoutSearchBtn) | — | — | Click → `BtnSearch_Click` | 상세 조회 버튼 |

### 3-3. 그리드
| 컨트롤명 | 타입 | 시트 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|
| `spdMain` | FpSpread | `Shipment Plan(Electrode)` | TopChange → `SpdMain_TopChange` · CellDoubleClick → `SpdMain_CellDoubleClick` · Change → `SpdMain_Change` · ClipboardPasted → `spdMain_ClipboardPasted` | Wijmo FlexGrid(3단 헤더 + 동적 날짜 컬럼) |
| `spdMain_Sheet1` | SheetView | (Designer 기본 시트) | — | — |
| `spdDetail` | FpSpread | `Shipment Plan Detail` / `Stock Detail` / `Shipment Result` | SheetTabClick → `SpdDetail_SheetTabClick` · ActiveSheetChanged → `SpdDetail_ActiveSheetChanged` · CellClick → `SpdDetail_CellClick` · ComboSelChange → `SpdDetail_ComboSelChange` · CellDoubleClick → `SpdDetail_CellDoubleClick` · EditChange → `SpdDetail_EditChange` · ClipboardPasted → `SpdDetail_ClipboardPasted` | 탭 + Wijmo FlexGrid 3개 |
| `spdDetail_Sheet1` | SheetView | (Designer 기본 시트) | — | — |
| `spdSub` | FpSpread | `Shipment Plan Detail Excel` | — | 엑셀 양식 전용(화면 표시 여부 확인 필요) |
| `spdSub_Sheet1` | SheetView | (Designer 기본 시트) | — | — |

- 비컨트롤 이벤트: `dsdm`.Changed → `shtPlanDetail_Change` (InitEvent:818). `dsdm`이 무엇인지는 확인 필요입니다.
- 프레임워크 버튼: FindButton(조회), SaveButton(저장), EditButton(편집). override 진입점입니다.

---

## 4. 그리드 명세

> 출처: META = SCM_MST_SHEET_COLUMNS(SetSheetHeaderColumn). CODE = 코드가 Visible을 변경. DBLOOP = InitSpreadDateColumn.
> division별 표시: 14개 division 모두 같습니다(Fact Pack §10·§12). 각 표의 "division" 열은 생략하고 여기서 한 번만 적습니다.
> 편집 가능 여부: 메타의 CELL_CONTROL_OBJECT_TYPE_CODE 값은 Fact Pack에 없습니다. 저장 검증 대상 컬럼은 "편집(검증 대상)", 나머지는 "확인 필요"로 적었습니다.

### 4-1. `Shipment Plan(Electrode)` — spdMain (메타 19/0, Measure 11행, 최종 13 (?9))
| 컬럼 | 헤더 | 타입 | 출처 | 표시 | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Div | 확인 필요 | META | 기본 | 확인 필요 |
| ELECTRODE_POST_OPER_LT | Oper. L/T | 확인 필요 | META | 기본 | 확인 필요 |
| ELECTRODE_TYPE | Elec Type | 확인 필요 | META | 기본 | 확인 필요 |
| FROM_SITE | From Site | 확인 필요 | META | 기본 | 확인 필요 |
| ITEM_ID | Material | 확인 필요 | META | 기본 | 확인 필요 |
| MODEL_ID | Model | 확인 필요 | META | 기본 | 확인 필요 |
| NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| MEASURE_NAME | Measure | 확인 필요 | META | 기본 | 확인 필요 |
| PSI_NAME | PSI | 확인 필요 | META | 기본 | 확인 필요 |
| TEMPCOLUMN | TEMPCOLUMN | 확인 필요 | META | 기본 | 확인 필요 |
| TOT_BOH_QTY / _CELL / _PCM | BOH | 확인 필요 | META + CODE | 라디오에 따라 1개만 표시(§4-6) | 확인 필요 |
| JR_BOH_QTY / _CELL / _PCM | J/R | 확인 필요 | META + CODE | 위와 같음 | 확인 필요 |
| PC_BOH_QTY / _CELL / _PCM | Pancake | 확인 필요 | META + CODE | 위와 같음 | 확인 필요 |
| BACK_COLOR, CONFIRM_DAY, GUBUN_NUM, LAST_UPDATED_BY(Requestor), MEASURE, PLANT_ID, SCM_SITE_ID | — | — | META | 숨김 | — |
| (동적) `X_/Y_/Z_` × `D_/W_/M_` 날짜 컬럼 | COLUMN_LABEL_NAME (3단: LARGE/SMALL_CLASS_LABEL_NAME, 끝에 `SUM`) | Num(폭 100, 우측, 소수 3) / `B_` 포함 시 Text | DBLOOP (`SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN`) | §4-6 규칙 | 확인 필요 (spdMain_ClipboardPasted·SpdMain_Change가 있어 편집 가능 그리드로 보임) |
- 위 표의 컬럼은 1차 분석서(web_components §3-1)를 옮긴 것입니다. 메타 수(19)와 열거된 컬럼 수가 일치하는지는 확인 필요입니다.

### 4-2. `Shipment Plan Detail` — spdDetail 탭 0 (메타 41/0, 최종 44 (?9))
| 컬럼 | 헤더 | 출처 | 표시 | 편집 |
|---|---|---|---|---|
| DIVISION_ID | Div | META | 기본 | 확인 필요 |
| CONFIRM_ID | Confirm/Plan ID | META | 기본 | 확인 필요 (검증 키) |
| CHANGE_REQ_NO | Change Request No | META | 기본 | 확인 필요 |
| SHIPMENT_STATUS | Status | META | 기본 | 확인 필요 |
| MODEL_ID | Model | META | 기본 | 확인 필요 |
| MODEL_USER | Model PIC | META | 기본 | 확인 필요 |
| ITEM_ID | Material | META | 기본 | 확인 필요 |
| ITEM_ID_NICK_NAME | Nick Name | META | 기본 | 확인 필요 |
| CELL_TYPE | Cell Type | META | 기본 | 확인 필요 |
| ELECTRODE_POST_OPER | Post Oper. | META | 기본 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site | META | 기본 | 확인 필요 |
| TO_SITE_DESCRIPTION | To Site | META | 기본 | 확인 필요 |
| SOLDTO_DESCRIPTION | Sold To Party | META | 기본 | 확인 필요 |
| SHIPTO_DESCRIPTION | Ship To Party | META | 기본 | 확인 필요 |
| DOM_EXP | DOM/EXP. | META | 기본 | 편집(검증 대상 dom_exp) |
| INCOTERMS | Incoterms | META | 기본 | 확인 필요 |
| SHIPPING_PLAN_QTY | Shipping Plan Qty | META | 기본 | 확인 필요 |
| SHIPMENT_CONFIRM_QTY | Confirm Qty* | META | 기본 | 편집(검증 대상) |
| GAP | Gap | META | 기본 | 확인 필요 |
| CONFIRM_QTY_CELL | Confirm Qty (Cell) | META | 기본 | 확인 필요 |
| CONFIRM_QTY_JR | Confirm Qty (Jumboroll m) | META | 기본 | 확인 필요 |
| CONFIRM_QTY_PANCAKE | Confirm Qty (Pancake m) | META | 기본 | 확인 필요 |
| CONFIRM_QTY_ROLL_LENGTH | Confirm Qty (Cut) | META | 기본 | 확인 필요 |
| SHIPMENT_DATE | Shipment Date* | META | 기본 | 편집(검증 대상) |
| DAYOFWEEK_NAME | Day | META | 기본 | 확인 필요 |
| Expected_Shipping_Date | Expected Shipping Date | META | 기본 | 확인 필요 |
| ETD | ETD | META | 기본 | 확인 필요 |
| ETA | ETA | META | 기본 | 확인 필요 |
| LT_DAY | L/T(Day) | META | 기본 | 확인 필요 |
| TRANSPORT_MODE | Trans Mode* | META | 기본 | 편집(검증 대상) |
| FACTORY_ID | Building Desc.* | META + CODE(CellClick 시 Building 콤보 동적 생성 1718) | 기본 | 편집(검증 대상) |
| PACKAGE_TYPE | Package Type * | META | 기본 | 편집(검증 대상) |
| PACKAGE_QTY | Package Qty | META | 기본 | 확인 필요 |
| ERP_SO_NO | PO No | META | 기본 | 확인 필요 |
| REMARKS2 | Shipment No. | META | 기본 | 편집(검증 대상 remarks2) |
| REMARKS | Remarks | META | 기본 | 편집(검증 대상 remarks) |
| REMARKS3 | Customer Requirement | META | 기본 | 확인 필요 |
| REQUESTOR | Shipment Requestor | META | 기본 | 확인 필요 |
| (Updated By) | Updated By | META | 기본 | 확인 필요 |
| (Updated Date) | Updated Date | META | 기본 | 확인 필요 |
| ATTRIBUTE10 | ATTRIBUTE10 | META | 기본 | 확인 필요 |
| 숨김: BOD_ID, CHANGE_REASON_CODE, CHANGE_REASON_DETAIL, CHANGE_TYPE, EDIT_MAIN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, FROM_SITE, TO_SITE, MERGE_NUM, MODEL_ID_NICK_NAME, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID | — | META | 숨김 | — |
- 헤더 CheckBox 컬럼이 있습니다(SpdDetail_CellClick 1727–1759에서 전체 선택/해제). 해당 컬럼명은 확인 필요입니다.
- 최종 44 = 41 + BOH 3(CODE_ONLY_CHANGE 전개분). 이 시트에 실제로 적용되는지는 확인 필요입니다.

### 4-3. `Stock Detail` — spdDetail 탭 1 (메타 28/0, 최종 31 (?9), 헤더 3단)
| # | 헤더 | 컬럼 | 출처 | 표시 | 편집 |
|---:|---|---|---|---|---|
| 1 | Div | 확인 필요 | META | 기본 | 확인 필요 |
| 2 | SCM Site | FROM_SITE | META | 기본 | 확인 필요 |
| 3 | Plant | 확인 필요 | META | 기본 | 확인 필요 |
| 4 | Storage | 확인 필요 | META | 기본 | 확인 필요 |
| 5 | Model | 확인 필요 | META | 기본 | 확인 필요 |
| 6 | Material | 확인 필요 | META | 기본 | 확인 필요 |
| 7 | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| 8 | Version | 확인 필요 | META | 기본 | 확인 필요 |
| 9 | Operation | 확인 필요 | META | 기본 | 확인 필요 |
| 10 | Lot ID | 확인 필요 | META | 기본 | 확인 필요 |
| 11 | Pallet ID | 확인 필요 | META | 기본 | 확인 필요 |
| 12 | Lane | 확인 필요 | META | 기본 | 확인 필요 |
| 13 | Expiration Date | 확인 필요 | META | 기본 | 확인 필요 |
| 14 | Available Stock YN | 확인 필요 | META | 기본 | 확인 필요 |
| 15 | Change Status | 확인 필요 | META | 기본 | 확인 필요 |
| 16 | Package Type(oWMS) | 확인 필요 | META | 기본 | 확인 필요 |
| 17 | MES Hold YN | 확인 필요 | META | 기본 | 확인 필요 |
| 18 | QMS Hold YN | 확인 필요 | META | 기본 | 확인 필요 |
| 19 | iWMS Hold YN | 확인 필요 | META | 기본 | 확인 필요 |
| 20 | oWMS Hold YN | 확인 필요 | META | 기본 | 확인 필요 |
| 21–22 | Total: UOM / Pancake M | TOTAL_QTY_UOM / TOTAL_QTY_PCM | META | 기본 | 확인 필요 |
| 23–24 | GMES: UOM / Pancake M | 확인 필요 | META | 기본 | 확인 필요 |
| 25–26 | IWMS: UOM / Pancake M | 확인 필요 | META | 기본 | 확인 필요 |
| 27–28 | OWMS: UOM / Pancake M | 확인 필요 | META | 기본 | 확인 필요 |
- 상위 헤더 그룹(Total/GMES/IWMS/OWMS)이 메타 ATTRIBUTE로 구성되는지는 확인 필요입니다.

### 4-4. `Shipment Result` — spdDetail 탭 2 (메타 17/0, 최종 20 (?9))
| # | 헤더 | 컬럼 | 출처 | 표시 | 편집 |
|---:|---|---|---|---|---|
| 1 | Div | 확인 필요 | META | 기본 | 확인 필요 |
| 2 | Confirm/Plan ID | 확인 필요 | META | 기본 | 확인 필요 |
| 3 | SO No | ERP_SO_NO | META | 기본 | 확인 필요 |
| 4 | Status | TYPE | META | 기본 | 확인 필요 |
| 5 | Ship Type | 확인 필요 | META | 기본 | 확인 필요 |
| 6 | Model | 확인 필요 | META | 기본 | 확인 필요 |
| 7 | Material | 확인 필요 | META | 기본 | 확인 필요 |
| 8 | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| 9 | From Site | 확인 필요 | META | 기본 | 확인 필요 |
| 10 | To Site | 확인 필요 | META | 기본 | 확인 필요 |
| 11 | End Customer | 확인 필요 | META | 기본 | 확인 필요 |
| 12 | Shipment Date | YYYYMMDD | META | 기본 | 확인 필요 |
| 13 | ETD | ETD_DATE | META | 기본 | 확인 필요 |
| 14 | ETA | ETA_DATE | META | 기본 | 확인 필요 |
| 15 | Trans Mode | 확인 필요 | META | 기본 | 확인 필요 |
| 16 | Incoterms | 확인 필요 | META | 기본 | 확인 필요 |
| 17 | Shipment Qty | QTY | META | 기본 | 확인 필요 |

### 4-5. `Shipment Plan Detail Excel` — spdSub (메타 6/0, 최종 9 (?9))
| 컬럼 | 헤더 | 출처 | 표시 | 편집 |
|---|---|---|---|---|
| COMPANY_ID | Company* | META | 기본 | 엑셀 양식 입력 |
| DIVISION_ID | Div* | META | 기본 | 엑셀 양식 입력 |
| FROM_SITE | FromSite* | META | 기본 | 엑셀 양식 입력 |
| ITEM_ID | Material* | META | 기본 | 엑셀 양식 입력 |
| YYYYMMDD | yyyyMMdd* | META | 기본 | 엑셀 양식 입력 |
| QTY | Qty* | META | 기본 | 엑셀 양식 입력 |

### 4-6. 코드 표시 규칙 요약 (업무분석서 §4-3·§4-4와 같음)
- BOH: rdButton1 → 기본 3컬럼 / rdButton2 → _CELL 3컬럼 / rdButton3 → _PCM 3컬럼 (InitSpread 597–629, rdButton_Changed 4420–4452).
- 날짜: 접두어 X_(UOM)·Y_(Cell)·Z_(Pancake). Bucket DAILY: D 표시, W와 M은 chkSum을 따름. WEEKLY: D 숨김, W 표시, M은 chkSum을 따름. MONTHLY: D·W 숨김, M 표시. chkPastPeriod가 꺼져 있으면 과거 날짜(SUM 헤더 제외)를 숨김.
- 주말 글자색: SAT 파랑, SUN 빨강.

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 (업무분석서 §5와 같은 이름) | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 Load | `Form_Load` | InitControls → GetBucketType / CreateSpread → InitSpread → GetSpdTitle | `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | cboBucketType 채움, spdMain 헤더 생성 |
| A2 | FindButton (조회) | (프레임워크 override) FindButton | FindData_Main(GetCheckedListValue ×4: 4683–4686) → InitSpread | `SSP.SSP0023_GET_SHIPMENT_PLAN`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | spdMain `Shipment Plan(Electrode)` 바인딩 |
| A3 | EditButton | (프레임워크 override) EditButton | GetCheckedListValue(2138) → GetSSPUserCheck | `SSP.SSP0002_GET_USER_INFO_LIST` | 편집 가능 여부 판정(기준 확인 필요) |
| A4 | SaveButton | (프레임워크 override) SaveButton | SaveData_Detail(검증) → GetERPInterface 체인 → 재조회 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`, `SSP.SSP0023_GET_SHIPMENT_STATUS`, `SSP.SSP0023_GET_ERP_SO_NO_CNT`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`, `SSP.SSP0023_GET_SHIPMENT_PLAN`, `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | 저장 후 spdMain과 spdDetail 재조회 |
| A5 | (현행 미호출) | — (`GetErpIFCheckNew_`, `GetErpIFCheck` unreached) | 진입점 없음 | `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING` | 현행 화면에서 실행되지 않음 |
| A6 | formDown Click | `btnExcelFormDownload_Click` | FindData_Plan_Detail_DownLoad → InitSpread → ExportExcel | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | spdSub `Shipment Plan Detail Excel` 엑셀 내보내기 |
| A7 | btnExcelUpload Click | `btnExcelUpload_Click` | 업로드(처리 엔드포인트 확인 필요) → FindData_Main → FindData_Detail | `SSP.SSP0023_GET_SHIPMENT_PLAN`, `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | Main과 Detail 재조회 |
| A8 | btnSimulation Click | `BtnSimulation_Click` | Simulation → FindData_Main → FindData_Detail | `SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU`, `SSP.SSP0023_GET_SHIPMENT_PLAN`, `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | 시뮬레이션 저장 후 재조회 |
| A9 | btnMeasure Click | `BtnMeasure_Click` | Measure 선택 → InitSpread | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | spdMain 헤더 재생성 |
| A10 | btnSearch Click | `BtnSearch_Click` | FindData_Detail / FindData_Stock_Detail / FindData_ShipmentResult | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL`, `SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | spdDetail 3개 시트 바인딩 |
| A11 | btnItemId Click | `btnItemId_Click` | Material 팝업 | 없음(Fact Pack 기준) | txtItemId 반영(확인 필요) |
| A12 | btnItemId2 Click | `BtnMaterialId2_Click` | Material 팝업(상세) | 없음 | txtItemId2 반영(확인 필요) |
| A13 | btnRequestor Click | `BtnRequestor_Click` | Requestor 팝업 | 없음 | txtRequestor 반영(확인 필요) |
| A14 | clbCompany_ID 변경 | `clbCompanyID_SelectedIndexChanged` | cboPlanDate 배선 해제(5776) → 재구성 → 재배선(5780) → InitSpread | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | Plan-date와 헤더 재구성 |
| A15 | clbDivision_ID 변경 | `clbDivision_ID_SelectedIndexChanged` | DIVISION_ID 필터 | 없음 | 하위 목록 필터(대상 확인 필요) |
| A16 | cboPlanDate 변경 | `cboPlanDate_SelectedIndexChanged` | CODE/FROM_DATE/TO_DATE 읽기 → GetSpdTitle(5825) | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | 날짜 헤더 재구성 |
| A17 | cboBucketType 변경 | `cboBucketType_SelectedIndexChanged` | 날짜 컬럼 Visible(§4-6, SetSpreadColumn 호출 여부 확인 필요) | 없음 | D/W/M 컬럼 표시 전환 |
| A18 | rdButton1/2 CheckedChanged | `rdButton_Changed` | BOH 컬럼 Visible 전환 | 없음 | BOH 3세트 중 1세트 표시 |
| A19 | chkSum CheckedChanged | `chkSum_CheckedChanged` | 합계 컬럼 Visible | 없음 | W/M 컬럼 표시 전환 |
| A20 | chkPastPeriod CheckedChanged | `chkPastPeriod_CheckedChanged` | 과거 날짜 컬럼 Visible | 없음 | 과거 날짜 표시 전환 |
| A21 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | Detail 시트로 전환(1798–1799) → FindData_Detail | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | spdDetail `Shipment Plan Detail` |
| A22 | spdMain TopChange | `SpdMain_TopChange` | 처리 내용 확인 필요 | 없음 | 확인 필요 |
| A23 | spdMain Change | `SpdMain_Change` | 처리 내용 확인 필요 | 없음 | 확인 필요 |
| A24 | spdMain ClipboardPasted | `spdMain_ClipboardPasted` | 키(DIVISION_ID, PLANT_ID, MODEL_ID, FROM_SITE, ELECTRODE_TYPE, MEASURE, ITEM_ID) 기준 처리 | 없음 | 확인 필요 |
| A25 | spdDetail SheetTabClick | `SpdDetail_SheetTabClick` | SheetTabIndex 0/1/2 | 없음 | 시트 전환 |
| A26 | spdDetail ActiveSheetChanged | `SpdDetail_ActiveSheetChanged` | 처리 내용 확인 필요 | 없음 | 확인 필요 |
| A27 | spdDetail CellClick | `SpdDetail_CellClick` | IsLock 확인 → 헤더 CheckBox 전체 토글 / FACTORY_ID Building 콤보 생성 | 없음 | 셀 값·콤보 반영 |
| A28 | spdDetail ComboSelChange | `SpdDetail_ComboSelChange` | 처리 내용 확인 필요 | 없음 | 확인 필요 |
| A29 | spdDetail CellDoubleClick | `SpdDetail_CellDoubleClick` | 처리 내용 확인 필요 | 없음 | 확인 필요 |
| A30 | spdDetail EditChange | `SpdDetail_EditChange` | 처리 내용 확인 필요 | 없음 | 확인 필요 |
| A31 | spdDetail ClipboardPasted | `SpdDetail_ClipboardPasted` | CODE 참조 | 없음 | 확인 필요 |
| A32 | dsdm Changed | `shtPlanDetail_Change` | 처리 내용 확인 필요 | 없음 | 확인 필요 |

---

## 6. 검증·메시지
| 시점 | 검증 | 대상 | 메시지 |
|---|---|---|---|
| 조회 전 | 필수 조건 | Company*, Division*, Plan-date*, Period* | 원문 확인 필요 |
| 저장 전 | Validation_Check | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, factory_id, package_type, dom_exp (SO No 행은 앞 5개) | 원문 확인 필요 |
| 저장 전 | ChangeData_Check | confirm_id + 위 7컬럼 | 원문 확인 필요 |
| 저장 전 | ChangeNotSendERP_Check | confirm_id + 위 7컬럼 / SO No 행 5컬럼 | 원문 확인 필요 |
| 저장 중 | chkERPIFBlockYn | BLOCK_YN, PERIOD | 원문 확인 필요 |
| 저장 중 | ChkConfirmChangeTime | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` 결과 | 원문 확인 필요 |
| 저장 중 | GetShipmentStatusChk | `SSP.SSP0023_GET_SHIPMENT_STATUS` Tables[0..2].CONFIRM_ID | 원문 확인 필요 |
| 편집 | IsLock | 시트 잠금 시 CellClick 처리 안 함 | — |

---

## 7. 권한(C/R/U/D) 사실
| 구분 | 사실 |
|---|---|
| R | FindButton → `SSP.SSP0023_GET_SHIPMENT_PLAN`, btnSearch 상세 조회 |
| C/U | SaveButton → 확정·변경요청 저장, btnSimulation → `SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU` |
| D | Delete 버튼 override 없음. 삭제 성격의 SP(`SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`)는 저장 체인 안에서 호출됨 |
| 편집 권한 | EditButton → `SSP.SSP0002_GET_USER_INFO_LIST` |
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 13행(그룹별 C/R/U/D 값은 확인 필요) |
| 그룹 기준 | `UserInfoContext.Current.NowGroupID` (SetChangeControl:341–342, InitControls:462) |

---

## 8. To-Be 전환 메모 (Wijmo · Oracle)
1. **그리드**: spdMain → Wijmo FlexGrid. 3단 헤더(LARGE/SMALL_CLASS_LABEL_NAME + 날짜 + `SUM`)는 `columnHeaders` 다중 행과 셀 병합으로 구현합니다. 날짜 컬럼은 `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` 결과로 동적으로 생성합니다. X_/Y_/Z_ × D_/W_/M_ 표시 규칙(§4-6)은 FE에서 컬럼 visible 토글로 처리하고 재조회하지 않습니다.
2. **상세 탭**: spdDetail 3개 시트 → 탭 + FlexGrid 3개. FACTORY_ID Building 콤보는 셀 편집기(DataMap)로 구현합니다. 헤더 CheckBox 전체 토글을 구현합니다.
3. **컬럼 메타**: SetSheetHeaderColumn이 읽는 SCM_MST_SHEET_COLUMNS 메타를 그대로 씁니다. 5개 시트 모두 division 변형이 없습니다.
4. **엑셀**: spdSub(숨김 양식 그리드)는 TO-BE에서 FlexGrid 대신 서버 또는 FE 엑셀 양식 생성으로 대체할 수 있습니다. 결정 필요.
5. **Oracle 전환 대상 SP의 MSSQL 요소**(Fact Pack 참조 객체 기준): `STRING_SPLIT`(GET_SHIPMENT_PLAN, GET_SHIPMENT_STATUS, GET_SHIPMENT_PLAN_RESULT, GET_SHIPMENT_PLAN_DETAIL_EXCEL), `SP_EXECUTESQL`(SAVE_SHIPMENT_PLAN_SIMU), `#임시테이블`(GET_SHIPMENT_PLAN, SAVE_SHIPMENT_REQUEST_CONFIRM, SCM_SSP_DELETE_…_BY_CONFIRM), 동적 SQL(GET_SHIPMENT_PLAN, _DETAIL, _STOCK_DETAIL), `MERGE`(SAVE_SHIPMENT_PLAN_SIMU), CTE 추정 객체(GET_SHIPMENT_PLAN_RESULT). 각각 Oracle 대응(GTT·EXECUTE IMMEDIATE·REGEXP 분할 등)이 필요합니다. 구체 변환은 SP 원문 확인 후 정합니다.
6. **저장 트랜잭션**: AS-IS는 화면에서 엔드포인트를 최대 9종 순서대로 호출합니다. TO-BE에서 BE 서비스 하나로 묶을지는 분기 조건(업무분석서 §8)을 확인한 뒤 결정합니다.
7. **rdButton3 배선 없음**: TO-BE RadioGroup은 단일 change 이벤트로 3개 값을 모두 처리합니다. AS-IS의 실제 동작이 같은지는 확인 필요입니다.
8. **unreached 메서드**: `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING`은 이전 대상에서 제외할 후보입니다. 확정은 필요합니다.

---

## 9. 미확정
1. splitContainer1의 Orientation, SplitterDistance, Size, parent → 분할 방향과 비율.
2. 확인 필요로 표기한 라벨(btnItemId, txtModelId, textNickName, btnMeasure, usrButton1, 하단 상세 조건 11개).
3. 체크박스(chkSum, chkPastPeriod, chkMyModel 등)의 초기값.
4. Excel Upload 처리 엔드포인트.
5. `SpdMain_TopChange`, `SpdMain_Change`, `SpdDetail_ActiveSheetChanged`, `SpdDetail_ComboSelChange`, `SpdDetail_CellDoubleClick`, `SpdDetail_EditChange`, `shtPlanDetail_Change` 본문의 처리 내용.
6. 각 시트 컬럼의 셀 타입과 편집 가능 여부(CELL_CONTROL_OBJECT_TYPE_CODE).
7. spdSub가 화면에 표시되는지.
8. BOH CODE_ONLY_CHANGE가 `Shipment Plan(Electrode)` 외 시트에도 적용되는지.
9. 메뉴 위치.
