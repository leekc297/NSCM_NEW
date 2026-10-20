# SCP0096 PKG 이식 — 사내오라클(ZIOUI1 · SCM_MGR) 적용 기록 2026-10-19

| # | 시각 | 작업 | 파일 | 결과 |
|---|---|---|---|---|
| 1 | 22:43 | 착수 원문 재조회(hook #152): PKG_SCP0096 spec/body ALL_SOURCE 덤프 · LAST_DDL 2026-10-09 13:38:32 / 13:38:44 · VALID | `dump_pkg.py` → `DB_PKG_SCP0096_PACKAGE{,_BODY}.sql` | OK |
| 2 | 22:52 | 하네스 파일 작성(현행 본문 무변경 + BUCKET/3SPAN 추가) · 보존 대조 | `verify_verbatim.py` | helpers/GET/SAVE/spec SAME |
| 3 | 22:53 | FRESH-GATE: LAST_DDL 재조회 = 착수본과 동일 | ora.py query | OK |
| 4 | 22:53 | `CREATE OR REPLACE PACKAGE / PACKAGE BODY SCM_MGR.PKG_SCP0096` (DDL, 자동 COMMIT) | `Doc/gen/SCP0096/SCP0096_PKG.sql` via `tools/DbConn/run_sql.py` | 컴파일 OK · ALL_ERRORS 0 · VALID · LAST_DDL 2026-10-19 22:53:27 · 의존 INVALID 0 |
| 5 | 22:55 | 적용본 == DB 원문 대조 | `verify_db_equals_file.py` | 본문 동일(1행 `SCM_MGR.`→공백 치환만) |
| 6 | 22:56 | 스모크 3건 + As-is MSSQL 직접 대조 2건 | `smoke_and_golden.py` | BUCKET 3행 동일 · 3SPAN 37행 동일 · 기존 GET 21행 정상 |
| 7 | 23:00 | PROC_M 신규 2 프로시저 등록(NOT EXISTS 멱등) · COMMIT | `02_PROC_M_new_procs.sql` | 아래 결과 참조 |
| – | 22:57 | `SCP0096_registration.sql` 전체 드라이런(ROLLBACK) — **커밋 안 함** | run_sql.py 기본 | BTN_MPG 5→2 · `PKG_SCP0096.P_` 공란 등록 → 사람 결정 |

- 기존 사내 객체 변경 없음: `P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`(6인자) · `P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP`(9인자) · `GT_SCP0096_PIVOT` · PROC_M 6/9행 그대로.
- 원복 필요 시: `DB_PKG_SCP0096_PACKAGE.sql`/`DB_PKG_SCP0096_PACKAGE_BODY.sql` 의 1행 스탬프 제거 후 `CREATE OR REPLACE` + `DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM IN ('PKG_SCP0096.P_DM0003_GET_BUCKET_TYPE_CODE','PKG_SCP0096.P_SCP0009_GET_SHEET_CALENDAR_3SPAN')`.
