# SSP0201 Shipment Change Request — 화면설계서

> **근거 범위**: AsisFacts Fact Pack(SSP0201)의 controls.csv, props.csv, events.csv, endpoints.csv, flow.csv, grid_effective.csv, grid_code와 1차 분석서. props.csv가 일부 잘려서(28,634자 생략) 확인하지 못한 라벨·속성은 **확인 필요**로 표시했습니다.
> **상호 참조**: §3 컨트롤명은 단위테스트 '절차' 열에서, §5 엔드포인트는 업무분석서 §5와 단위테스트 '근거' 열에서 같은 이름으로 씁니다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0201 |
| 화면 명칭 | Shipment Change Request (클래스 `SSP0201_ShipmentChangeRequest`) |
| 도메인 | SSP (`GSCM.SSP.Forms.UIL\Plan`) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행, 내용 미첨부) |
| 화면 크기(Designer) | splitContainer1 1192×649 |
| 그리드 | spdMain(`Shipment Change Request`, 헤더 1행), spdSub(`Change Request`, 헤더 2행) |
| 그리드 구성 방식 | META(프레임워크, `SetSheetHeaderColumn`) + 코드로 표시/라벨 변경 |
| 컨트롤 수 | 80 (controls.csv) |
| 이벤트 배선 | 18건 / 핸들러 17종 |
| 엔드포인트 | 13종 (호출 지점 22곳) |

---

## 2. 화면 레이아웃

### 2-1. 분할 트리 (props.csv의 SplitContainer + controls.csv의 parent 체인)

```
SSP0201_ShipmentChangeRequest (this)
└─ splitContainer1  [SplitContainer · Dock=Fill · Orientation=Horizontal(상/하) · Size=1192×649 · SplitterDistance=253]
   ├─ Panel1 (상) 253px = 253/649 ≈ 39.0%
   │  ├─ usrConditionPanel1 [UsrConditionPanel · Dock=Top · 1192×69 · UsrPanelType=HidePanel]   69/253 ≈ 27.3%
   │  │  └─ usrLayoutControl1 [UsrLayoutControl · Dock=Fill · 1192×69]  (layoutControlGroup1 1192×72)
   │  │     ├─ txtConfirmId · clbDivision_ID · clbFromSite · txtSoNo · drpPeriod · cboStatus
   │  │     ├─ txtRequest · btnItemId · cboChangeType · clbToSite
   │  │     └─ btnNew · btnChangeRe
   │  └─ spdMain [FpSpread · Dock=Fill · 1192×184]  184/253 ≈ 72.7%
   │     └─ spdMain_Sheet1 → 시트 "Shipment Change Request"
   └─ Panel2 (하) 649−253 = 396px ≈ 61.0%  (자식 높이 합 179+213=392, 4px 차이 = 스플리터 폭인지 확인 필요)
      ├─ panel3 [Panel · Dock=Top · 1192×179]   179/392 ≈ 45.7%
      │  ├─ usrLayoutControl2 [UsrLayoutControl · Dock=Fill · 432×179]  432/1192 ≈ 36.2% (가로)
      │  │  └─ dtDate · btnDel · btnCancel · btnSave · btnAdd · btnChangeRe2   (layoutControlGroup2 432×179)
      │  └─ panel1 [Panel · Dock/Size 확인 필요(props 잘림)]  나머지 760px ≈ 63.8% (추정, 확인 필요)
      │     └─ usrLayoutControl3 [UsrLayoutControl]
      │        └─ txtRequestNo · txtTitle · txtRequestor · txtRequestDeptName · txtApproval · btnApprovalUser
      │           txtAppDeptName · cboChangeReason · txtReasonDetail · usrLabel2
      └─ spdSub [FpSpread · Dock=Fill · 1192×213]   213/392 ≈ 54.3%
         └─ spdSub_Sheet1 → 시트 "Change Request"

(parent 공란) txtItemId [UsrMultiLineEditor] — 배치 확인 필요
(parent 공란) imageList1 [ImageList] — 비가시 컴포넌트
```

- usrLayoutControl2는 Dock=Fill인데 폭이 432입니다. 이는 panel1이 panel3 안에서 좌측 또는 우측에 도킹되어 있다는 뜻으로 보입니다. panel1의 Dock과 Size는 잘린 props에 있어 좌/우 위치와 비율은 **확인 필요**입니다.

### 2-2. 텍스트 와이어프레임

