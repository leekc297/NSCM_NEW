# SCP0096 — Web 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

| AS-IS 컨트롤 | 유형 | 라벨(원문) | LayoutItem | Size | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Division*` | layoutControlItem4 (236×25) | 181×20 | Wijmo ComboBox (필수) | 변경 시 CboDivision_SelectedIndexChanged |
| clbPlantSite | UsrCheckedList | `Plant Site` | layoutControlItem7 (226×25) | 165×21 | Wijmo MultiSelect | GetCheckedListValue(CODE) |
| dCalendar | UsrDateRangePicker3 | `Period*` | layoutControlItem2 (260×25) | 210×22 | 기간 선택(Date Range, 필수) | |
| cboDayWeek | UsrCombo | `Day of the week` | layoutControlItem3 (236×25) | 134×20 | Wijmo ComboBox 또는 MultiSelect (단일/다중 확인 필요) | 672에서 GetCheckedListValue 사용 |
| cboInputValue | UsrCombo | `Input Value` | layoutControlItem1 (226×25) | 124×20 | Wijmo ComboBox | cboDayWeek 변경 시 Enabled false(675)/true(679) |
| btnInput | UsrButton | `Input` (Text) | layoutControlItem10 (81×25) | 77×21 | Button | BtnInput_Click |
| chkSum | UsrCheckBox | `Sum` (Text) | layoutSum (50×25) | 46×20 | CheckBox | **Visible=false**(DS:346), Checked=false(121) |
| usrButton1 | UsrButton | (Text 없음) | – | 75×23 | 확인 필요 | parent 없음 |
| usrConditionPanel1 | UsrConditionPanel | – | – | 1192×96, Dock Top, HidePanel | 조회조건 영역 | |
| usrLayoutControl2 | UsrLayoutControl | – | – | 1192×96, Dock Fill | 조회조건 레이아웃 | |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | – | – | 1192×553, Dock Fill | Wijmo FlexGrid | 시트 `Shipment Working Day OSP` |
| emptySpaceItem1~6·9·10 | EmptySpaceItem | – | – | – | 여백(배치용) | 8개 |

## 2. 화면 배치

- props.csv에 SplitContainer는 **없습니다**. 분할 비율은 Dock과 Size 기준입니다.
- 상단: `usrConditionPanel1` Dock=Top, 높이 96
- 하단: `spdMain` Dock=Fill, 높이 553
- 상/하 비율: 96 : 553 ≈ **14.8% : 85.2%** (폭 1192 공통)
- 좌/우 분할: 없음
- 조회조건 행 구성: LayoutItem Size 높이 25~26으로 보아 2행 이상입니다. 정확한 행·열 위치(Location)는 Fact Pack에 없어 확인 필요입니다.

## 3. 시트별 Grid 컬럼 — `Shipment Working Day OSP`

연결 규칙: **META+코드연결** (메타 시트를 코드가 AddSheet/ChangeSheet로 사용). 헤더는 3행입니다.

### 3-1. 메타 고정 컬럼 (grid_effective 기준)

| 순서 | COLUMN_NAME | 라벨 | 출처 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| (메타 정렬 확인 필요) | DIVISION_ID | Division | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |
| | LAST_INPUT_DATE | Last Input Date | META | 기본 | … 전 division 기본 | | | | | | | | | | | | |
| | MEASURE | Measure | META | 기본 | … 전 division 기본 | | | | | | | | | | | | |
| | PLANT_SITE_ID | Plant Site ID | META | 기본 | … 전 division 기본 | | | | | | | | | | | | |
| | PLANT_SITE_NAME | Plant Site | META | 기본 | … 전 division 기본 | | | | | | | | | | | | |
| | WORKING_TIME_DEFAULT | Working Time Default | META | 기본 | … 전 division 기본 | | | | | | | | | | | | |

> 14개 division 모두 6개 컬럼이 "기본"이며 division별 표시 차이는 없습니다. 메타의 SORT_ORDER_NO, 폭, 편집 여부 값은 Fact Pack에 없어 확인 필요입니다.

### 3-2. 코드 생성 날짜 컬럼 (DB 루프, MEASURE 다음 열부터)

| 조건 | API | 폭 | 표시 | 셀 | 정렬 | 스타일 |
|---|---|---:|---|---|---|---|
| COLUMN_NAME에 `"B_"` 포함(IndexOf > 0) | AddTextColumn | 0 | 숨김 | Text | – | – |
| 그 외 | AddComboColumn | 50 | 표시 | Combo (`dtValidYN` = YesOrNo) | Center/Center | DAY_CODE SAT → 파랑, SUN → 빨강 |

- 헤더 라벨은 COLUMN_LABEL_NAME이고, 원천은 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과입니다.
- 헤더 3단 Span: 0행 LARGE_CLASS_LABEL_NAME, 1행 SMALL_CLASS_LABEL_NAME, 2행 컬럼 라벨. 각 Large/Small 그룹 시작 열에 `"SUM"` 헤더가 있습니다(높이 20, 222행만 30).

### 3-3. 코드 표시 토글 (SetSpreadColumn, Tag 접두어)

| Tag 접두어 | Visible | 근거 |
|---|---|---|
| `D_` | true | 350 |
| `M_` | chkSum.Checked | 355 |
| `W_` | 350에서 true → 355에서 chkSum.Checked (순차 실행 시 최종 chkSum.Checked, 확인 필요) | 350, 355 |

- chkSum이 Visible=false이고 초기 Checked=false이므로, 사용자가 토글할 수 없어 `M_`/`W_` 컬럼은 숨겨진 상태로 남을 것으로 보입니다 → 실행 확인 필요.
- Designer 헤더 스타일(628~631): HorizontalAlignment/VerticalAlignment General, NoteIndicatorColor Red, Parent `ColumnHeaderDefaultEnhanced`.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 메타 행 | 코드 사용 |
|---|---|---:|---|
| Shipment Working Day OSP | META+코드연결 | 6 (SCM_MST_SHEET_COLUMNS) | AddSheet(142) → SetSheetHeaderColumn(156) → InitSpreadDateColumn(159) → SetSpreadColumn(160) |

- 시트는 1개뿐이고, 마스터-디테일 같은 시트 간 연결은 없습니다.
- 실제 SP 실행 결과와 맞는 시트가 없어(grid 단계 미실행) 실데이터 컬럼 대조는 확인 필요입니다.
