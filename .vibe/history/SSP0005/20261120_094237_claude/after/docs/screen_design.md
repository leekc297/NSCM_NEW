# SSP0005 — Shipment Working Day 화면설계서

> 근거: Fact Pack(SSP0005), controls.csv, props.csv, grid_code.csv, grid_effective.csv, events.csv입니다. 사실이 없는 항목은 **확인 필요**로 적었습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0005 |
| 화면 명칭(Form Text 원문) | `Working Time` (Designer.cs:501) |
| 클래스 | `SSP0005_ShipmentWorkingDay` |
| 시트 | `Shipment Working Day` |
| 메뉴 위치 | **확인 필요** (`TB_FX_MenuItemInfo` 1행, 내용 미제공) |
| 구성 방식 | HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경) |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (props.csv + controls.csv parent 체인)

- props.csv에 **SplitContainer가 없습니다**. Orientation과 SplitterDistance는 해당 사항이 없습니다.
- 분할은 Dock으로만 구성됩니다.
  - `usrConditionPanel1`: Dock=Top
  - `spdMain`: Dock=Fill
  - 상/하 2단입니다.
- 비율(Designer 기준 높이): 상단 65 / 하단 584 → 65÷649 = **10.0% : 90.0%**입니다. 하단은 Fill이므로 실제 높이는 창 크기에 따라 달라집니다.

```
this (Form, Text="Working Time")
├─ usrConditionPanel1  [UsrConditionPanel, Dock=Top, 1192×65, UsrPanelType=HidePanel]   ── 상단 10.0%
│   └─ usrLayoutControl2  [UsrLayoutControl, Dock=Fill, 1192×65]  (layoutControlGroup2 1192×70)
│        ├─ layoutControlItem4  (257×25) "Company"          → cboCompany     [UsrCombo 198×20]
│        ├─ layoutControlItem1  (257×25) "Day of the week"  → cboDayWeek     [UsrCombo 155×20]
│        ├─ layoutControlItem10 (81×25)                     → btnInput       [UsrButton 77×21, "Input"]
│        ├─ layoutControlItem6  (251×25) "Period*"          → drpPeriod      [UsrDateRangePicker 206×20]
│        ├─ lcDivision          (247×25) "Division"         → clbDivision    [UsrCheckedList 199×21]
│        ├─ lcInputValue        (247×25) "Input Value"      → cboInputValue  [UsrComboBox 174×20]
│        ├─ emptySpaceItem1 (170×25)
│        └─ emptySpaceItem2 (417×50)
└─ spdMain  [FpSpread, Dock=Fill, 1192×584]                                              ── 하단 90.0%
     └─ spdMain_Sheet1 [SheetView] → 시트 "Shipment Working Day"

(parent 없음) usrButton1 [UsrButton 75×23] — 배치 위치·표시 여부 확인 필요
```

> LayoutControlItem과 컨트롤의 연결은 props `Control` 값입니다. LayoutControlItem의 parent는 controls.csv에서 비어 있으며, usrLayoutControl2 아래 배치로 표기한 것은 Control 연결을 기준으로 했습니다. 행·열 좌표(어느 항목이 같은 행인지)는 **확인 필요**입니다.

### 2-2. 영역

