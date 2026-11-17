=== FILE: analysis.md ===
# SSP0017 As-is 분석서 — Inventory Raw(Small)

> 출처: AsisFacts 정적 추출 Fact Pack(SSP0017). 이 문서는 Fact Pack에 있는 사실만 담았습니다. Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.

## 1. 화면 개요

| 항목 | 값 | 근거 |
|---|---|---|
| 화면 ID | SSP0017 | Fact Pack |
| 클래스 | `SSP0017_InventoryRaw` | controls.csv |
| 폼 Text(화면 제목) | `Inventory Raw(Small)` | props.csv `this.Text` (Designer.cs:589) |
| 도메인 | SSP (프로젝트 `GSCM.SSP.Plan.UIL`) | 파일 구성 |
| 화면 성격 | 조회 전용. 활성 엔드포인트는 모두 조회(GET/CommonDataList)이며, 저장 계열 호출은 추출되지 않았습니다. | endpoints.csv |

### 1-1. 파일 구성

| 구분(variant) | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only (current) | `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj` | 547 |
| only (current) | `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs` | `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj` | 641 |

- **shared**: 없음 (Fact Pack에 shared 파일 미추출)
- **legacy**: 없음 (variant가 모두 `only` = 현행)

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| # | 진입점 | 호출 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---:|---|---|---:|---|---|---|
| 1 | event: `this.Load` (`Form_Load`) | `Form_Load` > `InitControls` | 179 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | (공통 BIZ → `UP_FX_GetCommonDataList`) |
| 2 | event: `this.Load` (`Form_Load`) | `Form_Load` > `InitControls` > `SetChangedControl` | 365 | `biz:CommonData.CommonDataList` [code=PlanDateShip] | BIZ_MATCH | (공통 BIZ → `UP_FX_GetCommonDataList`) |
| 3 | event: `clbDivision.SelectedIndexChanged` (`clbDivision_SelectedIndexChanged`) | `clbDivision_SelectedIndexChanged` > `SetChangedControl` | 365 | `biz:CommonData.CommonDataList` [code=PlanDateShip] | BIZ_MATCH | (공통 BIZ → `UP_FX_GetCommonDataList`) |
| 4 | button: `FindButton` (프레임워크 조회 버튼) | `FindButton` > `FindData_Main` | 405 | `SSP.SSP0017_GET_INVENTORY_RAW` | MATCH | SP `SSP0017_GET_INVENTORY_RAW` |
| 5 | (진입점 미연결) | `<field:dtInventoryStatus>` (필드 초기화) | 49 | `biz:CommonData.CommonDataList` [code=OWMS_STOCK_STATUS] | BIZ_MATCH | (공통 BIZ) |
| 6 | (진입점 미연결) | `GetDivision` | 478 | `SCM.SCM0001_GET_DIVISION` | MATCH | SP `SCM0001_GET_DIVISION` |
| 7 | (진입점 미연결) | `GetDayRange` | 514 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH | SP `SCM0001_GET_SCP_DAY_PERIOD` |

