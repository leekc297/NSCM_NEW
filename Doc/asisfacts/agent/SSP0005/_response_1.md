=== FILE: analysis.md ===
# SSP0005 — Shipment Working Day: As-is 분석

> 출처: AsisFacts 정적 추출 Fact Pack(SSP0005). 묶음에 없는 사실은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0005 |
| 클래스 | `SSP0005_ShipmentWorkingDay` |
| 도메인 | SSP (프로젝트 `GSCM.SSP.Plan.UIL`) |
| Form Text(원문) | `"Working Time"` (Designer.cs:501) |
| 메인 시트 | `Shipment Working Day` |
| current/shared/legacy 구분 | 모든 파일이 `only`(현행 단일본)입니다. shared·legacy 사본은 없습니다. |

### 1-1. 파일 구성

| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only(current) | `06.UIL\GSCM.SSP.Plan.UIL\SSP0005_ShipmentWorkingDay.cs` | `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj` | 955 |
| only(current) | `06.UIL\GSCM.SSP.Plan.UIL\SSP0005_ShipmentWorkingDay.Designer.cs` | `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj` | 545 |
| shared | 없음 | - | - |
| legacy | 없음 | - | - |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:this.Load | `Form_Load > InitControls` | 168 | `biz:CommonData.YesOrNo` | BIZ_MATCH | - |
| event:this.Load | `Form_Load > InitControls > GetDayRange` | 941 | `SCP.SCM0001_GET_SCP_PERIOD` | MATCH | SP SCM0001_GET_SCP_PERIOD |
| event:this.Load | `Form_Load > CreateSpread > InitSpread > GetSpdTitle` | 925 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:FindButton | `FindButton > FindData_Main` | 403 | `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY` | MATCH | SP SSP0005_GET_SHIPMENT_WORKING_DAY |
| button:FindButton | `FindButton > FindData_Main > InitSpread > GetSpdTitle` | 925 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | `SaveButton > SaveData_Main` | 535 | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` | MATCH | SP SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW |
| button:SaveButton | `SaveButton > SaveData_Main` | 536 | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` | MATCH | SP SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW |
| button:SaveButton | `SaveButton > SaveData_Main` | 537 | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` | MATCH | SP SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW |
| button:SaveButton | `SaveButton > SaveData_Main > FindData_Main` | 403 | `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY` | MATCH | SP SSP0005_GET_SHIPMENT_WORKING_DAY |
| button:SaveButton | `SaveButton > SaveData_Main > FindData_Main > InitSpread > GetSpdTitle` | 925 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached(진입점 미연결) | `<field:dtMyDivision>` | 45 | `biz:CommonData.CommonDataList` [code=MyDivision] | BIZ_MATCH | - |
| unreached(진입점 미연결) | `<field:dtCompany>` | 46 | `biz:CommonData.CommonDataList` [code=Company] | BIZ_MATCH | - |
| unreached(진입점 미연결) | `<field:dtDayWeek>` | 47 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | - |
| unreached(진입점 미연결) | `<field:dtYesOrNo>` | 48 | `biz:CommonData.YesOrNo` | BIZ_MATCH | - |
| unreached(진입점 미연결) | `SetChangedPeriod` | 910 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value}] | BIZ_MATCH | - |

흐름 요약(추출된 경로 기준):
- **화면 로드(`Form_Load`)**: `InitControls`에서 YesOrNo 공통코드를 콤보에 바인딩하고(168), `GetDayRange`에서 `SCP.SCM0001_GET_SCP_PERIOD`로 기간을 가져옵니다(941). 이어 `CreateSpread > InitSpread > GetSpdTitle`에서 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`으로 달력 헤더를 조회합니다(925).
- **조회(FindButton)**: `FindData_Main`이 `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY`를 호출합니다(403). 같은 경로에서 `InitSpread > GetSpdTitle`로 달력 헤더를 다시 조회합니다.
- **저장(SaveButton)**: `SaveData_Main`이 `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW`를 535·536·537 세 지점에서 참조하고, `GetChanges`(538)로 변경분을 추출합니다. 저장 후에는 `FindData_Main`으로 다시 조회합니다.
- 필드 초기화(45~48)와 `SetChangedPeriod`(910)는 정적 분석상 진입점과 연결되지 않았습니다. 실제 실행 여부는 **확인 필요**입니다.

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체(EXEC 전이 포함) / 코드분기 |
|---|---|---:|---|---|
| `biz:CommonData.CommonDataList` [code=Company] | BIZ_MATCH | 1 | - | 코드분기: `UP_FX_GetCommonDataList`: SELECT SCM_MST_COMPANY_SN / `UP_FX_GetCommonDataList_SCP_ALL`: SELECT SCM_MST_PLANT_SN, SCM_MST_COMPANY_SN |
| `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 1 | - | 코드분기: `UP_FX_GetCommonDataList`: SELECT SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.CommonDataList` [code=MyDivision] | BIZ_MATCH | 1 | - | 코드분기: `UP_FX_GetCommonDataList`: SELECT SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION |
| `biz:CommonData.CommonDataList` [code=PERIOD_{p:value}] | BIZ_MATCH | 1 | - | 확인 필요(코드분기 정보 없음) |
| `biz:CommonData.YesOrNo` | BIZ_MATCH | 2 | - | 확인 필요(참조 테이블 정보 없음) |
| `SCP.SCM0001_GET_SCP_PERIOD` | MATCH | 1 | SP SCM0001_GET_SCP_PERIOD | EXEC:SCM0001_GET_SCP_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |
| `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |
| `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY` | MATCH | 1 | SP SSP0005_GET_SHIPMENT_WORKING_DAY | EXEC:SSP0005_GET_SHIPMENT_WORKING_DAY, INSERT:#TBLDYNAMICPIVOT_SSP0005, SELECT:SSP_MST_SHIP_CALENDAR, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@SSP0005_GET_SHIPMENT_WORKING_DAY |
| `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` | MATCH | 3 | SP SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW | EXEC:SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, UPDATE:SSP_MST_SHIP_CALENDAR, INSERT:SCM_SYS_LOG_BATCH |

### 3-1. 주석 처리된 호출(현행 기능 아님)

| 줄 | 값 | 비고 |
|---:|---|---|
| 569 | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY` | 주석 처리됨 |
| 940 | `SCP.GET_DATE_RANGE_1MONTH` | 주석 처리됨 |

