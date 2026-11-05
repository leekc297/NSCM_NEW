# DMF0049 중복 저장 차단(MOBILE 검증 실패 ROLLBACK) + 중복 데이터 정리 — 사내 ZIOUI1 적용 기록 (2026-10-28)

- DB: 59.19.252.148:2521/ZIOUI1 · 계정 SCM_MGR
- 기준 원문: 16:06:22 ALL_SOURCE 재조회 · PKG_DMF0044 BODY LAST_DDL 2026-10-27 13:14:01 VALID (10,611줄) → `PKG_DMF0044_BODY.ASIS_20261028_160622.sql`
- AS-IS 대조: AS-IS DB(LGCE_SCMDEV) `DMF0044_MOBILE_REPORT_CREATE`(modify 2026-02-09) L470~473 `ROLLBACK TRANSACTION` 직접 조회 확인
- 클라우드 패키지: `_artifacts/_deploy_packages/DMF0049_DUPROLLBACK_CLOUD_20261028/`

| # | 시각 | 작업 | 파일 | 결과 |
|---|---|---|---|---|
| 1 | 16:14:15 | 수정 전 동작 실측 (선행 UPDATE → MOBILE 중복 검증 → 값 확인 → ROLLBACK) | `t_rollback.py BEFORE` → `test_BEFORE.out.txt` | 선행 변경 살아남음 · 잔존 0 |
| 2 | 16:22:29~16:25:13 | 패치 리허설·적용 (99 SKIP → 10 → 10 SKIP → 99 → 99 SKIP → 10) | 패키지 `A_DB/10_*`, `A_DB/99_ROLLBACK_DUPROLLBACK_PATCH.sql` | 최종 BODY VALID · LAST_DDL 16:25:13 · 오류 0 · 원복본 = 기준본 동일 |
| 3 | 16:28:13 | 수정 후 동작 실측 | `t_rollback.py AFTER` → `test_AFTER.out.txt` | 선행 변경 ROLLBACK 됨 · 잔존 0 |
| 4 | 16:28:40 | 백업 테이블 생성 `BAK_DMF0049_DUP_20261028` | 패키지 `A_DB/20_DATA_DEDUP.sql` | 생성 |
| 5 | 16:29:08~16:31:46 | 중복 정리 리허설 (20 → 20 → 99_DATA → 99_DATA → 20) | 패키지 `A_DB/20_*`, `A_DB/99_ROLLBACK_DATA.sql` | 최종: R_S_20261002_V001_C DATA_SEQ 342 3행 삭제(174 유지, QTY 동일) · 원장 863,497 → 863,494 |
| 6 | 16:32:39 | 최종 확인 | 패키지 `A_DB/90_VERIFY.sql`, `lint_and_check.py` | V1 VALID / V2 6행 IN / V3 0·0 / 시험값 잔존 0 / DMF004x INVALID 0 |

원복: 패키지 `99_ROLLBACK_DUPROLLBACK_PATCH.sql` → `99_ROLLBACK_DATA.sql`.
Sales Report 재생성: 대상 버전 SEND_YN='N' 이라 불필요(사내).