- #5는 필드 초기화식이라 클래스 생성 시점에 실행될 수 있습니다. 다만 정적 파서가 이벤트 진입점과 연결하지 못했으므로 실행 여부는 **확인 필요**입니다.
- #6 `GetDivision`, #7 `GetDayRange`는 이 화면 안에서 호출자를 찾지 못했습니다(unreached). 실제 사용 여부는 **확인 필요**입니다(미사용 메서드일 수 있음).
- `btnItemId_Click`, `btnMeasure_Click`, `SpdMain_TopChange`에서 나가는 엔드포인트 호출은 추출되지 않았습니다. 내부에서 팝업을 여는지 등 동작은 **확인 필요**입니다. 확인된 사실은 `btnItemId_Click`:301에서 `txtItemId.Text = sItemId`로 값을 넣는다는 것 하나입니다.

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강(코드 분기) |
|---|---|---:|---|---|---|
| `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 1 | — | — | `UP_FX_GetCommonDataList`: SELECT `SCM_ADM_LOOKUP_MASTER`, SELECT `SCM_ADM_LOOKUP_MASTER_DETAIL` |
| `biz:CommonData.CommonDataList` [code=OWMS_STOCK_STATUS] | BIZ_MATCH | 1 | — | — | `UP_FX_GetCommonDataList`: SELECT `SCM_ADM_LOOKUP_MASTER_DETAIL` |
| `biz:CommonData.CommonDataList` [code=PlanDateShip] | BIZ_MATCH | 1 | — | — | `UP_FX_GetCommonDataList`: SELECT `SCM_ADM_LOOKUP_MASTER_DETAIL`, SELECT `SSP_ANL_SHIP_PLAN_P`, SELECT `SSP_PLAN_VERSION_V`, REF `STRING_SPLIT` |
| `SSP.SSP0017_GET_INVENTORY_RAW` | MATCH | 1 | SP `SSP0017_GET_INVENTORY_RAW` | EXEC `SSP0017_GET_INVENTORY_RAW`, SELECT `SCM_MST_ITEM_SN`, REF `FN_CHAR_TO_DATE`, SELECT `SSP_ANL_INVENTORY_RAW`, SELECT `SCM_MST_FACTORY_SN`, SELECT `SCM_MST_SLOC`, SELECT `SCM_MST_SITE`, REF `UF_FX_STRING_SPLIT` | — |
| `SCM.SCM0001_GET_DIVISION` | MATCH | 1 | SP `SCM0001_GET_DIVISION` | EXEC `SCM0001_GET_DIVISION`, SELECT `SCM_MST_DIVISION` | — |
| `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH | 1 | SP `SCM0001_GET_SCP_DAY_PERIOD` | EXEC `SCM0001_GET_SCP_DAY_PERIOD`, REF `FN_MULTY_TIME`, SELECT `SCM_SYS_CALENDAR_M`, REF `FN_WEEKOFDAY_DATE`, SELECT `SCM_ADM_LOOKUP_MASTER_DETAIL`, SELECT `CTE_DATE` | — |

### 3-1. 주석 처리된 호출 (활성 집계 제외)

아래 3건은 소스에서 **주석 처리됨** 상태입니다. 현행 기능이 아닙니다.

| 줄 | 값 | 상태 |
|---:|---|---|
| 513 | `SCP.GET_DATE_RANGE_1MONTH` | 주석 처리됨 (commented:MATCH) |
| 531 | `SCP.GET_DATE_RANGE_1MONTH` | 주석 처리됨 (commented:MATCH) |
| 532 | `SCP.SCM0001_GET_SCP_PERIOD` | 주석 처리됨 (commented:MATCH) |

## 4. 이벤트 배선 표

| 대상 | 이벤트 | 핸들러 | 등록 위치 | 연결 엔드포인트 |
|---|---|---|---|---|
| `this` | Load | `Form_Load` | `.ctor`:122 | `InitControls`→`biz:CommonData.CommonDataList`[LookupCommon], `SetChangedControl`→[PlanDateShip] |
| `spdMain` | TopChange | `SpdMain_TopChange` | `InitEvent`:243 | 추출된 호출 없음 (동작 확인 필요) |
| `this.btnItemId` | Click | `btnItemId_Click` | `InitEvent`:244 | 추출된 호출 없음. `txtItemId.Text = sItemId` (:301) |
| `this.btnMeasure` | Click | `btnMeasure_Click` | `InitEvent`:245 | 추출된 호출 없음 (동작 확인 필요) |
| `clbDivision` | SelectedIndexChanged | `clbDivision_SelectedIndexChanged` | `InitEvent`:247 | `SetChangedControl`→`biz:CommonData.CommonDataList`[PlanDateShip] |
| (프레임워크) | FindButton | `FindData_Main` | 프레임워크 조회 버튼 | `SSP.SSP0017_GET_INVENTORY_RAW` |

