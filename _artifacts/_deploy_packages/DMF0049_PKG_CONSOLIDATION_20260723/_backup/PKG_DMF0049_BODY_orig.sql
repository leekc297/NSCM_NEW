
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SCM_MGR"."PKG_DMF0049" IS

    PROCEDURE P_DMF0049_GET_MEASURE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
         * Program ID   : DMF0049_GET_MEASURE
         * Description  :  Sales ETC Report 메저 가져오기
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2020/03/30 HWI1993   Initial Release -- dmf0044 에서 복사해서 생성
         * 2020/05/04 HWI1993   DIVISION_ID 를 WHERE 절에 추가
         * 2020/06/10 HWI1993   40이 아닌 경우 USD 추가
         * 2021/01/28 P.C.I   [C20210125-000207] 소형사업부 RTF_SYS_RP Measure 추가
           2022.04.25 HWI1993   GM JV 작업
           2026.03.14 김준규   [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS

        V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE     VARCHAR2(30 CHAR);
        N_LOG_COUNT    INTEGER := 0;
        V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
        V_DESCRIPTION  VARCHAR2(500 CHAR);
        D_EVENT_DATE   DATE;
        V_IN_PARA_DATA VARCHAR2(4000);
    BEGIN

        V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID);

        IF P_DIVISION_ID = '40' THEN
            OPEN O_RC1 FOR
                SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME NAME, TEI.EDIT_YN
                FROM   SCM_MST_SHEET_MEASURE A
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = A.DIVISION_ID
                WHERE  1 = 1
                AND    PROGRAM_ID = 'DMF0049'
                AND    SHEET_NAME IN ( 'MDF Reports','mdfReports' )
                AND    COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'RTF_SYS_RP') --[C20210125-000207] 소형사업부 RTF_SYS_RP Measure 추가
                AND    INSTR(A.DIVISION_ID, P_DIVISION_ID) > 0
                ORDER  BY SORT_ORDER_NO;
        ELSE
            OPEN O_RC1 FOR
                SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME NAME, TEI.EDIT_YN
                FROM   SCM_MST_SHEET_MEASURE A
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = A.DIVISION_ID
                WHERE  1 = 1
                AND    PROGRAM_ID = 'DMF0049'
                AND    SHEET_NAME IN ( 'MDF Reports','mdfReports' )
                AND    COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD')
                AND    INSTR(A.DIVISION_ID, P_DIVISION_ID) > 0
                ORDER  BY SORT_ORDER_NO;
        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_DESCRIPTION
                                ,D_EVENT_DATE
                                ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE  => SQLCODE
                                ,P_SQL_ERR_MSG   => SQLERRM
                                ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0049_GET_MEASURE;

    PROCEDURE P_DMF0049_GET_SPREAD_TITLE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_START_DT      VARCHAR2
       ,P_END_DT        VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0049_GET_SPREAD_TITLE
        * Description  :
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 2020/04/02 hwi1993   DMF0049_GET_SPREAD_TITLE
        * 2022/05/12 hwi1993   GM JV
        * 2026/03/15 김준규      [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS

        P_PROGRAM_ID   VARCHAR2(50 CHAR);
        P_SHEET_NAME   VARCHAR2(50 CHAR);
        V_IN_PARA_DATA VARCHAR2(4000);
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN

        V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID
                                     ,'p_created_by' VALUE P_CREATED_BY
                                     ,'p_start_dt' VALUE P_START_DT
                                     ,'p_end_dt' VALUE P_END_DT);

        P_PROGRAM_ID := 'DMF0049';
        P_SHEET_NAME := 'MDF Reports';

        OPEN O_RC1 FOR
            SELECT C.PROGRAM_ID
                  ,C.SHEET_NAME
                  ,C.COLUMN_NAME
                  ,C.COLUMN_LABEL_NAME
                   --, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) SORT_ORDER_NO
                  ,CASE
                       WHEN P_DIVISION_ID = '40' THEN
                        TO_CHAR(C.SORT_ORDER_NO)
                       WHEN P_DIVISION_ID LIKE '81%' THEN
                        C.ATTRIBUTE2
                       WHEN P_DIVISION_ID = '82' THEN
                        C.ATTRIBUTE3
                   END AS SORT_ORDER_NO
                  ,C.DATA_SORT_METHOD_CODE
                  ,C.SMALL_CLASS_LABEL_NAME
                  ,C.LARGE_CLASS_LABEL_NAME
                  ,'' AS DAY_CODE
                  ,C.FIXED_FLAG
                  ,CASE
                       WHEN CASE
                                WHEN P_DIVISION_ID = '40' THEN
                                 C.VISIBLE_FLAG
                                WHEN P_DIVISION_ID LIKE '81%' THEN
                                 C.ATTRIBUTE4
                                WHEN P_DIVISION_ID = '82' THEN
                                 C.ATTRIBUTE5
                            END = 'Y' THEN
                        C.COLUMN_WIDTH
                       ELSE
                        0
                   END AS COLUMN_WIDTH
                  ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                  ,C.CELL_COMBO_DATA_TYPE
                  ,TO_CHAR(C.DATA_SCALE_NUMBER) DATA_SCALE_NUMBER
                  ,TO_CHAR(C.DATA_MAX_LENGTH) DATA_MAX_LENGTH
                  ,C.HORIZONTAL_ALIGN_CODE
                  ,C.UPPERCASE_APPLY_FLAG
                  ,CASE
                       WHEN P_DIVISION_ID = '40' THEN
                        C.VISIBLE_FLAG
                       WHEN P_DIVISION_ID LIKE '81%' THEN
                        C.ATTRIBUTE4
                       WHEN P_DIVISION_ID = '82' THEN
                        C.ATTRIBUTE5
                   END AS VISIBLE_FLAG
                  ,C.DEFAULT_FLAG
                  ,C.USER_SELECTABLE_FLAG
                  ,C.VALID_YN
                  ,C.DIVISION_ID
                  ,P_DIVISION_ID ATTRIBUTE1 -- COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다.
                  ,CASE
                       WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN
                        C.ATTRIBUTE1
                       ELSE
                        C.ATTRIBUTE1
                   END AS ATTRIBUTE2
                  ,'' AS ATTRIBUTE3
                  ,'' AS ATTRIBUTE4
                  ,'' AS ATTRIBUTE5
                  ,TEI.EDIT_YN
            FROM   SCM_MST_SHEET_COLUMNS C
            INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
            ON     TEI.UNIT_ID = C.DIVISION_ID
            WHERE  1 = 1
            AND    C.PROGRAM_ID = P_PROGRAM_ID
            AND    C.SHEET_NAME = P_SHEET_NAME
            AND    C.VALID_YN = 'Y'
            AND    C.DIVISION_ID LIKE '%' || P_DIVISION_ID || '%'
            UNION ALL

            SELECT P_PROGRAM_ID PROGRAM_ID
                  ,P_SHEET_NAME SHEET_NAME
                  ,MA.COLUMN_NAME
                  ,MA.COLUMN_LABEL_NAME
                  ,MA.SORT_ORDER_NO
                  ,'' AS DATA_SORT_METHOD_CODE
                  ,MA.SMALL_CLASS_LABEL_NAME
                  ,MA.LARGE_CLASS_LABEL_NAME
                  ,MA.DAY_CODE
                  ,'' AS FIXED_FLAG
                  ,120 COLUMN_WIDTH
                  ,MA.CELL_CONTROL_OBJECT_TYPE_CODE --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                  ,'' AS CELL_COMBO_DATA_TYPE
                   --, '2'         AS DATA_SCALE_NUMBER
                  ,'3' AS DATA_SCALE_NUMBER -- 20181029
                  ,'2' AS DATA_MAX_LENGTH
                  ,'R' AS HORIZONTAL_ALIGN_CODE
                  ,'' AS UPPERCASE_APPLY_FLAG
                  ,'Y' AS VISIBLE_FLAG
                  ,'' AS DEFAULT_FLAG
                  ,'' AS USER_SELECTABLE_FLAG
                  ,'' AS VALID_YN
                  ,'' AS DIVISION_ID
                  ,'' AS ATTRIBUTE1
                  ,'' AS ATTRIBUTE2
                  ,'' AS ATTRIBUTE3
                  ,'' AS ATTRIBUTE4
                  ,'' AS ATTRIBUTE5
                  ,'N' AS EDIT_YN
            FROM   (SELECT DISTINCT 'M_' || BASIS_YYYYMM AS COLUMN_NAME
                                   ,MONTH_NAME COLUMN_LABEL_NAME
                                   ,MONTH_NAME SMALL_CLASS_LABEL_NAME
                                   ,MONTH_NAME LARGE_CLASS_LABEL_NAME
                                   ,'' AS DAY_CODE
                                   ,TO_CHAR(BASIS_YYYYMM) SORT_ORDER_NO
                                   ,'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                    FROM   SCM_SYS_CALENDAR_M
                    WHERE  BASIS_YYYYMMDD >= P_START_DT
                    AND    BASIS_YYYYMMDD <= P_END_DT

                    ) MA

            ORDER  BY SORT_ORDER_NO;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_LOG_TYPE   := 'ERROR';
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_DESCRIPTION
                                ,D_EVENT_DATE
                                ,V_PROC_INPUT
                                ,V_SQL_CODE
                                ,V_SQL_ERRMSG
                                ,V_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0049_GET_SPREAD_TITLE;

END PKG_DMF0049;
/