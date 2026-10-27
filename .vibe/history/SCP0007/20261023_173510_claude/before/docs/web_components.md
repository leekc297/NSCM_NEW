# SCP0007 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

### 1-1. 메인 화면 조회조건 (SCP0007_BOD, usrConditionPanel1 > usrLayoutControl2)
| AS-IS 컨트롤 | 유형 | 라벨(LayoutControlItem.Text 원문) | 크기 | TO-BE 후보 |
|---|---|---|---|---|
| clbDivision | UsrCheckedList2 | `Div` (layoutDivision) | 223×21 | 멀티선택 콤보(Wijmo MultiSelect). 변경 이벤트 `cboDivision_SelectedIndexChanged` 대응 |
| clbFromSite | UsrCheckedList2 | `From Site` (layoutFrom) | 202×21 | 멀티선택 콤보 |
| clbToSite | UsrCheckedList2 | `To Site` (layoutToSite) | 200×21 | 멀티선택 콤보 |
| clbIncoterms | UsrCheckedList2 | `Incoterms` (layoutIncoterms) | 148×21 | 멀티선택 콤보 |
| clbTransMode | UsrCheckedList2 | `Trans Mode` (layoutTransMode) | 175×21 | 멀티선택 콤보 |
| clbIncotermsSSP | UsrCheckedList2 | `SSP Incoterms` (layoutSSPIncoterms) | 123×21 | 멀티선택 콤보 |
| cboValidYN | UsrCombo | `Valid` (layoutControlItem3) | 215×20 | 단일 콤보(Wijmo ComboBox) |
| cboInputStatus | UsrCombo | `Input Status` (layoutControlItem1) | 185×20 | 단일 콤보. 값 `"C"`/`"R"` 분기가 코드에 있다(InsertButton) |
| spdMain (Sheet `BOD`) | FpSpread | – | 1168×523 | Wijmo FlexGrid (2단 컬럼 헤더) |

### 1-2. 팝업 (SCP0007_DistributionRoutePopup, 폼 Text `Distribution Route Popup`)
| AS-IS 컨트롤 | 유형 | 라벨 원문 | 크기 | 초기 상태 | TO-BE 후보 |
|---|---|---|---|---|---|
| txtFromCountry | UsrMultiLineEditor | `From Country` | 185×21 | Enabled=false, Text=sFromCountry | 읽기전용 텍스트 |
| txtFromCity | UsrMultiLineEditor | `From City` | 186×21 | Enabled=false, Text=sFromCity | 읽기전용 텍스트 |
| btnFromSrch | UsrButton | (layoutControlItem9, Text 없음) | 39×25 | Enabled=false | 도시 검색 버튼 → popCity 결과(Country/City) 반영 |
| txtToCountry | UsrMultiLineEditor | `" To Country"`(앞 공백 포함 원문) | 187×21 | Enabled=false, Text=sToCountry | 읽기전용 텍스트 |
| txtToCity | UsrMultiLineEditor | `" To City"`(앞 공백 포함 원문) | 186×21 | Enabled=false, Text=sToCity | 읽기전용 텍스트 |
| btnToSrch | UsrButton | (layoutControlItem10, Text 없음) | 39×25 | Enabled=false | 도시 검색 버튼 |
| clbTransMode | UsrCheckedList | `Trans Mode` | 170×21 | Enabled=false | 멀티선택 콤보(읽기전용) |
| btnButtonList | UsrButtonList | (layoutControlItem6, Text 없음) | 215×25 | – | 팝업 버튼 바 → `btnButtonList_UsrButtonList_Click_Detected` |
| spdMain (Sheet `Distribution Route`) | FpSpread | – | 1084×335 | – | Wijmo FlexGrid (2단 헤더) |

## 2. 화면 배치
props.csv에는 SplitContainer(Orientation / SplitterDistance)가 없다. 화면은 Dock으로 나뉜다.

| 화면 | 상단 | 하단 | 상/하 비율(높이 기준) |
|---|---|---|---|
| SCP0007_BOD | usrConditionPanel1, Dock=Top, 1168×69, UsrPanelType=HidePanel | spdMain, Dock=Fill, 1168×523 | 약 11.7% : 88.3% (69 : 523) |
| Distribution Route Popup | usrConditionPanel1, Dock=Top, 1084×78, HidePanel | spdMain, Dock=Fill, 1084×335 | 약 18.9% : 81.1% (78 : 335) |

- 좌/우 분할은 없다. 조회조건은 상단 패널 하나, Grid는 하단 하나로 구성된다.
- 메인 조회조건은 2행이다. 행 높이는 약 24~25px(LayoutControlItem 크기 263×25, 263×24 등)이고, 각 행에 4개 항목이 있다. 실제로 어느 행에 어떤 항목이 배치되는지는 Location 값이 Fact Pack에 없어 **확인 필요**다.

## 3. 시트별 Grid 컬럼

