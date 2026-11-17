# SSP0201 컨트롤 → React/Wijmo 매핑

> 라벨은 props.csv에 있는 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다. props.csv가 일부 잘려서(28,634자 생략) 라벨을 확인하지 못한 항목은 **확인 필요**로 표시했습니다.
> 매핑 컴포넌트는 NSCM 공용 컴포넌트를 확정한 것이 아니라 Wijmo/React 계열의 후보입니다.

## 1. 화면 배치

| 컨테이너 | 속성(원문) | 해석 |
|---|---|---|
| splitContainer1 | Dock=Fill, Orientation=Horizontal, Size=1192×649, SplitterDistance=253 | **상/하 분할**. 상단 253px(253/649 ≈ 39.0%), 하단 나머지(≈ 61.0%) |
| 상단 Panel1 | usrConditionPanel1 (Dock=Top, 1192×69, HidePanel) + spdMain (Dock=Fill, 1192×184) | 조회조건 69px(상단 영역의 ≈27.3%) / 메인 그리드 184px(≈72.7%) |
| 하단 Panel2 | panel3 (Dock=Top, 1192×179) + spdSub (Dock=Fill, 1192×213) | 요청 정보·버튼 영역 179px(≈45.7%) / 하위 그리드 213px(≈54.3%) |
| panel3 내부 | usrLayoutControl2 (Dock=Fill, 432×179), panel1 → usrLayoutControl3 | 버튼 그룹(usrLayoutControl2)과 요청 정보 입력(usrLayoutControl3)이 좌우로 놓인 것으로 보이나, panel1의 Dock·Size는 잘린 props에 있어 **확인 필요** |

- 하단 높이 합(179+213=392)과 649−253=396 사이에 4px 차이가 있습니다. 이것이 스플리터 폭인지는 Fact Pack에 SplitterWidth 값이 없어 **확인 필요**입니다.

## 2. 컨트롤 매핑

### 2-1. 조회조건 (usrConditionPanel1 → usrLayoutControl1)

| 컨트롤 | AS-IS 유형 | 라벨(원문) | React/Wijmo 후보 | 비고 |
|---|---|---|---|---|
| clbDivision_ID | UsrCombo | "Div" (layoutControlItem8) | ComboBox (단일 선택) | 이름은 clb이지만 유형은 UsrCombo. `SelectedIndexChanged` 연결 |
| clbFromSite | UsrCheckedList | "From Site" (layoutControlItem7) | MultiSelect | GetCheckedListValue 대상으로 추정 — **확인 필요** |
| clbToSite | UsrCheckedList | "To Site" (layoutControlItem3) | MultiSelect | 위와 같음 |
| drpPeriod | UsrDateRangePicker | "Shipment Date" (layoutControlItem1) | InputDate ×2 (기간) | 초기값은 GetDayRange(`SCP.SCM0001_GET_SCP_DAY_PERIOD`) |
| cboStatus | UsrCombo | "Status" (PlanType) | ComboBox | 항목 출처 **확인 필요** |
| cboChangeType | UsrCombo | "Change Type" (PlanType1) | ComboBox | 값 "P"/그 외에 따라 그리드 헤더·컬럼이 바뀜. `SelectedIndexChanged` → GetDayRange |
| txtConfirmId | UsrMultiLineEditor | "Confirm Id" (layoutControlItem11) | 멀티라인 입력(팝업형 텍스트) | |
| txtSoNo | UsrMultiLineEditor | "SO No" (lblSONo) | 멀티라인 입력 | Designer Visible=false |
| txtRequest | UsrMultiLineEditor | 라벨 미추출 (항목명 `Model`) | 멀티라인 입력 | Text 속성이 추출되지 않음 → **확인 필요** |
| btnItemId | UsrButton | 라벨 없음 (layoutControlItem2) | Button(팝업 호출) | `btnItemId_Click` |
| txtItemId | UsrMultiLineEditor | — | — | controls.csv에서 parent 공란 → 배치 **확인 필요** |
| btnNew | UsrButton | Text "NEW" (항목 Text "layoutControlItem5") | Button | `BtnNew_Click` |
| btnChangeRe | SimpleButton | Text "Request Complete" (항목 lcChgReq, Text "layoutControlItem10") | Button | `BtnChangeRe_Click` |

