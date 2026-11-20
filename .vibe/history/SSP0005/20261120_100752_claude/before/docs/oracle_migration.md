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
