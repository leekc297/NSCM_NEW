# SSP0005 — React / Wijmo 컴포넌트 매핑

## 1. 컨트롤 → 컴포넌트 매핑

| As-is 컨트롤 | 유형 | 라벨(원문) | 라벨 출처 | Size | TO-BE 후보 |
|---|---|---|---|---|---|
| `cboCompany` | UsrCombo | `Company` | layoutControlItem4.Text (437) | 198×20 | 단일 선택 콤보(Wijmo ComboBox 계열) |
| `clbDivision` | UsrCheckedList | `Division` | lcDivision.Text (403) | 199×21 | 다중 선택(Wijmo MultiSelect 계열) |
| `drpPeriod` | UsrDateRangePicker | `Period*` | layoutControlItem6.Text (391) | 206×20 | 기간(From~To) 날짜 범위 입력 — 필수 표시 `*` |
| `cboDayWeek` | UsrCombo | `Day of the week` | layoutControlItem1.Text (365) | 155×20 | 콤보. 다중 여부는 확인 필요(`GetCheckedListValue` 사용: 660·682) |
| `cboInputValue` | UsrComboBox | `Input Value` | lcInputValue.Text (415) | 174×20 | 콤보(YesOrNo 바인딩: InitControls:168), Enabled 동적 제어 |
| `btnInput` | UsrButton | `Input` | btnInput.Text (164) | 77×21 | 버튼(일괄 입력) |
| `usrButton1` | UsrButton | 확인 필요(Text 미추출) | - | 75×23 | parent 없음, 용도 확인 필요 |
| `spdMain` / `spdMain_Sheet1` | FpSpread / SheetView | 시트 `Shipment Working Day` | grid_code AddSheet(179) | 1192×584 | Wijmo FlexGrid(3단 헤더 병합, 셀 콤보) |
| `usrConditionPanel1` | UsrConditionPanel | - | - | 1192×65 | 조회조건 영역(PanelType.HidePanel) |
| `usrLayoutControl2` / `layoutControlGroup2` | 레이아웃 | - | - | 1192×65 / 1192×70 | 조회조건 레이아웃 |
| `emptySpaceItem1/2` | EmptySpaceItem | - | - | 170×25 / 417×50 | 여백 |
| (Form) | - | `Working Time` | this.Text (501) | - | 화면 타이틀 원문 |

조회/저장 버튼(FindButton, SaveButton)은 프레임워크 공통 버튼 진입점으로만 추출되었습니다.

## 2. 화면 배치

- props.csv에 **SplitContainer가 없습니다**. Orientation과 SplitterDistance는 해당 사항 없음입니다.
- 상/하 2단 구성입니다.
  - 상단: `usrConditionPanel1` (Dock=Top, 1192×65)
  - 하단: `spdMain` (Dock=Fill, 1192×584)
- Designer 기준 높이 비율은 상단 65 : 하단 584 = 약 **10% : 90%**입니다. 하단은 Fill이므로 실제 높이는 창 크기에 따라 달라집니다.
- 조회조건 행의 LayoutItem 폭은 Company 257, Day of the week 257, Input 81, Period* 251, Division 247, Input Value 247입니다. 행·열 배치 좌표는 확인 필요입니다.

## 3. 시트별 Grid 컬럼 — `Shipment Working Day`

### 3-1. 메타 컬럼 (grid_effective 기준, SCM_MST_SHEET_COLUMNS)

| 컬럼 | 라벨(원문) | 출처 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| COMPANY_ID | Company | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |
| DIVISION_ID | Divison | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |

- 메타 컬럼 속성은 `SetSheetHeaderColumn`이 읽는 COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, FIXED_FLAG 등에서 가져옵니다. 구체적인 값은 Fact Pack에 없어 확인 필요입니다.
- 라벨 `Divison`은 메타 원문의 철자 그대로입니다.

### 3-2. 코드 생성 날짜 컬럼 (DB 루프 — `InitSpreadDateColumn`)

| 항목 | 값 |
|---|---|
| 데이터 원천 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과 행(dsSpdTitle) |
| 시작 위치 | DIVISION 컬럼 인덱스 + 1 |
| 헤더 / 필드 | `COLUMN_LABEL_NAME` / `COLUMN_NAME` |
| 셀 타입 | Combo(데이터 `Data.Common(YesOrNo)`) |
| 폭 / 정렬 | 70 / 가로 Center, 세로 Center |
| 생성 제외 조건 | `sColumnName.IndexOf("B_") > 0`이면 AddComboColumn 분기를 타지 않음(else 분기만 생성). B_ 분기 내용은 확인 필요 |
| 색상 | DAY_CODE = SAT → Blue, SUN → Red (ForeColor) |
| 헤더 행 | 3단(SetSheetHeaderColumn 인자 3). row 0 = LARGE_CLASS_LABEL_NAME 병합, row 1 = SMALL_CLASS_LABEL_NAME 병합, 높이 20 |
| 접기/펼치기 | 헤더 더블클릭. `M_` → `W_`·`D_` 반전, `W_` → `D_` 반전 |

### 3-3. Division별 표시 차이

모든 division의 최종 표시 컬럼 수는 2입니다(메타). division 분기 코드는 없습니다. 날짜 컬럼 수는 런타임 결과에 따라 정해지며 미집계입니다.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 설명 |
|---|---|---|
| Shipment Working Day | META+코드연결 | 메타 시트를 코드가 `AddSheet`(179)·`InitSheet`(194)로 사용하고, 메타 컬럼 뒤에 DB 루프 날짜 컬럼을 덧붙입니다 |
