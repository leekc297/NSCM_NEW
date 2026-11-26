# DMF0045 ShipmentRequest — 화면설계서

> 근거: AsisFacts Fact Pack(DMF0045)의 controls.csv, props.csv, events.csv, flow.csv, grid_code.csv, grid_effective.csv입니다. 없는 사실은 **확인 필요**로 적었습니다.
> 함께 보는 문서: §5 액션 명세의 엔드포인트는 업무분석서 §5, 단위테스트 근거 열과 같은 이름입니다. §3 컨트롤명은 단위테스트 절차 열에서 그대로 씁니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | DMF0045 |
| 화면 명칭(폼 Text) | `ShipmentRequest` (Designer:1039) |
| 클래스 | `DMF0045_ShipmentRequest` |
| 프로젝트 | `06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj` |
| 메뉴 위치 | **확인 필요** (`TB_FX_MenuItemInfo` 1행이 있지만 값은 Fact Pack에 없음) |
| 프레임워크 버튼 | FindButton(조회), InsertButton(행추가), SaveButton(저장), EditButton(편집) — flow.csv, grid_code 443 |
| 그리드 시트 | `Pack Biz`(초기 활성), `Cell Biz` |

## 2. 화면 레이아웃

### 2-1. 분할 구조 판정

- props.csv에는 **SplitContainer가 없습니다**(Orientation·SplitterDistance 속성 0건). 그래서 화면은 SplitContainer 분할이 아니라 **Dock 배치**로 구성됩니다.
- controls.csv parent 체인은 다음과 같습니다.

```
this (DMF0045_ShipmentRequest, Text="ShipmentRequest")
 ├─ usrConditionPanel1   [UsrConditionPanel, Dock=Top, 1284×95, UsrPanelType=HidePanel]
 │   └─ usrLayoutControl2 [UsrLayoutControl, Dock=Fill, 1284×95, Text="usrLayoutControl2"]
 │        ├─ cboDivision, cboBucketType, drpPeriod
 │        ├─ clbPlantSite, clbSalesSite, clbCustomer, clbTeam
 │        ├─ txtProject, btnProject, txtItemId, btnItemId
 │        └─ chkSum, btnMeasure, btnColumn(Visible=false)
 └─ spdMain              [FpSpread, Dock=Fill, 1284×479]
      └─ spdMain_Sheet1  [SheetView, parent 미추출]
 (parent 미추출) usrLayoutControl1 [UsrLayoutControl, Dock=Fill, 657×184] / layoutControlGroup1 657×184
```

### 2-2. 텍스트 와이어프레임 (상/하 분할, 비율은 Size 실측값으로 계산)

- 계산식: 상단 95 / (95+479) = 16.55%, 하단 479 / 574 = 83.45%
- 좌우 분할은 없습니다.

```
┌──────────────────────────────── 1284 ────────────────────────────────┐
│ [조회조건] usrConditionPanel1 (Dock Top, 높이 95 = 16.55%, 접기 HidePanel) │
│   usrLayoutControl2 / layoutControlGroup2 (1284×95)                   │
│   Division[cboDivision]  Bucket[cboBucketType]  Period[drpPeriod(비활성)] │
│   Plant Site[clbPlantSite]  Sales Site[clbSalesSite]                  │
│   End Customer[clbCustomer]  Team[clbTeam]                            │
│   Project[txtProject][btnProject]  Model[txtItemId][btnItemId]        │
│   [chkSum "Sum"] [btnMeasure] [btnColumn(Visible=false)]              │
│   ※ 위 행·열 배치 순서는 확인 필요(Location 미추출)                   │
├───────────────────────────────────────────────────────────────────────┤
│ [그리드] spdMain (Dock Fill, 높이 479 = 83.45%)                       │
│   시트 탭: [Pack Biz] [Cell Biz]  — 헤더 3행 + ColumnFooter(합계)      │
│   고정 컬럼 | M_ / W_ / D_ 버킷 컬럼(SP 생성) + SUM                     │
└───────────────────────────────────────────────────────────────────────┘
[팝업] btnProject_Click / btnItemId_Click → 선택값 반환(팝업 화면 ID 확인 필요)
```

