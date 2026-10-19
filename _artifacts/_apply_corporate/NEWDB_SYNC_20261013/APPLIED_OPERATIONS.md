# NEWDB_SYNC — 신규 사내오라클 누락분 반영 기록 (2026-10-13)

사용자 요청: 사내오라클 IP 변경(222.110.191.243 → 59.19.252.148) + **사용자 본인이 10-12 22시 이후 작업한 내역 중 신규 DB 누락분만** 반영.
(지시 경과: 10-12 20시 이후 전체 → 값 비교 생략·DDL 만 → 본인 작업만. "다른 분들이 작업한 내용을 제가 적용할 수는 없습니다.")

## 대상 DB
| 구분 | 주소 | SERVER_HOST | DBID | PDB 생성 |
|---|---|---|---|---|
| 구 | 222.110.191.243:2521/ZIOUI1 | ol9-db | 68425124 | 2026-09-14 14:10 |
| 신규 | 59.19.252.148:2521/ZIOUI1 | localhost | 71207375 | 2026-10-08 17:44 |

두 DB 는 별개 인스턴스이고 10-13 오전 현재 둘 다 접속된다.

## 접속 주소 변경 (파일 3개)
- `.env.asis` `TOBE_DB_HOST`
- `_artifacts/_apply_corporate/apply.sh` `CONN`
- `nscm-be/src/main/resources/config/config-local.yml` `jdbc-url`

## 사용자 작업 4건 — 신규 DB 반영 상태 (10:49 신·구 대조)
| 작업 | 구 DB 적용 | 신규 DB | 조치 |
|---|---|---|---|
| `[E20261012-FCSTTYPEADM]` 콤보 SQL 2행 (`SCM_ADM_CMBO_SQL_M`) | 10-12 23:35 | 이미 동일 (마커 2 · 내용 해시 동일) | 없음 |
| `[E20261013-DMF0082SSPMNEW]` `PKG_DMF0082` BODY | 10-13 00:18 | **누락 → 적용** | `sync_pkg_dmf0082.py` |
| `[E20261013-DMF0082ADJYNALL]` `PKG_DMF0082` BODY | 10-13 09:59 | **누락 → 적용** | `sync_pkg_dmf0082.py` |
| `[E20261013-DMF0020PERIODCOLS]` `PKG_DMF0020` BODY | (구 DB 미적용) | 10-13 10:43 다른 세션이 신규 DB 에 직접 적용 | 없음 |

## 신규 DB 에 실행한 작업
| 시각 | 작업 | 결과 |
|---|---|---|
| 10:32 | `PKG_DMF0082` BODY — 신규 DB 원문(LAST_DDL 10-12 21:52:20) 위에 치환 2건 | FRESH-GATE PASS · 결과 == 구 DB 원문(md5 동일) · VALID · USER_ERRORS 0 · INVALID 6 → 6 |
| 10:38 | `SCM_MST_SHEET_COLUMNS` SCP0009 `COLUMN_WIDTH` 12행 UPDATE | **10:48 원복** (사용자 작업 아님) — 적용 직전 값과 동일 확인 |
| 10:44 | `CREATE SYNONYM SCMP_APP.X` 15건 (GT_0080_* 13 · PKG_SCP0002 · PKG_SCP0080) | **10:48 DROP** (사용자 작업 아님) — 잔존 0 |

원복 스크립트 `99_revert_non_user_items.py`. 백업 `00_BACKUP_PKG_DMF0082_BODY.sql` (신규 DB 적용 전 원문).
최종적으로 신규 DB 에 남은 변경 = `PKG_DMF0082` BODY 1건.

## 손대지 않은 신·구 차이 (타 작업자분 · 참고)
- 신규 DB 가 앞선 것: `PR_SCM_MST_PROJECTBOM` · `PR_SCM_MST_PROJECT_DV_MASTER` · `PR_SCM_MST_PROJECT_SCHEDULE`(10-13 01:01), 인덱스 `IX01_SCM_MST_PROJECT_MAPPING`, `GT_DMF0053_EDI_CALLOFF.DIVISION_ID` 폭.
- 구 DB 에만 있는 것: SCP0080·SCP0002 계열 이름 15개의 시노님(구 = PUBLIC, 09-12 생성), SCP0009 컬럼 폭 12행(10-13 10:07~10:10), 백업·임시 테이블 62개.

## 미실행
- 신규 DB 에서 저장 SP 실호출·화면 확인 미실행. BE 미기동 상태(8080 free)라 재기동도 하지 않음.
- 구 DB 에는 `PKG_DMF0020` PERIODCOLS 가 없다(신규 DB 에만 적용됨).