### 3-1. 시트 `BOD` (META+코드연결, 메타 SCM_MST_SHEET_COLUMNS 39행)
14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 표시 34개 / 숨김 5개로 같다.

| # | 컬럼 | 라벨(메타) | 표시(전 division) | 코드 오버라이드 |
|---:|---|---|---|---|
| 1 | AFTER_LEAD_TIME | Additional Lead Time | 기본 | – |
| 2 | BEFORE_LEAD_TIME | Before | 숨김 | – |
| 3 | BOD_ID | BOD_ID | 기본 | – |
| 4 | BOD_VALID | BOD Valid* | 기본 | – |
| 5 | CREATED_BY | Created By | 기본 | – |
| 6 | CREATION_DATE | Creation Date | 기본 | – |
| 7 | CUSTOMER | Customer | 기본 | – |
| 8 | DAYS_FRI | Fri | 기본 | – |
| 9 | DAYS_MON | Mon | 기본 | – |
| 10 | DAYS_SAT | Sat | 기본 | – |
| 11 | DAYS_SUN | Sun | 기본 | – |
| 12 | DAYS_THU | Thu | 기본 | – |
| 13 | DAYS_TUE | Tue | 기본 | – |
| 14 | DAYS_WED | Wed | 기본 | – |
| 15 | DIS_TOTAL_LEAD_TIME | Distribution Total Lead Time | 기본 | – |
| 16 | DIVISION_ID | Division* | 기본 | InsertButton:387 셀 콤보 ← dtMyDivision(`BLUtils.GetDivisionWithoutEE`) |
| 17 | FROM_CITY | From City | 기본 | – |
| 18 | FROM_COUNTRY | FROM_COUNTRY | 숨김 | – |
| 19 | FROM_SITE_CODE | From Site* | 기본 | ComboSelChange 기준 컬럼 |
| 20 | FROM_YYYYMMDD | FROM* | 기본 | – |
| 21 | INCOTERMS | Incoterms* | 기본 | InsertButton:424 셀 콤보 ← dtIncotermsEdit |
| 22 | INCOTERMS_SSP | Incoterms SSP* | 기본 | InsertButton:425 / EditButton:484·490 셀 콤보 (TO SITE_TYPE=PLANT일 때) |
| 23 | LAST_UPDATE_DATE | Last Update Date | 기본 | – |
| 24 | LAST_UPDATED_BY | Last Updated By | 기본 | – |
| 25 | LEAD_TIME | Lead Time | 기본 | – |
| 26 | LT_TYPE | L/T Type | 기본 | – |
| 27 | PRIORITY | Priority* | 기본 | – |
| 28 | REMARKS | Remarks | 기본 | – |
| 29 | ROUTE_CHK | ROUTE_CHK | 숨김 | – |
| 30 | ROUTE_CNT | Route Count | 기본 | SetCityCode의 `route_cnt` 결과와 관련된 것으로 보임(**확인 필요**) |
| 31 | ROUTE_ID | Route Id* | 기본 | – |
| 32 | ROUTE_VALID | Route Valid | 기본 | – |
| 33 | SAFETY_STOCK | Safety Stock | 숨김 | InitSpread:338 Visible=false(→숨김) |
| 34 | TO_CITY | To City | 기본 | – |
| 35 | TO_COUNTRY | TO_COUNTRY | 숨김 | – |
| 36 | TO_SITE_CODE | To Site* | 기본 | ComboSelChange:1146·1154 셀 콤보 ← dtToSiteOfSpd(필터) |
| 37 | TO_YYYYMMDD | TO* | 기본 | – |
| 38 | TRANSPORT_MODE | Trans Mode | 기본 | – |
| 39 | VMI_YN | To Site VMI | 기본 | – |

- 메타 컬럼 속성(폭·정렬·콤보유형·FIXED·대문자 등)은 SetSheetHeaderColumn이 읽는 ATTRIBUTE1~5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG 등이 결정한다. 행별 값은 `dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv`를 봐야 한다(본 Fact Pack에는 값이 없다).
- 컬럼 헤더는 2행이다(`SetSheetHeaderColumn(siMain, 2)`, AddSheet 인자 2).
- InitSpread:277 `CellType = cellTypeImage`가 적용되는 컬럼은 **확인 필요**다.
- 표시 순서는 위 표처럼 알파벳순이다. 실제 순서(메타 정렬 컬럼)는 **확인 필요**다.

