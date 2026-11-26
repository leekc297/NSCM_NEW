# SSP0003 Shipment Change Request Confirm — 화면설계서

> 근거: AsisFacts Fact Pack(SSP0003)의 controls.csv, props.csv(일부 잘림), events.csv, grid_effective.csv, grid_code, 그리고 1차 분석서. Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.
> §5 액션 명세의 엔드포인트 이름은 업무분석서 §5, 단위테스트 근거 열과 같습니다. §3 컨트롤명은 단위테스트 절차 열에서 그대로 씁니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0003 |
| 화면 명칭 | Shipment Change Request Confirm (클래스 `SSP0003_ShipmentChangeRequestConfirm`) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 4행, TB_FX_ProgramInfo 4행 원문 확인) |
| 소스 | `...\SSP0003_ShipmentChangeRequestConfirm.cs`(2095줄), `.Designer.cs`(1318줄) |
| 시트 | `Shipment Change Request Confirm`(상단 마스터, 헤더 1행), `Shipment Change Request Confirm Detail`(하단 상세, 헤더 2행) |
| Grid 구성 방식 | META(프레임워크) (+코드 표시/라벨 변경). SetSheetHeaderColumn@InitSpread:431, 439 |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (props.csv의 SplitContainer와 controls.csv의 parent 체인)

| 노드 | parent | Dock | Orientation | Size | SplitterDistance | 근거 줄 |
|---|---|---|---|---|---|---|
| splitContainer1 | this | Fill | Horizontal (상/하) | 1192×649 | 259 | Designer 146·150·162·163 |
| usrConditionPanel1 | splitContainer1.Panel1 | Top | — | 1192×67 (HidePanel) | — | 220·223·225 |
| usrLayoutControl1 | usrConditionPanel1 | Fill | — | 1192×67 | — | 242·247 |
| spdMain | splitContainer1.Panel1 | Fill | — | 1192×192 | — | 169·174 |
| panel1 | splitContainer1.Panel2 | Top | — | 1192×209 | — | 877·880 |
| usrLayoutControl3 | panel1 | Fill | — | 1192×209 | — | 896·900 |
| splitter1 | splitContainer1.Panel2 | Top | — | 1192×3 | — | 867·870 |
| txtApprovalDeptName (FpSpread) | splitContainer1.Panel2 | Fill | — | 1192×174 | — | 817·822 |

비율 계산:
- splitContainer1(높이 649): Panel1은 259px로 39.9%입니다. Panel2는 649−259=390px로 60.1%이며, 여기서 분할선 폭을 뺀 값입니다. SplitterWidth 원문은 props.csv에 없습니다. Panel2 자식 높이 합(209+3+174)이 386이므로 분할선은 4px로 계산되지만, 원문 값은 **확인 필요**입니다.
- Panel1(259): usrConditionPanel1 67px(25.9%), spdMain 192px(74.1%)
- Panel2(386 기준): panel1 209px(54.1%), splitter1 3px(0.8%), txtApprovalDeptName 174px(45.1%)
- 좌/우 분할은 없습니다.

### 2-2. 텍스트 와이어프레임

```
┌──────────────────────────────── SSP0003 (1192 × 649) ───────────────────────────────┐
│ splitContainer1 · Horizontal · SplitterDistance 259                                  │
│ ┌─ Panel1 (259px, 39.9%) ───────────────────────────────────────────────────────────┐│
│ │ [조회조건] usrConditionPanel1 (Top 67px, HidePanel) > usrLayoutControl1           ││
│ │  Division[clbDivision]  From Site[clbFromSite]  Request Date[drpPeriod]           ││
│ │  Status[cboStatus]  Change Type[cboChangeType]                                    ││
│ │  (Requestor)[txtRequest][btnRequestUser]  (Model)[txtItemID][btnItemId]           ││
│ │  [버튼] [Approval btnApproval] [Reject btnReject] [Self Reject btnSelfReject]     ││
│ │  ※ 항목별 좌표·행 배치는 props.csv 잘림 → 확인 필요 (layoutControlGroup1 1192×73) ││
│ ├───────────────────────────────────────────────────────────────────────────────────┤│
│ │ [그리드] spdMain / spdMain_Sheet1  (Fill 192px)                                   ││
│ │   시트 "Shipment Change Request Confirm" (헤더 1행, 표시 19)                      ││
│ └───────────────────────────────────────────────────────────────────────────────────┘│
│ ══════════════ 분할선 (SplitterWidth 확인 필요, 계산상 4px) ══════════════            │
│ ┌─ Panel2 (≈386px, 60.1%) ──────────────────────────────────────────────────────────┐│
│ │ [요청 정보] panel1 (Top 209px) > usrLayoutControl3                                ││
│ │  txtRequestNo · txtTitle · txtRequestor · txtRequestDeptName · txtApproval        ││
│ │  txtAppDeptName · txtChangeReason · txtReasonDetail · usrLabel2 · txtRejectReason ││
│ ├─ splitter1 (Top 3px) ─────────────────────────────────────────────────────────────┤│
│ │ [그리드] txtApprovalDeptName / txtApprovalDeptName_Sheet1 (Fill 174px)            ││
│ │   시트 "Shipment Change Request Confirm Detail" (헤더 2행, 표시 29 ?1)            ││
│ └───────────────────────────────────────────────────────────────────────────────────┘│
└──────────────────────────────────────────────────────────────────────────────────────┘
[팝업] btnRequestUser / btnItemId의 팝업 여부는 확인 필요
```