```
┌──────────────────────────────────────────────────────────────────────────────────┐ ▲
│ [조회조건 usrConditionPanel1 / usrLayoutControl1]                        69px     │ │
│ Confirm Id[txtConfirmId] Div[clbDivision_ID▼] From Site[clbFromSite☑▼]           │ │ Panel1
│ (SO No[txtSoNo] Visible=false) Shipment Date[drpPeriod ~ ] Status[cboStatus▼]     │ │ 253px
│ (Model)[txtRequest][btnItemId] Change Type[cboChangeType▼] To Site[clbToSite☑▼]  │ │ ≈39.0%
│ [NEW btnNew] [Request Complete btnChangeRe]                                       │ │
├──────────────────────────────────────────────────────────────────────────────────┤ │
│ [spdMain : Shipment Change Request]  헤더 1행                         184px       │ │
│                                                                                  │ ▼
╞══════════════════════════════ splitter (SplitterDistance=253) ══════════════════╡
│ [panel3 179px]                                                                   │ ▲
│ ┌ usrLayoutControl2 432px ─────────┐┌ panel1 / usrLayoutControl3 (위치 확인 필요) ┐│ │
│ │ [Request Complete btnChangeRe2]   ││ Request No[txtRequestNo] Title[txtTitle]   ││ │ Panel2
│ │ [Cancel btnCancel] [Delete btnDel]││ Requestor[txtRequestor] Dept[txtRequestDept││ │ 396px
│ │ (Save Draft btnSave  Vis=false)   ││ Name] Approval[txtApproval][btnApprovalUser││ │ ≈61.0%
│ │ (Add Date btnAdd     Vis=false)   ││ ] App Dept[txtAppDeptName]                 ││ │
│ │ (dtDate              Vis=false)   ││ Change Reason[cboChangeReason▼]            ││ │
│ │                                   ││ Reason Detail[txtReasonDetail] usrLabel2   ││ │
│ └───────────────────────────────────┘└────────────────────────────────────────────┘│ │
├──────────────────────────────────────────────────────────────────────────────────┤ │
│ [spdSub : Change Request]  헤더 2행 (Plan/Confirmed │ Confirm/Change 그룹)  213px │ │
└──────────────────────────────────────────────────────────────────────────────────┘ ▼
```
- 요청 정보 영역(usrLayoutControl3)의 라벨 문구(Request No, Title 등)는 **컨트롤명에서 붙인 임시 표기**입니다. 원문 Text는 잘린 props에 있어 **확인 필요**입니다.
- 조회조건의 행/열 배치는 Designer 선언 순서 기준이며, 실제 좌표 배치는 **확인 필요**입니다.

### 2-3. 영역 구분

| 영역 | 컨테이너 | 구성 |
|---|---|---|
| 조회조건 | usrConditionPanel1 → usrLayoutControl1 | 조회 컨트롤 10개 + btnNew, btnChangeRe |
| 버튼 | usrLayoutControl2 (+ usrLayoutControl1 안의 btnNew, btnChangeRe) | btnChangeRe2, btnCancel, btnDel, btnSave, btnAdd, dtDate |
| 그리드 | spdMain, spdSub | 상단 대상 목록 / 하단 변경 요청 상세 |
| 요청 정보(폼) | panel1 → usrLayoutControl3 | 요청번호, 제목, 요청자, 승인자, 부서, 변경 사유 |
| 팝업 | btnItemId, btnApprovalUser | 팝업을 띄우는지 **확인 필요**(엔드포인트 미추출) |
| 툴바(프레임워크) | FindButton, InsertButton, SaveButton | 프레임워크 툴바 버튼과 연결되는 방식 **확인 필요** |

---

## 3. 컨트롤 명세

> 라벨 = props.csv의 Text 원문(LayoutControlItem.Text 또는 컨트롤 Text). 필수 여부는 Fact Pack에 근거가 없어 모두 **확인 필요**입니다. To-Be 컴포넌트는 Wijmo/React 후보이며 NSCM 공용 컴포넌트 확정이 아닙니다.

