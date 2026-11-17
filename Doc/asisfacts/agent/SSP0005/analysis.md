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
