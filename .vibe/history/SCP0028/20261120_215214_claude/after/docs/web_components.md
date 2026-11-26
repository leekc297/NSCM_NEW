# SCP0028 웹 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 컴포넌트 매핑

| AS-IS 컨트롤 | 유형 | 라벨 (원문) | 근거 | TO-BE 후보 | 데이터 |
|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Division*` | LayoutControlItem `Division`.Text (Designer:472) | 단일 ComboBox (필수 `*`) | 바인딩 엔드포인트 미추출 (**확인 필요**). 변경 시 Site 목록 재조회 |
| cboOperationGroup | UsrCombo | `Operation Group` | layoutControlItem1.Text (492) | 단일 ComboBox | 데이터 소스 **확인 필요** |
| clbFromSite | UsrCheckedList | `From Site` | layoutControlItem7.Text (504) | 멀티 체크 ComboBox | `CommonDataList` [code=FromSiteByDivision] (바인딩 대상 **확인 필요**) |
| clbToSite | UsrCheckedList | `To Site` | layoutControlItem4.Text (711) | 멀티 체크 ComboBox | `CommonDataList` [code=ToSiteByDivision] (바인딩 대상 **확인 필요**) |
| clbTransMode | UsrCheckedList | `Trans Mode` | layoutControlItem6.Text (516) | 멀티 체크 ComboBox | `CommonDataList` [code=LookupCommon] 추정 (**확인 필요**) |
| txtItemId | UsrMultiLineEditor | `Model` | layoutControlItem3.Text (528) | 멀티라인 입력 | `btnItemId_Click`이 값을 채움(256) |
| btnItemId | UsrButton | 텍스트 없음 | layoutControlItem11 (Text 미설정) | 검색 아이콘 버튼 | `btnItemId_Click` |
| cboValid | UsrComboBox | `Valid` | layoutControlItem9.Text (560) | 단일 ComboBox | `biz:CommonData.YesOrNo` (DataBind, 135) |
| btnInput | UsrButton | `Input` | btnInput.Text (401) | 화면 버튼 | `SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` |
| btnDelete | UsrButton | `Delete` | btnDelete.Text (437). 단, 감싸는 layoutControlItem2.Text는 `layoutControlItem5`(604) | 화면 버튼 | `SCP0028_SAVE_SHIPMENT_LOT_SIZE` → 재조회 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | – | – | Wijmo FlexGrid (메타 기반) | 시트 `Shipment Lot Size` |
| usrConditionPanel1 | UsrConditionPanel | – | `UsrPanelType = HidePanel` (117) | 접이식 조회조건 영역 | – |
| 조회·저장 | 프레임워크 버튼 | FindButton / SaveButton | flow.csv | 공통 툴바 Search / Save | GET / SAVE SP |

## 2. 화면 배치

- `props.csv`에 SplitContainer가 없어 Orientation·SplitterDistance 값은 없습니다. 영역은 Dock으로 나뉩니다.

| 영역 | 컨트롤 | Dock | Size |
|---|---|---|---|
| 상단 조회조건 | usrConditionPanel1 (내부 usrLayoutControl2 Fill) | Top | 1093 × 72 |
| 하단 Grid | spdMain | Fill | 1093 × 502 |

- 상/하 높이 비율(디자인 기준)은 72 : 502이며, 합계 574 기준 약 12.5% : 87.5%입니다. 좌/우 분할은 없습니다.
- 조회조건 레이아웃 그룹 `layoutControlGroup2`의 Size는 1093 × 78로 패널(72)과 다릅니다.
- 조회조건 항목 Size(폭×높이 29):

| 항목 | 폭 |
|---|---:|
| Division* | 217 |
| Operation Group | 228 |
| From Site | 241 |
| Trans Mode | 241 |
| To Site | 214 |
| Model | 174 |
| btnItemId | 43 |
| Valid | 228 |
| Input | 75 |
| Delete | 75 |
| 빈 공간 1/2/3/4 | 10 / 145 / 242 / 13 |

- 항목의 행·열 배치 순서(Location)는 Fact Pack에 없어 **확인 필요**입니다.
- `usrLayoutControl1`(Fill, 657×184)과 `layoutControlGroup1`은 parent가 비어 있어 실제 표시 여부를 **확인 필요**합니다.

## 3. 시트별 Grid 컬럼 — `Shipment Lot Size`

- 연결 규칙: `META+코드연결` (`AddSheet` 176 → `SetSheetHeaderColumn` 186, 헤더 1행)
- 코드 하드코딩 컬럼은 0개입니다. 코드는 컬럼헤더 스타일만 변경합니다(Designer 633~636).
- 아래 표는 grid_effective.csv 기준이며 14개 division이 모두 같습니다.

| # | COLUMN | 라벨 | 소스 | 표시 (전 division) |
|---:|---|---|---|---|
| 1 | CREATED_BY | Created By | META | 기본 |
| 2 | CREATION_DATE | Creation Date | META | 기본 |
| 3 | DIVISION_ID | Division | META | 기본 |
| 4 | FROM_SITE | From Site | META | 숨김 |
| 5 | FROM_SITE_DESCRIPTION | From Site | META | 기본 |
| 6 | INCREMENT | Increment* | META | 기본 |
| 7 | ITEM_ID | Model | META | 기본 |
| 8 | LAST_UPDATE_DATE | Last Update Date | META | 기본 |
| 9 | LAST_UPDATED_BY | Last Updated By | META | 기본 |
| 10 | LOT_SIZE | Lot Size* | META | 기본 |
| 11 | NICK_NAME | Nick Name | META | 기본 |
| 12 | OPERATION_GROUP_ID | Operation Group | META | 기본 |
| 13 | SPLIT_YN | Container Split* | META | 기본 |
| 14 | TO_SITE | To Site | META | 숨김 |
| 15 | TO_SITE_DESCRIPTION | To Site | META | 기본 |
| 16 | TRANS_MODE_CODE | Trans Mode | META | 숨김 |
| 17 | TRANS_MODE_NAME | Trans Mode | META | 기본 |
| 18 | VALID_YN | Valid* | META | 기본 |

- 위 `#`는 CSV 행 순서이며 실제 표시 순서가 아닙니다. 실제 순서는 메타의 정렬 컬럼으로 **확인 필요**합니다.
- 표시 컬럼은 15개(전 division 15/0, 필수+기본/선택)이고, 숨김은 코드 컬럼 3개(FROM_SITE, TO_SITE, TRANS_MODE_CODE)입니다. 각 코드 컬럼에는 설명 컬럼(…_DESCRIPTION / TRANS_MODE_NAME)이 함께 표시됩니다.
- 라벨의 `*`(Increment*, Lot Size*, Container Split*, Valid*)는 메타 COLUMN_LABEL_NAME 원문입니다. 필수 입력 검증 로직은 Fact Pack에 없어 **확인 필요**입니다.
- 셀 편집 유형(CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE), 폭, 정렬, 고정 컬럼은 `SetSheetHeaderColumn`이 메타에서 읽지만 컬럼별 값은 Fact Pack에 없습니다(dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv 확인 필요).

## 4. 시트 연결 규칙

| 시트 | 생성 | 메타 연결 | 다른 시트 연계 |
|---|---|---|---|
| Shipment Lot Size | `AddSheet` (CreateSpread:176) | `SetSheetHeaderColumn` (InitSpread:186) | 단일 시트, 연계 없음 |
