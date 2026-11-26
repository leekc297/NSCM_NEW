# SYS0016 공지 본문 CLOB 전환 사내 적용 기록 (ZIOUI1, 2026-11-24)

| 시각 | 작업 | 결과 | 로그 |
|---|---|---|---|
| 14:49 | 원문 조회(DBMS_METADATA, ALL_OBJECTS) | 표 2개, HIST, PKG_SYS0016 DDL 저장 | fetch.log |
| 14:50 | FRESH-GATE 재조회 | LAST_DDL 4건 14:49 조회값과 같음 | |
| 14:51 | 10_APPLY_NOTICE_CONTENT_CLOB.sql | 백업 2개 생성, CLOB 전환 2개, HIST 수정, PKG 재컴파일 | apply.log |
| 14:52 | 90_VERIFY_NOTICE_CONTENT_CLOB.sql | PASS 13건 | verify.log |
| 14:52 | smoke.py 1회차 | FAIL 1건. 시험 스크립트가 수정 구분값을 'U' 로 보냄. SAVE SP 와 FE 는 'M' 사용 | |
| 14:52 | smoke.py 2회차('M' 으로 고침, 삭제 확인 추가) | PASS 11건, ROLLBACK 뒤 행 수 45, 54, 42 그대로 | smoke.log |
| 14:54 | rehearse.py (99, 99 SKIP, 10, 10 SKIP, 90) | REHEARSE OK | rehearse.log |
| 14:54 | 00_PRECHECK_CLOUD.sql | CLOB 2개, 앵커 적용본, 객체 VALID 3건 | precheck.log |

- 백업 표: SCM_MGR.SCM_ADM_NOTICE_CONTENT_MASTER_BAK20261124(45행), SCM_MGR.SCM_ADM_NOTICE_CONTENT_MASTER_H_BAK20261124(54행)
- 원문: PR_HIST.ASIS.sql, TBL_M.ASIS.sql, TBL_H.ASIS.sql, PKG_SYS0016_body.ASIS.sql, PKG_SYS0016_spec.ASIS.sql
- 적용본: PR_HIST.APPLIED.sql, TBL_M.APPLIED.sql
- 클라우드 패키지: _artifacts/_deploy_packages/SYS0016_NOTICE_CLOB_CLOUD_20261124_1455
