# SCP0007 화면설계서 (AS-IS 사실 → TO-BE)

> 근거는 Fact Pack(controls.csv / props.csv / events.csv / grid_effective.csv / grid_code.csv)과 1차 분석서뿐이다. 없는 사실은 **확인 필요**로 적었다.
> §5 액션 명세의 엔드포인트 이름은 업무분석서 §5와 같다. §3 컨트롤명은 단위테스트 '절차' 열에서 그대로 쓴다.

---

## 1. 화면 개요

| 항목 | 메인 | 팝업 |
|---|---|---|
| 화면 ID | SCP0007 | SCP0007 연동 팝업 |
| 클래스 | `SCP0007_BOD` | `SCP0007_DistributionRoutePopup` |
| 폼 Text(원문) | `"SCP0007_BOD"` (Designer:626) | `"Distribution Route Popup"` (Designer:640) |
| 소속 | current (`GSCM.SCP.Forms.UIL\Master\SCP0007_BOD`) | shared (`GSCM.SCM.Popup.UIL`) |
| 시트 | `BOD` (META+코드연결) | `Distribution Route` (코드 하드코딩 전용, 메타 없음) |
| Grid 구성 방식 | HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경) | 〃 |
| 메뉴 위치 | **확인 필요** | – |

---

## 2. 화면 레이아웃

### 2-0. 분할 방식
- props.csv에 **SplitContainer(Orientation·SplitterDistance)가 없다(0건)**. 화면은 `Dock`(Top/Fill)으로만 나뉜다. 아래 트리는 controls.csv의 parent 체인과 props.csv의 Dock·Size로 그렸다.
- 비율 % = 높이 기준(Top 높이 ÷ (Top + Fill 높이)).
- LayoutControlItem의 Location 값은 Fact Pack에 없다. 행 안의 배치는 **크기(Size) 일치로 추정**했으며, 좌우 순서와 상하 행은 **확인 필요**다.

### 2-1. 메인 `SCP0007_BOD`

```
this (SCP0007_BOD, 1168 × 592 추정 = 69 + 523)
│
├─ usrConditionPanel1   Dock=Top  1168×69  UsrPanelType=HidePanel        ◀ 상 11.7%  [조회조건 영역]
│   └─ usrLayoutControl2   Dock=Fill 1168×69  (Text "usrLayoutControl2")
│        └─ layoutControlGroup2  1168×69
│             ┌──────────────────┬─────────────────┬─────────────────┬────────────────────┬──────────┐
│   행A(h25) │ Input Status 263 │ Valid 249       │ Trans Mode 248  │ SSP Incoterms 212  │ (빈칸)176 │
│             │ cboInputStatus   │ cboValidYN      │ clbTransMode    │ clbIncotermsSSP    │ emptySp1 │
│             ├──────────────────┼─────────────────┼─────────────────┼────────────────────┼──────────┤
│   행B(h24) │ From Site 263    │ To Site 249     │ Div 248         │ Incoterms 212      │ (빈칸)176 │
│             │ clbFromSite      │ clbToSite       │ clbDivision     │ clbIncoterms       │ emptySp3 │
│             └──────────────────┴─────────────────┴─────────────────┴────────────────────┴──────────┘
│             열 폭 비율(합 1148): 22.9% │ 21.7% │ 21.6% │ 18.5% │ 15.3%   ※ 열 정렬은 Size 일치로 추정
│
├─ spdMain   Dock=Fill  1168×523   Sheet "BOD" (spdMain_Sheet1)              ◀ 하 88.3%  [그리드 영역]
│
└─ (usrLayoutControl1  Dock=Fill 657×184, layoutControlGroup1 657×184 — parent 미기록. 배치 위치 확인 필요)

[버튼 영역] 메인 Designer에 버튼 컨트롤이 없다. FindButton / SaveButton / InsertButton / EditButton은
            프레임워크 공통 툴바의 진입점(override 메서드)으로 보인다 → 위치 확인 필요
[팝업 영역] Distribution Route Popup (§2-2). 메인에서 여는 방식은 확인 필요
```

### 2-2. 팝업 `SCP0007_DistributionRoutePopup`

