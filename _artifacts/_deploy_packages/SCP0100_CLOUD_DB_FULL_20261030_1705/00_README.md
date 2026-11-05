# SCP0100 클라우드 이관 패키지(DB) — 전체

- 생성 2026-10-30 17:02 · tools/CloudPkg/cloud_pkg.py 1.0.0 (결정적 빌더 — Claude 미사용)
- 원천 사내 ZIOUI1 (SERVER_HOST=localhost) 조회 2026-10-30 17:03:00 — SOURCE-FRESH
- 이관 범위 = 전체 — 화면 소유 DB 객체·META 전부 + FE·BE 없음 (모든 SQL 멱등)
- 사내 리허설 = OK

## 실행 순서 (클라우드, SCM_MGR, 파일마다 전체 F5)

1. `A_DB/00_PRECHECK_CLOUD.sql` — 사전 확인(읽기 전용) — 공용 객체 누락·컬럼 누락이 있으면 멈추고 전달
1. `A_DB/05_BACKUP_CLOUD.sql` — 현재 상태 백업(ZB_* 표) — 원복 대비
1. `A_DB/10_DDL_SCP0100.sql` — GTT 구조 동기화·테이블/SEQUENCE 생성
1. `A_DB/20_PKG_PKG_SCP0100.sql` — PKG/코드 전체 원문
1. `A_DB/30_META_SCP0100.sql` — META·문구·콤보
1. `A_DB/40_GRANT_SCP0100.sql` — 권한·시노님
1. `A_DB/90_VERIFY.sql` — 확인(읽기 전용)
1. `A_DB/99_ROLLBACK.sql` — 원복(문제 시에만)

## 이관 축 점검표

