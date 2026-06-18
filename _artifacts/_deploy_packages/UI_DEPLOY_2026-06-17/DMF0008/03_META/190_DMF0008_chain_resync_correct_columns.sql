--==============================================================================
-- 190_DMF0008_chain_resync_correct_columns.sql
--
-- 170 file 의 컬럼명 추측 오류 정정 → 040 file 의 검증된 컬럼명 그대로 사용
-- =============================================================================
-- 작성: 2026-06-17 (170 적용 후 0 row chain 발견 — 컬럼명 사고 root cause 확정)
--
-- 170 file 의 잘못된 컬럼명 (ORA-00904 사고):
--   SCM_ADM_MSG_M : ❌ MSG_KO_NM, MSG_CTN     ✅ MSG_NM, MSG_DESC (040 file 검증)
--   SCM_ADM_API_M : ❌ API_NM                 ✅ API_MSG_DESC (040 file 검증)
--
-- 본 SQL 은 040 file 의 정확한 컬럼명 그대로 + updateHistory chain 추가.
--==============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET LINESIZE 200

PROMPT === BLOCK 1 : SCM_ADM_MSG_M (정확 컬럼명 MSG_NM/MSG_DESC) ===

INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, MSG_DESC, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'MSG_API_DMF0008_UPDATE_HISTORY', 'KO', 'API', 'ERP EDI 업데이트 이력 조회', 'ERP EDI 업데이트 이력 조회', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID='MSG_API_DMF0008_UPDATE_HISTORY' AND X.LANG_CD='KO');

INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, MSG_DESC, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'MSG_API_DMF0008_STATUS_UPDATE', 'KO', 'API', 'ERP EDI Status Update 수행', 'ERP EDI Status Update 수행', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID='MSG_API_DMF0008_STATUS_UPDATE' AND X.LANG_CD='KO');

PROMPT === BLOCK 2 : SCM_ADM_API_M (정확 컬럼명 API_MSG_DESC) ===

INSERT INTO SCM_MGR.SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'P_DMF0008_UPDATE_HISTORY', 'PROC_SELECT', 'MSG_API_DMF0008_UPDATE_HISTORY', 'ERP EDI Update History 조회', 'DMF0008_GET_UPDATE_HISTORY', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_API_M X WHERE X.API_ID='P_DMF0008_UPDATE_HISTORY');

INSERT INTO SCM_MGR.SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'P_DMF0008_STATUS_UPDATE', 'PROC_SELECT', 'MSG_API_DMF0008_STATUS_UPDATE', 'ERP EDI Status Update', 'PR_DM_DNM_EDI_CALLOFF_STATUS', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_API_M X WHERE X.API_ID='P_DMF0008_STATUS_UPDATE');

PROMPT === BLOCK 3 : SCM_ADM_MNU_BTN_MPG_M ===

INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0008', 'updateHistory', 'SEARCH', 'P_DMF0008_UPDATE_HISTORY', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X WHERE X.MNU_ID='DMF0008' AND X.SHT_NM='updateHistory' AND X.MNU_BTN_CD='SEARCH');

INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0008', 'main', 'STATUS_UPDATE', 'P_DMF0008_STATUS_UPDATE', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X WHERE X.MNU_ID='DMF0008' AND X.SHT_NM='main' AND X.MNU_BTN_CD='STATUS_UPDATE');

PROMPT === BLOCK 4 : SCM_ADM_USER_GR_MNU_BTN_MPG_M (minyonglee1 4 그룹 + GUEST) ===

INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT gr.USER_GR_ID, 'DMF0008', NEW.SHT_NM, NEW.MNU_BTN_CD, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M gr
 CROSS JOIN (
    SELECT 'updateHistory' AS SHT_NM, 'SEARCH'        AS MNU_BTN_CD FROM DUAL UNION ALL
    SELECT 'main',                    'STATUS_UPDATE'               FROM DUAL
 ) NEW
 WHERE gr.USER_ID = 'minyonglee1' AND (gr.USE_YN='Y' OR gr.USE_YN IS NULL)
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M e
      WHERE e.USER_GR_ID = gr.USER_GR_ID AND e.MNU_ID = 'DMF0008'
        AND e.SHT_NM = NEW.SHT_NM AND e.MNU_BTN_CD = NEW.MNU_BTN_CD
   );

INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', 'DMF0008', NEW.SHT_NM, NEW.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'updateHistory' AS SHT_NM, 'SEARCH'        AS MNU_BTN_CD FROM DUAL UNION ALL
    SELECT 'main',                    'STATUS_UPDATE'               FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X
    WHERE X.USER_GR_ID='GUEST' AND X.MNU_ID='DMF0008'
      AND X.SHT_NM=NEW.SHT_NM AND X.MNU_BTN_CD=NEW.MNU_BTN_CD
 );