- `InitControls`:176에서 `clbDivision.Enabled = false`를 설정합니다. 사용자가 Division을 직접 바꿀 수 없는 상태에서 `clbDivision_SelectedIndexChanged`가 실제로 발생하는 경로(프로그램이 값을 설정할 때 등)는 **확인 필요**입니다.

## 5. 메타/데이터 컬럼 사용

| 메서드 / 위치 | 대상 | 컬럼 | 비고 |
|---|---|---|---|
| `<field:dtMyDivision>` (:46) | `UserInfoContext.Current` | `NowGroupID` | 로그인 사용자 그룹 기반 Division 데이터로 보입니다. 용도는 확인 필요 |
| `SetSheetHeaderColumn` (`InitSpread`:202) | `SpreadInfo.SetSheetHeaderColumn` (프레임워크) | ATTRIBUTE1~5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG | 메타로 Grid 컬럼 생성 |
| `GetCheckedListValue` (`SetChangedControl`:350, `FindData_Main`:386·387·389·390) | `CString.GetCheckedListValue` (프레임워크) | `CODE` | 체크 리스트에서 선택된 CODE 값을 추출. 각 줄이 어느 컨트롤을 읽는지는 확인 필요 |

## 6. Grid 구성 방식

**구성 방식: `META(프레임워크) (+코드 표시/라벨 변경)`**

1. `CreateSpread`:188에서 `AddSheet`로 `spdMain`에 시트 `SpdSheet.shtMain`을 만듭니다. 시트명은 `Inventory Raw(Mobility & IT)`이고, 인자는 `1 ¦ 1 ¦ 30`입니다.
2. `CreateSpread`:189 `GetSheetInfo(spdMain.Name, 0)` → :191 `ChangeSheet`
3. `InitSpread`:200 `if(spdInfo.SheetName == "Inventory Raw(Mobility & IT)")` 조건에서 `InitSheet`
4. `InitSpread`:202 `SetSheetHeaderColumn(spdInfo, 1)`: 컬럼헤더 1행 기준으로 `SCM_MST_SHEET_COLUMNS` 메타에서 컬럼을 생성합니다.
5. `InitSpreadFooterSum`:217 `siMain.ActiveSheet.ColumnFooter.Visible = true`: 컬럼 푸터(합계 행)를 켭니다. 합계 대상 컬럼은 확인 필요입니다.
6. Designer.cs:555~558의 코드 변경 4건은 모두 `ColumnHeaderDefaultEnhanced` 스타일 속성입니다: HorizontalAlignment = General, NoteIndicatorColor = Red, Parent = `ColumnHeaderDefaultEnhanced`, VerticalAlignment = General. 컬럼을 추가하거나 숨기지 않습니다.

### 6-1. 시트와 Division별 차이

| 시트 | 연결 규칙 | 메타 컬럼 수 | 표시 | 숨김 |
|---|---|---:|---:|---:|
| `Inventory Raw(Mobility & IT)` | META+코드연결 (현행 사용 시트) | 31 | 27 | 4 |
| `Inventory Raw(IT & Mobile)` | 메타 정의만, 코드 미참조(미사용 가능) | 31 | 27 | 4 |

- Division 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC **전부 27개(필수+기본 27 / 선택 0)로 같습니다**. Division별 Grid 차이는 없습니다.
- 숨김 컬럼 4개(두 시트 공통): `LONG_QTY`(Long-Term Qty), `OPERATION_NAME`(Operation Name), `ROUTE_NAME`(Route Name), `ROUTE_TYPE`(Route Type)
- 실제 SP 실행 결과와 매칭되는 시트가 없습니다(grid 단계 미실행 또는 시트명 불일치). SP 결과셋 컬럼과 메타 컬럼의 일치 여부는 **확인 필요**입니다.

## 7. DB 메타 데이터 (화면 ID 보유 행)

