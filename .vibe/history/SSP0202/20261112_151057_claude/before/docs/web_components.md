# SSP0202 화면 구성 → React / Wijmo 매핑

## 1. 화면 배치 (props.csv)

| 컨테이너 | 속성(원문) | 해석 |
|---|---|---|
| splitContainer1 | Orientation = Horizontal, Size = (1192, 649), SplitterDistance = 259, Dock Fill | **상/하 분할**. 상단 259 / 전체 649 = **약 39.9%**, 하단 약 60.1% |
| ├ Panel1(상) usrConditionPanel1 | Dock Top, Size (1192, 67), UsrPanelType = HidePanel | 조회조건 영역 (높이 67) |
| ├ Panel1(상) spdMain | Dock Fill, Size (1192, 192) | Main Grid (67 + 192 = 259) |
| ├ Panel2(하) panel1 → usrLayoutControl3 | Dock Top, Size (1192, 209) | 요청 상세 정보 폼 (높이 209) |
| ├ Panel2(하) splitter1 | Dock Top, Size (1192, 3) | 폼과 Detail Grid 사이 스플리터 |
| └ Panel2(하) txtApprovalDeptName (FpSpread) | Dock Fill, Size (1192, 174) | Detail Grid (컨트롤 이름은 txt*이지만 FpSpread임) |

하단 패널 높이 합계는 209 + 3 + 174 = 386입니다. 전체 649 − 259 = 390과 4px 차이가 나며, 이는 SplitContainer 분할선 몫입니다(SplitterWidth는 props에 값이 없음).

## 2. 컨트롤 → 컴포넌트 매핑

### 2-1. 조회조건 영역 (usrLayoutControl1)

| AS-IS 컨트롤 | 유형 | 라벨(LayoutControlItem.Text / 컨트롤 Text 원문) | Size | TO-BE 후보 |
|---|---|---|---|---|
| clbDivision | UsrCheckedList | "Division" (lcDivision) | 246×21 | 멀티 선택 콤보 (Wijmo MultiSelect 계열 공통 컴포넌트) |
| drpPeriod | UsrDateRangePicker | "Request Date" (layoutControlItem1) | 210×20 | 기간 선택(From~To) 공통 컴포넌트 |
| clbFromSite | UsrCheckedList | "From Site" (layoutControlItem7) | 199×21 | 멀티 선택 콤보 |
| cboStatus | UsrCombo | "Status" (LayoutControlItem 이름 `PlanType`) | 198×20 | 단일 콤보 (Wijmo ComboBox 계열) |
| cboChangeType | UsrCombo | "Change Type" (LayoutControlItem 이름 `PlanType1`) | 141×20 | 단일 콤보 |
| txtRequest | UsrMultiLineEditor | LayoutControlItem 이름 `Requestor` (Text 값은 Fact Pack에서 잘려 있음, 확인 필요) | 154×21 | 멀티라인 입력 + 팝업 버튼 |
| btnRequestUser | UsrButton | layoutControlItem13 Text "layoutControlItem2" (TextVisible 여부 확인 필요) | 39×24 | 사용자 검색 팝업 버튼 |
| txtItemID | UsrMultiLineEditor | LayoutControlItem 이름 `Model` (Text 값은 잘려 있음, 확인 필요) | 136×21 | 멀티라인 입력 + 팝업 버튼 |
| btnItemId | UsrButton | layoutControlItem2 (Text 확인 필요) | 39×24 | 품목 검색 팝업 버튼 |
| btnApproval | SimpleButton | "Approval" (lcBtnApproval Text "layoutControlItem10") | 105×22 | 화면 버튼 (menu-button 동적 조회 대상) |
| btnReject | SimpleButton | "Reject" (lcBtnReject Text "layoutControlItem10") | 105×22 | 화면 버튼 |
| btnSelfReject | SimpleButton | "Self Reject" (lcSelfReject Text "layoutControlItem10") | 105×22 | 화면 버튼 |

### 2-2. 요청 상세 폼 (usrLayoutControl3, panel1 내부)

