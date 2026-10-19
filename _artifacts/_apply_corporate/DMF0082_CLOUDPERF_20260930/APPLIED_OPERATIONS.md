# DMF0082 조회 병목 2문장 계획 고정 `[E20260930-DMF0082CLOUDPERF]` — 사내 ZIOUI1 실행 작업 대조표

| 시각 (2026-09-30) | 계정 | 작업 | 대상 | SQL / 스크립트 |
|---|---|---|---|---|
| 09:59~10:10 | SCM_MGR | 재현·힌트 벤치 (GTT 만 · ROLLBACK · 영구 변경 없음) | 세션 GTT | `_diagnostics/DMF0082_CLOUD_PERFCHK_20260930/b01_hint_bench.py` |
| 10:1x | SCM_MGR | 적용 전 결과 SHA 채취 (조회 · ROLLBACK) | — | `e01_equiv.py before` → `e01_before_raw.json` |
| 10:18:48 | SCM_MGR | **PKG BODY 적용** (FRESH-GATE 통과 · VALID · 오류 0 · 마커 3) | `PKG_DMF0082` BODY | [01_PKG_DMF0082_BODY_CLOUDPERF.sql](01_PKG_DMF0082_BODY_CLOUDPERF.sql) (`apply_cloudperf.py apply`) |
| 10:2x | SCM_MGR | 적용 후 동등성·속도 (조회 · ROLLBACK) | — | `e01_equiv.py afterN1/afterN2` · `diff` FAIL 0/6 |

- 적용 전 원문 백업: [00_BACKUP_PKG_DMF0082_BODY.sql](00_BACKUP_PKG_DMF0082_BODY.sql) (LAST_DDL 2026-09-30 08:04:37 = QRYPERF 적용본)
- 원복: [99_ROLLBACK_PKG_DMF0082_BODY.sql](99_ROLLBACK_PKG_DMF0082_BODY.sql)
- 변경 = L1229 · L1943 SELECT 줄 힌트 + 헤더 이력 1줄. SPEC · PROC_M · GRANT · 인덱스 · 통계 · 파라미터 변경 **없음**
- 클라우드 패키지: [`_deploy_packages/DMF0082_CLOUDPERF_CLOUD_20260930/`](../../_deploy_packages/DMF0082_CLOUDPERF_CLOUD_20260930/00_README.md)
