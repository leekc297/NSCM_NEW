# SSP0003 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

라벨은 props.csv의 `LayoutControlItem.Text` 또는 컨트롤 `Text` 원문입니다. props.csv가 잘려 원문을 볼 수 없는 라벨은 **확인 필요**로 표시했습니다.

### 1-1. 조회조건 영역 (usrConditionPanel1 → usrLayoutControl1)

| AS-IS 컨트롤 | 유형 | LayoutItem | 라벨(원문) | TO-BE 후보 |
|---|---|---|---|---|
| clbDivision | UsrCheckedList | lcDivision | "Division" | 다중 선택 콤보 (Wijmo MultiSelect 계열) |
| clbFromSite | UsrCheckedList | layoutControlItem7 | "From Site" | 다중 선택 콤보 |
| drpPeriod | UsrDateRangePicker | layoutControlItem1 | "Request Date" | 기간(From~To) 날짜 입력 |
| cboStatus | UsrCombo | PlanType | "Status" | 단일 선택 콤보 |
| cboChangeType | UsrCombo | PlanType1 | "Change Type" | 단일 선택 콤보 |
| txtRequest | UsrMultiLineEditor | Requestor | 확인 필요 (LayoutItem 이름은 Requestor) | 텍스트 입력 + 검색 버튼 |
| btnRequestUser | UsrButton | layoutControlItem13 | Text "layoutControlItem2"(TextVisible 여부 확인 필요) | 사용자 검색 팝업 버튼 후보 |
| txtItemID | UsrMultiLineEditor | Model | 확인 필요 (LayoutItem 이름은 Model) | 텍스트 입력 + 검색 버튼 |
| btnItemId | UsrButton | layoutControlItem2 | 확인 필요 | 품목 검색 팝업 버튼 후보 |
| btnApproval | SimpleButton | lcBtnApproval | "Approval" | 액션 버튼 |
| btnReject | SimpleButton | lcBtnReject | "Reject" | 액션 버튼 |
| btnSelfReject | SimpleButton | lcSelfReject | "Self Reject" | 액션 버튼 |

### 1-2. 하단 요청 정보 패널 (panel1 → usrLayoutControl3)

| AS-IS 컨트롤 | 유형 | 속성 | 라벨 | TO-BE 후보 |
|---|---|---|---|---|
| txtRequestNo | TextBox | ReadOnly | 확인 필요 | 읽기 전용 입력 |
| txtTitle | TextBox | ReadOnly | 확인 필요 (LayoutItem lcTitle/lcTitle1 존재) | 읽기 전용 입력 |
| txtRequestor | TextBox | ReadOnly | 확인 필요 | 읽기 전용 입력 |
| txtRequestDeptName | TextBox | 확인 필요 | 확인 필요 | 입력 |
| txtApproval | TextBox | 확인 필요 | 확인 필요 (LayoutItem lcApproval) | 입력 |
| txtAppDeptName | TextBox | 확인 필요 | 확인 필요 | 입력 |
| txtChangeReason | TextBox | 확인 필요 | 확인 필요 | 입력 |
| txtReasonDetail | TextBox | 확인 필요 | 확인 필요 (LayoutItem lcReasonDetail) | 입력 |
| txtRejectReason | TextBox | 확인 필요 | 확인 필요 | 반려 사유 입력 후보 |
| usrLabel2 | UsrLabel | — | 확인 필요 | 라벨 |

`SetChangeRequestInfo`(줄 852~859)가 이 패널을 채우는 것으로 보입니다. 이 메서드는 CHANGE_REQ_NO, REQUEST_TITLE, REQUEST_USER, REQUEST_DEPT, APPROVAL_USER, CHANGE_REASON_CODE, CHANGE_REASON_DETAIL, APPROVAL_DEPT_NAME을 읽습니다. 컬럼과 TextBox의 1:1 대응은 확인 필요입니다.

### 1-3. Grid

| AS-IS 컨트롤 | 시트 | TO-BE 후보 |
|---|---|---|
| spdMain (FpSpread) | `Shipment Change Request Confirm` | Wijmo FlexGrid (마스터) |
| txtApprovalDeptName (FpSpread, 이름과 달리 Spread) | `Shipment Change Request Confirm Detail` | Wijmo FlexGrid (상세, 2행 헤더) |

## 2. 화면 배치

- **splitContainer1**: Dock Fill, Orientation Horizontal(상/하 분할), Size 1192×649, SplitterDistance 259
  - 상단 Panel1은 259px입니다. 전체 649 중 약 39.9%입니다.
    - usrConditionPanel1: Dock Top, 67px, HidePanel
    - spdMain: Dock Fill, 192px
  - 하단 Panel2는 나머지 높이입니다. SplitterWidth 값이 Fact Pack에서 확인되지 않아, 649−259=390px(약 60.1%)에서 분할선 폭을 뺀 값입니다.
    - panel1(요청 정보): Dock Top, 209px
    - splitter1: Dock Top, 3px
    - txtApprovalDeptName(Detail Grid): Dock Fill, 174px
- 좌/우 분할은 없습니다.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

### 3-1. `Shipment Change Request Confirm` (메타 22행, 표시 19, 모든 Division 동일)