| 축 | 대상 | 이관 | 구분 | 근거 |
|---|---|---|---|---|
| PKG/코드 | PACKAGE PKG_SCP0100 | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-10-09 13:38:32 |
| PKG/코드 | PACKAGE BODY PKG_SCP0100 | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-10-16 09:42:30 |
| GTT | GT_SCP0100_ALL | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_ALL_DISPLAY_SEQ | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_ALL_MEASURE_UI | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_ALL_VARIOUS_KEY | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_CELL_GROUP_SORT_ORDER | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_DAYCOLS | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_DIO_DETAIL_RAW | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_FINAL | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_LINE | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_MEASURE | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_MEASURE1 | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_MEASURE2 | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_MEASURE3 | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_OPERATION | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_PRODUCTLEVEL | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_QTY_AUTO | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_QTY_CELL_GROUP | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_QTY_CELL_GROUP_DETAIL | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_QTY_DETAIL | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_QTY_PRODUCT_LEVEL1 | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_QTY_PRODUCT_LEVEL2 | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_QTY_PRODUCT_LEVEL3 | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_RAW | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_RAW_CELL_CF | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_TRANSPORT_MODE_CODE | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0100_USER_COLS | 포함 | 화면 전용 | 구조 동기화 |
| META | SCM_ADM_MNU_M (메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)) | 1/1행 | 공용·권한·메뉴 | insert · 키 MNU_ID (PK) |
| META | SCM_ADM_API_M (화면 전용 API) | 0/0행 | 화면 전용 | upsert · 키 API_ID (PK) |
| META | SCM_ADM_API_M (공용 API(이 화면 버튼이 씀)) | 4/4행 | 공용·권한·메뉴 | insert · 키 API_ID (PK) |
| META | SCM_ADM_MNU_BTN_MPG_M (버튼 → API 매핑) | 9/9행 | 화면 전용 | upsert · 키 MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_ADM_PROC_M (화면 PKG 프로시저 파라미터) | 33/33행 | 화면 전용 | upsert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_PROC_M (공용 프로시저 파라미터) | 0/0행 | 공용·권한·메뉴 | insert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_USER_GR_MNU_MPG_M (그룹 메뉴 권한) | 5/5행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID (PK) |
| META | SCM_ADM_USER_GR_MNU_BTN_MPG_M (그룹 버튼 권한) | 45/45행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_MST_SHEET_COLUMNS (시트 컬럼) | 36/36행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME, COLUMN_NAME (유일 키 실측(PK 없음)) |
| META | SCM_MST_SHEET_MEASURE (시트 Measure) | 36/36행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME, COLUMN_NAME (유일 키 실측(PK 없음)) |
| META | SCM_ADM_MSG_M (문구(MSG/LBL/MNU) — INSERT NOT EXISTS 전용(#140)) | 75/75행 | 공용·권한·메뉴 | insert · 키 MSG_ID, LANG_CD (논리 키(MSG_ID, LANG_CD)) |
| META | SCM_ADM_CMBO_SQL_M (콤보 SQL(공용) — 없을 때만) | 7/7행 | 공용·권한·메뉴 | insert · 키 SQL_ID, MDU_DIVS_CD (PK) |
| 공용 참조 | FUNCTION SCM_MGR.FN_CHAR_TO_DATE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | FUNCTION SCM_MGR.FN_GET_REPORT_USER_COLUMNS | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | FUNCTION SCM_MGR.FN_SPLITSTRING | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | TABLE SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-29 08:59:48 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_MST_ITEM_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SHEET_COLUMNS | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-13 09:50:17 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SHEET_MEASURE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-13 09:50:22 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_TITLESET_USER | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 21:19:15 |
| 공용 참조 | TABLE SCM_MGR.SCM_SYS_CALENDAR_M | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 21:19:12 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_FINAL_ITEM | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-15 11:00:26 |
| 공용 참조 | VIEW SCM_MGR.SCP_PLAN_VERSION_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:41 |
| 공용 참조 | TABLE SCM_MGR.SCP_PLN_INTERFACE_YN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 21:19:19 |
| 공용 참조 | TABLE SCM_MGR.SCP_RPT_GLOBAL_PSI_MD_DETAIL_MM | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-30 13:14:05 |
| 공용 참조 | TABLE SCM_MGR.SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-30 13:14:05 |
| 공용 참조 | TABLE SCM_MGR.SCP_RPT_GLOBAL_PSI_MD_MM | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 21:19:11 |
| 공용 참조 | TABLE SCM_MGR.SCP_RPT_GLOBAL_PSI_MD_WW | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 21:19:11 |

이름에 화면 ID 가 있지만 백업·임시 사본으로 보고 제외: SCM_ADM_PROC_M_BAK20261007_SCP0100

## 사내 리허설 (DRY·ROLLBACK — 사내 변경 없음)

| 파일 | 문장 | 실패 | 요약 |
|---|---|---|---|
| 00_PRECHECK_CLOUD.sql | 15 | 0 | SELECT 28행 · SELECT 0행 · SELECT 0행 · SELECT 0행 · SELECT 1행 — [('Supply_Plan', 'Y')] · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 1)] |
| 05_BACKUP_CLOUD.sql | 1 | 0 |  |
| 10_DDL_SCP0100.sql | 1 | 0 | > RESULT  CREATE=0  REBUILD=0  SKIP=26 |
| 20_PKG_PKG_SCP0100.sql | 4 | 0 | 컴파일 생략(사내 원문 그대로) · 문장 분할 확인 |
| 30_META_SCP0100.sql | 142 | 0 | 사내 기준 변경 행 0 (0 이 정상 — 사내가 원천) · COMMIT → ROLLBACK(리허설) |
| 40_GRANT_SCP0100.sql | 1 | 0 | > GRANT   DELETE, INSERT, SELECT, UPDATE ON GT_SCP0100_ALL TO RL_SCM_DML · > GRANT   SELECT ON GT_SCP0100_ALL TO RL_SCM_SEL · > GRANT   DELETE, INSERT, SELECT, UPDATE ON GT_SCP0100_ALL_DISPLAY_SEQ TO RL_SCM_DML · > GRANT   SELECT ON GT_SCP0100_ALL_DISPLAY_SEQ TO RL_SCM_SEL · > GRANT   DELETE, INSERT, SELECT, UPDATE ON GT_SCP0100_ALL_MEASURE_UI TO RL_SCM_DML · > GRANT   SELECT ON GT_SCP0100_ALL_MEA |
| 90_VERIFY.sql | 18 | 0 | SELECT 2행 — [('PKG_SCP0100', 'PACKAGE', 'VALID'), ('PKG_SCP0100', 'PACKAGE BODY', 'VALID')] · SELECT 0행 · SELECT 0행 · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 0)] · SELECT 1행 — [('SCM_ADM_API_M', '공용 API(이 화면 버튼이 씀)', 4, 0)] · SELECT 1행 — [('SCM_ADM_MNU_BTN_MPG_M', '버튼 → API 매핑', 9, 0)] |
| 99_ROLLBACK.sql | 2 | 0 | > META    SCM_ADM_MNU_M 삭제 1 · 복원 1 · > META    SCM_ADM_API_M 삭제 4 · 복원 4 · > META    SCM_ADM_MNU_BTN_MPG_M 삭제 9 · 복원 9 · > META    SCM_ADM_PROC_M 삭제 33 · 복원 33 · > META    SCM_ADM_USER_GR_MNU_MPG_M 삭제 5 · 복원 5 · > META    SCM_ADM_USER_GR_MNU_BTN_MPG_M 삭제 45 · 복원 45 |
| (정리) | 14 | 0 | 리허설 백업표 14개 삭제 |

## 백업 표 정리 (클라우드 적용·확인 후)

```sql
BEGIN FOR t IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'ZB\_SCP0100_202610301704\_%' ESCAPE '\') LOOP EXECUTE IMMEDIATE 'DROP TABLE ' || t.TABLE_NAME || ' PURGE'; END LOOP; END;
/
```