```
this ("Distribution Route Popup", 1084 × 413 추정 = 78 + 335)
│
├─ usrConditionPanel1   Dock=Top  1084×78  UsrPanelType=HidePanel        ◀ 상 18.9%  [조회조건·버튼 영역]
│   └─ usrLayoutControl2   Dock=Fill 1084×78  (Text "usrLayoutControl2")
│        └─ layoutControlGroup2  1084×78   (항목 높이 모두 29 → 2행으로 추정)
│             행1 추정(합 1064): [From Country 268 txtFromCountry][From City 246 txtFromCity][btnFromSrch 43]
│                                [emptySpaceItem5 317][emptySpaceItem7 190]
│             행2 추정(합 1064): [ To Country 268 txtToCountry][ To City 246 txtToCity][btnToSrch 43]
│                                [Trans Mode 243 clbTransMode][emptySpaceItem1 10][emptySpaceItem6 35][btnButtonList 219]
│             ※ 행 구성은 폭 합(1064)이 맞는 조합으로 추정한 것이다. 실제 Location 확인 필요
│
├─ spdMain   Dock=Fill  1084×335   Sheet "Distribution Route" (spdMain_Sheet1)   ◀ 하 81.1%  [그리드 영역]
│
└─ (usrLayoutControl1  Dock=Fill 657×184 — parent 미기록. 확인 필요)
```

---

## 3. 컨트롤 명세

> 라벨 = props.csv에서 해당 컨트롤을 담는 LayoutControlItem의 `Text` 원문(따옴표 안 공백 포함). 라벨 항목이 없으면 "–".
> 필수 여부: Fact Pack에 조회조건 필수 검증 사실이 없다. 모두 **확인 필요**.

| # | 컨트롤명 | 소속 | 타입 | 라벨(props Text 원문) | 초기값 / 크기 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|---|
| 1 | usrLayoutControl1 | 메인·팝업 | UsrLayoutControl | – | Dock=Fill, 657×184 (parent 미기록) | – | – | 미사용 여부 **확인 필요** (레이아웃 컨테이너) |
| 2 | usrConditionPanel1 | 메인·팝업 | UsrConditionPanel | – | Dock=Top, HidePanel. 메인 1168×69 / 팝업 1084×78 | – | – | 공통 조회조건 패널(접기 가능) |
| 3 | usrLayoutControl2 | 메인·팝업 | UsrLayoutControl | `"usrLayoutControl2"` (컨트롤 자체 Text) | Dock=Fill. 메인 1168×69 / 팝업 1084×78 | – | – | 조회조건 Grid 레이아웃 |
| 4 | clbDivision | 메인 | UsrCheckedList2 | `"Div"` (layoutDivision) | 223×21. 초기값 **확인 필요** | 확인 필요 | SelectedIndexChanged → `cboDivision_SelectedIndexChanged` | Wijmo MultiSelect |
| 5 | clbFromSite | 메인 | UsrCheckedList2 | `"From Site"` (layoutFrom) | 202×21 | 확인 필요 | – | Wijmo MultiSelect |
| 6 | clbToSite | 메인 | UsrCheckedList2 | `"To Site"` (layoutToSite) | 200×21 | 확인 필요 | – | Wijmo MultiSelect |
| 7 | clbIncoterms | 메인 | UsrCheckedList2 | `"Incoterms"` (layoutIncoterms) | 148×21 | 확인 필요 | – | Wijmo MultiSelect |
| 8 | clbTransMode | 메인 | UsrCheckedList2 | `"Trans Mode"` (layoutTransMode) | 175×21 | 확인 필요 | – | Wijmo MultiSelect |
| 9 | clbIncotermsSSP | 메인 | UsrCheckedList2 | `"SSP Incoterms"` (layoutSSPIncoterms) | 123×21 | 확인 필요 | – | Wijmo MultiSelect |
| 10 | cboValidYN | 메인 | UsrCombo | `"Valid"` (layoutControlItem3) | 215×20. 원천 후보 dtValidYN(`biz:CommonData.YesOrNo`) **확인 필요** | 확인 필요 | – | Wijmo ComboBox |
| 11 | cboInputStatus | 메인 | UsrCombo | `"Input Status"` (layoutControlItem1) | 185×20. 값 `"C"`/`"R"` 분기 존재 | 확인 필요 | – (InsertButton에서 값 참조) | Wijmo ComboBox |
| 12 | spdMain | 메인 | FpSpread | – | Dock=Fill 1168×523, 시트 `BOD` | – | CellDoubleClick → `spdMain_CellDoubleClick` / TopChange → `SpdMain_TopChange` / ComboSelChange → `SpdMain_ComboSelChange` / ClipboardPasted → `SpdMain_ClipboardPasted` / KeyPress → `SpdMain_KeyPress` / EditChange → `SpdMain_EditChange` / dsdm.Changed → `SpdMain_Changed` | Wijmo FlexGrid (2단 헤더) |
| 13 | spdMain_Sheet1 | 메인 | SheetView | – | Designer 시트. 런타임에 AddSheet `BOD` | – | – | FlexGrid 시트 1개 |
| 14 | txtFromCountry | 팝업 | UsrMultiLineEditor | `"From Country"` (layoutControlItem7) | 185×21, Enabled=false, Text=sFromCountry | – | – (btnFromSrch_Click가 값 갱신) | 읽기전용 InputText |
| 15 | txtFromCity | 팝업 | UsrMultiLineEditor | `"From City"` (layoutControlItem8) | 186×21, Enabled=false, Text=sFromCity | – | – | 읽기전용 InputText |
| 16 | btnFromSrch | 팝업 | UsrButton | – (layoutControlItem9, Text 없음) | 39×25, Enabled=false | – | Click → `btnFromSrch_Click` | 검색 아이콘 버튼(초기 비활성) |
| 17 | txtToCountry | 팝업 | UsrMultiLineEditor | `" To Country"` (layoutControlItem1, 앞 공백 원문) | 187×21, Enabled=false, Text=sToCountry | – | – (btnToSrch_Click가 값 갱신) | 읽기전용 InputText |
| 18 | txtToCity | 팝업 | UsrMultiLineEditor | `" To City"` (layoutControlItem2, 앞 공백 원문) | 186×21, Enabled=false, Text=sToCity | – | – | 읽기전용 InputText |
| 19 | btnToSrch | 팝업 | UsrButton | – (layoutControlItem10, Text 없음) | 39×25, Enabled=false | – | Click → `btnToSrch_Click` | 검색 아이콘 버튼(초기 비활성) |
| 20 | clbTransMode | 팝업 | UsrCheckedList | `"Trans Mode"` (layoutControlItem5) | 170×21, Enabled=false | – | – | 읽기전용 MultiSelect |
| 21 | btnButtonList | 팝업 | UsrButtonList | – (layoutControlItem6, Text 없음) | 215×25 | – | UsrButtonList_Click_Detected → `btnButtonList_UsrButtonList_Click_Detected` | 팝업 버튼 바 |
| 22 | spdMain | 팝업 | FpSpread | – | Dock=Fill 1084×335, 시트 `Distribution Route` | – | CellDoubleClick → `spdMain_CellDoubleClick` / dsdm.Changed → `spdMainDataModel_Changed` | Wijmo FlexGrid (2단 헤더) |
| 23 | spdMain_Sheet1 | 팝업 | SheetView | – | Designer 시트. 런타임에 AddSheet `Distribution Route` | – | – | FlexGrid 시트 1개 |

