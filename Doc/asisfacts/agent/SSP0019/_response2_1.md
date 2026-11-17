=== FILE: business_analysis.md ===
# SSP0019 Shipment Change History — 업무분석서

> 근거: AsisFacts Fact Pack(정적 추출)과 1차 분석서(analysis.md·web_components.md·tobe_design.md)
> 표기 원칙: Fact Pack에 없는 내용은 **확인 필요**로 적었습니다. 업무 규칙을 추측해서 만들지 않았습니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID | SSP0019 | Fact Pack §1 |
| 클래스 | `SSP0019_ShipmentChangeHistory` | controls.csv |
| 프로젝트 | `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj` | Fact Pack §1 |
| 소스 | `SSP0019_ShipmentChangeHistory.cs`(543줄), `SSP0019_ShipmentChangeHistory.Designer.cs`(845줄), variant=only | Fact Pack §1 |
| 업무 목적 | 출하(Shipment) 변경 이력을 조회합니다. 화면명과 시트명 `Shipment Change History`, 그리드 컬럼(BEFORE_QTY / QTY_CHANGE / SHIPMENT_DATE_CHANGE / TRANS_MODE_CHANGE / REMARKS_CHANGE / CHANGE_REASON_CODE 등)으로 판단했습니다. 업무 정의 원문은 **확인 필요** | grid_effective.csv |
| 범위 | **조회 전용**. 추출된 엔드포인트 3개(조회 1개, 초기 기간 1개, 공통코드 1개) 중 저장·삭제는 없습니다 | endpoints.csv |
| 범위 밖 | 523줄의 주석 처리된 호출 1건(commented_calls.csv)은 현행 기능이 아니어서 제외했습니다 | commented_calls.csv |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---:|---|---|---|---|
| S1 | 메뉴에서 화면을 엽니다 | `Form_Load` → `InitControls` → `GetDayRange` 순서로 `SCP.GET_DATE_RANGE_1MONTH`(SELECT:SCM_SYS_CALENDAR_M)를 호출합니다 | 기간 조건 `drpPeriod`에 기간이 설정됩니다. 구체 기간 값은 **확인 필요** | flow.csv, endpoints.csv |
| S1-a | (같은 시점) | `InitControls:258·262`에서 `DataService.FP_Log2`(LOGTYPE, NOTE, USER_ID)를 호출합니다 | 사용 로그가 남는 것으로 보입니다. 기록되는 테이블은 **확인 필요** | Fact Pack §4-2 |
| S1-b | (같은 시점) | `SetChangeControl:170·175·180`에서 `DataService.GetSSPInnerTable`을 3회 호출합니다. 163·164줄에서는 Filter GROUP_ID·USER_ID와 `UserInfoContext.Current.NowGroupID`를 사용합니다 | 조회조건 목록이 채워지는 것으로 보입니다. 어느 컨트롤에 바인딩되는지와 호출 시점은 **확인 필요** | Fact Pack §4, §4-2 |
| S1-c | (같은 시점) | `CreateSpread:318` AddSheet → `InitSpread:332` `SetSheetHeaderColumn`(메타 SCM_MST_SHEET_COLUMNS) 순서로 시트를 만듭니다 | 시트 `Shipment Change History`가 생성되고 컬럼 46개가 표시됩니다(LAST_SEQ는 숨김) | grid_code.csv, grid_effective.csv |
| S2 | 조회조건(Division / From Site / To Site / Transport Mode / Incoterms / Shipment Date / SO No / Model / Confirm ID / Current)을 입력합니다 | `clbDivision_SelectedIndexChanged`, `ChkCurrent_CheckedChanged`, `btnItemId_Click` 같은 이벤트가 처리됩니다 | 조건값이 반영됩니다. `btnItemId_Click`은 231줄에서 `txtItemId.Text = sItemId`를 설정합니다 | events.csv, props.csv |
| S3 | 조회(FindButton)를 누릅니다 | `FindData_Main`에서 `GetCheckedListValue`를 5회(387·388·389·390·396줄) 호출해 체크 목록 CODE 값을 모은 뒤, 409줄에서 `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY` → SP `SSP0019_GET_SHIPMENT_CHANGE_HISTORY`를 호출합니다 | 결과가 `spdMain` 시트 `Shipment Change History`에 표시됩니다 | flow.csv, Fact Pack §4-2 |
| S4 | 그리드에서 셀을 클릭하거나 스크롤합니다 | `SpdMain_CellClick`, `SpdMain_TopChange`가 실행됩니다 | 내부 동작은 **확인 필요**. REQUEST_NO가 이미지 셀이어서 클릭 동작과 관련이 있을 수 있으나 이것도 확인 필요 | events.csv, grid_code.csv:339 |
| S5 | (진입점 미확정) 기간 변경 | `SetChangedPeriod:500`에서 `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT]를 호출하고 507·508줄에서 `dt.Rows[0]` FROM_VALUE·TO_VALUE를 읽습니다 | 기간 From/To가 설정되는 것으로 보입니다. **정적 분석상 진입점에 연결되지 않아 실제 호출 여부는 확인 필요** | flow.csv, meta_reads.csv |

## 3. 업무 흐름도 (텍스트)

```
[화면 열기]
   └─ Form_Load
        └─ InitControls
             ├─ FP_Log2 (사용 로그, 258·262줄)
             └─ GetDayRange ──▶ SCP.GET_DATE_RANGE_1MONTH ──▶ SCM_SYS_CALENDAR_M (SELECT)
                                   └─▶ drpPeriod 기간 설정
   (SetChangeControl: GetSSPInnerTable ×3 → 조회조건 목록 — 호출 시점·대상 컨트롤 확인 필요)
   (CreateSpread/InitSpread: 시트 'Shipment Change History' 생성, SetSheetHeaderColumn 메타 46컬럼 표시, REQUEST_NO 이미지 셀)

