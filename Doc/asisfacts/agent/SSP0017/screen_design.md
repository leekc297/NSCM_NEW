# SSP0017 화면설계서 — Inventory Raw(Small)

> 근거: AsisFacts Fact Pack(SSP0017) controls.csv · props.csv · events.csv · flow.csv · grid_effective.csv · grid_code.csv.
> Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다. 소스에서 주석 처리된 호출 3건(줄 513·531·532)은 현행 기능이 아니므로 설계 대상에서 제외합니다.

## 1. 화면 개요

| 항목 | 값 | 근거 |
|---|---|---|
| 화면 ID | SSP0017 | Fact Pack |
| 화면 명칭 | `Inventory Raw(Small)` | props.csv `this.Text` (Designer.cs:589) |
| 클래스 | `SSP0017_InventoryRaw` | controls.csv |
| 프로젝트 | `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj` | 파일 구성 |
| 메뉴 위치 | **확인 필요** (`TB_FX_MenuItemInfo` 2행, 경로 값 미추출) | Fact Pack §8 |
| 화면 유형 | 조회 전용(조회조건 + 단일 Grid) | endpoints.csv |

## 2. 화면 레이아웃

### 2-1. 분할 구조

- props.csv에 **SplitContainer가 없습니다**(Orientation·SplitterDistance 속성 없음). 화면은 Dock 배치만으로 구성됩니다.
- controls.csv parent 체인:
  - `this` → `usrConditionPanel1` (Dock Top, 1192×79) → `usrLayoutControl2` (Dock Top, 1192×73) → `cboPlanDate`, `btnMeasure`, `btnItemId`, `clbPlantSite`, `txtItemId`, `cboInventoryType`, `clbDivision`
  - `this` → `panel1` (Dock Fill, 1192×570) → `spdMain` (Dock Fill, 1192×570)
  - parent 없음(레이아웃 아이템·비시각 요소): `usrButton1`, `layoutControlGroup2`, `emptySpaceItem1`, `emptySpaceItem3`, `layoutControlItem7`, `lblItemId`, `layoutControlItem2`, `PlanDate`, `layoutControlItem10`, `lcDivision`, `lblInventoryType`, `imageList1`, `spdMain_Sheet1`
- 상/하 비율(높이 기준, 합계 79 + 570 = 649): 상단 79/649 ≈ **12.2%**, 하단 570/649 ≈ **87.8%**
- 좌/우 분할은 없습니다.

### 2-2. 텍스트 와이어프레임

```
┌──────────────────────────────── SSP0017 Inventory Raw(Small) ── 1192 ───────────────────────────────┐
│ [usrConditionPanel1]  Dock=Top  H=79 (≈12.2%)  UsrPanelType=HidePanel(접기 가능)                    │
│ ┌─ [usrLayoutControl2] Dock=Top H=73 / layoutControlGroup2 1192×73 ─────────────────────────────────┐│
│ │ 행A(H=25): [PlanDate: Plan-date* | cboPlanDate](232) [emptySpaceItem1](940)                       ││
│ │ 행B(H=28): [lcDivision: Division | clbDivision](232) [lblInventoryType: Inventory Type |           ││
│ │            cboInventoryType](252) [layoutControlItem7: Plant Site | clbPlantSite](161)            ││
│ │            [lblItemId: Model | txtItemId](154) [layoutControlItem2: btnItemId](43)                ││
│ │            [layoutControlItem10: btnMeasure](43) [emptySpaceItem3](287)                           ││
│ └───────────────────────────────────────────────────────────────────────────────────────────────────┘│
├──────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ [panel1] Dock=Fill H=570 (≈87.8%)                                                                    │
│ ┌─ [spdMain] FpSpread Dock=Fill / [spdMain_Sheet1] ─────────────────────────────────────────────────┐│
│ │  시트: Inventory Raw(Mobility & IT)  (컬럼헤더 1행, 메타 컬럼 27개 표시)                          ││
│ │  ...                                                                                              ││
│ │  [ColumnFooter: 합계 행 Visible=true]                                                             ││
│ └───────────────────────────────────────────────────────────────────────────────────────────────────┘│
└──────────────────────────────────────────────────────────────────────────────────────────────────────┘
(배치 위치 미확인: usrButton1 75×23, parent 없음)
```