- 폼 이벤트: 메인 `this.Load` → `Form_Load`(.ctor:157), 팝업 `this.Load` → `Form_Load`(.ctor:149).
- 기타 컨트롤(ImageList imageList1, LayoutControlGroup, EmptySpaceItem)은 레이아웃·아이콘 보조용이다.

---

## 4. 그리드 명세

### 4-1. 시트 `BOD` (메인, META+코드연결)
- 구성: `CreateSpread:262 AddSheet("BOD", 헤더 2, …)` → `InitSpread:275 SetSheetHeaderColumn(siMain, 2)`. 메타 원천은 SCM_MST_SHEET_COLUMNS(PROGRAM_ID=SCP0007) 39행이다.
- 타입·폭·정렬·대문자·FIXED는 메타(CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG, FIXED_FLAG 등)가 정한다. 행별 값은 Fact Pack에 없어 '메타값(확인 필요)'으로 적었다.
- division별 표시: 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 같다. 아래 '표시' 열은 전 division 공통값이다.
- 표시 순서: 아래는 알파벳순이다. 실제 순서(메타 정렬)는 **확인 필요**.
- InitSpread:277 `CellType = cellTypeImage`가 적용되는 컬럼은 **확인 필요**.

| # | 컬럼 | 헤더(메타 라벨) | 타입 | 출처 | 표시(전 division) | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | AFTER_LEAD_TIME | Additional Lead Time | 메타값 | META | 기본 | 확인 필요 |
| 2 | BEFORE_LEAD_TIME | Before | 메타값 | META | 숨김 | – |
| 3 | BOD_ID | BOD_ID | 메타값 | META | 기본 | 확인 필요 |
| 4 | BOD_VALID | BOD Valid* | 메타값 | META | 기본 | 확인 필요 |
| 5 | CREATED_BY | Created By | 메타값 | META | 기본 | 확인 필요 |
| 6 | CREATION_DATE | Creation Date | 메타값 | META | 기본 | 확인 필요 |
| 7 | CUSTOMER | Customer | 메타값 | META | 기본 | 확인 필요 |
| 8 | DAYS_FRI | Fri | 메타값 | META | 기본 | 확인 필요 |
| 9 | DAYS_MON | Mon | 메타값 | META | 기본 | 확인 필요 |
| 10 | DAYS_SAT | Sat | 메타값 | META | 기본 | 확인 필요 |
| 11 | DAYS_SUN | Sun | 메타값 | META | 기본 | 확인 필요 |
| 12 | DAYS_THU | Thu | 메타값 | META | 기본 | 확인 필요 |
| 13 | DAYS_TUE | Tue | 메타값 | META | 기본 | 확인 필요 |
| 14 | DAYS_WED | Wed | 메타값 | META | 기본 | 확인 필요 |
| 15 | DIS_TOTAL_LEAD_TIME | Distribution Total Lead Time | 메타값 | META | 기본 | 확인 필요 |
| 16 | DIVISION_ID | Division* | 셀 콤보(코드 재설정) | META + HARDCODED(InsertButton:387) | 기본 | 행 추가 시 콤보(dtMyDivision) |
| 17 | FROM_CITY | From City | 메타값 | META | 기본 | 확인 필요(SetCityCode가 값 설정으로 보임) |
| 18 | FROM_COUNTRY | FROM_COUNTRY | 메타값 | META | 숨김 | – |
| 19 | FROM_SITE_CODE | From Site* | 메타값(콤보 추정) | META | 기본 | 편집 → `SpdMain_ComboSelChange` 기준 컬럼 |
| 20 | FROM_YYYYMMDD | FROM* | 메타값 | META | 기본 | 확인 필요 |
| 21 | INCOTERMS | Incoterms* | 셀 콤보(코드 재설정) | META + HARDCODED(InsertButton:424) | 기본 | 행 추가 시 콤보(incotermsEdit) |
| 22 | INCOTERMS_SSP | Incoterms SSP* | 셀 콤보(코드 재설정) | META + HARDCODED(InsertButton:425, EditButton:484/490) | 기본 | 행 추가 시 콤보. 수정 시 To SITE_TYPE=PLANT 행만 콤보 |
| 23 | LAST_UPDATE_DATE | Last Update Date | 메타값 | META | 기본 | 확인 필요 |
| 24 | LAST_UPDATED_BY | Last Updated By | 메타값 | META | 기본 | 확인 필요 |
| 25 | LEAD_TIME | Lead Time | 메타값 | META | 기본 | 확인 필요 |
| 26 | LT_TYPE | L/T Type | 메타값 | META | 기본 | 확인 필요(더블클릭 반영 후보) |
| 27 | PRIORITY | Priority* | 메타값 | META | 기본 | 확인 필요(더블클릭 반영 후보) |
| 28 | REMARKS | Remarks | 메타값 | META | 기본 | 확인 필요 |
| 29 | ROUTE_CHK | ROUTE_CHK | 메타값 | META | 숨김 | – |
| 30 | ROUTE_CNT | Route Count | 메타값 | META | 기본 | 확인 필요(`route_cnt` 반영 후보) |
| 31 | ROUTE_ID | Route Id* | 메타값 | META | 기본 | 확인 필요(더블클릭 반영 후보) |
| 32 | ROUTE_VALID | Route Valid | 메타값 | META | 기본 | 확인 필요 |
| 33 | SAFETY_STOCK | Safety Stock | 메타값 | META + HARDCODED(InitSpread:338 Visible=false) | 숨김 →숨김 | – |
| 34 | TO_CITY | To City | 메타값 | META | 기본 | 확인 필요 |
| 35 | TO_COUNTRY | TO_COUNTRY | 메타값 | META | 숨김 | – |
| 36 | TO_SITE_CODE | To Site* | 셀 콤보(코드 재설정) | META + HARDCODED(ComboSelChange:1146/1154) | 기본 | 편집(필터된 To Site 콤보) |
| 37 | TO_YYYYMMDD | TO* | 메타값 | META | 기본 | 확인 필요 |
| 38 | TRANSPORT_MODE | Trans Mode | 메타값 | META | 기본 | 확인 필요 |
| 39 | VMI_YN | To Site VMI | 메타값 | META | 기본 | 확인 필요(SetCityCode가 To VMI_YN 읽음) |

