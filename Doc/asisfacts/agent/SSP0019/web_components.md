# SSP0019 Web 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑
| As-is 컨트롤 | 유형 | 라벨(원문) | LayoutItem | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|
| clbDivision | UsrCheckedList | Division | lcDivision | 다중선택 콤보(Wijmo MultiSelect 계열) | SelectedIndexChanged 핸들러 있음 |
| clbFromSite | UsrCheckedList | From Site | FromSite | 다중선택 콤보 | |
| clbToSite | UsrCheckedList | To Site | ToSite | 다중선택 콤보 | |
| clbTransportMode | UsrCheckedList | 확인 필요(Text 미추출) | TransportMode | 다중선택 콤보 | LayoutItem 이름은 TransportMode |
| clbIncomterms | UsrCheckedList | Incoterms | Incotemrs | 다중선택 콤보 | LayoutItem 이름 오타(Incotemrs)는 원문 그대로 |
| drpPeriod | UsrDateRangePicker | Shipment Date | ShipmentDate | 기간(From~To) 입력 | 초기값은 `SCP.GET_DATE_RANGE_1MONTH` |
| txtSoNo | UsrMultiLineEditor | SO No | lblSONo | 다건 입력 텍스트 | |
| txtItemId | UsrMultiLineEditor | Model | lblItemId | 다건 입력 텍스트 | btnItemId 결과 반영 |
| btnItemId | UsrButton | (Text 미추출) | layoutControlItem2 | 조회 팝업 버튼 | Click → txtItemId.Text 설정 |
| txtConfirmId | UsrMultiLineEditor | Confirm ID | layoutControlItem3 | 다건 입력 텍스트 | |
| chkCurrent | UsrCheckBox | Current | layoutControlItem1 | 체크박스 | CheckedChanged 핸들러 있음 |
| spdMain | FpSpread | - | - | Wijmo FlexGrid | 시트 1개 |

## 2. 화면 배치
- SplitContainer 는 없습니다. 영역은 Dock 으로 나뉩니다.

| 컨트롤 | Dock | Size |
|---|---|---|
| usrConditionPanel1 (UsrPanelType=HidePanel) | Top | 1192×69 |
| usrLayoutControl1 (조건 레이아웃) | Fill(패널 내부) | 1192×69 |
| splitter1 | Bottom | 1192×3 |
| spdMain | Fill | 1192×577 |

- 상/하 분할: 조건영역 69 : 그리드 577 (높이 기준, 조건 약 10.7% / 그리드 약 89.3%. 69+577=646 기준으로 계산).
- splitter1 이 Dock=Bottom 이라 실제 분할선 위치가 의도와 같은지는 **확인 필요**.
- 조건 영역 LayoutItem 크기: FromSite 197×24, ShipmentDate 286×26, layoutControlItem2 43×28, lblSONo 157×28, ToSite 157×24, Incotemrs 406×24, lblItemId 154×28, layoutControlItem1 73×24, lcDivision 286×26, TransportMode 204×28, layoutControlItem3 202×28. 빈 칸(EmptySpaceItem): 4=126×28, 6=53×24, 7=230×26. 행·열 배치 좌표는 **확인 필요**.

## 3. 시트별 Grid 컬럼 — `Shipment Change History`
- 연결 규칙: **META+코드연결** (AddSheet/ChangeSheet + SetSheetHeaderColumn)
- 코드 하드코딩: `REQUEST_NO` CellType = cellTypeImage (InitSpread:339)
- Division별 표시 차이: 없음 (전 division 46컬럼 표시)

