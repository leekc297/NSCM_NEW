# SCP0100 Global PSI Report — 화면설계서

> 근거: Fact Pack(controls.csv, props.csv, events.csv, grid_code.csv, grid_effective.csv)과 1차 분석서만 사용했습니다.
> props.csv는 중간이 잘려 있습니다(약 10KB 미수록). 잘린 부분에 있을 값(Orientation, 일부 LayoutItem Text 등)은 **확인 필요**로 적었습니다.

## 1. 화면 개요

| 항목 | 내용 |
|---|---|
| 화면 ID | SCP0100 |
| 화면 명칭 | Global PSI Report (클래스 `SCP0100_Global_PSI_Report`) |
| 메뉴 위치 | **확인 필요** (`TB_FX_MenuItemInfo` 1행 존재, 값 미수록) |
| 화면 유형 | 조회조건 패널 + 차트/그리드 분할 리포트 |
| 저장 기능 | 추출된 저장 엔드포인트 없음 |
| 소스 | `SCP0100_Global_PSI_Report.cs`(2056줄), `.designer.cs`(1682줄) |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (controls.csv parent 체인 + props.csv)

```
SCP0100_Global_PSI_Report (this)
├─ usrConditionPanel1  [UsrConditionPanel | Dock=Top | Size 1784×102 | UsrPanelType=HidePanel]
│   └─ usrLayoutControl2  [UsrLayoutControl | Dock=Fill | Size 1784×102 | Text "usrLayoutControl2"]
│       └─ layoutControlGroup2  [LayoutControlGroup | Size 1784×102]
│           ├─ 조회조건 컨트롤 21개 (parent=usrLayoutControl2): rgrpSearchLevel, chkCellQty, cboPlanDate,
│           │   cboBucketType, dCalendar, cboGraphType, btnItemId, btnMeasure, txtItemId, cboDisplay,
│           │   txtProject, clbFromSite, clbToSite, txtCellGroup, btnProject, cboPlanType, btnColumn,
│           │   cboSearchLevel, chkAS, cboUnitQty, clbDivision
│           ├─ LayoutControlItem 21개 / EmptySpaceItem 9개 (Location 미추출 → 행·열 순서 확인 필요)
│           └─ ※ 높이 단서: Item 높이 27~32, EmptySpaceItem 높이 59 → 2행 배치로 보이지만 확인 필요
├─ splitContainer1  [SplitContainer | parent=this | Dock·Orientation·Size·기본 SplitterDistance = 확인 필요(props 잘림)]
│   ├─ Panel1
│   │   └─ chartMain  [ChartControl]
│   └─ Panel2  (VisibleSheet가 3개 중 1개만 Visible)
│       ├─ spdSearchLevel        [FpSpread] → 시트 SEARCH_LEVEL        (SheetView spdSearchLevel_Sheet)
│       ├─ spdDetail             [FpSpread] → 시트 REPORT              (SheetView spdMain_Sheet로 보이지만 확인 필요)
│       └─ spdSearchLevelDetail  [FpSpread] → 시트 SEARCH_LEVEL_DETAIL (SheetView spdSearchLevelDetail_Sheet)
└─ usrButton1  [UsrButton | parent 없음 | Size 75×23]  ← 화면 배치 위치 확인 필요
```

### 2-2. 분할 비율

| 대상 | 값 | 비율 % | 비고 |
|---|---|---|---|
| usrConditionPanel1 | 높이 102 (Dock=Top) | 전체 폼 높이 미추출 → **확인 필요** | 접기 가능한 HidePanel |
| splitContainer1 기본 | SplitterDistance 확인 필요 | **확인 필요** | Orientation(상/하·좌/우) 미추출 |
| cboDisplay 변경 시 | SplitterDistance 0 / 750 / 270 (1833 / 1841 / 1849줄) | splitContainer1 전체 크기 미추출 → % 산출 불가 | 0 = Panel1(차트) 크기 0 → 그리드만 표시 |

### 2-3. 영역 구분

