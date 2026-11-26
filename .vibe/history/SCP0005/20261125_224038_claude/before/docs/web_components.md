# SCP0005 웹 컴포넌트 매핑 (WinForms → React/Wijmo)

## 1. 컨트롤 → React/Wijmo 컴포넌트 매핑

라벨은 props.csv 의 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다.

| AS-IS 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | — | 1227×65, Dock Top, UsrPanelType=HidePanel | 조회조건 패널(접기/펼치기) | |
| cboValidYN | UsrCombo | `Valid` (layoutControlItem3) | 168×20 | ComboBox(단일 선택) | 데이터 후보: dtValidYN = biz:CommonData.YesOrNo (확인 필요) |
| clbTransMode | UsrCheckedList | `Trans Mode` (layoutControlItem4) | 149×21 | MultiSelect(체크 리스트) | GetCheckedListValue(CODE)@FindDataMain:404 — 대상 컨트롤 확인 필요 |
| txtFromCountry | TextBox | `From Country` (layoutControlItem5) | 139×25 | InputText | btnFromSrch_Click 에서 popCity.Country 로 채움 |
| txtFromCity | TextBox | `From City` (layoutControlItem2) | 142×25 | InputText | btnFromSrch_Click 에서 popCity.City 로 채움 |
| btnFromSrch | UsrButton | layoutControlItem7 Text=`"layoutControlItem6"`(원문). 버튼 자체 Text 는 Fact Pack 에 없음 | 39×25 | 검색(돋보기) 버튼 → City 팝업 | |
| txtToCountry | TextBox | `To Country` (layoutControlItem1) | 169×25 | InputText | btnToSrch_Click 에서 popCity.Country 로 채움 |
| txtToCity | TextBox | `To City` (layoutControlItem8) | 177×25 | InputText | btnToSrch_Click 에서 popCity.City 로 채움 |
| btnToSrch | UsrButton | layoutControlItem6 Text 없음. 버튼 Text 는 Fact Pack 에 없음 | 39×25 | 검색(돋보기) 버튼 → City 팝업 | |
| btnEaxel_Upload | SimpleButton | `Upload` | 76×22 | Button(Excel 업로드) | |
| btnExcel_Form | SimpleButton | `Excel Form` | 87×22 | Button(Excel 양식) | |
| spdMain (메인) | FpSpread | 시트 `Distribution Route` | 1227×492, Dock Fill | Wijmo FlexGrid | 2단 헤더 |
| spdMain (팝업) | FpSpread | 시트 `POPUP`, 폼 Text `DistributionRoute History` | 1387×589, Dock Fill | Wijmo FlexGrid(팝업 내) | 2단 헤더 |
| emptySpaceItem1 / emptySpaceItem4 | EmptySpaceItem | — | 61×29 / 783×25 | 레이아웃 여백 | |
| usrLayoutControl1 / layoutControlGroup1 | UsrLayoutControl / Group | — | 657×184 | — | parent 미지정. 실사용 여부 확인 필요 |
| imageList1 | ImageList | — | — | 아이콘 리소스 | 용도 확인 필요 |

툴바 버튼: FindButton(조회), SaveButton(저장), EditButton(318행)이 폼 오버라이드로 존재합니다(flow.csv / grid_code.csv).

## 2. 화면 배치

- props.csv 에 **SplitContainer 가 없습니다**(Orientation·SplitterDistance 항목 없음). 배치는 Dock 기반입니다.

| 영역 | 컨트롤 | Dock | Size | 높이 비율 |
|---|---|---|---|---|
| 상단 | usrConditionPanel1(내부 usrLayoutControl2 1227×65 Fill) | Top | 1227×65 | 65 / 557 ≈ 11.7% |
| 하단 | spdMain(Distribution Route) | Fill | 1227×492 | 492 / 557 ≈ 88.3% |

