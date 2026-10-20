# SCP0100 Web 컴포넌트 매핑 (React + Wijmo)

## 1. 조회조건 컨트롤 → 컴포넌트 매핑

라벨은 props.csv의 `LayoutControlItem.Text` 또는 컨트롤 `Text` 원문입니다.

| AS-IS 컨트롤 | 유형 | LayoutItem | 라벨 원문 | 크기 | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|---|
| txtItemId | UsrTextBox | layModel | `Model / Nick Name` | 150×25 | 텍스트 입력 + 검색 버튼 | btnItemId 팝업이 값을 채움(:1947) |
| btnItemId | UsrButton | layoutbtnitem | (Text `layoutControlItem3`, 기본 이름) | 39×25 | 팝업 버튼 | BtnItemId_Click |
| clbFromSite | UsrCheckedList2 | layoutControlItem1 | `From Site` | 202×21 | 멀티 선택 콤보(Wijmo MultiSelect) | getFromSite:306 |
| clbToSite | UsrCheckedList2 | lblToSite | `To Site` | 214×21 | 멀티 선택 콤보 | getToSite:325, 목록은 SCP0100_GET_SITE |
| txtCellGroup | UsrTextBox | lblCellGroup1 | `Cell Group` | 111×25 | 텍스트 입력 | — |
| txtProject | UsrTextBox | lblCellGroup | `Project` | 150×26 | 텍스트 입력 + 검색 버튼 | btnProject 팝업이 값을 채움(:1981) |
| btnProject | UsrButton | layoutControlItem2 | (Text 없음) | 39×25 | 팝업 버튼 | BtnProject_Click |
| cboBucketType | UsrCombo | lblBucket | `Bucket` | 70×20 | 단일 콤보(Wijmo ComboBox) | MONTHLY/WEEKLY 컬럼 전환 |
| cboPlanType | UsrCombo | PlanType | `Plan-type` | 70×20 | 단일 콤보 | LayoutItem Enabled=false |
| cboDisplay | UsrCombo | layDisplay | `Display` | 60×20 | 단일 콤보 | 차트/그리드 분할 변경 |
| cboGraphType | UsrCombo | lblGraphType | `Graph` | 60×20 | 단일 콤보 | 차트 유형 연동(확인 필요) |
| cboPlanDate | UsrCombo | 확인 필요(`layoutPlanDate` 추정) | 확인 필요 | 144×20 | 단일 콤보 | 목록은 SCP0100_GET_PLAN_DATE |
| dCalendar | UsrDateRangePicker3 | 확인 필요(`layPeriod` 추정) | 확인 필요 | 230×22 | 기간(From~To) 피커 | ValueChanged → 헤더 재구성 |
| btnMeasure | UsrButton | 확인 필요(`layMeasure` 추정) | 확인 필요 | 30×25 | 메저 선택 버튼 | btnMeasure_Click → InitSpread |
| btnColumn | UsrButton | 확인 필요(`layoutBtnColumn` 추정) | 확인 필요 | 30×25 | 컬럼 선택 버튼 | BtnColumn_Click → InitSpread |
| cboUnitQty | UsrCombo | 확인 필요(`layUnit_qty` 추정) | 확인 필요 | 100×20 | 단일 콤보 | — |
| cboSearchLevel | UsrCombo | 확인 필요(`lciSearchLevel` 추정) | 확인 필요 | 120×20 | 단일 콤보 | PRODUCT_LEVEL1~3 표시 제어. lciSearchLevel.Enabled = !_is_detail |
| rgrpSearchLevel | RadioGroup | 확인 필요 | 확인 필요 | 199×25 | 라디오 그룹 | 시트 전환·헤더 재구성 |
| clbDivision | UsrCheckedList2 | 확인 필요 | 확인 필요 | 179×21 | 멀티 선택 콤보 | getDivision:466 |
| chkCellQty | UsrCheckBox | — | `Cell Qty` | 80×26 | 체크박스 | Checked=true, **Visible=false** |
| chkAS | UsrCheckBox | 확인 필요(`layAS` 추정) | `A/S` | 80×25 | 체크박스 | **Visible=false** |
| usrButton1 | UsrButton | — | — | 75×23 | (미사용 후보) | parent 없음 |

> 컨트롤 이름이 비슷하다는 이유로 "추정"이라고 붙인 매핑은 모두 확인이 필요합니다. 근거가 되는 props.csv 뒷부분이 잘렸습니다. 대상은 layoutControlItem3, layoutControlItem4, layCategoryCC입니다.

## 2. 화면 배치

| 영역 | AS-IS | 사실 |
|---|---|---|
| 조회조건 패널 | usrConditionPanel1 → usrLayoutControl2 → layoutControlGroup2 | Dock=Top, Size 1784×102, UsrPanelType=HidePanel(접기 가능) |
| 본문 | splitContainer1 (parent=this) | Panel1 = `chartMain`(ChartControl), Panel2 = `spdSearchLevel` / `spdDetail` / `spdSearchLevelDetail` |
| 분할 방향(Orientation) | 확인 필요 | props.csv 해당 행이 잘렸습니다 |
| 초기 SplitterDistance / Size | 확인 필요 | 위와 같음 |
| 런타임 분할 | CboDisplay_SelectedIndexChanged | SplitterDistance = 0(:1833), 750(:1841), 270(:1849) |

- SplitterDistance=0이면 Panel1(차트)이 접히고 그리드만 보이는 구성으로 해석됩니다.
- 750과 270을 분할 비율로 바꾸려면 splitContainer1 전체 크기와 Orientation이 필요합니다. **확인 필요**
- TO-BE 후보: 상/하(또는 좌/우) Splitter 안에 Chart(Wijmo FlexChart)와 FlexGrid를 둡니다. Display 콤보 값에 따라 분할 위치를 0 / 750 / 270 px로 바꿉니다.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