- 행A/행B 구분은 LayoutControlItem 높이(25 / 28)와 행별 너비 합(각 1172)으로 추정한 것입니다. Location 좌표가 Fact Pack에 없으므로 **행 배치와 아이템 순서는 확인 필요**입니다.

### 2-3. 영역 정의

| 영역 | 구성 | 비고 |
|---|---|---|
| 조회조건 | `usrConditionPanel1` > `usrLayoutControl2` | HidePanel(접기 가능) |
| 버튼 | 프레임워크 조회 버튼(`FindButton`), 조건 영역 내 `btnItemId`·`btnMeasure`, 배치 미확인 `usrButton1` | |
| 그리드 | `panel1` > `spdMain` / `spdMain_Sheet1` | 메타 기반, 푸터 합계 |
| 팝업 | `btnItemId_Click`이 `txtItemId.Text = sItemId`로 값을 넣습니다. 팝업 사용 여부는 **확인 필요**입니다. | props.csv:301 |

## 3. 컨트롤 명세

> 라벨은 props.csv `Text` 원문입니다. 단위테스트 절차 열에서도 같은 컨트롤명을 씁니다.

| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 / 초기 상태 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| `usrConditionPanel1` | UsrConditionPanel | (Text 없음) | Dock Top, 1192×79, `HidePanel` | — | — | 조회조건 패널(접기 가능) 공용 컴포넌트 |
| `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2` (Designer 기본 Text, 화면 미노출로 보임 — 확인 필요) | Dock Top, 1192×73 | — | — | 조회조건 레이아웃(그리드형 배치) |
| `cboPlanDate` | UsrCombo | `Plan-date*` (PlanDate) | [code=PlanDateShip] 목록. 기본 선택값은 확인 필요 | 필수(`*`) | (값 공급: `Form_Load`·`clbDivision_SelectedIndexChanged` → `SetChangedControl`) | 단일 선택 ComboBox |
| `clbDivision` | UsrCheckedList | `Division` (lcDivision) | `Enabled=false` (:176). 기본값은 `NowGroupID` 기반으로 보임(확인 필요) | 확인 필요 | `clbDivision_SelectedIndexChanged` | 다중 선택 MultiSelect(비활성) |
| `cboInventoryType` | UsrCombo | `Inventory Type` (lblInventoryType) | 데이터 출처 확인 필요([LookupCommon] 후보) | 확인 필요 | — | 단일 선택 ComboBox |
| `clbPlantSite` | UsrCheckedList | `Plant Site` (layoutControlItem7) | 데이터 출처 확인 필요 | 확인 필요 | — | 다중 선택 MultiSelect |
| `txtItemId` | UsrMultiLineEditor | `Model` (lblItemId) | 빈 값(확인 필요). `btnItemId_Click`이 값을 채움 | 확인 필요 | (값 수신: `btnItemId_Click`) | 멀티라인(다건) 입력 공용 컴포넌트 |
| `btnItemId` | UsrButton | (Text 미추출, layoutControlItem2) | 39×24 | — | `btnItemId_Click` | 아이콘 버튼(Model 옆) |
| `btnMeasure` | UsrButton | (Text 미추출, layoutControlItem10) | 39×24 | — | `btnMeasure_Click` | 아이콘 버튼(동작 확인 필요) |
| `usrButton1` | UsrButton | (Text 미추출) | 75×23, parent 없음 | — | 없음 | **확인 필요**(화면 배치 여부 미확인) |
| `spdMain` | FpSpread | — | Dock Fill 1192×570, 시트 `Inventory Raw(Mobility & IT)` | — | `SpdMain_TopChange` | Wijmo FlexGrid(공용 Grid) |
| `spdMain_Sheet1` | SheetView | — | 컬럼헤더 1행, ColumnFooter Visible | — | — | FlexGrid 시트(컬럼 푸터 합계) |
| (화면) `this` | Form | `Inventory Raw(Small)` | — | — | `Form_Load` | 화면 페이지 |
| (프레임워크) FindButton | 공통 조회 버튼 | — | — | — | → `FindData_Main` | 공통 조회 버튼 |

