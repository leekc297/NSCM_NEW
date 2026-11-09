# SCP0125 클라우드 이관 패키지(DB) — 전체

- 생성 2026-11-06 17:50 · tools/CloudPkg/cloud_pkg.py 1.1.0 (결정적 빌더 — Claude 미사용)
- 원천 사내 ZIOUI1 (SERVER_HOST=localhost) 조회 2026-11-06 17:50:50 — SOURCE-FRESH
- 이관 범위 = 전체 — 화면 소유 DB 객체·META 전부 + FE·BE 없음 (모든 SQL 멱등)
- 사내 리허설 = OK

## 실행 순서 (클라우드, SCM_MGR, 파일마다 전체 F5)

1. `A_DB/00_PRECHECK_CLOUD.sql` — 사전 확인(읽기 전용) — 공용 객체 누락·컬럼 누락이 있으면 멈추고 전달
1. `A_DB/05_BACKUP_CLOUD.sql` — 현재 상태 백업(ZB_* 표) — 원복 대비
1. `A_DB/20_PKG_PKG_SCP0125.sql` — PKG/코드 전체 원문
1. `A_DB/30_META_SCP0125.sql` — META·문구·콤보
1. `A_DB/40_GRANT_SCP0125.sql` — 권한·시노님
1. `A_DB/90_VERIFY.sql` — 확인(읽기 전용)
1. `A_DB/99_ROLLBACK.sql` — 원복(문제 시에만)

## 이관 축 점검표

