# SCP0096 — Web 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

| As-is 컨트롤 | 유형 | 라벨 (원문) | 크기 | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | — | 1192×96, Dock Top, HidePanel | 조회조건 패널(접힘 지원) | |
| usrLayoutControl2 | UsrLayoutControl | — | 1192×96, Dock Fill | 조회조건 레이아웃 그리드 | |
| cboDivision | UsrCombo | Division* (layoutControlItem4) | 181×20 | 단일 선택 ComboBox | 필수(*) |
| clbPlantSite | UsrCheckedList | Plant Site (layoutControlItem7) | 165×21 | MultiSelect(CheckedList) | |
| dCalendar | UsrDateRangePicker3 | Period* (layoutControlItem2) | 210×22 | 기간(From~To) DateRangePicker | 필수(*) |
| cboDayWeek | UsrCombo | Day of the week (layoutControlItem3) | 134×20 | ComboBox | 원천은 dtDayWeek(LookupCommon) 추정 — 확인 필요 |
| cboInputValue | UsrCombo | Input Value (layoutControlItem1) | 124×20 | ComboBox | cboDayWeek 선택에 따라 Enabled 전환(:675/:679) |
| btnInput | UsrButton | Input (layoutControlItem10) | 77×21 | Button | 그리드 일괄 입력 |
| chkSum | UsrCheckBox | Sum (layoutSum) | 46×20, Visible=false, Checked=false | CheckBox | Designer 상 숨김 — 런타임 표시 여부 확인 필요 |
| usrButton1 | UsrButton | — | 75×23, parent 없음 | 확인 필요 | 용도 불명 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | — | 1192×553, Dock Fill | Wijmo FlexGrid (다단 헤더 3행) | |
| emptySpaceItem1~6, 9, 10 | EmptySpaceItem | — | — | 레이아웃 여백(구현 불필요) | |
| layoutControlGroup2 | LayoutControlGroup | — | 1192×96 | 레이아웃 그룹 | |

## 2. 화면 배치

- props.csv 에는 **SplitContainer 가 없습니다**(Orientation·SplitterDistance 없음).
- 구성: 상단 `usrConditionPanel1`(Dock Top, 높이 96) / 하단 `spdMain`(Dock Fill, 높이 553).
- 상/하 비율: 96 : 553 ≈ **14.8% : 85.2%** (Designer 기준 크기, 폭 1192).
- 조회조건 행 구성: layoutControlItem 높이가 25/26 이고 그룹 높이가 96 이므로 여러 행으로 보입니다. 다만 Location 이 없어 **각 항목의 행·열 위치는 확인 필요**합니다.

## 3. 시트별 Grid 컬럼 — `Shipment Working Day OSP`

연결 규칙: **META+코드연결** (CreateSpread:142 AddSheet → InitSpread:156 SetSheetHeaderColumn)

### 3-1. 메타 컬럼 (grid_effective 기준)

| 컬럼 | 라벨 | 출처 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| DIVISION_ID | Division | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |
| PLANT_SITE_ID | Plant Site ID | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |
| PLANT_SITE_NAME | Plant Site | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |
| MEASURE | Measure | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |
| WORKING_TIME_DEFAULT | Working Time Default | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |
| LAST_INPUT_DATE | Last Input Date | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |

- 최종 표시 컬럼 수: 전 division **6** — division별 차이 없음.
- 순서(SORT_ORDER_NO), 너비, 편집 여부(CELL_CONTROL_OBJECT_TYPE_CODE), 고정(FIXED_FLAG)은 `dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv` 확인 필요.

### 3-2. 코드 동적 컬럼 (DB 루프 — SCP0009 결과)

| 조건 | 생성 | 너비 | 표시 | 셀 | 서식 |
|---|---|---:|---|---|---|
| COLUMN_NAME 에 `B_` 포함(index>0) | AddTextColumn | 0 | 숨김 | 텍스트 | — |
| 그 외 | AddComboColumn | 50 | 표시 | YesOrNo 콤보(dtValidYN) | 가운데 정렬, SAT=파랑·SUN=빨강 |

- 삽입 위치: MEASURE 컬럼 다음(`GetColumnIndex(MEASURE)+1`).
- 헤더 3행: 0행 = LARGE_CLASS_LABEL_NAME 병합, 1행 = SMALL_CLASS_LABEL_NAME 병합, "SUM" 헤더(1~2행 / 2행)
- 태그별 표시: `D_`·`W_` → 표시, `M_`·`W_` → `chkSum.Checked` 일 때만 표시 (W_ 최종 결과는 확인 필요)

## 4. 시트 연결 규칙

- 시트는 1개(`Shipment Working Day OSP`)이고 시트 간 연결(마스터-디테일)은 없습니다.
- `SpdMain_CellDoubleClick` 의 동작(팝업/디테일 여부)은 확인 필요합니다.
