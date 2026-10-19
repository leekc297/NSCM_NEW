# DMF0082 조회 속도개선 `[E20260930-DMF0082QRYPERF]` — 사내 ZIOUI1 실행 작업 대조표

| 시각 (2026-09-30) | 계정 | 작업 | 대상 | SQL / 스크립트 |
|---|---|---|---|---|
| 02:xx~07:50 | SCM_MGR | 실험용 복제 패키지 생성·재생성 (검증 전용 — 운영 무영향) | `PKG_DMF0082_QPT` SPEC/BODY | `_diagnostics/DMF0082_QRYPERF_20260930/build_qpt.py` |
| 08:04:37 | SCM_MGR | **PKG BODY 적용** (FRESH-GATE 통과 · VALID · ERR 0) | `PKG_DMF0082` BODY | [01_PKG_DMF0082_BODY_QRYPERF.sql](01_PKG_DMF0082_BODY_QRYPERF.sql) (`apply_qryperf.py apply`) |
| 08:0x | SCM_MGR | 실험용 복제 패키지 삭제 | `PKG_DMF0082_QPT` | `DROP PACKAGE SCM_MGR.PKG_DMF0082_QPT;` (클라우드 이관 대상 아님 — 사내 임시 객체) |

- 적용 전 원문 백업: [00_BACKUP_PKG_DMF0082_BODY.sql](00_BACKUP_PKG_DMF0082_BODY.sql) (LAST_DDL 2026-09-29 22:12:35)
- 원복: [99_ROLLBACK_PKG_DMF0082_BODY.sql](99_ROLLBACK_PKG_DMF0082_BODY.sql)
- SPEC · PROC_M · GRANT · 시노님 · 인덱스 · GTT 통계 설정 변경 **없음** (BODY 교체만 — GRANT 는 CREATE OR REPLACE 로 보존, V6 확인)
- 클라우드 패키지: `_deploy_packages/DMF0082_QRYPERF_CLOUD_20260930/`