## 3. 컨트롤 명세

> 라벨은 props.csv의 Text 원문입니다(LayoutControlItem.Text 또는 컨트롤 Text). props.csv가 잘려 원문을 볼 수 없으면 **확인 필요**로 표시했습니다.

| # | 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|
| 1 | usrConditionPanel1 | UsrConditionPanel | — (UsrPanelType=HidePanel) | — | — | — | 조회조건 패널(접기 가능) |
| 2 | usrLayoutControl1 | UsrLayoutControl | "usrLayoutControl1" (컨트롤 Text) | — | — | — | 조회조건 레이아웃 |
| 3 | clbDivision | UsrCheckedList | "Division" (lcDivision) | `SSP.SSP0200_GET_SHIPMENT_DIVISION` 결과. 기본 선택은 **확인 필요** | 확인 필요 | SelectedIndexChanged → `ClbDivision_SelectedIndexChanged` | 다중 선택 콤보(Wijmo MultiSelect 계열) |
| 4 | clbFromSite | UsrCheckedList | "From Site" (layoutControlItem7) | Site SP 2종 결과 | 확인 필요 | — | 다중 선택 콤보 |
| 5 | drpPeriod | UsrDateRangePicker | "Request Date" (layoutControlItem1) | `SCP.SCM0001_GET_SCP_DAY_PERIOD` 기반(바인딩 확인 필요) | 확인 필요 | — | 기간(From~To) 날짜 입력 |
| 6 | cboStatus | UsrCombo | "Status" (PlanType) | 확인 필요 | 확인 필요 | — | 단일 선택 콤보 |
| 7 | cboChangeType | UsrCombo | "Change Type" (PlanType1) | 확인 필요 | 확인 필요 | — | 단일 선택 콤보 |
| 8 | txtRequest | UsrMultiLineEditor | 확인 필요 (LayoutItem 이름은 Requestor, Text 잘림) | 확인 필요 | 확인 필요 | — | 텍스트 입력 + 검색 버튼 |
| 9 | btnRequestUser | UsrButton | "layoutControlItem2" (layoutControlItem13 Text, 표시 여부 확인 필요) | — | — | Click → `BtnRequestUser_Click` | 검색 버튼(팝업 여부 확인 필요) |
| 10 | txtItemID | UsrMultiLineEditor | 확인 필요 (LayoutItem 이름은 Model) | 확인 필요 | 확인 필요 | — | 텍스트 입력 + 검색 버튼 |
| 11 | btnItemId | UsrButton | 확인 필요 (layoutControlItem2 Text 잘림) | — | — | Click → `btnItemId_Click` | 검색 버튼(팝업 여부 확인 필요) |
| 12 | btnApproval | SimpleButton | "Approval" (LayoutItem lcBtnApproval Text "layoutControlItem10") | — | — | Click → `BtnApproval_Click` | 액션 버튼 |
| 13 | btnReject | SimpleButton | "Reject" (LayoutItem lcBtnReject Text "layoutControlItem10") | — | — | Click → `BtnReject_Click` | 액션 버튼 |
| 14 | btnSelfReject | SimpleButton | "Self Reject" (LayoutItem lcSelfReject Text "layoutControlItem10") | — | — | Click → `BtnSelfReject_Click` | 액션 버튼 |
| 15 | spdMain | FpSpread | — | 빈 그리드 | — | CellDoubleClick → `SpdMain_CellDoubleClick`, TopChange → `SpdMain_TopChange` | Wijmo FlexGrid(마스터) |
| 16 | spdMain_Sheet1 | SheetView | 시트 `Shipment Change Request Confirm` | 메타 22행 | — | — | FlexGrid 컬럼 정의 |
| 17 | usrLayoutControl3 | UsrLayoutControl | "usrLayoutControl3" (컨트롤 Text) | — | — | — | 요청 정보 폼 레이아웃 |
| 18 | txtRequestNo | TextBox | 확인 필요 | 더블클릭 시 채움(CHANGE_REQ_NO로 추정, 1:1 대응 확인 필요) | — | — | 읽기 전용 입력(ReadOnly=true) |
| 19 | txtTitle | TextBox | 확인 필요 (LayoutItem lcTitle/lcTitle1) | 위와 같음 | — | — | 읽기 전용 입력(ReadOnly=true) |
| 20 | txtRequestor | TextBox | 확인 필요 | 위와 같음 | — | — | 읽기 전용 입력(ReadOnly=true) |
| 21 | txtRequestDeptName | TextBox | 확인 필요 | 위와 같음 | — | — | 입력(ReadOnly 확인 필요) |
| 22 | txtApproval | TextBox | 확인 필요 (LayoutItem lcApproval) | 위와 같음 | — | — | 입력(ReadOnly 확인 필요) |
| 23 | txtAppDeptName | TextBox | 확인 필요 | 위와 같음 | — | — | 입력(ReadOnly 확인 필요) |
| 24 | txtChangeReason | TextBox | 확인 필요 | 위와 같음 | — | — | 입력(ReadOnly 확인 필요) |
| 25 | txtReasonDetail | TextBox | 확인 필요 (LayoutItem lcReasonDetail) | 위와 같음 | — | — | 입력(ReadOnly 확인 필요) |
| 26 | txtRejectReason | TextBox | 확인 필요 | 확인 필요 | 확인 필요 | — | 반려 사유 입력 후보(편집 여부 확인 필요) |
| 27 | usrLabel2 | UsrLabel | 확인 필요 | — | — | — | 라벨 |
| 28 | txtApprovalDeptName | FpSpread (이름은 TextBox처럼 보이지만 Spread) | — | 빈 그리드 | — | — | Wijmo FlexGrid(상세, 헤더 2행) |
| 29 | txtApprovalDeptName_Sheet1 | SheetView | 시트 `Shipment Change Request Confirm Detail` | 메타 54행 | — | — | FlexGrid 컬럼 정의 |

