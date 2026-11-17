# SSP0012 As-is 분석 — Shipment Plan Confirm Detail

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0012). 이 묶음에 없는 내용은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0012 |
| 클래스 | `SSP0012_ShipmentPlanConfirmDetail` |
| 도메인 | SSP (프로젝트 `GSCM.SSP.Plan.UIL`) |
| 폼 Text (Designer.cs:545) | `Shipment Plan Confirm` |
| Grid 시트 | `Shipment Plan Confirm Detail` (1개) |
| Grid 구성 방식 | `META(프레임워크) (+코드 표시/라벨 변경)` |

### 1-1. 파일 구성

| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(only) | `06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs` | `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj` | 619 |
| current(only) | `06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs` | `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj` | 598 |
| shared | 없음 (Fact Pack 에 shared 로 분류된 파일 없음) | - | - |
| legacy | 없음 (Fact Pack 에 legacy 로 분류된 파일 없음) | - | - |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| # | 진입점 | 호출 경로 | 호출 줄 | 엔드포인트 | 상태 | SP / SQL |
|---:|---|---|---:|---|---|---|
| 1 | event `this.Load` | `Form_Load` > `InitControls` > `GetDayRange` | 596 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH | SP `SCM0001_GET_SCP_DAY_PERIOD` |
| 2 | event `clbDivision.SelectedIndexChanged` | `clbDivision_SelectedIndexChanged` > `SetChangedControl` > `GetDayRange` | 596 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH | SP `SCM0001_GET_SCP_DAY_PERIOD` |
| 3 | button `FindButton` (조회) | `FindButton` > `FindData_Main` | 418 | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | MATCH | SP `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` |
| 4 | 정적 분석상 진입점 미연결 | 필드 초기화 `<field:dtFcstType>` | 56 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | - |
| 5 | 정적 분석상 진입점 미연결 | 필드 초기화 `<field:dtBaseDay>` | 57 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | - |
| 6 | 정적 분석상 진입점 미연결 | `SetChangedPeriod` | 542 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH | - |

- 4·5번은 클래스 필드 초기화식이라 이벤트 진입점이 연결되지 않은 것으로 추출되었습니다. 실제로는 폼 인스턴스가 생성될 때 실행될 수 있으나, 실행 시점과 사용 여부는 **확인 필요**입니다.
- 6번 `SetChangedPeriod` 는 정적 분석으로 호출자를 찾지 못했습니다. 실제로 호출되는지(사용되지 않는 코드인지)는 **확인 필요**입니다.
- `SetChangedControl:366`, `FindData_Main:398`, `FindData_Main:399` 에서 `CString.GetCheckedListValue` 로 CheckedList 선택값(`CODE`)을 읽습니다. 어느 컨트롤을 읽는지(clbDivision / clbPlantSite)는 줄 번호만 추출되었으므로 **확인 필요**입니다.

## 3. 엔드포인트 전체

| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 2 | - | - | 코드 분기 `UP_FX_GetCommonDataList`: SELECT `SCM_ADM_LOOKUP_MASTER`, SELECT `SCM_ADM_LOOKUP_MASTER_DETAIL` |
| `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH | 1 | - | - | 없음 (분기 테이블 **확인 필요**) |
| `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH | 1 | SP `SCM0001_GET_SCP_DAY_PERIOD` | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE | - |
| `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | MATCH | 1 | SP `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | EXEC:SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL, CREATE:#TBLDYNAMICPIVOT_SSP0012, REF:FN_GET_IN_STR, DYNAMIC@SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL, SELECT:#TBLDYNAMICPIVOT_SSP0012, REF:FN_SCM_SPLIT | - |

### 3-1. 주석 처리된 호출 (현행 기능 아님)

| 줄 | 값 | 상태 |
|---:|---|---|
| 595 | `SCP.GET_DATE_RANGE_1MONTH` | 주석 처리됨 |

- 위 호출은 **주석 처리됨** 상태이므로 현행 기능 집계에서 뺐습니다. 이 화면에는 저장/삭제 엔드포인트가 추출되지 않았습니다. 조회 전용 화면으로 보이며, 이 판단은 추출 결과에 근거합니다.

## 4. 이벤트 배선

| 대상 | 이벤트 | 핸들러 | 배선 위치 | 연결 엔드포인트 |
|---|---|---|---|---|
| `this` | Load | `Form_Load` | `.ctor:186` | `SCP.SCM0001_GET_SCP_DAY_PERIOD` (InitControls > GetDayRange) |
| `this.spdMain` | TopChange | `SpdMain_TopChange` | `InitEvent:277` | 추출된 엔드포인트 없음. 동작은 **확인 필요** |
| `this.btnItemId` | Click | `btnItemId_Click` | `InitEvent:278` | 추출된 엔드포인트 없음. 341행에서 `txtItemId.Text = sItemId` |
| `this.spdMain` | CellClick | `SpdMain_CellClick` | `InitEvent:280` | 추출된 엔드포인트 없음. 동작은 **확인 필요** |
| `clbDivision` | SelectedIndexChanged | `clbDivision_SelectedIndexChanged` | `InitEvent:282` | `SCP.SCM0001_GET_SCP_DAY_PERIOD` (SetChangedControl > GetDayRange) |
| `this.btnColumn` | Click | `BtnColumn_Click` | `InitEvent:284` | 추출된 엔드포인트 없음. 동작은 **확인 필요** |

