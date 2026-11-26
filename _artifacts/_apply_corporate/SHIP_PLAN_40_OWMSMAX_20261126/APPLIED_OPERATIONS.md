# 사내 ZIOUI1 적용 기록 : SHIP_PLAN_40 1-1 단계 최근 CUTOFF 조회 보완 (2026-11-26)

| 시각 | 작업 | 결과 |
|---|---|---|
| 13:58 ~ 14:08 | 1차 변경안(DISTINCT 인라인 뷰 + NO_MERGE) 시험 | 옵티마이저가 DISTINCT 를 없애 53M 행 조인. 531초 넘어 본인 세션(sid 14) 중지. 폐기 |
| 14:09 | eq2.py : 원문 조건 vs 스칼라 서브쿼리 조건 | 결과 같음(HQ00, NJ00, AZ00). 2.43 → 0.23초, 2.54 → 0.35초, 2.42 → 0.20초 |
| 14:10:06 | build_owmsmax.py fetch | 기준본 LAST_DDL 2026-11-26 11:26:43, 3582줄(이전 패키지 적용본과 같음) |
| 14:10:14 | build_owmsmax.py apply | VALID, ALL_ERRORS 0, DB == 적용본(3583줄) |
| 14:11:24 ~ 14:11:29 | 패키지 리허설 | APPLY → SKIP → 원복 → APPLY, 90 기대값 일치. 최종 상태 = 적용 |
| 14:12 | 95_COMPARE_OWMSMAX.sql | 결과 3건 같음 |

- 생성 객체 : SCM_MGR.ZB_SSP40_SHIP_20261126B (보관 표)
- 원복 : `_artifacts/_deploy_packages/SSP_SHIP_PLAN_40_OWMSMAX_CLOUD_20261126/A_DB/99_ROLLBACK.sql` 또는 PR_SSP_ANL_SHIP_PLAN_40.ASIS.sql
