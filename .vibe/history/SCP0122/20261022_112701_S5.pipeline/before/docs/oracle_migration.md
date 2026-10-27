# SCP0122 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 엔드포인트 | 용도 | 참조 객체 | EXEC 체인 |
|---|---|---|---|---|
| `SCP0121_GET_SEARCH_INFO` | SCP.SCP0121_GET_SEARCH_INFO | 조회조건 정보 (GetPlanGroupByUserID) | 임시테이블 #DIVISION_INFO, #LINE_MASTER, #OSP_PLANT_INFO (INSERT/SELECT); SCM_MST_DIVISION, SCM_MST_LINE_SN, SCM_MST_FACTORY_SN, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_LINE_OSP, SCM_MST_SITE, SCM_MST_VENDOR, SCP_MST_CAPA_LINE, SCP_OPMZ_PLAN_GR_M, SCM_ADM_LOOKUP_MASTER, SCM_OPERATION_M_SN (SELECT) | 없음 |
| `SCP0122_GET_PLAN_ACTIVITY_MGMT` | SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT | 메인 조회 | SCP_OPMZ_PLAN_GR_ACTV_M, SCP_OPMZ_PLAN_GR_M, SCM_ADM_LOOKUP_MASTER_DETAIL (SELECT) | 없음 |
| `SCP0122_SAVE_PLAN_ACTIVITY_MGMT` | SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT | 저장 | SCP_OPMZ_PLAN_GR_ACTV_M (INSERT/UPDATE/DELETE), SCM_SYS_LOG_BATCH (INSERT), SCP_OPMZ_PLAN_GR_ACTV_H (INSERT); REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | → `PR_SCM_SYS_LOG_BATCH`, → `SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST` |

> `SCP0121_GET_SEARCH_INFO`는 SCP0121 화면 소유의 SP를 공유 호출한 것입니다. 이 화면 전용 SP가 아니므로 공용 처리 여부를 결정해야 합니다.

## 2. 공통코드 분기

| 호출 | code | 처리 SP | 테이블 |
|---|---|---|---|
| `biz:CommonData.CommonDataList` (`dtProcessCdAll`, 47행) | LookupCommon | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |

- LOOKUP 그룹 코드값(어떤 LOOKUP_TYPE을 조회하는지)은 Fact Pack에 없어 **확인 필요**입니다.

## 3. FoxQuery 미등록 / 직접 호출 SP

- FoxQuery 미등록: **없음** (3개 SP 엔드포인트 모두 MATCH)
- 직접 SQL/직접 SP 호출: **없음**
- 주석 처리된 호출: **0건**
- 진입점 미연결 2건 (GetPlanGroupByUserID → SCP0121_GET_SEARCH_INFO, dtProcessCdAll → CommonDataList)은 정적 미추적일 뿐 활성 코드입니다. 호출 시점은 **확인 필요**입니다.

## 4. Oracle 전환 확인 포인트

| # | 대상 | 사실 | 확인 포인트 |
|---:|---|---|---|
| 1 | SCP0121_GET_SEARCH_INFO | `#DIVISION_INFO`, `#LINE_MASTER`, `#OSP_PLANT_INFO` 임시테이블 3개를 INSERT 후 SELECT | Oracle GTT DDL을 직접 준비하거나 WITH/서브쿼리로 바꿀지 결정. 기존 TO-BE에 이미 이관된 SP가 있는지 먼저 확인 |
| 2 | SCP0122_SAVE_PLAN_ACTIVITY_MGMT | `SCM_ARR_SPL_CNT`, `SCM_ARR_SPL_VAL` 참조 (구분자 문자열 분해 함수로 보임) | Oracle 대응 함수의 존재 여부와 FE 전송 페이로드 형식(구분자 문자열인지 JSON인지) 확인 |
| 3 | SCP0122_SAVE_PLAN_ACTIVITY_MGMT | INSERT/UPDATE/DELETE를 하나의 SP에서 처리 | 행 상태(I/U/D) 플래그 전달 방식 확인 |
| 4 | SCP0122_SAVE_PLAN_ACTIVITY_MGMT | `SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST` EXEC → `SCP_OPMZ_PLAN_GR_ACTV_H` INSERT | 이력 SP를 PKG 내부 프로시저로 넣을지, Oracle에서 `_H` 테이블 존재 여부 확인 |
| 5 | SCP0122_SAVE_PLAN_ACTIVITY_MGMT | `PR_SCM_SYS_LOG_BATCH` EXEC → `SCM_SYS_LOG_BATCH` INSERT | 공용 로그 SP의 Oracle 존재 여부 확인 (공용이므로 standalone 유지 대상) |
| 6 | SCP0122_GET_PLAN_ACTIVITY_MGMT | 3개 테이블 SELECT, EXEC 체인 없음 | 결과 컬럼이 메타 15컬럼(AUTO_YN…PROGRAM_NAME)과 일치하는지 확인. Fact Pack은 "SP 실행 결과와 매칭되는 시트 없음"으로 보고 |
| 7 | 공통 | 원본 SP 본문(T-SQL)은 Fact Pack에 미포함 | MSSQL 고유 구문(ISNULL/GETDATE/TOP/NOLOCK 등)의 실제 존재 여부는 원문을 봐야 판단 가능 |

## 5. 난이도 (사실 근거)

| SP | 근거 | 난이도 |
|---|---|---|
| SCP0122_GET_PLAN_ACTIVITY_MGMT | SELECT 3테이블, EXEC 체인·임시테이블 없음 | 낮음 |
| SCP0122_SAVE_PLAN_ACTIVITY_MGMT | DML 3종, EXEC 2단, 분해 함수 REF 2개, 이력/로그 테이블 | 중간 |
| SCP0121_GET_SEARCH_INFO | 임시테이블 3개, 참조 테이블 11개 | 중간~높음 (본문 미확인. 공유 SP라 이미 이관됐는지에 따라 달라짐) |