### 2-2. 버튼 영역 (panel3 → usrLayoutControl2)

| 컨트롤 | AS-IS 유형 | Text(원문) | Designer Visible | React 후보 | 이벤트 |
|---|---|---|---|---|---|
| btnChangeRe2 | SimpleButton | "Request Complete" | (지정 없음) | Button | `BtnChangeRe_Click` |
| btnSave | SimpleButton | "Save Draft" | false | Button | `BtnSave_Click` |
| btnCancel | SimpleButton | "Cancel" | (지정 없음) | Button | `BtnCancel_Click` |
| btnDel | SimpleButton | "Delete" | (지정 없음) | Button | 배선 없음 — **확인 필요** |
| btnAdd | SimpleButton | "Add Date" | false | Button | 배선 없음 — **확인 필요** |
| dtDate | UsrDatePicker | — | false | InputDate | — |

- 레이아웃 항목 lcAdd, lcDel, lcCancel, lcDate, lcChgReq2, lcSave의 Text·Control 연결은 잘린 props에 있어 **확인 필요**입니다.

### 2-3. 변경 요청 정보 (panel1 → usrLayoutControl3)

| 컨트롤 | AS-IS 유형 | 바인딩 추정 근거 (SetChangeRequestInfo dt.Rows[0]) | React 후보 |
|---|---|---|---|
| txtRequestNo | TextBox | CHANGE_REQ_NO | Input(읽기전용 여부 **확인 필요**) |
| txtTitle | TextBox | REQUEST_TITLE | Input |
| txtRequestor | TextBox | REQUEST_USER / REQUEST_USER_NAME | Input |
| txtRequestDeptName | TextBox | REQUEST_DEPT / REQUEST_DEPT_NAME | Input |
| txtApproval | TextBox | APPROVAL_USER / APPROVAL_USER_NAME | Input |
| btnApprovalUser | UsrButton | — (`BtnApprovalUser_Click`) | Button(사용자 선택 팝업 — **확인 필요**) |
| txtAppDeptName | TextBox | APPROVAL_DEPT / APPROVAL_DEPT_NAME | Input |
| cboChangeReason | UsrComboBox | CHANGE_REASON_CODE | ComboBox |
| txtReasonDetail | TextBox | CHANGE_REASON_DETAIL | Input/TextArea |
| usrLabel2 | UsrLabel | — | Label |

- 컬럼과 컨트롤의 대응은 컬럼명과 컨트롤명이 비슷한 데서 나온 추정입니다. 실제 대입 코드(SetChangeRequestInfo 1986~1997)의 대상 컨트롤은 **확인 필요**입니다.
- 항목 layoutControlItem4/5/6/9/10, lcTitle, lcChangeReason, lcApproval, lcReasonDetail, lcAppDept의 Text는 잘린 props에 있어 **확인 필요**입니다.

### 2-4. 그리드

| 컨트롤 | 시트 | 위치 | React/Wijmo 후보 |
|---|---|---|---|
| spdMain (spdMain_Sheet1) | `Shipment Change Request` | 상단 Panel1 | FlexGrid (헤더 1행) |
| spdSub (spdSub_Sheet1) | `Change Request` | 하단 Panel2 | FlexGrid (헤더 2행, ColumnHeaderSpan 병합) |

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

규칙: 메타 `VISIBLE_FLAG·VALID_YN='Y'`에 해당하는 컬럼이 기본 표시이고, 코드 변경이 마지막에 →숨김이면 제외합니다. `?`는 런타임에 결정되는 분기입니다.

### 3-1. `Shipment Change Request` (spdMain, 메타 65행, 기본 표시 33)