| 축 | 대상 | 이관 | 구분 | 근거 |
|---|---|---|---|---|
| PKG/코드 | PACKAGE PKG_SCP0125 | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-10-09 13:38:31 |
| PKG/코드 | PACKAGE BODY PKG_SCP0125 | 포함 | 화면 전용 | 사내 원문 전체 · LAST_DDL 2026-11-06 17:46:59 |
| META | SCM_ADM_MNU_M (메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)) | 1/1행 | 공용·권한·메뉴 | insert · 키 MNU_ID (PK) |
| META | SCM_ADM_API_M (화면 전용 API) | 15/15행 | 화면 전용 | upsert · 키 API_ID (PK) |
| META | SCM_ADM_API_M (공용 API(이 화면 버튼이 씀)) | 0/0행 | 공용·권한·메뉴 | insert · 키 API_ID (PK) |
| META | SCM_ADM_MNU_BTN_MPG_M (버튼 → API 매핑) | 43/43행 | 화면 전용 | upsert · 키 MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_ADM_PROC_M (화면 PKG 프로시저 파라미터) | 143/143행 | 화면 전용 | upsert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_PROC_M (공용 프로시저 파라미터) | 0/0행 | 공용·권한·메뉴 | insert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_USER_GR_MNU_MPG_M (그룹 메뉴 권한) | 4/4행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID (PK) |
| META | SCM_ADM_USER_GR_MNU_BTN_MPG_M (그룹 버튼 권한) | 172/172행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_MST_SHEET_COLUMNS (시트 컬럼) | 102/102행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME, COLUMN_NAME (유일 키 실측(PK 없음)) |
| META | SCM_MST_SHEET_MEASURE (시트 Measure) | 0/0행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME (유일 키 실측(PK 없음)) |
| META | SCM_ADM_MSG_M (문구(MSG/LBL/MNU) — INSERT NOT EXISTS 전용(#140)) | 90/90행 | 공용·권한·메뉴 | insert · 키 MSG_ID, LANG_CD (논리 키(MSG_ID, LANG_CD)) |
| META | SCM_ADM_CMBO_SQL_M (콤보 SQL(공용) — 없을 때만) | 16/16행 | 공용·권한·메뉴 | insert · 키 SQL_ID, MDU_DIVS_CD (PK) |
| 공용 참조 | TABLE SCM_MGR.DM_MST_VERSION | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-01 03:21:34 |
| 공용 참조 | TABLE SCM_MGR.DM_PLN_NET_DEMAND | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-03 19:13:02 |
| 공용 참조 | FUNCTION SCM_MGR.FN_GET_ITEM_OPERATION_GROUP | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | FUNCTION SCM_MGR.FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | FUNCTION SCM_MGR.FN_GET_LOOKUP_VALUE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:33 |
| 공용 참조 | TABLE SCM_MGR.GT_0125_CELL_PROD | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:17 |
| 공용 참조 | TABLE SCM_MGR.GT_0125_CP_INFO | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:12 |
| 공용 참조 | TABLE SCM_MGR.GT_0125_DM_TEMP | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:28 |
| 공용 참조 | TABLE SCM_MGR.GT_0125_INTRANSIT_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:43 |
| 공용 참조 | TABLE SCM_MGR.GT_0125_INVENTORY_AGE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:24 |
| 공용 참조 | TABLE SCM_MGR.GT_0125_INVENTORY_ORG | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:34 |
| 공용 참조 | TABLE SCM_MGR.GT_0125_NET_DEMAND | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 20:24:54 |
| 공용 참조 | TABLE SCM_MGR.GT_0125_NICK_NAME | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:18 |
| 공용 참조 | TABLE SCM_MGR.GT_0125_OCV_EXCEPT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:12 |
| 공용 참조 | TABLE SCM_MGR.GT_0125_PJT_MAP | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 20:19:27 |
| 공용 참조 | TABLE SCM_MGR.GT_0125_SCP_INTRANSIT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:42 |
| 공용 참조 | TABLE SCM_MGR.GT_0125_SCP_INVENTORY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:42 |
| 공용 참조 | PROCEDURE SCM_MGR.PR_SCM_SYS_LOG_BATCH | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:36 |
| 공용 참조 | TABLE SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-29 08:59:48 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_AGING_STOCK_H | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | TABLE SCM_MGR.SCM_DNM_INTRANSIT_C | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 21:19:14 |
| 공용 참조 | TABLE SCM_MGR.SCM_DNM_STOCK | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:03:50 |
| 공용 참조 | VIEW SCM_MGR.SCM_DNM_STOCK_AGING_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:39:32 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_DNM_STOCK_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_ITEM_M_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | VIEW SCM_MGR.SCM_MST_BOM_SN_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:41 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_DIVISION | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 02:06:06 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_MST_FACTORY_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | VIEW SCM_MGR.SCM_MST_FINAL_ITEM_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:41 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_MST_ITEM_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_MST_LINE_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_LOCATION | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 02:16:31 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_PROJECT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:29:18 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SITE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-04 15:39:14 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SITE_ITEM | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-04 14:48:19 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SSO_DEPT_INFO | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:29:49 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SSO_USER_INFO | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 10:46:04 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_VMI_INT_SLOC | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 02:44:06 |
| 공용 참조 | TABLE SCM_MGR.SCM_SYS_CALENDAR_M | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:29:50 |
| 공용 참조 | TABLE SCM_MGR.SCP_ANL_PRODUCTION_PLAN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 07:16:34 |
| 공용 참조 | VIEW SCM_MGR.SCP_MST_BOD_N_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:41 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CELL_PROD_ASSY_MAP | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:15:19 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_FINAL_ITEM | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:15:29 |
| 공용 참조 | TABLE SCM_MGR.SCP_OPMZ_DMD_ADJ | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:21:59 |
| 공용 참조 | TABLE SCM_MGR.SCP_OPMZ_DMD_ELEC | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:22:01 |
| 공용 참조 | TABLE SCM_MGR.SCP_OPMZ_INV_ADJ | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:22:03 |
| 공용 참조 | TABLE SCM_MGR.SCP_OPMZ_INV_SECOND_OCV | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:22:04 |
| 공용 참조 | TABLE SCM_MGR.SCP_OPMZ_LOOKUP_MASTER_DETAIL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 21:19:14 |
| 공용 참조 | SYNONYM SCM_MGR.SCP_OPT_ENG_BOM_ELEC_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | FUNCTION SCM_MGR.STRING_SPLIT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:33 |

## 사내 리허설 (DRY·ROLLBACK — 사내 변경 없음)

| 파일 | 문장 | 실패 | 요약 |
|---|---|---|---|
| 00_PRECHECK_CLOUD.sql | 15 | 0 | SELECT 2행 — [('PKG_SCP0125', 'PACKAGE', 'VALID', '2026-10-09 13:38'), ('PKG_SCP0125', 'PACKAGE BODY', 'VALID', '2026-11-06 17:46')] · SELECT 0행 · SELECT 0행 · SELECT 0행 · SELECT 1행 — [('Supply_OPT_Plan', 'Y')] · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 1)] |
| 05_BACKUP_CLOUD.sql | 1 | 0 |  |
| 20_PKG_PKG_SCP0125.sql | 4 | 0 | 컴파일 생략(사내 원문 그대로) · 문장 분할 확인 |
| 30_META_SCP0125.sql | 294 | 0 | 사내 기준 변경 행 0 (0 이 정상 — 사내가 원천) · COMMIT → ROLLBACK(리허설) |
| 40_GRANT_SCP0125.sql | 1 | 0 |  |
| 90_VERIFY.sql | 16 | 0 | SELECT 2행 — [('PKG_SCP0125', 'PACKAGE', 'VALID'), ('PKG_SCP0125', 'PACKAGE BODY', 'VALID')] · SELECT 0행 · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 0)] · SELECT 1행 — [('SCM_ADM_API_M', '화면 전용 API', 15, 0)] · SELECT 1행 — [('SCM_ADM_MNU_BTN_MPG_M', '버튼 → API 매핑', 43, 0)] · SELECT 1행 — [('SCM_ADM_PROC_M', '화면 PKG 프로시저 파라미터', 143, 0)] |
| 99_ROLLBACK.sql | 2 | 0 | > META    SCM_ADM_MNU_M 삭제 1 · 복원 1 · > META    SCM_ADM_API_M 삭제 15 · 복원 15 · > META    SCM_ADM_MNU_BTN_MPG_M 삭제 43 · 복원 43 · > META    SCM_ADM_PROC_M 삭제 143 · 복원 143 · > META    SCM_ADM_USER_GR_MNU_MPG_M 삭제 4 · 복원 4 · > META    SCM_ADM_USER_GR_MNU_BTN_MPG_M 삭제 172 · 복원 172 |
| (정리) | 11 | 0 | 리허설 백업표 11개 삭제 |

