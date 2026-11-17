# SCP0033 웹 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑

| AS-IS 컨트롤 | 유형 | 라벨 (원문) | TO-BE 후보 | 비고 |
|---|---|---|---|---|
| txtItemId | TextBox | `Model` (layoutControlItem13) | 텍스트 입력 | Size 198×24 |
| cboValidYN | UsrCombo | `Valid` (layoutControlItem3) | ComboBox (Wijmo) | Size 155×20, 항목 소스는 확인 필요 |
| clbDivision | UsrCheckedList | `Division` (layoutControlItem4) | MultiSelect (Wijmo) | Size 199×21, GetCheckedListValue(CODE) |
| emptySpaceItem3 | EmptySpaceItem | - | 여백 | 473×28 |
| usrConditionPanel1 | UsrConditionPanel | - | 조회조건 영역 | Dock Top, PanelType HidePanel |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | - | FlexGrid (Wijmo) | Dock Fill |
| usrLayoutControl1 / layoutControlGroup1 | Layout | - | 확인 필요 | 657×184, parent 미확인 |
| imageList1 | ImageList | - | 미사용 후보 | 용도는 확인 필요 |

## 2. 화면 배치

- props.csv에는 SplitContainer가 없습니다. 분할 컨트롤 없이 Dock으로만 배치합니다.
- 상단: `usrConditionPanel1` Dock Top, 1168×48
- 하단: `spdMain` Dock Fill, 1168×544
- 상/하 비율(Designer 크기 기준): 48 : 544, 약 8.1% : 91.9%
- 조회조건 순서(LayoutControl 기준): Model(239×28) · 여백(473×28) · Valid(189×28) · Division(247×28). 실제 좌표 순서는 Location이 Fact Pack에 없어 확인 필요입니다.

## 3. 시트별 Grid 컬럼 — `Shipment Semi Dept Day`

구성: META(SetSheetHeaderColumn) + 코드 보정(InsertButton의 DIVISION_ID Combo, 헤더 스타일)

| 컬럼 | 라벨 (메타 원문) | 출처 | 40 | 81 계열 (81, _HD/_HG/_HM/_ST/_UC) | 82 | EE 계열 (EE, _HD/_HG/_HM/_ST/_UC) |
|---|---|---|---|---|---|---|
| DIVISION_ID | Division* | META (+코드 Combo, 행 추가 시) | 기본 | 기본 | 기본 | 기본 |
| ITEM_ID | Model* | META | 기본 | 기본 | 기본 | 기본 |
| NICK_NAME | Nick Name | META | 기본 | 기본 | 기본 | 기본 |
| OPERATION_GROUP | Operation Group | META | 기본 | 기본 | 기본 | 기본 |
| DEPARTURE_DAY | Departure day | META | 기본 | 기본 | 기본 | 기본 |
| VALID_YN | Valid | META | 기본 | 기본 | 기본 | 기본 |
| S_VALID_YN | S_VALID_YN | META | 숨김 | 숨김 | 숨김 | 숨김 |
| CREATED_BY | Created By | META | 기본 | 기본 | 기본 | 기본 |
| CREATION_DATE | Creation Date | META | 기본 | 기본 | 기본 | 기본 |
| LAST_UPDATED_BY | Last Updated By | META | 기본 | 기본 | 기본 | 기본 |
| LAST_UPDATE_DATE | Last Update Date | META | 기본 | 기본 | 기본 | 기본 |

- 표시 컬럼 수: 모든 division에서 10개(division별 차이 없음)
- 위 표의 행 순서는 grid_effective.csv의 순서가 아닙니다. 실제 컬럼 순서·폭·정렬·셀 타입(DEPARTURE_DAY, VALID_YN의 Combo 여부 등)은 SCM_MST_SHEET_COLUMNS 원문 확인이 필요합니다.
- 헤더 스타일: Horizontal/VerticalAlignment General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced (Designer.cs 270~273)

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 설명 |
|---|---|---|
| Shipment Semi Dept Day | META+코드연결 | 코드에서 AddSheet/ChangeSheet로 메타 시트를 사용함 (CreateSpread 147~149) |

- 시트는 1개이고, 마스터-디테일 연결은 없습니다.
