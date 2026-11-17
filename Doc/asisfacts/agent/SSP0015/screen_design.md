# SSP0015 Shipment PSI — 화면설계서 (As-Is → To-Be)

> 근거: Fact Pack(controls · props 원문은 1차 web_components에 옮겨진 범위만 사용), grid_rule, grid_code, grid_effective. 없는 값은 **확인 필요**로 적었다.
> §5의 엔드포인트명은 업무분석서 §5와 단위테스트 '근거' 열과 같은 이름이다. §3의 컨트롤명은 단위테스트 '절차' 열에서 그대로 쓴다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0015 |
| 화면명 | Shipment PSI (`SSP0015_ShipmentPSI`) |
| 팝업 | `SSP0015_ShipmentPSICommentsPopup` (WH In 코멘트 저장) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행. 내용은 Fact Pack에 없음) |
| Grid 구성 | HYBRID: META(SCM_MST_SHEET_COLUMNS 395행, SCM_MST_SHEET_MEASURE 32행) + DB루프(SCP0009 날짜 컬럼) + 코드 표시 변경 |
| 컨트롤 | 100개(controls.csv). 이 문서 §3에는 주요 컨트롤 46개를 실었다. |
| 조회조건 저장 메타 | TB_FX_SearchCondition 766행, TB_FX_Favorite 117행, SCM_MST_TITLESET_USER 12행 |

---

## 2. 화면 레이아웃

### 2-1. 분할 트리 (props.csv SplitContainer + controls.csv parent 체인)

```
SSP0015_ShipmentPSI (Form, 폭 1370)
├─ usrConditionPanel1        [UsrConditionPanel, Dock=Top, 1370×79, UsrPanelType=HidePanel]   ← 조회조건 영역
│   └─ usrLayoutControl2     [UsrLayoutControl, Dock=Top, 1370×73]
│        clbDivision · cboPlanDate · drpPeriod · cboBucketType · chkSum · btnMeasure ·
│        clbPlantSite · txtItemId · btnItemId · (숨김) chkMyModel · chkPartLeader · chkTeamLeader · chkDelegateeModel
├─ splitContainer1           [SplitContainer, Dock=Fill, Orientation=Horizontal(상/하), 1370×570, SplitterDistance=301]
│   ├─ Panel1 (상)  301 / 570 = 52.8 %
│   │   └─ spdMain           [FpSpread, Dock=Fill, 1370×301] ─ spdMain_Sheet1 (런타임 AddSheet: PSI 시트)
│   └─ Panel2 (하)  269 / 570 = 47.2 % (스플리터 폭 포함)
│       ├─ usrLayoutControl3 [UsrLayoutControl, Dock=Top, 1370×40]  = Panel2 내부 40/265 = 15.1 %
│       │    clbResultType · txtRequestor · btnRequestor · txtModel2 · btnItemID2 ·
│       │    drpPeriod2 · drpPeriod3 · txtLotID · btnSearch
│       └─ spdDetail         [FpSpread, Dock=Fill, 1370×225]          = Panel2 내부 225/265 = 84.9 %
│            └─ spdDetail_Sheet1 (런타임 AddSheet: Detail 시트)
└─ usrButton1                [UsrButton, 75×23, 부모 없음 — 배치 위치 확인 필요]
```
- 301 + 40 + 225 = 566이다. 570과의 차이 4는 스플리터 폭으로 보이지만, 스플리터 폭이 추출되지 않아 **확인 필요**하다.
- LayoutControl 안의 항목 배치 좌표가 추출되지 않았다. 조회조건 항목의 실제 좌→우 순서는 **확인 필요**하다(아래 와이어프레임은 Designer 선언 순서를 따랐다).

### 2-2. 텍스트 와이어프레임

```
┌───────────────────────────────────────────────────────────────────────────────────────┐
│ [툴바: 프레임워크 FindButton / EditButton / SaveButton — 위치·표시 버튼 확인 필요]          │
├──────────────────────── usrConditionPanel1 (H79, 접힘 패널) ─────────────────────────────┤
│ Division* [clbDivision ▼]  Plan-date* [cboPlanDate ▼]  Period* [drpPeriod ~ ]            │
│ Bucket [cboBucketType ▼] [☐ Sum chkSum] [btnMeasure]  From Site [clbPlantSite ☑▼]        │
│ Model [txtItemId     ][btnItemId]                                                         │
├═════════════ splitContainer1 (Horizontal) — Panel1 52.8 % ══════════════════════════════┤
│ spdMain : 탭 [Shipment PSI(Mobility & IT)] [Shipment PSI(Packer)]                        │
│   고정 컬럼(Div·From Site·Model·Nick Name·…·Measure) │ 3단 날짜 헤더(D_/W_/M_ + SUM)      │
├────────────────────────── splitter (Distance 301) ──────────────────────────────────────┤
│ usrLayoutControl3 (H40):                                                                  │
│ [clbResultType ☑▼] Requestor [txtRequestor][btnRequestor] [txtModel2][btnItemID2]         │
│ Shipment Date [drpPeriod2 ~ ] [drpPeriod3 ~ ] [txtLotID      ] [ Search btnSearch ]      │
├───────────────────────────── Panel2 47.2 % ─────────────────────────────────────────────┤
│ spdDetail : 탭 [Shipment Confirm Detail][Shipment Request Detail][W/H stock]              │
│            [W/H stock Detail][Hold stock][Hold stock Detail][Stock Detail]                │
│            [SCS Stock Detail][Stock Location Detail][WH In Plan Detail*권한][Shipment Result] │
└───────────────────────────────────────────────────────────────────────────────────────┘

[팝업 SSP0015_ShipmentPSICommentsPopup] (레이아웃 props 미수록 → 배치 확인 필요)
┌──────────────────────────────────────────┐
│ usrConditionPanel1 > usrLayoutControl1 / usrLayoutControl2 (팝업 내 parent 체인 확인 필요) │
│ txtPlan_Date txtDivision_ID txtFrom_Site txtItem_ID txtDate txtMeasure                  │
│ txtGap_Qty txtBefore_Qty txtProd_Qty txtWHin_Qty txtCurrent_Qty txtChange_Qty           │
│ usrLabel1   rtxComments (RichTextBox)                                                    │
│                                      [btnButtonList : 저장 등]                            │
└──────────────────────────────────────────┘
```

