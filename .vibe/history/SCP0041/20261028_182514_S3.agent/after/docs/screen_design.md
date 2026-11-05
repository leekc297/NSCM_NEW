# SCP0041 화면설계서 (As-is `SCP0041_StockOSP` → TO-BE React + Wijmo + Oracle)

> 근거: Fact Pack(controls.csv, props.csv, events.csv, flow.csv, grid_effective.csv, grid_code.csv)과 1차 분석서. 없는 사실은 **확인 필요**로 표기했습니다.
> 엔드포인트 이름은 업무분석서 §5와 같고, 컨트롤명은 단위테스트 절차 열에서 그대로 씁니다.

## 1. 화면 개요

| 항목 | 내용 |
|---|---|
| 화면 ID | SCP0041 |
| 화면 명칭(폼 Text) | `Plant Qty` (Designer:765) |
| 클래스 | `SCP0041_StockOSP` |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행 존재) |
| 시트 | `Osp Stock`(인덱스 0, 처음 활성), `Pack Hold Stock`(인덱스 1) |
| Grid 구성 방식 | META(프레임워크, SCM_MST_SHEET_COLUMNS) + 코드 표시 변경(ColumnHeader 기본 스타일) |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (props.csv + controls.csv parent 체인)

- props.csv에 **SplitContainer가 없습니다**(Orientation·SplitterDistance 속성 0건). 화면은 Dock으로 위아래로 나뉩니다.
- 높이 비율: 조회조건 48 / 그리드 554, 합계 602 → **상 8% : 하 92%**.

```
this (SCP0041_StockOSP, Text "Plant Qty")
├─ [상] usrConditionPanel1  (UsrConditionPanel, Dock=Top, 1469×48, UsrPanelType=HidePanel)   ≈ 8%
│    └─ usrLayoutControl2   (UsrLayoutControl, Dock=Fill, 1469×48, Text "usrLayoutControl2")
│         └─ layoutControlGroup2 (1469×49)  ※ 아래 항목의 parent는 controls.csv에서 공란 — 그룹 소속은 Designer 관례상 추정
│              ├─ Division            75×29  → cboDivision     "Division*"
│              ├─ layoutControlItem7 172×29  → clbPlantSite    "Plant Site"
│              ├─ emptySpaceItem1     12×29
│              ├─ lblItemId          141×29  → txtItemId       "Model"
│              ├─ layoutControlItem4  43×29  → btnItemId       (Text 없음)
│              ├─ layoutControlItem1 103×29  → btnExcelUpload  (버튼 Text "Upload")
│              ├─ layoutControlItem2 103×29  → formDown        (버튼 Text "Excel Form", 항목 Text "layoutControlItem1")
│              ├─ layoutControlItem5 260×29  → dCalendar       "Period*"
│              ├─ layoutInspection   166×29  → txtInspection   "Inspection" (런타임 DefPackLabel.INSEPECTION_ID)
│              ├─ layStatus          114×29  → cboStatus       "Status"
│              └─ layoutCutoffDate   260×29  → dCalendarCutoff "Cutoff Date"
├─ [하] spdMain  (FpSpread, Dock=Fill, 1469×554)                                               ≈ 92%
│    ├─ 시트 탭 0: Osp Stock        (AddSheet SpdSheet.shtMain)
│    ├─ 시트 탭 1: Pack Hold Stock  (AddSheet SpdSheet.shtPacker)
│    └─ spdMain_Sheet1 (SheetView, Designer 기본 시트)
└─ (부모 없음) usrButton1 (UsrButton, 75×23) — 화면에 배치되지 않음, 용도 확인 필요
```

- 항목 너비 합계는 75+172+12+141+43+103+103+260+166+114+260 = 1449로, 그룹 너비 1469 안에 한 줄로 들어갑니다. 실제 좌표(Location)와 배치 순서는 Fact Pack에 없어 **확인 필요**입니다(위 순서는 controls.csv 선언 순서). 높이 29 한 줄은 패널 높이 48과 맞습니다.

### 2-2. 텍스트 와이어프레임

