# SSP0015 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → React/Wijmo 매핑

라벨은 props.csv의 원문이다. LayoutControlItem.Text 또는 컨트롤 Text를 그대로 옮겼다. props.csv가 일부 잘린 탓에 라벨을 못 찾은 항목은 **확인 필요**로 적었다.

### 1-1. 조회조건 영역 (usrConditionPanel1 > usrLayoutControl2)

| 컨트롤 | AS-IS 유형 | 라벨(원문) | Size | TO-BE 후보 |
|---|---|---|---|---|
| clbDivision | UsrCombo (이름은 clb지만 유형은 Combo) | `Division*` (lblCombo1) | 162×20 | ComboBox (필수) |
| cboPlanDate | UsrCombo | `Plan-date*` (PlanDate) | 150×20 | ComboBox (필수) |
| drpPeriod | UsrDateRangePicker | `Period*` (layoutControlItem6) | 205×20 | DateRange (InputDate 2개) |
| cboBucketType | UsrCombo | `Bucket` (lblBucket) | 137×20 | ComboBox |
| chkSum | UsrCheckBox | `Sum` | 84×25 | CheckBox |
| btnMeasure | UsrButton | 확인 필요 (Text 미추출) | 39×25 | Button (측정 항목 선택) |
| clbPlantSite | UsrCheckedList | `From Site` (layoutControlItem7) | 189×21 | MultiSelect |
| txtItemId | UsrMultiLineEditor | `Model` (lblItemId) | 100×21 | 멀티라인 입력 |
| btnItemId | UsrButton | 확인 필요 | 39×24 | Button (Model 팝업) |
| chkMyModel | UsrCheckBox | `My Model` (Checked=true, Visible=false) | 110×23 | 숨김 |
| chkPartLeader | UsrCheckBox | `Part Leader` (Visible=false) | 110×23 | 숨김 |
| chkTeamLeader | UsrCheckBox | `Team Leader` (Visible=false) | 110×23 | 숨김 |
| chkDelegateeModel | UsrCheckBox | `Delegatee Model` (Visible=false) | 136×23 | 숨김 |
| usrButton1 | UsrButton | 확인 필요 (부모 없음) | 75×23 | 확인 필요 |

### 1-2. 상세 영역 조회조건 (splitContainer1.Panel2 > usrLayoutControl3)

| 컨트롤 | AS-IS 유형 | 라벨(원문) | Size | TO-BE 후보 |
|---|---|---|---|---|
| clbResultType | UsrCheckedList | 확인 필요 | 104×21 | MultiSelect |
| txtRequestor | UsrTextBox | LayoutControlItem 이름은 `Requestor`, Text는 확인 필요 | 20×20 | Input |
| btnRequestor | UsrButton | 확인 필요 | 39×24 | Button (사용자 팝업) |
| txtModel2 | UsrMultiLineEditor | 확인 필요 | 264×21 | 멀티라인 입력 |
| btnItemID2 | UsrButton | 확인 필요 | 39×25 | Button (Model 팝업) |
| drpPeriod2 | UsrDateRangePicker | `Shipment Date` (layoutControlItem11) | 197×20 | DateRange |
| drpPeriod3 | UsrDateRangePicker | 확인 필요 | 197×20 | DateRange |
| txtLotID | UsrMultiLineEditor | 확인 필요 | 207×21 | 멀티라인 입력 |
| btnSearch | DevExpress SimpleButton | `Search` | 47×25 | Button (상세 시트 조회) |

### 1-3. Grid

| 컨트롤 | AS-IS | TO-BE 후보 |
|---|---|---|
| spdMain | FpSpread (Panel1, Dock Fill, 1370×301) | Wijmo FlexGrid + 시트 탭 (PSI 시트 2개, 3단 헤더, 셀 병합) |
| spdDetail | FpSpread (Panel2, Dock Fill, 1370×225) | Wijmo FlexGrid + 시트 탭 (Detail 시트 11개) |

### 1-4. 팝업 SSP0015_ShipmentPSICommentsPopup

