-- SOURCE-FRESH: SCM_MGR 화면 DMF0048 객체·META (DB=ZIOUI1 SERVER_HOST=localhost) FETCHED=2026-11-22 13:49:34
/* 30_META — 화면 메타 7영역 + MSG/LBL + 콤보 (멱등)
 * 패키지 DMF0048_CLOUD_DB_MOD_20261122_1349 · 생성 tools/CloudPkg/cloud_pkg.py 1.4.1 · 2026-11-22 13:49
 * 실행 계정 = SCM_MGR (전체 F5 · 반복 실행 안전)
 * upsert = 없으면 INSERT · 값이 다르면 UPDATE(화면 전용 행) / insert = 없을 때만 INSERT(공용·권한·메뉴·문구·콤보)
 * 감사 컬럼 = admin / SYSDATE · ON 키 = PK 실측(없으면 유일 키 실측) · 클라우드에만 있는 행은 지우지 않음(90_VERIFY 보고)
 */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED


/* ── SCM_ADM_MNU_M — 메뉴 행 (메뉴 트리·노출은 클라우드 운영값 존중 — 없을 때만) · insert · 키 MNU_ID (PK) · 0행 */
-- (대상 행 없음)

/* ── SCM_ADM_API_M — 화면 전용 API · upsert · 키 API_ID (PK) · 0행 */
-- (대상 행 없음)

/* ── SCM_ADM_API_M — 공용 API(이 화면 버튼이 씀) · insert · 키 API_ID (PK) · 0행 */
-- (대상 행 없음)

/* ── SCM_ADM_MNU_BTN_MPG_M — 버튼 → API 매핑 · upsert · 키 MNU_ID, SHT_NM, MNU_BTN_CD (PK) · 0행 */
-- (대상 행 없음)

/* ── SCM_ADM_PROC_M — 화면 PKG 프로시저 파라미터 · upsert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) · 0행 */
-- (대상 행 없음)

/* ── SCM_ADM_PROC_M — 공용 프로시저 파라미터 · insert · 키 PROC_NM, COL_NM, COL_TP_CD (PK) · 0행 */
-- (대상 행 없음)

/* ── SCM_ADM_USER_GR_MNU_MPG_M — 그룹 메뉴 권한 · insert · 키 USER_GR_ID, MNU_ID (PK) · 0행 */
-- (대상 행 없음)

/* ── SCM_ADM_USER_GR_MNU_BTN_MPG_M — 그룹 버튼 권한 · insert · 키 USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD (PK) · 0행 */
-- (대상 행 없음)

/* ── SCM_MST_SHEET_COLUMNS — 시트 컬럼 · upsert · 키 PROGRAM_ID, SHEET_NAME, COLUMN_NAME (유일 키 실측(PK 없음)) · 0행 */
-- (대상 행 없음)

/* ── SCM_MST_SHEET_MEASURE — 시트 Measure · upsert · 키 PROGRAM_ID, SHEET_NAME, COLUMN_NAME (유일 키 실측(PK 없음)) · 0행 */
-- (대상 행 없음)

/* ── SCM_ADM_MSG_M — 문구(MSG/LBL/MNU) — INSERT NOT EXISTS 전용(#140) · insert · 키 MSG_ID, LANG_CD (논리 키(MSG_ID, LANG_CD)) · 3행 */
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT S.MSG_ID, S.LANG_CD, S.MSG_NM, S.MSG_DESC, S.MSG_TP_CD, S.USE_YN, 'admin', SYSDATE, 'admin', SYSDATE
  FROM (SELECT 'MSG01505' MSG_ID, 'CN' LANG_CD, '请输入2年以内的查询期间.' MSG_NM, NULL MSG_DESC, 'MSG' MSG_TP_CD, 'Y' USE_YN FROM DUAL) S
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M T WHERE NVL(TO_CHAR(T.MSG_ID), '~') = NVL(TO_CHAR(S.MSG_ID), '~') AND NVL(TO_CHAR(T.LANG_CD), '~') = NVL(TO_CHAR(S.LANG_CD), '~'));
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT S.MSG_ID, S.LANG_CD, S.MSG_NM, S.MSG_DESC, S.MSG_TP_CD, S.USE_YN, 'admin', SYSDATE, 'admin', SYSDATE
  FROM (SELECT 'MSG01505' MSG_ID, 'EN' LANG_CD, 'Please enter a period within 2 years.' MSG_NM, NULL MSG_DESC, 'MSG' MSG_TP_CD, 'Y' USE_YN FROM DUAL) S
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M T WHERE NVL(TO_CHAR(T.MSG_ID), '~') = NVL(TO_CHAR(S.MSG_ID), '~') AND NVL(TO_CHAR(T.LANG_CD), '~') = NVL(TO_CHAR(S.LANG_CD), '~'));
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT S.MSG_ID, S.LANG_CD, S.MSG_NM, S.MSG_DESC, S.MSG_TP_CD, S.USE_YN, 'admin', SYSDATE, 'admin', SYSDATE
  FROM (SELECT 'MSG01505' MSG_ID, 'KO' LANG_CD, '조회 기간은 2년 이내로 입력해주세요.' MSG_NM, NULL MSG_DESC, 'MSG' MSG_TP_CD, 'Y' USE_YN FROM DUAL) S
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M T WHERE NVL(TO_CHAR(T.MSG_ID), '~') = NVL(TO_CHAR(S.MSG_ID), '~') AND NVL(TO_CHAR(T.LANG_CD), '~') = NVL(TO_CHAR(S.LANG_CD), '~'));

/* ── SCM_ADM_CMBO_SQL_M — 콤보 SQL(공용) — 없을 때만 · insert · 키 SQL_ID, MDU_DIVS_CD (PK) · 0행 */
-- (대상 행 없음)

COMMIT;