## 4. 그리드 명세

### 4-1. 시트 구성

| 시트 | 연결 규칙 | 메타 컬럼 | 표시 | 숨김 | 근거 |
|---|---|---:|---:|---:|---|
| `Inventory Raw(Mobility & IT)` | META+코드연결 (현행) — `CreateSpread`:188 AddSheet → :191 ChangeSheet → `InitSpread`:200 InitSheet → :202 `SetSheetHeaderColumn(spdInfo, 1)` | 31 | 27 | 4 | grid_code.csv |
| `Inventory Raw(IT & Mobile)` | 메타 정의만, 코드 미참조(미사용 가능, 폐기 후보) | 31 | 27 | 4 | grid_effective.csv |

### 4-2. 컬럼 표 (두 시트 공통 — grid_effective.csv)

- 순서: CSV 정렬 순서(알파벳)입니다. 실제 표시 순서는 **확인 필요**입니다.
- 타입: 메타 `CELL_CONTROL_OBJECT_TYPE_CODE` 값이 Fact Pack에 없어 **확인 필요**입니다.
- 편집 가능 여부: 메타 편집 속성 값이 미추출이고 저장 엔드포인트가 없으므로 **조회 전용으로 보임(확인 필요)**입니다.
- Division별 표시: 14개 Division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 같습니다.

| # | 컬럼 | 헤더(원문) | 타입 | 출처 | `Inventory Raw(Mobility & IT)` | `Inventory Raw(IT & Mobile)` | Division별 표시 | 편집 |
|---:|---|---|---|---|---|---|---|---|
| 1 | AVAILABLE_QTY | Available Qty | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 2 | BUILDING | Building | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 3 | CAPACITY | Capacity | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 4 | CURRENT_OP_START_DATE | Current OP Start Date | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 5 | CUSTOMER | Customer | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 6 | DIVISION_ID | Div | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 7 | EXP_FORMATION_END_DATE | Exp. Formation End Date | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 8 | EXPIRATION_QTY | Expiration Qty | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 9 | HOLD_QTY | Hold Qty | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 10 | HOLD_YN | Hold YN | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 11 | INVENTORY_STATUS | Inventory Status | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 12 | INVENTORY_TYPE | Inventory Type | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 13 | LINE | Line | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 14 | LONG_QTY | Long-Term Qty | 확인 필요 | META | **숨김** | **숨김** | 전 Division 숨김 | — |
| 15 | LOT | Lot | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 16 | LOT_ID | Lot ID | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 17 | MODEL | Model | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 18 | NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 19 | OPERATION | Operation | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 20 | OPERATION_NAME | Operation Name | 확인 필요 | META | **숨김** | **숨김** | 전 Division 숨김 | — |
| 21 | PALLET_ID | Pallet ID | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 22 | PLANT_SITE | Plant Site | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 23 | PRODUCTION_DATE | Production Date | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 24 | REMAIN_LEAD_TIME | Remain Lead Time(Day) | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 25 | ROUTE | Route | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 26 | ROUTE_NAME | Route Name | 확인 필요 | META | **숨김** | **숨김** | 전 Division 숨김 | — |
| 27 | ROUTE_TYPE | Route Type | 확인 필요 | META | **숨김** | **숨김** | 전 Division 숨김 | — |
| 28 | SOC | SOC | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 29 | SPECIAL_YN | Special YN | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 30 | STOCK_QTY | Stock Qty | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |
| 31 | VALTAGE | Valtage | 확인 필요 | META | 기본 | 기본 | 전 Division 동일 | 확인 필요 |