| 메타 테이블 | 행 수 |
|---|---:|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 2 |
| dbo.SCM_MST_SHEET_COLUMNS | 62 |
| dbo.TB_FX_Favorite | 9 |
| dbo.TB_FX_GroupMenuAuth | 14 |
| dbo.TB_FX_MenuItemInfo | 2 |
| dbo.TB_FX_ProgramInfo | 2 |
| dbo.TB_FX_SearchCondition | 8 |

## 8. 확인 필요 항목

| # | 항목 | 사유 |
|---:|---|---|
| 1 | `GetDivision`(478) → `SCM.SCM0001_GET_DIVISION`의 실사용 여부 | 진입점 미연결(unreached) |
| 2 | `GetDayRange`(514) → `SCP.SCM0001_GET_SCP_DAY_PERIOD`의 실사용 여부 | 진입점 미연결(unreached) |
| 3 | `dtInventoryStatus`(49) [code=OWMS_STOCK_STATUS] 데이터의 사용처 | 필드 초기화. 바인딩 대상 미추출 |
| 4 | [code=LookupCommon](179)이 채우는 컨트롤 | `cboInventoryType`, `cboPlanDate`, `clbPlantSite` 중 어느 것인지 미추출 |
| 5 | `clbPlantSite` 항목의 데이터 출처 | 해당 엔드포인트 미추출 |
| 6 | `btnMeasure_Click`, `btnItemId_Click`, `SpdMain_TopChange` 내부 동작(팝업, 페이징 등) | 엔드포인트 호출 미추출 |
| 7 | `FindData_Main`:386~390 `GetCheckedListValue` 4회가 읽는 컨트롤과 SP 파라미터 매핑 | 파라미터 미추출 |
| 8 | `clbDivision.Enabled=false`(176) 상태에서 `SelectedIndexChanged`가 발생하는 경로 | 정적 추출 한계 |
| 9 | 푸터 합계 대상 컬럼 | `InitSpreadFooterSum` 세부 미추출 |
| 10 | `Inventory Raw(IT & Mobile)` 시트 메타의 폐기 여부 | 코드 미참조 |
| 11 | SP 결과셋 컬럼과 메타 컬럼의 일치 여부 | grid 단계 매칭 시트 없음 |
| 12 | 숨김 4개 컬럼의 사유(VISIBLE_FLAG 또는 VALID_YN) | grid_effective에는 결과만 있음 |

=== FILE: source_links.md ===
# SSP0017 소스 링크 표