- 상/하 2단 구조이고 좌/우 분할은 없습니다. 비율은 Designer Size 값으로 계산한 것이며, 실행 시 크기는 창 크기에 따라 달라집니다.
- 조회조건 배치(layoutControlGroup2 1227×74). 각 LayoutControlItem 크기 순서이며, 정확한 행·열 좌표는 Fact Pack 에 없어 **확인 필요**입니다.
  - 1행 후보(높이 25): Valid(202) · Trans Mode(222) · emptySpaceItem4(783)
  - 2행 후보(높이 29): From Country(222) · From City(202) · [btnFromSrch](43) · To Country(240) · To City(225) · [btnToSrch](43) · Upload(80) · Excel Form(91) · emptySpaceItem1(61)
- 팝업 `SCP0005_DistributionRoutePopup`: spdMain 1387×589 Dock Fill 단일 그리드입니다.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

규칙: 메타 SCM_MST_SHEET_COLUMNS. 필수 = USER_SELECTABLE_FLAG='N', 기본 = DEFAULT_FLAG='Y'. 14개 division 모두 같습니다.

### 3-1. 시트 `Distribution Route` (39컬럼, 메인 spdMain)

| # | COLUMN_NAME | 라벨(원문) | 구분 | 출처 |
|---:|---|---|---|---|
| 1 | ROUTE_ID | Route Id | **필수** | META |
| 2 | FROM_COUNTRY | Country* | 기본 | META |
| 3 | FROM_CITY | City* | 기본 | META |
| 4 | FROM_CITY_NAME | City Name | 기본 | META |
| 5 | TO_COUNTRY | Country* | 기본 | META |
| 6 | TO_CITY | City* | 기본 | META |
| 7 | TO_CITY_NAME | City Name | 기본 | META |
| 8 | D_COUNTRY | Country* | 기본 | META |
| 9 | D_PORT_CODE | Port Code* | 기본 | META |
| 10 | D_PORT_NAME | Port* | 기본 | META |
| 11 | A_COUNTRY | Country* | 기본 | META |
| 12 | A_PORT_CODE | Port Code* | 기본 | META |
| 13 | A_PORT_NAME | Port* | 기본 | META |
| 14 | TRANSPORT_MODE | Trans Mode* | 기본 | META |
| 15 | SHIPPING_COMPANY | Forwarder* | 기본 | META |
| 16 | PRIORITY | Priority* | 기본 | META |
| 17 | LT_TYPE | L/T Type* | 기본 | META |
| 18 | VALID_YN | Valid* | 기본 | META |
| 19 | LT_DEPARTURE_INLAND | Departure Inland | 기본 | META |
| 20 | LT_WAIT_SHIPPING | Waiting For Shipping | 기본 | META |
| 21 | LT_VOYAGE | Voyage | 기본 | META |
| 22 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | 기본 | META |
| 23 | LT_ARRIVAL_INLAND | Arrival Inland | 기본 | META |
| 24 | LT_SUM | Total L/T | 기본 | META |
| 25 | SHIP_DOC_PREPARATION_DATE | Shipping Document Preparation Date | 기본 | META |
| 26 | One_SEGMENT_COST | Pick Up Cost | 기본 | META |
| 27 | Two_SEGMENT_COST | Freight Cost | 기본 | META |
| 28 | Three_SEGMENT_COST | Delivery Cost | 기본 | META |
| 29 | DAYS_MON | Mon | 기본 | META |
| 30 | DAYS_TUE | Tue | 기본 | META |
| 31 | DAYS_WED | Wed | 기본 | META |
| 32 | DAYS_THU | Thu | 기본 | META |
| 33 | DAYS_FRI | Fri | 기본 | META |
| 34 | DAYS_SAT | Sat | 기본 | META |
| 35 | DAYS_SUN | Sun | 기본 | META |
| 36 | CREATED_BY | Created By | 기본 | META |
| 37 | CREATION_DATE | Creation Date | 기본 | META |
| 38 | LAST_UPDATED_BY | Last Updated By | 기본 | META |
| 39 | LAST_UPDATE_DATE | Last Update Date | 기본 | META |