공통 사항은 다음과 같습니다.
- 헤더는 3행입니다(SetSheetHeaderColumn(_SI, 3)).
- 메타 고정 컬럼 뒤에 SCP0100_GET_SHEET_CALENDAR_3SPAN 결과로 기간 컬럼이 DB 루프로 추가됩니다.
- **division별 표시 차이는 없습니다.** 14개 division이 모두 같습니다.

### 3-1. `REPORT` (spdDetail) — 연결 규칙: META+코드연결

| 컬럼 | 라벨 | 출처 | 표시 |
|---|---|---|---|
| DIVISION_ID | Div | META | 기본 |
| ITEM_ID | Model | META | 기본 |
| FROM_SITE | From Site | META | 기본 |
| TO_SITE | To Site | META | 기본 |
| INCOTERMS | INCOTERMS | META | 기본 |
| OPERATION_ID | Operation | META | 기본 |
| VARIOUS_KEY | Trans Mode or Line or Project | META | 기본 |
| CELL_GROUP | Cell Group | META | 기본 |
| CELL_CF | Cell Qty | META | 기본 |
| MEASURE_GROUP | Measure Group | META | 기본 |
| MEASURE_NAME | Measure Name | META | 기본 |
| MEASURE_UI | Measure | META | 숨김 |
| PRODUCT_LEVEL1 | Product Level1 | META + 코드 | 기본 → SetLayout 동적(?) |
| PRODUCT_LEVEL2 | Product Level2 | META + 코드 | 기본 → SetLayout 동적(?) |
| PRODUCT_LEVEL3 | Product Level3 | META + 코드 | 기본 → SetLayout 동적(?) |
| D0, D1 | (공란) | CODE_ONLY_CHANGE | → 숨김 (SetVisibleColumnCycle) |

- 최종 표시는 **11 (?3)** 입니다. 메타 순서(SORT_ORDER_NO 등)는 확인 필요입니다.

### 3-2. `SEARCH_LEVEL` (spdSearchLevel) — META+코드연결

| 컬럼 | 라벨 | 표시 |
|---|---|---|
| DIVISION_ID | Div | 기본 |
| OPERATION_GROUP | Operation Group | 기본 |
| CELL_GROUP | Cell Group | 기본 |
| MEASURE_GROUP | Measure Group | 기본 |
| MEASURE_NAME | Measure Name | 기본 |
| MEASURE_UI | Measure | 숨김 |
| PRODUCT_LEVEL1~3 | Product Level1~3 | 기본 → SetLayout 동적(?) |
| D0, D1 | (공란) | → 숨김 |

- 최종 표시는 **5 (?3)** 입니다.

### 3-3. `SEARCH_LEVEL_DETAIL` (spdSearchLevelDetail) — META+코드연결

컬럼 구성은 SEARCH_LEVEL과 같습니다. DIVISION_ID, OPERATION_GROUP, CELL_GROUP, MEASURE_GROUP, MEASURE_NAME, MEASURE_UI(숨김), PRODUCT_LEVEL1~3, D0/D1(숨김)입니다.
- 최종 표시는 **5 (?3)** 입니다.

### 3-4. 기간 컬럼 (3개 시트 공통, InitSpreadDateColumn)

| 규칙 | 내용 |
|---|---|
| 원천 | SCP0100_GET_SHEET_CALENDAR_3SPAN 결과 행 (COLUMN_NAME, COLUMN_LABEL_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME) |
| `B_` 포함 컬럼 | 텍스트 컬럼, 폭 0, 숨김 |
| 그 외 | 숫자 컬럼, 폭 70, 표시 |
| 헤더 0행 | LARGE_CLASS_LABEL_NAME 병합 |
| 헤더 1행 | SMALL_CLASS_LABEL_NAME 병합, 일부 "Qty" |
| 헤더 2행 | "Qty" |
| 글자색 | `M_` + 계획시작월(_plan_start_yyyymm) = 빨강 / `W_` + 라벨 A·B = 파랑 |
| Bucket 전환 | MONTHLY → `M_*`만 표시, WEEKLY → `W_*`만 표시 (SetSpreadColumn) |

- TO-BE 후보: Wijmo FlexGrid `columnHeaders`에 3행 병합(allowMerging)을 쓰고, 동적 컬럼으로 생성합니다.

### 3-5. 메저

- SCM_MST_SHEET_MEASURE에 `Global PSI New` 35행이 있습니다(모든 division 35/0).
- 메저 행의 내역은 dbmeta CSV 참조가 필요합니다.

## 4. 시트 연결 규칙

| 시트 | Spread | 연결 | 표시 전환 |
|---|---|---|---|
| SEARCH_LEVEL | spdSearchLevel | AddSheet:684 (META 시트명과 일치) | VisibleSheet:1894에서 true, 1880/1889에서 false |
| REPORT | spdDetail | AddSheet:685 | VisibleSheet:1882에서 true, 1896에서 false |
| SEARCH_LEVEL_DETAIL | spdSearchLevelDetail | AddSheet:686 | VisibleSheet:1888에서 true, 1881/1893에서 false |

- 세 시트는 같은 Panel2에 겹쳐 있고, 한 번에 하나만 Visible입니다.
- 전환 기준 변수는 `_is_detail`로 보입니다. 정확한 조건은 **확인 필요**입니다.
- 시트 간 마스터-디테일 연동(행 선택 → 상세 조회)은 Fact Pack에 없습니다. **확인 필요**