| 컨트롤 | AS-IS 유형 | 라벨 | TO-BE 후보 |
|---|---|---|---|
| txtGap_Qty, txtBefore_Qty, txtProd_Qty, txtWHin_Qty, txtCurrent_Qty, txtChange_Qty | UsrTextBox | 확인 필요 (props.csv 잘림) | Input (수량, txtChange_Qty는 KeyPress로 입력 제한 — 내용 확인 필요) |
| txtMeasure, txtFrom_Site, txtDivision_ID, txtDate, txtItem_ID, txtPlan_Date | UsrTextBox | 확인 필요 | 읽기전용 Input 후보 (ReadOnly 여부는 확인 필요) |
| rtxComments | RichTextBox | 확인 필요 | TextArea |
| usrLabel1 | UsrLabel | 확인 필요 | Label |
| btnButtonList | UsrButtonList | – | 버튼 그룹 (저장 → `SSP0015_SAVE_SHIPMENT_PSI_COMMENTS`) |

## 2. 화면 배치

| 영역 | 근거(props.csv) | 크기와 비율 |
|---|---|---|
| 조회조건 패널 | usrConditionPanel1: Dock=Top, Size 1370×79, UsrPanelType=HidePanel / usrLayoutControl2: Dock=Top, 1370×73 | 상단 고정 (높이 79) |
| 본문 분할 | splitContainer1: Dock=Fill, **Orientation=Horizontal**, Size 1370×570, **SplitterDistance=301** | **상/하 분할**. 상단 301 / 전체 570 = 약 52.8%. 하단은 나머지(약 47.2%)이며 스플리터 폭이 포함된다. 스플리터 폭은 미추출 |
| 상단 Panel1 | spdMain Dock=Fill, 1370×301 | Main Grid |
| 하단 Panel2 | usrLayoutControl3 Dock=Top 1370×40 + spdDetail Dock=Fill 1370×225 | 상세 조회조건(40) + Detail Grid(225) |

- 하단 내부 비율은 조회조건 40 : Grid 225이다(약 15% : 85%).
- 301 + 40 + 225 = 566이고, 570과의 차이 4는 스플리터 폭으로 보인다. 스플리터 폭이 미추출이라 이것도 **확인 필요**하다.

## 3. 시트별 Grid 컬럼

기준은 grid_effective.csv다. 모든 시트에서 14개 division의 값이 같아서 division별 표시 차이는 **없다**. "숨김"은 메타 VISIBLE_FLAG 기준이고, "→숨김"은 코드가 숨긴 것이다.

### 3-1. spdMain

#### `Shipment PSI(Mobility & IT)` — META+코드연결, 표시 10

- **표시(기본)**: DIVISION_ID(Div), FIGURE(Figure), FROM_SITE_NM(From Site), ITEM_ID(Model), LT_DAY(Aging L/T), MEASURE_NAME(Measure), NICK_NAME(Nick Name), PSI_NAME(PSI), TYPE(TYPE), YEILD(Yield(%))
- **숨김**: FROM_SITE(Site), LT_UPDATE_YN, MEASURE, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SHIP_FROZEN
- **코드 →숨김**: SHIP_TO, SHIPTO_DESCRIPTION (시트 연결이 맞는지 확인 필요, analysis.md 6장 4번)
- **코드 추가**:
  - 날짜 컬럼: InitSpreadDateColumn이 SCP0009_GET_SHEET_CALENDAR_3SPAN 결과로 만든다. `B_` 컬럼은 숨김 Text, 그 밖은 Num(폭 70)이며 SAT는 Blue, SUN은 Red다.
  - Bucket/Sum 표시 규칙: SetSpreadColumn(D_/W_/M_)
  - MergePolicy.Always
- **Measure 메타**: SCM_MST_SHEET_MEASURE 12/1 (필수 12, 선택 1)

#### `Shipment PSI(Packer)` — META+코드연결, 표시 8

