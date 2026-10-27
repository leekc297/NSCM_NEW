# SCP0100 Global PSI Report — 화면설계서

> **근거 범위**: Fact Pack의 controls.csv, props.csv, events.csv, grid_code.csv, grid_effective.csv와 1차 분석서만 사용했습니다.
> props.csv는 뒷부분 약 10KB가 잘렸습니다. 그 범위에 있는 라벨과 SplitContainer 속성은 **확인 필요**로 적었습니다.
> 주석 처리된 호출(commented_calls)은 0건입니다.

## 1. 화면 개요

| 항목 | 내용 |
|---|---|
| 화면 ID | SCP0100 |
| 명칭 | Global PSI Report (클래스 `SCP0100_Global_PSI_Report`) |
| 메뉴 위치 | **확인 필요**. TB_FX_MenuItemInfo에 1행이 있으나 값은 dbmeta CSV를 봐야 합니다 |
| 유형 | 조회(Report). 차트 + Spread 3개(한 번에 하나만 표시) |
| Grid 구성 방식 | HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경) |
| 컨트롤 수 | 63개(controls.csv) |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (controls.csv parent 체인 + props.csv)

```
this (SCP0100_Global_PSI_Report)
├─[Dock=Top] usrConditionPanel1  (UsrConditionPanel, Size 1784×102, UsrPanelType=HidePanel → 접기 가능)
│   └─[Dock=Fill] usrLayoutControl2  (UsrLayoutControl, Size 1784×102, Text "usrLayoutControl2")
│        └─ layoutControlGroup2 (Size 1784×102) ── 조회조건 컨트롤 22개
│             rgrpSearchLevel, chkCellQty, cboPlanDate, cboBucketType, dCalendar, cboGraphType,
│             btnItemId, btnMeasure, txtItemId, cboDisplay, txtProject, clbFromSite, clbToSite,
│             txtCellGroup, btnProject, cboPlanType, btnColumn, cboSearchLevel, chkAS,
│             cboUnitQty, clbDivision  (+ EmptySpaceItem 9개)
│
└─[나머지 영역] splitContainer1  (SplitContainer, parent=this)
     │   Orientation      : 확인 필요 (props.csv 잘린 범위)
     │   SplitterDistance : 초기값 확인 필요 / 실행 중 0·750·270 (CboDisplay_SelectedIndexChanged)
     │   Size             : 확인 필요
     ├─ Panel1 : chartMain (DevExpress ChartControl)                     ← 차트 영역
     └─ Panel2 : 그리드 3개 겹침 (VisibleSheet로 하나만 Visible)        ← 그리드 영역
          ├─ spdSearchLevel        (시트 SEARCH_LEVEL)
          ├─ spdDetail             (시트 REPORT)
          └─ spdSearchLevelDetail  (시트 SEARCH_LEVEL_DETAIL)

(parent 없음) usrButton1 (UsrButton, Size 75×23) ── 배치 위치·사용 여부 확인 필요
(parent 없음) SheetView 3개: spdMain_Sheet, spdSearchLevel_Sheet, spdSearchLevelDetail_Sheet
```

### 2-2. 비율

| 분할 | 값 | 비율 % |
|---|---|---|
| 조회조건 / 본문 | 조회조건 높이 102px(Dock=Top). 본문은 나머지 | 폼 전체 높이가 없어 **확인 필요** |
| splitContainer1 Panel1 / Panel2 | SplitterDistance 0 / 750 / 270(실행 중) | Orientation·Size가 없어 **확인 필요**. 0이면 Panel1(차트) 폭 또는 높이가 0입니다 |

### 2-3. 텍스트 와이어프레임

