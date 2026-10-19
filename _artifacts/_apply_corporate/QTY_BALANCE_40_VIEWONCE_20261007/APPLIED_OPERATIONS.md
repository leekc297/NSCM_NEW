# [E20261007-PERF] PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 배치 경로 뷰 평가 4회→2회 — 사내 적용 기록 · 클라우드 적용 패키지

> 대상: `SCM_MGR.PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` (클라우드 매일 00시 `JOB_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_*` → Daily Rolling 40 MF_D 안에서 ('40', NULL) 호출)
> 진단 근거: `_artifacts/_diagnostics/BATCH_PERF_QTY_BALANCE_40_20261007/00_README.md` §5-4 (클라우드 10-07 00:03 실행 138초 구간 분해)
> 순서(hook #129): 0-a 구간 측정 → 0-b ASH 문장 특정 → 후보 사내 실측 → **1-b(소비집합 선행축소: 뷰 재평가 제거)만 적용**. 1순위(스칼라 서브쿼리)·3순위(SARGable)·4·5순위(인덱스·힌트) 미적용(사유 §3).

## 1. 변경 내용 (결과 동치, 배치 경로만 영향)

| # | 위치(원문 줄) | 변경 | 동치 근거 |
|---|---|---|---|
| 1 | 선언부 L137 | `V_MAX_PLAN_START_PRE`, `V_MAX_PLAN_START_PRE_YN` 추가 | — |
| 2 | L1389~1399 | `MAX(PLAN_ID)` 질의에 `MAX(PLAN_START_YYYYMMDD) KEEP (DENSE_RANK LAST ORDER BY PLAN_ID)` 를 함께 구함 | PLAN_ID 최대 행들의 MAX(PLAN_START) = 원 L1423 질의(`PLAN_ID = MAX(PLAN_ID)`)와 동치. 사내 전 사업부 9종 + 무데이터 케이스 10/10 일치 |
| 3 | L1421~1430 | 배치 경로(`V_MAX_PLAN_START_PRE_YN='Y'`)는 위 값 사용, 그 외(PLAN_ID 지정 호출)는 원문 질의 유지 | 분기 보존 |
| 4 | L1633~1649 → L1578 앞(ELSE 분기 안) | `GT_PRDM2_MF_RTF_ALLOCATION` 적재 INSERT + 통계수집을 GT_PRDM2_RESULTS 적재 직전으로 이동 (조건·컬럼 원문 그대로) | 화면 CALL 경로는 C_PLAN_ID NULL 이라 원래도 0건 적재 → 이동 후 미수행과 동일. 사용 변수(C_PLAN_ID 등)는 모두 그 전에 확정 |
| 5 | L1606 | RESULTS 적재의 UNION 분기 `FROM SCP_PLN_RTF_ALLOCATION_V` → `FROM GT_PRDM2_MF_RTF_ALLOCATION` (WHERE 원문 유지) | GTT = 같은 조건의 뷰 결과. 사내 40/PLAN 1454: 양방향 MINUS 0건(4,494행) |
| 6 | 헤더 이력 1줄 | `2026.10.07 ZIONEX [E20261007-PERF] …` | — |

→ `SCP_PLN_RTF_ALLOCATION_V` 평가 횟수: 배치 경로 4회 → 2회 (L1391 KEEP 1회 + GTT 적재 1회). 원문 참조 수 4 → 3 (남은 1회는 비배치 경로 ELSE 안).

## 2. 사내 적용 (ZIOUI1 SCM_MGR, 2026-10-07)

| 시각 | 작업 | 결과 |
|---|---|---|
| 23:0x | FRESH-GATE: ALL_SOURCE 재덤프 → 이전 덤프와 해시 동일(LAST_DDL 2026-10-06 16:03:12 = 클라우드 10-06 16:16:08 판본, 3181줄) | `00_BACKUP_…_20261007.sql` |
| 23:1x | 동치 검증 ①KEEP vs 2질의 전 사업부 ②GTT 재사용 MINUS | 10/10 OK · 0/0 건 |
| 23:26:12 | `CREATE OR REPLACE` (`01_PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_VIEWONCE.sql`) | VALID · ALL_ERRORS 0 · 3201줄 · 마커 8 · 뷰 참조 3 · 의존 INVALID 0 |
| 23:26:14 | 스모크: `('ZZ_PERFSMOKE', NULL)` 호출 → L1391 KEEP 질의 수행 후 INVALID→END 조기 종료, 결과 커서 `('0','INVALID')` | 원장 무변경(로그만) |
| — | **배치 전체 실행(40/NULL) 사내 미실시** — DBMS_STATS·하위 SP 내부 COMMIT 으로 ROLLBACK 보호 불가, 사내 40 원장 변경 회피 | 실측은 클라우드 다음 00시 실행으로 |

## 3. 적용하지 않은 후보와 사유 (사내 실측, 40 데이터, ROLLBACK 보호)

| 후보 | 실측 | 결론 |
|---|---|---|
| L2972 CFM BALANCE DELETE `CASE` 제거 + `PROJECT_CODE =` 추가 (3순위) | 실행계획 동일(HASH JOIN RIGHT SEMI + PK FAST FULL SCAN), 7.5→1.6초 뒤 5.5→7.2초 = 캐시 노이즈 | 미적용 |
| L2936 MF BALANCE DELETE `DIVISION_ID` 조건 추가 (1-b) | 계획 동일(HASH JOIN SEMI), 169→5초(콜드) 뒤 10.3→14.7초 | 미적용. 비용 본체 = 15만 행 삭제·재삽입 DML |
| L1857 `DBMS_STATS.GATHER_TABLE_STATS(DM_PLN_MKT_FCST)` | 사내 1014/320(cascade=FALSE)/119초 — I/O 변동 과다 | 보류. 공유 테이블 통계 정책 변경은 승인 사안(§5 옵션) |
| L2341/2347 스칼라 서브쿼리 (1순위) | 신판 구간 2초 | 대상 제외 |

## 4. 클라우드 적용 절차

1. `03_CLOUD_VERIFY.sql` V1 (적용 전: lines=3181 · perf1007=0 · view_refs=4) · V2 (전 사업부 OK, MISMATCH 0)
2. `01_APPLY_PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_VIEWONCE.sql` 실행 (SCM_MGR, SQL*Plus/SQLcl `@`)
3. V1 재실행: lines=3201 · perf1007=8 · view_refs=3 · errors=0 · VALID
4. 다음 00시 Daily Rolling 실행 후 V3 (또는 `02_compact_output.sql` C3W): **A001→A007 구간**을 10-07 00:03 실행(14초)과 비교. 다른 구간은 변경 없음이 정상
5. 이상 시 `99_ROLLBACK_…sql` (10-06 판본 원복)

## 5. 추가 단축은 승인이 필요한 사안

| 옵션 | 기대 | 부작용/결정 필요 |
|---|---|---|
| L1857 통계수집 `CASCADE=>FALSE` 또는 생략 | A007→A010 18초 중 통계수집분 | DM_PLN_MKT_FCST 는 전 화면 공유 테이블. 2026-06-23 튜닝(NL 63분 사고) 취지상 유지 권장 |
| BALANCE DELETE+INSERT(MF 15만·CFM 15만/일) → 변경분 MERGE | A018→KRW 66초의 상당분 | 미변경 행의 CREATION_DATE/LAST_UPDATE_DATE 가 AS-IS 와 달라짐 = 파리티 변경 |
| `PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW` (19초) | 별도 SP 진단 | 별건 착수 여부 |
