# SCP0111 클라우드 이관 패키지(DB)(수정본)

- 생성 2026-11-17 17:36 · tools/CloudPkg/cloud_pkg.py 1.4.1 (결정적 빌더 — Claude 미사용)
- 원천 사내 ZIOUI1 (SERVER_HOST=localhost) 조회 2026-11-17 17:36:17 — SOURCE-FRESH
- 이관 범위 = 수정본 — 기준선(2026-11-03 10:48:56 생성 시각 · 이관 확정 아님) 이후 바뀐 것 전부
- 사내 리허설 = OK

## 실행 순서 (클라우드, SCM_MGR, 파일마다 전체 F5)

1. `A_DB/00_PRECHECK_CLOUD.sql` — 사전 확인(읽기 전용) — 공용 객체 누락·컬럼 누락이 있으면 멈추고 전달
1. `A_DB/05_BACKUP_CLOUD.sql` — 현재 상태 백업(ZB_* 표) — 원복 대비
1. `A_DB/20_PKG_PKG_SCP0111.sql` — PKG/코드 — 수정본: 바뀐 구간만 패치(클라우드 USER_SOURCE 치환) · 전체: 지문 다른 SPEC·BODY 만 교체 · Output 창에서 SKIP/APPLY 확인
1. `A_DB/30_META_SCP0111.sql` — META·문구·콤보
1. `A_DB/40_GRANT_SCP0111.sql` — 권한·시노님
1. `A_DB/90_VERIFY.sql` — 확인(읽기 전용)
1. `A_DB/99_ROLLBACK.sql` — 원복(문제 시에만)

## 이관 축 점검표