**기본 표시 컬럼 (33)**

| 컬럼 | 라벨(메타) | division 차이 / 코드 변경 |
|---|---|---|
| ATTRIBUTE10 | ATTRIBUTE10 | |
| CHANGE_REASON_CODE | Change Reason | |
| CHANGE_REASON_DETAIL | Reason Detail | |
| CONFIRM_ID | Confirm/Plan ID | ChangeType "P" → Width 0, 그 외 Width 120 |
| DIVISION_ID | Div | 셀 콤보 ← GetSSPInnerTable("MyDivision"), EE 제외 |
| EDIT_MAIN | EDIT_MAIN | |
| END_CUSTOMER | End Customer* | **40·EE만 표시**, 그 외 숨김 |
| ERP_SO_NO | SO No | ChangeType "P" → Width 0 |
| ETA | ETA | |
| ETD | ETD | |
| FCST_TYPE | FCST Type* | |
| FROM_SITE | From Site ID | |
| FROM_SITE_DESCRIPTION | From Site* | 셀 콤보 ← Data.UserPlantSiteByDivisionOspPack |
| INCOTERMS | Incoterms | |
| ITEM_ID | Model* | |
| LT_DAY | L/T(Day) | |
| MTK_OWNER | MKT Owner | |
| NICK_NAME | Nick Name | |
| PROJECT_CODE | Project Code* | **40·EE 숨김**, 그 외 표시 |
| PROJECT_NAME | Project Name | **40·EE 숨김**, 그 외 표시 |
| REMARKS | Remarks | |
| REMARKS2 | Building | |
| REMARKS3 | Customer Requirement | |
| REQUEST_DATE | Request Date | |
| REQUESTOR | Shipment Requestor | |
| SHIPMENT_CONFIRM_QTY | Shipment Qty* | |
| SHIPMENT_DATE | Shipment Date* | |
| SHIPMENT_STATUS | Status | |
| TO_SITE | To Site ID | |
| TO_SITE_DESCRIPTION | To Site* | 셀 콤보 ← Data_SCP.Common(ShipmentPlanToSite / ToSiteByDivisionEEForSSP) |
| TO_SITE_SHIPTO_CODE | Ship to | 셀 콤보 ← CommonDataList [ShipToCodeByDivision] |
| TO_SITE_SOLDTO_CODE | Sold to | |
| TRANSPORT_MODE | Trans Mode* | 셀 콤보 ← CommonDataList [TransMode] |

**숨김 컬럼 (32, 메타 숨김)**: BOD_ID, CHANGE_REQ_NO, CHANGE_TYPE, CHECK_NEED_YN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, Expected_Shipping_Date, MODEL_USER, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, SHIPTO_DESCRIPTION, SOLDTO_DESCRIPTION, TEAM, UPDATED_BY, UPDATED_DATE

**코드 전용 변경**: CHK (메타 행 없음, CODE_ONLY_CHANGE → 숨김?)

**division별 표시 수**: 40·EE = 31, 81·81_HD·81_HG·81_HM·81_ST·81_UC·82·EE_HD·EE_HG·EE_HM·EE_ST·EE_UC = 32 (각 ?4)

### 3-2. `Change Request` (spdSub, 메타 58행, 기본 표시 28)

**기본 표시 컬럼 (28)**