---

## 3. 컨트롤 명세 (46개)

- 라벨은 props.csv Text(또는 LayoutControlItem.Text) 원문이다. props.csv가 잘려서 원문이 없는 경우 **확인 필요**로 적었다.
- 필수 여부는 라벨의 `*` 표기만 근거로 삼았다.

| # | 컨트롤명 | 타입 | 라벨(원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|
| 1 | usrConditionPanel1 | UsrConditionPanel | – | Dock=Top, HidePanel | – | – | 조회조건 패널(접힘) |
| 2 | usrLayoutControl2 | UsrLayoutControl | – | Dock=Top 1370×73 | – | – | 조회조건 그리드 레이아웃 |
| 3 | clbDivision | UsrCombo | `Division*` (lblCombo1) | 확인 필요 (GetSSPInnerTable 바인딩 추정) | Y | `clbDivision_SelectedIndexChanged` | ComboBox |
| 4 | cboPlanDate | UsrCombo | `Plan-date*` (PlanDate) | CommonDataList[PlanDateShip] 결과. 기본 선택값은 확인 필요 | Y | `CboPlanDate_SelectedIndexChanged` | ComboBox |
| 5 | drpPeriod | UsrDateRangePicker | `Period*` (layoutControlItem6) | GetDayRange(SCM0001_GET_SCP_DAY_PERIOD) 결과 | Y | – | DateRange(InputDate×2) |
| 6 | cboBucketType | UsrCombo | `Bucket` (lblBucket) | DM0003 결과(DAILY/WEEKLY/MONTHLY). 기본값은 확인 필요 | N | `cboBucketType_SelectedIndexChanged` | ComboBox |
| 7 | chkSum | UsrCheckBox | `Sum` | 확인 필요 | N | `chkSum_CheckedChanged` | CheckBox |
| 8 | btnMeasure | UsrButton | 확인 필요 | – | – | `btnMeasure_Click` | Button(Measure 선택) |
| 9 | clbPlantSite | UsrCheckedList | `From Site` (layoutControlItem7) | 확인 필요 | N | – | MultiSelect |
| 10 | txtItemId | UsrMultiLineEditor | `Model` (lblItemId) | 빈값(확인 필요) | N | – | 멀티라인 입력 |
| 11 | btnItemId | UsrButton | 확인 필요 | – | – | `btnItemId_Click` | Button(Model 팝업) |
| 12 | chkMyModel | UsrCheckBox | `My Model` | Checked=true, Visible=false | – | – | 숨김(파라미터 사용 확인 필요) |
| 13 | chkPartLeader | UsrCheckBox | `Part Leader` | Visible=false | – | – | 숨김 |
| 14 | chkTeamLeader | UsrCheckBox | `Team Leader` | Visible=false | – | – | 숨김 |
| 15 | chkDelegateeModel | UsrCheckBox | `Delegatee Model` | Visible=false | – | – | 숨김 |
| 16 | usrButton1 | UsrButton | 확인 필요 | 부모 없음 | – | – | 확인 필요 |
| 17 | spdMain | FpSpread | – | Dock=Fill, Panel1 | – | `spdMain_TextTipFetch`, `SpdMain_CellDoubleClick`, `SpdMain_TopChange`, `SpdMain_ActiveSheetChanged`, `SpdMain_EditModeOn`, `SpdMain_CellClick` | Wijmo FlexGrid + 시트 탭 |
| 18 | spdMain_Sheet1 | SheetView | – | Designer 기본 시트 | – | – | (런타임 시트로 대체됨. 확인 필요) |
| 19 | spdDetail | FpSpread | – | Dock=Fill, Panel2 | – | `SpdDetail_TopChange`, `SpdDetail_CellClick`, `spdDetail_ComboSelChange`, `SpdDetail_SheetTabClick`, `SpdDetail_CellDoubleClick`, `SpdDetail_ActiveSheetChanged`, `SpdDetail_EditChange`, `SpdDetail_ClipboardPasted`, (dsdm) `shtDetail_Change` | Wijmo FlexGrid + 시트 탭 |
| 20 | spdDetail_Sheet1 | SheetView | – | Designer 기본 시트 | – | – | (위와 같음) |
| 21 | usrLayoutControl3 | UsrLayoutControl | – | Dock=Top 1370×40 | – | – | Detail 조회조건 레이아웃 |
| 22 | clbResultType | UsrCheckedList | 확인 필요 | 확인 필요 | – | – | MultiSelect |
| 23 | btnRequestor | UsrButton | 확인 필요 | – | – | `BtnRequestor_Click` | Button(사용자 팝업) |
| 24 | txtRequestor | UsrTextBox | LayoutItem 이름 `Requestor`(Text 확인 필요) | 확인 필요 | – | – | Input |
| 25 | btnSearch | SimpleButton | `Search` | – | – | `BtnSearch_Click` | Button |
| 26 | txtModel2 | UsrMultiLineEditor | 확인 필요 | 확인 필요 | – | – | 멀티라인 입력 |
| 27 | btnItemID2 | UsrButton | 확인 필요 | – | – | `BtnItemID2_Click` | Button(Model 팝업) |
| 28 | drpPeriod2 | UsrDateRangePicker | `Shipment Date` (layoutControlItem11) | 확인 필요 | – | – | DateRange |
| 29 | drpPeriod3 | UsrDateRangePicker | 확인 필요 | 확인 필요 | – | – | DateRange |
| 30 | txtLotID | UsrMultiLineEditor | 확인 필요 | 확인 필요 | – | – | 멀티라인 입력 |
| 31 | usrLayoutControl1 | UsrLayoutControl | – | (팝업) 확인 필요 | – | – | 팝업 레이아웃 |
| 32 | txtGap_Qty | UsrTextBox | 확인 필요 | 확인 필요 | – | `txtGap_Qty_TextChanged` | InputNumber |
| 33 | txtBefore_Qty | UsrTextBox | 확인 필요 | 확인 필요 | – | `txtBefore_Qty_TextChanged` | InputNumber |
| 34 | txtProd_Qty | UsrTextBox | 확인 필요 | 확인 필요 | – | `txtProd_Qty_TextChanged` | InputNumber |
| 35 | txtWHin_Qty | UsrTextBox | 확인 필요 | 확인 필요 | – | `txtWHin_Qty_TextChanged` | InputNumber |
| 36 | txtMeasure | UsrTextBox | 확인 필요 | 확인 필요 | – | – | Input(읽기전용 여부 확인 필요) |
| 37 | txtFrom_Site | UsrTextBox | 확인 필요 | 확인 필요 | – | – | Input(위와 같음) |
| 38 | txtDivision_ID | UsrTextBox | 확인 필요 | 확인 필요 | – | – | Input(위와 같음) |
| 39 | rtxComments | RichTextBox | 확인 필요 | 확인 필요 | – | – | TextArea |
| 40 | usrLabel1 | UsrLabel | 확인 필요 | – | – | – | Label |
| 41 | txtCurrent_Qty | UsrTextBox | 확인 필요 | 확인 필요 | – | `txtCurrent_Qty_TextChanged` | InputNumber |
| 42 | txtChange_Qty | UsrTextBox | 확인 필요 | 확인 필요 | – | `txtChange_Qty_TextChanged`, `txtChange_Qty_KeyPress` | InputNumber(입력 제한 내용 확인 필요) |
| 43 | txtDate | UsrTextBox | 확인 필요 | 확인 필요 | – | – | Input |
| 44 | txtItem_ID | UsrTextBox | 확인 필요 | 확인 필요 | – | – | Input |
| 45 | txtPlan_Date | UsrTextBox | 확인 필요 | 확인 필요 | – | – | Input |
| 46 | btnButtonList | UsrButtonList | – | – | – | `btnButtonList_UsrButtonList_Click_Detected` | 버튼 그룹(저장) |

