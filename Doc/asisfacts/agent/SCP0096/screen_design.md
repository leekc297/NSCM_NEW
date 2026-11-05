# SCP0096 — Shipment Working Day OSP 화면설계서

> **작성 근거**: AsisFacts Fact Pack(controls.csv / props.csv / events.csv / grid_effective.csv / grid_code.csv)과 1차 분석서. 사실에 없는 값은 **확인 필요**로 표기했습니다.
> **상호 참조**: §5 액션 명세의 엔드포인트 = 업무분석서 §5 데이터 흐름. §3 컨트롤명 = 단위테스트 '절차' 열.

---

## 1. 화면 개요

| 항목 | 값 | 근거 |
|---|---|---|
| 화면 ID | SCP0096 | — |
| 화면 명칭 | `Shipment Working Day OSP` | Designer.cs:663 |
| 클래스 | `SCP0096_Shipment_Working_Day_OSP` | controls.csv |
| 도메인 / 분류 | SCP / Master | 경로 |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행 존재, 값 미포함) | Fact Pack §8 |
| 시트 | `Shipment Working Day OSP` (1개) | grid_code.csv 142 |
| 화면 유형 | 조회조건 + 단일 그리드 (팝업 없음) | controls.csv |

---

## 2. 화면 레이아웃

### 2-1. 분할 구조 (SplitContainer)
- props.csv와 controls.csv에 **SplitContainer가 없습니다**. 그래서 SplitContainer 기준(Orientation·SplitterDistance)으로 분할 트리를 그릴 수 없고, **Dock + Size + parent 체인**으로 대신 그렸습니다.
- 상/하 비율: `usrConditionPanel1`(Dock Top, 높이 96) : `spdMain`(Dock Fill, 높이 553) = 96 : 553 → **약 14.8% : 85.2%**(합계 649, 폭 1192 공통)
- 좌/우 분할: **없음**

### 2-2. parent 체인 트리 (controls.csv 원문)
```
this (Form "Shipment Working Day OSP")
├── usrConditionPanel1   [UsrConditionPanel] Dock=Top  Size=1192×96  UsrPanelType=HidePanel
│   └── usrLayoutControl2 [UsrLayoutControl] Dock=Fill Size=1192×96  Text="usrLayoutControl2"
│       ├── dCalendar      [UsrDateRangePicker3]  210×22
│       ├── btnInput       [UsrButton]            77×21   Text="Input"
│       ├── cboDivision    [UsrCombo]             181×20
│       ├── clbPlantSite   [UsrCheckedList]       165×21
│       ├── chkSum         [UsrCheckBox]          46×20   Text="Sum"  Visible=false
│       ├── cboInputValue  [UsrCombo]             124×20
│       └── cboDayWeek     [UsrCombo]             134×20
└── spdMain              [FpSpread] Dock=Fill Size=1192×553
    (spdMain_Sheet1 [SheetView] — parent 미기록, spdMain 의 시트로 추정)

parent 미기록(빈값): usrButton1 [UsrButton] 75×23 / layoutControlGroup2 (1192×96)
                     / layoutControlItem* 7개 / emptySpaceItem* 8개
```

### 2-3. 텍스트 와이어프레임
```
┌──────────────────────────────────────────────────────────────────────────── 1192 ─┐
│ [공통 툴바: 조회(FindButton) · 저장(SaveButton) — 프레임워크 제공, 위치 확인 필요]   │
├───────────────────────────────────────────────────────────────────────────────────┤
│ usrConditionPanel1 / usrLayoutControl2  (높이 96 · 약 14.8%)  ※ HidePanel         │
│  Division* [cboDivision ▼]   Plant Site [clbPlantSite ☑▼]   Period* [dCalendar ~ ] │
│  Day of the week [cboDayWeek ▼]  Input Value [cboInputValue ▼]  [btnInput Input]   │
│  (Sum ☐ chkSum — Visible=false)                                                    │
│  ※ 행·열 배치 순서 = Location 미추출 → 확인 필요 (LayoutItem 높이 25/26, 2행 이상) │
├───────────────────────────────────────────────────────────────────────────────────┤
│ spdMain / spdMain_Sheet1 "Shipment Working Day OSP"  (높이 553 · 약 85.2%)        │
│ ┌────────┬───────────┬─────────┬────────────┬───────┬─────────┬─[LARGE]────────┐ │
│ │ (META 6 컬럼 — 순서 확인 필요)                       │ SUM │[SMALL] SUM│ …  │ │
│ │ DIVISION_ID·PLANT_SITE_ID·PLANT_SITE_NAME·MEASURE·  │     │ 일자 Y/N 콤보 │ │
│ │ WORKING_TIME_DEFAULT·LAST_INPUT_DATE                 │     │ (SAT 파랑/SUN 빨강)│
│ └──────────────────────────────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────────────────────────────┘
```

