# SCP0041 웹 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑

| As-is 컨트롤 | 유형 | 라벨(원문) | 라벨 출처 | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Division*` | LayoutControlItem `Division`.Text | 공용 Division 콤보 | 필수(`*`). SelectedIndexChanged 처리 내용 확인 필요 |
| clbPlantSite | UsrCheckedList | `Plant Site` | layoutControlItem7.Text | 공용 멀티선택 콤보 | GetCheckedListValue(CODE) 로 값 전달 |
| txtItemId | UsrMultiLineEditor | `Model` | lblItemId.Text | 멀티라인 입력 | BtnItemId_Click 결과가 Text 로 설정(:882) |
| btnItemId | UsrButton | (Text 없음) | layoutControlItem4 | 모델 검색 팝업 버튼 | 팝업 대상 확인 필요 |
| dCalendar | UsrDateRangePicker3 | `Period*` | layoutControlItem5.Text | 공용 기간(DateRange) 컨트롤 | 필수. PERIOD_DEFAULT 기본값 적용 대상 여부 확인 필요 |
| txtInspection | UsrMultiLineEditor | `Inspection` (런타임 `DefPackLabel.INSEPECTION_ID`) | layoutInspection.Text | 멀티라인 입력 | 런타임 라벨 문구 확인 필요 |
| cboStatus | UsrCombo | `Status` | layStatus.Text | 공용 콤보 | 데이터 원천 확인 필요 |
| dCalendarCutoff | UsrDateRangePicker3 | `Cutoff Date` | layoutCutoffDate.Text | 공용 기간 컨트롤 | |
| btnExcelUpload | UsrButton | `Upload` | 컨트롤 Text | 엑셀 업로드 버튼 | layoutControlItem1 의 Text 미지정 |
| formDown | UsrButton | `Excel Form` | 컨트롤 Text | 엑셀 양식 다운로드 버튼 | layoutControlItem2.Text 는 `"layoutControlItem1"`(라벨 비표시 여부 확인 필요) |
| usrButton1 | UsrButton | - | - | 없음 | 부모 미지정 — 사용 여부 확인 필요 |
| usrConditionPanel1 | UsrConditionPanel | - | - | 조회조건 영역 | HidePanel 형 |
| usrLayoutControl2 / layoutControlGroup2 / emptySpaceItem1 | 레이아웃 | - | - | 조회조건 레이아웃 | |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | - | - | Wijmo FlexGrid + 시트 탭 | 시트 2개(`Osp Stock`, `Pack Hold Stock`) |

## 2. 화면 배치

- props.csv 에 **SplitContainer 가 없습니다**(Orientation·SplitterDistance 없음).
- 배치는 Dock 기반 상/하 구성입니다.

| 영역 | 컨트롤 | Dock | Size | 비율(높이) |
|---|---|---|---|---:|
| 상단 | usrConditionPanel1 (조회조건) | Top | 1469 × 48 | 약 8% (48/602) |
| 하단 | spdMain (Grid, 시트 탭 2개) | Fill | 1469 × 554 | 약 92% (554/602) |

조회조건 배치 순서는 Designer 상 위치 좌표가 Fact Pack에 없어 **확인 필요**합니다. 너비(LayoutControlItem Size): Division 75 · Plant Site 172 · Model 141 · 모델버튼 43 · Upload 103 · Excel Form 103 · Period 260 · Inspection 166 · Status 114 · Cutoff Date 260.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

모든 컬럼의 출처는 META(SCM_MST_SHEET_COLUMNS)이고, 14개 division 전부 `기본`(표시)입니다. 코드로 추가하거나 숨기는 컬럼은 없습니다.

### 3-1. `Osp Stock` (14컬럼)

| # | COLUMN_NAME | 라벨 | 출처 | division 차이 |
|---:|---|---|---|---|
| 1 | ATTRIBUTE1 | Valuation Type | META | 없음 (전 division 기본) |
| 2 | ATTRIBUTE2 | Cell From Site | META | 없음 |
| 3 | ATTRIBUTE3 | Box | META | 없음 |
| 4 | COMMENT | Comment | META | 없음 |
| 5 | CREATED_BY | Created By | META | 없음 |
| 6 | CREATION_DATE | Creation Date | META | 없음 |
| 7 | DIVISION_ID | Division* | META | 없음 |
| 8 | ITEM_ID | Model* | META | 없음 |
| 9 | LAST_UPDATE_DATE | Last Update Date | META | 없음 |
| 10 | LAST_UPDATED_BY | Last Updated By | META | 없음 |
| 11 | NICK_NAME | Nick Name | META | 없음 |
| 12 | QTY | Qty* | META | 없음 |
| 13 | SITE_DESCRIPTION | Plant Site* | META | 없음 |
| 14 | YYYYMMDD | Date* | META | 없음 |

※ 표는 grid_effective.csv 행 순서(컬럼명 순)입니다. 실제 표시 순서·폭·정렬·편집 여부는 메타(COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, CELL_CONTROL_OBJECT_TYPE_CODE 등) 원문을 보고 **확인해야** 합니다.

### 3-2. `Pack Hold Stock` (15컬럼)

| # | COLUMN_NAME | 라벨 | 출처 | division 차이 |
|---:|---|---|---|---|
| 1 | CREATION_DATE | Create Date | META | 없음 |
| 2 | CUTOFF_DATE | Cutoff Date | META | 없음 |
| 3 | DATE_FINISH_REAL | 실제 완료일 | META | 없음 |
| 4 | DATE_FORECAST_FINISH | 예상 완료일 | META | 없음 |
| 5 | DATE_FORECAST_START | 예상 시작일 | META | 없음 |
| 6 | DIR | Status | META | 없음 |
| 7 | INSPECTION_ID | 관리번호 | META | 없음 |
| 8 | MODIFIER | 수정자 | META | 없음 |
| 9 | MODIFIER_DATE | Change Date | META | 없음 |
| 10 | NICK_NAME | Nick Name | META | 없음 |
| 11 | PLANT_ID | PLANT | META | 없음 |
| 12 | PROD_ID | Model | META | 없음 |
| 13 | QTY | 수량 | META | 없음 |
| 14 | REQUSET_USER | 변경점 신청자 | META | 없음 |
| 15 | SITE_DESCRIPTION | Plant Site | META | 없음 |

※ 컬럼명 `REQUSET_USER` 는 메타 원문 표기(오타형) 그대로입니다. 라벨에 한국어/영어가 섞여 있어(메타 원문) TO-BE 다국어 LBL 매핑을 확인해야 합니다.

### 3-3. 코드 표시/라벨 변경
| 줄 | 내용 | 적용 범위 |
|---:|---|---|
| Designer:665 | HorizontalAlignment = General | ColumnHeader 기본 스타일 |
| Designer:666 | NoteIndicatorColor = Red | ColumnHeader 기본 스타일 |
| Designer:667 | Parent = ColumnHeaderDefaultEnhanced | ColumnHeader 기본 스타일 |
| Designer:668 | VerticalAlignment = General | ColumnHeader 기본 스타일 |

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 생성 | 인덱스 | 조회 SP | 저장 SP |
|---|---|---|---:|---|---|
| `Osp Stock` | META+코드연결 | CreateSpread:174 AddSheet(SpdSheet.shtMain) | 0 (초기 활성) | SCP0041_GET_STOCK_OSP | 없음(현행 경로) |
| `Pack Hold Stock` | META+코드연결 | CreateSpread:177 AddSheet(SpdSheet.shtPacker) | 1 | SCP0041_GET_PACK_HOLD_STOCK | SCP0041_SAVE_PACKER_HOLD_STOCK |

- 두 시트는 마스터-디테일 관계가 아닌 **독립 탭**입니다(셀 선택으로 다른 시트를 조회하는 흐름이 추출되지 않음).
- 탭 전환(`SpdMain_SheetTabClick`) → SetSelectMenu → setPeriod(PERIOD_DEFAULT) 실행.
- EditButton 은 `iFocusTabIndex == 1` 조건에서만 시트 정보를 가져옵니다(편집은 `Pack Hold Stock` 전용으로 보이나 **확인 필요**).
