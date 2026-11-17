# SSP0200 Shipment Change Request — 화면설계서

> 근거: Fact Pack(controls.csv, props.csv, events.csv, grid_code, grid_effective)과 1차 분석서.
> props.csv 일부(LayoutControlItem Text 등)는 잘려서 추출되지 않았습니다. 해당 라벨은 **미추출(확인 필요)**로 적었습니다.
> 엔드포인트 이름은 업무분석서 §5와 같습니다. 컨트롤명은 단위테스트 절차 열에서 그대로 씁니다.

## 1. 화면 개요
| 항목 | 값 |
|---|---|
| 화면 ID | SSP0200 |
| 화면명 | Shipment Change Request (`SSP0200_ShipmentChangeRequest`) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 4행, 내용 미추출) |
| 도메인 | SSP / Plan |
| 그리드 구성 | META(프레임워크) + 코드 표시/라벨 변경. 메타는 SCM_MST_SHEET_COLUMNS 124행입니다 |
| 시트 | `Shipment Change Request` (spdMain), `Change Request` (spdSub) |
| 팝업 | SSP0200_ShipmentChangeRequestInsertPopup (shared). 다건 행 추가 수량을 입력합니다 |

## 2. 화면 레이아웃 (분할 트리 와이어프레임)

근거는 다음 props.csv 값입니다.
- splitContainer1: Dock=Fill, Orientation=Horizontal, Size=1192×649, SplitterDistance=253
- usrConditionPanel1: Dock=Top, 1192×73, HidePanel
- usrLayoutControl1: Fill, 1192×73
- spdMain: Fill, 1192×180
- panel3: Dock=Top, 1192×179
- usrLayoutControl2: Fill, 432×179
- spdSub: Fill, 1192×213
- controls.csv parent 체인

```
SSP0200 (Form)
└─ splitContainer1  [Dock=Fill · Orientation=Horizontal → 상/하 분할 · 1192×649 · SplitterDistance=253]
   ├─ Panel1 (상단) 253px / 649px = 39.0%
   │  ├─ usrConditionPanel1 [Dock=Top · 1192×73 · HidePanel(접이식)]       ── 조회조건 영역 (73/253 = 28.9%)
   │  │  └─ usrLayoutControl1 [Dock=Fill · 1192×73]
   │  │     ├ clbDivision_ID(Div) · clbFromSite(From Site) · clbToSite(To Site) · cboStatus(Status)
   │  │     ├ drpPeriod(Shipment Date) · cboChangeType(Change Type) · txtSoNo(SO No) · txtConfirmId(Confirm Id)
   │  │     ├ txtRequest + btnItemId (LayoutItem "Model", Text 미추출) · chkSingleProcess (Text 미추출)
   │  │     └ btnNew("New") · btnInsertMultiple("Insert(Multi)")                ── 행 추가 버튼
   │  └─ spdMain [Dock=Fill · 1192×180] (180/253 = 71.1%)                     ── 그리드: Shipment Change Request
   │     └─ spdMain_Sheet1
   └─ Panel2 (하단) 나머지 = 649 − 253 = 396px (61.0%; 스플리터 폭 미추출이라 정확값은 확인 필요)
      ├─ panel3 [Dock=Top · 1192×179]                                        ── 액션 + 변경요청 정보
      │  ├─ usrLayoutControl2 [Dock=Fill · 432×179]                            ── 버튼 영역
      │  │  ├ btnChangeRe2("Request Complete") · btnSave("Save Draft", Visible=false)
      │  │  ├ btnCancel("Cancel") · btnDel("Delete")
      │  │  └ btnAdd("Add Date", Visible=false) · dtDate(Visible=false)
      │  └─ panel1 [Dock·위치 미추출 — 확인 필요]
      │     └─ usrLayoutControl3                                               ── 변경요청 정보 영역
      │        ├ txtRequestNo · txtTitle · txtRequestor · txtRequestDeptName
      │        ├ txtApproval + btnApprovalUser · txtAppDeptName
      │        └ cboChangeReason · txtReasonDetail · usrLabel2
      └─ spdSub [Dock=Fill · 1192×213]                                        ── 그리드: Change Request (2단 헤더)
         └─ spdSub_Sheet1

※ panel3(179) + spdSub(213) = 392px. Panel2 396px와 4px 차이가 나는데, 원인은 미확인입니다.
※ usrLayoutControl2는 Dock=Fill인데 Size가 432×179로 기록돼 있습니다. panel1과 좌우로 나뉘는지는 확인 필요합니다.
※ txtItemId: controls.csv의 parent가 없어 배치 위치를 확인해야 합니다.

[팝업] SSP0200_ShipmentChangeRequestInsertPopup
└─ usrConditionPanel1 (parent=this)
   └─ usrLayoutControl2
      ├ usrLabel1 (Text 미추출)
      ├ txtCurrentInsert_Qty (추가 행 수)
      └ btnButtonList (UsrButtonList_Click_Detected)
```