```
┌──────────────────────────────────────────── 1784 ────────────────────────────────────────────┐
│ [조회조건 usrConditionPanel1 · 높이 102 · 접기 가능]                                          │
│ Model / Nick Name [txtItemId][btnItemId]  From Site [clbFromSite▼]  To Site [clbToSite▼]       │
│ Cell Group [txtCellGroup]  Project [txtProject][btnProject]  Bucket [cboBucketType▼]           │
│ Plan-type [cboPlanType▼](비활성)  Display [cboDisplay▼]  Graph [cboGraphType▼]                 │
│ (라벨 확인 필요) [cboPlanDate▼] [dCalendar From~To] [btnMeasure] [btnColumn] [cboUnitQty▼]      │
│ (라벨 확인 필요) [cboSearchLevel▼] (rgrpSearchLevel ◯◯) [clbDivision▼]                          │
│ (숨김) chkCellQty "Cell Qty" / chkAS "A/S"                                                      │
│ ※ 행 배치 순서는 LayoutItem Location 미추출로 확인 필요                                        │
├───────────────────────────────────────────────────────────────────────────────────────────────┤
│ splitContainer1 (Orientation 확인 필요)                                                        │
│ ┌ Panel1 ───────────────────────────────┐┌ Panel2 ─────────────────────────────────────────┐  │
│ │ chartMain (차트)                       ││ spdSearchLevel / spdDetail / spdSearchLevelDetail│  │
│ │                                        ││ (한 번에 하나만 Visible)                         │  │
│ └────────────────────────────────────────┘└─────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────────────────────────────────────┘
```

### 2-4. 영역

| 영역 | 구성 |
|---|---|
| 조회조건 | usrConditionPanel1 > usrLayoutControl2 아래의 컨트롤 |
| 버튼 | btnItemId, btnProject(팝업), btnMeasure, btnColumn(헤더 재구성). 공통 툴바(조회 등)는 BaseForm 제공으로 보이며 **확인 필요** |
| 그리드 | splitContainer1.Panel2의 spdSearchLevel, spdDetail, spdSearchLevelDetail |
| 차트 | splitContainer1.Panel1의 chartMain |
| 팝업 | BtnItemId_Click(Model), BtnProject_Click(Project). 팝업 화면 ID는 확인 필요 |

## 3. 컨트롤 명세

라벨은 props.csv의 Text 원문입니다. LayoutControlItem의 Text는 연결된 컨트롤의 라벨로 적었습니다. 필수 여부는 검증 코드가 추출되지 않아 모두 **확인 필요**입니다.

