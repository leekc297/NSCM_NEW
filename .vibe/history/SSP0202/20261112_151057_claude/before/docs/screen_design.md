# SSP0202 Shipment Change Request Confirm — 화면설계서

> 근거: AsisFacts Fact Pack(SSP0202) controls.csv / props.csv / events.csv / grid_effective.csv / grid_code.csv / flow.csv.
> 업무 규칙 번호(R#)는 업무분석서 §4, 엔드포인트 이름은 업무분석서 §5와 같습니다.
> props.csv는 Fact Pack에서 10,890자가 잘렸습니다. 이 때문에 라벨 원문을 확인하지 못한 항목은 **확인 필요**로 표시했습니다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0202 |
| 화면명 | Shipment Change Request Confirm |
| AS-IS 클래스 | `SSP0202_ShipmentChangeRequestConfirm` (06.UIL\GSCM.SSP.Plan.UIL) |
| AS-IS 파일 | SSP0202_ShipmentChangeRequestConfirm.cs (1440줄), .Designer.cs (1314줄) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행, 내용은 Fact Pack에 없음) |
| 그리드 구성 | META(프레임워크) + 코드 표시/라벨 변경. 시트 2개: `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| 화면 유형 | 조회조건 + Master 그리드 + 상세 폼 + Detail 그리드 + 처리 버튼 3종 |

---

## 2. 화면 레이아웃

### 2-1. 분할 트리 (props.csv + controls.csv parent 체인)

```
this
└─ splitContainer1  [SplitContainer] Dock=Fill, Orientation=Horizontal(상/하), Size=1192×649, SplitterDistance=259
   ├─ Panel1 (상, 259px = 259/649 ≈ 39.9%)
   │   ├─ usrConditionPanel1 [UsrConditionPanel] Dock=Top, 1192×67 (Panel1의 25.9%), UsrPanelType=HidePanel
   │   │   └─ usrLayoutControl1 [UsrLayoutControl] Dock=Fill, 1192×67  ← 조회조건 + 버튼
   │   │       (layoutControlGroup1 1192×73)
   │   └─ spdMain [FpSpread] Dock=Fill, 1192×192 (Panel1의 74.1%)  ← Main 그리드
   │       └─ spdMain_Sheet1 [SheetView]
   └─ Panel2 (하, 649−259 = 390px ≈ 60.1%. 분할선 폭 포함. SplitterWidth는 props에 없음)
       ├─ panel1 [Panel] Dock=Top, 1192×209
       │   └─ usrLayoutControl3 [UsrLayoutControl] Dock=Fill, 1192×209  ← 요청 상세 폼
       │       (layoutControlGroup3 1192×212)
       ├─ splitter1 [Splitter] Dock=Top, 1192×3
       └─ txtApprovalDeptName [FpSpread] Dock=Fill, 1192×174  ← Detail 그리드
           └─ txtApprovalDeptName_Sheet1 [SheetView]