- 폼 이벤트: 본 화면 `Form_Load`(.ctor:422)와 팝업 `Form_Load`(.ctor:207)가 있다.

---

## 4. 그리드 명세

- 범례
  - 출처: META = SCM_MST_SHEET_COLUMNS, CODE = 화면 코드
  - division별 표시: 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 모두 같으면 "공통"
  - 타입과 편집 가능: 메타 CELL_CONTROL_OBJECT_TYPE_CODE와 시트 잠금 값이 Fact Pack에 없어 `확인` 표기 = **확인 필요**. 라벨에 `*`가 붙은 컬럼은 편집·필수 후보로 따로 적었다.
  - 헤더 `—`: 원문 미수록

### 4-1. spdMain

#### (1) `Shipment PSI(Mobility & IT)` — META+코드연결, 표시 10 (14 div 공통), Measure 12/1, MergePolicy.Always

| 컬럼 | 헤더 | 타입 | 출처 | division별 표시 | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Div | 확인 | META | 공통 표시 | 확인 |
| FIGURE | Figure | 확인 | META | 공통 표시 | 확인 |
| FROM_SITE_NM | From Site | 확인 | META | 공통 표시 | 확인 |
| ITEM_ID | Model | 확인 | META | 공통 표시 | 확인 |
| LT_DAY | Aging L/T | 확인 | META | 공통 표시 | 확인 |
| MEASURE_NAME | Measure | 확인 | META | 공통 표시 | 확인 |
| NICK_NAME | Nick Name | 확인 | META | 공통 표시 | 확인 |
| PSI_NAME | PSI | 확인 | META | 공통 표시 | 확인 |
| TYPE | TYPE | 확인 | META | 공통 표시 | 확인 |
| YEILD | Yield(%) | 확인 | META | 공통 표시 | 확인 |
| FROM_SITE(Site), LT_UPDATE_YN, MEASURE, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SHIP_FROZEN | — | 확인 | META | 공통 숨김 | – |
| SHIP_TO, SHIPTO_DESCRIPTION | — | – | CODE(4991/4992) | →숨김(시트 연결이 맞는지 확인 필요) | – |
| 날짜 `D_*`/`W_*`/`M_*` | COLUMN_LABEL_NAME(3단 헤더 + SUM) | Num(폭 70) / `B_*`=Text(폭 0, 숨김) | CODE(DB루프 SCP0009) | Bucket/Sum 규칙(업무분석서 R5). SAT=Blue, SUN=Red | 확인 |

#### (2) `Shipment PSI(Packer)` — META+코드연결, 표시 8, Measure 6/0, MergePolicy.Always, SetSoNoColumnVisible(80/0)

