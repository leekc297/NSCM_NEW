# SCP0005 Distribution Route — 화면설계서

> 근거: Fact Pack(controls.csv·props.csv·events.csv·flow.csv·grid_effective.csv·grid_code.csv)에 있는 사실만 사용했습니다. 없는 값은 **확인 필요**로 적었습니다.

## 1. 화면 개요

| 항목 | 값 | 근거 |
|---|---|---|
| 화면 ID | SCP0005 | Fact Pack |
| 화면 명칭 | Distribution Route | props.csv this.Text (Designer.cs:555) |
| 메인 폼 클래스 | `SCP0005_DistributionRoute` | controls.csv |
| 공유 팝업 | `SCP0005_DistributionRoutePopup` — Text "DistributionRoute History" | props.csv Popup.Designer.cs:99 |
| 도메인 | SCP | 프로젝트 GSCM.SCP.Forms.UIL |
| 메뉴 위치 | **확인 필요** (메타 TB_FX_MenuItemInfo 1행이 있지만 본문 값은 없음) | |
| 시트 | `Distribution Route`(메인), `POPUP`(팝업) | grid_code.csv |

## 2. 화면 레이아웃

### 2-1. 분할 구조 판정
- props.csv에 **SplitContainer가 없습니다**(Orientation·SplitterDistance 속성 0건). 그래서 분할 트리가 아니라 **Dock 기반 상/하 2단** 구조입니다. 좌/우 분할은 없습니다.
- controls.csv의 parent 체인:
```
this (SCP0005_DistributionRoute)
├─ usrConditionPanel1  [UsrConditionPanel, Dock=Top, 1227×65, UsrPanelType=HidePanel]
│   └─ usrLayoutControl2  [UsrLayoutControl, Dock=Fill, 1227×65, Text="usrLayoutControl2"]
│        ├─ cboValidYN       [UsrCombo 168×20]        (layoutControlItem3 "Valid")
│        ├─ clbTransMode     [UsrCheckedList 149×21]  (layoutControlItem4 "Trans Mode")
│        ├─ txtFromCountry   [TextBox 139×25]         (layoutControlItem5 "From Country")
│        ├─ txtFromCity      [TextBox 142×25]         (layoutControlItem2 "From City")
│        ├─ btnFromSrch      [UsrButton 39×25]        (layoutControlItem7 Text="layoutControlItem6")
│        ├─ txtToCountry     [TextBox 169×25]         (layoutControlItem1 "To Country")
│        ├─ txtToCity        [TextBox 177×25]         (layoutControlItem8 "To City")
│        ├─ btnToSrch        [UsrButton 39×25]        (layoutControlItem6, Text 없음)
│        ├─ btnEaxel_Upload  [SimpleButton 76×22, "Upload"]     (layoutControlItem9)
│        └─ btnExcel_Form    [SimpleButton 87×22, "Excel Form"] (layoutControlItem10)
├─ spdMain  [FpSpread, Dock=Fill, 1227×492]
│   └─ spdMain_Sheet1 → 시트 "Distribution Route" (AddSheet@CreateSpread:233)
└─ (parent 미지정) usrLayoutControl1 [UsrLayoutControl, Dock=Fill, 657×184] / layoutControlGroup1 657×184 — 실사용 여부 확인 필요
   imageList1 [ImageList] — 용도 확인 필요

SCP0005_DistributionRoutePopup ("DistributionRoute History")
└─ spdMain [FpSpread, Dock=Fill, 1387×589]
    └─ spdMain_Sheet1 → 시트 "POPUP" (AddSheet@CreateSpread:122)
```