- 조회조건 영역의 높이: emptySpaceItem8의 Size가 10×75이고 LayoutControlItem 높이가 25이므로, 높이상 25×3 = 3행분입니다. 실제 행·열 배치는 **확인 필요**입니다.
- 조회조건 LayoutControlItem 크기(props.csv): clbDivision 303×25, lblBucket 316×25, Period 236×25, lblPlantSite 303×25, lblSalesSite 303×25, lblCustomer 346×25, lblTeam 359×25, lblProject 316×25, layoutControlItem3 43×25, lblModel 309×25, layoutControlItem1 41×25, layoutControlItem5 61×25, layoutControlItem4 38×25, layoutControlItem2 44×25, layoutControlItem6 128×25, layoutControlItem7 146×25, lblItemType 297×24.
- `lblItemType`("Item Type"), layoutControlItem6, layoutControlItem7에 연결된 컨트롤은 추출되지 않았습니다(**확인 필요**).

## 3. 컨트롤 명세

| # | 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값/속성 | 필수 | 연결 이벤트 | To-Be 컴포넌트(후보) |
|---:|---|---|---|---|---|---|---|
| 1 | `usrLayoutControl1` | UsrLayoutControl | — | Dock=Fill, 657×184. parent 미추출 | — | — | 용도 **확인 필요** |
| 2 | `usrConditionPanel1` | UsrConditionPanel | — | Dock=Top, 1284×95, UsrPanelType=HidePanel | — | — | 조회조건 패널(접기) |
| 3 | `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2`(Text) | Dock=Fill, 1284×95 | — | — | 조회조건 레이아웃 |
| 4 | `cboDivision` | UsrCombo | `Division`(clbDivision.Text:936) | 257×20. 목록 = `biz:CommonData.CommonDataList` [code=MyDivision] | 확인 필요 | SelectedIndexChanged → `cboDivision_SelectedIndexChanged` | 단일 선택 콤보(Wijmo ComboBox 계열) |
| 5 | `cboBucketType` | UsrCombo | `Bucket`(lblBucket.Text:948) | 256×20. 목록 = `DM.DM0003_GET_BUCKET_TYPE_CODE`. 초기 선택값 확인 필요 | 확인 필요 | SelectedIndexChanged → `cboBucketType_SelectedIndexChanged` | 단일 선택 콤보 |
| 6 | `drpPeriod` | UsrDateRangePicker | 확인 필요(LayoutControlItem 이름 `Period`, Text 미추출) | **Enabled=false**(515), 180×20 | 확인 필요 | — | 기간(From~To) 입력, 비활성 |
| 7 | `clbPlantSite` | UsrCheckedList | `Plant Site`(901) | 242×21. 데이터 소스 확인 필요 | 확인 필요 | — | 다중 선택(MultiSelect) |
| 8 | `clbSalesSite` | UsrCheckedList | `Sales Site`(824) | 242×21. 데이터 소스 확인 필요 | 확인 필요 | — | 다중 선택 |
| 9 | `clbCustomer` | UsrCheckedList | `End Customer`(798) | 247×21. 데이터 소스 확인 필요 | 확인 필요 | SelectedIndexChanged → `clbCustomer_SelectedIndexChanged` | 다중 선택 |
| 10 | `clbTeam` | UsrCheckedList | `Team`(786) | 306×21. 데이터 소스 확인 필요 | 확인 필요 | SelectedIndexChanged → `clbTeam_SelectedIndexChanged` | 다중 선택 |
| 11 | `txtProject` | UsrMultiLineEditor | `Project`(856) | 255×21 | 확인 필요 | (`btnProject_Click`이 값 대입) | 멀티라인 입력 |
| 12 | `btnProject` | UsrButton | 확인 필요(layoutControlItem3 Text 미추출) | 39×21 | — | Click → `btnProject_Click` | 찾기 버튼 + 팝업 |
| 13 | `txtItemId` | UsrMultiLineEditor | `Model`(844) | 255×21 | 확인 필요 | (`btnItemId_Click`이 값 대입) | 멀티라인 입력 |
| 14 | `btnItemId` | UsrButton | 확인 필요(layoutControlItem1 Text 미추출) | 37×21 | — | Click → `btnItemId_Click` | 찾기 버튼 + 팝업 |
| 15 | `chkSum` | UsrCheckBox | `Sum`(278) | 70×21. 초기 체크 여부 확인 필요 | — | CheckedChanged → `chkSum_CheckedChanged` | 체크박스 |
| 16 | `btnMeasure` | UsrButton | 확인 필요(layoutControlItem4 Text 미추출) | 34×21 | — | Click → `btnMeasure_Click` | 버튼 |
| 17 | `btnColumn` | UsrButton | 확인 필요(layoutControlItem2 Text 미추출) | **Visible=false**(356), 40×21 | — | Click → `btnColumn_Click` | 미표시 버튼(TO-BE 필요 여부 확인 필요) |
| 18 | `spdMain` | FpSpread | — | Dock=Fill, 1284×479 | — | CellDoubleClick → `spdMain_CellDoubleClick` / ComboSelChange → `spdMain_ComboSelChange` / TopChange → `spdMain_TopChange` / KeyUp → `spdMain_KeyUp`. 데이터소스 dsdmPack·dsdmCell Changed → `spdMain_Changed` | Wijmo FlexGrid(시트 2개 → 탭 + Grid) |
| 19 | `spdMain_Sheet1` | SheetView | — | Designer 기본 시트. 런타임 시트는 AddSheet로 `Pack Biz`, `Cell Biz`를 생성합니다. spdMain_Sheet1과의 관계는 **확인 필요** | — | — | (TO-BE 별도 대응 없음, 확인 필요) |

