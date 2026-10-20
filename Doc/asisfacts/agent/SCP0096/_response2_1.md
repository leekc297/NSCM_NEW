=== FILE: business_analysis.md ===
# SCP0096 — Shipment Working Day OSP 업무분석서

> 근거: AsisFacts 정적 추출 Fact Pack과 1차 분석서(analysis / web_components / tobe_design)입니다. Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.
> 연계 문서: 화면설계서(screen_design.md) §5 액션 명세, 단위테스트(unit_test.md) 근거 열과 엔드포인트 이름을 똑같이 씁니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID | SCP0096 | 클래스 `SCP0096_Shipment_Working_Day_OSP` |
| 화면명 | Shipment Working Day OSP | Designer.cs:663 `this.Text` |
| 도메인 / 분류 | SCP / Master | 경로 `06.UIL\GSCM.SCP.Forms.UIL\Master\...` |
| 목적 | Division과 Plant Site별로 기간(Period) 안의 일자 단위 Shipment Working Day(출하 가능 여부 Y/N) 값을 조회하고 저장합니다 | SP 이름 `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, 날짜 컬럼이 YesOrNo 콤보(:203), 저장 파라미터 `p_yyyymmdd`·`p_shipment_yn`(:570~:571) |
| 범위 | 조회(FindButton), 저장(SaveButton), 그리드 일괄 입력(btnInput), Sum 컬럼 표시 토글(chkSum) | flow.csv, events.csv |
| 범위 밖 | 저장 SP는 Fact Pack에서 추출되지 않았습니다 → **확인 필요** | §8 |

> 업무 목적 문장은 SP 이름, 컬럼 구성, 저장 파라미터 이름에서 읽은 것입니다. 업무 담당자의 공식 정의는 **확인 필요**입니다.

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 |
|---|---|---|---|
| S1 | 화면을 엽니다 | `Form_Load` → InitControls → GetBucketType에서 `DM.DM0003_GET_BUCKET_TYPE_CODE` 호출. 이어서 CreateSpread → InitSpread → GetSpdTitle에서 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 호출 | 시트 `Shipment Working Day OSP`가 만들어집니다. 메타 고정 컬럼 6개와 SCP0009 결과로 만든 달력 날짜 컬럼, 헤더 3행이 구성됩니다 |
| S2 | Division*, Plant Site, Period*를 넣고 조회합니다 | FindButton → FindData_Main(:457)에서 `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` 호출. clbPlantSite 값은 GetCheckedListValue(:442/:443)로 추출합니다. InitSpread → GetSpdTitle에서 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`을 다시 호출합니다 | 그리드에 조회 결과가 표시됩니다. `siMain.GetMaxRowIndex() > 0`(:484)이면 SetSpreadColumn으로 컬럼 표시를 다시 적용합니다 |
| S3 | Day of the week(cboDayWeek)를 선택합니다 | `CboDayWeek_SelectedIndexChanged` → GetCheckedListValue(:672) → cboInputValue.Enabled = false(:675) 또는 true(:679) | Input Value 콤보가 활성 또는 비활성으로 바뀝니다. 분기 조건은 **확인 필요**입니다 |
| S4 | Input Value를 고르고 Input 버튼을 누릅니다 | `BtnInput_Click` → GetCheckedListValue(:695, :696) | 그리드에 일괄 입력하는 것으로 보입니다. 상세 로직은 **확인 필요**입니다 |
| S5 | Sum 체크박스를 토글합니다 | `chkSum_CheckedChanged` → SetSpreadColumn(:330/:335) | 태그가 `M_`·`W_`로 시작하는 컬럼의 Visible이 chkSum.Checked로 바뀝니다(:355) |
| S6 | 그리드 셀을 수정하고 저장합니다 | SaveButton → SaveData_Main → GetChanges(:609)로 변경행을 모아 파라미터 행을 만들고, FindData_Main으로 재조회합니다(`SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`) | 저장한 뒤 재조회 결과가 표시됩니다. 저장 호출 대상은 **확인 필요**입니다 |
| S7 | Division이나 Plant Site를 바꿉니다 | `CboDivision_SelectedIndexChanged`, `ClbPlantSite_SelectedIndexChanged` | 내부 동작은 **확인 필요**입니다 |
| S8 | 그리드를 더블클릭하거나 스크롤합니다 | `SpdMain_CellDoubleClick`, `SpdMain_TopChange` | 내부 동작은 **확인 필요**입니다 |