- **표시**: DIVISION_ID(Div), FIGURE(Figure), FROM_SITE_NM(From Site), ITEM_ID(Model), MEASURE(Measure), NICK_NAME(Nick Name), PSI_NAME(PSI), TYPE(TYPE)
- **숨김**: FROM_SITE, LT_DAY, LT_UPDATE_YN, MEASURE_NAME, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SHIP_FROZEN, YEILD
- **코드**:
  - 날짜 컬럼 DB루프, SetSpreadColumn, MergePolicy.Always
  - SetSoNoColumnVisible이 이 시트이면 Width 80 또는 0을 준다(ichkbtn에 따라 다름)
- **Measure 메타**: 6/0

#### `Shipment PSI(IT & Mobile)` — 메타 정의만 있고 코드는 참조하지 않음(미사용 가능), 메타상 표시 10

- 컬럼 구성은 Mobility & IT와 같고 라벨만 `Yeild(%)` 철자가 다르다.
- **Measure 메타**: 12/1
- 코드에서 AddSheet하지 않는다. TO-BE에 넣을지는 **확인 필요**하다.

### 3-2. spdDetail

#### `Shipment Confirm Detail` — META+코드연결, 표시 40 (메타 규칙 집계는 39/0)

- **표시**: ATTRIBUTE10, attribute3(PLM status), attribute6(OQC Result), CHANGE_REASON_CODE(Change Reason), CHANGE_REASON_DETAIL(Reason Detail), CHANGE_REQ_NO(Change Request No), CONFIRM_ID(Confirm/Plan ID), DIVISION_ID(Division), END_CUSTOMER(End Customer), ERP_SO_NO(SO No), ETA, ETD, Expected_Shipping_Date(Expected Shipping Date), FCST_TYPE(FCST Type), FROM_SITE_DESCRIPTION(From Site), INCOTERMS(Incoterms), ITEM_ID(Model), LT_DAY(L/T(Day)), MODEL_USER(Model PIC), MTK_OWNER(MKT Owner), NICK_NAME(Nick Name), REMARKS(Remarks), REMARKS2(Building), REMARKS3(Customer Requirement), REQUESTOR(Shipment Requestor), RTF3(RTF), RTF4(RTF ETD), RTF5(RTF QTY), RTF6(RTF Detail), SHIPMENT_CONFIRM_QTY(Shipment Qty), SHIPMENT_DATE(Shipment Date), SHIPMENT_STATUS(Status), SOLDTO_DESCRIPTION(Sold To Party), TEAM(Team), TO_SITE_DESCRIPTION(To Site), TO_SITE_SHIPTO_CODE(Ship to), TO_SITE_SOLDTO_CODE(Sold to), TRANSPORT_MODE(Trans Mode), UPDATED_BY(Updated By), UPDATED_DATE(Updated Date)
- **기본이지만 코드가 →숨김**: SHIPTO_DESCRIPTION(Ship To Party)
- **숨김**: BEFORE_QTY, BOD_ID, CHANGE_TYPE, CHECK_NEED_YN, CHK(ALL), EDIT_MAIN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE(Shipment Date*), NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, PROJECT_CODE, PROJECT_NAME, TO_SITE
- **코드**:
  - FindData_Detail, FindData_Detail_btnSearch, FindData_Detail_Packer_btnSearch에 Visible=false가 있다. 대상 컬럼은 확인 필요하다.
  - SpdDetail_CellClick이 헤더 CheckBox로 전체를 선택하거나 해제한다.
  - TransMode와 ShipToCodeByDivision 콤보를 공통코드에서 채운다.
- 별도 메타 프로그램 `SSP0015_TEMP2`에 같은 이름의 시트(31/0)가 있다. 용도는 확인 필요하다.

#### `Shipment Request Detail` — META+코드연결, 표시 34