## 백업 표 정리 (클라우드 적용·확인 후)

```sql
BEGIN FOR t IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'ZB\_SCP0125_202611061750\_%' ESCAPE '\') LOOP EXECUTE IMMEDIATE 'DROP TABLE ' || t.TABLE_NAME || ' PURGE'; END LOOP; END;
/
```

## 11-06 해상재고 보완 추가 안내 (수기 추가)
- 이 패키지의 `20_PKG_PKG_SCP0125.sql` = 사내 LAST_DDL 2026-11-06 17:46:59 본문(10-30 보완 + 11-06 해상재고 보완, 본문 4473줄). 17:07 패키지(10-30 보완만)를 대체한다.
- 적용 전 클라우드 확인: `91_SPEED_MEASURE.sql` 1번 → FIX_LINES 5 · BODY_LINES 4282 (11-06 17:11 적용본) 이면 진행.
- 적용 후 기대: FIX_LINES ≥ 1 · FIX1106_LINES = 2 · BODY_LINES 4473 · VALID → 이어서 2~4번 측정 결과 전달.
- 사내 근거: `_artifacts/_apply_corporate/SCP0125_INTRANSIT_PERF_20261106/APPLIED_OPERATIONS.md` (337 조합 결과 동일 · 81 Stock ADJ 4.04s→2.69s).