| 컬럼 | 헤더 | 타입 | 출처 | division별 표시 | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Div | 확인 | META | 공통 표시 | 확인 |
| FIGURE | Figure | 확인 | META | 공통 표시 | 확인 |
| FROM_SITE_NM | From Site | 확인 | META | 공통 표시 | 확인 |
| ITEM_ID | Model | 확인 | META | 공통 표시 | 확인 |
| MEASURE | Measure | 확인 | META | 공통 표시 | 확인 |
| NICK_NAME | Nick Name | 확인 | META | 공통 표시 | 확인 |
| PSI_NAME | PSI | 확인 | META | 공통 표시 | 확인 |
| TYPE | TYPE | 확인 | META | 공통 표시 | 확인 |
| FROM_SITE, LT_DAY, LT_UPDATE_YN, MEASURE_NAME, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SHIP_FROZEN, YEILD | — | 확인 | META | 공통 숨김 | – |
| 날짜 컬럼 | (1)과 같음 | (1)과 같음 | CODE | (1)과 같음 | 확인 |
| SO No 계열(컬럼명 확인 필요) | — | – | CODE(9778~9793) | ichkbtn에 따라 Width 80/0 | – |

#### (3) `Shipment PSI(IT & Mobile)` — 메타 정의만 있음. 코드가 AddSheet하지 않는다(미사용 가능). 메타상 표시 10, Measure 12/1
- 컬럼 구성은 (1)과 같다. 헤더만 `Yeild(%)`로 철자가 다르다. TO-BE 포함 여부는 **확인 필요**하다.

### 4-2. spdDetail

#### (4) `Shipment Confirm Detail` — META+코드연결, 표시 40 (메타 규칙 집계 39/0와 1 차이 → 확인 필요)

| 컬럼 | 헤더 | 출처 | 표시 | 비고 |
|---|---|---|---|---|
| ATTRIBUTE10 | — | META | 공통 | |
| attribute3 | PLM status | META | 공통 | |
| attribute6 | OQC Result | META | 공통 | |
| CHANGE_REASON_CODE | Change Reason | META | 공통 | |
| CHANGE_REASON_DETAIL | Reason Detail | META | 공통 | |
| CHANGE_REQ_NO | Change Request No | META | 공통 | |
| CONFIRM_ID | Confirm/Plan ID | META | 공통 | |
| DIVISION_ID | Division | META | 공통 | |
| END_CUSTOMER | End Customer | META | 공통 | |
| ERP_SO_NO | SO No | META | 공통 | |
| ETA | ETA | META | 공통 | |
| ETD | ETD | META | 공통 | |
| Expected_Shipping_Date | Expected Shipping Date | META | 공통 | |
| FCST_TYPE | FCST Type | META | 공통 | |
| FROM_SITE_DESCRIPTION | From Site | META | 공통 | |
| INCOTERMS | Incoterms | META | 공통 | |
| ITEM_ID | Model | META | 공통 | |
| LT_DAY | L/T(Day) | META | 공통 | |
| MODEL_USER | Model PIC | META | 공통 | |
| MTK_OWNER | MKT Owner | META | 공통 | |
| NICK_NAME | Nick Name | META | 공통 | |
| REMARKS | Remarks | META | 공통 | Validation_Check 대상 |
| REMARKS2 | Building | META | 공통 | Validation_Check 대상 |
| REMARKS3 | Customer Requirement | META | 공통 | |
| REQUESTOR | Shipment Requestor | META | 공통 | |
| RTF3 | RTF | META | 공통 | |
| RTF4 | RTF ETD | META | 공통 | |
| RTF5 | RTF QTY | META | 공통 | |
| RTF6 | RTF Detail | META | 공통 | |
| SHIPMENT_CONFIRM_QTY | Shipment Qty | META | 공통 | Validation_Check 대상 |
| SHIPMENT_DATE | Shipment Date | META | 공통 | Validation_Check 대상 |
| SHIPMENT_STATUS | Status | META | 공통 | |
| SOLDTO_DESCRIPTION | Sold To Party | META | 공통 | |
| TEAM | Team | META | 공통 | |
| TO_SITE_DESCRIPTION | To Site | META | 공통 | |
| TO_SITE_SHIPTO_CODE | Ship to | META | 공통 | Validation_Check 대상. ShipToCodeByDivision 콤보 |
| TO_SITE_SOLDTO_CODE | Sold to | META | 공통 | |
| TRANSPORT_MODE | Trans Mode | META | 공통 | Validation_Check 대상. TransMode 콤보 |
| UPDATED_BY | Updated By | META | 공통 | |
| UPDATED_DATE | Updated Date | META | 공통 | |
| SHIPTO_DESCRIPTION | Ship To Party | META 기본 → CODE | →숨김 | |
| BEFORE_QTY, BOD_ID, CHANGE_TYPE, CHECK_NEED_YN, CHK(ALL), EDIT_MAIN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE(Shipment Date*), NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, PROJECT_CODE, PROJECT_NAME, TO_SITE | (괄호 안 원문) | META | 숨김 | CHK(ALL) = 헤더 CheckBox(SpdDetail_CellClick) |

- 코드 Visible=false: FindData_Detail 3218~3221, 3356~3359 / FindData_Detail_Packer_btnSearch 3491~3493 / FindData_Detail_btnSearch 3758~3761. 대상 컬럼은 **확인 필요**하다.
- 타입과 편집 가능 여부는 전 컬럼 **확인 필요**하다.
- `SSP0015_TEMP2` 프로그램에도 같은 이름의 시트(31/0)가 있다. 용도는 **확인 필요**하다.

#### (5) `Shipment Request Detail` — META+코드연결, 표시 34

