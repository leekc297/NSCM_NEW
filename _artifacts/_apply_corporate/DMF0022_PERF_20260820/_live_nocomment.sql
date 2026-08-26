PACKAGE BODY           "PKG_DMF0022"












AS

PROCEDURE P_DMF0022_GET_SPREAD_TITLE
(
    P_START_YYYYMMDD    IN VARCHAR2,
    P_END_YYYYMMDD      IN VARCHAR2,
    P_CREATED_BY        IN VARCHAR2,
    P_DIVISION_ID       IN VARCHAR2,
    P_BUCKET            IN VARCHAR2,
    P_USER_ID           IN VARCHAR2,
    P_MENU_ID           IN VARCHAR2,

    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)















AS
    i_Count         PLS_INTEGER := 0;
    v_program_id    VARCHAR2(50 CHAR) := 'DMF0022';
    v_sheet_name    VARCHAR2(50 CHAR) := 'salesPlanWaterfall';  

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    n_log_count     PLS_INTEGER := 0;
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    SELECT COUNT(*)
      INTO i_Count
      FROM SCM_MGR.SCM_MST_TITLESET_USER U
     WHERE U.PROGRAM_ID                      = v_program_id
       AND U.SHEET_NAME                      = v_sheet_name
       AND U.USER_ID                         = P_CREATED_BY
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE   = 'C';

    
    
    
    

    IF i_Count > 0 THEN
        OPEN O_RC1 FOR
            SELECT U.PROGRAM_ID
                 , U.SHEET_NAME
                 , U.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , U.SORT_ORDER_NO        
                 , U.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , ''            AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , C.DIVISION_ID
                 , EDY.EDIT_YN
              FROM SCM_MGR.SCM_MST_TITLESET_USER  U
                 , SCM_MGR.SCM_MST_SHEET_COLUMNS  C
                   INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
                        ON EDY.USER_ID = P_USER_ID
                       AND EDY.MNU_ID  = P_MENU_ID
                       AND EDY.UNIT_ID = P_DIVISION_ID  
             WHERE U.PROGRAM_ID  = C.PROGRAM_ID
               AND U.SHEET_NAME  = C.SHEET_NAME
               AND U.COLUMN_NAME = C.COLUMN_NAME
               AND U.PROGRAM_ID  = v_program_id
               AND U.SHEET_NAME  = v_sheet_name
               AND U.USER_ID     = P_CREATED_BY
               AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
               AND P_DIVISION_ID IN (
                       SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                         FROM DUAL
                       CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )    
            UNION ALL
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO        
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , ''            AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , C.DIVISION_ID
                 , EDY.EDIT_YN
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
                   INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
                        ON EDY.USER_ID = P_USER_ID
                       AND EDY.MNU_ID  = P_MENU_ID
                       AND EDY.UNIT_ID = P_DIVISION_ID  
             WHERE C.PROGRAM_ID   = v_program_id
               AND C.SHEET_NAME   = v_sheet_name
               AND C.VISIBLE_FLAG = 'N'
               AND RTRIM(C.DEFAULT_FLAG, ' -') IS NULL  
               AND C.VALID_YN     = 'Y'
               AND P_DIVISION_ID IN (
                       SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                         FROM DUAL
                       CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )    
            UNION ALL
            SELECT v_program_id   AS PROGRAM_ID
                 , v_sheet_name   AS SHEET_NAME
                 , T.COLUMN_NAME
                 , T.COLUMN_LABEL_NAME
                 , ROW_NUMBER() OVER(ORDER BY T.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , ''             AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , T.LARGE_CLASS_LABEL_NAME
                 , T.DAY_CODE
                 , ''             AS FIXED_FLAG
                 , CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 100 ELSE 50 END AS COLUMN_WIDTH
                 , T.CELL_CONTROL_OBJECT_TYPE_CODE   
                 , ''             AS CELL_COMBO_DATA_TYPE
                 , 3              AS DATA_SCALE_NUMBER
                 , NULL           AS DATA_MAX_LENGTH
                 , 'R'            AS HORIZONTAL_ALIGN_CODE
                 , 'Y'            AS UPPERCASE_APPLY_FLAG
                 , 'Y'            AS VISIBLE_FLAG
                 , ''             AS DEFAULT_FLAG
                 , ''             AS USER_SELECTABLE_FLAG
                 , ''             AS VALID_YN
                 , ''             AS DIVISION_ID
                 , 'N'            AS EDIT_YN
              FROM (
                       SELECT 'D_' || A.BASIS_YYYYMMDD       AS COLUMN_NAME
                            , A.CALENDAR_DAY                  AS COLUMN_LABEL_NAME
                            , A.WEEK_NAME                     AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME                    AS LARGE_CLASS_LABEL_NAME
                            , A.DAYOFWEEK                     AS DAY_CODE
                            , A.BASIS_YYYYMMDD || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                            , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD 
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   
                          AND 1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                       










                       UNION ALL
                       SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK  AS COLUMN_NAME
                            , A.WEEK_NAME                            AS COLUMN_LABEL_NAME
                            , A.WEEK_NAME                            AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME                           AS LARGE_CLASS_LABEL_NAME
                            , ''                                     AS DAY_CODE
                            , A.BASIS_START_DATE || TO_CHAR(21, 'FM00') AS SORT_ORDER_NO
                            , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD 
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   
                          AND 1 = CASE WHEN P_BUCKET <> 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME, A.BASIS_START_DATE
                       











                       UNION ALL
                       SELECT 'M_' || A.BASIS_YYYYMM              AS COLUMN_NAME
                            , A.MONTH_NAME                         AS COLUMN_LABEL_NAME
                            , A.MONTH_NAME                         AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME                         AS LARGE_CLASS_LABEL_NAME
                            , ''                                   AS DAY_CODE
                            , MIN(A.BASIS_START_DATE) || TO_CHAR(1, 'FM00') AS SORT_ORDER_NO
                            , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD 
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   
                          AND 1 = CASE WHEN P_BUCKET <> 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                        GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                       











                       
                       
                       UNION ALL
                       SELECT 'W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK  AS COLUMN_NAME
                            , WEEK_NAME                                                AS COLUMN_LABEL_NAME
                            , WEEK_NAME                                                AS SMALL_CLASS_LABEL_NAME
                            , SUBSTR(MIN(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MIN(BASIS_YYYYMMDD), 7, 2)
                                  || ' ~ ' || SUBSTR(MAX(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MAX(BASIS_YYYYMMDD), 7, 2)
                                                                                       AS LARGE_CLASS_LABEL_NAME
                            , ''                                                       AS DAY_CODE
                            , MAX(BASIS_YYYYMMDD) || TO_CHAR(21, 'FM00')              AS SORT_ORDER_NO
                            
                            , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                          AND 1 = CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                        GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
                   ) T
             ORDER BY SORT_ORDER_NO;

        DBMS_OUTPUT.PUT_LINE('

    ELSE
        OPEN O_RC1 FOR
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO        
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , ''            AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , C.DIVISION_ID
                 , EDY.EDIT_YN
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
                   INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) EDY
                       ON EDY.UNIT_ID = P_DIVISION_ID  
             WHERE C.PROGRAM_ID   = v_program_id
               AND C.SHEET_NAME   = v_sheet_name
               AND C.DEFAULT_FLAG = 'Y'
               AND C.VALID_YN     = 'Y'
               AND P_DIVISION_ID IN (
                       SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                         FROM DUAL
                       CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )    
            UNION ALL
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO        
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , ''            AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , C.DIVISION_ID
                 , EDY.EDIT_YN
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
                   INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) EDY
                       ON EDY.UNIT_ID = P_DIVISION_ID  
             WHERE C.PROGRAM_ID   = v_program_id
               AND C.SHEET_NAME   = v_sheet_name
               AND C.VISIBLE_FLAG = 'N'
               AND RTRIM(C.DEFAULT_FLAG, ' -') IS NULL  
               AND C.VALID_YN     = 'Y'
               AND P_DIVISION_ID IN (
                       SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                         FROM DUAL
                       CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )    
            UNION ALL
            SELECT v_program_id   AS PROGRAM_ID
                 , v_sheet_name   AS SHEET_NAME
                 , T.COLUMN_NAME
                 , T.COLUMN_LABEL_NAME
                 , ROW_NUMBER() OVER(ORDER BY T.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , ''             AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , T.LARGE_CLASS_LABEL_NAME
                 , T.DAY_CODE
                 , ''             AS FIXED_FLAG
                 , CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 100 ELSE 50 END AS COLUMN_WIDTH
                 , 'FPNumber'     AS CELL_CONTROL_OBJECT_TYPE_CODE
                 , ''             AS CELL_COMBO_DATA_TYPE
                 , 3              AS DATA_SCALE_NUMBER
                 , NULL           AS DATA_MAX_LENGTH
                 , 'R'            AS HORIZONTAL_ALIGN_CODE
                 , 'Y'            AS UPPERCASE_APPLY_FLAG
                 , 'Y'            AS VISIBLE_FLAG
                 , ''             AS DEFAULT_FLAG
                 , ''             AS USER_SELECTABLE_FLAG
                 , ''             AS VALID_YN
                 , ''             AS DIVISION_ID
                 , 'N'            AS EDIT_YN
              FROM (
                       SELECT 'D_' || A.BASIS_YYYYMMDD       AS COLUMN_NAME
                            , A.CALENDAR_DAY                  AS COLUMN_LABEL_NAME
                            , A.WEEK_NAME                     AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME                    AS LARGE_CLASS_LABEL_NAME
                            , A.DAYOFWEEK                     AS DAY_CODE
                            , A.BASIS_YYYYMMDD || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD 
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   
                          AND 1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                       









                       UNION ALL
                       SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK  AS COLUMN_NAME
                            , A.WEEK_NAME                            AS COLUMN_LABEL_NAME
                            , A.WEEK_NAME                            AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME                           AS LARGE_CLASS_LABEL_NAME
                            , ''                                     AS DAY_CODE
                            , A.BASIS_START_DATE || TO_CHAR(21, 'FM00') AS SORT_ORDER_NO
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD 
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   
                          AND 1 = CASE WHEN P_BUCKET <> 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME, A.BASIS_START_DATE
                       










                       UNION ALL
                       SELECT 'M_' || A.BASIS_YYYYMM              AS COLUMN_NAME
                            , A.MONTH_NAME                         AS COLUMN_LABEL_NAME
                            , A.MONTH_NAME                         AS SMALL_CLASS_LABEL_NAME
                            , A.MONTH_NAME                         AS LARGE_CLASS_LABEL_NAME
                            , ''                                   AS DAY_CODE
                            , MIN(A.BASIS_START_DATE) || TO_CHAR(1, 'FM00') AS SORT_ORDER_NO
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD 
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   
                          AND 1 = CASE WHEN P_BUCKET <> 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                        GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                       










                       
                       
                       UNION ALL
                       SELECT 'W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK  AS COLUMN_NAME
                            , WEEK_NAME                                                AS COLUMN_LABEL_NAME
                            , WEEK_NAME                                                AS SMALL_CLASS_LABEL_NAME
                            , SUBSTR(MIN(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MIN(BASIS_YYYYMMDD), 7, 2)
                                  || ' ~ ' || SUBSTR(MAX(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MAX(BASIS_YYYYMMDD), 7, 2)
                                                                                       AS LARGE_CLASS_LABEL_NAME
                            , ''                                                       AS DAY_CODE
                            , MAX(BASIS_YYYYMMDD) || TO_CHAR(21, 'FM00')              AS SORT_ORDER_NO
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                          AND 1 = CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                        GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
                   ) T
             ORDER BY SORT_ORDER_NO;

    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, NULL AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
             'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD
            ,'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD
            ,'P_CREATED_BY'     VALUE P_CREATED_BY
            ,'P_DIVISION_ID'    VALUE P_DIVISION_ID
            ,'P_BUCKET'         VALUE P_BUCKET
            ,'P_USER_ID'        VALUE P_USER_ID
            ,'P_MENU_ID'        VALUE P_MENU_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION', '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0022_GET_SPREAD_TITLE;

PROCEDURE P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL
(
    P_DIVISION_ID       IN VARCHAR2,
    P_DEPT_ID           IN VARCHAR2,
    P_END_CUSTOMER      IN VARCHAR2,
    P_SCM_SITE_ID       IN VARCHAR2,
    P_PROJECT_CODE      IN VARCHAR2,
    P_ITEM_ID           IN VARCHAR2,
    P_ITEM_TYPE         IN VARCHAR2,
    P_FROM_YYYYMMDD     IN VARCHAR2,
    P_NOW_YYYYMMDD      IN VARCHAR2,
    P_TO_YYYYMMDD       IN VARCHAR2,
    P_CREATED_BY        IN VARCHAR2,
    P_PLANT_SITE_ID     IN VARCHAR2,
    P_BIZTYPE           IN VARCHAR2,
    P_OWNER             IN VARCHAR2,
    P_INTERNAL_YN       IN VARCHAR2,
    P_CELL_YN           IN VARCHAR2,
    P_VERSION_TYPE      IN VARCHAR2,
    P_BUCKET            IN VARCHAR2,   
    P_USER_DEPT_ID      IN VARCHAR2,   
    P_GROUP_ID          IN VARCHAR2,   
    P_USER_ID           IN VARCHAR2,
    P_MENU_ID           IN VARCHAR2,

    O_RC1               OUT SYS_REFCURSOR,
    O_RC2               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)






































































































AS
    v_program_id    VARCHAR2(50  CHAR) := 'DMF0022';
    v_sheet_name    VARCHAR2(50  CHAR) := 'salesPlanWaterfall';
    v_measure_sheet VARCHAR2(50 CHAR) := 'Sales Plan Waterfall';  
    

    v_ColList       VARCHAR2(32767 CHAR) := '';
    v_OrderList     VARCHAR2(32767 CHAR) := '';
    
    
    i_count         PLS_INTEGER := 0;
    v_user_mea_cnt  PLS_INTEGER := 0;  

    
    
    
    v_start_yyyymmdd    VARCHAR2(8 CHAR);

    
    v_sql_text          VARCHAR2(32767 CHAR);
    
    
    V_PV_LIST           VARCHAR2(32767 CHAR);
    V_PV_COL_LIST       VARCHAR2(32767 CHAR);
    
    
    
    
    
    
    
    
    
    
    
    
    V_SQL_SELECT        VARCHAR2(32767 CHAR);
    V_SQL_GROUPBY       VARCHAR2(32767 CHAR);
    v_I                 PLS_INTEGER;
    v_CNT               PLS_INTEGER;

    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100  CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
    n_log_count         PLS_INTEGER := 0;
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

    v_exists            PLS_INTEGER;

BEGIN
    
    
    
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;
    
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_V_VERSION_NO',              'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_SELECT_MEASURE',            'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_SCM_MST_SHEET_MEASURE',     'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_PROGRAM_ADD_MEASURE',       'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_RAW_DATA',                  'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_RAW_DATA_TEMP40',           'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_RAW_DATA_TEMP40_KEY',       'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_RTF_ENERGY',                'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_SCM_MST_SITE_ITEM',         'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_T_PRICE',                   'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_T_COLUMN_SETUP',            'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_T',                         'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_CALENDAR',                  'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_SCM_MST_SITE',              'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_ORI_V',  'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_A_V',    'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_B_V',    'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_V',      'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_V_T',    'GLOBAL_TEMP_TABLE_STATS','SESSION');

    
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_V_VERSION_NO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_SELECT_MEASURE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_SCM_MST_SHEET_MEASURE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_PROGRAM_ADD_MEASURE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_RAW_DATA';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_RAW_DATA_TEMP40';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_RAW_DATA_TEMP40_KEY';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_RTF_ENERGY';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_SCM_MST_SITE_ITEM';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_T_PRICE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_T_COLUMN_SETUP';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_T';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_CALENDAR';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_SCM_MST_SITE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_ORI_V';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_A_V';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_B_V';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V_T';

    

    
    
    
    SELECT BASIS_START_DATE
      INTO v_start_yyyymmdd
      FROM SCM_MGR.SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMMDD = P_FROM_YYYYMMDD;

    
    
    
    INSERT  INTO SCM_MGR.GT_DM22_V_VERSION_NO
        (VERSION_NO, TOBE_VERSION_NO)
    SELECT TRIM(CASE WHEN INSTR(TOKEN, '(') = 0
                     THEN TOKEN
                     ELSE SUBSTR(TOKEN, 1, INSTR(TOKEN, '(') - 1)
                END) AS VERSION_NO,
           NULL AS TOBE_VERSION_NO
      FROM (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_VERSION_TYPE,',')) P)
    ;
    
    
    

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A001

    
    
    
    SELECT COUNT(*)
      INTO v_user_mea_cnt
      FROM SCM_MGR.SCM_MST_TITLESET_USER U
     WHERE U.PROGRAM_ID                     = v_program_id
       AND U.SHEET_NAME                     = v_sheet_name
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE  = 'M'
       AND U.USER_ID                        = P_CREATED_BY;

    IF v_user_mea_cnt = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
            (USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG,
             DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT P_CREATED_BY AS USER_ID, C.PROGRAM_ID, v_sheet_name, 'M' AS USER_INQUIRY_COLUMN_TYPE_CODE,
               C.COLUMN_NAME, C.SORT_ORDER_NO, 'N' AS SUB_TOTAL_FLAG,
               '' AS DATA_SORT_METHOD_CODE, P_CREATED_BY AS CREATED_BY,
               SYSDATE AS CREATION_DATE,
               P_CREATED_BY AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
          FROM SCM_MGR.SCM_MST_SHEET_MEASURE C
         WHERE C.PROGRAM_ID   = v_program_id
           AND C.SHEET_NAME   = v_measure_sheet
           AND C.DEFAULT_FLAG = 'Y'
           AND C.VALID_YN     = 'Y';
    END IF;
    
    
    

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A003

    
    
    
    
    INSERT  INTO GT_DM22_SCM_MST_SHEET_MEASURE
        (USER_ID, MEASURE, SORT_ORDER_NO, SYSTEM_ADD, DIVISION_ID)
    SELECT t.user_id, t.measure, t.sort_order_no, t.system_add, t.division_id
    FROM (
          SELECT a.user_id, a.measure, a.sort_order_no, a.system_add, TRIM(REGEXP_SUBSTR(a.division_id, '[^,]+', 1, lv.lvl)) AS division_id
          FROM (
                SELECT
                    u.user_id,
                    u.column_name     AS measure,
                    u.sort_order_no,
                    b.division_id,
                    'N'               AS system_add
                FROM SCM_MGR.SCM_MST_TITLESET_USER    u
                INNER JOIN scm_mst_sheet_measure   b
                    ON  u.program_id    = b.program_id
                    AND b.sheet_name    = v_measure_sheet
                    AND u.column_name   = b.column_name
                WHERE u.program_id                    = v_program_id
                  AND u.sheet_name                    = v_sheet_name
                  AND u.user_inquiry_column_type_code = 'M'
                  AND u.user_id                       = p_created_by
                  AND b.valid_yn                      = 'Y'
               ) a
              
              CROSS JOIN (
                  SELECT LEVEL AS lvl
                  FROM DUAL
                  CONNECT BY LEVEL <= (
                      SELECT MAX(REGEXP_COUNT(b2.division_id, ',') + 1)
                      FROM SCM_MGR.SCM_MST_SHEET_MEASURE b2
                      WHERE b2.program_id = v_program_id
                        AND b2.sheet_name = v_measure_sheet
                        AND b2.valid_yn   = 'Y'
                  )
              ) lv
          WHERE REGEXP_SUBSTR(a.division_id, '[^,]+', 1, lv.lvl) IS NOT NULL
    ) t
    WHERE t.division_id = p_division_id;

    















    INSERT  INTO GT_DM22_SELECT_MEASURE
        (MEASURE, SORT_ORDER_NO, SYSTEM_ADD)
    SELECT DISTINCT U.MEASURE, U.SORT_ORDER_NO, U.SYSTEM_ADD
      FROM SCM_MGR.GT_DM22_SCM_MST_SHEET_MEASURE U
      LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
             ON U.USER_ID     = T.SEGMENT4  
            AND P_CREATED_BY  = T.SEGMENT4  
            AND T.LOOKUP_TYPE = 'TMM_MEASURE_ADMIN'
            AND T.VALID_YN    = 'Y'         
     WHERE U.USER_ID = CASE WHEN U.MEASURE = 'TMM_FCST' THEN T.SEGMENT4 ELSE P_CREATED_BY END;
    
    
    

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A004

  
  
  
  
































































    INSERT  INTO GT_DM22_PROGRAM_ADD_MEASURE
        (UI_MEASURE, DB_MEASURE, PLAN_RESULT, SYSTEM_ADD)
    SELECT T.UI_MEASURE, T.DB_MEASURE, T.PLAN_RESULT, 'Y' AS SYSTEM_ADD
      FROM (
               SELECT A.COLUMN_NAME AS UI_MEASURE, TOKEN AS DB_MEASURE, PLAN_RESULT
                 FROM (
                          SELECT COLUMN_NAME,
                                 NVL(REPLACE(ATTRIBUTE5, ' ', ''), '') AS ATTRIBUTE5,
                                 CASE WHEN NVL(REPLACE(ATTRIBUTE5, ' ', ''), '@#@#@#') <> '@#@#@#' AND ATTRIBUTE7 = 'Y' THEN 'R'
                                      ELSE '' END AS PLAN_RESULT
                            FROM SCM_MGR.SCM_MST_SHEET_MEASURE
                           WHERE PROGRAM_ID = v_program_id
                             AND SHEET_NAME = v_measure_sheet
                             AND VALID_YN   = 'Y'
                             AND NVL(REPLACE(ATTRIBUTE5, ' ', ''), '@#@#@#') <> '@#@#@#'
                      ) A
               CROSS JOIN LATERAL (
                   SELECT TRIM(REGEXP_SUBSTR(A.ATTRIBUTE5, '[^,]+', 1, LEVEL)) AS TOKEN
                     FROM DUAL
                   CONNECT BY REGEXP_SUBSTR(A.ATTRIBUTE5, '[^,]+', 1, LEVEL) IS NOT NULL
               )
               UNION ALL
               SELECT A.COLUMN_NAME AS UI_MEASURE, TOKEN AS DB_MEASURE, PLAN_RESULT
                 FROM (
                          SELECT COLUMN_NAME,
                                 NVL(REPLACE(ATTRIBUTE6, ' ', ''), '') AS ATTRIBUTE6,
                                 CASE WHEN NVL(REPLACE(ATTRIBUTE6, ' ', ''), '@#@#@#') <> '@#@#@#' AND ATTRIBUTE7 = 'Y' THEN 'P'
                                      ELSE '' END AS PLAN_RESULT
                            FROM SCM_MGR.SCM_MST_SHEET_MEASURE
                           WHERE PROGRAM_ID = v_program_id
                             AND SHEET_NAME = v_measure_sheet
                             AND VALID_YN   = 'Y'
                             AND NVL(REPLACE(ATTRIBUTE6, ' ', ''), '@#@#@#') <> '@#@#@#'
                      ) A
               CROSS JOIN LATERAL (
                   SELECT TRIM(REGEXP_SUBSTR(A.ATTRIBUTE6, '[^,]+', 1, LEVEL)) AS TOKEN
                     FROM DUAL
                   CONNECT BY REGEXP_SUBSTR(A.ATTRIBUTE6, '[^,]+', 1, LEVEL) IS NOT NULL
               )
           ) T;

    SELECT COUNT(*)
      INTO v_exists
      FROM SCM_MGR.GT_DM22_PROGRAM_ADD_MEASURE A
     INNER JOIN GT_DM22_SELECT_MEASURE B ON A.UI_MEASURE = B.MEASURE
     WHERE ROWNUM = 1;

    IF v_exists > 0 THEN
        INSERT  INTO SCM_MGR.GT_DM22_SELECT_MEASURE
            (MEASURE, SYSTEM_ADD)
        SELECT A.DB_MEASURE AS MEASURE, A.SYSTEM_ADD
          FROM SCM_MGR.GT_DM22_PROGRAM_ADD_MEASURE A
          LEFT OUTER JOIN GT_DM22_SELECT_MEASURE B ON A.DB_MEASURE = B.MEASURE
         WHERE B.MEASURE IS NULL
         GROUP BY A.DB_MEASURE, A.SYSTEM_ADD;
    END IF;

    
    
    
    
    

    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_SELECT_MEASURE',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);
    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_PROGRAM_ADD_MEASURE',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);
    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_V_VERSION_NO',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A005

    
    
	  
    
    IF P_VERSION_TYPE LIKE '%CURRENT%' THEN
        INSERT  INTO GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE,
             YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        
        SELECT 'CURRENT', NULL, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, PLANT_SITE_ID, A.ITEM_ID,
               NVL(A.ATTRIBUTE9, '') AS TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, NULL, A.MEASURE,
               A.YYYYMMDD, A.QTY, 'P' AS PLAN_RESULT,
               CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END
          FROM SCM_MGR.DM_PLN_SALES_PLAN A
          JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
          JOIN SCM_MGR.SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
         WHERE A.YYYYMMDD   >= P_NOW_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.QTY        <> 0
           AND A.FCST_TYPE NOT IN (SELECT DISTINCT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                      AND VALID_YN = 'Y' AND SEGMENT1 = A.DIVISION_ID)
           AND A.ITEM_ID   NOT IN (SELECT DISTINCT SEGMENT3 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                      AND VALID_YN = 'Y' AND SEGMENT1 = A.DIVISION_ID)
           AND A.MEASURE   NOT IN (SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP' AND VALID_YN = 'Y')
        UNION ALL
        
        SELECT 'CURRENT', NULL, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, PLANT_SITE_ID, A.ITEM_ID,
               A.REMARK_TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, NULL, A.MEASURE,
               A.YYYYMMDD, A.QTY, 'P', '-'
          FROM SCM_MGR.DM_PLN_SALES_ETC_PLAN A
          JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
          JOIN SCM_MGR.SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
         WHERE A.YYYYMMDD   >= P_NOW_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.QTY        <> 0
        UNION ALL
        
        SELECT 'CURRENT', NULL, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, PLANT_SITE_ID, A.ITEM_ID,
               NVL(A.ATTRIBUTE9, ''), A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE,
               A.YYYYMMDD,
               A.QTY + CASE WHEN P_INTERNAL_YN = 'Y' AND P_DIVISION_ID = '82'
                                  AND REGEXP_LIKE(A.ATTRIBUTE2, '^\d+(\.\d+)?$')
                             THEN TO_NUMBER(A.ATTRIBUTE2) ELSE 0 END AS QTY,
               'R' AS PLAN_RESULT,
               A.CELL_PROD_SITE_ID
          FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
          JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
         WHERE A.YYYYMMDD   >= P_FROM_YYYYMMDD AND A.YYYYMMDD < P_NOW_YYYYMMDD
           AND A.DIVISION_ID = P_DIVISION_ID
           AND (A.QTY <> 0 OR (NVL(A.ATTRIBUTE2, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(A.ATTRIBUTE2, '^\d+(\.\d+)?$')))
           AND A.MEASURE NOT IN ('RTF_PR'); 


    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A006

   	
	  
	  
	  


    IF p_version_type LIKE '%SP_%' THEN
        INSERT  INTO SCM_MGR.GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE,
             YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        
        


        SELECT A.VERSION_NO
               
               , A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               NVL(A.ATTRIBUTE9, ''), A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE,
               A.YYYYMMDD, A.QTY, 'P' AS PLAN_RESULT,
               CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END 
          FROM SCM_MGR.DM_PLN_SALES_PLAN_C A
          JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
	       	
          JOIN SCM_MGR.GT_DM22_V_VERSION_NO D ON A.VERSION_NO = D.VERSION_NO
          JOIN SCM_MGR.SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
          
          
          



          
         WHERE A.YYYYMMDD   >= P_FROM_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.QTY        <> 0
           
           
           
           AND A.FCST_TYPE NOT IN (SELECT DISTINCT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                      AND VALID_YN = 'Y' AND SEGMENT1 = A.DIVISION_ID)
           AND A.ITEM_ID   NOT IN (SELECT DISTINCT SEGMENT3 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                      AND VALID_YN = 'Y' AND SEGMENT1 = A.DIVISION_ID)
           AND A.MEASURE   NOT IN (SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP' AND VALID_YN = 'Y')
        
        
        
        UNION ALL
        
        


        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, PLANT_SITE_ID, A.ITEM_ID,
               A.REMARK_TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, NULL  AS COMPANY_ID, A.MEASURE,
               A.YYYYMMDD, A.QTY, 'P' AS PLAN_RESULT, '-' AS CELL_PROD_SITE_ID 
          FROM SCM_MGR.DM_PLN_SALES_ETC_PLAN_C A
          JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		      
          JOIN SCM_MGR.GT_DM22_V_VERSION_NO D ON A.VERSION_NO = D.VERSION_NO
          JOIN SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
          
          
          



          
         WHERE A.YYYYMMDD   >= P_FROM_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.QTY        <> 0
        
        
        
        
        
        UNION ALL
        
        


        SELECT A.VERSION_NO
		    
               , A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               NVL(A.ATTRIBUTE9, ''), A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE,
               A.YYYYMMDD,
               A.QTY + CASE WHEN P_INTERNAL_YN = 'Y' AND P_DIVISION_ID = '82'
                                  AND REGEXP_LIKE(A.ATTRIBUTE2, '^\d+(\.\d+)?$')
                             THEN TO_NUMBER(A.ATTRIBUTE2) ELSE 0 END,
               'R' AS PLAN_RESULT
                 
               , A.CELL_PROD_SITE_ID			
          FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
          JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
      		
          JOIN SCM_MGR.GT_DM22_V_VERSION_NO D ON A.VERSION_NO = D.VERSION_NO
          
          
          



          
         WHERE A.YYYYMMDD   >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD   < TO_CHAR(FN_NEXT_DAY(TO_DATE(A.CUTOFF_YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
           AND A.DIVISION_ID = P_DIVISION_ID
           AND (A.QTY <> 0 OR (NVL(A.ATTRIBUTE2, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(A.ATTRIBUTE2, '^\d+(\.\d+)?$'))) 
          
          
           AND A.MEASURE NOT IN ('RTF_PR');  


    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A007
  
  
  
  













































































    
    
    
    SELECT COUNT(*) INTO v_exists
      FROM GT_DM22_PROGRAM_ADD_MEASURE A
     INNER JOIN GT_DM22_SELECT_MEASURE B ON A.UI_MEASURE = B.MEASURE
     WHERE PLAN_RESULT = 'P' AND ROWNUM = 1;

    IF v_exists > 0 THEN
        INSERT  INTO GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE,
             YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.UI_MEASURE,
               A.YYYYMMDD, A.QTY, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM SCM_MGR.GT_DM22_RAW_DATA A
         INNER JOIN (SELECT A.UI_MEASURE, A.DB_MEASURE
                       FROM SCM_MGR.GT_DM22_PROGRAM_ADD_MEASURE A
                      INNER JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.UI_MEASURE = B.MEASURE
                      WHERE PLAN_RESULT = 'P') B ON A.MEASURE = B.DB_MEASURE
         WHERE A.YYYYMMDD >= CASE WHEN A.VERSION_NO = 'CURRENT' THEN P_NOW_YYYYMMDD
                                  ELSE TO_CHAR(FN_NEXT_DAY(TO_DATE(A.CUTOFF_YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                             END 
           AND A.YYYYMMDD <= P_TO_YYYYMMDD;

    END IF;

    
    
    
    SELECT COUNT(*) INTO v_exists
      FROM SCM_MGR.GT_DM22_PROGRAM_ADD_MEASURE A
     INNER JOIN GT_DM22_SELECT_MEASURE B ON A.UI_MEASURE = B.MEASURE
     WHERE PLAN_RESULT = 'R' AND ROWNUM = 1;

    IF v_exists > 0 THEN
        
        INSERT  INTO GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE,
             YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.UI_MEASURE,
               A.YYYYMMDD, A.QTY, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM SCM_MGR.GT_DM22_RAW_DATA A
         INNER JOIN (SELECT A.UI_MEASURE, A.DB_MEASURE
                       FROM SCM_MGR.GT_DM22_PROGRAM_ADD_MEASURE A
                      INNER JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.UI_MEASURE = B.MEASURE
                      WHERE PLAN_RESULT = 'R') B ON A.MEASURE = B.DB_MEASURE
         WHERE A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <  CASE WHEN A.VERSION_NO = 'CURRENT' THEN P_NOW_YYYYMMDD
                                  ELSE TO_CHAR(FN_NEXT_DAY(TO_DATE(A.CUTOFF_YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                             END;

    END IF;
    
    
    

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A008

    
    

    
    
    
    UPDATE GT_DM22_RAW_DATA A
       SET A.CURRENCY =
           (SELECT B.CURRENCY
              FROM SCM_MGR.SCM_MST_SITE_ITEM B
             WHERE A.DIVISION_ID  = B.DIVISION_ID
               AND A.PROJECT_CODE = B.PROJECT_CODE
               AND A.SCM_SITE_ID  = B.SCM_SITE_ID
               AND A.ITEM_ID      = B.ITEM_ID
               AND ROWNUM = 1)
     WHERE A.CURRENCY IS NULL ;

    IF P_INTERNAL_YN <> 'Y' THEN
        DELETE FROM GT_DM22_RAW_DATA
         WHERE SCM_SITE_ID IN (SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN);
    END IF;



    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A009

  
  
  











































































    
    
    
    INSERT  INTO SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_ORI_V
          (COMPANY_ID
          ,DIVISION_ID
          ,SITE_ID
          ,ITEM_ID
          ,ITEM_NAME
          ,NICK_NAME
          ,ITEM_TYPE
          ,ITEM_CLASS_LEVEL_1
          ,ITEM_CLASS_LEVEL_2
          ,ITEM_CLASS_LEVEL_3
          ,ITEM_CLASS_LEVEL_4
          ,ITEM_CLASS
          ,ITEM_CLASS_NAME
          ,MATERIAL_CLASS
          ,MATERIAL_CLASS_NAME
          ,ELECTRODE_TYPE
          ,SIDE_TYPE
          ,ITEM_GROUP_ID
          ,SETUP_GROUP_ID_1
          ,SETUP_GROUP_ID_2
          ,SETUP_GROUP_ID_3
          ,FLOW_ID
          ,ERP_EOL
          ,SCP_EOL
          ,ITEM_UOM
          ,SPEC
          ,DEMAND_LOT_SIZE
          ,ITEM_ATTRIBUTE
          ,SETUP_ATTRIBUTE
          ,BATCH_RATIO_ID
          ,OUTSOURCING_FACTORY
          ,FINITE_TERM
          ,FINITE_TERM_UOM
          ,COATED_LENGTH
          ,UNCOATED_LENGTH
          ,LENGTH_UOM
          ,SLURRY_LOSS_RATE
          ,DESCRIPTION
          ,ACTIVE_FLAG
          ,INSERT_ID
          ,INSERT_TIME
          ,UPDATE_ID
          ,UPDATE_TIME
          ,APPLIED_MODEL
          ,CELL_TYPE
          ,MAKE_AND_BUY
          ,COLOR_ATTRIBUTE
          ,FORMATION_FLOW_ID
          ,STANDARD_COST
          ,CURRENCY
          ,FORM_ATTRIBUTE
          ,ENERGE
          ,SCP_FLOW_ID
          ,SCP_OPERATION_GROUP
          ,SCP_OPERATION_GROUP_ID
          ,MDM_PROJECT_NAME
          ,MIN_CAPACITY
          ,MOBILE_MODEL_ID
          ,FORECAST_INFO_BIZ_TYPE
          ,FORECAST_INFO_PRODUCT_GROUP
          ,FORECAST_INFO_CELL_MODEL
          ,FORECAST_INFO_CELL_PACK_COUNT
          ,FORECAST_INFO_SPEC
          ,FORECAST_INFOR_VERSION
          ,DOE
          ,INSULATION_COATING
          ,PACK_PRODUCT_GROUP_CODE
          ,CELL_QUANTITY
          ,SCP_EXTRA_SPEC
          ,SCM_PIC
          ,REP_CUSTOMER
          ,MAKER
          ,EVAL_CLASS
          ,EVAL_CLASS_INFO
          ,FP_EXTRA_SPEC
          ,MRP_USE_FLAG
          ,ITEM_RAW_PLANT_ID
          ,ITEM_COPY_YN
          )
    SELECT COMPANY_ID
          ,DIVISION_ID
          ,SITE_ID
          ,ITEM_ID
          ,ITEM_NAME
          ,NICK_NAME
          ,ITEM_TYPE
          ,ITEM_CLASS_LEVEL_1
          ,ITEM_CLASS_LEVEL_2
          ,ITEM_CLASS_LEVEL_3
          ,ITEM_CLASS_LEVEL_4
          ,ITEM_CLASS
          ,ITEM_CLASS_NAME
          ,MATERIAL_CLASS
          ,MATERIAL_CLASS_NAME
          ,ELECTRODE_TYPE
          ,SIDE_TYPE
          ,ITEM_GROUP_ID
          ,SETUP_GROUP_ID_1
          ,SETUP_GROUP_ID_2
          ,SETUP_GROUP_ID_3
          ,FLOW_ID
          ,ERP_EOL
          ,SCP_EOL
          ,ITEM_UOM
          ,SPEC
          ,DEMAND_LOT_SIZE
          ,ITEM_ATTRIBUTE
          ,SETUP_ATTRIBUTE
          ,BATCH_RATIO_ID
          ,OUTSOURCING_FACTORY
          ,FINITE_TERM
          ,FINITE_TERM_UOM
          ,COATED_LENGTH
          ,UNCOATED_LENGTH
          ,LENGTH_UOM
          ,SLURRY_LOSS_RATE
          ,DESCRIPTION
          ,ACTIVE_FLAG
          ,INSERT_ID
          ,INSERT_TIME
          ,UPDATE_ID
          ,UPDATE_TIME
          ,APPLIED_MODEL
          ,CELL_TYPE
          ,MAKE_AND_BUY
          ,COLOR_ATTRIBUTE
          ,FORMATION_FLOW_ID
          ,STANDARD_COST
          ,CURRENCY
          ,FORM_ATTRIBUTE
          ,ENERGE
          ,SCP_FLOW_ID
          ,SCP_OPERATION_GROUP
          ,SCP_OPERATION_GROUP_ID
          ,MDM_PROJECT_NAME
          ,MIN_CAPACITY
          ,MOBILE_MODEL_ID
          ,FORECAST_INFO_BIZ_TYPE
          ,FORECAST_INFO_PRODUCT_GROUP
          ,FORECAST_INFO_CELL_MODEL
          ,FORECAST_INFO_CELL_PACK_COUNT
          ,FORECAST_INFO_SPEC
          ,FORECAST_INFOR_VERSION
          ,DOE
          ,INSULATION_COATING
          ,PACK_PRODUCT_GROUP_CODE
          ,CELL_QUANTITY
          ,SCP_EXTRA_SPEC
          ,SCM_PIC
          ,REP_CUSTOMER
          ,MAKER
          ,EVAL_CLASS
          ,EVAL_CLASS_INFO
          ,FP_EXTRA_SPEC
          ,MRP_USE_FLAG
          ,ITEM_RAW_PLANT_ID
          ,ITEM_COPY_YN
    FROM   SCM_MGR.SCM_MST_ITEM_SN
    WHERE DIVISION_ID = p_division_id
    ;

    
    
    
    INSERT  INTO SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_A_V
          (DIVISION_ID
          ,ITEM_ID
          ,ITEM_CLASS
          ,ITEM_NAME
          ,ITEM_CLASS_NAME
          ,NICK_NAME
          ,ITEM_TYPE
          ,MATERIAL_CLASS_NAME
          ,ITEM_UOM
          ,SPEC
          ,MDM_PROJECT_NAME
          ,MIN_CAPACITY
          ,ACTIVE_FLAG
          ,ENERGE
          ,CELL_QUANTITY
          ,SCP_EXTRA_SPEC
          )
    SELECT T1.DIVISION_ID
          ,T1.ITEM_ID
          ,MAX(T1.ITEM_CLASS)           AS ITEM_CLASS
          ,MAX(T1.ITEM_NAME)            AS ITEM_NAME
          ,MAX(T1.ITEM_CLASS_NAME)      AS ITEM_CLASS_NAME
          ,MAX(T1.NICK_NAME)            AS NICK_NAME
          ,CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                  WHEN T1.ITEM_TYPE = 'H' THEN 2
                  WHEN T1.ITEM_TYPE = 'Q' THEN 3
               ELSE 4 END )
                      WHEN 1 THEN 'P'
                      WHEN 2 THEN 'H'
                      WHEN 3 THEN 'Q'
                      ELSE 'R' END      AS ITEM_TYPE
          ,MAX(T1.MATERIAL_CLASS_NAME)  AS MATERIAL_CLASS_NAME
          ,MAX(T1.ITEM_UOM)             AS ITEM_UOM
          ,MAX(T1.SPEC)                 AS SPEC
          ,MAX(T1.MDM_PROJECT_NAME)     AS MDM_PROJECT_NAME
          ,MAX(T1.MIN_CAPACITY)         AS MIN_CAPACITY
          ,MAX(T1.ACTIVE_FLAG)          AS ACTIVE_FLAG
          ,MAX(T1.ENERGE)               AS ENERGE
          ,MAX(T1.CELL_QUANTITY)        AS CELL_QUANTITY
          ,MAX(T1.SCP_EXTRA_SPEC)       AS SCP_EXTRA_SPEC
    FROM  SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_ORI_V T1
    WHERE 1=1
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID
    ;

    
    
    
    INSERT  INTO SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_B_V
          (DIVISION_ID
          ,ITEM_ID
          ,FORECAST_INFO_BIZ_TYPE
          ,FORECAST_INFO_PRODUCT_GROUP
          ,FORECAST_INFO_CELL_MODEL
          ,FORECAST_INFO_CELL_PACK_COUNT
          ,FORECAST_INFO_SPEC
          ,FORECAST_INFOR_VERSION
          ,CELL_TYPE
          )
    SELECT DIVISION_ID
          ,SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
          ,MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
          ,MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
          ,MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
          ,MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
          ,MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
          ,MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
          ,MAX(CELL_TYPE) AS CELL_TYPE
    FROM  SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_ORI_V T2
    GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
    ;

    
    
    
    
    
    
    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_RAW_DATA',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);
    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_A_V',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);
    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_B_V',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);
    

    
    
    
    
    INSERT  INTO SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V
          (DIVISION_ID
          ,ITEM_ID
          ,ITEM_NAME
          ,ITEM_CLASS
          ,ITEM_CLASS_NAME
          ,NICK_NAME
          ,ITEM_TYPE
          ,MATERIAL_CLASS_NAME
          ,ITEM_UOM
          ,SPEC
          ,MDM_PROJECT_NAME
          ,MIN_CAPACITY
          ,FORECAST_INFO_BIZ_TYPE
          ,FORECAST_INFO_PRODUCT_GROUP
          ,FORECAST_INFO_CELL_MODEL
          ,FORECAST_INFO_CELL_PACK_COUNT
          ,FORECAST_INFO_SPEC
          ,FORECAST_INFOR_VERSION
          ,ACTIVE_FLAG
          ,CELL_TYPE
          ,CELL_QUANTITY
          ,SCP_EXTRA_SPEC
          ,ENERGE_WH
          ,ENERGE
          )
    SELECT A.DIVISION_ID, A.ITEM_ID, A.ITEM_NAME, A.ITEM_CLASS, A.ITEM_CLASS_NAME
         , A.NICK_NAME, A.ITEM_TYPE, A.MATERIAL_CLASS_NAME, A.ITEM_UOM, A.SPEC
         , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.FORECAST_INFO_PRODUCT_GROUP, A.FORECAST_INFO_CELL_MODEL
         , A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION, A.ACTIVE_FLAG, A.CELL_TYPE
         , A.CELL_QUANTITY, A.SCP_EXTRA_SPEC, A.ENERGE AS ENERGE_WH
         , CASE WHEN REGEXP_LIKE(A.ENERGE, '^\d+(\.\d+)?$') THEN ROUND(TO_NUMBER(A.ENERGE) / 1000, 7) ELSE NULL END AS ENERGE
    FROM
        ( SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME
               , T1.NICK_NAME, T1.ITEM_TYPE, T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC
               , T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
               , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION, T1.ACTIVE_FLAG, T2.CELL_TYPE
               , T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC, T1.ENERGE
          FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_A_V T1
              INNER JOIN SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_B_V T2
                  ON T1.DIVISION_ID = T2.DIVISION_ID
                   AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
          WHERE 1=1  ) A
      JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID FROM SCM_MGR.GT_DM22_RAW_DATA ) B ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
      WHERE A.DIVISION_ID = p_division_id
      GROUP BY A.DIVISION_ID, A.ITEM_ID, A.ITEM_NAME, A.ITEM_CLASS, A.ITEM_CLASS_NAME, A.NICK_NAME, A.ITEM_TYPE, A.MATERIAL_CLASS_NAME
           , A.ITEM_UOM, A.SPEC, A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.FORECAST_INFO_PRODUCT_GROUP
           , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
           , A.ACTIVE_FLAG, A.CELL_TYPE, A.ENERGE, A.CELL_QUANTITY, A.SCP_EXTRA_SPEC
    ;


    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_V',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);

    
    
    



































    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A010

    
    
    
    INSERT  INTO GT_DM22_SCM_MST_SITE_ITEM
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, APPLICATION,
           CUST_GROUP, ROUTE, CUST_GROUP_DTL, CELL_PER_CAR, CELL_PER_MODULE,
           SALES_COMPANY, CURRENCY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5,
           ATTRIBUTE7, ATTRIBUTE8, NULL AS REPORT_GROUP6, A.OWNER,
           FN_GET_DM_MKT_OWNER_NAME(A.OWNER, ',', 'EN')   AS OWNER_NAME,
           FN_GET_DM_MKT_OWNER_NAME(A.OWNER, ',', 'KO')   AS OWNER_NAME_KO,
           (SELECT SU.DEPT_ID FROM SCM_MST_SSO_USER_INFO SU
             WHERE SU.USER_ID = (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(A.OWNER,',')) P WHERE ROWNUM = 1)) AS DEPT_ID,
           VALID_YN
      FROM SCM_MGR.SCM_MST_SITE_ITEM A
      JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID FROM SCM_MGR.GT_DM22_RAW_DATA) B
        ON A.DIVISION_ID  = B.DIVISION_ID
       AND A.SCM_SITE_ID  = B.SCM_SITE_ID
       AND A.PROJECT_CODE = B.PROJECT_CODE
       AND A.ITEM_ID      = B.ITEM_ID
     WHERE A.DIVISION_ID = P_DIVISION_ID;
    
    
    
    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A011

    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_SCM_MST_SITE_ITEM',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);


    DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
     WHERE A.PLAN_RESULT = 'P'
       AND A.ITEM_ID NOT IN (SELECT SEGMENT3 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                              WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                AND SEGMENT1 = A.DIVISION_ID)
       AND NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DM22_SCM_MST_SITE_ITEM B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.PROJECT_CODE = B.PROJECT_CODE
                          AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                          AND A.ITEM_ID      = B.ITEM_ID
                          AND B.VALID_YN     = 'Y');
    



    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A012

    
    
    
    UPDATE SCM_MGR.GT_DM22_RAW_DATA A
       SET A.ATTRIBUTE1 =
           (SELECT B.ATTRIBUTE1
              FROM SCM_MGR.DM_PLN_SALES_ETC_PLAN B
             WHERE B.DIVISION_ID  = '40'
               AND B.FCST_TYPE    = 'ETC'
               AND B.YYYYMMDD    >= P_NOW_YYYYMMDD AND B.YYYYMMDD <= P_TO_YYYYMMDD
               AND B.QTY         <> 0
               AND A.DIVISION_ID  = B.DIVISION_ID
               AND A.PROJECT_CODE = B.PROJECT_CODE
               AND A.SCM_SITE_ID  = B.SCM_SITE_ID
               AND A.ITEM_ID      = B.ITEM_ID
               AND A.DOM_EXP      = B.DOM_EXP
               AND A.FCST_TYPE    = B.FCST_TYPE
               AND A.INCOTERMS    = B.INCOTERMS
               AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
               AND A.YYYYMMDD     = B.YYYYMMDD
               AND A.TEXT         = B.REMARK_TEXT
               AND ROWNUM = 1)
     WHERE A.DIVISION_ID = '40' AND A.FCST_TYPE = 'ETC';
    
    
    



    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013

    
    
    
    IF NVL(P_PROJECT_CODE,'@#@#@#') <> '@#@#@#' THEN 
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_MST_PROJECT B
                    WHERE A.DIVISION_ID  = B.DIVISION_ID
                      AND A.PROJECT_CODE = B.PROJECT_CODE
                      AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE B.PROJECT_CODE LIKE '%'|| P.TOKEN ||'%')
                           OR
                           EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE B.PROJECT_NAME LIKE '%'|| P.TOKEN ||'%')
                          )
               );
        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-1

    END IF;

    IF NVL(P_ITEM_ID,'@#@#@#') <> '@#@#@#' THEN
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V B
                    WHERE A.ITEM_ID = B.ITEM_ID
                      AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE A.ITEM_ID LIKE '%'|| P.TOKEN ||'%')
                           OR
                           EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE B.NICK_NAME LIKE '%'|| P.TOKEN ||'%')
                          )
               );
        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-2
    END IF;

    IF NVL(P_OWNER,'@#@#@#') <> '@#@#@#' THEN
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.GT_DM22_SCM_MST_SITE_ITEM B
                    WHERE A.ITEM_ID     = B.ITEM_ID
                      AND A.SCM_SITE_ID = B.SCM_SITE_ID
                      AND A.PROJECT_CODE= B.PROJECT_CODE
                      AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_OWNER,',')) P WHERE B.OWNER LIKE '%'|| P.TOKEN ||'%')
                           OR
                           EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_OWNER,',')) P WHERE B.OWNER_NAME LIKE '%'|| P.TOKEN ||'%')
                           OR
                           EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_OWNER,',')) P WHERE B.OWNER_NAME_KO LIKE '%'|| P.TOKEN ||'%')
                          )
               );
        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-3
    END IF;

    IF P_DEPT_ID <> 'ALL' THEN
        
        
        
        
        
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE A.FCST_TYPE <> 'ETC'
           AND NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DM22_SCM_MST_SITE_ITEM B
                            WHERE A.ITEM_ID     = B.ITEM_ID
                              AND A.SCM_SITE_ID = B.SCM_SITE_ID
                              AND A.PROJECT_CODE= B.PROJECT_CODE
                              AND B.DEPT_ID IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DEPT_ID,',')) P)
                          );

        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-4
        
        
        
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE A.FCST_TYPE   = 'ETC'
           AND A.DIVISION_ID <> '40' 
           AND NOT EXISTS (
                           SELECT 1
                             FROM SCM_MGR.SCM_MST_SITE B
                                   LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM C
                                        ON C.DIVISION_ID = B.DIVISION_ID
                                       AND C.SCM_SITE_ID = B.SCM_SITE_ID
                            WHERE B.SCM_SITE_ID  = A.SCM_SITE_ID
                              AND B.DIVISION_ID  = P_DIVISION_ID
                              AND C.PROJECT_CODE = A.PROJECT_CODE
                              AND C.ITEM_ID      = A.ITEM_ID
                              AND C.DEPT_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_DEPT_ID,',')) P)
               );

        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-5
        
        
        
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE A.FCST_TYPE   = 'ETC'
           AND A.DIVISION_ID = '40'
           AND A.ATTRIBUTE1 NOT IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DEPT_ID,',')) P)
        ; 
        
        
        
        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-6
    END IF;

	
























    IF P_END_CUSTOMER <> 'ALL' THEN
        IF P_DIVISION_ID = '40' THEN
            DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
             WHERE A.PROJECT_CODE NOT IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER,',')) P)
            ;
        ELSE
            DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
             WHERE NOT EXISTS (
                       SELECT 1 FROM SCM_MGR.SCM_MST_SITE B
                        WHERE A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = P_DIVISION_ID
                          AND B.END_CUSTOMER IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER,',')) P)
                   );
        END IF;
        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-7
    END IF;

    IF P_SCM_SITE_ID <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE A.SCM_SITE_ID NOT IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_SCM_SITE_ID,',')) P)
         ;
    END IF;

    IF P_PLANT_SITE_ID <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE A.PLANT_SITE_ID NOT IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PLANT_SITE_ID,',')) P)
         ;
        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-8
    END IF;

    IF P_ITEM_TYPE <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
         WHERE NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V B
                    WHERE A.ITEM_ID = B.ITEM_ID
                      AND B.ITEM_TYPE IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_TYPE,',')) P)
               );
    END IF;

    IF P_BIZTYPE <> 'ALL' THEN
        IF P_DIVISION_ID = '40' THEN
            DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
             WHERE NOT EXISTS (
                       SELECT 1 FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V B
                        WHERE A.ITEM_ID = B.ITEM_ID
                          AND B.FORECAST_INFO_BIZ_TYPE IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_BIZTYPE,',')) P)
                   );
        ELSE
            DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
             WHERE NOT EXISTS (
                       SELECT 1 FROM SCM_MGR.SCM_MST_PROJECT B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.PROJECT_CODE = B.PROJECT_CODE
                          AND EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_BIZTYPE,',')) P WHERE B.BIZ_TYPE LIKE P.TOKEN ||'%')
                   );
        END IF;
        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A013-9
    END IF;

    
    
    

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A014

    
    
    
    
    
    
    SELECT COUNT(*) INTO v_exists FROM SCM_MGR.GT_DM22_SELECT_MEASURE WHERE MEASURE = 'LOC' AND ROWNUM = 1;
    IF v_exists > 0 THEN
        INSERT  INTO SCM_MGR.GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE,
             YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               '', A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'LOC',
               A.YYYYMMDD,
               CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END,
               'R', A.CELL_PROD_SITE_ID
          FROM (SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                       A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                  FROM SCM_MGR.GT_DM22_RAW_DATA A
                 WHERE YYYYMMDD >= v_start_yyyymmdd
                   AND YYYYMMDD <  CASE WHEN VERSION_NO = 'CURRENT' THEN P_NOW_YYYYMMDD
                                        ELSE TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD') END
                   AND A.MEASURE = 'RTF_SYS_RP'
                 GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID,
                          A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID) A
          JOIN (SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                       A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                  FROM SCM_MGR.GT_DM22_RAW_DATA A
                 WHERE YYYYMMDD >= v_start_yyyymmdd
                   AND YYYYMMDD <  CASE WHEN VERSION_NO = 'CURRENT' THEN P_NOW_YYYYMMDD
                                        ELSE TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD') END
                   AND A.MEASURE = 'SalesAmt_LOC'
                 GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID,
                          A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID) B
                ON A.VERSION_NO            = B.VERSION_NO
               AND A.DIVISION_ID           = B.DIVISION_ID
               AND A.PROJECT_CODE          = B.PROJECT_CODE
               AND A.SCM_SITE_ID           = B.SCM_SITE_ID
               AND A.PLANT_SITE_ID         = B.PLANT_SITE_ID
               AND A.ITEM_ID               = B.ITEM_ID
               AND A.INCOTERMS             = B.INCOTERMS
               AND A.DOM_EXP               = B.DOM_EXP
               AND A.FCST_TYPE             = B.FCST_TYPE
               AND A.CURRENCY              = B.CURRENCY
               AND A.YYYYMMDD              = B.YYYYMMDD
               AND NVL(A.COMPANY_ID,'')    = NVL(B.COMPANY_ID,'')
               AND A.CELL_PROD_SITE_ID     = B.CELL_PROD_SITE_ID;

    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A015

    
    
    
    SELECT COUNT(*) INTO v_exists FROM SCM_MGR.GT_DM22_SELECT_MEASURE WHERE MEASURE = 'KRW' AND ROWNUM = 1;
    IF v_exists > 0 THEN
        INSERT  INTO SCM_MGR.GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE,
             YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               '', A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'KRW',
               A.YYYYMMDD,
               CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END,
               'R', A.CELL_PROD_SITE_ID
          FROM (SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                       A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                  FROM SCM_MGR.GT_DM22_RAW_DATA A
                 WHERE YYYYMMDD >= v_start_yyyymmdd
                   AND YYYYMMDD <  CASE WHEN VERSION_NO = 'CURRENT' THEN P_NOW_YYYYMMDD
                                        ELSE TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD') END
                   AND A.MEASURE = 'RTF_SYS_RP'
                 GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID,
                          A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID) A
          JOIN (SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                       A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                  FROM SCM_MGR.GT_DM22_RAW_DATA A
                 WHERE YYYYMMDD >= v_start_yyyymmdd
                   AND YYYYMMDD <  CASE WHEN VERSION_NO = 'CURRENT' THEN P_NOW_YYYYMMDD
                                        ELSE TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD') END
                   AND A.MEASURE = 'SalesAmt_KRW'
                 GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID,
                          A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID) B
                ON A.VERSION_NO            = B.VERSION_NO
               AND A.DIVISION_ID           = B.DIVISION_ID
               AND A.PROJECT_CODE          = B.PROJECT_CODE
               AND A.SCM_SITE_ID           = B.SCM_SITE_ID
               AND A.PLANT_SITE_ID         = B.PLANT_SITE_ID
               AND A.ITEM_ID               = B.ITEM_ID
               AND A.INCOTERMS             = B.INCOTERMS
               AND A.DOM_EXP               = B.DOM_EXP
               AND A.FCST_TYPE             = B.FCST_TYPE
               AND A.CURRENCY              = B.CURRENCY
               AND A.YYYYMMDD              = B.YYYYMMDD
               AND NVL(A.COMPANY_ID,'')    = NVL(B.COMPANY_ID,'')
               AND A.CELL_PROD_SITE_ID     = B.CELL_PROD_SITE_ID;

    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A016

    
    
    
    
    
    
    
    
    SELECT COUNT(*) INTO v_exists FROM SCM_MGR.GT_DM22_SELECT_MEASURE WHERE MEASURE IN ('KRW','LOC','USD') AND ROWNUM = 1;

    IF v_exists > 0 AND P_VERSION_TYPE LIKE '%CURRENT%' THEN
        IF P_DIVISION_ID = '40' THEN
            INSERT  INTO SCM_MGR.GT_DM22_RAW_DATA
                (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
                 TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
            SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                   A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE,
                   A.YYYYMMDD, C.PRICE, 'P', A.CELL_PROD_SITE_ID
              FROM (SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                                    A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD,
                                    B.BASIS_START_DATE, A.CELL_PROD_SITE_ID
                     FROM SCM_MGR.GT_DM22_RAW_DATA A
                     JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
                    WHERE A.YYYYMMDD >= P_NOW_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
                      AND A.MEASURE IN ('RTF_SYS_RP','MKT_FCST_RP','MKT_FCST','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW','Catch_Up','SCM_FCST')) A
              JOIN SCM_MGR.DM_PLN_CFM_SELLING_PRICE C
                ON A.DIVISION_ID        = C.DIVISION_ID
               AND A.PROJECT_CODE       = C.PROJECT_CODE
               AND A.SCM_SITE_ID        = C.SCM_SITE_ID
               AND A.CELL_PROD_SITE_ID  = C.CELL_PROD_SITE_ID
               AND A.PLANT_SITE_ID      = C.PLANT_SITE_ID
               AND A.ITEM_ID            = C.ITEM_ID
               AND A.INCOTERMS          = C.INCOTERMS
               AND A.DOM_EXP            = C.DOM_EXP
               AND A.FCST_TYPE          = C.FCST_TYPE
               AND A.BASIS_START_DATE   = C.YYYYMMDD
               AND C.YYYYMMDD          <= P_TO_YYYYMMDD
              JOIN SCM_MGR.GT_DM22_SELECT_MEASURE D ON C.MEASURE = D.MEASURE;
        ELSE
            INSERT  INTO SCM_MGR.GT_DM22_RAW_DATA
                (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
                 TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
            SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                   A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE,
                   A.YYYYMMDD, C.PRICE, 'P', A.CELL_PROD_SITE_ID
              FROM (SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                                    A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD,
                                    B.BASIS_START_DATE, A.CELL_PROD_SITE_ID
                     FROM SCM_MGR.GT_DM22_RAW_DATA A
                     JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
                    WHERE A.YYYYMMDD >= P_NOW_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
                      AND A.MEASURE IN ('RTF_SYS_RP','MKT_FCST_RP','MKT_FCST','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW','Catch_Up','SCM_FCST')) A
              JOIN SCM_MGR.SCM_MST_FUTURE_PRICE C
                ON A.DIVISION_ID      = C.DIVISION_ID
               AND A.PROJECT_CODE     = C.PROJECT_CODE
               AND A.SCM_SITE_ID      = C.SCM_SITE_ID
               AND A.PLANT_SITE_ID    = C.PLANT_SITE_ID
               AND A.ITEM_ID          = C.ITEM_ID
               AND A.INCOTERMS        = C.INCOTERMS
               AND A.DOM_EXP          = C.DOM_EXP
               AND A.FCST_TYPE        = C.FCST_TYPE
               AND A.BASIS_START_DATE = C.YYYYMMDD
               AND C.YYYYMMDD        <= P_TO_YYYYMMDD
              JOIN SCM_MGR.GT_DM22_SELECT_MEASURE D ON C.MEASURE = D.MEASURE;
        END IF;

    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A017

    
    
    
    SELECT COUNT(*) INTO v_exists FROM SCM_MGR.GT_DM22_SELECT_MEASURE WHERE MEASURE IN ('KRW','LOC','USD') AND ROWNUM = 1;

    IF v_exists > 0 AND P_VERSION_TYPE LIKE '%SP_%' THEN
        IF P_DIVISION_ID = '40' THEN
            INSERT  INTO SCM_MGR.GT_DM22_T_PRICE
                (DIVISION_ID, VERSION_NO, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD,
                 CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CELL_PROD_SITE_ID)
            SELECT A.DIVISION_ID, A.VERSION_NO, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD,
                   A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE, A.CELL_PROD_SITE_ID
              FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
              JOIN SCM_MGR.GT_DM22_SELECT_MEASURE C ON A.MEASURE = C.MEASURE
              JOIN SCM_MGR.GT_DM22_V_VERSION_NO D ON A.VERSION_NO = D.VERSION_NO
              JOIN (SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                                    A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID
                      FROM SCM_MGR.GT_DM22_RAW_DATA A
                     WHERE A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.CUTOFF_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD')
                       AND A.YYYYMMDD <= P_TO_YYYYMMDD
                       AND A.MEASURE IN ('RTF_SYS_RP','MKT_FCST_RP','MKT_FCST','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW','SCM_FCST')) B
                ON A.DIVISION_ID       = B.DIVISION_ID
               AND A.PROJECT_CODE      = B.PROJECT_CODE
               AND A.SCM_SITE_ID       = B.SCM_SITE_ID
               AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
               AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
               AND A.ITEM_ID           = B.ITEM_ID
               AND A.INCOTERMS         = B.INCOTERMS
               AND A.DOM_EXP           = B.DOM_EXP
               AND A.FCST_TYPE         = B.FCST_TYPE
             WHERE A.DIVISION_ID = P_DIVISION_ID
               AND A.YYYYMMDD   <= P_TO_YYYYMMDD;
        ELSE
            INSERT  INTO GT_DM22_T_PRICE
                (DIVISION_ID, VERSION_NO, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD,
                 CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CELL_PROD_SITE_ID)
            SELECT A.DIVISION_ID, A.VERSION_NO, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD,
                   A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE, '-'
              FROM SCM_MGR.SCM_MST_FUTURE_PRICE_C A
              JOIN SCM_MGR.GT_DM22_SELECT_MEASURE C ON A.MEASURE = C.MEASURE
              JOIN SCM_MGR.GT_DM22_V_VERSION_NO D ON A.VERSION_NO = D.VERSION_NO
              JOIN (SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                                    A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD
                      FROM SCM_MGR.GT_DM22_RAW_DATA A
                     WHERE A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.CUTOFF_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD')
                       AND A.YYYYMMDD <= P_TO_YYYYMMDD
                       AND A.MEASURE IN ('RTF_SYS_RP','MKT_FCST_RP','MKT_FCST','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW','SCM_FCST')) B
                ON A.DIVISION_ID   = B.DIVISION_ID
               AND A.PROJECT_CODE  = B.PROJECT_CODE
               AND A.SCM_SITE_ID   = B.SCM_SITE_ID
               AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
               AND A.ITEM_ID       = B.ITEM_ID
               AND A.INCOTERMS     = B.INCOTERMS
               AND A.DOM_EXP       = B.DOM_EXP
               AND A.FCST_TYPE     = B.FCST_TYPE
             WHERE A.DIVISION_ID  = P_DIVISION_ID
               AND A.YYYYMMDD    <= P_TO_YYYYMMDD;
        END IF;

        DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_T_PRICE',
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);

        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A018

    
    
    
    












































































































        
        INSERT  INTO GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD,
               C.PRICE, 'P', A.CELL_PROD_SITE_ID
          FROM (SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
                                A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD,
                                B.BASIS_START_DATE, A.CELL_PROD_SITE_ID
                  FROM SCM_MGR.GT_DM22_RAW_DATA A
                  JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD  
				          
                 WHERE A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.CUTOFF_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD')
                   AND A.YYYYMMDD <= P_TO_YYYYMMDD
                   AND A.MEASURE IN ('RTF_SYS_RP','MKT_FCST_RP','MKT_FCST','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW','SCM_FCST')) A
		      
          JOIN SCM_MGR.GT_DM22_T_PRICE C
            ON A.DIVISION_ID      = C.DIVISION_ID
           AND A.PROJECT_CODE     = C.PROJECT_CODE
           AND A.SCM_SITE_ID      = C.SCM_SITE_ID
           AND A.PLANT_SITE_ID    = C.PLANT_SITE_ID
           AND A.ITEM_ID          = C.ITEM_ID
           AND A.INCOTERMS        = C.INCOTERMS
           AND A.DOM_EXP          = C.DOM_EXP
           AND A.FCST_TYPE        = C.FCST_TYPE
           AND A.BASIS_START_DATE = C.YYYYMMDD
           AND A.VERSION_NO       = C.VERSION_NO;
    
    
    
    
    

    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A019

    
    
    
    DELETE FROM SCM_MGR.GT_DM22_RAW_DATA A
     WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_DM22_SELECT_MEASURE B WHERE A.MEASURE = B.MEASURE AND B.SYSTEM_ADD = 'Y');

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A019-1

    
    
    
    SELECT COUNT(*) INTO v_exists
      FROM SCM_MGR.GT_DM22_SELECT_MEASURE
     WHERE MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL','RTF_SYS_RP_CAR','RTF_SYS_RP_CELL','RTF_ENERGY','MKT_FCST_ENERGY')
       AND ROWNUM = 1;

    IF v_exists > 0 THEN
        INSERT  INTO SCM_MGR.GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC, A.YYYYMMDD,
               CASE WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CAR','RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
                        CASE WHEN INSTR(C.ITEM_CLASS_NAME,'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN A.QTY / D.CELL_PER_CAR
                             WHEN INSTR(C.ITEM_CLASS_NAME,'Module') > 0 AND D.CELL_PER_CAR > 0 AND D.CELL_PER_MODULE > 0
                                  THEN A.QTY / (D.CELL_PER_CAR / D.CELL_PER_MODULE)
                             WHEN INSTR(C.ITEM_CLASS_NAME,'Pack') > 0 THEN A.QTY
                             ELSE 0 END
                    WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID LIKE '81%' THEN
                        CASE WHEN INSTR(C.ITEM_CLASS_NAME,'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN A.QTY
                             WHEN (INSTR(C.ITEM_CLASS_NAME,'Module') > 0 OR INSTR(C.ITEM_CLASS_NAME,'Pack') > 0)
                                  AND D.CELL_PER_MODULE > 0 THEN A.QTY * D.CELL_PER_MODULE
                             ELSE 0 END
                    WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID = '82'
                        THEN A.QTY * C.CELL_QUANTITY
                    
                    WHEN B.MEASURE_CALC = 'RTF_ENERGY' THEN
                        CASE WHEN REGEXP_LIKE(C.ENERGE_WH, '^\d+(\.\d+)?$') THEN (A.QTY * TO_NUMBER(C.ENERGE_WH)) / 1000 ELSE NULL END
                    
                    WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'RTF_SYS_RP' AND A.PLAN_RESULT = 'R' THEN
                        CASE WHEN REGEXP_LIKE(C.ENERGE_WH, '^\d+(\.\d+)?$') THEN (TO_NUMBER(C.ENERGE_WH) * A.QTY) / 1000 ELSE NULL END
                    ELSE 0
               END,
               A.PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM SCM_MGR.GT_DM22_RAW_DATA A
          JOIN (SELECT CASE WHEN A.MEASURE LIKE 'MKT_FCST_RP%' THEN 'MKT_FCST_RP' ELSE 'RTF_SYS_RP' END AS MEASURE_ORI,
                       A.MEASURE AS MEASURE_CALC
                  FROM SCM_MGR.GT_DM22_SELECT_MEASURE A
                 WHERE MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL','RTF_SYS_RP_CAR','RTF_SYS_RP_CELL','RTF_ENERGY','MKT_FCST_ENERGY')) B
                ON A.MEASURE = B.MEASURE_ORI
          JOIN SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
          LEFT OUTER JOIN SCM_MGR.GT_DM22_SCM_MST_SITE_ITEM D
                       ON A.DIVISION_ID  = D.DIVISION_ID
                      AND A.SCM_SITE_ID  = D.SCM_SITE_ID
                      AND A.PROJECT_CODE = D.PROJECT_CODE
                      AND A.ITEM_ID      = D.ITEM_ID
         WHERE A.MEASURE IN ('MKT_FCST_RP','RTF_SYS_RP');

    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A020

    
    
    
    SELECT COUNT(*) INTO v_exists FROM SCM_MGR.GT_DM22_SELECT_MEASURE WHERE MEASURE = 'MKT_FCST_ENERGY' AND ROWNUM = 1;
    IF v_exists > 0 THEN
        INSERT  INTO GT_DM22_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
             TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
               A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC, A.YYYYMMDD,
               CASE WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND A.PLAN_RESULT = 'P' THEN
                        CASE WHEN REGEXP_LIKE(C.ENERGE_WH,'^\d+(\.\d+)?$') THEN (TO_NUMBER(C.ENERGE_WH) * A.QTY)/1000 ELSE NULL END
                    ELSE 0 END,
               A.PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM SCM_MGR.GT_DM22_RAW_DATA A
          JOIN (SELECT 'MKT_FCST_RP' AS MEASURE_ORI, A.MEASURE AS MEASURE_CALC
                  FROM SCM_MGR.GT_DM22_SELECT_MEASURE A WHERE MEASURE = 'MKT_FCST_ENERGY') B ON A.MEASURE = B.MEASURE_ORI
          JOIN SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
         WHERE A.MEASURE = 'MKT_FCST_RP';

    END IF;

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A021




























































































    
    
    
    
    
    
    
    V_PV_LIST     := '';
    V_PV_COL_LIST := '';

    FOR r IN (
        SELECT COLUMN_NAME, PV_NAME, SORT_ORDER_NO
          FROM (
                   
                   SELECT '''D_' || A.BASIS_YYYYMMDD || '''  AS D_' || A.BASIS_YYYYMMDD AS COLUMN_NAME,
                          'D_' || A.BASIS_YYYYMMDD || ' ' AS PV_NAME,
                          A.BASIS_YYYYMMDD || '_' || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                     FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                    WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                      AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                      AND P_BUCKET = 'DAILY'
                   UNION ALL
                   
                   SELECT '''W_' || A.BASIS_YYYYMM || A.ISO_WEEK || '''  AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK,
                          'W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ' ',
                          A.BASIS_START_DATE || '_' || TO_CHAR(21, 'FM00')
                     FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                    WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                      AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                      AND P_BUCKET <> 'ONLY_WEEKLY'
                    GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                   UNION ALL
                   
                   SELECT '''M_' || A.BASIS_YYYYMM || '''  AS M_' || A.BASIS_YYYYMM,
                          'M_' || A.BASIS_YYYYMM || ' ',
                          MIN(A.BASIS_START_DATE) || '_' || TO_CHAR(1, 'FM00')
                     FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                    WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                      AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                      AND P_BUCKET <> 'ONLY_WEEKLY'
                    GROUP BY A.BASIS_YYYYMM
                   UNION ALL
                   
                   SELECT '''W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK || '''  AS W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK,
                          'W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK || ' ',
                          MAX(BASIS_YYYYMMDD) || '_' || TO_CHAR(21, 'FM00')
                     FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                    WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                      AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                      AND P_BUCKET = 'ONLY_WEEKLY'
                    GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
               )
         ORDER BY SORT_ORDER_NO
    ) LOOP
        IF V_PV_COL_LIST IS NOT NULL AND LENGTH(V_PV_COL_LIST) > 0 THEN
            V_PV_COL_LIST := V_PV_COL_LIST || ',' || r.COLUMN_NAME || CHR(10);
            V_PV_LIST     := V_PV_LIST     || ',' || r.PV_NAME || CHR(10);
        ELSE
            V_PV_COL_LIST := r.COLUMN_NAME || CHR(10);
            V_PV_LIST     := r.PV_NAME || CHR(10);
        END IF;
    END LOOP;
		
		
		

    
    
    
    
    INSERT  INTO SCM_MGR.GT_DM22_SCM_MST_SITE
        (SCM_SITE_ID, DIVISION_ID, PROJECT_CODE, ITEM_ID, DEPT_ID, SOLDTO_CODE, VMI_YN, END_CUSTOMER, CITY_NAME, COUNTRY_NAME, SHIPTO_DESCRIPTION, SOLDTO_DESCRIPTION)
    SELECT B.SCM_SITE_ID, B.DIVISION_ID, B.PROJECT_CODE, B.ITEM_ID, B.DEPT_ID, K.SOLDTO_CODE, B.VMI_YN, B.END_CUSTOMER,
           H.CITY_NAME, J.COUNTRY_NAME, L.SHIPTO_DESCRIPTION, L.SOLDTO_DESCRIPTION
      FROM (SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.PROJECT_CODE, B.ITEM_ID, B.DEPT_ID, A.END_CUSTOMER, A.VMI_YN, A.CITY, A.COUNTRY
              FROM SCM_MGR.SCM_MST_SITE A
                   LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                        ON A.DIVISION_ID = B.DIVISION_ID
                       AND A.SCM_SITE_ID = B.SCM_SITE_ID
             WHERE 1=1
             GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, B.PROJECT_CODE, B.ITEM_ID, B.DEPT_ID, A.END_CUSTOMER, A.VMI_YN, A.CITY, A.COUNTRY
           ) B
      LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_CUSTOMER K ON B.DIVISION_ID = K.DIVISION_ID AND B.SCM_SITE_ID = K.SCM_SITE_ID AND K.REP_YN = 'Y'
      LEFT OUTER JOIN SCM_MGR.SCM_MST_CITY H ON B.CITY = H.CITY
      LEFT OUTER JOIN SCM_MGR.SCM_MST_COUNTRY J ON B.COUNTRY = J.COUNTRY
      LEFT OUTER JOIN SCM_MGR.SCM_MST_CUSTOMER L ON K.DIVISION_ID = L.DIVISION_ID AND K.SHIPTO_CODE = L.SHIPTO_CODE AND K.SOLDTO_CODE = L.SOLDTO_CODE;

    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_SCM_MST_SITE',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);
    
    
    

    
    INSERT  INTO SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V_T
          (DIVISION_ID
          ,ITEM_ID
          ,ITEM_NAME
          ,ITEM_CLASS
          ,ITEM_CLASS_NAME
          ,NICK_NAME
          ,ITEM_TYPE
          ,MATERIAL_CLASS_NAME
          ,ITEM_UOM
          ,SPEC
          ,MDM_PROJECT_NAME
          ,MIN_CAPACITY
          ,FORECAST_INFO_BIZ_TYPE
          ,FORECAST_INFO_PRODUCT_GROUP
          ,FORECAST_INFO_CELL_MODEL
          ,FORECAST_INFO_CELL_PACK_COUNT
          ,FORECAST_INFO_SPEC
          ,FORECAST_INFOR_VERSION
          ,ACTIVE_FLAG
          ,CELL_TYPE
          ,CELL_QUANTITY
          ,SCP_EXTRA_SPEC
          ,ENERGE_WH
          ,ENERGE
          ,SEGMENT2
          ,CELL_MODEL_NICK_NAME
          )
    SELECT D.DIVISION_ID
          ,D.ITEM_ID
          ,D.ITEM_NAME
          ,D.ITEM_CLASS
          ,D.ITEM_CLASS_NAME
          ,D.NICK_NAME
          ,D.ITEM_TYPE
          ,D.MATERIAL_CLASS_NAME
          ,D.ITEM_UOM
          ,D.SPEC
          ,D.MDM_PROJECT_NAME
          ,D.MIN_CAPACITY
          ,D.FORECAST_INFO_BIZ_TYPE
          ,D.FORECAST_INFO_PRODUCT_GROUP
          ,D.FORECAST_INFO_CELL_MODEL
          ,D.FORECAST_INFO_CELL_PACK_COUNT
          ,D.FORECAST_INFO_SPEC
          ,D.FORECAST_INFOR_VERSION
          ,D.ACTIVE_FLAG
          ,D.CELL_TYPE
          ,D.CELL_QUANTITY
          ,D.SCP_EXTRA_SPEC
          ,D.ENERGE_WH
          ,D.ENERGE
          ,E.SEGMENT2
          ,NVL(F.NICK_NAME,'') AS CELL_MODEL_NICK_NAME
    FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V D
    LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL E
           ON D.CELL_TYPE = E.SEGMENT1
          AND E.LOOKUP_TYPE = 'CELL_TYPE'
    LEFT OUTER JOIN SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V F
           ON D.DIVISION_ID = F.DIVISION_ID
          AND NVL(D.FORECAST_INFO_CELL_MODEL,'@#@#@#') = F.ITEM_ID
    ;

    
    
    
    IF P_DIVISION_ID = '82' THEN
        UPDATE SCM_MGR.GT_DM22_V_VERSION_NO A
           SET A.TOBE_VERSION_NO =
               (SELECT CASE WHEN C.DM_RTF_YN = 'N' THEN A.VERSION_NO || '(' || B.WEEK_NAME || ') (NO PLAN)'
                            ELSE A.VERSION_NO || '(' || B.WEEK_NAME || ')' END
                  FROM SCM_MGR.SCM_SYS_CALENDAR_M B, SCM_MGR.SCP_PLN_INTERFACE_YN C
                 WHERE SUBSTR(A.VERSION_NO, 6, 8) = B.BASIS_YYYYMMDD
                   AND C.DIVISION_ID = P_DIVISION_ID
                   AND B.BASIS_START_DATE = C.PLAN_START_YYYYMMDD
                   AND ROWNUM = 1);

        UPDATE SCM_MGR.GT_DM22_RAW_DATA A
           SET A.VERSION_NO =
               (SELECT B.TOBE_VERSION_NO
                  FROM SCM_MGR.GT_DM22_V_VERSION_NO B
                 WHERE A.VERSION_NO = B.VERSION_NO
                   AND B.TOBE_VERSION_NO IS NOT NULL
                   AND ROWNUM = 1)
         WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_DM22_V_VERSION_NO B
                        WHERE A.VERSION_NO = B.VERSION_NO AND B.TOBE_VERSION_NO IS NOT NULL);

    END IF;
    
    
    


    
    
    
    SELECT COUNT(*)
      INTO i_count
      FROM SCM_MGR.SCM_MST_TITLESET_USER U
     WHERE U.PROGRAM_ID                     = v_program_id
       AND U.SHEET_NAME                     = v_sheet_name
       AND U.USER_ID                        = P_CREATED_BY
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE  = 'C';

    IF i_count = 0 THEN
        FOR r IN (
            SELECT C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
             WHERE C.PROGRAM_ID   = v_program_id
               AND C.SHEET_NAME   = v_sheet_name
               AND (C.DEFAULT_FLAG = 'Y' OR (C.VISIBLE_FLAG = 'N' AND C.DEFAULT_FLAG = 'Y' AND C.VALID_YN = 'Y'))
             ORDER BY SORT_ORDER_NO
        ) LOOP
            IF v_ColList IS NOT NULL AND LENGTH(v_ColList) > 0 THEN
                v_ColList   := v_ColList   || ',' || r.COLUMN_NAME || ' ';
                v_OrderList := v_OrderList || ',' || r.COLUMN_NAME || ' ' || r.DATA_SORT_METHOD_CODE;
            ELSE
                v_ColList   := ' ' || r.COLUMN_NAME || ' ';
                v_OrderList := ' ' || r.COLUMN_NAME || '  ' || r.DATA_SORT_METHOD_CODE;
            END IF;
        END LOOP;
    ELSE
        FOR r IN (
            SELECT CASE WHEN C.COLUMN_NAME = 'GROUP_ID'
                        THEN NVL(TU.SORT_ORDER_NO, 95) - 0.5
                        ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO,
                   C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
              FROM SCM_MGR.SCM_MST_TITLESET_USER U
             INNER JOIN SCM_MGR.SCM_MST_SHEET_COLUMNS C
                     ON U.PROGRAM_ID  = C.PROGRAM_ID
                    AND U.SHEET_NAME  = C.SHEET_NAME
                    AND U.COLUMN_NAME = C.COLUMN_NAME
                    AND U.PROGRAM_ID  = v_program_id
                    AND U.SHEET_NAME  = v_sheet_name
                    AND U.USER_ID     = P_CREATED_BY
                    AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
              LEFT OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER TU
                           ON TU.PROGRAM_ID = C.PROGRAM_ID
                          AND TU.SHEET_NAME = C.SHEET_NAME
                          AND TU.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                          AND TU.COLUMN_NAME = 'ITEM_ID'
                          AND TU.USER_ID = P_CREATED_BY
            UNION ALL
            SELECT C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
             WHERE C.PROGRAM_ID   = v_program_id
               AND C.SHEET_NAME   = v_sheet_name
               AND C.VISIBLE_FLAG = 'N'
               AND C.DEFAULT_FLAG = 'Y'
               AND C.VALID_YN     = 'Y'
            ORDER BY SORT_ORDER_NO
        ) LOOP
            IF v_ColList IS NOT NULL AND LENGTH(v_ColList) > 0 THEN
                v_ColList   := v_ColList   || ',' || r.COLUMN_NAME || ' ' || CHR(10);
                v_OrderList := v_OrderList || ',' || r.COLUMN_NAME || '  ' || r.DATA_SORT_METHOD_CODE || CHR(10);
            ELSE
                v_ColList   := ' ' || r.COLUMN_NAME || ' ' || CHR(10);
                v_OrderList := ' ' || r.COLUMN_NAME || ' ' || r.DATA_SORT_METHOD_CODE || CHR(10);
            END IF;
        END LOOP;
    END IF;

    
    
    
    v_ColList   := v_ColList || ',NOTATION';
    v_ColList   := REPLACE(v_ColList,   'VERSION_NO', 'VERSION_SORT,VERSION_NO');
    v_OrderList := REPLACE(v_OrderList, 'VERSION_NO', 'VERSION_SORT DESC,VERSION_NO');
    v_OrderList := REPLACE(v_OrderList, 'MEASURE',    'SORT_ORDER_NO,MEASURE');

    

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A022

    
    
    
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','VERSION_NO','A.VERSION_NO',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','DIVISION_ID','A.DIVISION_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','PROJECT_CODE','A.PROJECT_CODE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','SCM_SITE_ID','A.SCM_SITE_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','PLANT_SITE_ID','A.PLANT_SITE_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','GROUP_ID','NVL(I.GROUP_ID,'' '') AS GROUP_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','ITEM_ID','A.ITEM_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','TEXT','CASE WHEN LENGTH(A.TEXT) = 0 THEN '' '' ELSE A.TEXT END AS TEXT',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','INCOTERMS','A.INCOTERMS',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','DOM_EXP','A.DOM_EXP',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','FCST_TYPE','A.FCST_TYPE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','MEASURE','A.MEASURE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','END_CUSTOMER40','A.PROJECT_CODE AS END_CUSTOMER40',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','INTERNAL_YN','CASE WHEN LENGTH(A.SCM_SITE_ID) > 2 AND LENGTH(A.SCM_SITE_ID) < 6 THEN ''Y'' ELSE ''N'' END AS INTERNAL_YN',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','YYYYMMDD','A.YYYYMMDD',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','QTY','A.QTY',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','VERSION_SORT','CASE WHEN A.VERSION_NO = ''CURRENT'' THEN ''ZZZZZZZZZZZZZZZ'' ELSE A.VERSION_NO END AS VERSION_SORT',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('B','VMI_YN','B.VMI_YN',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('B','END_CUSTOMER','B.END_CUSTOMER',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('AC','CURRENCY','CASE WHEN A.CURRENCY IS NOT NULL THEN A.CURRENCY ELSE C.CURRENCY END AS CURRENCY',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','CELL_PROD_SITE_ID','A.CELL_PROD_SITE_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('ABC','DEPT_ID','CASE WHEN A.FCST_TYPE = ''ETC'' THEN CASE WHEN A.DIVISION_ID = ''40'' THEN A.ATTRIBUTE1 ELSE B.DEPT_ID END ELSE C.DEPT_ID END AS DEPT_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','APPLICATION','C.APPLICATION',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','CUST_GROUP','C.CUST_GROUP',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','OWNER','C.OWNER_NAME AS OWNER',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','ROUTE','C.ROUTE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','CUST_GROUP_DTL','C.CUST_GROUP_DTL',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','CELL_PER_CAR','C.CELL_PER_CAR',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','CELL_PER_MODULE','C.CELL_PER_MODULE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('AC','COMPANY_ID','CASE WHEN NVL(A.COMPANY_ID,''@#@#@#'') = ''@#@#@#'' THEN C.SALES_COMPANY ELSE A.COMPANY_ID END AS COMPANY_ID',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','MODULE_PER_CAR','CASE WHEN C.CELL_PER_MODULE <> 0 THEN C.CELL_PER_CAR / C.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','DMS_SALES','NVL(C.ATTRIBUTE1,'''') AS DMS_SALES',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','DMS_CUSTOMER','NVL(C.ATTRIBUTE2,'''') AS DMS_CUSTOMER',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','FORECAST_INFO_CELL_MODEL','C.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','PRIORITY','C.ATTRIBUTE7 AS PRIORITY',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','KWH_CELL','C.ATTRIBUTE8 AS KWH_CELL',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','REPORT_GROUP6','NVL(C.REPORT_GROUP6,'''') AS REPORT_GROUP6',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('AC','KWH_MODULE','CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND NVL(C.ATTRIBUTE8,''@#@#@#'') <> ''@#@#@#'' THEN (C.CELL_PER_MODULE * TO_NUMBER(C.ATTRIBUTE8)) ELSE NULL END AS KWH_MODULE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('AC','KWH_PACK','CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND NVL(C.ATTRIBUTE8,''@#@#@#'') <> ''@#@#@#'' THEN (C.CELL_PER_CAR * TO_NUMBER(C.ATTRIBUTE8)) ELSE NULL END AS KWH_PACK',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','FORECAST_INFO_CELL_PACK_COUNT','D.FORECAST_INFO_CELL_PACK_COUNT',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','BIZ_TYPE_NAME40','D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','FORECAST_INFO_PRODUCT_GROUP','D.FORECAST_INFO_PRODUCT_GROUP',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','ENERGE','D.ENERGE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','ENERGE_WH','D.ENERGE_WH',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','CELL_QUANTITY','D.CELL_QUANTITY',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','ITEM_CLASS_NAME','NVL(D.ITEM_CLASS_NAME,'''') AS ITEM_CLASS_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','ITEM_NAME','NVL(D.ITEM_NAME,'''') AS ITEM_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','ITEM_TYPE','NVL(D.ITEM_TYPE,'''') AS ITEM_TYPE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','NICK_NAME','NVL(D.NICK_NAME,'''') AS NICK_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','MIN_CAPACITY','D.MIN_CAPACITY',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','FORECAST_INFO_ALL','D.FORECAST_INFO_SPEC || D.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','FORECAST_INFO_SPEC','D.FORECAST_INFO_SPEC',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','FORECAST_INFOR_VERSION','D.FORECAST_INFOR_VERSION',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','MDM_PROJECT_NAME','D.MDM_PROJECT_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','CELL_TYPE','D.SEGMENT2 AS CELL_TYPE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('D','CELL_MODEL_NICK_NAME','D.CELL_MODEL_NICK_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('G','BIZ_TYPE_NAME','G.BIZ_TYPE AS BIZ_TYPE_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('G','PROJECT_NAME','G.PROJECT_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('G','PROJECT_OWNER','G.PROJECT_OWNER',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('G','PROJECT_STATUS','G.PROJECT_STATUS',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('G','PRODUCT_GROUP_NAME','G.PRODUCT_GROUP_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('B','CITY_NAME','B.CITY_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('B','COUNTRY_NAME','B.COUNTRY_NAME',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('B','SHIPTO_DESCRIPTION','B.SHIPTO_DESCRIPTION',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('M','SORT_ORDER_NO','M.SORT_ORDER_NO',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('C','SALES_COMPANY','C.SALES_COMPANY',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('B','SOLDTO_CODE','B.SOLDTO_CODE',1);
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('B','SOLDTO_DESCRIPTION','B.SOLDTO_DESCRIPTION',1); 
		
		
		
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('O','SEGMENT3','NVL(O.SEGMENT3,''DEFAULT'') AS NOTATION',1);
    
    
    
    
    
    
    INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ('A','SCP_USE_YN',
        'CASE WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE IN (''VMI_In_Req'',''VMI_In_Plan'') THEN ''Y'' '||
        'WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''N'' AND A.MEASURE IN (''MKT_FCST_RP'',''MKT_FCST'',''RTF'',''RTF_SCP'',''RTF_SYS_RP'',''RTF_PR'') THEN ''Y'' '||
        'ELSE ''N'' END AS SCP_USE_YN',1);
		
		
		

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A023


    
    INSERT INTO SCM_MGR.GT_DM22_T (COLUMN_STRING, SEQ)
    SELECT B.COLUMN_STRING, ROW_NUMBER() OVER (ORDER BY B.SORT_KEY) AS SEQ
      FROM (
               SELECT TRIM(REPLACE(REPLACE(REPLACE(TOKEN, '[', ''), ']', ''),CHR(10),'')) AS TOKEN
                 FROM (
                          SELECT TRIM(REGEXP_SUBSTR(v_ColList, '[^,]+', 1, LEVEL)) AS TOKEN
                            FROM DUAL
                          CONNECT BY REGEXP_SUBSTR(v_ColList, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
           ) A
      JOIN SCM_MGR.GT_DM22_T_COLUMN_SETUP B ON A.TOKEN = B.COLUMN_NAME;

    SELECT COUNT(*) INTO v_CNT FROM SCM_MGR.GT_DM22_T;
    V_SQL_SELECT  := '';
    V_SQL_GROUPBY := '';
    v_I := 1;

    WHILE v_I <= v_CNT LOOP
        DECLARE
            v_col_str VARCHAR2(1000 CHAR);
        BEGIN
            SELECT COLUMN_STRING INTO v_col_str FROM SCM_MGR.GT_DM22_T WHERE SEQ = v_I;
            V_SQL_SELECT  := V_SQL_SELECT  || CASE WHEN v_I = 1 THEN '' ELSE ',' END || v_col_str || CHR(10) ;
            V_SQL_GROUPBY := V_SQL_GROUPBY || CASE WHEN v_I = 1 THEN '' ELSE ',' END
                             || CASE WHEN INSTR(UPPER(v_col_str), ' AS ') > 0
                                     THEN SUBSTR(v_col_str, 1, INSTR(UPPER(v_col_str), ' AS ') - 1)
                                     ELSE v_col_str END  || CHR(10) ;
        END;
        v_I := v_I + 1;
    END LOOP;


    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A024

    
    
    
    IF p_division_id = '40' THEN

        
        
        
        INSERT  INTO SCM_MGR.GT_DM22_RAW_DATA_TEMP40
              (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
              ,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
              ,YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID  )
        SELECT VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
              ,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
              ,YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID
        FROM  SCM_MGR.GT_DM22_RAW_DATA
        WHERE DIVISION_ID = p_division_id
        AND   MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD', 'SCM_FCST') 
        AND   YYYYMMDD   >= p_now_yyyymmdd
        ;


        INSERT  INTO SCM_MGR.GT_DM22_RAW_DATA_TEMP40_KEY
              (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
              ,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
              ,VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)
        SELECT VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
              ,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
              ,VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID
        FROM   SCM_MGR.GT_DM22_RAW_DATA_TEMP40
        GROUP BY VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, TEXT
             , INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID
        ;
        
        
        
        DELETE SCM_MGR.GT_DM22_RAW_DATA
        WHERE  DIVISION_ID = p_division_id
        AND    MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD', 'SCM_FCST') 
        AND    YYYYMMDD   >= p_now_yyyymmdd
        
        
        
        AND   ITEM_ID NOT IN (  SELECT DISTINCT ITEM_ID
                                
                                FROM SCM_MGR.DM_PLN_SALES_ETC_PLAN Z  
                                WHERE Z.DIVISION_ID = p_division_id
                                AND   Z.FCST_TYPE = 'ETC'
                                AND   Z.YYYYMMDD >= p_now_yyyymmdd
                                AND   Z.ITEM_ID NOT IN ( SELECT ITEM_ID
                                             FROM SCM_MGR.SCP_MST_FINAL_ITEM
                                             WHERE DIVISION_ID = p_division_id ))
        ;

        IF ( p_version_type LIKE '%CURRENT%' ) THEN

            
            
            
            
            
            
            INSERT  INTO GT_DM22_RAW_DATA
                  ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                  , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
                  , YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)
            SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, B.PLANT_SITE_ID, A.ITEM_ID
                 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE
                 , B.YYYYMMDD, B.QTY, A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
            FROM  SCM_MGR.GT_DM22_RAW_DATA_TEMP40_KEY A
                  INNER JOIN SCM_MGR.DM_PLN_SALES_PLAN B
                      ON 1=1
                       AND A.DIVISION_ID    = B.DIVISION_ID
                       AND A.PROJECT_CODE   = B.PROJECT_CODE
                       AND A.SCM_SITE_ID    = B.SCM_SITE_ID
                       AND A.ITEM_ID        = B.ITEM_ID
                       AND A.INCOTERMS      = B.INCOTERMS
                       AND A.DOM_EXP        = B.DOM_EXP
                       AND A.FCST_TYPE      = B.FCST_TYPE
                       AND A.MEASURE        = B.MEASURE
                       AND B.YYYYMMDD       >= p_now_yyyymmdd
                       AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
            ;

            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            


            INSERT  INTO SCM_MGR.GT_DM22_RTF_ENERGY
                  (VERSION_NO
                  ,CUTOFF_YYYYMMDD
                  ,DIVISION_ID
                  ,PROJECT_CODE
                  ,SCM_SITE_ID
                  ,PLANT_SITE_ID
                  ,ITEM_ID
                  ,TEXT
                  ,INCOTERMS
                  ,DOM_EXP
                  ,FCST_TYPE
                  ,CURRENCY
                  ,COMPANY_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  ,VALID_YN
                  ,PLAN_RESULT
                  ,ATTRIBUTE1
                  ,CELL_PROD_SITE_ID
                  )
            SELECT VERSION_NO
                  ,CUTOFF_YYYYMMDD
                  ,DIVISION_ID
                  ,PROJECT_CODE
                  ,SCM_SITE_ID
                  ,PLANT_SITE_ID
                  ,ITEM_ID
                  ,TEXT
                  ,INCOTERMS
                  ,DOM_EXP
                  ,FCST_TYPE
                  ,CURRENCY
                  ,COMPANY_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  ,VALID_YN
                  ,PLAN_RESULT
                  ,ATTRIBUTE1
                  ,CELL_PROD_SITE_ID
            FROM  SCM_MGR.GT_DM22_RAW_DATA A
            WHERE A.DIVISION_ID = p_division_id
            AND   A.MEASURE   = 'RTF_ENERGY';

            DELETE SCM_MGR.GT_DM22_RAW_DATA
            WHERE DIVISION_ID = p_division_id
            AND   MEASURE = 'RTF_ENERGY';

            
            
            
            
            
            INSERT  INTO SCM_MGR.GT_DM22_RAW_DATA
                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS
                    , DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY
                    , VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID )
            SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, B.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS
                    , A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE, B.YYYYMMDD, A.QTY
                    , A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
            FROM  SCM_MGR.GT_DM22_RTF_ENERGY A
            INNER JOIN SCM_MGR.DM_PLN_SALES_PLAN B
                ON 1=1
                 AND A.PROJECT_CODE   = B.PROJECT_CODE
                 AND A.DIVISION_ID    = B.DIVISION_ID
                 AND A.SCM_SITE_ID    = B.SCM_SITE_ID
                 AND A.PLANT_SITE_ID  = B.PLANT_SITE_ID
                 AND A.ITEM_ID        = B.ITEM_ID
                 AND A.INCOTERMS      = B.INCOTERMS
                 AND A.DOM_EXP        = B.DOM_EXP
                 AND A.FCST_TYPE      = B.FCST_TYPE
                 AND A.YYYYMMDD       = B.YYYYMMDD
                 AND A.MEASURE        = 'RTF_ENERGY'
                 AND B.MEASURE        = 'RTF_SYS_RP'
                 AND B.YYYYMMDD       >= p_now_yyyymmdd
                 AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID;

            MERGE INTO SCM_MGR.GT_DM22_RAW_DATA A
            USING ( SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP
                        , A.FCST_TYPE, A.YYYYMMDD, A.QTY, B.SUM_QTY, A.CELL_PROD_SITE_ID
                    FROM SCM_MGR.GT_DM22_RAW_DATA A
                        INNER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, SUM(QTY) AS SUM_QTY, CELL_PROD_SITE_ID
                                    FROM SCM_MGR.GT_DM22_RAW_DATA
                                    WHERE DIVISION_ID = p_division_id
                                    AND   VERSION_NO  = p_version_type
                                    AND   MEASURE   = 'RTF_SYS_RP'
                                    AND   YYYYMMDD     >= p_now_yyyymmdd
                                    GROUP BY DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, CELL_PROD_SITE_ID ) B
                            ON 1=1
                             AND A.DIVISION_ID    = B.DIVISION_ID
                             AND A.PROJECT_CODE   = B.PROJECT_CODE
                             AND A.SCM_SITE_ID    = B.SCM_SITE_ID
                             AND A.PLANT_SITE_ID  = B.PLANT_SITE_ID
                             AND A.ITEM_ID        = B.ITEM_ID
                             AND A.INCOTERMS      = B.INCOTERMS
                             AND A.DOM_EXP        = B.DOM_EXP
                             AND A.FCST_TYPE      = B.FCST_TYPE
                             AND A.YYYYMMDD       = B.YYYYMMDD
                    WHERE A.DIVISION_ID       = p_division_id
                    AND   A.VERSION_NO        = p_version_type
                    AND   A.MEASURE           = 'RTF_SYS_RP'
                    AND   A.YYYYMMDD         >= p_now_yyyymmdd
                    AND   A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                 ) B
              ON ( 1 = 1
               AND A.DIVISION_ID    = B.DIVISION_ID
               AND A.PROJECT_CODE   = B.PROJECT_CODE
               AND A.SCM_SITE_ID    = B.SCM_SITE_ID
               AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
               AND A.ITEM_ID      = B.ITEM_ID
               AND A.INCOTERMS      = B.INCOTERMS
               AND A.DOM_EXP      = B.DOM_EXP
               AND A.FCST_TYPE      = B.FCST_TYPE
               AND A.YYYYMMDD     = B.YYYYMMDD
               AND A.MEASURE      = 'RTF_ENERGY'
               AND A.CELL_PROD_SITE_ID  = B.CELL_PROD_SITE_ID )
            WHEN MATCHED THEN
            UPDATE SET A.QTY = A.QTY * (B.QTY/B.SUM_QTY);

        ELSIF ( p_version_type LIKE '%SP%') THEN

            
            
            
            
            
            
            INSERT  INTO SCM_MGR.GT_DM22_RAW_DATA
                  ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                  , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
                  , YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)
            SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, B.PLANT_SITE_ID, A.ITEM_ID
                 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE
                 , B.YYYYMMDD, B.QTY, A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
            FROM  SCM_MGR.GT_DM22_RAW_DATA_TEMP40_KEY A
            INNER JOIN SCM_MGR.DM_PLN_SALES_PLAN_C B
                ON 1=1
                 AND  A.DIVISION_ID     = B.DIVISION_ID
                 AND  A.VERSION_NO      = B.VERSION_NO
                 AND  A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
                 AND  A.PROJECT_CODE    = B.PROJECT_CODE
                 AND  A.SCM_SITE_ID     = B.SCM_SITE_ID
                 AND  A.ITEM_ID         = B.ITEM_ID
                 AND  A.INCOTERMS       = B.INCOTERMS
                 AND  A.DOM_EXP         = B.DOM_EXP
                 AND  A.FCST_TYPE       = B.FCST_TYPE
                 AND  A.MEASURE         = B.MEASURE
                 AND  B.YYYYMMDD        >= p_now_yyyymmdd
                 AND  A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID;

            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            

            INSERT  INTO SCM_MGR.GT_DM22_RTF_ENERGY
                  (VERSION_NO
                  ,CUTOFF_YYYYMMDD
                  ,DIVISION_ID
                  ,PROJECT_CODE
                  ,SCM_SITE_ID
                  ,PLANT_SITE_ID
                  ,ITEM_ID
                  ,TEXT
                  ,INCOTERMS
                  ,DOM_EXP
                  ,FCST_TYPE
                  ,CURRENCY
                  ,COMPANY_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  ,VALID_YN
                  ,PLAN_RESULT
                  ,ATTRIBUTE1
                  ,CELL_PROD_SITE_ID
                  )
            SELECT VERSION_NO
                  ,CUTOFF_YYYYMMDD
                  ,DIVISION_ID
                  ,PROJECT_CODE
                  ,SCM_SITE_ID
                  ,PLANT_SITE_ID
                  ,ITEM_ID
                  ,TEXT
                  ,INCOTERMS
                  ,DOM_EXP
                  ,FCST_TYPE
                  ,CURRENCY
                  ,COMPANY_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  ,VALID_YN
                  ,PLAN_RESULT
                  ,ATTRIBUTE1
                  ,CELL_PROD_SITE_ID
            FROM  SCM_MGR.GT_DM22_RAW_DATA A
            WHERE A.DIVISION_ID = p_division_id
            AND   A.MEASURE   = 'RTF_ENERGY';

            DELETE SCM_MGR.GT_DM22_RAW_DATA
            WHERE DIVISION_ID = p_division_id
            AND   MEASURE = 'RTF_ENERGY';


            
            
            
            
            
            INSERT  INTO GT_DM22_RAW_DATA
                    ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                    , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
                    , YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)
            SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, B.PLANT_SITE_ID, A.ITEM_ID
                    , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE
                    , B.YYYYMMDD, A.QTY, A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
            FROM  SCM_MGR.GT_DM22_RTF_ENERGY A
            INNER JOIN SCM_MGR.DM_PLN_SALES_PLAN_C B
                ON 1=1
                 AND A.DIVISION_ID      = B.DIVISION_ID
                 AND A.VERSION_NO       = B.VERSION_NO
                 AND A.CUTOFF_YYYYMMDD  = B.CUTOFF_YYYYMMDD
                 AND A.PROJECT_CODE     = B.PROJECT_CODE
                 AND A.SCM_SITE_ID      = B.SCM_SITE_ID
                 AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
                 AND A.ITEM_ID          = B.ITEM_ID
                 AND A.INCOTERMS        = B.INCOTERMS
                 AND A.DOM_EXP          = B.DOM_EXP
                 AND A.FCST_TYPE        = B.FCST_TYPE
                 AND A.YYYYMMDD         = B.YYYYMMDD
                 AND A.MEASURE          = 'RTF_ENERGY'
                 AND B.MEASURE          = 'RTF_SYS_RP'
                 AND B.YYYYMMDD         >= p_now_yyyymmdd
                 AND A.CELL_PROD_SITE_ID  = B.CELL_PROD_SITE_ID;

            MERGE INTO SCM_MGR.GT_DM22_RAW_DATA A
            USING ( SELECT DISTINCT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
                              , A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.YYYYMMDD, A.QTY, B.SUM_QTY
                        , ROUND(CASE WHEN B.SUM_QTY  <> 0 THEN A.QTY / B.SUM_QTY ELSE 0 END , 9) AS RATIO 
                        
                        , A.CELL_PROD_SITE_ID
                    FROM SCM_MGR.GT_DM22_RAW_DATA A
                    INNER JOIN (  SELECT DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, SUM(QTY) AS SUM_QTY, CELL_PROD_SITE_ID
                                  FROM SCM_MGR.GT_DM22_RAW_DATA
                                  WHERE DIVISION_ID = p_division_id
                                  AND   MEASURE     = 'RTF_SYS_RP'
                                  AND   YYYYMMDD    >= p_now_yyyymmdd
                                  GROUP BY  DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, CELL_PROD_SITE_ID ) B
                        ON 1=1
                         AND  A.DIVISION_ID     = B.DIVISION_ID
                         AND  A.VERSION_NO      = B.VERSION_NO
                         AND  A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
                         AND  A.PROJECT_CODE    = B.PROJECT_CODE
                         AND  A.SCM_SITE_ID     = B.SCM_SITE_ID
                         AND  A.PLANT_SITE_ID   = B.PLANT_SITE_ID
                         AND  A.ITEM_ID         = B.ITEM_ID
                         AND  A.INCOTERMS       = B.INCOTERMS
                         AND  A.DOM_EXP         = B.DOM_EXP
                         AND  A.FCST_TYPE       = B.FCST_TYPE
                         AND  A.YYYYMMDD        = B.YYYYMMDD
                    WHERE A.DIVISION_ID         = p_division_id
                    AND   A.MEASURE             = 'RTF_SYS_RP'
                    AND   A.YYYYMMDD           >= p_now_yyyymmdd
                    AND   A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
               ) B
               ON ( 1=1
                  AND A.DIVISION_ID       = B.DIVISION_ID
                  AND A.VERSION_NO        = B.VERSION_NO
                  AND A.CUTOFF_YYYYMMDD   = B.CUTOFF_YYYYMMDD
                  AND A.PROJECT_CODE      = B.PROJECT_CODE
                  AND A.SCM_SITE_ID       = B.SCM_SITE_ID
                  AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
                  AND A.ITEM_ID           = B.ITEM_ID
                  AND A.INCOTERMS         = B.INCOTERMS
                  AND A.DOM_EXP           = B.DOM_EXP
                  AND A.FCST_TYPE         = B.FCST_TYPE
                  AND A.YYYYMMDD          = B.YYYYMMDD
                  AND A.MEASURE           = 'RTF_ENERGY'
                  AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID )
            WHEN MATCHED THEN
            UPDATE SET A.QTY = A.QTY * B.RATIO
            ;
        END IF;
    END IF;

    
    
    
    IF (p_division_id= '82') THEN

        MERGE INTO SCM_MGR.GT_DM22_V_VERSION_NO A
        USING (
            SELECT A.VERSION_NO,
                   CASE
                       WHEN C.DM_RTF_YN = 'N' THEN A.VERSION_NO || '(' || B.WEEK_NAME || ') (NO PLAN)'
                       ELSE A.VERSION_NO || '(' || B.WEEK_NAME || ')'
                   END AS TOBE_VERSION_NO
            FROM SCM_MGR.GT_DM22_V_VERSION_NO A
            INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M B
                ON SUBSTR(A.VERSION_NO, 6, 8) = B.BASIS_YYYYMMDD
            LEFT JOIN SCM_MGR.SCP_PLN_INTERFACE_YN C
                ON C.DIVISION_ID = p_division_id
                AND B.BASIS_START_DATE = C.PLAN_START_YYYYMMDD
        ) B
        ON (A.VERSION_NO = B.VERSION_NO)
        WHEN MATCHED THEN
            UPDATE SET A.TOBE_VERSION_NO = B.TOBE_VERSION_NO
        ;

        UPDATE SCM_MGR.GT_DM22_RAW_DATA A
        SET A.VERSION_NO = (
                            SELECT B.TOBE_VERSION_NO
                            FROM SCM_MGR.GT_DM22_V_VERSION_NO B
                            WHERE A.VERSION_NO = B.VERSION_NO
                           )
        WHERE EXISTS (
            SELECT 1
            FROM SCM_MGR.GT_DM22_V_VERSION_NO B
            WHERE A.VERSION_NO = B.VERSION_NO
        );
    END IF;
    
    
    

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A025

    
    INSERT  INTO SCM_MGR.GT_DM22_CALENDAR
        (BASIS_YYYYMMWW, ISO_YYYYWW, ISO_WEEK, BASIS_YYYYMMDD, END_FLAG, BASIS_YYYYMM)
    SELECT A.BASIS_YYYYMMWW, A.ISO_YYYYWW, A.ISO_WEEK, B.BASIS_YYYYMMDD, B.END_FLAG, B.BASIS_YYYYMM
      FROM (SELECT SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK AS BASIS_YYYYMMWW, ISO_YYYYWW, ISO_WEEK
              FROM SCM_MGR.SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
               AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD
             GROUP BY ISO_YYYYWW, ISO_WEEK) A
      JOIN SCM_MGR.SCM_SYS_CALENDAR_M B
        ON A.ISO_YYYYWW = B.ISO_YYYYWW
       AND A.ISO_WEEK   = B.ISO_WEEK;


    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A026

    DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_CALENDAR',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);


    
    IF P_CELL_YN = 'Y' THEN
        v_sql_text := 'WITH T_DM22_WF AS ('
                      || 'SELECT FN_GET_DM_SALES_PLAN_WATERFALL_QTY2('
                      || 'A.MEASURE, NVL(D.ITEM_CLASS_NAME,'''')'
                      || ', NVL(A.QTY,0)'
                      || ', NVL(C.CELL_PER_CAR,0)'
                      || ', NVL(C.CELL_PER_MODULE,0)'
                      || ', ''Y'''
                      || ', NVL(D.FORECAST_INFO_CELL_PACK_COUNT, 0)'
                      || ', ''' || P_DIVISION_ID || ''', NVL(D.FORECAST_INFO_BIZ_TYPE, '''')'
                      || ') AS QTY ';
    ELSIF P_DIVISION_ID = '82' THEN
        
        v_sql_text := 'WITH T_DM22_WF AS ('
                      || ' SELECT TO_NUMBER(TO_CHAR(A.QTY,''FM99999999990.9999999999'')) AS QTY ';
    ELSE
        v_sql_text := 'WITH T_DM22_WF AS ('
                      || ' SELECT A.QTY AS QTY ';
    END IF;

    v_sql_text := v_sql_text || '
        , A.MEASURE
        , CASE WHEN ''' || P_BUCKET || ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD
        , CAL.BASIS_YYYYMM, CAL.ISO_WEEK, CAL.BASIS_YYYYMMWW
        , M.SORT_ORDER_NO
        , CAL.END_FLAG
        , NVL(O.SEGMENT3, ''DEFAULT'') AS NOTATION
        , [V_SQL_SELECT]
        , EDY.EDIT_YN
        FROM SCM_MGR.GT_DM22_RAW_DATA A
        INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
             ON EDY.USER_ID = ''' || P_USER_ID || '''
            AND EDY.MNU_ID  = ''' || P_MENU_ID || '''
            AND EDY.UNIT_ID = A.DIVISION_ID
        JOIN SCM_MGR.GT_DM22_SELECT_MEASURE      M ON A.MEASURE    = M.MEASURE
        JOIN SCM_MGR.GT_DM22_CALENDAR          CAL ON A.YYYYMMDD   = CAL.BASIS_YYYYMMDD
        LEFT OUTER JOIN SCM_MGR.GT_DM22_SCM_MST_SITE        B ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID
        LEFT OUTER JOIN SCM_MGR.GT_DM22_SCM_MST_SITE_ITEM   C ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
        LEFT OUTER JOIN SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V_T D ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID
        LEFT OUTER JOIN SCM_MGR.SCM_MST_PROJECT         G ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
        LEFT OUTER JOIN SCM_MGR.SCP_MST_ITEM_GROUP_DETAIL I ON A.DIVISION_ID = I.DIVISION_ID AND A.PROJECT_CODE = I.PROJECT_CODE AND A.ITEM_ID = I.ITEM_ID
        LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL O ON O.LOOKUP_TYPE = ''DM_MEASURE_POSITIONAL_NOTATION'' AND A.MEASURE = O.SEGMENT2 AND A.DIVISION_ID = O.SEGMENT1
       )
       ';



    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A027

    
    
    
    v_sql_text := v_sql_text || CHR(10) || 'SELECT [v_ColList], SORT_ORDER_NO, EDIT_YN, [V_PV_LIST] '
                || CHR(10) || ' FROM ( ';

    IF P_BUCKET = 'DAILY' THEN
        v_sql_text := v_sql_text
                || CHR(10) || 'SELECT [v_ColList], F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.EDIT_YN, F.QTY'
                || CHR(10) || ' FROM T_DM22_WF F '
                || CHR(10) || 'WHERE F.QTY <> 0'
                || CHR(10) || 'UNION ALL';
    END IF;

    IF P_BUCKET <> 'ONLY_WEEKLY' THEN
        v_sql_text := v_sql_text
                || CHR(10) || ' SELECT [v_ColList], F.SORT_ORDER_NO, ''W_'' || F.BASIS_YYYYMM || F.ISO_WEEK AS YYYYMMDD'
                || CHR(10) || '  , F.EDIT_YN'
                || CHR(10) || '  , CASE WHEN F.MEASURE IN (''KRW'',''USD'',''LOC'') THEN AVG(F.QTY) ELSE SUM(F.QTY) END AS QTY'
                || CHR(10) || ' FROM T_DM22_WF F'
                || CHR(10) || 'WHERE F.QTY <> 0'
                || CHR(10) || 'GROUP BY [v_ColList], F.MEASURE, F.SORT_ORDER_NO, F.BASIS_YYYYMM, F.ISO_WEEK, F.EDIT_YN'
                || CHR(10) || ' UNION ALL'
                || CHR(10) || ' SELECT [v_ColList], F.SORT_ORDER_NO, ''M_'' || F.BASIS_YYYYMM AS YYYYMMDD'
                || CHR(10) || '  , F.EDIT_YN'
                || CHR(10) || '  , CASE WHEN F.MEASURE IN (''KRW'',''USD'',''LOC'') THEN AVG(F.QTY) ELSE SUM(F.QTY) END AS QTY'
                || CHR(10) || ' FROM T_DM22_WF F'
                || CHR(10) || 'WHERE F.QTY <> 0'
                || CHR(10) || 'GROUP BY [v_ColList], F.MEASURE, F.SORT_ORDER_NO, F.BASIS_YYYYMM, F.EDIT_YN'
                || CHR(10) || ' ) F PIVOT ( SUM(F.QTY) FOR YYYYMMDD IN ( [V_PV_COL_LIST] ))'
                || CHR(10) || ' ORDER BY [v_OrderList] ';
    ELSIF P_BUCKET = 'ONLY_WEEKLY' THEN
        
        v_sql_text := v_sql_text
                || CHR(10) || ' SELECT [v_ColList], F.SORT_ORDER_NO, ''W_'' || F.BASIS_YYYYMMWW AS YYYYMMDD'
                || CHR(10) || '  , F.EDIT_YN'
                || CHR(10) || '  , CASE WHEN F.MEASURE IN (''KRW'',''USD'',''LOC'') THEN AVG(F.QTY) ELSE SUM(F.QTY) END AS QTY'
                || CHR(10) || ' FROM T_DM22_WF F'
                || CHR(10) || 'WHERE F.QTY <> 0'
                || CHR(10) || 'GROUP BY [v_ColList], F.MEASURE, F.SORT_ORDER_NO, F.BASIS_YYYYMMWW, F.ISO_WEEK, F.EDIT_YN'
                || CHR(10) || ' ) F PIVOT ( SUM(F.QTY) FOR YYYYMMDD IN ([V_PV_COL_LIST] ))'
                || CHR(10) || ' ORDER BY [v_OrderList] ';
    END IF;

	  v_sql_text := REPLACE(v_sql_text,'[V_PV_COL_LIST]'    , V_PV_COL_LIST );
	  v_sql_text := REPLACE(v_sql_text,'[V_PV_LIST]'        , v_PV_LIST     );
	  v_sql_text := REPLACE(v_sql_text,'[v_ColList]'        , v_ColList     );
	  v_sql_text := REPLACE(v_sql_text,'[v_OrderList]'      , v_OrderList   );
	  v_sql_text := REPLACE(v_sql_text,'[V_SQL_SELECT]'     , V_SQL_SELECT  );
	  v_sql_text := REPLACE(v_sql_text,'[V_SQL_GROUPBY]'    , V_SQL_GROUPBY );

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A028












    OPEN O_RC1 FOR v_sql_text;

    
    OPEN O_RC2 FOR
        SELECT ISO_WEEK, BASIS_DATE
          FROM SCM_MGR.SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD = TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD');

    

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, NULL AS EVENT FROM DUAL;

    DBMS_OUTPUT.ENABLE(1000000);

    DBMS_OUTPUT.PUT_LINE('=============================');
    DBMS_OUTPUT.PUT_LINE('V_PV_COL_LIST : '||V_PV_COL_LIST ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('v_PV_LIST : '||v_PV_LIST ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('v_ColList : '||v_ColList ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('v_OrderList :'||v_OrderList ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_SQL_SELECT :'||V_SQL_SELECT ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_SQL_GROUPBY :'||V_SQL_GROUPBY ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('=============================');


    DBMS_OUTPUT.PUT_LINE(v_sql_text);

    DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A029

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_DIVISION_ID'       VALUE P_DIVISION_ID,
            'P_DEPT_ID'           VALUE P_DEPT_ID,
            'P_END_CUSTOMER'      VALUE P_END_CUSTOMER,
            'P_SCM_SITE_ID'       VALUE P_SCM_SITE_ID,
            'P_PROJECT_CODE'      VALUE P_PROJECT_CODE,
            'P_ITEM_ID'           VALUE P_ITEM_ID,
            'P_ITEM_TYPE'         VALUE P_ITEM_TYPE,
            'P_FROM_YYYYMMDD'     VALUE P_FROM_YYYYMMDD,
            'P_NOW_YYYYMMDD'      VALUE P_NOW_YYYYMMDD,
            'P_TO_YYYYMMDD'       VALUE P_TO_YYYYMMDD,
            'P_CREATED_BY'        VALUE P_CREATED_BY,
            'P_PLANT_SITE_ID'     VALUE P_PLANT_SITE_ID,
            'P_BIZTYPE'           VALUE P_BIZTYPE,
            'P_OWNER'             VALUE P_OWNER,
            'P_INTERNAL_YN'       VALUE P_INTERNAL_YN,
            'P_CELL_YN'           VALUE P_CELL_YN,
            'P_VERSION_TYPE'      VALUE P_VERSION_TYPE,
            'P_BUCKET'            VALUE P_BUCKET,
            'P_USER_DEPT_ID'      VALUE P_USER_DEPT_ID,
            'P_GROUP_ID'          VALUE P_GROUP_ID,
            'P_USER_ID'           VALUE P_USER_ID,
            'P_MENU_ID'           VALUE P_MENU_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL;

END PKG_DMF0022;