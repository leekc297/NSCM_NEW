# SSP0200 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

라벨은 props.csv의 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다. 원문이 추출되지 않은 라벨은 "미추출(확인 필요)"로 적었습니다.

### 1-1. 조회조건 영역 (usrConditionPanel1 / usrLayoutControl1)
| AS-IS 컨트롤 | 유형 | 라벨(원문) | TO-BE 컴포넌트 후보 |
|---|---|---|---|
| clbDivision_ID | UsrCombo | "Div" (layoutControlItem8) | Wijmo ComboBox (단일) |
| clbFromSite | UsrCheckedList | "From Site" (layoutControlItem7) | Wijmo MultiSelect |
| clbToSite | UsrCheckedList | "To Site" (layoutControlItem3) | Wijmo MultiSelect |
| cboStatus | UsrCombo | "Status" (PlanType) | Wijmo ComboBox |
| drpPeriod | UsrDateRangePicker | "Shipment Date" (layoutControlItem1) | 기간 DateRange (InputDate ×2) |
| cboChangeType | UsrCombo | "Change Type" (PlanType1) | Wijmo ComboBox |
| txtSoNo | UsrMultiLineEditor | "SO No" (lblSONo) | 멀티라인 입력(다건 붙여넣기) |
| txtConfirmId | UsrMultiLineEditor | "Confirm Id" (layoutControlItem11) | 멀티라인 입력 |
| txtRequest | UsrMultiLineEditor | 미추출 (LayoutItem 이름 "Model") — 확인 필요 | 멀티라인 입력 |
| btnItemId | UsrButton | 미추출 (layoutControlItem2) | 팝업 호출 버튼 |
| chkSingleProcess | CheckEdit | 미추출 (CheckSingleProcess) | CheckBox |
| btnNew | UsrButton | Text "New" (LayoutItem Text "layoutControlItem5") | Button |
| btnInsertMultiple | UsrButton | Text "Insert(Multi)" (layoutControlItem13) | Button → 수량 입력 팝업 |
| txtItemId | UsrMultiLineEditor | parent 없음 — 배치 확인 필요 | — |

### 1-2. 하단 액션 영역 (panel3 / usrLayoutControl2)
| AS-IS 컨트롤 | 유형 | 라벨(원문) | Visible | TO-BE |
|---|---|---|---|---|
| btnChangeRe2 | SimpleButton | "Request Complete" | (기본) | Button |
| btnSave | SimpleButton | "Save Draft" | **false** | Button (기본 숨김) |
| btnCancel | SimpleButton | "Cancel" | (기본) | Button |
| btnDel | SimpleButton | "Delete" | (기본) | Button (이벤트 배선 없음 — 확인 필요) |
| btnAdd | SimpleButton | "Add Date" | **false** | Button (기본 숨김) |
| dtDate | UsrDatePicker | — | **false** | InputDate (기본 숨김) |

### 1-3. 변경요청 정보 영역 (panel1 / usrLayoutControl3)
| AS-IS 컨트롤 | 유형 | 바인딩 컬럼 (SetChangeRequestInfo) | 라벨 |
|---|---|---|---|
| txtRequestNo | TextBox | CHANGE_REQ_NO | 미추출 — 확인 필요 |
| txtTitle | TextBox | REQUEST_TITLE | lcTitle Text 미추출 |
| txtRequestor | TextBox | REQUEST_USER(_NAME) | 미추출 |
| txtRequestDeptName | TextBox | REQUEST_DEPT(_NAME) | 미추출 |
| txtApproval | TextBox | APPROVAL_USER(_NAME) | lcApproval Text 미추출 |
| btnApprovalUser | UsrButton | — (BtnApprovalUser_Click) | 승인자 선택 팝업 |
| txtAppDeptName | TextBox | APPROVAL_DEPT(_NAME) | lcAppDept Text 미추출 |
| cboChangeReason | UsrComboBox | CHANGE_REASON_CODE | lcChangeReason Text 미추출 |
| txtReasonDetail | TextBox | CHANGE_REASON_DETAIL | lcReasonDetail Text 미추출 |
| usrLabel2 | UsrLabel | — | 미추출 |

- 바인딩 컬럼은 `SetChangeRequestInfo:2219~2230`에서 텍스트박스 이름과 컬럼명을 대응시킨 것입니다. 컨트롤↔컬럼 1:1 대입 코드는 **확인 필요**입니다.

### 1-4. Grid
| AS-IS | 시트 | TO-BE |
|---|---|---|
| spdMain | `Shipment Change Request` | Wijmo FlexGrid (메인, 편집) |
| spdSub | `Change Request` | Wijmo FlexGrid (2단 헤더, 체크박스) |

