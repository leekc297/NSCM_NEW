# DMF0045 클라우드 이관 패키지(DB)(수정본)

- 생성 2026-11-25 14:28 · tools/CloudPkg/cloud_pkg.py 1.4.1 (결정적 빌더 — Claude 미사용)
- 원천 사내 ZIOUI1 (SERVER_HOST=localhost) 조회 2026-11-25 14:28:56 — SOURCE-FRESH
- 이관 범위 = 수정본 — 이관 기준선 없음 → 사내 수정 시각 2026-11-25 00:00:00 이후 바뀐 것만(최근 수정분 · 코드/테이블 LAST_DDL · META 행 CREATION/LAST_UPDATE_DATE). 그 이전 수정 430건 제외 — 그 이전 수정분이 클라우드에 없으면 전체 메뉴 또는 --since 로 기준 시각을 앞당긴다
- 사내 리허설 = OK

## 실행 순서 (클라우드, SCM_MGR, 파일마다 전체 F5)

1. `A_DB/00_PRECHECK_CLOUD.sql` — 사전 확인(읽기 전용) — 공용 객체 누락·컬럼 누락이 있으면 멈추고 전달
1. `A_DB/05_BACKUP_CLOUD.sql` — 현재 상태 백업(ZB_* 표) — 원복 대비
1. `A_DB/20_PKG_PKG_DMF0045.sql` — PKG/코드 — 수정본: 바뀐 구간만 패치(클라우드 USER_SOURCE 치환) · 전체: 지문 다른 SPEC·BODY 만 교체 · Output 창에서 SKIP/APPLY 확인
1. `A_DB/30_META_DMF0045.sql` — META·문구·콤보
1. `A_DB/40_GRANT_DMF0045.sql` — 권한·시노님
1. `A_DB/90_VERIFY.sql` — 확인(읽기 전용)
1. `A_DB/99_ROLLBACK.sql` — 원복(문제 시에만)

## 이관 축 점검표