### 2-2. 텍스트 와이어프레임 (메인)
높이 비율은 Designer Size로 계산했습니다. 조회 영역 65 ÷ 전체 557 ≈ **11.7%**, 그리드 492 ÷ 557 ≈ **88.3%**입니다. 실행 중 창 크기에 따라 달라집니다.
```
┌──────────────────────────────── Distribution Route (1227) ───────────────────────────────┐
│ [조회조건] usrConditionPanel1 (Top, 접기 가능 HidePanel)                    ≈11.7%      │
│  행1(h25): Valid [cboValidYN▼] | Trans Mode [clbTransMode☑▼] | (emptySpaceItem4 783)     │
│  행2(h29): From Country [txtFromCountry] From City [txtFromCity][btnFromSrch]            │
│            To Country [txtToCountry] To City [txtToCity][btnToSrch]                      │
│            [btnEaxel_Upload "Upload"] [btnExcel_Form "Excel Form"] (emptySpaceItem1 61)  │
├──────────────────────────────────────────────────────────────────────────────────────────┤
│ [그리드] spdMain — 시트 "Distribution Route" (Fill, 헤더 2행, 39컬럼)       ≈88.3%      │
│                                                                                          │
└──────────────────────────────────────────────────────────────────────────────────────────┘
 툴바(프레임워크): FindButton(조회) · SaveButton(저장) · EditButton(318)
```
- 행 배치는 LayoutControlItem 높이(25/29)와 폭의 합으로 추정했습니다. layoutControlGroup2는 1227×74입니다. 행1 폭 합은 202+222+783=1207, 행2 폭 합은 222+202+43+240+225+43+80+91+61=1207입니다. 실제 좌표는 Fact Pack에 없어 **확인 필요**입니다.

### 2-3. 팝업 와이어프레임
```
┌─────────── DistributionRoute History (1387) ───────────┐
│ spdMain — 시트 "POPUP" (Fill 100%, 헤더 2행, 16컬럼)   │
└─────────────────────────────────────────────────────────┘
```

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수여부 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | — | UsrPanelType=HidePanel, Dock Top | — | — | 조회조건 패널(접기/펼치기) |
| usrLayoutControl2 | UsrLayoutControl | "usrLayoutControl2" | Dock Fill | — | — | 조회조건 레이아웃 그리드 |
| usrLayoutControl1 | UsrLayoutControl | — | Dock Fill, 657×184, parent 미지정 | — | — | 해당 없음(실사용 확인 필요) |
| cboValidYN | UsrCombo | "Valid" | 확인 필요(후보 dtValidYN = `biz:CommonData.YesOrNo`) | 확인 필요 | — | Wijmo ComboBox(단일) |
| clbTransMode | UsrCheckedList | "Trans Mode" | 확인 필요(후보 dtTransMode = `biz:CommonData.CommonDataList` [LookupCommon]) | 확인 필요 | — | Wijmo MultiSelect |
| txtFromCountry | TextBox | "From Country" | 빈값(확인 필요) | 확인 필요 | btnFromSrch_Click 이 값을 채움 | InputText |
| txtFromCity | TextBox | "From City" | 빈값(확인 필요) | 확인 필요 | btnFromSrch_Click 이 값을 채움 | InputText |
| btnFromSrch | UsrButton | 아이템 Text "layoutControlItem6"(원문), 버튼 Text 없음 | — | — | Click → `btnFromSrch_Click` | 검색 아이콘 버튼 → City 팝업 |
| txtToCountry | TextBox | "To Country" | 빈값(확인 필요) | 확인 필요 | btnToSrch_Click 이 값을 채움 | InputText |
| txtToCity | TextBox | "To City" | 빈값(확인 필요) | 확인 필요 | btnToSrch_Click 이 값을 채움 | InputText |
| btnToSrch | UsrButton | 없음 | — | — | Click → `btnToSrch_Click` | 검색 아이콘 버튼 → City 팝업 |
| btnEaxel_Upload | SimpleButton | "Upload" | — | — | Click → `btnEaxel_Upload_Click` (InitEvent:189) | Excel 업로드 버튼 |
| btnExcel_Form | SimpleButton | "Excel Form" | — | — | Click → `btnExcel_Form_Click` (Designer:327) | Excel 양식 버튼 |
| spdMain (메인) | FpSpread | — | Dock Fill 1227×492 | — | CellDoubleClick → `spdMain_CellDoubleClick`; 데이터모델(dsdm) Changed → `spdMainDataModel_Changed` | Wijmo FlexGrid |
| spdMain_Sheet1 (메인) | SheetView | 시트 "Distribution Route" | 헤더 2행 | — | — | FlexGrid 컬럼 정의(메타) |
| spdMain (팝업) | FpSpread | — | Dock Fill 1387×589 | — | — | 팝업 내 Wijmo FlexGrid |
| spdMain_Sheet1 (팝업) | SheetView | 시트 "POPUP" | 헤더 2행 | — | — | 팝업 FlexGrid 컬럼 정의 |
| 폼(this, 메인) | Form | "Distribution Route" | — | — | Load → `Form_Load` (.ctor:144) | 페이지 |
| 폼(this, 팝업) | Form | "DistributionRoute History" | — | — | Load → `Form_Load` (.ctor:98) | 모달 팝업 |