[조건 입력]
   ├─ clbDivision 변경 ─▶ clbDivision_SelectedIndexChanged (동작 확인 필요)
   ├─ chkCurrent 변경 ─▶ ChkCurrent_CheckedChanged (동작 확인 필요)
   └─ btnItemId 클릭 ─▶ btnItemId_Click ─▶ txtItemId.Text = sItemId

[조회 버튼(FindButton)]
   └─ FindData_Main
        ├─ GetCheckedListValue ×5 (387·388·389·390·396줄, CODE)
        └─ SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY ──▶ SP SSP0019_GET_SHIPMENT_CHANGE_HISTORY
                 (REF: FN_GET_IN_STR, FN_SCM_SPLIT, 동적 SQL 포함)
                 └─▶ spdMain / 'Shipment Change History' 결과 표시

[그리드 조작]
   ├─ SpdMain_CellClick (동작 확인 필요)
   └─ SpdMain_TopChange (동작 확인 필요)

[진입점 미연결]
   └─ SetChangedPeriod ──▶ biz:CommonData.CommonDataList [PERIOD_{p:value} || PERIOD_DEFAULT]
                            └─▶ dt.Rows[0].FROM_VALUE / TO_VALUE
```

## 4. 업무 규칙 (사실 근거만)

| # | 규칙 | 내용 | 근거 |
|---:|---|---|---|
| R1 | 초기 기간 | 화면이 로드될 때 `SCP.GET_DATE_RANGE_1MONTH`로 기간을 정합니다. 엔드포인트명이 '1MONTH'이고 SCM_SYS_CALENDAR_M을 SELECT하지만, 실제 산출 규칙(기준일·범위)은 SQL 원문으로 **확인 필요** | endpoints.csv |
| R2 | 기간 코드 | `biz:CommonData.CommonDataList`의 코드 표현은 `PERIOD_{p:value} \|\| PERIOD_DEFAULT`입니다. `{p:value}`에 들어가는 값과 PERIOD_DEFAULT로 대체되는 조건은 **확인 필요** | endpoints.csv |
| R3 | 다중 선택 조건 값 | 체크 목록 조건은 `CString.GetCheckedListValue`로 CODE 값을 모아 SP에 넘깁니다. 5건이 각각 어느 컨트롤에 대응하는지와 SP 파라미터 목록은 **확인 필요** | Fact Pack §4-2 |
| R4 | 다건 문자열 처리 | SP가 `FN_GET_IN_STR`, `FN_SCM_SPLIT`를 참조하므로 구분자로 이은 다건 값을 분리하는 것으로 보입니다. 구분자와 대상 파라미터는 **확인 필요** | endpoints.csv objects |
| R5 | 동적 SQL | SP `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` 안에 동적 SQL(DYNAMIC@)이 있습니다. 분기 조건은 **확인 필요** | endpoints.csv objects |
| R6 | 그룹 기준 조건 | `SetChangeControl`(163·164줄)과 `SetChangedControl`(298·303줄)에서 `NowGroupID`를 사용하고, Filter에 GROUP_ID·USER_ID를 씁니다. 사용자 그룹에 따라 조건 컨트롤 구성이 달라질 수 있으나 구체 분기는 **확인 필요** | meta_reads.csv |
| R7 | 필수값 | 조회 필수 조건과 검증 로직은 Fact Pack에서 추출되지 않았습니다(**확인 필요**) | — |
| R8 | 그리드 표시 | 메타 47컬럼 중 LAST_SEQ는 전 division 숨김이고 나머지 46컬럼은 기본 표시입니다. 셀 타입은 REQUEST_NO만 코드로 `cellTypeImage`가 지정됩니다(조건 `spdInfo.SheetName == "Shipment Change History"`) | grid_effective.csv, grid_code.csv:339 |
| R9 | 버킷 규칙 | 날짜 버킷(주·월) 규칙은 추출되지 않았습니다(**확인 필요**) | — |

## 5. 데이터 흐름 표

| 엔드포인트 | 호출 위치 | 진입점 | SP / SQL | 읽기 객체 | 쓰기 객체 |
|---|---|---|---|---|---|
| `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY` | FindData_Main:409 | button:FindButton | SP `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` | REF: FN_GET_IN_STR, FN_SCM_SPLIT. 테이블은 동적 SQL이어서 **확인 필요** | 없음(추출 결과 없음) |
| `SCP.GET_DATE_RANGE_1MONTH` | GetDayRange:522 | event:this.Load (Form_Load > InitControls > GetDayRange) | [statement] foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql | SCM_SYS_CALENDAR_M (SELECT) | 없음 |
| `biz:CommonData.CommonDataList` | SetChangedPeriod:500 | 진입점 미연결(unreached) | Biz 공통코드(Data.CallBizCommonData), code=PERIOD_{p:value} \|\| PERIOD_DEFAULT | **확인 필요**. 결과 컬럼은 FROM_VALUE, TO_VALUE | 없음 |

프레임워크 호출(엔드포인트로 추출되지 않은 것):

| 프레임워크 메서드 | 위치 | 읽는 컬럼 | 비고 |
|---|---|---|---|
| DataService.GetSSPInnerTable | SetChangeControl:170, 175, 180 | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID | 대상 컨트롤 **확인 필요** |
| DataService.FP_Log2 | InitControls:258, 262 | LOGTYPE, NOTE, USER_ID | 로그 쓰기 대상 테이블 **확인 필요** |
| SpreadInfo.SetSheetHeaderColumn | InitSpread:332 | 메타 SCM_MST_SHEET_COLUMNS(ATTRIBUTE1~5, COLUMN_NAME, COLUMN_LABEL_NAME, VISIBLE_FLAG 등) | 그리드 헤더 생성 |

## 6. Division·권한별 변형

| 구분 | 사실 | 근거 |
|---|---|---|
| Division 그리드 | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 `Shipment Change History` 46컬럼 표시로, **변형이 없습니다** | Fact Pack §10·§12 |
| Division 코드 분기 | 판단불가 0건이고 division 비교 코드 분기는 추출되지 않았습니다 | Fact Pack §12 |
| Division 조건 | `clbDivision` 조건과 `clbDivision_SelectedIndexChanged` 핸들러가 있습니다. 변경 시 다른 조건과 연동되는지는 **확인 필요** | events.csv |
| 권한 | TB_FX_GroupMenuAuth에 16행이 있으나 행별 C/R/U/D 값은 Fact Pack에 없어 **확인 필요** | Fact Pack §8 |
| 그룹 | NowGroupID 사용 위치는 SetChangeControl:163, SetChangedControl:298·303이며 분기 내용은 **확인 필요** | meta_reads.csv |

## 7. 외부 인터페이스
- Fact Pack에서 외부 시스템 인터페이스(I/F)는 추출되지 않았습니다. 해당 사항이 없거나 **확인 필요**입니다.

## 8. 미확정·확인 필요

| # | 항목 |
|---:|---|
| 1 | SP `SSP0019_GET_SHIPMENT_CHANGE_HISTORY`의 파라미터 목록, 동적 SQL 분기, 읽는 테이블 |
| 2 | FindData_Main 387~390·396줄의 GetCheckedListValue 5건과 조회조건 컨트롤의 대응 |
| 3 | `SetChangedPeriod`(`biz:CommonData.CommonDataList`)의 실제 진입점과 `{p:value}` 값 |
| 4 | `SCP.GET_DATE_RANGE_1MONTH` SQL의 기간 산출 규칙 |
| 5 | `SpdMain_TopChange`, `SpdMain_CellClick`, `ChkCurrent_CheckedChanged`, `clbDivision_SelectedIndexChanged`의 내부 동작 |
| 6 | `btnItemId_Click`에서 `sItemId`를 얻는 방법(팝업 여부) |
| 7 | GetSSPInnerTable 3건이 어느 컨트롤에 바인딩되는지 |
| 8 | TB_FX_GroupMenuAuth 16행의 C/R/U/D 값과 TB_FX_MenuItemInfo 4행 기준의 메뉴 위치 |
| 9 | SP 결과 컬럼과 메타 46컬럼의 일치 여부(Fact Pack §10: "실제 SP 실행 결과와 매칭되는 시트 없음") |
| 10 | FP_Log2 로그 쓰기 대상 테이블 |
| 11 | 523줄 주석 처리 호출 1건은 현행 아님(제외 확정, 참고용) |

=== FILE: screen_design.md ===
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

=== FILE: unit_test.md ===
# SSP0019 Shipment Change History — 단위테스트

> 근거 열의 이름은 업무분석서 §5와 화면설계서 §5의 엔드포인트·핸들러·시트 이름 원문과 같습니다.
> 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 기대결과 중 사실이 없는 부분은 "AS-IS 원문 확인 후 확정"으로 적었습니다.

## 1. 테스트 케이스

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0019-001 | 초기화 | SSP0019 메뉴 권한이 있는 사용자로 로그인 | 1) 화면을 엽니다 2) `drpPeriod` 값을 확인합니다 | 없음 | `SCP.GET_DATE_RANGE_1MONTH`가 1회 호출되고, 반환된 기간이 `drpPeriod` From~To에 설정됩니다(값은 SCM_SYS_CALENDAR_M 기준, 산출 규칙 확인 필요) | `Form_Load`, `SCP.GET_DATE_RANGE_1MONTH` |
| TC-SSP0019-002 | 초기화 | `SCP.GET_DATE_RANGE_1MONTH`가 0행을 반환하거나 오류를 반환하도록 설정 | 1) 화면을 엽니다 2) `drpPeriod` 상태와 메시지를 확인합니다 | 빈 결과 / 오류 응답 | 화면 로드가 중단되지 않습니다. `drpPeriod` 값과 메시지는 AS-IS 원문 확인 후 확정 | `Form_Load`, `SCP.GET_DATE_RANGE_1MONTH` |
| TC-SSP0019-003 | 초기화 | 화면 열기 | 1) 화면 레이아웃을 확인합니다 | 없음 | `usrConditionPanel1`(Top)과 `usrLayoutControl1` 안에 조건 컨트롤 11개(`clbDivision`, `clbFromSite`, `clbToSite`, `clbTransportMode`, `clbIncomterms`, `drpPeriod`, `txtSoNo`, `txtItemId`, `btnItemId`, `txtConfirmId`, `chkCurrent`)가 있고, 라벨은 Division / From Site / To Site / Incoterms / Shipment Date / SO No / Model / Confirm ID / Current입니다. `spdMain`은 Fill입니다 | `Form_Load`, `Shipment Change History` |
| TC-SSP0019-004 | 그리드 | 화면 열기 | 1) `spdMain` 시트 탭과 컬럼 헤더를 확인합니다 | 없음 | 시트 `Shipment Change History` 1개, 헤더 1행. 메타 47컬럼 중 46컬럼이 표시되고 LAST_SEQ는 숨김입니다. 헤더 라벨은 화면설계서 §4와 같습니다 | `Shipment Change History` (SetSheetHeaderColumn@InitSpread:332) |
| TC-SSP0019-005 | 그리드 | TC-SSP0019-007로 1건 이상 조회 | 1) `spdMain` REQUEST_NO 컬럼 셀을 확인합니다 | 없음 | REQUEST_NO 셀이 이미지 셀(cellTypeImage)로 표시됩니다 | `Shipment Change History` (InitSpread:339) |
| TC-SSP0019-006 | 그리드 | 데이터 1건 이상 조회 | 1) `spdMain` 시트 `Shipment Change History`의 표시 컬럼과 SP 결과 컬럼을 대조합니다 | 없음 | 표시 컬럼 46개가 모두 값과 바인딩됩니다. SP 결과에 없는 컬럼이 있는지는 실행으로 확인합니다(Fact Pack §10 미매칭) | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY`, `Shipment Change History` |
| TC-SSP0019-007 | 조회 | 화면 열기, 초기 기간 설정 완료 | 1) 조건을 기본값으로 둡니다 2) 조회(FindButton)를 누릅니다 | `drpPeriod` 초기값 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY` → SP `SSP0019_GET_SHIPMENT_CHANGE_HISTORY`가 1회 호출되고 결과가 `spdMain`에 표시됩니다 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY`, `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` |
| TC-SSP0019-008 | 조회 | 화면 열기 | 1) `clbDivision`, `clbFromSite`, `clbToSite`, `clbTransportMode`, `clbIncomterms`에서 항목을 각각 체크합니다 2) 조회합니다 | 각 목록에서 1개 이상 선택 | 선택 항목의 CODE 값(GetCheckedListValue)이 SP 파라미터로 전달되고, 결과가 선택 조건에 맞게 필터링됩니다. 파라미터 대응은 확인 필요 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY`, `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` |
| TC-SSP0019-009 | 조회 | 화면 열기 | 1) `txtSoNo`, `txtItemId`, `txtConfirmId`에 여러 줄을 입력합니다 2) 조회합니다 | SO No 2건, Model 2건, Confirm ID 2건 | 다건 값이 분리 처리(FN_SCM_SPLIT / FN_GET_IN_STR)되어 조회 조건에 반영됩니다. 구분자 규칙은 확인 필요 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY`, `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` |
| TC-SSP0019-010 | 조회 | 화면 열기 | 1) `drpPeriod`를 데이터가 없는 기간으로 바꿉니다 2) 조회합니다 | 데이터 없는 기간 | `spdMain` 시트 `Shipment Change History`가 0행이 됩니다. 안내 메시지는 AS-IS 원문 확인 후 확정 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY`, `Shipment Change History` |
| TC-SSP0019-011 | 조회 | SP가 오류를 반환하도록 설정(예: SP 실행 권한 제거) | 1) 조회합니다 | 기본 조건 | 오류 메시지가 표시되고 기존 그리드 상태 처리는 AS-IS 원문 확인 후 확정. 화면은 비정상 종료되지 않아야 합니다 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY`, `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` |
| TC-SSP0019-012 | 이벤트 | 화면 열기 | 1) `btnItemId`를 클릭합니다 2) Model을 선택합니다(팝업 여부 확인 필요) | Model 1건 | `txtItemId`에 선택값(sItemId)이 설정됩니다 | `btnItemId_Click` |
| TC-SSP0019-013 | 이벤트 | 화면 열기 | 1) `chkCurrent`를 체크합니다 2) 체크를 해제합니다 | Current = 체크/해제 | `ChkCurrent_CheckedChanged`가 실행됩니다. 조건 컨트롤과 조회 결과에 미치는 영향은 AS-IS 원문 확인 후 확정 | `ChkCurrent_CheckedChanged` |
| TC-SSP0019-014 | 이벤트 | 화면 열기 | 1) `clbDivision`의 선택을 바꿉니다 | Division 선택 변경 | `clbDivision_SelectedIndexChanged`가 실행됩니다. 다른 조건(`clbFromSite`·`clbToSite` 등)과 연동되는지는 AS-IS 원문 확인 후 확정 | `clbDivision_SelectedIndexChanged` |
| TC-SSP0019-015 | 이벤트 | 데이터 1건 이상 조회 | 1) `spdMain`의 REQUEST_NO 셀을 클릭합니다 2) 다른 컬럼 셀을 클릭합니다 | 없음 | `SpdMain_CellClick`이 실행됩니다. 셀별 동작(팝업 등)은 AS-IS 원문 확인 후 확정 | `SpdMain_CellClick`, `Shipment Change History` |
| TC-SSP0019-016 | 이벤트 | 화면 높이보다 많은 행 조회 | 1) `spdMain`을 세로로 스크롤합니다 | 없음 | `SpdMain_TopChange`가 실행됩니다. 동작은 AS-IS 원문 확인 후 확정 | `SpdMain_TopChange` |
| TC-SSP0019-017 | 이벤트 | SetChangedPeriod 진입점 확인 완료(현재 정적 분석상 미연결) | 1) 확인된 진입점 동작을 수행합니다 | `{p:value}` 값(확인 필요) | `biz:CommonData.CommonDataList`가 code=PERIOD_{p:value}로 호출되고 dt.Rows[0]의 FROM_VALUE·TO_VALUE가 기간에 반영됩니다 | `biz:CommonData.CommonDataList` |
| TC-SSP0019-018 | 이벤트 | TC-SSP0019-017과 같으며, PERIOD_{p:value} 코드 행이 없도록 설정 | 1) 같은 진입점 동작을 수행합니다 | 존재하지 않는 코드값 | 코드 표현식 `PERIOD_{p:value} \|\| PERIOD_DEFAULT`에 따른 대체 동작 또는 빈 결과 처리를 확인합니다. 기대값은 AS-IS 원문 확인 후 확정 | `biz:CommonData.CommonDataList` |
| TC-SSP0019-019 | division | Division이 각각 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC인 사용자(14개) | 1) division별로 화면을 엽니다 2) `spdMain` 표시 컬럼 수를 확인합니다 | division 14종 | 모든 division에서 시트 `Shipment Change History`가 46컬럼 표시, LAST_SEQ 숨김으로 같습니다(division 변형 없음) | `Shipment Change History` |
| TC-SSP0019-020 | 권한 | TB_FX_GroupMenuAuth에 SSP0019 권한이 있는 그룹과 없는 그룹의 사용자 | 1) 각 사용자로 화면을 열고 조회합니다 | 그룹 2종 | 권한이 있는 그룹은 조회가 가능합니다. 권한이 없는 그룹의 동작과 C/R/U/D 값은 GroupMenuAuth 16행 확인 후 확정 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY` |
| TC-SSP0019-021 | 권한 | 서로 다른 NowGroupID를 가진 사용자 2명 | 1) 각 사용자로 화면을 엽니다 2) 조건 목록(`clbDivision` 등)을 비교합니다 | 그룹 2종 | 그룹에 따라 조건 구성이 달라지는지 확인합니다(SetChangeControl:163·164, SetChangedControl:298·303). 기대값은 AS-IS 원문 확인 후 확정 | `Form_Load`, `clbDivision_SelectedIndexChanged` |
| TC-SSP0019-022 | 초기화 | 화면 열기 | 1) 화면을 엽니다 2) 사용 로그를 확인합니다 | 없음 | InitControls에서 FP_Log2(LOGTYPE, NOTE, USER_ID)가 호출됩니다. 기록 테이블은 확인 필요 | `Form_Load` |

## 2. 커버리지 점검

| 대상 | 원문 이름 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001, 002, 003, 021, 022 |
| 이벤트 핸들러 | `SpdMain_TopChange` | 016 |
| 이벤트 핸들러 | `SpdMain_CellClick` | 015 |
| 이벤트 핸들러 | `btnItemId_Click` | 012 |
| 이벤트 핸들러 | `ChkCurrent_CheckedChanged` | 013 |
| 이벤트 핸들러 | `clbDivision_SelectedIndexChanged` | 014, 021 |
| 엔드포인트 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY` | 006~011, 020 |
| 엔드포인트 | `SCP.GET_DATE_RANGE_1MONTH` | 001, 002 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 017, 018 |
| SP | `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` | 007~009, 011 |
| 시트 | `Shipment Change History` | 003~006, 010, 015, 019 |
| 빈 결과 | — | 002, 010, 018 |
| 오류 응답 | — | 002, 011 |
| division | 14종(변형 없음) | 019 |

- 523줄의 주석 처리 호출은 현행 기능이 아니어서 테스트 대상에서 제외했습니다.