> 위 표의 행 순서는 의미 단위로 묶어 보기 쉽게 정렬한 것이며, **화면 컬럼 순서가 아닙니다**. 실제 순서(메타 정렬 컬럼)와 2단 헤더 그룹명(ATTRIBUTE1~5 등)은 Fact Pack 본문에 없어 **확인 필요**입니다. `Country*` 라벨이 4개 컬럼(FROM/TO/D/A_COUNTRY)에 겹치는 것으로 보아 상위 그룹 헤더로 구분하는 구조로 보이지만, 근거는 SetSheetHeaderColumn 의 iColumnHeaderRowCount=2 뿐입니다.

### 3-2. 시트 `POPUP` (16컬럼, 이력 팝업 spdMain)

| # | COLUMN_NAME | 라벨(원문) | 구분 |
|---:|---|---|---|
| 1 | ROUTE_ID | Route Id | **필수** |
| 2 | LT_DEPARTURE_INLAND | Departure Inland | 기본 |
| 3 | LT_WAIT_SHIPPING | Waiting For Shipping | 기본 |
| 4 | LT_VOYAGE | Voyage | 기본 |
| 5 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | 기본 |
| 6 | LT_ARRIVAL_INLAND | Arrival Inland | 기본 |
| 7 | LT_SUM | Total L/T | 기본 |
| 8 | DAYS_MON | Mon | 기본 |
| 9 | DAYS_TUE | Tue | 기본 |
| 10 | DAYS_WED | Wed | 기본 |
| 11 | DAYS_THU | Thu | 기본 |
| 12 | DAYS_FRI | Fri | 기본 |
| 13 | DAYS_SAT | Sat | 기본 |
| 14 | DAYS_SUN | Sun | 기본 |
| 15 | LAST_UPDATED_BY | Last Updated By | 기본 |
| 16 | LAST_UPDATE_DATE | Last Update Date | 기본 |

> 이 표도 실제 컬럼 순서가 아닙니다. 순서는 **확인 필요**입니다.

### 3-3. 코드 하드코딩 / 표시 변경

- 하드코딩으로 추가하는 컬럼은 없습니다(grid_effective 의 source 가 전부 META).
- 표시/라벨 변경은 Designer 의 ColumnHeader 기본 스타일 4건만 있습니다(메인 515~518행, 팝업 65~68행: HorizontalAlignment=General, VerticalAlignment=General, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced).
- 화면이 직접 정의한 `SetSpreadColumn(siMain)` 을 조회 후(조회 결과 1행 이상일 때) 호출합니다(FindDataMain:452, FindDataReceive:521). 내부에서 컬럼 속성을 바꾸는지는 grid_code.csv 에 전개된 내용이 없어 **확인 필요**입니다.

### 3-4. division별 표시 차이

| 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Distribution Route | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 |
| POPUP | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |

division에 따른 차이는 없습니다. 판단불가 분기는 0건입니다.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 연결 방식 |
|---|---|---|
| Distribution Route | META+코드연결 | 메인 CreateSpread:233 AddSheet → InitSpread:245~246 `SheetName == "Distribution Route"` 조건으로 SetSheetHeaderColumn |
| POPUP | META+코드연결 | 팝업 CreateSpread:122 AddSheet → InitSpread:134~136 `SheetName == "POPUP"` 조건으로 SetSheetHeaderColumn |

- 메인 시트 하나(spdMain)에 두 조회 경로가 같이 바인딩됩니다: FindDataMain(SCP0005_GET_DISTRIBUTION_ROUTE)과 FindDataReceive(SCP0005_GET_DISTRIBUTION_ROUTEID).
- POPUP 시트는 SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID(이력 테이블 SCP_MST_DISTRIBUTION_ROUTE_H) 결과를 보여줍니다. 두 시트의 공통 필수 컬럼은 `ROUTE_ID` 입니다. 메인 → 팝업으로 넘기는 키가 ROUTE_ID 인지와 팝업을 띄우는 이벤트는 **확인 필요**입니다.