부속 레이아웃(To-Be 대상 아님): layoutControlGroup1/2, layoutControlItem1~10, emptySpaceItem1(61×29), emptySpaceItem4(783×25), imageList1.

## 4. 그리드 명세

공통 사항
- 출처: 모든 컬럼이 META(SCM_MST_SHEET_COLUMNS)입니다. 하드코딩 컬럼은 0개입니다.
- 헤더: 2행(SetSheetHeaderColumn iColumnHeaderRowCount=2)입니다. 그룹 헤더명은 ATTRIBUTE1~5에 들어 있다고 보이지만 값은 **확인 필요**입니다.
- 타입·편집 가능 여부: 메타 CELL_CONTROL_OBJECT_TYPE_CODE와 FIXED_FLAG 값이 Fact Pack 본문에 없어 **확인 필요**입니다.
- division별 표시: 14개 division 모두 같습니다(필수=표시, 기본=표시).
- 아래 순서는 의미 단위로 묶은 순서이고 **실제 화면 컬럼 순서가 아닙니다**(확인 필요).
- 코드 쪽 표시 변경: ColumnHeader 기본 스타일(HorizontalAlignment/VerticalAlignment=General, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced). 메인은 Designer 515~518행, 팝업은 65~68행입니다. 조회 결과가 1행 이상일 때 `SetSpreadColumn(siMain)` 을 호출합니다.

### 4-1. 시트 `Distribution Route` (39컬럼)