집계: 표시 34 / 숨김 5 (BEFORE_LEAD_TIME, FROM_COUNTRY, ROUTE_CHK, SAFETY_STOCK, TO_COUNTRY).

### 4-2. 시트 `Distribution Route` (팝업, 코드 하드코딩 전용)
- 구성: `CreateSpread:247 AddSheet("Distribution Route", 헤더 2, …)` → `InitSpread:264~297` Add*Column 33개 → `301~335` ColumnHeaderSpan(2단 헤더). 메타는 없다.
- division별 표시: 14개 division 모두 33(코드추가)으로 같다. 다만 DAYS_MON~DAYS_SUN 7개는 코드 인자가 `bVisible=false`다. 실제 보이는 컬럼은 26개일 수 있다 (**확인 필요**).
- 편집 가능 여부: Fact Pack에 잠금/편집 설정이 없다 (**확인 필요**).
- 헤더 span: "0행 2칸" = 0행부터 2행 병합. "1행" = 하단 행 1칸. "0행 1칸" = 상단 1칸만 지정(하단 문구 미추출). 302, 311~317줄(상단 그룹 헤더로 보임)은 Fact Pack에 없다 (**확인 필요**).
- 301줄: `CAppSetting.StringAction` 컬럼에 헤더 `"A"`(0행 2칸).