- **표시**: ATTRIBUTE3(RTF), ATTRIBUTE4(RTF ETD), ATTRIBUTE5(RTF QTY), ATTRIBUTE6(RTF Detail), BOD_ID, CHANGE_REQUEST_NO, DIVISION_ID(Div*), EDIT_FLAG, END_CUSTOMER, ETA_DATE(ETA), ETD_DATE(ETD), EXPECTED_SHIP_DATE, FCST_TYPE(FCST Type*), FROM_SITE(From Site*), INCOTERMS(Incoterms*), LAST_UPDATED_BY(Requestor), LAST_UPDATED_DATE(Request Date), LT_TOTAL(L/T(Day)), MKT_OWMER(MKT Owner), MODEL_ID(Model*), MODEL_PIC, NICK_NAME, ORDER_TYPE_DETAIL, QTY(Qty*), REMARK, REQUEST_ID(Confrim/Plan ID), SHIPTO_CODE(Ship to*), SHIPTO_NAME, SITE_DESCRIPTION(Plant Site), SOLDTO_CODE(Sold to), STATUS, TO_SITE(To Site*), TR_MODE(Trans Mode*), YYYYMMDD(Shipment Date*)
- **코드 →숨김**: SHIP_TO, SHIPTO_DESCRIPTION

#### `W/H stock` — META+코드연결, 메타 19/0

- 컬럼 상세는 grid_effective.csv가 잘려 **확인 필요**하다.

#### `W/H stock Detail` — META+코드연결, 메타 25/0

- 컬럼 상세는 **확인 필요**하다(CSV 잘림).

#### `Hold stock` — META+코드연결, 표시 10

- **표시**: DIVISION_ID(Div), FROM_SITE_NM(From Site), HOLD_QTY(Amend Qty*), HOLD_YYYYMMDD(Start Date), ITEM_ID(Model), LAST_UPDATE_DATE, LAST_UPDATED_BY, NICK_NAME, RELEASE_YYYYMMDD(End Date*), REMARKS
- **숨김**: FROM_SITE, HOLD_ID
- **코드 →숨김**: SHIP_TO, SHIPTO_DESCRIPTION
- 저장 SP는 `SSP0015_SAVE_BLOCK_STOCK_DATA`다.

#### `Hold stock Detail` — META+코드연결, 표시 10

- 컬럼은 Hold stock과 같다. 차이는 라벨에서 `Amend Qty`와 `End Date`에 `*`가 없다는 점이다.

#### `Stock Detail` — META+코드연결 (코드상 shtMesStock), 메타 26/0

- **표시(CSV에서 확인된 범위)**: AVAILABLE_YN, DIVISION_ID, FCS_HOLD_YN, FCS_SPECIAL_QTY, FROM_SITE(Site), ITEM_ID, JUDG_VLD_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY, LONGTERM_HOLD_YN, LOT_ID, LOT_QTY_FCS, LOT_QTY_MES, LOT_QTY_MES_NG, LOT_QTY_TOT, LOT_TYPE, MES_CHANGE_STATUS, MES_HOLD_RELEASE, MES_HOLD_YN, NICK_NAME, OWMS_STOCK_QTY, QMS_HOLD_RELEASE, QMS_HOLD_YN, REMARKS, USER_MOD_RELEASE_DATE(User Modified Release Date*), YYYYMMDD_LOT_ID_APPLIED_LT(D Day(Expected))
- **코드 →숨김**: SHIP_TO, SHIPTO_DESCRIPTION
- 저장 SP는 `SSP0015_SAVE_MES_STOCK`다.

#### `MES Stock Detail` — 메타 정의만 있고 코드는 참조하지 않음(미사용 가능), 메타 24

- 컬럼은 Stock Detail에서 LONGTERM_HOLD_YN과 LOT_QTY_MES_NG를 뺀 구성이다.
- TO-BE에 넣을지는 **확인 필요**하다.

#### `SCS Stock Detail` — META+코드연결, 표시 9

- **표시**: CUTOFF_DATE, DIVISION_ID, HOLD_YN, LAST_UPDATE_DATE(Update Date), MODEL_ID(Model), PLANT_ID, PLANT_NAME, PROD_DATE, QTY
- **코드 →숨김**: SHIP_TO, SHIPTO_DESCRIPTION

#### `Stock Location Detail` — META+코드연결, 메타 20/0

