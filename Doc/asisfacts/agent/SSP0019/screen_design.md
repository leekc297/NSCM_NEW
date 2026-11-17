# SSP0019 Shipment Change History — 화면설계서

> 근거: Fact Pack(controls.csv, props.csv, events.csv, grid_effective.csv, grid_code.csv)
> 사실에 없는 값은 **확인 필요**로 적었습니다.

## 1. 화면 개요

| 항목 | 내용 |
|---|---|
| 화면 ID | SSP0019 |
| 화면 명칭 | Shipment Change History (폼 Text 원문 `SSP0019_ShipmentChangeHistory`, Designer.cs:780) |
| 클래스 | `SSP0019_ShipmentChangeHistory` |
| 메뉴 위치 | **확인 필요**(TB_FX_MenuItemInfo 4행 존재, 값 미추출) |
| 화면 유형 | 조회 전용(저장 엔드포인트 없음) |
| 엔드포인트 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY`, `SCP.GET_DATE_RANGE_1MONTH`, `biz:CommonData.CommonDataList` |

## 2. 화면 레이아웃

### 2-1. 분할 트리
- props.csv에 **SplitContainer가 없습니다**(Orientation·SplitterDistance 속성 없음). 화면은 Dock으로 나뉩니다.
- 부모 체인은 controls.csv의 parent 열을 그대로 옮겼습니다.

```
this (SSP0019_ShipmentChangeHistory)
├─ usrConditionPanel1  [UsrConditionPanel, Dock=Top, 1192×69, UsrPanelType=HidePanel]
│   └─ usrLayoutControl1  [UsrLayoutControl, Dock=Fill, 1192×69, Text="usrLayoutControl1"]
│       ├─ clbDivision       (238×21)  ← LayoutItem lcDivision     "Division"      286×26
│       ├─ clbFromSite       (136×21)  ← LayoutItem FromSite       "From Site"     197×24
│       ├─ clbToSite         (108×21)  ← LayoutItem ToSite         "To Site"       157×24
│       ├─ clbTransportMode  (114×21)  ← LayoutItem TransportMode  (Text 미추출)   204×28
│       ├─ clbIncomterms     (316×21)  ← LayoutItem Incotemrs      "Incoterms"     406×24
│       ├─ drpPeriod         (195×20)  ← LayoutItem ShipmentDate   "Shipment Date" 286×26
│       ├─ txtSoNo           (100×21)  ← LayoutItem lblSONo        "SO No"         157×28
│       ├─ txtItemId         (100×21)  ← LayoutItem lblItemId      "Model"         154×28
│       ├─ btnItemId         (39×24)   ← LayoutItem layoutControlItem2  (Text 없음) 43×28
│       ├─ txtConfirmId      (136×21)  ← LayoutItem layoutControlItem3 "Confirm ID" 202×28
│       └─ chkCurrent        (69×20, Text="Current") ← LayoutItem layoutControlItem1 73×24
│       (layoutControlGroup1 1192×72 / emptySpaceItem4 126×28 · emptySpaceItem6 53×24 · emptySpaceItem7 230×26
│        — LayoutItem·EmptySpace 의 parent 는 controls.csv 에 비어 있음 → 소속 그룹 확인 필요)
├─ splitter1  [Splitter, Dock=Bottom, 1192×3]
└─ spdMain  [FpSpread, Dock=Fill, 1192×577]
    └─ spdMain_Sheet1 [SheetView, parent 미추출] — 시트 'Shipment Change History'