| # | 컨트롤명 | 타입 | 라벨(props Text 원문) | 초기값/속성 | 필수 | 연결 이벤트 | To-Be 컴포넌트(후보) |
|---:|---|---|---|---|---|---|---|
| 1 | spdMain | FarPoint FpSpread | — | Dock=Fill, 1192×184 | — | TopChange→`SpdMain_TopChange`, CellClick→`SpdMain_CellClick`, CellDoubleClick→`SpdMain_CellDoubleClick`, EditChange→`SpdMain_EditChange`, ClipboardPasted→`SpdMain_ClipboardPasted`, ComboSelChange→`SpdMain_ComboSelChange`, CursorChanged→`SpdMain_CursorChanged` | Wijmo FlexGrid |
| 2 | spdMain_Sheet1 | FarPoint SheetView | (시트 `Shipment Change Request`) | AddSheet CreateSpread:523, SetSheetHeaderColumn InitSpread:546 | — | — | FlexGrid columns(메타) |
| 3 | usrConditionPanel1 | UsrConditionPanel | — | Dock=Top, 1192×69, UsrPanelType=HidePanel | — | — | 조회조건 패널(접기 가능) |
| 4 | usrLayoutControl1 | UsrLayoutControl | "usrLayoutControl1" | Dock=Fill, 1192×69 | — | — | 조회조건 레이아웃 |
| 5 | txtConfirmId | UsrMultiLineEditor | "Confirm Id" (layoutControlItem11) | 100×21 | 확인 필요 | — | 멀티라인 입력 |
| 6 | clbDivision_ID | UsrCombo | "Div" (layoutControlItem8) | 223×20, 목록 출처 확인 필요 | 확인 필요 | SelectedIndexChanged→`clbDivision_ID_SelectedIndexChanged` | ComboBox(단일) |
| 7 | clbFromSite | UsrCheckedList | "From Site" (layoutControlItem7) | 154×21 | 확인 필요 | — | MultiSelect |
| 8 | txtSoNo | UsrMultiLineEditor | "SO No" (lblSONo) | 100×21, **Visible=false** | 확인 필요 | — | 멀티라인 입력(숨김) |
| 9 | drpPeriod | UsrDateRangePicker | "Shipment Date" (layoutControlItem1) | 195×20, 기본값 = `SCP.SCM0001_GET_SCP_DAY_PERIOD` 결과 | 확인 필요 | — | InputDate×2(기간) |
| 10 | btnChangeRe | DevExpress SimpleButton | "Request Complete" (항목 lcChgReq, 항목 Text "layoutControlItem10") | 133×22 | — | Click→`BtnChangeRe_Click` | Button |
| 11 | cboStatus | UsrCombo | "Status" (PlanType) | 58×20, 목록 확인 필요 | 확인 필요 | — | ComboBox |
| 12 | txtRequest | UsrMultiLineEditor | 미추출 (항목 이름 `Model`, Text 확인 필요) | 109×21 | 확인 필요 | — | 멀티라인 입력 |
| 13 | btnItemId | UsrButton | 미추출 (layoutControlItem2) | 39×24 | — | Click→`btnItemId_Click` | Button(팝업 호출 후보) |
| 14 | cboChangeType | UsrCombo | "Change Type" (PlanType1) | 20×20, 목록 확인 필요("P" 값 존재) | 확인 필요 | SelectedIndexChanged→`CboChangeType_SelectedIndexChanged` | ComboBox |
| 15 | clbToSite | UsrCheckedList | "To Site" (layoutControlItem3) | 271×21 | 확인 필요 | — | MultiSelect |
| 16 | btnNew | UsrButton | "NEW" (항목 layoutControlItem12, 항목 Text "layoutControlItem5") | 98×22 | — | Click→`BtnNew_Click` | Button |
| 17 | spdSub | FarPoint FpSpread | — | Dock=Fill, 1192×213 | — | (배선 없음) | Wijmo FlexGrid |
| 18 | spdSub_Sheet1 | FarPoint SheetView | (시트 `Change Request`) | AddSheet CreateSpread:527, ChangeSheet:537, SetSheetHeaderColumn InitSpread:599 | — | — | FlexGrid columns(메타, 2단 헤더) |
| 19 | usrLayoutControl2 | UsrLayoutControl | "usrLayoutControl2" | Dock=Fill, 432×179 | — | — | 버튼 영역 레이아웃 |
| 20 | dtDate | UsrDatePicker | 미추출 (lcDate, 확인 필요) | 92×20, **Visible=false** | — | — | InputDate(숨김) |
| 21 | btnDel | DevExpress SimpleButton | "Delete" | 92×22 | — | **배선 없음(확인 필요)** | Button |
| 22 | btnCancel | DevExpress SimpleButton | "Cancel" | 93×22 | — | Click→`BtnCancel_Click` | Button |
| 23 | btnSave | DevExpress SimpleButton | "Save Draft" | 92×22, **Visible=false** | — | Click→`BtnSave_Click` | Button(숨김) |
| 24 | btnAdd | DevExpress SimpleButton | "Add Date" | 93×22, **Visible=false** | — | **배선 없음(확인 필요)** | Button(숨김) |
| 25 | btnChangeRe2 | DevExpress SimpleButton | "Request Complete" | 127×22 | — | Click→`BtnChangeRe_Click` | Button |
| 26 | usrLayoutControl3 | UsrLayoutControl | 미추출 | 확인 필요 | — | — | 요청 정보 폼 레이아웃 |
| 27 | txtRequestNo | TextBox | 미추출 (확인 필요) | 바인딩 후보 CHANGE_REQ_NO | 확인 필요 | — | Input(읽기전용 여부 확인 필요) |
| 28 | txtTitle | TextBox | 미추출 (lcTitle) | 바인딩 후보 REQUEST_TITLE | 확인 필요 | — | Input |
| 29 | txtRequestor | TextBox | 미추출 | 바인딩 후보 REQUEST_USER/REQUEST_USER_NAME, 조회 시 ds.Tables[1] USER_NAME 등 | 확인 필요 | — | Input |
| 30 | txtRequestDeptName | TextBox | 미추출 | 바인딩 후보 REQUEST_DEPT/REQUEST_DEPT_NAME | 확인 필요 | — | Input |
| 31 | txtAppDeptName | TextBox | 미추출 (lcAppDept) | 바인딩 후보 APPROVAL_DEPT/APPROVAL_DEPT_NAME | 확인 필요 | — | Input |
| 32 | cboChangeReason | UsrComboBox | 미추출 (lcChangeReason) | 바인딩 후보 CHANGE_REASON_CODE, 목록 확인 필요 | 확인 필요 | — | ComboBox |
| 33 | txtReasonDetail | TextBox | 미추출 (lcReasonDetail) | 바인딩 후보 CHANGE_REASON_DETAIL | 확인 필요 | — | Input / TextArea |
| 34 | btnApprovalUser | UsrButton | 미추출 | — | — | Click→`BtnApprovalUser_Click` | Button(사용자 선택 팝업 후보) |
| 35 | usrLabel2 | UsrLabel | 미추출 | — | — | — | Label |
| 36 | txtApproval | TextBox | 미추출 (lcApproval) | 바인딩 후보 APPROVAL_USER/APPROVAL_USER_NAME | 확인 필요 | — | Input |
| 37 | txtItemId | UsrMultiLineEditor | — | **parent 공란(배치 확인 필요)** | — | — | 확인 필요 |

