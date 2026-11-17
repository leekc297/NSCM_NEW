# SCP0096 — Shipment Working Day OSP 화면설계서

> 근거: Fact Pack(controls.csv · props.csv · events.csv · grid_code.csv · grid_effective.csv · flow.csv · endpoints.csv)만 사용했습니다. 묶음에 없는 사항은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 값 | 근거 |
|---|---|---|
| 화면 ID | SCP0096 | files.csv |
| 화면 명칭 | `Shipment Working Day OSP` | Designer.cs:663 |
| AS-IS 클래스 | `SCP0096_Shipment_Working_Day_OSP` | files.csv |
| 소스 | `.cs` 852줄 / `.Designer.cs` 724줄 / `AssemblyInfo.cs` 37줄 | files.csv |
| 메뉴 위치 | **확인 필요**. `TB_FX_MenuItemInfo` 1행이 있지만 경로 값은 묶음에 없음 | Fact Pack §8 |
| 시트 | 1개: `Shipment Working Day OSP` | grid_code.csv 142 |

## 2. 화면 레이아웃

### 2-1. 분할 트리
props.csv 에 SplitContainer(Orientation · SplitterDistance) 행이 **없습니다**. 분할은 Dock 으로만 구성됩니다. controls.csv 의 parent 체인을 그대로 옮기면 다음과 같습니다.

```
this (Form, Text="Shipment Working Day OSP")
├─ usrConditionPanel1   [UsrConditionPanel, Dock=Top, 1192×96, UsrPanelType=HidePanel]   ← 상단 14.8%
│   └─ usrLayoutControl2 [UsrLayoutControl, Dock=Fill, 1192×96]
│        (layoutControlGroup2 1192×96 — 레이아웃 그룹, parent 미기재)
│        ├─ cboDivision    ← layoutControlItem4  "Division*"        (item 236×25 / ctrl 181×20)
│        ├─ clbPlantSite   ← layoutControlItem7  "Plant Site"       (item 226×25 / ctrl 165×21)
│        ├─ dCalendar      ← layoutControlItem2  "Period*"          (item 260×25 / ctrl 210×22)
│        ├─ cboDayWeek     ← layoutControlItem3  "Day of the week"  (item 236×25 / ctrl 134×20)
│        ├─ cboInputValue  ← layoutControlItem1  "Input Value"      (item 226×25 / ctrl 124×20)
│        ├─ btnInput       ← layoutControlItem10 (Text 없음)        (item 81×25  / ctrl 77×21, Text "Input")
│        ├─ chkSum         ← layoutSum           (Text 없음)        (item 50×25  / ctrl 46×20, Text "Sum", Visible=false)
│        └─ emptySpaceItem1·2·3·4·5·6·9·10 (간격 8개)
└─ spdMain              [FpSpread, Dock=Fill, 1192×553]                                     ← 하단 85.2%
     └─ spdMain_Sheet1  [SheetView] → 시트 "Shipment Working Day OSP"

(부모 없음) usrButton1  [UsrButton, 75×23, Text 없음] — 배치 위치 확인 필요
```

- 상/하 비율: 96 : 553 (합 649) = **14.8% : 85.2%**. Designer Size 기준이며 런타임 창 크기에 따라 하단(Fill)만 늘어납니다.
- 좌/우 분할: 없습니다.
- 조회조건 행·열 좌표: LayoutControlItem 의 Location 이 추출되지 않아 **확인 필요**입니다. 항목 높이(25)와 EmptySpaceItem 높이(25·26)가 섞여 있는 것만 사실로 확인됩니다.

### 2-2. 영역 정의