## 3. 컨트롤 명세

| # | 컨트롤명 | 타입 | 라벨(props Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|
| 1 | spdMain | FarPoint FpSpread | — | — | — | SpdMain_TopChange, SpdMain_CellClick, SpdMain_CellDoubleClick, SpdMain_EditChange, SpdMain_ClipboardPasted, SpdMain_ComboSelChange, SpdMain_CursorChanged | Wijmo FlexGrid (편집) |
| 2 | spdMain_Sheet1 | SheetView | 시트 `Shipment Change Request` | 메타 36/0 | — | (dsdm.Changed → shtMain_Change) | FlexGrid columns |
| 3 | usrConditionPanel1 | UsrConditionPanel | — | HidePanel | — | — | 조회조건 접이식 패널 |
| 4 | usrLayoutControl1 | UsrLayoutControl | "usrLayoutControl1" | — | — | — | 조회조건 레이아웃 |
| 5 | btnInsertMultiple | UsrButton | "Insert(Multi)" | — | — | btnInsertMultiple_Click | Button + 수량 팝업 |
| 6 | txtConfirmId | UsrMultiLineEditor | "Confirm Id" (layoutControlItem11) | 확인 필요 | 확인 필요 | — | 멀티라인 입력 |
| 7 | clbDivision_ID | UsrCombo | "Div" (layoutControlItem8) | SSP0200_GET_SHIPMENT_DIVISION 결과 | 확인 필요 | clbDivision_ID_SelectedIndexChanged | Wijmo ComboBox |
| 8 | clbFromSite | UsrCheckedList | "From Site" (layoutControlItem7) | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE 결과 | 확인 필요 | — | Wijmo MultiSelect |
| 9 | txtSoNo | UsrMultiLineEditor | "SO No" (lblSONo) | 확인 필요 | 확인 필요 | — | 멀티라인 입력 |
| 10 | drpPeriod | UsrDateRangePicker | "Shipment Date" (layoutControlItem1) | SCM0001_GET_SCP_DAY_PERIOD | 확인 필요 | — | DateRange (InputDate×2) |
| 11 | cboStatus | UsrCombo | "Status" (PlanType) | 소스 확인 필요 | 확인 필요 | — | Wijmo ComboBox |
| 12 | txtRequest | UsrMultiLineEditor | 미추출 (LayoutItem "Model") | 확인 필요 | 확인 필요 | — | 멀티라인 입력 |
| 13 | btnItemId | UsrButton | 미추출 (layoutControlItem2) | — | — | btnItemId_Click | 팝업 호출 버튼 |
| 14 | cboChangeType | UsrCombo | "Change Type" (PlanType1) | 소스 확인 필요 ("P" 값 존재) | 확인 필요 | CboChangeType_SelectedIndexChanged | Wijmo ComboBox |
| 15 | clbToSite | UsrCheckedList | "To Site" (layoutControlItem3) | 소스 확인 필요 | 확인 필요 | — | Wijmo MultiSelect |
| 16 | btnNew | UsrButton | "New" | — | — | BtnNew_Click | Button |
| 17 | chkSingleProcess | CheckEdit | 미추출 (CheckSingleProcess) | 확인 필요 | — | — | CheckBox |
| 18 | spdSub | FarPoint FpSpread | — | — | — | 배선 없음 | Wijmo FlexGrid (2단 헤더) |
| 19 | spdSub_Sheet1 | SheetView | 시트 `Change Request` | 메타 26/0 | — | — | FlexGrid columns |
| 20 | usrLayoutControl2 | UsrLayoutControl | 미추출 | — | — | — | 버튼 영역 레이아웃 |
| 21 | dtDate | UsrDatePicker | 미추출 (lcDate) | Visible=false | — | — | InputDate (숨김) |
| 22 | btnDel | SimpleButton | "Delete" | — | — | **배선 없음(확인 필요)** | Button |
| 23 | btnCancel | SimpleButton | "Cancel" | — | — | BtnCancel_Click | Button |
| 24 | btnSave | SimpleButton | "Save Draft" | Visible=false | — | BtnSave_Click | Button (숨김) |
| 25 | btnAdd | SimpleButton | "Add Date" | Visible=false | — | 배선 없음 | Button (숨김) |
| 26 | btnChangeRe2 | SimpleButton | "Request Complete" | — | — | BtnChangeRe_Click | Button |
| 27 | usrLayoutControl3 | UsrLayoutControl | 미추출 | — | — | — | 변경요청 정보 폼 |
| 28 | txtRequestNo | TextBox | 미추출 | CHANGE_REQ_NO (SetChangeRequestInfo) | 확인 필요 | — | Input (읽기 전용 여부 확인 필요) |
| 29 | txtTitle | TextBox | 미추출 (lcTitle) | REQUEST_TITLE | 확인 필요 | — | Input |
| 30 | txtRequestor | TextBox | 미추출 | REQUEST_USER(_NAME) | 확인 필요 | — | Input |
| 31 | txtRequestDeptName | TextBox | 미추출 | REQUEST_DEPT(_NAME) | 확인 필요 | — | Input |
| 32 | txtAppDeptName | TextBox | 미추출 (lcAppDept) | APPROVAL_DEPT(_NAME) | 확인 필요 | — | Input |
| 33 | cboChangeReason | UsrComboBox | 미추출 (lcChangeReason) | CHANGE_REASON_CODE, 소스 확인 필요 | 확인 필요 | — | Wijmo ComboBox |
| 34 | txtReasonDetail | TextBox | 미추출 (lcReasonDetail) | CHANGE_REASON_DETAIL | 확인 필요 | — | Input / TextArea |
| 35 | btnApprovalUser | UsrButton | 미추출 | — | — | BtnApprovalUser_Click | 승인자 선택 팝업 버튼 |
| 36 | usrLabel2 | UsrLabel | 미추출 | — | — | — | Label |
| 37 | txtApproval | TextBox | 미추출 (lcApproval) | APPROVAL_USER(_NAME) | 확인 필요 | — | Input |
| 38 | txtItemId | UsrMultiLineEditor | 미추출 (parent 없음) | 확인 필요 | — | — | 확인 필요 |
| 39 | usrLabel1 | UsrLabel (팝업) | 미추출 | — | — | — | Label |
| 40 | txtCurrentInsert_Qty | UsrTextBox (팝업) | — | 확인 필요 | 확인 필요 | — | InputNumber |
| 41 | btnButtonList | UsrButtonList (팝업) | — | — | — | btnButtonList_UsrButtonList_Click_Detected | 확인/취소 버튼 그룹 |