```
- Panel2 자식 높이의 합은 209 + 3 + 174 = 386입니다. Panel2 높이 390과 4px 차이가 나며, 분할선 폭으로 보입니다(SplitterWidth 값은 props에 없어 **확인 필요**). 비율로 보면 panel1 209/386 ≈ 54.1%, splitter1 0.8%, Detail 그리드 174/386 ≈ 45.1%입니다.
- Dock=Top 컨트롤(panel1, splitter1)이 쌓이는 순서는 z-order로 정해지며 Fact Pack에 없습니다. 크기 합으로 보아 위에서부터 panel1 → splitter1 → Detail 그리드 순서로 보이지만 **확인 필요**입니다.
- `txtApprovalDeptName`은 이름이 txt*이지만 **FpSpread(그리드)**입니다(controls.csv 66).

### 2-2. 텍스트 와이어프레임

```
┌──────────────────────────────────────────────────────────────── 1192 ─┐
│ [usrConditionPanel1 / usrLayoutControl1]                        67px  │  ▲
│ Division[clbDivision ▼]  Request Date[drpPeriod ~ ]  From Site[clbFromSite ▼] │  │
│ Status[cboStatus ▼]  Change Type[cboChangeType ▼]                     │  │ Panel1
│ (Requestor)[txtRequest][btnRequestUser] (Model)[txtItemID][btnItemId] │  │ 39.9%
│                      [btnApproval Approval][btnReject Reject][btnSelfReject Self Reject] │
├───────────────────────────────────────────────────────────────────────┤  │
│ spdMain : Shipment Change Request Confirm (헤더 1행)            192px │  ▼
╞═══════════════════════ splitContainer1 분할선 ════════════════════════╡
│ [panel1 / usrLayoutControl3]                                   209px  │  ▲
│  usrLabel2 "Request Confirm Detail"                                   │  │
│  Request No [txtRequestNo                                    ]        │  │
│  (?)[txtTitle]          (?)[txtRequestor]   (?)[txtRequestDeptName]   │  │ Panel2
│  (?)[txtApproval]       (?)[txtAppDeptName] (?)[txtChangeReason]      │  │ 60.1%
│  (?)[txtReasonDetail                                         ]        │  │
│  (?)[txtRejectReason                                         ]        │  │
├──────────────────────── splitter1 (3px) ──────────────────────────────┤  │
│ txtApprovalDeptName : Shipment Change Request Confirm Detail (2단 헤더) 174px │
└───────────────────────────────────────────────────────────────────────┘  ▼
```
- 조회조건 안의 실제 행·열 배치(LayoutControlItem 위치)는 props.csv 잘림 구간에 있어 **확인 필요**입니다. 위 배치는 컨트롤 소속만 보여 줍니다.
- `(?)`는 라벨 원문을 확인하지 못한 항목입니다(§3).

### 2-3. 영역 구분
| 영역 | 컨테이너 | 구성 |
|---|---|---|
| 조회조건 | usrConditionPanel1 > usrLayoutControl1 | clbDivision, drpPeriod, clbFromSite, cboStatus, cboChangeType, txtRequest, btnRequestUser, txtItemID, btnItemId |
| 버튼 | usrLayoutControl1 | btnApproval, btnReject, btnSelfReject (+ 프레임워크 FindButton) |
| Main 그리드 | splitContainer1.Panel1 | spdMain / spdMain_Sheet1 |
| 상세 폼 | panel1 > usrLayoutControl3 | usrLabel2, txtRequestNo, txtTitle, txtRequestor, txtRequestDeptName, txtApproval, txtAppDeptName, txtChangeReason, txtReasonDetail, txtRejectReason |
| Detail 그리드 | splitContainer1.Panel2 | txtApprovalDeptName / txtApprovalDeptName_Sheet1 |
| 팝업 | — | BtnRequestUser_Click, btnItemId_Click (팝업 여부와 대상 화면 **확인 필요**) |

---

## 3. 컨트롤 명세

> 라벨 = props.csv Text 원문입니다. LayoutControlItem의 Text는 대응 컨트롤의 라벨로 적었습니다.

| # | 컨트롤명 | 타입 | 라벨(Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|
| 1 | splitContainer1 | SplitContainer | — | Horizontal, SplitterDistance 259 | — | — | 상/하 분할 레이아웃 |
| 2 | usrConditionPanel1 | UsrConditionPanel | — | HidePanel, 높이 67 | — | — | 공통 조회조건 패널 |
| 3 | usrLayoutControl1 | UsrLayoutControl | "usrLayoutControl1" (컨트롤 자체 Text) | — | — | — | 조회조건 레이아웃 |
| 4 | clbDivision | UsrCheckedList | "Division" (lcDivision) | 확인 필요(GetSSPInnerTable 추정) | 확인 필요 | SelectedIndexChanged → `ClbDivision_SelectedIndexChanged` | 다중 선택 콤보(공통) |
| 5 | drpPeriod | UsrDateRangePicker | "Request Date" (layoutControlItem1) | `SCP.SCM0001_GET_SCP_DAY_PERIOD` 결과 (Form_Load) | 확인 필요 | — | 기간(From~To) 공통 컴포넌트 |
| 6 | clbFromSite | UsrCheckedList | "From Site" (layoutControlItem7) | 확인 필요 | 확인 필요 | — | 다중 선택 콤보 |
| 7 | cboStatus | UsrCombo | "Status" (LayoutControlItem 이름 PlanType) | 확인 필요 | 확인 필요 | — | 단일 콤보 |
| 8 | cboChangeType | UsrCombo | "Change Type" (LayoutControlItem 이름 PlanType1) | 확인 필요 | 확인 필요 | — | 단일 콤보 |
| 9 | txtRequest | UsrMultiLineEditor | 확인 필요 (LayoutControlItem 이름 `Requestor`, Text 행 미추출) | 빈 값(확인 필요) | 아님(확인 필요) | — | 다중 입력 + 검색 버튼 |
| 10 | btnRequestUser | UsrButton | "layoutControlItem2" (layoutControlItem13 Text, 표시 여부 확인 필요) | — | — | Click → `BtnRequestUser_Click` | 검색 팝업 버튼 |
| 11 | txtItemID | UsrMultiLineEditor | 확인 필요 (LayoutControlItem 이름 `Model`, Text 행 미추출) | 빈 값(확인 필요) | 아님(확인 필요) | — | 다중 입력 + 검색 버튼 |
| 12 | btnItemId | UsrButton | 확인 필요 (layoutControlItem2 Text 미추출) | — | — | Click → `btnItemId_Click` | 검색 팝업 버튼 |
| 13 | btnApproval | SimpleButton | "Approval" (lcBtnApproval Text "layoutControlItem10") | — | — | Click → `BtnApproval_Click` | 화면 버튼(menu-button 동적 조회) |
| 14 | btnReject | SimpleButton | "Reject" (lcBtnReject Text "layoutControlItem10") | — | — | Click → `BtnReject_Click` | 화면 버튼(menu-button 동적 조회) |
| 15 | btnSelfReject | SimpleButton | "Self Reject" (lcSelfReject Text "layoutControlItem10") | — | — | Click → `BtnSelfReject_Click` | 화면 버튼(menu-button 동적 조회) |
| 16 | spdMain | FpSpread | — | 빈 그리드 | — | CellDoubleClick → `SpdMain_CellDoubleClick`, TopChange → `SpdMain_TopChange` | Wijmo FlexGrid (Main) |
| 17 | spdMain_Sheet1 | SheetView | 시트 `Shipment Change Request Confirm` (CreateSpread:342) | — | — | — | FlexGrid 컬럼 정의(메타) |
| 18 | usrLayoutControl3 | UsrLayoutControl | "usrLayoutControl3" (컨트롤 자체 Text) | — | — | — | 상세 폼 레이아웃 |
| 19 | usrLabel2 | UsrLabel | "Request Confirm Detail" | — | — | — | 섹션 타이틀 |
| 20 | txtRequestNo | TextBox | "Request No" (layoutControlItem5) | CHANGE_REQ_NO (SetChangeRequestInfo 723, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 21 | txtTitle | TextBox | 확인 필요 | REQUEST_TITLE(724, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 22 | txtRequestor | TextBox | 확인 필요 (layoutControlItem4) | REQUEST_USER(725, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 23 | txtRequestDeptName | TextBox | 확인 필요 | REQUEST_DEPT(726, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 24 | txtApproval | TextBox | 확인 필요 (lcApproval) | APPROVAL_USER(727, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 25 | txtAppDeptName | TextBox | 확인 필요 | APPROVAL_DEPT_NAME(730, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 26 | txtChangeReason | TextBox | 확인 필요 | CHANGE_REASON_CODE(728, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 27 | txtReasonDetail | TextBox | 확인 필요 (lcReasonDetail) | CHANGE_REASON_DETAIL(729, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 28 | txtRejectReason | TextBox | 확인 필요 | 빈 값(확인 필요) | 확인 필요 | — | Input. **ReadOnly 행이 없어 입력 가능 여부 확인 필요** |
| 29 | txtApprovalDeptName | FpSpread | — | 빈 그리드 | — | — | Wijmo FlexGrid (Detail) |
| 30 | txtApprovalDeptName_Sheet1 | SheetView | 시트 `Shipment Change Request Confirm Detail` (CreateSpread:346) | — | — | — | FlexGrid 컬럼 정의(메타, 2단 헤더) |

- props.csv의 크기: clbDivision 246×21, drpPeriod 210×20, clbFromSite 199×21, cboStatus 198×20, cboChangeType 141×20, txtRequest 154×21, txtItemID 136×21, btnRequestUser·btnItemId 39×24, 버튼 3종 105×22, txtRequestNo·txtReasonDetail·txtRejectReason 644×24, txtTitle·txtRequestor·txtApproval 259×24, txtRequestDeptName·txtAppDeptName·txtChangeReason 292×20, usrLabel2 733×20.
- 그 외 Designer 컨트롤: splitter1, panel1, LayoutControlItem 22개, EmptySpaceItem 5개, LayoutControlGroup 2개, imageList1.

---

## 4. 그리드 명세

공통: 컬럼은 `SpreadInfo.SetSheetHeaderColumn`이 메타(SCM_MST_SHEET_COLUMNS)를 읽어 만듭니다. 읽는 메타 컬럼은 COLUMN_NAME, COLUMN_LABEL_NAME, VISIBLE_FLAG, VALID_YN, COLUMN_WIDTH, CELL_CONTROL_OBJECT_TYPE_CODE, HORIZONTAL_ALIGN_CODE, FIXED_FLAG, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, UPPERCASE_APPLY_FLAG 등입니다.
- **타입**(CELL_CONTROL_OBJECT_TYPE_CODE), **편집 가능 여부**, **표시 순서**는 메타 행 값이 Fact Pack 본문에 없어 모두 **확인 필요**입니다(dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv 72행).
- Division별 표시: 14개 division 키 모두 같습니다(아래 "division" 열은 전 division 공통).

### 4-1. `Shipment Change Request Confirm` (spdMain, 헤더 1행 — InitSpread:368)
표시 19 / 숨김 3 / 코드 전용 1

| # | 컬럼 | 헤더(메타 라벨) | 타입 | 출처 | division별 표시 | 편집 |
|---:|---|---|---|---|---|---|
| 1 | DIVISION_ID | Division | 확인 필요 | META | 기본(전 division) | 확인 필요 |
| 2 | CHANGE_REQ_NO | Request No | 확인 필요 | META | 기본 | 확인 필요 |
| 3 | REQUEST_TITLE | Title | 확인 필요 | META | 기본 | 확인 필요 |
| 4 | CHANGE_TYPE | Change Type | 확인 필요 | META | 기본 | 확인 필요 |
| 5 | SHIPMENT_STATUS | Status | 확인 필요 | META | 기본 | 확인 필요 |
| 6 | FROM_SITE | From Site | 확인 필요 | META | 기본 | 확인 필요 |
| 7 | TO_SITE | To Site | 확인 필요 | META | 기본 | 확인 필요 |
| 8 | ITEM_ID | Model | 확인 필요 | META | 기본 | 확인 필요 |
| 9 | NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| 10 | CHANGE_REASON_CODE | Change Reason | 확인 필요 | META | 기본 | 확인 필요 |
| 11 | REJECT_REASON | Reject Reason | 확인 필요 | META | 기본 | 확인 필요 |
| 12 | REQUEST_USER_NAME | Requestor | 확인 필요 | META | 기본 | 확인 필요 |
| 13 | REQUEST_DEPT | Requestor Dept Name | 확인 필요 | META | 기본 | 확인 필요 |
| 14 | REQUEST_TIME | Request Date | 확인 필요 | META | 기본 | 확인 필요 |
| 15 | APPROVAL_USER_NAME | Approval | 확인 필요 | META | 기본 | 확인 필요 |
| 16 | APPROVAL_DEPT | Approval Dept Name | 확인 필요 | META | 기본 | 확인 필요 |
| 17 | APPROVAL_TIME | Approval Date | 확인 필요 | META | 기본 | 확인 필요 |
| 18 | DELEGATEE_USER_NAME | Delegatee | 확인 필요 | META | 기본 | 확인 필요 |
| 19 | DELEGATEE_DEPT | Delegatee Dept Name | 확인 필요 | META | 기본 | 확인 필요 |
| 20 | REQUEST_USER | Requestor | 확인 필요 | META | 숨김 | — |
| 21 | APPROVAL_USER | Approval | 확인 필요 | META | 숨김 | — |
| 22 | DELEGATEE_USER | Delegatee | 확인 필요 | META | 숨김 | — |
| 23 | ERP_SO_NO | (없음) | — | CODE_ONLY_CHANGE | 값 없음. 코드 분기는 Detail 시트 조건 안에 있어 Main 귀속은 파서 오연결로 보임(**확인 필요**) | — |

### 4-2. `Shipment Change Request Confirm Detail` (txtApprovalDeptName, 헤더 2행 인자 — InitSpread:399)
표시 25(?1) / 숨김 25

| # | 컬럼 | 헤더(메타 라벨) | 코드 헤더 | 타입 | 출처 | division별 표시 | 편집 |
|---:|---|---|---|---|---|---|---|
| 1 | CONFIRM_ID | Confirm ID | — | 확인 필요 | META | 기본 | 확인 필요 |
| 2 | ERP_SO_NO | SO No | — | 확인 필요 | META + HARDCODED(Visible) | 기본 → `_sChangeType=="P"`면 숨김(405) / 그 외 표시(427) | 확인 필요 |
| 3 | FCST_TYPE | FCST Type | — | 확인 필요 | META | 기본 | 확인 필요 |
| 4 | PROJECT_NAME | Project Name | — | 확인 필요 | META | 기본 | 확인 필요 |
| 5 | ITEM_ID | Model | — | 확인 필요 | META | 기본 | 확인 필요 |
| 6 | FROM_SITE_DESCRIPTION | From Site | — | 확인 필요 | META | 기본 | 확인 필요 |
| 7 | TO_SITE_DESCRIPTION | To Site | — | 확인 필요 | META | 기본 | 확인 필요 |
| 8 | SHIPTO_CODE | ShipTo Code | — | 확인 필요 | META | 기본 | 확인 필요 |
| 9 | INCOTERMS | Incoterms | — | 확인 필요 | META | 기본 | 확인 필요 |
| 10 | LT_DAY | L/T(Day) | 1행 L/T(Day) | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 11 | ETD | ETD | 1행 ETD | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 12 | ETA | ETA | 1행 ETA | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 13 | TRANSPORT_MODE | Trans Mode | 1행 Trans Mode | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 14 | SHIPMENT_DATE | Shipment Date | 1행 Shipment Date | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 15 | SHIPMENT_CONFIRM_QTY | Qty | 1행 Qty | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 16 | NEW_LT_DAY | L/T(Day) | 1행 L/T(Day) | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 17 | NEW_ETD | ETD | 1행 ETD | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 18 | NEW_ETA | ETA | 1행 ETA | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 19 | NEW_TRANSPORT_MODE | Trans Mode | 1행 Trans Mode | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 20 | NEW_SHIPMENT_DATE | Shipment Date* | 1행 Shipment Date* | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요('*' 표기) |
| 21 | NEW_SHIPMENT_CONFIRM_QTY | Qty* | 1행 Qty* | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요('*' 표기) |
| 22 | NEW_SHIPTO_CODE | ShipTo Code | — | 확인 필요 | META | 기본 | 확인 필요 |
| 23 | REMARKS | Remarks | — | 확인 필요 | META | 기본 | 확인 필요 |
| 24 | REMARKS2 | Building | — | 확인 필요 | META | 기본 | 확인 필요 |
| 25 | REMARKS3 | Customer requirement | — | 확인 필요 | META | 기본 | 확인 필요 |

숨김 25개(META, 전 division 숨김): A_COUNTRY(A Country), A_PORT_CODE(A Port), BOD_ID(BOD), CHANGE_REQ_NO(change_req_no), CUSTOMER_LT(Customer LT), D_COUNTRY(D Country), D_PORT_CODE(D Port), DIVISION_ID(division), FROM_SITE(From Site), NEW_A_COUNTRY(A Country), NEW_A_PORT_CODE(A Port), NEW_BASE_CONFIRM_YN(NEW_BASE_CONFIRM_YN), NEW_BOD_ID(BOD), NEW_CUSTOMER_LT(Customer LT), NEW_D_COUNTRY(D Country), NEW_D_PORT_CODE(D Port), NEW_INCOTERMS(Incoterms), NEW_ROUTE(Route), NEW_TO_CITY(To City), NEW_TO_COUNTRY(To Country), NEW_YN(new_yn), ROUTE_ID(Route), TO_CITY(To City), TO_COUNTRY(To Country), TO_SITE(To Site).

#### 상단 병합 헤더 (InitSpread, `_sChangeType` 분기)
| 조건 | 0행 Span ① | 0행 Span ② | 1행 Span (RowCount 2, 높이 30) |
|---|---|---|---|
| `_sChangeType == "P"` (405~422) | LT_DAY부터 6칸 "Plan" (높이 20, Center) | NEW_LT_DAY부터 7칸 "Confirm" | 위 표의 1행 라벨 12개 |
| 그 외 (427~444) | LT_DAY부터 7칸 "Confirmed" | NEW_LT_DAY부터 7칸 "Change" | 같은 라벨 12개 |

- AddSheet 인자가 Main은 `1 ¦ 1 ¦ 30`, Detail은 `2 ¦ 1 ¦ 30`입니다. 1행 Span은 RowCount 2입니다. 이 둘로 실제 헤더 행 수가 몇 개인지는 **확인 필요**입니다.
- 6칸과 7칸의 차이, 그리고 Span 범위에 들어가는 컬럼(표시 순서)은 메타 순서가 없어 **확인 필요**입니다.
- Designer에서 두 시트 모두 ColumnHeader 스타일을 지정합니다(General 정렬, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced. 189~192, 837~840).

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 Load | `Form_Load` | InitControls > GetDayRange, FP_Log2 로그 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | drpPeriod 기본 기간 |
| A2 | 조회(프레임워크 FindButton) | FindButton > FindData_Main | 조회조건 수집(GetCheckedListValue ×4) | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | spdMain (`Shipment Change Request Confirm`) |
| A3 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | FindData_Sub, Delegate_Load (SetChangeRequestInfo로 상세 폼 채움, 호출 위치 확인 필요) | `SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`, `SSP.SSP0202_GET_DELEGATEE_LOAD` | txtApprovalDeptName (`Shipment Change Request Confirm Detail`), usrLayoutControl3 상세 폼 |
| A4 | clbDivision 선택 변경 | `ClbDivision_SelectedIndexChanged` | 확인 필요 | 없음 | 확인 필요 |
| A5 | spdMain 스크롤 | `SpdMain_TopChange` | 확인 필요 | 없음 | 확인 필요 |
| A6 | btnApproval | `BtnApproval_Click` | EngProcessingChk → chkSaveYN → GetErpIFCheck → SaveData → FindData_Main (순서는 flow 나열, 확인 필요) | `SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK`, `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 승인 저장 후 spdMain 재조회 |
| A7 | btnReject | `BtnReject_Click` | GetErpIFCheck → SaveData → FindData_Main | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 반려 저장 후 spdMain 재조회 |
| A8 | btnSelfReject | `BtnSelfReject_Click` | GetErpIFCheck → SaveData → FindData_Main | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 자가반려 저장 후 spdMain 재조회 |
| A9 | btnRequestUser | `BtnRequestUser_Click` | 확인 필요(사용자 검색으로 보임) | 없음 | txtRequest(확인 필요) |
| A10 | btnItemId | `btnItemId_Click` | 확인 필요(품목 검색으로 보임) | 없음 | txtItemID(확인 필요) |
| A11 | (진입점 미연결) | SetChangedPeriod | PERIOD_{p:value} 또는 PERIOD_DEFAULT 코드의 FROM_VALUE, TO_VALUE 조회 | `biz:CommonData.CommonDataList` | 기간 값(호출 여부 확인 필요) |

