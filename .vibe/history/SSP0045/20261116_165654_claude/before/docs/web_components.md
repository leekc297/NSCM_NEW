# SSP0045 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 화면 배치

| 영역 | 컨트롤 | Dock | Size | 비율(세로) |
|---|---|---|---|---:|
| 상단 조회조건 | `usrConditionPanel1` (PanelType=HidePanel) → `usrLayoutControl2`(Fill) | Top | 1129×75 | 약 11.6% (75/649) |
| 하단 Grid | `spdMain` (FpSpread) | Fill | 1129×574 | 약 88.4% (574/649) |

- SplitContainer 없음(props.csv 에 Orientation·SplitterDistance 미존재) → **상(조회조건)/하(Grid 단일)** 2단 구성.
- 조회조건 패널 PanelType = `HidePanel` (접기 가능 패널로 보임, TO-BE 동작은 확인 필요).

## 2. 컨트롤 → 컴포넌트 매핑

| AS-IS 컨트롤 | 유형 | 라벨(원문) | 라벨 출처 | Size | TO-BE 컴포넌트 후보 |
|---|---|---|---|---|---|
| cboBizType | UsrCombo | `Operation Group*` | lblCombo.Text | 145×20 | ComboBox (필수 표시) |
| cboDivision | UsrCombo | `Division*` | lblCombo1.Text | 162×20 | ComboBox (필수 표시) |
| cboBucketType | UsrCombo | `Bucket` | lblBucket.Text | 172×20 | ComboBox (값: DAILY/WEEKLY/MONTHLY — SetSpreadColumn 비교값) |
| txtItem_Id | UsrMultiLineEditor | `Model` | lblItemId.Text | 100×21 | 멀티라인 입력(다건 입력) |
| btnItem_Id | UsrButton | (텍스트 없음) | layoutControlItem4 | 39×25 | 검색 팝업 버튼 (Model 선택 → txtItem_Id 반영, 1198줄) |
| drpPeriod | UsrDateRangePicker | `Period*` | layoutControlItem6.Text | 207×20 | DateRange (Enabled=false, CreateSpread:291) |
| clbFromSite | UsrCheckedList | `From Site` | layoutControlItem3.Text | 151×21 | MultiSelect 체크 콤보 |
| chkSum | UsrCheckBox | `Sum` | 컨트롤 Text | 180×20 | CheckBox (변경 시 Grid 컬럼 표시 재계산) |
| usrButton1 | UsrButton | (미추출) | - | 75×23 | **확인 필요** (parent 없음) |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | 시트 `Shipment Request` | AddSheet | 1129×574 | Wijmo FlexGrid (3단 컬럼 헤더) |
| emptySpaceItem1/3 | EmptySpaceItem | - | - | 244×29 / 456×26 | 레이아웃 여백 |
| imageList1 | ImageList | - | - | - | 해당 없음 |

## 3. 시트별 Grid 컬럼 — `Shipment Request`

연결 규칙: **META+코드연결** (메타 시트를 코드가 AddSheet/ChangeSheet 로 사용). 헤더 3행(`SetSheetHeaderColumn(siMain, 3)`).

### 3-1. 메타 컬럼 (SCM_MST_SHEET_COLUMNS 18행, grid_effective 기준)

| # | 컬럼 | 라벨 | 소스 | 전 division(40/81/81_HD/81_HG/81_HM/81_ST/81_UC/82/EE/EE_HD/EE_HG/EE_HM/EE_ST/EE_UC) |
|---:|---|---|---|---|
| 1 | DIVISION_ID | Division* | META | 기본(표시) |
| 2 | FCST_TYPE | FCST Type | META | 기본 |
| 3 | FROM_SITE | From Site* | META | 기본 |
| 4 | INCOTERMS | Incoterms* | META | 기본 |
| 5 | ITEM_ID | Model* | META | 기본 (InsertRow 시 BODItemProjectRoute 콤보) |
| 6 | LAST_UPDATED_BY | Requestor | META | 기본 |
| 7 | LT_DAY | L/T(Day) | META | 기본 |
| 8 | MEASURE_LABEL | Measure | META | 기본 |
| 9 | NICK_NAME | Nick Name | META | 기본 |
| 10 | PROJECT_CODE | Project Code | META | 기본 |
| 11 | TO_SITE | To Site* | META | 기본 |
| 12 | TR_MODE | Trans Mode* | META | 기본 |
| 13 | BOD_FROM_YYYYMMDD | BOD_FROM_YYYYMMDD | META | 숨김 |
| 14 | BOD_ID | BOD_ID | META | 숨김 |
| 15 | BOD_TO_YYYYMMDD | BOD_TO_YYYYMMDD | META | 숨김 |
| 16 | FROZEN_YYYYMMDD | FROZEN_YYYYMMDD | META | 숨김 |
| 17 | MEASURE | Measure* | META | 숨김 |
| 18 | MEASURE_COLOR | MEASURE_COLOR | META | 숨김 |

