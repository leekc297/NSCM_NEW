# SCP0096 — Shipment Working Day OSP 화면설계서

> 근거: Fact Pack(controls.csv, props.csv, events.csv, grid_code.csv, grid_effective.csv)입니다. 없는 사실은 **확인 필요**로 표시했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SCP0096 |
| 화면명 | Shipment Working Day OSP (Designer.cs:663) |
| 도메인 / 분류 | SCP / Master |
| 메뉴 위치 | 확인 필요 (TB_FX_MenuItemInfo 1행 — 값 미제공) |
| 시트 | `Shipment Working Day OSP` (1개) |
| Grid 구성 방식 | HYBRID: META(SetSheetHeaderColumn) + DB루프(InitSpreadDateColumn) + 코드 표시 변경(SetSpreadColumn) |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (props.csv + controls.csv parent 체인)

- props.csv에는 **SplitContainer가 없습니다**(Orientation·SplitterDistance 항목 없음). 분할은 Dock으로만 구성됩니다.
- 상/하 비율은 Designer 크기 기준 96 : 553으로 **상 14.8% : 하 85.2%** 입니다(폭 1192).

```
this (Form "Shipment Working Day OSP")
├─ usrConditionPanel1  [UsrConditionPanel, Dock=Top, 1192×96, HidePanel]        ← 상 14.8%
│   └─ usrLayoutControl2  [UsrLayoutControl, Dock=Fill, 1192×96]
│        (layoutControlGroup2 1192×96)
│        ├─ cboDivision    via layoutControlItem4  "Division*"        item 236×25 / ctrl 181×20
│        ├─ clbPlantSite   via layoutControlItem7  "Plant Site"       item 226×25 / ctrl 165×21
│        ├─ dCalendar      via layoutControlItem2  "Period*"          item 260×25 / ctrl 210×22
│        ├─ cboDayWeek     via layoutControlItem3  "Day of the week"  item 236×25 / ctrl 134×20
│        ├─ cboInputValue  via layoutControlItem1  "Input Value"      item 226×25 / ctrl 124×20
│        ├─ btnInput       via layoutControlItem10 (Text "Input")     item 81×25  / ctrl 77×21
│        ├─ chkSum         via layoutSum           (Text "Sum")       item 50×25  / ctrl 46×20, Visible=false
│        └─ emptySpaceItem1~6, 9, 10 (여백)
└─ spdMain  [FpSpread, Dock=Fill, 1192×553]                                    ← 하 85.2%
     └─ spdMain_Sheet1 [SheetView] → 런타임 시트 "Shipment Working Day OSP"

(parent 없음) usrButton1 [UsrButton, 75×23] — 배치 위치·용도 확인 필요
```

### 2-2. 조회조건 영역 와이어프레임 (참고)

layoutControlItem에 Location이 없으므로 **행·열 위치는 확인 필요**합니다. 항목 높이 25/26과 그룹 높이 96으로 보아 여러 행 배치로 추정되지만, 아래 배치는 확정이 아닙니다.

