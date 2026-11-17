=== FILE: analysis.md ===
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

=== FILE: source_links.md ===
# SSP0012 소스 링크

> 기준 경로: AS-IS GSCM 소스 루트 기준 상대 경로. 줄 번호는 Fact Pack 추출값입니다.

- **CS** = `06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs`
- **DS** = `06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs`

## 1. 엔드포인트 호출 지점 (전수)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `<field:dtFcstType>` | 56 | `biz:CommonData.CommonDataList` [code=LookupCommon] (Data.Common > Data.CallBizCommonData) |
| CS | `<field:dtBaseDay>` | 57 | `biz:CommonData.CommonDataList` [code=LookupCommon] (Data.Common > Data.CallBizCommonData) |
| CS | `FindData_Main` | 418 | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` → SP `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` |
| CS | `SetChangedPeriod` | 542 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] (Data.CallBizCommonData) |
| CS | `GetDayRange` | 596 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` → SP `SCM0001_GET_SCP_DAY_PERIOD` |
| CS | (주석) | 595 | `SCP.GET_DATE_RANGE_1MONTH`: **주석 처리됨** (현행 아님) |

## 2. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `.ctor` | 186 | `this.Load += Form_Load` |
| CS | `InitEvent` | 277 | `this.spdMain.TopChange += SpdMain_TopChange` |
| CS | `InitEvent` | 278 | `this.btnItemId.Click += btnItemId_Click` |
| CS | `InitEvent` | 280 | `this.spdMain.CellClick += SpdMain_CellClick` |
| CS | `InitEvent` | 282 | `clbDivision.SelectedIndexChanged += clbDivision_SelectedIndexChanged` |
| CS | `InitEvent` | 284 | `this.btnColumn.Click += BtnColumn_Click` |

## 3. Grid 구성 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `CreateSpread` | 253 | `AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30)`: 시트 `Shipment Plan Confirm Detail` |
| CS | `CreateSpread` | 254 | `GetSheetInfo(spdMain.Name, 0)` |
| CS | `CreateSpread` | 256 | `ChangeSheet` |
| CS | `InitSpread` | 264 | `InitSheet(SpdSheet.shtMain)`, 조건 `spdInfo.SheetName == "Shipment Plan Confirm Detail"` |
| CS | `InitSpread` | 266 | `SetSheetHeaderColumn(spdInfo, 2)`: 메타 컬럼 생성 |
| CS | `InitSpread` | 270 | `INCOTERMS` CellType = `cellTypeImage` |
| CS | `InitSpread` | 271 | `CHANGE_REQ_NO` CellType = `cellTypeImage` |

## 4. 메타/데이터 컬럼 읽기 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `<field:dtMyDivision>` | 48 | `UserInfoContext.Current` → `NowGroupID` |
| CS | `InitControls` | 237 | `c["CODE"]` |
| CS | `btnItemId_Click` | 341 | `txtItemId.Text = sItemId` |
| CS | `SetChangedControl` | 366 | `CString.GetCheckedListValue` (CODE) |
| CS | `FindData_Main` | 398 | `CString.GetCheckedListValue` (CODE) |
| CS | `FindData_Main` | 399 | `CString.GetCheckedListValue` (CODE) |
| CS | `SetChangedPeriod` | 549 | `dt.Rows[0]["FROM_VALUE"]` |
| CS | `SetChangedPeriod` | 550 | `dt.Rows[0]["TO_VALUE"]` |

## 5. 컨트롤 선언 (Designer)

| 파일 | 컨트롤 | 줄 | 유형 |
|---|---|---:|---|
| DS | usrButton1 | 33 | UsrButton |
| DS | usrConditionPanel1 | 34 | UsrConditionPanel |
| DS | usrLayoutControl2 | 35 | UsrLayoutControl |
| DS | btnItemId | 36 | UsrButton |
| DS | clbPlantSite | 37 | UsrCheckedList |
| DS | drpPeriod | 38 | UsrDateRangePicker |
| DS | txtItemId | 39 | UsrMultiLineEditor |
| DS | clbDivision | 40 | UsrCheckedList |
| DS | txtSoldToParty | 41 | TextBox |
| DS | txtShipToParty | 42 | TextBox |
| DS | btnColumn | 43 | UsrButton |
| DS | layoutControlGroup2 | 44 | LayoutControlGroup |
| DS | emptySpaceItem3 | 45 | EmptySpaceItem |
| DS | layoutControlItem7 | 46 | LayoutControlItem |
| DS | lblItemId | 47 | LayoutControlItem |
| DS | layoutControlItem2 | 48 | LayoutControlItem |
| DS | layoutControlItem6 | 49 | LayoutControlItem |
| DS | emptySpaceItem1 | 50 | EmptySpaceItem |
| DS | lcDivision | 51 | LayoutControlItem |
| DS | layoutControlItem1 | 52 | LayoutControlItem |
| DS | layoutControlItem3 | 53 | LayoutControlItem |
| DS | layoutControlItem5 | 54 | LayoutControlItem |
| DS | spdMain | 55 | FpSpread |
| DS | spdMain_Sheet1 | 56 | SheetView |
| DS | imageList1 | 57 | ImageList |