### 2-4. 영역 정의
| 영역 | 구성 컨트롤 | 비고 |
|---|---|---|
| 조회조건 | cboDivision, clbPlantSite, dCalendar | 필수: Division*, Period* |
| 입력(일괄) 조건 | cboDayWeek, cboInputValue, btnInput | 조회조건 패널 안에 있음 |
| 표시 옵션 | chkSum | Visible=false |
| 버튼 | FindButton, SaveButton(프레임워크), btnInput, usrButton1(용도 확인 필요) | |
| 그리드 | spdMain / spdMain_Sheet1 | 시트 `Shipment Working Day OSP` |
| 팝업 | 없음 (사실 묶음에 팝업 폼 없음) | |

### 2-5. LayoutControlItem 크기 (참고)
| LayoutItem | Control | Size | Text |
|---|---|---|---|
| layoutControlItem4 | cboDivision | 236×25 | `Division*` |
| layoutControlItem7 | clbPlantSite | 226×25 | `Plant Site` |
| layoutControlItem2 | dCalendar | 260×25 | `Period*` |
| layoutControlItem3 | cboDayWeek | 236×25 | `Day of the week` |
| layoutControlItem1 | cboInputValue | 226×25 | `Input Value` |
| layoutControlItem10 | btnInput | 81×25 | (Text 없음) |
| layoutSum | chkSum | 50×25 | (Text 없음) |
| emptySpaceItem1/2/3/4/5/6/9/10 | — | 10×25 / 390×25 / 26×26 / 540×26 / 606×26 / 566×25 / 10×25 / 53×25 | 여백 |

---

## 3. 컨트롤 명세

| # | 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|---|
| C01 | `usrConditionPanel1` | UsrConditionPanel | (Text 없음) | Dock=Top, HidePanel | — | — | 조회조건 패널 컨테이너 |
| C02 | `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2` (디자이너 기본명) | Dock=Fill | — | — | 조회조건 Grid 레이아웃 |
| C03 | `cboDivision` | UsrCombo | `Division*` (layoutControlItem4) | **확인 필요** | 필수(`*`) | `CboDivision_SelectedIndexChanged` | Wijmo ComboBox |
| C04 | `clbPlantSite` | UsrCheckedList | `Plant Site` (layoutControlItem7) | **확인 필요** | — | `ClbPlantSite_SelectedIndexChanged` | Wijmo MultiSelect (값 CODE) |
| C05 | `dCalendar` | UsrDateRangePicker3 | `Period*` (layoutControlItem2) | **확인 필요** | 필수(`*`) | — | 기간(From~To) DateRange |
| C06 | `cboDayWeek` | UsrCombo | `Day of the week` (layoutControlItem3) | **확인 필요** | — | `CboDayWeek_SelectedIndexChanged` | Wijmo ComboBox 또는 MultiSelect (672 GetCheckedListValue → 다중 여부 확인 필요). 목록 원천 후보 `biz:CommonData.CommonDataList`(확인 필요) |
| C07 | `cboInputValue` | UsrCombo | `Input Value` (layoutControlItem1) | **확인 필요** (Enabled는 cboDayWeek 따라 false/true) | — | — | Wijmo ComboBox (목록 원천 확인 필요) |
| C08 | `btnInput` | UsrButton | `Input` | — | — | `BtnInput_Click` | Button (일괄 입력) |
| C09 | `chkSum` | UsrCheckBox | `Sum` | Checked=false(121), **Visible=false**(346) | — | `chkSum_CheckedChanged` | CheckBox (노출 정책 확인 필요) |
| C10 | `usrButton1` | UsrButton | (Text 없음) | 75×23, parent 없음 | — | 배선 없음 | **확인 필요** (미사용 후보) |
| C11 | `spdMain` | FpSpread | — | Dock=Fill 1192×553 | — | `SpdMain_CellDoubleClick`, `SpdMain_TopChange` | Wijmo FlexGrid |
| C12 | `spdMain_Sheet1` | SheetView | (시트명 `Shipment Working Day OSP`, AddSheet 142) | 헤더 3행 | — | — | FlexGrid 단일 뷰 (columnHeaders 3행) |