| 컬럼(헤더) | 출처 | 표시 | `*` 표기(편집·필수 후보) |
|---|---|---|---|
| ATTRIBUTE3(RTF), ATTRIBUTE4(RTF ETD), ATTRIBUTE5(RTF QTY), ATTRIBUTE6(RTF Detail), BOD_ID, CHANGE_REQUEST_NO, EDIT_FLAG, END_CUSTOMER, ETA_DATE(ETA), ETD_DATE(ETD), EXPECTED_SHIP_DATE, LAST_UPDATED_BY(Requestor), LAST_UPDATED_DATE(Request Date), LT_TOTAL(L/T(Day)), MKT_OWMER(MKT Owner), MODEL_PIC, NICK_NAME, ORDER_TYPE_DETAIL, REMARK, REQUEST_ID(Confrim/Plan ID), SHIPTO_NAME, SITE_DESCRIPTION(Plant Site), SOLDTO_CODE(Sold to), STATUS | META | 공통 | – |
| DIVISION_ID(Div*), FCST_TYPE(FCST Type*), FROM_SITE(From Site*), INCOTERMS(Incoterms*), MODEL_ID(Model*), QTY(Qty*), SHIPTO_CODE(Ship to*), TO_SITE(To Site*), TR_MODE(Trans Mode*), YYYYMMDD(Shipment Date*) | META | 공통 | `*` (편집 여부 확인 필요) |
| SHIP_TO, SHIPTO_DESCRIPTION | CODE | →숨김 | – |

#### (6) `W/H stock` — META+코드연결, 메타 19/0 (14 div 공통)
- 컬럼 상세는 grid_effective가 잘려 **확인 필요**하다. 코드 →숨김: SHIP_TO, SHIPTO_DESCRIPTION(연결 확인 필요).

#### (7) `W/H stock Detail` — META+코드연결, 메타 25/0
- 컬럼 상세와 조회 엔드포인트 모두 **확인 필요**하다.

#### (8) `Hold stock` — META+코드연결, 표시 10, 저장 `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA`

| 컬럼 | 헤더 | 출처 | 표시 | `*` |
|---|---|---|---|---|
| DIVISION_ID | Div | META | 공통 | |
| FROM_SITE_NM | From Site | META | 공통 | |
| HOLD_QTY | Amend Qty* | META | 공통 | `*` |
| HOLD_YYYYMMDD | Start Date | META | 공통 | |
| ITEM_ID | Model | META | 공통 | |
| LAST_UPDATE_DATE | — | META | 공통 | |
| LAST_UPDATED_BY | — | META | 공통 | |
| NICK_NAME | — | META | 공통 | |
| RELEASE_YYYYMMDD | End Date* | META | 공통 | `*` |
| REMARKS | — | META | 공통 | |
| FROM_SITE, HOLD_ID | — | META | 숨김 | |
| SHIP_TO, SHIPTO_DESCRIPTION | — | CODE | →숨김 | |

#### (9) `Hold stock Detail` — META+코드연결, 표시 10
- 컬럼은 (8)과 같다. 헤더에서 `Amend Qty`와 `End Date`에 `*`가 없다는 점만 다르다.

#### (10) `Stock Detail` — META+코드연결(코드상 shtMesStock), 메타 26/0, 저장 `SSP.SSP0015_SAVE_MES_STOCK`

| 컬럼 | 헤더 | 출처 | 표시 |
|---|---|---|---|
| AVAILABLE_YN, DIVISION_ID, FCS_HOLD_YN, FCS_SPECIAL_QTY, ITEM_ID, JUDG_VLD_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY, LONGTERM_HOLD_YN, LOT_ID, LOT_QTY_FCS, LOT_QTY_MES, LOT_QTY_MES_NG, LOT_QTY_TOT, LOT_TYPE, MES_CHANGE_STATUS, MES_HOLD_RELEASE, MES_HOLD_YN, NICK_NAME, OWMS_STOCK_QTY, QMS_HOLD_RELEASE, QMS_HOLD_YN, REMARKS | — | META | 공통 |
| FROM_SITE | Site | META | 공통 |
| USER_MOD_RELEASE_DATE | User Modified Release Date* | META | 공통 (`*`) |
| YYYYMMDD_LOT_ID_APPLIED_LT | D Day(Expected) | META | 공통 |
| SHIP_TO, SHIPTO_DESCRIPTION | — | CODE | →숨김 |

#### (11) `MES Stock Detail` — 메타 정의만 있음, 코드 미참조(미사용 가능), 메타 24
- 컬럼은 (10)에서 LONGTERM_HOLD_YN과 LOT_QTY_MES_NG를 뺀 구성이다. TO-BE 포함 여부는 **확인 필요**하다.

#### (12) `SCS Stock Detail` — META+코드연결, 표시 9

| 컬럼 | 헤더 | 출처 | 표시 |
|---|---|---|---|
| CUTOFF_DATE, DIVISION_ID, HOLD_YN, PLANT_ID, PLANT_NAME, PROD_DATE, QTY | — | META | 공통 |
| LAST_UPDATE_DATE | Update Date | META | 공통 |
| MODEL_ID | Model | META | 공통 |
| SHIP_TO, SHIPTO_DESCRIPTION | — | CODE | →숨김 |

#### (13) `Stock Location Detail` — META+코드연결, 메타 20/0
- 확인된 표시 컬럼: AVAILABLE_DATE, AVAILABLE_QTY, COMPANY_ID, CUTOFF_DATE, DEFECT_QTY(Deffect Qty), DIVISION_ID. 나머지 14개는 **확인 필요**하다.

#### (14) `WH In Plan Detail` — META+코드연결, 메타 11/0, `drPgmAuthId != null`일 때만 생성
- 컬럼 상세는 **확인 필요**하다.

#### (15) `Shipment Result` — META+코드연결, 표시 17 (메타 19 − 코드 숨김 2)

