# Hook #104 — SP 테스트 실행 게이트 (부작용 실측 → 실행 방식 판정)

> 신설: 2026-07-03 (DMF0003 SAVE_PRPOPUP — "4기능 전체 동작?" 검증 중 임의 실행 직전 부작용 발견으로 중단한 사례의 룰화)
> 트리거: T08 / T10 / T19 — **저장/실행 계열 SP 를 검증 목적으로 직접 호출**하려 할 때 (GET 계열 read-only 는 대상 아님)
> 짝: oracle-db-workflow(진입) / #99 oracle-save-payload-integrity / 32_CLAUDE_ORACLE_DIRECT

## §0. 원칙

**"저장 SP 를 테스트로 한 번 실행해 본다" 는 임의 결정 금지.** 실행 전 SP body 를 실측해
부작용 표면을 확인하고, 아래 판정표에 따라 실행 방식을 결정한다. 판정 결과는 사용자 보고에 명시한다.

## §1. 실행 전 실측 3단계 (의무)

```sql
-- ① 트랜잭션 제어: 내부 COMMIT 있으면 rollback 검증 불가
SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='<SP>'
 AND (UPPER(TEXT) LIKE '%COMMIT%' OR UPPER(TEXT) LIKE '%ROLLBACK%') ORDER BY LINE;
-- ② DML 표면: 어떤 테이블을 쓰는가 (INSERT/UPDATE/DELETE/MERGE + 채번 방식 MAX/SEQ)
SELECT LINE, TEXT FROM ALL_SOURCE ... LIKE '%INSERT INTO%' OR '%UPDATE %' OR '%DELETE%' OR '%MERGE%';
-- ③ 연쇄/외부 부작용: 다른 SP 호출(EXEC/직접호출), 메일(GT_T_MAIL_ADDR/HTML 조립), 큐/알림
```

## §2. 판정표

| 실측 결과 | 실행 방식 |
|---|---|
| 내부 COMMIT **없음** + DML 이 자기 테이블 한정 | ✅ **트랜잭션 rollback 검증** — autocommit off → callproc → OUT/행수 확인 → `conn.rollback()` → 행수 원복 assert (실데이터 무생성) |
| 내부 COMMIT **있음** + 정리 가능한 단순 INSERT | ⚠️ 실행 후 생성분 정확 DELETE 정리 — 단, 채번(MAX+1)/이력 테이블 연쇄까지 전부 파악된 경우만. 불확실하면 아래로 |
| **메일 발송 / 타 SP 연쇄(분석요청 등) / 본테이블 UPDATE** 포함 | ⛔ **임의 테스트 실행 금지** — 되돌릴 수 없는 실업무 부작용. 화면 E2E(사용자, 실업무 조합)로 위임하고 그 사유를 보고 |

## §3. 보고 양식

"저장 SP 는 실행 검증을 하지 않았습니다" 로 끝내지 말고:
`실측: COMMIT L506 / 메일 조립 L398~ / PR_SSP_ANL_ESS_REQ 연쇄 L389 → 임의 실행 부적합 판정 → 화면 E2E 위임` 처럼
**판정 근거(라인)까지** 명시. GET 계열은 read-only 이므로 대표 파라미터 왕복 검증을 기본 수행.

## §4. 안티패턴

1. ❌ 부작용 미확인 상태로 "테스트 1건이니 괜찮다" 실행
2. ❌ rollback 검증 스크립트에 내부 COMMIT 확인 단계 생략 (rollback 무효인데 무생성으로 오인)
3. ❌ 반대로 — 부작용 없음을 실측하고도 "위험해서 검증 생략" (검증 가능한 것은 검증 의무, anti-simplification)

레퍼런스: `_deploy_packages/DMF0003_PR_20260703/04_VERIFY/verify_save_rollback.py` (①단계에서 COMMIT 발견 → 중단 분기 내장).