| 축 | 대상 | 이관 | 구분 | 근거 |
|---|---|---|---|---|
| PKG/코드 | PACKAGE PKG_SCP0111 | 포함 | 화면 전용 | 전체 원문(지문 다를 때만) — 패치 불가: 기준본(이관 완료 원문·사내 적용 백업) 없음 · LAST_DDL 2026-11-17 17:17:12 |
| PKG/코드 | PACKAGE BODY PKG_SCP0111 | 포함 | 화면 전용 | **수정분만 패치 2개 구간** (기준본: 사내 적용 백업 _artifacts\_apply_corporate\SCP0111_YIELDP_ITEM_20261112\PKG_SCP0111_BODY.ASIS.sql) · LAST_DDL 2026-11-17 17:35:22 |
| GTT | GT_SCP0111_CELL_ELEC_MAP | 제외(직전과 같음) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0111_ELEC_PLANT | 제외(직전과 같음) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0111_PSI_230 | 제외(직전과 같음) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0111_PSI_CELL | 제외(직전과 같음) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0111_PSI_CHILD | 제외(직전과 같음) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0111_PSI_TGT | 제외(직전과 같음) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0111_TCO_ITEM | 제외(직전과 같음) | 화면 전용 | 구조 동기화 |
| GTT | GT_SCP0111_YIELD_P | 제외(직전과 같음) | 화면 전용 | 구조 동기화 |
| META | SCM_ADM_MNU_M (메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)) | 1/1행 | 공용·권한·메뉴 | insert · 키 MNU_ID (PK) |
| META | SCM_ADM_API_M (화면 전용 API) | 0/4행 | 화면 전용 | upsert · 키 API_ID (PK) |
| META | SCM_ADM_API_M (공용 API(이 화면 버튼이 씀)) | 0/3행 | 공용·권한·메뉴 | insert · 키 API_ID (PK) |
| META | SCM_ADM_MNU_BTN_MPG_M (버튼 → API 매핑) | 0/8행 | 화면 전용 | upsert · 키 MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_ADM_PROC_M (화면 PKG 프로시저 파라미터) | 0/55행 | 화면 전용 | upsert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_PROC_M (공용 프로시저 파라미터) | 0/0행 | 공용·권한·메뉴 | insert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) |
| META | SCM_ADM_USER_GR_MNU_MPG_M (그룹 메뉴 권한) | 0/5행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID (PK) |
| META | SCM_ADM_USER_GR_MNU_BTN_MPG_M (그룹 버튼 권한) | 0/38행 | 공용·권한·메뉴 | insert · 키 USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD (PK) |
| META | SCM_MST_SHEET_COLUMNS (시트 컬럼) | 1/24행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME, COLUMN_NAME (유일 키 실측(PK 없음)) |
| META | SCM_MST_SHEET_MEASURE (시트 Measure) | 0/7행 | 화면 전용 | upsert · 키 PROGRAM_ID, SHEET_NAME, COLUMN_NAME (유일 키 실측(PK 없음)) |
| META | SCM_ADM_MSG_M (문구(MSG/LBL/MNU) — INSERT NOT EXISTS 전용(#140)) | 3/69행 | 공용·권한·메뉴 | insert · 키 MSG_ID, LANG_CD (논리 키(MSG_ID, LANG_CD)) · 사내에서 사라진 행 3건(자동 삭제 안 함) |
| META | SCM_ADM_CMBO_SQL_M (콤보 SQL(공용) — 없을 때만) | 1/12행 | 공용·권한·메뉴 | insert · 키 SQL_ID, MDU_DIVS_CD (PK) |
| 공용 참조 | FUNCTION SCM_MGR.FN_GET_LOOKUP_VALUE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:33 |
| 공용 참조 | PROCEDURE SCM_MGR.PR_SCM_SYS_LOG_BATCH | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:36 |
| 공용 참조 | TABLE SCM_MGR.SCM_ADM_LOOKUP_MASTER | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-17 17:01:47 |
| 공용 참조 | TABLE SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-17 17:01:47 |
| 공용 참조 | VIEW SCM_MGR.SCM_MST_BOM_EFFECTIVE_SN_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-17 17:17:26 |
| 공용 참조 | SYNONYM SCM_MGR.SCM_MST_ITEM_SN | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 10:24:22 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_LINE_OSP | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 02:16:30 |
| 공용 참조 | VIEW SCM_MGR.SCM_MST_MODEL_FINAL_ITEM_BOM_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-17 17:17:26 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SITE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-17 17:01:47 |
| 공용 참조 | VIEW SCM_MGR.SCM_MST_YIELD_VER_H_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-17 17:17:26 |
| 공용 참조 | TABLE SCM_MGR.SCM_SYS_LOG_BATCH | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:05 |
| 공용 참조 | TABLE SCM_MGR.SCP_ANL_PSI_INTEGRATION | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 10:11:36 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_BOM_ELEC | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 13:27:39 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_CELL_PROD_ASSY_MAP | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:15:19 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_FINAL_ITEM | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:15:29 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_FORMATION | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:15:32 |
| 공용 참조 | VIEW SCM_MGR.SCP_MST_FORMATION_V | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-17 17:17:27 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_TACT_TIME_OSP | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:20:02 |
| 공용 참조 | FUNCTION SCM_MGR.SCM_ARR_SPL_CNT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:32 |
| 공용 참조 | FUNCTION SCM_MGR.SCM_ARR_SPL_VAL | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:33 |
| 공용 참조 | TABLE SCM_MGR.SCM_MST_SHEET_MEASURE | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-13 09:50:22 |
| 공용 참조 | TABLE SCM_MGR.SCP_MST_ITEM_CELL_CF | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-02 14:15:42 |
| 공용 참조 | FUNCTION SCM_MGR.STRING_SPLIT | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-10-09 13:38:33 |
| 공용 참조 | TYPE SCM_MGR.T_TOKEN_TAB | 제외 | 공용 | 존재·VALID·컬럼 PRECHECK · LAST_DDL 2026-11-17 17:17:24 |

이름에 화면 ID 가 있지만 백업·임시 사본으로 보고 제외: IX_SCP0111_BAK20260923, SCM_ADM_LOOKUP_MASTER_DETAIL_BAK20261117_SCP0111, SCM_ADM_PROC_M_BAK20261007_SCP0111, SCP_ANL_PSI_INTEGRATION_BAK20261113_SCP0111, SCP_ANL_PSI_INTEGRATION_BAK20261117_SCP0111

## ⚠ 공용 객체 변경 감지 — 이 화면 몫 패치 파일 없음

기준선 이후 사내에서 바뀐 공용 객체다. 이 화면 작업 때문이면 Doc/gen/SCP0111/<객체>_<멤버>_SCP0111.sql 로 이 화면 몫만 남기고 다시 만들 것(다른 작업자 변경일 수 있음 — 임의 포함 안 함).

- TYPE SCM_MGR.T_TOKEN_TAB · LAST_DDL 2026-11-17 17:17:24

## 사내 리허설 (DRY·ROLLBACK — 사내 변경 없음)

| 파일 | 문장 | 실패 | 요약 |
|---|---|---|---|
| 00_PRECHECK_CLOUD.sql | 15 | 0 | SELECT 10행 · SELECT 0행 · SELECT 0행 · SELECT 0행 · SELECT 1행 — [('Supply_Plan', 'Y')] · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 1)] |
| 05_BACKUP_CLOUD.sql | 1 | 0 |  |
| 20_PKG_PKG_SCP0111.sql | 4 | 0 | > > SKIP  PACKAGE PKG_SCP0111 — 클라우드 원문이 사내와 같음(79줄) · 적용 안 함 · > > SKIP  PACKAGE BODY PKG_SCP0111 — 이미 사내와 같음 · 원문 무변경 · SELECT 2행 — [('PKG_SCP0111', 'PACKAGE', 'VALID', '2026-11-17 17:17:12'), ('PKG_SCP0111', 'PACKAGE BODY', 'VALID', '2026-11-17 17:35:22')] · SELECT 0행 |
| 30_META_SCP0111.sql | 7 | 0 | 사내 기준 변경 행 0 (0 이 정상 — 사내가 원천) · COMMIT → ROLLBACK(리허설) |
| 40_GRANT_SCP0111.sql | 1 | 0 | > GRANT   EXECUTE ON PKG_SCP0111 TO RL_SCM_SEL |
| 90_VERIFY.sql | 19 | 0 | SELECT 2행 — [('PKG_SCP0111', 'PACKAGE', 'VALID'), ('PKG_SCP0111', 'PACKAGE BODY', 'VALID')] · SELECT 0행 · SELECT 0행 · SELECT 1행 — [('SCM_ADM_MNU_M', '메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만)', 1, 0)] · SELECT 1행 — [('SCM_ADM_API_M', '화면 전용 API', 4, 0)] · SELECT 1행 — [('SCM_ADM_API_M', '공용 API(이 화면 버튼이 씀)', 3, 0)] |
| 99_ROLLBACK.sql | 2 | 0 | > META    SCM_ADM_MNU_M 삭제 1 · 복원 1 · > META    SCM_MST_SHEET_COLUMNS 삭제 1 · 복원 1 · > META    SCM_ADM_MSG_M 삭제 3 · 복원 3 · > META    SCM_ADM_CMBO_SQL_M 삭제 1 · 복원 1 · > DRY     META ROLLBACK · > DRY     RESTORE PACKAGE PKG_SCP0111 (2849자) |
| (정리) | 6 | 0 | 리허설 백업표 6개 삭제 |

## 백업 표 정리 (클라우드 적용·확인 후)

```sql
BEGIN FOR t IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'ZB\_SCP0111_202611171736\_%' ESCAPE '\') LOOP EXECUTE IMMEDIATE 'DROP TABLE ' || t.TABLE_NAME || ' PURGE'; END LOOP; END;
/
```