> 필수 여부는 Fact Pack에 컨트롤 단위 근거가 없어 모두 **확인 필요**로 두었습니다. 그리드 셀 필수 여부는 §4와 §6을 봅니다.

## 4. 그리드 명세

### 4-1. 시트 `Shipment Change Request` (spdMain, 헤더 1행, 메타 36/0 → 최종 40/EE 34열, 그 외 32열, 판단불가 ?4)

| 컬럼 | 헤더(메타) | 타입 | 출처 | 40 / EE | 그 외 | 편집 |
|---|---|---|---|---|---|---|
| DIVISION_ID | Div | Combo (MyDivision, EE 제외) | META + 코드 콤보 | 표시 | 표시 | 확인 필요 (IsLock 기준) |
| CONFIRM_ID | Confirm/Plan ID | Text | META + 코드 Width | 표시 (ChangeType "P" → Width 0, 그 외 120) | 같음 | 확인 필요 |
| ERP_SO_NO | SO No | Text | META + 코드 Width | "P" → Width 0, 그 외 100 | 같음 | 확인 필요 |
| SHIPMENT_STATUS | Status | Text | META | 표시 | 표시 | 확인 필요 |
| ITEM_ID | Model* | Text | META | 표시 | 표시 | 확인 필요 |
| NICK_NAME | Nick Name | Text | META | 표시 | 표시 | 확인 필요 |
| FCST_TYPE | FCST Type* | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| FROM_SITE | From Site ID | Text | META | 표시 | 표시 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site* | Combo (SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION) | META + 코드 콤보 | 표시 | 표시 | 확인 필요 |
| TO_SITE | To Site ID | Text | META | 표시 | 표시 | 확인 필요 |
| TO_SITE_DESCRIPTION | To Site* | Combo (Data_SCP.Common, 확인 필요) | META + 코드 콤보 | 표시 | 표시 | 확인 필요 |
| TO_SITE_SHIPTO_CODE | Ship to | Text | META | 표시 | 표시 | 확인 필요 |
| TO_SITE_SOLDTO_CODE | Sold to | Text | META | 표시 | 표시 | 확인 필요 |
| END_CUSTOMER | End Customer* | 확인 필요 | META + 코드 Visible | **표시** | **숨김** | 확인 필요 |
| ERP_ATTR1 | Consignee Name | Text | META + 코드 Visible | **표시** | **숨김** | 확인 필요 |
| ERP_ATTR2 | Contact Point | Text | META + 코드 Visible | **표시** | **숨김** | 확인 필요 |
| ERP_ATTR3 | Lot | Text | META + 코드 Visible | **표시** | **숨김** | 확인 필요 |
| PROJECT_CODE | Project Code* | 확인 필요 | META + 코드 Visible | **숨김** | **표시** | 확인 필요 |
| PROJECT_NAME | Project Name | Text | META + 코드 Visible | **숨김** | **표시** | 확인 필요 |
| INCOTERMS | Incoterms* | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| TRANSPORT_MODE | Trans Mode* | Combo (biz:CommonData.CommonDataList TransMode) | META + 코드 콤보 | 표시 | 표시 | 확인 필요 |
| LT_DAY | L/T(Day) | Number | META | 표시 | 표시 | 확인 필요 |
| ETD | ETD | Date | META | 표시 | 표시 | 확인 필요 |
| ETA | ETA | Date | META | 표시 | 표시 | 확인 필요 |
| SHIPMENT_DATE | Shipment Date* | Date | META | 표시 | 표시 | 확인 필요 |
| SHIPMENT_CONFIRM_QTY | Shipment Qty* | Number | META | 표시 | 표시 | 확인 필요 |
| REQUEST_DATE | Request Date | Date | META | 표시 | 표시 | 확인 필요 |
| REQUESTOR | Shipment Requestor | Text | META | 표시 | 표시 | 확인 필요 |
| MTK_OWNER | MKT Owner | Text | META | 표시 | 표시 | 확인 필요 |
| CHANGE_REASON_CODE | Change Reason | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| CHANGE_REASON_DETAIL | Reason Detail | Text | META | 표시 | 표시 | 확인 필요 |
| REMARKS | Remarks | Text | META | 표시 | 표시 | 확인 필요 |
| REMARKS2 | Building | Text | META | 표시 | 표시 | 확인 필요 |
| REMARKS3 | Customer Requirement | Text | META | 표시 | 표시 | 확인 필요 |
| ATTRIBUTE10 | ATTRIBUTE10 | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| EDIT_MAIN | EDIT_MAIN | 확인 필요 | META | 표시 | 표시 | 확인 필요 |