- 폼 이벤트: this.Load → `Form_Load`(.ctor:165).

## 4. 그리드 명세

### 4-1. 공통 구성

| 항목 | 내용 | 출처 | 근거 |
|---|---|---|---|
| 시트 생성 | `AddSheet(spdMain, "Pack Biz", ..., 3, 1, 40)`, `AddSheet(spdMain, "Cell Biz", ..., 3, 1, 40)`. 초기 활성은 `ChangeSheet("Pack Biz")` | HARDCODED | CreateSpread:255/260/265 |
| 컬럼 생성 | `CreateSheetHeaderColumn(siMain, 3, dtTitle)`. dtTitle = `DM.DMF0045_GET_SPREAD_TITLE` | META | InitSpread:272 |
| 메타 소비 컬럼 | COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, LARGE/SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, PROGRAM_ID, SHEET_NAME | META | Fact Pack 4-2 |
| 헤더 3행 | 0행 = 대분류(LARGE_LABEL) Span + `SUM`, 1행 = 소분류(SMALL_LABEL) Span, 2행 = `SUM`. Span 기준 컬럼은 `DefColumns.Requestor` | HARDCODED+META | SetSpreadHeaderSpan:327~381 |
| `B_` 컬럼 | 숨김 | HARDCODED | 335 |
| 주말 헤더색 | DAY_CODE SAT = Blue, SUN = Red | HARDCODED | 346 |
| 날짜 버킷 컬럼 | 태그 접두어 `D_`/`W_`/`M_`. SP가 생성(SCM_SYS_CALENDAR_M) | SP 동적 | 2152~2184 |
| Footer | `ColumnFooter.Visible = true`. Set_SumValues가 MEASURE 컬럼을 참조 | HARDCODED | 285, 734 |
| 헤더 기본 스타일 | HorizontalAlignment=General, VerticalAlignment=General, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced | HARDCODED | Designer:999~1002 |

### 4-2. 시트 `Cell Biz` 컬럼 (grid_effective, 출처 META)

> 컬럼 순서는 grid_effective 나열 순서이며 SORT_ORDER_NO가 아닙니다. 실제 순서는 **확인 필요**(dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv)입니다.
> 셀 타입은 메타 CELL_CONTROL_OBJECT_TYPE_CODE에 따르지만 값은 Fact Pack에 없습니다. 코드에서 콤보를 설정하는 것이 확인된 컬럼만 '콤보'로 적었습니다.