| 영역 | 컨트롤 | 비고 |
|---|---|---|
| 조회조건 | cboDivision, clbPlantSite, dCalendar, cboDayWeek, cboInputValue, chkSum | usrConditionPanel1 > usrLayoutControl2 |
| 버튼 | btnInput(조회조건 영역 안), 공통 툴바 FindButton·SaveButton·EditButton(프레임워크) | 툴바 버튼의 배치·라벨은 **확인 필요** |
| 그리드 | spdMain / spdMain_Sheet1 | 시트 `Shipment Working Day OSP` |
| 팝업 | 없음 | `SpdMain_CellDoubleClick` 이 팝업을 여는지는 **확인 필요** |

### 2-3. 와이어프레임

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ [툴바: 조회 · 저장 ... (프레임워크, 확인 필요)]                                  │
├──────────────────────────────────────────────────────────────────────────────┤ ┐
│ Division* [cboDivision ▼]  Plant Site [clbPlantSite ▼]  Period* [dCalendar ~ ] │ │ usrConditionPanel1
│ Day of the week [cboDayWeek ▼]  Input Value [cboInputValue ▼]  [Input] (☐Sum) │ │ 96px · 14.8%
│   ※ 행 배치·순서는 Location 미추출로 확인 필요 · chkSum Visible=false          │ │
├──────────────────────────────────────────────────────────────────────────────┤ ┘
│ spdMain — Shipment Working Day OSP                                            │ ┐
│ ┌──────────┬────────────┬──────────┬────────┬──────────────┬────────────┬──── │ │
│ │          │            │          │        │              │            │대분류│ │ 헤더 3단
│ │ Division │Plant Site ID│Plant Site│Measure │Working Time  │Last Input  ├──────┤ │
│ │          │            │          │        │Default       │Date        │SUM│소│ │
│ │          │            │          │        │              │            │   │일│ │
│ ├──────────┼────────────┼──────────┼────────┼──────────────┼────────────┼───┼──┤ │ 553px · 85.2%
│ │ ...      │            │          │        │              │            │ Y │N │ │
│ └──────────┴────────────┴──────────┴────────┴──────────────┴────────────┴───┴──┘ │
└──────────────────────────────────────────────────────────────────────────────┘ ┘
```
메타 6컬럼의 실제 순서(SORT_ORDER_NO)는 **확인 필요**입니다. 위 순서는 grid_effective.csv 행 순서가 아니라 1차 분석서의 나열 순서입니다.

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수여부 | 연결 이벤트 | To-Be 컴포넌트(후보) |
|---|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | — (Text 없음) | Dock=Top, UsrPanelType=HidePanel | — | — | 조회조건 패널(접기 지원) |
| usrLayoutControl2 | UsrLayoutControl | `usrLayoutControl2` | Dock=Fill | — | — | 조회조건 레이아웃 그리드 |
| cboDivision | UsrCombo | `Division*` (layoutControlItem4) | 확인 필요 | 예(`*`) | SelectedIndexChanged → `CboDivision_SelectedIndexChanged` | 단일 선택 ComboBox |
| clbPlantSite | UsrCheckedList | `Plant Site` (layoutControlItem7) | 확인 필요 | 확인 필요 | SelectedIndexChanged → `ClbPlantSite_SelectedIndexChanged` | 다중 선택 MultiSelect |
| dCalendar | UsrDateRangePicker3 | `Period*` (layoutControlItem2) | 확인 필요 | 예(`*`) | — | 기간 DateRange |
| cboDayWeek | UsrCombo | `Day of the week` (layoutControlItem3) | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboDayWeek_SelectedIndexChanged` | ComboBox(데이터원 확인 필요, `biz:CommonData.CommonDataList` 후보) |
| cboInputValue | UsrCombo | `Input Value` (layoutControlItem1) | 확인 필요 | 확인 필요 | — (cboDayWeek 변경 시 Enabled 토글) | ComboBox(데이터원 확인 필요) |
| btnInput | UsrButton | `Input` (btnInput.Text) · layoutControlItem10 Text 없음 | — | — | Click → `BtnInput_Click` | Button |
| chkSum | UsrCheckBox | `Sum` (chkSum.Text) · layoutSum Text 없음 | Checked=false(DefineProperty:121), Visible=false(Designer:346) | — | CheckedChanged → `chkSum_CheckedChanged` | CheckBox(숨김 유지 여부 확인 필요) |
| usrButton1 | UsrButton | — (Text 없음, parent 없음) | Size 75×23 | — | — | 용도 확인 필요(화면에 배치되지 않은 것으로 보이나 확정 아님) |
| spdMain | FpSpread | — | Dock=Fill, 1192×553 | — | CellDoubleClick → `SpdMain_CellDoubleClick`, TopChange → `SpdMain_TopChange` | Wijmo FlexGrid |
| spdMain_Sheet1 | SheetView | 시트 `Shipment Working Day OSP` | AddSheet 인자 3·1·35 | — | — | FlexGrid 시트(단일) |

