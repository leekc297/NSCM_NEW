# SCP0111 Integration PSI — Web 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑

라벨은 props.csv의 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다.

| AS-IS 컨트롤 | 유형 | 라벨(원문) | 레이아웃 아이템 | Size | 비고 | TO-BE 후보 |
|---|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Division*` | lblCombo1 | 218x26 | 필수 표시(*) · 변경 이벤트 | 공용 Division 콤보(필수) |
| cboPlanDate | UsrCombo | `Plan-date*` | PlanDate | 207x26 | 필수 표시(*) · 변경 이벤트 | 공용 콤보(필수) |
| cboPlanType | UsrCombo | `Plan-type` | PlanType | 205x26 | **Visible=false** (Designer:450) · 변경 이벤트 | 숨김 — 코드에서 표시 전환하는지 확인 필요 |
| cmbFromMonth | UsrComboBox | `Period` | layoutControlItem2 | 103x26 | SetChangedPeriod에서 DataBind | 기간 From 콤보 |
| cmbToMonth | UsrComboBox | ` ~` | layoutControlItem5 | 103x26 | SetChangedPeriod에서 DataBind | 기간 To 콤보 |
| txtNickName | UsrMultiLineEditor | `Nick Name` | lblNickName | 227x21 | | 멀티라인 입력 |
| btnNickName | UsrButton | (Text 없음) | layoutControlItem3 | 37x23 | Click → BtnNickName_Click | 입력 옆 팝업 버튼 |
| txtItemId | UsrMultiLineEditor | `Model` | lblItemId | 292x21 | | 멀티라인 입력 |
| btnItemId | UsrButton | (layoutControlItem1 Text `layoutControlItem3`) | layoutControlItem1 | 37x23 | Click → BtnItemId_Click | 입력 옆 팝업 버튼 |
| txtCellItemId | UsrMultiLineEditor | `Cell Model` | lblCellItem | 223x21 | | 멀티라인 입력 |
| btnCellItem_Id | UsrButton | - | layoutControlItem4 | 37x23 | **Visible=false**, Click 배선 없음 | 미노출 |
| chkQty | UsrCheckBox | `Qty < 0` | layoutControlItem6 | 309x38 | | CheckBox |
| usrButton1 | UsrButton | - | (parent 없음) | 75x23 | 사용 여부 확인 필요 | - |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | 시트 `Integration PSI` | - | 2021x865 | Dock Fill | Wijmo FlexGrid |
| pnlCondition | UsrConditionPanel | - | - | 2021x112 | Dock Top, PanelType.HidePanel | 조회조건 영역 |

## 2. 화면 배치
- props.csv에 SplitContainer가 **없습니다**. 그래서 분할 비율은 없습니다.
- 위아래 Dock 배치입니다.
  - 상단: `pnlCondition` Dock=Top, 높이 112 (2021x112) — 조회조건
  - 본문: `spdMain` Dock=Fill, 높이 865 (2021x865) — 그리드 단일
  - 높이 비율로는 조회조건 약 11.5% : 그리드 약 88.5% (112 : 865)입니다.
- 조회조건 레이아웃은 `usrLayoutControl2`(Dock Fill, 2021x112) / `layoutControlGroup2`입니다. 개별 아이템 좌표가 Fact Pack에 없어 정확한 행·열 배치는 확인 필요입니다.

## 3. 시트별 Grid 컬럼 — `Integration PSI`

연결 규칙: **META+코드연결** (AddSheet:299 → InitSheet:312 → SetSheetHeaderColumn:333)

### 3-1. 메타 컬럼 (grid_effective 기준, 모든 division 동일)
| # | COLUMN | Label | 표시 |
|---:|---|---|---|
| 1 | BOH_QTY | BOH | 기본 |
| 2 | CELL_CF | Cell Coversion Factor | 기본 |
| 3 | CELL_ITEM_ID | Cell Model | 기본 |
| 4 | CELL_MODEL_NICK_NAME | Cell Model Nick Name | 기본 |
| 5 | COMPANY_ID | Company | 기본 |
| 6 | DIVISION_ID | Division | 기본 |
| 7 | INCOTERMS | Incoterms | 기본 |
| 8 | ITEM_ID | Model | 기본 |
| 9 | LINE_ID | Line | 기본 |
| 10 | MEASURE | MEASURE | 기본 (단, 조회 모드에서 코드가 숨김) |
| 11 | MEASURE_COLOR | MEASURE_COLOR | 숨김 |
| 12 | MEASURE_LABEL | Measure | 기본 |
| 13 | MEASURE_ORDER_NO | MEASURE_ORDER_NO | 숨김 |
| 14 | NICK_NAME | Nick Name | 기본 |
| 15 | OPERATION_GROUP | Operation | 기본 |
| 16 | PLAN_TYPE | Plan Type | 기본 |
| 17 | PLANT_ID | Plant | 기본 (조회 모드 폭 0) |
| 18 | PLANT_ID_DESCRIPTION | Plant | 기본 |
| 19 | SEQ_FLAG | SEQ_FLAG | 기본 (단, 조회 모드에서 코드가 숨김) |
| 20 | TO_PRODUCT | To Product | 기본 |
| 21 | TO_SITE | To Site | 기본 (조회 모드 폭 0) |
| 22 | TO_SITE_DESCRIPTION | To Site | 기본 |
| 23 | UOM | UOM | 기본 |
| 24 | VALUE_TYPE | Valuation Type | 기본 |

- 표시 22개 + 숨김 2개(MEASURE_COLOR, MEASURE_ORDER_NO)입니다.
- SCM_MST_SHEET_MEASURE 7행(7/0)은 Measure 행 정의입니다. 각 행의 값은 Fact Pack에 없어 확인 필요입니다.
- 원문 라벨 `Cell Coversion Factor`의 철자는 메타 원문 그대로 옮겼습니다.

### 3-2. 코드 하드코딩·동적 컬럼
| 구분 | 위치 | 내용 |
|---|---|---|
| DB 루프 | SetCalendar:354 | CalendarMonth 결과의 행마다 월 컬럼을 추가합니다. 헤더 = `YYYYMM_NAME`, 바인딩 = `YYYYMM`, 숫자, 폭 75, 병합 없음, 표시 |
| Tag 규칙 | SetSpreadColumn:392/396 | Tag가 `D_` 또는 `W_`로 시작하면 숨김, `M_`로 시작하면 표시합니다(월 단위만 노출) |
| 모드 전환 | SetVisibleSheetColumns:1069~1082 | 편집 모드: SEQ_FLAG(60), MEASURE(80), PLANT_ID(65), TO_SITE(75) 표시. 조회 모드: SEQ_FLAG·MEASURE 숨김, PLANT_ID·TO_SITE 폭 0 |
| 헤더 스타일 | Designer:858~861 | ColumnHeaderDefaultEnhanced 상속, NoteIndicatorColor=Red |

### 3-3. Division별 표시 차이
- 모든 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 **22개로 같습니다**. 차이가 없습니다.
- 코드에 division 분기가 없습니다.

## 4. 시트 연결 규칙
- 시트는 `Integration PSI` 1개입니다. 탭이나 마스터-디테일 연결은 없습니다.
- 셀 클릭(`spdMain_CellClick`)에서 Line CODE/NAME(dtLine)을 참조합니다. 셀 편집 콤보(Line 선택)로 쓰이는 것으로 보이지만 확인 필요입니다.
- `SpdMain_CellDoubleClick`, `SpdMain_TopChange` 동작은 확인 필요입니다.