## 4. 이벤트 배선

| 대상 | 이벤트 | 핸들러 | 연결 위치 | 연산 |
|---|---|---|---|---|
| this | Load | `Form_Load` | .ctor:123 | += |
| spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:311 | += |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:312 | += |
| cboDayWeek | SelectedIndexChanged | `CboDayWeek_SelectedIndexChanged` | InitEvent:314 | += |
| btnInput | Click | `BtnInput_Click` | InitEvent:316 | += |
| dsdm | Changed | `SpdMain_Changed` | BtnInput_Click:725 | -= |
| dsdm | Changed | `SpdMain_Changed` | BtnInput_Click:821 | += |
| dsdm | Changed | `SpdMain_Changed` | SpdMain_Changed:878 | -= |
| dsdm | Changed | `SpdMain_Changed` | SpdMain_Changed:902 | += |

핸들러별 추출 사실:
- **`Form_Load`**: `InitControls`(YesOrNo 바인딩, `GetDayRange`)를 실행하고, `CreateSpread > InitSpread`로 Grid를 생성합니다.
- **`SpdMain_CellDoubleClick`**: 컬럼 헤더(`e.ColumnHeader`)를 더블클릭하면 컬럼 Tag 접두어에 따라 컬럼 Visible을 반전합니다.
  - `M_` 헤더: `W_` 컬럼을 반전하고(840), 보이는 `D_` 컬럼을 반전합니다(843).
  - `W_` 헤더: `D_` 컬럼을 반전합니다(854).
- **`SpdMain_TopChange`**: 배선만 확인되었습니다. 내부 동작은 **확인 필요**입니다.
- **`CboDayWeek_SelectedIndexChanged`**: `GetCheckedListValue`(660)를 호출한 뒤 `cboInputValue.Enabled`를 false(663) 또는 true(666)로 설정합니다. 분기 조건은 **확인 필요**입니다.
- **`BtnInput_Click`**: `GetCheckedListValue`(682)를 호출합니다. `dsdm.Changed -= SpdMain_Changed`(725) 후 처리하고 `+=`(821)로 다시 연결합니다. 일괄 입력 중 Changed 이벤트를 억제하는 구조입니다. 입력값 기록 방식은 **확인 필요**입니다.
- **`SpdMain_Changed`**: 내부에서 자기 자신을 `-=`(878) / `+=`(902)로 해제·재연결해 재귀 발생을 막습니다. 878과 902 사이의 처리 내용은 **확인 필요**입니다.