## 4. 그리드 명세

> 타입(CELL_CONTROL_OBJECT_TYPE_CODE)과 편집 가능 여부는 Fact Pack에 컬럼별 값이 없어 **확인 필요**입니다. 예외는 코드로 지정된 CHK(CheckBox)입니다. 아래 표의 순서는 표시 순서가 아닙니다. 실제 순서는 메타 SCM_MST_SHEET_COLUMNS 기준으로 확인해야 합니다.

### 4-1. `Shipment Change Request Confirm` (spdMain, 메타 22행, 표시 19, 헤더 1행)

| 컬럼 | 헤더 | 타입 | 출처 | Division별 표시(40/81계열/82/EE계열) | 편집 |
|---|---|---|---|---|---|
| CHANGE_REQ_NO | Request No | 확인 필요 | META | 기본(전 Division) | 확인 필요 |
| REQUEST_TITLE | Title | 확인 필요 | META | 기본 | 확인 필요 |
| CHANGE_TYPE | Change Type | 확인 필요 | META | 기본 | 확인 필요 |
| SHIPMENT_STATUS | Status | 확인 필요 | META | 기본 | 확인 필요 |
| DIVISION_ID | Division | 확인 필요 | META | 기본 | 확인 필요 |
| FROM_SITE | From Site | 확인 필요 | META | 기본 | 확인 필요 |
| TO_SITE | To Site | 확인 필요 | META | 기본 | 확인 필요 |
| ITEM_ID | Model | 확인 필요 | META | 기본 | 확인 필요 |
| NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| CHANGE_REASON_CODE | Change Reason | 확인 필요 | META | 기본 | 확인 필요 |
| REJECT_REASON | Reject Reason | 확인 필요 | META | 기본 | 확인 필요 |
| REQUEST_USER_NAME | Requestor | 확인 필요 | META | 기본 | 확인 필요 |
| REQUEST_DEPT | Requestor Dept Name | 확인 필요 | META | 기본 | 확인 필요 |
| REQUEST_TIME | Request Date | 확인 필요 | META | 기본 | 확인 필요 |
| APPROVAL_USER_NAME | Approval | 확인 필요 | META | 기본 | 확인 필요 |
| APPROVAL_DEPT | Approval Dept Name | 확인 필요 | META | 기본 | 확인 필요 |
| APPROVAL_TIME | Approval Date | 확인 필요 | META | 기본 | 확인 필요 |
| DELEGATEE_USER_NAME | Delegatee | 확인 필요 | META | 기본 | 확인 필요 |
| DELEGATEE_DEPT | Delegatee Dept Name | 확인 필요 | META | 기본 | 확인 필요 |
| REQUEST_USER | Requestor | 확인 필요 | META | 숨김 | — |
| APPROVAL_USER | Approval | 확인 필요 | META | 숨김 | — |
| DELEGATEE_USER | Delegatee | 확인 필요 | META | 숨김 | — |
| ERP_SO_NO | (라벨 없음) | — | CODE_ONLY_CHANGE | 파서가 이 시트에 귀속시켰지만 코드 조건은 Detail 시트입니다(**확인 필요**). | — |

