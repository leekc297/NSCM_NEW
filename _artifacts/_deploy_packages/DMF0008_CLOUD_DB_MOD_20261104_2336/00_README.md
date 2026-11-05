# DMF0008 클라우드 이관 패키지(DB)(수정본)

- 생성 2026-11-04 23:36 · tools/CloudPkg/cloud_pkg.py 1.1.0 (결정적 빌더 — Claude 미사용)
- 원천 사내 ZIOUI1 (SERVER_HOST=localhost) 조회 2026-11-04 23:36:14 — SOURCE-FRESH
- 이관 범위 = 수정본 — 이관 기준선이 없어 화면 소유 전부(모든 SQL 멱등)
- 사내 리허설 = OK

## 실행 순서 (클라우드, SCM_MGR, 파일마다 전체 F5)

1. `A_DB/00_PRECHECK_CLOUD.sql` — 사전 확인(읽기 전용) — 공용 객체 누락·컬럼 누락이 있으면 멈추고 전달
1. `A_DB/05_BACKUP_CLOUD.sql` — 현재 상태 백업(ZB_* 표) — 원복 대비
1. `A_DB/10_DDL_DMF0008.sql` — GTT 구조 동기화·테이블/SEQUENCE 생성
1. `A_DB/20_PKG_DMF0008_GET_EDI_MST_REPAIR.sql` — PKG/코드 전체 원문
1. `A_DB/20_PKG_DMF0008_GET_EDI_MST_SUMMARY.sql` — PKG/코드 전체 원문
1. `A_DB/20_PKG_DMF0008_GET_SALES_SITE.sql` — PKG/코드 전체 원문
1. `A_DB/20_PKG_DMF0008_GET_SALES_SITE_PROJECT_MODEL.sql` — PKG/코드 전체 원문
1. `A_DB/20_PKG_DMF0008_GET_UPDATE_HISTORY.sql` — PKG/코드 전체 원문
1. `A_DB/20_PKG_DMF0008_SAVE_SALES_SITE_EDI_REPAIR.sql` — PKG/코드 전체 원문
1. `A_DB/20_PKG_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR.sql` — PKG/코드 전체 원문
1. `A_DB/20_PKG_PKG_DMF0008.sql` — PKG/코드 전체 원문
1. `A_DB/30_META_DMF0008.sql` — META·문구·콤보
1. `A_DB/40_GRANT_DMF0008.sql` — 권한·시노님
1. `A_DB/90_VERIFY.sql` — 확인(읽기 전용)
1. `A_DB/99_ROLLBACK.sql` — 원복(문제 시에만)

## 이관 축 점검표