| 컬럼 | 라벨(메타) | 코드 변경 |
|---|---|---|
| CHK | ALL | 체크박스 셀(608~610). SetChangeRequestSOGrid에서 조건부 숨김(2061) |
| CHANGE_REQ_NO | Change Req.No | |
| CONFIRM_ID | Confirm id | |
| ERP_SO_NO | SO No | ChangeType "P" → 숨김, 그 외 표시 |
| FCST_TYPE | FCST Type | |
| FROM_SITE_DESCRIPTION | From Site | |
| TO_SITE_DESCRIPTION | To Site | |
| ITEM_ID | Model | |
| NICK_NAME | Nick Name | |
| PROJECT_NAME | Project Name | grid_effective: 40·EE →숨김?, 그 외 →표시? (§5 확인 필요) |
| SHIPTO_CODE | ShipTo Code | |
| INCOTERMS | Incoterms | |
| LT_DAY | L/T(Day) | 2단 헤더 그룹 시작 ("Plan"/"Confirmed") |
| ETD | ETD | 그룹 |
| ETA | ETA | 그룹 |
| TRANSPORT_MODE | Trans Mode | 그룹 |
| SHIPMENT_DATE | Shipment Date | 그룹 |
| SHIPMENT_CONFIRM_QTY | Qty | 그룹 |
| NEW_LT_DAY | L/T(Day) | 2단 헤더 그룹 시작 ("Confirm"/"Change") |
| NEW_ETD | ETD | 그룹 |
| NEW_ETA | ETA | 그룹 |
| NEW_TRANSPORT_MODE | Trans Mode | 그룹 |
| NEW_SHIPMENT_DATE | Shipment Date* | 그룹 |
| NEW_SHIPMENT_CONFIRM_QTY | Qty* | 그룹 |
| NEW_SHIPTO_CODE | ShipTo Code | |
| REMARKS | Remarks | **Width=0 (619)** — 화면에서는 안 보일 수 있음 |
| REMARKS2 | Building | |
| REMARKS3 | Customer requirement | |

(표의 컬럼 순서는 표시 순서가 아닙니다. 실제 순서는 메타 정렬 기준이며, 정렬 컬럼이 Fact Pack에 없어 **확인 필요**입니다.)

**2단 헤더(ColumnHeaderSpan) 원문**

| 0행 그룹 (시작 컬럼, 7열 병합) | ChangeType = "P" | ChangeType ≠ "P" |
|---|---|---|
| LT_DAY | "Plan" | "Confirmed" |
| NEW_LT_DAY | "Confirm" | "Change" |

1행 헤더(공통): L/T(Day), ETD, ETA, Trans Mode, Shipment Date, Qty / L/T(Day), ETD, ETA, Trans Mode, Shipment Date*, Qty*

- 0행은 7열 병합이지만 1행 라벨은 각 그룹에 6개만 추출되었습니다. 남은 1열이 무엇인지 **확인 필요**입니다.

**숨김 컬럼 (30, 메타 숨김)**: A_COUNTRY, A_PORT_CODE, BOD_ID, CUSTOMER_LT, D_COUNTRY, D_PORT_CODE, DIVISION_ID, ELECTRODE_TYPE, ELECTRODE_YN, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BASE_CONFIRM_YN, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_INCOTERMS, NEW_ROUTE_ID, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_YN, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, PLAN_CONFIRM_ID, PROJECT_CODE, ROUTE_ID, TO_CITY, TO_COUNTRY, TO_SITE

**코드 전용 변경**: END_CUSTOMER (메타 행 없음, 40·EE →표시?, 그 외 →숨김?)

**division별 표시 수**: 40·EE = 27, 그 외 12개 division = 28 (각 ?5)

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 근거 |
|---|---|---|
| `Shipment Change Request` | META+코드연결 | AddSheet(523) + SetSheetHeaderColumn(546) |
| `Change Request` | META+코드연결 | AddSheet(527) + ChangeSheet(537) + SetSheetHeaderColumn(599) |

- 상·하 그리드 연동: 조회 시 `FindData_Main`이 상단, `FindData_Sub_Draft`가 하단을 채웁니다. `FindData_Sub_Draft`는 ds.Tables[1]에서 요청자 정보(USER_ID, DEPT_ID, USER_NAME, DEPT_NAME_KO, USER_NAME_EN, DEPT_NAME_EN)를 읽습니다.
- 상단 행 선택이 하단에 반영되는지(마스터-디테일 여부)는 Fact Pack에 근거가 없어 **확인 필요**입니다. `SpdMain_CursorChanged`, `SpdMain_CellDoubleClick`의 동작이 미추출이기 때문입니다.