- HARDCODED 컬럼은 없습니다. 코드 변경은 Designer.cs:555~558의 `ColumnHeaderDefaultEnhanced` 스타일 4건(HorizontalAlignment=General, NoteIndicatorColor=Red, Parent, VerticalAlignment=General)뿐이며, 컬럼을 추가하거나 숨기지 않습니다.
- 컬럼 푸터(합계 행): `InitSpreadFooterSum`:217 `ColumnFooter.Visible = true`. 합계 대상 컬럼은 **확인 필요**입니다.
- 헤더 `Valtage`는 메타 원문 철자입니다.

## 5. 액션 명세

> 엔드포인트 이름은 업무분석서 §5 데이터 흐름, 단위테스트 근거 열과 같습니다.

| # | 버튼 / 이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 로드(`this.Load`, .ctor:122) | `Form_Load` | `InitControls`(:176 `clbDivision.Enabled=false`) → `SetChangedControl` → `CreateSpread` / `InitSpread` / `InitSpreadFooterSum` / `InitEvent` | `biz:CommonData.CommonDataList` [code=LookupCommon] (:179), `biz:CommonData.CommonDataList` [code=PlanDateShip] (:365) | 조회조건 콤보 채움(LookupCommon 대상 컨트롤은 확인 필요), `cboPlanDate` 목록, `spdMain` 시트 `Inventory Raw(Mobility & IT)` 생성 |
| A2 | `clbDivision` SelectedIndexChanged (InitEvent:247) | `clbDivision_SelectedIndexChanged` | `SetChangedControl`(:350 `GetCheckedListValue`) | `biz:CommonData.CommonDataList` [code=PlanDateShip] | `cboPlanDate` 목록 갱신 |
| A3 | `btnItemId` Click (InitEvent:244) | `btnItemId_Click` | :301 `txtItemId.Text = sItemId` | 추출 없음 | `txtItemId` 값 반영 |
| A4 | `btnMeasure` Click (InitEvent:245) | `btnMeasure_Click` | **확인 필요** | 추출 없음 | **확인 필요** |
| A5 | 조회(프레임워크 FindButton) | `FindData_Main` | `GetCheckedListValue`(:386·387·389·390)로 조건 수집 | `SSP.SSP0017_GET_INVENTORY_RAW` (:405) → SP `SSP0017_GET_INVENTORY_RAW` | `spdMain` 결과 바인딩, 푸터 합계 |
| A6 | `spdMain` TopChange (InitEvent:243) | `SpdMain_TopChange` | **확인 필요** | 추출 없음 | **확인 필요** |
| A7 | (진입점 미연결) | `GetDivision`(:478) | 호출자 미발견 | `SCM.SCM0001_GET_DIVISION` → SP `SCM0001_GET_DIVISION` | **확인 필요** (실사용 시 Division 목록 용도로 보임) |
| A8 | (진입점 미연결) | `GetDayRange`(:514) | 호출자 미발견 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` → SP `SCM0001_GET_SCP_DAY_PERIOD` | **확인 필요** |
| A9 | (필드 초기화) | `<field:dtInventoryStatus>`(:49) | 클래스 생성 시 실행 가능(확인 필요) | `biz:CommonData.CommonDataList` [code=OWMS_STOCK_STATUS] | 바인딩 대상 **확인 필요** |

## 6. 검증·메시지

| # | 항목 | 사실 | 확정 여부 |
|---:|---|---|---|
| V1 | Plan-date 필수 | 라벨 `Plan-date*`의 `*` 표시 | 표시 확정. 미입력 검증 코드와 메시지 문구는 **확인 필요** |
| V2 | Division 수정 불가 | `clbDivision.Enabled=false` | 확정 |
| V3 | 조회 결과 0건 메시지 | 추출되지 않음 | **확인 필요** |
| V4 | 오류 응답 메시지 | 추출되지 않음(프레임워크 공통 처리로 보임) | **확인 필요** |

## 7. 권한(C/R/U/D) 사실

| 항목 | 값 |
|---|---|
| `TB_FX_GroupMenuAuth` 화면 행 수 | 14 |
| `TB_FX_MenuItemInfo` / `TB_FX_ProgramInfo` | 2 / 2 |
| `TB_FX_Favorite` | 9 |
| `TB_FX_SearchCondition` | 8 |
| C/U/D 엔드포인트 | 없음 (R만 존재) |
| 코드상 권한 분기 | 추출되지 않음 |
| 그룹별 C/R/U/D 플래그 값 | **확인 필요** |

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| # | 항목 | AS-IS | To-Be 관점 |
|---:|---|---|---|
| M1 | Grid | FarPoint `spdMain` + `SetSheetHeaderColumn` 메타 | Wijmo FlexGrid 공용 Grid + `SCM_MST_SHEET_COLUMNS` 대응 메타로 컬럼 구성. 시트 `Inventory Raw(Mobility & IT)` 기준 27개 표시·4개 숨김을 유지합니다. |
| M2 | 합계 행 | `ColumnFooter.Visible = true` | FlexGrid 컬럼 푸터(columnFooters) 합계 행. 합계 대상 컬럼은 확인 후 지정합니다. |
| M3 | 다중 선택 조건 | `UsrCheckedList` + `GetCheckedListValue`(CODE) | MultiSelect 계열 공용 컴포넌트. SP가 `UF_FX_STRING_SPLIT`을 참조하므로 Oracle 쪽 문자열 분해 함수 대응을 확인해야 합니다. |
| M4 | 공통코드 | `biz:CommonData.CommonDataList`(`UP_FX_GetCommonDataList`) | 공용 공통코드 조회 API. [PlanDateShip] 분기가 MSSQL `STRING_SPLIT`을 참조하므로 Oracle 변환 시 대체가 필요합니다. |
| M5 | 조회 SP | MSSQL SP `SSP0017_GET_INVENTORY_RAW` | Oracle 19c 패키지/프로시저로 전환. 참조 함수 `FN_CHAR_TO_DATE`, `UF_FX_STRING_SPLIT`의 Oracle 대응이 필요합니다. |
| M6 | 미연결 호출 | `GetDivision`, `GetDayRange`, `dtInventoryStatus` | 실사용 여부를 확인한 뒤 To-Be 반영 여부를 결정합니다. |
| M7 | 조회조건 패널 | `HidePanel` | 접기 가능한 조회조건 패널 공용 컴포넌트 |
| M8 | Grid 스크롤 이벤트 | `SpdMain_TopChange` | 동작을 확인한 뒤 FlexGrid 스크롤 이벤트로 대응할지 판단합니다. |
| M9 | 미사용 시트 | `Inventory Raw(IT & Mobile)` 메타 | 코드 미참조. 이관 여부를 결정해야 합니다. |

## 9. 미확정

1. 메뉴 위치
2. 조회조건 아이템의 실제 행·열 배치(Location 미추출)
3. `usrButton1` 배치 여부와 용도
4. `btnItemId_Click`(`sItemId` 취득 방식), `btnMeasure_Click`, `SpdMain_TopChange`의 동작
5. `cboInventoryType`·`clbPlantSite` 데이터 출처, [LookupCommon] 대상 컨트롤
6. `clbDivision` 기본값과 비활성 상태에서 `clbDivision_SelectedIndexChanged`가 발생하는 경로
7. Grid 컬럼 표시 순서·타입·편집 여부·합계 대상, 숨김 4개 컬럼의 사유
8. SP 결과셋 컬럼과 메타 컬럼의 일치 여부
9. `GetDivision`·`GetDayRange`·`dtInventoryStatus`의 실사용 여부
10. 검증 메시지 문구, 그룹별 권한 플래그