```
┌──────────────────────────────── usrConditionPanel1 (조회조건, 접힘) ──────────────────────────────┐
│ Division* [cboDivision ▼]  Plant Site [clbPlantSite ☑▼]  Period* [dCalendar From ~ To]  (Sum ☐)  │
│ Day of the week [cboDayWeek ▼]  Input Value [cboInputValue ▼]  [Input]                          │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
┌──────────────────────────────── spdMain : Shipment Working Day OSP ──────────────────────────────┐
│ 헤더 3행 | Division | Plant Site ID | Plant Site | Measure | (날짜 컬럼 …) | Working Time Default ...│
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

- 툴바 버튼(FindButton/SaveButton/EditButton)은 프레임워크 공통 툴바에서 제공하는 것으로 보입니다. 배치는 확인 필요합니다.
- 팝업 영역은 Fact Pack에 없습니다. `SpdMain_CellDoubleClick`이 팝업을 띄우는지는 확인 필요합니다.

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨(props Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | — | HidePanel, Dock Top | — | — | 조회조건 패널(접힘) |
| usrLayoutControl2 | UsrLayoutControl | "usrLayoutControl2" | Dock Fill | — | — | 조회조건 레이아웃 |
| cboDivision | UsrCombo | "Division*" (layoutControlItem4) | 확인 필요 | Y(라벨 *) | `CboDivision_SelectedIndexChanged` | 단일 ComboBox |
| clbPlantSite | UsrCheckedList | "Plant Site" (layoutControlItem7) | 확인 필요 | 확인 필요 | `ClbPlantSite_SelectedIndexChanged` | MultiSelect ComboBox |
| dCalendar | UsrDateRangePicker3 | "Period*" (layoutControlItem2) | 확인 필요 | Y(라벨 *) | — | DateRangePicker(From~To) |
| cboDayWeek | UsrCombo | "Day of the week" (layoutControlItem3) | 확인 필요 | — | `CboDayWeek_SelectedIndexChanged` | ComboBox (원천 dtDayWeek 추정, 확인 필요) |
| cboInputValue | UsrCombo | "Input Value" (layoutControlItem1) | 확인 필요 | — | — (Enabled는 CboDayWeek가 제어) | ComboBox |
| btnInput | UsrButton | "Input" | — | — | `BtnInput_Click` | Button |
| chkSum | UsrCheckBox | "Sum" | Checked=false, Visible=false | — | `chkSum_CheckedChanged` | CheckBox (표시 여부 확인 필요) |
| usrButton1 | UsrButton | 없음 | 75×23, parent 없음 | — | 없음 | 확인 필요 |
| spdMain | FpSpread | — | Dock Fill | — | `SpdMain_CellDoubleClick`, `SpdMain_TopChange` | Wijmo FlexGrid |
| spdMain_Sheet1 | SheetView | — | 시트 `Shipment Working Day OSP` | — | — | FlexGrid 단일 시트 |

화면 이벤트 `Form_Load`(this.Load, .ctor:103)는 화면 초기화 시점에 실행됩니다.

## 4. 그리드 명세 — 시트 `Shipment Working Day OSP`

생성: CreateSpread:142 `AddSheet`(인자 3 ¦ 1 ¦ 35, 의미 확인 필요) → InitSpread:156 `SetSheetHeaderColumn(siMain, 3)`(헤더 3행).

### 4-1. 메타 컬럼

| 컬럼 | 헤더 | 타입 | 출처 | division별 표시 | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Division | 확인 필요 | META | 14개 division 모두 기본 | 확인 필요 |
| PLANT_SITE_ID | Plant Site ID | 확인 필요 | META | 14개 division 모두 기본 | 확인 필요 |
| PLANT_SITE_NAME | Plant Site | 확인 필요 | META | 14개 division 모두 기본 | 확인 필요 |
| MEASURE | Measure | 확인 필요 | META | 14개 division 모두 기본 | 확인 필요 |
| WORKING_TIME_DEFAULT | Working Time Default | 확인 필요 | META | 14개 division 모두 기본 | 확인 필요 |
| LAST_INPUT_DATE | Last Input Date | 확인 필요 | META | 14개 division 모두 기본 | 확인 필요 |

- 순서(SORT_ORDER_NO), 너비, CELL_CONTROL_OBJECT_TYPE_CODE, FIXED_FLAG는 `dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv`에서 확인해야 합니다.

### 4-2. 코드 동적 컬럼 (SCP0009 결과 DB 루프, MEASURE 다음에 삽입)

| 조건 | 헤더 | 타입 | 출처 | 너비 | 표시 | 편집 |
|---|---|---|---|---:|---|---|
| COLUMN_NAME에 `B_` 포함(IndexOf > 0) | COLUMN_LABEL_NAME | Text | HARDCODED 로직 + DB 값 | 0 | 숨김 | 확인 필요 |
| 그 외 | COLUMN_LABEL_NAME | Combo(YesOrNo = dtValidYN, `biz:CommonData.YesOrNo`) | HARDCODED 로직 + DB 값 | 50 | 표시, 가운데 정렬 | 콤보 셀(잠금 여부 확인 필요) |

- 글자색: DAY_CODE `SAT` → Blue, `SUN` → Red(:208).
- 헤더: 0행 LARGE_CLASS_LABEL_NAME 병합, 1행 SMALL_CLASS_LABEL_NAME 병합, "SUM" 헤더(1~2행 span 또는 2행).
- 표시 제어(SetSpreadColumn): 태그가 `D_`·`W_`로 시작하면 표시, `M_`·`W_`로 시작하면 chkSum.Checked에 따릅니다(W_ 최종 결과 확인 필요).
- 헤더 스타일(Designer :628~:631): HorizontalAlignment/VerticalAlignment General, NoteIndicatorColor Red, Parent "ColumnHeaderDefaultEnhanced".
- division별 차이: 없음(14개 division 모두 6컬럼 + 동적 컬럼).

## 5. 액션 명세

| 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|
| 화면 로드 | `Form_Load` | InitControls > GetBucketType | `DM.DM0003_GET_BUCKET_TYPE_CODE` | 바인딩 대상 확인 필요 |
| 화면 로드 | `Form_Load` | CreateSpread > InitSpread > GetSpdTitle | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 시트 `Shipment Working Day OSP` 헤더와 날짜 컬럼 생성 |
| 필드 초기화 | (dtValidYN :51) | 날짜 콤보 데이터 | `biz:CommonData.YesOrNo` | 날짜 컬럼 Y/N 콤보 목록 |
| 필드 초기화 | (dtDayWeek :49) | LookupCommon 코드 | `biz:CommonData.CommonDataList` | 바인딩 컨트롤 확인 필요(cboDayWeek 추정) |
| 조회(툴바) | FindButton → FindData_Main | clbPlantSite GetCheckedListValue, SP 호출, InitSpread 재구성 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 그리드 바인딩. 행이 있으면(GetMaxRowIndex() > 0) SetSpreadColumn |
| 저장(툴바) | SaveButton → SaveData_Main | GetChanges → 파라미터 행 구성 → 재조회 | 저장 엔드포인트 확인 필요 → `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 재조회 결과 반영 |
| Edit(툴바) | EditButton(:288) | GetSheetInfo(spdMain.Name, ActiveSheetIndex) | 없음 | 확인 필요 |
| Day of the week 변경 | `CboDayWeek_SelectedIndexChanged` | GetCheckedListValue(:672) | 없음 | cboInputValue.Enabled false/true |
| Input 클릭 | `BtnInput_Click` | GetCheckedListValue(:695, :696) | 없음 | 그리드 일괄 입력(확인 필요) |
| Sum 토글 | `chkSum_CheckedChanged` | SetSpreadColumn | 없음 | M_/W_ 컬럼 Visible = chkSum.Checked |
| Division 변경 | `CboDivision_SelectedIndexChanged` | 확인 필요 | 확인 필요 | 확인 필요 |
| Plant Site 변경 | `ClbPlantSite_SelectedIndexChanged` | 확인 필요 | 확인 필요 | 확인 필요 |
| 셀 더블클릭 | `SpdMain_CellDoubleClick` | 확인 필요 | 확인 필요 | 확인 필요 |
| 스크롤 | `SpdMain_TopChange` | 확인 필요 | 확인 필요 | 확인 필요 |

