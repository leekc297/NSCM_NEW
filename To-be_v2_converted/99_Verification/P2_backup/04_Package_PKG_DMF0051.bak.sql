/*=============================================================================================
 * File         : 04_Package_PKG_DMF0051.sql
 * Description  : Package — PKG_DMF0051
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : Standalone SP와 화면 단위로 PKG 통합은 별도 후속 작업.
 *
 * 실행 순서   : 06_Packages 단계 (Foundation + Tables + GTT + Views 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN → (+) 변환 (사내 표준 §7.1.6)
 *   - @변수 잔존 시 검토
 *   - DATEADD/CHARINDEX/STRING_SPLIT (Oracle 비존재 함수) 수동 변환
 *   - v_program_name 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0051 IS
    /*
    * Program ID   : PKG_DMF0051
    * Description  : PKG_DMF0051
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.15   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DMF0051_GET_SPREAD_TITLE
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       ,P_DIVISION_ID    VARCHAR2
       ,P_BUCKET         VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

END PKG_DMF0051;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0051 IS

    PROCEDURE P_DMF0051_GET_SPREAD_TITLE
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       ,P_DIVISION_ID    VARCHAR2
       ,P_BUCKET         VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR        
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0051_GET_SPREAD_TITLE
        * Description  :
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 20220603     kdw2819         Initial Release PJ20216891R
        * 20221116     kdw2819         [C20221107-000343]BP Waterfall 오류 수정 요청의 건
        * 2026/03/15 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS
    
        I_COUNT        INTEGER := 0;
        V_PROGRAM_ID   VARCHAR2(50 CHAR) := 'DMF0051';
        V_SHEET_NAME   VARCHAR2(50 CHAR) := 'Biz Plan Waterfall';
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
    
        V_IN_PARA_DATA := JSON_OBJECT('p_start_yyyymmdd' VALUE P_START_YYYYMMDD
                                     ,'p_end_yyyymmdd' VALUE P_END_YYYYMMDD
                                     ,'p_created_by' VALUE P_CREATED_BY
                                     ,'p_division_id' VALUE P_DIVISION_ID
                                     ,'p_bucket' VALUE P_BUCKET);
    
        SELECT COUNT(*)
        INTO   I_COUNT
        FROM   SCM_MST_TITLESET_USER U
        
        WHERE  1 = 1
        AND    U.PROGRAM_ID = V_PROGRAM_ID
        AND    U.SHEET_NAME = V_SHEET_NAME
        AND    U.USER_ID = P_CREATED_BY
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';
    
        IF I_COUNT > 0 THEN
            OPEN O_RC1 FOR
                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,CASE
                           WHEN P_DIVISION_ID LIKE '81%' THEN
                            (CASE
                                WHEN C.ATTRIBUTE4 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           WHEN P_DIVISION_ID = '82' THEN
                            (CASE
                                WHEN C.ATTRIBUTE5 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           ELSE
                            C.COLUMN_LABEL_NAME
                       END AS COLUMN_LABEL_NAME
                       -- [C20221107-000343]BP Waterfall 오류 수정 요청의 건
                      ,TO_CHAR(U.SORT_ORDER_NO) SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,P_DIVISION_ID ATTRIBUTE1
                      ,CASE
                           WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN
                            C.ATTRIBUTE1
                           ELSE
                            ''
                       END AS ATTRIBUTE2
                      ,'' AS ATTRIBUTE3
                      ,C.ATTRIBUTE4
                      ,C.ATTRIBUTE5
                      ,TEI.EDIT_YN
                FROM   SCM_MST_TITLESET_USER U, SCM_MST_SHEET_COLUMNS C
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = C.DIVISION_ID
                WHERE  1 = 1
                AND    U.PROGRAM_ID = C.PROGRAM_ID
                AND    U.SHEET_NAME = C.SHEET_NAME
                AND    U.COLUMN_NAME = C.COLUMN_NAME
                AND    U.PROGRAM_ID = V_PROGRAM_ID
                AND    U.SHEET_NAME = V_SHEET_NAME
                AND    U.USER_ID = P_CREATED_BY
                AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ',')))
                UNION ALL
                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,CASE
                           WHEN P_DIVISION_ID LIKE '81%' THEN
                            (CASE
                                WHEN C.ATTRIBUTE4 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           WHEN P_DIVISION_ID = '82' THEN
                            (CASE
                                WHEN C.ATTRIBUTE5 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           ELSE
                            C.COLUMN_LABEL_NAME
                       END AS COLUMN_LABEL_NAME
                      ,TO_CHAR(C.SORT_ORDER_NO) SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,P_DIVISION_ID ATTRIBUTE1
                      ,C.ATTRIBUTE2
                      ,C.ATTRIBUTE3
                      ,C.ATTRIBUTE4
                      ,C.ATTRIBUTE5
                      ,'' AS EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = ''
                AND    C.DEFAULT_FLAG IS NULL
                AND    C.VALID_YN = 'Y'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ','))) -- 20180620 division 추가
                
                UNION ALL
                
                SELECT V_PROGRAM_ID AS PROGRAM_ID
                      ,V_SHEET_NAME SHEET_NAME
                      ,T.COLUMN_NAME
                      ,T.COLUMN_LABEL_NAME
                      ,T.SORT_ORDER_NO
                      ,'' AS DATA_SORT_METHOD_CODE
                      ,T.SMALL_CLASS_LABEL_NAME
                      ,T.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,'' AS FIXED_FLAG
                      ,CAST(50 AS NUMBER) COLUMN_WIDTH
                      ,'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                      ,'' AS CELL_COMBO_DATA_TYPE
                      ,CAST('3' AS NUMBER) DATA_SCALE_NUMBER
                      ,CAST(NULL AS NUMBER) DATA_MAX_LENGTH
                      ,'R' AS HORIZONTAL_ALIGN_CODE
                      ,'Y' AS UPPERCASE_APPLY_FLAG
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
                      ,'' AS EDIT_YN
                FROM   (SELECT *
                        FROM   (
                                -- Monthly
                                SELECT 'M_' || A.BASIS_YYYYMM AS COLUMN_NAME
                                       ,A.MONTH_NAME COLUMN_LABEL_NAME
                                       ,'Q' || TO_CHAR(TO_NUMBER(TO_CHAR(A.BASIS_YYYYMM || '01', 'Q'))) SMALL_CLASS_LABEL_NAME
                                       ,TO_CHAR(A.CALENDAR_YYYY) LARGE_CLASS_LABEL_NAME
                                       ,BASIS_YYYYMM || '01' AS SORT_ORDER_NO
                                FROM   SCM_SYS_CALENDAR_M A
                                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                                GROUP  BY CALENDAR_YYYY, A.BASIS_YYYYMM, A.MONTH_NAME
                                UNION ALL
                                -- Quarterly
                                SELECT DISTINCT 'Q_' || CALENDAR_YYYY || '_' || TO_CHAR(TO_NUMBER(TO_CHAR(A.BASIS_YYYYMM || '01', 'Q'))) COLUMN_NAME
                                                ,'Q' || TO_CHAR(TO_NUMBER(TO_CHAR(A.BASIS_YYYYMM || '01', 'Q'))) COLUMN_LABEL_NAME
                                                ,'Q' || TO_CHAR(TO_NUMBER(TO_CHAR(A.BASIS_YYYYMM || '01', 'Q'))) SMALL_CLASS_LABEL_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) LARGE_CLASS_LABEL_NAME
                                                ,CASE
                                                     WHEN TO_NUMBER(TO_CHAR(A.BASIS_YYYYMM || '01', 'Q')) = 1 THEN
                                                      CALENDAR_YYYY || '0100'
                                                     WHEN TO_NUMBER(TO_CHAR(A.BASIS_YYYYMM || '01', 'Q')) = 2 THEN
                                                      CALENDAR_YYYY || '0400'
                                                     WHEN TO_NUMBER(TO_CHAR(A.BASIS_YYYYMM || '01', 'Q')) = 3 THEN
                                                      CALENDAR_YYYY || '0700'
                                                     ELSE
                                                      CALENDAR_YYYY || '1000'
                                                 END AS SORT_ORDER_NO
                                FROM   SCM_SYS_CALENDAR_M A
                                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                                
                                UNION ALL
                                -- Yearly
                                SELECT DISTINCT 'Y_' || CALENDAR_YYYY AS COLUMN_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) COLUMN_LABEL_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) SMALL_CLASS_LABEL_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) LARGE_CLASS_LABEL_NAME
                                                ,CALENDAR_YYYY || '0000' AS SORT_ORDER_NO
                                FROM   SCM_SYS_CALENDAR_M A
                                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD) MA) T
                ORDER  BY SORT_ORDER_NO;
        
        ELSE
            OPEN O_RC1 FOR
                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,CASE
                           WHEN P_DIVISION_ID LIKE '81%' THEN
                            (CASE
                                WHEN C.ATTRIBUTE4 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           WHEN P_DIVISION_ID = '82' THEN
                            (CASE
                                WHEN C.ATTRIBUTE5 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           ELSE
                            C.COLUMN_LABEL_NAME
                       END AS COLUMN_LABEL_NAME
                      ,TO_CHAR(C.SORT_ORDER_NO) SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,P_DIVISION_ID ATTRIBUTE1
                      ,CASE
                           WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN
                            C.ATTRIBUTE1
                           ELSE
                            ''
                       END AS ATTRIBUTE2
                      ,'' AS ATTRIBUTE3
                      ,C.ATTRIBUTE4
                      ,C.ATTRIBUTE5
                      ,TEI.EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = C.DIVISION_ID
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.DEFAULT_FLAG = 'Y'
                AND    C.VALID_YN = 'Y'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ',')))
                
                UNION ALL
                
                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,CASE
                           WHEN P_DIVISION_ID LIKE '81%' THEN
                            (CASE
                                WHEN C.ATTRIBUTE4 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           WHEN P_DIVISION_ID = '82' THEN
                            (CASE
                                WHEN C.ATTRIBUTE5 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           ELSE
                            C.COLUMN_LABEL_NAME
                       END AS COLUMN_LABEL_NAME
                      ,TO_CHAR(C.SORT_ORDER_NO) SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,P_DIVISION_ID ATTRIBUTE1
                      ,CASE
                           WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN
                            C.ATTRIBUTE1
                           ELSE
                            C.ATTRIBUTE1
                       END AS ATTRIBUTE2
                      ,C.ATTRIBUTE3
                      ,C.ATTRIBUTE4
                      ,C.ATTRIBUTE5
                      ,'' AS EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = ''
                AND    C.DEFAULT_FLAG IS NULL
                AND    C.VALID_YN = 'Y'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ','))) -- 20180620 division 추가
                
                UNION ALL
                
                SELECT V_PROGRAM_ID AS PROGRAM_ID
                      ,V_SHEET_NAME SHEET_NAME
                      ,T.COLUMN_NAME
                      ,T.COLUMN_LABEL_NAME
                      ,T.SORT_ORDER_NO
                      ,'' AS DATA_SORT_METHOD_CODE
                      ,T.SMALL_CLASS_LABEL_NAME
                      ,T.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,'' AS FIXED_FLAG
                      ,CAST(50 AS NUMBER) COLUMN_WIDTH
                      ,'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                      ,'' AS CELL_COMBO_DATA_TYPE
                      ,CAST('3' AS NUMBER) DATA_SCALE_NUMBER
                      ,CAST(NULL AS NUMBER) DATA_MAX_LENGTH
                      ,'R' AS HORIZONTAL_ALIGN_CODE
                      ,'Y' AS UPPERCASE_APPLY_FLAG
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
                      ,'' AS EDIT_YN
                FROM   (SELECT *
                        FROM   (
                                -- Monthly
                                SELECT 'M_' || A.BASIS_YYYYMM AS COLUMN_NAME
                                       ,A.MONTH_NAME COLUMN_LABEL_NAME
                                       ,'Q' || TO_CHAR(TO_NUMBER(TO_CHAR(A.BASIS_YYYYMM || '01', 'Q'))) SMALL_CLASS_LABEL_NAME
                                       ,TO_CHAR(A.CALENDAR_YYYY) LARGE_CLASS_LABEL_NAME
                                       ,BASIS_YYYYMM || '01' AS SORT_ORDER_NO
                                FROM   SCM_SYS_CALENDAR_M A
                                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                                GROUP  BY CALENDAR_YYYY, A.BASIS_YYYYMM, A.MONTH_NAME
                                UNION ALL
                                -- Quarterly
                                SELECT DISTINCT 'Q_' || CALENDAR_YYYY || '_' || TO_CHAR(TO_NUMBER(TO_CHAR(A.BASIS_YYYYMM || '01', 'Q'))) COLUMN_NAME
                                                ,'Q' || TO_CHAR(TO_NUMBER(TO_CHAR(A.BASIS_YYYYMM || '01', 'Q'))) COLUMN_LABEL_NAME
                                                ,'Q' || TO_CHAR(TO_NUMBER(TO_CHAR(A.BASIS_YYYYMM || '01', 'Q'))) SMALL_CLASS_LABEL_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) LARGE_CLASS_LABEL_NAME
                                                ,CASE
                                                     WHEN TO_NUMBER(TO_CHAR(A.BASIS_YYYYMM || '01', 'Q')) = 1 THEN
                                                      CALENDAR_YYYY || '0100'
                                                     WHEN TO_NUMBER(TO_CHAR(A.BASIS_YYYYMM || '01', 'Q')) = 2 THEN
                                                      CALENDAR_YYYY || '0400'
                                                     WHEN TO_NUMBER(TO_CHAR(A.BASIS_YYYYMM || '01', 'Q')) = 3 THEN
                                                      CALENDAR_YYYY || '0700'
                                                     ELSE
                                                      CALENDAR_YYYY || '1000'
                                                 END
                                FROM   SCM_SYS_CALENDAR_M A
                                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                                
                                UNION ALL
                                -- Yearly
                                SELECT DISTINCT 'Y_' || CALENDAR_YYYY AS COLUMN_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) COLUMN_LABEL_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) SMALL_CLASS_LABEL_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) LARGE_CLASS_LABEL_NAME
                                                ,CALENDAR_YYYY || '0000' AS SORT_ORDER_NO
                                FROM   SCM_SYS_CALENDAR_M A
                                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD) MA) T
                ORDER  BY SORT_ORDER_NO;
        END IF;
    
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
    END P_DMF0051_GET_SPREAD_TITLE;

END PKG_DMF0051;
/