| 컬럼 | 헤더 | 출처 | 표시 |
|---|---|---|---|
| CONFIRM_ID, DIVISION_ID, END_CUSTOMER, ETA_DATE, ETD_DATE, FROM_SITE, INCOTERMS, ITEM_ID, NICK_NAME, SHIP_TYPE, TEAM, TO_SITE, TRANSPORT_MODE | — | META | 공통 |
| ERP_SO_NO | SO No | META | 공통 |
| QTY | Shipment Qty | META | 공통 |
| TYPE | Status | META | 공통 |
| YYYYMMDD | Shipment Date | META | 공통 |
| SHIP_TO | Ship to | META 기본 → CODE(4991) | →숨김 |
| SHIPTO_DESCRIPTION | Ship to Name | META 기본 → CODE(4992) | →숨김 |

### 4-3. 시트 연결 (코드 상수 → 조회)
| 시트 | Spread | 코드 상수 | 조회 엔드포인트 |
|---|---|---|---|
| Shipment PSI(Mobility & IT) | spdMain | SpdSheet.shtMain | `SSP.SSP0015_GET_SHIPMENT_PSI` |
| Shipment PSI(Packer) | spdMain | SpdSheet.shtPacker | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` / `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST` |
| Shipment Confirm Detail | spdDetail | shtDetail | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` / `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` |
| Shipment Request Detail | spdDetail | shtRequestDetail | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` |
| W/H stock | spdDetail | shtWHstock | `SSP.SSP0015_GET_WH_STOCK` |
| W/H stock Detail | spdDetail | shtWHstockDetail | 확인 필요 |
| Hold stock / Hold stock Detail | spdDetail | shtBolckStock / shtBolckStockDetail | `SSP.SSP0015_GET_BLOCK_STOCK` |
| Stock Detail | spdDetail | shtMesStock | `SSP.SSP0015_GET_MES_STOCK` |
| SCS Stock Detail | spdDetail | shtScsStock | `SSP.SSP0015_GET_SCS_STOCK` |
| Stock Location Detail | spdDetail | shtStockLocationDetail | `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` (+ `SSP.SSP0002_GET_NERP_CODE`) |
| WH In Plan Detail | spdDetail | shtWHinPlanDetail | `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS` |
| Shipment Result | spdDetail | shtShipmentResult | `SSP.SSP0015_GET_SHIPMENT_RESULT` / `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER` |

- 초기 활성 시트: CreateSpread의 ChangeSheet 호출 순서(740 → 741 → 746)로 보면 Main은 Mobility & IT, Detail은 Shipment Confirm Detail로 추정된다. 실행으로 **확인 필요**하다.

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 로드 | `Form_Load` | InitControls, GetBucketType, GetDayRange, SetChangedControl, CreateSpread, InitSpread | `biz:CommonData.CommonDataList`[PlanDateShip], `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | cboPlanDate, cboBucketType, drpPeriod, spdMain·spdDetail 시트 |
| A2 | Division 변경 | `clbDivision_SelectedIndexChanged` | SetChangedControl > GetDayRange | `biz:CommonData.CommonDataList`[PlanDateShip], `SCP.SCM0001_GET_SCP_DAY_PERIOD` | cboPlanDate, drpPeriod |
| A3 | Plan-date 변경 | `CboPlanDate_SelectedIndexChanged` | GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | drpPeriod |
| A4 | Bucket 변경 | `cboBucketType_SelectedIndexChanged` | 엔드포인트 없음. SetSpreadColumn 호출 여부는 확인 필요 | – | spdMain D_/W_/M_ 표시 |
| A5 | Sum 체크 | `chkSum_CheckedChanged` | 위와 같음 | – | spdMain M_/W_ 표시 |
| A6 | Measure 버튼 | `btnMeasure_Click` | InitSpread > GetSpdTitle | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain 헤더 재구성 |
| A7 | Model 버튼(상단) | `btnItemId_Click` | 엔드포인트 미추출(팝업 추정, 확인 필요) | – | txtItemId(확인 필요) |
| A8 | Model 버튼(하단) | `BtnItemID2_Click` | 위와 같음 | – | txtModel2(확인 필요) |
| A9 | Requestor 버튼 | `BtnRequestor_Click` | 위와 같음 | – | txtRequestor(확인 필요) |
| A10 | Main 시트 탭 변경 | `SpdMain_ActiveSheetChanged` | LookupCommon 조회(1400/1452), SetChangedControl, InitSpread | `biz:CommonData.CommonDataList`[LookupCommon, PlanDateShip], `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 조회조건, spdMain 헤더 |
| A11 | 조회 | FindButton(프레임워크) | FindData_Main / FindData_Main_Packer / FindData_Main_Packer_Past (분기 확인 필요) > Re_Design > GetNERPCode, InitSpread | `SSP.SSP0015_GET_SHIPMENT_PSI`, `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER`, `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST`, `SSP.SSP0002_GET_NERP_CODE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain |
| A12 | Main 더블클릭 | `SpdMain_CellDoubleClick` | DIVISION_ID·SITE·ITEM_ID·YYYYMMDD로 Detail 조회 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL`, `SSP.SSP0015_GET_WH_STOCK`, `SSP.SSP0015_GET_MES_STOCK`, `SSP.SSP0015_GET_BLOCK_STOCK`, `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0002_GET_NERP_CODE`, `SSP.SSP0015_GET_SCS_STOCK`, `SSP.SSP0015_GET_SHIPMENT_PSI`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdDetail 활성 시트 |
| A13 | Main 셀 클릭 | `SpdMain_CellClick` | 엔드포인트 미추출 | – | 확인 필요 |
| A14 | Main 편집 시작 | `SpdMain_EditModeOn` | 엔드포인트 미추출 | – | 확인 필요 |
| A15 | Main 툴팁 | `spdMain_TextTipFetch` | 엔드포인트 미추출 | – | 셀 툴팁(내용 확인 필요) |
| A16 | Main 스크롤 | `SpdMain_TopChange` | 엔드포인트 미추출(spdDetail과 스크롤 동기화로 추정, 확인 필요) | – | 확인 필요 |
| A17 | Detail 스크롤 | `SpdDetail_TopChange` | 위와 같음 | – | 확인 필요 |
| A18 | Detail Search | `BtnSearch_Click` | 활성 Detail 시트별 FindData_*_btnSearch | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER`, `SSP.SSP0015_GET_WH_STOCK`, `SSP.SSP0015_GET_BLOCK_STOCK`, `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0002_GET_NERP_CODE`, `SSP.SSP0015_GET_SCS_STOCK`, `SSP.SSP0015_GET_MES_STOCK`, `SSP.SSP0026_GET_REQUEST_DETAIL_PACK`, `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS`, `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER`, `SSP.SSP0015_GET_SHIPMENT_RESULT`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdDetail 활성 시트. Shipment Result에서는 SHIP_TO·SHIPTO_DESCRIPTION 숨김 |
| A19 | Detail 셀 클릭 | `SpdDetail_CellClick` | Trans Mode·Ship to 콤보 구성, 헤더 CheckBox 전체 토글(IsLock 분기) | `biz:CommonData.CommonDataList`[TransMode, ShipToCodeByDivision] | spdDetail 셀 콤보, CHK |
| A20 | Detail 콤보 선택 | `spdDetail_ComboSelChange` | 엔드포인트 미추출 | – | 확인 필요 |
| A21 | Detail 탭 클릭 | `SpdDetail_SheetTabClick` | 엔드포인트 미추출 | – | 확인 필요 |
| A22 | Detail 탭 전환 | `SpdDetail_ActiveSheetChanged` | 엔드포인트 미추출 | – | 하단 조회조건 표시 전환 추정(확인 필요) |
| A23 | Detail 더블클릭 | `SpdDetail_CellDoubleClick` | 엔드포인트 미추출 | – | 확인 필요 |
| A24 | Detail 편집 | `SpdDetail_EditChange` | 엔드포인트 미추출 | – | 확인 필요 |
| A25 | Detail 붙여넣기 | `SpdDetail_ClipboardPasted` | TransMode 코드(CODE) 대조 | `biz:CommonData.CommonDataList`[TransMode] | 붙여넣은 Trans Mode 값 |
| A26 | Detail 데이터 변경 | `shtDetail_Change` (dsdm.Changed) | 엔드포인트 미추출 | – | 확인 필요 |
| A27 | 편집 | EditButton(프레임워크) | PlanDateShip 재조회(1753/1757), GetSSPUserCheck | `biz:CommonData.CommonDataList`[PlanDateShip], `SSP.SSP0002_GET_USER_INFO_LIST` | 편집 가능 상태(조건 확인 필요) |
| A28 | 저장(Main) | SaveButton > SaveData_Main | – | `SSP.SSP0015_SAVE_SHIPMENT_PSI` | DB 반영 |
| A29 | 저장(Detail) | SaveButton > SaveData_Detail | Validation_Check(연결 확인 필요) → 저장 → 재조회 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40`, `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA`, `SSP.SSP0015_SAVE_MES_STOCK` → `SSP.SSP0015_GET_SHIPMENT_PSI`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL`, `SSP.SSP0015_GET_MES_STOCK`, `SSP.SSP0002_GET_NERP_CODE` | spdMain·spdDetail 재조회 |
| A30 | 저장(Detail Packer) | SaveButton > SaveData_Detail_Packer | chkSaveYN → EngProcessingChk → 확정 저장 → GetERPInterface → 재조회 (순서 확인 필요) | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK`, `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER`, `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`, `SSP.SSP0015_GET_ERP_SO_NO_CNT`, `SSP.SSP0015_GET_SHIPMENT_STATUS`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | Shipment Confirm Detail 재조회 |
| A31 | (팝업) 저장 | `btnButtonList_UsrButtonList_Click_Detected` | SaveData | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` | DB 반영(팝업 닫힘·재조회 여부 확인 필요) |
| A32 | (팝업) 로드 | `Form_Load`(팝업 .ctor:207) | 엔드포인트 미추출 | – | 팝업 텍스트박스 초기값(확인 필요) |
| A33 | (팝업) 수량 입력 | `txtGap_Qty_TextChanged`, `txtBefore_Qty_TextChanged`, `txtProd_Qty_TextChanged`, `txtWHin_Qty_TextChanged`, `txtCurrent_Qty_TextChanged`, `txtChange_Qty_TextChanged` | 엔드포인트 미추출 | – | 계산 결과(확인 필요) |
| A34 | (팝업) 키 입력 | `txtChange_Qty_KeyPress` | 입력 문자 제한(내용 확인 필요) | – | txtChange_Qty |
| A35 | (미연결) | GetErpIFCheck, GetErpIFCheckNew_ | unreached | `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING` | 화면 조작으로 호출되지 않음(확인 필요) |
| A36 | (미연결) | SCM_SYS_LOG_BATCH | unreached | `SCP.PR_SCM_SYS_LOG_BATCH` | 위와 같음 |
| A37 | (미연결) | GetDivision | unreached | `SCM.SCM0001_GET_DIVISION` | 위와 같음 |
| A38 | (미연결) | SetChangedPeriod, NewNonSoNo | unreached | `biz:CommonData.CommonDataList`[PERIOD_{p:value}, PERIOD2_{p:value}], `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` | 위와 같음 |