- 27~36의 바인딩 후보는 `SetChangeRequestInfo`가 dt.Rows[0]에서 읽는 컬럼 이름과 컨트롤 이름이 비슷한 데서 나온 **추정**입니다. 실제 대입 대상은 **확인 필요**입니다(1986~1997).
- 그 밖의 비가시·레이아웃 객체: splitContainer1, panel1, panel3, layoutControlGroup1~3, LayoutControlItem 28개, EmptySpaceItem 8개, imageList1.
- 비컨트롤 이벤트 소스: `dsdm`(Changed→`shtMain_Change`). controls.csv에 없는 객체라 정체는 **확인 필요**입니다.

---

## 4. 그리드 명세

> 출처 META = `SCM_MST_SHEET_COLUMNS`(PROGRAM_ID=SSP0201, 123행), CODE_ONLY = 메타 행 없이 코드에서만 다루는 컬럼. 컬럼 셀 타입(CELL_CONTROL_OBJECT_TYPE_CODE)과 편집 가능 여부(잠금)는 메타 행 값이 Fact Pack에 없어 **확인 필요**입니다(표에는 코드에서 확인된 콤보·체크박스만 적었습니다). 표의 컬럼 순서는 표시 순서가 아닙니다(정렬 컬럼 미첨부, **확인 필요**).

### 4-1. 시트 `Shipment Change Request` (spdMain · 헤더 1행 · 메타 65행 · 기본 표시 33)

**표시 컬럼 (메타 기본 33)**