## 5. Grid 구성 방식

구성 방식: **`HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)`**

1. **시트 생성(코드)**: `CreateSpread:179` `AddSheet(spdMain, SpdSheet.shtMain = "Shipment Working Day", …, 3, 1, 35)`. 인자 3·1·35의 의미는 **확인 필요**입니다.
2. **메타 컬럼(프레임워크)**: `InitSpread:196` `SetSheetHeaderColumn(spdInfo, 3)`가 `SCM_MST_SHEET_COLUMNS` 메타로 고정 컬럼을 만듭니다. 메타 행은 2건(`COMPANY_ID` "Company", `DIVISION_ID` "Divison")입니다.
3. **날짜 컬럼(DB 루프)**: `InitSpread:198`이 로컬 메서드 `InitSpreadDateColumn(spdInfo, GetColumnIndex(DIVISION)+1)`을 호출합니다.
   - `dsSpdTitle.Tables[0].Rows`(SCP0009 결과)를 순회합니다. `sColumnName.IndexOf("B_") > 0`이 아니면 `AddComboColumn(COLUMN_LABEL_NAME, COLUMN_NAME, None, 70, true, YesOrNo, Center, Center)`(263)로 컬럼을 추가합니다.
   - `DAY_CODE`가 SAT 또는 SUN이면 ForeColor를 지정합니다. SAT = Blue, 그 외(SUN) = Red입니다(267).
   - 헤더 병합: row 0은 `LARGE_CLASS_LABEL_NAME`, row 1은 `SMALL_CLASS_LABEL_NAME`으로 `ColumnHeaderSpan`(274·280·290·301·303)을 적용하며 높이는 20입니다.
4. **표시 변경(코드)**: 헤더 더블클릭으로 `M_`/`W_`/`D_` 컬럼을 접고 펼칩니다(840·843·854).
5. Designer.cs 467~470: HorizontalAlignment General, NoteIndicatorColor Red, Parent `ColumnHeaderDefaultEnhanced`, VerticalAlignment General.

### 5-1. Division별 차이

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Working Day | META+코드연결 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 |

- 메타 컬럼 수는 모든 division에서 같습니다(필수+기본 2 / 선택 0). division 분기 코드는 추출되지 않았습니다(분기 판단불가 0건).
- 날짜 컬럼 수는 SCP0009 실행 결과에 따라 정해지므로 정적 집계에 포함되지 않습니다. 실제 SP 결과와 매칭되는 시트가 없다고 보고되었으므로 실행 확인이 필요합니다.

## 6. 확인 필요 항목

| # | 항목 | 근거 |
|---:|---|---|
| 1 | `SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` 3회 참조(535·536·537)의 역할 구분(예: 행 상태별 명령 여부) | site_kind=prop, 상세 미추출 |
| 2 | 필드 초기화(45~48)와 `SetChangedPeriod`(910)의 실제 실행 경로 | unreached 판정 |
| 3 | `GetSpdTitle`이 화면 로컬 메서드(925)인지, 프레임워크 `SpreadInfo.GetSpdTitle`(InitSpread:190)인지의 관계 | Fact Pack 4-2와 flow가 서로 다르게 표기됨 |
| 4 | `SpdMain_TopChange` 내부 동작 | 배선만 추출됨 |
| 5 | `CboDayWeek_SelectedIndexChanged`의 Enabled 분기 조건 | 663/666 값만 추출됨 |
| 6 | `SaveData_Main`의 `dr["A"]`(502)·`row["A"]`(527) 컬럼 "A"의 의미 | meta_reads |
| 7 | `usrButton1`(parent 없음, 75×23)의 용도와 표시 여부 | controls/props |
| 8 | `SetChangedPeriod`가 읽는 `PERIOD_{p:value}` 코드의 실제 값(FROM_VALUE/TO_VALUE) | endpoint 910, meta_reads 916·917 |
| 9 | 메타 라벨 "Divison"(철자 원문) 표시 여부 | grid_effective |
| 10 | `EditButton`(352)의 동작(`GetSheetInfo` 외) | grid_code |

=== FILE: source_links.md ===
# SSP0005 — 소스 링크 표