- **확인된 표시 컬럼**: AVAILABLE_DATE, AVAILABLE_QTY, COMPANY_ID, CUTOFF_DATE, DEFECT_QTY(Deffect Qty), DIVISION_ID 등
- 나머지는 **확인 필요**하다(CSV 잘림).

#### `WH In Plan Detail` — META+코드연결, 메타 11/0

- AddSheet 조건이 `if(drPgmAuthId != null)`이다(CreateSpread:680).
- 컬럼 상세는 **확인 필요**하다.

#### `Shipment Result` — META+코드연결, 표시 17 (메타 19 − 코드 숨김 2)

- **표시**: CONFIRM_ID, DIVISION_ID, END_CUSTOMER, ERP_SO_NO(SO No), ETA_DATE, ETD_DATE, FROM_SITE, INCOTERMS, ITEM_ID, NICK_NAME, QTY(Shipment Qty), SHIP_TYPE, TEAM, TO_SITE, TRANSPORT_MODE, TYPE(Status), YYYYMMDD(Shipment Date)
- **기본이지만 코드가 →숨김**: SHIP_TO(Ship to), SHIPTO_DESCRIPTION(Ship to Name) (4991/4992줄)

## 4. 시트 연결 규칙

| 시트 | Spread | 코드 상수 | 조회 메서드 → 엔드포인트 (메서드명 기준이라 확인 필요 포함) |
|---|---|---|---|
| Shipment PSI(Mobility & IT) | spdMain | SpdSheet.shtMain | FindButton > FindData_Main → `SSP.SSP0015_GET_SHIPMENT_PSI` |
| Shipment PSI(Packer) | spdMain | SpdSheet.shtPacker | FindButton > FindData_Main_Packer / FindData_Main_Packer_Past → `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` / `_PACKER_PAST` |
| Shipment Confirm Detail | spdDetail | shtDetail | SpdMain_CellDoubleClick > FindData_Detail, BtnSearch_Click > FindData_Detail_btnSearch → `SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` / FindData_Detail_Packer_btnSearch → `..._PACKER` |
| Shipment Request Detail | spdDetail | shtRequestDetail | FindData_Request_Detail → `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` |
| W/H stock | spdDetail | shtWHstock | FindData_WHstock → `SSP.SSP0015_GET_WH_STOCK` |
| W/H stock Detail | spdDetail | shtWHstockDetail | 확인 필요 |
| Hold stock / Hold stock Detail | spdDetail | shtBolckStock / shtBolckStockDetail | FindData_block_stock / FindData_BolckStockDetail_btnSearch → `SSP.SSP0015_GET_BLOCK_STOCK` |
| Stock Detail | spdDetail | shtMesStock | FindData_mes_stock / FindData_MesStock_btnSearch → `SSP.SSP0015_GET_MES_STOCK` |
| SCS Stock Detail | spdDetail | shtScsStock | FindData_ScsStock_btnSearch → `SSP.SSP0015_GET_SCS_STOCK` |
| Stock Location Detail | spdDetail | shtStockLocationDetail | FindData_shtStockLocationDetail_btnSearch → `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` (+ GetNERPCode) |
| WH In Plan Detail | spdDetail | shtWHinPlanDetail | FindData_WHinPlanDetail_btnSearch → `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS` |
| Shipment Result | spdDetail | shtShipmentResult | FindData_ShipmentResult_btnSearch → `SSP0015_GET_SHIPMENT_RESULT` / FindData_ShipmentSCSResult_btnSearch → `..._RESULT_PACKER` |

- CreateSpread는 마지막에 ChangeSheet를 W/H stock(740줄), Shipment Confirm Detail(741줄), Shipment PSI(Mobility & IT)(746줄) 순서로 부른다. 그래서 초기 활성 시트는 Main이 Mobility & IT, Detail이 Shipment Confirm Detail로 추정된다. 실행으로 **확인 필요**하다.
- Main에서 셀을 더블클릭하면 행의 DIVISION_ID, SITE, ITEM_ID, YYYYMMDD 값으로 Detail을 조회한다(8290~8293줄).