---

## 6. 검증·메시지

| 항목 | 사실 | 메시지 문구 |
|---|---|---|
| 필수 조회조건 | Division*, Plan-date*, Period* (라벨 `*`) | 확인 필요 |
| 저장 전 Validation_Check | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE를 읽는다 | 확인 필요 |
| SCS Confirm ID 점검 | chkSaveYN이 Tables[0]·[1].CNT를 읽는다 | 확인 필요 |
| 계획 진행 점검 | EngProcessingChk(`SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`) | 확인 필요 |
| 변경 시각 점검 | ChkConfirmChangeTime(`SCM_SSP_CHECK_CONFIRM_CHANGETIME`) | 확인 필요 |
| SO No 건수, 출하 상태 | GetErpSoNoCnt CNT, GetShipmentStatusChk CONFIRM_ID | 확인 필요 |
| ERP I/F Block | chkERPIFBlockYn: BLOCK_YN, PERIOD (원천 미추출) | 확인 필요 |
| Detail 그리드 필수 후보 | 라벨 `*`: Shipment Request Detail 10개 컬럼, Hold stock의 Amend Qty*·End Date*, Stock Detail의 User Modified Release Date*, Confirm Detail의 NEW_SHIPMENT_DATE(Shipment Date*, 숨김) | 확인 필요 |
| 팝업 입력 제한 | txtChange_Qty_KeyPress | 확인 필요 |

