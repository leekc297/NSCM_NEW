# DMF0082 81 금액 조회 `[E20261002-DMF0082-81MKTAMT]` — 사내 ZIOUI1 실행 작업 대조표

| 시각 (2026-10-02) | 계정 | 작업 | 대상 | SQL / 스크립트 |
|---|---|---|---|---|
| 14:23:42 | SCM_MGR | (자동) INVALID BODY 가 첫 조회 호출 시 자동 재컴파일 — 소스 무변경 | `PKG_DMF0082` BODY | `v01_equiv.py cap before` 호출의 부수 효과 |
| 14:23~15:05 | SCM_MGR | 적용 전 조회 결과 채취 (조회 전용 · 매 회 ROLLBACK) | `PKG_DMF0082` GET 2본 | `v01_equiv.py cap before` → `v01_before/` |
| 14:48:14 | SCM_MGR | 실험용 복제 패키지 생성 (검증 전용 — 운영 무영향) | `PKG_DMF0082_T81` SPEC/BODY | `t01_clone_compile.py create` · `run` |
| 15:09:41 | SCM_MGR | **PKG BODY 적용** (FRESH-GATE 통과 · VALID · ERR 0 · 적용본 == DB 원문) | `PKG_DMF0082` BODY | [01_PKG_DMF0082_BODY_81MKTAMT.sql](01_PKG_DMF0082_BODY_81MKTAMT.sql) (`apply_81mktamt.py apply`) |
| 15:10~15:45 | SCM_MGR | 적용 후 조회 결과 채취 · 전후 대조 (예상 밖 변경 0) | 〃 | `v01_equiv.py cap after` · `diff before after` |
| 16:09 | SCM_MGR | 실험용 복제 패키지 삭제 | `PKG_DMF0082_T81` | `DROP PACKAGE SCM_MGR.PKG_DMF0082_T81;` (클라우드 이관 대상 아님 — 사내 임시 객체) |

- 적용 전 원문 백업: [00_BACKUP_PKG_DMF0082_BODY.sql](00_BACKUP_PKG_DMF0082_BODY.sql) (LAST_DDL 2026-10-02 14:23:42 = 09-30 21:19:15 FXZERO 본의 자동 재컴파일본, 소스 동일)
- 원복: `python apply_81mktamt.py restore`
- 삽입분 전문: [_change_preview.sql](_change_preview.sql)
- SPEC · PROC_M · GRANT · 시노님 · 메타 · 테이블 변경 **없음** (BODY 교체만 — GRANT 는 CREATE OR REPLACE 로 보존, 90_VERIFY V3 확인)
- 클라우드 패키지: `_deploy_packages/DMF0082_81MKTAMT_QRY_CLOUD_20261002/` — 클라우드 적용 완료(사용자 확인 2026-10-02)