## 3. 업무 흐름도 (텍스트)

```
[화면 열기]
  └─ Form_Load
       ├─ InitControls → GetBucketType ─────────────▶ DM.DM0003_GET_BUCKET_TYPE_CODE
       └─ CreateSpread (AddSheet "Shipment Working Day OSP")
            └─ InitSpread
                 ├─ GetSpdTitle ────────────────────▶ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN
                 ├─ SetSheetHeaderColumn(siMain, 3)  (메타 6컬럼, 헤더 3행)
                 ├─ InitSpreadDateColumn            (MEASURE 다음부터 날짜 컬럼)
                 └─ SetSpreadColumn                 (D_/W_/M_ 표시 규칙)
[조건 입력] Division* / Plant Site / Period* / (Sum)
[조회] FindButton
  └─ FindData_Main ─────────────────────────────────▶ SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP
       └─ InitSpread → GetSpdTitle ─────────────────▶ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN
       └─ if GetMaxRowIndex() > 0 → SetSpreadColumn
[편집 보조] cboDayWeek 선택 → cboInputValue Enabled 전환 → btnInput(Input) → 그리드 일괄 입력(상세 확인 필요)
[저장] SaveButton
  └─ SaveData_Main: GetChanges → 파라미터 행 구성 → (저장 호출: 확인 필요)
       └─ FindData_Main 재조회 (위 [조회]와 같음)
```

## 4. 업무 규칙 (사실 기반)

| # | 규칙 | 내용 | 근거 |
|---|---|---|---|
| R1 | 필수 조회조건 | 라벨에 `*`가 붙은 Division*, Period*는 필수로 표시됩니다. 실제 검증 코드와 메시지는 **확인 필요**입니다 | props layoutControlItem4/2 Text |
| R2 | Plant Site 다중 선택 | clbPlantSite(UsrCheckedList) 값은 GetCheckedListValue로 CODE를 추출합니다 | FindData_Main:442/443 |
| R3 | 날짜 컬럼 생성 | SCP0009 결과(dsSpdTitle) 행마다 MEASURE 다음 위치(`GetColumnIndex(MEASURE)+1`)부터 컬럼을 만듭니다 | InitSpread:159 |
| R4 | `B_` 컬럼 | COLUMN_NAME에 `B_`가 들어 있으면(IndexOf > 0) 텍스트 컬럼을 만듭니다. 너비 0, Visible=false입니다 | InitSpreadDateColumn:196 |
| R5 | 일자 값 컬럼 | R4가 아닌 컬럼은 YesOrNo 콤보(`dtValidYN`)로 만듭니다. 너비 50, 표시, 가운데 정렬입니다 | :203 |
| R6 | 주말 표시 | DAY_CODE가 `SAT`이면 파랑, `SUN`이면 빨강 글자색입니다 | :208 |
| R7 | 헤더 3행 | 0행 = LARGE_CLASS_LABEL_NAME 병합, 1행 = SMALL_CLASS_LABEL_NAME 병합, "SUM" 헤더(1~2행 span 또는 2행)입니다 | :215~:244 |
| R8 | 컬럼 표시 규칙 | 태그가 `D_`·`W_`로 시작하면 Visible=true(:350), `M_`·`W_`로 시작하면 Visible=chkSum.Checked(:355)입니다. `W_`의 최종 결과(if/else-if 구조)는 **확인 필요**입니다 | SetSpreadColumn |
| R9 | Sum 기본값 | chkSum.Checked=false(DefineProperty:121)입니다. Designer에서는 Visible=false(:346)입니다 | props |
| R10 | 조회 후 표시 재적용 | `siMain.GetMaxRowIndex() > 0`일 때만 SetSpreadColumn을 호출합니다 | FindData_Main:484 |
| R11 | Input Value 활성 | cboDayWeek 선택 결과에 따라 cboInputValue.Enabled가 false(:675) 또는 true(:679)가 됩니다. 조건은 **확인 필요**입니다 | CboDayWeek_SelectedIndexChanged |
| R12 | 저장 대상 행 | 변경행만 대상입니다(GetChanges, ROW_ID 기준) | SaveData_Main:609 |
| R13 | 저장 파라미터 | p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut(원문 철자), p_working_time_default. 블록이 :570~:573과 :578~:581 두 곳으로 나뉩니다(분기 조건 **확인 필요**) | meta_reads |
| R14 | 저장 후 재조회 | 저장한 뒤 FindData_Main을 호출합니다 | flow.csv |
| R15 | 버킷 규칙 | DM0003(Bucket Type 코드)은 Form_Load에서 호출합니다. 결과를 바인딩하는 컨트롤은 **확인 필요**입니다(cboBucketType은 컨트롤 목록에 없음) | GetBucketType:394 |