---

## 7. 권한 (C/R/U/D 사실)

| 구분 | 사실 |
|---|---|
| 메뉴 권한 | TB_FX_GroupMenuAuth 14행. C/R/U/D 값은 **확인 필요** |
| R (조회) | FindButton, BtnSearch_Click. 다수 SP가 SSP_MST_MODEL_USER·SSP_MST_DELEGATE를 읽는다(담당 범위 필터 여부 확인 필요). |
| U (편집 진입) | EditButton → GetSSPUserCheck(`SSP.SSP0002_GET_USER_INFO_LIST`) |
| C/U (저장) | SaveButton 3갈래. 팝업 btnButtonList 저장 |
| D (삭제) | 화면 삭제 버튼은 Fact Pack에 없다. 삭제는 저장 하위 SP 내부(DELETE SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_PLAN_40)에서만 일어난다. |
| 시트 단위 | WH In Plan Detail은 drPgmAuthId가 있을 때만 생성. Detail 시트 IsLock에 따라 헤더 CheckBox 동작이 다르다. |
| 그룹 필터 | NowGroupID, Filter GROUP_ID·USER_ID |

---

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 영역 | As-Is | To-Be 메모 |
|---|---|---|
| 레이아웃 | SplitContainer Horizontal, SplitterDistance=301 / 570 | 상하 분할 52.8 : 47.2(스플리터 포함), 하단 내부 조회조건 40 : 그리드 225. 메뉴·버튼 배치는 reference 화면 패턴을 따른다. |
| 시트 탭 | FpSpread 다중 시트(Main 2 + Detail 11) | FlexGrid + 탭. 시트별 컬럼은 SCM_MST_SHEET_COLUMNS 메타를 그대로 쓴다. |
| 3단 날짜 헤더 | ColumnHeaderSpan, SUM 헤더, SAT Blue / SUN Red | FlexGrid columnHeaders 다행과 allowMerging. 주말 색은 formatItem으로 처리 |
| 셀 병합 | MergePolicy.Always (PSI 2개 시트) | allowMerging(Cells)과 컬럼별 allowMerging |
| Bucket/Sum | Tag 접두어 D_/W_/M_ 표시 토글 | 컬럼 visible 바인딩. DAILY일 때 W_ 최종값은 확인 후 결정 |
| 헤더 CheckBox | CHK(ALL) + IsLock 분기 | 헤더 체크 셀. 잠금 시트 동작 차이를 보존 |
| 셀 콤보 | TransMode, ShipToCodeByDivision | DataMap(공통코드 API) |
| 팝업 | CommentsPopup | Modal. 수량 계산·KeyPress 제한 확인 후 이식 |
| SP 변환 | MSSQL `#TMP_*`, `#TBLDYNAMIC*`, STRING_SPLIT, MERGE, 동적 SQL(8개 SP), CTE, FN_* 함수, EXEC 체인 | Oracle 19c: GTT 또는 WITH 절, STRING_SPLIT 대체(FN_SCM_SPLIT 계열 등), MERGE 문법 차이, 동적 SQL → EXECUTE IMMEDIATE 또는 정적화. 변환 전 원문 확인 필요 |
| 로그 | PR_SCM_SYS_LOG_BATCH(_CALL_TRAN), PR_SCP_SYS_LOG_BATCH | 로그 프로시저 Oracle 대응본 필요 |
| I/F | XIF_ERP_*, XIF_SCS_* INSERT | I/F 테이블 존재 여부와 시노님 확인 필요 |
| 미연결 코드 | unreached 6개 메서드 | 이관 범위 결정 전까지 구현 보류 |

---

## 9. 미확정

1. 조회조건 항목의 실제 배치 순서(LayoutControl 좌표 미추출)와 스플리터 폭.
2. 라벨 미추출 컨트롤: btnMeasure, btnItemId, clbResultType, txtRequestor(Text), btnRequestor, txtModel2, btnItemID2, drpPeriod3, txtLotID, usrButton1, 팝업 컨트롤 전부.
3. 팝업 레이아웃과 parent 체인(usrLayoutControl1 포함).
4. 컬럼 상세가 잘린 시트: W/H stock, W/H stock Detail, Stock Location Detail(14개), WH In Plan Detail.
5. 전 시트의 셀 타입과 편집 가능 여부(메타 CELL_CONTROL_OBJECT_TYPE_CODE와 잠금 값 미수록).
6. 엔드포인트가 추출되지 않은 핸들러 16종의 처리 내용(§5 A4, A5, A7~A9, A13~A17, A20~A24, A26, A32~A34).
7. 메타에만 있는 시트(Shipment PSI(IT & Mobile), MES Stock Detail)와 SSP0015_TEMP2.
8. FindButton과 SaveButton의 분기 조건.
9. 초기 활성 시트.
