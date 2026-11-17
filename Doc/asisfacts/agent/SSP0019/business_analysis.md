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