```

### 2-2. 텍스트 와이어프레임 (상/하 분할, 높이 기준)
세로 합계 = 69 + 3 + 577 = 649px

```
┌──────────────────────────────────────────────────────────────── 1192 ┐
│ [조회조건] usrConditionPanel1 (HidePanel) — 69px ≈ 10.6%           │
│  Division[clbDivision▼] From Site[clbFromSite▼] To Site[clbToSite▼] │
│  (TransportMode)[clbTransportMode▼] Incoterms[clbIncomterms▼]       │
│  Shipment Date[drpPeriod From~To] SO No[txtSoNo] Model[txtItemId][btnItemId] │
│  Confirm ID[txtConfirmId] [☐ chkCurrent "Current"]                  │
│  ※ 행·열 좌표는 미추출 — 위 배치 순서는 정리용(확인 필요)               │
├──────────────────────────────────────────────── splitter1 3px ≈ 0.5% ┤
│ [그리드] spdMain — 577px ≈ 88.9%                                      │
│  시트 탭: Shipment Change History                                      │
│  컬럼 46개 표시(LAST_SEQ 숨김), REQUEST_NO = 이미지 셀                 │
└──────────────────────────────────────────────────────────────────────┘
```

- 버튼 영역: 화면 안에 조회 버튼 컨트롤은 없습니다. 진입점 `FindButton`은 프레임워크 공통 버튼으로 보이나 위치는 **확인 필요**합니다.
- 팝업: `btnItemId` 클릭 시 팝업이 뜨는지는 **확인 필요**합니다. 핸들러가 `txtItemId.Text = sItemId`를 설정하는 것만 확인됐습니다.
- splitter1이 Dock=Bottom이어서 실제 분할선 위치가 조건 영역과 그리드 사이인지는 **확인 필요**(컨트롤 추가 순서/Z-order에 따름)입니다.
- layoutControlGroup1의 높이(72)와 usrLayoutControl1의 높이(69)가 다릅니다. 원인은 **확인 필요**입니다.

## 3. 컨트롤 명세

라벨은 props.csv Text 원문입니다. 컨트롤 자체 Text와 LayoutItem Text를 나눠 적었습니다.

| 컨트롤명 | 타입 | 부모 | 라벨(Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|---|
| `usrConditionPanel1` | UsrConditionPanel | this | — (UsrPanelType=HidePanel) | — | — | — | 공통 조회조건 패널(접기 가능 여부 확인 필요) |
| `usrLayoutControl1` | UsrLayoutControl | usrConditionPanel1 | "usrLayoutControl1"(컨트롤 Text) | — | — | — | 조회조건 레이아웃(그리드형 폼) |
| `clbDivision` | UsrCheckedList | usrLayoutControl1 | LayoutItem lcDivision: "Division" | 확인 필요 | 확인 필요 | SelectedIndexChanged → `clbDivision_SelectedIndexChanged` | Wijmo MultiSelect 계열 다중선택 |
| `clbFromSite` | UsrCheckedList | usrLayoutControl1 | LayoutItem FromSite: "From Site" | 확인 필요 | 확인 필요 | — | 다중선택 콤보 |
| `clbToSite` | UsrCheckedList | usrLayoutControl1 | LayoutItem ToSite: "To Site" | 확인 필요 | 확인 필요 | — | 다중선택 콤보 |
| `clbTransportMode` | UsrCheckedList | usrLayoutControl1 | LayoutItem TransportMode: **Text 미추출(확인 필요)** | 확인 필요 | 확인 필요 | — | 다중선택 콤보 |
| `clbIncomterms` | UsrCheckedList | usrLayoutControl1 | LayoutItem Incotemrs: "Incoterms" | 확인 필요 | 확인 필요 | — | 다중선택 콤보 |
| `drpPeriod` | UsrDateRangePicker | usrLayoutControl1 | LayoutItem ShipmentDate: "Shipment Date" | `SCP.GET_DATE_RANGE_1MONTH` 결과(Form_Load) | 확인 필요 | (Form_Load에서 설정) | 기간(From~To) 입력 |
| `txtSoNo` | UsrMultiLineEditor | usrLayoutControl1 | LayoutItem lblSONo: "SO No" | 확인 필요 | 확인 필요 | — | 다건 입력 텍스트 |
| `txtItemId` | UsrMultiLineEditor | usrLayoutControl1 | LayoutItem lblItemId: "Model" | 확인 필요 | 확인 필요 | (btnItemId_Click 결과 반영) | 다건 입력 텍스트 |
| `btnItemId` | UsrButton | usrLayoutControl1 | LayoutItem layoutControlItem2: Text 미추출 | — | — | Click → `btnItemId_Click` | 찾기 버튼(팝업 여부 확인 필요) |
| `txtConfirmId` | UsrMultiLineEditor | usrLayoutControl1 | LayoutItem layoutControlItem3: "Confirm ID" | 확인 필요 | 확인 필요 | — | 다건 입력 텍스트 |
| `chkCurrent` | UsrCheckBox | usrLayoutControl1 | "Current"(컨트롤 Text) | 확인 필요 | — | CheckedChanged → `ChkCurrent_CheckedChanged` | 체크박스 |
| `spdMain` | FpSpread | this | — | 시트 1개 생성 | — | TopChange → `SpdMain_TopChange`, CellClick → `SpdMain_CellClick` | Wijmo FlexGrid |
| `spdMain_Sheet1` | SheetView | (미추출) | — | 시트명 `Shipment Change History` | — | — | FlexGrid 시트(단일) |

기타 컨트롤(참고): `splitter1`(Splitter, Dock=Bottom), `imageList1`(ImageList, REQUEST_NO 이미지 셀과 관련이 있는지는 확인 필요), `layoutControlGroup1`, emptySpaceItem4·6·7.

## 4. 그리드 명세 — 시트 `Shipment Change History`

- 생성 경로: `CreateSpread:318` AddSheet(인자 `spdMain ¦ SpdSheet.shtMain ¦ SpdSheet.shtMain ¦ 1 ¦ 1 ¦ 30`) → 319 GetSheetInfo → 321 ChangeSheet → `InitSpread:330` InitSheet → 332 `SetSheetHeaderColumn(spdInfo, 1)`(헤더 행 1개)
- 구성 방식: META(프레임워크) + 코드 변경(REQUEST_NO CellType)
- Designer 114~117줄: HorizontalAlignment=General, NoteIndicatorColor=Red, Parent="ColumnHeaderDefaultEnhanced", VerticalAlignment=General. 대상 객체는 **확인 필요**
- 컬럼 순서는 grid_effective.csv 행 순서(알파벳순)입니다. 실제 표시 순서·폭·정렬·고정·편집 여부는 SCM_MST_SHEET_COLUMNS 메타 원문으로 **확인 필요**
- 편집 가능 여부: 저장 엔드포인트가 없어 조회 전용으로 판단합니다. 컬럼별 Locked 설정은 추출되지 않았습니다(**확인 필요**)

| # | 컬럼 | 헤더 | 타입 | 출처 | division별 표시(14개 공통) | 편집 |
|---:|---|---|---|---|---|---|
| 1 | APPROVAL | Approval | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 2 | APPROVAL_DATE | Approval Date | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 3 | APPROVAL_DEPT_NAME | Approval Dept Name | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 4 | BEFORE_INCOTERMS | Before Incoterms | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 5 | BEFORE_QTY | Before QTY | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 6 | BEFORE_SHIPMENT_DATE | Before Shipment Date | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 7 | BEFORE_TRANSPORT_MODE | Before Trans Mode | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 8 | BUILDING | Building | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 9 | CHANGE_REASON_CODE | Change Reason | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 10 | CHANGE_REASON_DETAIL | Change Reason Detail | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 11 | CHANGE_TYPE | Change Type | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 12 | CONFIRM_ID | Confirm ID | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 13 | CUSTOMER_LT | L/T(Day) | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 14 | CUSTOMER_REQUIRMENT | Customer Requirement | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 15 | DIVISION_ID | Div | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 16 | END_CUSTOMER | End Customer | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 17 | ERP_SO_NO | SO No | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 18 | FCST_TYPE | FCST Type | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 19 | FROM_SITE | From Site | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 20 | INCOTERMS | Incoterms | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 21 | ITEM_ID | Model | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 22 | LAST_SEQ | Last Seq | 메타(확인 필요) | META | **숨김** | — |
| 23 | LAST_UPDATE_DATE | Last Update Date | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 24 | MODEL_PIC | Model PIC | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 25 | MTK_OWNER | MKT Owner | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 26 | NICK_NAME | Nick Name | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 27 | PROJECT_NAME | Project Name | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 28 | QTY | Qty | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 29 | QTY_CHANGE | Qty Change | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 30 | REMARKS | Remarks | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 31 | REMARKS_CHANGE | Remarks Change | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 32 | REQUEST_DATE | Request Date | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 33 | REQUEST_NO | Request No | **cellTypeImage**(코드 InitSpread:339) | META + 코드 변경 | 기본 | 확인 필요 |
| 34 | REQUESTOR | Requestor | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 35 | REQUESTOR_DEPT_NAME | Requestor Dept Name | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 36 | SEQ | Seq | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 37 | SHIP_TO_PARTY | Ship To Party | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 38 | SHIPMENT_DATE | Shipment Date | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 39 | SHIPMENT_DATE_CHANGE | Shipment Date Change | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 40 | SHIPMENT_REQUESTOR | Shipment Requestor | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 41 | SOLD_TO_PARTY | Sold To Party | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 42 | TO_SITE | To Site | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 43 | TRANS_MODE_CHANGE | Trans Mode Change | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 44 | TRANSPORT_MODE | Trans Mode | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 45 | TYPE | Type | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 46 | VARIABLE_DATE | Variable Date | 메타(확인 필요) | META | 기본 | 확인 필요 |
| 47 | VARIABLE_QTY | Variable Qty | 메타(확인 필요) | META | 기본 | 확인 필요 |

- HARDCODED 컬럼(코드로 추가한 컬럼): 없습니다
- Division별 표시: 14개 division 모두 46컬럼 표시이고 차이는 없습니다

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 Load (this.Load, .ctor:139) | `Form_Load` | InitControls → GetDayRange(522줄). InitControls에서 FP_Log2(258·262줄) 호출 | `SCP.GET_DATE_RANGE_1MONTH` | `drpPeriod` 기간 설정 |
| A2 | 조회 (FindButton) | FindData_Main | GetCheckedListValue ×5(387~390·396줄) → 409줄 호출 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY` (SP `SSP0019_GET_SHIPMENT_CHANGE_HISTORY`) | `spdMain` 시트 `Shipment Change History` |
| A3 | spdMain TopChange (InitEvent:191) | `SpdMain_TopChange` | **확인 필요** | 없음(추출 결과 없음) | 확인 필요 |
| A4 | spdMain CellClick (InitEvent:192) | `SpdMain_CellClick` | **확인 필요**(REQUEST_NO 이미지 셀과 관련 있는지 확인 필요) | 없음(추출 결과 없음) | 확인 필요 |
| A5 | btnItemId Click (InitEvent:193) | `btnItemId_Click` | `sItemId` 확보(방법 확인 필요) → 231줄 | 없음(추출 결과 없음) | `txtItemId.Text = sItemId` |
| A6 | chkCurrent CheckedChanged (InitEvent:194) | `ChkCurrent_CheckedChanged` | **확인 필요** | 없음(추출 결과 없음) | 확인 필요 |
| A7 | clbDivision SelectedIndexChanged (InitEvent:196) | `clbDivision_SelectedIndexChanged` | **확인 필요**(SetChangedControl:293 GetCheckedListValue, 298·303 NowGroupID와 관련 있는지 확인 필요) | 없음(추출 결과 없음) | 확인 필요 |
| A8 | (진입점 미연결) | SetChangedPeriod:500 | 공통코드 조회 → dt.Rows[0] FROM_VALUE(507)·TO_VALUE(508) | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 기간 설정으로 보이나 대상 컨트롤은 **확인 필요** |

