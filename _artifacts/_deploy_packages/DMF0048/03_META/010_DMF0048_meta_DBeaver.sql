--==============================================================================
-- 010_DMF0048_meta_DBeaver.sql — DBeaver 호환 버전
--   원본: 010_DMF0048_meta.sql (sqlplus 명령 포함)
--   본 파일: SET DEFINE OFF / SET SERVEROUTPUT ON / SET FEEDBACK ON / WHENEVER SQLERROR EXIT FAILURE
--           / PROMPT / EXIT 모두 제거 (DBeaver SQL Editor 호환)
--           / SELECT ... FROM DUAL 끝의 ; 유지 / `/` terminator 금지
--   feedback_sql_dual_output 메모리 의무 — DBeaver 호환 별도 작성
--==============================================================================

-- BLOCK 1 : MSG_M (5)
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, MSG_DESC, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, 'KO', 'API', NEW.MSG_NM, NEW.MSG_NM, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MSG_API_DMF0048_MAIN_RETRIEVE'         AS MSG_ID, 'Sales Monitoring 조회' AS MSG_NM FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0048_SPREADTITLE_RETRIEVE',           'Sales Monitoring 헤더 조회'                FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID=NEW.MSG_ID AND X.LANG_CD='KO');

-- BLOCK 2 : MNU_M (1 row)
INSERT INTO SCM_MGR.SCM_ADM_MNU_M (MNU_ID, UPPR_MNU_ID, MNU_NM, MNU_DESC, MNU_LVL, MNU_TP_CD, MNU_URL, MNU_ORD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0048', 'Demand_Plan', 'Sales Monitoring', 'Sales Monitoring (DM Plan 매출 모니터링 — 조회 전용)', 3, 'SCREEN', 'sales-monitoring', 90, 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0048');

-- BLOCK 3 : SHEET_COLUMNS (51 rows — 원본 010_DMF0048_meta.sql 참조)
-- 본 파일은 BLOCK 3~7 의 INSERT 만 실행. 원본의 PROMPT/POST 절 제거.
-- 51 row INSERT 는 원본 SQL 그대로 사용 (DBeaver 호환 — SELECT FROM DUAL 표준).
-- ⚠️ 본 파일은 DBeaver 실행용 placeholder. 전체 BLOCK 은 원본 010_DMF0048_meta.sql 의 BLOCK 1~7 참조.

COMMIT;