| 컬럼 | 헤더(메타 라벨) | 타입(코드 확인분) | 출처 | division별 표시 | 편집 |
|---|---|---|---|---|---|
| ATTRIBUTE10 | ATTRIBUTE10 | 확인 필요 | META | 전체 | 확인 필요 |
| CHANGE_REASON_CODE | Change Reason | 확인 필요 | META | 전체 | 확인 필요 |
| CHANGE_REASON_DETAIL | Reason Detail | 확인 필요 | META | 전체 | 확인 필요 |
| CONFIRM_ID | Confirm/Plan ID | 확인 필요 | META | 전체 (ChangeType "P" → Width 0, 그 외 Width 120) | 확인 필요 |
| DIVISION_ID | Div | 셀 콤보(GetSSPInnerTable "MyDivision") | META | 전체 | 콤보 선택(ComboSelChange 대상) |
| EDIT_MAIN | EDIT_MAIN | 확인 필요 | META | 전체 | 확인 필요 |
| END_CUSTOMER | End Customer* | 확인 필요(setEndCustomer CODE/NAME) | META + 코드 | **40·EE만 표시** | 확인 필요 |
| ERP_SO_NO | SO No | 확인 필요 | META | 전체 (ChangeType "P" → Width 0) | 확인 필요 |
| ETA | ETA | 확인 필요 | META | 전체 | 확인 필요 |
| ETD | ETD | 확인 필요 | META | 전체 | 확인 필요 |
| FCST_TYPE | FCST Type* | 확인 필요 | META | 전체 | 확인 필요 |
| FROM_SITE | From Site ID | 확인 필요 | META | 전체 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site* | 셀 콤보(Data.UserPlantSiteByDivisionOspPack) | META | 전체 | 콤보 선택 |
| INCOTERMS | Incoterms | 확인 필요(BOD 조회로 세팅) | META | 전체 | 확인 필요 |
| ITEM_ID | Model* | 확인 필요 | META | 전체 | 확인 필요 |
| LT_DAY | L/T(Day) | 확인 필요 | META | 전체 | 확인 필요 |
| MTK_OWNER | MKT Owner | 확인 필요 | META | 전체 | 확인 필요 |
| NICK_NAME | Nick Name | 확인 필요 | META | 전체 | 확인 필요 |
| PROJECT_CODE | Project Code* | 확인 필요 | META + 코드 | **40·EE 숨김**, 그 외 표시 | 확인 필요 |
| PROJECT_NAME | Project Name | 확인 필요 | META + 코드 | **40·EE 숨김**, 그 외 표시 | 확인 필요 |
| REMARKS | Remarks | 확인 필요 | META | 전체 | 확인 필요 |
| REMARKS2 | Building | 확인 필요 | META | 전체 | 확인 필요 |
| REMARKS3 | Customer Requirement | 확인 필요 | META | 전체 | 확인 필요 |
| REQUEST_DATE | Request Date | 확인 필요 | META | 전체 | 확인 필요 |
| REQUESTOR | Shipment Requestor | 확인 필요 | META | 전체 | 확인 필요 |
| SHIPMENT_CONFIRM_QTY | Shipment Qty* | 확인 필요 | META | 전체 | 확인 필요 |
| SHIPMENT_DATE | Shipment Date* | 확인 필요 | META | 전체 | 확인 필요 |
| SHIPMENT_STATUS | Status | 확인 필요 | META | 전체 | 확인 필요 |
| TO_SITE | To Site ID | 확인 필요 | META | 전체 | 확인 필요 |
| TO_SITE_DESCRIPTION | To Site* | 셀 콤보(Data_SCP.Common ShipmentPlanToSite / ToSiteByDivisionEEForSSP) | META | 전체 | 콤보 선택(BOD 조회 트리거 후보) |
| TO_SITE_SHIPTO_CODE | Ship to | 셀 콤보(`biz:CommonData.CommonDataList` [ShipToCodeByDivision]) | META | 전체 | 콤보 선택 |
| TO_SITE_SOLDTO_CODE | Sold to | 확인 필요 | META | 전체 | 확인 필요 |
| TRANSPORT_MODE | Trans Mode* | 셀 콤보(`biz:CommonData.CommonDataList` [TransMode]) | META | 전체 | 콤보 선택 |

**메타 숨김 컬럼 (32)**: BOD_ID, CHANGE_REQ_NO, CHANGE_TYPE, CHECK_NEED_YN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, Expected_Shipping_Date, MODEL_USER, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, SHIPTO_DESCRIPTION, SOLDTO_DESCRIPTION, TEAM, UPDATED_BY, UPDATED_DATE

**CODE_ONLY**: CHK(메타 행 없음, grid_effective "→숨김?"). 헤더 체크박스 토글은 `SpdMain_CellClick`에서 처리합니다.

**division별 표시 수**: 40·EE = 31 / 81·81_HD·81_HG·81_HM·81_ST·81_UC·82·EE_HD·EE_HG·EE_HM·EE_ST·EE_UC = 32 (각 판단불가 ?4)

### 4-2. 시트 `Change Request` (spdSub · 헤더 2행 · 메타 58행 · 기본 표시 28)

