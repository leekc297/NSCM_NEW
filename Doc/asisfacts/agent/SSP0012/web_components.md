# SSP0012 Web 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

| AS-IS 컨트롤 | 유형 | 라벨 (원문) | Size | TO-BE 후보 | 비고 |
|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | - | 1192×73, Dock Top, `HidePanel` | 조회조건 영역(접기 가능) | `UsrPanelType = HidePanel` |
| usrLayoutControl2 | UsrLayoutControl | (Text `usrLayoutControl2`) | 1192×73, Dock Top | 조회조건 레이아웃 | - |
| clbPlantSite | UsrCheckedList | `From Site` (layoutControlItem7) | 100×21 | 다중 선택 콤보(MultiSelect) | 항목 데이터 출처 **확인 필요** |
| txtItemId | UsrMultiLineEditor | `Model` (lblItemId) | 272×21 | 여러 줄 입력 | - |
| btnItemId | UsrButton | (LayoutControlItem Text 없음, layoutControlItem2) | 39×24 | 검색 버튼(팝업 후보) | 결과 → `txtItemId.Text` (341행). 팝업 여부 **확인 필요** |
| drpPeriod | UsrDateRangePicker | `Period*` (layoutControlItem6) | 205×20 | 기간(From~To) 날짜 범위, 필수 표시 `*` | 기본값 = `SCM0001_GET_SCP_DAY_PERIOD` 결과 |
| clbDivision | UsrCheckedList | `Division` (lcDivision) | 100×21 | 다중 선택 콤보 | 변경 시 기간 재계산 |
| txtSoldToParty | TextBox | `Sold To Party` (layoutControlItem1) | 273×20 | 텍스트 입력 | - |
| txtShipToParty | TextBox | `Ship To Party` (layoutControlItem3) | 268×20 | 텍스트 입력 | - |
| btnColumn | UsrButton | (LayoutControlItem Text 없음, layoutControlItem5) | 39×25 | 컬럼 설정 버튼 후보 | 동작 **확인 필요** |
| usrButton1 | UsrButton | - | 75×23 | **확인 필요** | parent 없음. 배치 여부 **확인 필요** |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | - | 1192×576, Dock Fill | Wijmo `FlexGrid` | 시트 `Shipment Plan Confirm Detail` |
| imageList1 | ImageList | - | - | 아이콘 리소스 | 이미지 셀(`cellTypeImage`) 관련 여부 **확인 필요** |
| emptySpaceItem3 / emptySpaceItem1 | EmptySpaceItem | - | 464×29 / 156×29 | 여백 | - |

## 2. 화면 배치

- props.csv 에 **SplitContainer 는 없습니다**. Dock 으로 상·하 2단 구성입니다.

| 영역 | 컨트롤 | Dock | Size(높이) | 비율(높이 기준) |
|---|---|---|---:|---:|
| 상단 | usrConditionPanel1 (조회조건) | Top | 73 | 73 / 649 ≈ 11.2% |
| 하단 | spdMain (Grid) | Fill | 576 | 576 / 649 ≈ 88.8% |

- 폭은 둘 다 1192입니다. 좌·우 분할은 없습니다.
- 조회조건 그룹 layoutControlGroup2 는 1192×78입니다. LayoutControlItem 의 높이가 모두 29이므로, 조회조건은 1행 또는 다중 행 배치로 보입니다. 행/열 배치(Location)는 미추출이므로 **확인 필요**입니다.
- 조회조건 Item 폭: From Site 161, Model 313, 버튼 43, Period* 309, Division 148, Sold To Party 356, Ship To Party 351, 버튼 43

## 3. 시트별 Grid 컬럼 — `Shipment Plan Confirm Detail`

- 연결 규칙: **META+코드연결**. 메타(`SCM_MST_SHEET_COLUMNS`) 47행을 `SetSheetHeaderColumn(spdInfo, 2)` 로 만들고, 헤더는 2행입니다.
- 표시 기준: grid_effective. 모든 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)의 결과가 같습니다.

