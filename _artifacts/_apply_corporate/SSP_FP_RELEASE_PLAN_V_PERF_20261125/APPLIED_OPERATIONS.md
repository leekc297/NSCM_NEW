# 사내 ZIOUI1 적용 기록 : FP_MGR.IF_SSP_FP_RELEASE_PLAN_V (E20261125-FPRELV-ITEMJOIN)

- DB: 사내 ZIOUI1(59.19.252.148:2521), 계정 system
- 기준본: LAST_DDL 2026-11-17 17:17:28, 조회 2026-11-25 13:57, 적용 직전 재조회 14:14:54 일치(precheck.log FRESH-GATE PASS)
- 원복용 원문: IF_SSP_FP_RELEASE_PLAN_V.ASIS.sql, 표 FP_MGR.ZB_FPRELV_20261125_SRC
- 실행 파일: _artifacts/_deploy_packages/SSP_FP_RELEASE_PLAN_V_PERF_CLOUD_20261125_1413/A_DB

| 시각 | 작업 | 결과 | 로그 |
|---|---|---|---|
| 14:14 | 보완 전 갈래별 건수, 해시 합계 측정 | 40 사업부 14,873건, 전체 239,027건 | precheck.log |
| 14:17:01 | 05_BACKUP_CLOUD | ZB_FPRELV_20261125_SRC 생성, 11,972자 | apply.log |
| 14:17:01 | 20_VIEW | 치환 3종 각 2곳, VALID, 12,412자 | apply.log |
| 14:17 | 90_VERIFY, 20 재실행, 05 재실행 | V4 14,846건 4.4초, 20 SKIP, 05 SKIP | verify.log |
| 14:17 | 보완 후 건수, 해시 합계 | 40 사업부 14,873건, 전체 239,027건, 해시 일치 | verify.log |
| 14:18 | 99_ROLLBACK 1차 | ORA-06502(SQL 안 DBMS_LOB.SUBSTR 4,000자 한도). 뷰 무변경 | rehearse_rollback.log |
| 14:19:34 | 99_ROLLBACK 수정 후 | 원문 일치 복원, VALID | rehearse_rollback.log |
| 14:19:35 | 20_VIEW 재적용 | VALID, 12,412자, 권한 2건 유지 | rehearse_rollback.log |
| 14:19 | 90_VERIFY 최종 | V4 14,846건 4.9초 | verify_final.log |

- 최종 상태: 적용본(LAST_DDL 2026-11-25 14:19:35)
- 권한: RL_FP_SEL SELECT, SCM_MGR SELECT(WITH GRANT OPTION), DBA_TAB_PRIVS 확인
- PR_SSP_ANL_SHIP_PLAN_40 전체 실행은 하지 않음(프로시저 안 COMMIT)