| 컬럼 | 헤더(원문) | 타입 | 출처 | 40 | 81 | 81_UC | 82 | EE 계열 | 편집 가능 |
|---|---|---|---|---|---|---|---|---|---|
| DIVISION_ID | Division* | 확인 필요 | META | 메타 없음 | 필수 | 필수 | 필수 | 메타 없음 | 확인 필요 |
| TEAM_NAME_KO | Team | 확인 필요 | META | 메타 없음 | 필수 | 필수 | 필수 | 메타 없음 | 확인 필요 |
| END_CUSTOMER | End Customer | 콤보(ComboSelChange 대상) | META | 메타 없음 | 필수 | 필수 | 필수 | 메타 없음 | 편집 가능(콤보 변경 이벤트 존재) |
| LAST_UPDATED_BY | Requestor | 확인 필요 | META | 메타 없음 | 필수 | 필수 | 필수 | 메타 없음 | 확인 필요 |
| FCST_TYPE | FCST Type* | 콤보(InsertRow:1003) | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 행추가 시 콤보 |
| FROM_SITE | Frorm ( Plant )* | 콤보(1158) | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 편집 가능(콤보) |
| TO_SITE | To ( Sales-Site )* | 확인 필요 | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 확인 필요 |
| INCOTERMS | Incoterms* | 확인 필요 | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 확인 필요 |
| TR_MODE | Trans Mode* | 확인 필요 | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 확인 필요 |
| ITEM_ID | Model* | 확인 필요 | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 확인 필요 |
| NICK_NAME | Nick Name | 확인 필요 | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 확인 필요 |
| PROJECT_CODE | Project Code* | 확인 필요 | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 확인 필요 |
| MEASURE | Measure* | 콤보(1005/1195) | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 편집 가능(콤보) |
| BOD_ID | BOD ID* | 확인 필요 | META | 메타 없음 | 숨김 | 숨김 | 숨김 | 메타 없음 | — |
| MEASURE_COLOR | MEASUR_COLOR | 확인 필요 | META | 메타 없음 | 숨김 | 숨김 | 숨김 | 메타 없음 | — |
| SHIP_FROZEN | DMF0045 | 확인 필요 | META | 메타 없음 | 숨김 | 숨김 | 숨김 | 메타 없음 | — |
| D_* / W_* / M_* | 날짜·SUM 라벨 | 숫자(확인 필요) | SP(HARDCODED 표시 제어) | — | Bucket·Sum에 따름 | 같음 | 같음 | — | 확인 필요 |

- `Cell Biz`의 SCM_MST_SHEET_MEASURE 행 수: 81 = 11, 81_UC = 11, 82 = 10.
- 원문 오탈자(`Frorm`, `MEASUR_COLOR`)와 라벨 `DMF0045`(SHIP_FROZEN)는 원문 그대로 적었습니다.

### 4-3. 시트 `Pack Biz` 컬럼 (grid_effective, 출처 META)

- 고정 컬럼 16개(표시 13, 숨김 3)의 컬럼·헤더·필수/기본/숨김 구분은 §4-2 `Cell Biz` 표와 **완전히 같습니다**(grid_effective.csv 행 단위 대조 결과).
- `Pack Biz`의 SCM_MST_SHEET_MEASURE 행 수: 81 = 9, 81_UC = 9, 82 = 8.
- 데이터소스 `dsdmPack`의 Changed 이벤트가 `spdMain_Changed`에 연결되어 있습니다(InitEvent:391). `Cell Biz` 쪽은 `dsdmCell`(394)입니다.

### 4-4. 버킷 표시 규칙 (SetSpreadColumn)