| # | 컬럼 | 헤더 | 타입(API) | 폭 | bVisible | 정렬 | 헤더 span | 출처 |
|---:|---|---|---|---:|---|---|---|---|
| 1 | ROUTE_ID | Route Id | Text(AddTextColumn) | 60 | true | Right | 0행 2칸 | HARDCODED |
| 2 | LT_TYPE | L/T Type | Text | 80 | true | Center | 0행 2칸 | HARDCODED |
| 3 | VALID_YN | Valid | Combo(dtYesOrNo) | 50 | true | Center | 0행 2칸 | HARDCODED |
| 4 | FROM_CITY_NAME | City Name | Text | 130 | true | Left | 1행 | HARDCODED |
| 5 | FROM_COUNTRY | Country | ExText(max 2) | 50 | true | Center | 1행 | HARDCODED |
| 6 | FROM_CITY | City | ExText(max 3) | 50 | true | Center | 1행 | HARDCODED |
| 7 | TRANSPORT_MODE_NAME | Trans Mode | Text | 60 | true | Center | 0행 2칸 | HARDCODED (원문 인자 `DefColumns.TRANSPORT_MODE`) |
| 8 | PRIORITY | Priority | NumText | 60 | true | Right | 0행 2칸 | HARDCODED |
| 9 | DAYS_MON | Mon | Combo(dtYesOrNo) | 40 | **false** | Center | 확인 필요 | HARDCODED |
| 10 | DAYS_TUE | Tue | Combo(dtYesOrNo) | 40 | **false** | Center | 확인 필요 | HARDCODED |
| 11 | DAYS_WED | Wed | Combo(dtYesOrNo) | 40 | **false** | Center | 확인 필요 | HARDCODED |
| 12 | DAYS_THU | Thu | Combo(dtYesOrNo) | 40 | **false** | Center | 확인 필요 | HARDCODED |
| 13 | DAYS_FRI | Fri | Combo(dtYesOrNo) | 40 | **false** | Center | 확인 필요 | HARDCODED |
| 14 | DAYS_SAT | Sat | Combo(dtYesOrNo) | 40 | **false** | Center | 확인 필요 | HARDCODED |
| 15 | DAYS_SUN | Sun | Combo(dtYesOrNo) | 40 | **false** | Center | 확인 필요 | HARDCODED |
| 16 | DAYS | Departure Days | Text | 140 | true | Left | 0행 2칸 | HARDCODED |
| 17 | D_PORT_NAME | Port | Text | 80 | true | Left | 0행 1칸 "Port" | HARDCODED |
| 18 | D_COUNTRY | Country | ExText(max 2) | 50 | true | Center | 1행 | HARDCODED |
| 19 | D_PORT_CODE | Port Code | ExText(max 3) | 70 | true | Center | 1행 | HARDCODED |
| 20 | A_PORT_NAME | Port | Text | 80 | true | Left | 1행 | HARDCODED |
| 21 | A_COUNTRY | Country | ExText(max 2) | 50 | true | Center | 1행 | HARDCODED |
| 22 | A_PORT_CODE | Port Code | ExText(max 3) | 70 | true | Center | 1행 | HARDCODED |
| 23 | SHIPPING_COMPANY | Shipping Company | ExText(max 3) | 80 | true | Center | 0행 2칸 | HARDCODED |
| 24 | TO_CITY_NAME | City Name | Text | 130 | true | Left | 1행 | HARDCODED |
| 25 | TO_COUNTRY | Country | ExText(max 2) | 50 | true | Center | 1행 | HARDCODED |
| 26 | TO_CITY | City | ExText(max 3) | 50 | true | Center | 1행 | HARDCODED |
| 27 | SHIP_DOC_PREPARATION_DATE | Shipping Document Preparation Data | Date | 120 | true | Center | 0행 2칸 | HARDCODED |
| 28 | LT_DEPARTURE_INLAND | Departure Inland | NumText | 100 | true | Right | 0행 1칸 | HARDCODED |
| 29 | LT_WAIT_SHIPPING | Waiting For Shipping | NumText | 100 | true | Right | 0행 1칸 | HARDCODED |
| 30 | LT_VOYAGE | Sea/Air Ferry | NumText | 100 | true | Right | 0행 1칸 | HARDCODED |
| 31 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | NumText | 100 | true | Right | 0행 1칸 | HARDCODED |
| 32 | LT_ARRIVAL_INLAND | Arrival Inland | NumText | 100 | true | Right | 0행 1칸 | HARDCODED |
| 33 | LT_SUM | Sum | NumText | 100 | true | Right | 0행 2칸 | HARDCODED |