기준 경로:
- `CS` = `06.UIL\GSCM.SSP.Plan.UIL\SSP0005_ShipmentWorkingDay.cs`
- `DS` = `06.UIL\GSCM.SSP.Plan.UIL\SSP0005_ShipmentWorkingDay.Designer.cs`

## 1. 엔드포인트 호출 지점 (전수 12건 + 주석 2건)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `<field:dtMyDivision>` | 45 | `biz:CommonData.CommonDataList` [code=MyDivision] (`UserInfoContext.Current.NowGroupID` 사용) |
| CS | `<field:dtCompany>` | 46 | `biz:CommonData.CommonDataList` [code=Company] |
| CS | `<field:dtDayWeek>` | 47 | `biz:CommonData.CommonDataList` [code=LookupCommon] |
| CS | `<field:dtYesOrNo>` | 48 | `biz:CommonData.YesOrNo` |
| CS | `InitControls` | 168 | `biz:CommonData.YesOrNo` (`UsrComboBox.DataBind`) |
| CS | `FindData_Main` | 403 | `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY` |
| CS | `SaveData_Main` | 535 | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` |
| CS | `SaveData_Main` | 536 | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` |
| CS | `SaveData_Main` | 537 | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` |
| CS | `SetChangedPeriod` | 910 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value}] |
| CS | `GetSpdTitle` | 925 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| CS | `GetDayRange` | 941 | `SCP.SCM0001_GET_SCP_PERIOD` |
| CS | (주석) | 569 | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY` — 주석 처리됨 |
| CS | (주석) | 940 | `SCP.GET_DATE_RANGE_1MONTH` — 주석 처리됨 |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `.ctor` | 123 | `this.Load += Form_Load` |
| CS | `InitEvent` | 311 | `spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| CS | `InitEvent` | 312 | `spdMain.TopChange += SpdMain_TopChange` |
| CS | `InitEvent` | 314 | `cboDayWeek.SelectedIndexChanged += CboDayWeek_SelectedIndexChanged` |
| CS | `InitEvent` | 316 | `btnInput.Click += BtnInput_Click` |
| CS | `BtnInput_Click` | 725 | `dsdm.Changed -= SpdMain_Changed` |
| CS | `BtnInput_Click` | 821 | `dsdm.Changed += SpdMain_Changed` |
| CS | `SpdMain_Changed` | 878 | `dsdm.Changed -= SpdMain_Changed` |
| CS | `SpdMain_Changed` | 902 | `dsdm.Changed += SpdMain_Changed` |

## 3. Grid 구성 / 메타 소비

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `CreateSpread` | 179 | `AddSheet` — `Shipment Working Day` (args 3 ¦ 1 ¦ 35) |
| CS | `CreateSpread` | 180 | `GetSheetInfo(spdMain.Name, 0)` |
| CS | `CreateSpread` | 182 | `ChangeSheet` |
| CS | `InitSpread` | 190 | `GetSpdTitle` (프레임워크 `SpreadInfo.GetSpdTitle`: COLUMN_NAME, SORT_ORDER_NO) |
| CS | `InitSpread` | 194 | `InitSheet` — `if(spdInfo.SheetName == "Shipment Working Day")` |
| CS | `InitSpread` | 196 | `SetSheetHeaderColumn(spdInfo, 3)` |
| CS | `InitSpread` | 198 | `InitSpreadDateColumn(spdInfo, nIdxDataMain)` |
| CS | `InitSpreadDateColumn` | 263 | `AddComboColumn` (DB 루프, 폭 70, YesOrNo, Center/Center) |
| CS | `InitSpreadDateColumn` | 267 | ForeColor: SAT=Blue, 그 외(SUN)=Red |
| CS | `InitSpreadDateColumn` | 274 / 303 | `ColumnHeaderSpan` row 0 (LARGE_CLASS_LABEL_NAME) |
| CS | `InitSpreadDateColumn` | 280 / 290 / 301 | `ColumnHeaderSpan` row 1 (SMALL_CLASS_LABEL_NAME) |
| CS | `EditButton` | 352 | `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)` |
| CS | `SpdMain_CellDoubleClick` | 840 | `M_` 헤더 → `W_` 컬럼 Visible 반전 |
| CS | `SpdMain_CellDoubleClick` | 843 | `M_` 헤더 → 보이는 `D_` 컬럼 Visible 반전 |
| CS | `SpdMain_CellDoubleClick` | 854 | `W_` 헤더 → `D_` 컬럼 Visible 반전 |
| DS | `InitializeComponent` | 467~470 | 헤더 스타일(HAlign General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced, VAlign General) |

## 4. 기타 로직 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `FindData_Main` | 387, 388 | `CString.GetCheckedListValue` (CODE) |
| CS | `SaveData_Main` | 502 | `dr["A"]` |
| CS | `SaveData_Main` | 527 | `row["A"]` |
| CS | `SaveData_Main` | 538 | `FPExtensions.GetChanges` (ROW_ID) |
| CS | `CboDayWeek_SelectedIndexChanged` | 660 | `GetCheckedListValue` |
| CS | `CboDayWeek_SelectedIndexChanged` | 663 / 666 | `cboInputValue.Enabled = false / true` |
| CS | `BtnInput_Click` | 682 | `GetCheckedListValue` |
| CS | `GetDayOfWeek` | 827 / 828 | `row.Field("COLUMN_NAME")` / `dr["DAY_CODE"]` |
| CS | `SetChangedPeriod` | 916 / 917 | `dt.Rows[0]["FROM_VALUE"]` / `["TO_VALUE"]` |
| DS | `InitializeComponent` | 501 | `this.Text = "Working Time"` |

=== FILE: web_components.md ===
# SSP0005 — React / Wijmo 컴포넌트 매핑

## 1. 컨트롤 → 컴포넌트 매핑

| As-is 컨트롤 | 유형 | 라벨(원문) | 라벨 출처 | Size | TO-BE 후보 |
|---|---|---|---|---|---|
| `cboCompany` | UsrCombo | `Company` | layoutControlItem4.Text (437) | 198×20 | 단일 선택 콤보(Wijmo ComboBox 계열) |
| `clbDivision` | UsrCheckedList | `Division` | lcDivision.Text (403) | 199×21 | 다중 선택(Wijmo MultiSelect 계열) |
| `drpPeriod` | UsrDateRangePicker | `Period*` | layoutControlItem6.Text (391) | 206×20 | 기간(From~To) 날짜 범위 입력 — 필수 표시 `*` |
| `cboDayWeek` | UsrCombo | `Day of the week` | layoutControlItem1.Text (365) | 155×20 | 콤보. 다중 여부는 확인 필요(`GetCheckedListValue` 사용: 660·682) |
| `cboInputValue` | UsrComboBox | `Input Value` | lcInputValue.Text (415) | 174×20 | 콤보(YesOrNo 바인딩: InitControls:168), Enabled 동적 제어 |
| `btnInput` | UsrButton | `Input` | btnInput.Text (164) | 77×21 | 버튼(일괄 입력) |
| `usrButton1` | UsrButton | 확인 필요(Text 미추출) | - | 75×23 | parent 없음, 용도 확인 필요 |
| `spdMain` / `spdMain_Sheet1` | FpSpread / SheetView | 시트 `Shipment Working Day` | grid_code AddSheet(179) | 1192×584 | Wijmo FlexGrid(3단 헤더 병합, 셀 콤보) |
| `usrConditionPanel1` | UsrConditionPanel | - | - | 1192×65 | 조회조건 영역(PanelType.HidePanel) |
| `usrLayoutControl2` / `layoutControlGroup2` | 레이아웃 | - | - | 1192×65 / 1192×70 | 조회조건 레이아웃 |
| `emptySpaceItem1/2` | EmptySpaceItem | - | - | 170×25 / 417×50 | 여백 |
| (Form) | - | `Working Time` | this.Text (501) | - | 화면 타이틀 원문 |

조회/저장 버튼(FindButton, SaveButton)은 프레임워크 공통 버튼 진입점으로만 추출되었습니다.

## 2. 화면 배치

- props.csv에 **SplitContainer가 없습니다**. Orientation과 SplitterDistance는 해당 사항 없음입니다.
- 상/하 2단 구성입니다.
  - 상단: `usrConditionPanel1` (Dock=Top, 1192×65)
  - 하단: `spdMain` (Dock=Fill, 1192×584)
- Designer 기준 높이 비율은 상단 65 : 하단 584 = 약 **10% : 90%**입니다. 하단은 Fill이므로 실제 높이는 창 크기에 따라 달라집니다.
- 조회조건 행의 LayoutItem 폭은 Company 257, Day of the week 257, Input 81, Period* 251, Division 247, Input Value 247입니다. 행·열 배치 좌표는 확인 필요입니다.

## 3. 시트별 Grid 컬럼 — `Shipment Working Day`

### 3-1. 메타 컬럼 (grid_effective 기준, SCM_MST_SHEET_COLUMNS)

| 컬럼 | 라벨(원문) | 출처 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| COMPANY_ID | Company | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |
| DIVISION_ID | Divison | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |

- 메타 컬럼 속성은 `SetSheetHeaderColumn`이 읽는 COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, FIXED_FLAG 등에서 가져옵니다. 구체적인 값은 Fact Pack에 없어 확인 필요입니다.
- 라벨 `Divison`은 메타 원문의 철자 그대로입니다.

### 3-2. 코드 생성 날짜 컬럼 (DB 루프 — `InitSpreadDateColumn`)

| 항목 | 값 |
|---|---|
| 데이터 원천 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과 행(dsSpdTitle) |
| 시작 위치 | DIVISION 컬럼 인덱스 + 1 |
| 헤더 / 필드 | `COLUMN_LABEL_NAME` / `COLUMN_NAME` |
| 셀 타입 | Combo(데이터 `Data.Common(YesOrNo)`) |
| 폭 / 정렬 | 70 / 가로 Center, 세로 Center |
| 생성 제외 조건 | `sColumnName.IndexOf("B_") > 0`이면 AddComboColumn 분기를 타지 않음(else 분기만 생성). B_ 분기 내용은 확인 필요 |
| 색상 | DAY_CODE = SAT → Blue, SUN → Red (ForeColor) |
| 헤더 행 | 3단(SetSheetHeaderColumn 인자 3). row 0 = LARGE_CLASS_LABEL_NAME 병합, row 1 = SMALL_CLASS_LABEL_NAME 병합, 높이 20 |
| 접기/펼치기 | 헤더 더블클릭. `M_` → `W_`·`D_` 반전, `W_` → `D_` 반전 |

### 3-3. Division별 표시 차이

모든 division의 최종 표시 컬럼 수는 2입니다(메타). division 분기 코드는 없습니다. 날짜 컬럼 수는 런타임 결과에 따라 정해지며 미집계입니다.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 설명 |
|---|---|---|
| Shipment Working Day | META+코드연결 | 메타 시트를 코드가 `AddSheet`(179)·`InitSheet`(194)로 사용하고, 메타 컬럼 뒤에 DB 루프 날짜 컬럼을 덧붙입니다 |

=== FILE: oracle_migration.md ===
# SSP0005 — Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | FoxQuery 키 | 호출 위치 | 참조 객체 / EXEC 체인 |
|---|---|---|---|
| `SSP0005_GET_SHIPMENT_WORKING_DAY` | SSP.SSP0005_GET_SHIPMENT_WORKING_DAY | FindData_Main:403 | INSERT `#TBLDYNAMICPIVOT_SSP0005`, SELECT `SSP_MST_SHIP_CALENDAR`, REF `STRING_SPLIT`, SELECT `SCM_SYS_CALENDAR_M`, DYNAMIC SQL(`DYNAMIC@SSP0005_GET_SHIPMENT_WORKING_DAY`) |
| `SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` | SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW | SaveData_Main:535·536·537 | UPDATE `SSP_MST_SHIP_CALENDAR`, EXEC `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`, INSERT `SCM_SYS_LOG_BATCH` |
| `SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | GetSpdTitle:925 | SELECT `SCM_SYS_CALENDAR_M` |
| `SCM0001_GET_SCP_PERIOD` | SCP.SCM0001_GET_SCP_PERIOD | GetDayRange:941 | REF `FN_MULTY_TIME`, REF `FN_WEEKOFDAY_DATE`, SELECT `SCM_SYS_CALENDAR_M`, SELECT `SCM_ADM_LOOKUP_MASTER_DETAIL`, SELECT `CTE_DATE`(CTE) |

EXEC 체인:
- `SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` → `PR_SCM_SYS_LOG_BATCH_CALL_TRAN` (→ INSERT `SCM_SYS_LOG_BATCH`)
- 나머지 3개 SP는 추가 EXEC 체인이 추출되지 않았습니다.

주석 처리됨(전환 대상 아님): `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY`(569), `SCP.GET_DATE_RANGE_1MONTH`(940).

## 2. 공통코드 분기 (CommonData)

| 엔드포인트 | code | 분기 SP | 테이블 |
|---|---|---|---|
| biz:CommonData.CommonDataList | Company | UP_FX_GetCommonDataList | SCM_MST_COMPANY_SN |
| biz:CommonData.CommonDataList | Company | UP_FX_GetCommonDataList_SCP_ALL | SCM_MST_PLANT_SN, SCM_MST_COMPANY_SN |
| biz:CommonData.CommonDataList | LookupCommon | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList | MyDivision | UP_FX_GetCommonDataList | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList | PERIOD_{p:value} | 확인 필요 | 확인 필요 (FROM_VALUE/TO_VALUE 반환) |
| biz:CommonData.YesOrNo | - | 확인 필요 (`Data.CallBizData`) | 확인 필요 |

## 3. FoxQuery 미등록 / 직접 호출 SP

- 활성 엔드포인트 4개는 모두 `MATCH`(FoxQuery 등록 확인)입니다. 미등록 또는 직접 호출 SP는 추출되지 않았습니다.
- 확인 필요 항목은 0건입니다.

## 4. Oracle 전환 확인 포인트 (추출 사실 근거)

| # | SP | 사실 | 전환 확인 포인트 |
|---:|---|---|---|
| 1 | SSP0005_GET_SHIPMENT_WORKING_DAY | REF `STRING_SPLIT` | MSSQL 전용 함수(금지 키워드)입니다. Oracle 문자열 분리 방식으로 대체해야 합니다 |
| 2 | SSP0005_GET_SHIPMENT_WORKING_DAY | INSERT `#TBLDYNAMICPIVOT_SSP0005` | MSSQL 로컬 임시테이블입니다. Oracle에서는 GTT 등으로 대체하고, 세션 시작 시 비우기를 검토해야 합니다 |
| 3 | SSP0005_GET_SHIPMENT_WORKING_DAY | DYNAMIC SQL + 테이블명 `PIVOT` | 동적 피벗으로 컬럼 수가 가변입니다. 결과 컬럼명은 SCP0009 헤더의 `COLUMN_NAME`과 일치해야 합니다(Grid 필드 바인딩). 동적 SQL 원문은 확인 필요입니다 |
| 4 | SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW | UPDATE `SSP_MST_SHIP_CALENDAR` + 로그 SP EXEC | 트랜잭션 처리(`..._CALL_TRAN`)의 Oracle 대응과 커밋 경계를 확인해야 합니다 |
| 5 | SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW | 화면 3회 참조(535~537) | 행 단위 호출 횟수와 파라미터를 확인해야 합니다(확인 필요) |
| 6 | SCM0001_GET_SCP_PERIOD | REF `FN_MULTY_TIME`, `FN_WEEKOFDAY_DATE` | 사용자 함수의 Oracle 존재 여부와 시그니처를 확인해야 합니다 |
| 7 | SCM0001_GET_SCP_PERIOD | `CTE_DATE` | CTE(재귀 여부 확인 필요)를 Oracle `WITH`로 전환해야 합니다 |
| 8 | SCP0009_GET_SHEET_CALENDAR_3SPAN | SELECT `SCM_SYS_CALENDAR_M` | 단일 테이블 조회입니다. 반환 컬럼(COLUMN_NAME, COLUMN_LABEL_NAME, DAY_CODE, LARGE/SMALL_CLASS_LABEL_NAME)을 유지해야 합니다 |

