# SSP0017 Web 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → React/Wijmo 매핑

라벨은 props.csv의 `LayoutControlItem.Text` 원문입니다.

| AS-IS 컨트롤 | 유형 | 라벨(LayoutControlItem.Text 원문) | LayoutControlItem | 크기(컨트롤) | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|---|
| `cboPlanDate` | UsrCombo | `Plan-date*` | `PlanDate` (232×25) | 165×20 | 단일 선택 콤보 (Wijmo ComboBox 계열 공용 컴포넌트) | 라벨의 `*`는 필수 표시. 데이터: [code=PlanDateShip] |
| `clbDivision` | UsrCheckedList | `Division` | `lcDivision` (232×28) | 184×21 | 다중 선택 체크 콤보 (Wijmo MultiSelect 계열) | `InitControls`:176 `Enabled=false`(비활성). 변경 시 `SetChangedControl` |
| `clbPlantSite` | UsrCheckedList | `Plant Site` | `layoutControlItem7` (161×28) | 100×21 | 다중 선택 체크 콤보 | 데이터 출처 확인 필요 |
| `cboInventoryType` | UsrCombo | `Inventory Type` | `lblInventoryType` (252×28) | 145×20 | 단일 선택 콤보 | 데이터 출처 확인 필요(LookupCommon 후보) |
| `txtItemId` | UsrMultiLineEditor | `Model` | `lblItemId` (154×28) | 100×21 | 멀티라인 입력(다건 입력) 공용 컴포넌트 | `btnItemId_Click`이 값을 채움 |
| `btnItemId` | UsrButton | (Text 미추출) | `layoutControlItem2` (43×28) | 39×24 | 아이콘 버튼 (Model 옆) | Click → `btnItemId_Click` |
| `btnMeasure` | UsrButton | (Text 미추출) | `layoutControlItem10` (43×28) | 39×24 | 아이콘 버튼 | Click → `btnMeasure_Click`. 동작 확인 필요 |
| `usrButton1` | UsrButton | (Text 미추출) | — | 75×23 | 확인 필요 | 부모 미지정. 화면 배치 여부 확인 필요 |
| `usrConditionPanel1` | UsrConditionPanel | — | — | 1192×79 | 조회조건 패널 (접기 가능) | `UsrPanelType = HidePanel` |
| `usrLayoutControl2` / `layoutControlGroup2` | UsrLayoutControl / LayoutControlGroup | — | — | 1192×73 | 조회조건 레이아웃 | |
| `emptySpaceItem3` / `emptySpaceItem1` | EmptySpaceItem | — | — | 287×28 / 940×25 | 여백 | |
| `panel1` | Panel | — | — | 1192×570 | Grid 컨테이너 | Dock Fill |
| `spdMain` / `spdMain_Sheet1` | FpSpread / SheetView | — | — | 1192×570 | Wijmo FlexGrid (공용 Grid) | Dock Fill. 컬럼 푸터 Visible(합계 행) |
| `imageList1` | ImageList | — | — | — | 불필요(아이콘 리소스) | |
| (프레임워크) FindButton | — | — | — | — | 공통 조회 버튼 | → `FindData_Main` |

## 2. 화면 배치

- props.csv에 **SplitContainer가 없습니다**. Dock 구성만 있습니다.
- 상/하 2분할:
  - 상단 `usrConditionPanel1`: Dock Top, 높이 79 → 79 / (79+570) ≈ **12.2%**
  - 하단 `panel1` → `spdMain`: Dock Fill, 높이 570 → 570 / 649 ≈ **87.8%** (나머지 영역을 모두 채움)
- 좌/우 분할은 없습니다(Grid 1개).
- 조회조건 행 배치는 LayoutControlItem 크기 기준입니다. 높이 25인 항목(`PlanDate` 232, `emptySpaceItem1` 940)과 높이 28인 항목(`lcDivision` 232, `lblInventoryType` 252, `layoutControlItem7` 161, `lblItemId` 154, `layoutControlItem2` 43, `layoutControlItem10` 43, `emptySpaceItem3` 287)이 있습니다. 정확한 행·열 좌표(Location)는 Fact Pack에 없어 **확인 필요**입니다.
  - 참고: 높이 28 항목 너비 합은 232+252+161+154+43+43+287 = 1172이고, 높이 25 항목 합은 232+940 = 1172입니다. 2행 구성으로 보이지만 확정하려면 Location 확인이 필요합니다.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