---

## 4. 그리드 명세 — 시트 `Shipment Working Day OSP`

연결 규칙: **META+코드연결** / 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** / 헤더 3행.

### 4-1. META 고정 컬럼 (SCM_MST_SHEET_COLUMNS 6행)
| 컬럼 | 헤더 | 타입 | 출처 | division별 표시(14개) | 편집 가능 | 비고 |
|---|---|---|---|---|---|---|
| DIVISION_ID | Division | 확인 필요 | META | 전 division 기본 | 확인 필요 | |
| PLANT_SITE_ID | Plant Site ID | 확인 필요 | META | 전 division 기본 | 확인 필요 | |
| PLANT_SITE_NAME | Plant Site | 확인 필요 | META | 전 division 기본 | 확인 필요 | |
| MEASURE | Measure | 확인 필요 | META | 전 division 기본 | 확인 필요 | 날짜 컬럼은 이 컬럼 다음 열부터 붙음(159) |
| WORKING_TIME_DEFAULT | Working Time Default | 확인 필요 | META | 전 division 기본 | 확인 필요 | 저장 파라미터 `p_working_time_default` 와 대응 추정 |
| LAST_INPUT_DATE | Last Input Date | 확인 필요 | META | 전 division 기본 | 확인 필요 | |

> 위 표의 행 순서는 grid_effective.csv 순서가 아닙니다. 실제 SORT_ORDER_NO·COLUMN_WIDTH·INPUT 속성·FIXED_FLAG 값은 사실 묶음에 없어 **확인 필요**입니다. division 14개(40 / 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC / 82 / EE / EE_HD / EE_HG / EE_HM / EE_ST / EE_UC) 모두 6/0이며 표시 차이는 없습니다.

### 4-2. 코드 생성 날짜 컬럼 (DB 루프 — `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과)
| 조건 | 컬럼 | 헤더 | 타입 | 출처 | 폭 | 표시 | 편집 | 스타일 | 근거 |
|---|---|---|---|---|---:|---|---|---|---|
| `COLUMN_NAME.IndexOf("B_") > 0` | COLUMN_NAME | COLUMN_LABEL_NAME | Text | HARDCODED(코드)+DB값 | 0 | 숨김 | — | — | 196 |
| 그 외 | COLUMN_NAME | COLUMN_LABEL_NAME | Combo (`dtValidYN` = `biz:CommonData.YesOrNo`) | HARDCODED(코드)+DB값 | 50 | 표시 | Combo 셀(편집 잠금 여부 확인 필요) | 가로·세로 Center, DAY_CODE SAT → 파랑 / SUN → 빨강 | 203·208 |

### 4-3. 헤더 3단 Span
| 헤더 행 | 내용 | 높이 | 근거 |
|---|---|---|---|
| 0행 | LARGE_CLASS_LABEL_NAME (그룹 Span) | 20 | 215·243 |
| 1행 | SMALL_CLASS_LABEL_NAME (그룹 Span), Large 그룹 시작 열에 `"SUM"`(행 Span 2) | 20 | 216·221·230·241·244 |
| 2행 | COLUMN_LABEL_NAME, Small 그룹 시작 열에 `"SUM"` | 30(222) / 20(231·242) | 222·231·242 |

### 4-4. 표시 토글 (SetSpreadColumn, Tag 접두어)
| Tag 접두어 | Visible | 근거 |
|---|---|---|
| `D_` | true | 350 |
| `M_` | `chkSum.Checked` | 355 |
| `W_` | 350에서 true → 355에서 `chkSum.Checked`(최종값 실행 확인 필요) | 350·355 |