### 난이도 (사실 기반)

| SP | 근거 | 난이도 |
|---|---|---|
| SSP0005_GET_SHIPMENT_WORKING_DAY | STRING_SPLIT + #임시테이블 + 동적 피벗 | 높음 |
| SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW | UPDATE + 로그 SP EXEC 체인 | 중간 |
| SCM0001_GET_SCP_PERIOD | 사용자 함수 2종 + CTE | 중간 |
| SCP0009_GET_SHEET_CALENDAR_3SPAN | 단일 테이블 SELECT | 낮음 |

=== FILE: tobe_design.md ===
# SSP0005 — TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 라벨(원문) | 컨트롤 | 데이터 원천 | 비고 |
|---|---|---|---|
| Company | cboCompany | `biz:CommonData.CommonDataList` [code=Company] (필드 dtCompany:46) | 바인딩 지점은 unreached 판정이므로 확인 필요 |
| Division | clbDivision | `biz:CommonData.CommonDataList` [code=MyDivision] (dtMyDivision:45, NowGroupID 기준) | 다중 선택. FindData_Main:387·388 `GetCheckedListValue` |
| Period* | drpPeriod | `SCP.SCM0001_GET_SCP_PERIOD` (GetDayRange:941) 초기값 | 필수 표시 `*` |
| Day of the week | cboDayWeek | `biz:CommonData.CommonDataList` [code=LookupCommon] (dtDayWeek:47) | 변경 시 cboInputValue Enabled 제어 |
| Input Value | cboInputValue | `biz:CommonData.YesOrNo` (InitControls:168) | 일괄 입력용 값 |