| cboBucketType | D_ | W_ | M_ | 근거 |
|---|---|---|---|---|
| DAILY | true | true(2152), 이어서 `chkSum.Checked`(2157). 최종값 **확인 필요** | `chkSum.Checked` | 2152/2157 |
| WEEKLY | false | true | `chkSum.Checked` | 2164/2168/2173 |
| MONTHLY | false | false | true | 2180/2184 |

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 로드 (this.Load) | `Form_Load` | InitControls → GetBucketType. CreateSpread → InitSpread | `biz:CommonData.CommonDataList` [code=MyDivision], [code=Measure], `DM.DM0003_GET_BUCKET_TYPE_CODE`, `DM.DMF0045_GET_SPREAD_TITLE` | cboDivision·cboBucketType 목록, 시트 `Pack Biz`/`Cell Biz`, 헤더 3행 |
| A2 | 조회 | FindButton → FindData | Measure 조회 → 데이터 조회 → InitSpread → (행≥1) SetSpreadColumn | `biz:CommonData.CommonDataList` [code=Measure], `DM.DMF0045_GET_SHIPMENT_REQUEST`, `DM.DMF0045_GET_SPREAD_TITLE` | spdMain 바인딩, 버킷 표시 |
| A3 | 행추가 | InsertButton → InsertRow | IsLock=false이고 활성 시트일 때 행 추가, 콤보 설정 | `biz:CommonData.CommonDataList` [code=FCST_TYPE], [code=Measure] | FCST_TYPE·MEASURE 셀 콤보 |
| A4 | 저장 | SaveButton → SaveData | 활성 시트(GetSheetInfo:807) 데이터 저장 → FindData 재조회 | `DM.DMF0045_SAVE_SHIPMENT_REQUEST` → 이어서 A2의 엔드포인트 | DM_PLN_SHIPMENT_REQ / _H INSERT, 재조회 |
| A5 | 편집 | EditButton | `fps != null`일 때 GetSheetInfo(활성 시트) | 없음 | **확인 필요** |
| A6 | Division 변경 | `cboDivision_SelectedIndexChanged` | GetCheckedListValue, InitSpread | `DM.DMF0045_GET_SPREAD_TITLE` | 헤더·컬럼 재구성 |
| A7 | Bucket 변경 | `cboBucketType_SelectedIndexChanged` | `siMain != null`일 때 SetSpreadColumn | 없음 | D_/W_/M_ 표시 전환 |
| A8 | Sum 체크 | `chkSum_CheckedChanged` | `siMain != null`일 때 SetSpreadColumn | 없음 | M_/W_ 표시 전환 |
| A9 | Measure 버튼 | `btnMeasure_Click` | InitSpread | `DM.DMF0045_GET_SPREAD_TITLE` | 헤더 재구성 |
| A10 | Column 버튼(Visible=false) | `btnColumn_Click` | InitSpread | `DM.DMF0045_GET_SPREAD_TITLE` | 헤더 재구성(버튼 비표시) |
| A11 | Project 찾기 | `btnProject_Click` | 선택값 반환 | 확인 필요 | `txtProject.Text = sProjectCode`(2093) |
| A12 | Model 찾기 | `btnItemId_Click` | 선택값 반환 | 확인 필요 | `txtItemId.Text = sItemId`(2116) |
| A13 | End Customer 조건 변경 | `clbCustomer_SelectedIndexChanged` | NowGroupID 읽기(1128) | 확인 필요 | **확인 필요** |
| A14 | Team 조건 변경 | `clbTeam_SelectedIndexChanged` | NowGroupID 읽기(1116/1120) | 확인 필요 | **확인 필요** |
| A15 | 헤더 더블클릭 | `spdMain_CellDoubleClick` | `e.ColumnHeader`일 때 M_ → W_/D_ 토글, W_ → D_ 토글 | 없음 | 컬럼 접기·펼치기 |
| A16 | 셀 콤보 변경 | `spdMain_ComboSelChange` | END_CUSTOMER → FROM_SITE 콤보(UserSiteByEndCustomer[Auth]). FROM_SITE → MEASURE 콤보 | `biz:CommonData.CommonDataList` [code=MktFcstEditMeasure] (+ FROM_SITE용 API 확인 필요) | 같은 행의 콤보 목록 재설정 |
| A17 | 스크롤 상단 변경 | `spdMain_TopChange` | **확인 필요** | 확인 필요 | 확인 필요 |
| A18 | 키 입력 | `spdMain_KeyUp` | **확인 필요** | 확인 필요 | 확인 필요 |
| A19 | 데이터 변경 (dsdmPack/dsdmCell.Changed) | `spdMain_Changed` | DefaultBucketDay 조회 | `biz:CommonData.CommonDataList` [code=DefaultBucketDay] | **확인 필요** |
| A20 | (진입점 미연결) | GetBizTypebyDivision | 정적 분석상 호출 경로 없음 | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` (SP `SCM0001_GET_BIZ_TYPE_BY_DIVISION`) | 현행 화면 동작에 반영되지 않음(확인 필요) |

## 6. 검증·메시지

| 항목 | 사실 | 상태 |
|---|---|---|
| 조회조건 필수 검증 | Fact Pack에 없음 | **확인 필요** |
| 그리드 필수 표시 | 헤더 라벨의 `*`(Division*, FCST Type*, Frorm ( Plant )*, To ( Sales-Site )*, Incoterms*, Trans Mode*, Model*, Project Code*, Measure*, BOD ID*) | 라벨 원문 사실. 저장 시 검증하는지는 **확인 필요** |
| 행추가 차단 | 시트 잠금(IsLock) 또는 비활성 시트이면 동작하지 않음 | 사실(1003). 메시지 표시 여부는 **확인 필요** |
| 메시지 원문 | Fact Pack에 없음 | **확인 필요** |
| 저장 오류 처리 | Fact Pack에 없음 | **확인 필요** |

## 7. 권한(C/R/U/D) 사실

| 구분 | 사실 | 근거 |
|---|---|---|
| R(조회) | FindButton 진입점 존재 | flow.csv |
| C(행추가) | InsertButton 진입점 존재. IsLock=false 조건 | flow.csv, grid_code 1003 |
| U(저장) | SaveButton 진입점 존재 | flow.csv |
| D(삭제) | 버튼·API 모두 Fact Pack에 없음 | **확인 필요** |
| 메뉴 권한 값 | `TB_FX_GroupMenuAuth` 13행. 값은 Fact Pack에 없음 | **확인 필요** |
| 데이터 권한 | Division 목록 = TB_FX_USERGROUPAUTHEXTENTION([code=MyDivision]). FROM_SITE = `UserSiteByEndCustomerAuth` 분기. NowGroupID 참조 | endpoints, grid_code 1158, meta_reads |

## 8. To-Be 전환 메모 (Wijmo·Oracle 관점)

| 항목 | AS-IS 사실 | To-Be 전환 시 바뀌는 점 |
|---|---|---|
| 시트 2개 | FpSpread `AddSheet`로 `Pack Biz`/`Cell Biz` 생성 | 탭 + FlexGrid. 활성 시트명을 SHEET_NAME 파라미터로 전달해야 합니다 |
| 헤더 3행 Span | SetSpreadHeaderSpan(LARGE/SMALL 라벨 + SUM) | FlexGrid columnHeaders 다행 + allowMerging으로 재현해야 합니다 |
| 버킷 컬럼 표시 | 컬럼 Tag 접두어 D_/W_/M_로 Visible 제어 | 컬럼 binding/name 접두어로 visible 제어. DAILY W_ 최종값은 확인 후 결정해야 합니다 |
| 헤더 더블클릭 접기 | CellDoubleClick + `e.ColumnHeader` | FlexGrid hitTest(CellType.ColumnHeader)로 대체해야 합니다 |
| 셀 콤보 연쇄 | SetCellTypeCombo(END_CUSTOMER → FROM_SITE → MEASURE) | 행 단위 DataMap 또는 동적 itemsSource가 필요합니다 |
| Footer 합계 | ColumnFooter + Set_SumValues | FlexGrid columnFooters 집계 |
| 비표시 버튼 | btnColumn Visible=false | TO-BE 필요 여부를 확인해야 합니다 |
| 조회 SP | `DMF0045_GET_SHIPMENT_REQUEST`: #임시테이블 다수, 동적 SQL, STRING_SPLIT, 조회 중 SCM_MST_TITLESET_USER INSERT | Oracle 19c에는 STRING_SPLIT와 #임시테이블이 없으므로 PKG/GTT/분해 함수로 전환해야 합니다. 조회 중 INSERT는 트랜잭션 처리를 확인해야 합니다 |
| 저장 SP | `DMF0045_SAVE_SHIPMENT_REQUEST`: SCM_ARR_SPL_CNT/VAL 배열 분해, 이력·로그 INSERT | 배열 파라미터 전달 방식을 Oracle 방식으로 바꿔야 합니다. 이력(_H)과 로그(PR_SCM_SYS_LOG_BATCH) 동작은 그대로 유지해야 합니다 |
| 타이틀 SP | `DMF0045_GET_SPREAD_TITLE`: SCM_MST_SHEET_COLUMNS + SCM_SYS_CALENDAR_M, STRING_SPLIT | 위와 같이 STRING_SPLIT를 대체해야 합니다 |
| 미연결 SP | `SCM0001_GET_BIZ_TYPE_BY_DIVISION` | 현행 미사용. 이관 여부를 확인해야 합니다 |
| 메타 차이 | SP 결과와 메타의 차이 1054건 | 컬럼을 확정하기 전에 grid_diff.csv와 대조해야 합니다 |

## 9. 미확정

1. 메뉴 위치와 `TB_FX_GroupMenuAuth` 권한 값
2. 조회조건의 행·열 배치 순서, `lblItemType`·layoutControlItem6·layoutControlItem7의 연결 컨트롤, `usrLayoutControl1`의 용도
3. btnMeasure, btnColumn, btnProject, btnItemId의 표시 문구(LayoutControlItem Text 미추출)
4. drpPeriod 라벨과 값 설정 로직
5. clbPlantSite, clbSalesSite, clbCustomer, clbTeam의 데이터 소스와 연쇄 갱신
6. Project / Model 찾기 팝업 화면 ID
7. `spdMain_TopChange`, `spdMain_KeyUp`, `spdMain_Changed`(DefaultBucketDay 사용처), EditButton의 동작
8. MEASURE 콤보 3가지 소스 중 실제 분기, FROM_SITE 콤보 API
9. DAILY일 때 W_ 컬럼의 최종 Visible
10. 컬럼 SORT_ORDER_NO, 셀 타입, 편집 가능 여부, Division 82에서 빠지는 Measure
11. Division 40과 EE 계열에서 화면을 쓸 수 있는지
12. `spdMain_Sheet1`과 런타임 시트의 관계, 시트 선택 규칙(Biz Type)