## 6. 레이아웃 라벨 (Designer InitializeComponent)

| 파일 | 대상 | 줄 | 내용 |
|---|---|---:|---|
| DS | layoutControlItem7 | 415 | Text `From Site` (Control: clbPlantSite, 411) |
| DS | lblItemId | 427 | Text `Model` (Control: txtItemId, 422) |
| DS | layoutControlItem6 | 453 | Text `Period*` (Control: drpPeriod, 446) |
| DS | lcDivision | 473 | Text `Division` (Control: clbDivision, 468) |
| DS | layoutControlItem1 | 485 | Text `Sold To Party` (Control: txtSoldToParty, 480) |
| DS | layoutControlItem3 | 497 | Text `Ship To Party` (Control: txtShipToParty, 492) |
| DS | spdMain | 518 / 523 | Dock Fill / Size(1192, 576) |
| DS | this | 545 | Text `Shipment Plan Confirm` |

=== FILE: web_components.md ===
# SSP0012 Web 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

| AS-IS 컨트롤 | 유형 | 라벨 (원문) | Size | TO-BE 후보 | 비고 |
|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | - | 1192×73, Dock Top, `HidePanel` | 조회조건 영역(접기 가능) | `UsrPanelType = HidePanel` |
| usrLayoutControl2 | UsrLayoutControl | (Text `usrLayoutControl2`) | 1192×73, Dock Top | 조회조건 레이아웃 | - |
| clbPlantSite | UsrCheckedList | `From Site` (layoutControlItem7) | 100×21 | 다중 선택 콤보(MultiSelect) | 항목 데이터 출처 **확인 필요** |
| txtItemId | UsrMultiLineEditor | `Model` (lblItemId) | 272×21 | 여러 줄 입력 | - |
| btnItemId | UsrButton | (LayoutControlItem Text 없음, layoutControlItem2) | 39×24 | 검색 버튼(팝업 후보) | 결과 → `txtItemId.Text` (341행). 팝업 여부 **확인 필요** |
| drpPeriod | UsrDateRangePicker | `Period*` (layoutControlItem6) | 205×20 | 기간(From~To) 날짜 범위, 필수 표시 `*` | 기본값 = `SCM0001_GET_SCP_DAY_PERIOD` 결과 |
| clbDivision | UsrCheckedList | `Division` (lcDivision) | 100×21 | 다중 선택 콤보 | 변경 시 기간 재계산 |
| txtSoldToParty | TextBox | `Sold To Party` (layoutControlItem1) | 273×20 | 텍스트 입력 | - |
| txtShipToParty | TextBox | `Ship To Party` (layoutControlItem3) | 268×20 | 텍스트 입력 | - |
| btnColumn | UsrButton | (LayoutControlItem Text 없음, layoutControlItem5) | 39×25 | 컬럼 설정 버튼 후보 | 동작 **확인 필요** |
| usrButton1 | UsrButton | - | 75×23 | **확인 필요** | parent 없음. 배치 여부 **확인 필요** |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | - | 1192×576, Dock Fill | Wijmo `FlexGrid` | 시트 `Shipment Plan Confirm Detail` |
| imageList1 | ImageList | - | - | 아이콘 리소스 | 이미지 셀(`cellTypeImage`) 관련 여부 **확인 필요** |
| emptySpaceItem3 / emptySpaceItem1 | EmptySpaceItem | - | 464×29 / 156×29 | 여백 | - |

## 2. 화면 배치

- props.csv 에 **SplitContainer 는 없습니다**. Dock 으로 상·하 2단 구성입니다.

