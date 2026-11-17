# SCP0104 클라우드 이관 패키지(DB)(수정본)

- 생성 2026-11-17 10:16 · tools/CloudPkg/cloud_pkg.py 1.4.1 (결정적 빌더 — Claude 미사용)
- 원천 사내 ZIOUI1 (SERVER_HOST=localhost) 조회 2026-11-17 10:16:45 — SOURCE-FRESH
- 이관 범위 = 수정본 — 이관 기준선 없음 → 사내 수정 시각 2026-11-17 00:00:00 이후 바뀐 것만(최근 수정분 · 코드/테이블 LAST_DDL · META 행 CREATION/LAST_UPDATE_DATE). 그 이전 수정 790건 제외 — 그 이전 수정분이 클라우드에 없으면 전체 메뉴 또는 --since 로 기준 시각을 앞당긴다
- 사내 리허설 = OK

## 실행 순서 (클라우드, SCM_MGR, 파일마다 전체 F5)

1. `A_DB/00_PRECHECK_CLOUD.sql` — 사전 확인(읽기 전용) — 공용 객체 누락·컬럼 누락이 있으면 멈추고 전달
1. `A_DB/05_BACKUP_CLOUD.sql` — 현재 상태 백업(ZB_* 표) — 원복 대비
1. `A_DB/20_PKG_PKG_SCP0104.sql` — PKG/코드 — 수정본: 바뀐 구간만 패치(클라우드 USER_SOURCE 치환) · 전체: 지문 다른 SPEC·BODY 만 교체 · Output 창에서 SKIP/APPLY 확인
1. `A_DB/30_META_SCP0104.sql` — META·문구·콤보
1. `A_DB/40_GRANT_SCP0104.sql` — 권한·시노님
1. `A_DB/90_VERIFY.sql` — 확인(읽기 전용)
1. `A_DB/99_ROLLBACK.sql` — 원복(문제 시에만)

## 이관 축 점검표

