# DMF0082 조회 병목 2문장 계획 고정 (클라우드 이관)

> 마커 `[E20260930-DMF0082CLOUDPERF]` — `P_DMF0082_GET_MAIN_DATA` (화면 [Search] · `FcstNPrice/SEARCH/call-proc`)

| 항목 | 값 |
|---|---|
| 범위 | **DB 전용**: `PKG_DMF0082` BODY 1본. SPEC·PROC_M·FE·BE·메타 변경 **없음** |
| 전제 | 클라우드 BODY = 09-30 QRYPERF 적용본 (지문 `16176/830176`). QA 는 C01 에서 확인됨(09:37). DEV 는 PRECHECK [H] 로 판정 |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1, 2026-09-30 10:18:48) — [`_apply_corporate/DMF0082_CLOUDPERF_20260930`](../../_apply_corporate/DMF0082_CLOUDPERF_20260930/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** · ⚠ **QA · DEV 2곳 모두** |
| BE 재기동 | 불요 |

## 1. 무엇이 바뀌나

클라우드 점검(`_diagnostics/DMF0082_CLOUD_PERFCHK_20260930`) 결과, 화면 조회 시간의 대부분(DB_S ≈ TOTAL_S)을 두 문장이 차지했다. 두 SELECT 줄에 **힌트만** 넣었고 로직은 바꾸지 않았다.

| # | 문장 (SQL_ID · 라인) | 증상 (클라우드 실측) | 원인 | 조치 |
|---|---|---|---|---|
| ① | `2nysu9tbng9v4` · L1943 CUST 종속 메저 실적 적재 (`DM_PLN_MKT_FCST_RESULT`) | 1회 18.6초 · BG 591만 · 결과 0행 · CUST_FCST 선택 사용자(k0101) 조회 62~64초의 주범 | '종속 메저 0행' 사용자 조건에서 파싱된 계획(GTT 3종 카테시안 → PK 행별 조회)이 굳어 모든 사용자가 재사용 | `LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1)` + D·C 해시 |
| ② | `7mrzdbpupw3b9` · L1229 div40 최신 데이터 키 (`DM_PLN_CFM_MKT_DEMAND_PLAN`) | 1회 9.4~9.7초 · BG 194만 (사내 0.05초) | `TEMP_SITE_ITEM` 1행 추정으로 Nested Loop + PK 행별 조회 | 형제 문장 L1265(08-15 선례)와 같은 `LEADING(A) USE_HASH(C)` |

**사내 검증**
- 재현 벤치 (나쁜 계획을 굳힌 뒤 재사용 조건): ① 28.41초 → **0.03초** · ② 4.64초 → **0.69초**. 결과 동일 (① 12,709행 SHA 일치 — 기간 확대 조건 포함).
- SP 전체 (사용자 2 × division 3, 결과 6커서 SHA): 화면 데이터 커서(O_RC1·O_RC2·O_RC5·결과)는 적용 전과 **6/6 동일**. O_RC3(조회 시각)·O_RC4(동순위 행 순서)만 매번 다르며, 이는 기존 동작이다.
- 속도 (사내 SP만, 적용 전 → 후): k0101 40 = 32.3초 → 4.7~6.2초 · 81 = 26.4초 → 6.5~7.4초 · 82 = 26.2초 → 7.3~7.8초 / minyonglee1 = 변화 없음(3~4초).

## 2. 작업 ↔ 파일 대조표 (SCM_MGR · QA → DEV 순으로 각각)

1. [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) — READ-ONLY. `[H]` JUDGE 가 **`적용`** 이면 진행, `SKIP` 이면 종료, `⚠ 중단` 이면 결과 회신
2. [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) — 현 BODY → `BAK_SRC_DMF0082_CLOUDPERF` (비파괴 · 멱등)
3. [A_DB/11_PKG_DMF0082_BODY.sql](A_DB/11_PKG_DMF0082_BODY.sql) — BODY 전체본 (`SHOW ERRORS` 0 확인)
4. [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) — V1 VALID·오류 0 / V2 지문 `16177/830657`·마커 3·QRYPERF 22 / V3 GRANT
5. 화면에서 40·81·82 Search → 점검 SQL [C02_SCREEN_LOG_ASH.sql](../../_diagnostics/DMF0082_CLOUD_PERFCHK_20260930/C02_SCREEN_LOG_ASH.sql) 로 효과 확인 (가능하면 **k0101 계정 포함**)

롤백 (평소 실행 안 함): [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql)

## 3. 클라우드 기대 효과와 남는 병목

- **기대 효과:** ②가 빠지면 div40 은 약 9초 단축된다 (minyonglee1 21초 → 약 11~12초). CUST_FCST 를 선택한 사용자는 ①이 빠지면서 60초대 → 10초대가 된다.
- **남는 병목 (이번 범위 밖 — 3초 목표에는 추가 조치 필요):**
  - `18xg1y5298qgq` MF_SP INSERT: 1회 3.6~5.3초, 사내 0.5~0.8초. 행수 3배 · TEMP 유출.
  - 결과 PIVOT fetch: 2.7~2.9초 (결과 7.6~8.1천 행, 사내 minyonglee1 2.1~2.6천 행).
- 클라우드 시스템 파라미터 `optimizer_dynamic_sampling=0`·`optimizer_adaptive_plans=FALSE` (사내 2·TRUE) 는 그대로다. SP 가 세션에서 2 로 보정하므로 이번 조치와 무관하나, 전 화면 공통 과제로 남는다 (DBA 결정).