| # | 컬럼 | 라벨 | 출처 | 표시(전 division 공통) | 코드 변경 |
|---:|---|---|---|---|---|
| 1 | APPROVAL | Approval | META | 기본 | |
| 2 | APPROVAL_DATE | Approval Date | META | 기본 | |
| 3 | APPROVAL_DEPT_NAME | Approval Dept Name | META | 기본 | |
| 4 | BEFORE_INCOTERMS | Before Incoterms | META | 기본 | |
| 5 | BEFORE_QTY | Before QTY | META | 기본 | |
| 6 | BEFORE_SHIPMENT_DATE | Before Shipment Date | META | 기본 | |
| 7 | BEFORE_TRANSPORT_MODE | Before Trans Mode | META | 기본 | |
| 8 | BUILDING | Building | META | 기본 | |
| 9 | CHANGE_REASON_CODE | Change Reason | META | 기본 | |
| 10 | CHANGE_REASON_DETAIL | Change Reason Detail | META | 기본 | |
| 11 | CHANGE_TYPE | Change Type | META | 기본 | |
| 12 | CONFIRM_ID | Confirm ID | META | 기본 | |
| 13 | CUSTOMER_LT | L/T(Day) | META | 기본 | |
| 14 | CUSTOMER_REQUIRMENT | Customer Requirement | META | 기본 | |
| 15 | DIVISION_ID | Div | META | 기본 | |
| 16 | END_CUSTOMER | End Customer | META | 기본 | |
| 17 | ERP_SO_NO | SO No | META | 기본 | |
| 18 | FCST_TYPE | FCST Type | META | 기본 | |
| 19 | FROM_SITE | From Site | META | 기본 | |
| 20 | INCOTERMS | Incoterms | META | 기본 | |
| 21 | ITEM_ID | Model | META | 기본 | |
| 22 | LAST_SEQ | Last Seq | META | **숨김** | |
| 23 | LAST_UPDATE_DATE | Last Update Date | META | 기본 | |
| 24 | MODEL_PIC | Model PIC | META | 기본 | |
| 25 | MTK_OWNER | MKT Owner | META | 기본 | |
| 26 | NICK_NAME | Nick Name | META | 기본 | |
| 27 | PROJECT_NAME | Project Name | META | 기본 | |
| 28 | QTY | Qty | META | 기본 | |
| 29 | QTY_CHANGE | Qty Change | META | 기본 | |
| 30 | REMARKS | Remarks | META | 기본 | |
| 31 | REMARKS_CHANGE | Remarks Change | META | 기본 | |
| 32 | REQUEST_DATE | Request Date | META | 기본 | |
| 33 | REQUEST_NO | Request No | META | 기본 | CellType=cellTypeImage |
| 34 | REQUESTOR | Requestor | META | 기본 | |
| 35 | REQUESTOR_DEPT_NAME | Requestor Dept Name | META | 기본 | |
| 36 | SEQ | Seq | META | 기본 | |
| 37 | SHIP_TO_PARTY | Ship To Party | META | 기본 | |
| 38 | SHIPMENT_DATE | Shipment Date | META | 기본 | |
| 39 | SHIPMENT_DATE_CHANGE | Shipment Date Change | META | 기본 | |
| 40 | SHIPMENT_REQUESTOR | Shipment Requestor | META | 기본 | |
| 41 | SOLD_TO_PARTY | Sold To Party | META | 기본 | |
| 42 | TO_SITE | To Site | META | 기본 | |
| 43 | TRANS_MODE_CHANGE | Trans Mode Change | META | 기본 | |
| 44 | TRANSPORT_MODE | Trans Mode | META | 기본 | |
| 45 | TYPE | Type | META | 기본 | |
| 46 | VARIABLE_DATE | Variable Date | META | 기본 | |
| 47 | VARIABLE_QTY | Variable Qty | META | 기본 | |

- 위 순서는 grid_effective.csv 행 순서(알파벳순)입니다. 실제 표시 순서·폭·정렬·고정(FIXED_FLAG) 값은 SCM_MST_SHEET_COLUMNS 메타 원문으로 **확인 필요**.
- AddSheet 인자 `1 ¦ 1 ¦ 30` 의 의미(헤더 행 수·고정 등)는 **확인 필요**.

## 4. 시트 연결 규칙
- 시트는 `Shipment Change History` 1개(SpdSheet.shtMain)입니다. 다른 시트와 마스터-디테일 연결은 추출되지 않았습니다.
- `SpdMain_CellClick` 이 REQUEST_NO 이미지 셀과 연동되어 다른 동작(팝업 등)을 하는지는 **확인 필요**.
