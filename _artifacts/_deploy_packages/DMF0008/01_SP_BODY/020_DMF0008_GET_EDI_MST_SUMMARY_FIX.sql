--==============================================================================
-- 020_DMF0008_GET_EDI_MST_SUMMARY_FIX.sql
--
-- 목적:
--   DMF0008_GET_EDI_MST_SUMMARY 의 line 132 `OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL;`
--   가 메인 cursor (line 66 OPEN O_RC1 FOR SELECT T.DIVISION_ID...) 결과를 덮어씀.
--   FE 가 success + 1 row (DUMMY 컬럼) 받음 = grid 비어 보임.
--
-- 진단 결과 (DIAG 1-5):
--   - 권한/grant 모두 OK (DIAG 3/6)
--   - 마스터 div=81 = 213,981 rows (DIAG 4)
--   - 직접 query (SP body logic 동일) div=81 = 9 rows 정상 (DIAG 5)
--   - SP body line 66/132 OPEN O_RC1 두 번 → 메인 → DUMMY 덮어쓰기
--   - DIAG 3 IF/THEN/ELSE grep = 0건 → line 132 무조건 흐름
--
-- As-Is 비교 (MSSQL line 76419-76577):
--   - As-Is = 메인 SELECT 1개. DUMMY OPEN 없음.
--   - To-Be 변환 시 자동 생성된 fallback OPEN 으로 추정 → 메인 결과 파괴.
--
-- Fix:
--   line 132 `OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL;` 만 제거.
--   line 133 `OPEN O_RC3 FOR SELECT NULL AS DUMMY FROM DUAL;` 유지 (O_RC3 OUT param 안전성).
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250

PROMPT === BLOCK 1 : 현재 SP body 백업 (audit 용) ===

DECLARE
  v_ddl CLOB;
BEGIN
  v_ddl := DBMS_METADATA.GET_DDL('PROCEDURE', 'DMF0008_GET_EDI_MST_SUMMARY', 'SCM_MGR');
  DBMS_OUTPUT.PUT_LINE('-- Current DDL length = ' || DBMS_LOB.GETLENGTH(v_ddl));
  DBMS_OUTPUT.PUT_LINE('-- Backup 권장: spool C:\tmp\DMF0008_SUMMARY_backup.sql + SELECT DBMS_METADATA.GET_DDL(...) FROM DUAL');
END;
/

PROMPT === BLOCK 2 : SP 재생성 (line 132 의 DUMMY OPEN O_RC1 제거) ===

CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0008_GET_EDI_MST_SUMMARY
(
  p_FROM_YYYYMMDD VARCHAR2,  --안쓰임
  p_TO_YYYYMMDD   VARCHAR2,  --안쓰임
  p_DIVISION_ID   VARCHAR2,  --쓰임
  p_user_id       VARCHAR2,
  p_menu_id       VARCHAR2,
  O_RC1           OUT SYS_REFCURSOR,
  O_RC3           OUT SYS_REFCURSOR,
  O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0008_GET_EDI_MST_SUMMARY
 * Description  : ERP, EDI MASTER DATA 정비 SUMMARY
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.04.05  kdmcc14   ERP, EDI MASTER DATA 정비 SUMMARY
 2023.09.20  chutoc730 제외 ITEM_ID 적용 (DM_DNM_EDI_CALLOFF_ITEM_EXCLUDE)
 2024.04.18  HMIN      [E20240405-001867] 예외 처리 칼럼 추가
 2024.07.03  JSSBAE    [E20240701-000472] 업데이트 범위 개선
 2024-12-31  dsiol     [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
 2025-01-21  dsiol     2차배포
 2026-03-15  김준규    [PJ20264226] NextSCM Pilot 설계 및 개발
 2026-05-15  전병주    컴파일 오류 수정
 2026-06-05  Claude    line 132 OPEN O_RC1 FOR DUMMY 제거 (메인 cursor 덮어쓰기 사고 fix)
*/
AS
  v_FROM_YYYYMMDD VARCHAR2(4000 CHAR);
  v_TO_YYYYMMDD   VARCHAR2(4000 CHAR);
  v_in_para_data  VARCHAR2(4000);
  V_LOG_TYPE      VARCHAR2(20)        := NULL;
  N_LOG_COUNT     NUMBER              := 0;
  V_LOG_MESSAGE   VARCHAR2(4000 CHAR) := NULL;
  V_DESCRIPTION   VARCHAR2(4000 CHAR) := NULL;
  D_EVENT_DATE    DATE                := SYSDATE;
  V_PROC_INPUT    CLOB                := NULL;
  V_SQL_CODE      VARCHAR2(100)       := NULL;
  V_SQL_ERRMSG    VARCHAR2(4000 CHAR) := NULL;
  V_BACKTRACE     VARCHAR2(4000 CHAR) := NULL;
  v_program_name  VARCHAR2(150 CHAR)  := $$PLSQL_UNIT;
BEGIN
  v_in_para_data := JSON_OBJECT(
    'p_FROM_YYYYMMDD' VALUE p_FROM_YYYYMMDD,
    'p_TO_YYYYMMDD'   VALUE p_TO_YYYYMMDD,
    'p_DIVISION_ID'   VALUE p_DIVISION_ID,
    'p_user_id'       VALUE p_user_id,
    'p_menu_id'       VALUE p_menu_id
  );
  V_PROC_INPUT := v_in_para_data;

  -- 현재시점으로 과거 52주 구간의 가장 최신인 EDI 데이터를 가져 온다.
  v_FROM_YYYYMMDD := TO_CHAR(TRUNC(SYSDATE, 'IW') - (52 * 7), 'YYYYMMDD');

  BEGIN
    OPEN O_RC1 FOR
      SELECT T.DIVISION_ID                  AS DIVISION_ID
           , T.SENDER_NAME                   AS EDI_SENDER_NAME
           , SUM(GSCM_MASTER_DATA)           AS GSCM_MASTER_DATA
           , SUM(SUCCESS)                    AS SUCCESS
           , SUM("EXCEPTION")                AS EXCEPTION_DATA
           , COUNT(1)                        AS CNT
           , tei.EDIT_YN                     AS EDIT_YN
        FROM (
              SELECT A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, A.UNLOADING_POINT
                   , A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE
                   , A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, A.SCM_SITE_ID
                   , A.STATUS_CODE, A.SSPM_STATUS, A.EDI_INCOTERMS
                   , A.PROJECT_CODE, B.END_CUSTOMER, A.SALES_PLANT_SITE_STATUS, A.ERP_STATUS
                   /* 2025.01.10 Philsu Park 수정 */
                   , CASE WHEN A.STATUS_CODE IN ('U', 'E') AND NVL(A.EXCEPTION_FLAG, NULL) != 'Y' THEN 1 ELSE 0 END AS GSCM_MASTER_DATA
                   , CASE WHEN A.STATUS_CODE = 'S'         AND NVL(A.EXCEPTION_fLAG, NULL) != 'Y' THEN 1 ELSE 0 END AS SUCCESS
                   , CASE WHEN A.EXCEPTION_FLAG = 'Y'      THEN 1 ELSE 0 END AS "EXCEPTION"
                FROM DM_DNM_EDI_CALLOFF_ITEM A
                LEFT OUTER JOIN SCM_MST_SITE B
                  ON  A.DIVISION_ID = B.DIVISION_ID
                  AND A.SCM_SITE_ID = B.SCM_SITE_ID
                  AND B.SITE_TYPE   = 'SALES'
                  AND B.VALID_YN    = 'Y'
               WHERE A.CREATE_DATE  >= v_FROM_YYYYMMDD
                 AND A.DIVISION_ID   = p_DIVISION_ID
                 AND A.ERP_STATUS    = 'S'  -- ERP Status 정상인 대상만 Count
                 AND LTRIM(RTRIM(A.YYYYMMDD)) NOT IN ('444444')  /* 20240422 추가 */
               GROUP BY A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, A.UNLOADING_POINT
                      , A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE
                      , A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, A.SCM_SITE_ID
                      , A.STATUS_CODE, A.SSPM_STATUS, A.EDI_INCOTERMS
                      , A.PROJECT_CODE, B.END_CUSTOMER, A.SALES_PLANT_SITE_STATUS
                      , A.ERP_STATUS, A.EXCEPTION_FLAG
             ) T
        INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
          ON tei.UNIT_ID = T.DIVISION_ID
       GROUP BY T.DIVISION_ID, T.SENDER_NAME, tei.EDIT_YN
       ORDER BY T.SENDER_NAME;

    -- 2026-06-05 fix : OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL; (제거 — 메인 cursor 덮어쓰기)
    -- O_RC3 는 As-Is 에 없으나 OUT param 안전성 위해 DUMMY 유지
    OPEN O_RC3 FOR SELECT NULL AS DUMMY FROM DUAL;
  END;

  OPEN O_RESULT_CURSOR FOR
    SELECT '1' AS RESULT_CODE
         , CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG
         , 'SUCCESS' AS ERR_EVENT
      FROM DUAL;

EXCEPTION
  WHEN OTHERS THEN
    V_LOG_TYPE   := 'ERROR';
    V_SQL_CODE   := TO_CHAR(SQLCODE);
    V_SQL_ERRMSG := SQLERRM;
    V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PR_SCM_SYS_LOG_BATCH(
      $$PLSQL_UNIT,
      V_LOG_TYPE,
      N_LOG_COUNT,
      V_LOG_MESSAGE,
      V_DESCRIPTION,
      D_EVENT_DATE,
      V_PROC_INPUT,
      V_SQL_CODE,
      V_SQL_ERRMSG,
      V_BACKTRACE
    );
    RAISE_APPLICATION_ERROR(
      -20001,
      '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE
        || ' / SQLERRM='   || SQLERRM
        || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
    );
END DMF0008_GET_EDI_MST_SUMMARY;
/

PROMPT === BLOCK 3 : 컴파일 STATUS 확인 ===

SELECT object_name, object_type, status, last_ddl_time
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND object_name = 'DMF0008_GET_EDI_MST_SUMMARY'
   AND object_type = 'PROCEDURE';

PROMPT === BLOCK 4 : 컴파일 오류 (있다면) ===

SELECT line, position, text
  FROM all_errors
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_SUMMARY'
   AND type = 'PROCEDURE'
 ORDER BY sequence;

PROMPT === BLOCK 5 : OPEN 구문 재확인 (line 132 제거 검증) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_SUMMARY'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'OPEN\s+O_', 'i')
 ORDER BY line;

PROMPT === BLOCK 6 : 정정 후 호출 검증 (div=81) ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_rc3 SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_division_id     VARCHAR2(20);
  v_edi_sender_name VARCHAR2(100);
  v_gscm            NUMBER;
  v_success         NUMBER;
  v_exception_data  NUMBER;
  v_total_cnt       NUMBER;
  v_edit_yn         VARCHAR2(1);
BEGIN
  DMF0008_GET_EDI_MST_SUMMARY(
    P_FROM_YYYYMMDD => '20240101',
    P_TO_YYYYMMDD   => '20261231',
    P_DIVISION_ID   => '81',
    P_USER_ID       => 'minyonglee1',
    P_MENU_ID       => 'DMF0008',
    O_RC1           => v_rc1,
    O_RC3           => v_rc3,
    O_RESULT_CURSOR => v_result_rc
  );

  LOOP
    FETCH v_rc1 INTO v_division_id, v_edi_sender_name, v_gscm, v_success, v_exception_data, v_total_cnt, v_edit_yn;
    EXIT WHEN v_rc1%NOTFOUND OR v_cnt >= 5;
    v_cnt := v_cnt + 1;
    DBMS_OUTPUT.PUT_LINE('row#' || v_cnt
                      || ' DIV=' || v_division_id
                      || ' SENDER=' || v_edi_sender_name
                      || ' SUCCESS=' || v_success
                      || ' CNT=' || v_total_cnt);
  END LOOP;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc3; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_result_rc; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('--- 정정 후 div=81 row sample = ' || v_cnt || ' (이전: 1 DUMMY → 정상: 9 rows 일부)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
END;
/

PROMPT === 판독 ===
PROMPT - BLOCK 3 : STATUS=VALID
PROMPT - BLOCK 4 : 0 rows (compile error 없음)
PROMPT - BLOCK 5 : OPEN O_RC1 = 1번 (line ~? 메인) / OPEN O_RC3 = 1번 (DUMMY) / OPEN O_RESULT_CURSOR = 1번
PROMPT - BLOCK 6 : div=81 row sample > 0 (정상 9 row 중 일부 출력)
PROMPT - FE 재조회 시 grid 데이터 표시됨