| # | 컬럼 | 라벨 | 출처 | 표시 | 코드 변경 |
|---:|---|---|---|---|---|
| 1 | A_COUNTRY | Country* | META | 기본 | - |
| 2 | A_PORT_CODE | Port Code* | META | 기본 | - |
| 3 | A_PORT_NAME | Port* | META | 기본 | - |
| 4 | BIZ_TYPE_NAME | Biz Name | META | 기본 | - |
| 5 | BOD_ID | bod_id | META | **숨김** | - |
| 6 | CHANGE_REQ_NO | Change Request No | META | 기본 | CellType = `cellTypeImage` (InitSpread:271) |
| 7 | CONFIRM_ID | Confirm ID | META | 기본 | - |
| 8 | CONFIRM_QTY | Confirmed Qty | META | 기본 | - |
| 9 | D_COUNTRY | Country* | META | 기본 | - |
| 10 | D_PORT_CODE | Port Code* | META | 기본 | - |
| 11 | D_PORT_NAME | Port* | META | 기본 | - |
| 12 | DAYS_FRI | Fri | META | 기본 | - |
| 13 | DAYS_MON | Mon | META | 기본 | - |
| 14 | DAYS_SAT | Sat | META | 기본 | - |
| 15 | DAYS_SUN | Sun | META | 기본 | - |
| 16 | DAYS_THU | Thu | META | 기본 | - |
| 17 | DAYS_TUE | Tue | META | 기본 | - |
| 18 | DAYS_WED | Wed | META | 기본 | - |
| 19 | DIVISION_ID | Division | META | 기본 | - |
| 20 | ERP_SO_NO | SO No | META | 기본 | - |
| 21 | ETA | ETA | META | 기본 | - |
| 22 | ETD | ETD | META | 기본 | - |
| 23 | Expected_Shipping_Date | Expected Shipping Date | META | 기본 | - |
| 24 | FCST_TYPE | FCST Type | META | 기본 | - |
| 25 | FROM_SITE_DESCRIPTION | From Site | META | 기본 | - |
| 26 | INCOTERMS | Incoterms | META | 기본 | CellType = `cellTypeImage` (InitSpread:270) |
| 27 | ITEM_ID | Model | META | 기본 | - |
| 28 | LAST_UPDATE_DATE | Last Update Date | META | 기본 | - |
| 29 | LAST_UPDATED_BY | Last Updated By | META | 기본 | - |
| 30 | LT_ARRIVAL_INLAND | Arrival Inland | META | 기본 | - |
| 31 | LT_DAY | L/T(Day) | META | 기본 | - |
| 32 | LT_DEPARTURE_INLAND | Departure Inland | META | 기본 | - |
| 33 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | META | 기본 | - |
| 34 | LT_SUM | Total L/T | META | 기본 | - |
| 35 | LT_TYPE | L/T Type | META | 기본 | - |
| 36 | LT_VOYAGE | Voyage | META | 기본 | - |
| 37 | LT_WAIT_SHIPPING | Waiting For Shipping | META | 기본 | - |
| 38 | MTK_OWNER | MKT Owner | META | 기본 | - |
| 39 | NICK_NAME | Nick Name | META | 기본 | - |
| 40 | ORIGIN_FROM_DIVISION_ID | ORIGIN_FROM_DIVISION_ID | META | **숨김** | - |
| 41 | PLAN_DATE | Shipment Date(GI) | META | 기본 | - |
| 42 | PLAN_QTY | Planned Qty | META | **숨김** | - |
| 43 | PROJECT_NAME | Project Name | META | 기본 | - |
| 44 | SHIPTO_DESCRIPTION | Ship To Party | META | 기본 | - |
| 45 | SOLDTO_DESCRIPTION | Sold To Party | META | 기본 | - |
| 46 | TO_SITE_DESCRIPTION | To Site | META | 기본 | - |
| 47 | TRANSPORT_MODE | Trans Mode | META | 기본 | - |

- 집계: 메타 47 / 표시 44 / 숨김 3 / 코드 추가 컬럼 0 / 코드 변경 2(CellType)
- 위 표는 grid_effective 의 순서(컬럼명 정렬)입니다. **실제 컬럼 순서**(메타 정렬 순번), 폭, 정렬, 고정(FIXED_FLAG), 2행 헤더의 상단 그룹 텍스트는 Fact Pack 에 없으므로 **확인 필요**입니다.
- `A_*`/`D_*` 라벨(`Country*`, `Port Code*`, `Port*`)이 같습니다. TO-BE 에서도 2단 헤더(ColumnGroup)로 구분해야 하는지는 상단 헤더 원문을 확인한 뒤 정합니다.
- `INCOTERMS`, `CHANGE_REQ_NO` 는 이미지 셀이므로 TO-BE 에서는 cellTemplate(아이콘) 후보입니다. 클릭 동작(`SpdMain_CellClick`)과의 연결은 **확인 필요**입니다.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 근거 |
|---|---|---|
| Shipment Plan Confirm Detail | META+코드연결 | `AddSheet` (CreateSpread:253)에서 시트명을 하드코딩하고 `SetSheetHeaderColumn` (InitSpread:266)으로 메타를 연결 |

- 시트는 1개이며 시트 간 마스터-디테일 연결은 없습니다.