- 표시 12 / 숨김 6. **division별 표시 차이 없음**(14개 division 모두 12).
- 메타 표 순서는 grid_effective.csv 순서(알파벳)이며, 실제 화면 표시 순서(SORT_ORDER)는 **확인 필요**.
- 측정값 메타 `SCM_MST_SHEET_MEASURE` 9행(전 division 9/0) — 측정값 이름은 미첨부, **확인 필요**.

### 3-2. 코드 생성 날짜 컬럼 (DB 루프, InitSpreadDateColumn)

| 조건 | API | 폭 | 표시 | 비고 |
|---|---|---:|---|---|
| 컬럼명에 `B_` 포함 (`IndexOf("B_") > 0`) | AddTextColumn | 0 | false | 354줄 |
| 그 외 | AddNumColumn | 70 | true | 358줄 |
| DAY_CODE = SAT | ForeColor Blue | - | - | 362줄 |
| DAY_CODE = SUN | ForeColor Red | - | - | 362줄 |

- 컬럼 원천: `SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과의 COLUMN_NAME / COLUMN_LABEL_NAME / DAY_CODE / LARGE_CLASS_LABEL_NAME / SMALL_CLASS_LABEL_NAME.
- 헤더 3단 Span: 0행 = 대분류(LARGE_CLASS) 묶음, 1행 = 소분류(SMALL_CLASS) 묶음, 대분류·소분류 그룹 시작 열마다 `"SUM"` 헤더(368~396줄).

### 3-3. 버킷·Sum 에 따른 컬럼 표시 (SetSpreadColumn, 컬럼 Tag 접두어 기준)

| cboBucketType | Tag 조건 | Visible | 줄 |
|---|---|---|---:|
| DAILY | `D_` 또는 `W_` 로 시작 | true | 1140 |
| DAILY | `M_` 또는 `W_` 로 시작 | chkSum.Checked | 1144 |
| WEEKLY | `D_` | false | 1149 |
| WEEKLY | `W_` | true | 1152 |
| WEEKLY | `M_` | chkSum.Checked | 1156 |
| MONTHLY | `D_` 또는 `W_` | false | 1161 |
| MONTHLY | 그 외 | true | 1164 |

> DAILY 에서 `W_` 가 1140·1144 두 조건에 모두 해당 — 최종 값은 if/else 구조 실행 확인 필요.

### 3-4. 헤더 기본 스타일 (Designer.cs 580~583)
HorizontalAlignment=General, VerticalAlignment=General, NoteIndicatorColor=Red, Parent=`ColumnHeaderDefaultEnhanced`.

## 4. 시트 연결 규칙
- 시트는 `Shipment Request` 1개(`SpdSheet.shtMain`). 마스터-디테일 연결 없음.
- 조회 시 `FindData_Main` 이 `InitSpread_2` 로 시트를 다시 초기화(메타 헤더 + 날짜 컬럼 재생성) 후 데이터 바인딩.
- `ITEM_ID` 셀: 행 추가(InsertRow/InsertRow2) 시 `Division`·`Operation Group` 조건의 BODItemProjectRoute 목록으로 콤보 셀 설정(시트 잠금이 아닐 때만).
- PlantSiteByDivision 결과(CODE/NAME, InitSpread_2:299~303)의 사용 컬럼(FROM_SITE/TO_SITE 콤보 여부)은 **확인 필요**.
