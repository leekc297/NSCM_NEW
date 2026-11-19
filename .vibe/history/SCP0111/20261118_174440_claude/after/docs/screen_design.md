# SCP0111 Integration PSI — 화면설계서

> 근거는 Fact Pack(controls.csv / props.csv / events.csv / flow.csv / grid_*.csv)입니다. 없는 내용은 **확인 필요**로 적었습니다. 주석 처리된 호출은 0건입니다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SCP0111 |
| 화면 명칭 | `Integration PSI` (Designer.cs:905) |
| 도메인 / 분류 | SCP / Analysis |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행이 있지만 값이 Fact Pack에 없음) |
| 시트 | `Integration PSI` 1개 (`spdMain` / `spdMain_Sheet1`) |
| 공통 버튼 | Find(조회) / Edit(편집) / Save(저장). Fact Pack의 버튼 오버라이드 기준입니다. |

---

## 2. 화면 레이아웃

### 2-1. 분할 구조 (props.csv + controls.csv parent 체인)
- props.csv에 **SplitContainer가 없습니다**(Orientation·SplitterDistance 사실 0건). 그래서 화면은 Dock으로 위/아래 2단 구성입니다.
- parent 체인:
  - `this` → `pnlCondition` (UsrConditionPanel, Dock=Top, 2021×112, PanelType.HidePanel) → `usrLayoutControl2` (Dock=Fill, 2021×112) → 조회조건 컨트롤 13개
  - `this` → `spdMain` (FpSpread, Dock=Fill, 2021×865) — 시트 `spdMain_Sheet1`(parent 미추출)
  - `usrButton1`: parent가 비어 있습니다(75×23). 화면에 배치되는지는 **확인 필요**입니다.
- 높이 비율(전체 977 = 112 + 865): 조회조건 **약 11.5%**, 그리드 **약 88.5%**.

### 2-2. 텍스트 와이어프레임

```
┌──────────────────────────── this : "Integration PSI" (2021 × 977) ───────────────────────────┐
│ [공통 툴바] Find · Edit · Save                                                                 │
├─ pnlCondition (Dock Top, 112px ≈ 11.5%, HidePanel) ────────────────────────────────────────────┤
│  usrLayoutControl2 / layoutControlGroup2 (Fill 2021×112)                                       │
│   Division* [cboDivision ▼]        Plan-date* [cboPlanDate ▼]      (Plan-type [cboPlanType ▼] 숨김) │
│   Period [cmbFromMonth ▼] ~ [cmbToMonth ▼]                         [☐ Qty < 0  (chkQty)]         │
│   Nick Name [txtNickName ⋯][btnNickName]  Model [txtItemId ⋯][btnItemId]                        │
│   Cell Model [txtCellItemId ⋯](btnCellItem_Id 숨김)                                              │
│   ※ 행/열 배치 순서는 좌표가 추출되지 않아 확인 필요. 위 그림은 항목 목록이며 순서를 보장하지 않습니다. │
├─ spdMain (Dock Fill, 865px ≈ 88.5%) ────────────────────────────────────────────────────────────┤
│  시트: Integration PSI (spdMain_Sheet1)                                                         │
│  │메타 컬럼(22 표시/2 숨김)│ M_ 월 컬럼(YYYYMM_NAME, 폭 75) × CalendarMonth 행 수 │              │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
팝업: Nick Name / Model 값 선택 수단(BtnNickName_Click / BtnItemId_Click) — 팝업 폼명 확인 필요
```