| 축 | 대상 | 이관 | 구분 | 근거 |
|---|---|---|---|---|
| PKG/코드 | TYPE T_FN_SCP0104_CAPA_VERSION_ROW | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 전체 원문(지문 다를 때만) — 패치 불가: 기준본(이관 완료 원문·사내 적용 백업) 없음 · LAST_DDL 2026-10-09 10:24:23 |
| PKG/코드 | TYPE T_FN_SCP0104_CAPA_VERSION_TAB | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 전체 원문(지문 다를 때만) — 패치 불가: 기준본(이관 완료 원문·사내 적용 백업) 없음 · LAST_DDL 2026-10-09 10:24:24 |
| PKG/코드 | TYPE T_FN_SCP0104_SPREAD_TITLE_ROW | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 전체 원문(지문 다를 때만) — 패치 불가: 기준본(이관 완료 원문·사내 적용 백업) 없음 · LAST_DDL 2026-10-09 10:24:23 |
| PKG/코드 | TYPE T_FN_SCP0104_SPREAD_TITLE_TAB | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 전체 원문(지문 다를 때만) — 패치 불가: 기준본(이관 완료 원문·사내 적용 백업) 없음 · LAST_DDL 2026-10-09 10:24:24 |
| PKG/코드 | PACKAGE PKG_SCP0104 | 포함 | 화면 전용 | 변경 없음 — 적용 안 함(클라우드 같음 확인만 · LAST_DDL 2026-10-09 13:38:32 < 기준 시각 2026-11-17 00:00:00 — 이번 수정분 아님) · LAST_DDL 2026-10-09 13:38:32 |
| PKG/코드 | FUNCTION FN_SCP0104_GET_CAPA_VERSION | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 전체 원문(지문 다를 때만) — 패치 불가: 기준본(이관 완료 원문·사내 적용 백업) 없음 · LAST_DDL 2026-10-09 13:38:33 |
| PKG/코드 | FUNCTION FN_SCP0104_GET_SPREAD_TITLE | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 전체 원문(지문 다를 때만) — 패치 불가: 기준본(이관 완료 원문·사내 적용 백업) 없음 · LAST_DDL 2026-10-09 13:38:32 |
| PKG/코드 | PACKAGE BODY PKG_SCP0104 | 포함 | 화면 전용 | 전체 원문(지문 다를 때만) — 패치 불가: 기준본(이관 완료 원문·사내 적용 백업) 없음 · LAST_DDL 2026-11-17 09:47:01 |
| GTT | GT_SCP0104_ASGN_ALL | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0104_ASGN_CHG | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0104_ASGN_TOKEN | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0104_ASSIGN_RAW | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0104_CAPA_LOSS | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0104_DATE_COLS | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0104_DATE_VALS | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0104_DUMMY_LIVE | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0104_EQUIPMENT | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0104_EQUIP_TP_ASGN | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0104_LINE_MDL | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0104_SCP_MST_CAPA_LINE_SOP | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0104_SCP_MST_CAPA_LOSS | 제외(기준 시각 2026-11-17 00:00:00 이전 수정) | 화면 전용 | 구조 동기화 |
| META | SCM_ADM_MNU_M (메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)) | 0/1행 | 공용·권한·메뉴 | insert · 키 MNU_ID (PK) |
| META | SCM_ADM_API_M (화면 전용 API) | 0/0행 | 화면 전용 | upsert · 키 API_ID (PK) |
| META | SCM_ADM_API_M (공용 API(이 화면 버튼이 씀)) | 0/14행 | 공용·권한·메뉴 | insert · 키 API_ID (PK) |
| META | SCM_ADM_MNU_BTN_MPG_M (버튼 → API 매핑) | 0/31행 | 화면 전용 | upsert · 키 MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_ADM_PROC_M (화면 PKG 프로시저 파라미터) | 0/231행 | 화면 전용 | upsert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_PROC_M (공용 프로시저 파라미터) | 0/0행 | 공용·권한·메뉴 | insert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_USER_GR_MNU_MPG_M (그룹 메뉴 권한) | 0/8행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID (PK) |
| META | SCM_ADM_USER_GR_MNU_BTN_MPG_M (그룹 버튼 권한) | 0/228행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_MST_SHEET_COLUMNS (시트 컬럼) | 3/139행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME, COLUMN_NAME (유일 키 실측(PK 없음)) |
| META | SCM_MST_SHEET_MEASURE (시트 Measure) | 0/0행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME (유일 키 실측(PK 없음)) |
| META | SCM_ADM_MSG_M (문구(MSG/LBL/MNU) — INSERT NOT EXISTS 전용(#140)) | 0/102행 | 공용·권한·메뉴 | insert · 키 MSG_ID, LANG_CD (논리 키(MSG_ID, LANG_CD)) |
| META | SCM_ADM_CMBO_SQL_M (콤보 SQL(공용) — 없을 때만) | 0/18행 | 공용·권한·메뉴 | insert · 키 SQL_ID, MDU_DIVS_CD (PK) |
| 공용 참조 | FUNCTION SCM_MGR.FN_CHAR_TO_DATE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | FUNCTION SCM_MGR.FN_GET_DIVISION_NAME | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | FUNCTION SCM_MGR.FN_SCM0002_GET_CAPA_ITEM_POPUP | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0105_CHK_BASE_KEY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:55 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0105_CHK_BASE_QTY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:26 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0105_CHK_EQP | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:21 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0105_CHK_NOT_VALID | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:18 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0105_CHK_RAW | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:30 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0105_CHK_RAW1 | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:34 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0105_CHK_RAW_TEMP | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:50 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0105_CHK_RSLT_QTY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:37 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0106_CHK_DAY_CNT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:33 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0106_CHK_EXISTS_BASE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:22 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0106_CHK_FINAL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:44 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0106_CHK_LOSS_RSLT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:29 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0106_CHK_MEASURE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:34 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0106_CHK_NOT_VALID | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:31 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0106_CHK_RAW | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:50 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0106_CHK_SPD_CF | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:35 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0106_CHK_SPD_RAW | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:41 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0106_CHK_SPD_SRC | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:40 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0106_CHK_SPD_UNIT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:37 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP0106_CHK_SPEED_PLAN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:25:43 |
| 공용 참조 | TABLE SCM_MGR.GT_SCP_CAPA_LINE_ASSIGN_KEYS | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:50 |
| 공용 참조 | PROCEDURE SCM_MGR.PR_SCM_SYS_LOG_BATCH_CALL_TRAN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:34 |
| 공용 참조 | TABLE SCM_MGR.SCM_ADM_LOOKUP_MASTER | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-04 15:39:14 |
| 공용 참조 | TABLE SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-29 08:59:48 |
| 공용 참조 | TABLE SCM_MGR.SCM_DNM_ELTR_EQP_SPED_MMLY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-01 03:43:39 |
| 공용 참조 | TABLE SCM_MGR.SCM_DNM_ELTR_LOSS_LN_MMLY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-01 03:43:47 |
| 공용 참조 | TABLE SCM_MGR.SCM_DNM_EQP_SPED_MMLY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-01 03:43:49 |
| 공용 참조 | TABLE SCM_MGR.SCM_DNM_LOSS_LN_MMLY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-01 03:48:23 |
| 공용 참조 | TABLE SCM_MGR.SCM_DNM_LOSS_MDL_MMLY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-01 03:48:26 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_ITEM_LANE_M_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_LINE_M_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_MMD_EQPT_PRDT_SPEED_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_MST_EQUIPMENT_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_MST_ITEM_CONV_CALC_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_MST_ITEM_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_MST_OPERATION_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SHEET_MEASURE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-13 09:50:22 |
| 공용 참조 | TABLE SCM_MGR.SCM_SYS_CALENDAR_M | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:29:50 |
| 공용 참조 | TABLE SCM_MGR.SCM_SYS_LOG_BATCH | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:05 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_DUMMY_CODE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 13:27:45 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_ELTR_LINE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 13:27:46 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_ELTR_LINE_ASSIGN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 13:27:49 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 13:28:28 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_ELTR_LINE_MDL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 13:28:30 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_ELTR_LINE_SOP | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 13:28:31 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 13:32:28 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_ELTR_SPEED_PLAN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 13:38:29 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_LINE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 13:39:01 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_LINE_ASSIGN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 13:39:05 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_LINE_ASSIGN_CUTF | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 13:40:55 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_LINE_MDL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 13:40:59 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_LINE_SOP | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 13:41:00 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_LOSS_PLAN_MDL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 13:57:24 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_SPEED_PLAN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:13:03 |
| 공용 참조 | VIEW SCM_MGR.SCP_MST_CAPA_SPEED_PLAN_NEW_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:39 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CAPA_VERSION | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:15:00 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_FINAL_ITEM | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:15:29 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_MDL_ELTR_QTY | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:17:37 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_MDL_EQP_SPED | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:17:38 |
| 공용 참조 | SEQUENCE SCM_MGR.SEQ1_SCP_MST_CAPA_DUMMY_CODE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:23 |
| 공용 참조 | FUNCTION SCM_MGR.STRING_SPLIT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:33 |

이름에 화면 ID 가 있지만 백업·임시 사본으로 보고 제외: SCM_ADM_PROC_M_BAK20261007_SCP0104, SCM_ADM_PROC_M_BAK20261008_SCP0104, SCM_MST_SHEET_COLUMNS_BAK20261007_SCP0104, SCP_MST_CAPA_LINE_ASSIGN_BAK20261113_SCP0104, SCP_MST_CAPA_LINE_MDL_BAK20261113_SCP0104, SCP_MST_CAPA_LINE_SOP_BAK20261113_SCP0104_SOP, SCP_MST_CAPA_LOSS_PLAN_MDL_BAK20261113_SCP0104, SCP_MST_CAPA_LOSS_PLAN_MDL_BAK20261113_SCP0104_SOP, SCP_MST_CAPA_SPEED_PLAN_BAK20261113_SCP0104

## 사내 리허설 (DRY·ROLLBACK — 사내 변경 없음)

| 파일 | 문장 | 실패 | 요약 |
|---|---|---|---|
| 00_PRECHECK_CLOUD.sql | 15 | 0 | SELECT 22행 · SELECT 0행 · SELECT 0행 · SELECT 0행 · SELECT 1행 — [('Capa Plan', 'Y')] · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 1)] |
| 05_BACKUP_CLOUD.sql | 1 | 0 |  |
| 20_PKG_PKG_SCP0104.sql | 4 | 0 | > > SKIP  PACKAGE PKG_SCP0104 — 변경 없음 · 클라우드 원문 = 사내 · > > SKIP  PACKAGE BODY PKG_SCP0104 — 클라우드 원문이 사내와 같음(9226줄) · 적용 안 함 · SELECT 2행 — [('PKG_SCP0104', 'PACKAGE', 'VALID', '2026-10-09 13:38:32'), ('PKG_SCP0104', 'PACKAGE BODY', 'VALID', '2026-11-17 09:47:01')] · SELECT 0행 |
| 30_META_SCP0104.sql | 2 | 0 | 사내 기준 변경 행 0 (0 이 정상 — 사내가 원천) · COMMIT → ROLLBACK(리허설) |
| 40_GRANT_SCP0104.sql | 1 | 0 |  |
| 90_VERIFY.sql | 17 | 0 | SELECT 8행 · SELECT 0행 · SELECT 0행 · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 0)] · SELECT 1행 — [('SCM_ADM_API_M', '공용 API(이 화면 버튼이 씀)', 14, 0)] · SELECT 1행 — [('SCM_ADM_MNU_BTN_MPG_M', '버튼 → API 매핑', 31, 0)] |
| 99_ROLLBACK.sql | 2 | 0 | > META    SCM_MST_SHEET_COLUMNS 삭제 3 · 복원 3 · > DRY     META ROLLBACK · > DRY     RESTORE PACKAGE PKG_SCP0104 (11052자) · > DRY     RESTORE PACKAGE BODY PKG_SCP0104 (372578자) · > ROLLBACK 완료 (DRY) · SELECT 2행 — [('PKG_SCP0104', 'PACKAGE', 'VALID'), ('PKG_SCP0104', 'PACKAGE BODY', 'VALID')] |
| (정리) | 3 | 0 | 리허설 백업표 3개 삭제 |

## 백업 표 정리 (클라우드 적용·확인 후)

```sql
BEGIN FOR t IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'ZB\_SCP0104_202611171016\_%' ESCAPE '\') LOOP EXECUTE IMMEDIATE 'DROP TABLE ' || t.TABLE_NAME || ' PURGE'; END LOOP; END;
/
```