| 컬럼 | 헤더 1행(메타 라벨) | 헤더 0행 그룹 | 타입(코드 확인분) | 출처 | division별 표시 | 편집 |
|---|---|---|---|---|---|---|
| CHK | ALL | — | 체크박스(Value=false, bevel) | META + 코드 | 전체, 단 SetChangeRequestSOGrid 조건부 숨김(2061) | 체크 가능(조건 확인 필요) |
| CHANGE_REQ_NO | Change Req.No | — | 확인 필요 | META | 전체 | 확인 필요 |
| CONFIRM_ID | Confirm id | — | 확인 필요 | META | 전체 | 확인 필요 |
| ERP_SO_NO | SO No | — | 확인 필요 | META + 코드 | ChangeType "P" → 숨김, 그 외 표시 | 확인 필요 |
| FCST_TYPE | FCST Type | — | 확인 필요 | META | 전체 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site | — | 확인 필요 | META | 전체 | 확인 필요 |
| TO_SITE_DESCRIPTION | To Site | — | 확인 필요 | META | 전체 | 확인 필요 |
| ITEM_ID | Model | — | 확인 필요 | META | 전체 | 확인 필요 |
| NICK_NAME | Nick Name | — | 확인 필요 | META | 전체 | 확인 필요 |
| PROJECT_NAME | Project Name | — | 확인 필요 | META (+ 코드 ?) | grid_effective: 40·EE →숨김?, 그 외 →표시? (적용 여부 확인 필요) | 확인 필요 |
| SHIPTO_CODE | ShipTo Code | — | 확인 필요 | META | 전체 | 확인 필요 |
| INCOTERMS | Incoterms | — | 확인 필요 | META | 전체 | 확인 필요 |
| LT_DAY | L/T(Day) | "Plan"(P) / "Confirmed"(그 외) 7열 병합 시작 | 확인 필요 | META + 코드 | 전체 | 확인 필요 |
| ETD | ETD | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| ETA | ETA | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| TRANSPORT_MODE | Trans Mode | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| SHIPMENT_DATE | Shipment Date | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| SHIPMENT_CONFIRM_QTY | Qty | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| NEW_LT_DAY | L/T(Day) | "Confirm"(P) / "Change"(그 외) 7열 병합 시작 | 확인 필요 | META + 코드 | 전체 | 확인 필요 |
| NEW_ETD | ETD | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| NEW_ETA | ETA | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| NEW_TRANSPORT_MODE | Trans Mode | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| NEW_SHIPMENT_DATE | Shipment Date* | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| NEW_SHIPMENT_CONFIRM_QTY | Qty* | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| NEW_SHIPTO_CODE | ShipTo Code | — | 확인 필요 | META | 전체 | 확인 필요 |
| REMARKS | Remarks | — | 확인 필요 | META + 코드 | **Width=0(619)** — 화면에서는 안 보일 수 있음 | 확인 필요 |
| REMARKS2 | Building | — | 확인 필요 | META | 전체 | 확인 필요 |
| REMARKS3 | Customer requirement | — | 확인 필요 | META | 전체 | 확인 필요 |

**메타 숨김 컬럼 (30)**: A_COUNTRY, A_PORT_CODE, BOD_ID, CUSTOMER_LT, D_COUNTRY, D_PORT_CODE, DIVISION_ID, ELECTRODE_TYPE, ELECTRODE_YN, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BASE_CONFIRM_YN, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_INCOTERMS, NEW_ROUTE_ID, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_YN, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, PLAN_CONFIRM_ID, PROJECT_CODE(코드 →표시? 분기 있음), ROUTE_ID, TO_CITY, TO_COUNTRY, TO_SITE

**CODE_ONLY**: END_CUSTOMER (40·EE →표시?, 그 외 →숨김?)

**division별 표시 수**: 40·EE = 27 / 그 외 12개 = 28 (각 ?5)