| 영역 | 컨트롤 |
|---|---|
| 조회조건 | `usrConditionPanel1` > `usrLayoutControl2`: cboCompany, clbDivision, drpPeriod, cboDayWeek, cboInputValue |
| 버튼 | `btnInput`(조회조건 영역 안), 공통 FindButton·SaveButton(프레임워크), `usrButton1`(확인 필요) |
| 그리드 | `spdMain` / `spdMain_Sheet1` (시트 `Shipment Working Day`) |
| 팝업 | 추출된 팝업 없음 |

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨(props Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| `usrConditionPanel1` | UsrConditionPanel | - | UsrPanelType=HidePanel | - | - | 조회조건 패널(접기 가능 여부 확인 필요) |
| `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2` (컨트롤 Text, 표시용 아님 — 확인 필요) | - | - | - | 조회조건 레이아웃 그리드 |
| `cboCompany` | UsrCombo | `Company` (layoutControlItem4) | 확인 필요 | 확인 필요 | - | Wijmo ComboBox (데이터: `biz:CommonData.CommonDataList` [code=Company]) |
| `clbDivision` | UsrCheckedList | `Division` (lcDivision) | 확인 필요 | 확인 필요 | - | Wijmo MultiSelect (데이터: `biz:CommonData.CommonDataList` [code=MyDivision]) |
| `drpPeriod` | UsrDateRangePicker | `Period*` (layoutControlItem6) | `SCP.SCM0001_GET_SCP_PERIOD` 결과(GetDayRange:941)에 연결되는지 확인 필요 | Y (`*` 표시) | - | 기간 From~To 입력(InputDate 2개 또는 범위 컴포넌트) |
| `cboDayWeek` | UsrCombo | `Day of the week` (layoutControlItem1) | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboDayWeek_SelectedIndexChanged` | 콤보(다중 여부 확인 필요 — `GetCheckedListValue` 사용) (데이터: `biz:CommonData.CommonDataList` [code=LookupCommon]) |
| `cboInputValue` | UsrComboBox | `Input Value` (lcInputValue) | `biz:CommonData.YesOrNo` 바인딩(InitControls:168) / 선택값 확인 필요 | 확인 필요 | Enabled ← `CboDayWeek_SelectedIndexChanged`(663/666) | Wijmo ComboBox (disabled 동적 제어) |
| `btnInput` | UsrButton | `Input` | - | - | Click → `BtnInput_Click` | Button(일괄 입력) |
| `usrButton1` | UsrButton | 확인 필요(Text 미추출) | - | - | 미연결 | 확인 필요(parent 없음, 75×23) |
| `spdMain` | FpSpread | - | - | - | CellDoubleClick → `SpdMain_CellDoubleClick`, TopChange → `SpdMain_TopChange`, (dsdm) Changed → `SpdMain_Changed` | Wijmo FlexGrid |
| `spdMain_Sheet1` | SheetView | 시트 `Shipment Working Day` | - | - | - | FlexGrid 단일 시트 |

## 4. 그리드 명세 — 시트 `Shipment Working Day`

헤더 행 수는 3입니다(`SetSheetHeaderColumn(spdInfo, 3)`, 196). `AddSheet(spdMain, "Shipment Working Day", "Shipment Working Day", 3, 1, 35)`(179)의 인자 1·35가 무엇을 뜻하는지는 **확인 필요**입니다.

| # | 컬럼 | 헤더 | 타입 | 출처 | division별 표시 | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | `COMPANY_ID` | `Company` | 메타 정의(CELL 타입 확인 필요) | META (`SCM_MST_SHEET_COLUMNS`) | 14개 division 모두 기본 | 확인 필요 |
| 2 | `DIVISION_ID` | `Divison` (메타 원문 철자) | 메타 정의(CELL 타입 확인 필요) | META | 14개 division 모두 기본 | 확인 필요 |
| 3~n | `{COLUMN_NAME}` (SCP0009 결과) | `{COLUMN_LABEL_NAME}` | Combo (`YesOrNo`), 폭 70, Center/Center | DB루프(HARDCODED 로직, DB_DRIVEN 값) — `InitSpreadDateColumn`:263 | 런타임 결정(정적 미집계) | Combo 셀입니다. 잠금 여부는 **확인 필요** |

날짜 컬럼의 부가 규칙:
- 시작 위치는 `GetColumnIndex(DIVISION) + 1`입니다.
- `sColumnName.IndexOf("B_") > 0`이면 Combo 컬럼 생성 분기에서 빠집니다. B_ 분기 처리 내용은 **확인 필요**입니다.
- `DAY_CODE`가 SAT이면 ForeColor Blue, SUN이면 Red입니다(267).
- 헤더 row 0에는 `LARGE_CLASS_LABEL_NAME`, row 1에는 `SMALL_CLASS_LABEL_NAME`을 `ColumnHeaderSpan`으로 병합하며 높이는 20입니다(274·280·290·301·303).
- 헤더 더블클릭: `M_` → `W_` 컬럼과 보이는 `D_` 컬럼을 반전하고(840·843), `W_` → `D_` 컬럼을 반전합니다(854).
- Designer(467~470): HorizontalAlignment General, NoteIndicatorColor Red, Parent `ColumnHeaderDefaultEnhanced`, VerticalAlignment General.

메타 속성(COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, FIXED_FLAG 등)의 구체적인 값은 Fact Pack에 없어 **확인 필요**입니다.

## 5. 액션 명세

| ID | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A1 | 화면 로드 (this.Load) | `Form_Load` | InitControls → GetDayRange, CreateSpread → InitSpread → GetSpdTitle / SetSheetHeaderColumn / InitSpreadDateColumn | `biz:CommonData.YesOrNo`, `SCP.SCM0001_GET_SCP_PERIOD`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` / (unreached, 확인 필요) `biz:CommonData.CommonDataList` [Company / MyDivision / LookupCommon] | cboInputValue 바인딩, 기간, 그리드 헤더 생성 |
| A2 | 조회 (FindButton) | `FindData_Main` | GetCheckedListValue(387·388) → 데이터 조회 → InitSpread → GetSpdTitle | `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 그리드를 다시 생성하고 데이터를 바인딩 |
| A3 | 저장 (SaveButton) | `SaveData_Main` | GetChanges(538, ROW_ID) → 저장 → FindData_Main | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` → `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | `SSP_MST_SHIP_CALENDAR` UPDATE 후 재조회 |
| A4 | btnInput Click | `BtnInput_Click` | GetCheckedListValue(682) → Changed 해제(725) → 일괄 처리 → 재연결(821) | 없음 | 그리드에 일괄 반영(상세 확인 필요) |
| A5 | cboDayWeek SelectedIndexChanged | `CboDayWeek_SelectedIndexChanged` | GetCheckedListValue(660) → cboInputValue.Enabled false(663) / true(666) | 없음 | Input Value 활성/비활성 |
| A6 | spdMain CellDoubleClick | `SpdMain_CellDoubleClick` | 헤더 Tag `M_` / `W_`에 따라 하위 컬럼 Visible 반전 | 없음 | 컬럼 접기/펼치기 |
| A7 | dsdm Changed | `SpdMain_Changed` | 자기 해제(878) → 처리(확인 필요) → 재연결(902) | 없음 | 확인 필요 |
| A8 | spdMain TopChange | `SpdMain_TopChange` | 확인 필요 | 없음 | 확인 필요 |
| (참고) | SetChangedPeriod | - | unreached | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value}] | FROM_VALUE / TO_VALUE 사용(확인 필요) |

> 주석 처리된 `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY`(569)와 `SCP.GET_DATE_RANGE_1MONTH`(940)는 액션에서 제외했습니다.

## 6. 검증·메시지

| 항목 | 사실 |
|---|---|
| Period 필수 | 라벨 `Period*` 표시만 확인되었습니다. 검증 코드와 메시지 문구는 **확인 필요**입니다. |
| 저장 전 변경 없음 처리 | `GetChanges` 사용만 확인되었습니다. 메시지는 **확인 필요**입니다. |
| 조회 결과 없음 / 오류 메시지 | 추출되지 않았습니다(**확인 필요**). |

## 7. 권한 (C/R/U/D)

| 항목 | 사실 |
|---|---|
| 코드상 기능 | R(FindButton), U(SaveButton → UPDATE `SSP_MST_SHIP_CALENDAR`). C·D 진입점은 추출되지 않았습니다. |
| `EditButton`(352) | `GetSheetInfo` 호출만 추출되었습니다. |
| 메타 | `TB_FX_GroupMenuAuth` 13행. 그룹별 플래그 값은 **확인 필요**입니다. |
| Division 범위 | `NowGroupID` 기준 MyDivision 목록입니다. |

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 영역 | As-Is | To-Be 고려 사항 |
|---|---|---|
| 그리드 헤더 | FarPoint 3단 헤더, `ColumnHeaderSpan` 병합 | FlexGrid `columnHeaders`에 3행을 추가하고 병합을 설정합니다. LARGE/SMALL 라벨은 SCP0009 결과로 동적 구성합니다. |
| 날짜 컬럼 | DB 루프 `AddComboColumn`(YesOrNo) | 조회 결과로 동적 컬럼을 생성하고, `DataMap`(YesOrNo)을 적용합니다. 폭 70, center 정렬입니다. |
| 요일 색상 | SAT Blue / SUN Red ForeColor | 컬럼 단위 CSS 클래스로 처리합니다(inline style 금지 규약 준수). |
| 접기/펼치기 | 헤더 더블클릭 + Tag 접두어 | 헤더 dblclick 핸들러에서 `column.visible`을 토글합니다. Tag 대신 binding 접두어를 씁니다. |
| Changed 억제 | 이벤트 `-=`/`+=` | 일괄 입력 중에는 플래그로 cellEditEnded 처리를 억제하거나 `deferUpdate`를 사용합니다. |
| 저장 | GetChanges(ROW_ID) | CollectionView `itemsEdited` 기반으로 변경 행만 전송합니다. |
| 조회 SP | MSSQL `#TBLDYNAMICPIVOT_SSP0005`, `STRING_SPLIT`, 동적 SQL | Oracle 19c에서는 temp → GTT 등으로 바꾸고, `STRING_SPLIT` 제거(MSSQL 키워드 금지)와 동적 피벗 변환이 필요합니다. 방식은 **확인 필요**입니다. |
| 기간 SP | `FN_MULTY_TIME`, `FN_WEEKOFDAY_DATE`, `CTE_DATE` | Oracle 함수와 WITH 절로 변환합니다. |
| 저장 SP | `PR_SCM_SYS_LOG_BATCH_CALL_TRAN` 호출 | Oracle 측 로그 프로시저와 트랜잭션 경계를 확인해야 합니다. |
| 메타 라벨 | `Divison` 철자 | 메타 원문을 그대로 둘지 **확인 필요**입니다. |

## 9. 미확정

1. `usrButton1`의 용도와 표시 여부
2. 조회조건 행·열 배치 좌표
3. 각 콤보의 초기값과 필수 여부(Period 제외)
4. `CboDayWeek_SelectedIndexChanged`의 Enabled 조건, `BtnInput_Click`의 일괄 입력 상세
5. `SpdMain_Changed`(878~902), `SpdMain_TopChange`의 동작
6. `B_` 컬럼 분기, `AddSheet` 인자 1·35
7. Company / MyDivision / LookupCommon / PERIOD 공통코드의 실제 바인딩 경로(unreached)
8. 메타 컬럼 속성값(폭·정렬·고정·편집)
9. 메뉴 위치와 그룹별 C/R/U/D 플래그