## 6. 검증·메시지

| 대상 | 규칙 | 메시지 |
|---|---|---|
| cboDivision | 라벨 "Division*" — 필수 표시 | 확인 필요 |
| dCalendar | 라벨 "Period*" — 필수 표시 | 확인 필요 |
| 저장 | 변경행(GetChanges)만 대상 | 변경 없음 / 성공 / 실패 메시지 확인 필요 |
| 조회 결과 없음 | SetSpreadColumn을 호출하지 않음(:484 조건 불충족) | 확인 필요 |

## 7. 권한 (C/R/U/D)

- TB_FX_GroupMenuAuth 4행이 있지만 값은 **확인 필요**합니다.
- 코드상 버튼 경로는 FindButton(R), SaveButton(U), EditButton입니다. 신규/삭제 버튼 경로는 Fact Pack에 없습니다.

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 항목 | As-Is | To-Be 고려사항 |
|---|---|---|
| 다단 헤더 | FarPoint ColumnHeaderSpan 3행 | Wijmo FlexGrid columnHeaders 3행 + 병합(LARGE/SMALL CLASS, SUM) |
| 동적 날짜 컬럼 | SCP0009 결과 루프로 Add*Column | 헤더 API 결과로 컬럼 정의를 동적으로 생성 |
| B_ 숨김 컬럼 | 너비 0, Visible=false | 데이터에는 남기고 visible=false 유지 |
| YesOrNo 콤보 셀 | dtValidYN | DataMap(코드-이름) |
| 주말 색 | ForeColor SAT/SUN | 헤더/셀 formatItem 스타일 클래스(inline style 금지) |
| Sum 토글 | SetSpreadColumn | 컬럼 visible 상태 토글 |
| SP #임시테이블 | `#TBLDYNAMICPIVOT_SCP0096` | Oracle GTT 등으로 바꿔야 합니다 |
| STRING_SPLIT | MSSQL 함수 | Oracle 대체 구현 필요(MSSQL 키워드 잔존 금지) |
| 동적 PIVOT SQL | DYNAMIC SQL | Oracle 동적 SQL + REF CURSOR |
| 저장 | 저장 SP 미확인 | 저장 SP 계약 확정 후 설계 |

## 9. 미확정

1. 조회조건 항목의 행·열 위치(Location 없음), usrButton1 용도
2. cboDivision / clbPlantSite / cboInputValue / cboDayWeek 데이터 원천과 초기값
3. chkSum 런타임 표시 여부, W_ 최종 표시 규칙
4. 메타 컬럼의 타입·순서·편집 속성
5. SpdMain_CellDoubleClick / SpdMain_TopChange / CboDivision_SelectedIndexChanged / ClbPlantSite_SelectedIndexChanged 로직, BtnInput_Click 상세
6. 저장 엔드포인트, 검증 메시지, 권한 값
7. DM0003 결과 바인딩 대상(cboBucketType 부재)