| # | 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 크기 | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|---|
| 1 | usrButton1 | UsrButton | 없음 | 75×23 | — | — | 없음(parent 없음) | 이관 여부 확인 필요 |
| 2 | usrConditionPanel1 | UsrConditionPanel | — | 1784×102, Dock=Top, HidePanel | — | — | — | 접이식 조회조건 패널 |
| 3 | usrLayoutControl2 | UsrLayoutControl | "usrLayoutControl2" | 1784×102, Dock=Fill | — | — | — | 조회조건 레이아웃(그리드 배치) |
| 4 | txtItemId | UsrTextBox | "Model / Nick Name" (layModel) | 150×25 | 확인 필요 | 확인 필요 | (BtnItemId_Click이 값을 채움) | Input + 검색 버튼 |
| 5 | btnItemId | UsrButton | "layoutControlItem3" (layoutbtnitem, 기본 이름) | 39×25 | — | — | Click → `BtnItemId_Click` | 팝업 버튼 |
| 6 | clbFromSite | UsrCheckedList2 | "From Site" (layoutControlItem1) | 202×21 | 확인 필요 | 확인 필요 | 없음 | Wijmo MultiSelect |
| 7 | clbToSite | UsrCheckedList2 | "To Site" (lblToSite) | 214×21 | `SCP.SCP0100_GET_SITE` 목록 | 확인 필요 | 없음 | Wijmo MultiSelect |
| 8 | txtCellGroup | UsrTextBox | "Cell Group" (lblCellGroup1) | 111×25 | 확인 필요 | 확인 필요 | 없음 | Input |
| 9 | txtProject | UsrTextBox | "Project" (lblCellGroup) | 150×26 | 확인 필요 | 확인 필요 | (BtnProject_Click이 값을 채움) | Input + 검색 버튼 |
| 10 | btnProject | UsrButton | layoutControlItem2 Text는 props.csv 표시 범위에 없음(확인 필요) | 39×25 | — | — | Click → `BtnProject_Click` | 팝업 버튼 |
| 11 | cboBucketType | UsrCombo | "Bucket" (lblBucket) | 70×20 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboBucketType_SelectedIndexChanged` | Wijmo ComboBox (MONTHLY/WEEKLY) |
| 12 | cboPlanType | UsrCombo | "Plan-type" (PlanType, Enabled=false) | 70×20 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboPlanType_SelectedIndexChanged` | Wijmo ComboBox(비활성) |
| 13 | cboDisplay | UsrCombo | "Display" (layDisplay) | 60×20 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboDisplay_SelectedIndexChanged` | Wijmo ComboBox |
| 14 | cboGraphType | UsrCombo | "Graph" (lblGraphType) | 60×20 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboGraphType_SelectedIndexChanged` | Wijmo ComboBox |
| 15 | cboPlanDate | UsrCombo | 확인 필요(props.csv 잘림) | 144×20 | `SCP.SCP0100_GET_PLAN_DATE` 목록 | 확인 필요 | SelectedIndexChanged → `CboPlanDate_SelectedIndexChanged` | Wijmo ComboBox |
| 16 | dCalendar | UsrDateRangePicker3 | 확인 필요(props.csv 잘림) | 230×22 | `biz:CommonData.CommonDataList_REPORT`(PLAN_END_DATE) 기반 | 확인 필요 | ValueChanged → `DCalendar_ValueChanged` | 기간(From~To) InputDate 쌍 |
| 17 | btnMeasure | UsrButton | 확인 필요(props.csv 잘림) | 30×25 | — | — | Click → `btnMeasure_Click` | 메저 선택 버튼 |
| 18 | btnColumn | UsrButton | 확인 필요(props.csv 잘림) | 30×25 | — | — | Click → `BtnColumn_Click` | 컬럼 선택 버튼 |
| 19 | cboUnitQty | UsrCombo | 확인 필요(props.csv 잘림) | 100×20 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboUnitQty_SelectedIndexChanged` | Wijmo ComboBox |
| 20 | cboSearchLevel | UsrCombo | 확인 필요(props.csv 잘림). LayoutItem lciSearchLevel.Enabled = !_is_detail | 120×20 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboSearchLevel_SelectedIndexChanged` | Wijmo ComboBox |
| 21 | rgrpSearchLevel | RadioGroup | 확인 필요 | 199×25 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `rgrpSearchLevel_SelectedIndexChanged` | Radio 그룹 |
| 22 | clbDivision | UsrCheckedList2 | 확인 필요(props.csv 잘림) | 179×21 | 확인 필요 | 확인 필요 | SelectedIndexChanged → `ClbDivision_SelectedIndexChanged` | Wijmo MultiSelect |
| 23 | chkCellQty | UsrCheckBox | "Cell Qty" | 80×26 | Checked=true, **Visible=false** | — | CheckedChanged → `ChkCellQty_CheckedChanged` | CheckBox(숨김). 이관 여부 확인 필요 |
| 24 | chkAS | UsrCheckBox | "A/S" | 80×25 | **Visible=false** | — | CheckedChanged → `ChkAS_CheckedChanged` | CheckBox(숨김). 이관 여부 확인 필요 |
| 25 | splitContainer1 | SplitContainer | — | 확인 필요 | SplitterDistance 확인 필요 | — | (CboDisplay가 변경) | Splitter 레이아웃 |
| 26 | chartMain | ChartControl | — | 확인 필요 | — | — | (CboGraphType 연동은 확인 필요) | Wijmo FlexChart |
| 27 | spdSearchLevel | FpSpread | — | — | 시트 SEARCH_LEVEL | — | — | Wijmo FlexGrid |
| 28 | spdDetail | FpSpread | — | — | 시트 REPORT | — | — | Wijmo FlexGrid |
| 29 | spdSearchLevelDetail | FpSpread | — | — | 시트 SEARCH_LEVEL_DETAIL | — | — | Wijmo FlexGrid |
| 30 | spdMain_Sheet | SheetView | — | — | 어느 Spread에 속하는지 확인 필요(이름상 spdMain) | — | — | (FlexGrid 내부, 별도 컴포넌트 없음) |
| 31 | spdSearchLevel_Sheet | SheetView | — | — | 확인 필요 | — | — | (FlexGrid 내부) |
| 32 | spdSearchLevelDetail_Sheet | SheetView | — | — | 확인 필요 | — | — | (FlexGrid 내부) |

