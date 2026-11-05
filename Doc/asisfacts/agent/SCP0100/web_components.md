# SCP0100 웹 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑

라벨은 props.csv의 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다. props.csv가 잘려서 라벨을 못 찾은 항목은 **확인 필요**로 적었습니다.

| As-is 컨트롤 | 유형 | 라벨(원문) | LayoutItem | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|
| clbDivision | UsrCheckedList2 | 확인 필요 | 확인 필요 | Wijmo MultiSelect (공용 멀티선택 콤보) | Size(179,21) |
| clbFromSite | UsrCheckedList2 | From Site | layoutControlItem1 | Wijmo MultiSelect | Size(202,21) |
| clbToSite | UsrCheckedList2 | To Site | lblToSite | Wijmo MultiSelect | Size(214,21). 목록은 SCP0100_GET_SITE |
| cboPlanDate | UsrCombo | 확인 필요 (layoutPlanDate 추정) | 확인 필요 | Wijmo ComboBox | SCP0100_GET_PLAN_DATE 결과 |
| cboBucketType | UsrCombo | Bucket | lblBucket | Wijmo ComboBox | MONTHLY / WEEKLY |
| cboPlanType | UsrCombo | Plan-type | PlanType | Wijmo ComboBox | LayoutItem Enabled=false |
| cboGraphType | UsrCombo | Graph | lblGraphType | Wijmo ComboBox | |
| cboDisplay | UsrCombo | Display | layDisplay | Wijmo ComboBox | 분할 비율 전환 |
| cboSearchLevel | UsrCombo | 확인 필요 (lciSearchLevel 추정) | 확인 필요 | Wijmo ComboBox | PRODUCT_LEVEL 표시 제어 |
| cboUnitQty | UsrCombo | 확인 필요 (layUnit_qty 추정) | 확인 필요 | Wijmo ComboBox | |
| rgrpSearchLevel | RadioGroup | 확인 필요 | 확인 필요 | Radio 그룹 (hook #154 v2 방식) | Size(199,25) |
| dCalendar | UsrDateRangePicker3 | 확인 필요 (layPeriod 추정) | 확인 필요 | 기간 선택 (공용 DateRange) | Size(230,22) |
| txtItemId | UsrTextBox | Model / Nick Name | layModel | Input + 팝업 버튼 | |
| btnItemId | UsrButton | - | layoutbtnitem | 팝업 호출 버튼 | 결과를 txtItemId에 세팅 |
| txtProject | UsrTextBox | Project | lblCellGroup | Input + 팝업 버튼 | |
| btnProject | UsrButton | - | layoutControlItem2 | 팝업 호출 버튼 | 결과를 txtProject에 세팅 |
| txtCellGroup | UsrTextBox | Cell Group | lblCellGroup1 | Input | Size(111,25) |
| btnMeasure | UsrButton | 확인 필요 (layMeasure 추정) | 확인 필요 | 버튼 → 헤더 재구성 | |
| btnColumn | UsrButton | 확인 필요 (layoutBtnColumn 추정) | 확인 필요 | 버튼 → 헤더 재구성 | |
| chkCellQty | UsrCheckBox | Cell Qty | 확인 필요 | CheckBox | Checked=true, Visible=false |
| chkAS | UsrCheckBox | A/S | layAS 추정 | CheckBox | Visible=false |
| usrButton1 | UsrButton | 확인 필요 | - | 확인 필요 | Size(75,23), parent 없음 |
| chartMain | ChartControl | - | - | Wijmo FlexChart | splitContainer1.Panel1 |
| spdSearchLevel | FpSpread | - | - | Wijmo FlexGrid (SEARCH_LEVEL) | Panel2 |
| spdDetail | FpSpread | - | - | Wijmo FlexGrid (REPORT) | Panel2 |
| spdSearchLevelDetail | FpSpread | - | - | Wijmo FlexGrid (SEARCH_LEVEL_DETAIL) | Panel2 |
| layCategoryCC, layoutControlItem3, layoutControlItem4 | LayoutControlItem | 확인 필요 | - | 확인 필요 | 연결 컨트롤 미추출 |

## 2. 화면 배치

| 영역 | 근거 | 내용 |
|---|---|---|
| 조회조건 | usrConditionPanel1 Dock=Top, Size(1784,102), UsrPanelType=HidePanel | 상단 고정 조건 패널(접기 가능 패널로 추정 — 확인 필요) |
| 본문 | splitContainer1 (Panel1 = chartMain, Panel2 = Spread 3개) | 차트와 그리드 분할 |
| 분할 방향 | Orientation 값이 props.csv 잘린 부분에 있음 | **확인 필요** (상/하 또는 좌/우) |
| 분할 비율 | `CboDisplay_SelectedIndexChanged`: SplitterDistance 0 / 750 / 270 | 0 = 차트 영역 0(그리드 위주), 750 / 270 = 차트 영역 크기. 각 값과 cboDisplay 항목의 대응, 전체 Size는 **확인 필요** |
| 그리드 전환 | `VisibleSheet` | Panel2에서 시트 1개만 보이게 전환(detail ↔ search level ↔ search level detail) |

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

전 Division(40 / 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC / 82 / EE / EE_HD / EE_HG / EE_HM / EE_ST / EE_UC)이 같습니다. Division별 표시 차이는 **없음**입니다.

### 3-1. REPORT (spdDetail) — 최종 11 (?3)

| 컬럼 | 라벨 | 출처 | 표시 |
|---|---|---|---|
| CELL_CF | Cell Qty | META | 기본 |
| CELL_GROUP | Cell Group | META | 기본 |
| DIVISION_ID | Div | META | 기본 |
| FROM_SITE | From Site | META | 기본 |
| TO_SITE | To Site | META | 기본 |
| INCOTERMS | INCOTERMS | META | 기본 |
| ITEM_ID | Model | META | 기본 |
| MEASURE_GROUP | Measure Group | META | 기본 |
| MEASURE_NAME | Measure Name | META | 기본 |
| MEASURE_UI | Measure | META | 숨김 |
| OPERATION_ID | Operation | META | 기본 |
| VARIOUS_KEY | Trans Mode or Line or Project | META | 기본 |
| PRODUCT_LEVEL1 | Product Level1 | META + 코드 | 기본 → SetLayout 런타임(?) |
| PRODUCT_LEVEL2 | Product Level2 | META + 코드 | 기본 → SetLayout 런타임(?) |
| PRODUCT_LEVEL3 | Product Level3 | META + 코드 | 기본 → SetLayout 런타임(?) |
| D0, D1 | - | CODE_ONLY_CHANGE | → 숨김 (SetVisibleColumnCycle) |
| (기간 컬럼 M_* / W_* / *B_*) | SP 결과 COLUMN_LABEL_NAME | DB루프 (SCP0100_GET_SHEET_CALENDAR_3SPAN) | Bucket에 따라 M_ 또는 W_만 표시. B_ 포함 열은 숨김 |

### 3-2. SEARCH_LEVEL (spdSearchLevel) — 최종 5 (?3)

| 컬럼 | 라벨 | 출처 | 표시 |
|---|---|---|---|
| CELL_GROUP | Cell Group | META | 기본 |
| DIVISION_ID | Div | META | 기본 |
| MEASURE_GROUP | Measure Group | META | 기본 |
| MEASURE_NAME | Measure Name | META | 기본 |
| OPERATION_GROUP | Operation Group | META | 기본 |
| MEASURE_UI | Measure | META | 숨김 |
| PRODUCT_LEVEL1~3 | Product Level1~3 | META + 코드 | 기본 → SetLayout 런타임(?) |
| D0, D1 | - | CODE_ONLY_CHANGE | → 숨김 |
| (기간 컬럼) | SP 결과 | DB루프 | REPORT와 같은 규칙 |

### 3-3. SEARCH_LEVEL_DETAIL (spdSearchLevelDetail) — 최종 5 (?3)

컬럼과 표시 규칙은 SEARCH_LEVEL과 같습니다: CELL_GROUP, DIVISION_ID, MEASURE_GROUP, MEASURE_NAME, OPERATION_GROUP = 기본 / MEASURE_UI = 숨김 / PRODUCT_LEVEL1~3 = 런타임 / D0·D1 = 숨김 / 기간 컬럼 = DB 루프.

### 3-4. 공통 코드 규칙 (세 시트 공통)

- 3단 헤더: 0행 LARGE_CLASS_LABEL_NAME 병합, 1행 SMALL_CLASS_LABEL_NAME 병합, 2행 "Qty"
- Num 컬럼 폭 70
- M_ 컬럼 중 계획 시작월(`_plan_start_yyyymm`) 포함 열 = 글자색 Red
- W_ 컬럼 중 라벨에 "A" 또는 "B" 포함 열 = 글자색 Blue
- PRODUCT_LEVEL 표시(`!_is_detail`일 때만)

| cboSearchLevel | L1 | L2 | L3 |
|---|---|---|---|
| 1 | O | O | X |
| 2 | O | X | X |
| 3 | X | O | X |
| 4 | O | O | O |
| case 미추출 | X | X | X |

- 메시지 차원 메타: SCM_MST_SHEET_MEASURE 시트 `Global PSI New` 35행(전 Division 35/0). 시트와의 연결 방식은 **확인 필요**

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 설명 |
|---|---|---|
| REPORT | META+코드연결 | 메타 시트를 코드가 AddSheet / ChangeSheet로 사용 |
| SEARCH_LEVEL | META+코드연결 | 같음 |
| SEARCH_LEVEL_DETAIL | META+코드연결 | 같음 |

- 시트 사이 전환은 `VisibleSheet`가 `_is_detail` 등 상태에 따라 수행합니다. 전환 조건값은 **확인 필요**입니다.
- 그리드 행 ↔ 차트 연동 여부는 사실 묶음에 없어 **확인 필요**입니다.
