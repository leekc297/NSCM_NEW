# DMF0082_XLSNULL_20261014 — 사내 ZIOUI1 실행 기록 (SCM_MGR, SERVER_HOST=localhost)

| 시각 (2026-10-14) | 작업 | 파일 | 결과 |
|---|---|---|---|
| 13:31~13:36 | 기준본 조회 (PKG_DMF0082 BODY, LAST_DDL 11:50:01) | `../../_deploy_packages/DMF0082_XLSNULL_CLOUD_20261014/build_package.py` | `PKG_DMF0082_BODY.ASIS.sql/.raw` · `TOBE.raw` (DB 무변경) |
| 13:36 | 1차 리허설: 10_APPLY 적용 → 재실행 SKIP → 90 → 99_ROLLBACK **중단**(ORA-20003, 원문 무변경) | `run_rehearsal.py` | 원인 = 적용 토큰 `ATTRIBUTE7 IS NOT NULL /*XLSNULL*/` ⊂ `EU.ATTRIBUTE7 …` → 생성기 표식 별칭 구분(`/*XLSNULL.EU*/`) + 포함관계 assert 추가 |
| 13:38:12 | 기준본 복원 (FRESH-GATE: 현재 == 1차 적용본) | `restore_asis_after_aborted_rollback.py` | VALID · 오류 0 · == ASIS (바이트 동일) |
| 13:38:48 | 10_APPLY | `A_DB/10_APPLY_XLSNULL_PATCH.sql` | APPLIED · DB == Python 적용본 |
| 13:38:5x | 10 재실행 / 90_VERIFY | 동 | SKIP / V1 81 · V2 VALID 0 0 · V3 0 |
| 13:38:56 | 99_ROLLBACK | `A_DB/99_ROLLBACK_XLSNULL_PATCH.sql` | ROLLED BACK · DB == 기준본 |
| 13:39:00 | 10_APPLY (최종) | `A_DB/10_APPLY_XLSNULL_PATCH.sql` | **APPLIED (현재 상태)** · VERIFY PASS |
| 13:40:23 | E2E 1차 — 케이스 스테이징 같은 초 누적(테스트 장치 문제) · 저장은 오류행 게이트로 차단 | `e2e_upload.py` | 원장 변경 0 · 스테이징 14행 정리 |
| 13:40:55 | E2E 2차 — 케이스별 스테이징 분리 | `e2e_upload.py` | 6/6 PASS · 저장 30행 확인 후 FP 30 · FP_H 30 · 스테이징 2 삭제 → 원장 0 (전 0) |

- 정리 DELETE 대상 = `CREATED_BY='XLSNULL_T1'` + `PROJECT_CODE='A25PS1001-M02'` + `ATTRIBUTE8='EXCEL UPLOAD'` (사전 assert: 대상 프로젝트 FP 0건).
- `SCM_SYS_LOG_BATCH` 로그 행(SP 내부 기록)은 남김.
- 원복: `../../_deploy_packages/DMF0082_XLSNULL_CLOUD_20261014/A_DB/99_ROLLBACK_XLSNULL_PATCH.sql` (또는 `PKG_DMF0082_BODY.ASIS.sql`, 단 그 뒤 타 작업자 변경이 있으면 99 사용).
