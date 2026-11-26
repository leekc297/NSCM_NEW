# DMF0045 화면 컴포넌트 매핑 (AS-IS → React/Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

라벨은 props.csv의 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다.

| AS-IS 컨트롤 | 유형 | 라벨(원문) | 라벨 출처 | 속성(원문) | TO-BE 컴포넌트 후보 |
|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Division` | clbDivision.Text (DS:936) | Size 257×20 | 단일 선택 콤보(Wijmo ComboBox 계열) |
| cboBucketType | UsrCombo | `Bucket` | lblBucket.Text (DS:948) | Size 256×20 | 단일 선택 콤보 |
| drpPeriod | UsrDateRangePicker | 확인 필요 (LayoutControlItem 이름은 `Period`, Text 미추출) | — | **Enabled=false**(DS:515), Size 180×20 | 기간(From~To) 입력, 비활성 |
| clbPlantSite | UsrCheckedList | `Plant Site` | lblPlantSite.Text (DS:901) | Size 242×21 | 다중 선택 체크리스트 콤보(MultiSelect) |
| clbSalesSite | UsrCheckedList | `Sales Site` | lblSalesSite.Text (DS:824) | Size 242×21 | 다중 선택 |
| clbCustomer | UsrCheckedList | `End Customer` | lblCustomer.Text (DS:798) | Size 247×21 | 다중 선택 |
| clbTeam | UsrCheckedList | `Team` | lblTeam.Text (DS:786) | Size 306×21 | 다중 선택 |
| txtProject | UsrMultiLineEditor | `Project` | lblProject.Text (DS:856) | Size 255×21 | 멀티라인 입력 + 찾기 버튼 |
| btnProject | UsrButton | 확인 필요 | layoutControlItem3 | Size 39×21 | txtProject 찾기 버튼 |
| txtItemId | UsrMultiLineEditor | `Model` | lblModel.Text (DS:844) | Size 255×21 | 멀티라인 입력 + 찾기 버튼 |
| btnItemId | UsrButton | 확인 필요 | layoutControlItem1 | Size 37×21 | txtItemId 찾기 버튼 |
| chkSum | UsrCheckBox | `Sum` | chkSum.Text (DS:278) | Size 70×21 | 체크박스(합계 컬럼 표시) |
| btnMeasure | UsrButton | 확인 필요 | layoutControlItem4 | Size 34×21 | Measure 설정 버튼 |
| btnColumn | UsrButton | 확인 필요 | layoutControlItem2 | **Visible=false**(DS:356), Size 40×21 | 미표시 버튼(TO-BE 필요 여부는 확인 필요) |
| (연결 컨트롤 확인 필요) | LayoutControlItem `lblItemType` | `Item Type` | DS:703 | Size 297×24 | Control 지정이 추출되지 않음 → 확인 필요 |
| layoutControlItem6 / layoutControlItem7 | LayoutControlItem | 확인 필요 | — | 128×25 / 146×25 | 연결 컨트롤 확인 필요 |
| spdMain (+spdMain_Sheet1) | FpSpread | — | — | Dock Fill, Size 1284×479 | Wijmo FlexGrid(시트 2개 → 탭 + Grid) |
| usrConditionPanel1 | UsrConditionPanel | — | — | Dock Top, Size 1284×95, UsrPanelType=HidePanel | 조회조건 패널(접기 가능) |

## 2. 화면 배치

- props.csv에는 SplitContainer가 **없습니다**(Orientation·SplitterDistance 없음).
- 배치는 Dock 방식입니다.

| 영역 | 컨트롤 | Dock | Size | 높이 비율(실측값 기반 계산) |
|---|---|---|---|---|
| 상단 조회조건 | usrConditionPanel1 → usrLayoutControl2 | Top | 1284×95 | 95 / (95+479) = 약 16.6% |
| 하단 Grid | spdMain | Fill | 1284×479 | 479 / 574 = 약 83.4% |

- 좌우 분할은 없습니다.
- 조회조건은 LayoutControl 기반으로 3행입니다(layoutControlGroup2 1284×95, emptySpaceItem8 높이 75 = 25×3행으로 판단). 행·열 순서 원문은 **확인 필요**.
- `usrLayoutControl1`(657×184)은 Dock Fill로 선언되어 있지만 부모가 추출되지 않았습니다. 용도는 **확인 필요**.

## 3. 시트별 Grid 컬럼

두 시트는 `CreateSpread`에서 `AddSheet(..., 헤더 3행, 1, 40)`으로 만들고, 컬럼은 `CreateSheetHeaderColumn`(메타 `SCM_MST_SHEET_COLUMNS`, SP `DMF0045_GET_SPREAD_TITLE`)으로 생성합니다.

### 3-1. `Cell Biz` (grid_effective 기준, Division 81 / 81_UC / 82 동일)

| # | COLUMN | 라벨(원문) | 상태 | 비고 |
|---:|---|---|---|---|
| 1 | DIVISION_ID | Division* | 필수 | |
| 2 | TEAM_NAME_KO | Team | 필수 | |
| 3 | END_CUSTOMER | End Customer | 필수 | ComboSelChange 시 FROM_SITE 콤보 재설정(1158) |
| 4 | LAST_UPDATED_BY | Requestor | 필수 | 헤더 Span 기준 컬럼(`DefColumns.Requestor`) |
| 5 | FCST_TYPE | FCST Type* | 기본 | 행추가 콤보 [code=FCST_TYPE](1003) |
| 6 | FROM_SITE | Frorm ( Plant )* | 기본 | 원문 오탈자 'Frorm' 유지. 변경 시 MEASURE 콤보 재설정(1195) |
| 7 | TO_SITE | To ( Sales-Site )* | 기본 | |
| 8 | INCOTERMS | Incoterms* | 기본 | |
| 9 | TR_MODE | Trans Mode* | 기본 | |
| 10 | ITEM_ID | Model* | 기본 | |
| 11 | NICK_NAME | Nick Name | 기본 | |
| 12 | PROJECT_CODE | Project Code* | 기본 | |
| 13 | MEASURE | Measure* | 기본 | 행추가·콤보 변경 시 콤보 재설정(1005/1195) |
| — | BOD_ID | BOD ID* | 숨김 | |
| — | MEASURE_COLOR | MEASUR_COLOR | 숨김 | 원문 라벨 그대로 |
| — | SHIP_FROZEN | DMF0045 | 숨김 | 원문 라벨 그대로 |

- 표의 순서는 grid_effective 나열 순서가 아닙니다. 실제 SORT_ORDER_NO 순서는 **확인 필요**(dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv).
- 메타 Measure 행: Division 81 = 11, 81_UC = 11, 82 = 10.

### 3-2. `Pack Biz` (grid_effective 기준, Division 81 / 81_UC / 82 동일)

- 고정 컬럼 16개(표시 13, 숨김 3)는 `Cell Biz`와 같습니다. COLUMN, 라벨, 필수/기본/숨김 구분이 모두 일치합니다.
- 메타 Measure 행: Division 81 = 9, 81_UC = 9, 82 = 8.

### 3-3. 코드 하드코딩·동적 컬럼 (두 시트 공통)

| 구분 | 내용 | 근거 |
|---|---|---|
| 날짜 버킷 컬럼 | SP `DMF0045_GET_SPREAD_TITLE`(SCM_SYS_CALENDAR_M)가 생성. 태그 접두어 `D_`(일)·`W_`(주)·`M_`(월) | SetSpreadColumn 2152~2184 |
| `B_` 포함 컬럼 | 숨김 | SetSpreadHeaderSpan 335 |
| 헤더 3행 | 0행 = 대분류(LARGE_LABEL) Span + `SUM`, 1행 = 소분류(SMALL_LABEL) Span, 2행 = `SUM` | 327~381 |
| 주말 색상 | DAY_CODE SAT = Blue, SUN = Red(헤더 ForeColor) | 346 |
| Bucket별 표시 | DAILY: D_·W_ 표시, M_·W_ = Sum 체크 / WEEKLY: D_ 숨김, W_ 표시, M_ = Sum 체크 / MONTHLY: D_·W_ 숨김, M_ 표시 | 2152~2184 |
| 헤더 더블클릭 | M_ 헤더 → W_/D_ 토글, W_ 헤더 → D_ 토글 | 1211/1217/1233 |
| Footer 합계 | ColumnFooter 표시 | 285 |

- Division 40과 EE 계열에는 메타가 없습니다(표시 컬럼 `·`).
- 메타와 SP 결과의 차이 1054건(grid_diff.csv)은 TO-BE 컬럼 확정 전에 대조가 필요합니다.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 설명 |
|---|---|---|
| `Cell Biz` | META+코드연결 | 코드가 `AddSheet`/`ChangeSheet`로 메타 시트명을 그대로 사용 |
| `Pack Biz` | META+코드연결 | 위와 같음. 초기 활성 시트(265 `ChangeSheet` Pack Biz) |

- 두 시트 사이의 데이터 연계(마스터-디테일)는 Fact Pack에 없습니다.
- 시트 선택 기준(Division의 Biz Type에 따라 Cell/Pack을 고르는지 등)은 **확인 필요**. 미연결 메서드 `GetBizTypebyDivision`이 관련 있을 수 있으나 정적 분석으로는 확정할 수 없습니다.
- 데이터소스: `dsdmPack`, `dsdmCell` 각각의 Changed 이벤트가 `spdMain_Changed`에 연결되어 있습니다(InitEvent 391/394).