PROMPT === BLOCK 5 : SCM_ADM_PROC_M (ALL_ARGUMENTS 자동 동기화) ===

-- 기존 잘못 등록 (혹시 있다면) DELETE
DELETE FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM IN ('DMF0008_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS');

-- ALL_ARGUMENTS 자동 추출 → BE 표준 COL_NM 매핑
DECLARE
  v_col_nm  VARCHAR2(100);
  v_data_tp VARCHAR2(20);
BEGIN
  FOR r IN (
    SELECT object_name, argument_name, position, data_type, in_out
      FROM all_arguments
     WHERE owner = 'SCM_MGR'
       AND object_name IN ('DMF0008_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS')
       AND package_name IS NULL
     ORDER BY object_name, position
  ) LOOP
    IF r.argument_name IN ('P_USER_ID', 'P_SES_USER_ID', 'USER_ID', 'SES_USER_ID') THEN
      v_col_nm := 'sesUserId';
    ELSIF r.argument_name IN ('P_MENU_ID', 'P_MNU_ID', 'MENU_ID', 'MNU_ID') THEN
      v_col_nm := 'mnuId';
    ELSIF r.argument_name IN ('P_LANG_CD', 'LANG_CD') THEN
      v_col_nm := 'sesLangCd';
    ELSIF r.argument_name = 'O_RESULT_CURSOR' THEN
      v_col_nm := 'O_RESULT_CURSOR';
    ELSIF r.in_out = 'OUT' AND r.data_type = 'REF CURSOR' THEN
      v_col_nm := LOWER(r.argument_name);
    ELSIF r.argument_name LIKE 'P\_%' ESCAPE '\' THEN
      v_col_nm := LOWER(SUBSTR(r.argument_name, 3));
    ELSE
      v_col_nm := LOWER(r.argument_name);
    END IF;

    IF r.data_type = 'REF CURSOR' AND r.argument_name = 'O_RESULT_CURSOR' THEN
      v_data_tp := 'PROC_RESULT';
    ELSIF r.data_type = 'REF CURSOR' THEN
      v_data_tp := 'CURSOR';
    ELSIF r.data_type LIKE 'VARCHAR%' OR r.data_type = 'CHAR' THEN
      v_data_tp := 'VARCHAR';
    ELSIF r.data_type IN ('NUMBER', 'PLS_INTEGER') THEN
      v_data_tp := 'NUMBER';
    ELSE
      v_data_tp := r.data_type;
    END IF;

    INSERT INTO SCM_MGR.SCM_ADM_PROC_M
      (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES
      (r.object_name, v_col_nm, v_data_tp, r.in_out, r.position, 'admin', SYSDATE, 'admin', SYSDATE);

    DBMS_OUTPUT.PUT_LINE('[INS] ' || RPAD(r.object_name, 30) ||
                         RPAD(r.argument_name, 22) || '→ ' || v_col_nm);
  END LOOP;
END;
/

COMMIT;

PROMPT === POST-CHECK : 통합 chain + USE_YN + PROC_M COUNT ===

SELECT BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD, BTN.USE_YN AS BTN_USE,
       API.API_ID, API.API_URL, API.USE_YN AS API_USE,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM=API.API_URL) AS PROC_M_CNT,
       (SELECT COUNT(*) FROM all_arguments WHERE owner='SCM_MGR' AND object_name=API.API_URL AND package_name IS NULL) AS SP_ARG_CNT,
       (SELECT status FROM all_objects WHERE owner='SCM_MGR' AND object_name=API.API_URL AND object_type='PROCEDURE' AND ROWNUM=1) AS SP_STATUS
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  LEFT JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID=BTN.API_ID
 WHERE BTN.MNU_ID='DMF0008'
   AND ((BTN.SHT_NM='updateHistory' AND BTN.MNU_BTN_CD='SEARCH')
     OR (BTN.SHT_NM='main' AND BTN.MNU_BTN_CD='STATUS_UPDATE'));

PROMPT === 190_DMF0008_chain_resync_correct_columns.sql 완료 ===

--==============================================================================
-- 적용 후:
--   POST-CHECK 가 2 row 출력 + BTN_USE='Y' + API_USE='Y' + SP_STATUS='VALID'
--   PROC_M_CNT = SP_ARG_CNT (둘 다 3, 또는 STATUS_UPDATE 의 경우 SP 시그니처 따라)
--   BE 재시작 완료 후 브라우저 새로고침 → -9994 해소 기대
--==============================================================================
