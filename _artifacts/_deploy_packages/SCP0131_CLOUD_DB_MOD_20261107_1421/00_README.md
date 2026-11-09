# SCP0131 클라우드 이관 패키지(DB)(수정본)

- 생성 2026-11-07 14:21 · tools/CloudPkg/cloud_pkg.py 1.1.0 (결정적 빌더 — Claude 미사용)
- 원천 사내 ZIOUI1 (SERVER_HOST=localhost) 조회 2026-11-07 14:21:48 — SOURCE-FRESH
- 이관 범위 = 수정본 — 이관 기준선이 없어 화면 소유 전부(모든 SQL 멱등)
- 사내 리허설 = OK

## 실행 순서 (클라우드, SCM_MGR, 파일마다 전체 F5)

1. `A_DB/00_PRECHECK_CLOUD.sql` — 사전 확인(읽기 전용) — 공용 객체 누락·컬럼 누락이 있으면 멈추고 전달
1. `A_DB/05_BACKUP_CLOUD.sql` — 현재 상태 백업(ZB_* 표) — 원복 대비
1. `A_DB/20_PKG_PKG_SCP0131.sql` — PKG/코드 전체 원문
1. `A_DB/30_META_SCP0131.sql` — META·문구·콤보
1. `A_DB/40_GRANT_SCP0131.sql` — 권한·시노님
1. `A_DB/90_VERIFY.sql` — 확인(읽기 전용)
1. `A_DB/99_ROLLBACK.sql` — 원복(문제 시에만)

## 이관 축 점검표