호출 시점: `InitSpread`(160), `FindData_Main`(484, 결과 행이 있을 때만), `chkSum_CheckedChanged`(330·335).

### 4-5. Designer 헤더 스타일
HorizontalAlignment/VerticalAlignment = General, NoteIndicatorColor = Red, Parent = `ColumnHeaderDefaultEnhanced` (628~631).

---

## 5. 액션 명세

| ID | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A-01 | 화면 Load | `Form_Load` | InitControls → GetBucketType | `DM.DM0003_GET_BUCKET_TYPE_CODE` (SP `DM0003_GET_BUCKET_TYPE_CODE`) | 바인딩 대상 컨트롤 **확인 필요** |
| A-02 | 화면 Load | `Form_Load` | CreateSpread → AddSheet → InitSpread → GetSpdTitle → SetSheetHeaderColumn → InitSpreadDateColumn → SetSpreadColumn | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` (SP `SCP0009_GET_SHEET_CALENDAR_3SPAN`), 날짜 Combo 데이터 `biz:CommonData.YesOrNo` | `spdMain_Sheet1` 헤더 3단, META 6컬럼과 날짜 컬럼 생성 |
| A-03 | 조회 버튼 | FindButton → `FindData_Main` | GetCheckedListValue ×2(442·443) → 조회 → InitSpread(헤더 재생성) → 결과가 있으면 SetSpreadColumn | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` (SP `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`), `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | `spdMain` 데이터 바인딩 |
| A-04 | 저장 버튼 | SaveButton → `SaveData_Main` | p_* 행 구성 → GetChanges(ROW_ID) → (저장 호출 **미검출**) → FindData_Main | 저장 엔드포인트 **확인 필요** → `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 재조회 결과 표시 |
| A-05 | 그리드 셀 더블클릭 | `SpdMain_CellDoubleClick` | **확인 필요** | 없음(검출 기준) | 확인 필요 |
| A-06 | 그리드 스크롤 | `SpdMain_TopChange` | **확인 필요** | 없음(검출 기준) | 확인 필요 |
| A-07 | Division 변경 | `CboDivision_SelectedIndexChanged` | **확인 필요** | 없음(검출 기준) | 확인 필요 |
| A-08 | Plant Site 변경 | `ClbPlantSite_SelectedIndexChanged` | **확인 필요** | 없음(검출 기준) | 확인 필요 |
| A-09 | Day of the week 변경 | `CboDayWeek_SelectedIndexChanged` | GetCheckedListValue(672) → 조건에 따라 `cboInputValue.Enabled` false(675)/true(679) | 없음 | cboInputValue 활성 상태 |
| A-10 | Input 버튼 | `BtnInput_Click` | GetCheckedListValue ×2(695·696) → 그리드 일괄 입력(범위 확인 필요) | 없음(검출 기준) | spdMain 셀 값(확인 필요) |
| A-11 | Day of the week 목록 | (필드 초기화 `dtDayWeek` :49) | Lookup 공통코드 조회 | `biz:CommonData.CommonDataList` [code=LookupCommon] | cboDayWeek 바인딩 여부 **확인 필요** |
| A-12 | Sum 체크 변경 | `chkSum_CheckedChanged` | SetSpreadColumn(330/335) | 없음 | M_/W_ 컬럼 Visible = chkSum.Checked |

---

## 6. 검증·메시지

| # | 검증 | 사실 | 메시지 |
|---|---|---|---|
| V1 | Division 필수 | 라벨 `Division*` | 메시지 ID/문구 **확인 필요** |
| V2 | Period 필수 | 라벨 `Period*` | **확인 필요** |
| V3 | 조회 결과 없음 | `GetMaxRowIndex() > 0` 이 아니면 SetSpreadColumn 생략 | 결과 없음 메시지 **확인 필요** |
| V4 | 저장 변경분 없음 | GetChanges(ROW_ID)로 변경분 추출 | 변경 없음 메시지 **확인 필요** |
| V5 | 저장 성공/실패 | 저장 SP 미검출 | **확인 필요** |
| V6 | Input Value 비활성 | cboDayWeek 따라 Enabled false/true | 메시지 없음(확인 필요) |