컬럼 순서는 CSV 정렬 순서(알파벳)입니다. 실제 표시 순서(메타의 순번 컬럼)는 Fact Pack에 없어 **확인 필요**입니다.

### 3-1. `Inventory Raw(Mobility & IT)` — META+코드연결 (현행 사용 시트)

| # | COLUMN_NAME | 라벨 | 출처 | 표시(전 Division 동일) |
|---:|---|---|---|---|
| 1 | AVAILABLE_QTY | Available Qty | META | 기본 |
| 2 | BUILDING | Building | META | 기본 |
| 3 | CAPACITY | Capacity | META | 기본 |
| 4 | CURRENT_OP_START_DATE | Current OP Start Date | META | 기본 |
| 5 | CUSTOMER | Customer | META | 기본 |
| 6 | DIVISION_ID | Div | META | 기본 |
| 7 | EXP_FORMATION_END_DATE | Exp. Formation End Date | META | 기본 |
| 8 | EXPIRATION_QTY | Expiration Qty | META | 기본 |
| 9 | HOLD_QTY | Hold Qty | META | 기본 |
| 10 | HOLD_YN | Hold YN | META | 기본 |
| 11 | INVENTORY_STATUS | Inventory Status | META | 기본 |
| 12 | INVENTORY_TYPE | Inventory Type | META | 기본 |
| 13 | LINE | Line | META | 기본 |
| 14 | LONG_QTY | Long-Term Qty | META | **숨김** |
| 15 | LOT | Lot | META | 기본 |
| 16 | LOT_ID | Lot ID | META | 기본 |
| 17 | MODEL | Model | META | 기본 |
| 18 | NICK_NAME | Nick Name | META | 기본 |
| 19 | OPERATION | Operation | META | 기본 |
| 20 | OPERATION_NAME | Operation Name | META | **숨김** |
| 21 | PALLET_ID | Pallet ID | META | 기본 |
| 22 | PLANT_SITE | Plant Site | META | 기본 |
| 23 | PRODUCTION_DATE | Production Date | META | 기본 |
| 24 | REMAIN_LEAD_TIME | Remain Lead Time(Day) | META | 기본 |
| 25 | ROUTE | Route | META | 기본 |
| 26 | ROUTE_NAME | Route Name | META | **숨김** |
| 27 | ROUTE_TYPE | Route Type | META | **숨김** |
| 28 | SOC | SOC | META | 기본 |
| 29 | SPECIAL_YN | Special YN | META | 기본 |
| 30 | STOCK_QTY | Stock Qty | META | 기본 |
| 31 | VALTAGE | Valtage | META | 기본 |

- 메타 31개 중 표시 27개, 숨김 4개입니다.
- 라벨 `Valtage`는 메타 원문 철자 그대로입니다. TO-BE에서 정정할지는 확인 필요입니다.
- 코드 하드코딩 컬럼은 없습니다. 코드 변경은 컬럼헤더 스타일 4건(Designer.cs:555~558)뿐입니다.

### 3-2. `Inventory Raw(IT & Mobile)` — 메타 정의만, 코드 미참조(미사용 가능)

- 컬럼 구성(31개)과 표시/숨김은 3-1과 같습니다(표시 27, 숨김 `LONG_QTY`·`OPERATION_NAME`·`ROUTE_NAME`·`ROUTE_TYPE`).
- 코드 어디에서도 이 시트명을 쓰지 않습니다. 폐기 후보이며, TO-BE 반영 여부는 확인 필요입니다.

### 3-3. Division별 표시 차이

| 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Inventory Raw(IT & Mobile) | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 |
| Inventory Raw(Mobility & IT) | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 |

→ Division별 차이는 없습니다. 분기 조건 판단불가 0건입니다.

## 4. 시트 연결 규칙

| 시트 | 규칙 | 코드 근거 |
|---|---|---|
| `Inventory Raw(Mobility & IT)` | META+코드연결 | `CreateSpread`:188 `AddSheet` → :191 `ChangeSheet` → `InitSpread`:200 `InitSheet` → :202 `SetSheetHeaderColumn(spdInfo, 1)` |
| `Inventory Raw(IT & Mobile)` | 메타 정의만, 코드 미참조 | 없음 |

- 컬럼헤더 1행(`SetSheetHeaderColumn` 두 번째 인자 1)
- 컬럼 푸터 표시(`InitSpreadFooterSum`:217). 합계 대상 컬럼은 확인 필요