> 기준 경로: AS-IS GSCM 소스 루트 아래 `06.UIL\GSCM.SSP.Plan.UIL\`

## 1. 엔드포인트 호출 지점 (활성 전부)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `<field:dtInventoryStatus>` | 49 | `biz:CommonData.CommonDataList` [code=OWMS_STOCK_STATUS] (`Data.Common` → `Data.CallBizCommonData`) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitControls` | 179 | `biz:CommonData.CommonDataList` [code=LookupCommon] (`Data.Common` → `Data.CallBizCommonData`) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `SetChangedControl` | 365 | `biz:CommonData.CommonDataList` [code=PlanDateShip] (`Data.Common` → `Data.CallBizCommonData`) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `FindData_Main` | 405 | `SSP.SSP0017_GET_INVENTORY_RAW` → SP `SSP0017_GET_INVENTORY_RAW` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `GetDivision` | 478 | `SCM.SCM0001_GET_DIVISION` → SP `SCM0001_GET_DIVISION` (진입점 미연결) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `GetDayRange` | 514 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` → SP `SCM0001_GET_SCP_DAY_PERIOD` (진입점 미연결) |

## 2. 주석 처리된 호출 (현행 아님)

| 파일 | 줄 | 내용 |
|---|---:|---|
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | 513 | 주석 처리됨: `SCP.GET_DATE_RANGE_1MONTH` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | 531 | 주석 처리됨: `SCP.GET_DATE_RANGE_1MONTH` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | 532 | 주석 처리됨: `SCP.SCM0001_GET_SCP_PERIOD` |

## 3. 이벤트 등록

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `.ctor` | 122 | `this.Load += Form_Load` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitEvent` | 243 | `spdMain.TopChange += SpdMain_TopChange` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitEvent` | 244 | `this.btnItemId.Click += btnItemId_Click` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitEvent` | 245 | `this.btnMeasure.Click += btnMeasure_Click` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitEvent` | 247 | `clbDivision.SelectedIndexChanged += clbDivision_SelectedIndexChanged` |

## 4. Grid / 컨트롤 초기화 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `<field:dtMyDivision>` | 46 | `UserInfoContext.Current` → `NowGroupID` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitControls` | 176 | `clbDivision.Enabled = false` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `CreateSpread` | 188 | `AddSheet(spdMain, SpdSheet.shtMain, "Inventory Raw(Mobility & IT)", 1, 1, 30)` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `CreateSpread` | 189 | `GetSheetInfo(spdMain.Name, 0)` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `CreateSpread` | 191 | `ChangeSheet` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitSpread` | 200 | `InitSheet` — `if(spdInfo.SheetName == "Inventory Raw(Mobility & IT)")` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitSpread` | 202 | `SetSheetHeaderColumn(spdInfo, 1)` (메타 컬럼 생성) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `InitSpreadFooterSum` | 217 | `siMain.ActiveSheet.ColumnFooter.Visible = true` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `btnItemId_Click` | 301 | `txtItemId.Text = sItemId` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `SetChangedControl` | 350 | `GetCheckedListValue` (CODE) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs` | `FindData_Main` | 386, 387, 389, 390 | `GetCheckedListValue` (CODE) × 4 |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs` | `InitializeComponent` | 555~558 | `ColumnHeaderDefaultEnhanced` 스타일(HorizontalAlignment / NoteIndicatorColor=Red / Parent / VerticalAlignment) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs` | `InitializeComponent` | 589 | `this.Text = "Inventory Raw(Small)"` |

## 5. 컨트롤 선언 (Designer.cs)

| 줄 | 컨트롤 | 유형 | 부모 |
|---:|---|---|---|
| 32 | `usrButton1` | UsrButton | — |
| 33 | `usrConditionPanel1` | UsrConditionPanel | this |
| 34 | `usrLayoutControl2` | UsrLayoutControl | usrConditionPanel1 |
| 35 | `cboPlanDate` | UsrCombo | usrLayoutControl2 |
| 36 | `btnMeasure` | UsrButton | usrLayoutControl2 |
| 37 | `btnItemId` | UsrButton | usrLayoutControl2 |
| 38 | `clbPlantSite` | UsrCheckedList | usrLayoutControl2 |
| 39 | `txtItemId` | UsrMultiLineEditor | usrLayoutControl2 |
| 40 | `cboInventoryType` | UsrCombo | usrLayoutControl2 |
| 41 | `clbDivision` | UsrCheckedList | usrLayoutControl2 |
| 42~51 | `layoutControlGroup2`, `emptySpaceItem3`, `layoutControlItem7`, `lblItemId`, `layoutControlItem2`, `PlanDate`, `layoutControlItem10`, `emptySpaceItem1`, `lcDivision`, `lblInventoryType` | Layout 계열 | — |
| 52 | `imageList1` | ImageList | — |
| 53 | `panel1` | Panel | this |
| 54 | `spdMain` | FpSpread | panel1 |
| 55 | `spdMain_Sheet1` | SheetView | — |

=== FILE: web_components.md ===
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

=== FILE: oracle_migration.md ===
# SSP0017 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 키 | 호출 위치 | 진입점 상태 | 참조 객체 / EXEC 체인 |
|---|---|---|---|---|
| `SSP0017_GET_INVENTORY_RAW` | `SSP.SSP0017_GET_INVENTORY_RAW` | `FindData_Main`:405 | 활성 (FindButton) | SELECT `SCM_MST_ITEM_SN`, `SSP_ANL_INVENTORY_RAW`, `SCM_MST_FACTORY_SN`, `SCM_MST_SLOC`, `SCM_MST_SITE` / REF `FN_CHAR_TO_DATE`, `UF_FX_STRING_SPLIT` |
| `SCM0001_GET_DIVISION` | `SCM.SCM0001_GET_DIVISION` | `GetDivision`:478 | 진입점 미연결 | SELECT `SCM_MST_DIVISION` |
| `SCM0001_GET_SCP_DAY_PERIOD` | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | `GetDayRange`:514 | 진입점 미연결 | SELECT `SCM_SYS_CALENDAR_M`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, `CTE_DATE`(CTE) / REF `FN_MULTY_TIME`, `FN_WEEKOFDAY_DATE` |
| `UP_FX_GetCommonDataList` | `biz:CommonData.CommonDataList` | 49, 179, 365 | 179·365 활성 / 49 미연결 | 아래 2장의 코드 분기 |

- 위 SP에서 다른 SP로 이어지는 EXEC 체인은 추출되지 않았습니다(EXEC는 자기 자신만 표기됨).
- 주석 처리됨(전환 대상 아님): `SCP.GET_DATE_RANGE_1MONTH`(513, 531), `SCP.SCM0001_GET_SCP_PERIOD`(532)

## 2. 공통코드 분기 (`biz:CommonData.CommonDataList` → `UP_FX_GetCommonDataList`)

| code | 호출 위치 | 참조 테이블 / 객체 |
|---|---|---|
| `LookupCommon` | `InitControls`:179 | `SCM_ADM_LOOKUP_MASTER`, `SCM_ADM_LOOKUP_MASTER_DETAIL` |
| `PlanDateShip` | `SetChangedControl`:365 | `SCM_ADM_LOOKUP_MASTER_DETAIL`, `SSP_ANL_SHIP_PLAN_P`, `SSP_PLAN_VERSION_V`, REF `STRING_SPLIT` |
| `OWMS_STOCK_STATUS` | `<field:dtInventoryStatus>`:49 | `SCM_ADM_LOOKUP_MASTER_DETAIL` |

- LookupCommon의 lookup 마스터 코드값(어떤 LOOKUP_TYPE인지)은 Fact Pack에 없어 **확인 필요**입니다.

## 3. FoxQuery 미등록 / 직접 호출 SP

- 모든 SP 호출의 상태가 `MATCH`(FoxQuery 등록 확인) 또는 `BIZ_MATCH`(공통 BIZ)입니다. **FoxQuery 미등록 SP나 직접 호출 SQL은 추출되지 않았습니다.**
- Fact Pack 7장 '확인 필요' 0건

## 4. Oracle 전환 시 확인 포인트

| # | 대상 | 포인트 | 근거 |
|---:|---|---|---|
| 1 | `UP_FX_GetCommonDataList` [PlanDateShip] | MSSQL `STRING_SPLIT` 참조 → Oracle에는 같은 함수가 없어 대체 구현이 필요합니다(금지 키워드 ⑩) | DB 보강 REF:STRING_SPLIT |
| 2 | `SSP0017_GET_INVENTORY_RAW` | `UF_FX_STRING_SPLIT`(사용자 함수) 참조 → Oracle 측 동등 함수가 있는지 확인 필요 | REF:UF_FX_STRING_SPLIT |
| 3 | `SSP0017_GET_INVENTORY_RAW` | `FN_CHAR_TO_DATE` 참조 → Oracle 동등 함수 존재 확인 필요 | REF:FN_CHAR_TO_DATE |
| 4 | `SCM0001_GET_SCP_DAY_PERIOD` | `FN_MULTY_TIME`, `FN_WEEKOFDAY_DATE` 참조, CTE(`CTE_DATE`) 사용 → 함수 이관 여부와 CTE 구문(재귀 여부) 확인 필요 | REF / SELECT:CTE_DATE |
| 5 | `SCM0001_GET_DIVISION`, `SCM0001_GET_SCP_DAY_PERIOD` | 이 화면에서는 진입점 미연결 → 화면 단독 전환 범위에 넣을지 확인 필요. SCM0001 공용 SP라면 다른 화면의 전환 상태 확인 필요 | flow.csv unreached |
| 6 | 결과셋 컬럼 | SP 결과와 메타 시트 매칭이 미실행됨 → Oracle SP의 결과 컬럼 31개(메타 COLUMN_NAME)가 일치하는지 대조 필요 | Fact Pack 10장 |
| 7 | 파라미터 | `FindData_Main`:386~390 `GetCheckedListValue`(CODE) 4회 → 다건 코드 문자열 파라미터로 보이며, 분리 방식(구분자) 확인 필요 | 4-2장 |

## 5. 난이도 (사실 근거)

| SP | 근거 사실 | 판단 |
|---|---|---|
| `SSP0017_GET_INVENTORY_RAW` | SELECT 5개 테이블 + 함수 2개(`FN_CHAR_TO_DATE`, `UF_FX_STRING_SPLIT`) 참조 | 함수 의존성 확인이 선행되어야 함. SP 본문 원문이 없어 정량 난이도는 확인 필요 |
| `SCM0001_GET_DIVISION` | SELECT 1개 테이블(`SCM_MST_DIVISION`) | 참조 객체가 1개뿐 |
| `SCM0001_GET_SCP_DAY_PERIOD` | SELECT 2개 테이블 + CTE + 함수 2개 | 함수와 CTE 확인 필요 |
| `UP_FX_GetCommonDataList` | `STRING_SPLIT` 사용 (PlanDateShip 분기) | MSSQL 전용 구문 대체 필요 |

=== FILE: tobe_design.md ===
# SSP0017 TO-BE 설계 입력 (Inventory Raw(Small))

## 1. 조회조건 (컨트롤 기준)

| 라벨(원문) | AS-IS 컨트롤 | 유형 | 필수 | 초기 상태 / 데이터 | 비고 |
|---|---|---|---|---|---|
| `Plan-date*` | `cboPlanDate` | 단일 콤보 | 라벨에 `*` 표시 | [code=PlanDateShip] (`SetChangedControl`:365, Form_Load 시와 Division 변경 시 갱신) | |
| `Division` | `clbDivision` | 다중 체크 | 확인 필요 | `Enabled=false` (`InitControls`:176) | 사용자 Division 기본 설정 로직(`dtMyDivision` ← `NowGroupID`)과의 관계는 확인 필요 |
| `Plant Site` | `clbPlantSite` | 다중 체크 | 확인 필요 | 데이터 출처 확인 필요 | |
| `Inventory Type` | `cboInventoryType` | 단일 콤보 | 확인 필요 | 데이터 출처 확인 필요 (LookupCommon 후보) | |
| `Model` | `txtItemId` (+`btnItemId`) | 멀티라인 입력 + 버튼 | 확인 필요 | `btnItemId_Click`에서 `txtItemId.Text = sItemId` | |
| (라벨 없음) | `btnMeasure` | 버튼 | — | Click → `btnMeasure_Click` | 동작 확인 필요 |

- 조회조건 패널은 `HidePanel` 타입(접기 가능)입니다.
- TB_FX_SearchCondition에 이 화면 행이 8건 있습니다(조회조건 저장/복원 기능으로 보이며, 내용은 확인 필요).

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 핸들러 / 경로 | AS-IS 엔드포인트 | TO-BE API 후보 |
|---|---|---|---|
| 화면 진입 | `Form_Load` > `InitControls` | `biz:CommonData.CommonDataList` [LookupCommon] | 공통코드 조회 API (공용) |
| 화면 진입 / Division 변경 | `Form_Load` > `InitControls` > `SetChangedControl`, `clbDivision_SelectedIndexChanged` > `SetChangedControl` | `biz:CommonData.CommonDataList` [PlanDateShip] | 공통코드 조회 API (PlanDateShip, Division 파라미터) |
| 조회(Find) | `FindButton` > `FindData_Main` | `SSP.SSP0017_GET_INVENTORY_RAW` | 화면 조회 API → Oracle `SSP0017_GET_INVENTORY_RAW` |
| Model 버튼 | `btnItemId_Click` | 추출 없음 | 확인 필요 (결과를 `txtItemId`에 반영) |
| Measure 버튼 | `btnMeasure_Click` | 추출 없음 | 확인 필요 |
| Grid 스크롤 | `SpdMain_TopChange` | 추출 없음 | 확인 필요 (FlexGrid 스크롤 이벤트로 대응할지 판단 필요) |
| (미연결) | `GetDivision` | `SCM.SCM0001_GET_DIVISION` | 사용 여부가 확인된 뒤 결정 |
| (미연결) | `GetDayRange` | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 사용 여부가 확인된 뒤 결정 |
| (미연결) | `<field:dtInventoryStatus>` | `biz:CommonData.CommonDataList` [OWMS_STOCK_STATUS] | 사용 여부가 확인된 뒤 결정 |

- 주석 처리된 호출(`SCP.GET_DATE_RANGE_1MONTH`, `SCP.SCM0001_GET_SCP_PERIOD`)은 TO-BE 범위에서 제외합니다.
- 저장·삭제 액션은 추출되지 않았습니다. 조회 전용 화면으로 판단합니다.

## 3. Division별 Grid 변형 요약

- 현행 시트: `Inventory Raw(Mobility & IT)` (META+코드연결). 메타 31개 컬럼 중 표시 27개, 숨김 4개(`LONG_QTY`, `OPERATION_NAME`, `ROUTE_NAME`, `ROUTE_TYPE`)
- Division 14개 전부 27개로 같아서 **Division별 변형이 없습니다**.
- `Inventory Raw(IT & Mobile)` 시트는 메타에만 있고 코드는 참조하지 않습니다. 폐기 후보입니다.
- 컬럼헤더 1행, 컬럼 푸터(합계) 표시. 합계 컬럼은 확인 필요입니다.
- 메타 기반 Grid이므로 TO-BE에서도 메타(`SCM_MST_SHEET_COLUMNS` 대응) 기반 컬럼 구성이 전제입니다.

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 값 |
|---|---|
| TB_FX_GroupMenuAuth 화면 행 수 | 14 |
| TB_FX_MenuItemInfo 행 수 | 2 |
| TB_FX_ProgramInfo 행 수 | 2 |
| TB_FX_Favorite 행 수 | 9 |
| 코드상 권한 분기 | 추출되지 않음 |
| C/U/D 엔드포인트 | 없음 (조회만 존재) |

- 그룹별 C/R/U/D 플래그 값은 Fact Pack에 없습니다(행 수만 있음). 원문 CSV `dbmeta_dbo_TB_FX_GroupMenuAuth.csv` 확인이 필요합니다.

## 5. 미확정 사항

1. `btnMeasure_Click`, `btnItemId_Click`, `SpdMain_TopChange`의 내부 동작
2. `clbDivision`을 비활성(`Enabled=false`) 상태로 두는 정책, 그리고 `NowGroupID` 기반 기본 Division 설정 방식
3. `clbPlantSite`, `cboInventoryType`의 데이터 출처
4. `FindData_Main`:386~390 파라미터와 SP 인자 매핑
5. `GetDivision`, `GetDayRange`, `dtInventoryStatus`(진입점 미연결)의 실사용 여부
6. Grid 컬럼 표시 순서, 합계 대상 컬럼, 숨김 4개 컬럼의 사유
7. SP 결과셋과 메타 컬럼의 일치 여부 (grid 매칭 미실행)
8. `Inventory Raw(IT & Mobile)` 메타 시트를 폐기할지 여부
9. `usrButton1`(부모 미지정)이 화면에 실제로 배치되는지
10. 라벨 `Valtage` 철자를 유지할지 정정할지