### 4-2. `Shipment Change Request Confirm Detail` (txtApprovalDeptName, 메타 54행, 표시 29 ?1, 헤더 2행)

| 컬럼 | 헤더(1행) | 0행 그룹 헤더 | 타입 | 출처 | Division별 표시 | 편집 |
|---|---|---|---|---|---|---|
| CHK | ALL | — | CheckBox(Value=true, Border=bevelbrdr) | META + 코드(InitSpread:447~449) | 기본 | 체크 가능 여부는 확인 필요 |
| CONFIRM_ID | Confirm ID | — | 확인 필요 | META | 기본 | 확인 필요 |
| ERP_SO_NO | SO No | — | 확인 필요 | META + 코드(475 숨김 / 503 표시) | `_sChangeType=="P"`이면 숨김, 그 외 표시(?) | 확인 필요 |
| FCST_TYPE | FCST Type | — | 확인 필요 | META | 기본 | 확인 필요 |
| PROJECT_NAME | Project Name | — | 확인 필요 | META | 기본 | 확인 필요 |
| ITEM_ID | Model | — | 확인 필요 | META | 기본 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site | — | 확인 필요 | META | 기본 | 확인 필요 |
| TO_SITE_DESCRIPTION | To Site | — | 확인 필요 | META | 기본 | 확인 필요 |
| INCOTERMS | Incoterms | — | 확인 필요 | META | 기본 | 확인 필요 |
| LT_DAY | L/T(Day) | P: "Plan" / 그 외: "Confirmed" (6열 span 시작) | 확인 필요 | META + 코드 | 기본 | 확인 필요 |
| ETD | ETD | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| ETA | ETA | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| TRANSPORT_MODE | Trans Mode | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| SHIPMENT_DATE | Shipment Date | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| SHIPMENT_CONFIRM_QTY | Qty | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| NEW_LT_DAY | L/T(Day) | P: "Confirm" / 그 외: "Change" (6열 span 시작) | 확인 필요 | META + 코드 | 기본 | 확인 필요 |
| NEW_ETD | ETD | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| NEW_ETA | ETA | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| NEW_TRANSPORT_MODE | Trans Mode | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| NEW_SHIPMENT_DATE | Shipment Date* | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요('*' 표기) |
| NEW_SHIPMENT_CONFIRM_QTY | Qty* | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요('*' 표기) |
| ERP_ATTR1 | Consignee Name | — | 확인 필요 | META | 기본 | 확인 필요 |
| ERP_ATTR2 | Contact Point | — | 확인 필요 | META | 기본 | 확인 필요 |
| ERP_ATTR3 | Lot | — | 확인 필요 | META | 기본 | 확인 필요 |
| REMARKS | Remarks | — | 확인 필요 | META | 기본 | 확인 필요 |
| REMARKS2 | Building | — | 확인 필요 | META | 기본 | 확인 필요 |
| REMARKS3 | Customer requirement | — | 확인 필요 | META | 기본 | 확인 필요 |
| STATUS_DETAIL | Status Detail | — | 확인 필요 | META | 기본 | 확인 필요 |
| REJECT_REASON | Reject Reason | — | 확인 필요 | META | 기본 | 확인 필요 |

