# SCP0016 클라우드 이관 패키지(DB)(수정본)

- 생성 2026-11-06 22:30 · tools/CloudPkg/cloud_pkg.py 1.1.0 (결정적 빌더 — Claude 미사용)
- 원천 사내 ZIOUI1 (SERVER_HOST=localhost) 조회 2026-11-06 22:30:22 — SOURCE-FRESH
- 이관 범위 = 수정본 — 이관 기준선이 없어 화면 소유 전부(모든 SQL 멱등)
- 사내 리허설 = OK

## 실행 순서 (클라우드, SCM_MGR, 파일마다 전체 F5)

1. `A_DB/00_PRECHECK_CLOUD.sql` — 사전 확인(읽기 전용) — 공용 객체 누락·컬럼 누락이 있으면 멈추고 전달
1. `A_DB/05_BACKUP_CLOUD.sql` — 현재 상태 백업(ZB_* 표) — 원복 대비
1. `A_DB/10_DDL_SCP0016.sql` — GTT 구조 동기화·테이블/SEQUENCE 생성
1. `A_DB/20_PKG_PKG_SCP0016.sql` — PKG/코드 전체 원문
1. `A_DB/25_SHARED_SCP_OPT_PLANT_ONHAND_V_SEQGUARD_SCP0016.sql` — 공용 객체 이 화면 몫 패치
1. `A_DB/25_SHARED_SCP_PLN_SALES_ONHAND_V_SEQGUARD_SCP0016.sql` — 공용 객체 이 화면 몫 패치
1. `A_DB/30_META_SCP0016.sql` — META·문구·콤보
1. `A_DB/40_GRANT_SCP0016.sql` — 권한·시노님
1. `A_DB/90_VERIFY.sql` — 확인(읽기 전용)
1. `A_DB/99_ROLLBACK.sql` — 원복(문제 시에만)

## 이관 축 점검표