---

## 6. 검증·메시지

| # | 검증 | 위치 | 판정 근거 | 메시지 원문 |
|---:|---|---|---|---|
| V1 | 계획 처리 중 여부 | EngProcessingChk(1090), Approval만 | `SSP0202_GET_SSP_PLAN_PROCESSING_CHECK` 결과 | 확인 필요 |
| V2 | SCS Confirm ID 존재 여부 | chkSaveYN(1130), Approval만 | Tables[0].CNT(1141), Tables[1].CNT(1147, 1161) | 확인 필요 |
| V3 | ERP I/F 검사 | GetErpIFCheck(986), 3버튼 공통 | Tables[0].result_code(998) | 확인 필요 |
| V4 | ERP Block | chkERPIFBlockYn(1064, 1073) | BLOCK_YN, PERIOD | 확인 필요(호출 위치도 확인 필요) |
| V5 | 처리 대상 행 선택·상세 조회 여부 | 확인 필요 | 확인 필요 | 확인 필요 |
| V6 | 반려 사유 입력 필수 여부 | 확인 필요 (txtRejectReason ReadOnly 미설정) | 확인 필요 | 확인 필요 |

---

## 7. 권한 (C/R/U/D)

| 구분 | 사실 | 근거 |
|---|---|---|
| R (조회) | FindButton 조회, 더블클릭 상세 조회 | flow.csv |
| U (처리) | btnApproval, btnReject, btnSelfReject → 저장 SP 2종 | flow.csv |
| C / D | 화면에서 직접 행을 추가하거나 삭제하는 버튼은 없습니다. 저장 SP 안에는 INSERT/DELETE SSP_ANL_SHIP_CONFIRM이 있습니다. | endpoints.csv |
| 그룹 | SetChangeControl(209~210): Filter GROUP_ID, USER_ID / NowGroupID. SetChangedControl(327): NowGroupID | meta_reads.csv |
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 8행 (C/R/U/D 플래그 값은 **확인 필요**) | Fact Pack §8 |
| 버튼별 활성 제어 | 그룹에 따른 버튼 활성/비활성 여부는 **확인 필요** | — |

