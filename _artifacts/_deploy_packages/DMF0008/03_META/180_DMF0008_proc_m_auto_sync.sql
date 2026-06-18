--==============================================================================
-- 180_DMF0008_proc_m_auto_sync.sql
--
-- DMF0008 PROC_M ↔ SP ALL_ARGUMENTS 자동 동기화 (-9994 잔존 사고 fix)
-- =============================================================================
-- 작성: 2026-06-17 (170 file 적용 후에도 동일 오류 — PROC_M signature mismatch 발견)
--
-- 발견:
--   DMF0008_GET_UPDATE_HISTORY 실 시그니처 = 3 인자 (P_USER_ID, P_MENU_ID, O_RC1)
--   170 file 의 PROC_M 등록 = 4 인자 (sesUserId, mnuId, o_rc1, O_RESULT_CURSOR)
--   → BE 가 PROC_M signature 따라 4번째 OUT param 매핑 시도 → 시그니처 mismatch → 오류
--
-- 전략:
--   1) 잘못 등록된 PROC_M row 전체 DELETE
--   2) ALL_ARGUMENTS 자동 추출 → BE 표준 COL_NM 으로 정확 INSERT
--      (position 1=IN→sesUserId, 2=IN→mnuId, ..., OUT CURSOR → o_rc1/o_rc2/...)
--==============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === DIAG 1 : 현 PROC_M 상태 (잘못 등록된 row 확인) ===

SELECT PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM IN ('DMF0008_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS')
 ORDER BY PROC_NM, SORT_ORD;

PROMPT === DIAG 2 : SP 실제 ALL_ARGUMENTS (정정 기준) ===

SELECT object_name, argument_name, position, data_type, in_out
  FROM all_arguments
 WHERE owner = 'SCM_MGR'
   AND object_name IN ('DMF0008_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS')
   AND package_name IS NULL
 ORDER BY object_name, position;

PROMPT === FIX 1 : 잘못 등록된 PROC_M row 전체 DELETE ===

DELETE FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM IN ('DMF0008_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS');

PROMPT === FIX 2 : ALL_ARGUMENTS 자동 추출 → PROC_M 정확 INSERT ===

-- BE 표준 COL_NM 매핑 규칙 (메모리 feedback_proc_meta_col_nm_be_auto_keys):
--   IN  param: P_USER_ID/P_SES_USER_ID/USER_ID/SES_USER_ID → 'sesUserId'
--              P_MENU_ID/P_MNU_ID/MENU_ID/MNU_ID/MNUID    → 'mnuId'
--              P_LANG_CD/LANG_CD                           → 'sesLangCd'
--              그 외 P_XXX                                 → 'xXx' camelCase
--   OUT CURSOR: O_RC1/O_RC2/... → 'o_rc1'/'o_rc2'/...
--              O_RESULT_CURSOR → 'O_RESULT_CURSOR' 대문자 그대로 (PROC_RESULT)

