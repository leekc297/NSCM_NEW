# 사내 ZIOUI1 적용 기록 : SHIP_PLAN_40 배치 3개 SP 속도 보완 (2026-11-26)

| 시각 | 작업 | 결과 |
|---|---|---|
| 11:05:59 | 기준본 조회 *.ASIS.sql (ALL_SOURCE) | SHIP_PLAN_40 3579줄 LAST_DDL 2026-11-25 10:33:42 · BALANCE 854줄 10:33:41 · MAIL 2248줄 16:29:53 |
| 11:0x | build_tobe.py → *.TOBE.sql | 원문 위 치환(매칭 1건 assert). DS 2줄 x 3, BALANCE 1·3단계 |
| 11:08 ~ 11:24 | eq_test.py, time_full.py | 결과 MINUS 양방향 0건(계획 4개), 소요 1단계 20.3 → 1.0초, 3단계 108.8 → 1.7초 |
| 11:26:01 | 패키지 00 → 05 → 10 → 11 → 20 → 90 (FRESH-GATE DB = ASIS) | APPLY 3, VALID, ALL_ERRORS 0 |
| 11:26:3x | 10, 11, 20 재실행 / 99 원복 | SKIP 3 / 원복 원문 == ASIS 3건 |
| 11:26:43 | 10, 11, 20 재적용 / 90 | 원문 == TOBE 3건, VALID, 오류 0. 최종 상태 = 적용 |
| 11:27 | PR_SSP_ANL_SHIP_PLAN_40('40','HQ00') 호출 | 세션 DS 0 → 2, 가드 RETURN, 데이터 변경 0 |

- 의존 객체 : 3개 SP 를 참조하는 객체 0건. SCM_MGR INVALID 112건 중 1시간 안 DDL 0건(이번 변경 무관)
- 생성 객체 : SCM_MGR.ZB_SSP40_SHIP_20261126, ZB_SSP40_BAL_20261126, ZB_SSP40_MAIL_20261126 (보관 표)
- 원복 : `_artifacts/_deploy_packages/SSP_SHIP_PLAN_40_BATCH_PERF_CLOUD_20261126/A_DB/99_ROLLBACK.sql` 또는 *.ASIS.sql