- 메타 숨김 컬럼(정의만 있음): BOD_ID, CHANGE_REQ_NO, CHANGE_TYPE, CHECK_NEED_YN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, Expected_Shipping_Date, MODEL_USER, NEW_* 계열 15개, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, SHIPTO_DESCRIPTION, SOLDTO_DESCRIPTION, TEAM, UPDATED_BY, UPDATED_DATE
- 헤더의 '*'는 메타 라벨 원문입니다. 이것이 저장 필수와 같은 뜻인지는 SSP_Main_Validation 조건식으로 확인해야 합니다.

### 4-2. 시트 `Change Request` (spdSub, 헤더 2행, 메타 26/0 → 최종 40/EE 25열, 그 외 26열, 판단불가 ?5)

| 컬럼 | 헤더(메타) | 상위 헤더 Span | 타입 | 출처 | 40 / EE | 그 외 | 편집 |
|---|---|---|---|---|---|---|---|
| CHK | ALL | — | CheckBox (기본 false) | META + 코드 CellType | 표시 (Ship Status가 "R"이 아니고 sSearchType이 "Exist"이면 숨김) | 같음 | 체크 가능 |
| CHANGE_REQ_NO | Change Req.No | — | Text | META | 표시 | 표시 | 확인 필요 |
| CONFIRM_ID | Confirm id | — | Text | META | 표시 | 표시 | 확인 필요 |
| ERP_SO_NO | SO No | — | Text | META + 코드 Visible | "P"이면 숨김, 그 외 표시 | 같음 | 확인 필요 |
| ITEM_ID | Model | — | Text | META | 표시 | 표시 | 확인 필요 |
| NICK_NAME | Nick Name | — | Text | META | 표시 | 표시 | 확인 필요 |
| FCST_TYPE | FCST Type | — | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site | — | Text | META | 표시 | 표시 | 확인 필요 |
| TO_SITE_DESCRIPTION | To Site | — | Text | META | 표시 | 표시 | 확인 필요 |
| INCOTERMS | Incoterms | — | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| PROJECT_NAME / PROJECT_CODE / END_CUSTOMER | Project Name / Project Code / — | — | 확인 필요 | 코드 변경 귀속 추정 | 확인 필요 | 확인 필요 | 확인 필요 |
| LT_DAY, ETD, ETA, TRANSPORT_MODE, SHIPMENT_DATE, SHIPMENT_CONFIRM_QTY | L/T(Day), ETD, ETA, Trans Mode, Shipment Date, Qty | "Plan"("P") / "Confirmed"(그 외) | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| NEW_LT_DAY, NEW_ETD, NEW_ETA, NEW_TRANSPORT_MODE, NEW_SHIPMENT_DATE, NEW_SHIPMENT_CONFIRM_QTY | L/T(Day), ETD, ETA, Trans Mode, Shipment Date*, Qty* | "Confirm"("P") / "Change"(그 외) | 확인 필요 | META | 표시 | 표시 | 확인 필요 |
| REMARKS | Remarks | — | Text | META + 코드 Width=0 | 사실상 숨김 | 같음 | — |
| REMARKS2 | Building | — | Text | META | 표시 | 표시 | 확인 필요 |
| REMARKS3 | Customer requirement | — | Text | META | 표시 | 표시 | 확인 필요 |

