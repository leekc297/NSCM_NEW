# DMF0049_SOLDTONULL_20261022 — 사내 ZIOUI1 적용 기록 [E20261022-SOLDTONULL]

DB: 59.19.252.148:2521/ZIOUI1 (SERVER_HOST=localhost) · 계정 SCM_MGR

| # | 시각 | 작업 | 파일 | 결과 |
|---|---|---|---|---|
| 1 | 11:36 | PKG_DMF0049 BODY 착수 원문 재조회·백업 (LAST_DDL 2026-10-16 17:24:07) | `00_BACKUP_PKG_DMF0049_BODY_*.sql` | — |
| 2 | 11:36:46 | P_DMF0049_SAVE_SALES_ETC_REPORT_C INSERT 2곳 SOLDTO_CODE `NVL(…,'/')` → `NULLIF(RTRIM(…),'')` (FRESH-GATE 통과) | `apply_pkg.py --apply` · `10_TOBE_*.sql` | VALID · 오류 0 · 적용본==DB 원문 |
| 3 | 11:37 | 백업 테이블 `DM_PLN_SALES_ETC_REPORT_C_BAK20261022_SOLDTO` CTAS(238행) + `UPDATE … SOLDTO_CODE=NULL WHERE IN ('-','/')` 238행 COMMIT | `apply_data.py --apply` | 원장 전체 NULL 863,497 |
| 4 | 11:40 | 저장 실호출 검증 — SQL_LOG 2293331 실전송값(INSERT 경로) 재실행 → DATA_SEQ 345 3행 NULL 확인 후 시험 행 C 3행 삭제(_H 0) | `verify_save_replay.py` | PASS |
| 5 | 11:44 | 클라우드 패키지 리허설: 90→99(원복, md5==수정 전)→99 SKIP→00→10(md5==적용본)→10 SKIP→99_DATA(238 복원)→00→20(238 정리)→20(0)→90 | `_deploy_packages/DMF0049_SOLDTONULL_CLOUD_20261022/_rehearsal_out/` | 전부 PASS · 최종 LAST_DDL 11:44:39 |

- 리허설 중 PKG 원문이 11:44:35~11:44:39 (약 4초) 수정 전 상태, 데이터 238행이 11:44:41~42 (약 1초) '-'/'/' 상태였다.
- 이력 테이블 `DM_PLN_SALES_ETC_REPORT_H` 의 '-' 120 · '/' 73 행은 저장 당시 기록이라 변경하지 않음.
- 원복: `00_BACKUP_*.sql` 또는 패키지 `99_ROLLBACK_SOLDTONULL_PATCH.sql` / 데이터 `99_ROLLBACK_DATA.sql`(백업 테이블 기준).