## 4. 그리드 명세

공통 사항
- 헤더는 3행입니다(`SetSheetHeaderColumn(_SI, 3)`).
- AddSheet 인자는 `3 ¦ 1 ¦ 30`입니다(의미는 확인 필요).
- 메타 고정 컬럼 뒤에 `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` 결과로 기간 컬럼을 붙입니다.
- 편집 가능 여부: 조회 화면이고 저장 엔드포인트가 없습니다. 메타 CELL_CONTROL_OBJECT_TYPE_CODE 값은 Fact Pack에 없어 **확인 필요**입니다.
- 메타 컬럼의 데이터 타입은 메타 행 값이 없어 **확인 필요**입니다.
- 메타 순서(SORT_ORDER_NO)도 **확인 필요**입니다.

### 4-1. 시트 `REPORT` (spdDetail, AddSheet:685, META+코드연결)

| 컬럼 | 헤더 | 타입 | 출처 | division별 표시(14개 동일) | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Div | 확인 필요 | META | 기본 표시 | 확인 필요 |
| ITEM_ID | Model | 확인 필요 | META | 기본 표시 | 확인 필요 |
| FROM_SITE | From Site | 확인 필요 | META | 기본 표시 | 확인 필요 |
| TO_SITE | To Site | 확인 필요 | META | 기본 표시 | 확인 필요 |
| INCOTERMS | INCOTERMS | 확인 필요 | META | 기본 표시 | 확인 필요 |
| OPERATION_ID | Operation | 확인 필요 | META | 기본 표시 | 확인 필요 |
| VARIOUS_KEY | Trans Mode or Line or Project | 확인 필요 | META | 기본 표시 | 확인 필요 |
| CELL_GROUP | Cell Group | 확인 필요 | META | 기본 표시 | 확인 필요 |
| CELL_CF | Cell Qty | 확인 필요 | META | 기본 표시 | 확인 필요 |
| MEASURE_GROUP | Measure Group | 확인 필요 | META | 기본 표시 | 확인 필요 |
| MEASURE_NAME | Measure Name | 확인 필요 | META | 기본 표시 | 확인 필요 |
| MEASURE_UI | Measure | 확인 필요 | META | 숨김 | 확인 필요 |
| PRODUCT_LEVEL1 | Product Level1 | 확인 필요 | META + 코드(SetLayout) | 기본 → cboSearchLevel에 따라 동적(?) | 확인 필요 |
| PRODUCT_LEVEL2 | Product Level2 | 확인 필요 | META + 코드(SetLayout) | 기본 → 동적(?) | 확인 필요 |
| PRODUCT_LEVEL3 | Product Level3 | 확인 필요 | META + 코드(SetLayout) | 기본 → 동적(?) | 확인 필요 |
| D0, D1 | (공란) | — | CODE_ONLY_CHANGE | 숨김(SetVisibleColumnCycle:1290) | — |
| 기간 컬럼(M_*, W_*, *B_*) | LARGE / SMALL / "Qty" 3행 | B_ 포함: Text, 그 외: Num | HARDCODED 로직 + DB루프(3SPAN) | §4-4 규칙 | 확인 필요 |

메타 14/0이고 최종 표시는 **11 (?3)** 입니다.