| 영역 | 컨트롤 | Dock | Size(높이) | 비율(높이 기준) |
|---|---|---|---:|---:|
| 상단 | usrConditionPanel1 (조회조건) | Top | 73 | 73 / 649 ≈ 11.2% |
| 하단 | spdMain (Grid) | Fill | 576 | 576 / 649 ≈ 88.8% |

- 폭은 둘 다 1192입니다. 좌·우 분할은 없습니다.
- 조회조건 그룹 layoutControlGroup2 는 1192×78입니다. LayoutControlItem 의 높이가 모두 29이므로, 조회조건은 1행 또는 다중 행 배치로 보입니다. 행/열 배치(Location)는 미추출이므로 **확인 필요**입니다.
- 조회조건 Item 폭: From Site 161, Model 313, 버튼 43, Period* 309, Division 148, Sold To Party 356, Ship To Party 351, 버튼 43

## 3. 시트별 Grid 컬럼 — `Shipment Plan Confirm Detail`

- 연결 규칙: **META+코드연결**. 메타(`SCM_MST_SHEET_COLUMNS`) 47행을 `SetSheetHeaderColumn(spdInfo, 2)` 로 만들고, 헤더는 2행입니다.
- 표시 기준: grid_effective. 모든 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)의 결과가 같습니다.

| # | 컬럼 | 라벨 | 출처 | 표시 | 코드 변경 |
|---:|---|---|---|---|---|
| 1 | A_COUNTRY | Country* | META | 기본 | - |
| 2 | A_PORT_CODE | Port Code* | META | 기본 | - |
| 3 | A_PORT_NAME | Port* | META | 기본 | - |
| 4 | BIZ_TYPE_NAME | Biz Name | META | 기본 | - |
| 5 | BOD_ID | bod_id | META | **숨김** | - |
| 6 | CHANGE_REQ_NO | Change Request No | META | 기본 | CellType = `cellTypeImage` (InitSpread:271) |
| 7 | CONFIRM_ID | Confirm ID | META | 기본 | - |
| 8 | CONFIRM_QTY | Confirmed Qty | META | 기본 | - |
| 9 | D_COUNTRY | Country* | META | 기본 | - |
| 10 | D_PORT_CODE | Port Code* | META | 기본 | - |
| 11 | D_PORT_NAME | Port* | META | 기본 | - |
| 12 | DAYS_FRI | Fri | META | 기본 | - |
| 13 | DAYS_MON | Mon | META | 기본 | - |
| 14 | DAYS_SAT | Sat | META | 기본 | - |
| 15 | DAYS_SUN | Sun | META | 기본 | - |
| 16 | DAYS_THU | Thu | META | 기본 | - |
| 17 | DAYS_TUE | Tue | META | 기본 | - |
| 18 | DAYS_WED | Wed | META | 기본 | - |
| 19 | DIVISION_ID | Division | META | 기본 | - |
| 20 | ERP_SO_NO | SO No | META | 기본 | - |
| 21 | ETA | ETA | META | 기본 | - |
| 22 | ETD | ETD | META | 기본 | - |
| 23 | Expected_Shipping_Date | Expected Shipping Date | META | 기본 | - |
| 24 | FCST_TYPE | FCST Type | META | 기본 | - |
| 25 | FROM_SITE_DESCRIPTION | From Site | META | 기본 | - |
| 26 | INCOTERMS | Incoterms | META | 기본 | CellType = `cellTypeImage` (InitSpread:270) |
| 27 | ITEM_ID | Model | META | 기본 | - |
| 28 | LAST_UPDATE_DATE | Last Update Date | META | 기본 | - |
| 29 | LAST_UPDATED_BY | Last Updated By | META | 기본 | - |
| 30 | LT_ARRIVAL_INLAND | Arrival Inland | META | 기본 | - |
| 31 | LT_DAY | L/T(Day) | META | 기본 | - |
| 32 | LT_DEPARTURE_INLAND | Departure Inland | META | 기본 | - |
| 33 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | META | 기본 | - |
| 34 | LT_SUM | Total L/T | META | 기본 | - |
| 35 | LT_TYPE | L/T Type | META | 기본 | - |
| 36 | LT_VOYAGE | Voyage | META | 기본 | - |
| 37 | LT_WAIT_SHIPPING | Waiting For Shipping | META | 기본 | - |
| 38 | MTK_OWNER | MKT Owner | META | 기본 | - |
| 39 | NICK_NAME | Nick Name | META | 기본 | - |
| 40 | ORIGIN_FROM_DIVISION_ID | ORIGIN_FROM_DIVISION_ID | META | **숨김** | - |
| 41 | PLAN_DATE | Shipment Date(GI) | META | 기본 | - |
| 42 | PLAN_QTY | Planned Qty | META | **숨김** | - |
| 43 | PROJECT_NAME | Project Name | META | 기본 | - |
| 44 | SHIPTO_DESCRIPTION | Ship To Party | META | 기본 | - |
| 45 | SOLDTO_DESCRIPTION | Sold To Party | META | 기본 | - |
| 46 | TO_SITE_DESCRIPTION | To Site | META | 기본 | - |
| 47 | TRANSPORT_MODE | Trans Mode | META | 기본 | - |