```
┌───────────────────────────────────────────────────────────────────────────────────────────────┐
│ [조회조건 usrConditionPanel1 · HidePanel · 8%]                                               │
│ Division*[cboDivision▼] Plant Site[clbPlantSite▼] Model[txtItemId][btnItemId]                │
│ [Upload] [Excel Form] Period*[dCalendar ~ ] Inspection[txtInspection] Status[cboStatus▼]     │
│ Cutoff Date[dCalendarCutoff ~ ]          (※ 실제 순서·줄바꿈 확인 필요)                     │
├───────────────────────────────────────────────────────────────────────────────────────────────┤
│ [그리드 spdMain · 92%]                                                                        │
│  ┌ Osp Stock ┐┌ Pack Hold Stock ┐                                                           │
│  │ 메타 컬럼 14 / 15개                                                                        │
│  └────────────────────────────────────────────────────────────────────────────────────────── │
└───────────────────────────────────────────────────────────────────────────────────────────────┘
[툴바(공통)] Find · Save · Edit  (오버라이드 FindButton / SaveButton / EditButton)
[팝업] btnItemId → 모델 검색 팝업(종류 확인 필요)
```

## 3. 컨트롤 명세

| # | 컨트롤명 | 타입 | 라벨 (props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|
| 1 | `usrConditionPanel1` | UsrConditionPanel | - | HidePanel, Dock Top | - | - | 공용 조회조건 영역 |
| 2 | `usrLayoutControl2` | UsrLayoutControl | `"usrLayoutControl2"` | Dock Fill | - | - | 조회조건 레이아웃(공용) |
| 3 | `cboDivision` | UsrCombo | `"Division*"` (Division 항목) | 확인 필요 | Y (`*`) | `CboDivision_SelectedIndexChanged` | 공용 Division 콤보 |
| 4 | `clbPlantSite` | UsrCheckedList | `"Plant Site"` (layoutControlItem7) | 확인 필요 | N | (GetCheckedListValue CODE) | 공용 멀티선택 콤보 |
| 5 | `txtItemId` | UsrMultiLineEditor | `"Model"` (lblItemId) | 공란(확인 필요) | N | `BtnItemId_Click` 결과 반영(:882) | 멀티라인 입력 |
| 6 | `btnItemId` | UsrButton | (Text 없음, layoutControlItem4) | - | - | `BtnItemId_Click` | 모델 검색 팝업 버튼 |
| 7 | `btnExcelUpload` | UsrButton | `"Upload"` | - | - | `btnExcelUpload_Click` | 엑셀 업로드 버튼 |
| 8 | `formDown` | UsrButton | `"Excel Form"` (항목 Text `"layoutControlItem1"`) | - | - | `btnExcelFormDownload_Click` | 엑셀 양식 다운로드 버튼 |
| 9 | `dCalendar` | UsrDateRangePicker3 | `"Period*"` (layoutControlItem5) | PERIOD_DEFAULT FROM/TO(적용 대상 확인 필요) | Y (`*`) | (setPeriod) | 공용 기간 컨트롤 |
| 10 | `txtInspection` | UsrMultiLineEditor | `"Inspection"` → 런타임 `DefPackLabel.INSEPECTION_ID` | 확인 필요 | N | - | 멀티라인 입력 |
| 11 | `cboStatus` | UsrCombo | `"Status"` (layStatus) | 확인 필요 | N | - | 공용 콤보 |
| 12 | `dCalendarCutoff` | UsrDateRangePicker3 | `"Cutoff Date"` (layoutCutoffDate) | 확인 필요 | N | (setPeriod 대상 여부 확인 필요) | 공용 기간 컨트롤 |
| 13 | `spdMain` | FpSpread | - | 활성 시트 0 (`Osp Stock`) | - | `SpdMain_SheetTabClick`, `SpdMain_EditChange`, `ActiveSheet_CellChanged`(siMain.ActiveSheet) | Wijmo FlexGrid + 시트 탭 |
| 14 | `spdMain_Sheet1` | SheetView | - | Designer 기본 시트 | - | - | (FlexGrid 내부, 별도 컴포넌트 없음) |
| 15 | `usrButton1` | UsrButton | (Text 없음, Size 75×23) | - | - | 없음 | 없음(부모 미지정 → 용도 확인 필요) |

## 4. 그리드 명세

공통: 모든 컬럼은 `SetSheetHeaderColumn`(SetSpreadInit:211)이 메타 `SCM_MST_SHEET_COLUMNS`로 생성합니다(출처 META). 14개 division 모두 `기본` 표시이며 division마다 다르지 않습니다. 타입·편집 가능 여부·폭·정렬은 메타 컬럼(CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE 등) 원문이 Fact Pack에 없어 **확인 필요**입니다.

### 4-1. `Osp Stock` (14컬럼, 조회 `SCP.SCP0041_GET_STOCK_OSP`)

