# DMF0049 저장 키 중복 검증 = 저장 후 모습 기준 — 사내 ZIOUI1 적용 기록 (2026-10-28)

- DB: 59.19.252.148:2521/ZIOUI1 · 계정 SCM_MGR
- 기준 원문: 16:52:21 ALL_SOURCE 재조회 · PKG_DMF0049 BODY LAST_DDL 2026-10-22 11:44:39 VALID (1,358줄) → `PKG_DMF0049_BODY.ASIS_20261028_165221.sql`
- 클라우드 패키지: `_artifacts/_deploy_packages/DMF0049_DUPKEYMSG_CLOUD_20261028/`

| # | 시각 | 작업 | 파일 | 결과 |
|---|---|---|---|---|
| 1 | 17:00:27 | 시나리오 시험(GT 만, 원장 무변경) 현재/신규 검증 비교 7건 | 패키지 `scenario_test.py` → `_scenario_before_apply.out.txt` | 7건 PASS · GT 잔여 0 |
| 2 | 17:09:30~17:11:20 | 패치 리허설·적용 (99 SKIP → 10 → 10 SKIP → 90 → 99 → 99 SKIP → 10 → 90) | 패키지 `A_DB/10_*`, `A_DB/99_*` | 최종 BODY VALID · LAST_DDL 17:11:20 · 오류 0 · 원복본 = 기준본 동일 |
| 3 | 17:12:50 | 저장 SP 직접 호출 1차 — **시험 입력 오류**(LOC 파생 메저 행을 payload 에 포함 → 저장분 안에서 LOC 2건) | `e2e_save.py` → `e2e_AFTER_withLOC_invalid.out.txt` | 두 건 모두 차단 · 원장 무변경. 화면은 LOC 를 보내지 않음(메저 메타 3종) → 입력 정정 후 재시험 |
| 4 | 17:18:56 | 저장 SP 직접 호출 2차 (LOC 제외 = 화면과 같은 payload) | `e2e_save.py` → `e2e_AFTER.out.txt` | T1 같은 키 → 키 중복 메시지·저장 안 됨 / T2 다른 키 → success 37행 |
| 5 | 17:18:58 | T2 시험 행 삭제 (CUST_REPORT='ZZ_DUPTEST', 원장 37행 · 이력 0행) | `e2e_save.py` 정리부 | 원장 13,341 복귀 |

원복: 패키지 `A_DB/99_ROLLBACK_DUPKEYMSG_PATCH.sql`.