- 집계: 메타 47 / 표시 44 / 숨김 3 / 코드 추가 컬럼 0 / 코드 변경 2(CellType)
- 위 표는 grid_effective 의 순서(컬럼명 정렬)입니다. **실제 컬럼 순서**(메타 정렬 순번), 폭, 정렬, 고정(FIXED_FLAG), 2행 헤더의 상단 그룹 텍스트는 Fact Pack 에 없으므로 **확인 필요**입니다.
- `A_*`/`D_*` 라벨(`Country*`, `Port Code*`, `Port*`)이 같습니다. TO-BE 에서도 2단 헤더(ColumnGroup)로 구분해야 하는지는 상단 헤더 원문을 확인한 뒤 정합니다.
- `INCOTERMS`, `CHANGE_REQ_NO` 는 이미지 셀이므로 TO-BE 에서는 cellTemplate(아이콘) 후보입니다. 클릭 동작(`SpdMain_CellClick`)과의 연결은 **확인 필요**입니다.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 근거 |
|---|---|---|
| Shipment Plan Confirm Detail | META+코드연결 | `AddSheet` (CreateSpread:253)에서 시트명을 하드코딩하고 `SetSheetHeaderColumn` (InitSpread:266)으로 메타를 연결 |

- 시트는 1개이며 시트 간 마스터-디테일 연결은 없습니다.

=== FILE: oracle_migration.md ===
# SSP0012 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| # | FoxQuery ID | SP | 호출 위치 | 참조 객체 | EXEC 체인 |
|---:|---|---|---|---|---|
| 1 | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | FindData_Main:418 (조회) | CREATE/SELECT `#TBLDYNAMICPIVOT_SSP0012`, REF `FN_GET_IN_STR`, REF `FN_SCM_SPLIT`, DYNAMIC SQL | EXEC:SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL → (동적 SQL `DYNAMIC@SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`) |
| 2 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | `SCM0001_GET_SCP_DAY_PERIOD` | GetDayRange:596 (Form_Load, Division 변경) | SELECT `SCM_SYS_CALENDAR_M`, SELECT `SCM_ADM_LOOKUP_MASTER_DETAIL`, REF `FN_MULTY_TIME`, REF `FN_WEEKOFDAY_DATE`, SELECT `CTE_DATE`(CTE) | EXEC:SCM0001_GET_SCP_DAY_PERIOD |

- 주석 처리됨: `SCP.GET_DATE_RANGE_1MONTH` (595행). 전환 대상에서 뺍니다.
- `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` 이 참조하는 **실 테이블**은 정적 추출 결과에 나타나지 않았습니다. 동적 SQL 안에서 참조할 가능성이 있으므로 SP 원문 확인이 필요합니다.

## 2. 공통코드 분기 (biz:CommonData.CommonDataList)

| 호출 | code | 분기 대상 | 참조 테이블 |
|---|---|---|---|
| `<field:dtFcstType>`:56 | LookupCommon | `UP_FX_GetCommonDataList` | `SCM_ADM_LOOKUP_MASTER`, `SCM_ADM_LOOKUP_MASTER_DETAIL` |
| `<field:dtBaseDay>`:57 | LookupCommon | `UP_FX_GetCommonDataList` | `SCM_ADM_LOOKUP_MASTER`, `SCM_ADM_LOOKUP_MASTER_DETAIL` |
| `SetChangedPeriod`:542 | `PERIOD_{p:value}` \|\| `PERIOD_DEFAULT` | **확인 필요** | **확인 필요** (결과 컬럼 `FROM_VALUE`, `TO_VALUE` 사용, 549~550행) |

- LookupCommon 의 lookup 그룹 코드값(dtFcstType / dtBaseDay 가 넘기는 키)은 미추출이므로 **확인 필요**입니다.

## 3. FoxQuery 미등록 / 직접 호출 SP