- 0행 그룹은 7열 병합인데, 1행 라벨은 그룹마다 6개만 확인됩니다. 7번째 열은 **확인 필요**입니다(메타 정렬 기준 인접 숨김 컬럼일 수 있음).
- SetChangeRequestSOGrid(2042)는 행 루프에서 `CAppSetting.StringAction` 컬럼을 숨깁니다. 대상 컬럼은 **확인 필요**입니다.

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 로드(this.Load) | `Form_Load` | InitControls → GetDayRange, CreateSpread/InitSpread | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | drpPeriod 기본값, 시트 2개 헤더 |
| A2 | 툴바 조회 | FindButton | FindData_Main, FindData_Sub_Draft | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | spdMain, spdSub, 요청자 정보 |
| A3 | 툴바 행 추가 | InsertButton | InsertRow (IsLock=false일 때) | `biz:CommonData.CommonDataList` [ShipToCodeByDivision] | spdMain 신규 행, Ship to 콤보 |
| A4 | 툴바 저장 | SaveButton | SSP_Main_Validation → 채번 → 확정 저장 → GetERPInterface / GetNewERPInterface → 재조회 | `SSP.SSP0201_GET_CHANGE_REQ_NO`, `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW`, `SSP.SSP0201_GET_SHIPMENT_STATUS`, `SSP.SSP0201_GET_ERP_SO_NO_CNT`, `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | 상·하 그리드 재조회 (분기 조건 확인 필요) |
| A5 | btnChangeRe "Request Complete" | `BtnChangeRe_Click` | SaveDataDrafting → FindButton | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` → `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | 요청 완료(메일 체인), 재조회 |
| A6 | btnChangeRe2 "Request Complete" | `BtnChangeRe_Click` | A5와 같음 | A5와 같음 | A5와 같음 |
| A7 | btnSave "Save Draft"(Visible=false) | `BtnSave_Click` | SaveDataDrafting → FindButton | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` → 재조회 2종 | A5와 같음 (의도 확인 필요) |
| A8 | btnCancel "Cancel" | `BtnCancel_Click` | DeleteDataDrafting → FindButton | `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` → `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | 요청 취소, ERP/SCS I/F INSERT, 재조회 |
| A9 | btnNew "NEW" | `BtnNew_Click` | 신규 행 (IsLock=false, NowGroupID 사용) | `biz:CommonData.CommonDataList` [ShipToCodeByDivision] | spdMain 신규 행 |
| A10 | btnApprovalUser | `BtnApprovalUser_Click` | 확인 필요 | 추출 없음 | 확인 필요 |
| A11 | btnItemId | `btnItemId_Click` | 확인 필요 | 추출 없음 | 확인 필요 |
| A12 | clbDivision_ID 변경 | `clbDivision_ID_SelectedIndexChanged` | 확인 필요 | 추출 없음 | 확인 필요(40/EE 컬럼 전환과의 관계) |
| A13 | cboChangeType 변경 | `CboChangeType_SelectedIndexChanged` | GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | drpPeriod 재계산 |
| A14 | dsdm.Changed | `shtMain_Change` | 확인 필요 | 추출 없음 | 확인 필요 |
| A15 | spdMain TopChange | `SpdMain_TopChange` | 확인 필요 | 추출 없음 | 확인 필요 |
| A16 | spdMain CellClick | `SpdMain_CellClick` | TRANSPORT_MODE / TO_SITE_SHIPTO_CODE 콤보 로딩, 헤더 체크 토글 | `biz:CommonData.CommonDataList` [TransMode], [ShipToCodeByDivision] | 셀 콤보 목록, 체크 상태 |
| A17 | spdMain CellDoubleClick | `SpdMain_CellDoubleClick` | 확인 필요 | 추출 없음 | 확인 필요 |
| A18 | spdMain EditChange | `SpdMain_EditChange` | 확인 필요 | 추출 없음 | 확인 필요 |
| A19 | spdMain ClipboardPasted | `SpdMain_ClipboardPasted` | 붙여넣은 행 콤보 세팅 | `biz:CommonData.CommonDataList` [ShipToCodeByDivision] | Ship to 콤보 |
| A20 | spdMain ComboSelChange | `SpdMain_ComboSelChange` | Ship to 콤보, FindData_BOD, DIVISION_ID 변경 시 END_CUSTOMER/PROJECT_* 표시 전환 | `biz:CommonData.CommonDataList` [ShipToCodeByDivision], `SSP.SSP0026_GET_BOD_ITEM`, `biz:CommonData.CommonDataList` [TransMode] | ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL 세팅 |
| A21 | spdMain CursorChanged | `SpdMain_CursorChanged` | 확인 필요 | 추출 없음 | 확인 필요 (상·하 연동 여부) |
| A22 | btnDel "Delete" / btnAdd "Add Date" | 배선 없음 | — | — | **확인 필요** |

- `GetErpIFCheck`(4276 → `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING`)는 진입점이 없어 액션에 넣지 않았습니다(**확인 필요**).

---

## 6. 검증·메시지

| 검증 | 위치 | 대상 | 메시지 |
|---|---|---|---|
| 저장 전 필수 검사(Validationdr) | SSP_Main_Validation 3188~3195 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, INCOTERMS, remarks2, remarks, TO_SITE_SHIPTO_CODE | 확인 필요 |
| 저장 전 필수 검사(SONoValidationdr) | 3238~3244, 3315~3321 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE | 확인 필요 |
| ERP I/F 차단 | chkERPIFBlockYn | BLOCK_YN, PERIOD | 확인 필요 |
| 출하 상태 검사 | GetShipmentStatusChk (`SSP.SSP0201_GET_SHIPMENT_STATUS`) | ds.Tables[0~2] CONFIRM_ID | 확인 필요 |
| SO 건수 검사 | GetErpSoNoCnt (`SSP.SSP0201_GET_ERP_SO_NO_CNT`) | CNT | 확인 필요 |
| 시트 잠금 | InsertRow, BtnNew_Click, SpdMain_CellClick | `siMain.IsLock(siMain.SheetName) == false` | (메시지 없이 동작 생략으로 보임, 확인 필요) |

- 메시지 문구 원문은 Fact Pack에 없습니다. 전환 시 `validation.md`/`__asis-mapping__.md`에 원문을 대조해야 합니다.

---

## 7. 권한 (C/R/U/D) 사실

| 권한 | 관련 진입점 | 사실 |
|---|---|---|
| R | FindButton | 툴바 버튼(entry_kind=button) |
| C | InsertButton, btnNew | 시트 잠금 시 미동작 |
| C/U | SaveButton, btnChangeRe, btnChangeRe2, btnSave | INSERT/MERGE/UPDATE SP 호출 |
| D 성격 | btnCancel | DELETE SP(`SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING`) 호출 |
| 그룹 필터 | SetChangeControl 외 | `UserInfoContext.Current["NowGroupID"]`, Filter GROUP_ID/USER_ID |
| 메뉴 권한 | — | TB_FX_GroupMenuAuth 8행(값 **확인 필요**) |

---

## 8. To-Be 전환 메모 (Wijmo·Oracle 관점)

| 항목 | AS-IS | To-Be 고려점 |
|---|---|---|
| 분할 레이아웃 | SplitContainer 상/하 253:396 | 상/하 분할(≈39:61) 유지. 하단은 폼(panel3) + 그리드 |
| 그리드 | FarPoint FpSpread + 메타 SetSheetHeaderColumn | Wijmo FlexGrid + 메타 컬럼 정의(공통 메타 로딩) |
| 2단 헤더 | ColumnHeaderSpan 7열 병합, ChangeType별 문구 | FlexGrid columnHeaders 병합 / 컬럼 그룹. 문구를 ChangeType 값으로 바꿔야 함 |
| 헤더 체크박스 | CheckBoxCellType 헤더 토글 | FlexGrid 헤더 체크박스(전체 선택) |
| 셀 콤보 지연 로딩 | CellClick/ComboSelChange에서 CommonDataList 호출 | DataMap. 로딩 시점(사전/지연)은 설계 결정 필요 |
| 컬럼 Width=0 숨김 | ERP_SO_NO, CONFIRM_ID, REMARKS | Width 0이 아니라 visible=false로 바꿀지 결정 필요(결과 화면 동일성 확인) |
| division 컬럼 전환 | InitSpread·ComboSelChange에서 Visible 전환 | 상태 기반 columns visible 계산 |
| MSSQL → Oracle | STRING_SPLIT, #TMP_*/#TBL* 임시 테이블, 동적 SQL, SP_SEND_DBMAIL, FN_* 함수 | STRING_SPLIT은 Oracle 분할 함수로, 임시 테이블은 GTT 등으로 대체. 동적 SQL은 바인드 변수 전환. 메일 발송 방식은 아키텍처 결정 필요 |
| 다중 결과셋 | GET_SHIPMENT_REQUEST_DRAFTING(Tables[1] 요청자), GET_SHIPMENT_STATUS(Tables[0~2]) | Oracle SYS_REFCURSOR 다중 OUT 또는 API 분리 |
| 숨김 버튼 | btnSave, btnAdd, dtDate, txtSoNo Visible=false | 표시 조건을 확인한 뒤 구현 여부 결정 |

---

## 9. 미확정

1. usrLayoutControl3 안 컨트롤 라벨 원문, panel1의 Dock/Size (props 잘림)
2. txtRequest 라벨(항목 이름 Model), btnItemId·dtDate 라벨
3. txtItemId 배치(parent 공란), dsdm 객체 정체
4. btnDel, btnAdd 동작(배선 없음)
5. btnSave 표시 조건과 COMPLETE SP를 호출하는 의도
6. SaveButton 내부 분기 조건(GetERPInterface / GetNewERPInterface, FindData_Main / FindData_Main_Nonasync)
7. 핸들러 내부 로직 미추출: `clbDivision_ID_SelectedIndexChanged`, `SpdMain_TopChange`, `BtnApprovalUser_Click`, `shtMain_Change`, `SpdMain_CellDoubleClick`, `SpdMain_EditChange`, `btnItemId_Click`, `SpdMain_CursorChanged`
8. 그리드 컬럼 셀 타입·편집 가능 여부·표시 순서(메타 행 값 미첨부)
9. Change Request 2단 헤더 7번째 열, REMARKS Width=0 처리
10. 콤보 목록 출처(cboStatus, cboChangeType, cboChangeReason, clbDivision_ID, clbFromSite, clbToSite)