| 축 | 대상 | 이관 | 구분 | 근거 |
|---|---|---|---|---|
| PKG/코드 | PACKAGE PKG_DMF0045 | 포함 | 화면 전용 | 변경 없음 — 적용 안 함(클라우드 같음 확인만 · LAST_DDL 2026-11-17 17:17:12 < 기준 시각 2026-11-25 00:00:00 — 이번 수정분 아님) · LAST_DDL 2026-11-17 17:17:12 |
| PKG/코드 | PACKAGE BODY PKG_DMF0045 | 포함 | 화면 전용 | **수정분만 패치 1개 구간** (기준본: 사내 적용 백업 _artifacts\_apply_corporate\DMF0045_BOH_PERF_20261125\PKG_DMF0045_BODY.ASIS.sql) · LAST_DDL 2026-11-25 14:27:06 |
| GTT | GT_DMF0045_BOH | 제외(기준 시각 2026-11-25 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_DMF0045_ETD | 제외(기준 시각 2026-11-25 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_DMF0045_LOC | 제외(기준 시각 2026-11-25 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_DMF0045_MEASURE | 제외(기준 시각 2026-11-25 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_DMF0045_MKT | 제외(기준 시각 2026-11-25 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_DMF0045_PIVOT | 제외(기준 시각 2026-11-25 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_DMF0045_PLAN | 제외(기준 시각 2026-11-25 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_DMF0045_PLAN_FG | 제외(기준 시각 2026-11-25 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_DMF0045_REQUESTOR | 제외(기준 시각 2026-11-25 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_DMF0045_SAVE | 제외(기준 시각 2026-11-25 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_DMF0045_SHIP_REQ | 제외(기준 시각 2026-11-25 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_DMF0045_SHIP_ROW | 제외(기준 시각 2026-11-25 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_DMF0045_STOCK | 제외(기준 시각 2026-11-25 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| META | SCM_ADM_MNU_M (메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)) | 0/1행 | 공용·권한·메뉴 | insert · 키 MNU_ID (PK) |
| META | SCM_ADM_API_M (화면 전용 API) | 0/7행 | 화면 전용 | upsert · 키 API_ID (PK) |
| META | SCM_ADM_API_M (공용 API(이 화면 버튼이 씀)) | 0/0행 | 공용·권한·메뉴 | insert · 키 API_ID (PK) |
| META | SCM_ADM_MNU_BTN_MPG_M (버튼 → API 매핑) | 0/18행 | 화면 전용 | upsert · 키 MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_ADM_PROC_M (화면 PKG 프로시저 파라미터) | 0/35행 | 화면 전용 | upsert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_PROC_M (공용 프로시저 파라미터) | 0/21행 | 공용·권한·메뉴 | insert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_USER_GR_MNU_MPG_M (그룹 메뉴 권한) | 0/14행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID (PK) |
| META | SCM_ADM_USER_GR_MNU_BTN_MPG_M (그룹 버튼 권한) | 0/261행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_MST_SHEET_COLUMNS (시트 컬럼) | 2/32행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME, COLUMN_NAME (유일 키 실측(PK 없음)) |
| META | SCM_MST_SHEET_MEASURE (시트 Measure) | 0/22행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME, COLUMN_NAME (유일 키 실측(PK 없음)) |
| META | SCM_ADM_MSG_M (문구(MSG/LBL/MNU) — INSERT NOT EXISTS 전용(#140)) | 0/3행 | 공용·권한·메뉴 | insert · 키 MSG_ID, LANG_CD (논리 키(MSG_ID, LANG_CD)) |
| META | SCM_ADM_CMBO_SQL_M (콤보 SQL(공용) — 없을 때만) | 0/4행 | 공용·권한·메뉴 | insert · 키 SQL_ID, MDU_DIVS_CD (PK) |
| 공용 참조 | TABLE SCM_MGR.DM_PLN_MKT_FCST | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-25 00:19:04 |
| 공용 참조 | TABLE SCM_MGR.DM_PLN_SHIPMENT_REQ | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-25 00:16:49 |
| 공용 참조 | TABLE SCM_MGR.DM_PLN_SHIPMENT_REQ_H | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-23 09:56:23 |
| 공용 참조 | FUNCTION SCM_MGR.FN_GET_SSP_ETD_DATE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-17 17:17:12 |
| 공용 참조 | FUNCTION SCM_MGR.FN_NEXT_DAY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-28 14:02:59 |
| 공용 참조 | FUNCTION SCM_MGR.FN_STRING_SPLIT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-17 17:17:12 |
| 공용 참조 | PROCEDURE SCM_MGR.PR_SCM_SYS_LOG_BATCH | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:36 |
| 공용 참조 | TABLE SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-17 17:01:47 |
| 공용 참조 | TABLE SCM_MGR.SCM_ADM_USER_M | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 21:19:22 |
| 공용 참조 | FUNCTION SCM_MGR.SCM_ARR_SPL_CNT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | FUNCTION SCM_MGR.SCM_ARR_SPL_VAL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:33 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_DNM_CELL_INHOUSE_PLAN_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_MST_ITEM_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_LOCATION | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-25 00:25:58 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SHEET_COLUMNS | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-04 12:40:38 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SHEET_MEASURE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-13 09:50:22 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SITE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-25 00:24:13 |
| 공용 참조 | VIEW SCM_MGR.SCM_MST_SITE_ITEM_DEPT_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-17 17:17:26 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SSO_DEPT_INFO | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-25 00:19:25 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_TITLESET_USER | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 21:19:15 |
| 공용 참조 | TABLE SCM_MGR.SCM_SYS_CALENDAR_M | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-25 00:21:05 |
| 공용 참조 | TABLE SCM_MGR.SCM_SYS_LOG_BATCH | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:05 |
| 공용 참조 | TABLE SCM_MGR.SCP_ANL_PRODUCTION_PLAN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-24 17:25:13 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_BOD | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-25 00:20:35 |
| 공용 참조 | VIEW SCM_MGR.SCP_MST_BOD_N_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:41 |
| 공용 참조 | VIEW SCM_MGR.SCP_MST_BOD_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:41 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_DISTRIBUTION_ROUTE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-25 00:23:25 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_FINAL_ITEM | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-25 00:19:31 |
| 공용 참조 | VIEW SCM_MGR.SCP_OPT_SHIPMENT_PLAN_PEGGING_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-17 17:17:27 |
| 공용 참조 | VIEW SCM_MGR.SCP_OPT_SHIPMENT_PLAN_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-17 17:17:27 |
| 공용 참조 | VIEW SCM_MGR.SCP_PLAN_VERSION_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-12 14:05:34 |
| 공용 참조 | TABLE SCM_MGR.SSP_ANL_SHIP_CONFIRM | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-24 23:50:50 |
| 공용 참조 | VIEW SCM_MGR.SSP_DNM_ESS_PACKER_STOCK_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-17 17:17:28 |
| 공용 참조 | TABLE SCM_MGR.SSP_DNM_FP_PLAN_FROZEN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-25 00:23:52 |
| 공용 참조 | TABLE SCM_MGR.SSP_DNM_STOCK_C | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 21:19:11 |
| 공용 참조 | TABLE SCM_MGR.END_CUSTOMER | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-25 00:21:00 |
| 공용 참조 | TABLE SCM_MGR.SCP_PLN_SHIPMENT_PLAN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-24 22:52:37 |
| 공용 참조 | TABLE SCM_MGR.SCP_PLN_SHIPMENT_PLAN_PEGGING | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-24 23:12:53 |
| 공용 참조 | TABLE SCM_MGR.TB_FX_USER | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-25 00:20:57 |

## 사내 리허설 (DRY·ROLLBACK — 사내 변경 없음)

| 파일 | 문장 | 실패 | 요약 |
|---|---|---|---|
| 00_PRECHECK_CLOUD.sql | 15 | 0 | SELECT 15행 · SELECT 0행 · SELECT 0행 · SELECT 0행 · SELECT 1행 — [('Shipping_Schedule', 'Y')] · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 1)] |
| 05_BACKUP_CLOUD.sql | 1 | 0 |  |
| 20_PKG_PKG_DMF0045.sql | 4 | 0 | > > SKIP  PACKAGE PKG_DMF0045 — 변경 없음 · 클라우드 원문 = 사내 · > > SKIP  PACKAGE BODY PKG_DMF0045 — 이미 사내와 같음 · 원문 무변경 · SELECT 2행 — [('PKG_DMF0045', 'PACKAGE', 'VALID', '2026-11-17 17:17:12'), ('PKG_DMF0045', 'PACKAGE BODY', 'VALID', '2026-11-25 14:27:06')] · SELECT 0행 |
| 30_META_DMF0045.sql | 2 | 0 | 사내 기준 변경 행 0 (0 이 정상 — 사내가 원천) · COMMIT → ROLLBACK(리허설) |
| 40_GRANT_DMF0045.sql | 1 | 0 | > GRANT   EXECUTE ON PKG_DMF0045 TO RL_SCM_SEL |
| 90_VERIFY.sql | 19 | 0 | SELECT 2행 — [('PKG_DMF0045', 'PACKAGE', 'VALID'), ('PKG_DMF0045', 'PACKAGE BODY', 'VALID')] · SELECT 0행 · SELECT 0행 · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 0)] · SELECT 1행 — [('SCM_ADM_API_M', '화면 전용 API', 7, 0)] · SELECT 1행 — [('SCM_ADM_MNU_BTN_MPG_M', '버튼 → API 매핑', 18, 0)] |
| 99_ROLLBACK.sql | 2 | 0 | > META    SCM_MST_SHEET_COLUMNS 삭제 2 · 복원 2 · > DRY     META ROLLBACK · > DRY     RESTORE PACKAGE PKG_DMF0045 (2623자) · > DRY     RESTORE PACKAGE BODY PKG_DMF0045 (125695자) · > ROLLBACK 완료 (DRY) · SELECT 2행 — [('PKG_DMF0045', 'PACKAGE', 'VALID'), ('PKG_DMF0045', 'PACKAGE BODY', 'VALID')] |
| (정리) | 3 | 0 | 리허설 백업표 3개 삭제 |

## 백업 표 정리 (클라우드 적용·확인 후)

```sql
BEGIN FOR t IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'ZB\_DMF0045_202611251429\_%' ESCAPE '\') LOOP EXECUTE IMMEDIATE 'DROP TABLE ' || t.TABLE_NAME || ' PURGE'; END LOOP; END;
/
```