- 미등록(UNMATCH) 또는 직접 SQL 호출로 추출된 건은 **없습니다**. 두 FoxQuery 는 모두 `MATCH` 상태입니다.

## 4. Oracle 전환 시 확인 포인트

### 4-1. `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`
| # | 사실 | 전환 확인 포인트 |
|---:|---|---|
| 1 | `CREATE:#TBLDYNAMICPIVOT_SSP0012` 임시 테이블 생성 | MSSQL `#temp` → Oracle GTT(사전 생성) 또는 CTE/인라인 뷰로 바꿉니다. GTT 를 쓰면 세션 재사용 시 시작할 때 비우는지 확인합니다 |
| 2 | `DYNAMIC@...` 동적 SQL, 이름에 PIVOT 포함 | 동적 컬럼 생성 → Oracle `EXECUTE IMMEDIATE`/`OPEN ... FOR` + SYS_REFCURSOR. 결과 컬럼이 메타 47컬럼(`DAYS_MON`~`DAYS_SUN` 등)과 맞는지 확인합니다 |
| 3 | `REF:FN_GET_IN_STR`, `REF:FN_SCM_SPLIT` | 다중 선택 문자열(GetCheckedListValue 결과로 보임) 분해 함수 → Oracle 에 같은 함수가 있는지 확인하거나 `REGEXP_SUBSTR`/`CONNECT BY` 로 바꿉니다 |
| 4 | 입력 파라미터 | 미추출. FindData_Main 398~399행 CheckedList 값과 Period/Model/Sold To/Ship To 의 매핑은 **확인 필요**입니다 |

### 4-2. `SCM0001_GET_SCP_DAY_PERIOD`
| # | 사실 | 전환 확인 포인트 |
|---:|---|---|
| 1 | `SELECT:CTE_DATE` (CTE) | 재귀 CTE라면 Oracle 재귀 WITH 문법(컬럼 목록 필수)을 확인합니다 |
| 2 | `REF:FN_MULTY_TIME`, `REF:FN_WEEKOFDAY_DATE` | 이 함수들이 Oracle 에 있는지 확인합니다 |
| 3 | `SCM_SYS_CALENDAR_M`, `SCM_ADM_LOOKUP_MASTER_DETAIL` | Oracle 시노님/권한을 확인합니다 |
| 4 | SCP 도메인 공용 SP | 다른 화면과 공유하므로 수정할 때 영향 범위를 확인합니다 |

