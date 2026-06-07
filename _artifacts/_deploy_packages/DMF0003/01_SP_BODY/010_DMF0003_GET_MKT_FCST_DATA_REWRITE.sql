/*=============================================================================================
 * File         : 010_DMF0003_GET_MKT_FCST_DATA_REWRITE.sql
 * Description  : 메인 GET SP — 실제 AS-IS DM_PLN_MKT_FCST 데이터 SELECT (449,315 rows)
 *              :   - 22 IN + 4 OUT signature 유지 (PROC_M / BE 영향 없음)
 *              :   - DM_PLN_MKT_FCST (fact) LEFT JOIN SCM_MST_PROJECT (메타)
 *              :   - long format: row 별 YYYYMMDD + QTY (FE longToPivot 이 wide PIVOT 변환)
 *===========================================================================================*/

CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_MKT_FCST_DATA
( P_DIVISION_ID      IN  VARCHAR2
, P_SCM_SITE_ID      IN  VARCHAR2
, P_PLANT_SITE_ID    IN  VARCHAR2
, P_TEAM_ID          IN  VARCHAR2
, P_CUSTOMER         IN  VARCHAR2
, P_BIZ_TYPE         IN  VARCHAR2
, P_PROJECT_CODE     IN  VARCHAR2
, P_ITEM_ID          IN  VARCHAR2
, P_FROM_YYYYMMDD    IN  VARCHAR2
, P_TO_YYYYMMDD      IN  VARCHAR2
, P_CREATED_BY       IN  VARCHAR2
, P_USER_GROUP       IN  VARCHAR2
, P_ITEM_TYPE        IN  VARCHAR2
, P_OWNER            IN  VARCHAR2
, P_QTY_YN           IN  VARCHAR2
, P_CELL_YN          IN  VARCHAR2
, P_INVALID_EXEC     IN  VARCHAR2
, P_AS_YN            IN  VARCHAR2
, P_USER_DEPT_ID     IN  VARCHAR2
, P_SENDER_CODE      IN  VARCHAR2
, P_USER_ID          IN  VARCHAR2
, P_MENU_ID          IN  VARCHAR2
, O_RC1              OUT SYS_REFCURSOR
, O_RC2              OUT SYS_REFCURSOR
, O_RC3              OUT SYS_REFCURSOR
, O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
AS
    v_err VARCHAR2(300);
BEGIN
    -- O_RC1: 실제 AS-IS DM_PLN_MKT_FCST 데이터 (long format)
    -- JOIN SCM_MST_PROJECT 로 zproject / Project Owner / Nick Name 등 채움
    OPEN O_RC1 FOR
        SELECT
            F.DIVISION_ID                                  AS DIVISION_ID,
            CAST(NULL AS VARCHAR2(50))                     AS DEPT_ID,
            CAST(NULL AS VARCHAR2(100))                    AS DEPT_NAME_KO,
            CAST(NULL AS VARCHAR2(50))                     AS TEAM_ID,
            CAST(NULL AS VARCHAR2(100))                    AS TEAM_NAME_KO,
            -- End Customer: SCM_SITE_ID 의 prefix (예: 'ABS_US_LRP' → 'ABS') 또는 PROJECT_CODE
            NVL(SUBSTR(F.SCM_SITE_ID, 1, INSTR(F.SCM_SITE_ID||'_', '_') - 1), F.PROJECT_CODE) AS END_CUSTOMER,
            P.BIZ_TYPE                                     AS BIZ_TYPE,
            F.SCM_SITE_ID                                  AS SCM_SITE_ID,
            F.PLANT_SITE_ID                                AS PLANT_SITE_ID,
            F.PROJECT_CODE                                 AS PROJECT_CODE,
            P.PROJECT_NAME                                 AS PROJECT_CODE_NAME,
            P.PROJECT_NAME                                 AS PROJECT_NAME,
            F.ITEM_ID                                      AS ITEM_ID,
            P.PROJECT_NAME                                 AS ITEM_NAME,
            P.GPLM_PROJECT_CODE                            AS NICK_NAME,
            F.INCOTERMS                                    AS INCOTERMS,
            CAST(NULL AS VARCHAR2(20))                     AS ITEM_TYPE,
            F.FCST_TYPE                                    AS FCST_TYPE,
            F.DOM_EXP                                      AS DOM_EXP,
            P.PROJECT_STATUS                               AS PROJECT_STATUS,
            P.PROJECT_OWNER                                AS PROJECT_OWNER,
            CAST(NULL AS VARCHAR2(50))                     AS OWNER,
            CAST(NULL AS VARCHAR2(50))                     AS SOLD_TO_CUSTOMER,
            CAST(NULL AS VARCHAR2(20))                     AS CELL_TYPE,
            CAST(NULL AS VARCHAR2(20))                     AS CITY,
            CAST(NULL AS VARCHAR2(100))                    AS CITY_NAME,
            CAST(NULL AS VARCHAR2(10))                     AS COUNTRY,
            CAST(NULL AS VARCHAR2(100))                    AS COUNTRY_NAME,
            CAST('' AS VARCHAR2(1))                        AS EDIT_FLAG,
            CAST(NULL AS VARCHAR2(50))                     AS MEASURE_GROUP,
            F.MEASURE                                      AS MEASURE,
            F.YYYYMMDD                                     AS YYYYMMDD,
            F.QTY                                          AS QTY,
            CAST(NULL AS VARCHAR2(50))                     AS COLUMN_NAME,
            CAST(NULL AS VARCHAR2(100))                    AS COLUMN_LABEL,
            CAST(NULL AS VARCHAR2(50))                     AS SMALL_LABEL_NAME,
            CAST(NULL AS VARCHAR2(50))                     AS LARGE_LABEL_NAME,
            CAST(NULL AS VARCHAR2(10))                     AS DAY_CODE,
            CAST(NULL AS VARCHAR2(10))                     AS DIVISION_ID40,
            CAST(NULL AS VARCHAR2(50))                     AS END_CUSTOMER40,
            CAST(NULL AS VARCHAR2(50))                     AS SCM_SITE_ID40,
            CAST(NULL AS VARCHAR2(50))                     AS ITEM_ID40,
            CAST('N' AS VARCHAR2(1))                       AS VMI_YN
        FROM SCM_MGR.DM_PLN_MKT_FCST F
        LEFT JOIN SCM_MGR.SCM_MST_PROJECT P
            ON F.DIVISION_ID = P.DIVISION_ID
           AND F.PROJECT_CODE = P.PROJECT_CODE
        WHERE F.DIVISION_ID = P_DIVISION_ID
          AND F.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
          AND (P_PROJECT_CODE = 'ALL' OR F.PROJECT_CODE = P_PROJECT_CODE)
          AND (P_SCM_SITE_ID = 'ALL' OR F.SCM_SITE_ID = P_SCM_SITE_ID)
          AND (P_ITEM_ID = 'ALL' OR F.ITEM_ID = P_ITEM_ID)
          AND ROWNUM <= 10000
        ORDER BY F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID,
                 F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD;

    -- O_RC2: 8주 bucket (Div 40 전용)
    OPEN O_RC2 FOR
        SELECT BASIS_YYYYMMDD, ISO_WEEK, CALENDAR_YYYY
        FROM SCM_MGR.SCM_SYS_CALENDAR_M
        WHERE BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
          AND ROWNUM <= 56;

    -- O_RC3: 현재 주차
    OPEN O_RC3 FOR
        SELECT BASIS_YYYYMMDD, ISO_WEEK, CALENDAR_YYYY
        FROM SCM_MGR.SCM_SYS_CALENDAR_M
        WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
          AND ROWNUM <= 1;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CAST(NULL AS VARCHAR2(10)) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        v_err := SUBSTR(SQLERRM, 1, 200);
        OPEN O_RC1 FOR SELECT NULL AS DIVISION_ID FROM DUAL WHERE 1=0;
        OPEN O_RC2 FOR SELECT NULL AS BASIS_YYYYMMDD FROM DUAL WHERE 1=0;
        OPEN O_RC3 FOR SELECT NULL AS BASIS_YYYYMMDD FROM DUAL WHERE 1=0;
        OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, v_err AS MSG, 'ERROR' AS EVENT FROM DUAL;
END DMF0003_GET_MKT_FCST_DATA;
/
SHOW ERRORS