### 3-2. 시트 `Distribution Route` (코드 하드코딩 전용, 메타 없음, 팝업)
| # | 필드 | 헤더 | API | 폭 | bVisible(코드 인자) | 정렬 | 비고 |
|---:|---|---|---|---:|---|---|---|
| 1 | ROUTE_ID | Route Id | AddTextColumn | 60 | true | Right | 헤더 0행 2칸 병합 |
| 2 | LT_TYPE | L/T Type | AddTextColumn | 80 | true | Center | 0행 2칸 병합 |
| 3 | VALID_YN | Valid | AddComboColumn(dtYesOrNo) | 50 | true | Center | 0행 2칸 병합 |
| 4 | FROM_CITY_NAME | City Name | AddTextColumn | 130 | true | Left | 1행 |
| 5 | FROM_COUNTRY | Country | AddExTextColumn(max 2) | 50 | true | Center | 1행 |
| 6 | FROM_CITY | City | AddExTextColumn(max 3) | 50 | true | Center | 1행 |
| 7 | TRANSPORT_MODE_NAME | Trans Mode | AddTextColumn | 60 | true | Center | 원문 인자 `DefColumns.TRANSPORT_MODE` |
| 8 | PRIORITY | Priority | AddNumTextColumn | 60 | true | Right | 0행 2칸 병합 |
| 9~15 | DAYS_MON~DAYS_SUN | Mon~Sun | AddComboColumn(dtYesOrNo) | 40 | **false** | Center | 표시 여부 **확인 필요** |
| 16 | DAYS | Departure Days | AddTextColumn | 140 | true | Left | 0행 2칸 병합 |
| 17 | D_PORT_NAME | Port | AddTextColumn | 80 | true | Left | 319: 0행 1칸 "Port" |
| 18 | D_COUNTRY | Country | AddExTextColumn(max 2) | 50 | true | Center | 1행 |
| 19 | D_PORT_CODE | Port Code | AddExTextColumn(max 3) | 70 | true | Center | 1행 |
| 20 | A_PORT_NAME | Port | AddTextColumn | 80 | true | Left | 1행 |
| 21 | A_COUNTRY | Country | AddExTextColumn(max 2) | 50 | true | Center | 1행 |
| 22 | A_PORT_CODE | Port Code | AddExTextColumn(max 3) | 70 | true | Center | 1행 |
| 23 | SHIPPING_COMPANY | Shipping Company | AddExTextColumn(max 3) | 80 | true | Center | 0행 2칸 병합 |
| 24 | TO_CITY_NAME | City Name | AddTextColumn | 130 | true | Left | 1행 |
| 25 | TO_COUNTRY | Country | AddExTextColumn(max 2) | 50 | true | Center | 1행 |
| 26 | TO_CITY | City | AddExTextColumn(max 3) | 50 | true | Center | 1행 |
| 27 | SHIP_DOC_PREPARATION_DATE | Shipping Document Preparation Data | AddDateColumn | 120 | true | Center | 0행 2칸 병합 |
| 28 | LT_DEPARTURE_INLAND | Departure Inland | AddNumTextColumn | 100 | true | Right | 0행 1칸 |
| 29 | LT_WAIT_SHIPPING | Waiting For Shipping | AddNumTextColumn | 100 | true | Right | 0행 1칸 |
| 30 | LT_VOYAGE | Sea/Air Ferry | AddNumTextColumn | 100 | true | Right | 0행 1칸 |
| 31 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | AddNumTextColumn | 100 | true | Right | 0행 1칸 |
| 32 | LT_ARRIVAL_INLAND | Arrival Inland | AddNumTextColumn | 100 | true | Right | 0행 1칸 |
| 33 | LT_SUM | Sum | AddNumTextColumn | 100 | true | Right | 0행 2칸 병합 |

- grid_effective는 14개 division 모두 33개(코드추가)로 집계했다. DAYS_MON~SUN 7개는 코드 인자가 bVisible=false여서 실제 표시 수와 다를 수 있다(**확인 필요**).
- CAppSetting.StringAction 컬럼에 헤더 "A"(0행 2칸, 301줄)가 있다.
- From/Depart/Arrive/To 그룹의 상단 헤더 문구(302, 311~317줄)는 Fact Pack에 없다(**확인 필요**).
- division별 표시 차이는 없다.

## 4. 시트 연결 규칙
| 시트 | 연결 규칙 | 의미 |
|---|---|---|
| `BOD` | META+코드연결 | 메타 시트를 코드가 AddSheet/ChangeSheet로 쓰고, 컬럼은 SetSheetHeaderColumn이 메타로 만든다. 코드는 숨김 처리와 셀 콤보만 덧씌운다 |
| `Distribution Route` | 코드 하드코딩 전용(메타 없음) | 팝업 InitSpread에서 Add*Column으로만 구성한다. 메타 행은 없다 |

- 시트 간 데이터 연결: 메인 `spdMain_CellDoubleClick`(BOD.cs:1068~1089)이 `Distribution Route`와 같은 컬럼명(ROUTE_ID, TRANSPORT_MODE_NAME, PRIORITY, DAYS_*, VALID_YN, LT_SUM, LT_TYPE)을 `dr`에서 읽는다. 팝업에서 고른 경로를 BOD 행에 반영하는 연결로 보이지만, 팝업 호출문과 대상 컬럼 매핑은 Fact Pack에 없어 **확인 필요**다.