| # | 컬럼 | 헤더 | 타입 | 출처 | division별 표시 | 편집 |
|---:|---|---|---|---|---|---|
| 1 | ATTRIBUTE1 | Valuation Type | 확인 필요 | META | 14개 전부 표시 | 확인 필요 |
| 2 | ATTRIBUTE2 | Cell From Site | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 3 | ATTRIBUTE3 | Box | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 4 | COMMENT | Comment | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 5 | CREATED_BY | Created By | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 6 | CREATION_DATE | Creation Date | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 7 | DIVISION_ID | Division* | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 8 | ITEM_ID | Model* | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 9 | LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 10 | LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 11 | NICK_NAME | Nick Name | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 12 | QTY | Qty* | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 13 | SITE_DESCRIPTION | Plant Site* | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 14 | YYYYMMDD | Date* | 확인 필요 | META | 전부 표시 | 확인 필요 |

※ 순서는 grid_effective.csv 행 순서입니다. 실제 표시 순서는 메타 원문 **확인 필요**. 현행 경로에는 이 시트의 저장 경로가 없습니다.

### 4-2. `Pack Hold Stock` (15컬럼, 조회 `SCP.SCP0041_GET_PACK_HOLD_STOCK` / 저장 `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK`)

| # | 컬럼 | 헤더 | 타입 | 출처 | division별 표시 | 편집 |
|---:|---|---|---|---|---|---|
| 1 | CREATION_DATE | Create Date | 확인 필요 | META | 14개 전부 표시 | 확인 필요 |
| 2 | CUTOFF_DATE | Cutoff Date | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 3 | DATE_FINISH_REAL | 실제 완료일 | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 4 | DATE_FORECAST_FINISH | 예상 완료일 | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 5 | DATE_FORECAST_START | 예상 시작일 | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 6 | DIR | Status | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 7 | INSPECTION_ID | 관리번호 | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 8 | MODIFIER | 수정자 | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 9 | MODIFIER_DATE | Change Date | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 10 | NICK_NAME | Nick Name | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 11 | PLANT_ID | PLANT | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 12 | PROD_ID | Model | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 13 | QTY | 수량 | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 14 | REQUSET_USER | 변경점 신청자 | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 15 | SITE_DESCRIPTION | Plant Site | 확인 필요 | META | 전부 표시 | 확인 필요 |

※ `REQUSET_USER`는 메타 원문 표기를 그대로 옮겼습니다. 헤더에 한국어와 영어가 섞여 있습니다(메타 원문).

### 4-3. 코드로 바꾸는 표시 (HARDCODED/EXPR, Designer)

| 줄 | 속성 | 값 | 범위 |
|---:|---|---|---|
| 665 | HorizontalAlignment | General | ColumnHeader 기본 스타일 |
| 666 | NoteIndicatorColor | Red | ColumnHeader 기본 스타일 |
| 667 | Parent | ColumnHeaderDefaultEnhanced | ColumnHeader 기본 스타일 |
| 668 | VerticalAlignment | General | ColumnHeader 기본 스타일 |

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 Load | `Form_Load` | InitControls > GetLookupData | `SCM.SCM0001_GET_LOOKUP_VALUES` | 룩업 바인딩(대상 컨트롤 확인 필요) |
| A2 | 화면 Load | `Form_Load` | InitControls > setPeriod (PERIOD_DEFAULT) | `biz:CommonData.CommonDataList` | FROM_VALUE/TO_VALUE를 기간 컨트롤에 설정 |
| A3 | 시트 탭 클릭 | `SpdMain_SheetTabClick` | SetSelectMenu > setPeriod | `biz:CommonData.CommonDataList` | 기간 기본값 다시 설정. 조회조건 표시 전환 확인 필요 |
| A4 | 툴바 Find | FindButton (오버라이드) | FindData_Main | `SCP.SCP0041_GET_STOCK_OSP` | `Osp Stock` 시트 바인딩 |
| A5 | 툴바 Find | FindButton (오버라이드) | FindData_Pack | `SCP.SCP0041_GET_PACK_HOLD_STOCK` | `Pack Hold Stock` 시트 바인딩 (A4·A5 분기 방식 확인 필요) |
| A6 | 툴바 Save | SaveButton (오버라이드) | SaveDataPacker → FindData_Pack | `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` → `SCP.SCP0041_GET_PACK_HOLD_STOCK` | 저장 후 `Pack Hold Stock` 재조회 |
| A7 | 툴바 Edit | EditButton (오버라이드) | `iFocusTabIndex == 1`일 때 GetSheetInfo | 없음 | 편집 모드 |
| A8 | btnItemId 클릭 | `BtnItemId_Click` | 모델 검색 → `txtItemId.Text = sItemId` | 없음(추출 안 됨) | txtItemId 값 설정 |
| A9 | cboDivision 변경 | `CboDivision_SelectedIndexChanged` | 확인 필요 | 추출 안 됨 | 확인 필요 |
| A10 | btnExcelUpload 클릭 | `btnExcelUpload_Click` | 확인 필요 | 추출 안 됨 | 확인 필요 |
| A11 | formDown 클릭 | `btnExcelFormDownload_Click` | 확인 필요 | 추출 안 됨 | 확인 필요 |
| A12 | spdMain 셀 편집 | `SpdMain_EditChange` | 확인 필요 | 없음 | 확인 필요 |
| A13 | ActiveSheet 셀 변경 | `ActiveSheet_CellChanged` | 확인 필요 | 없음 | 확인 필요 |
| A14 | (진입점 없음) | SaveData | 미도달 | `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` | **현행 UI 액션 아님** — TO-BE 이관 제외 후보(확인 필요) |