- InitEvent 195줄은 이벤트 배선에 없습니다(**확인 필요**).

## 6. 검증·메시지
- 조회 전 필수값 검증과 메시지 원문은 Fact Pack에서 추출되지 않았습니다(**확인 필요**).
- 0건 조회와 오류 응답 때의 메시지도 **확인 필요**입니다.

## 7. 권한 (C/R/U/D)

| 항목 | 사실 |
|---|---|
| TB_FX_GroupMenuAuth | SSP0019 관련 16행. C/R/U/D 값은 **확인 필요** |
| TB_FX_ProgramInfo | 4행(내용 미추출) |
| TB_FX_Favorite | 17행 |
| TB_FX_SearchCondition | 96행(저장된 조회조건) |
| 코드 내 그룹 사용 | SetChangeControl:163·164(Filter GROUP_ID·USER_ID, NowGroupID), SetChangedControl:298·303(NowGroupID) |
| 화면 기능 | 저장/삭제 없음. 조회(R)만 사용하는 것으로 판단 |

## 8. To-Be 전환 메모 (Wijmo·Oracle)

| # | 항목 | 내용 |
|---:|---|---|
| 1 | 그리드 | FarPoint `spdMain` → Wijmo FlexGrid. 메타(SCM_MST_SHEET_COLUMNS, 47행) 기반으로 컬럼을 동적 생성하고 LAST_SEQ는 숨김으로 유지 |
| 2 | 이미지 셀 | REQUEST_NO `cellTypeImage` → FlexGrid 셀 템플릿(아이콘). 이미지 원천(imageList1 여부)과 클릭 동작은 확인 필요 |
| 3 | 조건 컨트롤 | UsrCheckedList 5개 → 다중선택 콤보. UsrMultiLineEditor 3개 → 다건 입력. UsrDateRangePicker → 기간 입력 |
| 4 | SP | MSSQL SP `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` → Oracle 패키지/SP 전환. FN_GET_IN_STR·FN_SCM_SPLIT 대응 함수와 동적 SQL 전환이 필요하며 원문 확인 필요 |
| 5 | 초기 기간 | `SCP.GET_DATE_RANGE_1MONTH`(SCM_SYS_CALENDAR_M) → 공통 기간 API |
| 6 | 공통코드 | `biz:CommonData.CommonDataList` → 공통코드 API. 진입점이 확정된 뒤 반영 |
| 7 | 조회조건 저장 | TB_FX_SearchCondition 96행 → 조회조건 저장·복원 공통 기능 대상 |
| 8 | 레이아웃 | 상단 조건 패널(HidePanel) + 하단 그리드(Fill) 구조 유지 |

## 9. 미확정
1. TransportMode LayoutItem 라벨 Text 원문
2. 조회조건 행·열 좌표와 LayoutItem 소속 그룹(parent 비어 있음)
3. splitter1(Dock=Bottom)의 실제 위치와 역할
4. 핸들러 4종(`SpdMain_TopChange`, `SpdMain_CellClick`, `ChkCurrent_CheckedChanged`, `clbDivision_SelectedIndexChanged`)의 동작
5. `btnItemId_Click`의 팝업 여부와 sItemId 출처
6. 컬럼별 타입·폭·정렬·고정·편집 여부(메타 원문)
7. AddSheet 인자 `1 ¦ 1 ¦ 30`의 의미
8. `biz:CommonData.CommonDataList` 진입점
9. 권한 16행의 C/R/U/D 값과 메뉴 위치