| 축 | 대상 | 이관 | 구분 | 근거 |
|---|---|---|---|---|
| PKG/코드 | PACKAGE PKG_DMF0008 | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-10-14 14:43:23 |
| PKG/코드 | PROCEDURE DMF0008_GET_EDI_MST_REPAIR | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-10-13 14:15:10 |
| PKG/코드 | PROCEDURE DMF0008_GET_EDI_MST_SUMMARY | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-10-13 14:15:10 |
| PKG/코드 | PROCEDURE DMF0008_GET_SALES_SITE | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-11-04 14:48:20 |
| PKG/코드 | PROCEDURE DMF0008_GET_SALES_SITE_PROJECT_MODEL | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-11-04 14:48:20 |
| PKG/코드 | PROCEDURE DMF0008_GET_UPDATE_HISTORY | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-10-09 13:38:34 |
| PKG/코드 | PROCEDURE DMF0008_SAVE_SALES_SITE_EDI_REPAIR | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-11-04 15:39:16 |
| PKG/코드 | PROCEDURE DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-11-04 14:48:20 |
| PKG/코드 | PACKAGE BODY PKG_DMF0008 | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-11-04 23:35:06 |
| GTT | GT_GSSI_DMF0008_RESULT_TABLE_1 | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_GSSI_DMF0008_RESULT_TABLE_1_2 | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_GSSI_DMF0008_RESULT_TABLE_2 | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_GSSI_DMF0008_RESULT_TABLE_2_2 | 포함 | 화면 전용 | 구조 동기화 |
| META | SCM_ADM_MNU_M (메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)) | 1/1행 | 공용·권한·메뉴 | insert · 키 MNU_ID (PK) |
| META | SCM_ADM_API_M (화면 전용 API) | 0/0행 | 화면 전용 | upsert · 키 API_ID (PK) |
| META | SCM_ADM_API_M (공용 API(이 화면 버튼이 씀)) | 13/13행 | 공용·권한·메뉴 | insert · 키 API_ID (PK) |
| META | SCM_ADM_MNU_BTN_MPG_M (버튼 → API 매핑) | 20/20행 | 화면 전용 | upsert · 키 MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_ADM_PROC_M (화면 PKG 프로시저 파라미터) | 73/73행 | 화면 전용 | upsert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_PROC_M (공용 프로시저 파라미터) | 2/2행 | 공용·권한·메뉴 | insert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_USER_GR_MNU_MPG_M (그룹 메뉴 권한) | 8/8행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID (PK) |
| META | SCM_ADM_USER_GR_MNU_BTN_MPG_M (그룹 버튼 권한) | 140/140행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_MST_SHEET_COLUMNS (시트 컬럼) | 121/121행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME, COLUMN_NAME (유일 키 실측(PK 없음)) |
| META | SCM_MST_SHEET_MEASURE (시트 Measure) | 0/0행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME (유일 키 실측(PK 없음)) |
| META | SCM_ADM_MSG_M (문구(MSG/LBL/MNU) — INSERT NOT EXISTS 전용(#140)) | 57/57행 | 공용·권한·메뉴 | insert · 키 MSG_ID, LANG_CD (논리 키(MSG_ID, LANG_CD)) |
| META | SCM_ADM_CMBO_SQL_M (콤보 SQL(공용) — 없을 때만) | 38/38행 | 공용·권한·메뉴 | insert · 키 SQL_ID, MDU_DIVS_CD (PK) |
| 공용 참조 | PROCEDURE SCM_MGR.DMF0000_GET_UPDATE_HISTORY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:36 |
| 공용 참조 | TABLE SCM_MGR.DM_DNM_EDI_CALLOFF_ITEM | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-01 02:49:13 |
| 공용 참조 | TABLE SCM_MGR.DM_MST_CUSTOMER_MODEL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-01 03:21:18 |
| 공용 참조 | VIEW SCM_MGR.DM_MST_ITEM_SINGLE_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:41 |
| 공용 참조 | FUNCTION SCM_MGR.FN_GET_DEPT_LIST | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:33 |
| 공용 참조 | FUNCTION SCM_MGR.FN_GET_DEPT_LIST2 | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-04 14:48:19 |
| 공용 참조 | FUNCTION SCM_MGR.FN_GET_MULTI_OWNER_NAME | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | PACKAGE SCM_MGR.PKG_DMF0000 | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-27 15:15:38 |
| 공용 참조 | PACKAGE SCM_MGR.PKG_SCM_USER_MNU | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:39:33 |
| 공용 참조 | PROCEDURE SCM_MGR.PR_DM_DNM_EDI_CALLOFF_STATUS | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-22 18:51:20 |
| 공용 참조 | PROCEDURE SCM_MGR.PR_DM_MST_SITE_CUSTOMER_HIST | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:34 |
| 공용 참조 | PROCEDURE SCM_MGR.PR_SCM_SYS_LOG_BATCH | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:36 |
| 공용 참조 | TABLE SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-29 08:59:48 |
| 공용 참조 | TABLE SCM_MGR.SCM_ADM_USER_M | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 21:19:22 |
| 공용 참조 | FUNCTION SCM_MGR.SCM_ARR_SPL_CNT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | FUNCTION SCM_MGR.SCM_ARR_SPL_VAL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:33 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_CITY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 02:05:59 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_COUNTRY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 02:06:00 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_CUSTOMER | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 02:06:04 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_PROJECT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:29:18 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SITE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-04 15:39:14 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SITE_CUSTOMER | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 02:43:06 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SITE_H | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-04 15:39:14 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SITE_ITEM | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-04 14:48:19 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SITE_ITEM_H | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-04 14:48:19 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SSO_DEPT_INFO | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:29:49 |
| 공용 참조 | TABLE SCM_MGR.SCM_SYS_LOG_BATCH | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:05 |
| 공용 참조 | SEQUENCE SCM_MGR.SEQ1_SCM_MST_SITE_H | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-03 09:51:44 |
| 공용 참조 | SEQUENCE SCM_MGR.SEQ1_SCM_MST_SITE_ITEM_H | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-10 08:27:00 |

## 사내 리허설 (DRY·ROLLBACK — 사내 변경 없음)

| 파일 | 문장 | 실패 | 요약 |
|---|---|---|---|
| 00_PRECHECK_CLOUD.sql | 15 | 0 | SELECT 13행 · SELECT 0행 · SELECT 0행 · SELECT 0행 · SELECT 1행 — [('Demand_Master', 'Y')] · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 1)] |
| 05_BACKUP_CLOUD.sql | 1 | 0 |  |
| 10_DDL_DMF0008.sql | 1 | 0 | > RESULT  CREATE=0  REBUILD=0  SKIP=4 |
| 20_PKG_DMF0008_GET_EDI_MST_REPAIR.sql | 3 | 0 | 컴파일 생략(사내 원문 그대로) · 문장 분할 확인 |
| 20_PKG_DMF0008_GET_EDI_MST_SUMMARY.sql | 3 | 0 | 컴파일 생략(사내 원문 그대로) · 문장 분할 확인 |
| 20_PKG_DMF0008_GET_SALES_SITE.sql | 3 | 0 | 컴파일 생략(사내 원문 그대로) · 문장 분할 확인 |
| 20_PKG_DMF0008_GET_SALES_SITE_PROJECT_MODEL.sql | 3 | 0 | 컴파일 생략(사내 원문 그대로) · 문장 분할 확인 |
| 20_PKG_DMF0008_GET_UPDATE_HISTORY.sql | 3 | 0 | 컴파일 생략(사내 원문 그대로) · 문장 분할 확인 |
| 20_PKG_DMF0008_SAVE_SALES_SITE_EDI_REPAIR.sql | 3 | 0 | 컴파일 생략(사내 원문 그대로) · 문장 분할 확인 |
| 20_PKG_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR.sql | 3 | 0 | 컴파일 생략(사내 원문 그대로) · 문장 분할 확인 |
| 20_PKG_PKG_DMF0008.sql | 4 | 0 | 컴파일 생략(사내 원문 그대로) · 문장 분할 확인 |
| 30_META_DMF0008.sql | 267 | 0 | 사내 기준 변경 행 0 (0 이 정상 — 사내가 원천) · COMMIT → ROLLBACK(리허설) |
| 40_GRANT_DMF0008.sql | 1 | 0 | > GRANT   DEBUG, EXECUTE ON DMF0008_GET_SALES_SITE TO RL_SCM_DML · > GRANT   EXECUTE ON DMF0008_GET_SALES_SITE TO RL_SCM_SEL · > GRANT   DEBUG, EXECUTE ON DMF0008_GET_SALES_SITE_PROJECT_MODEL TO RL_SCM_DML · > GRANT   EXECUTE ON DMF0008_GET_SALES_SITE_PROJECT_MODEL TO RL_SCM_SEL · > GRANT   DEBUG, EXECUTE ON DMF0008_SAVE_SALES_SITE_EDI_REPAIR TO RL_SCM_DML · > GRANT   EXECUTE ON DMF0008_SAVE_SALES |
| 90_VERIFY.sql | 18 | 0 | SELECT 9행 · SELECT 0행 · SELECT 0행 · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 0)] · SELECT 1행 — [('SCM_ADM_API_M', '공용 API(이 화면 버튼이 씀)', 13, 0)] · SELECT 1행 — [('SCM_ADM_MNU_BTN_MPG_M', '버튼 → API 매핑', 20, 0)] |
| 99_ROLLBACK.sql | 2 | 0 | > META    SCM_ADM_MNU_M 삭제 1 · 복원 1 · > META    SCM_ADM_API_M 삭제 13 · 복원 13 · > META    SCM_ADM_MNU_BTN_MPG_M 삭제 20 · 복원 20 · > META    SCM_ADM_PROC_M 삭제 73 · 복원 73 · > META    SCM_ADM_PROC_M 삭제 2 · 복원 2 · > META    SCM_ADM_USER_GR_MNU_MPG_M 삭제 8 · 복원 8 |
| (정리) | 14 | 0 | 리허설 백업표 14개 삭제 |

## 백업 표 정리 (클라우드 적용·확인 후)

```sql
BEGIN FOR t IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'ZB\_DMF0008_202611042336\_%' ESCAPE '\') LOOP EXECUTE IMMEDIATE 'DROP TABLE ' || t.TABLE_NAME || ' PURGE'; END LOOP; END;
/
```
