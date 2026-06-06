--==============================================================================
-- 130_DMF0008_Summary_EXCEPTION_Capture.sql
--
-- 목적:
--   DIAG 4/5 에서 SP 가 fallback dummy cursor (NULL AS DUMMY) 1 row 만 반환 →
--   SP 내부 EXCEPTION 절로 빠지는 것 확인됨. 실제 SQLCODE / SQLERRM 캡쳐.
--
-- 발견 사항:
--   SP body line 132 : OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL;
--   실제 source : DM_DNM_EDI_CALLOFF_ITEM (110 SQL 의 DM_DNM_EDI_SUMMARY 는 잘못)
--   권한 필터  : PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : SP body 의 EXCEPTION 절 + 마지막 line 영역 (130-160) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_SUMMARY'
   AND type = 'PROCEDURE'
   AND line BETWEEN 125 AND 160
 ORDER BY line;

PROMPT === DIAG 2 : 종속 객체 STATUS 확인 (PKG_SCM_USER_MNU + 마스터 테이블) ===

SELECT owner, object_name, object_type, status, last_ddl_time
  FROM all_objects
 WHERE object_name IN ('PKG_SCM_USER_MNU', 'DM_DNM_EDI_CALLOFF_ITEM', 'SCM_MST_SITE',
                       'DMF0008_GET_EDI_MST_SUMMARY')
   AND object_type IN ('PROCEDURE', 'PACKAGE', 'PACKAGE BODY', 'TABLE', 'SYNONYM')
 ORDER BY owner, object_name, object_type;

PROMPT === DIAG 3 : PKG_SCM_USER_MNU.PR_SCM_EDIT_YN 단독 호출 (minyonglee1, DMF0008) ===

DECLARE
  v_cnt PLS_INTEGER := 0;