---

## 8. To-Be 전환 메모 (React + Wijmo + Oracle)

| # | 항목 | AS-IS | To-Be 관점 |
|---:|---|---|---|
| M1 | 그리드 | FarPoint FpSpread 2개 (Detail 이름이 `txtApprovalDeptName`) | Wijmo FlexGrid 2개. 메타(SCM_MST_SHEET_COLUMNS) 기반 컬럼 생성은 그대로 유지합니다. 컴포넌트 이름은 역할에 맞게 바꾸되, AS-IS 대조표에 원래 이름을 남깁니다. |
| M2 | 2단 병합 헤더 | ColumnHeaderSpan 0행/1행 (`_sChangeType` 분기) | FlexGrid columnHeaders 병합. "P" 분기("Plan" 6칸 / "Confirm" 7칸)와 그 외 분기("Confirmed" / "Change", 각 7칸)를 둘 다 구현합니다. |
| M3 | ERP_SO_NO 표시 | `_sChangeType=="P"`면 숨김 | 상세 조회 시점에 컬럼 visible을 바꿉니다. `_sChangeType` 출처는 확인 필요 |
| M4 | 버튼 | SimpleButton 3종 | 메뉴 버튼 동적 조회(menu-button-dynamic-fetch) 대상. 라벨 원문 "Approval", "Reject", "Self Reject" |
| M5 | 분할 | SplitContainer Horizontal 259/649, 하단 panel1 209 + splitter1 3 + 그리드 174 | 상/하 분할 레이아웃(상단 약 39.9%), 하단은 상세 폼과 Detail 그리드를 나누는 2단 구성 |
| M6 | `SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | `STRING_SPLIT` 사용 | Oracle 19c에는 STRING_SPLIT이 없어 대체 분리 함수나 구문이 필요합니다(MSSQL 키워드 잔존 금지 규칙). |
| M7 | 저장 SP | #임시테이블(#T_CONFIRM_ID, #T_SSP, #T_SSP_SUM, #T_MKT_RESULT, #T_MKT_RESULT_SUM, #TEMP_SALES_RESULT, #TBLSSPAPPROVEDMAILSEND) | Oracle GTT 등으로 전환합니다. 세션 안에서 다시 실행할 때 비우는 처리를 함께 검증해야 합니다. |
| M8 | `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | `SP_SEND_DBMAIL`(MSSQL Database Mail) | Oracle 쪽 메일 발송 수단으로 대체해야 합니다. **확인 필요** |
| M9 | `SSP0202_GET_SCS_CONFIRM_ID_CHECK` | 동적 SQL | Oracle 동적 SQL(EXECUTE IMMEDIATE / OPEN FOR)로 바꾸고 대상 객체를 확인합니다. |
| M10 | 상세 폼 | TextBox 9개(8개 ReadOnly) | 읽기 전용 Input 8개 + txtRejectReason(입력 가능 여부 확인 필요) |
| M11 | 주석 호출 | 877줄, 1262줄 | 구현하지 않습니다. |

---

## 9. 미확정

1. 조회조건 라벨 원문: txtRequest(Requestor), txtItemID(Model), btnItemId, 상세 폼 TextBox 8개(txtTitle, txtRequestor, txtRequestDeptName, txtApproval, txtAppDeptName, txtChangeReason, txtReasonDetail, txtRejectReason). 전체 props.csv로 확인해야 합니다.
2. LayoutControlItem 배치(행·열 위치)와 Dock=Top 쌓임 순서.
3. 그리드 컬럼의 타입·편집 가능 여부·표시 순서(메타 72행 원문).
4. `_sChangeType` 값 출처, Span 6칸과 7칸의 차이.
5. 핸들러 4종(`ClbDivision_SelectedIndexChanged`, `SpdMain_TopChange`, `BtnRequestUser_Click`, `btnItemId_Click`)의 동작.
6. 검증 메시지 원문, `_40`과 일반 저장의 분기 조건, 처리 구분 값.
7. 조회조건 초기값과 GetSSPInnerTable 바인딩 대응.
8. Main 시트 ERP_SO_NO(CODE_ONLY_CHANGE) 행이 파서 오연결인지.
9. 메뉴 위치와 권한 메타 내용.
