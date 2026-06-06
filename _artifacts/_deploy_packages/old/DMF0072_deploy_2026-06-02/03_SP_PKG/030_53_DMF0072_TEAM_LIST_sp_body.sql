--==============================================================================
-- 53_DMF0072_TEAM_LIST_sp_body.sql  (SQL*Plus 본체)
--
-- 목적: DMF0072_GET_TEAM_LIST 의 stub (`'ALL'/'ALL'` 만 반환) 을 As-Is 로직 1:1 변환 본체로 교체
--
-- As-Is 원천 (Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP6_DDL.sql:19847):
--   CREATE procedure [dbo].[SCM0001_GET_TEAM_BY_DIVISION] @p_division_id NVARCHAR(18)
--   SELECT DISTINCT B.DEPT_ID AS CODE, B.DEPT_NAME_KO AS NAME
--     FROM SCM_MST_SITE A WITH(NOLOCK), SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK)
--    WHERE A.SITE_TYPE='SALES' AND A.DEPT_ID=B.DEPT_ID
--      AND CASE WHEN @p_division_id='ALL' THEN 'ALL' ELSE A.DIVISION_ID END
--           IN (XML split @p_division_id ',')
--
-- 변환 의무 (메모리 feedback_asis_to_tobe_sp_no_omission):
--   - As-Is SQL 의 JOIN/필터/콤마 split 1:1 의미 보존
--   - WITH(NOLOCK) 제거 (Oracle 자동 read consistency)
--   - XML split → SCM_MGR.UF_FX_STRING_SPLIT (메인 SP 와 일관)
--   - signature P_DIVISION_ID 단일 인자 그대로 (As-Is 와 1:1)
--
-- 변경 전 상태 (53_diagnose 확인):
--   - body 8 lines, SELECT 'ALL' 단일행 반환만 함
--
-- 영향:
--   - DMF0072 화면의 Team 콤보가 실제 dept list 반환 (현재 'ALL' 만)
--   - Division=40 (자동차사업부) site 의 DEPT_ID 가 '-' 로 저장되어 있어 매칭 0건 — 운영 데이터 별도 작업
--
-- BLOCK:
--   B1 DMF0072_GET_TEAM_LIST  : CREATE OR REPLACE (As-Is 1:1 변환)
--   B2 사후 카운트 + 호출 테스트
--
-- 멱등성: CREATE OR REPLACE
-- 작성: 2026-06-02 (DMF0072 격차 C 적용)
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET LINESIZE 200
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : DMF0072_GET_TEAM_LIST body — As-Is SCM0001_GET_TEAM_BY_DIVISION 1:1 변환 ===
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0072_GET_TEAM_LIST (
    P_DIVISION_ID VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR
) AS
BEGIN
    -- As-Is SCM0001_GET_TEAM_BY_DIVISION 1:1 변환
    --   - SCM_MST_SITE A (SITE_TYPE='SALES') ⋈ SCM_MST_SSO_DEPT_INFO B (DEPT_ID 매칭)
    --   - P_DIVISION_ID 'ALL' 또는 콤마 split IN 매칭
    --   - WITH(NOLOCK) 제거 (Oracle read consistency)
    --   - XML split → UF_FX_STRING_SPLIT (메인 SP P_DMF0072_GET_NNMASTER_MAPPING 과 일관)
    OPEN O_RC1 FOR
      SELECT DISTINCT
             B.DEPT_ID      AS CODE,
             B.DEPT_NAME_KO AS NAME
        FROM SCM_MGR.SCM_MST_SITE          A,
             SCM_MGR.SCM_MST_SSO_DEPT_INFO B
       WHERE A.SITE_TYPE = 'SALES'
         AND A.DEPT_ID   = B.DEPT_ID
         AND (P_DIVISION_ID IS NULL
              OR P_DIVISION_ID = 'ALL'
              OR A.DIVISION_ID IN (
                  SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DIVISION_ID, ','))
                   WHERE TOKEN IS NOT NULL
              )
             )
       ORDER BY 2;
END DMF0072_GET_TEAM_LIST;
/

PROMPT === BLOCK 2 : 사후 카운트 + 호출 테스트 ===
SELECT 'POST: TEAM SP VALID' AS K, STATUS AS V FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='DMF0072_GET_TEAM_LIST' AND OBJECT_TYPE='PROCEDURE';
SELECT 'POST: TEAM body line count' AS K, COUNT(*) AS V FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='DMF0072_GET_TEAM_LIST';

DECLARE
    V_RC SYS_REFCURSOR;
    V_CODE VARCHAR2(100);
    V_NAME VARCHAR2(300);
    V_CNT  PLS_INTEGER := 0;
BEGIN
    -- DIV='ALL' (모든 division 의 모든 dept)
    SCM_MGR.DMF0072_GET_TEAM_LIST('ALL', V_RC);
    LOOP
        FETCH V_RC INTO V_CODE, V_NAME;
        EXIT WHEN V_RC%NOTFOUND;
        V_CNT := V_CNT + 1;
        EXIT WHEN V_CNT >= 5;
    END LOOP;
    CLOSE V_RC;
    DBMS_OUTPUT.PUT_LINE('POST: TEAM_LIST(ALL) rows (max 5) = ' || V_CNT);

    -- DIV='81' (전지 등 dept 매핑 있는 division)
    SCM_MGR.DMF0072_GET_TEAM_LIST('81', V_RC);
    V_CNT := 0;
    LOOP
        FETCH V_RC INTO V_CODE, V_NAME;
        EXIT WHEN V_RC%NOTFOUND;
        V_CNT := V_CNT + 1;
        EXIT WHEN V_CNT >= 5;
    END LOOP;
    CLOSE V_RC;
    DBMS_OUTPUT.PUT_LINE('POST: TEAM_LIST(81) rows (max 5) = ' || V_CNT);

    -- DIV='40' (자동차사업부 — 현재 데이터로 0 row 예상)
    SCM_MGR.DMF0072_GET_TEAM_LIST('40', V_RC);
    V_CNT := 0;
    LOOP
        FETCH V_RC INTO V_CODE, V_NAME;
        EXIT WHEN V_RC%NOTFOUND;
        V_CNT := V_CNT + 1;
        EXIT WHEN V_CNT >= 5;
    END LOOP;
    CLOSE V_RC;
    DBMS_OUTPUT.PUT_LINE('POST: TEAM_LIST(40) rows (max 5) = ' || V_CNT
                         || ' [참고: div=40 site 의 DEPT_ID 가 ''-''로 운영 데이터 부재 시 0 정상]');
END;
/

COMMIT;
PROMPT === COMPLETE ===
EXIT;