레이아웃 보조(라벨 보유 항목 외): layoutControlGroup2, emptySpaceItem1·2·3·4·5·6·9·10 — 간격 전용입니다.

## 4. 그리드 명세 — 시트 `Shipment Working Day OSP`

### 4-1. 메타 컬럼 (SCM_MST_SHEET_COLUMNS, `SetSheetHeaderColumn(siMain, 3)`)

| 컬럼 | 헤더 | 타입 | 출처 | division별 표시(14종) | 편집 가능 |
|---|---|---|---|---|---|
| DIVISION_ID | Division | 확인 필요 | META | 전부 기본(표시) | 확인 필요 |
| PLANT_SITE_ID | Plant Site ID | 확인 필요 | META | 전부 기본(표시) | 확인 필요 |
| PLANT_SITE_NAME | Plant Site | 확인 필요 | META | 전부 기본(표시) | 확인 필요 |
| MEASURE | Measure | 확인 필요 | META | 전부 기본(표시) | 확인 필요 |
| WORKING_TIME_DEFAULT | Working Time Default | 확인 필요 | META | 전부 기본(표시) | 확인 필요(저장 파라미터 `p_working_time_default` 로 전달됨) |
| LAST_INPUT_DATE | Last Input Date | 확인 필요 | META | 전부 기본(표시) | 확인 필요 |

타입·폭·정렬·편집 속성은 메타 원문(CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, FIXED_FLAG 등)이 묶음에 없어 **확인 필요**입니다.

### 4-2. 날짜 컬럼 (DB 루프, InitSpreadDateColumn — `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과)

삽입 위치는 `spdInfo.GetColumnIndex(DefColumns.MEASURE)` 기준입니다(InitSpread:159, 산식 확인 필요).

| 조건 | 컬럼 / 헤더 | 타입 | 폭 | 표시 | 출처 | 편집 |
|---|---|---|---:|---|---|---|
| COLUMN_NAME `IndexOf("B_") > 0` | COLUMN_NAME / COLUMN_LABEL_NAME | Text(AddTextColumn) | 0 | 숨김 | HARDCODED 로직 + DB값 | 확인 필요 |
| 그 외 | COLUMN_NAME / COLUMN_LABEL_NAME | Combo(AddComboColumn, 데이터 `dtValidYN` = `biz:CommonData.YesOrNo`), 가로·세로 Center | 50 | 표시 | HARDCODED 로직 + DB값 | 콤보 편집(잠금 여부 확인 필요) |
| DAY_CODE = SAT | — | — | — | — | HARDCODED | 글자색 Blue |
| DAY_CODE = SUN | — | — | — | — | HARDCODED | 글자색 Red |

### 4-3. 헤더 3단 Span

| 행 | 내용 | 높이 | 근거 |
|---|---|---:|---|
| 0 | LARGE_CLASS_LABEL_NAME (대분류 구간 Span) | 20 | grid_code.csv 215·243 |
| 1 | SMALL_CLASS_LABEL_NAME (소분류 구간 Span) | 20 | 221·230·241 |
| 1~2 | 대분류 시작 열 `"SUM"` (2행 Span) | 20 | 216·244 |
| 2 | 소분류 시작 열 `"SUM"` | 30 / 20 | 222 / 231·242 |