- 메타 숨김 컬럼: A_COUNTRY, A_PORT_CODE, BOD_ID, CUSTOMER_LT, D_COUNTRY, D_PORT_CODE, DIVISION_ID, ELECTRODE_TYPE, ELECTRODE_YN, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BASE_CONFIRM_YN, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_INCOTERMS, NEW_ROUTE_ID, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_YN, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, PLAN_CONFIRM_ID, ROUTE_ID, TO_CITY, TO_COUNTRY, TO_SITE

## 5. 액션 명세

| # | 트리거(컨트롤/이벤트) | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 Load | `Form_Load` | InitControls > GetDayRange / GetDivision > SetChangedControl > GetShipmentPlanPlantSite | `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `SSP.SSP0200_GET_SHIPMENT_DIVISION`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | drpPeriod, clbDivision_ID, clbFromSite |
| A2 | clbDivision_ID 변경 | `clbDivision_ID_SelectedIndexChanged` | SetChangedControl > GetShipmentPlanPlantSite | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | clbFromSite |
| A3 | cboChangeType 변경 | `CboChangeType_SelectedIndexChanged` | GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | drpPeriod. "P" 분기 컬럼 폭과 헤더(§4) |
| A4 | 조회 (프레임워크 FindButton) | FindButton (오버라이드) | FindData_Main / FindData_Sub_Draft | `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING` | spdMain(`Shipment Change Request`), spdSub(`Change Request`), usrLayoutControl3 정보 |
| A5 | 행추가 (프레임워크 InsertButton) | InsertButton > InsertRow | 신규 행 추가, From Site 콤보 소스 설정 | `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | spdMain 신규 행 |
| A6 | btnNew 클릭 | `BtnNew_Click` | 신규 행 추가, DIVISION_ID 콤보(EE 제외) | `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | spdMain 신규 행 |
| A7 | btnInsertMultiple 클릭 | `btnInsertMultiple_Click` | 팝업(`Form_Load`, `btnButtonList_UsrButtonList_Click_Detected`) → InsertRowMultiple | `SSP.SSP0200_GET_ITEM_FROM_BOD`, `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | spdMain 다건 행 |
| A8 | dsdm 데이터 변경 | `shtMain_Change` | GetItemFromBOD (row operation_group) | `SSP.SSP0200_GET_ITEM_FROM_BOD` | spdMain 행 값(**확인 필요**) |
| A9 | spdMain 셀 클릭 | `SpdMain_CellClick` | TRANSPORT_MODE 콤보 소스 로드, 헤더 CheckBox 전체 토글 | `biz:CommonData.CommonDataList` [TransMode] | 셀 콤보, 체크 값 |
| A10 | spdMain 콤보 선택 | `SpdMain_ComboSelChange` | FindData_BOD (ROUTE·BOD·INCOTERMS·국가·포트·LT 설정). DIVISION_ID 컬럼이면 Site 재조회 + END_CUSTOMER/PROJECT_* 표시 전환 | `SSP.SSP0026_GET_BOD_ITEM`, `biz:CommonData.CommonDataList`, `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | spdMain 행 값, 컬럼 표시 |
| A11 | 저장 (프레임워크 SaveButton) | SaveButton (오버라이드) | SSP_Main_Validation, chkERPIFBlockYn → 채번 → Confirm 저장 → ERP I/F 분기 → 재조회 | `SSP.SSP0200_GET_CHANGE_REQ_NO`, `SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0200_GET_SHIPMENT_STATUS`, `SSP.SSP0200_GET_ERP_SO_NO_CNT`, `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE`, `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N` (+ A4 재조회) | spdMain, spdSub 재조회 |
| A12 | btnChangeRe2 "Request Complete" | `BtnChangeRe_Click` | SaveDataDrafting → 재조회 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` (+ A4) | spdMain, spdSub. 메일 발송(SP 내부) |
| A13 | btnSave "Save Draft" (Visible=false) | `BtnSave_Click` | SaveDataDrafting → 재조회 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` (+ A4) | spdMain, spdSub |
| A14 | btnCancel "Cancel" | `BtnCancel_Click` | DeleteDataDrafting (+ GetErpIFCheck) → 재조회 | `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` (+ A4) | spdMain, spdSub |
| A15 | btnApprovalUser 클릭 | `BtnApprovalUser_Click` | 승인자 선택 (엔드포인트 미추출) | — | txtApproval, txtAppDeptName (**확인 필요**) |
| A16 | btnItemId 클릭 | `btnItemId_Click` | Item 선택 팝업 추정 (내부 미추출) | — | txtRequest (**확인 필요**) |
| A17 | spdMain 상단 행 변경 | `SpdMain_TopChange` | 내부 미추출 | — | **확인 필요** |
| A18 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | 내부 미추출 | — | **확인 필요** |
| A19 | spdMain 편집 변경 | `SpdMain_EditChange` | 내부 미추출 | — | **확인 필요** |
| A20 | spdMain 붙여넣기 | `SpdMain_ClipboardPasted` | 내부 미추출 | — | **확인 필요** |
| A21 | spdMain 커서 변경 | `SpdMain_CursorChanged` | 내부 미추출 (상·하단 연동 여부 확인 필요) | — | **확인 필요** |
| A22 | 팝업 Load | `Form_Load` (InsertPopup) | 팝업 초기화 | — | txtCurrentInsert_Qty |
| A23 | 팝업 버튼 | `btnButtonList_UsrButtonList_Click_Detected` | 확인/취소 처리 (내부 미추출) | — | 팝업 닫힘, 수량 반환(**확인 필요**) |
| A24 | btnDel "Delete" | 배선 없음 | — | — | **확인 필요** |