- 표준 툴바 `FindButton` 은 이벤트 배선이 아니라 프레임워크 버튼 진입점으로 추출되었습니다(`FindButton` > `FindData_Main`).

## 5. DB/메타 컬럼 사용

| 메서드 | 줄 | 대상 | 컬럼 |
|---|---:|---|---|
| `<field:dtMyDivision>` | 48 | `UserInfoContext.Current` | `NowGroupID` |
| `InitControls` | 237 | `c` | `CODE` |
| `SetChangedPeriod` | 549 | `dt.Rows[0]` | `FROM_VALUE` |
| `SetChangedPeriod` | 550 | `dt.Rows[0]` | `TO_VALUE` |

### 5-1. 프레임워크 메타 소비 메서드

| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| `SetSheetHeaderColumn` | InitSpread:266 | `SpreadInfo.SetSheetHeaderColumn` | ATTRIBUTE1~5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| `GetCheckedListValue` | SetChangedControl:366, FindData_Main:398, FindData_Main:399 | `CString.GetCheckedListValue` | CODE |

## 6. Grid 구성 방식

**구성 방식: `META(프레임워크) (+코드 표시/라벨 변경)`**

1. `CreateSpread:253`: `AddSheet(spdMain, "Shipment Plan Confirm Detail", "Shipment Plan Confirm Detail", 2, 1, 30)`. 시트 이름은 하드코딩되어 있습니다. 2/1/30 인자의 뜻은 **확인 필요**입니다.
2. `CreateSpread:254`: `GetSheetInfo(spdMain.Name, 0)`, `CreateSpread:256`: `ChangeSheet`
3. `InitSpread:264`: `InitSheet`, 조건 `if(spdInfo.SheetName == "Shipment Plan Confirm Detail")`
4. `InitSpread:266`: `SetSheetHeaderColumn(spdInfo, 2)`. 메타(`SCM_MST_SHEET_COLUMNS`)로 컬럼을 만들고, `iColumnHeaderRowCount = 2` 이므로 헤더는 2행입니다.
5. 코드 변경(같은 시트 조건)
   - `InitSpread:270`: `INCOTERMS` 컬럼의 CellType = `cellTypeImage`
   - `InitSpread:271`: `CHANGE_REQ_NO` 컬럼의 CellType = `cellTypeImage`

### 6-1. Division별 차이

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Plan Confirm Detail | META+코드연결 | 44 | 44 | 44 | 44 | 44 | 44 | 44 | 44 | 44 | 44 | 44 | 44 | 44 | 44 |

- 메타 행은 47개입니다. 그중 표시(기본) 44개, 숨김 3개(`BOD_ID`, `ORIGIN_FROM_DIVISION_ID`, `PLAN_QTY`)입니다. 필수(USER_SELECTABLE_FLAG='N')와 선택 컬럼은 0개입니다(메타 규칙 44/0).
- 모든 division 에서 표시 컬럼 구성이 같고, **division별 차이는 없습니다**.
- 코드 분기는 시트명 비교뿐이고 division 변수를 비교하는 분기는 추출되지 않았습니다(분기 판단불가 0건).
- 실제 SP 실행 결과와 맞춰 본 결과는 없습니다(grid 단계 미실행 또는 시트명 불일치).

## 7. 확인 필요 항목

| # | 항목 | 근거 |
|---:|---|---|
| 1 | `SpdMain_TopChange`, `SpdMain_CellClick`, `BtnColumn_Click` 의 실제 동작(셀 클릭 시 이미지 셀 `INCOTERMS`/`CHANGE_REQ_NO` 와의 관계 포함) | 핸들러 본문 사실 미추출 |
| 2 | `btnItemId_Click` 에서 `sItemId` 를 얻는 방법(팝업 여부와 팝업 화면 ID) | 341행 대입만 추출됨 |
| 3 | `dtFcstType`·`dtBaseDay`(LookupCommon)의 lookup 코드값과 사용처 | 필드 초기화, 진입점 미연결 |
| 4 | `SetChangedPeriod`(PERIOD_{value} \|\| PERIOD_DEFAULT) 호출 여부와 분기 테이블 | 진입점 미연결, DB 보강 없음 |
| 5 | `GetCheckedListValue` 3곳(366/398/399)의 대상 컨트롤 | 줄 번호만 추출됨 |
| 6 | `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` 의 입력 파라미터 목록과 결과 컬럼(동적 피벗)이 메타 47컬럼과 맞는지 | SP 파라미터·결과셋 미추출 |
| 7 | 2행 헤더의 상단 그룹 텍스트(`A_*`/`D_*` 컬럼의 라벨 `Country*`, `Port Code*`, `Port*` 가 겹침) | 상단 헤더 값 미추출 |
| 8 | `AddSheet` 인자 2/1/30 의 의미 | 인자 원문만 추출됨 |
| 9 | 권한(TB_FX_GroupMenuAuth 16행)의 내용 | 행 수만 추출됨 |