| AS-IS 컨트롤 | 유형 | 라벨 원문 | ReadOnly(props) | Size | TO-BE 후보 |
|---|---|---|---|---|---|
| usrLabel2 | UsrLabel | "Request Confirm Detail" | - | 733×20 | 섹션 타이틀 |
| txtRequestNo | TextBox | "Request No" (layoutControlItem5) | true | 644×24 | 읽기 전용 Input |
| txtTitle | TextBox | 확인 필요 (lcTitle 또는 lcTitle1 추정, Text 잘림) | true | 259×24 | 읽기 전용 Input |
| txtRequestor | TextBox | 확인 필요 (layoutControlItem4, Text 잘림) | true | 259×24 | 읽기 전용 Input |
| txtRequestDeptName | TextBox | 확인 필요 | true | 292×20 | 읽기 전용 Input |
| txtApproval | TextBox | 확인 필요 (lcApproval 추정) | true | 259×24 | 읽기 전용 Input |
| txtAppDeptName | TextBox | 확인 필요 | true | 292×20 | 읽기 전용 Input |
| txtChangeReason | TextBox | 확인 필요 | true | 292×20 | 읽기 전용 Input |
| txtReasonDetail | TextBox | 확인 필요 (lcReasonDetail 추정) | true | 644×24 | 읽기 전용 Input |
| txtRejectReason | TextBox | 확인 필요 | **ReadOnly 행 없음** (입력 가능 여부 확인 필요) | 644×24 | Input (반려 사유 입력 여부 확인 필요) |

라벨 원문이 "확인 필요"인 행이 있습니다. props.csv가 Fact Pack에서 10,890자 잘려서 layoutControlItem6, 9, 10, 3, lcApproval, lcReasonDetail, lcTitle, lcTitle1의 Text를 볼 수 없기 때문입니다. 전체 props.csv를 열어 확인해야 합니다.

### 2-3. Grid

| AS-IS | 시트 | TO-BE |
|---|---|---|
| spdMain (FpSpread) | `Shipment Change Request Confirm` | Wijmo FlexGrid — 메타(SCM_MST_SHEET_COLUMNS) 기반, 헤더 1행 |
| txtApprovalDeptName (FpSpread) | `Shipment Change Request Confirm Detail` | Wijmo FlexGrid — 메타 기반, 헤더 2행(병합 헤더) |

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

### 3-1. Shipment Change Request Confirm (표시 19 / 전 division 동일)

| 컬럼 | 라벨 | 출처 | 표시 |
|---|---|---|---|
| DIVISION_ID | Division | META | 기본 |
| CHANGE_REQ_NO | Request No | META | 기본 |
| REQUEST_TITLE | Title | META | 기본 |
| CHANGE_TYPE | Change Type | META | 기본 |
| SHIPMENT_STATUS | Status | META | 기본 |
| FROM_SITE | From Site | META | 기본 |
| TO_SITE | To Site | META | 기본 |
| ITEM_ID | Model | META | 기본 |
| NICK_NAME | Nick Name | META | 기본 |
| CHANGE_REASON_CODE | Change Reason | META | 기본 |
| REJECT_REASON | Reject Reason | META | 기본 |
| REQUEST_USER_NAME | Requestor | META | 기본 |
| REQUEST_DEPT | Requestor Dept Name | META | 기본 |
| REQUEST_TIME | Request Date | META | 기본 |
| APPROVAL_USER_NAME | Approval | META | 기본 |
| APPROVAL_DEPT | Approval Dept Name | META | 기본 |
| APPROVAL_TIME | Approval Date | META | 기본 |
| DELEGATEE_USER_NAME | Delegatee | META | 기본 |
| DELEGATEE_DEPT | Delegatee Dept Name | META | 기본 |
| REQUEST_USER | Requestor | META | 숨김 |
| APPROVAL_USER | Approval | META | 숨김 |
| DELEGATEE_USER | Delegatee | META | 숨김 |
| ERP_SO_NO | (없음) | CODE_ONLY_CHANGE | 값 없음. 코드 분기는 Detail 시트 조건 안에 있으므로 Main 시트 귀속은 확인 필요 |

표의 컬럼 순서는 grid_effective.csv의 행 순서(알파벳 순)와 다릅니다. 실제 표시 순서는 메타의 순서 컬럼으로 확인해야 합니다(확인 필요).

### 3-2. Shipment Change Request Confirm Detail (표시 25(?1) / 전 division 동일)

