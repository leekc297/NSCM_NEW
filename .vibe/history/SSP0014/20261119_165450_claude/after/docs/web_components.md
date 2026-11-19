# SSP0014 웹 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑

| As-is 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Division*` | 189×20 | Wijmo ComboBox (필수) | SelectedIndexChanged 핸들러 있음 |
| cboOperationGroup | UsrCombo | `Operation Group` | 142×20 | Wijmo ComboBox | 데이터 원천 확인 필요 |
| clbFromSite | UsrCheckedList | `From Site` | 240×21 | Wijmo MultiSelect | GetCheckedListValue(CODE) 사용 |
| cboValidYN | UsrCombo | `Valid` | 105×20 | Wijmo ComboBox | YesOrNo 연결 여부 확인 필요 |
| txtUser | TextBox | `User ID(Name)` | 150×24 | 텍스트 입력 | – |
| txtItemId | UsrMultiLineEditor | `Model` | 160×21 | 다중행 입력 | btnItemId_Click 에서 값 설정 |
| btnItemId | UsrButton | (layoutControlItem4.Text = `layoutControlItem2`) | 39×24 | 아이콘 버튼 | 라벨 표시 여부 확인 필요 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | – | 1192×582 | Wijmo FlexGrid | 시트 `Shipment Model PIC` |
| usrButton1 | UsrButton | – | 75×23 | 확인 필요 | parent 없음, 사용 여부 확인 필요 |
| usrConditionPanel1 | UsrConditionPanel | – | 1192×67 | 조회조건 패널 | UsrPanelType = HidePanel |
| imageList1 | ImageList | – | – | 아이콘 자원 | 이미지 CellType 과의 관계 확인 필요 |

## 2. 화면 배치

- props.csv 에 **SplitContainer 가 없습니다**(Orientation·SplitterDistance 값 없음). 좌/우 분할은 없습니다.
- 상/하 구성:
  - 상단: `usrConditionPanel1` Dock = Top, 1192×67 (안쪽 `usrLayoutControl2` Dock = Fill, 1192×67, layoutControlGroup2 1192×73)
  - 하단: `spdMain` Dock = Fill, 1192×582
  - 높이 비율(크기 값 기준): 67 : 582 ≈ 10.3% : 89.7%
- 조회조건 레이아웃 항목 크기(LayoutControlItem): Division 244×25, Operation Group 240×25, From Site 301×25, Valid 139×25, emptySpaceItem2 248×25 (높이 25 줄) / User ID(Name) 240×28, Model 201×28, btnItemId 43×28, emptySpaceItem1 688×28 (높이 28 줄). 높이 값 기준 2줄로 보이지만 실제 배치 좌표는 Fact Pack에 없음 → **확인 필요**.

## 3. 시트별 Grid 컬럼 — `Shipment Model PIC`

- 연결 규칙: META+코드연결 (AddSheet 208줄, SetSheetHeaderColumn 222줄)
- 컬럼헤더 행 수: 1 (SetSheetHeaderColumn 인자). AddSheet 인자 `1, 1, 30` 의 의미는 확인 필요.
- grid_effective 기준 21컬럼. 모든 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)에서 **기본 표시**.

| # | COLUMN_NAME | 라벨 | 출처 | Division별 표시 |
|---:|---|---|---|---|
| 1 | CREATED_BY | Created By | META | 전체 기본 |
| 2 | CREATION_DATE | Creation Date | META | 전체 기본 |
| 3 | DIVISION_ID | Division | META | 전체 기본 |
| 4 | FROM_SITE | From Site | META | 전체 기본 |
| 5 | ITEM_ID | Model | META | 전체 기본 |
| 6 | LAST_UPDATE_DATE | Last Update Date | META | 전체 기본 |
| 7 | LAST_UPDATED_BY | Last Updated By | META | 전체 기본 |
| 8 | MAIL_USER1 | Mail User1 | META | 전체 기본 |
| 9 | MAIL_USER2 | Mail User2 | META | 전체 기본 |
| 10 | MAIL_USER3 | Mail User3 | META | 전체 기본 |
| 11 | MAIL_USER4 | Mail User4 | META | 전체 기본 |
| 12 | MAIL_USER5 | Mail User5 | META | 전체 기본 |
| 13 | NICK_NAME | Nick Name | META | 전체 기본 |
| 14 | OPERATION_GROUP | Operation Group | META | 전체 기본 |
| 15 | PART_LEADER | Part Leader | META | 전체 기본 |
| 16 | PART_LEADER_NAME | Part Leader Name | META | 전체 기본 |
| 17 | TEAM_LEADER | Team Leader | META | 전체 기본 |
| 18 | TEAM_LEADER_NAME | Team Leader Name | META | 전체 기본 |
| 19 | USER_ID | User ID* | META | 전체 기본 |
| 20 | USER_NAME | User Name | META | 전체 기본 |
| 21 | VALID_YN | Valid* | META | 전체 기본 |

> 위 순서는 grid_effective.csv 의 행 순서(알파벳순)입니다. 실제 표시 순서·폭·정렬·편집 여부(COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, CELL_CONTROL_OBJECT_TYPE_CODE 등)는 Fact Pack에 값이 없습니다 → **확인 필요**(SCM_MST_SHEET_COLUMNS 원문 대조).

### 코드 하드코딩 / 표시 변경
| 줄 | 내용 | 대상 컬럼 |
|---|---|---|
| InitSpread 225, 226, 227, 229, 230, 231, 232, 233 | `CellType = cellTypeImage` (조건: SheetName == "Shipment Model PIC") | 확인 필요 (8건. 사용자 선택용 이미지 셀일 수 있으나 추정이므로 원문 확인 필요) |
| Designer 411~414 | 컬럼헤더: HorizontalAlignment General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced, VerticalAlignment General | 헤더 전체 |

- 코드로 추가하는 컬럼은 없습니다. 숨김으로 바꾸는 변경도 없습니다.

## 4. 시트 연결 규칙

- 시트 1개(`Shipment Model PIC`)이므로 시트 간 연결(마스터-디테일)은 없습니다.
- 그리드 이벤트: `SpdMain_CellDoubleClick`, `SpdMain_TopChange`. 동작 내용은 확인 필요입니다.
