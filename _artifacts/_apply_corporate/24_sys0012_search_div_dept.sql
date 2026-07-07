-- =====================================================================================
-- SYS0012 GET SP 확장 — Div / Department 조회조건 필터 추가 (2026-06-28 사용자 요구)
--   기존 P_SYS0012_GET_APPROVAL_LIST 는 User ID/날짜/Status 만 필터 → AS-IS(SCM0009) parity 위해
--   P_DIVISION_ID / P_DEPARTMENT IN 파라미터 + WHERE 2절 추가 (P_STATUS 다음, O_RC 앞).
--   필터 컬럼: Div = T.DIVISION_ID (SCM_MST_AUTH_REQUEST), Department = U.DEPT_ID (SCM_ADM_USER_M).
--   기존 body 최소 변경 (signature 2줄 + WHERE 2줄). 나머지 SELECT/EXCEPTION 원본 동일.
--   ⚠️ PROC_M 동기화 필수 — 25_sys0012_proc_m_sync.py 와 함께 적용 (positional 일치).
--   적용: ora.py exec _artifacts/_apply_corporate/24_sys0012_search_div_dept.sql (또는 sqlplus)
-- =====================================================================================
CREATE OR REPLACE PROCEDURE SCM_MGR.P_SYS0012_GET_APPROVAL_LIST (
    P_SES_USER_ID    IN  VARCHAR2,
    P_USER_ID        IN  VARCHAR2,
    P_START_DATE     IN  VARCHAR2,
    P_END_DATE       IN  VARCHAR2,
    P_STATUS         IN  VARCHAR2,
    P_DIVISION_ID    IN  VARCHAR2,
    P_DEPARTMENT     IN  VARCHAR2,
    O_RC             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR  OUT SYS_REFCURSOR
)
AS
    V_STATUS  VARCHAR2(20) := NVL(P_STATUS, 'REQUEST');
BEGIN
    OPEN O_RC FOR
    SELECT
        (T.USER_ID || ':' || T.GROUP_ID || ':' || T.DIVISION_ID || ':' || T.PLANT_ID) AS REQUEST_ID,
        T.USER_ID                                  AS USER_ID,
        NVL(U.USER_NM,    T.USER_ID)               AS USER_NAME,
        T.GROUP_ID                                 AS GROUP_ID,
        T.GROUP_ID                                 AS GRP_NAME,
        T.DIVISION_ID                              AS DIVISION_ID,
        T.PLANT_ID                                 AS PLANT,
        ''                                         AS CUSTOMER,
        TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD')     AS REQUEST_DATE,
        CASE
          WHEN T.APPROVAL_RESULT = 'APPROVED' THEN 'APPROVED'
          WHEN T.APPROVAL_RESULT = 'REJECT'   THEN 'REJECTED'
          WHEN T.APPROVAL_RESULT = 'REQUESTING' THEN 'REQUEST'
          ELSE 'REQUEST'
        END                                        AS STATUS,
        NVL(T.LAST_UPDATED_BY, '')                 AS APPROVED_BY,
        TO_CHAR(T.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI') AS APPROVED_DATE,
        NVL(T.REJECT_REASON, '')                   AS REASON
    FROM SCM_MGR.SCM_MST_AUTH_REQUEST T
    LEFT JOIN SCM_MGR.SCM_ADM_USER_M U ON U.USER_ID = T.USER_ID
    WHERE (P_USER_ID IS NULL OR P_USER_ID = '' OR T.USER_ID LIKE '%' || P_USER_ID || '%')
      AND (P_START_DATE IS NULL OR P_START_DATE = '' OR T.CREATION_DATE >= TO_DATE(P_START_DATE, 'YYYYMMDD'))
      AND (P_END_DATE   IS NULL OR P_END_DATE   = '' OR T.CREATION_DATE <  TO_DATE(P_END_DATE,   'YYYYMMDD') + 1)
      AND (P_DIVISION_ID IS NULL OR P_DIVISION_ID = '' OR P_DIVISION_ID = 'ALL' OR T.DIVISION_ID = P_DIVISION_ID)
      AND (P_DEPARTMENT IS NULL OR P_DEPARTMENT = '' OR U.DEPT_ID LIKE '%' || P_DEPARTMENT || '%')
      AND (
          V_STATUS = 'ALL'
       OR (V_STATUS = 'REQUEST'  AND NVL(T.APPROVAL_RESULT, 'REQUESTING') IN ('REQUESTING', ''))
       OR (V_STATUS = 'APPROVED' AND T.APPROVAL_RESULT = 'APPROVED')
       OR (V_STATUS = 'REJECTED' AND T.APPROVAL_RESULT = 'REJECT')
      )
    ORDER BY T.CREATION_DATE DESC, T.USER_ID;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
        DECLARE
            V_ERR VARCHAR2(4000) := SUBSTR(SQLERRM, 1, 4000);
        BEGIN
            OPEN O_RC FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_ERR AS MSG FROM DUAL;
        END;
END P_SYS0012_GET_APPROVAL_LIST;
/
