--==============================================================================
-- 67_SYS0013_DMF0027_PROC_M_resync.sql
--
-- 목적: SYS0013 (SCM0005 Dynamic Query) main sheet 호출 시 PLS-00306 오류 fix
--
-- 사고 (2026-06-09 BE log):
--   SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST 실제 시그니처 = 5 IN + 2 OUT
--     P_DQ_ID / P_DQ_NAME / P_ROLE / P_USER_ID / P_MNU_ID + O_RC1 + O_RESULT_CURSOR
--   PROC_M 등록 = 1 IN (divisionId) + 1 OUT (O_RC1) — 완전 mismatch
--   → callProc 시 PLS-00306 (인수 갯수/유형 잘못)
--
-- 동작:
--   - PROC_M 의 잘못된 DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST 2 row 삭제
--   - 정확한 7 row INSERT (FE filter 필드명 매칭 + dual cursor)
--   - SORT_ORD = SP positional 순서 정확히 일치 의무
--
-- FE filter 필드 (BE log 확인): { queryName, category, mnuBtnCd, shtNm, mnuId }
-- BE 자동 채움: sesUserId, mnuId, sesLangCd
-- 매핑:
--   P_DQ_ID    (1) → dqId      (FE 미전송 — null 안전)
--   P_DQ_NAME  (2) → queryName (FE 전송)
--   P_ROLE     (3) → category  (FE 전송)
--   P_USER_ID  (4) → sesUserId (BE 자동)
--   P_MNU_ID   (5) → mnuId     (BE 자동)
--   O_RC1      (6) → o_rc1     (소문자 — FE data.o_rc1 일치)
--   O_RESULT_CURSOR (7) → O_RESULT_CURSOR (대문자 — dual cursor 표준)
--
-- 작성: 2026-06-09
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : 사전 상태 ===
SELECT PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM = 'DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST'
 ORDER BY SORT_ORD;

PROMPT === BLOCK 2 : DELETE 기존 (잘못된) PROC_M ===
DELETE FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM = 'DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST';

PROMPT === BLOCK 3 : INSERT 정정 7 row (positional 순서 정확) ===
INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.PROC_NM, NEW.COL_NM, NEW.COL_TP_CD, NEW.DATA_TP_CD, NEW.SORT_ORD, NEW.CREATED_BY, NEW.CREATION_DATE, NEW.LAST_UPDATED_BY, NEW.LAST_UPDATE_DATE
  FROM (
    SELECT 'DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST' AS PROC_NM, 'dqId' AS COL_NM, 'IN' AS COL_TP_CD, 'VARCHAR' AS DATA_TP_CD, 1 AS SORT_ORD, 'system' AS CREATED_BY, SYSDATE AS CREATION_DATE, 'system' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE FROM DUAL UNION ALL
    SELECT 'DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST', 'queryName',       'IN',  'VARCHAR',     2, 'system', SYSDATE, 'system', SYSDATE FROM DUAL UNION ALL
    SELECT 'DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST', 'category',        'IN',  'VARCHAR',     3, 'system', SYSDATE, 'system', SYSDATE FROM DUAL UNION ALL
    SELECT 'DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST', 'sesUserId',       'IN',  'VARCHAR',     4, 'system', SYSDATE, 'system', SYSDATE FROM DUAL UNION ALL
    SELECT 'DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST', 'mnuId',           'IN',  'VARCHAR',     5, 'system', SYSDATE, 'system', SYSDATE FROM DUAL UNION ALL
    SELECT 'DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST', 'o_rc1',           'OUT', 'CURSOR',      6, 'system', SYSDATE, 'system', SYSDATE FROM DUAL UNION ALL
    SELECT 'DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST', 'O_RESULT_CURSOR', 'OUT', 'PROC_RESULT', 7, 'system', SYSDATE, 'system', SYSDATE FROM DUAL
  ) NEW;

PROMPT === BLOCK 4 : 사후 상태 (7 row 의무) ===
SELECT PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM = 'DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST'
 ORDER BY SORT_ORD;

COMMIT;
PROMPT === COMPLETE ===
EXIT;