조회 파라미터 구성(FindData_Main 387·388의 값 매핑)은 확인 필요입니다. `TB_FX_SearchCondition` 메타에 19행이 존재합니다.

## 2. 액션별 호출 API 후보

| 액션 | As-is 진입점 | 호출 엔드포인트 | TO-BE API 후보 |
|---|---|---|---|
| 화면 로드 | Form_Load | biz:CommonData.YesOrNo, SCP.SCM0001_GET_SCP_PERIOD, SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 공통코드 API + 기간 조회 API + 달력 헤더 조회 API |
| 조회 | FindButton → FindData_Main | SSP.SSP0005_GET_SHIPMENT_WORKING_DAY, SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 헤더(달력) 조회 → 데이터 조회 |
| 저장 | SaveButton → SaveData_Main | SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW (변경분 GetChanges) → 재조회 | 변경 행 저장 API → 재조회 |
| 일괄 입력 | BtnInput_Click | 서버 호출 추출 없음 | 클라이언트 처리. Changed 이벤트 억제 후 일괄 반영 |
| 요일 변경 | CboDayWeek_SelectedIndexChanged | 서버 호출 추출 없음 | Input Value 활성/비활성 처리 |
| 헤더 더블클릭 | SpdMain_CellDoubleClick | 없음 | 월(M_)·주(W_)·일(D_) 컬럼 접기/펼치기 |
| 셀 변경 | SpdMain_Changed | 없음 | 변경 처리(내용 확인 필요) |
| 스크롤 | SpdMain_TopChange | 없음 | 확인 필요 |