| # | 컬럼 | 헤더(원문) | 타입 | 출처 | division별 표시 | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | ROUTE_ID | Route Id | 확인 필요 | META | 14개 전부 필수 | 확인 필요 |
| 2 | FROM_COUNTRY | Country* | 확인 필요 | META | 14개 전부 기본 | 확인 필요 |
| 3 | FROM_CITY | City* | 확인 필요 | META | 기본 | 확인 필요 |
| 4 | FROM_CITY_NAME | City Name | 확인 필요 | META | 기본 | 확인 필요 |
| 5 | TO_COUNTRY | Country* | 확인 필요 | META | 기본 | 확인 필요 |
| 6 | TO_CITY | City* | 확인 필요 | META | 기본 | 확인 필요 |
| 7 | TO_CITY_NAME | City Name | 확인 필요 | META | 기본 | 확인 필요 |
| 8 | D_COUNTRY | Country* | 확인 필요 | META | 기본 | 확인 필요 |
| 9 | D_PORT_CODE | Port Code* | 확인 필요 | META | 기본 | 확인 필요 |
| 10 | D_PORT_NAME | Port* | 확인 필요 | META | 기본 | 확인 필요 |
| 11 | A_COUNTRY | Country* | 확인 필요 | META | 기본 | 확인 필요 |
| 12 | A_PORT_CODE | Port Code* | 확인 필요 | META | 기본 | 확인 필요 |
| 13 | A_PORT_NAME | Port* | 확인 필요 | META | 기본 | 확인 필요 |
| 14 | TRANSPORT_MODE | Trans Mode* | 확인 필요 | META | 기본 | 확인 필요 |
| 15 | SHIPPING_COMPANY | Forwarder* | 확인 필요 | META | 기본 | 확인 필요 |
| 16 | PRIORITY | Priority* | 확인 필요 | META | 기본 | 확인 필요 |
| 17 | LT_TYPE | L/T Type* | 확인 필요 | META | 기본 | 확인 필요 |
| 18 | VALID_YN | Valid* | 확인 필요 | META | 기본 | 확인 필요 |
| 19 | LT_DEPARTURE_INLAND | Departure Inland | 확인 필요 | META | 기본 | 확인 필요 |
| 20 | LT_WAIT_SHIPPING | Waiting For Shipping | 확인 필요 | META | 기본 | 확인 필요 |
| 21 | LT_VOYAGE | Voyage | 확인 필요 | META | 기본 | 확인 필요 |
| 22 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | 확인 필요 | META | 기본 | 확인 필요 |
| 23 | LT_ARRIVAL_INLAND | Arrival Inland | 확인 필요 | META | 기본 | 확인 필요 |
| 24 | LT_SUM | Total L/T | 확인 필요 | META | 기본 | 확인 필요 |
| 25 | SHIP_DOC_PREPARATION_DATE | Shipping Document Preparation Date | 확인 필요 | META | 기본 | 확인 필요 |
| 26 | One_SEGMENT_COST | Pick Up Cost | 확인 필요 | META | 기본 | 확인 필요 |
| 27 | Two_SEGMENT_COST | Freight Cost | 확인 필요 | META | 기본 | 확인 필요 |
| 28 | Three_SEGMENT_COST | Delivery Cost | 확인 필요 | META | 기본 | 확인 필요 |
| 29 | DAYS_MON | Mon | 확인 필요 | META | 기본 | 확인 필요 |
| 30 | DAYS_TUE | Tue | 확인 필요 | META | 기본 | 확인 필요 |
| 31 | DAYS_WED | Wed | 확인 필요 | META | 기본 | 확인 필요 |
| 32 | DAYS_THU | Thu | 확인 필요 | META | 기본 | 확인 필요 |
| 33 | DAYS_FRI | Fri | 확인 필요 | META | 기본 | 확인 필요 |
| 34 | DAYS_SAT | Sat | 확인 필요 | META | 기본 | 확인 필요 |
| 35 | DAYS_SUN | Sun | 확인 필요 | META | 기본 | 확인 필요 |
| 36 | CREATED_BY | Created By | 확인 필요 | META | 기본 | 확인 필요 |
| 37 | CREATION_DATE | Creation Date | 확인 필요 | META | 기본 | 확인 필요 |
| 38 | LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 기본 | 확인 필요 |
| 39 | LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 기본 | 확인 필요 |

### 4-2. 시트 `POPUP` (16컬럼, 이력 팝업)

| # | 컬럼 | 헤더(원문) | 타입 | 출처 | division별 표시 | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | ROUTE_ID | Route Id | 확인 필요 | META | 14개 전부 필수 | 확인 필요 |
| 2 | LT_DEPARTURE_INLAND | Departure Inland | 확인 필요 | META | 기본 | 확인 필요 |
| 3 | LT_WAIT_SHIPPING | Waiting For Shipping | 확인 필요 | META | 기본 | 확인 필요 |
| 4 | LT_VOYAGE | Voyage | 확인 필요 | META | 기본 | 확인 필요 |
| 5 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | 확인 필요 | META | 기본 | 확인 필요 |
| 6 | LT_ARRIVAL_INLAND | Arrival Inland | 확인 필요 | META | 기본 | 확인 필요 |
| 7 | LT_SUM | Total L/T | 확인 필요 | META | 기본 | 확인 필요 |
| 8 | DAYS_MON | Mon | 확인 필요 | META | 기본 | 확인 필요 |
| 9 | DAYS_TUE | Tue | 확인 필요 | META | 기본 | 확인 필요 |
| 10 | DAYS_WED | Wed | 확인 필요 | META | 기본 | 확인 필요 |
| 11 | DAYS_THU | Thu | 확인 필요 | META | 기본 | 확인 필요 |
| 12 | DAYS_FRI | Fri | 확인 필요 | META | 기본 | 확인 필요 |
| 13 | DAYS_SAT | Sat | 확인 필요 | META | 기본 | 확인 필요 |
| 14 | DAYS_SUN | Sun | 확인 필요 | META | 기본 | 확인 필요 |
| 15 | LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 기본 | 확인 필요 |
| 16 | LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 기본 | 확인 필요 |