### 1-5. Insert(Multi) 팝업 (SSP0200_ShipmentChangeRequestInsertPopup, shared)
| 컨트롤 | 유형 | TO-BE |
|---|---|---|
| usrLabel1 | UsrLabel | Label (Text 확인 필요) |
| txtCurrentInsert_Qty | UsrTextBox | InputNumber (추가 행 수) |
| btnButtonList | UsrButtonList | 확인/취소 버튼 그룹 |

## 2. 화면 배치

- `splitContainer1`: Dock=Fill, **Orientation=Horizontal → 상/하 분할**, Size=1192×649, SplitterDistance=253
  - 상단 Panel1: 253/649 ≈ **39.0%**
  - 하단 Panel2: 나머지 ≈ 61%(스플리터 폭 미추출이라 정확값은 확인 필요)
- **상단 Panel1**
  - `usrConditionPanel1`: Dock=Top, 1192×73, UsrPanelType=HidePanel → 조회조건(접이식)
  - `spdMain`: Dock=Fill, 1192×180 → Shipment Change Request
- **하단 Panel2**
  - `panel3`: Dock=Top, 1192×179
    - `usrLayoutControl2`: Dock=Fill, 432×179 → 버튼 영역
    - `panel1` → `usrLayoutControl3` 변경요청 정보 영역 (panel1의 Dock과 좌/우 배치는 truncated라 확인 필요)
  - `spdSub`: Dock=Fill, 1192×213 → Change Request

## 3. 시트별 Grid 컬럼

### 3-1. `Shipment Change Request` (spdMain, 헤더 1행, 메타 36/0)

| 컬럼 | 라벨(메타) | 40 / EE | 그 외 division | 비고 |
|---|---|---|---|---|
| ATTRIBUTE10 | ATTRIBUTE10 | 표시 | 표시 | |
| CHANGE_REASON_CODE | Change Reason | 표시 | 표시 | |
| CHANGE_REASON_DETAIL | Reason Detail | 표시 | 표시 | |
| CONFIRM_ID | Confirm/Plan ID | 표시 | 표시 | ChangeType "P" → Width 0, 그 외 120 |
| DIVISION_ID | Div | 표시 | 표시 | 콤보 = MyDivision(EE 제외) |
| EDIT_MAIN | EDIT_MAIN | 표시 | 표시 | |
| END_CUSTOMER | End Customer* | **표시** | **숨김** | 코드 InitSpread:630/641, ComboSelChange:5668/5677 |
| ERP_ATTR1 | Consignee Name | **표시** | **숨김** | InitSpread:635/646 |
| ERP_ATTR2 | Contact Point | **표시** | **숨김** | |
| ERP_ATTR3 | Lot | **표시** | **숨김** | |
| ERP_SO_NO | SO No | 표시 | 표시 | ChangeType "P" → Width 0, 그 외 100 |
| ETA / ETD | ETA / ETD | 표시 | 표시 | |
| FCST_TYPE | FCST Type* | 표시 | 표시 | |
| FROM_SITE | From Site ID | 표시 | 표시 | |
| FROM_SITE_DESCRIPTION | From Site* | 표시 | 표시 | 콤보 = GetPlantSiteByDivisionEEOperation |
| INCOTERMS | Incoterms* | 표시 | 표시 | |
| ITEM_ID | Model* | 표시 | 표시 | |
| LT_DAY | L/T(Day) | 표시 | 표시 | |
| MTK_OWNER | MKT Owner | 표시 | 표시 | |
| NICK_NAME | Nick Name | 표시 | 표시 | |
| PROJECT_CODE | Project Code* | **숨김** | **표시** | InitSpread:631/642 |
| PROJECT_NAME | Project Name | **숨김** | **표시** | InitSpread:632/643 |
| REMARKS / REMARKS2 / REMARKS3 | Remarks / Building / Customer Requirement | 표시 | 표시 | |
| REQUEST_DATE | Request Date | 표시 | 표시 | |
| REQUESTOR | Shipment Requestor | 표시 | 표시 | |
| SHIPMENT_CONFIRM_QTY | Shipment Qty* | 표시 | 표시 | |
| SHIPMENT_DATE | Shipment Date* | 표시 | 표시 | |
| SHIPMENT_STATUS | Status | 표시 | 표시 | |
| TO_SITE | To Site ID | 표시 | 표시 | |
| TO_SITE_DESCRIPTION | To Site* | 표시 | 표시 | 콤보 = Data_SCP.Common(…) |
| TO_SITE_SHIPTO_CODE / TO_SITE_SOLDTO_CODE | Ship to / Sold to | 표시 | 표시 | |
| TRANSPORT_MODE | Trans Mode* | 표시 | 표시 | 콤보 = CommonDataList[TransMode] |