## 5. 데이터 흐름 표

| 엔드포인트 | SP | 호출 위치 | 읽기 테이블 | 쓰기 테이블 |
|---|---|---|---|---|
| `biz:CommonData.CommonDataList` [code=LookupCommon] | — (코드 분기 UP_FX_GetCommonDataList) | `<field:dtDayWeek>`:49 (진입점 미연결) | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | 없음 |
| `biz:CommonData.YesOrNo` | — | `<field:dtValidYN>`:51. InitSpreadDateColumn:203 콤보 데이터로 사용 | 확인 필요 (Data.CallBizData) | 없음 |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | `DM0003_GET_BUCKET_TYPE_CODE` | GetBucketType:394 (Form_Load) | SCM_ADM_LOOKUP_MASTER_DETAIL | 없음 |
| `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | `SCP0009_GET_SHEET_CALENDAR_3SPAN` | GetSpdTitle:831 (Form_Load / FindButton / SaveButton) | SCM_SYS_CALENDAR_M | 없음 |
| `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | FindData_Main:457 (FindButton / SaveButton 재조회) | SCP_MST_SHIPMENT_WORKING_DAY_OSP, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_LINE_OSP, SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT (REF STRING_SPLIT, DYNAMIC SQL) | #TBLDYNAMICPIVOT_SCP0096 (임시 테이블 INSERT) |
| (저장) | 확인 필요 | SaveData_Main | 확인 필요 | 확인 필요 |

## 6. Division·권한별 변형

- **Division**: 메타 기준 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 모두 6/0(필수+기본 6, 선택 0)입니다. 최종 Grid도 모두 6컬럼입니다. 코드에는 division 변수를 비교하는 분기가 없습니다. 따라서 **division별 변형은 없습니다.**
- 날짜 동적 컬럼 수는 Period(SCP0009 결과)에 따라 달라지고, division과는 관계가 없습니다.
- **권한**: TB_FX_GroupMenuAuth 4행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_Favorite 1행이 있습니다. 그룹별 C/R/U/D 값은 **확인 필요**입니다(`dbmeta_dbo_TB_FX_GroupMenuAuth.csv`). 코드에서 확인된 버튼 경로는 FindButton, SaveButton, EditButton(:288)입니다.

## 7. 외부 인터페이스

Fact Pack에는 외부 시스템 인터페이스가 없습니다(해당 없음).

## 8. 미확정·확인 필요

| # | 항목 | 근거 |
|---|---|---|
| 1 | 저장 SP/엔드포인트와 파라미터 계약 | SaveData_Main, meta_reads :558~:600 |
| 2 | `dr["A"]`/`row["A"]` 컬럼 A의 의미 | :558, :600 |
| 3 | `p_is_save_defalut`(원문 철자)와 Default 저장 분기, 파라미터 2블록(:570~:573 / :578~:581)의 분기 조건 | meta_reads |
| 4 | DM0003 결과를 바인딩하는 컨트롤과 `cboBucketType_SelectedIndexChanged`(:311/:316, 배선 없음)를 쓰는지 여부 | grid_code |
| 5 | dtDayWeek(LookupCommon) 코드값과 cboDayWeek에 바인딩되는지 여부 | :49 |
| 6 | cboDivision / clbPlantSite / cboInputValue 데이터 원천 | 미추출 |
| 7 | SpdMain_CellDoubleClick / SpdMain_TopChange / CboDivision_SelectedIndexChanged / ClbPlantSite_SelectedIndexChanged 로직 | 미추출 |
| 8 | BtnInput_Click 일괄 입력 상세, CboDayWeek 분기 조건 | :672~:696 |
| 9 | 필수값(Division*, Period*) 검증 코드와 메시지 | 미추출 |
| 10 | SetSpreadColumn의 W_ 이중 조건 구조 | :350, :355 |
| 11 | chkSum을 런타임에 다시 표시하는지 여부 | Designer :346 |
| 12 | SP 결과 컬럼 접두어(D_/W_/M_/B_) 체계와 동적 PIVOT 매핑 | SP DYNAMIC |
| 13 | 그룹별 권한 값 | TB_FX_GroupMenuAuth |
| 14 | 456행 주석 처리 호출(SCP.SCP0019_GET_WORKING_TIME)은 현행 기능이 아니므로 분석 대상에서 뺐습니다 | commented_calls.csv |