| 컬럼 | 라벨 | 표시 |
|---|---|---|
| CHANGE_REQ_NO | Request No | 기본 |
| REQUEST_TITLE | Title | 기본 |
| CHANGE_TYPE | Change Type | 기본 |
| SHIPMENT_STATUS | Status | 기본 |
| DIVISION_ID | Division | 기본 |
| FROM_SITE | From Site | 기본 |
| TO_SITE | To Site | 기본 |
| ITEM_ID | Model | 기본 |
| NICK_NAME | Nick Name | 기본 |
| CHANGE_REASON_CODE | Change Reason | 기본 |
| REJECT_REASON | Reject Reason | 기본 |
| REQUEST_USER_NAME | Requestor | 기본 |
| REQUEST_DEPT | Requestor Dept Name | 기본 |
| REQUEST_TIME | Request Date | 기본 |
| APPROVAL_USER_NAME | Approval | 기본 |
| APPROVAL_DEPT | Approval Dept Name | 기본 |
| APPROVAL_TIME | Approval Date | 기본 |
| DELEGATEE_USER_NAME | Delegatee | 기본 |
| DELEGATEE_DEPT | Delegatee Dept Name | 기본 |
| REQUEST_USER | Requestor | 숨김 |
| APPROVAL_USER | Approval | 숨김 |
| DELEGATEE_USER | Delegatee | 숨김 |
| ERP_SO_NO | (라벨 없음) | CODE_ONLY_CHANGE. 이 시트에 귀속된 근거는 확인 필요 |

- 위 표의 컬럼 순서는 표시 순서가 아닙니다. 실제 순서는 메타 `SCM_MST_SHEET_COLUMNS`를 기준으로 확인해야 합니다.

### 3-2. `Shipment Change Request Confirm Detail` (메타 54행, 표시 29, 헤더 2행)

**표시 컬럼 (29)**

| 컬럼 | 라벨 | 비고 |
|---|---|---|
| CHK | ALL | 코드: CheckBox CellType, Value=true, bevel Border |
| CONFIRM_ID | Confirm ID | |
| ERP_SO_NO | SO No | 코드: `_sChangeType=="P"`이면 숨김, 그 외 표시 (?) |
| FCST_TYPE | FCST Type | |
| PROJECT_NAME | Project Name | |
| ITEM_ID | Model | |
| FROM_SITE_DESCRIPTION | From Site | |
| TO_SITE_DESCRIPTION | To Site | |
| INCOTERMS | Incoterms | |
| LT_DAY | L/T(Day) | 그룹 헤더 "Plan" 또는 "Confirmed" 시작 열 |
| ETD | ETD | |
| ETA | ETA | |
| TRANSPORT_MODE | Trans Mode | |
| SHIPMENT_DATE | Shipment Date | |
| SHIPMENT_CONFIRM_QTY | Qty | |
| NEW_LT_DAY | L/T(Day) | 그룹 헤더 "Confirm" 또는 "Change" 시작 열 |
| NEW_ETD | ETD | |
| NEW_ETA | ETA | |
| NEW_TRANSPORT_MODE | Trans Mode | |
| NEW_SHIPMENT_DATE | Shipment Date* | |
| NEW_SHIPMENT_CONFIRM_QTY | Qty* | |
| ERP_ATTR1 | Consignee Name | |
| ERP_ATTR2 | Contact Point | |
| ERP_ATTR3 | Lot | |
| REMARKS | Remarks | |
| REMARKS2 | Building | |
| REMARKS3 | Customer requirement | |
| STATUS_DETAIL | Status Detail | |
| REJECT_REASON | Reject Reason | |

**숨김 컬럼 (25)**: A_COUNTRY, A_PORT_CODE, BOD_ID, CHANGE_REQ_NO, CUSTOMER_LT, D_COUNTRY, D_PORT_CODE, DIVISION_ID, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BASE_CONFIRM_YN, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_INCOTERMS, NEW_ROUTE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_YN, ROUTE_ID, TO_CITY, TO_COUNTRY, TO_SITE

**2행 헤더 (ColumnHeaderSpan, InitSpread 477~520)**

| 조건 | 0행 LT_DAY부터 6열 | 0행 NEW_LT_DAY부터 6열 | ERP_SO_NO |
|---|---|---|---|
| `_sChangeType == "P"` | "Plan" | "Confirm" | 숨김 |
| 그 외 | "Confirmed" | "Change" | 표시 |

- 1행 헤더는 두 경우 모두 같습니다: L/T(Day), ETD, ETA, Trans Mode, Shipment Date / Shipment Date*, Qty / Qty*. 각 헤더는 2행에 걸쳐 span됩니다.

**Division별 표시 차이**: 40, 81 계열, 82, EE 계열 모두 19개(Main)와 29개(Detail, ?1=ERP_SO_NO)로 같습니다. Division별 차이는 없습니다.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 연결 동작 |
|---|---|---|
| Shipment Change Request Confirm | META+코드연결 | FindButton → FindData_Main(`SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM`) |
| Shipment Change Request Confirm Detail | META+코드연결 | 마스터 `SpdMain_CellDoubleClick` → FindData_Sub(`SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`) + Delegate_Load(`SSP.SSP0003_GET_DELEGATEE_LOAD`) |

- 마스터→상세 연결은 더블클릭으로 일어납니다. 행 선택 변경으로는 연결되지 않습니다.
- 상세 조회 키 파라미터는 Fact Pack에 없습니다(확인 필요).
- FindData_Sub:827에서 `p_status` 값에 따라 상세 Grid 0번 컬럼(CHK로 추정)을 숨깁니다. 그 외 분기의 처리는 확인 필요입니다.
