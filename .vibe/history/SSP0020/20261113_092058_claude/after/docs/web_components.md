# SSP0020 Web 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑

| As-is 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 컴포넌트 후보 |
|---|---|---|---|---|
| usrLabel1 (layoutControlItem3) | UsrLabel | `Division*` | 59×54 | 조회조건 라벨(필수 표시) |
| clbDivision (layoutControlItem4) | CheckedListBoxControl | (Division* 라벨 영역) | 377×40 | 다중 선택 체크 목록 (Division 다중 선택 컴포넌트) |
| chkAll (layoutControlItem1) | UsrCheckBox | `All` | 373×14 | Checkbox (Division 전체 선택) |
| txtDelegatee (lblDelegatee) | UsrMultiLineEditor | `Delegatee*` | 170×21 (Item 255×24) | 텍스트 입력 + 사용자 검색 팝업 |
| btnDelegatee (layoutControlItem2) | UsrButton | Text 없음(Fact Pack) | 38×24 | 사용자 검색(돋보기) 버튼. 아이콘은 **확인 필요** |
| drpPeriod (layoutControlItem6) | UsrDateRangePicker | `Period*` | 200×20 | 기간(From~To) DateRange 입력 |
| btnSave (lcBtnSave) | UsrButton | `SAVE` | 71×22 | Button (저장) |
| btnUnSet (lcBtnUnset) | UsrButton | `UnSet` | 71×22 | Button (해제) |
| btnMeasure (layoutControlItem10) | UsrButton | Text 없음 | 39×24 | 용도·이벤트 미배선 — **확인 필요** |
| usrButton1 | UsrButton | Text 없음 | 75×23 | parent 없음 — 미사용 여부 **확인 필요** |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | 시트 `Delegate`, `Delegated List` | 1192×566 | Wijmo FlexGrid + 시트 탭 |
| usrConditionPanel1 | UsrConditionPanel (HidePanel) | - | 1192×83 | 조회조건 패널(접기 가능) |
| usrLayoutControl2 / layoutControlGroup2 | UsrLayoutControl / LayoutControlGroup | - | 1192×73 / 1192×78 | 조건 영역 레이아웃 |
| panel1 | Panel | - | 1192×566 | Grid 컨테이너 |
| emptySpaceItem2/3/4/6 | EmptySpaceItem | - | 285×26 / 435×32 / 255×10 / 42×30 | 간격 |
| imageList1 | ImageList | - | - | 해당 없음 |

## 2. 화면 배치

- props.csv에는 SplitContainer가 없다. 분할 비율(Orientation·SplitterDistance)은 해당하지 않는다.
- 상/하 구성(Dock 기준)
  - 상단: `usrConditionPanel1` Dock=Top, 높이 83(내부 usrLayoutControl2 Dock=Top, 높이 73)
  - 하단: `panel1` Dock=Fill, 높이 566 → `spdMain` Dock=Fill
  - Designer 크기 기준 상:하 = 83 : 566 (약 12.8% : 87.2%). 실행 시 하단이 남은 영역을 채운다.
- 조건 영역 안의 컨트롤 좌표·순서는 Fact Pack에 Location이 없어 **확인 필요**.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

모든 컬럼은 메타(`SCM_MST_SHEET_COLUMNS`, `SetSheetHeaderColumn`)에서 생성된다. 코드 하드코딩 컬럼 추가는 없다.

### 3-1. `Delegate` (표시 8컬럼, 모든 division 동일)

| # | 컬럼 | 라벨 | 출처 | 표시 |
|---:|---|---|---|---|
| 1 | CHK | ALL | META | 기본 |
| 2 | DIVISION_ID | Div | META | 기본 |
| 3 | DELEGATEE | Delegatee | META | 기본 |
| 4 | FROM_DATE | From | META | 기본 |
| 5 | TO_DATE | To | META | 기본 |
| 6 | VALID | Valid | META | 기본 |
| 7 | LAST_UPDATED_BY | Last Updated By | META | 기본 |
| 8 | LAST_UPDATE_DATE | Last Update Date | META | 기본 |

> 컬럼 순서는 grid_effective.csv의 행 순서(알파벳 정렬로 보임)와 같지 않을 수 있다. 실제 순서는 메타의 컬럼 순번으로 **확인 필요**.

### 3-2. `Delegated List` (표시 7컬럼, 모든 division 동일)

| # | 컬럼 | 라벨 | 출처 | 표시 |
|---:|---|---|---|---|
| - | CHK | ALL | META | **숨김**(전 division) |
| 1 | DIVISION_ID | Div | META | 기본 |
| 2 | DELEGATOR | Delegator | META | 기본 |
| 3 | FROM_DATE | From | META | 기본 |
| 4 | TO_DATE | To | META | 기본 |
| 5 | VALID | Valid | META | 기본 |
| 6 | LAST_UPDATED_BY | Last Updated By | META | 기본 |
| 7 | LAST_UPDATE_DATE | Last Update Date | META | 기본 |

### 3-3. 코드 표시 변경

| 줄 | 대상 | 변경 |
|---:|---|---|
| InitSpread 216~218 | CHK (시트 추정 Delegated List) | CellType=chk, Value=false, Border=bevelbrdr |
| SpdMain_CellClick 859/863 | 활성 시트 컬럼 헤더 CheckBox | 헤더 클릭 시 Value true↔false 토글(전체 체크) |
| Designer 667~670 | 컬럼 헤더 기본 스타일 | Align General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced |

### 3-4. Division별 표시 차이
- 없음. 40 / 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC / 82 / EE / EE_HD / EE_HG / EE_HM / EE_ST / EE_UC 모두 Delegate 8, Delegated List 7.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 데이터 원천 | 활성화 조건 |
|---|---|---|---|
| `Delegate` | META+코드연결 (SpdSheet.shtMain) | `SSP0020_GET_DELEGATE` 결과 Tables[0] | Rows>0일 때 바인딩(290~291). `intActiveSheetIdx == 0`이면 활성(312~313) |
| `Delegated List` | META+코드연결 (SpdSheet.shtMainList) | `SSP0020_GET_DELEGATE` 결과 Tables[1] | Rows>0이고 `isReLoad == false`일 때 바인딩(299~300). `intActiveSheetIdx != 0`이면 활성(317~318) |

- 시트 탭 클릭 이벤트(`SpdMain_SheetTabClick`)의 처리 내용은 **확인 필요**.
