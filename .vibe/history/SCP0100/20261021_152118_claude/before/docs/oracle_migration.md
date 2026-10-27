# SCP0100 Oracle 전환 포인트

## 1. 호출 SP 인벤토리

| SP | FoxQuery 키 | 호출 위치 | 참조 객체 | EXEC 체인 |
|---|---|---|---|---|
| `SCP0100_GET_SHEET_CALENDAR_3SPAN` | SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN (MATCH) | GetSpdTitle:1326 | SELECT SCM_SYS_CALENDAR_M | 자기 자신만 |
| `SCP0100_GET_SITE` | SCP.SCP0100_GET_SITE (MATCH) | GetSiteList:1342 | SELECT SCP_RPT_GLOBAL_PSI_MD_MM, SCP_RPT_GLOBAL_PSI_MD_WW / REF FN_SPLITSTRING | 자기 자신만 |
| `SCP0100_GET_PLAN_DATE` | SCP.SCP0100_GET_PLAN_DATE (MATCH) | GetPlanDate:1365 | INSERT/SELECT #TMP_PLAN / SELECT SCP_PLAN_VERSION_V, SCM_SYS_CALENDAR_M, SCP_PLN_INTERFACE_YN, SCP_RPT_GLOBAL_PSI_MD_MM, SCP_RPT_GLOBAL_PSI_MD_WW / REF FN_CHAR_TO_DATE, FN_SPLITSTRING | 자기 자신만 |

- 세 SP 모두 다른 SP를 EXEC로 호출하는 체인은 추출되지 않았습니다.

## 2. 공통코드 분기

| 호출 | code | 테이블 |
|---|---|---|
| biz:CommonData.CommonDataList_REPORT (GetPlanEndDate:2035) | `Data_REPORT.Type.PLAN_END_DATE` | **확인 필요** (Biz 내부 SQL 미추출) |

## 3. FoxQuery 미등록 / 직접 호출 SP

- FoxQuery 미등록(UNMATCH) 엔드포인트는 **0건**입니다. 3개 SP는 모두 MATCH입니다.
- 직접 SQL 호출은 추출되지 않았습니다. Biz 경유 1건(BIZ_MATCH)이 있습니다.
- 확인 필요 0건, 주석 처리된 호출 0건입니다.
- **메인 데이터 조회 SP가 추출되지 않았습니다.** Report 본문과 차트 데이터의 원천이 Fact Pack에 없습니다. 전환 범위를 확정하려면 원천을 먼저 확인해야 합니다.

## 4. Oracle 전환 시 확인 포인트

| # | 대상 | 포인트 (사실 근거) |
|---:|---|---|
| 1 | SCP0100_GET_PLAN_DATE | `#TMP_PLAN` 임시테이블에 INSERT 후 SELECT합니다. Oracle에서는 GTT DDL을 만들거나 CTE/WITH로 바꿔야 합니다. GTT라면 호출 단위 초기화가 필요합니다. |
| 2 | SCP0100_GET_PLAN_DATE, SCP0100_GET_SITE | `FN_SPLITSTRING`을 참조합니다. 멀티선택 문자열 분해 함수를 Oracle에서 어떻게 대체하거나 이관할지 확인해야 합니다. 화면의 getFromSite / getToSite / getPlanType / getDivision이 멀티선택 CODE를 넘깁니다. |
| 3 | SCP0100_GET_PLAN_DATE | `FN_CHAR_TO_DATE`를 참조합니다. 문자→날짜 변환 함수의 Oracle 존재 여부와 포맷을 확인해야 합니다. |
| 4 | SCP0100_GET_PLAN_DATE | 뷰 `SCP_PLAN_VERSION_V`가 Oracle에 있는지 확인해야 합니다. |
| 5 | SCP0100_GET_SITE, SCP0100_GET_PLAN_DATE | 결과 테이블 `SCP_RPT_GLOBAL_PSI_MD_MM`(월)과 `_WW`(주) 2종을 조회합니다. 화면의 Bucket(MONTHLY/WEEKLY) 구분과 연관되는지 확인이 필요합니다. |
| 6 | SCP0100_GET_SHEET_CALENDAR_3SPAN | SCM_SYS_CALENDAR_M 기반으로 동적 헤더 행을 반환합니다. 화면이 소비하는 결과 컬럼 계약은 다음과 같습니다: COLUMN_NAME, COLUMN_LABEL_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME, SORT_ORDER_NO. 또 컬럼명 접두 규칙(`M_`, `W_`, `B_` 포함)을 그대로 유지해야 합니다. |
| 7 | 공통 | MSSQL 고유 구문(날짜 함수, TOP, ISNULL 등)이 있는지는 SP 원문을 봐야 판단할 수 있습니다. Fact Pack에는 원문이 없어 **확인 필요**입니다. |

## 5. 난이도 (사실 근거만)

- SP 3개, EXEC 체인 없음, 참조 테이블은 6종(뷰 1 포함)입니다. 함수 2종과 임시테이블 1종이 있습니다.
- 임시테이블과 사용자 함수 의존은 GET_PLAN_DATE에 몰려 있습니다. 세 SP 중 상대적으로 전환 항목이 가장 많습니다.
- 메인 조회 SP가 미식별이라 **전체 난이도는 판정할 수 없습니다(확인 필요)**.