### 2-3. 레이아웃 아이템 크기 (props.csv 원문)
| LayoutControlItem | 연결 컨트롤 | Size | Text |
|---|---|---|---|
| lblCombo1 | cboDivision | 300×38 | `Division*` |
| PlanDate | cboPlanDate | 300×44 | `Plan-date*` |
| PlanType | cboPlanType | 290×44 | `Plan-type` |
| layoutControlItem2 | cmbFromMonth | 161×44 | `Period` |
| layoutControlItem5 | cmbToMonth | 161×44 | ` ~` |
| lblNickName | txtNickName | 322×38 | `Nick Name` |
| layoutControlItem3 | btnNickName | 43×29 | (Text 없음) |
| lblItemId | txtItemId | 350×38 | `Model` |
| layoutControlItem1 | btnItemId | 43×29 | `layoutControlItem3` |
| lblCellItem | txtCellItemId | 315×38 | `Cell Model` |
| layoutControlItem4 | btnCellItem_Id | 43×29 | (Text 없음) |
| layoutControlItem6 | chkQty | 315×44 | (Text 없음 — 컨트롤 Text `Qty < 0`) |

EmptySpaceItem 11개(emptySpaceItem1~11)가 있지만 좌표가 없어 위치는 **확인 필요**입니다.

---

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨 (props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트(후보) |
|---|---|---|---|---|---|---|
| `pnlCondition` | UsrConditionPanel | (없음) | Dock=Top, HidePanel | - | - | 공용 조회조건 영역 |
| `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2` | Dock=Fill | - | - | 조회조건 Grid 레이아웃 |
| `cboDivision` | UsrCombo | `Division*` (lblCombo1) | 확인 필요 | Y (`*`) | SelectedIndexChanged → `CboDivision_SelectedIndexChanged` | 공용 Division 콤보 |
| `cboPlanDate` | UsrCombo | `Plan-date*` (PlanDate) | 확인 필요 | Y (`*`) | SelectedIndexChanged → `CboPlanDate_SelectedIndexChanged` | 공용 콤보 |
| `cboPlanType` | UsrCombo | `Plan-type` (PlanType) | **Visible=false** | - | SelectedIndexChanged → `CboPlanType_SelectedIndexChanged` | 숨김 처리 — 노출 여부 확인 필요 |
| `cmbFromMonth` | UsrComboBox | `Period` (layoutControlItem2) | SetChangedPeriod DataBind:290 | 확인 필요 | - | 기간 From 콤보 |
| `cmbToMonth` | UsrComboBox | ` ~` (layoutControlItem5) | SetChangedPeriod DataBind:291 | 확인 필요 | - | 기간 To 콤보 |
| `txtNickName` | UsrMultiLineEditor | `Nick Name` (lblNickName) | 빈값(확인 필요) | - | - | 멀티라인 입력 |
| `btnNickName` | UsrButton | (layoutControlItem3 Text 없음) | 표시 | - | Click → `BtnNickName_Click` | 입력 옆 선택 버튼 |
| `txtItemId` | UsrMultiLineEditor | `Model` (lblItemId) | 빈값(확인 필요) | - | - | 멀티라인 입력 |
| `btnItemId` | UsrButton | `layoutControlItem3` (layoutControlItem1) | 표시 | - | Click → `BtnItemId_Click` | 입력 옆 선택 버튼 |
| `txtCellItemId` | UsrMultiLineEditor | `Cell Model` (lblCellItem) | 빈값(확인 필요) | - | - | 멀티라인 입력 |
| `btnCellItem_Id` | UsrButton | (layoutControlItem4 Text 없음) | **Visible=false** | - | (배선 없음) | 미노출 |
| `chkQty` | UsrCheckBox | `Qty < 0` | 확인 필요 | - | - | CheckBox |
| `usrButton1` | UsrButton | (없음) | parent 없음, 75×23 | - | (배선 없음) | 사용 여부 확인 필요 |
| `spdMain` | FpSpread | (없음) | Dock=Fill | - | CellDoubleClick → `SpdMain_CellDoubleClick` / TopChange → `SpdMain_TopChange` / CellClick → `spdMain_CellClick` | Wijmo FlexGrid |
| `spdMain_Sheet1` | SheetView | (props Text 없음 — 시트명 `Integration PSI`는 AddSheet:299 인자) | - | - | - | FlexGrid 단일 시트 |

비 UI 이벤트: `_defaultDataModel` Changed → `_defaultDataModel_Changed`(InitEvent:374). 폼: `this` Load → `Form_Load`(.ctor:167).

---

## 4. 그리드 명세 — 시트 `Integration PSI`

생성 순서는 AddSheet(`Integration PSI`, 1, 1, 35):299 → InitSheet:312 → SetSheetHeaderColumn(spdInfo, 1):333 → SetSpreadColumn:336 → SetCalendar:354입니다. 인자 `1, 1, 35`의 의미는 **확인 필요**입니다.

### 4-1. 메타 컬럼 (SCM_MST_SHEET_COLUMNS, 출처 META)
| # | 컬럼 | 헤더 | 타입 | 출처 | division별 표시 (14개 공통) | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | BOH_QTY | BOH | 확인 필요 | META | 기본 | 확인 필요 |
| 2 | CELL_CF | Cell Coversion Factor | 확인 필요 | META | 기본 | 확인 필요 |
| 3 | CELL_ITEM_ID | Cell Model | 확인 필요 | META | 기본 | 확인 필요 |
| 4 | CELL_MODEL_NICK_NAME | Cell Model Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| 5 | COMPANY_ID | Company | 확인 필요 | META | 기본 | 확인 필요 |
| 6 | DIVISION_ID | Division | 확인 필요 | META | 기본 | 확인 필요 |
| 7 | INCOTERMS | Incoterms | 확인 필요 | META | 기본 | 확인 필요 |
| 8 | ITEM_ID | Model | 확인 필요 | META | 기본 | 확인 필요 |
| 9 | LINE_ID | Line | 확인 필요 | META | 기본 | 확인 필요 (spdMain_CellClick이 dtLine을 참조) |
| 10 | MEASURE | MEASURE | 확인 필요 | META | 기본 → 조회 모드 숨김(1079), 편집 모드 폭 80(1070) | 확인 필요 |
| 11 | MEASURE_COLOR | MEASURE_COLOR | 확인 필요 | META | 숨김 | - |
| 12 | MEASURE_LABEL | Measure | 확인 필요 | META | 기본 | 확인 필요 |
| 13 | MEASURE_ORDER_NO | MEASURE_ORDER_NO | 확인 필요 | META | 숨김 | - |
| 14 | NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| 15 | OPERATION_GROUP | Operation | 확인 필요 | META | 기본 | 확인 필요 |
| 16 | PLAN_TYPE | Plan Type | 확인 필요 | META | 기본 | 확인 필요 |
| 17 | PLANT_ID | Plant | 확인 필요 | META | 기본 → 조회 모드 폭 0(1081), 편집 모드 폭 65(1072) | 확인 필요 |
| 18 | PLANT_ID_DESCRIPTION | Plant | 확인 필요 | META | 기본 | 확인 필요 |
| 19 | SEQ_FLAG | SEQ_FLAG | 확인 필요 | META | 기본 → 조회 모드 숨김(1078), 편집 모드 폭 60(1069) | 확인 필요 |
| 20 | TO_PRODUCT | To Product | 확인 필요 | META | 기본 | 확인 필요 |
| 21 | TO_SITE | To Site | 확인 필요 | META | 기본 → 조회 모드 폭 0(1082), 편집 모드 폭 75(1073) | 확인 필요 |
| 22 | TO_SITE_DESCRIPTION | To Site | 확인 필요 | META | 기본 | 확인 필요 |
| 23 | UOM | UOM | 확인 필요 | META | 기본 | 확인 필요 |
| 24 | VALUE_TYPE | Valuation Type | 확인 필요 | META | 기본 | 확인 필요 |

- `Cell Coversion Factor`는 메타 원문 철자를 그대로 옮겼습니다.
- 타입과 편집 가능 여부는 메타의 CELL_CONTROL_OBJECT_TYPE_CODE 등에서 정해지지만, 값이 Fact Pack에 없어 **확인 필요**입니다.
- SCM_MST_SHEET_MEASURE 7행(Measure 행 정의)의 값도 **확인 필요**입니다.

### 4-2. 코드 컬럼 (출처 HARDCODED / DB_DRIVEN)
| 구분 | 위치 | 컬럼·헤더 | 타입 | 출처 | 표시 | 편집 |
|---|---|---|---|---|---|---|
| 월 동적 컬럼 | SetCalendar:354 | 헤더 `YYYYMM_NAME` / 필드 `YYYYMM`, CalendarMonth 행마다 1개 | Num | DB_DRIVEN (`biz:CommonData.CommonDataList` [code=CalendarMonth]) | 표시, 폭 75, 병합 None | 확인 필요 |
| Tag 규칙 | SetSpreadColumn:392/396 | Tag `D_`·`W_` 접두 | - | HARDCODED | 숨김 | - |
| Tag 규칙 | SetSpreadColumn:396 | Tag `M_` 접두 | - | HARDCODED | 표시 | - |
| 헤더 스타일 | Designer:858~861 | ColumnHeaderDefaultEnhanced 상속, NoteIndicatorColor=Red, 정렬 General | - | HARDCODED | - | - |

### 4-3. Division별 표시
- 14개 division 모두 22컬럼으로 같습니다. 코드에 division 분기가 없습니다(grid_effective.csv).

---

## 5. 액션 명세

| 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|
| 화면 Load | `Form_Load` | GetEssPackLineAll:490 | `SCP.SCP0111_GET_ESS_PACK_LINE` | Line 목록 보관(dtLine인지 확인 필요) |
| 화면 Load | `Form_Load` | InitControls > GetBucketType:1095 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | 사용처 확인 필요 |
| 화면 Load | `Form_Load` | InitControls > SetChangedPeriod:287/288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | cmbFromMonth / cmbToMonth DataBind |
| 화면 Load | `Form_Load` | CreateSpread > InitSpread > SetCalendar:345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | 시트 `Integration PSI` 생성, 월 컬럼 추가 |
| cboDivision 변경 | `CboDivision_SelectedIndexChanged` | SetChangedPeriod:287/288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | Period 재바인딩 |
| cboPlanDate 변경 | `CboPlanDate_SelectedIndexChanged` | SetChangedPeriod:287/288, InitSpread > SetCalendar:345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | Period 재바인딩, 월 컬럼 재생성 |
| cboPlanType 변경 | `CboPlanType_SelectedIndexChanged` | SetChangedPeriod:287/288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | Period 재바인딩 |
| 데이터모델 변경 | `_defaultDataModel_Changed` | 1980 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | 반영 대상 확인 필요 |
| btnNickName 클릭 | `BtnNickName_Click` | 1887 | (없음) | `txtNickName.Text = sNickName` |
| btnItemId 클릭 | `BtnItemId_Click` | 1926 | (없음) | `txtItemId.Text = sItemId` |
| 그리드 셀 클릭 | `spdMain_CellClick` | 1781~1786 dtLine/drLine CODE·NAME | (없음) | 셀 반영 내용 확인 필요 |
| 그리드 더블클릭 | `SpdMain_CellDoubleClick` | 확인 필요 | (없음) | 확인 필요 |
| 그리드 스크롤 | `SpdMain_TopChange` | 확인 필요 | (없음) | 확인 필요 |
| Find | FindButton | FindData_Main:874 → InitSpread > SetCalendar:345 | `SCP.SCP0111_GET_INTEGRATION_PSI`, `biz:CommonData.CommonDataList` [code=CalendarMonth] | 시트 `Integration PSI`에 결과 바인딩 |
| Edit | EditButton | 554 / 622, SetVisibleSheetColumns | `biz:CommonData.CommonDataList` [code=CalendarMonth], [code=LookupCommon] | 편집 모드에서 SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE 표시 |
| Save | SaveButton | SaveData 1154/1205/1242/1511 → 1379 또는 1637 → FindData_Main:874 | `biz:CommonData.CommonDataList` [code=CalendarMonth]·[code=LookupCommon], `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN`, `SCP.SCP0111_SAVE_INTEGRATION_PSI`, `SCP.SCP0111_GET_INTEGRATION_PSI` | 저장 후 재조회. ADMIN/일반 분기 조건 확인 필요 |

---

## 6. 검증·메시지

| 항목 | 사실 | 비고 |
|---|---|---|
| 필수 조건 | `Division*`, `Plan-date*` 라벨에 `*`가 붙어 있습니다. | 검사 코드와 메시지 ID/문구는 **확인 필요** |
| 저장 성공/실패 메시지 | Fact Pack에 없습니다. | **확인 필요** (TO-BE는 문구로 TO-BE MSG ID를 찾아 매핑) |
| 조회 결과 0건 메시지 | Fact Pack에 없습니다. | **확인 필요** |

---

## 7. 권한 (C/R/U/D)

| 구분 | 사실 |
|---|---|
| R (조회) | FindButton → `SCP.SCP0111_GET_INTEGRATION_PSI` |
| U/C (편집·저장) | EditButton, SaveButton → `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN` / `SCP.SCP0111_SAVE_INTEGRATION_PSI`. 저장 SP가 SCP_ANL_PSI_INTEGRATION에 UPDATE·INSERT합니다. |
| D (삭제) | 사실 없음 |
| 그룹 판정 | EditButton:559, InsertRow:960, SaveData:1159에서 `NowGroupID`를 읽습니다. 조건은 **확인 필요**입니다. |
| 메타 | TB_FX_GroupMenuAuth 4행. 플래그 값은 **확인 필요**입니다. |

---

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 관점 | AS-IS 사실 | To-Be 고려점 |
|---|---|---|
| 그리드 | FpSpread, META(SetSheetHeaderColumn) + CalendarMonth 동적 월 컬럼 | Wijmo FlexGrid: 메타 컬럼과 동적 월 컬럼을 합쳐서 구성합니다. 월 컬럼은 조회할 때마다 다시 만들어야 합니다(CboPlanDate 변경 시 포함). |
| 표시 전환 | IsEditMode에 따라 SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE 폭·표시 전환 | 편집 모드 상태에 따라 컬럼 visible/width를 바꿔야 합니다. |
| Tag 규칙 | D_/W_ 숨김, M_ 표시 | 동적 컬럼의 접두 규칙을 그대로 옮겨야 합니다. 접두를 누가 붙이는지는 확인 필요입니다. |
| SP — MSSQL 잔존 | GET SP가 `STRING_SPLIT`을 참조하고, 동적 SQL을 씁니다. | Oracle에는 STRING_SPLIT이 없으므로 대체 구현이 필요합니다. |
| 임시 테이블 | GET 1종, SAVE 18종의 `#` 임시 테이블 | Oracle GTT 등으로 바꿔야 합니다. 저장 전 초기화 여부를 확인해야 합니다. |
| 배열 분해 | SAVE SP가 `SCM_ARR_SPL_CNT`/`SCM_ARR_SPL_VAL`을 참조합니다. | Oracle 대응 함수가 있어야 합니다. |
| 공통데이터 | `biz:CommonData.CommonDataList` CalendarMonth/LookupCommon (UP_FX_GetCommonDataList) | TO-BE 공통 콤보/코드 API에 매핑해야 합니다. |
| 숨김 컨트롤 | cboPlanType, btnCellItem_Id Visible=false, usrButton1 parent 없음 | 노출하지 않는 대상인지 확인해야 합니다. |

---

## 9. 미확정

1. 조회조건 실제 배치 순서와 좌표.
2. ADMIN/일반 저장 분기 조건.
3. Nick Name / Model 선택 팝업 폼, 값 원천.
4. `SpdMain_CellDoubleClick` / `SpdMain_TopChange` 동작, `spdMain_CellClick`이 셀에 반영하는 내용.
5. 메타 컬럼 타입·편집 가능 여부, SHEET_MEASURE 7행 내용.
6. AddSheet 인자 `1, 1, 35`의 의미.
7. `InsertRow` 진입점.
8. 검증·결과 메시지 원문.
9. 메뉴 위치.
