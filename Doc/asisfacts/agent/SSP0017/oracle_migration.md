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