## 5. 액션 명세

| ID | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A1 | 메인 화면 로드 | `Form_Load` (.ctor:144) | InitControls(조회조건 복원). 필드 초기화 공통코드는 진입점 미연결(시점 확인 필요) | `biz:CommonData.CommonDataList` [COUNTRY_MST, LookupCommon], `biz:CommonData.YesOrNo` | cboValidYN·clbTransMode 데이터 후보(확인 필요), 조회조건 복원 |
| A2 | btnFromSrch 클릭 | `btnFromSrch_Click` | popCity 결과 반영 | popCity 엔드포인트는 확인 필요 | txtFromCountry ← popCity.Country, txtFromCity ← popCity.City |
| A3 | btnToSrch 클릭 | `btnToSrch_Click` | popCity 결과 반영 | popCity 엔드포인트는 확인 필요 | txtToCountry ← popCity.Country, txtToCity ← popCity.City |
| A4 | 툴바 FindButton | (프레임워크 오버라이드) FindDataMain / FindDataReceive / GetData_Country | 분기 조건 확인 필요 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` / `SCP.SCP0005_GET_DISTRIBUTION_ROUTEID` / `SCP.SCP0005_GET_COUNTRY_CITY` | 시트 `Distribution Route` 바인딩. Rows>0이면 SetSpreadColumn. GET_COUNTRY_CITY 결과 반영 위치(SetCityCode 여부)는 확인 필요 |
| A5 | 그리드 셀 값 변경 | `spdMainDataModel_Changed` | 핸들러 해제(970) → 처리 → 재등록(1082) | 없음 | 변경 셀·계산 확인 필요 |
| A6 | 툴바 SaveButton | SaveData(752) | 저장 → 오류 확인 → 재조회 | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` → `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | 오류: ERR_MESSAGE(871). 성공: 목록 재조회 |
| A7 | 그리드 셀 더블클릭 | `spdMain_CellDoubleClick` | Changed 핸들러 해제(1135) → 처리 → 재등록(1164) | 없음(팝업 호출 여부 확인 필요) | 확인 필요 |
| A8 | btnEaxel_Upload 클릭 | `btnEaxel_Upload_Click` | 업로드(방식 확인 필요) → FindDataMain | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | 목록 재조회 |
| A9 | btnExcel_Form 클릭 | `btnExcel_Form_Click` | 양식 생성(확인 필요) | 없음 | 확인 필요(메타 SCM_ADM_EXCEL_COLUMNS 1행) |
| A10 | 팝업 로드 / 팝업 FindButton | `Form_Load` (.ctor:98) → FindData(171) | 이력 조회 | `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` | 시트 `POPUP` 바인딩 |
| A11 | 툴바 EditButton | EditButton(318) | `if(fps.Name == "spdMain")` 조건에서 GetSheetInfo | 없음 | 확인 필요 |
| (참고) | 호출자 없음 | GetFromSitebyDivision / GetToSitebyDivision / GetBodType / GetTransMode | — | `biz:CommonData.CommonDataList` [FromSiteByDivision / ToSiteByDivision / BodType / TransportMode] | 사용 여부 확인 필요 |

## 6. 검증·메시지

| 항목 | 사실 | 비고 |
|---|---|---|
| 저장 오류 | SaveData가 `dtErr.Rows[0]["ERR_MESSAGE"]` 를 읽음(871) | 메시지 표시 방식(MessageBox 등)은 확인 필요 |
| 빈 조회 결과 | Rows.Count = 0이면 SetSpreadColumn을 호출하지 않음 | 빈 결과 안내 메시지가 있는지는 확인 필요 |
| 필수 입력 | 메타 라벨에 `*` 표시가 15개 | 검증 로직 위치는 확인 필요 |
| 메시지 코드 | Fact Pack에 없음 | 확인 필요 |
| 헤더 Note 표시 | ColumnHeader NoteIndicatorColor=Red | 용도는 확인 필요 |

## 7. 권한 (C/R/U/D)

| 권한 | 사실 |
|---|---|
| R | 조회 엔드포인트 4종(ROUTE, ROUTEID, COUNTRY_CITY, HISTORY_ROUTEID) |
| C/U/D | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` 1종(INSERT/UPDATE/DELETE) |
| 메뉴 권한 | TB_FX_GroupMenuAuth 13행. 그룹별 플래그 값과 버튼 활성/비활성 연동은 **확인 필요** |
| 그룹 | UserInfoContext.Current["NowGroupID"](60행) |