### 4-3. 난이도 (사실 근거)
| SP | 근거 | 평가 |
|---|---|---|
| `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | 임시 테이블 + 동적 SQL + split 함수 2종 | 이 화면에서 상대적으로 높음 |
| `SCM0001_GET_SCP_DAY_PERIOD` | CTE + 함수 2종 + 테이블 2종, 공용 | 중간. 공용 SP 라 이미 전환되었는지 확인 필요 |

## 5. DB 메타 테이블 (화면 ID 행)

| 메타 테이블 | 행 수 | 전환 대상 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 47 | Grid 컬럼 메타 |
| dbo.TB_FX_SearchCondition | 46 | 조회조건 저장값 |
| dbo.SCM_MST_TITLESET_USER | 90 | 사용자 타이틀셋(컬럼 설정 추정, **확인 필요**) |
| dbo.TB_FX_GroupMenuAuth | 16 | 그룹별 메뉴 권한 |
| dbo.TB_FX_Favorite | 12 | 즐겨찾기 |
| dbo.TB_FX_MenuItemInfo | 4 | 메뉴 |
| dbo.TB_FX_ProgramInfo | 4 | 프로그램 |
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 7 | 스크립트 백업 이력(이관 대상 여부 **확인 필요**) |

=== FILE: tobe_design.md ===
# SSP0012 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 순서(Designer 선언) | 라벨 (원문) | AS-IS 컨트롤 | TO-BE 형태 | 필수 | 기본값 / 연동 |
|---:|---|---|---|---|---|
| 1 | From Site | clbPlantSite (UsrCheckedList) | 다중 선택 콤보 | 표시 없음 | 항목 출처 **확인 필요** |
| 2 | Period* | drpPeriod (UsrDateRangePicker) | 날짜 범위(From~To) | `*` 표시 | `SCM0001_GET_SCP_DAY_PERIOD` 결과(Form_Load, Division 변경 시) |
| 3 | Model | txtItemId (UsrMultiLineEditor) + btnItemId | 여러 줄 입력 + 검색 버튼 | 표시 없음 | 버튼 결과를 `txtItemId.Text` 에 넣음 |
| 4 | Division | clbDivision (UsrCheckedList) | 다중 선택 콤보 | 표시 없음 | 변경 시 Period 재계산. 기본값 = 사용자 `NowGroupID`(dtMyDivision, 48행) 관련 여부 **확인 필요** |
| 5 | Sold To Party | txtSoldToParty (TextBox) | 텍스트 | 표시 없음 | - |
| 6 | Ship To Party | txtShipToParty (TextBox) | 텍스트 | 표시 없음 | - |
| - | (텍스트 없음) | btnColumn (UsrButton) | 버튼 | - | `BtnColumn_Click` 동작 **확인 필요** |

- 순서는 Designer 선언/라벨 줄 순서입니다. 화면상 배치 순서는 **확인 필요**입니다.
- 조회조건 영역은 `HidePanel`(접기 가능)입니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 경로 | 호출 엔드포인트 | TO-BE API 후보 |
|---|---|---|---|
| 화면 로드 | Form_Load > InitControls > GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 공용 기간 조회 API (SCM0001) |
| Division 변경 | clbDivision_SelectedIndexChanged > SetChangedControl > GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 공용 기간 조회 API 재호출 |
| 조회 (FindButton) | FindButton > FindData_Main | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | SSP0012 조회 API |
| Model 검색 버튼 | btnItemId_Click | 추출된 엔드포인트 없음 | 팝업 여부 **확인 필요** |
| 컬럼 버튼 | BtnColumn_Click | 추출된 엔드포인트 없음 | **확인 필요** |
| Grid 셀 클릭 | SpdMain_CellClick | 추출된 엔드포인트 없음 | **확인 필요** (이미지 셀 INCOTERMS / CHANGE_REQ_NO 연계 여부) |
| Grid 스크롤 | SpdMain_TopChange | 추출된 엔드포인트 없음 | **확인 필요** |
| 공통코드 | dtFcstType / dtBaseDay (필드) | `biz:CommonData.CommonDataList` [LookupCommon] | 공통코드 API. 사용처 **확인 필요** |
| 기간 기본값(미연결) | SetChangedPeriod | `biz:CommonData.CommonDataList` [PERIOD_*] | 사용 여부 **확인 필요** |

- 저장·삭제·Excel 업로드 엔드포인트는 추출되지 않았습니다. 주석 처리됨 `SCP.GET_DATE_RANGE_1MONTH` 은 대상이 아닙니다.

## 3. Division별 Grid 변형 요약

| 시트 | 표시 컬럼 수 (전 division 공통) | 숨김 | 코드 변경 |
|---|---:|---|---|
| Shipment Plan Confirm Detail | 44 | BOD_ID, ORIGIN_FROM_DIVISION_ID, PLAN_QTY | INCOTERMS, CHANGE_REQ_NO → 이미지 셀 |

- 40 / 81(_HD/_HG/_HM/_ST/_UC) / 82 / EE(_HD/_HG/_HM/_ST/_UC) 모두 같습니다. Division에 따른 변형은 **없습니다**.
- 헤더는 2행입니다(`SetSheetHeaderColumn(spdInfo, 2)`).

## 4. 권한 (C/R/U/D) 관련 사실

| 사실 | 내용 |
|---|---|
| 메뉴 권한 메타 | `TB_FX_GroupMenuAuth` 16행. 그룹별 C/R/U/D 값은 미추출이므로 **확인 필요** |
| 기능 | 조회(R) 엔드포인트만 추출됨. C/U/D 엔드포인트는 없음 |
| 사용자 정보 | `UserInfoContext.Current.NowGroupID` 를 읽음(48행) |

## 5. 미확정 사항

1. 핸들러 4종(`SpdMain_TopChange`, `SpdMain_CellClick`, `BtnColumn_Click`, `btnItemId_Click`)의 상세 동작
2. `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` 의 입력 파라미터와 결과 컬럼(동적 피벗)
3. Grid 컬럼 순서·폭·고정, 2행 헤더 상단 그룹 텍스트
4. `SetChangedPeriod` / `dtFcstType` / `dtBaseDay` 가 실제로 쓰이는지
5. `PERIOD_*` 공통코드의 분기 테이블
6. `usrButton1`(parent 없음)이 화면에 배치되는지
7. From Site / Division 콤보 항목의 데이터 출처, Division 기본 선택값
8. 권한 메타 16행의 내용