## 3. Division별 Grid 변형 요약

- 시트 `Shipment Working Day`의 메타 컬럼은 COMPANY_ID, DIVISION_ID 2개입니다. 14개 division 모두 같습니다(기본 2).
- 날짜 컬럼은 SCP0009 결과로 동적 생성됩니다(Combo YesOrNo, 폭 70, SAT 파랑/SUN 빨강, 3단 헤더). division 분기는 없습니다.

## 4. 권한(C/R/U/D) 관련 사실

| 메타 테이블 | 행 수 |
|---|---:|
| TB_FX_GroupMenuAuth | 13 |
| TB_FX_MenuItemInfo | 1 |
| TB_FX_ProgramInfo | 1 |
| TB_FX_Favorite | 5 |

- 그룹별 C/R/U/D 플래그 값은 Fact Pack에 없어 확인 필요입니다(`dbmeta_dbo_TB_FX_GroupMenuAuth.csv` 참조).
- 화면 코드에서 확인된 기능은 조회(FindButton)와 저장(SaveButton)입니다. 신규/삭제 진입점은 추출되지 않았습니다. `EditButton`(352)은 `GetSheetInfo`만 추출되었습니다.

## 5. 미확정 사항

1. `SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` 3회 참조(535~537)의 구분과 저장 파라미터
2. `SaveData_Main`의 컬럼 `A`(502·527) 의미
3. `BtnInput_Click`의 일괄 입력 대상(요일·기간·Division 조합)과 반영 방식
4. `CboDayWeek_SelectedIndexChanged`의 Enabled 분기 조건
5. `SpdMain_TopChange`, `SpdMain_Changed` 내부 처리
6. `SetChangedPeriod`(PERIOD_ 코드)와 필드 초기화(45~48)의 실제 호출 경로
7. `B_` 컬럼 처리 분기와 AddSheet 인자(3, 1, 35)의 의미
8. `usrButton1`의 용도
9. 메타 라벨 `Divison` 철자의 TO-BE 처리 여부
10. 주석 처리된 `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY`, `SCP.GET_DATE_RANGE_1MONTH`는 현행 기능이 아니므로 설계에서 제외합니다