### 4-2. 시트 `SEARCH_LEVEL` (spdSearchLevel, AddSheet:684, META+코드연결)

| 컬럼 | 헤더 | 타입 | 출처 | division별 표시(14개 동일) | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Div | 확인 필요 | META | 기본 표시 | 확인 필요 |
| OPERATION_GROUP | Operation Group | 확인 필요 | META | 기본 표시 | 확인 필요 |
| CELL_GROUP | Cell Group | 확인 필요 | META | 기본 표시 | 확인 필요 |
| MEASURE_GROUP | Measure Group | 확인 필요 | META | 기본 표시 | 확인 필요 |
| MEASURE_NAME | Measure Name | 확인 필요 | META | 기본 표시 | 확인 필요 |
| MEASURE_UI | Measure | 확인 필요 | META | 숨김 | 확인 필요 |
| PRODUCT_LEVEL1~3 | Product Level1~3 | 확인 필요 | META + 코드(SetLayout) | 기본 → 동적(?) | 확인 필요 |
| D0, D1 | (공란) | — | CODE_ONLY_CHANGE | 숨김 | — |
| 기간 컬럼 | 3행 헤더 | Text / Num | DB루프(3SPAN) | §4-4 | 확인 필요 |

메타 8/0이고 최종 표시는 **5 (?3)** 입니다.

### 4-3. 시트 `SEARCH_LEVEL_DETAIL` (spdSearchLevelDetail, AddSheet:686, META+코드연결)

컬럼 구성은 SEARCH_LEVEL과 같습니다: DIVISION_ID(Div), OPERATION_GROUP(Operation Group), CELL_GROUP(Cell Group), MEASURE_GROUP(Measure Group), MEASURE_NAME(Measure Name), MEASURE_UI(Measure, 숨김), PRODUCT_LEVEL1~3(동적), D0/D1(숨김), 기간 컬럼. 출처도 같습니다(META / CODE_ONLY_CHANGE / DB루프). 메타 8/0이고 최종 표시는 **5 (?3)** 입니다.

### 4-4. 기간 컬럼 규칙 (3개 시트 공통, InitSpreadDateColumn)

