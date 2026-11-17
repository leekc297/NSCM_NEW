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