헤더 스타일: HorizontalAlignment General, VerticalAlignment General, NoteIndicatorColor Red, Parent `ColumnHeaderDefaultEnhanced`(Designer 628~631).

### 4-4. 컬럼 표시 토글 (SetSpreadColumn)

| 태그 접두어 | Visible | 근거 |
|---|---|---|
| `D_`, `W_` | true | 350 |
| `M_`, `W_` | `chkSum.Checked` | 355 |

`W_` 는 두 조건에 모두 들어 있어 최종값이 **확인 필요**입니다. 호출 지점: InitSpread:160, chkSum_CheckedChanged:330/335, FindData_Main:484(결과 행 > 0), cboBucketType_SelectedIndexChanged:311/316(미배선).

### 4-5. Division별 표시
14개 division 모두 메타 6컬럼으로 같습니다. 코드에 division 분기가 없습니다.

## 5. 액션 명세

| ID | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A-01 | 화면 Load | `Form_Load` | InitControls > GetBucketType | `DM.DM0003_GET_BUCKET_TYPE_CODE` | 반영 컨트롤 확인 필요 |
| A-02 | 화면 Load | `Form_Load` | CreateSpread > InitSpread > GetSpdTitle → 메타 컬럼 + 날짜 컬럼 + 헤더 Span + SetSpreadColumn | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `biz:CommonData.YesOrNo`(콤보 데이터) | 시트 `Shipment Working Day OSP` 구성 |
| A-03 | 조회(툴바) | FindButton > FindData_Main | GetCheckedListValue(442·443) → GET 호출 → InitSpread 재구성 → 결과 행 > 0 이면 SetSpreadColumn | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain 데이터 표시 |
| A-04 | 저장(툴바) | SaveButton > SaveData_Main | GetChanges(609) → 파라미터 구성(558~581) → SAVE 호출 → FindData_Main 재조회 | `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` → `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` → `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 저장 후 그리드 재표시 |
| A-05 | spdMain 셀 더블클릭 | `SpdMain_CellDoubleClick` | 확인 필요 | 묶음상 없음 | 확인 필요 |
| A-06 | spdMain 스크롤 | `SpdMain_TopChange` | 확인 필요 | 묶음상 없음 | 확인 필요 |
| A-07 | cboDivision 변경 | `CboDivision_SelectedIndexChanged` | 확인 필요 | 묶음상 없음 | 확인 필요 |
| A-08 | clbPlantSite 변경 | `ClbPlantSite_SelectedIndexChanged` | 확인 필요 | 묶음상 없음 | 확인 필요 |
| A-09 | cboDayWeek 변경 | `CboDayWeek_SelectedIndexChanged` | GetCheckedListValue(672) → 분기 | 없음 | cboInputValue.Enabled = false(675) / true(679) |
| A-10 | cboDayWeek 데이터 | (진입점 미연결 `<field:dtDayWeek>`) | 공통코드 LookupCommon | `biz:CommonData.CommonDataList` | 바인딩 컨트롤 확인 필요 |
| A-11 | btnInput 클릭 | `BtnInput_Click` | GetCheckedListValue(695·696) → 그리드 반영(규칙 확인 필요) | 없음(클라이언트) | 확인 필요 |
| A-12 | chkSum 체크 변경 | `chkSum_CheckedChanged` | SetSpreadColumn(330/335) | 없음 | `M_`·`W_` 컬럼 Visible = chkSum.Checked |

## 6. 검증·메시지

| 항목 | 사실 | 상태 |
|---|---|---|
| Division 필수 | 라벨 `Division*` | 검증 코드·메시지 확인 필요 |
| Period 필수 | 라벨 `Period*` | 검증 코드·메시지 확인 필요 |
| 저장 대상 없음 | GetChanges 사용 | 변경분 0건일 때 메시지 확인 필요 |
| 조회 0건 | SetSpreadColumn 은 결과 행 > 0 일 때만 호출(484) | 메시지 확인 필요 |
| SP 오류 | — | 처리·메시지 확인 필요 |

메시지 문구 원문은 묶음에 없습니다.

## 7. 권한 (C/R/U/D)

| 항목 | 사실 |
|---|---|
| 메타 행 | TB_FX_GroupMenuAuth 4행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_Favorite 1행 |
| 그룹별 C/R/U/D | **확인 필요**(값 미추출) |
| 코드상 액션 | R: FindButton · U: SaveButton · EditButton(288, GetSheetInfo) · C/D 전용 버튼 코드 없음 |

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 영역 | AS-IS | To-Be 관점 |
|---|---|---|
| 그리드 | FarPoint FpSpread, 헤더 3단 ColumnHeaderSpan | Wijmo FlexGrid `columnHeaders` 3행 + 병합(allowMerging), 대분류·소분류·SUM Span 재현 |
| 날짜 컬럼 | DB 루프 AddComboColumn(폭 50, Y/N, Center) / `B_` 숨김 | 조회 응답(SCP0009 결과)으로 컬럼 정의를 동적 생성, `dataMap` 으로 Y/N 콤보, `B_` 는 visible=false |
| 주말 색상 | ForeColor Blue(SAT)/Red(SUN) | 셀 포맷터/클래스로 처리(inline style 금지 규약) |
| 표시 토글 | Columns[].Visible 태그 접두어 판정 | 컬럼 binding 접두어 기준 visible 토글. `W_` 중복 판정은 AS-IS 확인 후 확정 |
| 변경분 저장 | FPExtensions.GetChanges(ROW_ID) | FlexGrid CollectionView `itemsEdited` 기준 변경분 전송 |
| 피벗 조회 SP | MSSQL `#TBLDYNAMICPIVOT_SCP0096` + 동적 SQL + `STRING_SPLIT` | Oracle: 임시 테이블 → GTT, `STRING_SPLIT` → Oracle 분할 방식, 동적 피벗 재구성(MSSQL 키워드 잔존 금지) |
| 저장 SP | MERGE 2개 + PR_SCM_SYS_LOG_BATCH | Oracle MERGE 로 변환, 로그 프로시저 동일 호출 |
| 공통코드 | `biz:CommonData.CommonDataList`(LookupCommon), `biz:CommonData.YesOrNo` | 공통 코드 API로 대체 |
| chkSum | Designer Visible=false | To-Be 노출 여부는 AS-IS 런타임 확인 후 결정 |
| usrButton1 | 부모 없음 | 배치되지 않았는지 확인 후 이관 대상에서 뺄지 결정 |

## 9. 미확정

1. 조회조건 행·열 배치 순서(Location 미추출)
2. 툴바 버튼(FindButton·SaveButton·EditButton) 표시 구성
3. 메타 6컬럼 정렬 순서·폭·타입·편집 가능 여부
4. cboDayWeek / cboInputValue 데이터원, BtnInput_Click 일괄 입력 규칙, CboDayWeek 분기 조건
5. SpdMain_CellDoubleClick, SpdMain_TopChange, CboDivision_SelectedIndexChanged, ClbPlantSite_SelectedIndexChanged 내부 동작
6. `W_` 컬럼 최종 Visible, `B_` 판정의 위치 0 제외 의도
7. `DM.DM0003_GET_BUCKET_TYPE_CODE` 결과 사용처, `cboBucketType_SelectedIndexChanged`·`SetChangedControl` 호출 경로
8. usrButton1 용도
9. 검증 메시지 문구, 권한 C/R/U/D 값, 메뉴 위치