| 규칙 | 내용 | 줄 |
|---|---|---|
| 원천 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` 결과 행 | 706 |
| `IndexOf("B_") > 0` | AddTextColumn, 폭 0, Visible=false | 755 |
| 그 외 | AddNumColumn, 폭 70, Visible=true | 760 |
| 글자색 빨강 | `M_`로 시작하고 `_plan_start_yyyymm` 포함 | 767 |
| 글자색 파랑 | `W_`로 시작하고 라벨에 "A" 포함 / "B" 포함 | 774 / 778 |
| 헤더 0행 | LARGE_CLASS_LABEL_NAME 병합 | 787, 815 |
| 헤더 1행 | SMALL_CLASS_LABEL_NAME 병합(또는 "Qty" 2행 병합) | 788, 793, 802, 813, 816 |
| 헤더 2행 | "Qty" | 794, 803, 814 |
| Bucket | MONTHLY: `M_`만 표시 / WEEKLY: `W_`만 표시 | SetSpreadColumn 1103~1118 |

### 4-5. PRODUCT_LEVEL 표시 (SetLayout, `!_is_detail`일 때)

| cboSearchLevel.SelectedIndex | L1 | L2 | L3 |
|---|---|---|---|
| 1 | 표시 | 표시 | 숨김 |
| 2 | 표시 | 숨김 | 숨김 |
| 3 | 숨김 | 표시 | 숨김 |
| 4 | 표시 | 표시 | 표시 |
| (case 라벨 미추출) | 숨김 | 숨김 | 숨김 |

### 4-6. 메저

SCM_MST_SHEET_MEASURE `Global PSI New`에 35행이 있습니다(division 공통). 메저별 내역은 **확인 필요**입니다.

## 5. 액션 명세

| # | 트리거(컨트롤.이벤트) | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | this.Load | `Form_Load` | CreateSpread > InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 시트 3개 생성, 메타 + 기간 컬럼 구성 |
| A2 | this.Load | `Form_Load` | InitControls > GetPlanDate | `SCP.SCP0100_GET_PLAN_DATE` | cboPlanDate 목록 |
| A3 | this.Load | `Form_Load` | InitControls > SetCalendar > GetDayRange > GetPlanEndDate | `biz:CommonData.CommonDataList_REPORT` [PLAN_END_DATE] | dCalendar 범위 |
| A4 | this.Shown | `SCP0100_Global_PSI_Report_Shown` | InitControlsAfter > RefreshToSite > GetSiteList | `SCP.SCP0100_GET_SITE` | clbToSite 목록 |
| A5 | cboPlanDate.SelectedIndexChanged | `CboPlanDate_SelectedIndexChanged` | InitSpread > GetSpdTitle / SetCalendar > GetDayRange > GetPlanEndDate | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, `biz:CommonData.CommonDataList_REPORT` | 헤더 재구성, dCalendar 재설정 |
| A6 | dCalendar.ValueChanged | `DCalendar_ValueChanged` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성 |
| A7 | rgrpSearchLevel.SelectedIndexChanged | `rgrpSearchLevel_SelectedIndexChanged` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성(시트 전환 관계는 확인 필요) |
| A8 | btnMeasure.Click | `btnMeasure_Click` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성 |
| A9 | btnColumn.Click | `BtnColumn_Click` | InitSpread > GetSpdTitle | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 헤더 재구성 |
| A10 | cboBucketType.SelectedIndexChanged | `CboBucketType_SelectedIndexChanged` | `if(_SI != null)` SetSpreadColumn(:1804) | 없음 | M_ / W_ 컬럼 표시 전환 |
| A11 | cboDisplay.SelectedIndexChanged | `CboDisplay_SelectedIndexChanged` | splitContainer1.SplitterDistance = 0 / 750 / 270 | 없음 | 차트·그리드 분할 변경 |
| A12 | cboSearchLevel.SelectedIndexChanged | `CboSearchLevel_SelectedIndexChanged` | 확인 필요(SetLayout 연동 여부 미추출) | 없음 | 확인 필요 |
| A13 | clbDivision.SelectedIndexChanged | `ClbDivision_SelectedIndexChanged` | 확인 필요 | 없음 | 확인 필요 |
| A14 | cboGraphType.SelectedIndexChanged | `CboGraphType_SelectedIndexChanged` | 확인 필요 | 없음 | 확인 필요(차트 연동 추정, 미확인) |
| A15 | cboUnitQty.SelectedIndexChanged | `CboUnitQty_SelectedIndexChanged` | 확인 필요 | 없음 | 확인 필요 |
| A16 | cboPlanType.SelectedIndexChanged | `CboPlanType_SelectedIndexChanged` | 확인 필요(LayoutItem 비활성) | 없음 | 확인 필요 |
| A17 | btnItemId.Click | `BtnItemId_Click` | 팝업(확인 필요) → `txtItemId.Text = sItemId`(:1947) | 없음 | txtItemId 값 |
| A18 | btnProject.Click | `BtnProject_Click` | 팝업(확인 필요) → `txtProject.Text = sProjectCode`(:1981) | 없음 | txtProject 값 |
| A19 | chkCellQty.CheckedChanged | `ChkCellQty_CheckedChanged` | 확인 필요(컨트롤 숨김) | 없음 | 확인 필요 |
| A20 | chkAS.CheckedChanged | `ChkAS_CheckedChanged` | 확인 필요(컨트롤 숨김) | 없음 | 확인 필요 |
| A21 | 조회(BaseForm 툴바 추정) | 미식별 | 미식별 | **미식별** | 시트 3개 본문, 차트 — **확인 필요** |

## 6. 검증·메시지

- 입력 검증 코드와 메시지 코드는 Fact Pack에서 추출되지 않았습니다. **확인 필요**
- 코드상 조건으로 확인된 것은 다음뿐입니다.
  - `CboBucketType_SelectedIndexChanged`의 `_SI != null` 가드
  - `lciSearchLevel.Enabled = !_is_detail`

## 7. 권한 (C/R/U/D)

| 항목 | 사실 |
|---|---|
| TB_FX_GroupMenuAuth | SCP0100 행 4건이 있습니다. C/R/U/D 값은 **확인 필요** |
| 세션 | BaseForm.OnShown:522가 NowGroupID와 USER_ID를 사용합니다 |
| 저장·삭제 | 엔드포인트가 없습니다. R 전용으로 보이며 확인 필요 |
| 조회조건 저장 | TB_FX_SearchCondition 23행, SCM_MST_TITLESET_USER 526행 |

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 항목 | AS-IS | To-Be 관점 |
|---|---|---|
| 그리드 | FarPoint Spread 3개 겹침 + VisibleSheet | FlexGrid. 시트별 3개 또는 단일 그리드 전환 중 선택은 설계 결정이 필요합니다(`_is_detail` 조건 확인 후) |
| 3행 헤더 | ColumnHeaderSpan | FlexGrid `columnHeaders` 3행 + allowMerging. LARGE / SMALL / "Qty" 병합 |
| 동적 기간 컬럼 | 3SPAN 결과 DB 루프 | API 결과로 컬럼 정의를 생성합니다. `B_` 숨김 텍스트, 숫자 폭 70, 글자색 규칙(빨강/파랑)은 셀 서식 처리 |
| Bucket 전환 | SetSpreadColumn | 재조회 없이 FE에서 M_ / W_ 컬럼 visible만 전환(AS-IS도 API 없음) |
| 차트 | DevExpress ChartControl | FlexChart. 시리즈 구성은 확인 필요 |
| 분할 | SplitContainer 0/750/270 | Splitter 컴포넌트. 비율 기준 환산은 Orientation·Size 확인 후 |
| 멀티 선택 | UsrCheckedList2(GetCheckedListValue CODE) | MultiSelect. 선택 CODE를 구분자 문자열로 전달하는지는 SP 파라미터 확인 후(SP가 FN_SPLITSTRING 사용) |
| SP: #TMP_PLAN | MSSQL 임시 테이블 | Oracle GTT 또는 WITH절로 전환 |
| SP: FN_SPLITSTRING, FN_CHAR_TO_DATE | MSSQL 함수 | Oracle 동등 함수 존재 여부 확인 |
| Biz 경유 PLAN_END_DATE | Data_REPORT.CallBizCommonData | To-Be 공통 데이터 API 매핑이 필요하며 원천은 확인 필요 |
| 숨김 컨트롤 | chkCellQty, chkAS(Visible=false), usrButton1(parent 없음) | 이관 여부 결정 필요 |
| Division | 코드·메타 분기 없음 | division별 컬럼 분기가 필요 없습니다(추출 기준) |

## 9. 미확정

1. 메인 조회 엔드포인트와 SP, 차트 데이터 원천
2. splitContainer1의 Orientation, 초기 SplitterDistance, Size(props.csv 잘림)
3. 라벨 미확인 LayoutItem: layPeriod, layMeasure, layoutBtnColumn, layUnit_qty, lciSearchLevel, layoutControlItem2/3/4, layAS, layCategoryCC, layoutPlanDate
4. 조회조건 컨트롤의 배치 순서와 행(Location 미추출)
5. 핸들러 내부 동작: ClbDivision, CboGraphType, CboSearchLevel, CboUnitQty, CboPlanType, ChkCellQty, ChkAS
6. CboDisplay 값과 0/750/270의 대응
7. `_is_detail` 조건과 VisibleSheet 규칙
8. SheetView 3개와 Spread의 소속 관계(spdMain_Sheet 명칭)
9. 메타 컬럼 타입·편집·순서
10. Model / Project 팝업 화면 ID
11. 권한 C/R/U/D 값