| 축 | 대상 | 이관 | 구분 | 근거 |
|---|---|---|---|---|
| PKG/코드 | PACKAGE PKG_SCP0131 | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-10-09 13:38:31 |
| PKG/코드 | PACKAGE BODY PKG_SCP0131 | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-11-07 07:38:34 |
| META | SCM_ADM_MNU_M (메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)) | 1/1행 | 공용·권한·메뉴 | insert · 키 MNU_ID (PK) |
| META | SCM_ADM_API_M (화면 전용 API) | 0/0행 | 화면 전용 | upsert · 키 API_ID (PK) |
| META | SCM_ADM_API_M (공용 API(이 화면 버튼이 씀)) | 2/2행 | 공용·권한·메뉴 | insert · 키 API_ID (PK) |
| META | SCM_ADM_MNU_BTN_MPG_M (버튼 → API 매핑) | 4/4행 | 화면 전용 | upsert · 키 MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_ADM_PROC_M (화면 PKG 프로시저 파라미터) | 29/29행 | 화면 전용 | upsert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_PROC_M (공용 프로시저 파라미터) | 0/0행 | 공용·권한·메뉴 | insert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_USER_GR_MNU_MPG_M (그룹 메뉴 권한) | 3/3행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID (PK) |
| META | SCM_ADM_USER_GR_MNU_BTN_MPG_M (그룹 버튼 권한) | 12/12행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_MST_SHEET_COLUMNS (시트 컬럼) | 14/14행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME, COLUMN_NAME (유일 키 실측(PK 없음)) |
| META | SCM_MST_SHEET_MEASURE (시트 Measure) | 0/0행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME (유일 키 실측(PK 없음)) |
| META | SCM_ADM_MSG_M (문구(MSG/LBL/MNU) — INSERT NOT EXISTS 전용(#140)) | 60/60행 | 공용·권한·메뉴 | insert · 키 MSG_ID, LANG_CD (논리 키(MSG_ID, LANG_CD)) |
| META | SCM_ADM_CMBO_SQL_M (콤보 SQL(공용) — 없을 때만) | 7/7행 | 공용·권한·메뉴 | insert · 키 SQL_ID, MDU_DIVS_CD (PK) |
| 공용 참조 | FUNCTION SCM_MGR.FN_ASIS_SORT_KEY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:33 |
| 공용 참조 | PROCEDURE SCM_MGR.PR_SCM_SYS_LOG_BATCH | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:36 |
| 공용 참조 | FUNCTION SCM_MGR.SCM_ARR_SPL_CNT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | FUNCTION SCM_MGR.SCM_ARR_SPL_VAL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:33 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_MST_ITEM_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | TABLE SCM_MGR.SCM_SYS_LOG_BATCH | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:05 |
| 공용 참조 | TABLE SCM_MGR.SCP_OPMZ_SALES_SITE_PRIORITY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:22:21 |
| 공용 참조 | TABLE SCM_MGR.SCP_OPMZ_VIRTUAL_BOM | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:22:25 |
| 공용 참조 | FUNCTION SCM_MGR.STRING_SPLIT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:33 |
| 공용 참조 | PACKAGE SCM_MGR.PKG_SCP0127 | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-06 23:16:32 |

이름에 화면 ID 가 있지만 백업·임시 사본으로 보고 제외: SCM_MST_SHEET_COLUMNS_BAK20260926_SCP0131, SCM_MST_SHEET_COLUMNS_BAK20261007_SCP0131

## ⚠ 공용 객체 변경 감지 — 이 화면 몫 패치 파일 없음

기준선 이후 사내에서 바뀐 공용 객체다. 이 화면 작업 때문이면 Doc/gen/SCP0131/<객체>_<멤버>_SCP0131.sql 로 이 화면 몫만 남기고 다시 만들 것(다른 작업자 변경일 수 있음 — 임의 포함 안 함).

- PACKAGE SCM_MGR.PKG_SCP0127 · LAST_DDL 2026-11-06 23:16:32

## 사내 리허설 (DRY·ROLLBACK — 사내 변경 없음)

| 파일 | 문장 | 실패 | 요약 |
|---|---|---|---|
| 00_PRECHECK_CLOUD.sql | 15 | 0 | SELECT 2행 — [('PKG_SCP0131', 'PACKAGE', 'VALID', '2026-10-09 13:38'), ('PKG_SCP0131', 'PACKAGE BODY', 'VALID', '2026-11-07 07:38')] · SELECT 0행 · SELECT 0행 · SELECT 0행 · SELECT 1행 — [('Supply_OPT_Plan', 'Y')] · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 1)] |
| 05_BACKUP_CLOUD.sql | 1 | 0 |  |
| 20_PKG_PKG_SCP0131.sql | 4 | 0 | 컴파일 생략(사내 원문 그대로) · 문장 분할 확인 |
| 30_META_SCP0131.sql | 89 | 0 | 사내 기준 변경 행 0 (0 이 정상 — 사내가 원천) · COMMIT → ROLLBACK(리허설) |
| 40_GRANT_SCP0131.sql | 1 | 0 |  |
| 90_VERIFY.sql | 16 | 0 | SELECT 2행 — [('PKG_SCP0131', 'PACKAGE', 'VALID'), ('PKG_SCP0131', 'PACKAGE BODY', 'VALID')] · SELECT 0행 · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 0)] · SELECT 1행 — [('SCM_ADM_API_M', '공용 API(이 화면 버튼이 씀)', 2, 0)] · SELECT 1행 — [('SCM_ADM_MNU_BTN_MPG_M', '버튼 → API 매핑', 4, 0)] · SELECT 1행 — [('SCM_ADM_PROC_M', '화면 PKG 프로시저 파라미터', 29, 0)] |
| 99_ROLLBACK.sql | 2 | 0 | > META    SCM_ADM_MNU_M 삭제 1 · 복원 1 · > META    SCM_ADM_API_M 삭제 2 · 복원 2 · > META    SCM_ADM_MNU_BTN_MPG_M 삭제 4 · 복원 4 · > META    SCM_ADM_PROC_M 삭제 29 · 복원 29 · > META    SCM_ADM_USER_GR_MNU_MPG_M 삭제 3 · 복원 3 · > META    SCM_ADM_USER_GR_MNU_BTN_MPG_M 삭제 12 · 복원 12 |
| (정리) | 11 | 0 | 리허설 백업표 11개 삭제 |

## 백업 표 정리 (클라우드 적용·확인 후)

```sql
BEGIN FOR t IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'ZB\_SCP0131_202611071421\_%' ESCAPE '\') LOOP EXECUTE IMMEDIATE 'DROP TABLE ' || t.TABLE_NAME || ' PURGE'; END LOOP; END;
/
```