| 축 | 대상 | 이관 | 구분 | 근거 |
|---|---|---|---|---|
| PKG/코드 | PACKAGE PKG_SCP0016 | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-11-04 13:21:30 |
| PKG/코드 | PACKAGE BODY PKG_SCP0016 | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-11-04 13:32:02 |
| GTT | GT_SCP0016_BOD | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0016_DATA1 | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0016_PIVOT | 포함 | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0016_VER | 포함 | 화면 전용 | 구조 동기화 |
| META | SCM_ADM_MNU_M (메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)) | 1/1행 | 공용·권한·메뉴 | insert · 키 MNU_ID (PK) |
| META | SCM_ADM_API_M (화면 전용 API) | 0/0행 | 화면 전용 | upsert · 키 API_ID (PK) |
| META | SCM_ADM_API_M (공용 API(이 화면 버튼이 씀)) | 3/3행 | 공용·권한·메뉴 | insert · 키 API_ID (PK) |
| META | SCM_ADM_MNU_BTN_MPG_M (버튼 → API 매핑) | 4/4행 | 화면 전용 | upsert · 키 MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_ADM_PROC_M (화면 PKG 프로시저 파라미터) | 29/29행 | 화면 전용 | upsert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_PROC_M (공용 프로시저 파라미터) | 8/8행 | 공용·권한·메뉴 | insert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_USER_GR_MNU_MPG_M (그룹 메뉴 권한) | 14/14행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID (PK) |
| META | SCM_ADM_USER_GR_MNU_BTN_MPG_M (그룹 버튼 권한) | 44/44행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_MST_SHEET_COLUMNS (시트 컬럼) | 28/28행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME, COLUMN_NAME (유일 키 실측(PK 없음)) |
| META | SCM_MST_SHEET_MEASURE (시트 Measure) | 8/8행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME, COLUMN_NAME (유일 키 실측(PK 없음)) |
| META | SCM_ADM_MSG_M (문구(MSG/LBL/MNU) — INSERT NOT EXISTS 전용(#140)) | 78/78행 | 공용·권한·메뉴 | insert · 키 MSG_ID, LANG_CD (논리 키(MSG_ID, LANG_CD)) |
| META | SCM_ADM_CMBO_SQL_M (콤보 SQL(공용) — 없을 때만) | 9/9행 | 공용·권한·메뉴 | insert · 키 SQL_ID, MDU_DIVS_CD (PK) |
| 공용 참조 | FUNCTION SCM_MGR.FN_GET_DIVISION_DIV | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | FUNCTION SCM_MGR.FN_GET_ITEM_LIKE_CONDITION | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SHEET_MEASURE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-13 09:50:22 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_TITLESET_USER | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 21:19:15 |
| 공용 참조 | TABLE SCM_MGR.SCM_SYS_CALENDAR_M | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:29:50 |
| 공용 참조 | TABLE SCM_MGR.SCM_SYS_LOG_BATCH | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:05 |
| 공용 참조 | TABLE SCM_MGR.SCP_ANL_SHIPMENT_PLAN_FG_C | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 21:19:15 |
| 공용 참조 | VIEW SCM_MGR.SCP_MST_BOD_N_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:41 |
| 공용 참조 | FUNCTION SCM_MGR.STRING_SPLIT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:33 |
| 공용 참조 | TYPE SCM_MGR.T_STR_TAB | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:23 |
| 공용 참조 | FUNCTION SCM_MGR.FN_ASIS_SORT_KEY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:33 |
| 공용 참조 | FUNCTION SCM_MGR.FN_GET_LOOKUP_CODE_DESC | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | FUNCTION SCM_MGR.FN_GET_SCP_ANL_BOH_QTY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-06 22:23:46 |
| 공용 참조 | FUNCTION SCM_MGR.FN_GET_SITE_NAME_SHIPMENT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_PROJECT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:29:18 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SITE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-04 15:39:14 |
| 공용 참조 | VIEW SCM_MGR.SCM_MST_SITE_DEPT_REP_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:41 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SSO_DEPT_INFO | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:29:49 |
| 공용 참조 | VIEW SCM_MGR.SCP_OPT_PLANT_ONHAND_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-06 22:23:45 |
| 공용 참조 | TABLE SCM_MGR.SCP_PLN_SALES_ONHAND | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-10 00:02:51 |
| 공용 참조 | VIEW SCM_MGR.SCP_PLN_SALES_ONHAND_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-06 22:23:44 |
| 공용 패치 | SCP_OPT_PLANT_ONHAND_V_SEQGUARD_SCP0016.sql | 25_SHARED | 공용 — 이 화면 몫 | Doc/gen/SCP0016 패치 파일(H14) |
| 공용 패치 | SCP_PLN_SALES_ONHAND_V_SEQGUARD_SCP0016.sql | 25_SHARED | 공용 — 이 화면 몫 | Doc/gen/SCP0016 패치 파일(H14) |

이름에 화면 ID 가 있지만 백업·임시 사본으로 보고 제외: SCM_MST_SHEET_COL_SCP0016_BAK20261103

## ⚠ 공용 객체 변경 감지 — 이 화면 몫 패치 파일 없음

기준선 이후 사내에서 바뀐 공용 객체다. 이 화면 작업 때문이면 Doc/gen/SCP0016/<객체>_<멤버>_SCP0016.sql 로 이 화면 몫만 남기고 다시 만들 것(다른 작업자 변경일 수 있음 — 임의 포함 안 함).

- FUNCTION SCM_MGR.FN_GET_SCP_ANL_BOH_QTY · LAST_DDL 2026-11-06 22:23:46

## 사내 리허설 (DRY·ROLLBACK — 사내 변경 없음)

| 파일 | 문장 | 실패 | 요약 |
|---|---|---|---|
| 00_PRECHECK_CLOUD.sql | 15 | 0 | SELECT 6행 · SELECT 0행 · SELECT 0행 · SELECT 0행 · SELECT 1행 — [('Supply_Waterfall', 'Y')] · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 1)] |
| 05_BACKUP_CLOUD.sql | 1 | 0 |  |
| 10_DDL_SCP0016.sql | 1 | 0 | > RESULT  CREATE=0  REBUILD=0  SKIP=4 |
| 20_PKG_PKG_SCP0016.sql | 4 | 0 | 컴파일 생략(사내 원문 그대로) · 문장 분할 확인 |
| 25_SHARED_SCP_OPT_PLANT_ONHAND_V_SEQGUARD_SCP0016.sql | 1 | 0 | 컴파일 생략(사내 원문 그대로) · 문장 분할 확인 |
| 25_SHARED_SCP_PLN_SALES_ONHAND_V_SEQGUARD_SCP0016.sql | 1 | 0 | 컴파일 생략(사내 원문 그대로) · 문장 분할 확인 |
| 30_META_SCP0016.sql | 162 | 0 | 사내 기준 변경 행 0 (0 이 정상 — 사내가 원천) · COMMIT → ROLLBACK(리허설) |
| 40_GRANT_SCP0016.sql | 1 | 0 |  |
| 90_VERIFY.sql | 19 | 0 | SELECT 2행 — [('PKG_SCP0016', 'PACKAGE', 'VALID'), ('PKG_SCP0016', 'PACKAGE BODY', 'VALID')] · SELECT 0행 · SELECT 0행 · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 0)] · SELECT 1행 — [('SCM_ADM_API_M', '공용 API(이 화면 버튼이 씀)', 3, 0)] · SELECT 1행 — [('SCM_ADM_MNU_BTN_MPG_M', '버튼 → API 매핑', 4, 0)] |
| 99_ROLLBACK.sql | 2 | 0 | > META    SCM_ADM_MNU_M 삭제 1 · 복원 1 · > META    SCM_ADM_API_M 삭제 3 · 복원 3 · > META    SCM_ADM_MNU_BTN_MPG_M 삭제 4 · 복원 4 · > META    SCM_ADM_PROC_M 삭제 29 · 복원 29 · > META    SCM_ADM_PROC_M 삭제 8 · 복원 8 · > META    SCM_ADM_USER_GR_MNU_MPG_M 삭제 14 · 복원 14 |
| (정리) | 15 | 0 | 리허설 백업표 15개 삭제 |

## 백업 표 정리 (클라우드 적용·확인 후)

```sql
BEGIN FOR t IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'ZB\_SCP0016_202611062230\_%' ESCAPE '\') LOOP EXECUTE IMMEDIATE 'DROP TABLE ' || t.TABLE_NAME || ' PURGE'; END LOOP; END;
/
```