> TO-BE 메시지는 AS-IS MSG ID를 그대로 쓰지 말고, 문구 기준으로 TO-BE ID를 찾아 매핑합니다(프로젝트 규약).

---

## 7. 권한 (C/R/U/D)

| 권한 | 사실 | 근거 |
|---|---|---|
| R (조회) | FindButton 사용 | flow.csv |
| C/U (저장) | SaveButton 사용, `p_user_id` 전달. 신규와 수정의 구분은 **확인 필요** | flow.csv, meta_reads.csv |
| D (삭제) | 삭제 버튼·엔드포인트 미검출 | — |
| 메타 | TB_FX_GroupMenuAuth 4행 — 값 **확인 필요** | Fact Pack §8 |
| 기타 | EditButton 메서드(288) — 진입 여부 **확인 필요** | grid_code.csv |

---

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| # | 항목 | AS-IS | To-Be |
|---|---|---|---|
| T1 | 그리드 | FarPoint FpSpread, 헤더 3행 ColumnHeaderSpan | Wijmo FlexGrid `columnHeaders` 3행 + 병합(allowMerging) 또는 컬럼 그룹. SUM 헤더 Span 재현 |
| T2 | 동적 날짜 컬럼 | SCP0009 결과로 DB 루프 AddCombo/AddText | 조회 응답의 컬럼 정의로 columns 동적 생성. `B_` 포함 컬럼은 visible=false |
| T3 | Y/N 콤보 셀 | `dtValidYN` = Data.Common(YesOrNo) | FlexGrid `DataMap`(Y/N), 셀에 NAME 표시 |
| T4 | 주말 색상 | ForeColor SAT 파랑 / SUN 빨강 | `formatItem` 에서 DAY_CODE 기준 class 적용(inline style 금지) |
| T5 | 표시 토글 | Tag 접두어 D_/M_/W_ + chkSum | 컬럼 Tag(바인딩명 접두어)로 visible 계산. chkSum 노출 정책 결정 필요(AS-IS Visible=false) |
| T6 | 체크 목록 | UsrCheckedList / GetCheckedListValue(CODE) | MultiSelect, 선택값 배열 → SP 다중값 인자 |
| T7 | Oracle 변환 | SP 안에 `STRING_SPLIT`, `#TBLDYNAMICPIVOT_SCP0096`(임시 테이블), 동적 SQL PIVOT | `STRING_SPLIT` 은 MSSQL 키워드라 금지 → 다중값은 GTT 적재나 Oracle 분해 방식으로 대체. `#` 임시 테이블 → GTT(DDL 동반). 동적 PIVOT은 IN절과 SELECT 변수를 분리 |
| T8 | 일괄 입력 | btnInput (조회조건 패널 안) | 프로젝트 규약(조회영역 일괄 입력 = SubTitle 버튼 + InputModal, hook #155)을 적용할지는 설계 확정 시 확인 |
| T9 | 저장 | 저장 SP 미검출 | 저장 SP를 확정한 뒤 PKG로 구현. `p_is_save_defalut` 철자는 계약 확정 시 결정 |
| T10 | 미사용 후보 | `usrButton1`, `cboBucketType_SelectedIndexChanged`, DM0003 결과 사용처 | 사용처를 확인한 뒤 이관할지 결정 |

---

## 9. 미확정

1. 저장 SP/엔드포인트와 저장 대상 테이블 (최우선)
2. 조회조건 배치 순서(Location 미추출)와 컨트롤 초기값
3. META 6개 컬럼의 정렬·폭·편집 여부·고정 여부
4. `SpdMain_CellDoubleClick` / `SpdMain_TopChange` / `CboDivision_SelectedIndexChanged` / `ClbPlantSite_SelectedIndexChanged` 본문
5. `cboInputValue` Enabled 분기 조건, `BtnInput_Click` 입력 범위
6. `cboDayWeek` 단일/다중 여부와 목록 원천(`biz:CommonData.CommonDataList`)
7. `chkSum` 노출 정책, `W_` 최종 표시값
8. `usrButton1` 용도, DM0003 결과 사용처
9. 메뉴 위치, TB_FX_GroupMenuAuth 권한 값
10. 456행 주석 처리 호출은 현행 아님 → 설계 대상에서 제외