## 8. To-Be 전환 메모 (Wijmo·Oracle)

| 항목 | AS-IS | To-Be 고려 |
|---|---|---|
| 레이아웃 | Dock Top 조회패널 + Fill 그리드 | 조회조건 영역 + FlexGrid 2단. 비율 11.7/88.3은 Designer 값 기준 |
| 그리드 | FarPoint FpSpread, 메타 SetSheetHeaderColumn, 헤더 2행 | Wijmo FlexGrid + 메타 컬럼(SCM_MST_SHEET_COLUMNS) 2단 헤더(columnHeaders 행 추가/병합) |
| 셀 변경 이벤트 | dsdm.Changed 핸들러를 해제하고 재등록 | FlexGrid cellEditEnded. 재귀를 막는 플래그로 대체 |
| 셀 더블클릭 | spdMain.CellDoubleClick | FlexGrid hostElement dblclick / hitTest |
| City 검색 | popCity 팝업 | 공통 City 검색 팝업(엔드포인트 확인 후 결정) |
| 다중 선택 | UsrCheckedList + GetCheckedListValue(CODE) | Wijmo MultiSelect. SP 쪽 STRING_SPLIT → Oracle 문자열 분해 방식으로 변환 필요 |
| SP | MSSQL SP 5종 | Oracle PKG/SP로 변환. STRING_SPLIT 등 MSSQL 전용 구문 제거 |
| 저장 | 배열 파라미터 + SCM_ARR_SPL_CNT/VAL | 행 단위 JSON/리스트 바인딩 검토 |
| 버튼 철자 | btnEaxel_Upload | AS-IS 이름은 대조용으로만 쓰고, To-Be 이름은 명명 규약을 따름 |
| 이력 팝업 | 공유 팝업(GSCM.SCM.Popup.UIL) | 공용 팝업 컴포넌트 위치 검토 |

## 9. 미확정

1. 메뉴 위치
2. FindButton 3경로의 분기 조건
3. popCity의 정체와 엔드포인트
4. spdMain_CellDoubleClick → 이력 팝업 호출 여부, 넘기는 키
5. spdMainDataModel_Changed 셀 계산
6. Excel Upload 저장 경로, Excel Form 양식 생성 방식
7. 그리드 컬럼 실제 순서, 2단 헤더 그룹명, 셀 타입, 편집 가능 여부
8. cboValidYN·clbTransMode의 초기값과 데이터 바인딩
9. usrLayoutControl1, imageList1 용도
10. SaveButton:333 SaveData 매핑 충돌
11. TB_FX_GroupMenuAuth 권한 값