| 컬럼 | 라벨(메타) | 표시 | 코드 헤더(2행째, "P"·else 같음) |
|---|---|---|---|
| CONFIRM_ID | Confirm ID | 기본 | |
| ERP_SO_NO | SO No | 기본 → `_sChangeType=="P"`면 숨김(405) / 그 외 표시(427) | |
| FCST_TYPE | FCST Type | 기본 | |
| PROJECT_NAME | Project Name | 기본 | |
| ITEM_ID | Model | 기본 | |
| FROM_SITE_DESCRIPTION | From Site | 기본 | |
| TO_SITE_DESCRIPTION | To Site | 기본 | |
| SHIPTO_CODE | ShipTo Code | 기본 | |
| INCOTERMS | Incoterms | 기본 | |
| LT_DAY | L/T(Day) | 기본 | L/T(Day) |
| ETD | ETD | 기본 | ETD |
| ETA | ETA | 기본 | ETA |
| TRANSPORT_MODE | Trans Mode | 기본 | Trans Mode |
| SHIPMENT_DATE | Shipment Date | 기본 | Shipment Date |
| SHIPMENT_CONFIRM_QTY | Qty | 기본 | Qty |
| NEW_LT_DAY | L/T(Day) | 기본 | L/T(Day) |
| NEW_ETD | ETD | 기본 | ETD |
| NEW_ETA | ETA | 기본 | ETA |
| NEW_TRANSPORT_MODE | Trans Mode | 기본 | Trans Mode |
| NEW_SHIPMENT_DATE | Shipment Date* | 기본 | Shipment Date* |
| NEW_SHIPMENT_CONFIRM_QTY | Qty* | 기본 | Qty* |
| NEW_SHIPTO_CODE | ShipTo Code | 기본 | |
| REMARKS | Remarks | 기본 | |
| REMARKS2 | Building | 기본 | |
| REMARKS3 | Customer requirement | 기본 | |

숨김 컬럼 25개(메타 기준): A_COUNTRY, A_PORT_CODE, BOD_ID, CHANGE_REQ_NO, CUSTOMER_LT, D_COUNTRY, D_PORT_CODE, DIVISION_ID, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BASE_CONFIRM_YN, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_INCOTERMS, NEW_ROUTE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_YN, ROUTE_ID, TO_CITY, TO_COUNTRY, TO_SITE.

#### 상단 헤더 병합 (InitSpread, `_sChangeType` 분기)

| 조건 | 0행 Span 1 | 0행 Span 2 |
|---|---|---|
| `_sChangeType == "P"` (407~408) | LT_DAY부터 6칸 = **"Plan"** | NEW_LT_DAY부터 7칸 = **"Confirm"** |
| 그 외 (429~430) | LT_DAY부터 7칸 = **"Confirmed"** | NEW_LT_DAY부터 7칸 = **"Change"** |

"P" 분기에서만 기존 쪽 Span이 6칸입니다. ERP_SO_NO가 숨김이 되는 것과 관련이 있을 수 있지만, 메타의 컬럼 순서가 Fact Pack에 없어 **확인 필요**입니다. 1행(2~3행 Span, 높이 30) 라벨은 두 분기가 같습니다.

### 3-3. Division별 표시 차이

| 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Change Request Confirm | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |
| Shipment Change Request Confirm Detail | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) |

Division별 차이는 없습니다. 차이는 런타임 `_sChangeType` 값 하나로만 생깁니다.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 근거 |
|---|---|---|
| Shipment Change Request Confirm | META+코드연결 | CreateSpread:342 AddSheet(spdMain) → InitSpread:368 SetSheetHeaderColumn(…, 1) |
| Shipment Change Request Confirm Detail | META+코드연결 | CreateSpread:346 AddSheet(txtApprovalDeptName) → 349/352/356 ChangeSheet → InitSpread:399 SetSheetHeaderColumn(…, 2) |

Master–Detail 연결:
- `spdMain` 셀을 더블클릭하면(`SpdMain_CellDoubleClick`) `FindData_Sub`가 `SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`를 호출하고, `Delegate_Load`가 `SSP0202_GET_DELEGATEE_LOAD`를 호출합니다.
- 더블클릭한 행에서 어떤 키(CHANGE_REQ_NO 등)를 넘기는지는 Fact Pack에 없습니다(**확인 필요**).