## 6. 검증·메시지
| # | 시점 | 검증 내용 | 메시지 |
|---:|---|---|---|
| V1 | SaveButton (SSP_Main_Validation), 일반 건 | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, INCOTERMS, remarks2, remarks | 확인 필요 |
| V2 | SaveButton (SSP_Main_Validation), SO 건 | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks | 확인 필요 |
| V3 | SaveButton (chkERPIFBlockYn) | BLOCK_YN, PERIOD | 확인 필요 |
| V4 | GetShipmentStatusChk | `SSP.SSP0200_GET_SHIPMENT_STATUS` 결과 Tables[0~2]의 CONFIRM_ID | 확인 필요 |
| V5 | GetErpSoNoCnt | `SSP.SSP0200_GET_ERP_SO_NO_CNT` 결과 CNT | 확인 필요 |
| V6 | 편집 계열 | `siMain.IsLock(SheetName)`이 true이면 행 추가와 헤더 체크를 막습니다 | 확인 필요 |

## 7. 권한 (C/R/U/D) 사실
- TB_FX_GroupMenuAuth 16행, TB_FX_MenuItemInfo 4행, TB_FX_ProgramInfo 4행이 있습니다. 버튼별 C/R/U/D 값은 **확인 필요**입니다.
- 프레임워크 버튼 Find, Insert, Save가 오버라이드로 쓰입니다(R/C/U). EditButton도 오버라이드 대상으로 언급되지만 엔드포인트는 없습니다.
- Div 목록과 Site 목록은 사용자 그룹(NowGroupID)과 TB_FX_USERGROUPAUTHEXTENTION으로 필터링됩니다.
- 그리드 잠금(IsLock)에 따라 편집이 제한됩니다.