BEGIN
  FOR rec IN (SELECT * FROM TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN('minyonglee1', 'DMF0008'))) LOOP
    v_cnt := v_cnt + 1;
    IF v_cnt <= 10 THEN
      DBMS_OUTPUT.PUT_LINE('row#' || v_cnt || ' UNIT_ID=' || rec.UNIT_ID || ' EDIT_YN=' || rec.EDIT_YN);
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('--- TOTAL PR_SCM_EDIT_YN rows = ' || v_cnt);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('PR_SCM_EDIT_YN ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 300));
END;
/

PROMPT === DIAG 4 : DM_DNM_EDI_CALLOFF_ITEM div=81 + 52주 + ERP_STATUS=S 실제 row 수 ===

SELECT COUNT(*) AS rows_81_52w
  FROM SCM_MGR.DM_DNM_EDI_CALLOFF_ITEM
 WHERE DIVISION_ID = '81'
   AND ERP_STATUS = 'S'
   AND CREATE_DATE >= TO_CHAR(TRUNC(SYSDATE, 'IW') - (52*7), 'YYYYMMDD')
   AND LTRIM(RTRIM(YYYYMMDD)) NOT IN ('444444');

SELECT COUNT(*) AS rows_40_52w
  FROM SCM_MGR.DM_DNM_EDI_CALLOFF_ITEM
 WHERE DIVISION_ID = '40'
   AND ERP_STATUS = 'S'
   AND CREATE_DATE >= TO_CHAR(TRUNC(SYSDATE, 'IW') - (52*7), 'YYYYMMDD')
   AND LTRIM(RTRIM(YYYYMMDD)) NOT IN ('444444');

PROMPT === DIAG 5 : SP 호출 + 실제 EXCEPTION SQLCODE/SQLERRM 캡쳐 (DIAG 4 와 동일 logic anonymous block 으로) ===

DECLARE
  v_FROM_YYYYMMDD VARCHAR2(8);
  v_cnt PLS_INTEGER := 0;
  TYPE r_rec IS RECORD (
    DIVISION_ID      VARCHAR2(20),
    EDI_SENDER_NAME  VARCHAR2(100),
    GSCM_MASTER_DATA NUMBER,
    SUCCESS_CNT      NUMBER,
    EXCEPTION_DATA   NUMBER,
    CNT              NUMBER,
    EDIT_YN          VARCHAR2(1)
  );
  v_rec r_rec;
  v_rc SYS_REFCURSOR;
BEGIN
  v_FROM_YYYYMMDD := TO_CHAR(TRUNC(SYSDATE, 'IW') - (52 * 7), 'YYYYMMDD');
  DBMS_OUTPUT.PUT_LINE('v_FROM_YYYYMMDD = ' || v_FROM_YYYYMMDD);

  -- SP body line 66-115 와 동등한 query 직접 실행 (EXCEPTION 캡쳐)
  OPEN v_rc FOR
    SELECT T.DIVISION_ID                     AS DIVISION_ID
         , T.SENDER_NAME                     AS EDI_SENDER_NAME
         , SUM(GSCM_MASTER_DATA)             AS GSCM_MASTER_DATA
         , SUM(SUCCESS)                      AS SUCCESS_CNT
         , SUM("EXCEPTION")                  AS EXCEPTION_DATA
         , COUNT(1)                          AS CNT
         , tei.EDIT_YN
      FROM (
            SELECT A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, A.UNLOADING_POINT
                 , A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE
                 , A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, A.SCM_SITE_ID
                 , A.STATUS_CODE, A.SSPM_STATUS, A.EDI_INCOTERMS
                 , A.PROJECT_CODE, B.END_CUSTOMER, A.SALES_PLANT_SITE_STATUS, A.ERP_STATUS
                 , CASE WHEN A.STATUS_CODE IN ('U', 'E') AND NVL(A.EXCEPTION_FLAG, NULL) != 'Y' THEN 1 ELSE 0 END AS GSCM_MASTER_DATA
                 , CASE WHEN A.STATUS_CODE = 'S' AND NVL(A.EXCEPTION_fLAG, NULL) != 'Y' THEN 1 ELSE 0 END AS SUCCESS
                 , CASE WHEN A.EXCEPTION_FLAG = 'Y' THEN 1 ELSE 0 END AS "EXCEPTION"
              FROM DM_DNM_EDI_CALLOFF_ITEM A
              LEFT OUTER JOIN SCM_MST_SITE B
                ON A.DIVISION_ID = B.DIVISION_ID
               AND A.SCM_SITE_ID = B.SCM_SITE_ID
               AND B.SITE_TYPE  = 'SALES'
               AND B.VALID_YN   = 'Y'
             WHERE A.CREATE_DATE  >= v_FROM_YYYYMMDD
               AND A.DIVISION_ID   = '81'
               AND A.ERP_STATUS    = 'S'
               AND LTRIM(RTRIM(A.YYYYMMDD)) NOT IN ('444444')
             GROUP BY A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, A.UNLOADING_POINT
                    , A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE
                    , A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, A.SCM_SITE_ID
                    , A.STATUS_CODE, A.SSPM_STATUS, A.EDI_INCOTERMS
                    , A.PROJECT_CODE, B.END_CUSTOMER, A.SALES_PLANT_SITE_STATUS, A.ERP_STATUS, A.EXCEPTION_FLAG
           ) T
      INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN('minyonglee1', 'DMF0008')) tei
        ON tei.UNIT_ID = T.DIVISION_ID
     GROUP BY T.DIVISION_ID, T.SENDER_NAME, tei.EDIT_YN;

  LOOP
    FETCH v_rc INTO v_rec;
    EXIT WHEN v_rc%NOTFOUND OR v_cnt >= 10;
    v_cnt := v_cnt + 1;
    DBMS_OUTPUT.PUT_LINE('row#' || v_cnt || ' DIV=' || v_rec.DIVISION_ID
                       || ' SENDER=' || v_rec.EDI_SENDER_NAME
                       || ' SUCCESS=' || v_rec.SUCCESS_CNT
                       || ' CNT=' || v_rec.CNT
                       || ' EDIT=' || v_rec.EDIT_YN);
  END LOOP;
  CLOSE v_rc;
  DBMS_OUTPUT.PUT_LINE('--- 직접 query 결과 div=81 = ' || v_cnt || ' rows (sample)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('DIRECT QUERY ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 300));
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === DIAG 6 : SCMD_APP 단독 grant check (DM_DNM_EDI_CALLOFF_ITEM + SCM_MST_SITE + PKG_SCM_USER_MNU) ===

SELECT grantee, table_name, privilege
  FROM all_tab_privs
 WHERE grantee IN ('SCMD_APP', 'PUBLIC')
   AND table_name IN ('DM_DNM_EDI_CALLOFF_ITEM', 'SCM_MST_SITE', 'PKG_SCM_USER_MNU')
 ORDER BY table_name, grantee, privilege;

PROMPT === 판독 ===
PROMPT - DIAG 1 EXCEPTION 절 SQLERRM 출력 logic 있는지 (보통 swallow 패턴이면 안 보임)
PROMPT - DIAG 2 모든 객체 VALID + SCMD_APP synonym 확인
PROMPT - DIAG 3 PR_SCM_EDIT_YN minyonglee1+DMF0008 row > 0 → 권한 있음. = 0 → EXCEPTION 원인 = 권한 없음
PROMPT - DIAG 4 div=81 마스터 row > 0 → 데이터 있음 (110 SQL 의 DM_DNM_EDI_SUMMARY 는 잘못)
PROMPT - DIAG 5 직접 query 에서 ERR SQLCODE 캡쳐 (SP 의 EXCEPTION 원인 동일)
PROMPT - DIAG 6 SCMD_APP 권한 (PR_SCM_EDIT_YN EXECUTE / 마스터 테이블 SELECT) 누락 시 SP 가 EXCEPTION