- 메타 숨김 컬럼(정의만 있음): BOD_ID, CHANGE_REQ_NO, CHANGE_TYPE, CHECK_NEED_YN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, Expected_Shipping_Date, MODEL_USER, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, SHIPTO_DESCRIPTION, SOLDTO_DESCRIPTION, TEAM, UPDATED_BY, UPDATED_DATE
- 최종 표시 컬럼 수: **40/EE 34개, 그 외 32개**
- CHK 컬럼은 grid_effective에서 이 시트에 귀속돼 있지만, 근거 코드(SetChangeRequestSOGrid:2294)는 siSub 대상입니다. **확인 필요**

### 3-2. `Change Request` (spdSub, 헤더 2행, 메타 26/0)

| 컬럼 | 라벨(메타) | 표시 | 비고 |
|---|---|---|---|
| CHK | ALL | 표시 | CheckBox(672~674), 헤더 클릭 전체 선택(5505~5544), sSearchType=="Exist" 시 숨김(2294) |
| CHANGE_REQ_NO | Change Req.No | 표시 | |
| CONFIRM_ID | Confirm id | 표시 | |
| ERP_SO_NO | SO No | ChangeType "P" → 숨김, 그 외 → 표시 | 701/723 |
| ITEM_ID / NICK_NAME | Model / Nick Name | 표시 | |
| FCST_TYPE | FCST Type | 표시 | |
| FROM_SITE_DESCRIPTION / TO_SITE_DESCRIPTION | From Site / To Site | 표시 | |
| INCOTERMS | Incoterms | 표시 | |
| PROJECT_NAME | Project Name | 40/EE 숨김(?) · 그 외 표시(?) | 귀속 추정 — 확인 필요 |
| PROJECT_CODE | Project Code | 메타 숨김 → 그 외 division 표시(?) | 귀속 추정 — 확인 필요 |
| END_CUSTOMER | — | CODE_ONLY_CHANGE, 40/EE 표시(?) | 메타 미정의, 귀속 추정 — 확인 필요 |
| (기존) LT_DAY, ETD, ETA, TRANSPORT_MODE, SHIPMENT_DATE, SHIPMENT_CONFIRM_QTY | L/T(Day), ETD, ETA, Trans Mode, Shipment Date, Qty | 표시 | 상위 Span "Plan"("P") / "Confirmed"(그 외), 6열 |
| (변경) NEW_LT_DAY, NEW_ETD, NEW_ETA, NEW_TRANSPORT_MODE, NEW_SHIPMENT_DATE, NEW_SHIPMENT_CONFIRM_QTY | L/T(Day), ETD, ETA, Trans Mode, Shipment Date*, Qty* | 표시 | 상위 Span "Confirm"("P") / "Change"(그 외), 6열 |
| REMARKS | Remarks | Width=0 (696) | 사실상 숨김 |
| REMARKS2 / REMARKS3 | Building / Customer requirement | 표시 | |

- 메타 숨김 컬럼: A_COUNTRY, A_PORT_CODE, BOD_ID, CUSTOMER_LT, D_COUNTRY, D_PORT_CODE, DIVISION_ID, ELECTRODE_TYPE, ELECTRODE_YN, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BASE_CONFIRM_YN, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_INCOTERMS, NEW_ROUTE_ID, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_YN, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, PLAN_CONFIRM_ID, ROUTE_ID, TO_CITY, TO_COUNTRY, TO_SITE
- 최종 표시 컬럼 수(grid_effective): **40/EE 25개(?5), 그 외 26개(?5)**

## 4. 시트 연결 규칙
- 두 시트 모두 `META+코드연결`입니다. 메타 시트명을 코드가 `AddSheet`/`ChangeSheet`에서 그대로 사용합니다.
- 상단 `Shipment Change Request`는 `SSP0200_GET_SHIPMENT_CHANGE_REQUEST`로, 하단 `Change Request`는 `SSP0200_GET_SHIPMENT_REQUEST_DRAFTING`으로 조회합니다. 두 조회는 FindButton 한 번에 함께 호출됩니다.
- 상단 행 선택이 하단을 필터링하는 마스터-디테일 구조인지는 Fact Pack에 근거가 없습니다(SpdMain_CursorChanged 내부 미추출). **확인 필요**
- 하단 `SetChangeRequestSOGrid`(2268~2294)는 spdSub 행 루프에서 Ship Status("R")와 sSearchType("Exist")로 CHK 표시를 제어합니다.
