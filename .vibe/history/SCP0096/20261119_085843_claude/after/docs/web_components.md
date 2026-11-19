# SCP0096 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 매핑
| AS-IS 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 후보 |
|---|---|---|---|---|
| cboDivision | UsrCombo | `Division*` (layoutControlItem4) | 181×20 | 단일 선택 ComboBox(필수) |
| clbPlantSite | UsrCheckedList | `Plant Site` (layoutControlItem7) | 165×21 | 다중 선택 MultiSelect |
| dCalendar | UsrDateRangePicker3 | `Period*` (layoutControlItem2) | 210×22 | 기간 DateRange(필수) |
| cboDayWeek | UsrCombo | `Day of the week` (layoutControlItem3) | 134×20 | ComboBox. 데이터원은 확인 필요(dtDayWeek/LookupCommon 후보) |
| cboInputValue | UsrCombo | `Input Value` (layoutControlItem1) | 124×20 | ComboBox. Day of the week 변경 시 Enabled 토글 |
| btnInput | UsrButton | Text `Input` (layoutControlItem10) | 77×21 | 조회조건 영역 Button |
| chkSum | UsrCheckBox | Text `Sum` (layoutSum) | 46×20 | CheckBox. Designer에서 Visible=false, 초기 Checked=false |
| usrButton1 | UsrButton | (Text 없음, 부모 없음) | 75×23 | 확인 필요(미배치 추정 불가) |
| usrConditionPanel1 | UsrConditionPanel | — | 1192×96, Dock Top, HidePanel | 조회조건 패널 |
| usrLayoutControl2 / layoutControlGroup2 | UsrLayoutControl / LayoutControlGroup | — | 1192×96 | 조회조건 레이아웃 그리드 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | — | 1192×553, Dock Fill | Wijmo FlexGrid |
| emptySpaceItem1~10 (8개) | EmptySpaceItem | — | — | 간격(레이아웃 전용) |

## 2. 화면 배치
- props.csv에 SplitContainer 관련 값(Orientation, SplitterDistance)이 **없습니다**. 분할 컨테이너는 쓰지 않습니다.
- 상하 배치(Dock 기준):
  - 상단은 `usrConditionPanel1`(Dock Top)이며 높이 96입니다.
  - 하단은 `spdMain`(Dock Fill)이며 높이 553입니다.
  - Designer 크기 기준 비율은 96 : 553 = **약 14.8% : 85.2%**(합계 649)입니다.
- 조회조건 행 구성: LayoutControlItem 높이가 25/26이고 EmptySpaceItem 높이 조합(25·26)으로 보아 2행 배치로 보입니다. 정확한 행·열 좌표(Location)는 묶음에 없어 **확인 필요**입니다.

## 3. 시트별 Grid 컬럼 — `Shipment Working Day OSP`

### 3-1. 메타 컬럼 (SCM_MST_SHEET_COLUMNS, grid_effective 기준)
| COLUMN_NAME | 라벨 | 출처 | 전 division(14종) 표시 |
|---|---|---|---|
| DIVISION_ID | Division | META | 기본 |
| PLANT_SITE_ID | Plant Site ID | META | 기본 |
| PLANT_SITE_NAME | Plant Site | META | 기본 |
| MEASURE | Measure | META | 기본 |
| WORKING_TIME_DEFAULT | Working Time Default | META | 기본 |
| LAST_INPUT_DATE | Last Input Date | META | 기본 |

> 표의 순서는 CSV 순서가 아닌 나열 순서입니다. 실제 SORT_ORDER_NO, 폭, 정렬, 편집 속성은 **확인 필요**입니다(메타 원문 행이 묶음에 없음).

### 3-2. 코드 하드코딩·DB 루프 컬럼 (InitSpreadDateColumn)
| 조건 | API | 헤더 / 필드 | 폭 | 표시 | 편집기 |
|---|---|---|---:|---|---|
| COLUMN_NAME에 `B_` 포함(`IndexOf > 0`) | AddTextColumn | COLUMN_LABEL_NAME / COLUMN_NAME | 0 | 숨김 | Text |
| 그 외 | AddComboColumn | COLUMN_LABEL_NAME / COLUMN_NAME | 50 | 표시 | Combo(YesOrNo, `dtValidYN`), 가로·세로 Center |
| DAY_CODE = SAT | set:ForeColor | — | — | — | 글자색 Blue |
| DAY_CODE = SUN | set:ForeColor | — | — | — | 글자색 Red |

- 헤더는 3단입니다(`SetSheetHeaderColumn(siMain, 3)`, AddSheet 인자 3).
  - 0행: `LARGE_CLASS_LABEL_NAME` Span
  - 1행: `SMALL_CLASS_LABEL_NAME` Span
  - 대분류·소분류 시작 열: `"SUM"` 헤더 Span(1~2행, 높이 20/30)
- 컬럼 태그 접두어별 표시 규칙(SetSpreadColumn):
  - `D_`·`W_`: 항상 표시
  - `M_`·`W_`: `chkSum.Checked`일 때만 표시. W_가 두 조건에 겹치는 경우의 최종 값은 확인 필요
- 헤더 스타일(Designer 628~631): General 정렬, NoteIndicatorColor Red, Parent `ColumnHeaderDefaultEnhanced`

### 3-3. Division별 표시 차이
- 메타와 최종 표시 모두 14개 division에서 **6컬럼으로 같습니다**. 코드에 division 분기가 없습니다.

## 4. 시트 연결 규칙
| 시트 | 연결 규칙 | 설명 |
|---|---|---|
| Shipment Working Day OSP | META+코드연결 | 메타 시트 이름을 코드가 `AddSheet`/`ChangeSheet`/`InitSheet`(142·144·155)로 사용합니다. 메타 6컬럼 뒤에 날짜 컬럼을 DB 루프로 붙입니다(삽입 기준 MEASURE 인덱스) |

- 시트는 1개입니다. 마스터-디테일 같은 시트 간 연결은 없습니다.