- 헤더 기본 스타일(Designer 586~589, 600~603): HorizontalAlignment=General, NoteIndicatorColor=Red, Parent=`ColumnHeaderDefaultEnhanced`, VerticalAlignment=General.

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A01 | 메인 화면 로드(this.Load) | `Form_Load` (메인 .ctor:157) | 시트 `BOD` 생성, SetSheetHeaderColumn(2단), SAFETY_STOCK 숨김. 공통코드 필드 초기화 | `biz:CommonData.CommonDataList` [LookupCommon, incotermsEdit], `biz:CommonData.YesOrNo` (파서 분류 '진입점 미연결' — 실행 시점 확인 필요) | 빈 BOD 그리드, 콤보 데이터 |
| A02 | 조회(FindButton) | FindButton → GetData_Country | 국가/도시 조회 | `SCP.SCP0007_GET_COUNTRY_CITY` (SP `SCP0007_GET_COUNTRY_CITY`) | 결과 사용처 확인 필요 |
| A03 | 조회(FindButton) | FindButton → FindData_Main | 조회조건 GetCheckedListValue(CODE) 전달 | `SCP.SCP0007_GET_BOD` (SP `SCP0007_GET_BOD`) | spdMain 시트 `BOD` 바인딩 |
| A04 | 행 추가(InsertButton) | InsertButton | Input Status="C", 시트 BOD, 잠금 아님 → 활성 행 DIVISION_ID·INCOTERMS·INCOTERMS_SSP 셀 콤보 | `biz:CommonData.CommonDataList` [code=incotermsEdit] (+ `BLUtils.GetDivisionWithoutEE`) | 새 행 콤보 설정 |
| A05 | 수정(EditButton) | EditButton | 각 행 To SITE_TYPE="PLANT" → INCOTERMS_SSP 콤보(boolEditChange 분기) | `biz:CommonData.CommonDataList` [incotermsEdit / LookupCommon "INCOTERMS"] | PLANT 행 콤보 교체 |
| A06 | 저장(SaveButton) | SaveButton → SaveData_Main | 변경분 저장 → `ERR_MESSAGE` 판정 → 재조회 | `SCP.SCP0007_SAVE_BOD` (SP `SCP0007_SAVE_BOD`) → `SCP.SCP0007_GET_BOD` | 메시지 표시, BOD 재바인딩 |
| A07 | Div 변경(clbDivision.SelectedIndexChanged) | `cboDivision_SelectedIndexChanged` | 내부 동작 확인 필요 | 없음(Fact Pack 기준) | 확인 필요 |
| A08 | From Site 콤보 선택(spdMain.ComboSelChange) | `SpdMain_ComboSelChange` | FROM_SITE_CODE 변경 시 `sFromSite=="E"` 또는 `"A" && OSP_YN=="Y"` → TO_SITE_CODE 콤보 필터 재바인딩 | 없음 | TO_SITE_CODE 콤보 후보 변경 |
| A09 | 셀 값 변경(dsdm.Changed) | `SpdMain_Changed` → SetCityCode | 실행 중 자기 이벤트 해제(1284)/재등록(1315). From/To COUNTRY·CITY·VMI_YN·SITE_TYPE 조회 | `SCP.SCP0007_GET_ROUTE_CNT` (SP `SCP0007_GET_ROUTE_CNT`) | `route_cnt` 반영(대상 컬럼 확인 필요) |
| A10 | 붙여넣기(spdMain.ClipboardPasted) | `SpdMain_ClipboardPasted` | OSP_YN, CITY 참조 | 없음 | 확인 필요 |
| A11 | 셀 편집 중(spdMain.EditChange) | `SpdMain_EditChange` | To SITE_TYPE 참조 | 없음 | 확인 필요 |
| A12 | 키 입력(spdMain.KeyPress) | `SpdMain_KeyPress` | 내부 동작 확인 필요 | 없음 | 확인 필요 |
| A13 | 스크롤 상단 변경(spdMain.TopChange) | `SpdMain_TopChange` | 내부 동작 확인 필요 | 없음 | 확인 필요 |
| A14 | BOD 셀 더블클릭(spdMain.CellDoubleClick) | `spdMain_CellDoubleClick` (메인) | SpdMain_Changed 해제(1073) → dr의 ROUTE_ID, TRANSPORT_MODE_NAME, PRIORITY, DAYS_MON~SUN, VALID_YN, LT_SUM, LT_TYPE 읽기 → 재등록(1104) | 팝업 경유 `SCP.SCP0005_GET_DISTRIBUTION_ROUTE`로 보임(호출문 확인 필요) | Route 값 반영(매핑 확인 필요) |
| A15 | 팝업 로드(this.Load) | `Form_Load` (팝업 .ctor:149) | txtFrom*/txtTo*에 생성자 값, 컨트롤 Enabled=false, 시트 `Distribution Route` 생성 → FindDataMain | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` (SP `SCP0005_GET_DISTRIBUTION_ROUTE`) | 시트 `Distribution Route` 바인딩 |
| A16 | 팝업 버튼 바(btnButtonList) | `btnButtonList_UsrButtonList_Click_Detected` | FindDataMain | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | 〃 |
| A17 | 팝업 조회(FindButton) | FindButton → FindDataMain | 재조회 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | 〃 |
| A18 | From 도시 검색(btnFromSrch.Click) | `btnFromSrch_Click` | popCity 선택 결과 | 없음(popCity 내부 확인 필요) | txtFromCountry ← popCity.Country, txtFromCity ← popCity.City |
| A19 | To 도시 검색(btnToSrch.Click) | `btnToSrch_Click` | popCity 선택 결과 | 없음 | txtToCountry ← popCity.Country, txtToCity ← popCity.City |
| A20 | 팝업 셀 더블클릭 | `spdMain_CellDoubleClick` (팝업 InitEvent:201) | 내부 동작 확인 필요(선택 행 반환으로 보임) | 없음 | 확인 필요 |
| A21 | 팝업 셀 값 변경(dsdm.Changed) | `spdMainDataModel_Changed` | 자기 해제(489)/재등록(521) | 없음 | 확인 필요 |
| A22 | 팝업 공통코드 | 필드·메서드 초기화 | 국가, Yes/No, Trans Mode, Division, From/To Site, BOD Type, Transport Mode | `biz:CommonData.CommonDataList` [COUNTRY_MST, LookupCommon, MyDivision, FromSiteByDivision, ToSiteByDivision, BodType, TransportMode], `biz:CommonData.YesOrNo` | VALID_YN, DAYS_* 콤보 등. GetDivision 등 5개 메서드는 '진입점 미연결' |

---

## 6. 검증·메시지

| # | 항목 | 사실 | 비고 |
|---|---|---|---|
| V01 | 저장 결과 메시지 | `dtErr.Rows[0]["ERR_MESSAGE"]` (SaveData_Main:930) | 메시지 ID, 성공 판정 값 확인 필요 |
| V02 | 행 추가 가능 조건 | Input Status="C", 시트 `BOD`, 시트 잠금 아님 | 조건 불충족 시 알림이 있는지 확인 필요 |
| V03 | To Site 후보 제한 | ComboSelChange의 sFromSite/OSP_YN 분기 | filterExpression 확인 필요 |
| V04 | 필수 표기 | BOD 메타 라벨 `*` 10개 | 실제 필수 검증이 FE/SP에 있는지 확인 필요 |
| V05 | 입력 길이 | Distribution Route ExText maxLength: Country 2, City/Port Code/Shipping Company 3 | |
| V06 | 팝업 입력 잠금 | txtFrom*/txtTo*/btn*Srch/clbTransMode Enabled=false | |
| V07 | 조회조건 필수·조회 0건 메시지 | Fact Pack에 없음 | 확인 필요 |

---

## 7. 권한 (C/R/U/D) 사실

| 구분 | 사실 |
|---|---|
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 13행, TB_FX_ProgramInfo 1행, TB_FX_MenuItemInfo 1행. C/R/U/D 값은 **확인 필요** |
| 버튼 진입점 | FindButton(R), InsertButton(C), EditButton(U), SaveButton(저장 SP가 MERGE·DELETE 수행 → C/U/D 함께 처리 가능). 별도 DeleteButton은 Fact Pack에 없다 |
| 데이터 범위 | `UserInfoContext.Current.NowGroupID`(메인 55/60/63/64, 팝업 58). MyDivision/FromSiteByDivision/ToSiteByDivision → TB_FX_USERGROUPAUTHEXTENTION |
| 시트 잠금 | `siMain.IsLock(siMain.SheetName)` (InsertButton, ComboSelChange) |

---

## 8. To-Be 전환 메모 (Wijmo · Oracle 관점)

| # | AS-IS | To-Be에서 바뀌는 점 |
|---|---|---|
| T01 | FpSpread + SetSheetHeaderColumn(메타 2단 헤더) | Wijmo FlexGrid + 메타 기반 컬럼 생성. 2단 헤더는 columnHeaders 행 추가와 병합으로 구현한다. SAFETY_STOCK 숨김은 메타·코드 이중 정의이므로 한 곳으로 정리해야 한다 |
| T02 | Distribution Route 코드 하드코딩 33컬럼 | 메타가 없다. FE 컬럼 정의로 옮기거나 메타 등록 여부를 결정해야 한다. DAYS_* 7개 bVisible=false 처리와 상단 그룹 헤더(302, 311~317줄) 원문 확인이 먼저다 |
| T03 | SetCellTypeCombo(행 단위 콤보 교체: DIVISION_ID, INCOTERMS, INCOTERMS_SSP, TO_SITE_CODE) | FlexGrid는 행마다 다른 dataMap이 필요하다(beginningEdit 또는 cellEditEnding에서 후보 전환). TO_SITE_CODE의 sFromSite/OSP_YN 필터 로직을 FE로 옮긴다 |
| T04 | dsdm.Changed 이벤트 해제/재등록으로 재진입 방지 | FlexGrid cellEditEnded 처리에서 프로그램 설정값과 사용자 입력을 구분하는 플래그가 필요하다 |
| T05 | UsrCheckedList2 → GetCheckedListValue(CODE) | MultiSelect 선택값을 구분자 문자열 또는 배열로 넘긴다. 파라미터 매핑 확인 필요 |
| T06 | MSSQL `STRING_SPLIT` (GET_BOD, GET_COUNTRY_CITY, SAVE_BOD, SCP0005_GET_DISTRIBUTION_ROUTE) | Oracle에는 STRING_SPLIT이 없어 대체 구현(분해 함수, JSON_TABLE 등)이 필요하다 |
| T07 | `SCP0007_GET_BOD` 동적 SQL | Oracle 동적 SQL(EXECUTE IMMEDIATE / OPEN REF CURSOR FOR)로 전환한다. 결과 컬럼과 BOD 메타 39컬럼 대조가 필요하다 |
| T08 | `#TMP_SCM_MST_SITE_ITEM` | Oracle GTT 등 임시 저장 구조로 바꾼다 |
| T09 | EXEC PR_SCP_MST_BOD_HIST / PR_SCP_MST_BOD_ITEM / PR_SCM_SYS_LOG_BATCH / PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF FN_NEXT_DAY / SCM_ARR_SPL_CNT / SCM_ARR_SPL_VAL | 하위 객체의 Oracle 전환 상태를 확인해야 한다 |
| T10 | `UPDATE:X`(별칭) | 실제 대상 테이블을 확정한 뒤 Oracle UPDATE/MERGE 구문으로 옮긴다 |
| T11 | ERR_MESSAGE 결과 테이블로 판정 | TO-BE 저장 결과 커서(코드·메시지) 계약으로 바꾼다 |
| T12 | popCity 도시 검색 팝업 | 공통 도시 선택 팝업으로 연결할지 확인 필요 |