=== FILE: screen_design.md ===
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

=== FILE: unit_test.md ===
# SCP0096 — Shipment Working Day OSP 단위테스트

> 근거 열에는 업무분석서 §5와 화면설계서 §5의 엔드포인트·SP·핸들러·시트 이름을 원문 그대로 씁니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 기대결과에 "확인 필요"가 있는 케이스는 As-Is 동작을 확정한 뒤 기대값을 채워야 합니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0096-001 | 초기화 | 메뉴 권한 보유 | 화면을 엽니다 | — | Bucket Type 코드 조회가 1회 호출되고 오류가 없습니다 | `Form_Load`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SCP0096-002 | 초기화 | 메뉴 권한 보유 | 화면을 열고 spdMain을 확인합니다 | — | 시트 `Shipment Working Day OSP`가 만들어지고 헤더가 3행이며, 달력 헤더 조회가 호출됩니다 | `Form_Load`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `SCP0009_GET_SHEET_CALENDAR_3SPAN`, `Shipment Working Day OSP` |
| TC-SCP0096-003 | 초기화 | 화면 로드 완료 | chkSum 상태를 확인합니다 | — | chkSum Checked=false. Designer Visible=false(런타임 표시 여부 확인 필요) | `Form_Load`, `chkSum_CheckedChanged` |
| TC-SCP0096-004 | 그리드 | 화면 로드 완료 | spdMain_Sheet1의 고정 컬럼 헤더를 확인합니다 | — | Division, Plant Site ID, Plant Site, Measure, Working Time Default, Last Input Date 6개 메타 컬럼이 표시됩니다 | `Shipment Working Day OSP` (SetSheetHeaderColumn) |
| TC-SCP0096-005 | 그리드 | 날짜 컬럼 생성 | MEASURE 다음 날짜 컬럼 중 COLUMN_NAME에 `B_`가 들어 있는 컬럼을 확인합니다 | Period 임의 | 해당 컬럼은 너비 0으로 숨김 처리됩니다 | `Shipment Working Day OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-006 | 그리드 | 날짜 컬럼 생성 | `B_`가 아닌 날짜 셀을 클릭해 콤보 목록을 엽니다 | — | YesOrNo 콤보, 너비 50, 가운데 정렬로 표시됩니다 | `Shipment Working Day OSP`, `biz:CommonData.YesOrNo` |
| TC-SCP0096-007 | 그리드 | Period에 토·일 포함 | 날짜 컬럼 글자색을 확인합니다 | 주말 포함 기간 | DAY_CODE SAT = 파랑, SUN = 빨강입니다 | `Shipment Working Day OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-008 | 그리드 | Period 지정 | 헤더 병합을 확인합니다 | — | 0행 LARGE_CLASS_LABEL_NAME 병합, 1행 SMALL_CLASS_LABEL_NAME 병합, "SUM" 헤더가 표시됩니다 | `Shipment Working Day OSP`, `SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-009 | 조회 | 데이터 있는 조건 | cboDivision, clbPlantSite, dCalendar를 넣고 조회(FindButton)합니다 | Division=데이터 있는 값, Plant Site 1개 이상 체크, Period=유효 기간 | 결과가 바인딩되고 GetMaxRowIndex() > 0이면 SetSpreadColumn으로 D_/W_ 컬럼이 표시됩니다 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-010 | 조회 | 데이터 없는 조건 | 조회(FindButton)합니다 | 데이터가 없는 Plant Site/Period | 그리드가 비고 SetSpreadColumn은 호출되지 않습니다(:484). 안내 메시지는 확인 필요 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-011 | 조회 | SP 오류 유발(DB 연결 불가 등) | 조회(FindButton)합니다 | — | 오류 메시지가 표시되고 화면이 유지됩니다(메시지 문구 확인 필요) | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-012 | 조회 | — | cboDivision 또는 dCalendar를 비우고 조회합니다 | Division 빈값 / Period 빈값 | 필수값 검증 메시지가 표시됩니다(검증 코드·문구 확인 필요) | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-013 | 조회 | 조회 완료 | Period를 바꿔 다시 조회합니다 | 기간 변경 | 날짜 컬럼이 새 기간 기준으로 다시 만들어집니다 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `Shipment Working Day OSP` |
| TC-SCP0096-014 | 저장 | 조회 완료 | 날짜 셀 값을 Y↔N으로 바꾸고 저장(SaveButton)합니다 | 셀 1건 변경 | 변경행만 저장 대상이 되고, 저장한 뒤 재조회가 실행되어 변경값이 반영됩니다(저장 엔드포인트 확인 필요) | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-015 | 저장 | 조회 완료, 변경 없음 | 저장(SaveButton)합니다 | — | 저장 대상 0건 처리(메시지·동작 확인 필요) | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-016 | 이벤트 | 조회 완료 | chkSum을 체크합니다 | Checked=true | 태그가 M_/W_로 시작하는 컬럼이 표시됩니다 | `chkSum_CheckedChanged`, `Shipment Working Day OSP` |
| TC-SCP0096-017 | 이벤트 | TC-016 이후 | chkSum 체크를 풉니다 | Checked=false | M_ 컬럼이 숨겨집니다(W_ 최종 결과 확인 필요) | `chkSum_CheckedChanged`, `Shipment Working Day OSP` |
| TC-SCP0096-018 | 이벤트 | 화면 로드 완료 | cboDayWeek 값을 바꿉니다 | 선택값 변경 | 선택에 따라 cboInputValue.Enabled가 false 또는 true로 바뀝니다(분기 조건 확인 필요) | `CboDayWeek_SelectedIndexChanged` |
| TC-SCP0096-019 | 이벤트 | 조회 완료, cboInputValue 활성 | cboDayWeek, cboInputValue를 고르고 btnInput을 클릭합니다 | 요일·입력값 선택 | 그리드에 일괄 입력됩니다(대상 범위 확인 필요) | `BtnInput_Click`, `Shipment Working Day OSP` |
| TC-SCP0096-020 | 이벤트 | 화면 로드 완료 | cboDivision 값을 바꿉니다 | 다른 Division | 연쇄 동작 확인 필요(clbPlantSite 목록 갱신 여부 등) | `CboDivision_SelectedIndexChanged` |
| TC-SCP0096-021 | 이벤트 | 화면 로드 완료 | clbPlantSite 항목을 체크하거나 해제합니다 | 항목 변경 | 동작 확인 필요 | `ClbPlantSite_SelectedIndexChanged` |
| TC-SCP0096-022 | 이벤트 | 조회 완료 | spdMain 셀을 더블클릭합니다 | 임의 셀 | 동작 확인 필요(팝업 여부 포함) | `SpdMain_CellDoubleClick` |
| TC-SCP0096-023 | 이벤트 | 조회 완료(행 다수) | spdMain을 세로로 스크롤합니다 | — | 동작 확인 필요 | `SpdMain_TopChange` |
| TC-SCP0096-024 | division | 데이터 존재 | cboDivision을 40, 81, EE로 각각 조회해 고정 컬럼을 비교합니다 | 40 / 81 / EE | 세 division 모두 메타 6컬럼이 같습니다(division 변형 없음) | `Shipment Working Day OSP`, `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-025 | 초기화 | 화면 로드 완료 | cboDayWeek 목록을 확인합니다 | — | LookupCommon 공통코드 목록 바인딩 여부를 확인합니다(코드값·바인딩 확인 필요) | `biz:CommonData.CommonDataList` |
| TC-SCP0096-026 | 권한 | 조회 전용 그룹 계정 | 화면을 열고 저장(SaveButton)을 시도합니다 | — | 권한 값(TB_FX_GroupMenuAuth)에 따라 저장 버튼이 제어됩니다(값 확인 필요) | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |

### 커버리지 점검

| 대상 | TC |
|---|---|
| `Form_Load` | 001, 002, 003 |
| `SpdMain_CellDoubleClick` | 022 |
| `SpdMain_TopChange` | 023 |
| `CboDivision_SelectedIndexChanged` | 020 |
| `ClbPlantSite_SelectedIndexChanged` | 021 |
| `CboDayWeek_SelectedIndexChanged` | 018 |
| `BtnInput_Click` | 019 |
| `chkSum_CheckedChanged` | 003, 016, 017 |
| `biz:CommonData.CommonDataList` | 025 |
| `biz:CommonData.YesOrNo` | 006 |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | 001 |
| `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | 009~012, 014, 015, 024, 026 |
| `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 002, 005, 007, 008, 009, 013, 014 |
| 시트 `Shipment Working Day OSP` | 002, 004~008, 013, 016, 017, 019, 024 |
| 빈 결과 / 오류 응답 | 010 / 011 |