## 6. 검증·메시지

| 항목 | 사실 |
|---|---|
| 필수 표기 | `Division*`, `Period*` (라벨). 검증 코드·메시지 ID는 **확인 필요** |
| 그리드 필수 표기 | `Osp Stock` 헤더 `Division*`, `Model*`, `Qty*`, `Plant Site*`, `Date*` (메타 라벨). 검증 로직은 **확인 필요** |
| 저장 성공/실패 메시지 | Fact Pack에 없음 → **확인 필요** |
| 빈 결과 메시지 | Fact Pack에 없음 → **확인 필요** |

## 7. 권한 (C/R/U/D) 사실

| 구분 | 사실 |
|---|---|
| R | FindButton 오버라이드 → `SCP.SCP0041_GET_STOCK_OSP`, `SCP.SCP0041_GET_PACK_HOLD_STOCK` |
| U | SaveButton 오버라이드 → `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` (UPDATE SCM_DNM_STOCK_LOT_CONTROL) |
| 편집 진입 | EditButton 오버라이드 (`iFocusTabIndex == 1`) |
| C / D | 업무 테이블 INSERT/DELETE 경로 추출 없음 |
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 9행 (내용 **확인 필요**) |

## 8. To-Be 전환 메모 (Wijmo·Oracle 관점)

| # | 항목 | As-is | To-Be 메모 |
|---:|---|---|---|
| M1 | 그리드 | FpSpread `spdMain` + 시트 2개 | Wijmo FlexGrid + 탭 2개(`Osp Stock`, `Pack Hold Stock`). 컬럼은 메타 기반 공통 구성 사용 |
| M2 | 조회조건 | UsrConditionPanel(HidePanel) + LayoutControl | 공용 조회조건 영역. Radio/Check 없음 |
| M3 | 다중값 분해 | SP 내부 `STRING_SPLIT`(MSSQL) | Oracle에는 같은 함수가 없음 → PKG 안에서 대체 구현 필요(방식은 프로젝트 공통 규칙에 따름) |
| M4 | 배열 분해 | `SCM_ARR_SPL_CNT`/`SCM_ARR_SPL_VAL` | Oracle 대응 객체 존재 여부 **확인 필요** |
| M5 | 기간 기본값 | `biz:CommonData.CommonDataList` PERIOD_DEFAULT | 공용 기간 컨트롤 기본값 API로 옮김 |
| M6 | 미도달 코드 | SaveData → `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` | 현행 UI 액션이 아니므로 화면 기능으로 구현하지 않음(확정 전 확인 필요) |
| M7 | 엑셀 | `btnExcelUpload`, `formDown` | 업로드 대상·SP를 확인한 뒤 설계 |
| M8 | 다국어 | 헤더 한국어/영어 혼재, `DefPackLabel.INSEPECTION_ID` | LBL 매핑 필요 |

## 9. 미확정

1. FindButton 시트 분기 방식(A4·A5).
2. `btnExcelUpload_Click`·`btnExcelFormDownload_Click`·`CboDivision_SelectedIndexChanged`·`SpdMain_EditChange`·`ActiveSheet_CellChanged`의 처리 내용.
3. `BtnItemId_Click` 팝업 종류.
4. `SCM.SCM0001_GET_LOOKUP_VALUES` 결과 바인딩 컨트롤.
5. PERIOD_DEFAULT 적용 대상(`dCalendar` / `dCalendarCutoff`).
6. 조회조건 항목의 실제 배치 순서·좌표와 시트별 표시 전환.
7. 그리드 컬럼 타입·편집 가능 여부·순서(메타 원문).
8. `usrButton1` 용도, `spdMain_Sheet1`과 AddSheet 시트의 관계.
9. `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` 이관 제외 확정.