| 영역 | 구성 |
|---|---|
| 조회조건 | `usrConditionPanel1` > `usrLayoutControl2`: Division, From/To Site, Plan Date, 기간, Bucket, Plan-type, Model, Project, Cell Group, Search Level, Unit Qty, Graph, Display, Cell Qty, A/S |
| 버튼 | 조건 영역 안: `btnItemId`, `btnProject`(팝업), `btnMeasure`, `btnColumn`(헤더 재구성). `usrButton1`(용도 확인 필요). 툴바 조회 버튼은 BaseForm 소관으로 보이지만 확인 필요 |
| 그리드 | `splitContainer1.Panel2`: `spdSearchLevel` / `spdDetail` / `spdSearchLevelDetail` |
| 차트 | `splitContainer1.Panel1`: `chartMain` |
| 팝업 | Model 팝업(`BtnItemId_Click`), Project 팝업(`BtnProject_Click`). 팝업 화면 ID는 확인 필요 |

## 3. 컨트롤 명세

라벨 열은 props.csv의 Text 원문입니다. 연결된 LayoutControlItem의 Text를 쓰고, 해당 행이 잘린 경우 **확인 필요**로 적었습니다.

| 컨트롤명 | 타입 | 라벨 (Text 원문) | 초기값 / 속성 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | - | Dock=Top, 1784×102, HidePanel | - | - | 공용 조회조건 영역 (접기) |
| usrLayoutControl2 | UsrLayoutControl | "usrLayoutControl2" (컨트롤 Text) | Dock=Fill, 1784×102 | - | - | 조회조건 Grid 레이아웃 |
| clbDivision | UsrCheckedList2 | 확인 필요 | 179×21 | 확인 필요 | `ClbDivision_SelectedIndexChanged` | Wijmo MultiSelect (공용) |
| clbFromSite | UsrCheckedList2 | "From Site" (layoutControlItem1) | 202×21 | 확인 필요 | - | Wijmo MultiSelect |
| clbToSite | UsrCheckedList2 | "To Site" (lblToSite) | 214×21, 목록=`SCP.SCP0100_GET_SITE` | 확인 필요 | - (Shown에서 채움) | Wijmo MultiSelect |
| cboPlanDate | UsrCombo | 확인 필요 (layoutPlanDate Text 잘림) | 144×20, 목록=`SCP.SCP0100_GET_PLAN_DATE` | 확인 필요 | `CboPlanDate_SelectedIndexChanged` | Wijmo ComboBox |
| dCalendar | UsrDateRangePicker3 | 확인 필요 (layPeriod 추정, Text 잘림) | 230×22, 범위=PLAN_END_DATE | 확인 필요 | `DCalendar_ValueChanged` | 공용 DateRange |
| cboBucketType | UsrCombo | "Bucket" (lblBucket) | 70×20, 값 MONTHLY / WEEKLY | 확인 필요 | `CboBucketType_SelectedIndexChanged` | Wijmo ComboBox |
| cboPlanType | UsrCombo | "Plan-type" (PlanType) | 70×20, **LayoutItem Enabled=false** | 확인 필요 | `CboPlanType_SelectedIndexChanged` | Wijmo ComboBox (비활성) |
| cboGraphType | UsrCombo | "Graph" (lblGraphType) | 60×20 | 확인 필요 | `CboGraphType_SelectedIndexChanged` | Wijmo ComboBox |
| cboDisplay | UsrCombo | "Display" (layDisplay) | 60×20 | 확인 필요 | `CboDisplay_SelectedIndexChanged` | Wijmo ComboBox |
| cboSearchLevel | UsrCombo | 확인 필요 (lciSearchLevel 추정) | 120×20, lciSearchLevel.Enabled=`!_is_detail` | 확인 필요 | `CboSearchLevel_SelectedIndexChanged` | Wijmo ComboBox |
| rgrpSearchLevel | RadioGroup | 확인 필요 | 199×25 | 확인 필요 | `rgrpSearchLevel_SelectedIndexChanged` | Radio 그룹 (hook #154 v2 형태) |
| cboUnitQty | UsrCombo | 확인 필요 (layUnit_qty 추정) | 100×20 | 확인 필요 | `CboUnitQty_SelectedIndexChanged` | Wijmo ComboBox |
| txtItemId | UsrTextBox | "Model / Nick Name" (layModel) | 150×25, 팝업 결과 `sItemId` | 확인 필요 | - | Input + 팝업 |
| btnItemId | UsrButton | "layoutControlItem3" (layoutbtnitem Text 원문, 화면 표시 여부 확인 필요) | 39×25 | - | `BtnItemId_Click` | 팝업 호출 버튼 |
| txtProject | UsrTextBox | "Project" (lblCellGroup) | 150×26, 팝업 결과 `sProjectCode` | 확인 필요 | - | Input + 팝업 |
| btnProject | UsrButton | 확인 필요 (layoutControlItem2 Text 미추출) | 39×25 | - | `BtnProject_Click` | 팝업 호출 버튼 |
| txtCellGroup | UsrTextBox | "Cell Group" (lblCellGroup1) | 111×25 | 확인 필요 | - | Input |
| btnMeasure | UsrButton | 확인 필요 (layMeasure 추정) | 30×25 | - | `btnMeasure_Click` | 버튼 → 헤더 재구성 |
| btnColumn | UsrButton | 확인 필요 (layoutBtnColumn 추정) | 30×25 | - | `BtnColumn_Click` | 버튼 → 헤더 재구성 |
| chkCellQty | UsrCheckBox | "Cell Qty" | **Checked=true, Visible=false**, 80×26 | - | `ChkCellQty_CheckedChanged` | CheckBox (숨김) |
| chkAS | UsrCheckBox | "A/S" | **Visible=false**, 80×25 | - | `ChkAS_CheckedChanged` | CheckBox (숨김) |
| usrButton1 | UsrButton | 확인 필요 | 75×23, parent 없음 | - | 없음 | 확인 필요 (미사용 가능성) |
| splitContainer1 | SplitContainer | - | SplitterDistance 런타임 0/750/270 | - | (cboDisplay) | Split 레이아웃 |
| chartMain | ChartControl | - | Panel1 | - | 확인 필요 | Wijmo FlexChart |
| spdSearchLevel | FpSpread | - | Panel2, 시트 SEARCH_LEVEL | - | - | Wijmo FlexGrid |
| spdDetail | FpSpread | - | Panel2, 시트 REPORT | - | - | Wijmo FlexGrid |
| spdSearchLevelDetail | FpSpread | - | Panel2, 시트 SEARCH_LEVEL_DETAIL | - | - | Wijmo FlexGrid |
| spdMain_Sheet | SheetView | - | designer 94줄 | - | - | (FlexGrid 내부) |
| spdSearchLevel_Sheet | SheetView | - | designer 96줄 | - | - | (FlexGrid 내부) |
| spdSearchLevelDetail_Sheet | SheetView | - | designer 98줄 | - | - | (FlexGrid 내부) |

## 4. 그리드 명세

### 4-0. 시트 생성 (CreateSpread)

| Spread | 시트 | AddSheet 인자 | 줄 |
|---|---|---|---:|
| spdSearchLevel | SEARCH_LEVEL | 3, 1, 30 (헤더 3행. 1·30의 의미는 확인 필요) | 684 |
| spdDetail | REPORT | 3, 1, 30 | 685 |
| spdSearchLevelDetail | SEARCH_LEVEL_DETAIL | 3, 1, 30 | 686 |

- 컬럼 타입과 편집 가능 여부: `SetSheetHeaderColumn`이 `CELL_CONTROL_OBJECT_TYPE_CODE`, `DATA_SCALE_NUMBER` 등을 읽습니다. 하지만 값이 사실 묶음에 없어 META 컬럼의 타입·편집 여부는 **확인 필요**입니다. 저장 기능이 추출되지 않아 읽기 전용으로 보이지만, 이것도 확인 필요입니다.
- Division별 표시: 14개 Division 전부 같습니다(§4-4).

### 4-1. REPORT (spdDetail) — 최종 11 (?3)

| 컬럼 | 헤더 | 타입 | 출처 | Division별 표시 | 편집 |
|---|---|---|---|---|---|
| CELL_CF | Cell Qty | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| CELL_GROUP | Cell Group | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| DIVISION_ID | Div | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| FROM_SITE | From Site | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| TO_SITE | To Site | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| INCOTERMS | INCOTERMS | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| ITEM_ID | Model | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| MEASURE_GROUP | Measure Group | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| MEASURE_NAME | Measure Name | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| MEASURE_UI | Measure | 확인 필요 | META | 전 Div 숨김 | - |
| OPERATION_ID | Operation | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| VARIOUS_KEY | Trans Mode or Line or Project | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| PRODUCT_LEVEL1 | Product Level1 | 확인 필요 | META + 코드(SetLayout) | 기본 → 런타임(?) | 확인 필요 |
| PRODUCT_LEVEL2 | Product Level2 | 확인 필요 | META + 코드(SetLayout) | 기본 → 런타임(?) | 확인 필요 |
| PRODUCT_LEVEL3 | Product Level3 | 확인 필요 | META + 코드(SetLayout) | 기본 → 런타임(?) | 확인 필요 |
| D0, D1 | (빈값) | - | CODE_ONLY_CHANGE | → 숨김 (SetVisibleColumnCycle) | - |
| 기간 컬럼 (`*B_*`) | SP COLUMN_LABEL_NAME | Text | HARDCODED 루프(DB_DRIVEN) | 숨김, 폭 0 | - |
| 기간 컬럼 (`M_*` / `W_*`) | SP COLUMN_LABEL_NAME + 3단 헤더 | Num | HARDCODED 루프(DB_DRIVEN) | 폭 70. Bucket에 따라 M_ 또는 W_만 표시 | 확인 필요 |

### 4-2. SEARCH_LEVEL (spdSearchLevel) — 최종 5 (?3)

| 컬럼 | 헤더 | 타입 | 출처 | Division별 표시 | 편집 |
|---|---|---|---|---|---|
| CELL_GROUP | Cell Group | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| DIVISION_ID | Div | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| MEASURE_GROUP | Measure Group | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| MEASURE_NAME | Measure Name | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| OPERATION_GROUP | Operation Group | 확인 필요 | META | 전 Div 기본 | 확인 필요 |
| MEASURE_UI | Measure | 확인 필요 | META | 전 Div 숨김 | - |
| PRODUCT_LEVEL1~3 | Product Level1~3 | 확인 필요 | META + 코드(SetLayout) | 기본 → 런타임(?) | 확인 필요 |
| D0, D1 | (빈값) | - | CODE_ONLY_CHANGE | → 숨김 | - |
| 기간 컬럼 | SP 결과 | Text / Num | HARDCODED 루프(DB_DRIVEN) | REPORT와 같은 규칙 | 확인 필요 |

### 4-3. SEARCH_LEVEL_DETAIL (spdSearchLevelDetail) — 최종 5 (?3)

컬럼 구성과 규칙은 SEARCH_LEVEL과 같습니다.

| 컬럼 | 헤더 | 출처 | 표시 |
|---|---|---|---|
| CELL_GROUP / DIVISION_ID / MEASURE_GROUP / MEASURE_NAME / OPERATION_GROUP | Cell Group / Div / Measure Group / Measure Name / Operation Group | META | 기본 |
| MEASURE_UI | Measure | META | 숨김 |
| PRODUCT_LEVEL1~3 | Product Level1~3 | META + 코드 | 런타임(?) |
| D0, D1 | - | CODE_ONLY_CHANGE | 숨김 |
| 기간 컬럼 | SP 결과 | DB 루프 | REPORT와 같은 규칙 |

### 4-4. 공통 코드 규칙 (세 시트 공통)

- 3단 헤더:
  - 0행: LARGE_CLASS_LABEL_NAME 병합 (높이 20)
  - 1행: SMALL_CLASS_LABEL_NAME 병합
  - 2행: "Qty"
- 글자색:
  - `M_` 컬럼 중 `_plan_start_yyyymm` 포함 = Red
  - `W_` 컬럼 중 라벨에 "A" 또는 "B" 포함 = Blue
- Bucket 표시: MONTHLY → `M_`만 표시, WEEKLY → `W_`만 표시 (SetSpreadColumn)
- PRODUCT_LEVEL 표시 (`!_is_detail`일 때):

  | cboSearchLevel | L1 | L2 | L3 |
  |---|---|---|---|
  | 1 | O | O | X |
  | 2 | O | X | X |
  | 3 | X | O | X |
  | 4 | O | O | O |
  | case 미추출 | X | X | X |

- 시트 전환 (`VisibleSheet`, 1880~1896줄). 분기 조건은 확인 필요입니다.

  | 블록 | spdDetail | spdSearchLevel | spdSearchLevelDetail |
  |---|---|---|---|
  | 1880~1882 | 표시 | 숨김 | 숨김 |
  | 1888~1889 | (변경 없음) | 숨김 | 표시 |
  | 1893~1896 | 숨김 | 표시 | 숨김 |

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | this.Load | `Form_Load` | InitControls > GetPlanDate | `SCP.SCP0100_GET_PLAN_DATE` | cboPlanDate |
| A2 | this.Load | `Form_Load` | InitControls > SetCalendar > GetDayRange > GetPlanEndDate | `biz:CommonData.CommonDataList_REPORT` | dCalendar |
| A3 | this.Load | `Form_Load` | CreateSpread > InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 시트 3개, 헤더 |
| A4 | this.Shown | `SCP0100_Global_PSI_Report_Shown` | InitControlsAfter > RefreshToSite > GetSiteList | `SCP.SCP0100_GET_SITE` | clbToSite |
| A5 | clbDivision 변경 | `ClbDivision_SelectedIndexChanged` | 확인 필요 | 추출 없음 | 확인 필요 |
| A6 | cboGraphType 변경 | `CboGraphType_SelectedIndexChanged` | 확인 필요 (차트 유형 관련 추정) | 추출 없음 | chartMain (확인 필요) |
| A7 | cboPlanDate 변경 | `CboPlanDate_SelectedIndexChanged` | SetCalendar > GetDayRange > GetPlanEndDate. 이어서 InitSpread > GetSpdTitle | `biz:CommonData.CommonDataList_REPORT`, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | dCalendar, 헤더 |
| A8 | cboBucketType 변경 | `CboBucketType_SelectedIndexChanged` | `if(_SI != null)` SetSpreadColumn | 없음 | M_/W_ 컬럼 표시 |
| A9 | cboDisplay 변경 | `CboDisplay_SelectedIndexChanged` | SplitterDistance = 0 / 750 / 270 | 없음 | 차트/그리드 분할 |
| A10 | cboSearchLevel 변경 | `CboSearchLevel_SelectedIndexChanged` | 확인 필요 (SetLayout 연관 추정) | 추출 없음 | 확인 필요 |
| A11 | cboUnitQty 변경 | `CboUnitQty_SelectedIndexChanged` | 확인 필요 | 추출 없음 | 확인 필요 |
| A12 | rgrpSearchLevel 변경 | `rgrpSearchLevel_SelectedIndexChanged` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 |
| A13 | btnItemId 클릭 | `BtnItemId_Click` | 팝업 → `txtItemId.Text = sItemId` (1947) | 추출 없음 | txtItemId |
| A14 | btnMeasure 클릭 | `btnMeasure_Click` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 |
| A15 | btnProject 클릭 | `BtnProject_Click` | 팝업 → `txtProject.Text = sProjectCode` (1981) | 추출 없음 | txtProject |
| A16 | cboPlanType 변경 | `CboPlanType_SelectedIndexChanged` | 확인 필요 (LayoutItem Enabled=false) | 추출 없음 | 확인 필요 |
| A17 | btnColumn 클릭 | `BtnColumn_Click` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 |
| A18 | dCalendar 변경 | `DCalendar_ValueChanged` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 |
| A19 | chkCellQty 변경 | `ChkCellQty_CheckedChanged` | 확인 필요 (컨트롤 Visible=false) | 추출 없음 | 확인 필요 |
| A20 | chkAS 변경 | `ChkAS_CheckedChanged` | 확인 필요 (컨트롤 Visible=false) | 추출 없음 | 확인 필요 |
| A21 | 조회(Search) | 확인 필요 | 확인 필요 | 확인 필요 | 그리드·chartMain |

## 6. 검증·메시지

- 필수값 검증 코드와 메시지 ID는 추출되지 않았습니다 → **확인 필요**.
- TO-BE에서 메시지를 정할 때는 AS-IS MSG ID를 그대로 쓰지 않고, 문구로 TO-BE ID를 찾아야 합니다. 문구 원문도 확인 필요입니다.
- 조회 결과 0건, SP 오류일 때 화면이 보이는 반응도 확인 필요입니다.

## 7. 권한 (C/R/U/D)

| 항목 | 사실 |
|---|---|
| TB_FX_GroupMenuAuth | 4행. C/R/U/D 값 **확인 필요** |
| TB_FX_MenuItemInfo / TB_FX_ProgramInfo | 각 1행 |
| TB_FX_Favorite | 2행 |
| 세션 | `BaseForm.OnShown`:522가 NowGroupID, USER_ID 소비 |
| 저장·삭제 | 엔드포인트 없음 |

## 8. To-Be 전환 메모

| 영역 | AS-IS | To-Be |
|---|---|---|
| 그리드 | FarPoint Spread 3개 + VisibleSheet 전환 | Wijmo FlexGrid. 1개 그리드에서 시트를 전환할지, 3개를 둘지는 reference 패턴에 맞춰 결정 |
| 3단 헤더 | ColumnHeaderSpan | FlexGrid columnHeaders 행 추가 + allowMerging |
| 기간 컬럼 | `SCP0100_GET_SHEET_CALENDAR_3SPAN` 결과 루프 | 같은 SP(Oracle)의 결과로 동적 컬럼 생성. B_ 숨김, Num 폭 70, Red/Blue 규칙 유지 |
| Bucket 표시 | SetSpreadColumn (M_/W_) | FE에서 컬럼 visible 토글. 메타 고정 컬럼을 숨기지 않도록 시작 인덱스 확인 필요 |
| 차트 | DevExpress ChartControl | Wijmo FlexChart. 데이터 원천 확인 필요 |
| 분할 | SplitContainer, SplitterDistance 0/750/270 | 비율 기반 레이아웃. px → % 환산은 컨테이너 크기를 확인한 뒤 결정 |
| 조회조건 | UsrLayoutControl | SCP 조회조건 기준표(search_cond.csv, CR-071) 우선 대조 |
| Radio | RadioGroup | hook #154 v2 (좌측 라벨 열 + 입력 열) |
| 숨김 컨트롤 | chkCellQty, chkAS (Visible=false), cboPlanType (비활성) | 동작 유지 여부 확인 필요 |
| Oracle | `#TMP_PLAN` 임시 테이블, `FN_SPLITSTRING`, `FN_CHAR_TO_DATE` | GTT 또는 인라인 처리, 멀티선택 split 함수 대체, MSSQL 키워드 제거 |
| 공통 데이터 | `biz:CommonData.CommonDataList_REPORT` (PLAN_END_DATE) | TO-BE 대체 API 확인 필요 |

## 9. 미확정

1. splitContainer1의 Orientation, Dock, Size, 기본 SplitterDistance (props.csv 잘림)
2. LayoutControlItem Location과 Text: layPeriod, layMeasure, layoutBtnColumn, layUnit_qty, lciSearchLevel, layAS, layCategoryCC, layoutControlItem2·3·4, layoutPlanDate
3. clbDivision, rgrpSearchLevel 라벨
4. usrButton1 용도 (parent 없음)
5. 메인 조회 엔드포인트·SP, 차트 데이터
6. META 컬럼의 타입·편집 여부, SheetView ↔ Spread 대응(spdMain_Sheet)
7. VisibleSheet 분기 조건, SetLayout 마지막 case 라벨과 호출 지점
8. 핸들러 A5·A6·A10·A11·A16·A19·A20의 실제 동작
9. 권한 C/R/U/D 값과 메뉴 위치