숨김 컬럼 25개(META, 전 Division 숨김): A_COUNTRY, A_PORT_CODE, BOD_ID, CHANGE_REQ_NO, CUSTOMER_LT, D_COUNTRY, D_PORT_CODE, DIVISION_ID, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BASE_CONFIRM_YN, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_INCOTERMS, NEW_ROUTE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_YN, ROUTE_ID, TO_CITY, TO_COUNTRY, TO_SITE.

추가 코드 규칙: FindData_Sub:827에서 `p_status`가 E·O·R·S, D·A, P가 모두 아닌 경우 `VisibleColumns(0, false)`로 0번 컬럼을 숨깁니다.

Division 요약: 40, 81 계열, 82, EE 계열 모두 상단 19개, 상세 29개(?1)로 같습니다.

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 로드 | `Form_Load` | InitControls(317) | `SSP.SSP0200_GET_SHIPMENT_DIVISION` | clbDivision |
| A2 | 화면 로드 | `Form_Load` | InitControls > SetChangedControl(369/386) | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | clbFromSite |
| A3 | 화면 로드 | `Form_Load` | InitControls > GetDayRange(1864) | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 기간 기본값(drpPeriod 바인딩 확인 필요) |
| A4 | clbDivision 선택 변경 | `ClbDivision_SelectedIndexChanged` | SetChangedControl(354 GetCheckedListValue, 369, 386) | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | clbFromSite 재구성 |
| A5 | 조회(프레임워크 FindButton) | FindButton | FindData_Main(675~685 조건 수집, 696 호출) | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | spdMain 시트 `Shipment Change Request Confirm` |
| A6 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | FindData_Sub(772), SetChangeRequestInfo | `SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | txtApprovalDeptName 시트 `Shipment Change Request Confirm Detail`, usrLayoutControl3의 TextBox들 |
| A7 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | Delegate_Load(1834) | `SSP.SSP0003_GET_DELEGATEE_LOAD` | 반영 위치 확인 필요 |
| A8 | spdMain 스크롤 | `SpdMain_TopChange` | 확인 필요 | 없음 | 확인 필요 |
| A9 | btnApproval | `BtnApproval_Click` | GetShipmentStatusChk(1656) | `SSP.SSP0200_GET_SHIPMENT_STATUS` | 상태 검사(Tables[2] CONFIRM_ID) |
| A10 | btnApproval | `BtnApproval_Click` | EngProcessingChk(1619) | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | 계획 처리 검사 |
| A11 | btnApproval | `BtnApproval_Click` | SaveDraftingData(970) | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` | 상세 확정 저장 |
| A12 | btnApproval | `BtnApproval_Click` | SaveData(1207; 호출 2029·2061·2063) | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` / `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` | 요청 확정 저장(분기 조건 확인 필요) |
| A13 | btnApproval | `BtnApproval_Click` | GetErpIFCheck(1337) | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | result_code 판정 |
| A14 | btnApproval | `BtnApproval_Click` | GetErpIFCheckNew(1409, 1492) | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | result_code 판정(1426) |
| A15 | btnApproval | `BtnApproval_Click` | GetErpIFCheckNew(1458) | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | Drafting 삭제 |
| A16 | btnApproval | `BtnApproval_Click` | GetErpIFCheckNew(1541) | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | ERP 오류 확정 |
| A17 | btnApproval | `BtnApproval_Click` | SaveData > FindData_Main(696) | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | spdMain 재조회 |
| A18 | btnReject | `BtnReject_Click` | SaveDraftingData → SaveData(1993) → GetErpIFCheck → FindData_Main (순서 확인 필요) | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` / `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 반려 저장 후 재조회 |
| A19 | btnSelfReject | `BtnSelfReject_Click` | SaveDraftingData → SaveData(1921) → GetErpIFCheck → FindData_Main (순서 확인 필요) | A18과 같음 | 자가 반려 저장 후 재조회 |
| A20 | btnRequestUser | `BtnRequestUser_Click` | 확인 필요 | 없음 | 확인 필요(txtRequest 반영 여부) |
| A21 | btnItemId | `btnItemId_Click` | 확인 필요 | 없음 | 확인 필요(txtItemID 반영 여부) |
| A22 | (진입점 미연결) | SetChangedPeriod(1573) | FROM_VALUE, TO_VALUE 읽음 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 실제 호출 여부 확인 필요 |

## 6. 검증·메시지

| # | 검증 | 위치 | 판정 근거 | 메시지 원문 |
|---:|---|---|---|---|
| V1 | 선적 상태 검사 | GetShipmentStatusChk | `SSP.SSP0200_GET_SHIPMENT_STATUS` Tables[2] CONFIRM_ID | 확인 필요 |
| V2 | 계획 처리 중 검사 | EngProcessingChk | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | 확인 필요 |
| V3 | ERP IF 검사 | GetErpIFCheck / GetErpIFCheckNew | `result_code` (Tables[0].Rows[0]) | 확인 필요 |
| V4 | ERP IF 차단 | chkERPIFBlockYn | BLOCK_YN, PERIOD | 확인 필요 |
| V5 | 필수 입력('*' 컬럼, 조회조건) | — | Fact Pack에 검증 코드 없음 | 확인 필요 |

## 7. 권한 (C/R/U/D) 사실

| 사실 | 출처 |
|---|---|
| TB_FX_GroupMenuAuth에 SSP0003 관련 15행이 있습니다. C/R/U/D 플래그 값은 **확인 필요**입니다. | Fact Pack §8 |
| Division·Site 목록은 TB_FX_USERGROUPAUTHEXTENTION과 `NowGroupID`로 제한됩니다. | InitControls:321, SetChangedControl:376·391 |
| GetSSPInnerTable 필터에 GROUP_ID와 USER_ID를 사용합니다. | SetChangeControl:227~228 |
| btnApproval, btnReject, btnSelfReject의 권한별 활성화 조건은 **확인 필요**입니다. | Fact Pack에 없음 |

## 8. To-Be 전환 메모 (Wijmo·Oracle)

| 영역 | AS-IS | To-Be 메모 |
|---|---|---|
| 상단 그리드 | FpSpread spdMain + SetSheetHeaderColumn(메타) | Wijmo FlexGrid. 컬럼 정의는 SCM_MST_SHEET_COLUMNS(PROGRAM_ID=SSP0003) 메타로 유지합니다. |
| 상세 그리드 | FpSpread txtApprovalDeptName, ColumnHeaderSpan 2행 | FlexGrid columnHeaders 2행으로 구성하고 병합을 적용합니다. `_sChangeType`에 따라 그룹 헤더 텍스트("Plan"/"Confirm" ↔ "Confirmed"/"Change")와 ERP_SO_NO 표시를 런타임에 전환합니다. |
| CHK 컬럼 | CellType chk, Value=true | FlexGrid boolean 컬럼으로 만들고 헤더 "ALL"에 전체 선택을 둡니다(동작 확인 필요). |
| 마스터→상세 | CellDoubleClick | 더블클릭 이벤트로 연결합니다. AS-IS에서는 행 선택 변경으로 연결되지 않습니다. |
| Site 조회 SP | FoxQuery 미등록 2종 | MyBatis mapper에 명시적으로 등록해야 합니다. 등록 방식은 확인 필요입니다. |
| SQL 변환 | STRING_SPLIT, UF_FX_STRING_SPLIT, `#` 임시 테이블(#TBLDYNAMIC_SSP0003_40_STD, #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 등) | Oracle 19c에는 STRING_SPLIT이 없으므로 대체 구현이 필요합니다. 임시 테이블은 GTT 등으로 전환합니다. 세션 시작 시 비우기 처리를 포함해야 합니다. |
| 저장 분기 | 줄 1207의 CONFIRM_40 / CONFIRM | 분기 조건을 확인한 뒤 BE Service에서 한 곳으로 분기합니다. |
| 주석 호출 | 줄 1209, 1863 | 전환 대상에서 제외합니다. |

## 9. 미확정

1. props.csv가 잘려 조회조건 항목 좌표, Requestor·Model 라벨, 하단 패널 TextBox 라벨과 ReadOnly 여부(txtRequestDeptName 이후)를 확인할 수 없습니다.
2. splitContainer1의 SplitterWidth 원문 값
3. 줄 1207 저장 SP 분기 조건, 버튼별 호출 순서와 실패 분기
4. `BtnRequestUser_Click`, `btnItemId_Click`, `SpdMain_TopChange`의 동작
5. cboStatus·cboChangeType 항목의 출처, `_sChangeType`과의 연계
6. 그리드 컬럼별 타입, 편집 가능 여부, 표시 순서(메타 원문 대조)
7. `biz:CommonData.CommonDataList` 실사용 여부
8. 검증 메시지 원문, C/R/U/D 플래그 값
9. ERP_SO_NO(CODE_ONLY_CHANGE)가 상단 시트에 귀속된 것이 파서 오류인지 여부