## 8. To-Be 전환 메모 (Wijmo·Oracle)
1. **레이아웃**: splitContainer1 상/하 분할(39.0% : 61.0%)을 Split 레이아웃으로 옮깁니다. usrConditionPanel1(HidePanel)은 접이식 조회조건으로 만듭니다. 하단 panel3은 버튼 영역과 변경요청 정보 폼을 함께 둡니다.
2. **그리드**:
   - spdMain은 FlexGrid로 만들고, 메타(SCM_MST_SHEET_COLUMNS) 기반 컬럼에 division/ChangeType 분기 표시(R1~R4)를 코드로 적용합니다.
   - spdSub는 FlexGrid 2단 헤더(columnGroups)로 만들고, Span 문구를 ChangeType에 따라 동적으로 바꿉니다("Plan"/"Confirm" ↔ "Confirmed"/"Change").
   - CHK 헤더 전체 선택은 FlexGrid 헤더 체크박스로 구현합니다.
   - 행 단위 DIVISION_ID 변경 시 컬럼 표시를 전환하는 동작(시트 전체 컬럼에 적용)은 AS-IS와 같게 유지해야 합니다.
3. **셀 콤보**: TRANSPORT_MODE(CommonDataList TransMode), FROM_SITE_DESCRIPTION, TO_SITE_DESCRIPTION, DIVISION_ID(EE 제외)는 DataMap으로 만듭니다.
4. **Oracle 변환**:
   - MSSQL 전용 요소를 Oracle 등가로 바꿔야 합니다: STRING_SPLIT 사용 SP(SSP0200_GET_SHIPMENT_STATUS, SSP0026_GET_BOD_ITEM, SSP0200_SAVE_SHIPMENT_CONFIRM_NEW, SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE), #임시테이블(#T_SSP, #TMP_* 등), 동적 SQL(DYNAMIC@)
   - 메일 발송 체인 SP_SEND_DBMAIL의 대체 방식을 정해야 합니다.
5. **FoxQuery 미등록 SP 2개**(SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE, SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION): BE 매핑을 새로 정의해야 합니다.
6. **저장 트랜잭션**: AS-IS는 클라이언트가 여러 SP를 차례로 호출합니다(채번 → Confirm → ERP I/F 분기). TO-BE에서 BE 서비스 한 트랜잭션으로 묶을지는 **확인 필요**입니다(분기 조건 미추출).

## 9. 미확정
1. 미추출 라벨: Model(txtRequest), CheckSingleProcess, layoutControlItem2/13, lcAdd~lcSave, usrLayoutControl3 항목 전부, usrLabel1, usrLabel2
2. panel1의 Dock과 좌우 배치, usrLayoutControl2 폭 432의 의미, txtItemId 배치
3. 콤보 소스: cboStatus, cboChangeType, clbToSite, cboChangeReason, TO_SITE_DESCRIPTION
4. 내부 미추출 핸들러: SpdMain_TopChange, BtnApprovalUser_Click, SpdMain_CellDoubleClick, SpdMain_EditChange, SpdMain_ClipboardPasted, btnItemId_Click, SpdMain_CursorChanged, btnButtonList_UsrButtonList_Click_Detected
5. btnDel 배선 없음, btnAdd·dtDate Visible=false
6. grid_effective 판단불가 140건, Change Request 귀속 추정 컬럼
7. 컨트롤과 그리드 셀의 필수 여부, 편집 가능 여부