---

## 9. 미확정

1. 조회조건 실제 배치(Location)와 행 순서. §2는 Size 일치로 추정한 것이다.
2. usrLayoutControl1(657×184, parent 미기록)의 용도.
3. FindButton 내부 호출 순서와 `SCP.SCP0007_GET_COUNTRY_CITY` 결과의 용도.
4. 메인 `spdMain_CellDoubleClick` → 팝업 호출 방식, 생성자 인자, 반환 매핑.
5. `cboDivision_SelectedIndexChanged`, `SpdMain_TopChange`, `SpdMain_KeyPress`, `SpdMain_ClipboardPasted`, `SpdMain_EditChange`, 팝업 `spdMain_CellDoubleClick`, `spdMainDataModel_Changed`의 세부 동작.
6. BOD 메타 컬럼 타입·폭·정렬·편집 여부·표시 순서. InitSpread:277 cellTypeImage 대상 컬럼.
7. Distribution Route DAYS_* 표시 여부, 상단 그룹 헤더 문구, `DefColumns.TRANSPORT_MODE` 상수값.
8. 조회조건 콤보 원천(Div, From/To Site, Incoterms, SSP Incoterms, Trans Mode, Input Status)과 초기값.
9. 메시지 ID, 필수 검증, 권한 C/R/U/D 값.