DECLARE
  v_col_nm  VARCHAR2(100);
  v_data_tp VARCHAR2(20);
  v_col_tp  VARCHAR2(20);
  v_cnt     PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT object_name, argument_name, position, data_type, in_out
      FROM all_arguments
     WHERE owner = 'SCM_MGR'
       AND object_name IN ('DMF0008_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS')
       AND package_name IS NULL
     ORDER BY object_name, position
  ) LOOP
    -- COL_NM 매핑
    IF r.argument_name IN ('P_USER_ID', 'P_SES_USER_ID', 'USER_ID', 'SES_USER_ID') THEN
      v_col_nm := 'sesUserId';
    ELSIF r.argument_name IN ('P_MENU_ID', 'P_MNU_ID', 'MENU_ID', 'MNU_ID', 'MNUID') THEN
      v_col_nm := 'mnuId';
    ELSIF r.argument_name IN ('P_LANG_CD', 'LANG_CD') THEN
      v_col_nm := 'sesLangCd';
    ELSIF r.argument_name = 'O_RESULT_CURSOR' THEN
      v_col_nm := 'O_RESULT_CURSOR';  -- 대문자 그대로
    ELSIF r.in_out = 'OUT' AND r.data_type = 'REF CURSOR' THEN
      v_col_nm := LOWER(r.argument_name);  -- O_RC1 → o_rc1
    ELSIF r.argument_name LIKE 'P\_%' ESCAPE '\' THEN
      -- P_XXX → xXx (camelCase 변환은 단순화 — 첫 _ 뒤 segments 처리)
      v_col_nm := LOWER(SUBSTR(r.argument_name, 3));
      v_col_nm := REGEXP_REPLACE(v_col_nm, '_([a-z])', '\1', 1, 0, NULL);  -- _x → X 단순
    ELSE
      v_col_nm := LOWER(r.argument_name);
    END IF;

    -- DATA_TP_CD 매핑
    IF r.data_type = 'REF CURSOR' AND r.argument_name = 'O_RESULT_CURSOR' THEN
      v_data_tp := 'PROC_RESULT';
    ELSIF r.data_type = 'REF CURSOR' THEN
      v_data_tp := 'CURSOR';
    ELSIF r.data_type LIKE 'VARCHAR%' OR r.data_type = 'CHAR' THEN
      v_data_tp := 'VARCHAR';
    ELSIF r.data_type IN ('NUMBER', 'PLS_INTEGER', 'INTEGER') THEN
      v_data_tp := 'NUMBER';
    ELSIF r.data_type = 'DATE' THEN
      v_data_tp := 'DATE';
    ELSE
      v_data_tp := r.data_type;
    END IF;

    v_col_tp := r.in_out;

    INSERT INTO SCM_MGR.SCM_ADM_PROC_M
      (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES
      (r.object_name, v_col_nm, v_data_tp, v_col_tp, r.position, 'admin', SYSDATE, 'admin', SYSDATE);

    DBMS_OUTPUT.PUT_LINE(RPAD('[INS]', 6) || RPAD(r.object_name, 30) ||
                         RPAD(r.argument_name, 22) || '→ ' ||
                         RPAD(v_col_nm, 20) || RPAD(v_data_tp, 12) || v_col_tp);
    v_cnt := v_cnt + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('FIX 2: INSERT ' || v_cnt || ' rows');
END;
/

COMMIT;

PROMPT === POST-CHECK : PROC_M 동기화 후 상태 ===

SELECT PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM IN ('DMF0008_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS')
 ORDER BY PROC_NM, SORT_ORD;

PROMPT === POST-CHECK 2 : SP ALL_ARGUMENTS vs PROC_M COUNT 일치 검증 ===

WITH SP_ARGS AS (
  SELECT object_name, COUNT(*) AS arg_cnt
    FROM all_arguments
   WHERE owner='SCM_MGR'
     AND object_name IN ('DMF0008_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS')
     AND package_name IS NULL
   GROUP BY object_name
),
PROC_ROWS AS (
  SELECT PROC_NM AS object_name, COUNT(*) AS proc_cnt
    FROM SCM_MGR.SCM_ADM_PROC_M
   WHERE PROC_NM IN ('DMF0008_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS')
   GROUP BY PROC_NM
)
SELECT s.object_name, s.arg_cnt AS sp_args, p.proc_cnt AS proc_m_rows,
       CASE WHEN s.arg_cnt = p.proc_cnt THEN 'OK' ELSE 'MISMATCH' END AS RESULT
  FROM SP_ARGS s LEFT JOIN PROC_ROWS p ON s.object_name = p.object_name;

PROMPT === 180_DMF0008_proc_m_auto_sync.sql 완료 ===

--==============================================================================
-- 적용 후:
--   POST-CHECK 2 의 RESULT = 'OK' (sp_args = proc_m_rows) 확인
--   브라우저 새로고침 → DMF0008 진입 → updateHistory 호출 200 OK 기대
--   Status Update 버튼 클릭 200 OK 기대
--==============================================================================
